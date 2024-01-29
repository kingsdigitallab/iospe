<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang"/>
  <xsl:param name="hl"/>

  <xsl:param name="lang"/>
  <xsl:param name="current-date"/>
  <xsl:param name="current-letter"/>

  <!-- ************************************* -->
  <!-- ********** Global variables ********* -->
  <!-- ************************************* -->
  <xsl:variable name="lang-suffix">
    <xsl:choose>
      <xsl:when test="$lang != 'en'">
        <xsl:value-of select="concat('-', $lang)"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>
  <!-- For display "sort by date" the following variables help us
    create the pagination list at top of table and to associate the
    correct Attested Person names with each era+century value -->
  <xsl:variable name="input">
    <xsl:sequence select="distinct-values(//tei:person/tei:floruit/@notBefore)"/>
  </xsl:variable>

  <xsl:variable name="sorted">
    <xsl:perform-sort select="tokenize($input, '\s')">
      <xsl:sort select="."/>
    </xsl:perform-sort>
  </xsl:variable>

  <xsl:variable name="earliest_date">
    <xsl:sequence select="tokenize($sorted, '\s')[1]"/>
  </xsl:variable>

  <xsl:variable name="e_century_string" as="node()*">
    <xsl:choose>
      <xsl:when test="starts-with($earliest_date, '-')">
        <xsl:sequence
          select="//list[@xml:lang = $lang]/century[substring(@max, 2, 2) = substring($earliest_date, 2, 2)][1]/@url"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence
          select="//list[@xml:lang = $lang]/century[substring(@min, 1, 2) = substring($earliest_date, 1, 2)][1]/@url"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="earliest_century" select="substring-before($e_century_string, '-')"/>
  <xsl:variable name="earliest_era_prefix" select="substring-after($e_century_string, '-')"/>

  <xsl:variable name="latest_date">
    <xsl:sequence select="tokenize($sorted, '\s')[last()]"/>
  </xsl:variable>

  <xsl:variable name="l_century_string" as="node()*">
    <xsl:sequence
      select="//list[@xml:lang = $lang]/century[substring(@min, 1, 2) = substring($latest_date, 1, 2)]/@url"
    />
  </xsl:variable>

  <xsl:variable name="l_century_num" as="node()*">
    <xsl:sequence
      select="//list[@xml:lang = $lang]/century[substring(@min, 1, 2) = substring($latest_date, 1, 2)]/@num"
    />
  </xsl:variable>

  <xsl:variable name="latest_century" select="substring-before($l_century_string, '-')"/>

  <!-- the two date_limit variables below help with grouping the Attested Persons by their @notBefore value -->
  <xsl:variable name="lower_date_limit"
    select="number(//list[@xml:lang = $lang]/century[@url = $current-date]/@min)"/>
  <xsl:variable name="upper_date_limit" select="number($lower_date_limit + 99)"/>

  <!-- ****************************************** -->
  <!-- ********** End global variables ********** -->
  <!-- ****************************************** -->

  <xsl:template match="/"/>



  <xsl:template name="indexTitlePerson">
    <i18n:text>Attested Persons</i18n:text>
  </xsl:template>

  <xsl:template name="group_pagination">
    <xsl:param name="prefix" select="''"/>
    <ul class="pagination">
      <xsl:for-each select="//AL//tei:listPerson">
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$prefix"/>
              <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang = $lang])"/>
            </xsl:attribute>
            <xsl:value-of select="tei:head[@xml:lang = $lang]"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexPerson">



    <div class="section-container tabs" data-section="tabs" data-options="deep_linking: false;">

      <section>
        <xsl:attribute name="class">
          <xsl:if test="$sort = 'letters'">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="../letters/A{$lang-suffix}.html">

            <i18n:text>Sort by name</i18n:text>
          </a>
        </p>
        <xsl:if test="$sort = 'letters'">
          <div class="content" data-section-content="true">
            <div class="row">

              <xsl:if test="//letters[@type != 'date']">
                <xsl:call-template name="letterList">
                  <xsl:with-param name="lettertype">
                    <xsl:value-of select="//letters[@type != 'date']/@type"/>
                  </xsl:with-param>
                  <xsl:with-param name="myletter" select="$current-letter"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:call-template name="indices_apl_info"/>

              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <xsl:choose>
                        <xsl:when test="$lang = 'ru'">Русский</xsl:when>
                        <xsl:when test="$lang = 'uk'">Українська</xsl:when>
                        <xsl:otherwise>English</xsl:otherwise>
                      </xsl:choose>
                    </th>
                    <th>
                      <i18n:text>Date</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Relationships</i18n:text>
                    </th>

                    <th>
                      <i18n:text>Occupation/Title</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Inscriptions</i18n:text>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each
                      select="/aggregation/data//result/doc">
                    <xsl:call-template name="person">
                      <xsl:with-param name="myXMLid">
                        <xsl:value-of select="current()/str[@name = 'id']"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </div>
        </xsl:if>
      </section>


      <section>
        <xsl:attribute name="class">
          <xsl:if test="$sort = 'date'">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="../dates/{$earliest_century}_{$earliest_era_prefix}{$lang-suffix}.html">
            <i18n:text>Sort by date</i18n:text>
          </a>
        </p>
        <xsl:if test="$sort = 'date'">
          <div class="content" data-section-content="true">
            <div class="row">
              <div class="pagination-centered">
                <ul class="date pagination">
                  <xsl:if test="$earliest_era_prefix = 'BCE'">
                    <li class="unavailable">
                      <i18n:text>BCE</i18n:text>
                    </li>
                    <xsl:for-each
                      select="//letters[@type = 'date']/letter[not(text() = 'dated')][substring-after(., '-') = 'BCE']">
                      <xsl:sort select="//list[@xml:lang = $lang]/century[@url = current()]/@num"
                        data-type="number" order="descending"/>

                      <li>
                        <xsl:attribute name="class">
                          <xsl:if test="current() = $current-date">
                            <xsl:text>current</xsl:text>
                          </xsl:if>
                        </xsl:attribute>
                        <a href="{translate(., '-', '_')}{$lang-suffix}.html">
                          <xsl:value-of select="substring-before(., '-')"/>
                        </a>
                      </li>
                    </xsl:for-each>
                  </xsl:if>


                  <li class="unavailable">
                    <i18n:text>CE</i18n:text>
                  </li>

                  <xsl:for-each
                    select="//letters[@type = 'date']/letter[not(text() = 'dated')][substring-after(., '-') = 'CE']">
                    <xsl:sort
                      select="//list[@xml:lang = $lang]/century[(@url = current()) and (@num &lt;= $l_century_num)]/@num"
                      data-type="number" order="ascending"/>
                    <li>
                      <xsl:attribute name="class">
                        <xsl:if test="current() = $current-date">
                          <xsl:text>current</xsl:text>
                        </xsl:if>
                      </xsl:attribute>
                      <a href="{translate(., '-', '_')}{$lang-suffix}.html">
                        <xsl:value-of select="substring-before(., '-')"/>
                      </a>
                    </li>
                  </xsl:for-each>


                </ul>
              </div>

              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <i18n:text>English</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Date</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Relationships</i18n:text>
                    </th>

                    <th>
                      <i18n:text>Occupation/Title</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Inscriptions</i18n:text>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each
                    select="//persons//tei:person[(number(tei:floruit/@notBefore) >= $lower_date_limit) and (number(tei:floruit/@notBefore) &lt;= $upper_date_limit)]">
                    <xsl:sort
                      select="concat(tei:floruit[tei:seg[@xml:lang = $lang]]/@notBefore, 'X')"/>
                    <xsl:sort select="tei:floruit[tei:seg[@xml:lang = $lang]]/@notAfter"/>
                    <xsl:call-template name="person">
                      <xsl:with-param name="myXMLid">
                        <xsl:value-of select="current()/@xml:id"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </div>
        </xsl:if>
      </section>


    </div>
  </xsl:template>

  <xsl:template name="person">
    <xsl:param name="myXMLid">foo</xsl:param>
    <xsl:variable name="attPersonEntry">
      <xsl:sequence select="/aggregation/persons//tei:person[@xml:id = $myXMLid]"/>
    </xsl:variable>
    <tr class="index_row">
      <xsl:if test="$myXMLid = $hl">
        <xsl:attribute name="style">background-color: yellow</xsl:attribute>
      </xsl:if>
      <th id="{$myXMLid}">
        <xsl:choose>
          <xsl:when test="$lang = 'ru'">
            <a href="../record/{$myXMLid}-{$lang}.html" i18n:attr="title"
              title="Permanent link for this person" name="{$myXMLid}">
              <span style="font-size: smaller;">
                <sup>&#x00B6;</sup>
              </span>
              <xsl:text> </xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="../record/{$myXMLid}.html" i18n:attr="title"
              title="Permanent link for this person" name="{$myXMLid}">
              <span style="font-size: smaller;">
                <sup>&#x00B6;</sup>
              </span>
              <xsl:text> </xsl:text>
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="/aggregation/persons//tei:person[@xml:id =$myXMLid]/tei:persName[@xml:lang != 'en'][@xml:lang != 'ru']">
          <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:text> </xsl:text>
      </th>

      <td class="persName">
        <xsl:choose>
          <xsl:when test="$lang != 'en'">
            <xsl:value-of select="string-join(/aggregation/persons//tei:person[@xml:id =$myXMLid]/tei:persName[@xml:lang = $lang], ', ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string-join(/aggregation/persons//tei:person[@xml:id =$myXMLid]/tei:persName[@xml:lang = $lang], ', ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <td class="flourit">
        <xsl:value-of select="/aggregation/persons//tei:person[@xml:id =$myXMLid]/tei:floruit/tei:seg[@xml:lang = $lang]"/>
        <xsl:text> </xsl:text>
      </td>

      <td class="relations">
        <xsl:for-each
          select="/aggregation/persons/descendant::tei:relation[substring-after(@active, '#') = $myXMLid]">
          <xsl:choose>
            <!-- the child tei:desc should only be in Russian, so if $lang is ru we'll
             use the value of tei:desc because it will have the correct genitive form -->
            <xsl:when test="tei:desc[@xml:lang = $lang]">
              <xsl:variable name="passiveXMLid" select="normalize-space(substring-after(@passive, '#'))"/>
              <!--<xsl:variable name="grc_first_letter" select="substring(substring-after(tei:desc[@xml:lang = $lang], ' '), 1, 1)"/>-->
              <xsl:variable name="grc_first_letter"
                select="substring(/aggregation/persons/descendant::tei:person[@xml:id = $passiveXMLid]/tei:persName[@xml:lang = 'grc'], 1, 1)"/>
              <xsl:variable name="link_letter" select="//firstletters/alist/list[@type='grc']/item[letter = $grc_first_letter]/equiv-en"/>
              <xsl:variable name="link_date" select="/aggregation/persdates//result/doc[str[@name='id'] = $passiveXMLid]/str[@name='date-era']"/>          
              <xsl:variable name="link_string">
                <xsl:choose>
                  <xsl:when test="$sort='letters'">
                    <xsl:value-of select="concat('letters/', $link_letter, '_', $passiveXMLid, '-ru')"/>
                  </xsl:when>
                  <xsl:when test="$sort='date'">
                    <xsl:value-of select="concat('dates/', $link_date, '_', $passiveXMLid, '-ru')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:value-of select="substring-before(tei:desc[@xml:lang = $lang], ' ')"/>
              <xsl:text> </xsl:text>
              <a class="relation-link" href="../{$link_string}.html#{$passiveXMLid}">
                <xsl:value-of select="substring-after(tei:desc[@xml:lang = $lang], ' ')"/>
              </a>
            </xsl:when>

            <!-- otherwise we just concat an appropriate phrase with the name pointed to by @passive -->
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@name = 'father'">
                  <i18n:text>father of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'son'">
                  <i18n:text>son of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'mother'">
                  <i18n:text>mother of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'daughter'">
                  <i18n:text>daughter of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'brother'">
                  <i18n:text>brother of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'sister'">
                  <i18n:text>sister of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'related'">
                  <i18n:text>related of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'fiancé'">
                  <i18n:text>fiancé of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'fiancée'">
                  <i18n:text>fiancée of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'husband'">
                  <i18n:text>husband of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'wife'">
                  <i18n:text>wife of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'grandfather'">
                  <i18n:text>grandfather of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'grandson'">
                  <i18n:text>grandson of</i18n:text>
                </xsl:when>
                <xsl:when test="@name = 'granddaughter'">
                  <i18n:text>granddaughter of</i18n:text>
                </xsl:when>
              </xsl:choose>
              <!-- space after relationship -->
              <xsl:text> </xsl:text>

              <xsl:variable name="passives" select="tokenize(substring-after(@passive, '#'), ' #')"
                as="xs:sequence"/>

              <xsl:for-each select="/aggregation/persons/descendant::tei:person[@xml:id = $passives]">
                <xsl:variable name="theirXMLid" select="normalize-space(@xml:id)"/>
                <xsl:variable name="grc_first_letter"
                  select="substring(tei:persName[@xml:lang = 'grc'], 1, 1)"/>
                <xsl:variable name="link_letter"
                  select="//firstletters/alist/list[@type = 'grc']/item[letter = $grc_first_letter]/equiv-en"/>
                <xsl:variable name="link_date"
                  select="/aggregation/persdates//result/doc[str[@name = 'id'] = $theirXMLid]/str[@name = 'date-era']"/>
                <xsl:variable name="link_string">
                  <xsl:choose>
                    <xsl:when test="$sort = 'letters' and $lang = 'en'">
                      <xsl:value-of select="concat('letters/', $link_letter, '_', $theirXMLid)"/>
                    </xsl:when>
                    <xsl:when test="$sort = 'letters' and $lang = 'ru'">
                      <xsl:value-of
                        select="concat('letters/', $link_letter, '_', $theirXMLid, '-ru')"/>
                    </xsl:when>
                    <xsl:when test="$sort = 'date' and $lang = 'en'">
                      <xsl:value-of select="concat('dates/', $link_date, '_', $theirXMLid)"/>
                    </xsl:when>
                    <xsl:when test="$sort = 'date' and $lang = 'ru'">
                      <xsl:value-of select="concat('dates/', $link_date, '_', $theirXMLid, '-ru')"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <a href="../{$link_string}.html#{$theirXMLid}">
                  <xsl:value-of select="tei:persName[@xml:lang = $lang]"/>
                </a>
                <xsl:if test="following::tei:person[@xml:id = $passives]">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="following::tei:relation[@active = current()/@active]">
            <br/>
          </xsl:if>

        </xsl:for-each>
        <xsl:text> </xsl:text>
      </td>

      <td class="occupation">
        <xsl:value-of select="/aggregation/persons//tei:person[@xml:id =$myXMLid]/tei:occupation"/>
        <xsl:choose>
          <xsl:when test="@key='stonecutter'">
            <i18n:text>stonecutter</i18n:text>
          </xsl:when>
          <xsl:when test="@key='priest'">
            <i18n:text>priest</i18n:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <td class="inscriptions">
        <ul class="inline-list">
          <xsl:for-each
            select="/aggregation/index//result/doc[arr[@name = 'persName-ref']/str[substring-after(text(), '#') = $myXMLid]]">
            <xsl:sort select="str[@name = 'tei-id']"/>
            <li>
              <xsl:call-template name="link2inscription"/>
            </li>
          </xsl:for-each>
        </ul>
      </td>
    </tr>


  </xsl:template>
  <!-- print sort options, name is default unless group param is true, in which case, group is default -->
  <xsl:template name="sort-option">
    <xsl:param name="group" select="false()"/>
    <div class="row">
      <div class="large-12 columns">
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
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>
