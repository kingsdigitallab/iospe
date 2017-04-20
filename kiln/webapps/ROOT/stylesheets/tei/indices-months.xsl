<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="lang"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitleMonths">
    <xsl:choose>
      <xsl:when test="$index='months'">
        <i18n:text>Months</i18n:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexMonths">
    <xsl:call-template name="indices_bracket_info"/>
    <table class="indices indices-months">
      <xsl:for-each select="//AL//list">

        <xsl:if test="count(descendant::month) > 0">
          <tbody>
            <tr class="index_row row">
              <th class="table_sub_heading" colspan="2">
                <xsl:value-of select="head[@xml:lang = $lang]"/>
              </th>
            </tr>


            <xsl:for-each select="descendant::month">
              <tr class="index_row row">
                <th>
                  <xsl:choose>
                    <xsl:when test="count(name[not(@type)][@xml:lang])>1">
                      <xsl:value-of select="name[not(@type)][@xml:lang='grc'][1]"/>
                      <xsl:if test="name[not(@type)][@xml:lang='la']">
                        <xsl:text> / </xsl:text>
                        <xsl:value-of select="name[not(@type)][@xml:lang='la'][1]"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="name[not(@type)][1]"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </th>
                <xsl:choose>
                  <xsl:when test="@xml:id">
                    <td>
                      <ul class="inline-list">
                        <xsl:for-each
                          select="//result//doc[str[@name='months-ref']=current()/@xml:id]">
                          <xsl:sort select="str[@name='tei-id']"/>
                          <li>
                            <xsl:call-template name="link2inscription"/>
                          </li>
                        </xsl:for-each>
                      </ul>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td>
                      <xsl:text>&#160;</xsl:text>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
            </xsl:for-each>
          </tbody>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>
