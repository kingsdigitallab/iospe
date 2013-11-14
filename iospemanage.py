#!/usr/bin/env python
# -*- coding: utf-8 -*-

from manager import Manager


from codecs import open

import re

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


class Doc(object):

    """ Abstract conversion """
    @classmethod
    def parse(cls, *args):
        """parse a conversion into a new Doc object"""
        return cls(*args)

    def to_reference(self):
        """convert the document to a reference notation"""
        pass

    def to_filename(self):
        """convert the document to a filename notation"""
        pass


class IOSPEDoc(Doc):

    """"Defines a IOSPE Document"""
    prefix = 'byz'
    prefix_sep = ''
    num_pad = 3
    num_id = r'\d+'
    num_id_sep = ''
    subletter = r'\w'
    subletter_sep = '\.'
    sub_id = r'\d+'
    sub_id_sep = ''



    @classmethod
    def parse(cls, original_form, new_form):
        doc_id_parser_format_r = re.compile((
            # beggining of the string
            r'^'

            # prefix
            r'(?P<prefix>{0.prefix})'

            #prefix separator
            '{0.prefix_sep}'

            # padded digit id
            r'(?P<num_id>{0.num_id}{{{0.num_pad}}})'

            # numeric id separator
            '{0.num_id_sep}'

            # subletter id
            r'(?P<subletter>{0.subletter})?'

            # subversion
            r'(?:\.(?P<subversion>\d))?'

            # end of the string
            r'$'
        ).format(cls),
            flags=(re.VERBOSE or re.IGNORECASE))

        try:
            doc_id_matches = doc_id_parser_format_r.match(
                original_form.strip())
            assert doc_id_matches is not None
        except AssertionError:
            raise InvalidFormat(
                '{} not a valid {}'.format(original_form, IOSPEDoc.__name__))

        print original_form, doc_id_matches.groups()

        return cls()


def load_conversion_file(filepath, conv_type):
    """loads the file which contains the conversion"""

    docs = []
    with open(filepath, 'r', 'utf') as conversion_file:
        for line in conversion_file:
            s = line.split()
            docs.append(conv_type.parse(*s))

    return docs


class IRCyrDoc(Doc):
    prefix = r'[ABCGPT]'
    prefix_sep = ''
    num_pad = 5
    num_id = r'\d+'
    num_id_sep = ''
    subletter = ''
    subletter_sep = ''
    sub_id = ''
    sub_id_sep = ''


@manager.arg('conversions', help='file which contains the document conversions')
@manager.arg('path', help='path to documents')
@manager.arg('conversion_type', help='type of conversion')
@manager.command
def convert(conversions, path, conversion_type):
    if conversion_type == 'IOSPE':
        conv_type = IOSPEDoc
    elif conversion_type == 'IRCyr':
        conv_type = IRCyrDoc
    else:
        raise InvalidConversionType
        exit()

    load_conversion_file(conversions, conv_type)

if __name__ == '__main__':
    manager.main()
