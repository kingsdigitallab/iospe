<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="criteria">
    <xsl:sequence select="/aggregation/criteria/tei:TEI/tei:text/tei:body/tei:list"/>
  </xsl:variable>
  <xsl:variable name="execution">
    <xsl:sequence select="/aggregation/execution/list"/>
  </xsl:variable>
  <xsl:variable name="location">
    <xsl:sequence select="/aggregation/location/tei:TEI/tei:text/tei:body/tei:listPlace"/>
  </xsl:variable>
  <xsl:variable name="material">
    <xsl:sequence select="/aggregation/material/tei:TEI/tei:text/tei:body/tei:list"/>
  </xsl:variable>
  <xsl:variable name="monument">
    <xsl:sequence select="/aggregation/monument/tei:TEI/tei:text/tei:body/tei:list"/>
  </xsl:variable>
  <xsl:variable name="document">
    <xsl:sequence select="/aggregation/document/tei:TEI/tei:text/tei:body/tei:list"/>
  </xsl:variable>

  <xsl:variable name="file-path-end" select="substring-after($file-path, 'inscriptions/')"/>

  <xsl:template match="/aggregation/document/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]" mode="identifier_fields">
    <xsl:param name="idno" select="none"/>
    <xsl:param name="dt" select="'none'"/>
    <xsl:param name="suffix" select="''"/>
    <xsl:param name="full" select="false()"/>

    <!-- unique id for the <doc> -->
    <field name="id">
      <xsl:value-of select="$idno"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$dt"/>
      <xsl:if test="not($suffix = '')">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$suffix"/>
      </xsl:if>
    </field>
    <field name="tei-id">
      <xsl:value-of select="$idno/text()"/>
    </field>
    <field name="sortable-id">
      <xsl:value-of select="local:sort_id($idno/text())"/>
    </field>
    <field name="volume">
      <xsl:choose>
        <xsl:when test="starts-with($file-path-end, '1.')">1</xsl:when>
        <xsl:when test="starts-with($file-path-end, '2.')">2.1.1</xsl:when>
        <xsl:when test="starts-with($file-path-end, '3')">3</xsl:when>
        <xsl:when test="starts-with($file-path-end, 'PE4')">4</xsl:when>
        <xsl:when test="starts-with($file-path-end, '5.')">5</xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>


  <xsl:template match="tei:titleStmt/tei:title[@xml:lang][not(@n = 1)]" mode="title_fields">
    <field name="document-title">
      <xsl:value-of select="local:clean(.)"/>
    </field>
    <field name="document-title-{@xml:lang}">
      <xsl:value-of select="local:clean(.)"/>
      <xsl:if test="tei:certainty[@cert = 'low']">
        <xsl:text> (?)</xsl:text>
      </xsl:if>
    </field>

    <field name="inscription-title-{@xml:lang}">
      <xsl:value-of select="local:clean(.)"/>
      <xsl:if test="tei:certainty[@cert = 'low']">
        <xsl:text> (?)</xsl:text>
      </xsl:if>
    </field>
  </xsl:template>



  <xsl:template name="make_inscription-has-date">
    <field name="inscription-has-date">
      <xsl:if test="ancestor::aggregation/document/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]/tei:origDate">
        <xsl:text>yes</xsl:text>
      </xsl:if>
    </field>
  </xsl:template>

  <xsl:template match="tei:repository" mode="institution_fields">
    <field name="institution">
      <xsl:value-of select="local:replace-spaces(local:clean(.))"/>
    </field>
    <field name="institution-{parent::*/@xml:lang}">
      <xsl:value-of select="local:replace-spaces(local:clean(.))"/>
    </field>
  </xsl:template>

  <xsl:template match="tei:objectType" mode="monument-type_fields">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>

      <xsl:for-each select="$monument/tei:list/tei:item[@xml:id = $ref]">
        <field name="monument-type">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>
        <field name="monument-type-{tei:term/@xml:lang}">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="monument-type-{@xml:lang}">
            <xsl:value-of select="local:replace-spaces(.)"/>
          </field>
        </xsl:for-each>

      </xsl:for-each>

    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:material[@xml:lang = 'ru']" mode="material_fields">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>
      <xsl:for-each select="$material/tei:list/tei:item[@xml:id = $ref]">
        <field name="material">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>
        <field name="material-{tei:term/@xml:lang}">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="material-{@xml:lang}">
            <xsl:value-of select="local:replace-spaces(.)"/>
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:summary[@corresp]" mode="document-type_fields">
    <xsl:for-each select="tokenize(@corresp, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>

      <xsl:for-each select="$document/tei:list/tei:item[@xml:id = $ref]">
        <field name="document-type">
          <xsl:value-of select="local:replace-spaces(tei:term[@xml:lang = 'uk'])"/>
        </field>
        <field name="document-type-ru">
          <xsl:value-of select="local:replace-spaces(tei:term[@xml:lang = 'ru'])"/>
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="document-type-{@xml:lang}">
            <xsl:value-of select="local:replace-spaces(.)"/>
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:origPlace" mode="orig_place_fields">
    <xsl:if test="descendant::tei:*[@cert = 'low'] or ancestor-or-self::tei:*[@cert = 'low']">
      <field name="cert-origin">low</field>
    </xsl:if>
    <field name="origin-en">
      <xsl:apply-templates select="tei:seg[@xml:lang = 'en']" mode="origin"/>
    </field>
    <field name="origin-ru">
      <xsl:apply-templates select="tei:seg[@xml:lang = 'ru']" mode="origin"/>
    </field>
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>
      <field name="origin-ref">
        <xsl:value-of select="$ref"/>
      </field>
      <xsl:for-each select="$location/tei:listPlace/tei:listPlace/tei:place[@xml:id = $ref]/tei:placeName[@xml:lang = ('en', 'ru')]">
        <field name="location">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
        <field name="location-{@xml:lang}">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="tei:origPlace" mode="document-metadata document-metadata-indispensible">
    <xsl:if test="descendant::tei:*[@cert = 'low'] or ancestor-or-self::tei:*[@cert = 'low']">
      <field name="cert-origin">low</field>
    </xsl:if>
    <field name="origin-en">
      <xsl:apply-templates select="tei:seg[@xml:lang = 'en']" mode="origin"/>
    </field>
    <field name="origin-ru">
      <xsl:apply-templates select="tei:seg[@xml:lang = 'ru']" mode="origin"/>
    </field>
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>
      <field name="origin-ref">
        <xsl:value-of select="$ref"/>
      </field>
      <xsl:for-each select="$location/tei:listPlace/tei:listPlace/tei:place[@xml:id = $ref]/tei:placeName[@xml:lang = ('en', 'ru')]">
        <field name="location">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
        <field name="location-{@xml:lang}">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:origDate" mode="orig_date_fields">
    <xsl:for-each select="tei:seg">
      <field name="origDate">
        <xsl:value-of select="."/>
      </field>

      <field name="origDate-{@xml:lang}">
        <xsl:value-of select="."/>
      </field>
    </xsl:for-each>

    <xsl:if test="normalize-space(@notBefore)">
      <field name="not-before">
        <xsl:value-of select="local:get-year-from-date(@notBefore)"/>
      </field>
    </xsl:if>
    <xsl:if test="normalize-space(@notAfter)">
      <field name="not-after">
        <xsl:value-of select="local:get-year-from-date(@notAfter)"/>
      </field>
    </xsl:if>

    <xsl:if test="normalize-space(@evidence)">
      <xsl:for-each select="tokenize(@evidence, ' ')">
        <xsl:variable name="evidence" select="translate(., '_', ' ')"/>
        <xsl:variable name="evidence-en" select="$criteria/tei:list/tei:item[preceding-sibling::tei:label[1][lower-case(.) = lower-case($evidence)]]"/>

        <field name="evidence">
          <xsl:value-of select="local:replace-spaces($evidence)"/>
        </field>
        <field name="evidence-ru">
          <xsl:value-of select="local:replace-spaces($evidence)"/>
        </field>
        <field name="evidence">
          <xsl:value-of select="local:replace-spaces($evidence-en)"/>
        </field>
        <field name="evidence-en">
          <xsl:value-of select="local:replace-spaces($evidence-en)"/>
        </field>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:rs[@type = 'execution']" mode="execution_fields">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>

      <xsl:for-each select="$execution/list/item[@xml:id = $ref]/term">
        <field name="execution">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
        <field name="execution-{@xml:lang}">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'apparatus']" mode="apparatus_fields">
    <field name="apparatus">
      <xsl:apply-templates mode="apparatus"/>
    </field>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'edition']" mode="edition_fields">
    <field name="edition">
      <xsl:apply-templates mode="edition"/>
    </field>
    <field name="diplomatic">
      <xsl:apply-templates mode="diplomatic"/>
    </field>
    <!-- PC: 23 Aug 2016  added barebones field to provide a container for version of the inscription with all special characters stripped out; search strings coming in from the HTML will 
      get the same treatment so that a match should be possible even when the 'normal' text contains a lot of special chars-->
    <field name="barebones">
      <xsl:value-of select="translate(normalize-unicode(., 'NFD'), '&#x0300;&#x0301;&#x0308;&#x0313;&#x0314;&#x0323;&#x0342;&#x0345;&#x02bc;&#x02bd;&#x0302;&#x0340;&#x0341;&#x0343;&#x0344;', '')" />
    </field>
    <!-- END TEST -->
    <field name="lemma">
      <xsl:apply-templates mode="lemma"/>
    </field>
    <!-- PC 17 Mar 2016: NB IN THIS TEMPLATE IN PREVIOUS TEI-TO-SOLR-COMMON.XSL NEXT LINE WAS THIS:
            <xsl:apply-templates mode="#current"/>
    THE #current MODE WAS DOCUMENT BODY WHICH WE NO LONGER HAVE APPLYING TO OTHER TEMPLATES
    HOWEVER THERE WERE ONLY A FEW OTHER TEMPLATES WHICH BOTH (1) MATCH CHILDREN OF tei:div[@type = 'edition']
    AND (2) ARE mode="document-body" AND THESE WERE: match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'divine']" mode="document-body" match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'ruler']" mode="document-body" match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'attested']" mode="document-body"
    
    SO IN OTHER WORDS WE WOULD ACHIEVE THE SAME THING BY ADDING HERE:
         <xsl:apply-templates mode="persnames_fields"/>
    BUT I'M NOT GOING TO ADD THIS IN UNTIL I SEE A REASON FOR IT
    -->
  </xsl:template>

  <xsl:template match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'divine']" mode="persnames_fields">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('divine, religious, or mythic figures')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('Божественные, религиозные или мифические личности и персонажи')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('divine, religious, or mythic figures')"/>
    </field>
  </xsl:template>

  <xsl:template match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'ruler']" mode="persnames_fields">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('rulers')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('Правители')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('rulers')"/>
    </field>
  </xsl:template>

  <xsl:template match="/aggregation/document/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'attested']" mode="persnames_fields">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('attested persons')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('Идентифицированные лица')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('attested persons')"/>
    </field>
  </xsl:template>





  <!-- TEMPLATES BELOW DO NOT CREATE FIELDS -->
  <xsl:template match="tei:app" mode="edition">
    <xsl:apply-templates mode="#current" select="tei:lem"/>
  </xsl:template>
  <xsl:template match="tei:app" mode="diplomatic">
    <xsl:apply-templates mode="#current" select="tei:rdg"/>
  </xsl:template>

  <xsl:template match="tei:choice" mode="edition">
    <xsl:apply-templates mode="#current" select="tei:corr"/>
    <xsl:apply-templates mode="#current" select="tei:reg"/>
  </xsl:template>
  <xsl:template match="tei:choice" mode="diplomatic">
    <xsl:apply-templates mode="#current" select="tei:sic"/>
    <xsl:apply-templates mode="#current" select="tei:orig"/>
  </xsl:template>

  <!--<xsl:template match="*" mode="edition diplomatic">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>-->

  <xsl:template match="node()" mode="apparatus edition diplomatic">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="tei:w[@lemma]" mode="lemma">
    <xsl:value-of select="@lemma"/>
    <xsl:text></xsl:text>
  </xsl:template>

  <xsl:template match="tei:name[@nymRef] | tei:placeName[@nymRef]" mode="lemma">
    <xsl:choose>
      <xsl:when test="contains(@nymRef, '#')">
        <xsl:value-of select="substring-after(@nymRef, '#')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@nymRef"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text></xsl:text>
  </xsl:template>


  <xsl:template match="tei:app" mode="apparatus">
    <xsl:apply-templates mode="#current" select="tei:lem"/>
    <xsl:text></xsl:text>
    <xsl:apply-templates mode="#current" select="tei:rdg"/>
  </xsl:template>

  <xsl:template match="tei:rdg" mode="apparatus">
    <xsl:apply-templates mode="#current"/>
    <xsl:text></xsl:text>
  </xsl:template>

  <xsl:template match="tei:note" mode="apparatus"/>


</xsl:stylesheet>
