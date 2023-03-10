# IOSPEScraper

This script scrapes the index of inscriptions in the live database and produces a concatenated html file with all inscriptions in order. 

## Quickstart

- Install the Dependencies:
    
    `pip install -r requirements.txt`
- Run the scraper:

    `scrapy crawl inscription`
    

## About


The scraper works by going to the inscriptions directory at [https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations.html](https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations.html). It then looks for links to individual inscription urls by analysing the url structure. It will accept urls which end with the following structure:

`<CORPUS_NUMBER>.<INSCRIPTION_NUMBER><OPTIONAL_INSCRIPTION_LETTER><OPTIONAL_LANGUAGE_SUFFIX>.html`

where,

`CORPUS_NUMBER`
:    One digit identifier for the corpus – e.g: `5`

`INSCRIPTION_NUMBER`
:    One to three digit identifier for the individual inscription – e.g: `170`, `1`, `34`

`OPTIONAL_INSCRIPTION_LETTER`
:    Optional one letter identifier for the individual inscription, which follows the inscription number – e.g: `a`

`OPTIONAL_LANGUAGE_SUFFIX`
:    Optional URL suffix for to account for the Russian version of the website – e.g: `-ru`

Examples of a valid url for an inscriptions are:

```
https://iospe-dev.cch.kcl.ac.uk/5.1.html
https://iospe-dev.cch.kcl.ac.uk/5.99a.html
https://iospe-dev.cch.kcl.ac.uk/5.170-ru.html
```

## Configuration

The `settings.py` contains some configuration settings. Especially two settings are important:

`START_URLS`
:    list of urls to start scraping, it is initially set to only to `https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations.html`. To parse Russian inscriptions set it to: `https://iospe-dev.cch.kcl.ac.uk/corpora/byzantine/locations-ru.html`

`OUTFILE`
:    The filename used to save the scraped data. 

`AUTH`
:    Dictionary of authentication details needed for the scraper to access the site, if it is protected. 