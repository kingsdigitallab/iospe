<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:import href="../common/conversions.xsl"/>
  <xsl:import href="inscription.xsl"/>

  <xsl:template match="/"/>


  <xsl:function name="iospe:sort-dur">
    <xsl:param name="w3cdur"/>
    <xsl:param name="request"/>
    <xsl:variable name="year">
      <xsl:analyze-string select="$w3cdur" regex="^P(\d+)Y">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="month">
      <xsl:analyze-string select="$w3cdur" regex="(\d+)M">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="day">
      <xsl:analyze-string select="$w3cdur" regex="(\d+)D">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$request='Y'">
        <xsl:value-of select="$year"/>
      </xsl:when>
      <xsl:when test="$request='M'">
        <xsl:value-of select="$month"/>
      </xsl:when>
      <xsl:when test="$request='D'">
        <xsl:value-of select="$day"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

  <!-- set title -->
  <xsl:template name="indexTitle">
    <!-- KFL - Inscriptions by Date gets title from tocs.xsl, all the rest get the title here -->
    <xsl:choose>
      <xsl:when test="$index='words' and //str[@name='lang']='lat'">
        <i18n:text>Latin Words</i18n:text>
      </xsl:when>
      <xsl:when test="$index='words' and //str[@name='lang']='grc'">
        <i18n:text>Greek Words</i18n:text>
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='lat'">
        <i18n:text>Fragments of Text in Latin</i18n:text>
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='grc'">
        <i18n:text>Fragments of Text in Greek</i18n:text>
      </xsl:when>
      <xsl:when test="$index='attested' and //str[@name='persName-type']='attested'">
        <i18n:text>Personal Names</i18n:text>
      </xsl:when>
      <xsl:when test="$index='symbols'">
        <i18n:text>Symbols</i18n:text>
      </xsl:when>
      <xsl:when test="$index='numerals'">
        <i18n:text>Numerals</i18n:text>
      </xsl:when>
      <xsl:when test="$index='ligatures'">
        <i18n:text>Ligatured characters</i18n:text>
      </xsl:when>
      <xsl:when test="$index='death'">
        <i18n:text>Age at Death</i18n:text>
      </xsl:when>
      <xsl:when test="$index=concat('findspot-',$lang)">
        <i18n:text>Find Places</i18n:text>
      </xsl:when>
      <xsl:when test="$index='attested'">
        <i18n:text>Personal names</i18n:text>
      </xsl:when>
      <xsl:when test="$index='monument-type'">
        <i18n:text>Inscriptions by Monument Type</i18n:text>
      </xsl:when>
      <xsl:when test="$index='document-type'">
        <i18n:text>Inscriptions by Category of Text</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="letterList">
    <ul class="pagination">
      <xsl:for-each select="//letters/letter">
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="$ancient-lang=('grc', 'all')">
                  <xsl:value-of
                    select="translate(translate(., $unicode, $betacode),$lowercase, $uppercase)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="$kiln:url-lang-suffix"/>
              <xsl:text>.html</xsl:text>
            </xsl:attribute>

            <xsl:choose>
              <xsl:when test="$ancient-lang=('grc', 'all')">
                <xsl:value-of
                  select="translate(translate(., $betacode, $unicode),$lowercase, $uppercase)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndex">
    <!-- Some indices require an upper-case grouping. Add the list here -->
    <!-- Pull the right transformation to keep the grouping key unchanged or make it uppercase -->
    <xsl:variable name="transformation">
      <xsl:choose>
        <xsl:when test="$index=('fragment', 'abbr')">
          <xsl:sequence select="$uppercase"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$lowercase"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- list of available letters, if present -->
    <xsl:if test="//letters">
      <xsl:call-template name="letterList"/>
    </xsl:if>


    <!-- grouping is typically done on the field named after the index,
            but sometimes it needs other fields. The switch is handled with XPath in @group-by -->
    <!-- These are the fields grouped in a non-standard manner: -->
    <table class="indices">
      <tbody>
        <xsl:choose>
          <!-- Tests if the index element is an array or a string
                Some solr fields are multivalued, documents can belong to more than one category
                -->
          <xsl:when test="//doc/str[@name=$index]">
            <xsl:for-each-group select="//doc"
              group-by="translate(normalize-space(str[@name=$index]), $lowercase, $transformation)">
              <xsl:call-template name="index_group"/>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:when test="//doc/arr[@name=concat($index, '-', $lang)]">
            <xsl:for-each-group select="//doc" group-by="arr[@name=concat($index, '-', $lang)]/str">
              <xsl:call-template name="index_group"/>
            </xsl:for-each-group>
          </xsl:when>
          <!-- There is no default, if nothing is displayed something is very wrong in the indices -->
        </xsl:choose>
      </tbody>
    </table>

  </xsl:template>


  <xsl:template name="link2inscription">
    <a class="link2inscription" href="/{str[@name='file']}{$kiln:url-lang-suffix}.html">
      <xsl:if test="str[@name='sup']">
        <xsl:text>[</xsl:text>
      </xsl:if>
      <xsl:if test="str[@name='cert']">
        <xsl:text>?</xsl:text>
      </xsl:if>
      <xsl:call-template name="formatInscrNum">
        <xsl:with-param name="num" select="str[@name='tei-id']"/>
      </xsl:call-template>
      <xsl:if test="arr[@name='divloc']">
        <xsl:for-each select="arr[@name='divloc']/str">
          <xsl:if test="not(preceding-sibling::str)">
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:value-of select="translate(., '-', '.')"/>
          <xsl:text>.</xsl:text>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="not(str[@name='line']='0')">
        <xsl:choose>
          <xsl:when test="not(str[@name='line'])"/>
          <xsl:when test="arr[@name='divloc']"/>
          <xsl:otherwise>
            <xsl:text>.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="str[@name='line']"/>
      </xsl:if>
      <xsl:if test="str[@name='sup']">
        <xsl:text>]</xsl:text>
      </xsl:if>
    </a>
  </xsl:template>

  <xsl:template name="index_group">
    <!-- Only sort for death index (Solr does not handle ISO-duration -->
    <xsl:sort
      select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'Y')) else ()"/>
    <xsl:sort
      select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'M')) else ()"/>
    <xsl:sort
      select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'D')) else ()"/>

    <xsl:variable name="display_key">
      <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))"/>
      <xsl:value-of select="substring(replace(current-grouping-key(), '_' , ' '), 2)"/>
    </xsl:variable>

    <tr class="index_row row">
      <th class="large-2">
        <xsl:choose>
          <xsl:when test="str[@name='num-value']">
            <xsl:value-of select="$display_key"/>
            <small>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="str[@name='num-value']"/>
              <xsl:text>)</xsl:text>
            </small>
          </xsl:when>
          <xsl:when test="str[@name='num-atleast'] and str[@name='num-atmost']">
            <xsl:value-of select="$display_key"/>
            <small>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="str[@name='num-atleast']"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="str[@name='num-atmost']"/>
              <xsl:text>)</xsl:text>
            </small>
          </xsl:when>
          <xsl:when test="str[@name='num-atleast']">
            <xsl:value-of select="$display_key"/>
            <small>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="str[@name='num-atleast']"/>
              <xsl:text>)</xsl:text>
            </small>
          </xsl:when>
          <xsl:when test="str[@name='num-atmost']">
            <xsl:value-of select="$display_key"/>
            <small>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="str[@name='num-atmost']"/>
              <xsl:text>)</xsl:text>
            </small>
          </xsl:when>
          <xsl:when test="$index='death'">
            <xsl:variable name="y" select="iospe:sort-dur(current-grouping-key(), 'Y')"/>
            <xsl:variable name="m" select="iospe:sort-dur(current-grouping-key(), 'M')"/>
            <xsl:variable name="d" select="iospe:sort-dur(current-grouping-key(), 'D')"/>
            <xsl:if test="$y!=''">
              <xsl:value-of select="$y"/>
              <xsl:text> year</xsl:text>
              <xsl:if test="$y &gt; 1">s</xsl:if>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="$m!=''">
              <xsl:value-of select="$m"/>
              <xsl:text> month</xsl:text>
              <xsl:if test="$m &gt; 1">s</xsl:if>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="$d!=''">
              <xsl:value-of select="$m"/>
              <xsl:text> day</xsl:text>
              <xsl:if test="$m &gt; 1">s</xsl:if>
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="normalize-space(current-grouping-key())">
                <xsl:value-of select="$display_key"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Empty</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </th>

      <td class="large-10">
        <ul class="inline-list">
          <xsl:for-each select="current-group()">
            <li>
              <xsl:call-template name="link2inscription"/>
            </li>
          </xsl:for-each>
        </ul>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="sort-option">
    <!-- print sort options, name is default unless group param is true, in which case, group is default -->
    <xsl:param name="group" select="false()"/>

    <dl class="sub-nav">
      <dt>
        <i18n:text>Sort by</i18n:text>
        <xsl:text>: </xsl:text>
      </dt>
      <dd>
        <xsl:attribute name="class">
          <xsl:if test="$sort = 'date'">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <a href="?sort=date">
          <i18n:text>Date</i18n:text>
        </a>
      </dd>
      <dd>
        <xsl:attribute name="class">
          <xsl:if test="$sort = 'name' or ($sort = '' and not($group))">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <a href="?sort=name">
          <i18n:text>Name</i18n:text>
        </a>
      </dd>
           
      <xsl:if test="$group">
        <dd>
          <xsl:attribute name="class">
            <xsl:if test="$sort = 'group' or $sort = ''">
              <xsl:text>active</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <a href="?sort=group">
            <i18n:text>Group</i18n:text>
          </a>
        </dd>
      </xsl:if>
    </dl>
  </xsl:template>


</xsl:stylesheet>
