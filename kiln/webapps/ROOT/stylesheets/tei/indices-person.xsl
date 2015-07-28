<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:param name="lang"/>
  <xsl:template match="/"/>

  <!-- set title -->
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

    <xsl:call-template name="indices_bracket_info"/>



    <div class="section-container tabs" data-section="tabs" data-options="deep_linking: false;">
      <section>
        <xsl:attribute name="class">
          <xsl:if test="$sort = 'date'">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="?sort=date">
            <i18n:text>Sort by date</i18n:text>
          </a>
        </p>
        <xsl:if test="$sort = 'date'">
          <div class="content" data-section-content="true">
            <div class="row">
              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <i18n:text>Greek</i18n:text>
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
                  <xsl:for-each select="//persons//tei:person">
                    <xsl:sort
                      select="concat(tei:floruit[tei:seg[@xml:lang = $lang]]/@notBefore, 'X')"/>
                    <xsl:sort select="tei:floruit[tei:seg[@xml:lang = $lang]]/@notAfter"/>
                    <xsl:call-template name="person"/>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </div>
        </xsl:if>
      </section>
      <section>
        <xsl:attribute name="class">
          <xsl:if test="
              $sort = ('name',
              '')">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="?sort=name">
            <i18n:text>Sort by name</i18n:text>
          </a>
        </p>
        <xsl:if test="
            $sort = ('name',
            '')">
          <div class="content" data-section-content="true">
            <div class="row">
              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <i18n:text>Greek</i18n:text>
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
                  <xsl:for-each select="//persons//tei:person">
                    <xsl:sort
                      select="
                        concat(
                        upper-case(
                        replace(
                        replace(
                        normalize-unicode(
                        normalize-space(tei:persName[@xml:lang = $lang]),
                        'NFKD'),
                        '[?\-\.]', '–'),
                        '[^A-Za-z0-9А-Яа-я –]', '')
                        ),
                        'ЯЯЯ')"/>

                    <xsl:call-template name="person"/>
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
    <tr class="index_row">
      <th id="{@xml:id}">
        <xsl:value-of select="string-join(tei:persName[@xml:lang = $lang], ', ')"/>
        <xsl:text> </xsl:text>
      </th>


      <td class="persName">
        <xsl:for-each select="tei:persName[@xml:lang != 'en'][@xml:lang != 'ru']">
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:text> </xsl:text>
      </td>

      <td class="flourit">
        <xsl:value-of select="tei:floruit/tei:seg[@xml:lang = $lang]"/>
        <xsl:text> </xsl:text>
      </td>

      <td class="relations">
        <xsl:for-each
          select="//persons/descendant::tei:relation[substring-after(@active, '#') = current()/@xml:id]">
          <xsl:choose>
            <!-- the child tei:desc should only be in Russian, so if $lang is ru we'll 
              use the value of tei:desc because it will have the correct genitive form -->
            <xsl:when test="tei:desc[@xml:lang = $lang]">
              <xsl:value-of select="substring-before(tei:desc[@xml:lang = $lang], ' ')"/>
              <xsl:text> </xsl:text>
              <a class="relation-link" href="{@passive}">
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

              <xsl:for-each select="//persons/descendant::tei:person[@xml:id = $passives]">
                <a href="#{@xml:id}" class="relation_link">
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
        <xsl:value-of select="tei:occupation"/>
        <xsl:text> </xsl:text>
      </td>

      <td class="inscriptions">

        <ul class="inline-list">
          <xsl:for-each
            select="//result/doc[arr[@name = 'persName-ref']/str[substring-after(text(), '#') = current()/@xml:id]]">
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
