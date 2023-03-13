# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

from codecs import open
from iospescraper import settings

from scrapy import log

from lxml import html
from lxml.etree import XMLSyntaxError

from scrapy.exceptions import DropItem


class PreprocessorPipeline(object):

    def remove_content_sections(self, etree):
        for content_section in etree.xpath(
            (u"//div[contains(@class, 'inscription-data')]"
             u"//section["
             u"descendant::div["
             u"contains(@class, 'content') and "
             u"(contains(@class, 'diplomatic') or "
             u"contains(@class, 'epidoc_xml'))]]")):
            content_section.getparent().remove(content_section)

        return etree

    def remove_edition_title(self, etree):
        for edition_title in etree.xpath(
            (u"//div[contains(@class, 'inscription-data')]"
             u"//section["
             u"descendant::div["
             u"contains(@class, 'content') and "
             u"contains(@class, 'edition')]]"
             u"//p[contains(@class, 'title')]")):
            edition_title.getparent().remove(edition_title)

        return etree


    def remove_images_section(self, etree):
        for images_section in etree.xpath(
            (u"//div[contains(@class, 'row')]["
             u"div[contains(@class, 'details')]"
             u"[descendant::img]]")):
            images_section.getparent().remove(images_section)

        return etree

    def process_item(self, item, spider):
        try:

            tree = html.fromstring(item['body'])

        except XMLSyntaxError:
            log.msg('Unable to parse XML tree', level=log.INFO)

            raise DropItem("Unable to parse SML tree in item {}".format(item))

        tree = self.remove_content_sections(tree)
        tree = self.remove_edition_title(tree)
        tree = self.remove_images_section(tree)

        item['body'] = html.tostring(tree)

        return item


class HTMLExporterPipeline(object):
    outfile = settings.OUTFILE
    inscription_tuples = []

    def open_spider(self, spider):
        pass

    def close_spider(self, spider):
        log.msg('close pipeline', level=log.INFO)

        head_html = u"""<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">

</head>
<body>
        """

        foot_html = u"""
</body>
</html>
        """
        inscriptions_html = u'\n'.join(
            [t[1]
             for t
             in sorted(self.inscription_tuples,
                       key=lambda t: t[0])])

        with open(self.outfile, 'wb',  'utf') as fh:
            fh.write(head_html)
            fh.write(inscriptions_html)
            fh.write(foot_html)

    def process_item(self, item, spider):
        inscr_html = u"""
        <h1>{title}</h1>

        <div class="inscription">
        {body}
        </div>

        <hr />

        """.format(**dict(item))

        self.inscription_tuples.append((item['sn'], inscr_html, ))
        return item
