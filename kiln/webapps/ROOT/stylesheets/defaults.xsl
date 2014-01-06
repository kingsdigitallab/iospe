<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
  <!--
      Defaults stylesheet. Defines default globals and reads
      parameters from the sitemap.
  -->
  <xsl:param name="url" select="''"/>
  <!-- $language is the language code used to distinguish between
       language contexts in a multilingual site. -->
  <xsl:param name="language" select="''"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:variable name="kiln:url-lang-suffix" select="if ($lang='ru') then '-ru' else()"/>


  <!-- minimum and maximums years of inscriptions -->
  <xsl:variable as="xs:integer" name="kiln:min-year" select="200"/>
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
    <xsl:variable name="url_base" select="replace($url, '(^.+?)(-ru)?(\.html)$', '$1')"/>
    <li class="lang en">
      <a class="en" href="/{$url_base}.html" title="English">English</a>
    </li>
    <li class="lang py">
      <a class="py" href="/{$url_base}-ru.html" title="Русский">Русский</a>
    </li>
  </xsl:template>

  <xsl:template name="jump-to-inscription">
    <!-- searchform -->
    <li class="has-form">
      <form id="jumpForm">
        <div class="row collapse">
          <div class="small-8 columns">
            <input id="numTxt" name="numTxt" type="text" placeholder="Inscription number"
              i18n:attr="placeholder"/>
          </div>
          <div class="small-4 columns">
            <input href="#" type="submit" value="Go" i18n:attr="value"/>
          </div>
        </div>
      </form>
    </li>
  </xsl:template>


  <!-- LINKS -->
  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="@type='inscription'">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>/</xsl:text>
            <xsl:variable name="volume" select="substring-before(normalize-space(.),' ')"/>
            <xsl:variable name="num1" select="substring-after(normalize-space(.),' ')"/>
            <xsl:choose>
              <xsl:when test="$volume='I'">
                <xsl:number value="1"/>
              </xsl:when>
              <xsl:when test="$volume='II'">
                <xsl:number value="2"/>
              </xsl:when>
              <xsl:when test="$volume='III'">
                <xsl:number value="3"/>
              </xsl:when>
              <xsl:when test="$volume='IV'">
                <xsl:number value="4"/>
              </xsl:when>
              <xsl:when test="$volume='V'">
                <xsl:number value="5"/>
              </xsl:when>
            </xsl:choose>
            <!--<xsl:number format="1" value="$volume"/>-->
            <xsl:text>.</xsl:text>
            <xsl:number format="1" value="$num1"/>
            <xsl:value-of select="if ($lang='ru') then '-ru' else ()"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of
              select="if ($lang='ru') then 'переход к надписи № ' else 'Link to inscription '"/>
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:attribute>
          <xsl:attribute name="style">
            <xsl:text>font-weight:bold;</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@type='introduction'">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <!-- this needs to be parametrized, and to cater for other "volumes" -->
            <xsl:text>/</xsl:text>
            <xsl:text>corpora/byzantine/introduction</xsl:text>
            <xsl:if test="$lang='ru'">
              <xsl:text>-ru</xsl:text>
            </xsl:if>
            <xsl:text>.html#</xsl:text>
            <xsl:value-of select="translate(normalize-space(.),'.','-')"/>
            <xsl:text>-</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@type  = 'external' or @rend = 'external'">
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
                <xsl:value-of select="$xmp:context-path"/>
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
              <xsl:value-of select="$xmp:context-path"/>
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


</xsl:stylesheet>
