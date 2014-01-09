<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="toc"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="tocTitleBynum">
    <i18n:text>All Inscriptions by Number</i18n:text>
  </xsl:template>

  <xsl:template name="generateTocBynum">
    <dl class="tocs">
      <xsl:for-each select="//doc">
        <dt>
          <xsl:number value="substring-before(str[@name='tei-id'],'.')" format="I"/>
          <xsl:text>&#xa0;</xsl:text>
          <xsl:number value="substring-after(str[@name='tei-id'],'.')" format="1"/>
          <!--<xsl:value-of select="substring-after(str[@name='tei-id'],'byz')"/>-->
        </dt>

        <dd>
          <a href="/{str[@name='inscription']}.html">
            <xsl:choose>
              <xsl:when
                test="translate(normalize-space(str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                <xsl:text>[</xsl:text>
                <i18n:text>no title</i18n:text>
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="str[@name=concat('inscription-title-', $lang)]"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </dd>
      </xsl:for-each>
    </dl>
  </xsl:template>

</xsl:stylesheet>
