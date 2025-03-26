<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="inscription-apparatus.xsl"/>

  <xsl:param name="lang" select="$lang"/>
  <xsl:param name="kiln:assets-path" select="$kiln:assets-path"/>
  <xsl:param name="kiln:url-lang-suffix" select="$kiln:url-lang-suffix"/>

  <!-- PC JULY 2015: for 5.236, which has multiple fragments and multiple inscriptions, display structure needs to be:
  Monument
  Fragment_1
    EpiField_1
    Text_1
    EpiField_2
    Text_2
    (etc.)
  Fragment_2
    EpiField_1
    Text_1
    EpiField_2
    Text_2
    (etc.)
  (etc. with rest of fragments)  -->
  <!-- PC AUGUST 2015: for 5.7, which has two fragments but only one inscription, display structure needs to be:
  Monument
  Fragment_1
  Fragment_2
  EpiField
  Text -->

  <xsl:template match="/"/>

  <xsl:template name="inscriptionnav">
    <xsl:param name="next_inscr"/>
    <xsl:param name="prev_inscr"/>

    <xsl:variable name="filename">
      <xsl:value-of select="//tei:idno[@type = 'filename']"/>
    </xsl:variable>

    <xsl:variable name="prev"
      select="/aggregation/order//result/doc[str[@name = 'tei-id' and text() = $filename]]/preceding-sibling::doc[1]/str/text()"/>
    <xsl:variable name="next"
      select="/aggregation/order//result/doc[str[@name = 'tei-id' and text() = $filename]]/following-sibling::doc[1]/str/text()"/>


    <div class="row">
      <div class="large-12 columns">
        <ul class="pagination right">
          <!-- prev -->
          <li class="arrow">
            <xsl:attribute name="class">
              <xsl:text>arrow</xsl:text>
              <xsl:if test="not($prev)">
                <xsl:text> unavailable</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:if test="$prev">
                  <xsl:value-of select="$prev"/>
                  <xsl:value-of select="$kiln:url-lang-suffix"/>
                  <xsl:text>.html</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <xsl:text>&#171;</xsl:text>
              <i18n:text>Previous</i18n:text>
            </a>
          </li>

          <li class="arrow">
            <xsl:attribute name="class">
              <xsl:text>arrow</xsl:text>
              <xsl:if test="not($next)">
                <xsl:text> unavailable</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:if test="$next">
                  <xsl:value-of select="$next"/>
                  <xsl:value-of select="$kiln:url-lang-suffix"/>
                  <xsl:text>.html</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <i18n:text>Next</i18n:text>
              <xsl:text>&#187;</xsl:text>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="inscription-title">
    <!-- inscription number -->
    <xsl:choose>
      <xsl:when test="starts-with(//tei:publicationStmt/tei:idno[@type = 'filename'], 'PE')">
        <xsl:value-of select="//tei:publicationStmt/tei:idno[@type = 'filename']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formatInscrNum">
          <xsl:with-param name="num" select="//tei:publicationStmt/tei:idno[@type = 'filename']"/>
          <xsl:with-param name="printCorpus" select="true()"/>
          <xsl:with-param name="txt" select="true()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>

    <!-- origin -->
    <xsl:apply-templates
      select="/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace[1]/tei:seg[@xml:lang = $lang]"/>
    <xsl:text/>

    <!-- title -->
    <xsl:apply-templates
      select="/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)][@xml:lang = $lang]"/>


    <!--<xsl:if test="/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)][@xml:lang=$lang]/tei:certainty[@cert = 'low']">
      <xsl:text> (?)</xsl:text>
    </xsl:if>-->

    <xsl:if
      test="not(/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)][@xml:lang = $lang]//tei:origDate)">

      <xsl:choose>
        <xsl:when
          test="(/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc//tei:history/tei:origin/tei:origDate)[1]/tei:seg[@xml:lang = 'en'] = 'Unknown.'">
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
          <!-- origDate -->
          <xsl:value-of
            select="(/aggregation/inscription/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc//tei:history/tei:origin/tei:origDate)[1]/tei:seg[@xml:lang = $lang]"
          />
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <!-- format inscription number -->

  <xsl:template name="formatInscrNum">
    <xsl:param name="num"/>
    <xsl:param name="printCorpus" select="false()"/>
    <xsl:param name="txt" select="false()"/>
