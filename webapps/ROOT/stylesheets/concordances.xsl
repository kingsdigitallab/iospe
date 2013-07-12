<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
    xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
    xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!--
        Handles Concordances.
        Raffaele Viglianti; started on April 17 2012
    -->
    
    <xsl:import href="default.xsl" />
    <xsl:import href="common/conversions.xsl" />
            
    <xsl:param name="filedir" />
    <xsl:param name="filename" />
    <xsl:param name="fileextension" />
    <xsl:param name="lang" select="'en'" />
    
    <xsl:param name="concordance"/>
    
    <xsl:function name="iospe:mixedSort">
        <!-- Sorts mixed content for biblScope. Since the calling sort sorts by number,
            this function "cheats" by transforming strings into numbers > 10000 -->
        <xsl:param name="i"/>
        
        <xsl:choose>
            <!-- String -->
            <xsl:when test="string(number($i)) = 'NaN'">
                <xsl:choose>
                    <!-- When range, try to get a number -->
                    <xsl:when test="contains($i, '-') and string(number(substring-before($i, '-'))) != 'NaN'">
                        <xsl:value-of select="substring-before($i, '-')"/>
                    </xsl:when>
                    <!-- Otherwise just compute an order for letters -->
                    <xsl:otherwise>
                        <xsl:value-of select="number(string-join(
                            for $x in string-to-codepoints($i) return string($x), ''))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$i"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    <xsl:template name="tpl-list">
        <xsl:param name="col"/>
        <xsl:param name="item-count"/>
        <xsl:param name="bibls"/>
        
        <xsl:variable name="div">
            <xsl:number value="ceiling($item-count div 3)"/>
        </xsl:variable>
        <xsl:variable name="bottom-limit">
            <xsl:number value="$div * ($col - 1)" format="0001"/>
        </xsl:variable>
        <xsl:variable name="top-limit">
            <xsl:number value="$div * $col" format="0001"/>
        </xsl:variable>
        <!-- <div class="col{$col}" xsl:exclude-result-prefixes="#all" style="border-bottom: 1px solid grey"> -->
        <div class="col{$col}" xsl:exclude-result-prefixes="#all">
            <div class="unorderedList">
                <div class="t01">
                    <ul>
                        <xsl:for-each select="$bibls/*[name()='doc']">
                            <xsl:variable name="item-pos">
                                <xsl:number format="0001"/>
                            </xsl:variable>
                            <xsl:if test="$top-limit >= $item-pos and $item-pos > $bottom-limit">
                                <li>
                                    <a href="publications/{(str[@name='bibl-target'])[1]}.html">
                                        <xsl:value-of select="str[@name=concat('bibl-short-',$lang)]"/>
                                    </a>
                                </li>
                            </xsl:if>
                        </xsl:for-each>
                    </ul>
                </div>
            </div>
        </div>        
    </xsl:template>   

    <xsl:template name="tpl-dl">
        <xsl:param name="col"/>
        <xsl:param name="item-count"/>
        <xsl:param name="bibls"/>
        
        <xsl:variable name="div">
            <xsl:number value="ceiling($item-count div 3)"/>
        </xsl:variable>
        <xsl:variable name="bottom-limit">
            <xsl:number value="$div * ($col - 1)" format="0001"/>
        </xsl:variable>
        <xsl:variable name="top-limit">
            <xsl:number value="$div * $col" format="0001"/>
        </xsl:variable>
        <div class="col{$col}" xsl:exclude-result-prefixes="#all" style="border-bottom: 1px solid grey">
            <div class="unorderedList">
                <div class="t01">
                    <dl>
                        <xsl:for-each-group select="$bibls/*[name()='doc']" group-by="str[@name='publications']">
                            <xsl:variable name="item-pos">
                                <xsl:number format="0001"/>
                            </xsl:variable>
                            <xsl:if test="$top-limit >= $item-pos and $item-pos > $bottom-limit">
                                <dt>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </dt>
                                <dd>
                                    <xsl:for-each select="current-group()">
                                        <a href="../../{str[@name='tei-id']}.html">
                                            <xsl:value-of select="substring-after(str[@name='tei-id'],'byz')"/>
                                        </a>
                                    </xsl:for-each>
                                </dd>
                            </xsl:if>
                        </xsl:for-each-group>
                    </dl>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- set title -->
    <xsl:variable name="xmg:title">
        <xsl:choose>
            <xsl:when test="$concordance='home'">
                <xsl:value-of select="if ($lang='en') then 'Concordances' else 'RU: Concordances'"/>
            </xsl:when>
            <xsl:when test="$concordance='publications'">
                <xsl:value-of select="if ($lang='en') then 'Epigraphic editions of inscriptions, by author' else 'RU: Epigraphic editions of inscriptions, by author'"/>
            </xsl:when>
            <xsl:when test="$concordance='publication'">
                <xsl:value-of select="(//str[@name=concat('bibl-short-',$lang)])[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
        
    <!-- OVERRIDES -->
    <xsl:template name="xms:options1" />
    <xsl:template name="xms:options2" />
    
    <xsl:template name="xms:submenu" />
    
    <xsl:template name="xms:footnotes" />
    
    <xsl:template name="xms:content">
        
        <xsl:choose>
            <xsl:when test="$concordance='publications'">
                
                <xsl:variable name="distinct-bibls">
                    <xsl:for-each-group select="//doc" group-by="str[@name=concat('bibl-short-',$lang)]">
                        <xsl:sort select="str[@name=concat('bibl-short-',$lang)]" />
                        <!-- sorting here or solr?? -->
                        <!-- THIS MAY BE DONE IN SOLR if sorting value is bibl-short -->
                        <doc>
                            <xsl:sequence select="str[@name=concat('bibl-short-',$lang)]"/>
                            <xsl:sequence select="str[@name='bibl-target']"/>
                        </doc>
                    </xsl:for-each-group>
                </xsl:variable>
                
                <xsl:variable name="item-count" select="count($distinct-bibls/*)" />
                
                <xsl:choose>
                    <xsl:when test="$item-count >= 30">
                        <div class="cg">
                            <xsl:call-template name="tpl-list">
                                <xsl:with-param name="col" select="1"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>
                            <xsl:call-template name="tpl-list">
                                <xsl:with-param name="col" select="2"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>
                            <xsl:call-template name="tpl-list">
                                <xsl:with-param name="col" select="3"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>                                
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="resourceList">
                            <div class="t03">
                                <dl>
                                    <xsl:call-template name="tpl-list">
                                        <xsl:with-param name="col" select="1"/>
                                        <xsl:with-param name="item-count" select="$item-count"/>
                                        <xsl:with-param name="bibls" select="$distinct-bibls"/>
                                    </xsl:call-template>
                                </dl>
                            </div>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            <xsl:when test="$concordance='publication'">
                
                <xsl:variable name="distinct-bibls">
                    <xsl:for-each-group select="//doc" group-by="str[@name='tei-id']">
                        <!-- Sorting here: too complex to determine one sorting field in Solr! -->
                        <xsl:sort select="iospe:mixedSort(str[@name='publications'])" data-type="number" order="ascending" />
                        
                        <doc>
                            <xsl:sequence select="str[@name='tei-id']"/>
                            <xsl:sequence select="str[@name='publications']"/>
                        </doc>
                    </xsl:for-each-group>
                </xsl:variable>
                
                <xsl:variable name="item-count" select="count($distinct-bibls/*)" />
                
                <xsl:choose>
                    <xsl:when test="$item-count >= 30">
                        <div class="cg">
                            <xsl:call-template name="tpl-dl">
                                <xsl:with-param name="col" select="1"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>
                            <xsl:call-template name="tpl-dl">
                                <xsl:with-param name="col" select="2"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>
                            <xsl:call-template name="tpl-dl">
                                <xsl:with-param name="col" select="3"/>
                                <xsl:with-param name="item-count" select="$item-count"/>
                                <xsl:with-param name="bibls" select="$distinct-bibls"/>
                            </xsl:call-template>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="resourceList">
                            <div class="t03">
                                <dl>
                                    <xsl:call-template name="tpl-dl">
                                        <xsl:with-param name="col" select="1"/>
                                        <xsl:with-param name="item-count" select="$item-count"/>
                                        <xsl:with-param name="bibls" select="$distinct-bibls"/>
                                    </xsl:call-template>
                                </dl>
                            </div>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>  
            
</xsl:stylesheet>
