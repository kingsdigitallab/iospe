# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

from codecs import open
from iospescraper import settings

from scrapy import log


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
        <span>from URL: {link}</span>

        <div class="inscription">
        {body}
        </div>

        <hr />

        """.format(**dict(item))

        self.inscription_tuples.append((item['sn'], inscr_html, ))
        return item
