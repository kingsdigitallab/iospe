<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
    xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
    xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <!-- REPLACE "RU-..." strings with Russian translations -->


  <xsl:import href="default.xsl" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />
  <xsl:param name="lang" select="'en'" />

  <xsl:strip-space elements="tei:w"/>

  <!-- OVERRIDES -->
  <xsl:template name="xms:options1" >
    <div class="options">
      <ul>
        <li>
          <xsl:if test="//prev_inscr//str[@name='inscription']
            [text()=substring-before($filename, '.xml')]/preceding::str[@name='inscription'][1]">
            <a class="s06" href="{concat(//prev_inscr//str[@name='inscription'][text()=substring-before($filename, '.xml')]/preceding::str[@name='inscription'][1], 
              if ($lang='ru') then '-ru' else())}.html">
              <span>
                <xsl:value-of select="if ($lang='ru') then 'Предыдущая' else 'Previous'"/>
              </span></a>
          </xsl:if>
          <xsl:text> </xsl:text>
        </li>
        <li>
          <xsl:if test="//next_inscr//str[@name='inscription']
            [not(text()=substring-before($filename, '.xml'))]">
            <a class="s06" href="{concat(//next_inscr//str[@name='inscription'], if ($lang='ru') then '-ru' else())}.html">
              <span>
                <xsl:value-of select="if ($lang='ru') then 'Следующая' else 'Next'"/>
              </span></a>
          </xsl:if>
          <xsl:text> </xsl:text>
        </li>
        <li><span>
          <!-- action="javascript:generateUrl('.', this.numTxt.value, '{$lang}');" -->
          <form  id="jumpForm">
            <legend>
              <xsl:value-of select="if ($lang='ru') then 'Надпись №' else 'Inscription #'"/>
            </legend><input id="numTxt" name="numTxt" size="5" type="text" /><button type="submit"><xsl:value-of select="if ($lang='ru') then 'Найти' else 'Go'"/></button></form></span></li>
      </ul>
    </div>
  </xsl:template>
  <xsl:template name="xms:options2" />
  
  <xsl:template name="xms:submenu" />
  
  <xsl:template name="xms:footnotes" />
  
  <!--<xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/a.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/s.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/googlecode.css" media="screen, projection" rel="stylesheet" type="text/css" />
  </xsl:template>-->
  
  <xsl:template name="xmv:script">
    <script type="text/javascript">var lang = "<xsl:value-of select="$lang"/>";</script>
    <script src="{$xmp:assets-path}/s/jquery-1.7.2.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/highlight.pack.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/superfish.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/c.js" type="text/javascript">&#160;</script>
  </xsl:template>
  
  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <xsl:if test="string($xmg:title)">
          <h1>
            <xsl:call-template name="formatInscrNum">
              <xsl:with-param name="num" select="//tei:publicationStmt/tei:idno[@type='filename']"/>
              <xsl:with-param name="printCorpus" select="true()"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="$xmg:title"/>
          </h1>
        </xsl:if>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template name="xms:content">
    <div class="inscription">
      <xsl:apply-templates select="//inscription/tei:TEI" />
    </div>
  </xsl:template>
  
  <xsl:template match="tei:ref">
    <xsl:choose>
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
      <xsl:when test="@type='inscription'">
        <a>
          <xsl:attribute name="href">
            <xsl:if test="starts-with(@target, '/')">
              <xsl:value-of select="$xmp:context-path"/>
            </xsl:if>
            <xsl:value-of select="@target"/>
            <xsl:value-of select="if ($lang='ru') then '-ru' else ()"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
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
    </xsl:choose>
  </xsl:template>

  <!--MAIN BODY -->
  
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

  <xsl:template match="tei:body">
    
    <div>
      <!-- General description -->
      <h2><xsl:value-of select="if ($lang='ru') then 'Камень' else 'Stone'"/></h2>
      
      <xsl:for-each select="//tei:support"> <!-- Support is the only always-one element in the metadata -->
        <div class="details">
        <dl>
          <xsl:if test="tei:objectType[@xml:lang=$lang]">
            <dt><xsl:value-of select="if ($lang='ru') then 'Разновидность' else 'Type of monument'"/></dt>
            <dd><xsl:value-of select="tei:objectType[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
          </xsl:if>
          <xsl:if test="tei:material[@xml:lang=$lang]">
            <dt><xsl:value-of select="if ($lang='ru') then 'Материал' else 'Material'"/></dt>
            <dd><xsl:value-of select="tei:material[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
          </xsl:if>
          <xsl:if test="tei:p[@xml:lang=$lang]">
            <dt><xsl:value-of select="if ($lang='ru') then 'Описание  и состояние  документа' else 'Description and condition'"/></dt>
            <dd><xsl:apply-templates select="tei:p[@xml:lang=$lang]/node()"/><xsl:text>&#160;</xsl:text></dd> 
          </xsl:if>
        </dl>
        </div>
      </xsl:for-each>
      
      <!-- Render metadata about physical object; either whole or in fragments (tei:div[@subtype='fragment']) -->
      <xsl:choose>
        <xsl:when test="//tei:div[@type='edition']/tei:div[@subtype='fragment']">
          <xsl:for-each select="//tei:div[@type='edition']//tei:div[@subtype='fragment']">
            <xsl:call-template name="objectData"/>
            <!-- Render metadata about inscriptions in current fragment, if any --> 
            <xsl:choose>
              <xsl:when test="descendant::tei:div[@subtype='inscription']">
                <xsl:for-each select="descendant::tei:div[@subtype='inscription']">
                  <xsl:call-template name="inscriptionData">
                    <xsl:with-param name="nestedTitles" select="true()"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="inscriptionData">
                  <xsl:with-param name="nestedTitles" select="true()"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- Whole object: common entry point for physical obj metadata and inscription(s) -->
          <xsl:for-each select="//tei:div[@type='edition']">
            <xsl:call-template name="objectData"/>
            <xsl:choose>
              <xsl:when test="descendant::tei:div[@subtype='inscription']">
                <xsl:for-each select="descendant::tei:div[@subtype='inscription']">
                  <xsl:call-template name="inscriptionData">
                    <xsl:with-param name="nestedTitles" select="false()"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="inscriptionData"/>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      
    </div>
    
    <div xsl:exclude-result-prefixes="tei">
      <p>
        <a href="http://creativecommons.org/licenses/by/2.0/uk/" title="Creative Commons license">
          <img alt="(cc)" border="0" src="{$xmp:assets-path}/i/80x15.png"/>
        </a>
        <xsl:value-of select="if ($lang='ru') then 'RU-&#160;You may download this ' else '&#160;You may download this '"/>
        <a href="{$filename}">
          <xsl:attribute name="title">
            <xsl:value-of select="if ($lang='ru') then 'RU-Right-click to save this file' else '&#160;You may download this '"/>
          </xsl:attribute>
          <xsl:value-of select="if ($lang='ru') then 'RU-inscription in EpiDoc XML' else 'inscription in EpiDoc XML'"/>
        </a>
        <xsl:text>.</xsl:text>
        
        <xsl:value-of select="if ($lang='ru') then 'RU- (This file should validate to the ' else ' (This file should validate to the '"/>
        <a href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng">
          <xsl:attribute name="title">
            <xsl:value-of select="if ($lang='ru') then 'RU-Right-click to save this file' else '&#160;You may download this '"/>
          </xsl:attribute>
          <xsl:value-of select="if ($lang='ru') then 'RU-EpiDoc schema' else 'EpiDoc schema'"/>
        </a>
        <xsl:text>.)</xsl:text>
      </p>
    </div>
  </xsl:template>

  <xsl:template name="objectData">
      <!-- If the object is in fragments, add title -->
      <xsl:if test="@n"><h2 class="part"><xsl:value-of select="if ($lang='ru') then 'Фрагмент ' else 'Fragment '"/><xsl:value-of select="@n"/></h2></xsl:if>
    <div class="details">
      <dl>
        <xsl:for-each select="//tei:provenance[@type='found'][@n=current()/@n or not(@n)]">
          <dt><xsl:value-of select="if ($lang='ru') then 'Место  находки' else 'Find place'"/></dt>
          <dd><xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:placeName[@type='ancientFindspot']"/><xsl:text>&#160;</xsl:text></dd>
          <dt><xsl:value-of select="if ($lang='ru') then 'Условия  находки' else 'Find circumstances'"/></dt>
          <dd><xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:rs[@type='circumstances']"/><xsl:text>&#160;</xsl:text></dd>
          <dt><xsl:value-of select="if ($lang='ru') then 'Контекст находки' else 'Find context'"/></dt>
          <dd><xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:rs[@type='context']"/><xsl:text>&#160;</xsl:text></dd>
        </xsl:for-each>
        
        <xsl:if test="//tei:provenance[@type='observed'][@n = current()/@n or not(@n)]">
          <dt><xsl:value-of select="if ($lang='ru') then 'Место хранения' else 'Modern location'"/></dt>
          <dd><xsl:value-of select="//tei:provenance[@type='observed'][@n = current()/@n or not(@n)]/tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
        </xsl:if>
        
        <xsl:for-each select="//tei:support/tei:dimensions[@n = current()/@n or not(@n)]">
          <dt><xsl:value-of select="if ($lang='ru') then 'Размеры' else 'Dimensions'"/></dt>
          <dd>
            <xsl:choose>
              <xsl:when test="not(tei:height) and not(tei:width) and not(tei:depth)">
                <xsl:value-of select="if ($lang='ru') then 'Неизвестны' else 'Unknown'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="if ($lang='ru') then 'Высота ' else 'H. '"/>
                <xsl:choose>
                  <xsl:when test="tei:height">
                    <xsl:value-of select="if ($lang='ru') then tei:height else translate(tei:height, ',', '.')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>                  
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="if ($lang='ru') then '; ширина ' else ', W. '"/>
                <xsl:choose>
                  <xsl:when test="tei:width">
                    <xsl:value-of select="if ($lang='ru') then tei:width else translate(tei:width, ',', '.')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>                  
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="if ($lang='ru') then '; толщина ' else ', Th. '"/>
                <xsl:choose>
                  <xsl:when test="tei:depth">
                    <xsl:value-of select="if ($lang='ru') then tei:depth else translate(tei:depth, ',', '.')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>                  
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          <xsl:text>.</xsl:text>
          </dd>
        </xsl:for-each>
        
        <xsl:if test="//tei:provenance[@type = 'autopsy']">
          <dt><xsl:value-of select="if ($lang='ru') then 'Автопсия' else 'Autopsy'"/></dt>
          <dd>
            <xsl:value-of select="//tei:provenance[@type = 'autopsy']/tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text>
          </dd>
        </xsl:if>        
        
        
        <xsl:if test="//tei:altIdentifier[@n = current()/@n or not(@n)]">
          <dt><xsl:value-of select="if ($lang='ru') then 'Институт  хранения' else 'Institution and inventory'"/></dt>
          <dd>
            <xsl:value-of select="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:repository"/>
            <xsl:if test="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:idno/text()">
              <xsl:text>&#160;</xsl:text>
            </xsl:if>
            <xsl:value-of select="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:idno"/>
            <xsl:text>.&#160;</xsl:text>
          </dd>
        </xsl:if>
        
      </dl>
    </div>
  </xsl:template>

  <xsl:template name="inscriptionData">
      <xsl:param name="nestedTitles" select="false()"/>
    
      <xsl:variable name="fullN">
        
          <xsl:if test="ancestor::tei:div[@subtype='fragment']">
            <xsl:value-of select="ancestor::tei:div[@subtype='fragment'][1]/@n"/>
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:if test="self::tei:div[@subtype='fragment'] or self::tei:div[@subtype='inscription']">
            <xsl:value-of select="@n"/>
          </xsl:if>
      </xsl:variable>
    
    <!--<xsl:message><xsl:value-of select="$fullN"/></xsl:message>-->
      <!-- If there are multiple inscriptions, add title -->
    <div>     
      <xsl:if test="self::tei:div[@subtype='inscription']/@n">
        <xsl:attribute name="class"><xsl:text>wrap</xsl:text></xsl:attribute>
        <xsl:element name="{if ($nestedTitles=true()) then 'h4' else 'h2'}">
          <xsl:attribute name="class"><xsl:text>part</xsl:text></xsl:attribute>
          <xsl:value-of select="if ($lang='ru') then 'Надпись ' else 'Inscription '"/>
          <xsl:value-of select="@n"/>
        </xsl:element>
      </xsl:if>
      
      <!-- Text field -->
    <xsl:element name="{if (self::tei:div[@subtype='inscription']/@n) 
        then 
          if ($nestedTitles=true()) 
          then 'h4' 
          else 'h2' 
        else 'h2'}">
      <xsl:attribute name="class"><xsl:text>field</xsl:text></xsl:attribute>
        <xsl:value-of select="if ($lang='ru') then 'Эпиграфическое поле' else 'Inscribed field'"/>
    </xsl:element>
    </div>
    
    <div class="details">
      <dl>
        <xsl:for-each select="//tei:layout[@n=$fullN or not(@n)]">
          <xsl:if test="@ana">
            <dt><xsl:value-of select="if ($lang='ru') then 'Код фаса' else 'Faces code'"/></dt>
            <dd><xsl:value-of select="@ana"/><xsl:text>.&#160;</xsl:text></dd>
          </xsl:if>
          <xsl:if test="tei:seg">
            <dt><xsl:value-of select="if ($lang='ru') then 'Местоположение' else 'Placement of text'"/></dt>
            <dd><xsl:value-of select="tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
          </xsl:if>
        </xsl:for-each>
        <xsl:if test="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:seg">
          <dt><xsl:value-of select="if ($lang='ru') then 'Стиль  письма' else 'Style of lettering'"/></dt>
          <dd><xsl:value-of select="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
        </xsl:if>
        <xsl:if test="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height">
          <dt><xsl:value-of select="if ($lang='ru') then 'Высота букв' else 'Letterheights'"/></dt>
          <dd><xsl:value-of select="if ($lang='ru') then //tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height else translate(//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height, ',', '.')"/><xsl:text>&#160;</xsl:text></dd>
        </xsl:if>
      </dl>
      </div>     
      
      <!-- Text -->
    <xsl:element name="{if (@n) 
      then 
      if ($nestedTitles=true()) 
      then 'h4' 
      else 'h2' 
      else 'h2'}">
      <xsl:attribute name="class"><xsl:text>field</xsl:text></xsl:attribute>
        <xsl:value-of select="if ($lang='ru') then 'Текст' else 'Text'"/>
      
    </xsl:element>
    <div class="details">
      <dl>
        <dt><xsl:value-of select="if ($lang='ru') then 'Происхождение текста' else 'Origin'"/></dt>
        <dd><xsl:value-of select="//tei:origPlace[@n = $fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
        <dt><xsl:value-of select="if ($lang='ru') then 'Характер документа' else 'Category'"/></dt>
        <dd><xsl:value-of select="//tei:msContents/tei:summary/tei:seg[@n = $fullN or not(@n)][@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
        <dt><xsl:value-of select="if ($lang='ru') then 'Датировка текста' else 'Date'"/></dt>
        <dd><xsl:value-of select="//tei:history/tei:origin/tei:origDate[@n = $fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></dd>
        <dt><xsl:value-of select="if ($lang='ru') then 'Обоснование датировки' else 'Dating criteria'"/></dt>
        <dd>
          <xsl:choose>
            <xsl:when test="$lang='ru'">
              <xsl:value-of select="translate(string-join(tokenize(//tei:origDate[1]/@evidence, ' '), ', '), '-', ' ')"/><xsl:text>.&#160;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string-join(for $term in tokenize(//tei:origDate[1]/@evidence, ' ')
                return //crit//tei:label[lower-case(.)=lower-case(normalize-space(translate($term,'-',' ')))]
                /following-sibling::tei:item[1], ', ')"/><xsl:text>.&#160;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </dd>
        <dt>
          <xsl:value-of select="if ($lang='ru') then 'Издания' else 'Editions'"/>
        </dt>
        <dd>
          <xsl:choose>
            <xsl:when test="//tei:div[@type='bibliography'][tei:listBibl[@n = $fullN or not(@n)]]">
                <xsl:for-each select="//tei:div[@type='bibliography']/tei:listBibl[@n = $fullN or not(@n)]/tei:bibl">
                    <xsl:if test="@n"><xsl:value-of select="@n"/><xsl:text> </xsl:text></xsl:if>
                    <xsl:variable name="target" select="tei:ptr/@target"/>
                    <xsl:for-each select="//bib//tei:biblStruct[@xml:id=$target]">
                      <xsl:value-of select="normalize-space(descendant::tei:author[1]/descendant::tei:surname[if (not(@xml:lang)) then true() else @xml:lang=$lang][1])"/>
                      <xsl:if test="descendant::tei:author[2]">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="normalize-space(descendant::tei:author[2]//tei:surname[if (not(@xml:lang)) then true() else @xml:lang=$lang][1])"/>
                      </xsl:if>
                      <xsl:if test="count(//tei:biblStruct[@xml:id=$target]//tei:author[1])>2">, et al.</xsl:if>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="normalize-space(descendant::tei:imprint[1]/tei:date[1])"/>
                    </xsl:for-each>
                    <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="following-sibling::tei:bibl"><xsl:text>; </xsl:text></xsl:if>
                </xsl:for-each>
              
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="if ($lang='ru') then 'ined' else 'Unpublished'"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>.&#160;</xsl:text>
        </dd>
      </dl>
      </div>
      
      <div class="inscription_text">
        <ul class="tabNav">
          <li>
            <a href="#edition{if (@n) then @n else '1'}">
              <span><xsl:value-of select="if ($lang='ru') then 'Критическое' else 'Edition'"/></span>
            </a>
          </li>
          <li>
            <a href="#diplomatic{if (@n) then @n else '1'}">
              <span><xsl:value-of select="if ($lang='ru') then 'Дипломатическое' else 'Diplomatic'"/></span>
            </a>
          </li>
          <li>
            <a href="#epidoc{if (@n) then @n else '1'}">
              <span><xsl:value-of select="if ($lang='ru') then 'EpiDoc (XML)' else 'EpiDoc (XML)'"/></span>
            </a>
          </li>
          <xsl:if test="descendant::tei:lg">
            <li>
              <a href="#verse{if (@n) then @n else '1'}">
                <span><xsl:value-of select="if ($lang='ru') then 'В стихотворной форме' else 'Edition in Verse'"/></span>
              </a>
            </li>
          </xsl:if>
        </ul>
        
        <!-- Creates the inscription views from preprocessed files aggregated in the sitemap -->
        <div id="edition{if (@n) then @n else '1'}">
          <!-- Only get current text part (inscription) if necessary -->
          <xsl:choose>
            <xsl:when test="@n">
              <xsl:variable name="tet" select="@n"/>
              <xsl:apply-templates select="//v_in//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]" mode="copyEpidoc"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates
                select="//v_in//div[@id='edition'][1]/*[not(self::h2)]" mode="copyEpidoc"
              />
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <xsl:if test="descendant::tei:lg">
          <div id="verse{if (@n) then @n else '1'}">
            <xsl:choose>
              <xsl:when test="@n">
                <xsl:variable name="tet" select="@n"/>
                <xsl:apply-templates select="//v_ve//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]" mode="copyEpidoc"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates
                  select="//v_ve//div[@id='edition'][1]/*[not(self::h2)]" mode="copyEpidoc"
                />
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:if>
        <div id="diplomatic{if (@n) then @n else '1'}">
          <xsl:choose>
            <xsl:when test="@n">
              <xsl:variable name="tet" select="@n"/>
              <xsl:apply-templates select="//v_di//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]" mode="copyEpidoc"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates
                select="//v_di//div[@id='edition'][1]/*[not(self::h2)]" mode="copyEpidoc"
              />
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div id="epidoc{if (@n) then @n else '1'}">
          <textarea cols="60" rows="20" wrap="off">
            <xsl:copy-of select="//v_ep/node()"/>
            <!--<xsl:choose>
              <xsl:when test="@n">
                <xsl:variable name="tet" select="@n"/>
                <xsl:copy-of select="//v_ep//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="//v_ep//div[@id='edition'][1]/*"/>
              </xsl:otherwise>
            </xsl:choose>-->
          </textarea>
        </div>
      </div>
      
    <xsl:if test="//tei:div[@type='apparatus'][@n = $fullN or not(@n)][descendant::tei:app/descendant::text()]">
    <div>
      <dl>
        <dt class="h2"><xsl:value-of select="if ($lang='ru') then 'Критический аппарат' else 'Apparatus criticus'"/></dt>
        <dd class="app">
          <xsl:apply-templates mode="multipara" select="//tei:div[@type='apparatus'][@n = $fullN or not(@n)]"/>
        </dd>
      </dl>
      </div>
      
      </xsl:if>
          
      
      <div>
        <dl>
          <dt class="h2"><xsl:value-of select="if ($lang='ru') then 'Перевод' else 'Translation'"/></dt>
          <dd class="trans">
            <!-- N.B. Leaving @n=none and @n=notyet even though they are not used in corpus yet -->
            <xsl:choose>
              <xsl:when test="//tei:div[@type='translation'][@n='none'][@xml:lang=$lang]">
                <xsl:value-of select="if ($lang='ru') then 'RU-not usefully translatable.' else ' not usefully translatable.'"/>
              </xsl:when>
              <xsl:when test="//tei:div[@type='translation'][@n='notyet'][@xml:lang=$lang]">
                <xsl:value-of select="if ($lang='ru') then 'RU-No translation yet (2012).:' else 'No translation yet (2010).'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="@n">
                    <xsl:apply-templates mode="multipara" select="//tei:div[@type='translation'][@xml:lang=$lang]/tei:div[@type='textpart'][@n=$fullN]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates mode="multipara" select="//tei:div[@type='translation'][@xml:lang=$lang]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </dd>
        </dl>
        </div>
      
      <div>
        <dl>
          <dt class="h2"><xsl:value-of select="if ($lang='ru') then 'Комментарий' else 'Commentary'"/></dt>
          <dd class="comm">
            <xsl:choose>
              <xsl:when test="//tei:div[@type='commentary'][@xml:lang=$lang]//tei:p/text()">
                <xsl:choose>
                  <xsl:when test="@n">
                    <xsl:apply-templates mode="multipara" select="//tei:div[@type='commentary'][@xml:lang=$lang]/tei:div[@type='textpart'][@n=$fullN]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates mode="multipara" select="//tei:div[@type='commentary'][@xml:lang=$lang]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="if ($lang='ru') then 'RU-no comment.' else 'no comment.'"/>
              </xsl:otherwise>
            </xsl:choose>
          </dd>
        </dl>
        </div> 
    
    <xsl:if test="//tei:facsimile//tei:graphic">
      <div>
      <dl>
        <dt class="h2"><xsl:value-of select="if ($lang='ru') then 'Изображения' else 'Images'"/></dt>
        <dd>
        <xsl:apply-templates select="//tei:facsimile//tei:graphic" mode="photograph"/>
      </dd>
      </dl>
    </div>
    </xsl:if>
    
  </xsl:template>

  <!-- https://issuetracker.cch.kcl.ac.uk/view.php?id=3053 (4) -->
  <xsl:template match="tei:placeName[@type='ancientFindspot']">
   <!-- <xsl:variable name="loc-n" select="document($locationAL)//tei:place[@xml:id = current()/ancestor::tei:event//tei:rs[@type='monuList']/@key]/ancestor-or-self::tei:place[@n]/@n"/>
    <xsl:variable name="loc-label"
      select="translate(substring(document($locationAL)//tei:place[@xml:id = current()/ancestor::tei:event//tei:rs[@type='monuList']/@key]/ancestor-or-self::tei:place[@n]/tei:placeName, 1, 3), $upper, $lower)"/>

    <a href="{$linkroot}{$group-index-loc-path}/{$loc-n}-{$loc-label}.html"
      xsl:exclude-result-prefixes="tei">-->
      <xsl:apply-templates/>
    <!--</a>-->
    </xsl:template>


  <!--DIVS-->
  <xsl:template match="tei:div">
    <xsl:choose>
      <xsl:when test="@type='edition'">
        <!-- Removes edition div, content is preprocessed and copied -->
      </xsl:when>
      <xsl:when test="@type='metadata' and (@n='category-text' or @n='category-monument')">
        <!-- Removes categoy-text and category-monument -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- BIBLIOGRAPHY (pointers) -->
  <xsl:template match="tei:bibl//tei:ptr">
    <xsl:apply-templates select="//bib//tei:bibl[@id=current()/@target]"/>
    <xml:text>, </xml:text>
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
        <xsl:apply-templates select=".//tei:graphic[@decls='#representation']"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="tei:div/tei:head"/>

  <!--CHUNK LEVEL-->

  <!-- Mode multipara -->
  <xsl:template match="tei:p|tei:ab" mode="multipara">
    <p xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="tei:div/tei:head" mode="multipara"> </xsl:template>

  <xsl:template match="tei:div[@type='apparatus']" mode="multipara">
    <xsl:for-each select="descendant::tei:app">
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
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:lem">
    <xsl:apply-templates/>
    <xsl:call-template name="resp"/>
    <xsl:text>: </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:rdg">
    <xsl:apply-templates/>
    <xsl:call-template name="resp"/>
    <xsl:if test="following-sibling::tei:rdg">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>

