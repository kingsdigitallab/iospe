# -*- coding: utf-8 -*-

# Scrapy settings for iospescraper project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

LOG_LEVEL = 'INFO'

BOT_NAME = 'iospescraper'

OUTFILE = 'inscriptions.html'
# OUTFILE = 'inscriptions-ru.html'

START_URLS = [
    "https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations.html",
    # "https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations-ru.html"
]

SPIDER_MODULES = ['iospescraper.spiders']
NEWSPIDER_MODULE = 'iospescraper.spiders'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'iospescraper (+http://www.yourdomain.com)'

# DOWNLOADER_MIDDLEWARES = {
#     'myproject.middlewares.CustomDownloaderMiddleware': 543,
#     'scrapy.contrib.downloadermiddleware.httpauth.HttpAuthMiddleware': True
# }

AUTH = {
    'user': 'agiacometti',
}

ITEM_PIPELINES = {
    'iospescraper.pipelines.PreprocessorPipeline': 100,
    'iospescraper.pipelines.HTMLExporterPipeline': 200,
}
