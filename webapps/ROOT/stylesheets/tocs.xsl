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
        Handles TOCs.
        Raffaele Viglianti; started on April 3 2012
    -->
    
    <xsl:import href="default.xsl" />
    <xsl:import href="common/conversions.xsl" />
            
    <xsl:param name="filedir" />
    <xsl:param name="filename" />
    <xsl:param name="fileextension" />
    <xsl:param name="lang" select="'en'" />
    
    <xsl:param name="toc"/>
    
    <!-- set title -->
    <xsl:variable name="xmg:title">
        <xsl:choose>
            <xsl:when test="$toc='home'">
                <xsl:value-of select="if ($lang='en') then 'Tables of Contents' else 'RU: Tables of Contents'"/>
            </xsl:when>
            <xsl:when test="$toc='bynum'">
                <xsl:value-of select="if ($lang='en') then 'All Inscriptions by Number' else 'RU: All Inscriptions by Number'"/>
            </xsl:when>
            <xsl:when test="$toc='date'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Date - ' else 'Надписи по дате  - '"/>
                <xsl:choose>
                    <xsl:when test="substring-after(//str[@name='q'], 'date-type:')='dated'">
                        <xsl:value-of select="if ($lang='en') then 'Dated by year' else 'Датированные по годам'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//list[@xml:lang=$lang]/century[@url=substring-after(//str[@name='q'], 'date-type:')]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$toc='document-type'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Category of Text' else 'Надписи по типу документа'"/>
            </xsl:when>
            <xsl:when test="$toc='monument-type'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Monument Type' else 'Надписи по типу памятника'"/>
            </xsl:when>
            <xsl:when test="$toc='locations'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Location' else 'RU: Inscriptions by Location'"/>
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
    
    <xsl:template name="xmm:menu-top">
                <div id="ns">
                    <ul class="nvg">
                        <xsl:for-each select="/*/xmm:root/xmm:menu">
                            <xsl:call-template name="xmm:menu-item">
                                <xsl:with-param name="output-sub-items" select="true()" />
                            </xsl:call-template>
                        </xsl:for-each>
                        <li class="lang"><a class="py" href="{substring-before($filename,'.xml')}-ru.html" title="Русский">Русский</a></li>
                        <li class="lang"><a class="en" href="{substring-before($filename,'.xml')}.html" title="English">English</a></li>
                    </ul>
                </div>
    </xsl:template>
    
    <xsl:template name="xms:content">
        
        
        <div class="toc">
            <div class="t01">
                
                <xsl:choose>
                    <xsl:when test="//century">                        
                        <!-- list of available date groups  -->
                        <ul class="letters">
                            <li>
                                <a href="dated.html"><xsl:value-of select="if ($lang='en') then 'Dated by year' else 'Датированные по годам'"/></a>
                            </li>
                        </ul>
                        <xsl:if test="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
                            <ul class="letters">
                                <li><xsl:value-of select="if ($lang='en') then 'By century: BCE' else 'По столетиям до н.э.'"/></li>
                                <xsl:for-each select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'BCE']">
                                    <xsl:sort select="//century[@url=current()]/@num" data-type="number" order="descending"/>
                                    <li>
                                        <a href="{.}.html"><xsl:value-of select="substring-before(., '-')"/></a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <ul class="letters">
                            <li><xsl:value-of select="if ($lang='en') then 'By century: CE' else 'По столетиям н.э.'"/></li>
                            <xsl:for-each select="//letters/letter[not(text()='dated')][substring-after(.,'-') = 'CE']">
                                <xsl:sort select="//century[@url=current()]/@num" data-type="number"/>
                                <li>
                                    <a href="{.}.html"><xsl:value-of select="substring-before(., '-')"/></a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:when test="//letters">
                        <!-- list of available letters  -->
                        <ul class="letters">
                            <xsl:for-each select="//letters/letter">
                                <li>
                                    <a href="{.}{if ($lang='ru') then '-ru' else()}.html">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                </xsl:choose>
                
                
                <dl>
                    <!-- bynum doesn't need grouping or sorting -->
                    <xsl:choose>
                        <xsl:when test="$toc='bynum'">
                            <xsl:for-each select="//doc">
                                
                                <dt>
                                    
                                    <xsl:value-of select="number(substring-after(str[@name='tei-id'], 'byz'))"/>
                                    
                                </dt>
                                <dd>
                                    <a href="/{str[@name='inscription']}.html">
                                        <xsl:choose>
                                            <xsl:when test="translate(normalize-space(str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                                                <xsl:value-of select="if ($lang='en') then '[no title]' else 'RU: [no title]'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="str[@name=concat('inscription-title-', $lang)]"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                </dd>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$toc='date'">
                            
                            <!-- exclude duplicates (caused by multiple inscriptions within the same file with the same date) -->
                            <xsl:for-each-group select="//doc[not(str[@name='date-en'] = preceding-sibling::doc/str[@name='date-en']) 
                                and not(str[@name='file'] = preceding-sibling::doc/str[@name='file']) ]"
                                group-by="int[@name='date-notBefore']">
                                <xsl:for-each-group select="current-group()" group-by="int[@name='date-notAfter']">
                                   
                                    <dt>
                                        <xsl:choose>
                                            <xsl:when test="str[@name=concat($toc,'-',$lang)]!=''">
                                                <xsl:value-of select="str[@name=concat($toc,'-',$lang)]"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="if ($lang='en') then ' [date specified, but not spelled out]' else ' RU: [date specified, but not spelled out]'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </dt>
                                    <xsl:for-each select="current-group()">
                                        <dd>
                                            <a href="/{str[@name='file']}.html">
                                                <xsl:value-of select="substring-after(str[@name='tei-id'], 'byz')"/>
                                                <xsl:choose>
                                                    <xsl:when test="translate(normalize-space(str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                                                        <xsl:value-of select="if ($lang='en') then ' [no title]' else ' RU: [no title]'"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="str[@name=concat('inscription-title-', $lang)]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </dd>
                                    </xsl:for-each>
                                    
                                </xsl:for-each-group>  
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:when test="$toc=('document', 'monument')">
                            
                            
                                <xsl:for-each select="//AL//tei:item[*[@xml:lang=$lang]=(//result//doc//arr[@name=concat($toc,'-type-',$lang)]//str)]">
                                    <dt>
                                        <xsl:value-of select="*[@xml:lang=$lang]"/>
                                    </dt>
                                    <xsl:for-each select="//doc[arr[@name=concat($toc,'-type-',$lang)][str=current()/*[@xml:lang=$lang]]]">
                                        <dd>
                                            <a href="/{str[@name='tei-id']}.html">
                                                <xsl:call-template name="formatInscrNum">
                                                    <xsl:with-param name="num" select="str[@name='tei-id']"/>
                                                </xsl:call-template>
                                                <xsl:choose>
                                                    <xsl:when test="translate(normalize-space(arr[@name=concat('document-title-', $lang)]/str[1]), ' ', '') = ''">
                                                        <xsl:text> [no title]</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="arr[@name=concat('document-title-', $lang)]/str[1]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </dd>
                                    </xsl:for-each>
                                </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$toc='locations'">
                            <xsl:for-each select="//AL//tei:place">
                                <dl>
                                    <dt><xsl:value-of select="translate(tei:placeName[@xml:lang=$lang],'.','')"/></dt>
                                    
                                    <xsl:for-each select="//doc/arr[@name='origin-ref']/str[.=current()/@xml:id]">
                                        <dd>
                                            <xsl:call-template name="formatInscrNum">
                                                <xsl:with-param name="num" select="ancestor::doc/str[@name='tei-id']"/>
                                            </xsl:call-template>
                                            <xsl:text> </xsl:text>
                                            <a href="/{ancestor::doc/str[@name='file']}.html">
                                                <xsl:choose>
                                                    <xsl:when test="translate(normalize-space(ancestor::doc/str[@name=concat('inscription-title-', $lang)]), ' ', '') = ''">
                                                        <xsl:value-of select="if ($lang='en') then '[no title]' else 'RU: [no title]'"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="ancestor::doc/str[@name=concat('inscription-title-', $lang)]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </a></dd>
                                    </xsl:for-each>
                                    
                                </dl>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- grouping is typically done on the filed named after the index, 
                                but sometimes it needs other fields. The switch is handled with XPath in @group-by -->
                            <!-- These are the fields grouped in a non-standard manner: -->
                            <!--  
                                months, grouped by field: months-key
                                places, grouped by field: places-key
                            -->
                            <!--<xsl:for-each-group select="//doc" group-by="translate(translate(normalize-space(
                                if ($toc=('months', 'places')) then str[@name=concat($toc, '-key')] else str[@name=$toc]
                                ), '[].? - ', ''), $lowercase, $transformation)">
                                
                                
                                <dt>
                                <xsl:if test="str[@name='abbr-g']">
                                <em>
                                <xsl:text>(</xsl:text>
                                <xsl:value-of select="str[@name='abbr-g']"/>
                                <xsl:text>) </xsl:text>
                                </em>
                                </xsl:if>
                                <xsl:choose>
                                <xsl:when test="str[@name='num-value']">
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-value']"/><xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="str[@name='num-atleast'] and str[@name='num-atmost']">
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="str[@name='num-atleast']"/>
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="str[@name='num-atmost']"/>
                                <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="str[@name='num-atleast']">
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-atleast']"/><xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="str[@name='num-atmost']">
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-atmost']"/><xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:value-of select="current-grouping-key()"/>
                                </xsl:otherwise>
                                </xsl:choose>
                                </dt>
                                <dd>
                                <xsl:for-each select="//doc[translate(translate(normalize-space(str[@name=$toc]), '[].? - ', ''), $lowercase, $transformation)=current-grouping-key()]">
                                <a href="/{str[@name='file']}.html">
                                <xsl:if test="str[@name='sup']">
                                <xsl:text>[</xsl:text>
                                </xsl:if>
                                <xsl:if test="str[@name='cert']">
                                <xsl:text>?</xsl:text>
                                </xsl:if>
                                <xsl:value-of select="substring-after(str[@name='tei-id'], 'byz')"/>
                                <xsl:if test="str[@name='divloc']">
                                <xsl:text>.</xsl:text>
                                <xsl:value-of select="translate(str[@name='divloc'], '-', '.')"/>
                                </xsl:if>
                                <xsl:if test="not(str[@name='line']='0')">
                                <xsl:choose>
                                <xsl:when test="str[@name='divloc']"/>
                                <xsl:otherwise>
                                <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="str[@name='line']"/>
                                </xsl:if>
                                <xsl:if test="str[@name='sup']">
                                <xsl:text>]</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                </a>
                                </xsl:for-each>
                                </dd>
                                </xsl:for-each-group>-->
                        </xsl:otherwise>
                    </xsl:choose>
                </dl>
            </div>
        </div>
           
    </xsl:template>  
            
</xsl:stylesheet>
