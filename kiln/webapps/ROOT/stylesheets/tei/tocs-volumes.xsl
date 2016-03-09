<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
    
    <xsl:param name="toc"/>
    
    <xsl:template match="/"/>
    
    <!-- set title -->
    <xsl:template name="tocVolumeTitle">
        <i18n:text>III. Inscriptions of Chersonesos and vicinity</i18n:text>
    </xsl:template>
    
    <xsl:template name="generateVolumeToc">
        <dl class="tocs">
            <xsl:for-each select="//doc">
                <xsl:sort select="int[@name='sortable-id']" order="ascending"/>
                <dt>
                    <a href="/{str[@name='file']}.html"><xsl:value-of select="str[@name='tei-id']"/></a> <xsl:choose>
                        <xsl:when
                            test="translate(normalize-space(str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                            <xsl:text>[</xsl:text>
                            <i18n:text>no title</i18n:text>
                            <xsl:text>]</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="str[@name=concat('inscription-title-', $lang)]"/>
                            <xsl:text></xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </dt>
            </xsl:for-each>
        </dl>
    </xsl:template>
    
</xsl:stylesheet>