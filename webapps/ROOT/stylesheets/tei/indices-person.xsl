<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitlePerson">
    <xsl:choose>
      <xsl:when test="$index='ruler' and //str[@name='persName-type']='ruler'">
        <i18n:text>Rulers of Rome, Byzantium or Bosporan Kingdoms</i18n:text>
      </xsl:when>
      <xsl:when test="$index='divine' and //str[@name='persName-type']='divine'">
        <i18n:text>Divine, religious or mythic figures</i18n:text>
      </xsl:when>
      <xsl:when test="$index='persons'">
        <i18n:text>Attested Persons</i18n:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexPerson">
    <xsl:choose>
      <xsl:when test="$index=('divine', 'ruler')">
        <xsl:for-each select="//AL//tei:listPerson">
          <h2>
            <xsl:value-of select="tei:head[@xml:lang=$lang]"/>
          </h2>

          <dl class="indices-person">
            <xsl:for-each
              select="tei:person[not(@xml:id) or @xml:id=(//result//doc/str[@name='persName-key'])]">

              <dt>
                <xsl:choose>
                  <xsl:when test="count(tei:persName[not(@type)][@xml:lang])>1">
                    <xsl:value-of select="tei:persName[not(@type)][@xml:lang='grc'][1]"/>
                    <xsl:if test="tei:persName[not(@type)][@xml:lang='la']">
                      <xsl:text> / </xsl:text>
                      <xsl:value-of select="tei:persName[not(@type)][@xml:lang='la'][1]"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="tei:persName[not(@type)][1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </dt>


              <xsl:choose>
                <xsl:when test="@xml:id">
                  <xsl:for-each-group
                    select="//result//doc[str[@name='persName-key']=current()/@xml:id]"
                    group-by="str[@name='persName-full']">
                    <dd>
                      <xsl:value-of select="current-grouping-key()"/>
                      <xsl:text> </xsl:text>
                      <ul class="inline-list">
                        <xsl:for-each select="current-group()">
                          <li>
                            <xsl:call-template name="link2inscription"/>
                          </li>
                        </xsl:for-each>
                      </ul>
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

            </xsl:for-each>
          </dl>
        </xsl:for-each>



      </xsl:when>
      <xsl:when test="$index='persons' and $sort='date'">
        <xsl:call-template name="sort-option"/>
        <dl class="indices-person">
          <xsl:for-each select="//persons//tei:person">
            <xsl:sort select="concat(tei:floruit[tei:seg[@xml:lang=$lang]]/@notBefore, 'X')"/>
            <xsl:sort select="tei:floruit[tei:seg[@xml:lang=$lang]]/@notAfter"/>
            <xsl:call-template name="person"/>

          </xsl:for-each>
        </dl>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sort-option"/>
        <dl class="indices-person">
          <xsl:for-each select="//persons//tei:person">
            <xsl:sort
              select="concat(upper-case(replace(normalize-unicode(normalize-space(tei:persName[@xml:lang=$lang]),'NFKD'),'[^A-Za-z0-9А-Яа-я ]','')), 'ЯЯЯ')"/>
            <xsl:call-template name="person"/>

          </xsl:for-each>
        </dl>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <xsl:template name="person">
    <dt id="{@xml:id}">
      <xsl:value-of select="tei:persName[@xml:lang=$lang]"/>
    </dt>


    <dd>
      <xsl:for-each select="tei:persName[@xml:lang!='en'][@xml:lang!='ru']">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </dd>

    <xsl:if test="tei:floruit[tei:seg[@xml:lang=$lang]]">
      <dd>
        <i18n:text>Attested</i18n:text>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="tei:floruit/tei:seg[@xml:lang=$lang]"/>
        <xsl:text> </xsl:text>
      </dd>
    </xsl:if>


    <xsl:if test="tei:occupation">
      <dd>
        <xsl:value-of select="tei:occupation"/>
        <xsl:text> </xsl:text>
      </dd>
    </xsl:if>


    <xsl:variable name="passives" select="tokenize(substring-after(@passive, '#'), ' #')"
      as="xs:sequence"/>
    <xsl:if
      test="//persons/descendant::tei:relation[substring-after(@active, '#')=current()/@xml:id] or //persons/descendant::tei:person[@xml:id=$passives]">
      <dd class="relations">
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

          <xsl:for-each select="//persons/descendant::tei:person[@xml:id=$passives]">
            <a href="#{@xml:id}">
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
      </dd>
    </xsl:if>

    <dd class="inscriptions">
      <ul class="inline-list">
        <xsl:for-each
          select="//result/doc[substring-after(str[@name='persName-ref'], '#') = current()/@xml:id]">
          <li>
            <xsl:call-template name="link2inscription"/>
          </li>
        </xsl:for-each>
      </ul>
    </dd>


  </xsl:template>


</xsl:stylesheet>
