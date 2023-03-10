import scrapy

from iospescraper import settings
from getpass import getuser, getpass
from iospescraper.items import Inscription

from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.lxmlhtml import LxmlLinkExtractor

from scrapy import log

import re


class InscriptionSpider(CrawlSpider):
    http_user = ''
    http_pass = ''

    name = "inscription"
    allowed_domains = ["iospe-dev.cch.kcl.ac.uk"]
    start_urls = settings.START_URLS


    rules = (
        Rule(
            LxmlLinkExtractor(
                allow=("\d\.\d{1,3}\w?(?:-ru)?.html", ),
                restrict_xpaths=(
                    '//dl[@class="indices indices-locations tocs"]',)
            ),
            callback="parse_link",
            follow= True
        ),
    )

    def __init__(self, category=None, *args, **kwargs):
        super(InscriptionSpider, self).__init__(*args, **kwargs)

        if settings.AUTH.get('user', None):
            self.http_user = settings.AUTH['user']
        else:
            self.http_user = getuser()

        if settings.AUTH.get('pass', None):
            self.http_pass = settings.AUTH['pass']
        else:
            self.http_pass = getpass()

    def parse_link(self, response):

        self.log('Parsing Inscription page: %s' % response.url, level=log.INFO)
        inscription = Inscription()

        inscription['link'] = response.url
        inscription['sn'] = self.generate_sort_code(response.url)

        inscription['title'] = self.parse_inscription_title(response)
        inscription['body'] = self.parse_inscription_body(response)

        return inscription

    def generate_sort_code(self, url):
        doc_n_format = re.compile(
            (   # beggining of the string
                r'^'

                # corpus
                r'(?P<corpus>\d)'

                # separator
                r'\.'

                # inscription number
                r'(?P<num_id>\d{1,3})'

                # inscription letter
                r'(?P<subletter>\w?)'

                # language suffix
                r'(?:-ru)?'

                # extension
                r'\.html'

                # end of the string
                r'$'
            ),
            flags=(re.VERBOSE or re.IGNORECASE))

        _, sid = url.strip().rsplit(u'/', 1)

        # self.log(sid, level=log.INFO)

        parsed = doc_n_format.match(sid)

        try:
            assert parsed is not None
            pdict = parsed.groupdict()
            num = (int(pdict['corpus']) * 1000000)
            num += (int(pdict['num_id']) * 1000)
            num += (ord(pdict['subletter'])) if len(pdict['subletter']) else 0

            return num

        except AssertionError:
            self.log('Unable to parse inscription-id', level=log.INFO)

        return 0

    def parse_inscription_title(self, response):
        if len(response.xpath('//h1/text()')):
            return response.xpath('//h1/text()').extract()[0]
        return u''

    def parse_inscription_body(self, response):
        if len(response.xpath('//main')):
            return u'\n'.join(response.xpath(
                (u'//main//div['
                    u'contains(@class, "monument-section") or '
                    u'contains(@class, "epigraphic-field-section")'
                    u']')
            ).extract())

        return u''
