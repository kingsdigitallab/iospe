<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
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


  <!--performed at import -->
  <xsl:variable name="memoized-common-data">
    <xsl:apply-templates mode="document-metadata" select="/aggregation/tei:TEI/tei:teiHeader"/>
    <xsl:apply-templates mode="document-metadata" select="/aggregation/tei:TEI/tei:text/tei:body"/>
    <xsl:apply-templates mode="document-body" select="/aggregation/tei:TEI/tei:text/tei:body"/>
  </xsl:variable>

  <xsl:variable name="memoized-indispensible-data">
    <xsl:apply-templates mode="document-metadata-indispensible"
      select="/aggregation/tei:TEI/tei:teiHeader"/>
    <xsl:apply-templates mode="document-metadata-indispensible"
      select="/aggregation/tei:TEI/tei:text/tei:body"/>
  </xsl:variable>


  <xsl:template
    match="/aggregation/tei:TEI[tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']]"
    mode="common-data">
    <xsl:param name="dt" select="'none'"/>
    <xsl:param name="suffix" select="''"/>
    <xsl:param name="full" select="false()"/>

    <field name="dt">
      <xsl:value-of select="$dt"/>
    </field>

    <!-- unique id -->
    <field name="id">
      <xsl:value-of
        select="./tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'filename']"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$dt"/>
      <xsl:if test="not($suffix = '')">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$suffix"/>
      </xsl:if>
    </field>
    <xsl:choose>
      <xsl:when test="$full">
        <xsl:sequence select="$memoized-common-data"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$memoized-indispensible-data"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="tei:publicationStmt/tei:idno[@type = 'filename']"
    mode="document-metadata document-metadata-indispensible">
    <field name="file">
      <xsl:value-of select="substring-after($file-path, 'inscriptions/')"/>
    </field>
    <field name="tei-id">
      <xsl:value-of select="text()"/>
    </field>
    <field name="inscription">
      <xsl:value-of select="substring-after($file-path, 'inscriptions/')"/>
    </field>

    <field name="sortable-id">
      <xsl:value-of select="local:sort_id(text())"/>
    </field>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title[@xml:lang]"
    mode="document-metadata document-metadata-indispensible">
    <field name="document-title">
      <xsl:value-of select="local:clean(.)"/>
    </field>
    <field name="document-title-{@xml:lang}">
      <xsl:value-of select="local:clean(.)"/>
      
      <xsl:if test="tei:certainty[@cert='low']">
        <xsl:text> (?)</xsl:text>
      </xsl:if>
    </field>

    <field name="inscription-title-{@xml:lang}">
      <xsl:value-of select="local:clean(.)"/>
      
      <xsl:if test="tei:certainty[@cert='low']">
        <xsl:text> (?)</xsl:text>
      </xsl:if>
      
    </field>
  </xsl:template>


  <xsl:template match="tei:repository" mode="document-metadata">
    <field name="institution">
      <xsl:value-of select="local:replace-spaces(local:clean(.))"/>
    </field>
    <field name="institution-{parent::*/@xml:lang}">
      <xsl:value-of select="local:replace-spaces(local:clean(.))"/>
    </field>
  </xsl:template>

  <xsl:template match="tei:objectType" mode="document-metadata">
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

  <xsl:template match="tei:material[@xml:lang = 'ru']" mode="document-metadata">
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

  <xsl:template match="tei:summary[@corresp]" mode="document-metadata">
    <xsl:for-each select="tokenize(@corresp, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>

      <xsl:for-each select="$document/tei:list/tei:item[@xml:id = $ref]">
        <field name="document-type">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>
        <field name="document-type-ru">
          <xsl:value-of select="local:replace-spaces(tei:term)"/>
        </field>

        <xsl:for-each select="tei:gloss">
          <field name="document-type-{@xml:lang}">
            <xsl:value-of select="local:replace-spaces(.)"/>
          </field>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <!-- i believe this is copied into the field -->
  <!--<xsl:template match="tei:fileDesc/tei:sourceDesc/tei:msDesc" mode="document-metadata">
    <!-\- general text search of metadata -\->
    <field name="text">
      <xsl:text>hello</xsl:text>
      <xsl:value-of select="text()"/>
    </field>
    <xsl:apply-templates mode="#current"></xsl:apply-templates>
  </xsl:template>-->

  <!--  Per document part-->

  <xsl:template match="tei:origPlace" mode="document-metadata document-metadata-indispensible">
    <xsl:for-each select="tokenize(@ref, ' ')">
      <xsl:variable name="ref" select="substring-after(., '#')"/>

      <xsl:for-each
        select="$location/tei:listPlace/tei:listPlace/tei:place[@xml:id = $ref]/tei:placeName[@xml:lang = ('en', 'ru')]">
        <field name="location">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
        <field name="location-{@xml:lang}">
          <xsl:value-of select="local:replace-spaces(.)"/>
        </field>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:origDate" mode="document-metadata document-metadata-indispensible">
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
        <xsl:variable name="evidence-en"
          select="$criteria/tei:list/tei:item[preceding-sibling::tei:label[1][lower-case(.) = lower-case($evidence)]]"/>

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


  <xsl:template match="tei:rs[@type = 'execution']" mode="document-metadata">
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

  <xsl:template match="tei:div[@type = 'apparatus']" mode="document-body">
    <field name="apparatus">
      <xsl:apply-templates mode="apparatus"/>
    </field>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'edition']" mode="document-body">
    <field name="edition">
      <xsl:apply-templates mode="edition"/>
    </field>
    <field name="diplomatic">
      <xsl:apply-templates mode="diplomatic"/>
    </field>
    <field name="lemma">
      <xsl:apply-templates mode="lemma"/>
    </field>

    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template
    match="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'divine']"
    mode="document-body">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('sacred or divine entity')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('RU: sacred or divine entity')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('sacred or divine entity')"/>
    </field>
  </xsl:template>

  <xsl:template
    match="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'ruler']"
    mode="document-body">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('emperor or ruler')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('RU: emperor or ruler')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('emperor or ruler')"/>
    </field>
  </xsl:template>

  <xsl:template
    match="/aggregation/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']//tei:persName[@type = 'attested']"
    mode="document-body">
    <field name="persnames">
      <xsl:value-of select="local:replace-spaces('other person')"/>
    </field>
    <field name="persnames-ru">
      <xsl:value-of select="local:replace-spaces('RU: other person')"/>
    </field>
    <field name="persnames-en">
      <xsl:value-of select="local:replace-spaces('other person')"/>
    </field>
  </xsl:template>

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

  <xsl:template match="*" mode="edition diplomatic">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="text()" mode="apparatus edition diplomatic">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="tei:w[@lemma]" mode="lemma">
    <xsl:value-of select="@lemma"/>
    <xsl:text> </xsl:text>
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
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="tei:app" mode="apparatus">
    <xsl:apply-templates mode="#current" select="tei:lem"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="#current" select="tei:rdg"/>
  </xsl:template>

  <xsl:template match="tei:rdg" mode="apparatus">
    <xsl:apply-templates mode="#current"/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:note" mode="apparatus"/>

</xsl:stylesheet>
