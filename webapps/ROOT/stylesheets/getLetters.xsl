<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="lang"/>
    <!-- Returns available letters in index. -->
    
    <xsl:template match="/">
        <letters>
            <xsl:for-each select="distinct-values(
                if (//str[@name='first-letter-grc']) 
                then //str[@name='first-letter-grc'] 
                else 
                  if (//str[@name='first-letter'])
                  then (//str[@name='first-letter'])
                  else //arr[@name='date-type']/str
                )">
                <xsl:sort select="."/>
                <letter><xsl:value-of select="."></xsl:value-of></letter>
            </xsl:for-each>
        </letters>
    </xsl:template>
    
</xsl:stylesheet>
