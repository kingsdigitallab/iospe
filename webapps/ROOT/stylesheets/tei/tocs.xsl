<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="toc"/>

  <xsl:import href="../common/conversions.xsl"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="tocTitle">
    <xsl:choose>
      <xsl:when test="$toc='home'">
        <i18n:text>Tables of Contents</i18n:text>
      </xsl:when>
      <xsl:when test="$toc='document-type'">
        <i18n:text>Inscriptions by Category of Text</i18n:text>
      </xsl:when>
      <xsl:when test="$toc='monument-type'">
        <i18n:text>Inscriptions by Monument Type</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="tocNav">
    <xsl:choose>
      <xsl:when test="//century">
        <!-- list of available date groups  -->
        <ul class="letters pagination">
          <li>
            <a href="dated.html">
              <i18n:text>Dated by year</i18n:text>
            </a>
          </li>
        </ul>
        <xsl:if test="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
          <ul class="letters pagination">
            <li>
              <i18n:text>By century: BCE</i18n:text>
            </li>
            <xsl:for-each
              select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
              <xsl:sort select="//century[@url=current()]/@num" data-type="number"
                order="descending"/>
              <li>
                <a href="{.}.html">
                  <xsl:value-of select="substring-before(., '-')"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <ul class="letters pagination">
          <li>
            <i18n:text>By century: CE</i18n:text>
          </li>
          <xsl:for-each
            select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'CE']">
            <xsl:sort select="//century[@url=current()]/@num" data-type="number"/>
            <li>
              <a href="{.}.html">
                <xsl:value-of select="substring-before(., '-')"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:when>
      <xsl:when test="//letters">
        <!-- list of available letters  -->
        <ul class="letters pagination">
          <xsl:for-each select="//letters/letter">
            <li>
              <a href="{.}{$kiln:url-lang-suffix}.html">
                <xsl:value-of select="."/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
