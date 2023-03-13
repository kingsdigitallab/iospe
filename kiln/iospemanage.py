#!/usr/bin/env python
# -*- coding: utf-8 -*-

from manager import Manager


from codecs import open

import re

import os

from lxml import etree

from copy import deepcopy


manager = Manager()

TEI_NAMESPACE = u"http://www.tei-c.org/ns/1.0"


class IOSPEManageError(Exception):

    """Generic exception for IOSPE Manager """
    pass


class InvalidConversionType(IOSPEManageError):

    """Convesion type invalid"""
    pass


class InvalidFormat(IOSPEManageError):

    """Formatting error of pre-conversion format"""
    pass


class IOSPENotFoundError(IOSPEManageError):

    """Generic Exception for not found"""
    pass


class FilenameNotFound(IOSPENotFoundError):

    """Filename not Found"""
    pass


class ReferenceNotFound(IOSPENotFoundError):

    """Reference not Found"""
    pass


class DocParser(object):

    """ Abstract conversion """

    # Document properties, these get filled with
    # actual values of specific documents
    prefix = None
    num_id_sep = None
    num_pad = None
    num_id = None
    subletter_sep = None
    subletter = None
    sub_id_set = None
    sub_id = None
    suffix = None

    extension = None

    # Document property parsing properties
    # they get used with parsing a documdent
    prefix_format = u''
    num_id_sep_format = u''
    num_pad = 0
    num_id_format = u''
    subletter_sep_format = u''
    subletter_format = u''
    sub_id_sep_format = u''
    sub_id_format = u''
    suffix_format = u''

    numeric = [u'num_id', u'sub_id']

    def __init__(self, **kwargs):
        # when the document gets initialised
        # it fills the properties based on a dictionary
        for name, val in kwargs.iteritems():
            if name in self.numeric:
                # numeric values get converted into integers
                if val == None or val == u'':
                    setattr(self, name, u'')
                else:
                    setattr(self, name, int(val))
            else:
                if val == None or val == u'':
                    setattr(self, name, u'')
                else:
                    setattr(self, name, val)

    def to_reference(self):
        """convert the document to a reference notation"""
        pass

    def to_filename(self, ext=True):
        """convert the document to a filename notation"""
        pass

    @classmethod
    def parse(cls, string):
        """parse a conversion into a new DocParser object"""

        doc_id_parser_format = (

            # beggining of the string
            r'^'

            # prefix
            r'(?P<prefix>{0.prefix_format})'

            r'(?:'
            # id separator
            r'(?P<num_id_sep>{0.num_id_sep_format})'

            # padded digit id
            r'(?:0{{0,{0.num_pad}}})'
            r'(?P<num_id>{0.num_id_format})'
            r')?'

            r'(?:'
            # subletter separator
            r'(?P<subletter_sep>{0.subletter_sep_format})'

            # subletter id
            r'(?P<subletter>{0.subletter_format})'
            r')?'

            r'(?:'
            # sub_id_sep separator
            r'(?P<sub_id_sep>{0.sub_id_sep_format})'

            # sub_id id
            r'(?P<sub_id>{0.sub_id_format})'
            r')?'

            # suffix
            r'(?P<suffix>{0.suffix_format})'


            # end of the string
            r'$'
        ).format(cls)

        doc_id_parser_format_r = re.compile(
            doc_id_parser_format,
            flags=(re.VERBOSE or re.IGNORECASE))

        try:
            doc_id_matches = doc_id_parser_format_r.match(
                string.strip())
            assert doc_id_matches is not None
        except AssertionError:
            raise InvalidFormat(
                u'{} not a valid {}'.format(string, cls.__name__))

        # returns an instance of a class using the
        # parsed elements as new properties
        return cls(**doc_id_matches.groupdict())


