<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:variable name="default-language" select="'en'"/>

  <xsl:variable name="local-bibliography">
    <xsl:for-each select="//t:div[@type='bibliography']//(t:bibl | t:biblStruct)">
      <xsl:choose>
        <xsl:when test="t:ptr/@target">
          <!-- I know there is only one, we use for-each only to change context -->
          <xsl:for-each select="t:ptr/@target">
            <xsl:call-template name="source">
              <xsl:with-param name="root" select="/"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <t:ref>
            <xsl:apply-templates select="." mode="parse-name-year"/>
          </t:ref>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="surnames" select="//surnames"/>

  <xsl:template name="sources">
    <xsl:param name="root"/>

    <!-- collect all sources -->
    <xsl:variable name="sources">
      <xsl:for-each select="tokenize(@resp, ' ')">
        <xsl:call-template name="source">
          <xsl:with-param name="root" select="$root"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>

    <!-- preselect sources to be printed -->
    <xsl:variable name="final_printing_sources">
      <xsl:for-each select="$sources/t:ref">
        <xsl:variable name="n_authors_with_same_name_in_local_bib_and_current_sources"
          select="count($local-bibliography/t:ref[t:name/text() = $sources/t:ref[t:name/text() = current()/t:name/text()]/t:name/text()])"/>
        <xsl:variable name="n_authors_with_same_name_in_current_sources"
          select="count($sources/t:ref[t:name/text() = current()/t:name/text()])"/>
        <xsl:variable name="first_occurrence_of_this_author_in_sources"
          select="$sources/t:ref[t:name/text() = current()/t:name/text()][1] = current()"/>
        <xsl:variable name="n_authors_with_same_name_in_local_bib"
          select="count($local-bibliography/t:ref[t:name/text() = current()/t:name/text()])"/>

        <xsl:if
          test="not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources) 
          or $first_occurrence_of_this_author_in_sources">

          <t:ref>
            <xsl:sequence select="./t:name"/>
            <xsl:if
              test="$n_authors_with_same_name_in_local_bib != 1 
              and not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources)">

              <xsl:sequence select="./t:date"/>
            </xsl:if>
          </t:ref>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- print references -->
    <xsl:text> </xsl:text>
    <xsl:for-each select="$final_printing_sources/t:ref">
      <xsl:apply-templates select="t:name"/>

      <xsl:if test="t:date">
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="t:date"/>
      </xsl:if>
      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="source">
    <xsl:param name="root"/>

    <!--<xsl:variable name="pref" select="'bib:'"/>-->
    <xsl:variable name="pref" select="''"/>
    <t:ref>
      <xsl:choose>
        <xsl:when test="starts-with(., $pref)">
          <xsl:apply-templates
            select="$root//bib//(t:bibl | t:biblStruct)[@xml:id=substring-after(current(), $pref)]"
            mode="parse-name-year"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates
            select="$root//t:div[@type='bibliography']//(t:bibl | t:biblStruct)[@xml:id=current()]"
            mode="parse-name-year"/>

        </xsl:otherwise>
      </xsl:choose>
    </t:ref>
  </xsl:template>

  <xsl:template match="t:bibl[@xml:id='IOSPE']" mode="parse-name-year">
    <t:name>IOSPE</t:name>
  </xsl:template>
  
  <xsl:template match="t:bibl[@xml:id='IOSPE2']" mode="parse-name-year">
    <t:name>IOSPE 1<sup>2</sup></t:name>
  </xsl:template>
  
  <xsl:template match="t:bibl | t:biblStruct" mode="parse-name-year">
    <t:name>
      <xsl:for-each select=".//t:author[1]">
        <xsl:choose>
          <xsl:when test=".//t:surname[@corresp]">
            <xsl:apply-templates
              select="$surnames//t:person[@xml:id=substring-after(current()//t:surname/@corresp, 'surnames.xml#')]//t:surname[@xml:lang=$default-language or not(@xml:lang)]"
            />
          </xsl:when>
          <xsl:when test=".//t:surname">
            <xsl:apply-templates select=".//t:surname[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:when test=".//t:forename">
            <xsl:apply-templates select=".//t:forename[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </t:name>
    <t:date>
      <xsl:choose>
        <xsl:when test=".//t:imprint[1]">
          <xsl:apply-templates select=".//t:imprint[1]//t:date"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select=".//t:date[1]"/>
        </xsl:otherwise>
      </xsl:choose>

    </t:date>
  </xsl:template>



  <xsl:template match="tei:div[@type='apparatus']" mode="multipara">
    <div id="apparatus">
      <p>
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[@type='apparatus']//tei:app">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@loc"/>
      </xsl:attribute>
      <xsl:if
        test="@loc and (not(preceding-sibling::tei:app) or @loc != preceding-sibling::tei:app[1]/@loc)">
        <xsl:value-of select="translate(@loc, ' ', '.')"/>
        <xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </span>

    <xsl:choose>
      <xsl:when test="@loc != following-sibling::tei:app[1]/@loc">
        <br/>
      </xsl:when>
      <xsl:when test="following-sibling::tei:app">
        <xsl:text>; </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'apparatus']//tei:rdg">
    <xsl:apply-templates/>

    <xsl:call-template name="sources">
      <xsl:with-param name="root" select="/"/>
    </xsl:call-template>

    <xsl:if test="following-sibling::tei:rdg and not(following-sibling::*[1][self::tei:note])">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="tei:div[@type = 'apparatus']//tei:lem">
    <xsl:apply-templates/>

    <xsl:call-template name="sources">
      <xsl:with-param name="root" select="/"/>
    </xsl:call-template>

    <xsl:if
      test="following-sibling::tei:* and not(following-sibling::tei:*[1][self::tei:note]) and not(@resp)">
      <xsl:text>: </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
