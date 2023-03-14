<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl"/>
  <xsl:import href="../tei/introTOC.xsl"/>

  <xsl:template match="tei:divGen[contains(@type, 'intro-toc')]">
    <xsl:sequence select="
      if (contains(@type, 'ru'))
      then
      $introTOC-ru
      else
      $introTOC-en"/>
  </xsl:template>


  <xsl:template match="tei:list[@type = 'logo']">
    <xsl:variable name="n" select="count(child::tei:item)"/>
    <div class="row">
      <div class="large-12 columns">
        <ul class="large-block-grid-{$n}">
          <xsl:apply-templates/>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:list[@rend = 'bulleted']">
    <xsl:element name="ul">
      <xsl:attribute name="class" select="'bulleted'"> </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:list[@rend = 'bulleted']/tei:item">
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:list[@type = 'logo']//tei:ref[@target]">
    <a href="{@target}">
      <xsl:apply-templates select="@*"/>
      <xsl:if test="normalize-space(@title)">
        <xsl:attribute name="title">
          <xsl:value-of select="@title"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'ref'"/>
        <xsl:with-param name="extra-classes" select="'th'"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="tei:list[@type = 'gloss']">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="tei:list[@type = 'gloss']/tei:item">
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template match="tei:list[@type = 'gloss']/tei:label">
    <dt>
      <xsl:apply-templates/>
    </dt>
  </xsl:template>


  <xsl:template match="tei:name">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>


  <xsl:template match="tei:list[@type = 'logo']//tei:figure">
    <xsl:attribute name="id">
      <xsl:value-of select="@xml:id"/>
    </xsl:attribute>
    <xsl:call-template name="tei-assign-classes"/>
    <xsl:variable name="root-id"
      select="ancestor::tei:TEI/@xml:id | ancestor::tei:teiCorpus/@xml:id"/>
    <img src="{$kiln:content-path}/images/{$root-id}/{tei:graphic/@url}">
      <xsl:apply-templates mode="tei-alt-text" select="."/>
    </img>
  </xsl:template>

  <xsl:template match="//tei:body/tei:div/tei:head">
    <h2>
      <xsl:call-template name="divids"/>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:head">
    <h3>
      <xsl:call-template name="divids"/>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:div/tei:head">
    <h4>
      <xsl:call-template name="divids"/>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:div/tei:div/tei:head">
    <h5>
      <xsl:call-template name="divids"/>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:div/tei:div/tei:div/tei:head">
    <h6>
      <xsl:call-template name="divids"/>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>

  <xsl:template name="divids">
    <xsl:choose>
      <xsl:when test="parent::tei:div[@n]">
        <xsl:attribute name="id">
          <xsl:for-each select="ancestor::tei:div[@n]">
            <xsl:value-of select="@n"/>
            <xsl:text>-</xsl:text>
          </xsl:for-each>
        </xsl:attribute>
        <xsl:for-each select="ancestor::tei:div[@n]">
          <xsl:value-of select="@n"/>
          <xsl:text>.</xsl:text>
        </xsl:for-each>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id">
          <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
