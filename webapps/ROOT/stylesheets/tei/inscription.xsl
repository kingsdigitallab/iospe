<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/" />

    <xsl:template name="inscriptionnav">
      <xsl:param name="next_inscr" />
      <xsl:param name="prev_inscr" />

      <xsl:variable name="nextlabel" select="if ($lang='ru') then 'Следующая' else 'Next'" />
      <xsl:variable name="prevlabel" select="if ($lang='ru') then 'Предыдущая' else 'Previous'"/>
      <xsl:variable name="placeholder" select="if ($lang='ru') then 'Надпись №' else 'Inscription #'"/>
      <xsl:variable name="golabel" select="if ($lang='ru') then 'Найти' else 'Go'"/>

      <div class="row">

        <!-- prev -->
        <div class="large-1 columns">
          <ul class="pagination">
            <xsl:choose>
              <xsl:when test="//prev_inscr//result/doc/str[@name='inscription']/text()">
                <li class="arrow">
                  <a href="{concat(//prev_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                    <xsl:text>&#171; </xsl:text>
                    <xsl:value-of select="$prevlabel" />
                  </a>
                </li>
              </xsl:when>
              <xsl:otherwise>
                <li class="arrow unavailable">
                  <a href="">
                    <xsl:text>&#171; </xsl:text>
                    <xsl:value-of select="$prevlabel" />
                  </a>
                </li>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </div>

        <!-- searchform -->
        <div class="large-2 columns">
          <div class="row collapse">
            <form id="jumpForm">
              <div class="small-8 columns">
                <input id="numTxt" name="numTxt" type="text" placeholder="{$placeholder}" />
              </div>
              <div class="small-4 columns">
                <a href="#" class="button prefix submit"><xsl:value-of select="$golabel" /></a>
              </div>
            </form>
          </div>
        </div>

        <!-- next -->
        <div class="large-9 columns">
          <ul class="pagination">
            <xsl:choose>
              <xsl:when test="//next_inscr//result/doc/str[@name='inscription']/text()">
                <li class="arrow">
                  <a href="{concat(//next_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                    <xsl:value-of select="$nextlabel" />
                    <xsl:text> &#187;</xsl:text>
                  </a>
                </li>
              </xsl:when>
              <xsl:otherwise>
                <li class="arrow unavailable">
                  <a href="">
                    <xsl:value-of select="$nextlabel" />
                    <xsl:text> &#187;</xsl:text>
                  </a>
                </li>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </div>
      </div>
    </xsl:template>

</xsl:stylesheet>