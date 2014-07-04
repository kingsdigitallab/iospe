<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

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
        <i18n:text key="__concordance_notice">Concordance and comparatio numerorum of previous publications of all
          inscriptions</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generateConcordance">
    <xsl:variable name="distinct-bibls">
      <xsl:for-each-group select="//doc" group-by="str[@name=concat('bibl-short-',$lang)]">
        <xsl:sort
          select="iospe:sort-bibliography(/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id=current()/str[@name='bibl-target']])"/>
        <xsl:sort
          select="normalize-space(/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id=current()/str[@name='bibl-target']]/*[tei:imprint[tei:date]][1]/tei:imprint[tei:date][1]/tei:date[1])"/>
        <doc>
          <xsl:sequence select="str[@name=concat('bibl-short-',$lang)]"/>
          <xsl:sequence select="str[@name='bibl-target']"/>
        </doc>
      </xsl:for-each-group>
    </xsl:variable>

    <div class="large-8 medium-12 small-11 columns concordance" xsl:exclude-result-prefixes="#all">
      <ul class="no-bullet">
        <xsl:call-template name="tpl-list">
          <xsl:with-param name="bibls" select="$distinct-bibls"/>
          <xsl:with-param name="master-bib" select="/aggregation/bib"/>
        </xsl:call-template>
      </ul>
    </div>

  </xsl:template>


  <xsl:template name="tpl-list">
    <xsl:param name="bibls"/>
    <xsl:param name="master-bib"/>
    <xsl:for-each select="$bibls/*[name()='doc']">
      <li class="concordance_item">
        <p class="concordance_link right">
          <a href="publications/{(str[@name='bibl-target'])[1]}.html" i18n:attr="title" title="View Concordance">
            <i class="fa fa-list fa-3x">
              <xsl:text> </xsl:text>
            </i>
          </a>
        </p>
        <p class="reference">
          <xsl:apply-templates
            select="$master-bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id = current()/str[@name='bibl-target']]"/>

        </p>
      </li>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
