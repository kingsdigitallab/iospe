<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitlePerson">
    <xsl:choose>
      <xsl:when test="$index='ruler' and //arr[@name='persName-type']/str='ruler'">
        <i18n:text>Rulers of Rome, Byzantium or Bosporan Kingdoms</i18n:text>
      </xsl:when>
      <xsl:when test="$index='divine' and //arr[@name='persName-type']/str='divine'">
        <i18n:text>Divine, religious or mythic figures</i18n:text>
      </xsl:when>
      <xsl:when test="$index='persons'">
        <i18n:text>Attested Persons</i18n:text>
      </xsl:when>
    </xsl:choose>
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
              <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang=$lang])"/>
            </xsl:attribute>
            <xsl:value-of select="tei:head[@xml:lang=$lang]"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  <!-- Generate Index -->
  <xsl:template name="generateIndexPerson">
    <xsl:choose>
      <!-- divine -->
      <xsl:when test="$index='divine'">
        <xsl:for-each select="//AL//tei:listPerson">
          <dl class="indices indices-person">
            <xsl:for-each
              select="tei:person[not(@xml:id) or @xml:id=(//result//doc/arr[@name='persName-key']/str)]">
              <xsl:sort
                select="concat( 
                          upper-case(
                            replace(
                              normalize-unicode(
                                normalize-space(tei:persName[@xml:lang=$lang]),'NFKD'),
                              '[^A-Za-z0-9А-Яа-я ]','')), 
                          'ЯЯЯ')"/>
              <xsl:call-template name="character"/>
            </xsl:for-each>
          </dl>
        </xsl:for-each>
      </xsl:when>

      <!-- ruler -->
      <xsl:when test="$index='ruler'">
        <div class="section-container tabs" data-section="tabs" data-options="deep_linking: false;">
          <section>
            <xsl:attribute name="class">
              <xsl:if test="$sort=('date', '')">
                <xsl:text>active</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <p class="title" data-section-title="true">
              <a href="?sort=date">Date</a>
            </p>
            <div class="content" data-section-content="true">
              <xsl:call-template name="group_pagination">
                <xsl:with-param name="prefix">date_</xsl:with-param>
              </xsl:call-template>
              <xsl:for-each select="//AL//tei:listPerson">
                <h3>
                  <a>
                    <xsl:attribute name="name">
                      <xsl:text>date_</xsl:text>
                      <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang=$lang])"/>
                    </xsl:attribute>
                    <xsl:value-of select="tei:head[@xml:lang=$lang]"/>
                  </a>
                </h3>
                <dl class="indices indices-person">
                  <xsl:for-each
                    select="tei:person[not(@xml:id) or @xml:id=(//result//doc/arr[@name='persName-key']/str)]">
                    <xsl:sort select="concat(tei:floruit[tei:seg[@xml:lang=$lang]]/@notBefore, 'X')"/>
                    <xsl:sort select="tei:floruit[tei:seg[@xml:lang=$lang]]/@notAfter"/>
                    <xsl:call-template name="character"/>
                  </xsl:for-each>
                </dl>
              </xsl:for-each>
            </div>
          </section>
          <section>
            <xsl:attribute name="class">
              <xsl:if test="$sort=('name')">
                <xsl:text>active</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <p class="title" data-section-title="true">
              <a href="?sort=name">Name</a>
            </p>
            <div class="content" data-section-content="true">
              <xsl:call-template name="group_pagination">
                <xsl:with-param name="prefix">name_</xsl:with-param>
              </xsl:call-template>
              <xsl:for-each select="//AL//tei:listPerson">
                <h3>
                  <a>
                    <xsl:attribute name="name">
                      <xsl:text>name_</xsl:text>
                      <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang=$lang])"/>
                    </xsl:attribute>
                    <xsl:value-of select="tei:head[@xml:lang=$lang]"/>
                  </a>
                </h3>
                <dl class="indices indices-person">
                  <xsl:for-each
                    select="tei:person[not(@xml:id) or @xml:id=(//result//doc/arr[@name='persName-key']/str)]">
                    <xsl:sort
                      select="concat(upper-case(replace(normalize-unicode(normalize-space(tei:persName[@xml:lang=$lang]),'NFKD'),'[^A-Za-z0-9А-Яа-я ]','')), 'ЯЯЯ')"/>
                    <xsl:call-template name="character"/>
                  </xsl:for-each>
                </dl>
              </xsl:for-each>
            </div>
          </section>
        </div>
      </xsl:when>


      <!-- attested persons -->

      <xsl:when test="$index='persons'">
        <div class="section-container tabs" data-section="tabs" data-options="deep_linking: false;">
          <section>
            <xsl:attribute name="class">
              <xsl:if test="$sort='date'">
                <xsl:text>active</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <p class="title" data-section-title="true">
              <a href="?sort=date">sort by date</a>
            </p>
            <xsl:if test="$sort='date'">
              <div class="content" data-section-content="true">
                <table class="indices indices-person">
                  <thead>
                    <tr>
                      <th>
                        <xsl:text> </xsl:text>
                      </th>
                      <th>
                        <i18n:text>Name</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Flourit</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Relationships</i18n:text>
                      </th>

                      <th>
                        <i18n:text>Occupation</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Inscriptions</i18n:text>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//persons//tei:person">
                      <xsl:sort
                        select="concat(tei:floruit[tei:seg[@xml:lang=$lang]]/@notBefore, 'X')"/>
                      <xsl:sort select="tei:floruit[tei:seg[@xml:lang=$lang]]/@notAfter"/>
                      <xsl:call-template name="person"/>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </xsl:if>
          </section>
          <section>
            <xsl:attribute name="class">
              <xsl:if test="$sort=('name', '')">
                <xsl:text>active</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <p class="title" data-section-title="true">
              <a href="?sort=name">sort by name</a>
            </p>
            <xsl:if test="$sort=('name', '')">
              <div class="content" data-section-content="true">
                <table class="indices indices-person">
                  <thead>
                    <tr>
                      <th>
                        <xsl:text> </xsl:text>
                      </th>
                      <th>
                        <i18n:text>Name</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Flourit</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Relationships</i18n:text>
                      </th>

                      <th>
                        <i18n:text>Occupation</i18n:text>
                      </th>
                      <th>
                        <i18n:text>Inscriptions</i18n:text>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//persons//tei:person">
                      <xsl:sort
                        select="concat(upper-case(replace(normalize-unicode(normalize-space(tei:persName[@xml:lang=$lang]),'NFKD'),'[^A-Za-z0-9А-Яа-я ]','')), 'ЯЯЯ')"/>
                      <xsl:call-template name="person"/>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </xsl:if>
          </section>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="character">
    <dt>
      <xsl:choose>
        <xsl:when test="count(tei:persName[not(@type)][@xml:lang])>1">
          <xsl:value-of select="string-join( tei:persName[not(@type)][@xml:lang='grc'], ', ')"/>
          <xsl:if test="tei:persName[not(@type)][@xml:lang='la']">
            <xsl:text> / </xsl:text>
            <xsl:value-of select="string-join(tei:persName[not(@type)][@xml:lang='la'], ', ')"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string-join(tei:persName[not(@type)], ', ')"/>
        </xsl:otherwise>
      </xsl:choose>
    </dt>

    <xsl:if test="tei:floruit">
      <dd class="floruit">

        <span class="person_detail_label">
          <i18n:text>Attested</i18n:text>
        </span>
        <xsl:text> </xsl:text>

        <xsl:value-of select="tei:floruit"/>
        <xsl:text> </xsl:text>
      </dd>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@xml:id">
        <xsl:for-each-group select="//result//doc[arr[@name='persName-key']/str=current()/@xml:id]"
          group-by="arr[@name='persName-full']/str">
          <dd class="row">
            <div class="large-4 columns">
              <span class="person_detail_label">
                <i18n:text>Full Name</i18n:text>
              </span>
              <xsl:text> </xsl:text>

              <xsl:value-of select="current-grouping-key()"/>
            </div>
            <div class="large-8 columns inscriptions">

              <span class="person_detail_label">
                <i18n:text>Inscriptions</i18n:text>
              </span>
              <xsl:text> </xsl:text>

              <ul class="inline-list">
                <xsl:for-each-group select="current-group()"
                  group-by="concat(str[@name='tei-id'], 
                                   '.', 
                                   string-join(arr[@name='divloc']/str, '.'), 
                                   '.', 
                                   str[@name='line'])">

                  <xsl:sort select="str[@name='tei-id']"/>
                  <li>
                    <xsl:call-template name="link2inscription"/>
                  </li>
                </xsl:for-each-group>
              </ul>
            </div>
          </dd>

        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <dd> See: <xsl:choose>
            <xsl:when
              test="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/count(tei:persName[@xml:lang])>1">
              <xsl:value-of
                select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[@xml:lang='grc'][1]"/>
              <xsl:if
                test="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[not(@type)][@xml:lang='la']">
                <xsl:text> / </xsl:text>
                <xsl:value-of
                  select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[@xml:lang='la'][1]"
                />
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[1]"
              />
            </xsl:otherwise>
          </xsl:choose>
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="person">
    <tr class="index_row row">
      <th id="{@xml:id}" class="large-2 columns">
        <xsl:value-of select="string-join(tei:persName[@xml:lang=$lang], ', ')"/>
        <xsl:text> </xsl:text>
      </th>


      <td class="persName">
        <xsl:for-each select="tei:persName[@xml:lang!='en'][@xml:lang!='ru']">
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:text> </xsl:text>
      </td>

      <td class="flourit">
        <xsl:value-of select="tei:floruit/tei:seg[@xml:lang=$lang]"/>
        <xsl:text> </xsl:text>
      </td>

      <td class="relations">
        <xsl:for-each
          select="//persons/descendant::tei:relation[substring-after(@active, '#')=current()/@xml:id]">
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
          </xsl:choose>
          <!-- space after relationship -->
          <xsl:text> </xsl:text>

          <xsl:variable name="passives" select="tokenize(substring-after(@passive, '#'), ' #')"
            as="xs:sequence"/>

          <xsl:for-each select="//persons/descendant::tei:person[@xml:id=$passives]">
            <a href="#{@xml:id}" class="relation_link">
              <xsl:value-of select="tei:persName[@xml:lang=$lang]"/>
            </a>
            <xsl:if test="following::tei:person[@xml:id=$passives]">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>

          <xsl:if test="following::tei:relation[@active=current()/@active]">
            <xsl:text>; </xsl:text>
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
            select="//result/doc[arr[@name='persName-ref']/str[substring-after(text(), '#') = current()/@xml:id]]">
            <xsl:sort select="str[@name='tei-id']"/>
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
