<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" /> -->

  <xsl:import href="../common/conversions.xsl"/>
  <xsl:import href="tei-to-solr-functions.xsl"/>
  <xsl:import href="tei-to-solr-common.xsl"/>

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the
        parameter file-path, which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:param name="file-path"/>

  <xsl:template match="/">
    <add>
      <!-- Doing all in different passes to make sure that all indexes are populated -->
      <!--<xsl:variable name="saved-common-data">
        <xsl:call-template name="common-data" >
          <xsl:with-param name="inscription" select="/aggregation/tei:TEI" />
        </xsl:call-template>
      </xsl:variable>-->
      <xsl:apply-templates mode="publication"/>
      <xsl:apply-templates mode="origin"/>
      <xsl:apply-templates mode="findspot"/>
      <xsl:apply-templates mode="inscription"/>
      <xsl:apply-templates mode="date"/>
      <xsl:apply-templates mode="words"/>
      <xsl:apply-templates mode="death"/>
      <xsl:apply-templates mode="abbr"/>
      <xsl:apply-templates mode="fragment"/>
      <xsl:apply-templates mode="ligature"/>
      <xsl:apply-templates mode="month"/>
      <xsl:apply-templates mode="name"/>
      <xsl:apply-templates mode="attested"/>
      <xsl:apply-templates mode="symbol"/>
      <xsl:apply-templates mode="num"/>
      <xsl:apply-templates mode="place"/>
    </add>
  </xsl:template>

  <xsl:template match="text()" mode="#all" priority="-1"/>

  <!-- Unit: PUBLICATION (Concordances) -->
  <xsl:template match="tei:bibl[tei:citedRange][descendant::tei:ptr]" mode="publication">
    <xsl:variable name="target" select="substring-after(descendant::tei:ptr[1]/@target, 'bib:')"/>
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'publication'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space($target),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Publication</xsl:comment>

        <field name="publications">
          <xsl:value-of select="tei:citedRange"/>
        </field>
        <!-- SORTING IN POST-QUERY XSLT to account for mix of numeric and string values -->
        <xsl:variable name="target" select="substring-after(descendant::tei:ptr[1]/@target, 'bib:')"/>
        <field name="bibl-target">
          <xsl:value-of select="$target"/>
        </field>

        <field name="bibl-list">
          <xsl:value-of
            select="//tei:listBibl[(descendant::tei:biblStruct | descendant::tei:bibl)[@xml:id=$target]]/@type"
          />
        </field>
        <!-- From AL bibliography.xml -->
        <xsl:for-each select="//(tei:biblStruct | tei:bibl)[@xml:id=$target]">

          <field name="bibl-short-en">
            <xsl:choose>
              <xsl:when test="descendant::tei:author">
                <xsl:value-of
                  select="descendant::tei:author[1]//tei:surname[@xml:lang='en' or not(@xml:lang)]"/>
                <xsl:if test="descendant::tei:author[2]">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of
                    select="descendant::tei:author[2]//tei:surname[@xml:lang='en' or not(@xml:lang)]"
                  />
                </xsl:if>
                <xsl:if test="count(descendant::tei:author[1]) &gt; 2">
                  <xsl:text>, et al.</xsl:text>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@xml:id"/>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="descendant::tei:imprint/tei:date">
                <xsl:value-of select="descendant::tei:imprint/tei:date"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="descendant::tei:date"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="bibl-short-ru">
            <xsl:choose>
              <xsl:when test="descendant::tei:author">
                <xsl:value-of
                  select="descendant::tei:author[1]//tei:surname[@xml:lang='ru' or not(@xml:lang)]"/>
                <xsl:if test="descendant::tei:author[2]">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of
                    select="descendant::tei:author[2]//tei:surname[@xml:lang='ru' or not(@xml:lang)]"
                  />
                </xsl:if>
                <xsl:if test="count(descendant::tei:author[1]) &gt; 2">
                  <xsl:text>, и др.</xsl:text>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@xml:id"/>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="descendant::tei:imprint/tei:date">
                <xsl:value-of select="descendant::tei:imprint/tei:date"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="descendant::tei:date"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="bibl-title">
            <xsl:text>(FIXME) </xsl:text>
            <xsl:for-each select="descendant::tei:title">
              <xsl:value-of select="."/>
              <xsl:if
                test="following::tei:title[(ancestor::tei:biblStruct | ancestor::tei:bibl)[@xml:id=$target]]">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </field>
        </xsl:for-each>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: ORIGIN (Tables of Content) -->

  <xsl:template match="tei:origin/tei:origPlace//tei:certainty[@cert='low']" mode="origin">
    <xsl:text>(?)</xsl:text>
  </xsl:template>


  <xsl:template match="tei:origin/tei:origPlace//tei:seg/text()" mode="origin">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="tei:origin/tei:origPlace[@ref][1]" mode="origin">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'origin'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(@ref),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Origin</xsl:comment>
        <xsl:if test="descendant::tei:*[@cert='low'] or ancestor-or-self::tei:*[@cert='low']">
          <field name="cert">low</field>
        </xsl:if>

        <!-- Indexed Item Value(s) -->
        <xsl:for-each select="tokenize(@ref, ' ')">
          <field name="origin-ref">
            <xsl:value-of select="substring-after(., '#')"/>
          </field>
        </xsl:for-each>
        <field name="origin-en">
          <xsl:apply-templates select="tei:seg[@xml:lang='en']" mode="origin"/>
        </field>
        <field name="origin-ru">
          <xsl:apply-templates select="tei:seg[@xml:lang='ru']" mode="origin"/>
        </field>

        <field name="inscription-has-date">
          <xsl:if
            test="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]/tei:origDate">
            <xsl:text>yes</xsl:text>
          </xsl:if>
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
    </xsl:if>
  </xsl:template>

  <!-- Unit: FINDSPOT (index) -->
  <xsl:template match="tei:provenance[@type='found'][descendant::tei:placeName]" mode="findspot">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'findspot'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(tei:seg[@xml:lang='en']/tei:placeName[1]),
                           '_',
                           position())"
          />
        </xsl:apply-templates>
        <xsl:comment>Findspot</xsl:comment>

        <xsl:if test="descendant::tei:*[@cert='low'] or ancestor-or-self::tei:*[@cert='low']">
          <field name="cert">low</field>
        </xsl:if>
        <!-- Indexed Item Value(s) -->
        <field name="findspot-en">
          <xsl:value-of select="normalize-space(tei:seg[@xml:lang='en']/tei:placeName[1])"/>
        </field>
        <field name="findspot-ru">
          <xsl:value-of select="normalize-space(tei:seg[@xml:lang='ru']/tei:placeName[1])"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: INSCRIPTION (Tables of Content) -->
  <xsl:template match="tei:TEI[descendant::tei:div[@type='edition']]" mode="inscription">

    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'inscription'"/>
          <xsl:with-param name="full" select="true()"/>
        </xsl:apply-templates>
        <xsl:comment>Inscription</xsl:comment>
      </doc>
    </xsl:if>
  </xsl:template>


  <!-- Unit: DATE (Table of Contents) -->
  <xsl:template match="tei:origDate[@value or (@notBefore and @notAfter)]" mode="date">
    <xsl:variable name="notBefore">
      <xsl:choose>
        <xsl:when test="@value">
          <xsl:value-of select="@value"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@notBefore"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="notAfter">
      <xsl:choose>
        <xsl:when test="@value">
          <xsl:value-of select="@value"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@notAfter"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'date'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(tei:seg[@xml:lang='en']),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Date</xsl:comment>
        <!-- TOC Item Information -->
        <field name="date-en">
          <xsl:value-of select="tei:seg[@xml:lang='en']"/>
        </field>
        <field name="date-ru">
          <xsl:value-of select="tei:seg[@xml:lang='ru']"/>
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
                <xsl:value-of select="@url"/>
              </field>
            </xsl:for-each>

            <xsl:for-each
              select="//alist/list[@xml:lang='ru']/century
                      [number(@max)>=number(substring($notBefore, 1,4))]
                      [number(substring($notAfter, 1,4))>=number(@min)]">

              <field name="date-type-ru">
                <xsl:value-of select="@url"/>
              </field>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>

        <field name="date-notBefore">
          <xsl:value-of select="$notBefore"/>
        </field>

        <field name="date-notAfter">
          <xsl:value-of select="$notAfter"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: WORDS -->

  <xsl:template match="tei:div[@type='edition']//tei:w[@lemma and @lemma != '']" mode="words">

    <xsl:variable name="line" select="preceding::tei:lb[1]/@n"/>
    <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
    <xsl:variable name="document" select="ancestor::aggregation/tei:TEI"/>
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>

    <xsl:variable name="common-data">

      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
        <field name="divloc">
          <xsl:value-of select="@n"/>
        </field>
      </xsl:for-each>

      <field name="line">
        <xsl:value-of select="$line"/>
      </field>

      <!-- Indexed Item Information -->
      <field name="lang">
        <xsl:value-of select="$lang"/>
      </field>
      <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
        <field name="cert">low</field>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
        <field name="sup">yes</field>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:variable>

    <xsl:for-each select="tokenize(normalize-space(@lemma), ' ')">

      <xsl:if test="not($idno = '')">
        <doc>
          <xsl:apply-templates mode="common-data" select="$document">
            <xsl:with-param name="dt" select="'words'"/>
            <xsl:with-param name="suffix"
              select="concat(normalize-space($line),
                           '_',
                           normalize-space($lang),
                           '_',
                           normalize-space(.),
                           '_',
                           position())"
            />
          </xsl:apply-templates>

          <xsl:comment>Words</xsl:comment>
          <xsl:sequence select="$common-data"/>
          <xsl:if test="$lang = 'grc'">
            <field name="first-letter-grc">
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              translate(normalize-space(.), $lowercase, $uppercase),
                              $grkb4, $grkafter),
                            '?.-', '—'),
                          1,1)"
              />
            </field>
          </xsl:if>
          <field name="first-letter">
            <xsl:choose>
              <xsl:when test="$lang = 'grc'">
                <xsl:value-of
                  select="substring(
                            translate(
                              translate(
                                translate(
                                  translate(normalize-space(.), $lowercase, $uppercase),
                                  $grkb4, $grkafter),
                                $unicode, $betacode),
                              '?.-', '—'),
                            1,1)"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="substring(
                            translate(
                              translate(
                                normalize-space(.),
                                $lowercase, $uppercase),
                              '?.-', '—'),
                            1,1)"
                />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="words">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
          <field name="words-sort">
            <xsl:choose>
              <xsl:when test="$lang = 'grc'">
                <xsl:value-of
                  select="translate(
                          translate(
                            translate(normalize-space(.), $uppercase, $lowercase),
                            $grkb4, $grkafter),
                          ' ', '')"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="translate(
                          translate(normalize-space(.), $uppercase, $lowercase),
                          ' ', '')"
                />
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </doc>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Unit: DEATH -->

  <xsl:template match="tei:div[@type='edition']//tei:date[@dur]" mode="death">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'death'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@dur),
                           '_',
                           position())"
          />
        </xsl:apply-templates>
        <xsl:comment>Death</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
          <field name="cert">low</field>
        </xsl:if>

        <!-- Indexed Item Value(s) -->
        <field name="death">
          <xsl:value-of select="normalize-space(@dur)"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: ABBR -->

  <xsl:template match="tei:div[@type='edition']//tei:expan/tei:abbr[1]" mode="abbr">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'abbr'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(ancestor::tei:expan),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Abbr</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>
        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <!-- Indexed Item Value(s) -->
        <field name="abbr">
          <xsl:variable name="aggr">
            <xsl:for-each
              select="parent::tei:expan/descendant::tei:abbr/descendant::node()[self::text() or self::tei:g][not(ancestor::tei:sic or ancestor::tei:orig or ancestor::tei:del[parent::tei:subst])]">
              <xsl:sequence select="normalize-space(.)"/>
            </xsl:for-each>
          </xsl:variable>

          <xsl:for-each select="$aggr//node()">
            <xsl:choose>
              <xsl:when test="self::tei:g"> (<xsl:value-of select="@type"/>) </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </field>
        <xsl:if test="descendant::tei:g">
          <field name="abbr-g">
            <xsl:for-each select="descendant::tei:g">
              <xsl:value-of select="@type"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </field>
        </xsl:if>


        <field name="expan">
          <xsl:for-each
            select="parent::tei:expan/descendant::node()[self::text() or self::tei:g][not(ancestor::tei:sic or ancestor::tei:orig or ancestor::tei:am or ancestor::tei:del[parent::tei:subst])]">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:for-each>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: FRAGMENT -->

  <xsl:template
    match="tei:div[@type='edition']//tei:w[@part=('I','M','F')][not(@lemma)][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
    | tei:div[@type='edition']//tei:name[not(@nymRef)][descendant::tei:seg[@part=('I','M','F')]][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
    | tei:div[@type='edition']//tei:orig[not(ancestor::tei:choice)]
    | tei:div[@type='edition']//tei:abbr[not(ancestor::tei:expan)]"
    mode="fragment">

    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'fragments'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           position())"
          />
        </xsl:apply-templates>
        <xsl:comment>Fragment</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>
        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <xsl:if test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
          <field name="first-letter-grc">
            <xsl:value-of
              select="substring(
                        translate(
                          translate(
                            translate(normalize-space(.), $lowercase, $uppercase),
                            $grkb4, $grkafter),
                          '?.-', '—'),
                        1,1)"
            />
          </field>
        </xsl:if>
        <field name="first-letter">
          <xsl:choose>
            <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              translate(
                                translate(normalize-space(.), $lowercase, $uppercase),
                                $grkb4, $grkafter),
                              $unicode, $betacode),
                            '?.-', '—'),
                          1,1)"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              normalize-space(.),
                              $lowercase, $uppercase),
                            '?.-', '—'),
                          1,1)"
              />
            </xsl:otherwise>
          </xsl:choose>

        </field>
        <!-- Indexed Item Value(s) -->
        <field name="fragments">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
        <field name="fragments-sort">
          <xsl:choose>
            <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
              <xsl:value-of
                select="translate(
                          translate(
                            translate(normalize-space(.), $uppercase, $lowercase),
                            $grkb4, $grkafter),
                          ' ', '')"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="translate(
                          translate(normalize-space(.), $uppercase, $lowercase),
                          ' ', '')"
              />
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: LIGATURE -->

  <xsl:template match="tei:div[@type='edition']//tei:hi[@rend='ligature']" mode="ligature">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'ligature'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@xml:id),
                           '_',
                           position())"
          />
        </xsl:apply-templates>
        <xsl:comment>Ligature</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>
        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <!-- Indexed Item Value(s) -->
        <field name="ligatures">
          <xsl:if test="@xml:id">
            <xsl:variable name="cur-id" select="@xml:id"/>
            <xsl:for-each select="ancestor::tei:div[1]//tei:link">
              <xsl:if test="contains(@targets, $cur-id)">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </field>
        <!-- ligatures-sort is copy of ligatures. See schema.xml -->
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: MONTH -->

  <xsl:template match="tei:div[@type='edition']//tei:rs[@type='month'][@ref]" mode="month">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'months'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@ref),
                           '_',
                           position())"
          />
        </xsl:apply-templates>
        <xsl:comment>Month</xsl:comment>

        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <!-- Indexed Item Location -->
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
          <field name="sup">yes</field>
        </xsl:if>

        <!-- Indexed Item Value(s) -->
        <field name="months">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
        <field name="months-ref">
          <xsl:value-of select="normalize-space(@ref)"/>
        </field>
        <field name="months-sort">
          <xsl:value-of select="//alist//month[.=normalize-space(@ref)]/@order"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: NAME -->

  <xsl:template
    match="tei:div[@type='edition']//tei:name[not(preceding-sibling::tei:name = .)]
    | tei:div[@type='edition']//tei:roleName"
    mode="name">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'name'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           if (self::tei:name) then (normalize-space(@nymRef)) else (normalize-space(child::tei:w/@lemma)),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Name</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>

        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>
        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="ancestor::tei:persName[1][descendant::tei:supplied or ancestor::tei:supplied]">
          <field name="sup">yes</field>
        </xsl:if>
        <xsl:if test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
          <field name="first-letter-grc">
            <xsl:value-of
              select="substring(
                        translate(
                          translate(
                            translate(normalize-space(.), $lowercase, $uppercase),
                            $grkb4, $grkafter),
                          '?.-', '—'),
                        1,1)"
            />
          </field>
        </xsl:if>
        <field name="first-letter">
          <xsl:choose>
            <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              translate(
                                translate(normalize-space(.), $lowercase, $uppercase),
                                $grkb4, $grkafter),
                              $unicode, $betacode),
                            '?.-', '—'),
                          1,1)"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              normalize-space(.),
                              $lowercase, $uppercase),
                            '?.-', '—'),
                          1,1)"
              />
            </xsl:otherwise>
          </xsl:choose>

        </field>
        <!-- Indexed Item Value(s) -->
        <field name="names">
          <xsl:value-of select="."/>
        </field>
        <field name="name-type">
          <xsl:value-of select="@type"/>
        </field>
        <xsl:for-each select="ancestor::tei:persName">
          <field name="persName-type">
            <xsl:value-of select="@type"/>
          </field>
          <field name="persName-key">
            <xsl:value-of select="@key"/>
          </field>
          <xsl:if test="@ref">
            <field name="persName-ref">
              <xsl:value-of select="@ref"/>
            </field>
          </xsl:if>
        </xsl:for-each>

        <field name="persName-full">
          <xsl:for-each
            select="ancestor::tei:persName[last()]//tei:name[@nymRef] | ancestor::tei:persName[last()]//tei:roleName/tei:w[@lemma]">
            <xsl:if test="@nymRef">
              <xsl:value-of select="@nymRef"/>
            </xsl:if>
            <xsl:if test="@lemma">
              <xsl:value-of select="@lemma"/>
            </xsl:if>
            <xsl:if test="not(position() = last())">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </field>

        <field name="name-nymRef">
          <xsl:value-of
            select="if (self::tei:name) then (normalize-space(@nymRef)) else (normalize-space(child::tei:w/@lemma))"
          />
        </field>
        <field name="names-sort">
          <xsl:choose>
            <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
              <xsl:value-of
                select="translate(
                          translate(
                            translate(
                              normalize-space(
                                string-join(ancestor::tei:persName[1]//text(), '')),
                              $uppercase, $lowercase),
                            $grkb4, $grkafter),
                          ' ', '')"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="translate(
                          translate(
                            normalize-space(
                              string-join(ancestor::tei:persName[1]//text(), '')),
                            $uppercase, $lowercase),
                          ' ', '')"
              />
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: ATTESTED -->

  <xsl:template
    match="tei:div[@type='edition']//tei:name[@nymRef][ancestor::tei:persName[@type=('attested', 'ruler')]][not(preceding-sibling::tei:name = .)]"
    mode="attested">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <xsl:variable name="line" select="preceding::tei:lb[1]/@n"/>
      <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
      <xsl:variable name="doc" select="ancestor::aggregation/tei:TEI"/>


      <xsl:variable name="common-data">
        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="$line"/>
        </field>

        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="$lang"/>
        </field>
        <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
          <field name="sup">yes</field>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:variable>

      <xsl:variable name="is-surname" select="@type = 'surname'" type="xs:boolean"/>

      <xsl:for-each select="tokenize(normalize-space(@nymRef), ' ')">
        <doc>

          <xsl:apply-templates mode="common-data" select="$doc">
            <xsl:with-param name="dt" select="'attested'"/>
            <xsl:with-param name="suffix"
              select="concat(normalize-space($line),
              '_',
              normalize-space($lang),
              '_',
              normalize-space(.),
              '_',
              position())"
            />
          </xsl:apply-templates>

          <xsl:comment>Attested</xsl:comment>
          <xsl:sequence select="$common-data"/>

          <xsl:if test="$lang = 'grc'">
            <field name="first-letter-grc">
              <xsl:value-of
                select="substring(
                          translate(
                            translate(
                              translate(normalize-space(.), $lowercase, $uppercase),
                              $grkb4, $grkafter),
                            '-.?', '—'),
                          1, 1)"
              />
            </field>
          </xsl:if>
          <field name="first-letter">
            <xsl:choose>
              <xsl:when test="$lang = 'grc'">
                <xsl:value-of
                  select="substring(
                            translate(
                              translate(
                                translate(
                                  translate(normalize-space(.), $lowercase, $uppercase),
                                  $grkb4, $grkafter),
                                $unicode, $betacode),
                              '-.?', '—'),
                            1, 1)"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="substring(
                            translate(
                              translate(
                                normalize-space(.),
                                $lowercase, $uppercase),
                              '?.-', '—'),
                            1,1)"
                />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="attested">
            <xsl:value-of select="."/>
          </field>
          <field name="attested-en">
            <xsl:value-of select="."/>
            <xsl:if test="$is-surname">
              <xsl:text> (surname)</xsl:text>
            </xsl:if>
          </field>
          <field name="attested-ru">
            <xsl:value-of select="."/>
            <xsl:if test="$is-surname">
              <xsl:text> (родовое)</xsl:text>
            </xsl:if>
          </field>

          <field name="attested-sort">
            <xsl:choose>
              <xsl:when test="$lang = 'grc'">
                <xsl:value-of
                  select="translate(
                            translate(
                              translate(normalize-space(.), $uppercase, $lowercase),
                              $grkb4, $grkafter),
                            ' ', '')"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="translate(
                            translate(normalize-space(.), $uppercase, $lowercase),
                            ' ', '')"
                />
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </doc>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Unit: SYMBOL -->

  <xsl:template match="tei:div[@type='edition']//tei:g" mode="symbol">
    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'symbols'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@type),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Symbol</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>

        <!-- Indexed Item Value(s) -->
        <field name="symbols">
          <xsl:value-of select="@type"/>
        </field>

        <!-- symbols-sort is copy of symbols. See schema.xml -->
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: NUMERAL -->

  <xsl:template
    match="tei:div[@type='edition']//tei:num
    [translate(normalize-space(string-join(descendant::text(), '')),' ', '')!='']
    [@value or @atLeast or @atMost]"
    mode="num">

    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="$idno != ''">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'numerals'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@value),
                           '_',
                           position())"
          />
        </xsl:apply-templates>


        <xsl:comment>Numeral</xsl:comment>

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>

        <!-- Indexed Item Value(s) -->
        <field name="numerals">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
        <xsl:if test="@value">
          <field name="num-value">
            <xsl:value-of select="@value"/>
          </field>
        </xsl:if>
        <xsl:if test="@atLeast">
          <field name="num-atleast">
            <xsl:value-of select="@atLeast"/>
          </field>
        </xsl:if>
        <xsl:if test="@atMost">
          <field name="num-atmost">
            <xsl:value-of select="@atMost"/>
          </field>
        </xsl:if>
        <xsl:if test="@value or @atLeast or @atMost">
          <field name="numerals-sort">
            <xsl:choose>
              <xsl:when test="@value">
                <xsl:value-of select="@value"/>
              </xsl:when>
              <xsl:when test="@atLeast">
                <xsl:value-of select="@atLeast"/>
              </xsl:when>
              <xsl:when test="@atMost">
                <xsl:value-of select="@atMost"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@atMost"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:if>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: PLACE -->

  <xsl:template
    match="tei:div[@type='edition']//tei:placeName[@key]
    | tei:div[@type='edition']//tei:geogName[@key]"
    mode="place">

    <xsl:variable name="idno"
      select="ancestor::aggregation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:apply-templates mode="common-data" select="ancestor::aggregation/tei:TEI">
          <xsl:with-param name="dt" select="'places'"/>
          <xsl:with-param name="suffix"
            select="concat(normalize-space(preceding::tei:lb[1]/@n),
                           '_',
                           normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
                           '_',
                           normalize-space(@key),
                           '_',
                           position())"
          />
        </xsl:apply-templates>

        <xsl:comment>Place</xsl:comment>


        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <field name="lang">
          <xsl:value-of select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        </field>
        <xsl:if test="descendant::tei:*/@cert='low' or ancestor-or-self::tei:*/@cert='low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
          <field name="sup">yes</field>
        </xsl:if>

        <!-- Indexed Item Value(s) -->
        <field name="places">
          <xsl:value-of select="normalize-space(.)"/>
        </field>
        <field name="places-key">
          <xsl:value-of select="normalize-space(@key)"/>
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
                select="translate(translate(normalize-space(.), $uppercase, $lowercase), ' ', '')"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
