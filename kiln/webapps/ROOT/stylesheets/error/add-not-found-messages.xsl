<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:ex="http://apache.org/cocoon/exception/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add specific error messages for known problems related to not
       found resources. -->
  <xsl:param name="URIstring"/>
  <xsl:param name="base-uri"/>
  <xsl:param name="repository"/>
  <xsl:param name="server"/>

  <xsl:template match="ex:exception-report/ex:message">
    <xsl:choose>
      <xsl:when test="contains(//ex:stacktrace, '/content/xml/tei/inscriptions/')">
        <xsl:variable name="insc">
          <xsl:analyze-string select="//ex:stacktrace"
            regex="(/content/xml/tei/inscriptions/)([0-9]+\.[0-9a-zA-Z]+)\.xml">
            <xsl:matching-substring>
              <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="contains($URIstring, '-ru.')">
            <xsl:copy><h4>мы не смогли найти надпись "<xsl:value-of select="$insc"/>" - пожалуйста,
              проверьте, правильно ли Вы ввели номер.</h4><h4>Введите номер тома и надписи арабскими
                цифрами, разделив их точкой, например для Византийских Надписей (<a
                  href="/corpora/byzantine/locations-ru.html" style="text-decoration: underline;"
                  >том 5</a>), лемма 9,
                введите "5.9".</h4><h4>Вернуться на <a href="/index-ru.html"
                  style="text-decoration: underline;">Главную страницу</a>.</h4></xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <h4>we could not find inscription "<xsl:value-of select="$insc"/>" - please check if you entered the
                number correctly.</h4>
              <h4>Enter the volume and inscription numbers in arabic numerals, separated by a dot, e.g. for Byzantine inscriptions (<a
                  href="/corpora/byzantine/locations.html" style="text-decoration: underline;"
                  >volume 5</a>), lemma 9, enter "5.9".</h4>
              <h4>Go to the <a href="/index.html" style="text-decoration: underline;">home
                page</a></h4>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($URIstring, '-ru.')">
            <xsl:copy>
              <h4>мы не можем найти страницу, которую Вы запросили.</h4>
              <h4>Вернуться на <a href="/index-ru.html" style="text-decoration: underline;">Главную страницу</a>.</h4>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <h4>we could not find the page you requested.</h4>
              <h4>Go to the <a href="/index.html" style="text-decoration: underline;">home page</a></h4>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
