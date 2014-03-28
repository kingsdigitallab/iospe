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

      <!-- Authors -->
      <xsl:for-each select=".//tei:author">
        <xsl:value-of select=".//tei:roleName[@xml:lang=$lang or not(@xml:lang)]"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select=".//tei:forename[@xml:lang=$lang or not(@xml:lang)]"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select=".//tei:surname[@xml:lang=$lang or not(@xml:lang)]"/>
        <xsl:if test="not(position() = last())">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text> (</xsl:text>

      <!-- Date -->
      <xsl:value-of select=".//tei:imprint/tei:date"/>
      <xsl:text>). </xsl:text>

      <!-- Title -->
      <em>
        <xsl:value-of select=".//tei:title"/>
        <xsl:text>. </xsl:text>
      </em>
      
      <!-- Place-->
      <xsl:value-of select=".//tei:imprint/tei:pubPlace[@xml:lang=$lang or not(@xml:lang)]"/>
      <xsl:text>. </xsl:text>
      
      
      <!-- parts -->
      <pre>
        <xsl:for-each select="*">
          <xsl:value-of select="./local-name()"/><br/>
        </xsl:for-each>
      </pre>
    </p>
  </xsl:template>
</xsl:stylesheet>
