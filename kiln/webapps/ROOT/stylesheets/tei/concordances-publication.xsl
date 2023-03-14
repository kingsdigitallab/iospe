<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="bibliography.xsl"/>

  <xsl:param name="concordance"/>


  <xsl:template match="/"/>

  <xsl:template name="concordancePublicationTitle">
    
    <xsl:value-of select="(//str[@name=concat('bibl-short-',$lang)])[1]"/>
  </xsl:template>


  <xsl:template name="generatePublicationConcordance">
    <p class="reference">
      <xsl:apply-templates
        select="/aggregation/bib/tei:TEI//tei:listBibl/(tei:biblStruct | tei:bibl)[@xml:id = current()//str[@name='bibl-target']]"
      />
    </p>

    <xsl:variable name="distinct-publications">
      <xsl:for-each-group select="//doc" group-by="str[@name='publications']">
        <xsl:sort select="iospe:publication-sort(normalize-space(current-grouping-key()))"
          data-type="number" order="ascending"/>

        <publication>
          <xsl:attribute name="publication-id">
            <xsl:value-of select="current-grouping-key()"/>
          </xsl:attribute>
          <!--<debug>
            <xsl:value-of select="iospe:publication-sort(current-grouping-key())"/>
          </debug>-->

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
          <xsl:variable name="volnum" select="str[@name='volume']"/>
          <td class="head">
            <xsl:value-of select="@publication-id"/>
          </td>
          <!--<td>
            <xsl:value-of select="debug"/>
          </td>-->
          <td>
            <ul class="inline-list">
              <xsl:for-each select="distinct-values(str[@name='tei-id'])">
                <li>
                  <a href="../../{.}.html">
                    <xsl:choose><xsl:when test="$volnum = 5">
                      <xsl:number value="substring-before(.,'.')" format="I"/>
                    <xsl:text>&#xa0;</xsl:text>
                    <xsl:number value="substring-after(.,'.')" format="1"/>
                    </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
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
  <xsl:function name="iospe:roman-character-impl-value" as="xs:double">
    <xsl:param name="character" as="xs:string"/>
    <xsl:variable name="lcharacter" select="lower-case($character)"/>
    <xsl:choose>
      <xsl:when test="$lcharacter = 'i'">
        <xsl:number value="1" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'v'">
        <xsl:number value="5" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'x'">
        <xsl:number value="10" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'l'">
        <xsl:number value="50" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'c'">
        <xsl:number value="100" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'd'">
        <xsl:number value="500" format="1"/>
      </xsl:when>
      <xsl:when test="$lcharacter = 'm'">
        <xsl:number value="1000" format="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number value="0" format="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="iospe:roman-to-arabic-impl" as="xs:double">
    <xsl:param name="roman" as="xs:string"/>
    <xsl:param name="i" as="xs:double"/>
    <xsl:param name="prev" as="xs:double"/>

    <xsl:variable name="current-value" as="xs:double"
      select="if ($i &gt; 0 and $i &lt;= string-length($roman))
      then iospe:roman-character-impl-value(substring($roman, $i, 1))
      else 0"/>


    <xsl:choose>

      <xsl:when test="$i = 0">
        <xsl:sequence select="0"/>
      </xsl:when>
      <xsl:when test="$prev &lt;= $current-value ">
        <xsl:sequence
          select="iospe:roman-to-arabic-impl($roman, $i - 1, $current-value) + $current-value"/>
      </xsl:when>
      <xsl:when test="$prev &gt; $current-value ">
        <xsl:sequence
          select="iospe:roman-to-arabic-impl($roman, $i - 1, $current-value) - $current-value"/>
      </xsl:when>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="iospe:roman-to-arabic" as="xs:integer">
    <xsl:param name="roman" as="xs:string"/>
    <xsl:number value="iospe:roman-to-arabic-impl($roman, string-length($roman), 0)"/>

  </xsl:function>

  <xsl:function name="iospe:publication-sort">
    <xsl:param name="i" as="xs:string"/>

    <xsl:variable name="broken_i">
      <!-- xpath 2.0 regex cannot handle zero length matching strings, appending a bogus
        string to the end of $i is a hack to deal with that. -->
      <xsl:analyze-string select="concat(normalize-space($i), ' !!END!!')"
        regex="^(([ivxlcdmIVXLCDM]+)[\s\.])?(\d+)?([-–\.](\d+))?(\w+)?(\s!!END!!)$">
        <xsl:matching-substring>
          <!-- this sequence contains a large decimal number, it is composed of the addition of:
              - a conversion of roman numerals to decimal (e.g. XX) multiplied by a large number
              - a first arabic numeral set, separated by a space or a dot (e.g. 544) multiplied by a smaller number
              - a second arabic numeral set, separated by a hyphen or a dot (e.g -398)
              - a set of letters, converted to unicode code points and treated as decimal numbers. (abc)
            for example:
            20 (XX) * 100000000 + 544 * 10000 + 398 + 0.616263 (a = 61, b = 62, c = 63) = 2,005,440,398.61626,

            That number is used as the sorting key. Every part of the number is optional. -->
          <xsl:sequence
            select="
            number(concat('0', iospe:roman-to-arabic(regex-group(2)))) * 100000000 +
            number(concat('0', regex-group(3))) * 10000 +
            number(concat('0', regex-group(5))) +
            number(concat('0.', string-join(for $x in string-to-codepoints(regex-group(6)) return string(format-number($x, '0000')), '')))"
          />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:sequence
            select="number(concat('0.', string-join(for $x in string-to-codepoints($i) return string($x), '')))"
          />
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:value-of select="$broken_i"/>
  </xsl:function>


</xsl:stylesheet>
