<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
    
    <xsl:param name="context"/>  
    <xsl:param name="id"/>
    <xsl:param name="lang"/>
    
    
    <!-- THIS VARIABLE IS A TEMPORARY MEASURE TO ENSURE THAT NO UKRAINIAN LINKS ARE MADE 
    AT THIS LEVEL. IT CAN BE REMOVED ONCE UKRAINIAN VERSIONS OF THE INSCRIPTION FILES ARE IN PLACE -->
    <xsl:variable name="temp-lang-suffix">
        <xsl:choose>
            <xsl:when test="$lang = 'ru'">
                <xsl:value-of select="$lang"/>
            </xsl:when>
            <xsl:otherwise>   
                <xsl:value-of select="'en'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>  
    <!-- END -->
    
    <xsl:variable name="record_url">
        <xsl:choose>
            <xsl:when test="$temp-lang-suffix != 'en'">
                <xsl:value-of select="concat('/indices/person/record/', $id, '-', $temp-lang-suffix, '.html')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('/indices/person/record/', $id, '.html')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="name" select="string-join(//tei:person[@xml:id = $id]/tei:persName[@xml:lang = $temp-lang-suffix], ', ')"/>
    
    <xsl:template name="personRecordTitle">
        <i18n:text>Person record</i18n:text>: <xsl:value-of select="$name"/>
    </xsl:template>
    
    <xsl:template name="modal_window_body">
        <div class="row">
            <div class="large-12 columns"><table class="indices indices-person">
                <thead>
                    <tr>
                        <th>
                            <xsl:text> </xsl:text>
                        </th>
                        <th>
                            <i18n:text>English</i18n:text>
                        </th>
                        <th>
                            <i18n:text>Date</i18n:text>
                        </th>
                        <th>
                            <i18n:text>Relationships</i18n:text>
                        </th>
                        
                        <th>
                            <i18n:text>Occupation/Title</i18n:text>
                        </th>
                        <th>
                            <i18n:text>Inscriptions</i18n:text>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="index_row">
                        <xsl:apply-templates select="//tei:person[@xml:id = $id]"/>
                    </tr>
                </tbody>
            </table>
                
                <p><i18n:text>Permanent link for this person</i18n:text>: <a href="{$record_url}"><xsl:value-of select="concat($context, $record_url)"/></a></p>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:person[@xml:id = $id]">
        <th id="{@xml:id}">
            <xsl:value-of select="tei:persName[@xml:lang = 'grc']"/>
        </th>
        <td class="persName">
            <xsl:value-of select="$name"/> 
        </td>
        <td class="floruit">
            <xsl:value-of
                select="tei:floruit/tei:seg[@xml:lang = $temp-lang-suffix]"/>
        </td>
        <td class="relations">
            <xsl:for-each
                select="//persons/descendant::tei:relation[substring-after(@active, '#') = $id]">
                <xsl:choose>
                    <xsl:when test="@name = 'father'">
                        <i18n:text>father of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'son'">
                        <i18n:text>son of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'mother'">
                        <i18n:text>mother of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'daughter'">
                        <i18n:text>daughter of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'brother'">
                        <i18n:text>brother of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'sister'">
                        <i18n:text>sister of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'related'">
                        <i18n:text>related of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'fiancé'">
                        <i18n:text>fiancé of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'fiancée'">
                        <i18n:text>fiancée of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'husband'">
                        <i18n:text>husband of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'wife'">
                        <i18n:text>wife of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'grandfather'">
                        <i18n:text>grandfather of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'grandson'">
                        <i18n:text>grandson of</i18n:text>
                    </xsl:when>
                    <xsl:when test="@name = 'granddaughter'">
                        <i18n:text>granddaughter of</i18n:text>
                    </xsl:when>
                </xsl:choose>
                <!-- space after relationship -->
                <xsl:text> </xsl:text> <xsl:variable name="passives"
                    select="tokenize(substring-after(@passive, '#'), ' #')" as="xs:sequence"/>
                <xsl:for-each select="//persons/descendant::tei:person[@xml:id = $passives]">
                    <a href="../record/{@xml:id}-{$temp-lang-suffix}.html" i18n:attr="title" title="Permalink">
                    <xsl:value-of select="tei:persName[@xml:lang = $temp-lang-suffix]"/>
                    </a>
                    <xsl:if test="following::tei:person[@xml:id = $passives]">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each> <xsl:if test="following::tei:relation[@active = current()/@active]">
                    <xsl:text>; </xsl:text>
                </xsl:if> </xsl:for-each>
        </td>
        <td class="occupation">
            <xsl:value-of select="tei:occupation"/>
        </td>
        <td class="inscriptions">
            <ul class="inline-list">
                <xsl:for-each
                    select="/aggregation/index//result/doc[arr[@name = 'persName-ref']/str[substring-after(text(), '#') = $id]]">
                    <xsl:sort select="number(int[@name = 'sortable-id'])"/>
                    <li>
                        <xsl:call-template name="link2inscription"/>
                    </li>
                </xsl:for-each>
            </ul>
        </td>
        
    </xsl:template>
    
</xsl:stylesheet>
