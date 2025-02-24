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
            <xsl:when test="starts-with($url, '2')">
                II.1 <i18n:text>Inscriptions of Borysthenes (Berezan)<br/>Part 1 Collection of the State Hermitage Museum</i18n:text>
            </xsl:when>
            <xsl:when test="starts-with($url, '3')">
                III. <i18n:text>Inscriptions of Chersonesos and vicinity</i18n:text>
            </xsl:when>
            <!-- Nb we don't handle vol 5 here: see above -->
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
    
    
    <xsl:template name="generateTOCItems">
        <xsl:param name="values"/>
        <xsl:for-each select="$values">
            <xsl:variable name="number" select="string(current())"/>
            <dd>
               <a href="/{$number}{$kiln:url-lang-suffix}.html">
                <xsl:call-template name="formatInscrNum">
                    <xsl:with-param name="num" select="$number"/>
                    <xsl:with-param name="printCorpus" select="true()"/>
                </xsl:call-template>
                   
                   <xsl:text> </xsl:text>
                   
                <xsl:choose>
                    <xsl:when
                        test="translate(normalize-space($seq/node()/doc[str[@name='tei-id']=$number]/str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                        <xsl:text>[</xsl:text>
                        <i18n:text>no title</i18n:text>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="$seq/node()/doc[str[@name='tei-id']=$number]/str[@name=concat('inscription-title-', $lang)]"/>
                    </xsl:otherwise>
                </xsl:choose>
                   <xsl:if test="not($seq/node()/doc[str[@name='tei-id']=$number]/str[@name='inscription-has-date'] = 'yes')">
                       <xsl:choose>
                           <xsl:when
                               test="$seq/node()/doc[str[@name='tei-id']=$number]/arr[@name=concat('origDate-', 'en')]/str[1] = 'Unknown.'">
                               <xsl:text>.</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:text>, </xsl:text>
                               <!-- origDate -->
                               <xsl:value-of
                                   select="$seq/node()/doc[str[@name='tei-id']=$number]/arr[@name=concat('origDate-', $lang)]/str[1]"/>
                           </xsl:otherwise>
                       </xsl:choose>
                   </xsl:if>
               </a>
            </dd>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
