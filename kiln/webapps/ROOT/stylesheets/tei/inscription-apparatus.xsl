<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:variable name="default-language" select="'en'"/>

  <xsl:variable name="local-bibliography">
    <xsl:for-each-group select="//tei:div[@type='bibliography']//tei:listBibl" group-by="if(@n) then @n else ''">
      <tei:lref>
        <xsl:if test="current-grouping-key() != ''">
          <xsl:attribute name="n" select="current-grouping-key()"/>
        </xsl:if>

        <xsl:for-each select="current-group()//(tei:bibl | tei:biblStruct)">
          <xsl:choose>
            <xsl:when test="tei:ptr/@target">
              <!-- I know there is only one, we use for-each only to change context -->
              <xsl:for-each select="tei:ptr/@target">
                <xsl:call-template name="source">
                  <xsl:with-param name="root" select="/"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <tei:ref>
                <xsl:apply-templates select="." mode="parse-name-year"/>
              </tei:ref>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </tei:lref>
    </xsl:for-each-group>
  </xsl:variable>


  <xsl:variable name="surnames" select="//surnames"/>

  <xsl:template name="sources">
    <xsl:param name="root"/>
    <xsl:param name="n"/>
    <!-- collect all sources -->
    <xsl:variable name="sources">
      <xsl:for-each select="tokenize(@source, ' ')">
        <xsl:call-template name="source">
          <xsl:with-param name="root" select="$root"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>
    <!-- preselect sources to be printed -->
    <xsl:variable name="final_printing_sources">
      <xsl:for-each select="$sources/tei:ref">
        <xsl:variable name="n_authors_with_same_name_in_local_bib_and_current_sources" select="count($local-bibliography/tei:lref[@n = $n or not(@n)]/tei:ref[tei:name/text() = $sources/tei:ref[tei:name/text() = current()/tei:name/text()]/tei:name/text()])"/>
        <xsl:variable name="n_authors_with_same_name_in_current_sources" select="count($sources/tei:ref[tei:name/text() = current()/tei:name/text()])"/>
        <xsl:variable name="first_occurrence_of_this_author_in_sources" select="$sources/tei:ref[tei:name/text() = current()/tei:name/text()][1] = current()"/>
        <xsl:variable name="n_authors_with_same_name_in_local_bib" select="count($local-bibliography/tei:lref[@n = $n or not(@n)]/tei:ref[tei:name/text() = current()/tei:name/text()])"/>
        <xsl:if test="not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources) 
          or $first_occurrence_of_this_author_in_sources">

          <tei:ref>
            <xsl:sequence select="./tei:name"/>
            <xsl:if test="$n_authors_with_same_name_in_local_bib != 1 
              and not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources)">
              <xsl:sequence select="./tei:date"/>
            </xsl:if>
          </tei:ref>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- print references -->
    <xsl:for-each select="$final_printing_sources/tei:ref">
      <xsl:text></xsl:text>
      <xsl:apply-templates select="tei:name/node()"/>
      <xsl:if test="tei:date and normalize-space(tei:date/text()) != ''">
        <xsl:text>&#x0020;</xsl:text>
        <xsl:apply-templates select="tei:date/node()"/>
      </xsl:if>
      <xsl:if test="not(position() = last())">
        <xsl:text>,&#x0020;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="source">
    <xsl:param name="root"/>

    <xsl:variable name="pref" select="'bib:'"/>
    <tei:ref>
      <xsl:choose>
        <xsl:when test="starts-with(., $pref)">
          <!-- all bibl or biblstruct elements referenced in apparatus which come from the main bibliography.xml -->
          <xsl:apply-templates select="$root//bib//(tei:bibl | tei:biblStruct)[@xml:id=substring-after(current(), $pref)]" mode="parse-name-year"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- all bibl or biblstruct elements referenced only in apparatus which come from the local div#bibliography -->
          <xsl:apply-templates select="$root//tei:div[@type='bibliography']//(tei:bibl | tei:biblStruct)[@xml:id=current()]" mode="parse-name-year"/>

        </xsl:otherwise>
      </xsl:choose>
    </tei:ref>
  </xsl:template>

  <xsl:template match="tei:bibl[@xml:id='IOSPE']" mode="parse-name-year">
    <tei:name>IOSPE</tei:name>
  </xsl:template>

  <xsl:template match="tei:bibl[@xml:id='IOSPE2']" mode="parse-name-year">
    <tei:name>IOSPE I<kiln:sup>2</kiln:sup>
    </tei:name>
  </xsl:template>


  <xsl:template match="kiln:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:bibl | tei:biblStruct" mode="parse-name-year">
    <tei:name>
      <xsl:for-each select=".//tei:author[1]">
        <xsl:choose>
          <xsl:when test=".//tei:surname[@corresp]">
            <xsl:apply-templates select="$surnames//tei:person[@xml:id=substring-after(current()//tei:surname/@corresp, 'surnames.xml#')]//tei:surname[@xml:lang=$default-language or not(@xml:lang)]" />
          </xsl:when>
          <xsl:when test=".//tei:surname">
            <xsl:apply-templates select=".//tei:surname[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:when test=".//tei:forename">
            <xsl:apply-templates select=".//tei:forename[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tei:name>
    <tei:date>
      <xsl:variable name="all_dates">
        <xsl:for-each select="current()//tei:date">
          <xsl:copy-of select="self::tei:date"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:apply-templates select="$all_dates/tei:date[1]"/>
    </tei:date>
  </xsl:template>



  <xsl:template match="tei:div[@type='apparatus']" mode="multipara">
    <div id="apparatus">
    <xsl:for-each select="child::tei:listApp">
      
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[@type='apparatus']//tei:app">

    <xsl:if test="@loc and (not(preceding-sibling::tei:app) or @loc != preceding-sibling::tei:app[1]/@loc)">
      <xsl:value-of select="translate(@loc, ' ', '.')"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>

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
    <xsl:variable name="curr-n" select="ancestor::tei:div[@type='apparatus']/@n"/>
    <span>
      <xsl:choose>
        <xsl:when test="@xml:lang">
          <xsl:attribute name="lang" select="@xml:lang"/>
        </xsl:when>
        <xsl:when test="not(normalize-space($curr-n) = '') and //tei:div[@type='edition']//tei:div[@type='textpart'][@n=$curr-n]/@xml:lang">
          <xsl:attribute name="lang" select="//tei:div[@type='edition']//tei:div[@type='textpart'][@n=$curr-n]/@xml:lang"/>
        </xsl:when>
        <xsl:when test="//tei:div[@type='edition']/@xml:lang">
          <xsl:attribute name="lang" select="//tei:div[@type='edition']/@xml:lang"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="lang" select="'grc'"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates/>
    </span>

    <xsl:call-template name="sources">
      <xsl:with-param name="root" select="/"/>
      <xsl:with-param name="n" select="$curr-n"/>
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

    <xsl:if test="following-sibling::tei:* and not(following-sibling::tei:*[1][self::tei:note]) and not(@source)">
      <xsl:text>: </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
