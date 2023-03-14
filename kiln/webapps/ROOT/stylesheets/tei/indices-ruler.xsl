<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">


  <xsl:import href="indices-person.xsl"/>

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:param name="lang"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitlePerson">
    <i18n:text>Rulers</i18n:text>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexPerson">

    <xsl:call-template name="indices_bracket_info"/>




    <div class="section-container tabs" data-section="tabs" data-options="deep_linking: false;">
      <section>
        <xsl:attribute name="class">
          <xsl:if test="
              $sort = ('date',
              '')">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="?sort=date">
            <i18n:text>Sort by date</i18n:text>
          </a>
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
                  <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang = $lang])"/>
                </xsl:attribute>
                <xsl:value-of select="tei:head[@xml:lang = $lang]"/>
              </a>
            </h3>
            <div class="row">
              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <i18n:text>Reign</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Attested name and titles</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Inscriptions</i18n:text>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each
                    select="tei:person[not(@xml:id) or @xml:id = (//result//doc/arr[@name = 'persName-key']/str)]">
                    <xsl:sort
                      select="concat(tei:floruit[tei:seg[@xml:lang = $lang]]/@notBefore, 'X')"/>
                    <xsl:sort select="tei:floruit[tei:seg[@xml:lang = $lang]]/@notAfter"/>
                    <xsl:call-template name="character"/>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </xsl:for-each>
        </div>
      </section>
      <section>
        <xsl:attribute name="class">
          <xsl:if test="$sort = ('name')">
            <xsl:text>active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <p class="title" data-section-title="true">
          <a href="?sort=name">
            <i18n:text>Sort by name</i18n:text>
          </a>
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
                  <xsl:value-of select="iospe:normalise_id(tei:head[@xml:lang = $lang])"/>
                </xsl:attribute>
                <xsl:value-of select="tei:head[@xml:lang = $lang]"/>
              </a>
            </h3>
            <div class="row">
              <table class="indices indices-person">
                <thead>
                  <tr>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                    <th>
                      <i18n:text>Reign</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Attested name and titles</i18n:text>
                    </th>
                    <th>
                      <i18n:text>Inscriptions</i18n:text>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each
                    select="tei:person[not(@xml:id) or @xml:id = (//result//doc/arr[@name = 'persName-key']/str)]">
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
                        '[^A-Za-z0-9А-Яа-я ]', '')
                        ),
                        'ЯЯЯ')"/>
                    <xsl:call-template name="character"/>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </xsl:for-each>
        </div>
      </section>
    </div>

  </xsl:template>
  
  <xsl:template match="tei:idno" mode="prosopography-link">
    
  </xsl:template>


  <xsl:template match="
      tei:idno[@type = ('wp',
      'wp-ru')]" mode="prosopography-link">

    <xsl:choose>
      <xsl:when
        test="($lang = 'ru' and self::node()[@type = 'wp-ru']) or ($lang = 'en' and self::node()[@type = 'wp'])">
        <sup>
          <a>
            <xsl:attribute name="href" select="text()"/>
            <i class="fa fa-external-link">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>
            <i18n:text>Wikipedia</i18n:text>
          </a>
        </sup>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="tei:idno[@type = 'snap']" mode="prosopography-link">

    <sup>
      <a>
        <xsl:attribute name="href" select="text()"/>
        <i class="fa fa-external-link">
          <xsl:text> </xsl:text>
        </i>
        <xsl:text> </xsl:text>
        <i18n:text>Snap</i18n:text>
      </a>
    </sup>

  </xsl:template>

  <xsl:template name="character">

    <xsl:variable name="person-xml-id" select="@xml:id"/>

    <xsl:variable name="persname_lang">
      <xsl:value-of select="tei:persName[@xml:lang = $lang]"/>
      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:variable name="persname_grc">
      <xsl:value-of select="tei:persName[@xml:lang = 'grc']"/>
      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:variable name="persname_la">
      <xsl:value-of select="tei:persName[@xml:lang = 'la']"/>
      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:variable name="persname-links">
      <xsl:apply-templates select="tei:idno" mode="prosopography-link"/>
    </xsl:variable>


    <xsl:variable name="floruit">
      <xsl:value-of select="tei:floruit"/>
      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@xml:id">
        <xsl:for-each-group
          select="//result//doc[arr[@name = 'persName-key']/str = current()/@xml:id]"
          group-by="arr[@name = 'persName-full']/str">
          <tr class="index_row">
            <xsl:attribute name="data-group-index" select="position()"/>
            <xsl:attribute name="id" select="concat('ruler.xml#', $person-xml-id)"/>
            <xsl:if test="position() = 1">
              <th>
                <xsl:attribute name="rowspan" select="last()"/>
                <xsl:value-of select="$persname_lang"/>
                <xsl:text> </xsl:text>

                <xsl:sequence select="$persname-links"/>
              </th>

              <td>
                <xsl:attribute name="rowspan" select="last()"/>
                <xsl:value-of select="$floruit"/>
                <xsl:text> </xsl:text>
              </td>

            </xsl:if>


            <xsl:variable name="offset">
              <xsl:if test="position() > 1">
                <xsl:text>large-offset-7</xsl:text>
              </xsl:if>
            </xsl:variable>

            <td class="full_name ">
              <xsl:value-of select="current-grouping-key()"/>
            </td>
            <td class="inscriptions">

              <ul class="inline-list">
                <xsl:for-each-group select="current-group()"
                  group-by="
                    concat(str[@name = 'tei-id'],
                    '.',
                    string-join(arr[@name = 'divloc']/str, '.'),
                    '.',
                    str[@name = 'line'])">

                  <xsl:sort select="str[@name = 'tei-id']"/>
                  <li>
                    <xsl:call-template name="link2inscription"/>
                  </li>
                </xsl:for-each-group>
                <xsl:text> </xsl:text>
              </ul>
            </td>
          </tr>

        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <tr class="index_row">
          <th>
            <xsl:value-of select="$persname_lang"/>
            <xsl:text> </xsl:text>
            <small>
              <i18n:text>see</i18n:text>
              <xsl:text>: </xsl:text>
              <xsl:choose>
                <xsl:when
                  test="//AL//tei:person[@xml:id = substring-after(current()/@sameAs, '#')]/count(tei:persName[@xml:lang]) > 1">
                  <xsl:value-of
                    select="//AL//tei:person[@xml:id = substring-after(current()/@sameAs, '#')]/tei:persName[@xml:lang = 'grc'][1]"/>
                  <xsl:if
                    test="//AL//tei:person[@xml:id = substring-after(current()/@sameAs, '#')]/tei:persName[not(@type)][@xml:lang = 'la']">
                    <xsl:text> / </xsl:text>
                    <xsl:value-of
                      select="//AL//tei:person[@xml:id = substring-after(current()/@sameAs, '#')]/tei:persName[@xml:lang = 'la'][1]"
                    />
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="//AL//tei:person[@xml:id = substring-after(current()/@sameAs, '#')]/tei:persName[1]"
                  />
                </xsl:otherwise>
              </xsl:choose>
            </small>
          </th>

          <td>
            <xsl:attribute name="rowspan" select="last()"/>
            <xsl:choose>
              <xsl:when test="not(normalize-space($persname_la) = '')">
                <xsl:value-of select="$persname_la"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$persname_grc"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
          </td>

          <td>
            <xsl:attribute name="rowspan" select="last()"/>
            <xsl:value-of select="$floruit"/>
            <xsl:text> </xsl:text>
          </td>


          <td class="full_name">
            <xsl:text> </xsl:text>
          </td>
          <td class="inscriptions">
            <xsl:text> </xsl:text>
          </td>
        </tr>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
