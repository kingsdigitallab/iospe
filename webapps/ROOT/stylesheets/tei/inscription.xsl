<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/" />

  <xsl:template name="inscriptionnav">
    <xsl:param name="next_inscr" />
    <xsl:param name="prev_inscr" />

    <xsl:variable name="nextlabel" select="if ($lang='ru') then 'Следующая' else 'Next'" />
    <xsl:variable name="prevlabel" select="if ($lang='ru') then 'Предыдущая' else 'Previous'"/>
    <xsl:variable name="placeholder" select="if ($lang='ru') then 'Надпись №' else 'Inscription #'"/>
    <xsl:variable name="golabel" select="if ($lang='ru') then 'Найти' else 'Go'"/>

    <div class="row">

      <!-- prev -->
      <div class="large-1 columns">
        <ul class="pagination">
          <xsl:choose>
            <xsl:when test="//prev_inscr//result/doc/str[@name='inscription']/text()">
              <li class="arrow">
                <a href="{concat(//prev_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                  <xsl:text>&#171; </xsl:text>
                  <xsl:value-of select="$prevlabel" />
                </a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow unavailable">
                <a href="">
                  <xsl:text>&#171; </xsl:text>
                  <xsl:value-of select="$prevlabel" />
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </div>

      <!-- searchform -->
      <div class="large-2 columns">
        <div class="row collapse">
          <form id="jumpForm">
            <div class="small-8 columns">
              <input id="numTxt" name="numTxt" type="text" placeholder="{$placeholder}" />
            </div>
            <div class="small-4 columns">
              <a href="#" class="button prefix submit"><xsl:value-of select="$golabel" /></a>
            </div>
          </form>
        </div>
      </div>

      <!-- next -->
      <div class="large-9 columns">
        <ul class="pagination">
          <xsl:choose>
            <xsl:when test="//next_inscr//result/doc/str[@name='inscription']/text()">
              <li class="arrow">
                <a href="{concat(//next_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                  <xsl:value-of select="$nextlabel" />
                  <xsl:text> &#187;</xsl:text>
                </a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow unavailable">
                <a href="">
                  <xsl:value-of select="$nextlabel" />
                  <xsl:text> &#187;</xsl:text>
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </div>
    </div>
  </xsl:template>

    <!-- formatInscrNum -->

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



  <xsl:template name="inscriptionSupport">
    <xsl:text>hello</xsl:text>

    <xsl:if test="tei:objectType[@xml:lang=$lang]">
      <div class="large-2">
        <h4><xsl:value-of select="if ($lang='ru') then 'Разновидность' else 'Type of monument'"/></h4>
      </div>
      <div class="large-8">
        <p><xsl:value-of select="tei:objectType[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></p>
      </div>
    </xsl:if>

    <xsl:if test="tei:material[@xml:lang=$lang]">
      <div class="large-2">
        <h4><xsl:value-of select="if ($lang='ru') then 'Материал' else 'Material'"/></h4>
      </div>
      <div class="large-8">
        <p><xsl:value-of select="tei:material[@xml:lang=$lang]"/><xsl:text>&#160;</xsl:text></p>
      </div>
    </xsl:if>

    <xsl:if test="tei:p[@xml:lang=$lang]">
      <div class="large-2">
        <h4><xsl:value-of select="if ($lang='ru') then 'Описание  и состояние  документа' else 'Description and condition'"/></h4>
      </div>
      <div class="large-8">
        <p><xsl:apply-templates select="tei:p[@xml:lang=$lang]/node()"/><xsl:text>&#160;</xsl:text></p>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:body">

    <div>


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
        <xsl:attribute name="class">
          <xsl:text>field</xsl:text>
        </xsl:attribute>
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
          <dd>
            <xsl:value-of select="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/>
            <xsl:text>&#160;</xsl:text>
          </dd>
        </xsl:if>
        <xsl:if test="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height">
          <dt>
            <xsl:value-of select="if ($lang='ru') then 'Высота букв' else 'Letterheights'"/>
          </dt>
          <dd>
            <xsl:value-of select="if ($lang='ru') then //tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height else translate(//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height, ',', '.')"/>
            <xsl:text>&#160;</xsl:text>
          </dd>
        </xsl:if>
      </dl>
    </div>

      <!-- Text -->
    <xsl:element name="{if (@n) then if ($nestedTitles=true()) then 'h4' else 'h2' else 'h2'}">
      <xsl:attribute name="class">
        <xsl:text>field</xsl:text>
      </xsl:attribute>
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
              <xsl:value-of select="string-join(for $term in tokenize(//tei:origDate[1]/@evidence, ' ') return //crit//tei:label[lower-case(.)=lower-case(normalize-space(translate($term,'-',' ')))]/following-sibling::tei:item[1], ', ')"/>
              <xsl:text>.&#160;</xsl:text>
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
                    <xsl:if test="count(//tei:biblStruct[@xml:id=$target]//tei:author[1])>2">
                      <xml:text>, et al.</xml:text>
                    </xsl:if>
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
            <xsl:apply-templates select="//v_in//div[@id='edition'][1]/*[not(self::h2)]" mode="copyEpidoc" />
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
              <xsl:apply-templates select="//v_ve//div[@id='edition'][1]/*[not(self::h2)]" mode="copyEpidoc"/>
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

    <xsl:apply-templates />

  </xsl:template>



</xsl:stylesheet>