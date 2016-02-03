<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:import href="../common/conversions.xsl"/>
  <xsl:param name="lang" select="$lang"/>
  <xsl:param name="kiln:url-lang-suffix" select="$kiln:url-lang-suffix"/>
  <xsl:template match="/"/>

  <xsl:template name="bibliographyTitle">
    <i18n:text>Bibliography</i18n:text>
  </xsl:template>

  <xsl:variable name="surnames" select="/aggregation/surnames"/>
vo
  <xsl:function name="iospe:sort-bibliography">
    <xsl:param name="node"/>
    <xsl:variable name="normalised_author"
      select="normalize-space($surnames//tei:listPerson/tei:person[@xml:id = substring-after($node/*[tei:author | tei:editor][1]/(tei:author | tei:editor)[1]/tei:surname[1]/@corresp, 'surnames.xml#')]//tei:surname[@xml:lang = $lang or not(@xml:lang)])"/>
    <xsl:variable name="author"
      select="normalize-space($node/(*[tei:author | tei:editor][1]/(tei:author | tei:editor)[1]/(tei:surname | tei:forename[not(following-sibling::tei:surname)])[@xml:lang = $lang or not(@xml:lang)][1]/(@n | text())[1]))"/>
    <xsl:variable name="title"
      select="normalize-space($node/(*[tei:title][1]/tei:title[@xml:lang = $lang or not(@xml:lang)][1]/(@n | text())[1]))"/>
    <xsl:variable name="sort-string"
      select="
        if ($normalised_author != '') then
          $normalised_author
        else
          if ($author != '') then
            $author
          else
            $title"/>

    <xsl:choose>
      <xsl:when
        test="$lang = 'ru' and string-to-codepoints($sort-string)[1] >= 1024 and string-to-codepoints($sort-string)[1] &lt;= 1279">
        <xsl:value-of select="concat('00000', $sort-string)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sort-string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <xsl:template name="generateBibliography">
    <ul class="no-bullet">
      <xsl:for-each select="/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct">
        <xsl:sort select="iospe:sort-bibliography(.)"/>
        <xsl:sort
          select="normalize-space(./*[tei:imprint[tei:date]][1]/tei:imprint[tei:date][1]/tei:date[1])"/>
        <li class="concordance_item">
          <xsl:if test="/aggregation/concordance//doc/str[@name = 'bibl-target']/text() = @xml:id">
            <p class="concordance_link right">
              <a href="/conc/publications/{@xml:id}{$kiln:url-lang-suffix}.html" i18n:attr="title"
                title="View Concordance">
                <i class="fa fa-list fa-3x">
                  <xsl:text> </xsl:text>
                </i>
              </a>
            </p>
          </xsl:if>

          <p class="reference">
            <xsl:apply-templates select="."/>
          </p>
        </li>
      </xsl:for-each>
    </ul>
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
        <xsl:when test="not($analytic) and $monogr">
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
        <xsl:when test="$analytic/tei:title">
          <xsl:text>"</xsl:text>
          <xsl:apply-templates select="$analytic" mode="title"/>
          <xsl:text>."</xsl:text>
        </xsl:when>
        <xsl:when test="$analytic">
          <xsl:apply-templates select="$analytic" mode="title"/>
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:when test="$monogr and $series">
          <xsl:apply-templates select="$monogr" mode="title">
            <xsl:with-param name="emphasized" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$monogr">
          <xsl:apply-templates select="$monogr" mode="title">
            <xsl:with-param name="emphasized" select="true()"/>
          </xsl:apply-templates>
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:when test="$series">
          <xsl:apply-templates select="$series" mode="title">
            <xsl:with-param name="emphasized" select="true()"/>
          </xsl:apply-templates>
          <xsl:text>.</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Date -->

    <xsl:variable name="year">
      <xsl:apply-templates select="." mode="date"/>
    </xsl:variable>

    <!-- Reference Heading -->
    <xsl:choose>
      <xsl:when test="normalize-space($main-author-list) = ''">
        <xsl:copy-of select="$main-title"/>
        <xsl:text> (</xsl:text>
        <xsl:copy-of select="$year"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$main-author-list"/>
        <xsl:text> (</xsl:text>
        <xsl:copy-of select="$year"/>
        <xsl:text>) </xsl:text>
        <xsl:copy-of select="$main-title"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- secondary and tertiary titles -->
    <xsl:choose>
      <xsl:when test="$analytic and $monogr and not($series)">
        <xsl:text> </xsl:text>
        <xsl:if test="$monogr/tei:title[@level = 'm']">
          <i18n:text key="__edited_volumes_prefix">In </i18n:text>
        </xsl:if>
        <xsl:apply-templates select="$monogr" mode="secondary"/>
      </xsl:when>
      <xsl:when test="$analytic and $series and not($monogr)">
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="$series" mode="secondary"/>
      </xsl:when>
      <xsl:when test="$analytic and $series and $monogr">
        <xsl:text> </xsl:text>
        <xsl:if test="$monogr/tei:title[@level = 'm']">
          <i18n:text key="__edited_volumes_prefix">In </i18n:text>
        </xsl:if>
        <xsl:apply-templates select="$monogr" mode="secondary"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="$series" mode="tertiary"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="$series" mode="tertiary"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- scope (journal)-->
    <xsl:if test="$monogr/tei:title[@level = 'j']">
      <xsl:apply-templates select="$monogr" mode="scope"/>
    </xsl:if>
    
    <xsl:if
      test="($analytic and ($monogr and not($series) or not($monogr) and $series) or ($monogr and $series))
      and not($monogr/tei:biblScope[@unit='vol'] and $monogr/tei:biblScope[@unit='pp']
      and not($monogr/tei:imprint/tei:pubPlace))">
      <xsl:text>. </xsl:text>
    </xsl:if>
    

    <!-- Location & Publisher-->
    <xsl:if test=".//tei:imprint/tei:pubPlace">

      <!-- Location -->
      <xsl:for-each select=".//tei:imprint/tei:pubPlace[@xml:lang = $lang or not(@xml:lang)]">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <!-- Publisher -->
      <xsl:if test=".//tei:imprint/tei:publisher">
        <xsl:text>: </xsl:text>
        <xsl:value-of select=".//tei:imprint/tei:publisher[@xml:lang = $lang or not(@xml:lang)]"/>
      </xsl:if>
    </xsl:if>
    
    <!-- scope (not journals)-->
    <xsl:if test="not($monogr/tei:title[@level = 'j'])">
      <xsl:apply-templates select="$monogr | $analytic" mode="scope"/>
    </xsl:if>


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

  <xsl:template name="print_name">
    <xsl:param name="name"/>
    <xsl:param name="normalised_name"/>

    <xsl:if test="$name">
      <xsl:choose>
        <xsl:when test="$normalised_name">
          <xsl:value-of select="$normalised_name"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$name"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series | tei:bibl" mode="author_list">
    <xsl:variable name="editor_only_list"
      select="count(./tei:editor[not(following-sibling::tei:author) and not(preceding-sibling::tei:author)]) > 1"/>


    <xsl:for-each select="./tei:author | ./tei:editor">
      <xsl:variable name="roleName" select="./tei:roleName[@xml:lang = $lang or not(@xml:lang)]"/>
      <xsl:variable name="forename" select="./tei:forename[@xml:lang = $lang or not(@xml:lang)]"/>
      <xsl:variable name="surname" select="./tei:surname[@xml:lang = $lang or not(@xml:lang)]"/>

      <xsl:variable name="normalised_forename"
        select="/aggregation/surnames//tei:listPerson/tei:person[@xml:id = substring-after(current()/tei:surname/@corresp, 'surnames.xml#')]//tei:forename[@xml:lang = $lang or not(@xml:lang)]"/>

      <xsl:variable name="normalised_surname"
        select="/aggregation/surnames//tei:listPerson/tei:person[@xml:id = substring-after(current()/tei:surname/@corresp, 'surnames.xml#')]//tei:surname[@xml:lang = $lang or not(@xml:lang)]"/>


      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:call-template name="print_name">
            <xsl:with-param name="name" select="$surname"/>
            <xsl:with-param name="normalised_name" select="$normalised_surname"/>
          </xsl:call-template>

          <xsl:if test="$surname and ($roleName or $forename)">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:if test="$forename">
            <xsl:text> </xsl:text>
            <xsl:call-template name="print_name">
              <xsl:with-param name="name" select="$forename"/>
              <xsl:with-param name="normalised_name" select="$normalised_forename"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$roleName">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$roleName"/>
          </xsl:if>

        </xsl:when>
        <xsl:otherwise>

          <xsl:if test="$forename">
            <xsl:text> </xsl:text>
            <xsl:call-template name="print_name">
              <xsl:with-param name="name" select="$forename"/>
              <xsl:with-param name="normalised_name" select="$normalised_forename"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$surname">
            <xsl:text> </xsl:text>
            <xsl:call-template name="print_name">
              <xsl:with-param name="name" select="$surname"/>
              <xsl:with-param name="normalised_name" select="$normalised_surname"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$roleName">
            <xsl:value-of select="$roleName"/>
          </xsl:if>

        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="./local-name() = 'editor' and not($editor_only_list)">
        <i18n:text key="__bibliography_editor">, ed.</i18n:text>
      </xsl:if>

      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>

      <xsl:if test="$editor_only_list and position() = last()">
        <i18n:text key="__bibliography_editors">, eds.</i18n:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:biblStruct//tei:date">
    <xsl:apply-templates select="child::node()[@xml:lang = $lang or not(@xml:lang)]"/>
  </xsl:template>

  <xsl:template match="tei:biblStruct | tei:bibl" mode="date">
    <xsl:choose>
      <xsl:when test=".//tei:imprint/tei:date[1]">
        <xsl:apply-templates select=".//tei:imprint/tei:date[1]"/>
      </xsl:when>
      <xsl:when test=".//tei:date[1]">
        <xsl:apply-templates select=".//tei:date[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <i18n:text key="__date_nd">n.d.</i18n:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:biblStruct//tei:title">
    <xsl:param name="emphasized" select="false()"/>

    <xsl:variable name="journal-name" select="normalize-space(.)"/>

    <xsl:choose>
      <xsl:when
        test="
          @level = 'j' and
          not(normalize-space(//tei:listBibl[@type = 'periodicals']/tei:bibl[@xml:id = $journal-name]) = '')">
        <!-- journal is abbreviated -->

        <xsl:variable name="full-journal-name"
          select='//tei:listBibl[@type = "periodicals"]/tei:bibl[@xml:id = $journal-name]'/>
        <xsl:choose>
          <xsl:when test="$emphasized">
            <em>
              <xsl:call-template name="full-journal-name">
                <xsl:with-param name="journal" select="$full-journal-name"/>
              </xsl:call-template>
            </em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="full-journal-name">
              <xsl:with-param name="journal" select="$full-journal-name"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$emphasized">
            <em>
              <xsl:apply-templates/>
            </em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="full-journal-name">
    <xsl:param name="journal"/>
    <span class="has-tip">
      <xsl:attribute name="title">
        <xsl:apply-templates select="$journal/tei:title"/>
        <xsl:text>&#160;</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="data-id">
        <xsl:text>tooltip_id_</xsl:text>
        <xsl:value-of select="normalize-space($journal/@xml:id)"/>
      </xsl:attribute>
      <xsl:attribute name="data-tooltip">
        <xsl:text>#tooltip_id_</xsl:text>
        <xsl:value-of select="normalize-space($journal/@xml:id)"/>
      </xsl:attribute>
      <xsl:value-of select="$journal/@xml:id"/>
    </span>

  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series | tei:bibl" mode="title">
    <xsl:param name="emphasized" select="false()"/>

    <xsl:if test="./tei:title[@xml:lang = $lang and text() != '' or text() != '']">
      <xsl:apply-templates
        select="./tei:title[@xml:lang = $lang and text() != '' or text() != ''][1]">
        <xsl:with-param name="emphasized" select="$emphasized"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if
      test="./tei:title[@xml:lang = $lang and text() != '' or text() != ''] and self::tei:analytic and following-sibling::tei:relatedItem">
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:if test="self::tei:analytic and following-sibling::tei:relatedItem">
      <xsl:variable name="rel_item" select="following-sibling::tei:relatedItem/@target"/>
      <i18n:text>Review of</i18n:text>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when
          test="/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id = substring-after($rel_item, '#')]">
          <a href="{$rel_item}">
            <xsl:variable name="referenced_biblstruct"
              select="/aggregation/bib/tei:TEI//tei:listBibl/tei:biblStruct[@xml:id = substring-after($rel_item, '#')]"/>
            <xsl:apply-templates
              select="$referenced_biblstruct/(tei:analytic | tei:monogr | tei:series)[1]"
              mode="author_list"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="$referenced_biblstruct" mode="date"/>
          </a>
        </xsl:when>

        <xsl:when
          test="/aggregation/bib/tei:TEI//tei:listBibl[@type = 'corpora']/tei:bibl[@xml:id = substring-after($rel_item, '#')]">
          <xsl:variable name="referenced_corpora_bibl"
            select="/aggregation/bib/tei:TEI//tei:listBibl[@type = 'corpora']/tei:bibl[@xml:id = substring-after($rel_item, '#')]"/>
          <xsl:apply-templates select="$referenced_corpora_bibl" mode="author_list"/>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="$referenced_corpora_bibl" mode="title"/>

        </xsl:when>
      </xsl:choose>

    </xsl:if>


    <xsl:if test="self::tei:monogr/tei:biblScope[@unit = 'vol']">
      <xsl:if test="tei:title[@level = 'm' or @level ='s']">
        <xsl:text>, </xsl:text>
        <i18n:text key="__series_title_prefix">vol. </i18n:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./tei:biblScope[@unit = 'vol']"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:analytic | tei:monogr | tei:series" mode="scope">

    <xsl:if test="./tei:biblScope[@unit = 'series']">
      <xsl:text> (</xsl:text>
      <i18n:text>Series</i18n:text>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./tei:biblScope[@unit = 'series']"/>
      <xsl:text>)</xsl:text>
    </xsl:if>

    <xsl:if test=".[not(self::tei:monogr)]/tei:biblScope[@unit = 'vol']">
      
      <xsl:if test="./tei:title[@level = 's' or @level = 'm']">
        <xsl:text> </xsl:text>
        <i18n:text key="__series_title_prefix">vol. </i18n:text>
      </xsl:if>
      
      <xsl:text> </xsl:text>
      <xsl:value-of select="./tei:biblScope[@unit = 'vol']"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when
        test=".[not(self::tei:monogr)]/tei:biblScope[@unit = 'vol'] and (./tei:biblScope[@unit = 'issue'] or ./tei:biblScope[@unit = 'part'])">
        <xsl:text>.</xsl:text>
      </xsl:when>
      <xsl:when test="./tei:biblScope[@unit = 'issue']">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="./tei:biblScope[@unit='part']">
        <xsl:text> </xsl:text>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="./tei:biblScope[@unit = 'issue']">
      <xsl:value-of select="./tei:biblScope[@unit = 'issue'][@xml:lang = $lang or not(@xml:lang)]"/>
    </xsl:if>
    <xsl:if test="./tei:biblScope[@unit = 'part']">
      <xsl:for-each select="./tei:biblScope[@unit = 'part'][@xml:lang = $lang or not(@xml:lang)]">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="./tei:biblScope[@unit = 'pp']">
      <xsl:choose>
        <xsl:when
          test=".[not(self::tei:monogr)]/tei:biblScope[@unit = 'vol'] or ./tei:biblScope[@unit = 'issue']">
          <xsl:text>:</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="./tei:biblScope[@unit = 'pp']">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
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
      <xsl:apply-templates select="." mode="title">
        <xsl:with-param name="emphasized" select="true()"/>
      </xsl:apply-templates>
    </xsl:if>

    <!-- Scope -->
    <xsl:if test="self::tei:series">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="." mode="scope"/>
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
    </xsl:if>
    

    <!-- Scope -->
    <xsl:apply-templates select="." mode="scope"/>
    <xsl:text>)</xsl:text>

  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='sup']">
    <sup>
      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
    </sup>
  </xsl:template>
  
</xsl:stylesheet>
