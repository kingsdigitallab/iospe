<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="concordance"/>

  <xsl:import href="../common/conversions.xsl"/>
  <xsl:import href="bibliography.xsl"/>

  <xsl:template match="/"/>

  <xsl:template name="concordanceTitle">
    <xsl:choose>
      <xsl:when test="$concordance='home'">
        <i18n:text>Concordances</i18n:text>
      </xsl:when>
      <xsl:when test="$concordance='publications'">
        <i18n:text>Epigraphic editions of inscriptions, by author</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generateConcordance">
    <xsl:variable name="distinct-bibls">
      <xsl:for-each-group select="//doc" group-by="str[@name=concat('bibl-short-',$lang)]">
        <xsl:sort select="str[@name=concat('bibl-short-',$lang)]"/>
        <!-- sorting here or solr?? -->
        <!-- THIS MAY BE DONE IN SOLR if sorting value is bibl-short -->
        <doc>
          <xsl:sequence select="str[@name=concat('bibl-short-',$lang)]"/>
          <xsl:sequence select="str[@name='bibl-target']"/>
        </doc>
      </xsl:for-each-group>
    </xsl:variable>

    <xsl:variable name="item-count" select="count($distinct-bibls/*)"/>

    <xsl:choose>
      <xsl:when test="$item-count >= 30">
        <div class="concordance">
          <xsl:call-template name="tpl-list">
            <xsl:with-param name="col" select="1"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
            <xsl:with-param name="master-bib" select="/aggregation/bib"/>
          </xsl:call-template>
          <xsl:call-template name="tpl-list">
            <xsl:with-param name="col" select="2"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
            <xsl:with-param name="master-bib" select="/aggregation/bib"/>
          </xsl:call-template>
          <xsl:call-template name="tpl-list">
            <xsl:with-param name="col" select="3"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
            <xsl:with-param name="master-bib" select="/aggregation/bib"/>
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:otherwise>

        <div class="concordance">
          <dl>
            <xsl:call-template name="tpl-list">
              <xsl:with-param name="col" select="1"/>
              <xsl:with-param name="item-count" select="$item-count"/>
              <xsl:with-param name="bibls" select="$distinct-bibls"/>
              <xsl:with-param name="master-bib" select="/aggregation/bib"/>
            </xsl:call-template>
          </dl>
        </div>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="tpl-list">
    <xsl:param name="col"/>
    <xsl:param name="item-count"/>
    <xsl:param name="bibls"/>
    <xsl:param name="master-bib"/>

    <xsl:variable name="div">
      <xsl:number value="ceiling($item-count div 3)"/>
    </xsl:variable>
    <xsl:variable name="bottom-limit">
      <xsl:number value="$div * ($col - 1)" format="0001"/>
    </xsl:variable>
    <xsl:variable name="top-limit">
      <xsl:number value="$div * $col" format="0001"/>
    </xsl:variable>
    <div class="large-4 columns col{$col}" xsl:exclude-result-prefixes="#all">

      <ul class="no-bullet">
        <xsl:for-each select="$bibls/*[name()='doc']">
          <xsl:variable name="item-pos">
            <xsl:number format="0001"/>
          </xsl:variable>
          <xsl:if test="$top-limit >= $item-pos and $item-pos > $bottom-limit">
            <li>
              <p class="reference">
                <xsl:apply-templates
                  select="$master-bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id = current()/str[@name='bibl-target']]"/>
                
                <xsl:text> [</xsl:text>
                <a href="publications/{(str[@name='bibl-target'])[1]}.html">
                  <xsl:value-of select="normalize-space(str[@name=concat('bibl-short-',$lang)])"/>
                </a>
                <xsl:text>] </xsl:text>
              </p>
            </li>
          </xsl:if>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>



</xsl:stylesheet>
