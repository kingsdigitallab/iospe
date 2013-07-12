<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<!-- Creates epidoc view for tabs, needs only to be copied by stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
  <xsl:output method="text" indent="yes"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:variable name="lb">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:apply-templates select="//div[@type='edition']"/>
  </xsl:template>
  
  <xsl:template match="*[not(self::name or self::placeName or self::persName or self::geogName or 
                       self::seg[not(@part)] or self::w[not(@part)])]">
    
    <xsl:choose>
      <!-- empty -->
      <xsl:when test="not(node())">
        <xsl:value-of select="concat('&lt;',name())"/>
        <xsl:apply-templates select="@*[not(name()='xml:space')]"/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <!-- seg and w exceptions -->
      <xsl:when test="self::seg or self::w">
        <xsl:value-of select="concat('&lt;',name())"/>
        <xsl:apply-templates select="@part"/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <!-- not empty -->
      <xsl:otherwise>
        <xsl:value-of select="concat('&lt;',name())"/>
        <xsl:apply-templates select="@*[not(name()='xml:space')]"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:value-of select="concat('&lt;/',name(),'&gt;')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:value-of select="concat(' ',name(),'=', '&quot;', ., '&quot;')"/>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:value-of select="replace(., '    ', ' ')"/>
  </xsl:template>

</xsl:stylesheet>
