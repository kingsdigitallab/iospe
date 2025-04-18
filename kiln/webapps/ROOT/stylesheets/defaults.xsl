<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
  <!--
      Defaults stylesheet. Defines default globals and reads
      parameters from the sitemap.
  -->
  <xsl:param name="url" select="''"/>
  <!-- $language is the language code used to distinguish between
       language contexts in a multilingual site. -->
  <xsl:param name="language" select="''"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:variable name="kiln:url-lang-suffix">
    <xsl:choose>
      <xsl:when test="$lang = 'ru'">-ru</xsl:when>
      <xsl:when test="$lang = 'uk'">-uk</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>


  <!-- minimum and maximums years of inscriptions -->
  <xsl:variable as="xs:integer" name="kiln:min-year" select="-500"/>
  <xsl:variable as="xs:integer" name="kiln:max-year" select="1800"/>

  <!-- Specify a mount path if you are mounting the webapp in a
       subdirectory rather than at the root of the domain. This path
       must either be empty or begin with a "/" and not include a
       trailing slash.

       The value is the URL root for the webapp. -->
  <xsl:variable name="kiln:mount-path" select="''"/>

  <!-- $kiln:context-path defines the URL root for the webapp. -->
  <xsl:variable name="kiln:context-path">
    <xsl:value-of select="$kiln:mount-path"/>
    <xsl:if test="$language">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$language"/>
    </xsl:if>
  </xsl:variable>

  <!-- Base URL for non-textual content (images, video, etc). If these
       are being served by Cocoon, this should be specified as
       relative to $context-path. Otherwise, a full URL including
       protocol and domain is required.

       This URL must not include a trailing slash. -->
  <xsl:variable name="kiln:content-url" select="''"/>
  <xsl:variable name="kiln:content-path">
    <xsl:if test="not(starts-with($kiln:content-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path"/>
    </xsl:if>
    <xsl:value-of select="$kiln:content-url"/>
  </xsl:variable>

  <!-- Base URL for assets (non-content images, CSS, JavaScript,
       etc). If these are being served by Cocoon, this should be
       specified as relative to $context-path. Otherwise, a full URL
       including protocol and domain is required.

       This URL must not include a trailing slash. -->
  <xsl:variable name="kiln:assets-url" select="'/assets'"/>
  <xsl:variable name="kiln:assets-path">
    <xsl:if test="not(starts-with($kiln:assets-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path"/>
    </xsl:if>
    <xsl:value-of select="$kiln:assets-url"/>
  </xsl:variable>

  <!-- Base URL for content images. -->
  <xsl:variable name="kiln:images-url" select="concat($kiln:content-path, '/images')"/>
  <xsl:variable name="kiln:images-path">
    <xsl:if test="not(starts-with($kiln:images-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path"/>
    </xsl:if>
    <xsl:value-of select="$kiln:images-url"/>
  </xsl:variable>

  <xsl:template name="menu-languages">
    <xsl:variable name="url_base">
      <xsl:choose>
        <xsl:when test="contains($url, '-ru')">
          <xsl:value-of select="replace($url, '(^.+?)(-ru)(\.html)(#person[0-9]+)?$', '$1')"/>
        </xsl:when>
        <xsl:when test="contains($url, '-uk')">
          <xsl:value-of select="replace($url, '(^.+?)(-uk)(\.html)(#person[0-9]+)?$', '$1')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace($url, '(^.+?)(\.html)(#person[0-9]+)?$', '$1')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url_suffix">
      <xsl:choose>
        <xsl:when test="contains($url, '#')">
          <xsl:value-of select="substring-after($url, '.html')"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    
    <!-- PC, 18 Apr 2025: THIS VARIABLE IS A TEMPORARY MEASURE TO ENSURE THAT A RUSSIAN LANGUAGE
      CHOICE DOESN'T APPEAR IN CERTAIN VOLUME 2 CONTEXTS. IT CAN BE REMOVED LATER -->
    <xsl:variable name="include_ru_lang_choice">
      <xsl:choose>
        <xsl:when test="contains($url_base, '2.')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, 'corpora/olbia')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>yes</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- END TEMP VARIABLE -->

    <!-- PC, 18 Apr 2025: THIS VARIABLE IS A TEMPORARY MEASURE TO ENSURE THAT A UKRAINIAN LANGUAGE
      CHOICE DOESN'T APPEAR IN CERTAIN CONTEXTS. IT CAN BE REMOVED ONCE UKRAINIAN
      VERSIONS OF THE INSCRIPTION FILES ARE IN PLACE -->
    <xsl:variable name="include_ukr_lang_choice">
      <xsl:choose>
        <xsl:when test="contains($url_base, 'indices') and contains($url_base, 'index')">
          <xsl:text>yes</xsl:text>
        </xsl:when>
        <xsl:when test="(contains($url_base, 'indices') and not(contains($url_base, 'index')))">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, 'toc')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, '1.')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, '2.')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, '3.')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, '5.')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, 'corpus/maps')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:when test="contains($url_base, 'corpora/olbia')">
          <xsl:text>no</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>yes</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- END TEMP VARIABLE -->
    
    <li class="lang en">
      <a class="en" href="/{$url_base}.html{$url_suffix}" title="English">en</a>
    </li>
    <xsl:choose>
      <xsl:when test="$include_ru_lang_choice = 'yes'">   
        <li class="lang py">
          <a class="py" href="/{$url_base}-ru.html{$url_suffix}" title="Русский">py</a>
        </li> 
      </xsl:when>
      <xsl:when test="$include_ukr_lang_choice = 'yes'">
        <li class="lang ук">
          <a class="ук" href="/{$url_base}-uk.html{$url_suffix}" title="Українська">укр</a>
        </li>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="jump-to-inscription">
    <!-- searchform -->
    <li class="has-form jump-form-container">
      <form id="jumpForm">
        <div class="row collapse">
          <div class="small-12 columns">
            <input id="numTxt" name="numTxt" type="text" placeholder="__jump_to_box_placeholder"
              i18n:attr="placeholder"/>
          </div>
        </div>
      </form>
    </li>
  </xsl:template>

  <xsl:template name="simple-search">
    <!-- THIS IS A TEMP VARIABLE REPLACING $LANG IN THE TEMPLATE BELOW
          PURPOSE IS TO KEEP THE LANG INPUT TO ENGLISH OR RUSSIAN
         THIS MAKESHIFT SOLUTION CAN GO ONCE UKRAINIAN INSCRIPTIONS ARE AVAILABLE-->
    <xsl:variable name="temporary-lang">
      <xsl:choose>
        <xsl:when test="$lang = 'ru'">
          <xsl:value-of select="$lang"/>
        </xsl:when>
        <xsl:when test="$lang = 'en'">
          <xsl:value-of select="$lang"/>
        </xsl:when>
        <xsl:when test="$lang = 'uk'">
          <xsl:text>en</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- END OF TEMP VARIABLE -->
    
    <!-- searchform -->
    <li class="has-form">
      <form id="simpleSearchForm" method="get" action="{concat('/search/', $temporary-lang, '/-500/1800/')}">
        <div class="row collapse">
          <div class="small-12 columns">
            <input id="query" name="query" type="text" placeholder="__search_box_placeholder"
              i18n:attr="placeholder"/>
            <input id="top-bar-search-dummy" name="top-bar-search-dummy" type="hidden" value="1"/>
          </div>
        </div>
      </form>
    </li>
  </xsl:template>


  <!-- LINKS -->
  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="@type = 'inscription'">


        <xsl:analyze-string regex="([IV]{{1,3}})\s(\d{{1,3}}[a-z]?)" select="normalize-space(.)">
          <xsl:matching-substring>
            <xsl:variable name="volume" select="regex-group(1)"/>
            <xsl:variable name="num1" select="regex-group(2)"/>

            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text>
                <xsl:choose>
                  <xsl:when test="$volume = 'I'">
                    <xsl:number value="1"/>
                  </xsl:when>
                  <xsl:when test="$volume = 'II'">
                    <xsl:number value="2"/>
                  </xsl:when>
                  <xsl:when test="$volume = 'III'">
                    <xsl:number value="3"/>
                  </xsl:when>
                  <xsl:when test="$volume = 'IV'">
                    <xsl:number value="4"/>
                  </xsl:when>
                  <xsl:when test="$volume = 'V'">
                    <xsl:number value="5"/>
                  </xsl:when>
                </xsl:choose>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$num1"/>
                <xsl:value-of select="$kiln:url-lang-suffix"/>
                <xsl:text>.html</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="title">
                <i18n:text>Link to inscription</i18n:text>
                <xsl:text> </xsl:text>
                <xsl:value-of select="regex-group(0)"/>
              </xsl:attribute>
              <xsl:attribute name="style">
                <xsl:text>font-weight:bold;</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="regex-group(0)"/>
            </xsl:element>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:when test="@type = 'introduction'">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <!-- this needs to be parametrized, and to cater for other "volumes" -->
            <xsl:text>/</xsl:text>
            <xsl:text>corpora/byzantine/introduction</xsl:text>
            <xsl:value-of select="$kiln:url-lang-suffix"/>
            <xsl:text>.html#</xsl:text>
            <xsl:value-of select="translate(normalize-space(.), '.', '-')"/>
            <xsl:text>-</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@type = 'external' or @rend = 'external'">
        <a href="{@target}">
          <xsl:call-template name="external-link"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@cRef">
        <xsl:choose>
          <xsl:when test="contains(@cRef, '#')">
            <xsl:variable name="file" select="substring-before(@cRef, '#')"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
            <xsl:variable name="anchor" select="substring-after(@cRef, '#')"/>
            <a title="Link internal to this page">
              <xsl:attribute name="href">
                <xsl:if test="string($file)">
                  <xsl:value-of select="$path"/>
                </xsl:if>
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$anchor"/>
              </xsl:attribute>
              <xsl:call-template name="internal-link">
                <xsl:with-param name="title" select="$title"/>
              </xsl:call-template>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="file" select="@cRef"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
            <a>
              <xsl:call-template name="internal-link">
                <xsl:with-param name="title" select="$title"/>
              </xsl:call-template>
              <xsl:attribute name="href">
                <xsl:value-of select="$kiln:context-path"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$path"/>
              </xsl:attribute>
              <xsl:apply-templates/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@target">
        <a>
          <xsl:attribute name="href">
            <xsl:if test="starts-with(@target, '/')">
              <xsl:value-of select="$kiln:context-path"/>
            </xsl:if>
            <!-- This is well dodgy. -->
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="indices_bracket_info">
    <div data-alert="data-alert" class="alert-box secondary">
      <i class="fa fa-info-circle">
        <xsl:text> </xsl:text>
      </i>
      <xsl:text> </xsl:text>
      <i18n:text key="__indices_bracket_info">Square brackets [ ] indicate that the name/word is
        partially or completely restored in this inscription.</i18n:text>
    </div>
  </xsl:template>


  <xsl:template name="indices_dashes_info">
    <div data-alert="data-alert" class="alert-box secondary">
      <i class="fa fa-info-circle">
        <xsl:text> </xsl:text>
      </i>
      <xsl:text> </xsl:text>
      <i18n:text key="__indices_dashes_info">For names where the initial letter(s) are lost, see
        under emdash (—) in the alphabet bar. An emdash indicates missing letters at the beginning,
        middle or end of a name. A single hyphen in the middle of a name indicates a hyphenated
        name.</i18n:text>
    </div>
  </xsl:template>

  <xsl:template name="indices_apl_info">
    <div data-alert="data-alert" class="alert-box secondary">
      <p>
        <xsl:choose>
          <xsl:when test="$lang = 'en'">
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Emdash (—) in a name indicates missing letters at the beginning
            (see "—" in alphabet bar), middle or end.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Hyphen ( - ) indicates a hyphenated name.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Square brackets [ ] indicate that the name is partially or
            completely restored in this inscription.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Pilcrow (¶) links to a permanent web address for each person, for
            referencing in external prosopographical databases. </xsl:when>
          <xsl:otherwise>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Длинное тире (—) в начале (см. алфавитную линейку), середине и
            конце имени обозначает потерянные буквы.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Дефис ( - ) означает, что имя состоит из двух частей.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Квадратные скобки [ ] означают, что имя частично или полностью
            восстановлено в тексте.<br/>
            <i class="fa fa-info-circle">
              <xsl:text> </xsl:text>
            </i>
            <xsl:text> </xsl:text>Знак абзаца (¶) отсылает к постоянному адресу в сети, созданного
            для каждого лица, для ссылок в электронных базах данных. </xsl:otherwise>
        </xsl:choose>
      </p>
    </div>
  </xsl:template>

  <!-- GREEK -->
  <xsl:template match="tei:foreign[@xml:lang = 'grc'] | tei:term[@xml:lang = 'grc']">
    <span lang="grc" xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Old Church Slavonic -->
  <xsl:template match="tei:foreign[@xml:lang = 'cu'] | tei:term[@xml:lang = 'cu']">
    <span lang="cu" xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- SUPERSCRIPT -->
  <xsl:template match="tei:hi[@rend = 'superscript']">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>

  <xsl:template match="tei:divGen[@type = 'pleiadesmap']">
    <div id="pleiadesmap" style="height:400px"/>
    <br/>
    <small>
      <a
        href="//maps.google.com/maps?q=http:%2F%2Fepiduke.cch.kcl.ac.uk%2Fblacksea.kml&amp;ie=UTF8&amp;t=h&amp;vpsrc=6&amp;ll=44.824708,34.584961&amp;spn=7.48047,14.0625&amp;z=6&amp;source=embed"
        style="color:#0000FF;text-align:left">View Larger Map</a>
    </small>
  </xsl:template>

</xsl:stylesheet>
