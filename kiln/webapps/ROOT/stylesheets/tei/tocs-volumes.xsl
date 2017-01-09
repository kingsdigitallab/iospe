<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
    
    
    <!-- ***************************************************************************************************** -->
    <!-- Note that this stylesheet does not handle the TOC for volume 5; that is handled by tocs-locations.xsl -->
    <!-- ***************************************************************************************************** -->
    
    <xsl:import href="inscription.xsl"/>
    <xsl:param name="toc"/>
    <xsl:param name="url"/>
    <xsl:param name="lang"/>

    <xsl:template match="/"/>

    <!-- set title -->
    <xsl:template name="tocVolumeTitle">
        <xsl:choose>
            <xsl:when test="starts-with($url, '1')">
                I. <i18n:text>Inscriptions of Tyras and vicinity</i18n:text>
            </xsl:when>
            <xsl:when test="starts-with($url, '3')">
                III. <i18n:text>Inscriptions of Chersonesos and vicinity</i18n:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="generateVolumeToc">
        <dl class="tocs">
            <xsl:for-each select="//doc">
                <xsl:sort select="int[@name = 'sortable-id']" order="ascending"/>
                <dt>
                    <a href="/{str[@name='tei-id']}{$kiln:url-lang-suffix}.html">
                        <xsl:value-of select="str[@name = 'tei-id']"/>
                    </a>
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                        <xsl:when
                            test="translate(normalize-space(str[@name = concat('inscription-title-', $lang)]), ' ', '') = ''">
                            <xsl:text>[</xsl:text>
                            <i18n:text>no title</i18n:text>
                            <xsl:text>]</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="str[@name = concat('inscription-title-', $lang)]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </dt>
            </xsl:for-each>
        </dl>
    </xsl:template>

</xsl:stylesheet>