class IOSPEDocBefore(DocParser):

    """"Defines a IOSPE Old Document"""
    prefix_format = u'byz'
    num_id_sep_format = u''
    num_pad = 3
    num_id_format = r'\d+'
    subletter_sep_format = u''
    subletter_format = r'\w'
    sub_id_sep_format = u'\.'
    sub_id_format = r'\d+'
    suffix_format = u''

    extension = u'xml'

    def to_filename(self, ext=True):
        extension = (u'.' + self.extension) if ext else u''
        return (u'{self.prefix}'
                u'{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                u'{self.suffix}'
                u'{extension}'
                ).format(self=self, extension=extension)

    def to_reference(self):
        return (u'V'
                u' {self.num_id}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IOSPEDocAfter(DocParser):

    """"Defines a IOSPE New Document"""
    prefix_format = u'5'
    num_id_sep_format = u'\.'
    num_id_format = r'\d+'

    extension = u'xml'

    def to_filename(self, ext=True):
        extension = (u'.' + self.extension) if ext else u''
        return (u'{self.prefix}'
                u'{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                u'{self.suffix}'
                u'{extension}'
                ).format(self=self, extension=extension)

    def to_reference(self):
        return (u'V'
                u' {self.num_id}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IRCyrDocBefore(DocParser):

    """"Defines a IRCyr Old Document"""
    prefix_format = r'[ABCGPT]'
    num_id_sep_format = u''
    num_pad = 5
    num_id_format = r'\d+'

    extension = u'xml'

    def to_filename(self, ext=True):
        extension = (u'.' + self.extension) if ext else u''
        return (u'{self.prefix}'
                u'{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                u'{self.suffix}'
                u'{extension}'
                ).format(self=self, extension=extension)

    def to_reference(self):
        return (u'{self.prefix}'
                u'.{self.num_id}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IRCyrDocAfter(DocParser):

    """"Defines a IRCyr New Document"""
    prefix_format = r'[ABCGPT]'
    num_id_sep_format = u'\.'
    num_id_format = r'\d+'

    extension = u'xml'

    def to_filename(self, ext=True):
        extension = (u'.' + self.extension) if ext else u''
        return (u'{self.prefix}'
                u'{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                u'{self.suffix}'
                u'{extension}'
                ).format(self=self, extension=extension)

    def to_reference(self):
        return (u'{self.prefix}'
                u'.{self.num_id}'
                u'{self.subletter_sep}{self.subletter}'
                u'{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class Conversion(object):

    """Defines a basic conversion"""

    _sourceParser = DocParser
    _destParser = DocParser

    source = None
    destination = None

    def __init__(self, source=None, destination=None):
        self.source = source
        self.destination = destination

    @classmethod
    def parse(cls, original_form, new_form):
        source = cls._sourceParser.parse(original_form)
        destination = cls._destParser.parse(new_form)
        return cls(source, destination)


class IOSPEConversion(Conversion):

    """Defines an IOSPE conversion"""

    _sourceParser = IOSPEDocBefore
    _destParser = IOSPEDocAfter


class IRCyrConversion(Conversion):

    """Defines an IRCyr conversion"""

    _sourceParser = IRCyrDocBefore
    _destParser = IRCyrDocAfter


class Index(object):
    conversions = None
    old_filenames = {}
    old_references = {}

    def __init__(self, conversions):
        self.conversions = conversions
        self.__build_index()

    def __build_index(self):
        for conversion in self.conversions:

            self.old_filenames[
                conversion.source.to_filename(ext=False)] = conversion
            self.old_references[conversion.source.to_reference()] = conversion

    def find(self, string):
        if string in self.old_filenames:
            return self.old_filenames[string]
        elif string in self.old_references:
            return self.old_references[string]
        else:
            raise IOSPENotFoundError(
                u'"{}" not found in index.'.format(string))


def load_conversion_file(filepath, conv_type):
    """loads the file which contains the conversion and build an index"""

    conversions = []
    with open(filepath, 'r', 'utf') as conversion_file:
        for line in conversion_file:
            try:
                original_form, new_form = line.strip().split()
            except ValueError:
                raise InvalidConversionType(
                    (u'Error: "{line}"'
                     u' does not specify a'
                     u'valid conversion').format(line=line))

            conversions.append(conv_type.parse(original_form, new_form))

    return Index(conversions)


def walk_through_files(root):
    for root, dirs, files in os.walk(root):
        for f in files:
            yield f


def open_xml(filepath):
    xmlParser = etree.XMLParser(
        ns_clean=False,
        remove_blank_text=False,
        remove_comments=False,
        strip_cdata=False)

    return etree.parse(filepath, xmlParser)


def write_xml(et, filepath):

    et.write(
        filepath,
        method='xml',
        pretty_print=False,
        encoding='UTF-8',
        with_tail=True,
        standalone=None,
        compression=0,
        exclusive=False,
        with_comments=True,
        xml_declaration=True)


def update_references(doc, c_index, type='inscription'):
    if type:
        t = (u'[@type="{type}"]').format(type=type)
    else:
        t = u''

    p = (u'//TEI:ref{typed}').format(typed=t)

    for ref in doc.xpath(p,
                         namespaces={u'TEI': TEI_NAMESPACE}):

        key = ref.text

        print key.strip()

        try:
            conv = c_index.find(key.strip())
        except IOSPENotFoundError:
            raise ReferenceNotFound(
                u'Reference: "{}" in line {} not found in index!'.format(key.strip(), ref.sourceline))

        ref.text = conv.destination.to_reference()
        ref.addnext(etree.Comment(conv.source.to_filename(ext=False)))

    return doc


def update_filename(doc, c_index):
    for ref in doc.xpath((u'/TEI:TEI/TEI:teiHeader/'
                          u'TEI:fileDesc/TEI:publicationStmt'
                          u'/TEI:idno[@type="filename"]'),
                         namespaces={u'TEI': TEI_NAMESPACE}):

        key = ref.text
        new_ref = deepcopy(ref)
        save_tail = ref.tail
        save_head = ref.getparent().itertext().next()
        if save_head.strip() != u'':
            save_head = u''

        try:
            conv = c_index.find(key.strip())
        except IOSPENotFoundError:
            raise FilenameNotFound(
                u'idno: "{}" not found in index!'.format(key.strip()))

        ref.text = conv.destination.to_filename(ext=False)
        new_ref.set(u'type', u'AYV2012-number')
        ref.addnext(new_ref)
        ref.tail = save_head
        new_ref.tail = save_tail

    return doc


def write_dictionary(index, filename):
    """Write the dictionary for reference """

    with open(filename, 'w', 'utf') as dictfl:
        for conv in index.conversions:
            dictfl.write('\t'.join([
                conv.source.to_filename(),
                conv.source.to_reference(),
                conv.destination.to_filename(),
                conv.destination.to_reference()
            ]))

            dictfl.write("\n")


def write_svn_repair_log(log, filename):
    """Writes a bash file to repair the moves of converted
        in order to keep svn history on those files"""

    with open(filename, 'w', 'utf') as svn_log_fl:

        svn_log_fl.write(u'#!/usr/bin/env sh\n\n')
        for source, dest in log:
            svn_log_fl.write((
                u'mv "{dest}" "{source}"'
                u' && '
                u'svn mv "{source}" "{dest}"'
            ).format(source=source, dest=dest))
            svn_log_fl.write("\n")

    print("""================NOTICE:==============================
In order to keep the subversion history on the modified
files, svn needs to be notified of their new location.
An svn repair file was generated: '{filename}'
=====================================================""".format(filename=filename))


def check_valid_conversion(conversion_type):
    if conversion_type == 'IOSPE':
        conv_type = IOSPEConversion
    elif conversion_type == 'IRCyr':
        conv_type = IRCyrConversion
    else:
        raise InvalidConversionType
        exit()

    return conv_type


@manager.arg(
    'conversions',
    help='file which contains the document conversions')
@manager.arg('path', help='path to documents')
@manager.arg('conversion_type', help='type of conversion')
@manager.command
def convert(conversions, path, conversion_type):
    """
    Convert a series of files and update references within them
    """
    conv_type = check_valid_conversion(conversion_type)

    c_index = load_conversion_file(conversions, conv_type)

    write_dictionary(c_index, u'dictionary.txt')

    accumulate_errors = []
    log_for_svn = []
    for f in walk_through_files(path):
        fname, ext = os.path.splitext(f)
        try:
            conv = c_index.find(fname)
            assert conv != False
        except IOSPENotFoundError as e:
            accumulate_errors.append([f, e.__class__.__name__, e.message])
            continue

        print u'Reading {}.'.format(conv.source.to_filename()),
        doc = open_xml(os.path.join(path, conv.source.to_filename()))

        try:
            print 'updating references.',
            doc = update_references(doc, c_index)
            print 'updating filename.',
            doc = update_filename(doc, c_index)
        except IOSPENotFoundError as e:
            accumulate_errors.append(
                [conv.source.to_filename(), e.__class__.__name__, e.message])
            print 'skipping'
            continue

        print u'Writing {}.'.format(conv.destination.to_filename()),
        write_xml(doc, os.path.join(path, conv.destination.to_filename()))

        print u'Removing {}.'.format(conv.source.to_filename())
        os.remove(os.path.join(path, conv.source.to_filename()))

        log_for_svn.append([
            os.path.join(path, conv.source.to_filename()),
            os.path.join(path, conv.destination.to_filename())
        ])

    write_svn_repair_log(log_for_svn, 'svn_repair.sh')

    for ref, errtype, mess in accumulate_errors:
        print u'ERROR: {} {} {}'.format(ref, errtype, mess)


@manager.arg(
    'conversions',
    help='file which contains the document conversions')
@manager.arg('filename', help='path to document')
@manager.arg('conversion_type', help='type of conversion')
@manager.command
def update_refs(conversions, filename, conversion_type):
    """
    Update references within a single file
    """
    conv_type = check_valid_conversion(conversion_type)

    c_index = load_conversion_file(conversions, conv_type)

    write_dictionary(c_index, u'dictionary.txt')

    doc = open_xml(filename)

    print 'updating references. ',
    doc = update_references(doc, c_index, type=False)

    print u'Writing {}.'.format(filename),
    write_xml(doc, filename)


if __name__ == '__main__':
    manager.main()
