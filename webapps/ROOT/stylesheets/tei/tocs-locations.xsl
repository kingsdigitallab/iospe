<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="toc"/>

  <xsl:import href="inscription.xsl"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="tocTitleLocations">
    <i18n:text>Inscriptions by Location</i18n:text>
  </xsl:template>

  <xsl:template name="generateTocLocations">
    <dl class="tocs">
      <xsl:for-each select="//AL//tei:place">

        <dt>
          <xsl:value-of select="translate(tei:placeName[@xml:lang=$lang],'.','')"/>
        </dt>

        <xsl:for-each select="//doc/arr[@name='origin-ref']/str[.=current()/@xml:id]">
          <dd>
            <xsl:call-template name="formatInscrNum">
              <xsl:with-param name="num" select="ancestor::doc/str[@name='tei-id']"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <a href="/{ancestor::doc/str[@name='file']}.html">
              <xsl:choose>
                <xsl:when test="translate(normalize-space(ancestor::doc/str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                  [<i18n:text>no title</i18n:text>]
                  <xsl:value-of select="if ($lang='en') then '[no title]' else 'RU: [no title]'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="ancestor::doc/str[@name=concat('inscription-title-', $lang)]"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </dd>
        </xsl:for-each>
      </xsl:for-each>
    </dl>
  </xsl:template>

</xsl:stylesheet>