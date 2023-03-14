<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitleAbbrs">
    <xsl:choose>
      <xsl:when test="$index='abbr'">
        <i18n:text>Abbreviations</i18n:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexAbbrs">
    <xsl:call-template name="indices_bracket_info"/>

    <table class="indices indices-abbrs">
      <thead>
        <tr>
          <th>
            <i18n:text>Abbreviation</i18n:text>
          </th>
          <th>
            <i18n:text>Expands to</i18n:text>
          </th>
          <th>
            <i18n:text>References</i18n:text>
          </th>
        </tr>
      </thead>
      <tbody>


        <xsl:for-each-group select="//doc"
          group-by="translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)">
          <xsl:sort order="ascending"
            select="translate(normalize-unicode(current-grouping-key(),'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>


          <xsl:if test="not(translate(str[@name='abbr'], ' ','') = '')">
            <xsl:variable name="group-head">
              <xsl:value-of select="current-grouping-key()"/>
            </xsl:variable>

            <xsl:for-each-group
              select="//doc[translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)=current-grouping-key()]"
              group-by="translate(normalize-space(str[@name='expan']), '[].? - ', '')">
              <xsl:sort order="ascending"
                select="translate(normalize-unicode(str[@name='expan'],'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>

              <tr class="index_row">
                <xsl:choose>
                  <xsl:when test="position() = 1">
                    <th>
                      <xsl:value-of select="$group-head"/>
                    </th>
                  </xsl:when>
                  <xsl:otherwise>
                    <th>
                      <xsl:text> </xsl:text>
                    </th>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <xsl:value-of select="current-grouping-key()"/>
                </td>
                <td>
                  <ul class="inline-list">
                    <xsl:for-each
                      select="//doc[translate(normalize-space(str[@name='expan']), '[].? - ', '')=current-grouping-key()]">
                      <xsl:sort select="str[@name='tei-id']"/>
                      <li>
                        <xsl:call-template name="link2inscription"/>
                      </li>
                    </xsl:for-each>
                  </ul>
                </td>
              </tr>

            </xsl:for-each-group>
          </xsl:if>

        </xsl:for-each-group>
      </tbody>
    </table>


  </xsl:template>

</xsl:stylesheet>
