<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:ex="http://apache.org/cocoon/exception/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add specific error messages for known problems related to not
       found resources. -->

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
        <xsl:copy>
          <h4>we could not find inscription "<xsl:value-of select="$insc"/>" - please check the number.</h4>
          <h4>The currently available inscriptions are <a href="/corpora/byzantine/locations.html" style="text-decoration: underline;">listed here</a></h4>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <h4>we could not find the page you requested.</h4>
          <h4>Go to the <a href="/index.html" style="text-decoration: underline;">home page</a></h4>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
