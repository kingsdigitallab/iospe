<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:ex="http://apache.org/cocoon/exception/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add specific error messages for known problems related to not
       found resources. -->

  <xsl:param name="base-uri" />
  <xsl:param name="repository" />
  <xsl:param name="server" />

  <xsl:template match="ex:exception-report/ex:message">
    <xsl:choose>
      <xsl:when test="contains(//ex:stacktrace, '/content/xml/tei/inscriptions/')">       
        <xsl:copy>
          <p>Sorry, we could not find that inscription.</p>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <p>Sorry, we could not find the page you requested.</p>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
