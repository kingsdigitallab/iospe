<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<!-- Creates epidoc view for tabs, needs only to be copied by stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//div[@type='edition']/div[@n]">
        <xsl:for-each select="//div[@type='edition']/div[@n]">
          <xsl:choose>
            <xsl:when test="child::div[@n]">
              <xsl:for-each select="child::div[@n]">
                <div type="edition" n="{parent::div/@n}.{@n}">
                  <xsl:apply-templates select="."/>
                </div>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <div type="edition" n="{@n}">
                <xsl:apply-templates select="."/>
              </div>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//div[@type='edition']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
    match="*[not(self::name or self::placeName or self::persName or self::geogName or
                       self::seg[not(@part)] or self::w[not(@part)])]">

    <xsl:choose>
      <!-- empty -->
      <xsl:when test="not(node())">
        <xsl:value-of select="concat('&lt;',name())"/>
        <xsl:apply-templates select="@*[not(name()='xml:space')]"/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <!-- seg and w exceptions -->
      <!--<xsl:when test="self::seg or self::w">
        <xsl:value-of select="concat('&lt;',name())"/>
        <xsl:apply-templates select="@part"/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>-->
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
