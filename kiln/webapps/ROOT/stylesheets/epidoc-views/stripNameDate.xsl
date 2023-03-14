<?xml version="1.0" encoding="UTF-8"?>
<!-- 

project: IRT
author: RV
description: simple stylesheet to run on the div[edition] as a preliminary step 
    to creating both editorial and diplomatic. 
    Strips out from the XML all <rs>, <persName>, <name>, <placeName> ...

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    
    <!-- copy all elements and attributes -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- copy comments -->
    <xsl:template match="//comment()">
        <xsl:comment>
            <xsl:value-of select="."/>
        </xsl:comment>
    </xsl:template>
    
    <xsl:template match="
        rs[ancestor::div[@type='edition']] |
        persName[ancestor::div[@type='edition']] |
        name[ancestor::div[@type='edition']] |
        placeName[ancestor::div[@type='edition']] |
        geogName[ancestor::div[@type='edition']] |
        orgName[ancestor::div[@type='edition']]
        ">
        <xsl:apply-templates />
    </xsl:template>
    

</xsl:stylesheet>
