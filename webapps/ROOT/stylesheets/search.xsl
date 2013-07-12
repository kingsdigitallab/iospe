<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl" />

  <xsl:param name="params" />
  <xsl:param name="min-year" />
  <xsl:param name="max-year" />

  <xsl:variable as="xs:integer" name="xmg:min-year" select="200" />
  <xsl:variable as="xs:integer" name="xmg:max-year" select="1800" />

  <!-- set title -->
  <xsl:variable name="xmg:title">
    <xsl:choose>
      <xsl:when test="$lang = 'ru'">Поиск</xsl:when>
      <xsl:otherwise>Search</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="fq">
    <xsl:call-template name="get-filter-query" />
  </xsl:variable>

  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/a.css" media="screen, projection" rel="stylesheet"
      type="text/css" />
    <link href="{$xmp:assets-path}/c/s.css" media="screen, projection" rel="stylesheet"
      type="text/css" />
    <link href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" rel="stylesheet" />
  </xsl:template>

  <xsl:template name="xmv:script">
    <script src="http://code.jquery.com/jquery-1.8.2.js">&#160;</script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js">&#160;</script>
    <script src="{$xmp:assets-path}/s/highlight.pack.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/superfish.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/c.js" type="text/javascript">&#160;</script>
    <script>
      $(function() {
        $( "#accordion" ).accordion({
          active: false,
          collapsible: true,
          heightStyle: "content"
        });
        
        $( "#date-range" ).slider({
        range: true,
        min: <xsl:value-of select="$xmg:min-year" />,
        max: <xsl:value-of select="$xmg:max-year" />,
        values: [<xsl:value-of select="$min-year" />, <xsl:value-of select="$max-year" />],
        step: 25,
        slide: function(event, ui) {
        $("#date-text").text("<xsl:value-of select="if ($lang = 'ru') then 'Дата' else 'date'" />: " +
          ui.values[0] + " - " + ui.values[1] + " <xsl:value-of select="if ($lang = 'ru') then 'гг.' else 'A.D.'" />");
          },
        stop: function(event, ui) {
            var fq = "<xsl:value-of select="$fq" />".replace(/&amp;/g, "%26");
            location.href = "../../../" + ui.values[0] + "/" + ui.values[1] + "/start=0" + fq + "/";
          }
        });
        
        $( "#date-text" ).text("<xsl:value-of select="if ($lang = 'ru') then 'Дата' else 'date'" />: " + $("#date-range").slider("values", 0) +
          " - " + $("#date-range").slider("values", 1)  + " <xsl:value-of select="if ($lang = 'ru') then 'гг.' else 'A.D.'" />");
      });
    </script>
  </xsl:template>

  <xsl:template name="menu-languages">
    <li class="lang">
      <a class="py" href="../../../../ru/{$min-year}/{$max-year}/{$params}/" title="Русский"
        >Русский</a>
    </li>
    <li class="lang">
      <a class="en" href="../../../../en/{$min-year}/{$max-year}/{$params}/" title="English"
        >English</a>
    </li>
  </xsl:template>

  <xsl:template name="xms:content">
    <div class="mod facetedNavigation" style="float: left; margin-right: 2em; width: 40%;">
      <section class="facetPanel">
        <div class="facetHeaderSection">
          <form id="frmSearch"
            onsubmit="location.href = '../start=0{$fq}fq=text:' + $('#txtSearch').val().trim().replace(/ /g, '+') + '/'; return false;">
            <input id="txtSearch" name="txtSearch" placeholder="Enter search terms..." type="text" />
            <input type="submit" value="Search" />
          </form>
        </div>
      </section>

      <section class="facetPanel">
        <div class="facetHeaderSection">
          <h3>
            <xsl:choose>
              <xsl:when test="$lang = 'ru'">Фильтры</xsl:when>
              <xsl:otherwise>Filters</xsl:otherwise>
            </xsl:choose>
          </h3>
        </div>

        <xsl:variable name="facets">
          <xsl:sequence select="/aggregation/response/lst/lst[@name = 'facet_fields']" />
        </xsl:variable>

        <div id="accordion">
          <xsl:for-each select="'location', 'document-type'">
            <xsl:variable name="label" select="." />

            <xsl:for-each select="$facets//lst[starts-with(@name, $label)]">
              <xsl:variable name="facet" select="@name" />

              <h3 style="font-variant: small-caps; padding-left: 2em;">
                <xsl:choose>
                  <xsl:when test="$label = 'location'">
                    <xsl:value-of
                      select="if ($lang = 'ru') then 'происхождение текста' else 'origin of text'"
                     />
                  </xsl:when>
                  <xsl:when test="$label = 'document-type'">
                    <xsl:value-of select="if ($lang = 'ru') then 'документ' else 'category of text'" />
                  </xsl:when>
                </xsl:choose>
              </h3>
              <div style="padding-left: 0; padding-right: 1em;">
                <ul class="facetOptions resultsList" style="margin: 0;">
                  <xsl:for-each select="int">
                    <xsl:sort select="upper-case(replace(@name, '&quot;', ''))" />
                    <li>
                      <a class="ctrl select" href="../start=0{$fq}fq={$facet}%3A{@name}/"
                        title="Select this filter">
                        <xsl:choose>
                          <xsl:when test="normalize-space(@name)">
                            <xsl:value-of select="xms:replace-underscores(@name)" />
                          </xsl:when>
                          <xsl:otherwise>EMPTY</xsl:otherwise>
                        </xsl:choose>
                      </a>
                      <xsl:text> </xsl:text>
                      <small style="float: right;">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="." />
                        <xsl:text>)</xsl:text>
                      </small>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:for-each>
          </xsl:for-each>

          <h3 style="font-variant: small-caps; padding-left: 2em;">
            <span id="date-text">
              <xsl:value-of select="if ($lang = 'ru') then 'дата' else 'date'" />
            </span>
          </h3>
          <div style="padding-left: 0; padding-right: 1em;">
            <ul class="facetOptions resultsList" style="margin: 0;">
              <li id="date-range">&#160;</li>
              <li style="text-align: center;">
                <xsl:value-of
                  select="if ($lang = 'ru') then 'Используйте движок для выбора хоронологического периода' else 'Use sliders to select date range'"
                 />
              </li>
            </ul>
          </div>

          <xsl:for-each
            select="'evidence', 'persnames', 'monument-type', 'material', 'execution', 'institution'">
            <xsl:variable name="label" select="." />

            <xsl:for-each select="$facets//lst[starts-with(@name, $label)]">
              <xsl:variable name="facet" select="@name" />

              <h3 style="font-variant: small-caps; padding-left: 2em;">
                <xsl:choose>
                  <xsl:when test="$label = 'institution'">
                    <xsl:value-of
                      select="if ($lang = 'ru') then 'институт хранения' else 'repository'" />
                  </xsl:when>
                  <xsl:when test="$label = 'monument-type'">
                    <xsl:value-of select="if ($lang = 'ru') then 'памятник' else 'monument'" />
                  </xsl:when>
                  <xsl:when test="$label = 'evidence'">
                    <xsl:value-of
                      select="if ($lang = 'ru') then 'критерии датировки' else 'dating criteria'" />
                  </xsl:when>
                  <xsl:when test="$label = 'execution'">
                    <xsl:value-of select="if ($lang = 'ru') then 'техника' else 'technique'" />
                  </xsl:when>
                  <xsl:when test="$label = 'persnames'">
                    <xsl:value-of select="if ($lang = 'ru') then 'имена' else 'names'" />
                  </xsl:when>
                  <xsl:when test="$label = 'material'">
                    <xsl:value-of select="if ($lang = 'ru') then 'материал' else 'material'" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="if ($lang = 'ru') then concat('RU:', xms:remove-language-suffix($facet)) else xms:remove-language-suffix($facet)"
                     />
                  </xsl:otherwise>
                </xsl:choose>
              </h3>
              <div style="padding-left: 0; padding-right: 1em;">
                <ul class="facetOptions resultsList" style="margin: 0;">
                  <xsl:for-each select="int">
                    <xsl:sort select="upper-case(replace(@name, '&quot;', ''))" />
                    <li>
                      <a class="ctrl select" href="../start=0{$fq}fq={$facet}%3A{@name}/"
                        title="Select this filter">
                        <xsl:choose>
                          <xsl:when test="normalize-space(@name)">
                            <xsl:value-of select="xms:replace-underscores(@name)" />
                          </xsl:when>
                          <xsl:otherwise>EMPTY</xsl:otherwise>
                        </xsl:choose>
                      </a>
                      <xsl:text> </xsl:text>
                      <small style="float: right;">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="." />
                        <xsl:text>)</xsl:text>
                      </small>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:for-each>
          </xsl:for-each>
        </div>
      </section>
    </div>

    <xsl:variable name="start" select="/aggregation/response/result/@start" />
    <xsl:variable name="rows"
      select="/aggregation/response/lst/lst[@name = 'params']/str[@name = 'rows']" />
    <xsl:variable name="page" select="count(/aggregation/response/result/doc)" />
    <xsl:variable name="total" select="/aggregation/response/result/@numFound" />

    <div style="float: left;">
      <div class="activeFilters" id="active-filters">
        <h3>
          <xsl:choose>
            <xsl:when test="$lang = 'ru'">Выборочный поиск</xsl:when>
            <xsl:otherwise>Selected searches</xsl:otherwise>
          </xsl:choose>
        </h3>
        <ul class="filtersList inline">
          <xsl:choose>
            <xsl:when test="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
              <xsl:for-each select="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
                <xsl:for-each select="node()">
                  <xsl:variable name="facet" select="substring-before(., ':')" />
                  <xsl:variable name="value" select="substring-after(., ':')" />

                  <xsl:variable name="remove-fq">
                    <xsl:call-template name="get-filter-query">
                      <xsl:with-param name="remove-fq" select="." />
                    </xsl:call-template>
                  </xsl:variable>

                  <li>
                    <xsl:value-of select="xms:remove-language-suffix($facet)" />
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="xms:replace-underscores($value)" />
                    <xsl:text> </xsl:text>
                    <a href="../start=0{$remove-fq}/">
                      <xsl:text>[x]</xsl:text>
                    </a>
                  </li>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <li>
                <xsl:choose>
                  <xsl:when test="$lang = 'ru'">Без фильтров</xsl:when>
                  <xsl:otherwise>No filters</xsl:otherwise>
                </xsl:choose>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </div>

      <div class="searchResults">
        <h3>
          <xsl:choose>
            <xsl:when test="$lang = 'ru'">
              <xsl:text>Результаты </xsl:text>
              <small>
                <xsl:text>с </xsl:text>
                <xsl:value-of select="$start + 1" />
                <xsl:text> по </xsl:text>
                <xsl:value-of select="$start + $page" />
                <xsl:text> из </xsl:text>
                <xsl:value-of select="$total" />
              </small>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Results </xsl:text>
              <small>
                <xsl:text>Showing </xsl:text>
                <xsl:value-of select="$start + 1" />
                <xsl:text> to </xsl:text>
                <xsl:value-of select="$start + $page" />
                <xsl:text> of </xsl:text>
                <xsl:value-of select="$total" />
              </small>
            </xsl:otherwise>
          </xsl:choose>

        </h3>
        <table>
          <thead>
            <tr>
              <th>
                <xsl:choose>
                  <xsl:when test="$lang = 'ru'">Надпись</xsl:when>
                  <xsl:otherwise>Inscription</xsl:otherwise>
                </xsl:choose>
              </th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="/aggregation/response/result/doc">
              <tr>
                <td>
                  <a href="/{str[@name = 'file']}{if ($lang = 'ru') then '-ru' else ''}.html">
                    <xsl:variable name="id"
                      select="replace(substring-after(str[@name = 'tei-id'], 'byz'), '^0+', '')" />

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
                  </a>
                  <xsl:text>. </xsl:text>
                  <a href="/{str[@name = 'file']}{if ($lang = 'ru') then '-ru' else ''}.html">
                    <xsl:value-of select="arr[@name = concat('document-title-', $xmg:lang)]/str" />
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>

      <xsl:call-template name="navigation">
        <xsl:with-param name="fq" select="$fq" />
        <xsl:with-param name="start" select="$start" />
        <xsl:with-param name="rows" select="$rows" />
        <xsl:with-param name="total" select="$total" />
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template name="get-filter-query">
    <xsl:param name="remove-fq" />
    <xsl:variable name="remove-fq" select="normalize-space($remove-fq)" />

    <xsl:variable name="fqs">
      <xsl:for-each select="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
        <xsl:for-each select="node()">
          <xsl:variable name="fq" select="normalize-space(.)" />

          <xsl:if test="$fq != $remove-fq">
            <xsl:text>&amp;</xsl:text>
            <xsl:text>fq=</xsl:text>
            <xsl:value-of select="$fq" />
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <xsl:value-of select="$fqs" />
    <xsl:text>&amp;</xsl:text>
  </xsl:template>

  <xsl:function as="xs:string" name="xms:remove-language-suffix">
    <xsl:param name="value" />

    <xsl:variable name="lang-suffix" select="concat('-', $xmg:lang)" />

    <xsl:choose>
      <xsl:when test="contains($value, $lang-suffix)">
        <xsl:value-of select="substring-before($value, $lang-suffix)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function as="xs:string" name="xms:replace-underscores">
    <xsl:param name="value" />

    <xsl:value-of select="replace($value, '_', ' ')" />
  </xsl:function>

  <xsl:template name="navigation">
    <xsl:param name="fq" required="yes" />
    <xsl:param name="start" required="yes" />
    <xsl:param name="rows" required="yes" />
    <xsl:param name="total" required="yes" />

    <div>
      <ul>
        <xsl:choose>
          <xsl:when test="$start = 0">
            <li class="disabled" style="display: inline;">
              <a href="">&lt;</a>
            </li>
          </xsl:when>
          <xsl:otherwise>
            <li style="display: inline;">
              <a href="../start={$start - $rows}{$fq}/">&lt;</a>
            </li>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:for-each select="1 to xs:integer(ceiling($total div $rows))">
          <xsl:variable name="cur" select="$rows * . - $rows" />

          <li style="display: inline;">
            <xsl:if test="$cur = $start">
              <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="../start={$cur}{$fq}/">
              <xsl:value-of select="." />
            </a>
          </li>
        </xsl:for-each>

        <xsl:choose>
          <xsl:when test="$start + $rows > $total">
            <li class="disabled" style="display: inline;">
              <a href="">&gt;</a>
            </li>
          </xsl:when>
          <xsl:otherwise>
            <li style="display: inline;">
              <a href="../start={$start + $rows}{$fq}/">&gt;</a>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>