<!-- choice here because the nums for vols 1, 3, and 5 are just two groups, i.e. x.x, whereas vol 2 nums are always four groups i.e. 2.x.x.x -->
    <xsl:choose>
      
      <xsl:when test="starts-with($num, '2')">   
        <xsl:analyze-string regex="(\d+)\.(\d+)\.(\d+)\.(\d+[a-z]?)" select="$num">
          <xsl:matching-substring>
            <xsl:if test="$printCorpus">
              <xsl:number value="regex-group(1)" format="I"/>
              <xsl:text>.</xsl:text>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$txt">
                <xsl:number format="1"
                  value="number(translate(regex-group(2), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                <xsl:value-of select="translate(regex-group(2), '0123456789', '')"/>
                <xsl:text>.</xsl:text>
                <xsl:number format="1"
                  value="number(translate(regex-group(3), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                <xsl:value-of select="translate(regex-group(3), '0123456789', '')"/>
                <xsl:text> </xsl:text>
                <xsl:number format="1"
                  value="number(translate(regex-group(4), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                <xsl:value-of select="translate(regex-group(4), '0123456789', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <strong>
                  <xsl:number format="1"
                    value="number(translate(regex-group(2), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                  <xsl:value-of select="translate(regex-group(2), '0123456789', '')"/>
                  <xsl:text>.</xsl:text>
                  <xsl:number format="1"
                    value="number(translate(regex-group(3), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                  <xsl:value-of select="translate(regex-group(3), '0123456789', '')"/>
                  <xsl:text> </xsl:text>
                  <xsl:number format="1"
                    value="number(translate(regex-group(4), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                  <xsl:value-of select="translate(regex-group(4), '0123456789', '')"/>
                </strong>
              </xsl:otherwise>
            </xsl:choose>        
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:analyze-string regex="(\d+)\.(\d+[a-z]?)" select="$num">
          <xsl:matching-substring>
            <xsl:if test="$printCorpus">
              <xsl:number value="regex-group(1)" format="I"/>
              <xsl:text>&#160;</xsl:text>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$txt">
                <xsl:number format="1"
                  value="number(translate(regex-group(2), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                <xsl:value-of select="translate(regex-group(2), '0123456789', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <strong>
                  <xsl:number format="1"
                    value="number(translate(regex-group(2), 'abcdefghijklmnopqrstuvwxyz', ''))"/>
                  <xsl:value-of select="translate(regex-group(2), '0123456789', '')"/>
                </strong>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="copyEpidoc">
    <!-- Template to add XHTML namespace to elements coming from example-p5-xslts -->
    <xsl:element name="{name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="@*"/>
      <xsl:apply-templates mode="copyEpidoc"/>
      <xsl:if test="not(comment()) and not(self::br)">
        <xsl:comment>0</xsl:comment>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="comment()" mode="copyEpidoc">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:msDesc | tei:msPart" mode="do_fragment_or_monument">
    <xsl:param name="n"/>
    <xsl:param name="specialFrag" select="false()"/>
    <xsl:param name="nestedTitles" select="true()"/>

    <div>
      <xsl:attribute name="class">
        <xsl:text>row</xsl:text>
        <xsl:choose>
          <xsl:when test="$n">
            <xsl:text> fragment-section</xsl:text>
            <xsl:text> fragment-section</xsl:text>
            <!-- PC JULY 2015: why do we add this 'fragment-section2' to the attr value? -->
            <xsl:value-of select="$n"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> monument-section</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!-- Stone -->
      <div class="large-2 columns">
        <!-- would be better in stylesheet -->
        <h2>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$n and $nestedTitles and $specialFrag"/>
              <xsl:when test="$n and $nestedTitles">
                <xsl:text>subpart</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>

          <xsl:choose>
            <xsl:when test="$n">
              <i18n:text>Fragment</i18n:text>
              <xsl:text/>
              <xsl:value-of select="$n"/>
            </xsl:when>
            <xsl:otherwise>
              <i18n:text>Monument</i18n:text>
            </xsl:otherwise>
          </xsl:choose>
        </h2>
      </div>

      <div class="large-10 columns details">
        <!-- Type of monument (if exists) -->
        <xsl:if
          test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType[@xml:lang = $lang]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Type</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>

        <!-- Material (if exists) -->
        <xsl:if
          test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material[@xml:lang = $lang]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Material</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>
        <!-- Dimensions -->
        <xsl:for-each
          select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Dimensions (cm)</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates select="self::tei:dimensions"/>
                <!-- moved xsl:choose from here to dimensions template below -->
                <xsl:text>.</xsl:text>
              </p>
            </div>
          </div>
        </xsl:for-each>

        <!-- Description and condition (if exists) -->
        <xsl:if
          test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p[(@xml:lang = $lang) and (normalize-space(text()[1]) != '')]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Additional description</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p[@xml:lang = $lang]/node()"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>

        <xsl:if
          test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/(tei:objectType | tei:material | tei:dimensions | tei:p)[@xml:lang = $lang]">
          <!-- DEBUG <br/> -->
        </xsl:if>

        <!-- Origin -->
        <xsl:if test="tei:history/tei:origin/tei:origPlace/tei:seg[@xml:lang = $lang]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Place of Origin</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:history/tei:origin/tei:origPlace/tei:seg[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>

        <xsl:for-each select="tei:history/tei:provenance[@type = 'found']">

          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Find place</i18n:text>
              </h6>
            </div>

            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:seg[@xml:lang = $lang]/tei:placeName[@type = 'ancientFindspot']"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>

          <!-- Find context -->
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Find context</i18n:text>
              </h6>
            </div>

            <div class="large-9 columns">
              <p>
                <xsl:apply-templates select="tei:seg[@xml:lang = $lang]/tei:rs[@type = 'context']"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>

          <!-- Find Circumstances -->
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Find circumstances</i18n:text>
              </h6>
            </div>

            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:seg[@xml:lang = $lang]/tei:rs[@type = 'circumstances']"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:for-each>

        <!-- Find place -->
        <xsl:if test="
            tei:history/tei:origin/tei:origPlace/tei:seg[@xml:lang = $lang]
            | tei:history/tei:provenance[@type = 'found']">
          <!-- DEBUG <br/> -->
        </xsl:if>

        <!-- Modern Location (if exists) -->
        <xsl:if test="tei:history/tei:provenance[@type = 'observed'][not(@subtype)]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Modern location</i18n:text>
              </h6>
            </div>

            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:history/tei:provenance[@type = 'observed'][not(@subtype)]/tei:seg[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>

        <!-- Institution and Inventory -->
        <xsl:for-each
          select="tei:msIdentifier/tei:altIdentifier[@xml:lang = $lang or not(@xml:lang)]">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Institution and inventory</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates select="tei:repository"/>

                <xsl:choose>
                  <xsl:when test="tei:idno/text()">
                    <xsl:text>,&#160;</xsl:text>
                    <xsl:value-of select="tei:idno"/>
                  </xsl:when>
                  <xsl:when test="
                      not(tei:repository[. = ('Unknown',
                      'Неизвестен')])">
                    <xsl:text>,&#160;</xsl:text>
                    <i18n:text>no inventory number</i18n:text>
                  </xsl:when>
                </xsl:choose>
                <xsl:text>.&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:for-each>

        <!-- Autopsy -->
        <xsl:if test="tei:history/tei:provenance[@type = 'observed'][@subtype = 'autopsy']">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Autopsy</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="tei:history/tei:provenance[@type = 'observed'][@subtype = 'autopsy']/tei:seg[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>
      </div>
    </div>


  </xsl:template>


  <xsl:template match="tei:body">
    <!-- monument information, common to all fragments -->
    <xsl:apply-templates mode="do_fragment_or_monument" select="//tei:msDesc"/>

    <xsl:choose>
      <!-- PC JULY 2015: this first case is to deal with complex cases like V.236 (see comment at top) -->
      <xsl:when
        test="//tei:msDesc/tei:msPart[(@ana = 'fragment') and (child::tei:msPart[@ana = 'text'])]">
        <xsl:for-each
          select="//tei:msDesc/tei:msPart[(@ana = 'fragment') and (child::tei:msPart[@ana = 'text'])]">
          <xsl:variable name="fragNum" select="@n"/>
          <xsl:apply-templates select="." mode="do_fragment_or_monument">
            <xsl:with-param name="n" select="$fragNum"/>
            <xsl:with-param name="specialFrag" select="true()"/>
          </xsl:apply-templates>
          <xsl:for-each select="child::tei:msPart[@ana = 'text']">
            <xsl:call-template name="do_epigraphic_field">
              <xsl:with-param name="fragNum" select="$fragNum"/>
              <xsl:with-param name="fullN" select="concat($fragNum, '.', @n)"/>
              <xsl:with-param name="nestedTitles" select="true()"/>
              <!-- PC JULY 2015: is this actually true? -->
            </xsl:call-template>
            <xsl:call-template name="do_textpart">
              <xsl:with-param name="fragNum" select="$fragNum"/>
              <xsl:with-param name="fullN" select="concat($fragNum, '.', @n)"/>
              <xsl:with-param name="nestedTitles" select="true()"/>
              <!-- PC JULY 2015: is this actually true? -->
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>


      <!-- Render metadata about physical object; either whole or in fragments (tei:div[@subtype='fragment']) -->

      <xsl:when
        test="//tei:div[@type = 'edition'][descendant::tei:div[@subtype = 'fragment'][descendant::tei:div[@subtype = 'inscription']]]">

        <xsl:for-each select="//tei:div[@type = 'edition']//tei:div[@subtype = 'fragment']">
          <!-- Render metadata about inscriptions in current fragment, if any -->
          <xsl:variable name="f-n" select="@n"/>

          <xsl:for-each select="//tei:msDesc/tei:msPart">
            <xsl:apply-templates select="." mode="do_fragment_or_monument">
              <xsl:with-param name="n" select="$f-n"/>
              <xsl:with-param name="nestedTitles" select="false()"/>
            </xsl:apply-templates>
          </xsl:for-each>

          <xsl:choose>
            <xsl:when test="tei:div[@subtype = 'inscription'][@n]">
              <xsl:for-each select="tei:div[@subtype = 'inscription'][@n]">
                <xsl:call-template name="do_epigraphic_field">
                  <xsl:with-param name="fullN" select="concat($f-n, '.', @n)"/>
                  <xsl:with-param name="nestedTitles" select="true()"/>
                </xsl:call-template>
                <xsl:call-template name="do_textpart">
                  <xsl:with-param name="fullN" select="concat($f-n, '.', @n)"/>
                  <xsl:with-param name="nestedTitles" select="true()"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="do_epigraphic_field">
                <xsl:with-param name="fullN" select="concat($f-n, '.')"/>
                <xsl:with-param name="nestedTitles" select="true()"/>
              </xsl:call-template>
              <xsl:call-template name="do_textpart">
                <xsl:with-param name="fullN" select="concat($f-n, '.')"/>
                <xsl:with-param name="nestedTitles" select="true()"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:text/>

        </xsl:for-each>
      </xsl:when>

      <xsl:otherwise>
        <!-- support section per fragment, if any -->
        <xsl:for-each select="//tei:msDesc/tei:msPart">
          <xsl:if test="
              descendant::tei:support/tei:objectType
              | descendant::tei:support/tei:material
              | descendant::tei:support/tei:p
              | descendant::tei:provenance
              | descendant::tei:support/tei:dimensions
              | descendant::tei:origPlace">
            <xsl:apply-templates select="." mode="do_fragment_or_monument">
              <xsl:with-param name="n" select="@n"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>

        <xsl:choose>
          <xsl:when
            test="//tei:msDesc/tei:msPart[descendant::tei:layoutDesc][@n][descendant::tei:origDate][descendant::tei:msContents]">
            <!-- multiple epigraphic fields, each with its corresponding textpart -->
            <xsl:for-each select="//tei:msDesc/tei:msPart[descendant::tei:layoutDesc][@n]">
              <xsl:call-template name="do_epigraphic_field">
                <xsl:with-param name="fullN" select="@n"/>
              </xsl:call-template>
              <xsl:call-template name="do_textpart">
                <xsl:with-param name="fullN" select="@n"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="//tei:msDesc/tei:msPart[@n][descendant::tei:layoutDesc]">
            <!-- multiple epigraphic fields, followed by a single textpart -->
            <xsl:for-each select="//tei:msDesc/tei:msPart[@n][descendant::tei:layoutDesc]">
              <xsl:call-template name="do_epigraphic_field">
                <xsl:with-param name="fullN" select="@n"/>

              </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="do_textpart"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- single epigraphic field, followed by a single textpart -->
            <xsl:call-template name="do_epigraphic_field"/>


            <xsl:call-template name="do_textpart"/>
          </xsl:otherwise>

        </xsl:choose>

        <xsl:text/>

      </xsl:otherwise>

    </xsl:choose>
    <div class="row">
      <xsl:call-template name="download_xml_link"/>
    </div>
  </xsl:template>

  <xsl:template name="download_xml_link">
    <xsl:variable name="filename">
      <xsl:value-of select="//tei:idno[@type = 'filename']"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>

    <div xsl:exclude-result-prefixes="tei" class="large-12 columns">
      <p>
        <a href="http://creativecommons.org/licenses/by/2.0/uk/" title="Creative Commons license">
          <img alt="(cc)" border="0" src="{$kiln:assets-path}/images/80x15.png"/>
          <xsl:text/>
        </a>
        <xsl:choose>
          <xsl:when test="substring(//tei:idno[@type = 'PE'], 3, 1) = '1'">© 2017 <i18n:text>Askold
              Ivantchik (edition), Irene Polinskaya (translation)</i18n:text>
          </xsl:when>
          <xsl:when test="substring(//tei:idno[@type = 'PE'], 3, 1) = '2'">© 2024 <i18n:text>Irene
              Polinskaya (edition and translation)</i18n:text>
          </xsl:when>
          <xsl:when test="substring(//tei:idno[@type = 'PE'], 3, 1) = '3'">© 2017 <i18n:text>Igor
              Makarov (edition), Irene Polinskaya (translation)</i18n:text>
          </xsl:when>
          <xsl:when test="substring(//tei:idno[@type = 'PE'], 3, 1) = '5'">© 2015 <i18n:text>Andrey
              Vinogradov (edition), Irene Polinskaya (translation)</i18n:text>
          </xsl:when>
        </xsl:choose>
        <br/>
        <i18n:text>You may download this</i18n:text>
        <xsl:text>&#160;</xsl:text>
        <a href="{$filename}">
          <xsl:attribute name="title">
            <i18n:text>Right-click to save this file</i18n:text>
          </xsl:attribute>
          <i18n:text>inscription in EpiDoc XML</i18n:text>
        </a>
        <xsl:text>. (</xsl:text>
        <i18n:text>This file should validate to the</i18n:text>
        <xsl:text/>
        <a href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng">
          <xsl:attribute name="title">
            <i18n:text>Right-click to save this file</i18n:text>
          </xsl:attribute>
          <i18n:text>EpiDoc schema</i18n:text>
        </a>
        <xsl:text>.)</xsl:text>
      </p>
    </div>
  </xsl:template>


  <xsl:template name="do_epigraphic_field">
    <xsl:param name="nestedTitles" select="false()"/>
    <xsl:param name="fragNum"/>
    <xsl:param name="fullN"/>

    <!-- change context for this template to be the actual ms_context (mspart or msdesc) -->
    <xsl:variable name="ms_context">
      <xsl:choose>
        <xsl:when test="normalize-space($fragNum)">
          <!-- for cases like V.236 -->
          <xsl:sequence
            select="//tei:msPart[(@ana = 'fragment') and (@n = $fragNum)]/tei:msPart[(@ana = 'text') and (@n = substring-after($fullN, '.'))]"
          />
        </xsl:when>
        <xsl:when test="not(normalize-space($fragNum)) and normalize-space($fullN)">
          <xsl:sequence select="//tei:msPart[@n = $fullN]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="//tei:msDesc"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <div>
      <xsl:attribute name="class">
        <xsl:text>row</xsl:text>
        <xsl:text> epigraphic-field-section</xsl:text>
        <xsl:if test="$fullN">
          <xsl:text> epigraphic-field-section</xsl:text>
          <xsl:value-of select="$fullN"/>
        </xsl:if>
      </xsl:attribute>

      <!-- If there are multiple inscriptions, add title -->

      <div class="large-2 columns">
        <xsl:choose>
          <xsl:when test="normalize-space($fragNum)">
            <!-- we need a different styling on the h2 when this particular condition applies,
            eg. with inscription V.236, so against usual practice we specify the style here-->
            <h2 style="color: #285072; font: 1.25em Arial,Helvetica,sans-serif;">
              <i18n:text>Epigraphic field</i18n:text>
              <xsl:if test="substring-after($fullN, '.') != '0'">
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="substring-after($fullN, '.')"/>
              </xsl:if>
            </h2>
          </xsl:when>
          <xsl:when test="$ms_context/node()/@n">
            <xsl:attribute name="class">
              <xsl:text>large-2 columns wrap</xsl:text>
            </xsl:attribute>
            <h2>
              <xsl:attribute name="class">
                <xsl:text>part</xsl:text>
                <xsl:if test="$nestedTitles">
                  <xsl:text> subpart</xsl:text>
                </xsl:if>
              </xsl:attribute>

              <i18n:text>Epigraphic field</i18n:text>
              <xsl:text>&#160;</xsl:text>
              <xsl:choose>
                <xsl:when test="contains($fullN, '.')">
                  <xsl:value-of select="substring-after($fullN, '.')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$fullN"/>
                </xsl:otherwise>
              </xsl:choose>
            </h2>
          </xsl:when>
          <xsl:otherwise>
            <h2>
              <i18n:text>Epigraphic field</i18n:text>
            </h2>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <div class="large-10 columns details">
        <xsl:for-each select="$ms_context//tei:physDesc//tei:layout">

          <!-- Faces code deprecated -->
          <!--<xsl:if test="@ana">

            <div class="row">
              <div class="large-3 columns">
                <h6>
                  <i18n:text>Face</i18n:text>
                </h6>
              </div>
              <div class="large-9 columns">
                <p>
                  <xsl:value-of select="@ana"/>
                  <xsl:text>.&#160;</xsl:text>
                </p>
              </div>
            </div>
          </xsl:if>-->

          <!-- Placement of text (If exists) -->
          <xsl:if test="tei:seg">
            <div class="row">
              <div class="large-3 columns">
                <h6>
                  <i18n:text>Position</i18n:text>
                </h6>
              </div>
              <div class="large-9 columns">
                <p>
                  <xsl:if test="tei:seg[@xml:lang = $lang][normalize-space(.) != '']">
                    <xsl:apply-templates select="tei:seg[@xml:lang = $lang]"/>
                    <xsl:text>&#160;</xsl:text>
                  </xsl:if>
                  <xsl:if test="tei:dimensions">
                    <xsl:apply-templates select="tei:dimensions"/>
                  </xsl:if>
                </p>
              </div>
            </div>
          </xsl:if>
        </xsl:for-each>

        <!-- Style of lettering (if exists) -->
        <xsl:if test="$ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:seg">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Lettering</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:apply-templates
                  select="$ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:seg[@xml:lang = $lang]"/>
                <xsl:text>&#160;</xsl:text>
              </p>
            </div>
          </div>
        </xsl:if>

        <!-- Letterheights (if exists) -->
        <xsl:if test="$ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:height">
          <div class="row">
            <div class="large-3 columns">
              <h6>
                <i18n:text>Letterheights (cm)</i18n:text>
              </h6>
            </div>
            <div class="large-9 columns">
              <p>
                <xsl:choose>
                  <xsl:when
                    test="string($ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:height)">
                    <xsl:value-of select="
                        if ($lang = 'ru')
                        then
                          $ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:height
                        else
                          translate($ms_context//tei:physDesc/tei:handDesc/tei:handNote/tei:height, ',', '.')"
                    />
                  </xsl:when>
                  <xsl:otherwise>
                    <i18n:text>Unknown_lh</i18n:text>
                  </xsl:otherwise>
                </xsl:choose>
              </p>
            </div>
          </div>
        </xsl:if>
        <!-- PC: 22 JAN 2016 DEBUGGING TEST -->
        <!-- <br/> -->
        <!-- END DEBUGGING TEST -->

      </div>
    </div>
  </xsl:template>

  <xsl:template name="do_textpart">
    <xsl:param name="nestedTitles" select="false()"/>
    <xsl:param name="fragNum"/>
    <xsl:param name="fullN"/>

    <xsl:variable name="f_n" select="
        if (contains($fullN, '.'))
        then
          substring-before($fullN, '.')
        else
          $fullN"/>
    <xsl:variable name="tx_n" select="substring-after($fullN, '.')"/>

    <!-- change context for this template to be the actual ms_context (mspart or msdesc) -->
    <xsl:variable name="ms_context">
      <xsl:choose>
        <xsl:when test="normalize-space($fragNum)">
          <xsl:sequence
            select="//tei:msPart[(@ana = 'fragment') and (@n = $fragNum)]/tei:msPart[(@ana = 'text') and (@n = substring-after($fullN, '.'))]"
          />
        </xsl:when>
        <xsl:when test="not(normalize-space($fragNum)) and normalize-space($fullN)">
          <xsl:sequence select="//tei:msPart[@n = $fullN]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="//tei:msDesc"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div>
      <xsl:attribute name="class">
        <xsl:text>row</xsl:text>
        <xsl:text> textpart-section</xsl:text>
        <xsl:if test="$fullN">
          <xsl:text> textpart-section-</xsl:text>
          <xsl:value-of select="$fullN"/>
        </xsl:if>
      </xsl:attribute>

      <div class="large-12 columns">
        <div class="row">


          <div class="large-2 columns">
            <xsl:choose>
              <xsl:when test="$f_n">
                <xsl:attribute name="class">
                  <xsl:text>large-2 columns wrap</xsl:text>
                </xsl:attribute>
                <h2>
                  <xsl:choose>
                    <!-- we need a different styling on the h2 for rare cases such as with inscription V.236, 
                    so against usual practice we specify the style here-->
                    <xsl:when test="normalize-space($fragNum)">
                      <xsl:attribute name="style">
                        <xsl:text>color: #285072; font: 1.25em Arial,Helvetica,sans-serif;</xsl:text>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">
                        <xsl:text>part</xsl:text>
                        <xsl:if test="$nestedTitles">
                          <xsl:text> subpart</xsl:text>
                        </xsl:if>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- DEBUG: check variable values -->
                  <!--f_n value: <xsl:value-of select="$f_n"/>; tx_n value: <xsl:value-of select="$tx_n"/>;-->
                  <!-- END DEBUG -->

                  <i18n:text>Text</i18n:text>
                  <xsl:choose>
                    <xsl:when test="contains($fullN, '.') and substring-after($fullN, '.') != '0'">
                      <xsl:text>&#160;</xsl:text>
                      <xsl:value-of select="substring-after($fullN, '.')"/>
                    </xsl:when>
                    <xsl:when test="contains($fullN, '.') and substring-after($fullN, '.') = '0'">
                      <!-- do nothing -->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>&#160;</xsl:text>
                      <xsl:value-of select="$fullN"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </h2>
              </xsl:when>
              <xsl:otherwise>
                <h2>
                  <i18n:text>Text</i18n:text>
                </h2>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="large-10 columns details">

            <!-- Category -->
            <div class="row">
              <div class="large-3 columns">
                <h6>
                  <i18n:text>Category</i18n:text>
                </h6>
              </div>
              <div class="large-9 columns">
                <p>
                  <xsl:apply-templates
                    select="$ms_context//tei:msContents/tei:summary/tei:seg[@xml:lang = $lang]"/>
                  <xsl:text>&#160;</xsl:text>
                </p>
              </div>
            </div>

            <!-- Date -->
            <div class="row">
              <div class="large-3 columns">
                <h6>
                  <i18n:text key="__inscription_date">Date</i18n:text>
                </h6>
              </div>
              <div class="large-9 columns">
                <p>
                  <xsl:value-of
                    select="upper-case(substring($ms_context//tei:history/tei:origin/tei:origDate/tei:seg[@xml:lang = $lang], 1, 1))"/>
                  <xsl:value-of
                    select="substring($ms_context//tei:history/tei:origin/tei:origDate/tei:seg[@xml:lang = $lang], 2)"/>
                  <xsl:text>&#160;</xsl:text>
                </p>
              </div>
            </div>

            <!-- Dating Criteria -->
            <div class="row">
              <div class="large-3 columns">
                <h6>
                  <i18n:text>Dating criteria</i18n:text>
                </h6>
              </div>
              <div class="large-9 columns">
                <p>
                  <xsl:choose>
                    <xsl:when
                      test="$lang = 'ru' and $ms_context//tei:history/tei:origin/tei:origDate/@evidence">
                      <xsl:for-each
                        select="tokenize(normalize-space($ms_context//tei:history/tei:origin/tei:origDate/@evidence), ' ')">
                        <xsl:variable name="token">
                          <xsl:value-of select="translate(., '_', ' ')"/>
                        </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="position() = 1">
                            <xsl:value-of select="upper-case(substring($token, 1, 1))"/>
                            <xsl:value-of select="substring($token, 2)"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="lower-case($token)"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() != last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text>.&#160;</xsl:text>
                    </xsl:when>
                    <!--<xsl:when
                      test="$lang = 'en' and $ms_context//tei:history/tei:origin/tei:origDate/@evidence">
                      
                      <xsl:variable name="crit" select="/aggregation/crit"/>
                      <xsl:for-each
                        select="tokenize(normalize-space($ms_context//tei:history/tei:origin/tei:origDate/@evidence), ' ')">
                        <xsl:variable name="term" select="
                            $crit//tei:seg[
                            lower-case(.) = lower-case(normalize-space(translate(current(), '_', ' ')))
                            ]/preceding-sibling::tei:seg[1]"/>

                        <xsl:choose>
                          <xsl:when test="position() = 1">
                            <xsl:value-of select="upper-case(substring($term, 1, 1))"/>
                            <xsl:value-of select="substring($term, 2)"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="lower-case($term)"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() != last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text>.&#160;</xsl:text>
                    </xsl:when>-->
                    
                    <!-- PC, 26 March 2025: the 'when' templates below are what we will use if we can find a way to pass the tei-id as a variable in the solr query in the main.xmap template aggregation -->
                    
                    <xsl:when
                      test="$lang = 'en' and $ms_context//tei:history/tei:origin/tei:origDate/@evidence">
                      
                      <xsl:for-each
                        select="/aggregation/evidence//arr[@name='evidence-en']/str">
                        
                        <xsl:choose>
                          <xsl:when test="position() = 1">
                            <xsl:value-of select="upper-case(substring(current(), 1, 1))"/>
                            <xsl:value-of select="translate(substring(current(), 2), '_', ' ')"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="translate(lower-case(current()), '_', ' ')"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() != last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:when>
                    <!--<xsl:when
                      test="$lang = 'uk' and $ms_context//tei:history/tei:origin/tei:origDate/@evidence">
                      <xsl:variable name="ukvalue" select="/aggregation/evidence//arr[@name='evidence-uk']/str"/>
                      <xsl:for-each
                        select="tokenize($ukvalue, ' ')">
                        
                        <xsl:choose>
                          <xsl:when test="position() = 1">
                            <xsl:value-of select="upper-case(substring(current(), 1, 1))"/>
                            <xsl:value-of select="translate(substring(current(), 2), '_', ' ')"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="translate(lower-case(current()), '_', ' ')"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() != last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:when>-->
                    

                    <xsl:otherwise>
                      <i18n:text>Not applicable</i18n:text>
                      <xsl:text>.&#160;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </p>
              </div>
            </div>

            <!-- Editions -->
            <!-- PC, 20 Jun 2024:  IP does not want this field to display for volume 2 files, so for now we will wrap the 
              entire chunk of code (which starts with div class-"row") in a choice element to show or not to show depending 
              on what volume the inscription is in -->

            <xsl:choose>
              <xsl:when test="starts-with(//tei:publicationStmt/tei:idno[@type = 'filename'], '2')">
                <!-- do nothing -->
              </xsl:when>
              <xsl:otherwise>

                <div class="row">
                  <div class="large-3 columns">
                    <h6>
                      <i18n:text>Editions</i18n:text>
                    </h6>
                  </div>
                  <div class="large-9 columns">
                    <p>
                      <xsl:variable name="surnames">
                        <xsl:sequence select="//surnames//tei:listPerson/tei:person"/>
                      </xsl:variable>
                      <xsl:choose>
                        <xsl:when test="
                            normalize-space($fullN) = '' and
                            (//tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')][tei:listBibl//text()[not(normalize-space(.) = '')]]
                            or //tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')][tei:listBibl//tei:ptr])">
                          <xsl:for-each
                            select="//tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')]/tei:listBibl">
                            <xsl:if test="@n">
                              <em>
                                <i18n:text>Fr.</i18n:text>
                                <xsl:text/>
                                <xsl:value-of select="@n"/>
                                <xsl:text>.&#160;</xsl:text>
                              </em>
                            </xsl:if>
                            <xsl:apply-templates select="tei:bibl"/>
                            <xsl:if
                              test="not(string(normalize-space(self::tei:listBibl))) and not(descendant::tei:ptr)">
                              <i18n:text>Unpublished</i18n:text>
                            </xsl:if>
                            <xsl:if test="position() != last()">
                              <xsl:text>.&#160;</xsl:text>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="
                            //tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')][tei:listBibl[@n = $fullN or not(@n)]//(text()[not(normalize-space(.) = '')])]
                            or //tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')][tei:listBibl[@n = $fullN or not(@n)]//tei:ptr]">
                          <xsl:apply-templates
                            select="//tei:div[@type = 'bibliography'][not(@subtype = 'commentaries')]/tei:listBibl[@n = $fullN or not(@n)]/tei:bibl"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <i18n:text>Unpublished</i18n:text>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:text>.&#160;</xsl:text>
                    </p>
                  </div>
                </div>

              </xsl:otherwise>
            </xsl:choose>


            <!-- Actual Inscription Data -->
            <div class="row inscription-data">
              <!-- Creates the inscription views from preprocessed files aggregated in the sitemap -->
              <div class="large-12 columns">
                <div class="section-container tabs" data-section="tabs">

                  <!-- Edition -->
                  <section class="active">
                    <p class="title" data-section-title="true">
                      <a href="#edition{if (@n) then @n else '1'}">
                        <i18n:text>Edition</i18n:text>
                      </a>
                    </p>
                    <div id="edition{if (@n) then @n else '1'}" class="content edition"
                      data-section-content="true">
                      <!-- Only get current text part (inscription) if necessary -->
                      <xsl:choose>
                        <xsl:when test="$f_n and $tx_n and $tx_n != '0'">
                          <xsl:apply-templates
                            select="//v_in//div[@id = 'edition'][1]//div[starts-with(@id, concat('div', $f_n, '-', $tx_n, '-'))]"
                            mode="copyEpidoc"/>
                          <xsl:apply-templates
                            select="//v_in//div[@id = 'edition'][1]//p[starts-with(@id, concat('miniapp', $f_n, '-', $tx_n, '-'))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:when test="$f_n and (not($tx_n) or $tx_n = '0')">
                          <xsl:apply-templates
                            select="//v_in//div[@id = 'edition'][1]//div[@class = 'textpart'][child::span[@class = 'ab'][starts-with(@id, concat('div', $f_n, '-'))]]"
                            mode="copyEpidoc"/>
                          <xsl:apply-templates
                            select="//v_in//div[@id = 'edition'][1]//p[starts-with(@id, concat('miniapp', $f_n, '-'))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates
                            select="//v_in//div[@id = 'edition'][1]/*[not(self::h2)]"
                            mode="copyEpidoc"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </section>

                  <!-- Diplomatic -->
                  <section>
                    <p class="title" data-section-title="true">
                      <a href="#diplomatic{if (@n) then @n else '1'}">
                        <i18n:text>Diplomatic</i18n:text>
                      </a>
                    </p>
                    <div id="diplomatic{if (@n) then @n else '1'}" class="content diplomatic"
                      data-section-content="true">
                      <xsl:choose>
                        <xsl:when test="$f_n and $tx_n and $tx_n != '0'">
                          <xsl:apply-templates
                            select="//v_di//div[@id = 'edition'][1]//div[starts-with(@id, concat('div', $f_n, '-', $tx_n, '-'))]"
                            mode="copyEpidoc"/>
                          <xsl:apply-templates
                            select="//v_di//div[@id = 'edition'][1]//p[starts-with(@id, concat('miniapp', $f_n, '-', $tx_n, '-'))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:when test="$f_n and (not($tx_n) or $tx_n = '0')">
                          <xsl:apply-templates
                            select="//v_di//div[@id = 'edition'][1]//div[@class = 'textpart'][child::span[@class = 'ab'][starts-with(@id, concat('div', $f_n, '-'))]]"
                            mode="copyEpidoc"/>
                          <xsl:apply-templates
                            select="//v_di//div[@id = 'edition'][1]//p[starts-with(@id, concat('miniapp', $f_n, '-'))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates
                            select="//v_di//div[@id = 'edition'][1]/*[not(self::h2)]"
                            mode="copyEpidoc"/>
                        </xsl:otherwise>
                      </xsl:choose>

                    </div>
                  </section>

                  <!-- Epidoc XML -->
                  <section>
                    <p class="title" data-section-title="true">
                      <a href="#epidoc{if (@n) then @n else '1'}">
                        <i18n:text>EpiDoc (XML)</i18n:text>
                      </a>
                    </p>
                    <div id="epidoc{if (@n) then @n else '1'}" class="content epidoc_xml epidoc"
                      data-section-content="true">
                      <pre>
                        <code class="language-xml">
                          <xsl:choose>
                            <xsl:when test="$f_n and $tx_n and $tx_n != '0'">
                              <xsl:copy-of select="/aggregation/v_ep/div[@type = 'edition'][@n = $fullN]/node()"/>
                            </xsl:when>
                            <xsl:when test="$f_n and (not($tx_n) or $tx_n = '0')">
                              <xsl:copy-of select="/aggregation/v_ep/div[@type = 'edition'][@n = $f_n]/node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:copy-of select="/aggregation/v_ep/node()"/>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:text/>
                        </code>
                      </pre>
                    </div>
                  </section>

                  <!-- Edition in Verse (If it exists)-->
                  <xsl:if test="descendant::tei:lg">
                    <section>
                      <p class="title" data-section-title="true">
                        <a href="#verse{if (@n) then @n else '1'}">
                          <i18n:text>Edition in Verse</i18n:text>
                        </a>
                      </p>
                      <div id="verse{if (@n) then @n else '1'}" class="content"
                        data-section-content="true">
                        <xsl:choose>
                          <xsl:when test="@n">
                            <xsl:variable name="tet" select="@n"/>
                            <xsl:apply-templates
                              select="//v_ve//div[@id = 'edition'][1]//div[starts-with(@id, concat('div', $tet))]"
                              mode="copyEpidoc"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:apply-templates
                              select="//v_ve//div[@id = 'edition'][1]/*[not(self::h2)]"
                              mode="copyEpidoc"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </div>
                    </section>
                  </xsl:if>
                </div>
              </div>

            </div>

            <!-- Commentaries -->
            <xsl:if
              test="normalize-space($fullN) = '' and (//tei:div[@type = 'bibliography'][@subtype = 'commentaries'][@n = $fullN or not(@n)]//(text()[not(normalize-space(.) = '')]))">
              <div class="row">
                <div class="large-3 columns">
                  <h6>
                    <i18n:text>Commentaries</i18n:text>
                  </h6>
                </div>
                <div class="large-9 columns">
                  <p>
                    <xsl:variable name="surnames">
                      <xsl:sequence select="//surnames//tei:listPerson/tei:person"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="
                          normalize-space($fullN) = '' and
                          (//tei:div[@type = 'bibliography'][@subtype = 'commentaries'][tei:listBibl//text()[not(normalize-space(.) = '')]]
                          or //tei:div[@type = 'bibliography'][@subtype = 'commentaries'][tei:listBibl//tei:ptr])">
                        <xsl:for-each
                          select="//tei:div[@type = 'bibliography'][@subtype = 'commentaries']/tei:listBibl">
                          <xsl:if test="@n">
                            <em>
                              <i18n:text>Fr.</i18n:text>
                              <xsl:text/>
                              <xsl:value-of select="@n"/>
                              <xsl:text>.&#160;</xsl:text>
                            </em>
                          </xsl:if>
                          <xsl:apply-templates select="tei:bibl"/>
                          <xsl:if
                            test="not(string(normalize-space(self::tei:listBibl))) and not(descendant::tei:ptr)">
                            <i18n:text>Unpublished</i18n:text>
                          </xsl:if>
                          <xsl:if test="position() != last()">
                            <xsl:text>.&#160;</xsl:text>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:when test="
                          //tei:div[@type = 'bibliography'][@subtype = 'commentaries'][tei:listBibl[@n = $fullN or not(@n)]//(text()[not(normalize-space(.) = '')])]
                          or //tei:div[@type = 'bibliography'][@subtype = 'commentaries'][tei:listBibl[@n = $fullN or not(@n)]//tei:ptr]">
                        <xsl:apply-templates
                          select="//tei:div[@type = 'bibliography'][@subtype = 'commentaries']/tei:listBibl[@n = $fullN or not(@n)]/tei:bibl"
                        />
                      </xsl:when>
                      <xsl:otherwise>
                        <i18n:text>Unpublished</i18n:text>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.&#160;</xsl:text>
                  </p>
                </div>
              </div>
            </xsl:if>
          </div>
        </div>

        <!-- Apparatus Criticus -->

        <xsl:if
          test="//tei:div[@type = 'apparatus'][@n = $fullN or not(@n)][descendant::tei:app[descendant::text() or descendant::tei:*]]">
          <div class="row">
            <div class="large-2 columns">
              <xsl:text>&#160;</xsl:text>
            </div>
            <div class="large-10 columns details">
              <div class="row">
                <div class="large-3 columns">
                  <h6>
                    <i18n:text>Apparatus criticus</i18n:text>
                  </h6>
                </div>
                <div class="large-9 columns">
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type = 'apparatus'][@n = $fullN or not(@n)]"/>

                </div>
              </div>

            </div>
          </div>
        </xsl:if>

        <!-- Translation -->

        <div class="row">
          <div class="large-2 columns">
            <h2>
              <em>
                <i18n:text>Translation</i18n:text>
              </em>
            </h2>
          </div>
          <div class="large-10 columns details">
            <!-- N.B. Leaving @n=none and @n=notyet even though they are not used in corpus yet -->
            <xsl:choose>
              <xsl:when test="//tei:div[@type = 'translation'][@n = 'none'][@xml:lang = $lang]">
                <i18n:text>not usefully translatable</i18n:text>. </xsl:when>
              <xsl:when test="//tei:div[@type = 'translation'][@n = 'notyet'][@xml:lang = $lang]">
                <i18n:text>No translation yet (2010)</i18n:text>. </xsl:when>
              <xsl:when test="@n">
                <xsl:apply-templates mode="multipara"
                  select="//tei:div[@type = 'translation'][@xml:lang = $lang]/tei:div[@type = 'textpart'][@n = $fullN]"
                />
              </xsl:when>
              <xsl:when test="//tei:div[@type = 'translation']/tei:div[@type = 'textpart'][@n]">
                <xsl:for-each
                  select="//tei:div[@type = 'translation'][@xml:lang = $lang]/tei:div[@type = 'textpart'][@n]">
                  <span class="textpartnum">
                    <xsl:value-of select="@n"/>
                  </span>
                  <xsl:apply-templates mode="multipara"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="multipara"
                  select="//tei:div[@type = 'translation'][@xml:lang = $lang]"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#160;</xsl:text>
          </div>
        </div>


        <!-- Commentary -->
        <!-- PC  31 OCT 2017:  put in the 'if' condition as temporary measure to hide from display editor's 
          commentary section for those vol 3 files for which the bibliography says 'Ineditum' -->
        <xsl:if
          test="not(contains(//tei:body/tei:div[@type = 'bibliography'][1]/tei:listBibl[1]/tei:bibl[1], 'Ineditum'))">
          <xsl:choose>
            <xsl:when
              test="//tei:div[@type = 'commentary'][@xml:lang = $lang]/tei:div[@type = 'textpart'][@n = $fullN]">
              <div class="row">
                <div class="large-2 columns">
                  <h2>
                    <em>
                      <i18n:text>Commentary</i18n:text>
                    </em>
                  </h2>

                </div>
                <div class="large-10 columns details">
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type = 'commentary'][@xml:lang = $lang]/tei:div[@type = 'textpart'][@n = $fullN]"/>
                  <xsl:text>&#160;</xsl:text>
                </div>
              </div>
            </xsl:when>
            <xsl:when
              test="not($fullN) and //tei:div[@type = 'commentary'][@xml:lang = $lang]//tei:p/text()">
              <div class="row">
                <div class="large-2 columns">
                  <h2>
                    <em>
                      <i18n:text>Commentary</i18n:text>
                    </em>
                  </h2>

                </div>
                <div class="large-10 columns details">
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type = 'commentary'][@xml:lang = $lang]"/>
                  <xsl:text>&#160;</xsl:text>
                </div>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <!-- do nothing -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>


        <!-- Images -->

        <xsl:if
          test="//tei:facsimile//tei:graphic[contains(concat(' ', @n, ' '), $fullN) or not(@n)]">
          <div class="row">
            <div class="large-2 columns">
              <h2>
                <em>
                  <i18n:text>Images</i18n:text>
                </em>
              </h2>
            </div>
            <div class="large-10 columns details">
              <xsl:apply-templates
                select="//tei:facsimile//tei:graphic[contains(concat(' ', @n, ' '), $fullN) or not(@n)]"
                mode="photograph"/>

            </div>
          </div>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <!--DIVS-->
  <xsl:template match="tei:div">
    <xsl:choose>
      <xsl:when test="@type = 'edition'">
        <!-- Removes edition div, content is preprocessed and copied -->
      </xsl:when>
      <xsl:when test="@type = 'metadata' and (@n = 'category-text' or @n = 'category-monument')">
        <!-- Removes categoy-text and category-monument -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- BIBLIOGRAPHY (pointers) -->
  <xsl:template match="tei:bibl//tei:ptr">
    <xsl:apply-templates select="//bib//tei:bibl[@id = substring-after(current()/@target, 'bib:')]"
    />
  </xsl:template>

  <xsl:template match="tei:bibl//tei:seg[@xml:lang]">
    <xsl:if test="@xml:lang = $lang">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>


  <!-- IMAGES (photograph [default] and representation [mode]) -->
  <xsl:template match="tei:facsimile" mode="photograph">
    <div class="image" xsl:exclude-result-prefixes="tei">
      <div class="t04">
        <xsl:apply-templates select=".//tei:graphic"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:facsimile" mode="representation">
    <div class="image" xsl:exclude-result-prefixes="tei">
      <div class="t04">
        <xsl:apply-templates select=".//tei:graphic[@decls = '#representation']"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:div/tei:head"/>


  <!-- Mode multipara -->
  <xsl:template match="tei:p | tei:ab" mode="multipara">
    <p xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="tei:div/tei:head" mode="multipara"/>

  <xsl:template match="tei:dimensions">
    <xsl:choose>
      <xsl:when test="not(tei:height) and not(tei:width) and not(tei:depth)">
        <i18n:text>Unknown</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="tei:height">
          <i18n:text key="__Height">H.</i18n:text>
          <xsl:text/>
          <xsl:choose>
            <xsl:when test="tei:height[. = '?']">
              <i18n:text>unknown</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="
                  if ($lang = 'ru') then
                    tei:height
                  else
                    translate(tei:height, ',', '.')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="tei:width">
          <xsl:choose>
            <xsl:when test="tei:height">
              <i18n:text key="__dim_separator">, </i18n:text>
              <i18n:text key="__width">W.</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <i18n:text key="__Width">W.</i18n:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text/>
          <xsl:choose>
            <xsl:when test="tei:width[. = '?']">
              <i18n:text>unknown</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="
                  if ($lang = 'ru') then
                    tei:width
                  else
                    translate(tei:width, ',', '.')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="tei:depth">
          <xsl:choose>
            <xsl:when test="tei:height or tei:width">
              <i18n:text key="__dim_separator">, </i18n:text>
              <i18n:text key="__depth">Th.</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <i18n:text key="__Depth">Th.</i18n:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text/>
          <xsl:choose>
            <xsl:when test="tei:depth[. = '?']">
              <i18n:text>unknown</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="
                  if ($lang = 'ru') then
                    tei:depth
                  else
                    translate(tei:depth, ',', '.')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="tei:dim[@type = 'diameter']">
          <xsl:choose>
            <xsl:when test="tei:height or tei:width or tei:depth">
              <i18n:text key="__dim_separator">, </i18n:text>
              <i18n:text key="__diameter">Diam.</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <i18n:text key="__Diameter">Diam.</i18n:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text/>
          <xsl:choose>
            <xsl:when test="tei:dim[@type = 'diameter'][. = '?']">
              <i18n:text>unknown</i18n:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="
                  if ($lang = 'ru') then
                    tei:dim[@type = 'diameter']
                  else
                    translate(tei:dim[@type = 'diameter'], ',', '.')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>


    <!-- replaced old content with choose from support/dimensions tests above -->
  </xsl:template>

  <xsl:template match="tei:lb">
    <xsl:text>|</xsl:text>
  </xsl:template>
  <!-- FIGURES -->
  <xsl:template match="tei:facsimile//tei:graphic" mode="photograph">
    <span
      style="height: 100%; min-height: 106px; min-width: 106px; text-align: center; vertical-align: middle;">
      <!-- Full size popup -->
      <a class="x87" target="_blank"
        href="/iiif/2/inscriptions%2f{@url}.jp2/full/max/0/default.jpg">
        <span>&#160;</span>
        <!-- Thumbnail image -->
        <img src="/iiif/2/inscriptions%2f{@url}.jp2/full/100,100/0/default.jpg">
          <!-- @alt info -->
          <xsl:if test="string(tei:desc[@xml:lang = $lang])">
            <xsl:attribute name="alt">
              <xsl:value-of select="tei:desc[@xml:lang = $lang]"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="tei:desc[@xml:lang = $lang]"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </a>
    </span>
  </xsl:template>

  <xsl:template name="lang-grc">
    <xsl:if test="ancestor-or-self::tei:div[@lang = 'grc']">
      <xsl:attribute name="class">
        <xsl:text>greek</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:*[@lang = 'la']">
    <em xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <!-- BIBLIO -->
  <xsl:template match="tei:bibl[title = 'PHI' or title = 'EDH']//tei:citedRange">
    <xsl:choose>
      <xsl:when test="tei:title = 'PHI' and @n">
        <a class="intNew" rel="external" target="_blank" xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="title">
            <i18n:text>Link to PHI Inscriptions (opens in new window)</i18n:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>http://epigraphy.packhum.org/inscriptions/oi?ikey=</xsl:text>
            <xsl:value-of select="@n"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="tei:title = 'EDH' and @n">
        <a class="intNew" rel="external" target="_blank" xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="title">
            <i18n:text>Link to EDH Inscriptions (opens in new window)</i18n:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>http://edh-www.adw.uni-heidelberg.de/EDH/servlet/EgrForm?aktion=eingabe&amp;benutzer=gast&amp;kennwort=g2dhst&amp;f_id_nr='</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>'</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:bibl/tei:title">
    <xsl:choose>
      <xsl:when test="@level = 'm' or @level = 'j'">
        <em xsl:exclude-result-prefixes="tei">
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:when test="@level = 'a' or @level = 'u'">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template
    match="tei:author[ancestor::tei:bibl[@rend = 'primary']][not(preceding-sibling::tei:author)]">
    <xsl:text>&#8226;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="editions_author_name">
    <xsl:param name="surnames"/>
    <xsl:param name="author"/>
    <xsl:choose>
      <xsl:when test="$author/tei:surname">
        <xsl:choose>
          <xsl:when test="$author/tei:surname[@corresp]">
            <xsl:variable name="person_id">
              <xsl:value-of select="substring-after($author/tei:surname/@corresp, 'surnames.xml#')"
              />
            </xsl:variable>
            <xsl:value-of
              select="$surnames/tei:person[@xml:id = $person_id]/tei:persName/tei:surname[@xml:lang = $lang or not(@xml:lang)]"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="
                $author//tei:surname[if (not(@xml:lang)) then
                  true()
                else
                  @xml:lang = $lang][1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$author/tei:forename">
        <xsl:value-of select="
            normalize-space($author//tei:forename[if (not(@xml:lang)) then
              true()
            else
              @xml:lang = $lang][1])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="
            normalize-space($author//tei:*[if (not(@xml:lang)) then
              true()
            else
              @xml:lang = $lang][1])"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="tei:bibl">
    <xsl:if test="@n">
      <xsl:value-of select="@n"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:variable name="surnames">
      <xsl:sequence select="//surnames//tei:listPerson/tei:person"/>
    </xsl:variable>
    <xsl:variable name="target" select="substring-after(tei:ptr/@target, 'bib:')"/>
    <xsl:for-each
      select="//bib//tei:biblStruct[@xml:id = $target] | //bib//tei:bibl[@xml:id = $target]">
      <xsl:choose>
        <xsl:when test="@xml:id = 'IOSPE'">
          <xsl:text>IOSPE</xsl:text>
        </xsl:when>
        <xsl:when test="@xml:id = 'IOSPE2'">
          <xsl:text>IOSPE I</xsl:text>
          <xsl:element name="sup">
            <xsl:text>2</xsl:text>
          </xsl:element>
        </xsl:when>
        <xsl:when test="@xml:id = 'НЭПХ'">
          <xsl:text>НЭПХ I</xsl:text>
          <xsl:if test="$lang = 'en'">
            <xsl:text> (Solomonik 1964)</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="@xml:id = 'НЭПХ2'">
          <xsl:text>НЭПХ II</xsl:text>
          <xsl:if test="$lang = 'en'">
            <xsl:text> (Solomonik 1973)</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="descendant::tei:title[@type = 'abbreviated']">
          <xsl:apply-templates select="descendant::tei:title[@type = 'abbreviated']"/>
        </xsl:when>
        <xsl:when test="descendant::tei:title[@type = 'full']">
          <xsl:apply-templates select="descendant::tei:title[@type = 'full']"/>
        </xsl:when>
        <xsl:when test="descendant::tei:analytic//tei:author">
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:analytic[1]//tei:author[1]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="descendant::tei:monogr//tei:author">
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:monogr//tei:author[1]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="descendant::tei:author">
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:author[1]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="descendant::tei:analytic//tei:author[2]">
          <xsl:text>, </xsl:text>
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:analytic[1]//tei:author[2]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when
          test="not(descendant::tei:analytic//tei:author) and descendant::tei:monogr//tei:author[2]">
          <xsl:text>, </xsl:text>
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:monogr//tei:author[2]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when
          test="not(descendant::tei:analytic//tei:author) and not(descendant::tei:monogr//tei:author) and descendant::tei:author[2]">
          <xsl:text>, </xsl:text>
          <xsl:call-template name="editions_author_name">
            <xsl:with-param name="author" select="descendant::tei:author[2]"/>
            <xsl:with-param name="surnames" select="$surnames"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="
          descendant::tei:analytic//tei:author[3] or
          (not(descendant::tei:analytic//tei:author) and descendant::tei:monogr//tei:author[3]) or
          (not(descendant::tei:analytic//tei:author) and not(descendant::tei:monogr//tei:author) and descendant::tei:author[3])">
        <xsl:text>, et al.</xsl:text>
      </xsl:if>

      <xsl:if test="descendant::tei:imprint[1]/tei:date[1]">
        <xsl:text/>
        <xsl:apply-templates select="descendant::tei:imprint[1]/tei:date[1]"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:apply-templates/>

    <xsl:if test="following-sibling::tei:bibl[child::node()]">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- EDITORIAL AMENDMENTS -->
  <xsl:template match="tei:unclear[@reason = 'damage']">
    <xsl:call-template name="subpunct">
      <xsl:with-param name="unc-len" select="string-length(.)"/>
      <xsl:with-param name="abs-len" select="string-length(.) + 1"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template name="subpunct">
    <xsl:param name="abs-len"/>
    <xsl:param name="unc-len"/>
    <xsl:if test="$unc-len != 0">
      <xsl:value-of select="substring(., number($abs-len - $unc-len), 1)"/>
      <xsl:text>&#x0323;</xsl:text>
      <xsl:call-template name="subpunct">
        <xsl:with-param name="unc-len" select="$unc-len - 1"/>
        <xsl:with-param name="abs-len" select="string-length(.) + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <xsl:template match="tei:gap[@reason = 'omitted']">
    <xsl:text>(---)</xsl:text>
  </xsl:template>



  <xsl:template match="tei:gap[@reason = 'ellipsis']">
    <xsl:text> ... </xsl:text>
  </xsl:template>



  <xsl:template match="tei:gap">
    <xsl:if test="@reason = 'lost' and not(@dim = 'top')">
      <xsl:call-template name="lost-opener"/>
    </xsl:if>
    <xsl:if test="following-sibling::tei:certainty[@target = current()/@xml:id and @degree = 'low']">
      <xsl:text>?</xsl:text>
    </xsl:if>
    <xsl:choose>
      <!-- condition -->
      <xsl:when test="@quantity and @unit = 'character'">
        <xsl:choose>
          <xsl:when test="@quantity = '1'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;</xsl:text>
          </xsl:when>
          <xsl:when test="@quantity = '2'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7;</xsl:text>
          </xsl:when>
          <xsl:when test="@quantity = '3'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7;&#xb7;</xsl:text>
          </xsl:when>
          <!-- PC JULY 2015: found this commented out block of code below; OK to delete? -->
          <!--<xsl:when test="quantity(@quantity)>3">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7; c. </xsl:text>
            <xsl:value-of select="@quantity"/>
            <xsl:text> &#xb7;&#xb7;</xsl:text>
          </xsl:when>-->
          <xsl:otherwise>
            <xsl:text>&#xb7;&#xb7; ? &#xb7;&#xb7;</xsl:text>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@quantity and @unit = 'cm'">
        <xsl:apply-templates/>
        <xsl:text>&#xb7;&#xb7; c. </xsl:text>
        <xsl:value-of select="@quantity"/>
        <xsl:text> cm &#xb7;&#xb7;</xsl:text>
      </xsl:when>
      <!-- extent = unknown -->
      <xsl:when test="@extent = 'unknown'">
        <xsl:apply-templates/>
        <xsl:text>&#xb7;&#xb7; ? &#xb7;&#xb7;</xsl:text>
      </xsl:when>
      <!-- default -->
      <xsl:otherwise>
        <xsl:text>&#xb7;&#xb7; ? &#xb7;&#xb7;</xsl:text>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@reason = 'lost' and not(@dim = 'bottom')">
      <xsl:call-template name="lost-closer"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="tei:ex">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>


  <xsl:template match="tei:abbr">
    <xsl:apply-templates/>
    <xsl:if
      test="not(parent::tei:expan) and not(following-sibling::tei:supplied[@reason = 'abbreviation'])">
      <xsl:text>(?)</xsl:text>
    </xsl:if>
  </xsl:template>



  <xsl:template match="tei:orig">
    <xsl:choose>
      <xsl:when test="ancestor::tei:expan and not(contains(@n, 'unresolved'))"/>
      <xsl:when test="contains(@n, 'unresolved')">
        <span style="text-transform: uppercase ;" xsl:exclude-result-prefixes="tei">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:note">
    <span class="default-lang" xsl:exclude-result-prefixes="tei">
      <xsl:choose>
        <xsl:when test="ancestor::tei:app">
          <!-- PC JULY 2015: found this commented out block of code below; OK to delete? -->
          <!--<xsl:if test="parent::tei:lem or parent::tei:rdg">
            <xsl:text>:</xsl:text>
          </xsl:if>-->
          <xsl:apply-templates/>
          <xsl:if test="preceding-sibling::tei:rdg and following-sibling::tei:rdg">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="ancestor::tei:bibl">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::tei:p">
          <xsl:call-template name="note-par"/>
        </xsl:when>
        <xsl:when test="ancestor::tei:l">
          <xsl:call-template name="note-par"/>
        </xsl:when>
        <xsl:when test="ancestor::tei:div[@type = 'translation'] and parent::tei:p">
          <xsl:text>(</xsl:text>
          <em>
            <xsl:apply-templates/>
          </em>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:when
          test="parent::tei:div[@type = 'translation'] or parent::tei:div[@type = 'textpart'][parent::tei:div[@type = 'translation']]">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::tei:ab">
          <xsl:choose>
            <xsl:when test="@rend = 'italic'">
              <em>
                <xsl:apply-templates/>
              </em>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="note-par"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <dd>
            <xsl:call-template name="note-par"/>
          </dd>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template name="note-par">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="tei:space">
    <xsl:choose>
      <!-- condition -->
      <xsl:when test="@quantity = '1' and @unit = 'character'">
        <xsl:apply-templates/>
        <em xsl:exclude-result-prefixes="tei">
          <sup>
            <xsl:text/>
            <xsl:if
              test="following-sibling::tei:certainty[@target = current()/@xml:id and @degree = 'low']">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:text>v. </xsl:text>
          </sup>
        </em>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@unit = 'line'">
        <xsl:apply-templates/>
        <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
        <em xsl:exclude-result-prefixes="tei">
          <span class="smaller">
            <xsl:if
              test="following-sibling::tei:certainty[@target = current()/@xml:id and @degree = 'low']">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:text>vacat </xsl:text>
          </span>
        </em>
      </xsl:when>
      <!-- default -->
      <xsl:otherwise>
        <xsl:apply-templates/>
        <em xsl:exclude-result-prefixes="tei">
          <span class="smaller">
            <xsl:text/>
            <xsl:if
              test="following-sibling::tei:certainty[@target = current()/@xml:id and @degree = 'low']">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:text>vac. </xsl:text>
          </span>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:surplus">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:choice[@type = 'correction']/tei:sic"/>

  <xsl:template match="tei:choice[@type = 'correction']/tei:corr">
    <xsl:text>&#x231C;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#x231D;</xsl:text>
  </xsl:template>


  <xsl:template match="tei:supplied">
    <xsl:choose>
      <!-- condition -->
      <xsl:when test="@reason = 'lost'">
        <xsl:call-template name="lost-opener"/>
        <xsl:apply-templates/>
        <xsl:call-template name="cert-low"/>
        <xsl:call-template name="lost-closer"/>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason = 'omitted'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:call-template name="cert-low"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason = 'subaudible'">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:call-template name="cert-low"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason = 'abbreviation'">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:call-template name="cert-low"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason = 'explanation'">
        <xsl:text>(i.e. </xsl:text>
        <xsl:apply-templates/>
        <xsl:call-template name="cert-low"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!-- default -->
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:g">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="@type = 'denarius'">
        <xsl:text>&#x10196;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <em xsl:exclude-result-prefixes="tei">
          <span class="smaller">
            <xsl:value-of select="@type"/>
          </span>
        </em>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:apply-templates/>
    <xsl:if test="ancestor::tei:w">
      <xsl:text> </xsl:text>
    </xsl:if>
    <em xsl:exclude-result-prefixes="tei">
      <span class="smaller">
        <xsl:value-of select="@type"/>
      </span>
    </em>
    <xsl:if test="ancestor::tei:w">
      <xsl:text> </xsl:text>
    </xsl:if> -->
  </xsl:template>

  <xsl:template match="tei:add">
    <span class="addedtext" xsl:exclude-result-prefixes="tei">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#xb4;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:del">
    <span class="deletedtext" xsl:exclude-result-prefixes="tei">
      <xsl:text>[[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:rs[@cert = 'low']">
    <xsl:text>?</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- SEG -->
  <xsl:template match="tei:seg[@cert = 'low']">
    <xsl:text>?</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:provenance[@type = 'observed'][@subtype = 'autopsy']">
    <span class="autopsy" xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </span>
  </xsl:template>



  <xsl:template match="tei:emph">
    <em xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </em>
  </xsl:template>



  <xsl:template match="tei:width | tei:height | tei:depth">
    <xsl:if test="ancestor::tei:div[@type = 'description'][@n != 'letters']">
      <xsl:choose>
        <xsl:when test="self::tei:width">
          <xsl:text>W. </xsl:text>
        </xsl:when>
        <xsl:when test="self::tei:height">
          <xsl:text>H. </xsl:text>
        </xsl:when>
        <xsl:when test="self::tei:depth">
          <xsl:text>D. </xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@precision = 'circa'">
      <xsl:text>c. </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>


  <!-- Templates for opening and closing brackets for gap and supplied -->
  <xsl:template name="lost-opener">
    <xsl:choose>
      <!--1.
````````__|__
```````|`````|
```````x`````x
      -->
      <xsl:when test="preceding-sibling::tei:*[1][@reason = 'lost']">
        <xsl:if
          test="preceding-sibling::text() and preceding-sibling::tei:*[1][following-sibling::text()]">
          <xsl:variable name="curr-prec" select="generate-id(preceding-sibling::text()[1])"/>
          <xsl:for-each select="preceding-sibling::tei:*[1][@reason = 'lost']">
            <xsl:choose>
              <xsl:when test="generate-id(following-sibling::text()[1]) = $curr-prec">
                <xsl:if test="not(following-sibling::text()[1] = ' ')">
                  <xsl:text>[</xsl:text>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>


      <!--2.
````````__|__
```````|```__|__
```````x``|`````|
``````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1][@reason = 'lost']]]"/>


      <!--3.
````````__|__
`````__|__```|
````|`````|``x
``````````x
      -->
      <xsl:when
        test="preceding-sibling::tei:*[1]/tei:*[not(following-sibling::node())][@reason = 'lost']">
        <xsl:if test="preceding-sibling::node()[1]/self::text()">
          <xsl:if test="preceding-sibling::node()[1][not(normalize-space(.) = '')]">
            <xsl:text>[</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:when>


      <!--4.
````````____|____
`````__|__`````__|__
````|`````|```|`````|
``````````x```x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason = 'lost']]]"/>


      <!--5.
````````____|____
`````__|__```````|
````|```__|__````x
```````|`````|
`````````````x
      -->
      <xsl:when
        test="preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason = 'lost']"/>


      <!--6.
````````____|____
`````__|__`````__|__
````|```__|__`|`````|
```````|`````|x
`````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason = 'lost']]]"/>


      <!--7.
````````______|______
`````__|__`````````__|__
````|```__|__```__|__```|
```````|`````|`|`````|
`````````````x`x
      -->


      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason = 'lost']]]]"/>


      <!--8.
````````______|______
```````|```````````__|__
```````x````````__|__```|
```````````````|`````|
```````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1][@reason = 'lost']]]]"/>



      <!--9.
````````______|______
`````__|__`````````__|__
````|`````|`````__|__```|
``````````x````|`````|
```````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::node())][@reason = 'lost']]]]">
        <xsl:if test="parent::tei:*[parent::tei:*[preceding-sibling::node()[1]/self::text()]]">
          <xsl:if
            test="parent::tei:*[parent::tei:*[normalize-space(preceding-sibling::node()[1]) != '']]"
            >[</xsl:if>
        </xsl:if>
      </xsl:when>


      <!-- 10. -->
      <xsl:when
        test="preceding-sibling::tei:*[1][local-name() = 'lb'] and preceding-sibling::tei:*[2][local-name() = 'supplied' and @reason = 'lost']">

        <xsl:variable name="curr-prec-txt" select="generate-id(preceding-sibling::text()[1])"/>
        <xsl:for-each select="preceding-sibling::tei:*[1][local-name() = 'lb']">
          <xsl:choose>
            <xsl:when
              test="following-sibling::text() and generate-id(following-sibling::text()[1]) = $curr-prec-txt and not(following-sibling::text()[1] = ' ')">
              <xsl:text>[</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="lb-prec-txt" select="generate-id(preceding-sibling::text()[1])"/>
              <xsl:for-each select="preceding-sibling::tei:*[1][@reason = 'lost']">
                <xsl:choose>
                  <xsl:when
                    test="following-sibling::text() and generate-id(following-sibling::text()[1]) = $lb-prec-txt and not(following-sibling::text()[1] = ' ')">
                    <xsl:text>[</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="lost-closer">
    <xsl:choose>
      <!-- 1. -->
      <xsl:when test="following-sibling::tei:*[1][@reason = 'lost']">
        <xsl:if
          test="following-sibling::text() and following-sibling::tei:*[1][preceding-sibling::text()]">
          <xsl:variable name="curr-foll" select="generate-id(following-sibling::text()[1])"/>
          <xsl:for-each select="following-sibling::tei:*[1][@reason = 'lost']">
            <xsl:choose>
              <xsl:when
                test="generate-id(preceding-sibling::text()[1]) = $curr-foll and not(preceding-sibling::text()[1] = ' ')">
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
      <!-- 2. -->
      <xsl:when
        test="following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason = 'lost']"/>
      <!-- 3. -->
      <xsl:when
        test="current()[not(following-sibling::node())][parent::node()[following-sibling::tei:*[1][@reason = 'lost']]]">
        <xsl:variable name="curr-foll-txt" select="generate-id(following-sibling::text()[1])"/>
        <xsl:choose>
          <xsl:when
            test="parent::node()/following-sibling::tei:*[1][@reason = 'lost'][generate-id(preceding-sibling::text()[1]) = $curr-foll-txt]"
            >]</xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- 4. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason = 'lost']]]"/>
      <!-- 5. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1][@reason = 'lost']]]]"/>
      <!-- 6. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason = 'lost']]]]"/>
      <!-- 7. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())]/tei:*[not(preceding-sibling::node())][@reason = 'lost']]]]"/>
      <!-- 8. -->
      <xsl:when
        test="following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())]/tei:*[not(preceding-sibling::node())][@reason = 'lost']"/>
      <!-- 9. -->
      <xsl:when
        test="current()[not(following-sibling::node())][parent::tei:*[following-sibling::tei:*[1]/child::node()[1]/child::node()[1][@reason = 'lost']]]">
        <xsl:if test="parent::tei:*[following-sibling::node()[1]/self::text()]">
          <xsl:if test="parent::tei:*[normalize-space(following-sibling::node()[1]) != '']"
            >]</xsl:if>
        </xsl:if>
      </xsl:when>
      <!-- 10. -->
      <xsl:when
        test="following-sibling::tei:*[1][local-name() = 'lb'] and following-sibling::tei:*[2][local-name() = 'supplied' and @reason = 'lost']">
        <xsl:variable name="curr-prec-txt" select="generate-id(following-sibling::text()[1])"/>
        <xsl:for-each select="following-sibling::*[1][local-name() = 'lb']">
          <xsl:choose>
            <xsl:when
              test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1]) = $curr-prec-txt and not(preceding-sibling::text()[1] = ' ')">
              <xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="lb-prec-txt" select="generate-id(following-sibling::text()[1])"/>
              <xsl:for-each select="following-sibling::tei:*[1][@reason = 'lost']">
                <xsl:choose>
                  <xsl:when
                    test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1]) = $lb-prec-txt and not(preceding-sibling::text()[1] = ' ')">
                    <xsl:text>]</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="cert-low">
    <xsl:if test="@cert = 'low'">
      <xsl:text>?</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:certainty[@cert = 'low']">
    <xsl:text> (?)</xsl:text>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'sup']">
    <sup>
      <xsl:apply-templates/>
      <xsl:text/>
    </sup>
  </xsl:template>

</xsl:stylesheet>
