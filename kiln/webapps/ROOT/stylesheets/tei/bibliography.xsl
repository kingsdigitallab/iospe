<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:import href="../common/conversions.xsl"/>

  <xsl:template match="/"/>

  <xsl:template name="bibliographyTitle">
    <i18n:text>Bibliography</i18n:text>
  </xsl:template>

  <xsl:template name="generateBibliography">
  </xsl:template>

</xsl:stylesheet>
