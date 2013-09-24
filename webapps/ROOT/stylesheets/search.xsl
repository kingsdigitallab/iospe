<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0">


  <xsl:param name="lang"/>
  <xsl:param name="url"/>
  <xsl:param name="min-year"/>
  <xsl:param name="max-year"/>
  <xsl:param name="params"/>
  <xsl:param name="query-string"/>


  <xsl:template name="searchMenuLanguages">
    <li class="lang en">
      <a class="en" href="../../../../en/{$min-year}/{$max-year}/{$query-string}/" title="English"
        >English</a>
    </li>

    <li class="lang py">
      <a class="py" href="../../../../ru/{$min-year}/{$max-year}/{$query-string}/" title="Русский"
        >Русский</a>
    </li>
  </xsl:template>


</xsl:stylesheet>