<xsl:template name="resp">
  <xsl:if test="@resp">
    <xsl:text> </xsl:text>
    <xsl:variable name="cur-n" select="ancestor::tei:div[@type='apparatus']/@n/string()"/>
    <xsl:variable name="resps">
      <xsl:for-each select="tokenize(@resp, ' ')">
        <tei:resp><xsl:value-of select="."/></tei:resp>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="docSubset">
      <xsl:sequence select="//bib"/>
      <xsl:sequence select="//tei:TEI[descendant::tei:div[@type='bibliography']]"/>
    </xsl:variable>
    <xsl:for-each select="$resps//tei:resp">
      <xsl:choose>
        <xsl:when test="$docSubset//tei:biblStruct[@xml:id=current()]">
          <xsl:variable name="biblio-subset">
            <xsl:for-each select="$docSubset//tei:body//tei:div[@type='bibliography']/tei:listBibl[if (@n) then @n=$cur-n else true()]/tei:bibl//tei:ptr">
              <xsl:sequence select="$docSubset//tei:biblStruct[@xml:id=current()/@target]"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="cur-surname">
            <xsl:value-of select="normalize-space($biblio-subset//tei:biblStruct[@xml:id=current()][1]/(descendant::tei:surname[if (@xml:lang=$lang) then @xml:lang else if (not(@xml:lang)) then true() else false()])[1])"/>
          </xsl:variable>
          <xsl:variable name="bibDate">
            <xsl:if test="count($biblio-subset//tei:biblStruct//tei:author[1]//tei:surname[if (@xml:lang=$lang) then @xml:lang=$lang else if (not(@xml:lang)) then true() else false()][normalize-space(.)=$cur-surname]) &gt; 1">
              <xsl:value-of select="$biblio-subset//tei:biblStruct[@xml:id=current()]//tei:imprint[1]//tei:date"/>
            </xsl:if>
          </xsl:variable>
          <xsl:value-of select="$cur-surname"/>
          <xsl:if test="$bibDate != ''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$bibDate"/>
          </xsl:if>
          <xsl:if test="following-sibling::tei:resp">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

  <xsl:template match="tei:dimensions">
    <!-- https://issuetracker.cch.kcl.ac.uk/view.php?id=3053 (1) -->
    

    <xsl:if test="tei:height">
      <xsl:value-of select="if ($lang='ru') then 'высота: ' else 'h:'"/>
      <xsl:value-of select="tei:height"/>
      <xsl:text> x </xsl:text>
    </xsl:if>

    <xsl:if test="tei:width">
      <xsl:value-of select="if ($lang='ru') then 'ширина: ' else 'w:'"/>
      <xsl:value-of select="tei:width"/>
    </xsl:if>

    <xsl:if test="tei:depth">
      <xsl:value-of select="if ($lang='ru') then ' x толщина:' else ' x d:'"/>
      <xsl:value-of select="tei:depth"/>
    </xsl:if>

    <xsl:if test="tei:dim[@type = 'diameter']">
      <xsl:value-of select="if ($lang='ru') then 'диам.:' else ' x diam.:'"/>
      <xsl:value-of select="tei:dim[@type = 'diameter']"/>
    </xsl:if>

    <xsl:if test="tei:dim[@type != 'diameter']">
      <xsl:for-each select="tei:dim[@type != 'diameter']">
	<xsl:text> x </xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <!--PHRASE LEVEL -->
  <!-- LB -->
  <xsl:template match="tei:lb">
    <xsl:text>|</xsl:text>
  </xsl:template>


  <!-- FIGURES -->
  <xsl:template match="tei:facsimile//tei:graphic" mode="photograph">
      <span style="height: 100%; min-height: 106px; min-width: 106px; text-align: center; vertical-align: middle;">
        <!-- Full size popup -->
        <a class="x87" href="/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&amp;CVT=jpeg">
          <!-- https://iospe-stg.cch.kcl.ac.uk/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&WID=100&HEI=100&CVT=jpeg -->
          <span>&#160;</span>
          <!-- Thumbnail image -->
          <img src="/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&amp;WID=100&amp;HEI=100&amp;CVT=jpeg">
            <!-- @alt info -->
            <xsl:if test="string(tei:desc[@xml:lang=$lang])">
              <xsl:attribute name="alt">
                <xsl:value-of select="tei:desc[@xml:lang=$lang]"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </span>
    <!--
    <dl style="width: 112px;" xsl:exclude-result-prefixes="tei">
      <dt>
        <xsl:value-of select="tei:desc[@xml:lang=$lang]"/>
      </dt>
      <dd style="height: 106px;">
        <!-\- Full size popup -\->
        <a class="x87" href="/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&amp;CVT=jpeg">
          <!-\- https://iospe-stg.cch.kcl.ac.uk/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&WID=100&HEI=100&CVT=jpeg -\->
          <span>&#160;</span>
          <!-\- Thumbnail image -\->
          <img src="/iip/iipsrv.fcgi?FIF=inscriptions/{@url}.jp2&amp;WID=100&amp;HEI=100&amp;CVT=jpeg">
            <!-\- @alt info -\->
            <xsl:if test="string(tei:desc[@xml:lang=$lang])">
              <xsl:attribute name="alt">
                <xsl:value-of select="tei:desc[@xml:lang=$lang]"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </dd>
    </dl>-->
  </xsl:template>


  <!-- GREEK -->
  <xsl:template match="tei:foreign[@lang='grc']|tei:term[@lang='grc']">
    <span class="greek" xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template name="lang-grc">
    <xsl:if test="ancestor-or-self::tei:div[@lang='grc']">
      <xsl:attribute name="class">
        <xsl:text>greek</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:*[@lang='la']">
    <em xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </em>
  </xsl:template>


  <!-- LINKS -->
  <xsl:template match="tei:xref">
    <xsl:choose>
      <!--Narrative-->
      <xsl:when test="@type='eAla-text'">
        <em xsl:exclude-result-prefixes="tei">
          <xsl:text>ala2004 </xsl:text>
        </em>
        <xsl:apply-templates/>
      </xsl:when>
      <!--ALA Inscriptions-->
      <xsl:when test="@type='eAla'">
        <em xsl:exclude-result-prefixes="tei">
          <xsl:text>ala2004 </xsl:text>
        </em>
        <strong xsl:exclude-result-prefixes="tei">
          <xsl:apply-templates/>
        </strong>
      </xsl:when>
      <!-- Unpublished inscriptions -->
      <xsl:when test="@type='iAph'">
        <xsl:text>(</xsl:text>
        <span style="font-style: italic;" title="(unpublished inscription forthcoming 2008)"
          xsl:exclude-result-prefixes="tei">
          <xsl:value-of select="if ($lang='ru') then 'RU-unpublished' else 'unpublished'"/>
        </span>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!--Inscriptions-->
      <xsl:when test="@type='inscription'">
        <a xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="href">
            <xsl:variable name="num1" select="upper-case(normalize-space(.))"/>
            <xsl:variable name="letter" select="translate(normalize-space(.), '0123456789', '')"/>
            <xsl:value-of select="$letter"/>
            <xsl:number format="00001" value="$num1"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:variable name="num1" select="upper-case(normalize-space(.))"/>
            <xsl:variable name="letter" select="translate(normalize-space(.), '0123456789', '')"/>
            <xsl:value-of select="if ($lang='ru') then 'переход к надписи № ' else 'Link to inscription '"/>
            <xsl:value-of select="$letter"/>
            <xsl:number format="00001" value="$num1"/>
          </xsl:attribute>
          <strong>
            <xsl:apply-templates/>
          </strong>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- BIBLIO -->
  <xsl:template match="tei:bibl[title='PHI' or title='EDH']//tei:biblScope">
    <xsl:choose>
      <xsl:when test="tei:title='PHI' and @n">
        <a class="intNew" rel="external" target="_blank" xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="title">
            <xsl:value-of select="if ($lang='ru') then 'RU-Link to PHI Inscriptions (opens in new window)' else 'Link to PHI Inscriptions (opens in new window)'"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>http://epigraphy.packhum.org/inscriptions/oi?ikey=</xsl:text>
            <xsl:value-of select="@n"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="tei:title='EDH' and @n">
        <a class="intNew" rel="external" target="_blank" xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="title">
            <xsl:value-of select="if ($lang='ru') then 'RU-Link to EDH Inscriptions (opens in new window)' else 'Link to EDH Inscriptions (opens in new window)'"/>
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

  <xsl:template match="tei:bibl">
    <xsl:choose>
      <xsl:when test="@type='hbi'">
        <!--<a xsl:exclude-result-prefixes="tei">
          <xsl:attribute name="href">
            <xsl:value-of select="$InsAphroot"/>
            <xsl:value-of select="$biblpath"/>
            <xsl:text>index.html</xsl:text>
            <xsl:if test="string(@n)">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="@n"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:apply-templates/>
        <!--</a>-->
      </xsl:when>
      <!--<xsl:when test="tei:title='IRT'">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>http://irt.kcl.ac.uk/irt2009/IRT</xsl:text>
            <xsl:number value="translate(biblScope, 'abcde','')" format="001"/>
            <xsl:value-of select="translate(biblScope, '0123456789','')"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>-->
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="tei:bibl/tei:title">
    <xsl:choose>
      <xsl:when test="@level='m' or @level='j'">
        <em xsl:exclude-result-prefixes="tei">
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:when test="@level='a' or @level='u'">
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
    match="tei:author[ancestor::tei:bibl[@rend='primary']][not(preceding-sibling::tei:author)]">
    <xsl:text>&#8226;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>



  <!-- EDITORIAL AMENDMENTS -->
  <xsl:template match="tei:unclear[@reason='damage']">
    <xsl:call-template name="subpunct">
      <xsl:with-param name="unc-len" select="string-length(.)"/>
      <xsl:with-param name="abs-len" select="string-length(.)+1"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template name="subpunct">
    <xsl:param name="abs-len"/>
    <xsl:param name="unc-len"/>
    <xsl:if test="$unc-len!=0">
      <xsl:value-of select="substring(., number($abs-len - $unc-len),1)"/>
      <xsl:text>&#x0323;</xsl:text>
      <xsl:call-template name="subpunct">
        <xsl:with-param name="unc-len" select="$unc-len - 1"/>
        <xsl:with-param name="abs-len" select="string-length(.)+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <xsl:template match="tei:gap[@reason='omitted']">
    <xsl:text>(---)</xsl:text>
  </xsl:template>



  <xsl:template match="tei:gap[@reason='ellipsis']">
    <xsl:text> ... </xsl:text>
  </xsl:template>



  <xsl:template match="tei:gap">
    <xsl:if test="@reason='lost' and not(@dim='top')">
      <xsl:call-template name="lost-opener"/>
    </xsl:if>
    <xsl:if test="following-sibling::tei:certainty[@target=current()/@xml:id and @degree='low']">
      <xsl:text>?</xsl:text>
    </xsl:if>
    <xsl:choose>
      <!-- condition -->
      <xsl:when test="@quantity and @unit='character'">
        <xsl:choose>
          <xsl:when test="@quantity='1'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;</xsl:text>
          </xsl:when>
          <xsl:when test="@quantity='2'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7;</xsl:text>
          </xsl:when>
          <xsl:when test="@quantity='3'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7;&#xb7;</xsl:text>
          </xsl:when>
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
      <xsl:when test="@quantity and @unit='cm'">
        <xsl:apply-templates/>
        <xsl:text>&#xb7;&#xb7; c. </xsl:text>
        <xsl:value-of select="@quantity"/>
        <xsl:text> cm &#xb7;&#xb7;</xsl:text>
      </xsl:when>
      <!-- extent = unknown -->
      <xsl:when test="@extent='unknown'">
            <xsl:apply-templates/>
            <xsl:text>&#xb7;&#xb7; ? &#xb7;&#xb7;</xsl:text>
          </xsl:when>
      <!-- default -->
      <xsl:otherwise>
        <xsl:text>&#xb7;&#xb7; ? &#xb7;&#xb7;</xsl:text>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@reason='lost' and not(@dim='bottom')">
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
      test="not(parent::tei:expan) and not(following-sibling::tei:supplied[@reason='abbreviation'])">
      <xsl:text>(?)</xsl:text>
    </xsl:if>
  </xsl:template>



  <xsl:template match="tei:orig">
    <xsl:choose>
      <xsl:when test="ancestor::tei:expan and not(contains(@n, 'unresolved'))"> </xsl:when>
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



  <xsl:template match="tei:num">
    <xsl:if test="@value &gt;= 1000">
      <xsl:text>&#x0375;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="not(@value mod 1000 = 0)">
      <xsl:text>&#x00B4;</xsl:text>
    </xsl:if>
  </xsl:template>



  <xsl:template match="tei:note">
    <span style="font-style: normal; important!" xsl:exclude-result-prefixes="tei">
      <xsl:choose>
        <xsl:when test="ancestor::tei:app">
          <xsl:if test="parent::tei:lem or parent::tei:rdg">
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
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
        <xsl:when test="ancestor::tei:translation">
          <xsl:text>(</xsl:text>
          <em>
            <xsl:apply-templates/>
          </em>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::tei:ab">
          <xsl:choose>
            <xsl:when test="@rend='italic'">
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
      <xsl:when test="@quantity='1' and @unit='character'">
        <xsl:apply-templates/>
        <em xsl:exclude-result-prefixes="tei">
          <sup>
            <xsl:text> </xsl:text>
            <xsl:if
              test="following-sibling::tei:certainty[@target=current()/@xml:id and @degree='low']">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:text>v. </xsl:text>
          </sup>
        </em>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@unit='line'">
        <xsl:apply-templates/>
        <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
        <em xsl:exclude-result-prefixes="tei">
          <span class="smaller">
            <xsl:if
              test="following-sibling::tei:certainty[@target=current()/@xml:id and @degree='low']">
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
            <xsl:text> </xsl:text>
            <xsl:if
              test="following-sibling::tei:certainty[@target=current()/@xml:id and @degree='low']">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:text>vac. </xsl:text>
          </span>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:sic[@n='superfluous']">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:choice[@type='correction']/tei:sic"> </xsl:template>

  <xsl:template match="tei:choice[@type='correction']/tei:corr">
    <xsl:text>&#x231C;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#x231D;</xsl:text>
  </xsl:template>


  <xsl:template match="tei:supplied">
    <xsl:choose>
      <!-- condition -->
      <xsl:when test="@reason='lost'">
        <xsl:call-template name="lost-opener"/>
        <xsl:call-template name="cert-low"/>
        <xsl:apply-templates/>
        <xsl:call-template name="lost-closer"/>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason='omitted'">
        <xsl:text>&lt;</xsl:text>
        <xsl:call-template name="cert-low"/>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason='subaudible'">
        <xsl:text>(</xsl:text>
        <xsl:call-template name="cert-low"/>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason='abbreviation'">
        <xsl:text>(</xsl:text>
        <xsl:call-template name="cert-low"/>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <!-- condition -->
      <xsl:when test="@reason='explanation'">
        <xsl:text>(i.e. </xsl:text>
        <xsl:call-template name="cert-low"/>
        <xsl:apply-templates/>
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
    </xsl:if>
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

  <xsl:template match="tei:rs[@cert='low']">
    <xsl:text>?</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- SEG -->
  <xsl:template match="tei:seg[@cert='low']">
    <xsl:text>?</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:provenance[@type='autopsy']">
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
    <xsl:if test="@precision='circa'">
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
      <xsl:when test="preceding-sibling::tei:*[1][@reason='lost']">
        <xsl:if
          test="preceding-sibling::text() and preceding-sibling::tei:*[1][following-sibling::text()]">
          <xsl:variable name="curr-prec" select="generate-id(preceding-sibling::text()[1])"/>
          <xsl:for-each select="preceding-sibling::tei:*[1][@reason='lost']">
            <xsl:choose>
              <xsl:when test="generate-id(following-sibling::text()[1]) = $curr-prec">
                <xsl:if test="not(following-sibling::text()[1] =' ')">
                  <xsl:text>[</xsl:text>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise> </xsl:otherwise>
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
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1][@reason='lost']]]"> </xsl:when>


      <!--3.
````````__|__
`````__|__```|
````|`````|``x
``````````x
      -->
      <xsl:when
        test="preceding-sibling::tei:*[1]/tei:*[not(following-sibling::node())][@reason='lost']">
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
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason='lost']]]"> </xsl:when>


      <!--5.
````````____|____
`````__|__```````|
````|```__|__````x
```````|`````|
`````````````x
      -->
      <xsl:when
        test="preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason='lost']"> </xsl:when>


      <!--6.
````````____|____
`````__|__`````__|__
````|```__|__`|`````|
```````|`````|x
`````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason='lost']]]"> </xsl:when>


      <!--7. 
````````______|______
`````__|__`````````__|__
````|```__|__```__|__```|
```````|`````|`|`````|
`````````````x`x
      -->


      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())]/tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][@reason='lost']]]]"> </xsl:when>


      <!--8.
