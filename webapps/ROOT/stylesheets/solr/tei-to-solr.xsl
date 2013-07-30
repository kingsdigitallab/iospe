<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:variable name="criteria">
    <xsl:sequence select="/aggregation/criteria/tei:TEI/tei:text/tei:body/tei:list" />
  </xsl:variable>
  <xsl:variable name="execution">
    <xsl:sequence select="/aggregation/execution/list" />
  </xsl:variable>
  <xsl:variable name="location">
    <xsl:sequence select="/aggregation/location/tei:TEI/tei:text/tei:body/tei:listPlace" />
  </xsl:variable>
  <xsl:variable name="material">
    <xsl:sequence select="/aggregation/material/tei:TEI/tei:text/tei:body/tei:list" />
  </xsl:variable>
  <xsl:variable name="monument">
    <xsl:sequence select="/aggregation/monument/tei:TEI/tei:text/tei:body/tei:list" />
  </xsl:variable>
  <xsl:variable name="document">
    <xsl:sequence select="/aggregation/document/tei:TEI/tei:text/tei:body/tei:list" />
  </xsl:variable>

  <xsl:template match="/">
    <add>
      <!-- Doing all in different passes to make sure that all indexes are populated -->
      <xsl:apply-templates mode="publication" />
      <xsl:apply-templates mode="origin" />
      <xsl:apply-templates mode="findspot" />
      <xsl:apply-templates mode="inscription" />
      <xsl:apply-templates mode="date" />
      <xsl:apply-templates mode="words" />
      <xsl:apply-templates mode="death" />
      <xsl:apply-templates mode="abbr" />
      <xsl:apply-templates mode="fragment" />
      <xsl:apply-templates mode="ligature" />
      <xsl:apply-templates mode="month" />
      <xsl:apply-templates mode="name" />
      <xsl:apply-templates mode="attested" />
      <xsl:apply-templates mode="symbol" />
      <xsl:apply-templates mode="num" />
      <xsl:apply-templates mode="place" />

      <xsl:call-template name="add-document" />
    </add>
  </xsl:template>

  <xsl:template match="text()" mode="#all" priority="-1" />

  <!-- Unit: PUBLICATION (Concordances) -->
  <xsl:template match="tei:bibl[tei:biblScope][descendant::tei:ptr]" mode="publication">
    <doc>
      <xsl:comment>Publication</xsl:comment>
      <!--<field name="id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
      </field>-->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='en']), ' ', '') != ''">
        <field name="inscription-title-en">
          <xsl:value-of select="ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='en']" />
        </field>
      </xsl:if>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='ru']), ' ', '') != ''">
        <field name="inscription-title-ru">
          <xsl:value-of select="ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='ru']" />
        </field>
      </xsl:if>
      <field name="publications">
        <xsl:value-of select="tei:biblScope" />
      </field>
      <!-- SORTING IN POST-QUERY XSLT to account for mix of numeric and string values -->
      <xsl:variable name="target" select="descendant::tei:ptr[1]/@target" />
      <field name="bibl-target">
        <xsl:value-of select="$target" />
      </field>
      <!-- From AL bibliography.xml -->
      <xsl:for-each select="//tei:biblStruct[@xml:id=$target]">
        <field name="bibl-short-en">
          <xsl:value-of select="descendant::tei:author[1]//tei:surname[@xml:lang='en' or not(@xml:lang)]" />
          <xsl:if test="descendant::tei:author[2]">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="descendant::tei:author[2]//tei:surname[@xml:lang='en' or not(@xml:lang)]" />
          </xsl:if>
          <xsl:if test="count(//tei:biblStruct[@xml:id=$target]//tei:author[1])>2">, et al.</xsl:if>
          <xsl:text> </xsl:text>
          <xsl:value-of select="descendant::tei:imprint/tei:date" />
        </field>
        <field name="bibl-short-ru">
          <xsl:value-of select="descendant::tei:author[1]//tei:surname[@xml:lang='ru' or not(@xml:lang)]" />
          <xsl:if test="descendant::tei:author[2]">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="descendant::tei:author[2]//tei:surname[@xml:lang='ru' or not(@xml:lang)]" />
          </xsl:if>
          <xsl:if test="count(//tei:biblStruct[@xml:id=$target]//tei:author[1])>2">, и др.</xsl:if>
          <xsl:text> </xsl:text>
          <xsl:value-of select="descendant::tei:imprint/tei:date" />
        </field>
        <field name="bibl-title">
          <xsl:text>(FIXME) </xsl:text>
          <xsl:for-each select="descendant::tei:title">
            <xsl:value-of select="." />
            <xsl:if test="following::tei:title[ancestor::tei:biblStruct[@xml:id=$target]]">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </field>
      </xsl:for-each>
    </doc>
  </xsl:template>

  <!-- Unit: ORIGIN (Tables of Content) -->
  <xsl:template match="tei:origin/tei:origPlace[@ref][1]" mode="origin">
    <doc>
      <xsl:comment>Origin</xsl:comment>
      <!--<field name="id">
        <xsl:text>origin-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <xsl:if test="descendant::tei:*[@cert='low'] or ancestor-or-self::tei:*[@cert='low']">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='en']), ' ', '') != ''">
        <field name="inscription-title-en">
          <xsl:value-of
            select="ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='en']" />
        </field>
      </xsl:if>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI//tei:titleStmt/tei:title[@xml:lang='ru']), ' ', '') != ''">
        <field name="inscription-title-ru">
          <xsl:value-of
            select="ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='ru']" />
        </field>
      </xsl:if>
      <!-- Indexed Item Value(s) -->
      <xsl:for-each select="tokenize(@ref, ' ')">
        <field name="origin-ref">
          <xsl:value-of select="substring-after(., '#')" />
        </field>
      </xsl:for-each>
      <field name="origin-en">
        <xsl:value-of select="tei:seg[@xml:lang='en']" />
      </field>
      <field name="origin-ru">
        <xsl:value-of select="tei:seg[@xml:lang='ru']" />
      </field>
      <!--<field name="origin-en">
        <xsl:value-of select="//origplace//tei:place[@xml:id=current()/@ref]/tei:placeName[xml:lang='en']"/>
      </field>
      <field name="origin-ru">
        <xsl:value-of select="//origplace//tei:place[@xml:id=current()/@ref]/tei:placeName[xml:lang='ru']"/>
      </field>
      <field name="areas-en">
        <xsl:for-each select="//origplace//tei:place[@xml:id=current()/@ref]/ancestor::tei:place">
          <xsl:value-of select="tei:placeName[@xml:lang='en']"/>
        </xsl:for-each>
      </field>
      <field name="areas-ru">
        <xsl:for-each select="//origplace//tei:place[@xml:id=current()/@ref]/ancestor::tei:place">
          <xsl:value-of select="tei:placeName[@xml:lang='ru']"/>
        </xsl:for-each>
      </field>
      <field name="region-en">
        <xsl:value-of select="//origplace//tei:place[@xml:id=current()/@ref]/ancestor::tei:listPlace/head[@xml:lang='en']"/>
      </field>
      <field name="region-ru">
        <xsl:value-of select="//origplace//tei:place[@xml:id=current()/@ref]/ancestor::tei:listPlace/head[@xml:lang='ru']"/>
      </field>-->
    </doc>
  </xsl:template>

  <!-- Unit: FINDSPOT (index) -->
  <xsl:template match="tei:provenance[@type='found'][descendant::tei:placeName]" mode="findspot">
    <doc>
      <xsl:comment>Findspot</xsl:comment>
      <!--<field name="id">
        <xsl:text>findspot-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:provenance[@type='found'][@ref][descendant::tei:placeName[@type='ancientFindspot']]) &gt; 1">
          <xsl:message>findspot: <xsl:number count="tei:provenance[@type='found'][@ref][descendant::tei:placeName[@type='ancientFindspot']]" level="any"/></xsl:message>
          <xsl:number level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <xsl:if test="descendant::tei:*[@cert='low'] or ancestor-or-self::tei:*[@cert='low']">
        <field name="cert">low</field>
      </xsl:if>
      <!-- Indexed Item Value(s) -->
      <field name="findspot-en">
        <xsl:value-of select="normalize-space(tei:seg[@xml:lang='en']/tei:placeName[1])" />
      </field>
      <field name="findspot-ru">
        <xsl:value-of select="normalize-space(tei:seg[@xml:lang='ru']/tei:placeName[1])" />
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: INSCRIPTION (Tables of Content) -->
  <xsl:template match="tei:TEI[descendant::tei:div[@type='edition']]" mode="inscription">
    <doc>
      <xsl:comment>Inscription</xsl:comment>
      <!--<field name="id">
        <xsl:text>inscription-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
      </field>-->
      <field name="inscription">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="descendant::tei:idno[@type='filename']" />
      </field>
      <xsl:if
        test="translate(normalize-space(descendant::tei:titleStmt/tei:title[@xml:lang='en']), ' ', '') != ''">
        <field name="inscription-title-en">
          <xsl:value-of select="descendant::tei:titleStmt/tei:title[@xml:lang='en']" />
        </field>
      </xsl:if>
      <xsl:if
        test="translate(normalize-space(descendant::tei:titleStmt/tei:title[@xml:lang='ru']), ' ', '') != ''">
        <field name="inscription-title-ru">
          <xsl:value-of select="descendant::tei:titleStmt/tei:title[@xml:lang='ru']" />
        </field>
      </xsl:if>
    </doc>
  </xsl:template>


  <!-- Unit: DATE (Table of Contents) -->
  <xsl:template match="tei:origDate[@value or (@notBefore and @notAfter)]" mode="date">
    <xsl:variable name="notBefore">
      <xsl:choose>
        <xsl:when test="@value">
          <xsl:value-of select="@value" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@notBefore" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="notAfter">
      <xsl:choose>
        <xsl:when test="@value">
          <xsl:value-of select="@value" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@notAfter" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <doc>
      <xsl:comment>Date</xsl:comment>
      <!--<field name="id">
        <xsl:text>date-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:origDate[@value or (@notBefore and @notAfter)]) &gt; 1">
          <xsl:message>date: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:origDate[@value or (@notBefore and @notAfter)]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='en']), ' ', '') != ''">
        <field name="inscription-title-en">
          <xsl:value-of
            select="ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='en']" />
        </field>
      </xsl:if>
      <xsl:if
        test="translate(normalize-space(ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='ru']), ' ', '') != ''">
        <field name="inscription-title-ru">
          <xsl:value-of
            select="ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[@xml:lang='ru']" />
        </field>
      </xsl:if>
      <!-- TOC Item Information -->
      <field name="date-en">
        <xsl:value-of select="tei:seg[@xml:lang='en']" />
      </field>
      <field name="date-ru">
        <xsl:value-of select="tei:seg[@xml:lang='ru']" />
      </field>
      <xsl:if test="descendant::tei:origDate[@cert='low']">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="not(@precision) and not(following-sibling::precision)">
          <field name="date-type">dated</field>
          <field name="date-type-ru">RU: dated</field>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each
            select="//alist/list[@xml:lang='en']/century
            [number(@max)>=number(substring($notBefore, 1,4))]
            [number(substring($notAfter, 1,4))>=number(@min)]">
            <field name="date-type">
              <xsl:value-of select="@url" />
            </field>
          </xsl:for-each>
          <xsl:for-each
            select="//alist/list[@xml:lang='ru']/century
            [number(@max)>=number(substring($notBefore, 1,4))]
            [number(substring($notAfter, 1,4))>=number(@min)]">
            <field name="date-type-ru">
              <xsl:value-of select="@url" />
            </field>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <field name="date-notBefore">
        <xsl:value-of select="$notBefore" />
      </field>
      <field name="date-notAfter">
        <xsl:value-of select="$notAfter" />
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: WORDS -->

  <xsl:template match="tei:div[@type='edition']//tei:w[@lemma and @lemma != '']" mode="words">

    <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />

    <xsl:variable name="solr-id">
      <xsl:text>w-</xsl:text>
      <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      <xsl:if test="count(tei:div[@type='edition']//tei:w) &gt; 1">
        <!--<xsl:message>w: <xsl:number level="any"/></xsl:message>-->
        <xsl:number count="tei:div[@type='edition']//tei:w" level="any" />
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="common-data">
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="$lang" />
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <xsl:apply-templates />
    </xsl:variable>

    <xsl:for-each select="tokenize(normalize-space(@lemma), ' ')">
      <doc>
        <xsl:comment>Words</xsl:comment>
        <xsl:sequence select="$common-data" />
        <!-- Indexed Item Value(s) -->
        <!--<field name="id">
          <xsl:sequence select="$solr-id"/>
          <xsl:value-of select="normalize-space(.)"/>
          </field>-->
        <xsl:if test="$lang = 'grc'">
          <field name="first-letter-grc">
            <xsl:value-of
              select="
              substring(
              translate(
              translate(
              normalize-space(.), $lowercase, $uppercase)
              , $grkb4, $grkafter)
              ,1,1)"
             />
          </field>
        </xsl:if>
        <field name="first-letter">
          <xsl:choose>
            <xsl:when test="$lang = 'grc'">
              <xsl:value-of
                select="
                substring(
                translate(
                translate(
                translate(
                normalize-space(.), $lowercase, $uppercase)
                , $grkb4, $grkafter)
                , $unicode, $betacode)
                ,1,1)"
               />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="
                substring(translate(normalize-space(.), $lowercase, $uppercase),1,1)"
               />
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <field name="words">
          <xsl:value-of select="normalize-space(.)" />
        </field>
        <field name="words-sort">
          <xsl:choose>
            <xsl:when test="$lang = 'grc'">
              <xsl:value-of
                select="
                translate(translate(
                translate(
                normalize-space(.), $uppercase, $lowercase)
                , $grkb4, $grkafter), ' ', '')"
               />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')"
               />
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </doc>
    </xsl:for-each>
  </xsl:template>

  <!-- Unit: DEATH -->

  <xsl:template match="tei:div[@type='edition']//tei:date[@dur]" mode="death">
    <doc>
      <xsl:comment>Death</xsl:comment>
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <!-- Indexed Item Value(s) -->
      <field name="death">
        <xsl:value-of select="normalize-space(@dur)" />
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: ABBR -->

  <xsl:template match="tei:div[@type='edition']//tei:expan/tei:abbr[1]" mode="abbr">
    <doc>
      <xsl:comment>Abbr</xsl:comment>
      <!-- File Information -->
      <!--<field name="id">
        <xsl:text>abbr-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:expan/tei:abbr[1]) &gt; 1">
          <xsl:message>abbr: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:expan/tei:abbr[1]" level="any" />
        </xsl:if>
      </field>-->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <!-- Indexed Item Value(s) -->
      <field name="abbr">
        <xsl:variable name="aggr">
          <xsl:for-each
            select="parent::tei:expan/descendant::tei:abbr/descendant::node()[self::text() or self::tei:g]">
            <xsl:sequence select="normalize-space(.)" />
          </xsl:for-each>
        </xsl:variable>

        <xsl:for-each select="$aggr//node()">
          <!--<xsl:message>
              <xsl:sequence select="."/>
            </xsl:message>-->
          <xsl:choose>
            <xsl:when test="self::tei:g"> (<xsl:value-of select="@type" />) </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </field>
      <xsl:if test="descendant::tei:g">
        <field name="abbr-g">
          <xsl:for-each select="descendant::tei:g">
            <xsl:value-of select="@type" />
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </field>
      </xsl:if>
      <field name="expan">
        <xsl:value-of select="normalize-space(ancestor::tei:expan)" />
      </field>
      <!--<field name="abbr-sort">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of select="translate(
              translate(
              translate(
              string-join(normalize-space(.), for $a in following-sibling::tei:abbr return normalize-space($a)), $uppercase, $lowercase)
              , $grkb4, $grkafter), ' ', '')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(translate(normalize-space(ancestor::tei:expan), $uppercase, $lowercase), ' ', '')"/>
          </xsl:otherwise>
        </xsl:choose>
      </field>-->
      <field name="expan-sort">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="translate(
              translate(
              translate(
              normalize-space(ancestor::tei:expan), $uppercase, $lowercase)
              , $grkb4, $grkafter), ' ', '')"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')" />
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: FRAGMENT -->

  <xsl:template
    match="tei:div[@type='edition']//tei:w[@part=('I','M','F')][not(@lemma)][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
    | tei:div[@type='edition']//tei:name[not(@nymRef)][descendant::tei:seg[@part=('I','M','F')]][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
    | tei:div[@type='edition']//tei:orig[not(ancestor::tei:choice)]
    | tei:div[@type='edition']//tei:abbr[not(ancestor::tei:expan)]"
    mode="fragment">
    <doc>
      <xsl:comment>Fragment</xsl:comment>
      <!--<field name="id">
        <xsl:text>frag-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(//*[name()=parent::*/name()]) &gt; 1">
          <xsl:message>frag: <xsl:number level="any"/></xsl:message>
          <xsl:number count="//*[name()=parent::*/name()]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <xsl:if test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
        <field name="first-letter-grc">
          <xsl:value-of
            select="
            substring(
            translate(
            translate(
            normalize-space(.), $lowercase, $uppercase)
            , $grkb4, $grkafter)
            ,1,1)"
           />
        </field>
      </xsl:if>
      <field name="first-letter">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="
              substring(
              translate(
              translate(
              translate(
              normalize-space(.), $lowercase, $uppercase)
              , $grkb4, $grkafter)
              , $unicode, $betacode)
              ,1,1)"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="
              substring(translate(normalize-space(.), $lowercase, $uppercase),1,1)"
             />
          </xsl:otherwise>
        </xsl:choose>

      </field>
      <!-- Indexed Item Value(s) -->
      <field name="fragments">
        <xsl:value-of select="normalize-space(.)" />
      </field>
      <field name="fragments-sort">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="translate(
              translate(
              translate(
              normalize-space(.), $uppercase, $lowercase)
              , $grkb4, $grkafter), ' ', '')"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')" />
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: LIGATURE -->

  <xsl:template match="tei:div[@type='edition']//tei:hi[@rend='ligature']" mode="ligature">
    <doc>
      <xsl:comment>Ligature</xsl:comment>
      <!-- File Information -->
      <!--<field name="id">
        <xsl:text>ligature-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:hi[@rend='ligature']) &gt; 1">
          <xsl:message>ligature: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:hi[@rend='ligature']" level="any" />
        </xsl:if>
      </field>-->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <!-- Indexed Item Value(s) -->
      <field name="ligatures">
        <xsl:if test="@xml:id">
          <xsl:variable name="cur-id" select="@xml:id" />
          <xsl:for-each select="ancestor::tei:div[1]//tei:link">
            <xsl:if test="contains(@targets, $cur-id)">
              <xsl:value-of select="normalize-space(.)" />
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </field>
      <!-- ligatures-sort is copy of ligatures. See schema.xml -->
    </doc>
  </xsl:template>

  <!-- Unit: MONTH -->

  <xsl:template match="tei:div[@type='edition']//tei:rs[@type='month'][@ref]" mode="month">
    <doc>
      <xsl:comment>Month</xsl:comment>
      <!--<field name="id">
        <xsl:text>month-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:rs[@type='month'][@key]) &gt; 1">
          <xsl:message>month: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:rs[@type='month'][@key]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <!-- Indexed Item Value(s) -->
      <field name="months">
        <xsl:value-of select="normalize-space(.)" />
      </field>
      <field name="months-ref">
        <xsl:value-of select="normalize-space(@ref)" />
      </field>
      <field name="months-sort">
        <xsl:value-of select="//alist//month[.=normalize-space(@ref)]/@order" />
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: NAME -->

  <xsl:template match="tei:div[@type='edition']//tei:name[not(preceding-sibling::tei:name = .)]"
    mode="name">
    <doc>
      <xsl:comment>Name</xsl:comment>
      <!--<field name="id">
        <xsl:text>name-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:name[@nymRef][not(preceding-sibling::tei:name = .)]) &gt; 1">
          <xsl:message>name: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:name[@nymRef][not(preceding-sibling::tei:name = .)]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <xsl:if test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
        <field name="first-letter-grc">
          <xsl:value-of
            select="
            substring(
            translate(
            translate(
            normalize-space(.), $lowercase, $uppercase)
            , $grkb4, $grkafter)
            ,1,1)"
           />
        </field>
      </xsl:if>
      <field name="first-letter">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="
              substring(
              translate(
              translate(
              translate(
              normalize-space(.), $lowercase, $uppercase)
              , $grkb4, $grkafter)
              , $unicode, $betacode)
              ,1,1)"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="
              substring(translate(normalize-space(.), $lowercase, $uppercase),1,1)"
             />
          </xsl:otherwise>
        </xsl:choose>

      </field>
      <!-- Indexed Item Value(s) -->
      <field name="names">
        <xsl:value-of select="." />
      </field>
      <field name="name-type">
        <xsl:value-of select="@type" />
      </field>
      <field name="persName-type">
        <xsl:value-of select="ancestor::tei:persName[1]/@type" />
      </field>
      <field name="persName-key">
        <xsl:value-of select="ancestor::tei:persName[1]/@key" />
      </field>
      <xsl:if test="ancestor::tei:persName[1]/@ref">
        <field name="persName-ref">
          <xsl:value-of select="ancestor::tei:persName[1]/@ref" />
        </field>
      </xsl:if>
      <field name="persName-full">
        <!-- IF IT CONTAINS CHOICE/CORR, GET CORR -->
        <xsl:value-of
          select="normalize-space(string-join(ancestor::tei:persName[1]//text()[not(parent::tei:sic)][not(parent::tei:orig[parent::tei:choice])], ''))"
         />
      </field>
      <field name="name-nymRef">
        <xsl:value-of select="normalize-space(@nymRef)" />
      </field>
      <field name="names-sort">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="translate(
              translate(
              translate(
              normalize-space(string-join(ancestor::tei:persName[1]//text(), '')), $uppercase, $lowercase)
              , $grkb4, $grkafter), ' ', '')"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="translate(translate(normalize-space(string-join(ancestor::tei:persName[1]//text(), '')), $uppercase, $lowercase), ' ', '')"
             />
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </doc>
  </xsl:template>

  <!-- Unit: ATTESTED -->

  <xsl:template
    match="tei:div[@type='edition']//tei:name[@nymRef][ancestor::tei:persName[@type=('attested', 'ruler')]][not(preceding-sibling::tei:name = .)]"
    mode="attested">
    <!--<field name="id">
        <xsl:text>name-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:name[@nymRef][not(preceding-sibling::tei:name = .)]) &gt; 1">
        <xsl:message>name: <xsl:number level="any"/></xsl:message>
        <xsl:number count="tei:div[@type='edition']//tei:name[@nymRef][not(preceding-sibling::tei:name = .)]" level="any" />
        </xsl:if>
        </field>-->

    <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />

    <xsl:variable name="common-data">
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="$lang" />
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <xsl:apply-templates />
    </xsl:variable>

    <xsl:for-each select="tokenize(normalize-space(@nymRef), ' ')">
      <doc>
        <xsl:comment>Attested</xsl:comment>
        <xsl:sequence select="$common-data" />
        <!-- Indexed Item Value(s) -->
        <!--<field name="id">
            <xsl:sequence select="$solr-id"/>
            <xsl:value-of select="normalize-space(.)"/>
            </field>-->
        <xsl:if test="$lang = 'grc'">
          <field name="first-letter-grc">
            <xsl:value-of
              select="
                substring(
                translate(
                translate(
                normalize-space(.), $lowercase, $uppercase)
                , $grkb4, $grkafter)
                ,1,1)"
             />
          </field>
        </xsl:if>
        <field name="first-letter">
          <xsl:choose>
            <xsl:when test="$lang = 'grc'">
              <xsl:value-of
                select="
                  substring(
                  translate(
                  translate(
                  translate(
                  normalize-space(.), $lowercase, $uppercase)
                  , $grkb4, $grkafter)
                  , $unicode, $betacode)
                  ,1,1)"
               />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="
                  substring(translate(normalize-space(.), $lowercase, $uppercase),1,1)"
               />
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <field name="attested">
          <xsl:value-of select="." />
        </field>
        <field name="attested-sort">
          <xsl:choose>
            <xsl:when test="$lang = 'grc'">
              <xsl:value-of
                select="
                  translate(translate(
                  translate(
                  normalize-space(.), $uppercase, $lowercase)
                  , $grkb4, $grkafter), ' ', '')"
               />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')"
               />
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </doc>
    </xsl:for-each>
  </xsl:template>

  <!-- Unit: SYMBOL -->

  <xsl:template match="tei:div[@type='edition']//tei:g" mode="symbol">
    <doc>
      <xsl:comment>Symbol</xsl:comment>
      <!--<field name="id">
        <xsl:text>symbol-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:g) &gt; 1">
          <xsl:message>symbol: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:g" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <!-- Indexed Item Value(s) -->
      <field name="symbols">
        <xsl:value-of select="@type" />
      </field>
      <!-- symbols-sort is copy of symbols. See schema.xml -->
    </doc>
  </xsl:template>

  <!-- Unit: NUMERAL -->

  <xsl:template
    match="tei:div[@type='edition']//tei:num
    [translate(normalize-space(string-join(descendant::text(), '')),' ', '')!='']
    [@value or @atLeast or @atMost]"
    mode="num">
    <doc>
      <xsl:comment>Numeral</xsl:comment>
      <!--<field name="id">
        <xsl:text>num-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(tei:div[@type='edition']//tei:num
          [translate(normalize-space(string-join(descendant::text(), '')),' ', '')!='']
          [@value or @atLeast or @atMost]) &gt; 1">
          <xsl:message>num: <xsl:number level="any"/></xsl:message>
          <xsl:number count="tei:div[@type='edition']//tei:num
            [translate(normalize-space(string-join(descendant::text(), '')),' ', '')!='']
            [@value or @atLeast or @atMost]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <!-- Indexed Item Value(s) -->
      <field name="numerals">
        <xsl:value-of select="normalize-space(.)" />
      </field>
      <xsl:if test="@value">
        <field name="num-value">
          <xsl:value-of select="@value" />
        </field>
      </xsl:if>
      <xsl:if test="@atLeast">
        <field name="num-atleast">
          <xsl:value-of select="@atLeast" />
        </field>
      </xsl:if>
      <xsl:if test="@atMost">
        <field name="num-atmost">
          <xsl:value-of select="@atMost" />
        </field>
      </xsl:if>
      <xsl:if test="@value or @atLeast or @atMost">
        <field name="numerals-sort">
          <xsl:choose>
            <xsl:when test="@value">
              <xsl:value-of select="@value" />
            </xsl:when>
            <xsl:when test="@atLeast">
              <xsl:value-of select="@atLeast" />
            </xsl:when>
            <xsl:when test="@atMost">
              <xsl:value-of select="@atMost" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@atMost" />
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </xsl:if>
    </doc>
  </xsl:template>

  <!-- Unit: PLACE -->

  <xsl:template
    match="tei:div[@type='edition']//tei:placeName[@key]
    | tei:div[@type='edition']//tei:geogName[@key]"
    mode="place">
    <doc>
      <xsl:comment>Place</xsl:comment>
      <!--<field name="id">
        <xsl:text>place-</xsl:text>
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']"/>
        <xsl:if test="count(//*[name()=parent::*/name()]) &gt; 1">
          <xsl:message>place: <xsl:number level="any"/></xsl:message>
          <xsl:number count="//*[name()=parent::*/name()]" level="any" />
        </xsl:if>
      </field>-->
      <!-- File Information -->
      <field name="file">
        <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
      </field>
      <field name="tei-id">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
      </field>
      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n" />
        </field>
      </xsl:for-each>
      <field name="line">
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </field>
      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang" />
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <!-- Indexed Item Value(s) -->
      <field name="places">
        <xsl:value-of select="normalize-space(.)" />
      </field>
      <field name="places-key">
        <xsl:value-of select="normalize-space(@key)" />
      </field>
      <field name="places-sort">
        <xsl:choose>
          <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
            <xsl:value-of
              select="translate(
              translate(
              translate(
              normalize-space(.), $uppercase, $lowercase)
              , $grkb4, $grkafter), ' ', '')"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')" />
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </doc>
  </xsl:template>

  <xsl:template name="add-document">
    <xsl:variable name="idno"
      select="/aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']" />

    <xsl:if test="$idno">
      <doc>
        <field name="file">
          <xsl:value-of select="substring-after($file-path, 'inscriptions/')" />
        </field>
        <field name="tei-id">
          <xsl:value-of select="$idno" />
        </field>
        <field name="dt">i</field>

        <xsl:apply-templates mode="document-metadata" select="/aggregation/tei:TEI/tei:teiHeader" />
        <xsl:apply-templates mode="document-metadata"
          select="/aggregation/tei:TEI/tei:text/tei:body" />

        <xsl:if
          test="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'divine']">
          <field name="persnames">
            <xsl:value-of select="xms:replace-spaces('sacred or divine entity')" />
          </field>
          <field name="persnames-ru">
            <xsl:value-of select="xms:replace-spaces('RU: sacred or divine entity')" />
          </field>
          <field name="persnames-en">
            <xsl:value-of select="xms:replace-spaces('sacred or divine entity')" />
          </field>
        </xsl:if>
        <xsl:if
          test="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'ruler']">
          <field name="persnames">
            <xsl:value-of select="xms:replace-spaces('emperor or ruler')" />
          </field>
          <field name="persnames-ru">
            <xsl:value-of select="xms:replace-spaces('RU: emperor or ruler')" />
          </field>
          <field name="persnames-en">
            <xsl:value-of select="xms:replace-spaces('emperor or ruler')" />
          </field>
        </xsl:if>
        <xsl:if
          test="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'attested']">
          <field name="persnames">
            <xsl:value-of select="xms:replace-spaces('other person')" />
          </field>
          <field name="persnames-ru">
            <xsl:value-of select="xms:replace-spaces('RU: other person')" />
          </field>
          <field name="persnames-en">
            <xsl:value-of select="xms:replace-spaces('other person')" />
          </field>
        </xsl:if>

        <xsl:apply-templates mode="document-body" select="/aggregation/tei:TEI/tei:text/tei:body" />

        <field name="text">
          <xsl:value-of
            select="/aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc" />
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title[@xml:lang]" mode="document-metadata">
    <field name="document-title">
      <xsl:value-of select="xms:clean(.)" />
    </field>
    <field name="document-title-{@xml:lang}">
      <xsl:value-of select="xms:clean(.)" />
    </field>
  </xsl:template>

  <xsl:function as="xs:string" name="xms:clean">
    <xsl:param name="value" />

    <xsl:value-of select="normalize-space(replace($value, '\(\?\)', ''))" />
  </xsl:function>

  <xsl:template match="tei:origDate" mode="document-metadata">
    <xsl:if test="normalize-space(@notBefore)">
      <field name="not-before">
        <xsl:value-of select="xms:get-year-from-date(@notBefore)" />
      </field>
    </xsl:if>
    <xsl:if test="normalize-space(@notAfter)">
      <field name="not-after">
        <xsl:value-of select="xms:get-year-from-date(@notAfter)" />
      </field>
    </xsl:if>

    <xsl:if test="normalize-space(@evidence)">
      <xsl:for-each select="tokenize(@evidence, ' ')">
        <xsl:variable name="evidence" select="translate(., '-', ' ')" />
        <xsl:variable name="evidence-en"
          select="$criteria/tei:list/tei:item[preceding-sibling::tei:label[1] = $evidence]" />

        <field name="evidence">
          <xsl:value-of select="xms:replace-spaces($evidence)" />
        </field>
        <field name="evidence-ru">
          <xsl:value-of select="xms:replace-spaces($evidence)" />
        </field>
        <field name="evidence">
          <xsl:value-of select="xms:replace-spaces($evidence-en)" />
        </field>
        <field name="evidence-en">
          <xsl:value-of select="xms:replace-spaces($evidence-en)" />
        </field>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:function as="xs:integer" name="xms:get-year-from-date">
    <xsl:param name="date" />

    <xsl:variable name="year">
      <xsl:analyze-string regex="(-?)(\d{{4}})(-\d{{2}})?(-\d{{2}})?" select="$date">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)" />
          <xsl:value-of select="regex-group(2)" />
        </xsl:matching-substring>
        <xsl:fallback>
          <xsl:value-of select="." />
        </xsl:fallback>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:value-of select="$year" />
  </xsl:function>

  <xsl:function as="xs:string" name="xms:replace-spaces">
    <xsl:param name="value" />

    <xsl:value-of select="normalize-space(replace($value, '\s', '_'))" />
  </xsl:function>

  <xsl:template match="tei:objectType" mode="document-metadata">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')" />

      <xsl:for-each select="$monument/tei:list/tei:item[@xml:id = $ref]">
        <field name="monument-type">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>
        <field name="monument-type-{@xml:lang}">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="monument-type-{@xml:lang}">
            <xsl:value-of select="xms:replace-spaces(.)" />
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:summary[@corresp]" mode="document-metadata">
    <xsl:for-each select="tokenize(@corresp, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')" />

      <xsl:for-each select="$document/tei:list/tei:item[@xml:id = $ref]">
        <field name="document-type">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>
        <field name="document-type-ru">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="document-type-{@xml:lang}">
            <xsl:value-of select="xms:replace-spaces(.)" />
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:origPlace" mode="document-metadata">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')" />

      <xsl:for-each
        select="$location/tei:listPlace/tei:place[@xml:id = $ref]/tei:placeName[@xml:lang = ('en', 'ru')]">
        <field name="location">
          <xsl:value-of select="xms:replace-spaces(.)" />
        </field>
        <field name="location-{@xml:lang}">
          <xsl:value-of select="xms:replace-spaces(.)" />
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:material[@xml:lang = 'ru']" mode="document-metadata">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')" />


      <xsl:for-each select="$material/tei:list/tei:item[@xml:id = $ref]">
        <field name="material">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>
        <field name="material-{tei:term/@xml:lang}">
          <xsl:value-of select="xms:replace-spaces(tei:term)" />
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="material-{@xml:lang}">
            <xsl:value-of select="xms:replace-spaces(.)" />
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:rs[@type = 'execution']" mode="document-metadata">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')" />

      <xsl:for-each select="$execution/list/item[@xml:id = $ref]/term">
        <field name="execution">
          <xsl:value-of select="xms:replace-spaces(.)" />
        </field>
        <field name="execution-{@xml:lang}">
          <xsl:value-of select="xms:replace-spaces(.)" />
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:repository" mode="document-metadata">
    <field name="institution">
      <xsl:value-of select="xms:replace-spaces(xms:clean(.))" />
    </field>
    <field name="institution-{parent::*/@xml:lang}">
      <xsl:value-of select="xms:replace-spaces(xms:clean(.))" />
    </field>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'edition']" mode="document-body">
    <field name="edition">
      <xsl:apply-templates mode="edition" />
    </field>
    <field name="diplomatic">
      <xsl:apply-templates mode="diplomatic" />
    </field>
    <field name="lemma">
      <xsl:apply-templates mode="lemma" />
    </field>
  </xsl:template>

  <xsl:template match="tei:app" mode="edition">
    <xsl:apply-templates mode="#current" select="tei:lem" />
  </xsl:template>
  <xsl:template match="tei:app" mode="diplomatic">
    <xsl:apply-templates mode="#current" select="tei:rdg" />
  </xsl:template>

  <xsl:template match="tei:choice" mode="edition">
    <xsl:apply-templates mode="#current" select="tei:corr" />
    <xsl:apply-templates mode="#current" select="tei:reg" />
  </xsl:template>
  <xsl:template match="tei:choice" mode="diplomatic">
    <xsl:apply-templates mode="#current" select="tei:sic" />
    <xsl:apply-templates mode="#current" select="tei:orig" />
  </xsl:template>

  <xsl:template match="*" mode="edition diplomatic">
    <xsl:apply-templates mode="#current" />
  </xsl:template>

  <xsl:template match="text()" mode="apparatus edition diplomatic">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="tei:w[@lemma]" mode="lemma">
    <xsl:value-of select="@lemma" />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:name[@nymRef] | tei:placeName[@nymRef]" mode="lemma">
    <xsl:choose>
      <xsl:when test="contains(@nymRef, '#')">
        <xsl:value-of select="substring-after(@nymRef, '#')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@nymRef" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'apparatus']" mode="document-body">
    <field name="apparatus">
      <xsl:apply-templates mode="apparatus" />
    </field>
  </xsl:template>

  <xsl:template match="tei:app" mode="apparatus">
    <xsl:apply-templates mode="#current" select="tei:lem" />
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="#current" select="tei:rdg" />
  </xsl:template>

  <xsl:template match="tei:rdg" mode="apparatus">
    <xsl:apply-templates mode="#current" />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:note" mode="apparatus" />

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
</xsl:stylesheet>
