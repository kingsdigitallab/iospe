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
      select="replace(if($query-string = '') then 'start=0' else $query-string , ',', '%2C')"/>
  </xsl:variable>
  <xsl:variable name="default_search_query" select="'dt:i'" />


  <xsl:variable as="xs:integer" name="kiln:min-year" select="200"/>
  <xsl:variable as="xs:integer" name="kiln:max-year" select="1800"/>



  <xsl:template
    match="/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/*[@name='q']"
    mode="search_form">
    <form id="search_form" action="." method="get" >
      <input name="q" placeholder="Search terms" type="search"/>
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
          <xsl:text>?</xsl:text>
          <xsl:call-template name="create_facet_button_url">
            <xsl:with-param name="r_q_name">fq</xsl:with-param>
            <xsl:with-param name="r_q_value">
              <xsl:value-of select="$escaped-fq"/>
            </xsl:with-param>
            <xsl:with-param name="start" select="'0'" />
          </xsl:call-template>
          <xsl:value-of select="$fq" />
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
          data-value-max="{$max-year}" i18n:attr="data-label-suffix"
          data-label-suffix="A.D.">
          <xsl:attribute name="data-query">
            <xsl:call-template name="create_facet_button_url" />
          </xsl:attribute>
          <xsl:text>&#160;</xsl:text>
        </div>
        <p class="muted">
          <i18n:text>Use sliders to select date range</i18n:text>
        </p>
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
    <xsl:choose>
      <xsl:when test="starts-with(., 'institution')">
        <i18n:text>repository</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'monument-type')">
        <i18n:text>monument</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'evidence')">
        <i18n:text>dating criteria</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'execution')">
        <i18n:text>technique</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'persnames')">
        <i18n:text>names</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'material')">
        <i18n:text>material</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'location')">
        <i18n:text>origin of text</i18n:text>
      </xsl:when>
      <xsl:when test="starts-with(., 'document-type')">
        <i18n:text>category of text</i18n:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:for-each select="tokenize(., '_')">
          <xsl:value-of select="upper-case(substring(., 1, 1))"/>
          <xsl:value-of select="substring(., 2)"/>
          <xsl:if test="not(position() = last())">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="result/doc" mode="search-results">
    <xsl:variable name="id"
      select="replace(substring-after(str[@name = 'tei-id'], 'byz'), '^0+', '')" />
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$kiln:context-path"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="str[@name='tei-id']"/>
          <xsl:value-of select="$kiln:url-lang-suffix"/>
          <xsl:text>.html</xsl:text>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="contains($id, '.')">
            <strong>
              <xsl:value-of select="substring-before($id, '.')" />
            </strong>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="substring-after($id, '.')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$id" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="arr[@name=concat('document-title-', $lang)]/str[1]"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="response/result" mode="search-results">
    <xsl:variable name="start" select="/aggregation/response/result/@start"/>
    <xsl:variable name="rows"
      select="/aggregation/response/lst/lst[@name = 'params']/str[@name = 'rows']"/>
    <xsl:variable name="page" select="count(/aggregation/response/result/doc)"/>
    <xsl:variable name="total" select="/aggregation/response/result/@numFound"/>

    <xsl:choose>
      <xsl:when test="number(@numFound) = 0">
        <h3>
          <i18n:text>No results found</i18n:text>
        </h3>
      </xsl:when>
      <xsl:when test="doc">
        <h2>
          <i18n:text>Results</i18n:text>
          <xsl:text> </xsl:text>
          <small>
            <i18n:translate>
              <i18n:text key="__res_showing">Showing {0} to {1} of {2}</i18n:text>
              <i18n:param><xsl:value-of select="$start + 1" /></i18n:param>
              <i18n:param><xsl:value-of select="$start + count(doc)" /></i18n:param>
              <i18n:param><xsl:value-of select="$total" /></i18n:param>
            </i18n:translate>
          </small>
        </h2>

        <ul class="no-bullet">
          <xsl:apply-templates mode="search-results" select="doc"/>
        </ul>

        <xsl:call-template name="navigation">
          <xsl:with-param name="start" select="$start"/>
          <xsl:with-param name="rows" select="$rows"/>
          <xsl:with-param name="total" select="$total"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="navigation">
    <xsl:param name="start" required="yes"/>
    <xsl:param name="rows" required="yes"/>
    <xsl:param name="total" required="yes"/>

    <xsl:variable name="context" select="/" />

    <div class="row">
      <div class="large-12 columns">
        <ul class="pagination pagination-centered">
          <xsl:choose>
            <xsl:when test="$start = 0">
              <li class="unavailable arrow">
                <a href="">&lt;</a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow">
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>?</xsl:text>
                    <xsl:call-template name="create_facet_button_url">
                      <xsl:with-param name="start">
                        <xsl:value-of select="$start - $rows"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:text>&lt;</xsl:text>
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:for-each select="1 to xs:integer(ceiling($total div $rows))">
            <xsl:variable name="cur" select="$rows * . - $rows"/>
            <li>
              <xsl:if test="$cur = $start">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              <a>
                <xsl:attribute name="href">
                  <xsl:text>?</xsl:text>
                  <xsl:call-template name="create_facet_button_url">
                    <xsl:with-param name="start">
                      <xsl:value-of select="$cur" />
                    </xsl:with-param>
                    <xsl:with-param name="context" select="$context" />
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </a>
            </li>
          </xsl:for-each>

          <xsl:choose>
            <xsl:when test="$start + $rows > $total">
              <li class="arrow unavailable">
                <a href="">&gt;</a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow">
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>?</xsl:text>
                    <xsl:call-template name="create_facet_button_url">
                      <xsl:with-param name="start">
                        <xsl:value-of select="$start + $rows"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:text>&gt;</xsl:text>
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </div>
    </div>
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

    <xsl:variable name="label">
      <xsl:value-of select="replace(replace(., '[^:]+:&quot;(.*)&quot;$', '$1'), '_', ' ')"/>
    </xsl:variable>

    <li>
      <a class="info secondary button small">
        <xsl:attribute name="href">
          <xsl:text>?</xsl:text>
          <xsl:call-template name="create_facet_button_url">
            <xsl:with-param name="r_q_name">fq</xsl:with-param>
            <xsl:with-param name="r_q_value">
              <xsl:value-of select="text()"/>
            </xsl:with-param>
            <xsl:with-param name="start" select="'0'" />
          </xsl:call-template>
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
    <xsl:if test="not(text() = $default_search_query)">
      <xsl:variable name="label">
        <i18n:text>text</i18n:text>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="."/>
      </xsl:variable>
      <li>
        <a class="info secondary button small">
          <xsl:attribute name="href">
            <xsl:text>?</xsl:text>

            <xsl:call-template name="create_facet_button_url">
              <xsl:with-param name="r_q_name">q</xsl:with-param>
              <xsl:with-param name="r_q_value">
                <xsl:value-of select="text()"/>
              </xsl:with-param>
              <xsl:with-param name="start" select="'0'" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:value-of select="$label"/>
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
    <xsl:param name="r_q_name" select="'q'"/>
    <xsl:param name="r_q_value" select="$default_search_query"/>
    <xsl:param name="start" select="'none'"/>
    <xsl:param name="context" select="/" />

    <xsl:text>start=</xsl:text>
    <xsl:choose>
      <xsl:when test="not($start='none')">
        <xsl:value-of select="$start"/>
      </xsl:when>
      <xsl:when
        test="count($context/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='start']) = 1">
        <xsl:value-of
          select="$context/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='start']"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>999</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each
      select="$context/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/*[@name='fq' or @name='q']">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'str'">
          <xsl:if
            test="not(@name=$r_q_name and text() = $r_q_value) and not(@name='q' and text() = $default_search_query)">
            <xsl:text>&amp;</xsl:text>
            <xsl:value-of select="./@name"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="text()"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="local-name(.) = 'arr'">
          <xsl:for-each select="str">
            <xsl:if
              test="not(parent::node()[@name=$r_q_name] and text() = $r_q_value) and not(parent::node()[@name='q'] and text() = $default_search_query)">
              <xsl:text>&amp;</xsl:text>
              <xsl:value-of select="parent::node()/@name"/>
              <xsl:text>=</xsl:text>
              <xsl:value-of select="text()"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
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
