<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0">

  <xsl:param name="concordance"/>

  <xsl:template match="/"/>

  <xsl:template name="concordancePublicationTitle">
    <xsl:value-of select="(//str[@name=concat('bibl-short-',$lang)])[1]"/>
  </xsl:template>

  <xsl:template name="generatePublicationConcordance">
    <xsl:variable name="distinct-publications">
      <xsl:for-each-group select="//doc" group-by="str[@name='publications']">
        <xsl:sort select="iospe:mixedSort(current-grouping-key())" data-type="number"
          order="ascending"/>
        <publication>
          <xsl:attribute name="publication-id">
            <xsl:value-of select="current-grouping-key()"/>
          </xsl:attribute>
          <xsl:sequence select="current-group()/str[@name='tei-id']"/>
        </publication>
      </xsl:for-each-group>
    </xsl:variable>

    <xsl:variable name="item-count" select="count($distinct-publications/*)"/>
    <table class="concordance">
      <tbody>
        <xsl:choose>
          <xsl:when test="$item-count >= 30">

            <xsl:call-template name="tpl-dl">
              <xsl:with-param name="ncols" select="3"/>
              <xsl:with-param name="pubs" select="$distinct-publications"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="tpl-dl">
              <xsl:with-param name="ncols" select="1"/>
              <xsl:with-param name="pubs" select="$distinct-publications"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="tpl-dl">
    <xsl:param name="ncols"/>
    <xsl:param name="pubs"/>

    <xsl:for-each select="$pubs/*[name()='publication'][position() mod $ncols = 1 or $ncols = 1]">
      <tr xsl:exclude-result-prefixes="#all">
        <xsl:for-each select=". | following-sibling::publication[position() &lt; $ncols]">
          <td class="head">
            <xsl:value-of select="@publication-id"/>
          </td>

          <td>
            <ul class="inline-list">
              <xsl:for-each select="distinct-values(str[@name='tei-id'])">
                <li>
                  <a href="../../{.}.html">
                    <xsl:number value="substring-before(.,'.')" format="I"/>
                    <xsl:text>&#xa0;</xsl:text>
                    <xsl:number value="substring-after(.,'.')" format="1"/>
                    <!--<xsl:value-of select="substring-after(str[@name='tei-id'],'byz')"/>-->
                  </a>
                </li>

              </xsl:for-each>
            </ul>
          </td>
          <xsl:if test="position() = last() and last() &lt; $ncols">
            <!-- Fill with empty td's if table not complete -->
            <xsl:for-each select="position() + 1 to $ncols">
              <td class="head">
                <xsl:text> </xsl:text>
              </td>
              <td>
                <xsl:text> </xsl:text>
              </td>
            </xsl:for-each>
          </xsl:if>

        </xsl:for-each>
      </tr>
    </xsl:for-each>

  </xsl:template>

  <xsl:function name="iospe:mixedSort">
    <!-- Sorts mixed content for biblScope. Since the calling sort sorts by number,
            this function "cheats" by transforming strings into numbers > 10000 -->
    <xsl:param name="i"/>

    <xsl:choose>
      <!-- String -->
      <xsl:when test="string(number($i)) = 'NaN'">
        <xsl:choose>
          <!-- When range, try to get a number -->
          <xsl:when test="contains($i, '-') and string(number(substring-before($i, '-'))) != 'NaN'">
            <xsl:value-of select="substring-before($i, '-')"/>
          </xsl:when>
          <!-- Otherwise just compute an order for letters -->
          <xsl:otherwise>
            <xsl:value-of
              select="number(string-join(for $x in string-to-codepoints($i) return string($x), ''))"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$i"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


</xsl:stylesheet>
