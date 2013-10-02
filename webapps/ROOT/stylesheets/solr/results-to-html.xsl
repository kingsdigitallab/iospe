<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:str="http://exslt.org/strings">

  <xsl:import href="../defaults.xsl"/>

  <xsl:param name="lang"/>
  <xsl:param name="url"/>
  <xsl:param name="min-year"/>
  <xsl:param name="max-year"/>

  <!-- query-string is escaped, but according to different rules than
       both XPath's encode-for-uri and escape-html-uri
       functions. encode-for-uri being the standard to compare
       against, the query string has the following characters not
       escaped: "," (there may be others) -->
  <xsl:param name="query-string"/>
  <xsl:variable name="escaped-query-string">
    <xsl:value-of
      select="replace(if($query-string = '') then 'q=&quot;&quot;' else $query-string , ',', '%2C')"
    />
  </xsl:variable>


  <xsl:variable as="xs:integer" name="kiln:min-year" select="200"/>
  <xsl:variable as="xs:integer" name="kiln:max-year" select="1800"/>



  <xsl:template
    match="/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/*[@name='q']"
    mode="search_form">
    <form id="search_form" action="." method="get" data-query="{$escaped-query-string}">
      <input name="q" placeholder="Search terms" type="search">
        <xsl:attribute name="value">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </input>
    </form>
  </xsl:template>

  <xsl:template match="int" mode="search-results">
    <!-- A facet's count. -->
    <xsl:variable name="fq">
      <xsl:text>&amp;fq=</xsl:text>
      <xsl:value-of select="../@name"/>
      <xsl:text>:"</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>"</xsl:text>
    </xsl:variable>
    <xsl:variable name="escaped-fq">
      <xsl:value-of select="substring-before($fq, '&quot;')"/>
      <xsl:value-of select="encode-for-uri(substring-after($fq, ':'))"/>
    </xsl:variable>

    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="not(contains($escaped-query-string, $escaped-fq))">
              <xsl:text>?</xsl:text>
              <xsl:value-of select="$escaped-query-string"/>
              <xsl:value-of select="$fq"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>#</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:if test="contains($escaped-query-string, $escaped-fq)">
            <xsl:text>disabled</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <xsl:value-of select="replace(@name, '_', ' ')"/>
        <xsl:if test="@name = ''">
          <i18n:text>Empty</i18n:text>
        </xsl:if>
      </a>
      <xsl:text> </xsl:text>

      <xsl:variable name="label_type">
        <xsl:if test="contains($escaped-query-string, $escaped-fq)">
          <xsl:text>secondary</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:variable>

      <span class="round label {$label_type}">
        <xsl:value-of select="."/>
      </span>
    </li>

  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']" mode="search-results">
    <xsl:if test="lst/int">
      <h3>Facets</h3>

      <div class="section-container accordion" data-section="accordion">
        <xsl:apply-templates mode="search-results"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="timeSlider">
    <section>
      <p class="title" data-section-title="">
        <a href="#">
          <i18n:text>Date</i18n:text>
          <xsl:text> </xsl:text>
          <span id="date-slider-label">-</span>
        </a>
      </p>
      <div class="content" data-section-content="">


        <div id="date-slider-range" data-range-max="{$kiln:max-year}"
          data-range-min="{$kiln:min-year}" data-value-min="{$min-year}"
          data-value-max="{$max-year}" data-query="{$escaped-query-string}"
          i18n:attr="data-label-suffix" data-label-suffix="A.D.">
          <xsl:text>&#160;</xsl:text>
        </div>
      </div>
    </section>
  </xsl:template>

  <xsl:template name="defaultFacet">
    <section>
      <p class="title" data-section-title="">
        <a href="#">
          <xsl:apply-templates mode="search-results" select="@name"/>
        </a>
      </p>
      <div class="content" data-section-content="">
        <ul class="no-bullet">
          <xsl:apply-templates mode="search-results"/>
        </ul>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']/lst" mode="search-results">
    <xsl:choose>
      <xsl:when test="./@name='not-before' and ./following-sibling::lst[@name='not-after'] ">
        <xsl:call-template name="timeSlider"/>
      </xsl:when>
      <xsl:when test="./@name='not-after' "/>
      <xsl:otherwise>
        <xsl:call-template name="defaultFacet"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']/lst/@name" mode="search-results">
    <xsl:for-each select="tokenize(., '_')">
      <xsl:value-of select="upper-case(substring(., 1, 1))"/>
      <xsl:value-of select="substring(., 2)"/>
      <xsl:if test="not(position() = last())">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="result/doc" mode="search-results">
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$kiln:context-path"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="str[@name='tei-id']"/>
          <xsl:text>.html</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="arr[@name=concat('document-title-', $lang)]/str[1]"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="response/result" mode="search-results">
    <xsl:choose>
      <xsl:when test="number(@numFound) = 0">
        <h3>No results found</h3>
      </xsl:when>
      <xsl:when test="doc">
        <ul class="no-bullet">
          <xsl:apply-templates mode="search-results" select="doc"/>
        </ul>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@name='fq']" mode="search-results">

    <xsl:choose>
      <xsl:when test="local-name(.) = 'str'">
        <xsl:call-template name="display-applied-facet"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="str">
          <xsl:call-template name="display-applied-facet"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display-applied-facet">
    <xsl:variable name="fq">
      <!-- Match the fq parameter as it appears in the query
           string. -->
      <xsl:text>&amp;fq=</xsl:text>
      <xsl:value-of select="substring-before(., '&quot;')"/>
      <xsl:value-of select="encode-for-uri(substring-after(., ':'))"/>
    </xsl:variable>
    <xsl:variable name="label">
      <xsl:value-of select="replace(replace(., '[^:]+:&quot;(.*)&quot;$', '$1'), '_', ' ')"/>
    </xsl:variable>
    <li>
      <a class="info secondary button small">
        <xsl:attribute name="href">
          <xsl:text>?</xsl:text>
          <xsl:value-of select="replace($escaped-query-string, $fq, '')"/>
        </xsl:attribute>

        <xsl:value-of select="$label"/>
        <xsl:if test="$label = ''">
          <i18n:text>Empty</i18n:text>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
        <!-- Create a link to unapply the facet. -->
        <span>
          <i class="icon-remove">&#160;</i>
        </span>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="*[@name='q']" mode="search-results">

    <xsl:choose>
      <xsl:when test="local-name(.) = 'str'">
        <xsl:call-template name="display-applied-search-term"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="str">
          <xsl:call-template name="display-applied-search-term"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display-applied-search-term">
    <xsl:if test="not(text() = 'dt:i')">
      <xsl:variable name="q">
        <!-- Match the fq parameter as it appears in the query
           string. -->
        <xsl:text>([&amp;]?)</xsl:text>
        <xsl:text>(q=</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:text>)([&amp;$])</xsl:text>
      </xsl:variable>
      <xsl:variable name="label">
        <i18n:text>text</i18n:text>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:call-template name="create_facet_button_url">
        <xsl:with-param name="r_q_name">q</xsl:with-param>
        <xsl:with-param name="r_q_value"><xsl:value-of select="text()"/></xsl:with-param>
      </xsl:call-template> query: [<xsl:value-of select="$q"/>]<br/> replaced query: [<xsl:value-of
        select="replace($escaped-query-string, $q, '$3')"/>]<br/>
      <li>
        <a class="info secondary button small">
          <xsl:attribute name="href">
            <xsl:text>?</xsl:text>
            <xsl:value-of select="replace($escaped-query-string, $q, '')"/>
          </xsl:attribute> <xsl:value-of select="$label"/>
          <xsl:text>&#160;</xsl:text>
          <!-- Create a link to unapply the facet. -->
          <span>
            <i class="icon-remove">&#160;</i>
          </span>
        </a>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="search-results"/>


  <xsl:template name="create_facet_button_url">
    <xsl:param name="r_q_name"/>
    <xsl:param name="r_q_value"/>

    <xsl:for-each
      select="/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/*[@name='fq']">
      yelo
      <xsl:value-of select="node()"/>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="searchMenuLanguages">
    <li class="lang en">
      <a class="en" href="../../../en/{$min-year}/{$max-year}/?{$query-string}" title="English"
        >English</a>
    </li>

    <li class="lang py">
      <a class="py" href="../../../ru/{$min-year}/{$max-year}/?{$query-string}" title="Русский"
        >Русский</a>
    </li>
  </xsl:template>

</xsl:stylesheet>
