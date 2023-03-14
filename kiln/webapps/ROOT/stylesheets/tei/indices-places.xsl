<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>
  <xsl:param name="ancient-lang" select="'n/a'"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitlePlaces">
    <xsl:choose>
      <xsl:when test="$index='places'">
        <i18n:text>Mentioned places</i18n:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndexPlaces">
    <xsl:call-template name="indices_bracket_info"/>
    <dl class="indices indices-places">
      <xsl:for-each select="//AL//tei:place[@xml:id=(//result//doc//str[@name='places-key'])]">
        <dt>
          <xsl:choose>
            <xsl:when test="count(tei:placeName[@xml:lang])>1">
              <xsl:value-of
                select="translate(string-join(tei:placeName[@xml:lang='grc'], ','),'.','')"/>
              <xsl:if test="tei:placeName[@xml:lang='la']">
                <xsl:text> / </xsl:text>
                <xsl:value-of
                  select="translate(string-join(tei:placeName[@xml:lang='la'], ', '),'.','')"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="translate(string-join(tei:placeName, ', '),'.','')"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="tei:placeName[@xml:lang=$lang]">
            <xsl:text> (</xsl:text>
            <xsl:value-of
              select="translate(string-join(tei:placeName[@xml:lang=$lang], ', ') ,'.','')"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test="tei:idno[@type='pleiades']">
            <xsl:text> [</xsl:text>
            <a href="{tei:idno[@type='pleiades']}">Pleiades</a>
            <xsl:text>]</xsl:text>
          </xsl:if>
        </dt>
        <xsl:choose>
          <xsl:when test="@xml:id">
            <xsl:for-each-group select="//result//doc[str[@name='places-key']=current()/@xml:id]"
              group-by="str[@name='places']">
              <dd>
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text> </xsl:text>
                <ul class="inline-list">
                  <xsl:for-each select="current-group()">
                    <xsl:sort select="str[@name='tei-id']"/>
                    <li>
                      <xsl:call-template name="link2inscription"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </dd>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </dl>


  </xsl:template>

</xsl:stylesheet>
