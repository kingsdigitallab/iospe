<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0">

  <!-- Project-specific XSLT for transforming TEI to HTML. Override
       the core to-html.xsl with any local customisations. -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />


  <xsl:template match="tei:list[@type='logo']">
    <xsl:variable name="n" select="count(child::tei:item)" />
    <div class="row">
      <div class="large-12 columns">
        <ul class="large-block-grid-{$n}">
          <xsl:apply-templates />
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:ref[@target][ancestor::tei:list[@type='logo']]">
    <a href="{@target}">
      <xsl:apply-templates select="@*" />
      <xsl:if test="normalize-space(@title)">
        <xsl:attribute name="title">
          <xsl:value-of select="@title" />
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'ref'" />
        <xsl:with-param name="extra-classes" select="'th'" />
      </xsl:call-template>
      <xsl:apply-templates />
    </a>
  </xsl:template>
</xsl:stylesheet>
