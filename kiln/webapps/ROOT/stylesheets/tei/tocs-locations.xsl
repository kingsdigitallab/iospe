<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">



  <xsl:import href="inscription.xsl"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="tocTitleLocations">
    <i18n:text>Byzantine Inscriptions</i18n:text>
  </xsl:template>

  <xsl:template name="generateTocLocations">
    <dl class="indices indices-locations tocs">
      <xsl:for-each select="//AL//tei:place">

        <xsl:if test="//doc/arr[@name='origin-ref']/str[.=current()/@xml:id]">
          
          <dt>
          <xsl:value-of select="translate(tei:placeName[@xml:lang=$lang],'.','')"/>
        </dt>

        <xsl:for-each select="//doc/arr[@name='origin-ref']/str[.=current()/@xml:id]">
          <xsl:sort select="ancestor::doc/int[@name='sortable-id']"/>
          <dd>
            <a href="/{ancestor::doc/str[@name='tei-id']}{$kiln:url-lang-suffix}.html">
              <!-- inscription number -->
              <xsl:call-template name="formatInscrNum">
                <xsl:with-param name="num" select="ancestor::doc/str[@name='tei-id']"/>
                <xsl:with-param name="printCorpus" select="true()"/>
              </xsl:call-template>

              <!-- origin -->
              <xsl:text> </xsl:text>
              <xsl:if test="ancestor::doc/str[@name='cert-origin'] = 'low'"><xsl:text>(?)</xsl:text></xsl:if>
              <xsl:value-of select="ancestor::doc/str[@name=concat('origin-', $lang)]"/>
              <xsl:text> </xsl:text>

              <!-- title -->
              <xsl:choose>
                <xsl:when
                  test="translate(normalize-space(ancestor::doc/str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                  <xsl:text>[</xsl:text>
                  <i18n:text>ERROR: no title</i18n:text>
                  <xsl:text>]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="ancestor::doc/str[@name=concat('inscription-title-', $lang)]"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="not(ancestor::doc/str[@name='inscription-has-date'] = 'yes')">
                <xsl:choose>
                  <xsl:when
                    test="ancestor::doc/arr[@name=concat('origDate-', 'en')]/str[1] = 'Unknown.'">
                    <xsl:text>.</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>, </xsl:text>
                    <!-- origDate -->
                    <xsl:value-of
                      select="ancestor::doc/arr[@name=concat('origDate-', $lang)]/str[1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>

            </a>
          </dd>
        </xsl:for-each>
        
        </xsl:if>
        
        
      </xsl:for-each>
    </dl>
  </xsl:template>

</xsl:stylesheet>
