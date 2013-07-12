<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
      Defaults stylesheet. Defines default globals and reads
      parameters from the sitemap.
  -->

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />
  <xsl:param name="menutop" select="'true'" />
  <xsl:param name="lang" select="'en'" />

  <!-- Specify a mount path if you are mounting the webapp in a
       subdirectory rather than at the root of the domain. This path
       must either be empty or begin with a "/" and not include a
       trailing slash.

       The value is the URL root for the webapp. -->
  <xsl:variable name="kiln:mount-path" select="''" />

  <!-- $kiln:context-path defines the URL root for the webapp. -->
  <xsl:variable name="kiln:context-path">
    <xsl:value-of select="$kiln:mount-path" />
    <xsl:if test="$language">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$language" />
    </xsl:if>
  </xsl:variable>

  <!-- Base URL for non-textual content (images, video, etc). If these
       are being served by Cocoon, this should be specified as
       relative to $context-path. Otherwise, a full URL including
       protocol and domain is required.

       This URL must not include a trailing slash. -->
  <xsl:variable name="kiln:content-url" select="''" />
  <xsl:variable name="kiln:content-path">
    <xsl:if test="not(starts-with($kiln:content-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path" />
    </xsl:if>
    <xsl:value-of select="$kiln:content-url" />
  </xsl:variable>

  <!-- Base URL for assets (non-content images, CSS, JavaScript,
       etc). If these are being served by Cocoon, this should be
       specified as relative to $context-path. Otherwise, a full URL
       including protocol and domain is required.

       This URL must not include a trailing slash. -->
  <xsl:variable name="kiln:assets-url" select="'/assets'" />
  <xsl:variable name="kiln:assets-path">
    <xsl:if test="not(starts-with($kiln:assets-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path" />
    </xsl:if>
    <xsl:value-of select="$kiln:assets-url" />
  </xsl:variable>

  <!-- Base URL for content images. -->
  <xsl:variable name="kiln:images-url"
    select="concat($kiln:content-path, '/images')" />
  <xsl:variable name="kiln:images-path">
    <xsl:if test="not(starts-with($kiln:images-url, 'http'))">
      <xsl:value-of select="$kiln:mount-path" />
    </xsl:if>
    <xsl:value-of select="$kiln:images-url" />
  </xsl:variable>

  <xsl:variable name="kiln:pathroot"
                select="concat($kiln:context-path, '/', $filedir)" />
  <xsl:variable name="kiln:path">
    <xsl:value-of select="$kiln:pathroot" />
    <xsl:if test="not(ends-with($kiln:pathroot, '/'))">
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:value-of select="substring-before($filename, '.')" />
    <xsl:if test="$fileextension">
      <xsl:text>.</xsl:text>
      <xsl:value-of select="$fileextension" />
    </xsl:if>
  </xsl:variable>


  <xsl:variable name="xmg:title"
    select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)][@xml:lang=$xmg:lang]" />
  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)" />
  <xsl:variable name="xmg:path"
    select="concat($xmg:pathroot, '/', substring-before($filename, '.'), '.', $fileextension)" />
  <xsl:variable name="xmg:menu-top">
    <xsl:choose>
      <xsl:when test="$menutop = 'false'">
        <xsl:value-of select="false()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="xmg:lang" select="$lang" />

  <xsl:template match="/">
    <xsl:call-template name="xmv:screen" />
  </xsl:template>

  <xsl:template name="xms:content">
    <xsl:apply-templates select="//*[ancestor::tei:text][@xml:lang = $xmg:lang]" />
  </xsl:template>

  <xsl:template name="xmv:banner">
    <div>
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="$xmg:lang = 'ru'">
            <xsl:text>bsr</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>bs</xsl:text>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:attribute>
      <h3 title="{$xmp:title}">
        <a href="/" title="Return to the Homepage">Home</a>
      </h3>
      <h4 title="{$xmp:title}">
        <a href="/" title="Return to the {$xmp:title} Homepage">
          <xsl:value-of select="$xmp:title" />
        </a>
      </h4>
      <div class="gx gx0" title="[Image: ]">[Image: ]</div>
    </div>
  </xsl:template>

  <xsl:template name="xmm:menu-top">
    <div id="ns">
      <ul class="nvg">
        <xsl:for-each select="/*/xmm:root/xmm:menu">
          <xsl:call-template name="xmm:menu-item">
            <xsl:with-param name="output-sub-items" select="true()" />
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="menu-languages" />
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="menu-languages">
    <li class="lang">
      <a class="py" href="{substring-before($filename,'.xml')}-ru.html" title="Русский">Русский</a>
    </li>
    <li class="lang">
      <a class="en" href="{substring-before($filename,'.xml')}.html" title="English">English</a>
    </li>
  </xsl:template>

  <xsl:template name="xmm:menu-item">
    <xsl:param name="output-sub-items" select="true()" />
    <li>
      <xsl:choose>
        <!-- Active item with children. -->
        <xsl:when test="child::* and @href = $xmg:path">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
            <xsl:with-param name="active" select="true()" />
          </xsl:call-template>
        </xsl:when>
        <!-- Active item. -->
        <xsl:when test="@href = $xmg:path">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
            <xsl:with-param name="active" select="true()" />
          </xsl:call-template>
        </xsl:when>
        <!-- Ancestor of active item. -->
        <xsl:when test="child::* and starts-with($xmg:path, @path)">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
            <xsl:with-param name="active" select="true()" />
          </xsl:call-template>
        </xsl:when>
        <!-- Inactive item with children. -->
        <xsl:when test="child::*">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xmm:menu-item-class" />
        </xsl:otherwise>
      </xsl:choose>
      <a>
        <xsl:if test="@href">
          <xsl:attribute name="href">
            <xsl:value-of select="@href" />
          </xsl:attribute>
        </xsl:if>
        <b>
          <xsl:value-of select="@label" />
        </b>
      </a>
      <xsl:if test="$output-sub-items = true()">
        <xsl:if test="child::*">
          <ul class="pn{count(ancestor::xmm:menu) + 2}">
            <xsl:apply-templates />
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="xmv:body">
    <body class="o0">
      <div id="gw">
        <div id="hs">
          <!-- banner -->
          <xsl:call-template name="xmv:banner" />

          <!-- top navigation: menu-top.xsl -->
          <xsl:if test="$xmg:menu-top = true()">
            <xsl:call-template name="xmm:menu-top" />
          </xsl:if>
        </div>

        <!-- breadcrumb navigation: menu.xsl -->
        <!--<xsl:call-template name="xmm:breadcrumbs" />-->

        <div id="cs">
          <div class="cg n2">
            <!-- content: local stylesheets -->
            <div class="m">
              <div class="c c1">
                <xsl:call-template name="xms:rhcontent" />

                <xsl:call-template name="xms:options1" />

                <xsl:call-template name="xms:submenu" />

                <xsl:call-template name="xms:pagehead" />

                <xsl:call-template name="xms:toc1" />

                <xsl:call-template name="xms:content" />

                <xsl:call-template name="xms:footnotes" />

                <xsl:call-template name="xms:toc2" />

                <xsl:call-template name="xms:options2" />
              </div>
            </div>

            <!-- left navigation: menu.xsl -->
            <div class="c c2">
              <xsl:text>&#160;</xsl:text>
              <!--
              <xsl:choose>
                <xsl:when test="$xmg:menu-top = true()">
                  <xsl:call-template name="xmm:menu-top-sub" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="xmm:menu" />
                </xsl:otherwise>
              </xsl:choose>-->
            </div>
          </div>
        </div>

        <xsl:call-template name="xmv:footer" />
      </div>
    </body>
  </xsl:template>


  <xsl:template match="tei:label" />

  <xsl:template match="tei:item[parent::tei:list[@type='gloss']]">
    <!-- item HERE -->
    <dt>
      <xsl:attribute name="class">
        <xsl:call-template name="r-num" />
        <xsl:call-template name="odd-even" />
      </xsl:attribute>
      <xsl:apply-templates mode="glossary" select="preceding-sibling::tei:label[1]" />
    </dt>
    <!-- label HERE -->
    <dd>
      <xsl:attribute name="class">
        <xsl:call-template name="r-num" />
        <xsl:text> c01</xsl:text>
        <xsl:call-template name="odd-even" />
      </xsl:attribute>
      <xsl:apply-templates />
    </dd>
  </xsl:template>

  <xsl:template match="tei:name">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="tei:list[@type='simple']">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>
  <xsl:template match="tei:list[@type='simple']/tei:item">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="tei:divGen[@type='pleiadesmap']">
    <iframe frameborder="0" height="480" marginheight="0" marginwidth="0" scrolling="no"
      src="http://maps.google.com/maps?q=http:%2F%2Fepiduke.cch.kcl.ac.uk%2Fblacksea.kml&amp;ie=UTF8&amp;t=h&amp;vpsrc=6&amp;ll=44.824708,34.584961&amp;spn=7.48047,14.0625&amp;z=5&amp;output=embed"
      width="640">
      <xsl:comment>testing</xsl:comment>
    </iframe>
    <br />
    <small>
      <a
        href="http://maps.google.com/maps?q=http:%2F%2Fepiduke.cch.kcl.ac.uk%2Fblacksea.kml&amp;ie=UTF8&amp;t=h&amp;vpsrc=6&amp;ll=44.824708,34.584961&amp;spn=7.48047,14.0625&amp;z=6&amp;source=embed"
        style="color:#0000FF;text-align:left">View Larger Map</a>
    </small>
  </xsl:template>


  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <xsl:if test="string($xmg:title)">
          <h1>
            <xsl:value-of select="$xmg:title" />
          </h1>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="//tei:body/tei:div/tei:head">
    <h2 id="{generate-id()}">
      <xsl:apply-templates />
    </h2>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:head">
    <h3 id="{generate-id()}">
      <xsl:apply-templates />
    </h3>
  </xsl:template>
  <xsl:template match="//tei:body/tei:div/tei:div/tei:div/tei:head">
    <h4 id="{generate-id()}">
      <xsl:apply-templates />
    </h4>
  </xsl:template>

  <xsl:template name="xmv:footer">
    <div id="fs">
      <!--<div class="r1">
        <ul class="img">
          <li>
            <a href="http://www.kcl.ac.uk/" title="King's College London">
              <img alt="" height="40" src="{$xmp:assets-path}/i/kcl.png" width="61" />
            </a>
          </li>
        </ul>
      </div>-->
      <div class="r2">
        <a class="gx" href="/" title="Return to the Homepage">
          <xsl:value-of select="$xmp:title" />
        </a>
        <ul>
          <li class="i1 ix">
            <xsl:choose>
              <xsl:when test="$xmg:lang='en'">
                <a href="#cs" title="#">Top of Page</a>
              </xsl:when>
              <xsl:when test="$xmg:lang='ru'">
                <a href="#cs" title="#">К началу страницы</a>
              </xsl:when>
            </xsl:choose>
          </li>
          <!--<li>
            <a href="#" title="#">Sitemap</a>
          </li>
          <li>
            <a href="#" title="#">Copyright and License Information</a>
          </li>
          <li class="">
            <a href="#" title="#">About this website</a>
          </li>-->
        </ul>
        <xsl:choose>
          <xsl:when test="$xmg:lang='en'">
            <p>&#xa9; 2011 King's College London</p>
          </xsl:when>
          <xsl:when test="$xmg:lang='ru'">
            <p>&#xa9; 2011 Кингс Колледж Лондон</p>
          </xsl:when>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:lb">
    <br />
  </xsl:template>

  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/a.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/s/superfish/css/superfish.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/s.css" media="screen, projection" rel="stylesheet" type="text/css" />
  </xsl:template>

  <xsl:template name="xmv:script">
    <script src="{$xmp:assets-path}/s/jquery-1.10.2.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/superfish/js/hoverIntent.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/superfish/js/superfish-1.7.4.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/c.js" type="text/javascript">&#160;</script>
  </xsl:template>

  <xsl:template name="formatInscrNum">
    <xsl:param name="num" />
    <xsl:param name="printCorpus" select="false()" />

    <xsl:analyze-string regex="(\D+)(\d+)(\.\d+)?(\D*)" select="$num">
      <xsl:matching-substring>
        <xsl:if test="$printCorpus">
          <xsl:choose>
            <xsl:when test="regex-group(1) = 'byz'">
              <xsl:text>Byzantine </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Unknwon corpus </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <strong>
          <xsl:number format="1" value="number(regex-group(2))" />
          <xsl:value-of select="regex-group(3)" />
          <xsl:value-of select="regex-group(4)" />
        </strong>
      </xsl:matching-substring>
    </xsl:analyze-string>

  </xsl:template>

</xsl:stylesheet>
