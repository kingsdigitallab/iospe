<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:import href="../common/conversions.xsl"/>

  <xsl:template match="/"/>

  <xsl:template name="bibliographyTitle">
    <i18n:text>Bibliography</i18n:text>
  </xsl:template>

  <xsl:function name="iospe:sort-bibliography">
    <xsl:param name="node"/>
    <xsl:variable name="author"
      select="normalize-space($node/(*[tei:author | tei:editor][1]/(tei:author | tei:editor)[1]/(tei:surname | tei:forename[not(following-sibling::tei:surname)])[@xml:lang=$lang or not(@xml:lang)][1]/(@n | text())[1]))"/>
    <xsl:variable name="title"
      select="normalize-space($node/(*[tei:title][1]/tei:title[@xml:lang=$lang or not(@xml:lang)][1]/(@n | text())[1]))"/>
    <xsl:variable name="sort-string" select="if($author != '') then $author else $title"/>

    <xsl:choose>
      <xsl:when
        test="$lang = 'ru' and string-to-codepoints($sort-string)[1] &gt;= 1024 and string-to-codepoints($sort-string)[1] &lt;= 1279">
        <xsl:value-of select="concat('00000', $sort-string)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sort-string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <xsl:template name="generateBibliography">
    <xsl:for-each select="/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct">
      <xsl:sort select="iospe:sort-bibliography(.)"/>
      <xsl:sort
        select="normalize-space(./*[tei:imprint[tei:date]][1]/tei:imprint[tei:date][1]/tei:date[1])"/>

      <p class="reference">
        <xsl:apply-templates select="."/>
      </p>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="tei:biblStruct">
    <span>
      <xsl:attribute name="id" select="@xml:id"/>
    </span>
    <xsl:variable name="analytic" select="./tei:analytic"/>
    <xsl:variable name="monogr" select="./tei:monogr"/>
    <xsl:variable name="series" select="./tei:series"/>

    <!-- Authors -->
    <xsl:variable name="main-author-list">
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
    </xsl:variable>

    <!-- Title -->
    <xsl:variable name="main-title">
      <xsl:choose>
        <xsl:when test="$analytic">
          <xsl:text>"</xsl:text>
          <xsl:apply-templates select="$analytic" mode="title"/>
          <xsl:text>." </xsl:text>
        </xsl:when>
        <xsl:when test="not($analytic) and  $monogr">
          <em>
            <xsl:apply-templates select="$monogr" mode="title"/>
          </em>
          <xsl:text>. </xsl:text>
        </xsl:when>
        <xsl:when test="not($analytic | $monogr) and $series">
          <em>
            <xsl:apply-templates select="$series" mode="title"/>
          </em>
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Date -->

    <xsl:variable name="year">
      <xsl:choose>
        <xsl:when test=".//tei:imprint/tei:date[1]">
          <xsl:value-of select=".//tei:imprint/tei:date[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <i18n:text key="__date_nd">n.d.</i18n:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Reference Heading -->
    <xsl:choose>
      <xsl:when test="normalize-space($main-author-list) = ''">
        <xsl:value-of select="$main-title"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$year"/>
        <xsl:text>) </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$main-author-list"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$year"/>
        <xsl:text>) </xsl:text>
        <xsl:value-of select="$main-title"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- secondary and tertiary titles -->
    <xsl:choose>
      <xsl:when test="$analytic and $monogr and not($series)">
        <xsl:apply-templates select="$monogr" mode="secondary"/>
      </xsl:when>
      <xsl:when test="$analytic and $series and not($monogr)">
        <xsl:apply-templates select="$series" mode="secondary"/>
      </xsl:when>
      <xsl:when test="$analytic and $series and $monogr">
        <xsl:apply-templates select="$monogr" mode="secondary"/>
        <xsl:apply-templates select="$series" mode="tertiary"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$series" mode="tertiary"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- Location & Publisher-->
    <xsl:if test="not($analytic) and .//tei:imprint/tei:pubPlace">
      <xsl:value-of select=".//tei:imprint/tei:pubPlace[@xml:lang=$lang or not(@xml:lang)]"/>
      <xsl:if test=".//tei:imprint/tei:publisher">
        <xsl:text>: </xsl:text>
        <xsl:value-of select=".//tei:imprint/tei:publisher[@xml:lang=$lang or not(@xml:lang)]"/>
      </xsl:if>
      <xsl:text> </xsl:text>
    </xsl:if>

    <!-- scope -->

    <xsl:apply-templates select="$monogr | $analytic " mode="scope"/>


    <!-- debugging -->
    <!--<pre>
      <xsl:value-of select="@xml:id"/><br/>
      <xsl:text>analytic: </xsl:text><xsl:value-of select="if($analytic) then true() else false()"/><br/>
      <xsl:text>monogr: </xsl:text><xsl:value-of select="if($monogr) then true() else false()"/><br/>
      <xsl:text>series: </xsl:text><xsl:value-of select="if($series) then true() else false()"/><br/>
      <xsl:for-each select="*"><br/>
        <xsl:value-of select="./local-name()"/><br/>
      </xsl:for-each>
    </pre>-->
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="author_list">
    <xsl:variable name="editor_only_list"
      select="count(./tei:editor[not(following-sibling::tei:author) and not(preceding-sibling::tei:author)]) &gt; 1"/>


    <xsl:for-each select="./tei:author | ./tei:editor">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:if test="./tei:surname[@xml:lang=$lang or not(@xml:lang)]">
            <xsl:value-of select="./tei:surname[@xml:lang=$lang or not(@xml:lang)]"/>
            <xsl:text>, </xsl:text>
          </xsl:if>
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

      <xsl:if test="./local-name() = 'editor' and not($editor_only_list)">
        <xsl:text> </xsl:text>
        <i18n:text key="__bibliography_editor">(Ed.)</i18n:text>
      </xsl:if>

      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>

      <xsl:if test="$editor_only_list and position() = last()">
        <i18n:text key="__bibliography_editors">, eds.</i18n:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="title">
    <xsl:value-of select="./tei:title"/>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="scope">

    <xsl:if test="./tei:biblScope[@type='series']">
      <xsl:text>(</xsl:text>
      <i18n:text>Series</i18n:text>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./tei:biblScope[@type='series']"/>
      <xsl:text>) </xsl:text>
    </xsl:if>

    <xsl:if test="./tei:biblScope[@type='vol']">
      <xsl:value-of select="./tei:biblScope[@type='vol']"/>
    </xsl:if>
    <xsl:if test="./tei:biblScope[@type='vol'] and ./tei:biblScope[@type='issue']">
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:if test="./tei:biblScope[@type='issue']">
      <xsl:value-of select="./tei:biblScope[@type='issue']"/>
    </xsl:if>

    <xsl:if test="./tei:biblScope[@type='pp']">
      <xsl:if test="./tei:biblScope[@type='vol'] or ./tei:biblScope[@type='issue']">
        <xsl:text>:</xsl:text>
      </xsl:if>
      <xsl:value-of select="./tei:biblScope[@type='pp']"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:monogr | tei:series" mode="secondary">

    <!-- Authors -->
    <xsl:if test="./(tei:author | tei:editor)">
      <xsl:apply-templates select="." mode="author_list"/>
      <xsl:text>, </xsl:text>
    </xsl:if>

    <!-- Title -->
    <xsl:if test="./tei:title">
      <em>
        <xsl:apply-templates select="." mode="title"/>
      </em>
      <xsl:text> </xsl:text>
    </xsl:if>

    <!-- Scope -->
    <xsl:if test="self::node()/local-name() = 'series'">
      <xsl:apply-templates select="." mode="scope"/>
      <xsl:text> </xsl:text>
    </xsl:if>

  </xsl:template>

  <xsl:template match="tei:series" mode="tertiary">

    <!-- Authors -->
    <xsl:if test="./(tei:author | tei:editor)">
      <xsl:apply-templates select="." mode="author_list"/>
      <xsl:text>, </xsl:text>
    </xsl:if>


    <xsl:text>(</xsl:text>
    <!-- Title -->
    <xsl:if test="./tei:title">
      <xsl:apply-templates select="." mode="title"/>
      <xsl:text> </xsl:text>
    </xsl:if>

    <!-- Scope -->
    <xsl:apply-templates select="." mode="scope"/>
    <xsl:text>)</xsl:text>
    <xsl:text> </xsl:text>


  </xsl:template>
</xsl:stylesheet>
