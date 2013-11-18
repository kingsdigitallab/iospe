#!/usr/bin/env python
# -*- coding: utf-8 -*-

from manager import Manager


from codecs import open

import re

import os

manager = Manager()


class IOSPEManageError(Exception):

    """Generic exception for IOSPE Manager """
    pass


class InvalidConversionType(IOSPEManageError):

    """Convesion type invalid"""
    pass


class InvalidFormat(IOSPEManageError):

    """Formatting error of pre-conversion format"""
    pass


class DocParser(object):

    """ Abstract conversion """

    prefix = None
    num_id_sep = None
    num_pad = None
    num_id = None
    subletter_sep = None
    subletter = None
    sub_id_set = None
    sub_id = None
    suffix = None

    prefix_format = ''
    num_id_sep_format = ''
    num_pad = 0
    num_id_format = ''
    subletter_sep_format = ''
    subletter_format = ''
    sub_id_sep_format = ''
    sub_id_format = ''
    suffix_format = ''

    numeric = ['num_id', 'sub_id']

    def __init__(self, **kwargs):
        for name, val in kwargs.iteritems():
            if name in self.numeric:
                if val == None or val == '':
                    setattr(self, name, '')
                else:
                    setattr(self, name, int(val))
            else:
                if val == None or val == '':
                    setattr(self, name, u'')
                else:
                    setattr(self, name, val)

    def to_reference(self):
        """convert the document to a reference notation"""
        pass

    def to_filename(self):
        """convert the document to a filename notation"""
        pass

    @classmethod
    def parse(cls, string):
        """parse a conversion into a new Doc object"""
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

        doc_id_parser_format_r = re.compile(doc_id_parser_format,
                                            flags=(re.VERBOSE or re.IGNORECASE))

        try:
            doc_id_matches = doc_id_parser_format_r.match(
                string.strip())
            assert doc_id_matches is not None
        except AssertionError:
            raise InvalidFormat(
                '{} not a valid {}'.format(string, cls.__name__))

        return cls(**doc_id_matches.groupdict())


class IOSPEDocBefore(DocParser):

    """"Defines a IOSPE Old Document"""
    prefix_format = 'byz'
    num_id_sep_format = ''
    num_pad = 3
    num_id_format = r'\d+'
    subletter_sep_format = ''
    subletter_format = r'\w'
    sub_id_sep_format = '\.'
    sub_id_format = r'\d+'
    suffix_format = ''

    def to_filename(self):
        return ('{self.prefix}'
                '{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                '{self.suffix}.xml'
                ).format(self=self)

    def to_reference(self):
        return ('V'
                ' {self.num_id}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IOSPEDocAfter(DocParser):

    """"Defines a IOSPE Old Document"""
    prefix_format = '5'
    num_id_sep_format = '\.'
    num_id_format = r'\d+'

    def to_filename(self):
        return ('{self.prefix}'
                '{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                '{self.suffix}.xml'
                ).format(self=self)

    def to_reference(self):
        return ('V'
                ' {self.num_id}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IRCyrDocBefore(DocParser):
    prefix_format = r'[ABCGPT]'
    num_id_sep_format = ''
    num_pad = 5
    num_id_format = r'\d+'

    def to_filename(self):
        return ('{self.prefix}'
                '{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                '{self.suffix}.xml'
                ).format(self=self)

    def to_reference(self):
        return ('{self.prefix}'
                '.{self.num_id}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                ).format(self=self)


class IRCyrDocAfter(DocParser):
    prefix_format = r'[ABCGPT]'
    num_id_sep_format = '\.'
    num_id_format = r'\d+'

    def to_filename(self):
        return ('{self.prefix}'
                '{self.num_id_sep}{self.num_id:0{self.num_pad}}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
                '{self.suffix}.xml'
                ).format(self=self)

    def to_reference(self):
        return ('{self.prefix}'
                '.{self.num_id}'
                '{self.subletter_sep}{self.subletter}'
                '{self.sub_id_sep}{self.sub_id}'
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
            self.old_filenames[conversion.source.to_filename()] = conversion
            self.old_references[conversion.source.to_reference()] = conversion

    def find(self, string):
        if string in self.old_filenames:
            return self.old_filenames[string]
        elif string in self.old_references:
            return self.old_references[string]
        else:
            return False


def load_conversion_file(filepath, conv_type):
    """loads the file which contains the conversion and build an index"""

    conversions = []
    with open(filepath, 'r', 'utf') as conversion_file:
        for line in conversion_file:
            try:
                original_form, new_form = line.strip().split()
            except ValueError:
                raise InvalidConversionType(
                    'Error: "{line}" does not specify a valid conversion'.format(line=line))

            conversions.append(conv_type.parse(original_form, new_form))

    return Index(conversions)


def walk_through_files(root):
    for root, dirs, files in os.walk(root):
        for f in files:
            yield f


@manager.arg('conversions', help='file which contains the document conversions')
@manager.arg('path', help='path to documents')
@manager.arg('conversion_type', help='type of conversion')
@manager.command
def convert(conversions, path, conversion_type):
    if conversion_type == 'IOSPE':
        conv_type = IOSPEConversion
    elif conversion_type == 'IRCyr':
        conv_type = IRCyrConversion
    else:
        raise InvalidConversionType
        exit()

    c_index = load_conversion_file(conversions, conv_type)

    print path
    for f in walk_through_files(path):
        conv = c_index.find(f)
        print f, conv.source.to_reference(), ': ', conv.destination.to_reference(), ', ', conv.destination.to_filename()





if __name__ == '__main__':
    manager.main()
