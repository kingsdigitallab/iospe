<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

      <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

      <!-- DEBUG -->
      <!-- PC, 01 March 2016: 
            test mode checks that all metadata can be grabbed from tei-to-solr-common.xsl.
      The  xsl:apply-templates mode='test' calls the example template at the end of this 
      stylesheet. You can test various calls to tei-to-solr-common.xsl by uncommenting them -->

      <!--<xsl:apply-templates mode="test"/>-->

      <!-- END DEBUG -->

      <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

      <xsl:apply-templates mode="publication"/>
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
      <xsl:apply-templates mode="anthroponymic"/>
      <xsl:apply-templates mode="symbol"/>
      <xsl:apply-templates mode="num"/>
      <xsl:apply-templates mode="place"/>
      <xsl:apply-templates mode="att_persons"/>
    </add>
  </xsl:template>

  <xsl:template match="text()" mode="#all" priority="-1"/>






  <!-- Unit: PUBLICATION (Concordances) -->
  <xsl:template match="tei:bibl[tei:citedRange][descendant::tei:ptr]" mode="publication">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Publication</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'publication'"/>
        </field>
        <xsl:variable name="target" select="substring-after(descendant::tei:ptr[1]/@target, 'bib:')"/>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'publication'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space($target),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <field name="publications">
          <xsl:value-of select="tei:citedRange"/>
        </field>
        <!-- SORTING IN POST-QUERY XSLT to account for mix of numeric and string values -->

        <field name="bibl-target">
          <xsl:value-of select="$target"/>
        </field>

        <field name="bibl-list">
          <xsl:value-of
            select="//tei:listBibl[(descendant::tei:biblStruct | descendant::tei:bibl)[@xml:id = $target]]/@type"
          />
        </field>
        <!-- From AL bibliography.xml -->
        <xsl:for-each select="//(tei:biblStruct | tei:bibl)[@xml:id = $target]">

          <field name="bibl-short-en">
            <xsl:choose>
              <xsl:when test="descendant::tei:author">
                <xsl:value-of
                  select="descendant::tei:author[1]//tei:surname[@xml:lang = 'en' or not(@xml:lang)]"/>
                <xsl:if test="descendant::tei:author[2]">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of
                    select="descendant::tei:author[2]//tei:surname[@xml:lang = 'en' or not(@xml:lang)]"
                  />
                </xsl:if>
                <xsl:if test="count(descendant::tei:author[1]) > 2">
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
                  select="descendant::tei:author[1]//tei:surname[@xml:lang = 'ru' or not(@xml:lang)]"/>
                <xsl:if test="descendant::tei:author[2]">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of
                    select="descendant::tei:author[2]//tei:surname[@xml:lang = 'ru' or not(@xml:lang)]"
                  />
                </xsl:if>
                <xsl:if test="count(descendant::tei:author[1]) > 2">
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
                test="following::tei:title[(ancestor::tei:biblStruct | ancestor::tei:bibl)[@xml:id = $target]]">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </field>
        </xsl:for-each>
        <!-- the two fields below are used to determine the ordering of items in the concordance display -->
        <xsl:for-each select="//tei:listBibl[@type = 'corpora']/tei:bibl[@xml:id = $target]">
          <field name="bibl-abbrev-en">
            <xsl:value-of select="tei:title[@type = 'abbreviated' and not(@xml:lang = 'ru')]"/>
          </field>
          <field name="bibl-abbrev-ru">
            <xsl:choose>
              <!-- if we do have a Russian version, grab that -->
              <xsl:when test="tei:title[@type = 'abbreviated' and @xml:lang = 'ru']">
                <xsl:value-of select="tei:title[@type = 'abbreviated' and @xml:lang = 'ru']"/>
              </xsl:when>
              <!-- otherwise just grab an English value -->
              <xsl:otherwise>
                <xsl:value-of select="tei:title[@type = 'abbreviated'][1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:for-each>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: ORIGIN (Tables of Content) -->
  <!-- PC, 29 Jan 2016: there used to be template that created a separate <doc> with dt:origin, which fed
       the "locations.html" and "locations-ru.html" pages, but that origin data is now added to the main
       dt:inscription <doc> by tei-to-solr-common.xsl. However, the 2 templates below are still used. -->
  <xsl:template match="tei:origin/tei:origPlace//tei:certainty[@cert = 'low']" mode="origin">
    <xsl:text>(?)</xsl:text>
  </xsl:template>

  <xsl:template match="tei:origin/tei:origPlace//tei:seg/text()" mode="origin">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Unit: FINDSPOT (index) -->
  <xsl:template match="tei:provenance[@type = 'found'][descendant::tei:placeName[@ref]]"
    mode="findspot">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>

    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Findspot</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'findspot'"/>
        </field>

        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'findspot'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(tei:seg[@xml:lang = 'en']/tei:placeName[1]),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <xsl:if test="descendant::tei:*[@cert = 'low'] or ancestor-or-self::tei:*[@cert = 'low']">
          <field name="cert">low</field>
        </xsl:if>

        <field name="findspot-ref">
          <xsl:value-of select="normalize-space(tei:seg/tei:placeName[@ref]/@ref)"/>
        </field>

        <!-- Indexed Item Value(s) -->
        <field name="findspot-en">
          <xsl:value-of select="normalize-space(tei:seg[@xml:lang = 'en']/tei:placeName[1])"/>
        </field>
        <field name="findspot-ru">
          <xsl:value-of select="normalize-space(tei:seg[@xml:lang = 'ru']/tei:placeName[1])"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: INSCRIPTION (Tables of Content) -->
  <xsl:template match="tei:TEI[descendant::tei:div[@type = 'edition']]" mode="inscription">

    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Inscription</xsl:comment>

        <field name="dt">
          <xsl:value-of select="'inscription'"/>
        </field>

        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'inscription'"/>
        </xsl:apply-templates>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="title_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="document-type_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="institution_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="monument-type_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="material_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="execution_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="orig_place_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="orig_date_fields"/>
        <!-- end of the metadata templates -->

        <!-- get the text content and critical apparatus of the inscription -->
        <xsl:apply-templates select="descendant::tei:div[@type = 'edition']" mode="edition_fields"/>
        <xsl:apply-templates select="descendant::tei:div[@type = 'apparatus']"
          mode="apparatus_fields"/>

        <!-- get persNames from the inscription -->
        <xsl:apply-templates select="descendant::tei:div[@type = 'edition']" mode="persnames_fields"/>


        <!-- PC, 15 Sep 2016: we throw in here bits of text content that need to be searchable and are not getting put into other <field>s 
             This was created to resolve JIRA issue IOSPE-270 -->
        <field name="textbucket">
          <xsl:for-each select="descendant::tei:div[@type = 'bibliography']">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:div[@type = 'translation']">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:div[@type = 'commentary']">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:support/tei:p">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:support/tei:dimensions">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:layout/tei:seg">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:handNote/tei:seg">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="descendant::tei:provenance">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </field>

      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: DATE (Table of Contents) -->
  <xsl:template match="tei:origDate[@value or (@notBefore and @notAfter)]" mode="date">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Date</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'date'"/>
        </field>

        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'date'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(tei:seg[@xml:lang = 'en']),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="title_fields"/>
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="orig_place_fields"/>


        <!-- end of the metadata templates -->

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
        <!-- TOC Item Information -->
        <field name="date-en">
          <xsl:value-of select="tei:seg[@xml:lang = 'en']"/>
        </field>
        <field name="date-ru">
          <xsl:value-of select="tei:seg[@xml:lang = 'ru']"/>
        </field>
        <xsl:if test="descendant::tei:origDate[@cert = 'low']">
          <field name="cert">low</field>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="not(@precision) and not(following-sibling::precision)">
            <field name="date-type">dated</field>
            <field name="date-type-ru">RU: dated</field>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="adjusted_notBefore">
              <xsl:choose>
                <xsl:when test="contains($notBefore, '-')">
                  <!-- is a BCE value -->
                  <xsl:value-of select="number(substring($notBefore, 1, 5))"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- is a CE value -->
                  <xsl:value-of select="number(substring($notBefore, 1, 4))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="adjusted_notAfter">
              <xsl:choose>
                <xsl:when test="contains($notAfter, '-')">
                  <!-- is a BCE value -->
                  <xsl:value-of select="number(substring($notAfter, 1, 5))"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- is a CE value -->
                  <xsl:value-of select="number(substring($notAfter, 1, 4))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>


            <xsl:for-each
              select="
                //alist/list[@xml:lang = 'en']/century
                [number(@max) >= $adjusted_notBefore]
                [number(substring($adjusted_notAfter, 1, 4)) >= number(@min)]">
              <field name="date-type">
                <xsl:value-of select="@url"/>
              </field>
            </xsl:for-each>

            <xsl:for-each
              select="
                //alist/list[@xml:lang = 'ru']/century
                [number(@max) >= $adjusted_notBefore]
                [number(substring($adjusted_notAfter, 1, 4)) >= number(@min)]">

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
  <xsl:template match="tei:div[@type = 'edition']//tei:w[@lemma and @lemma != '']" mode="words">

    <xsl:variable name="line" select="preceding::tei:lb[1]/@n"/>
    <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
    <xsl:variable name="document" select="ancestor::aggregation/document/tei:TEI"/>
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>

    <xsl:variable name="utility-data">

      <field name="dt">
        <xsl:value-of select="'words'"/>
      </field>

      <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->

      <xsl:apply-templates
        select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
        mode="identifier_fields">
        <xsl:with-param name="idno" select="$idno"/>
        <xsl:with-param name="dt" select="'words'"/>
        <xsl:with-param name="suffix"
          select="
            concat(normalize-space($line),
            '_',
            normalize-space($lang),
            '_',
            normalize-space(.),
            '_',
            position())"
        />
      </xsl:apply-templates>

      <!-- end of the metadata templates -->

      <!-- Indexed Item Location -->
      <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
      <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
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
          <xsl:comment>Words</xsl:comment>
          <xsl:sequence select="$utility-data"/>
          <xsl:if test="$lang = 'grc'">
            <field name="first-letter-grc">
              <xsl:value-of
                select="
                  substring(
                  translate(
                  translate(
                  translate(normalize-space(.), $lowercase, $uppercase),
                  $grkb4, $grkafter),
                  '?.-', '—'),
                  1, 1)"
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
                    translate(normalize-space(.), $lowercase, $uppercase),
                    $grkb4, $grkafter),
                    $unicode, $betacode),
                    '?.-', '—'),
                    1, 1)"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="
                    substring(
                    translate(
                    translate(
                    normalize-space(.),
                    $lowercase, $uppercase),
                    '?.-', '—'),
                    1, 1)"
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
                  select="
                    translate(
                    translate(
                    translate(normalize-space(.), $uppercase, $lowercase),
                    $grkb4, $grkafter),
                    ' ', '')"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="
                    translate(
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
  <xsl:template match="tei:div[@type = 'edition']//tei:date[@dur]" mode="death">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Death</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'death'"/>
        </field>

        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'death'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@dur),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
          <field name="divloc">
            <xsl:value-of select="@n"/>
          </field>
        </xsl:for-each>
        <field name="line">
          <xsl:value-of select="preceding::tei:lb[1]/@n"/>
        </field>

        <!-- Indexed Item Information -->
        <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
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
  <xsl:template match="tei:div[@type = 'edition']//tei:expan/tei:abbr[1]" mode="abbr">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>

        <xsl:comment>Abbr</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'abbr'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'abbr'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(ancestor::tei:expan),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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

  <!-- Unit: FRAGMENTS -->
  <xsl:template
    match="
      tei:div[@type = 'edition']//tei:w[@part = ('I',
      'M',
      'F')][not(@lemma)][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
      | tei:div[@type = 'edition']//tei:name[not(@nymRef)][descendant::tei:seg[@part = ('I',
      'M',
      'F')]][not(descendant::tei:expan)][.//text()[not(ancestor::tei:supplied)]]
      | tei:div[@type = 'edition']//tei:orig[not(ancestor::tei:choice)]
      | tei:div[@type = 'edition']//tei:abbr[not(ancestor::tei:expan)]"
    mode="fragment">

    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Fragment</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'fragments'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'fragments'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
              select="
                substring(
                translate(
                translate(
                translate(normalize-space(.), $lowercase, $uppercase),
                $grkb4, $grkafter),
                '?.-', '—'),
                1, 1)"
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
                  translate(normalize-space(.), $lowercase, $uppercase),
                  $grkb4, $grkafter),
                  $unicode, $betacode),
                  '?.-', '—'),
                  1, 1)"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="
                  substring(
                  translate(
                  translate(
                  normalize-space(.),
                  $lowercase, $uppercase),
                  '?.-', '—'),
                  1, 1)"
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
                select="
                  translate(
                  translate(
                  translate(normalize-space(.), $uppercase, $lowercase),
                  $grkb4, $grkafter),
                  ' ', '')"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="
                  translate(
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
  <xsl:template match="tei:div[@type = 'edition']//tei:hi[@rend = 'ligature']" mode="ligature">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Ligature</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'ligature'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'ligature'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@xml:id),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
  <xsl:template match="tei:div[@type = 'edition']//tei:rs[@type = 'month'][@ref]" mode="month">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Month</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'months'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'months'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@ref),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
        <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
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
          <xsl:value-of select="//alist//month[. = normalize-space(@ref)]/@order"/>
        </field>
      </doc>
    </xsl:if>
  </xsl:template>


  <!-- Unit: NAME -->
  <xsl:template
    match="
      tei:div[@type = 'edition']//tei:name[not(preceding-sibling::tei:name = .)]
      | tei:div[@type = 'edition']//tei:roleName"
    mode="name">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Name</xsl:comment>
        <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
        <field name="dt">
          <xsl:value-of select="'names'"/>
        </field>

        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'names'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              if (self::tei:name) then
                (normalize-space(@nymRef))
              else
                (normalize-space(child::tei:w/@lemma)),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
        <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="ancestor::tei:persName[1][descendant::tei:supplied or ancestor::tei:supplied]">
          <field name="sup">yes</field>
        </xsl:if>

        <xsl:if test="$lang = 'grc'">
          <field name="first-letter-grc">
            <xsl:value-of
              select="
                substring(
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
                select="
                  substring(
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
                select="
                  substring(
                  translate(
                  translate(
                  normalize-space(.),
                  $lowercase, $uppercase),
                  '?.-', '—'),
                  1, 1)"
              />
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <xsl:if
          test="(@nymRef) and (ancestor::tei:persName[@type = 'attested']) and (starts-with(normalize-space(@nymRef), '—'))">
          <field name="first-letter-emdash">
            <xsl:value-of select="'yes'"/>
          </field>
        </xsl:if>
        <!-- Indexed Item Value(s) -->
        <field name="names">
          <xsl:value-of select="."/>
        </field>
        <field name="name-type">
          <xsl:value-of select="@type"/>
        </field>
        <xsl:for-each select="ancestor::tei:persName[1]">
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
            select="
              if (self::tei:name) then
                (normalize-space(@nymRef))
              else
                (normalize-space(child::tei:w/@lemma))"
          />
        </field>
        <field name="names-sort">
          <xsl:choose>
            <xsl:when test="ancestor::tei:*[@xml:lang][1]/@xml:lang = 'grc'">
              <xsl:value-of
                select="
                  translate(
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
                select="
                  translate(
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


  <!-- Unit: ANTHROPONYMIC -->
  <!-- creates fields used to build the index page 'Personal names'. For explanation of what
       this index contains and how it differs from 'Attested Persons' see Confluence documentation-->
  <xsl:template
    match="
      tei:div[@type = 'edition']//tei:name[@nymRef][ancestor::tei:persName[@type = ('attested',
      'ruler')]][not(preceding-sibling::tei:name = .)]"
    mode="anthroponymic">

    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <xsl:variable name="line" select="preceding::tei:lb[1]/@n"/>
      <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
      <xsl:variable name="doc" select="ancestor::aggregation/document/tei:TEI"/>


      <xsl:variable name="common-data">
        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
        <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
          <field name="cert">low</field>
        </xsl:if>
        <xsl:if test="descendant::tei:supplied or ancestor::tei:supplied">
          <field name="sup">yes</field>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:variable>

      <xsl:variable name="is-surname" select="@type = 'surname'" as="xs:boolean"/>

      <xsl:for-each select="tokenize(normalize-space(@nymRef), ' ')">
        <doc>
          <xsl:comment>Anthroponymic</xsl:comment>
          <field name="dt">
            <xsl:value-of select="'anthroponymic'"/>
          </field>

          <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
          <xsl:apply-templates select="$doc" mode="identifier_fields">
            <xsl:with-param name="idno" select="$idno"/>
            <xsl:with-param name="dt" select="'anthroponymic'"/>
            <xsl:with-param name="suffix"
              select="
                concat(normalize-space($line),
                '_',
                normalize-space($lang),
                '_',
                normalize-space(.),
                '_',
                position())"
            />
          </xsl:apply-templates>
          <!-- @@@@@@@@@@@@  I THINK WE WILL NEED MORE METADTA FIELDS HERE, EG. TITLE INFO; CHECK WHAT PREVIOUS TEMPLATE WAS GETTING @@@@@@@@@@@@@@@@ -->
          <!-- end of the metadata templates -->

          <xsl:sequence select="$common-data"/>

          <xsl:if test="$lang = 'grc'">
            <field name="first-letter-grc">
              <xsl:value-of
                select="
                  substring(
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
                  select="
                    substring(
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
                  select="
                    substring(
                    translate(
                    translate(
                    normalize-space(.),
                    $lowercase, $uppercase),
                    '?.-', '—'),
                    1, 1)"
                />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="anthroponymic">
            <xsl:value-of select="."/>
          </field>
          <field name="anthroponymic-en">
            <xsl:value-of select="."/>
            <xsl:if test="$is-surname">
              <xsl:text> (surname)</xsl:text>
            </xsl:if>
          </field>
          <field name="anthroponymic-ru">
            <xsl:value-of select="."/>
            <xsl:if test="$is-surname">
              <xsl:text> (родовое)</xsl:text>
            </xsl:if>
          </field>

          <field name="anthroponymic-sort">
            <xsl:choose>
              <xsl:when test="$lang = 'grc'">
                <xsl:value-of
                  select="
                    translate(
                    translate(
                    translate(normalize-space(.), $uppercase, $lowercase),
                    $grkb4, $grkafter),
                    ' ', '')"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="
                    translate(
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
  <xsl:template match="tei:div[@type = 'edition']//tei:g" mode="symbol">
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Symbol</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'symbols'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'symbols'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@type),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
          <xsl:value-of select="@ref"/>
        </field>

        <!-- symbols-sort is copy of symbols. See schema.xml -->
      </doc>
    </xsl:if>
  </xsl:template>

  <!-- Unit: NUMERAL -->
  <xsl:template
    match="
      tei:div[@type = 'edition']//tei:num
      [translate(normalize-space(string-join(descendant::text(), '')), ' ', '') != '']
      [@value or @atLeast or @atMost]"
    mode="num">

    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="$idno != ''">
      <doc>
        <xsl:comment>Numeral</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'numerals'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'numerals'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@value),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->

        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
    match="
      tei:div[@type = 'edition']//tei:placeName[@key]
      | tei:div[@type = 'edition']//tei:geogName[@key]"
    mode="place">

    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <xsl:comment>Place</xsl:comment>
        <field name="dt">
          <xsl:value-of select="'places'"/>
        </field>
        <!-- get metadata by using templates that are in tei-to-solr-common.xsl -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="'places'"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space(preceding::tei:lb[1]/@n),
              '_',
              normalize-space(ancestor::tei:*[@xml:lang][1]/@xml:lang),
              '_',
              normalize-space(@key),
              '_',
              position())"
          />
        </xsl:apply-templates>
        <!-- end of the metadata templates -->


        <!-- Indexed Item Location -->
        <xsl:for-each select="ancestor::tei:div[@type = 'textpart'][@n]">
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
        <xsl:if test="descendant::tei:*/@cert = 'low' or ancestor-or-self::tei:*/@cert = 'low'">
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
                select="
                  translate(
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

  <!-- Unit: ATT_PERSONS -->
  <xsl:template mode="att_persons"
    match="/aggregation/attpersons/tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson/tei:person">
    <xsl:comment>Nb. data comes from the Attested Person list, *not* from the inscriptions files</xsl:comment>
    <xsl:for-each select=".">
      <doc>
        <field name="dt">
          <xsl:value-of select="'attPerson'"/>
        </field>
        <field name="id">
          <xsl:value-of select="@xml:id"/>
        </field>

        <field name="names-sort">
          <xsl:value-of
            select="
              translate(
              translate(
              translate(
              translate(
              normalize-space(
              string-join(tei:persName[@xml:lang = 'grc']//text(), '')),
              $uppercase, $lowercase),
              $grkb4, $grkafter),
              ' ', ''), ']-.?—[', '')"/>

          <!-- THE PREVIOUS CODE -->
          <!--
              <xsl:value-of
                select="
                translate(
                translate(
                translate(
                normalize-space(
                string-join(tei:persName[@xml:lang = 'grc']//text(), '')),
                $uppercase, $lowercase),
                $grkb4, $grkafter),
                ' ', '')"
              />-->


        </field>

        <field name="first-letter-grc">
          <xsl:choose>
            <!-- each 'when' handles a special case -->
            <xsl:when test="starts-with(normalize-space(tei:persName[@xml:lang = 'grc']), '’Υ')">
              <xsl:value-of select="'υ'"/>
            </xsl:when>
            <!-- 'otherwise' handles the normal cases -->
            <xsl:otherwise>
              <xsl:value-of
                select="
                  substring(
                  translate(
                  translate(
                  translate(normalize-space(tei:persName[@xml:lang = 'grc']), $lowercase, $uppercase),
                  $grkb4, $grkafter),
                  '-.?', '—'),
                  1, 1)"
              />
            </xsl:otherwise>
          </xsl:choose>
        </field>

        <field name="first-letter">
          <xsl:choose>
            <xsl:when test="tei:persName[1]/@xml:lang = 'grc'">
              <xsl:choose>
                <!-- each 'when' handles a special case -->
                <xsl:when test="starts-with(normalize-space(tei:persName[@xml:lang = 'grc']), '’Υ')">
                  <xsl:value-of select="'U'"/>
                </xsl:when>
                <!-- 'otherwise' handles the normal cases -->
                <xsl:otherwise>
                  <xsl:value-of
                    select="
                      substring(
                      translate(
                      translate(
                      translate(
                      translate(normalize-space(tei:persName[1]), $lowercase, $uppercase),
                      $grkb4, $grkafter),
                      $unicode, $betacode),
                      '-.?', '—'),
                      1, 1)"
                  />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="
                  substring(
                  translate(
                  translate(
                  normalize-space(tei:persName[1]),
                  $lowercase, $uppercase),
                  '?.-', '—'),
                  1, 1)"
              />
            </xsl:otherwise>
          </xsl:choose>
        </field>
        <field name="date-era">
          <xsl:variable name="era_string">
            <xsl:choose>
              <xsl:when test="starts-with(tei:floruit/@notBefore, '-')">BCE</xsl:when>
              <xsl:otherwise>CE</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="cent_string">

            <xsl:variable name="num_part">
              <xsl:choose>
                <xsl:when test="starts-with(tei:floruit/@notBefore, '-')">
                  <xsl:value-of select="number(substring(tei:floruit/@notBefore, 2, 4))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="number(substring(tei:floruit/@notBefore, 1, 4))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:if test="($num_part &gt;= 0001) and ($num_part &lt;= 0100)">I</xsl:if>
            <xsl:if test="($num_part &gt;= 0101) and ($num_part &lt;= 0200)">II</xsl:if>
            <xsl:if test="($num_part &gt;= 0201) and ($num_part &lt;= 0300)">III</xsl:if>
            <xsl:if test="($num_part &gt;= 0301) and ($num_part &lt;= 0400)">IV</xsl:if>
            <xsl:if test="($num_part &gt;= 0401) and ($num_part &lt;= 0500)">V</xsl:if>
            <xsl:if test="($num_part &gt;= 0501) and ($num_part &lt;= 0600)">VI</xsl:if>
            <xsl:if test="($num_part &gt;= 0601) and ($num_part &lt;= 0700)">VII</xsl:if>
            <xsl:if test="($num_part &gt;= 0701) and ($num_part &lt;= 0800)">VIII</xsl:if>
            <xsl:if test="($num_part &gt;= 0801) and ($num_part &lt;= 0900)">IX</xsl:if>
            <xsl:if test="($num_part &gt;= 0901) and ($num_part &lt;= 1000)">X</xsl:if>
            <xsl:if test="($num_part &gt;= 1001) and ($num_part &lt;= 1100)">XI</xsl:if>
            <xsl:if test="($num_part &gt;= 1101) and ($num_part &lt;= 1200)">XII</xsl:if>
            <xsl:if test="($num_part &gt;= 1201) and ($num_part &lt;= 1300)">XIII</xsl:if>
            <xsl:if test="($num_part &gt;= 1301) and ($num_part &lt;= 1400)">XIV</xsl:if>
            <xsl:if test="($num_part &gt;= 1401) and ($num_part &lt;= 1500)">XV</xsl:if>
            <xsl:if test="($num_part &gt;= 1501) and ($num_part &lt;= 1600)">XVI</xsl:if>
            <xsl:if test="($num_part &gt;= 1601) and ($num_part &lt;= 1700)">XVII</xsl:if>
          </xsl:variable>
          <xsl:value-of select="concat($cent_string, '_', $era_string)"/>
        </field>
      </doc>
    </xsl:for-each>

  </xsl:template>








  <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

  <!-- DEBUG -->
  <!-- this is just a sample template for testing purposes. It only gets called if you uncomment
   the xsl:apply-templates mode="test" at top of this stylesheet -->
  <xsl:template match="tei:div[@type = 'edition']//tei:w[@lemma and @lemma != '']" mode="test">
    <xsl:variable name="line" select="preceding::tei:lb[1]/@n"/>
    <xsl:variable name="lang" select="ancestor::tei:*[@xml:lang][1]/@xml:lang"/>
    <xsl:variable name="document" select="ancestor::aggregation/document/tei:TEI"/>
    <xsl:variable name="idno"
      select="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
    <xsl:if test="not($idno = '')">
      <doc>
        <field name="dt">
          <xsl:value-of select="'words'"/>
        </field>

        <!-- mode="id_fields" brings in:
          id
          tei-id
          sortable-id
          volume
          NB IT USED TO GET file AND inscription TOO BUT WE SHOULD LOOK TO GET RID OF THOSE
          TWO FIELDS BECAUSE THEY SIMPLY DUPLICATE tei-id
          -->
        <xsl:apply-templates
          select="ancestor::aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
          mode="identifier_fields">
          <xsl:with-param name="idno" select="$idno"/>
          <xsl:with-param name="dt" select="words"/>
          <xsl:with-param name="suffix"
            select="
              concat(normalize-space($line),
              '_',
              normalize-space($lang),
              '_',
              normalize-space(.),
              '_',
              position())"
          />
        </xsl:apply-templates>

        <!-- mode="title_fields" brings in:
        document-title
        document-title-en
        document-title-ru
        inscription-title
        inscription-title-en
        inscription-title-ru-->
        <!-- NOTE THAT THE ONLY DIFFERENCE BETWEEN DOCUMENT-TITLE AND DOCUMENT-TITLE-EN (ALSO INSCRIPTION-TITLE 
          AND INSCRIPTION-TITLE-EN) IS THAT THE LATTER TEMPLATE HAS CODE TO ADD A QUESTION MARK IF
          tei:certainty[@cert='low'] IS PRESENT-->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="title_fields"/>-->


        <!--<xsl:call-template name="make_inscription-has-date"/>-->


        <!-- mode="institution_fields" brings in:
        institution
        institution-en
        institution-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="institution_fields"/>-->


        <!-- mode="monument-type_fields" brings in:
        monument-type
        monument-type-en
        monument-type-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="monument-type_fields"/>-->


        <!-- mode="material_fields" brings in:
        material
        material-en
        material-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="material_fields"/>-->



        <!-- mode="document-type_fields" brings in:
        document-type
        document-type-en
        document-type-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="document-type_fields"/>-->


        <!-- mode="orig_place_fields" brings in:
        cert-origin
        origin-en
        origin-ru
        origin-ref
        location
        location-en
        location-ru-->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="orig_place_fields"/>-->


        <!-- mode="orig_date_fields" brings in:
        orig-date
        orig-date-en
        orig-date-ru
        not-before
        not-after
        evidence
        evidence-en
        evidence YES, AGAIN 
        evidence-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="orig_date_fields"/>-->


        <!-- mode="execution_fields" brings in:
        execution
        execution-en
        execution-ru-->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:teiHeader" mode="execution_fields"/>-->


        <!-- mode="apparatus_fields" brings in:
        apparatus -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:text/tei:body" mode="apparatus_fields"/>-->


        <!-- mode="edition_fields" brings in:
        edition
        diplomatic
        lemma
        AND PROBABLY A NUMBER OF OTHERS -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:text/tei:body" mode="edition_fields"/>-->


        <!-- mode="persnames_fields" brings in:
          persnames
          persnames-en
          persnames-ru -->
        <!--<xsl:apply-templates select="ancestor::aggregation/document/tei:TEI/tei:text/tei:body" mode="persnames_fields"/>-->

      </doc>
    </xsl:if>
  </xsl:template>

  <!-- END DEBUG -->

  <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->


</xsl:stylesheet>
