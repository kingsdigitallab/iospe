<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Returns available letters in index. -->
  
  <xsl:param name="type">foo</xsl:param>

  <xsl:template match="/">
    <letters>
      <xsl:attribute name="type" select="$type"/>
      <xsl:for-each
        select="distinct-values(
                if (//str[@name='first-letter-grc'])
                then //str[@name='first-letter-grc']
                else
                  if (//str[@name='first-letter'])
                  then (//str[@name='first-letter'])
                  else //arr[@name='date-type']/str
                )">
        <xsl:sort select="."/>
        <letter>
          <xsl:value-of select="."/>
        </letter>
      </xsl:for-each>
    </letters>
  </xsl:template>

</xsl:stylesheet>
