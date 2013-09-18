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
    <xsl:variable name="transformation">
      <xsl:choose>
        <xsl:when test="$index=('fragment', 'abbr')">
          <xsl:sequence select="$uppercase"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$lowercase"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <dl class="indices-abbrs">

      <xsl:for-each-group select="//doc"
        group-by="translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)">


        <xsl:if test="not(translate(str[@name='abbr'], ' ','') = '')">
          <dt>
            <xsl:value-of select="current-grouping-key()"/>
          </dt>

          <xsl:for-each-group
            select="//doc[translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)=current-grouping-key()]"
            group-by="translate(normalize-space(str[@name='expan']), '[].? - ', '')">
            <xsl:sort select="str[@name='expan-sort']"/>
            <dd>
              <xsl:value-of select="current-grouping-key()"/>
              <xsl:text> </xsl:text>
              <ul class="inline-list">
                <xsl:for-each
                  select="//doc[translate(normalize-space(str[@name='expan']), '[].? - ', '')=current-grouping-key()]">
                  <li>
                    <xsl:call-template name="link2inscription"/>
                  </li>
                </xsl:for-each>
              </ul>
            </dd>
          </xsl:for-each-group>
        </xsl:if>

      </xsl:for-each-group>
    </dl>


  </xsl:template>

</xsl:stylesheet>
