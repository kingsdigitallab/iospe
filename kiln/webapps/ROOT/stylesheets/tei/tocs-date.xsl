<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="toc"/>
  <xsl:param name="date-type"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="tocTitleDate">
    <i18n:text>Inscriptions by Date</i18n:text>
  </xsl:template>

  <xsl:template name="tocNav">
    <div class="pagination-centered">
      <ul class="date pagination">
        <xsl:choose>
          <xsl:when test="//century">
            <!-- list of available date groups  -->
            <li>
              <xsl:attribute name="class">
                <xsl:if test="$date-type='dated'">
                  <xsl:text>current</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <a href="dated.html">
                <i18n:text>Dated by year</i18n:text>
              </a>
            </li>

            <xsl:if test="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
              <li class="unavailable">
                <a href="#">
                  <i18n:text>By century: BCE</i18n:text>
                </a>
              </li>
              <xsl:for-each
                select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
                <xsl:sort select="//list[@xml:lang=$lang]/century[@url=current()]/@num"
                  data-type="number" order="descending"/>
                <li>
                  <xsl:attribute name="class">
                    <xsl:if test="current() = $date-type">
                      <xsl:text>current</xsl:text>
                    </xsl:if>
                  </xsl:attribute>
                  <a href="{.}.html">
                    <xsl:value-of select="substring-before(., '-')"/>
                  </a>
                </li>
              </xsl:for-each>
            </xsl:if>

            <xsl:if test="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'CE']">
              <li class="unavailable">
                <a href="#">
                  <i18n:text>By century: CE</i18n:text>
                </a>
              </li>
              <xsl:for-each
                select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'CE']">
                <xsl:sort select="//list[@xml:lang=$lang]/century[@url=current()]/@num"
                  data-type="number"/>
                <li>
                  <xsl:attribute name="class">
                    <xsl:if test="current() = $date-type">
                      <xsl:text>current</xsl:text>
                    </xsl:if>
                  </xsl:attribute>
                  <a href="{.}.html">
                    <xsl:value-of select="substring-before(., '-')"/>
                  </a>
                </li>
              </xsl:for-each>
            </xsl:if>
          </xsl:when>
          <xsl:when test="//letters">
            <!-- list of available letters  -->
            <xsl:for-each select="//letters/letter">
              <li>
                <a href="{.}{$kiln:url-lang-suffix}.html">
                  <xsl:value-of select="."/>
                </a>
              </li>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>


  <xsl:template name="generateTocDate">
    <!-- exclude duplicates (caused by multiple inscriptions within the same file with the same date) -->
    <dl class="indices indices-date tocs">
      <xsl:for-each-group
        select="//doc[not(str[@name='date-en'] = preceding-sibling::doc/str[@name='date-en'])
                                  and not(str[@name='file'] = preceding-sibling::doc/str[@name='file']) ]"
        group-by="int[@name='date-notBefore']">
        <xsl:sort select="int[@name='date-notBefore']"/>
        <xsl:for-each-group select="current-group()" group-by="int[@name='date-notAfter']">
          <xsl:sort select="int[@name='date-notAfter']"/>
          <xsl:if test="not(str[@name='tei-id'] = '')">
            <!-- Remove empty elements which might have been indexed -->
            <dt>
              <xsl:choose>
                <xsl:when test="str[@name=concat($toc,'-',$lang)]!=''">
                  <xsl:value-of select="str[@name=concat($toc,'-',$lang)]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[</xsl:text>
                  <i18n:text>date specified, but not spelled out</i18n:text>
                  <xsl:text>]</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </dt>
            <xsl:for-each select="current-group()">
              <xsl:sort select="int[@name='sortable-id']"/>
              <dd>
                <a href="/{str[@name='file']}.html">
                  <xsl:number value="substring-before(str[@name='tei-id'],'.')" format="I"/>
                  <xsl:text>&#xa0;</xsl:text>
                  <xsl:number value="substring-after(str[@name='tei-id'],'.')" format="1"/>

                  <xsl:text> </xsl:text>
                  <xsl:value-of select="arr[@name=concat('location-', $lang)]/str[1]"/>

                  <xsl:text>. </xsl:text>
                  <xsl:choose>
                    <xsl:when
                      test="translate(
                              normalize-space(str[@name=concat('inscription-title-', $lang)]),
                              ' ', '') = ''">
                      <xsl:text>[</xsl:text>
                      <i18n:text>no title</i18n:text>
                      <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text/>
                      <xsl:value-of select="str[@name=concat('inscription-title-', $lang)]"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </dd>

            </xsl:for-each>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </dl>
  </xsl:template>

</xsl:stylesheet>