````````______|______
```````|```````````__|__
```````x````````__|__```|
```````````````|`````|
```````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1][@reason='lost']]]]"> </xsl:when>



      <!--9.
````````______|______
`````__|__`````````__|__
````|`````|`````__|__```|
``````````x````|`````|
```````````````x
      -->
      <xsl:when
        test="current()[not(preceding-sibling::node())][parent::tei:*[not(preceding-sibling::node())][parent::tei:*[preceding-sibling::tei:*[1]/tei:*[not(following-sibling::node())][@reason='lost']]]]">
        <xsl:if test="parent::tei:*[parent::tei:*[preceding-sibling::node()[1]/self::text()]]">
          <xsl:if
            test="parent::tei:*[parent::tei:*[normalize-space(preceding-sibling::node()[1]) != '']]"
            >[</xsl:if>
        </xsl:if>
      </xsl:when>


      <!-- 10. -->
      <xsl:when
        test="preceding-sibling::tei:*[1][local-name()='lb'] and preceding-sibling::tei:*[2][local-name()='supplied' and @reason='lost']">

        <xsl:variable name="curr-prec-txt" select="generate-id(preceding-sibling::text()[1])"/>
        <xsl:for-each select="preceding-sibling::tei:*[1][local-name()='lb']">
          <xsl:choose>
            <xsl:when
              test="following-sibling::text() and generate-id(following-sibling::text()[1])=$curr-prec-txt and not(following-sibling::text()[1]=' ')">
              <xsl:text>[</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="lb-prec-txt" select="generate-id(preceding-sibling::text()[1])"/>
              <xsl:for-each select="preceding-sibling::tei:*[1][@reason='lost']">
                <xsl:choose>
                  <xsl:when
                    test="following-sibling::text() and generate-id(following-sibling::text()[1])=$lb-prec-txt and not(following-sibling::text()[1]=' ')">
                    <xsl:text>[</xsl:text>
                  </xsl:when>
                  <xsl:otherwise> </xsl:otherwise>
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
      <xsl:when test="following-sibling::tei:*[1][@reason='lost']">
        <xsl:if
          test="following-sibling::text() and following-sibling::tei:*[1][preceding-sibling::text()]">
          <xsl:variable name="curr-foll" select="generate-id(following-sibling::text()[1])"/>
          <xsl:for-each select="following-sibling::tei:*[1][@reason='lost']">
            <xsl:choose>
              <xsl:when
                test="generate-id(preceding-sibling::text()[1]) = $curr-foll and not(preceding-sibling::text()[1]=' ')">
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise> </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
      <!-- 2. -->
      <xsl:when
        test="following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason='lost']"> </xsl:when>
      <!-- 3. -->
      <xsl:when
        test="current()[not(following-sibling::node())][parent::node()[following-sibling::tei:*[1][@reason='lost']]]">
        <xsl:variable name="curr-foll-txt" select="generate-id(following-sibling::text()[1])"/>
        <xsl:choose>
          <xsl:when
            test="parent::node()/following-sibling::tei:*[1][@reason='lost'][generate-id(preceding-sibling::text()[1]) = $curr-foll-txt]"
            >]</xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- 4. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason='lost']]]"> </xsl:when>
      <!-- 5. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1][@reason='lost']]]]"> </xsl:when>
      <!-- 6. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())][@reason='lost']]]]"> </xsl:when>
      <!-- 7. -->
      <xsl:when
        test="current()[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[not(following-sibling::tei:*)][not(following-sibling::text())][parent::tei:*[following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())]/tei:*[not(preceding-sibling::node())][@reason='lost']]]]"> </xsl:when>
      <!-- 8. -->
      <xsl:when
        test="following-sibling::tei:*[1]/tei:*[not(preceding-sibling::node())]/tei:*[not(preceding-sibling::node())][@reason='lost']"> </xsl:when>
      <!-- 9. -->
      <xsl:when
        test="current()[not(following-sibling::node())][parent::tei:*[following-sibling::tei:*[1]/child::node()[1]/child::node()[1][@reason='lost']]]">
        <xsl:if test="parent::tei:*[following-sibling::node()[1]/self::text()]">
          <xsl:if test="parent::tei:*[normalize-space(following-sibling::node()[1]) != '']"
            >]</xsl:if>
        </xsl:if>
      </xsl:when>
      <!-- 10. -->
      <xsl:when
        test="following-sibling::tei:*[1][local-name()='lb'] and following-sibling::tei:*[2][local-name()='supplied' and @reason='lost']">
        <xsl:variable name="curr-prec-txt" select="generate-id(following-sibling::text()[1])"/>
        <xsl:for-each select="following-sibling::*[1][local-name()='lb']">
          <xsl:choose>
            <xsl:when
              test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1])=$curr-prec-txt and not(preceding-sibling::text()[1]=' ')">
              <xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="lb-prec-txt" select="generate-id(following-sibling::text()[1])"/>
              <xsl:for-each select="following-sibling::tei:*[1][@reason='lost']">
                <xsl:choose>
                  <xsl:when
                    test="preceding-sibling::text() and generate-id(preceding-sibling::text()[1])=$lb-prec-txt and not(preceding-sibling::text()[1]=' ')">
                    <xsl:text>]</xsl:text>
                  </xsl:when>
                  <xsl:otherwise> </xsl:otherwise>
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
    <xsl:if test="@cert='low'">
      <xsl:text>?</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
