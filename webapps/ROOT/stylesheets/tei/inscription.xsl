<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/" />

    <xsl:template name="inscriptionnav">
      <xsl:variable name="nextlabel">
        <xsl:value-of select="if ($lang='ru') then 'Следующая' else 'Next'"/>
      </xsl:variable>
      <xsl:variable name="prevlabel">
        <xsl:value-of select="if ($lang='ru') then 'Предыдущая' else 'Previous'"/>
      </xsl:variable>
      <xsl:variable name="placeholder">
        <xsl:value-of select="if ($lang='ru') then 'Надпись №' else 'Inscription #'"/>
      </xsl:variable>
      <xsl:variable name="golabel">
        <xsl:value-of select="if ($lang='ru') then 'Найти' else 'Go'"/>
      </xsl:variable>

      <div class="row">

        <!-- prev -->
        <div class="large-1 columns">
          <ul class="pagination">
            <xsl:choose>
              <xsl:when test="//prev_inscr//str[@name='inscription'][text()=substring-before($filename, '.xml')]/preceding::str[@name='inscription'][1]">
                <li class="arrow"><a href="{concat(//prev_inscr//str[@name='inscription'][text()=substring-before($filename, '.xml')]/preceding::str[@name='inscription'][1], if ($lang='ru') then '-ru' else())}.html">
                  &#171;
                  <xsl:value-of select="$prevlabel" /></a>
                </li>
              </xsl:when>
              <xsl:otherwise>
                <li class="arrow unavailable"><a href="">
                  &#171;
                  <xsl:value-of select="$prevlabel" /></a>
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
                <a href="#" class="button prefix"><xsl:value-of select="$golabel" /></a>
              </div>
            </form>
          </div>
        </div>

        <!-- next -->
        <div class="large-1 columns">
          <ul class="pagination">
            <xsl:choose>
              <xsl:when test="//next_inscr//str[@name='inscription'][not(text()=substring-before($filename, '.xml'))]">
                <li class="arrow"><a href="{concat(//next_inscr//str[@name='inscription'], if ($lang='ru') then '-ru' else())}.html">
                  <xsl:value-of select="$nextlabel" />
                  &#187;</a>
                </li>
              </xsl:when>
              <xsl:otherwise>
                <li class="arrow unavailable"><a href="">
                  <xsl:value-of select="$nextlabel" />
                  &#187;</a>
                </li>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </div>
        <div class="large-8 columns" />
      </div>
    </xsl:template>

</xsl:stylesheet>