<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:import href="../common/conversions.xsl"/>

  <xsl:template match="/"/>

  <xsl:template name="bibliographyTitle">
    <i18n:text>Bibliography</i18n:text>
  </xsl:template>

  <xsl:template name="generateBibliography">
    <xsl:for-each select="/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct">
      <xsl:sort
        select="./*[tei:author | tei:editor][1]/(tei:author | tei:editor)[1]/(tei:surname | tei:forename)[@xml:lang=$lang or not(@xml:lang)][1]"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="tei:biblStruct">
    <p class="reference">
      <xsl:attribute name="id" select="@xml:id"/>

      <xsl:variable name="analytic" select="./tei:analytic"/>
      <xsl:variable name="monogr" select="./tei:monogr"/>
      <xsl:variable name="series" select="./tei:series"/>


      <!-- Authors -->
      <xsl:choose>
        <xsl:when test="$analytic">
          <xsl:apply-templates select="$analytic" mode="author_list"/>
        </xsl:when>
        <xsl:when test="not($analytic) and  $monogr">
          <xsl:apply-templates select="$monogr" mode="author_list"/>
        </xsl:when>
        <xsl:when test="not($analytic | $monogr) and $series">
          <xsl:apply-templates select="$series" mode="author_list"/>
        </xsl:when>
      </xsl:choose>


      <xsl:text> (</xsl:text>

      <!-- Date -->
      <xsl:value-of select=".//tei:imprint/tei:date"/>
      <xsl:text>). </xsl:text>

      <!-- Title -->

      <em>
        <xsl:choose>
          <xsl:when test="$analytic">
            <xsl:apply-templates select="$analytic" mode="title"/>
          </xsl:when>
          <xsl:when test="not($analytic) and  $monogr">
            <xsl:apply-templates select="$monogr" mode="title"/>
          </xsl:when>
          <xsl:when test="not($analytic | $monogr) and $series">
            <xsl:apply-templates select="$series" mode="title"/>
          </xsl:when>
        </xsl:choose>
        <xsl:text>. </xsl:text>
      </em>

      <xsl:if test="$analytic">
        <xsl:apply-templates select="$monogr" mode="secondary"/>
        <xsl:apply-templates select="$series" mode="secondary"/>
      </xsl:if>
      
      <xsl:if test="not($analytic) and $monogr">
        <xsl:apply-templates select="$series" mode="secondary"/>
      </xsl:if>

      <!-- scope -->
      <xsl:apply-templates select="$analytic" mode="scope"/>


      <!-- Place & Publisher-->
      <xsl:if test=".//tei:imprint/tei:pubPlace">
        <xsl:value-of select=".//tei:imprint/tei:pubPlace[@xml:lang=$lang or not(@xml:lang)]"/>
        <xsl:if test=".//tei:imprint/tei:publisher">
          <xsl:text>: </xsl:text>
          <xsl:value-of select=".//tei:imprint/tei:publisher[@xml:lang=$lang or not(@xml:lang)]"/>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </xsl:if>

      <!--
      <!-\- debugging -\->
      <pre>
        <xsl:value-of select="@xml:id"/><br/>
        <xsl:text>analytic: </xsl:text><xsl:value-of select="if($analytic) then true() else false()"/><br/>
        <xsl:text>monogr: </xsl:text><xsl:value-of select="if($monogr) then true() else false()"/><br/>
        <xsl:text>series: </xsl:text><xsl:value-of select="if($series) then true() else false()"/><br/>
        <xsl:for-each select="*"><br/>
          <xsl:value-of select="./local-name()"/><br/>
        </xsl:for-each>
      </pre>-->
    </p>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="author_list">
    <xsl:for-each select="./tei:author | ./tei:editor">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:value-of select="./tei:surname[@xml:lang=$lang or not(@xml:lang)]"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="./tei:roleName[@xml:lang=$lang or not(@xml:lang)]"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./tei:forename[@xml:lang=$lang or not(@xml:lang)]"/>

        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./tei:roleName[@xml:lang=$lang or not(@xml:lang)]"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./tei:forename[@xml:lang=$lang or not(@xml:lang)]"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./tei:surname[@xml:lang=$lang or not(@xml:lang)]"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="./local-name() = 'editor'">
        <i18n:text> (Ed.)</i18n:text>
      </xsl:if>

      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="title">
    <xsl:value-of select="./tei:title"/>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="scope">
    <xsl:for-each select="./tei:biblScope">
      <xsl:value-of select="@type"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
      <i18n:text>. </i18n:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:monogr | tei:series" mode="secondary">
    
    <i18n:text>In </i18n:text>
    
    <!-- Authors -->
    <xsl:if test="./(tei:author | tei:editor)">
      <xsl:apply-templates select="." mode="author_list"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
    
    <!-- Title -->
    <xsl:if test="./tei:title">
      <xsl:apply-templates select="." mode="title"/>
      <xsl:text>. </xsl:text>
    </xsl:if>

    <!-- scope -->
    <xsl:apply-templates select="." mode="scope"/>
  </xsl:template>
</xsl:stylesheet>
