<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="lang" select="'en'" />
  <xsl:param name="min-year" />
  <xsl:param name="max-year" />
  <xsl:param name="params" />
  
  <xsl:variable name="xmg:min-year" select="200" as="xs:integer" />
  <xsl:variable name="xmg:max-year" select="1800" as="xs:integer" />

  <!-- Creates a Solr query. -->
  <xsl:template match="/">
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/solr/query/q=dt:i+AND+not-before:[</xsl:text>
        <xsl:value-of select="$xmg:min-year" />
        <xsl:text>+TO+</xsl:text>
        <xsl:value-of select="xs:integer($max-year)" />
        <xsl:text>]+AND+not-after:[</xsl:text>
        <xsl:value-of select="xs:integer($min-year)" />
        <xsl:text>+TO+</xsl:text>
        <xsl:value-of select="$xmg:max-year" />
        <xsl:text>]&amp;rows=20</xsl:text>
        <xsl:if test="$params">
          <xsl:text>&amp;</xsl:text>
          <xsl:value-of select="$params" />
        </xsl:if>
        <xsl:text>&amp;facet.mincount=1&amp;facet=on&amp;fl=file,tei-id,document-title-</xsl:text>
        <xsl:value-of select="$lang" />
        <xsl:for-each
          select="('not-before', 'not-after', 'persnames', 'evidence', 'monument-type', 'document-type', 'location', 'material', 'execution', 'institution')">
          <xsl:text>&amp;facet.field=</xsl:text>
          <xsl:value-of select="." />
          <xsl:if test="not(starts-with(., 'not-'))">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$lang" />
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </xi:include>
  </xsl:template>
</xsl:stylesheet>
