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
    <xsl:variable name="distinct-bibls">
      <xsl:for-each-group select="//doc" group-by="str[@name='tei-id']">
        <!-- Sorting here: too complex to determine one sorting field in Solr! -->
        <xsl:sort select="iospe:mixedSort(str[@name='publications'])" data-type="number"
          order="ascending"/>

        <doc>
          <xsl:sequence select="str[@name='tei-id']"/>
          <xsl:sequence select="str[@name='publications']"/>
        </doc>
      </xsl:for-each-group>
    </xsl:variable>

    <xsl:variable name="item-count" select="count($distinct-bibls/*)"/>

    <xsl:choose>
      <xsl:when test="$item-count >= 30">
        <div class="concordance">
          <xsl:call-template name="tpl-dl">
            <xsl:with-param name="col" select="1"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
          </xsl:call-template>
          <xsl:call-template name="tpl-dl">
            <xsl:with-param name="col" select="2"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
          </xsl:call-template>
          <xsl:call-template name="tpl-dl">
            <xsl:with-param name="col" select="3"/>
            <xsl:with-param name="item-count" select="$item-count"/>
            <xsl:with-param name="bibls" select="$distinct-bibls"/>
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="concordance">

          <dl>
            <xsl:call-template name="tpl-dl">
              <xsl:with-param name="col" select="1"/>
              <xsl:with-param name="item-count" select="$item-count"/>
              <xsl:with-param name="bibls" select="$distinct-bibls"/>
            </xsl:call-template>
          </dl>
        </div>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="tpl-dl">
    <xsl:param name="col"/>
    <xsl:param name="item-count"/>
    <xsl:param name="bibls"/>

    <xsl:variable name="div">
      <xsl:number value="ceiling($item-count div 3)"/>
    </xsl:variable>
    <xsl:variable name="bottom-limit">
      <xsl:number value="$div * ($col - 1)" format="0001"/>
    </xsl:variable>
    <xsl:variable name="top-limit">
      <xsl:number value="$div * $col" format="0001"/>
    </xsl:variable>
    <div class="large-4 columns col{$col}" xsl:exclude-result-prefixes="#all">

      <dl>
        <xsl:for-each-group select="$bibls/*[name()='doc']" group-by="str[@name='publications']">
          <xsl:variable name="item-pos">
            <xsl:number format="0001"/>
          </xsl:variable>
          <xsl:if test="$top-limit >= $item-pos and $item-pos > $bottom-limit">
            <dt>
              <xsl:value-of select="current-grouping-key()"/>
            </dt>
            <dd>
              <ul class="inline-list">
                <xsl:for-each select="current-group()">
                  <li>
                    <a href="../../{str[@name='tei-id']}.html">
                      <xsl:value-of select="substring-after(str[@name='tei-id'],'byz')"/>
                    </a>
                  </li>

                </xsl:for-each>
              </ul>
            </dd>
          </xsl:if>
        </xsl:for-each-group>
      </dl>
    </div>
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
