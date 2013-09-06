<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/"/>

  <xsl:template name="inscriptionnav">
    <xsl:param name="next_inscr"/>
    <xsl:param name="prev_inscr"/>

    <xsl:variable name="nextlabel" select="if ($lang='ru') then 'Следующая' else 'Next'"/>
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
                <a
                  href="{concat(//prev_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                  <xsl:text>&#171;</xsl:text>
                  <xsl:value-of select="$prevlabel"/>
                </a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow unavailable">
                <a href="">
                  <xsl:text>&#171;</xsl:text>
                  <xsl:value-of select="$prevlabel"/>
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
              <input id="numTxt" name="numTxt" type="text" placeholder="{$placeholder}"/>
            </div>
            <div class="small-4 columns">
              <a href="#" class="button prefix submit">
                <xsl:value-of select="$golabel"/>
              </a>
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
                <a
                  href="{concat(//next_inscr//result/doc/str[@name='inscription'], $kiln:url-lang-suffix)}.html">
                  <xsl:value-of select="$nextlabel"/>
                  <xsl:text>&#187;</xsl:text>
                </a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li class="arrow unavailable">
                <a href="">
                  <xsl:value-of select="$nextlabel"/>
                  <xsl:text>&#187;</xsl:text>
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
    <xsl:param name="num"/>
    <xsl:param name="printCorpus" select="false()"/>

    <xsl:analyze-string regex="(\D+)(\d+)(\.\d+)?(\D*)" select="$num">
      <xsl:matching-substring>
        <xsl:if test="$printCorpus">
          <xsl:choose>
            <xsl:when test="regex-group(1) = 'byz'">
              <xsl:text>Byzantine</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Unknwon corpus</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <strong>
          <xsl:number format="1" value="number(regex-group(2))"/>
          <xsl:value-of select="regex-group(3)"/>
          <xsl:value-of select="regex-group(4)"/>
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

    <!-- Type of monument (if exists) -->
    <xsl:if test="//tei:support/tei:objectType[@xml:lang=$lang]">
      <div class="row">
        <div class="large-2 columns">
          <h3>
            <xsl:value-of select="if ($lang='ru') then 'Разновидность' else 'Type of monument'"/>
          </h3>
        </div>
        <div class="large-10 columns">
          <p>
            <xsl:value-of select="//tei:objectType[@xml:lang=$lang]"/>
            <xsl:text>&#160;</xsl:text>
          </p>
        </div>
      </div>
    </xsl:if>


    <!-- Material (if exists) -->
    <xsl:if test="//tei:support/tei:material[@xml:lang=$lang]">
      <div class="row">
        <div class="large-2 columns">
          <h3>
            <xsl:value-of select="if ($lang='ru') then 'Материал' else 'Material'"/>
          </h3>
        </div>
        <div class="large-10 columns">
          <p>
            <xsl:value-of select="//tei:material[@xml:lang=$lang]"/>
            <xsl:text>&#160;</xsl:text>
          </p>
        </div>
      </div>
    </xsl:if>

    <!-- Description and condition (if exists) -->
    <xsl:if test="//tei:support/tei:p[@xml:lang=$lang]">
      <div class="row">
        <div class="large-2 columns">
          <h3>
            <xsl:value-of
              select="if ($lang='ru') then 'Описание  и состояние  документа' else 'Description and condition'"
            />
          </h3>
        </div>
        <div class="large-10 columns">
          <p>
            <xsl:apply-templates select="//tei:p[@xml:lang=$lang]/node()"/>
            <xsl:text>&#160;</xsl:text>
          </p>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="objectData">

    <!-- If the object is in fragments, add title -->

    <!-- Fragment -->
    <div class="row">
      <div class="large-2 columns">
        <xsl:if test="@n">
          <h2 class="part">
            <xsl:value-of select="if ($lang='ru') then 'Фрагмент ' else 'Fragment '"/>
            <xsl:value-of select="@n"/>
          </h2>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
      </div>
      <div class="large-10 columns details">

        <!-- Find place -->
        <xsl:for-each select="//tei:provenance[@type='found'][@n=current()/@n or not(@n)]">
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Место  находки' else 'Find place'"/>
              </h3>
            </div>

            <div class="large-10 columns">
              <xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:placeName[@type='ancientFindspot']"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Find Circumnstances -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of
                  select="if ($lang='ru') then 'Условия  находки' else 'Find circumstances'"/>
              </h3>
            </div>

            <div class="large-10 columns">
              <xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:rs[@type='circumstances']"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Find context -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Контекст находки' else 'Find context'"/>
              </h3>
            </div>

            <div class="large-10 columns">
              <xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:rs[@type='context']"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>
        </xsl:for-each>

        <!-- Modern Location (if exists) -->
        <xsl:if test="//tei:provenance[@type='observed'][@n = current()/@n or not(@n)]">
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Место хранения' else 'Modern location'"
                />
              </h3>
            </div>

            <div class="large-10 columns">
              <xsl:value-of
                select="//tei:provenance[@type='observed'][@n = current()/@n or not(@n)]/tei:seg[@xml:lang=$lang]"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>
        </xsl:if>

        <!-- Dimensions -->
        <xsl:for-each select="//tei:support/tei:dimensions[@n = current()/@n or not(@n)]">
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Размеры' else 'Dimensions'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:choose>
                <xsl:when test="not(tei:height) and not(tei:width) and not(tei:depth)">
                  <xsl:value-of select="if ($lang='ru') then 'Неизвестны' else 'Unknown'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="if ($lang='ru') then 'Высота ' else 'H. '"/>
                  <xsl:choose>
                    <xsl:when test="tei:height">
                      <xsl:value-of
                        select="if ($lang='ru') then tei:height else translate(tei:height, ',', '.')"
                      />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="if ($lang='ru') then '; ширина ' else ', W. '"/>
                  <xsl:choose>
                    <xsl:when test="tei:width">
                      <xsl:value-of
                        select="if ($lang='ru') then tei:width else translate(tei:width, ',', '.')"
                      />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="if ($lang='ru') then '; толщина ' else ', Th. '"/>
                  <xsl:choose>
                    <xsl:when test="tei:depth">
                      <xsl:value-of
                        select="if ($lang='ru') then tei:depth else translate(tei:depth, ',', '.')"
                      />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="if ($lang='ru') then 'неизвестна' else 'unknown'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>.</xsl:text>
            </div>
          </div>
        </xsl:for-each>


        <!-- Autopsy -->
        <xsl:if test="//tei:provenance[@type = 'autopsy']">
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Автопсия' else 'Autopsy'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:value-of select="//tei:provenance[@type = 'autopsy']/tei:seg[@xml:lang=$lang]"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>
        </xsl:if>

        <!-- Institution and Inventory -->
        <xsl:if test="//tei:altIdentifier[@n = current()/@n or not(@n)]">
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of
                  select="if ($lang='ru') then 'Институт  хранения' else 'Institution and inventory'"
                />
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:value-of
                select="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:repository"/>
              <xsl:if
                test="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:idno/text()">
                <xsl:text>&#160;</xsl:text>
              </xsl:if>
              <xsl:value-of
                select="//tei:altIdentifier[@n = current()/@n or not(@n)][@xml:lang=$lang]/tei:idno"/>
              <xsl:text>.&#160;</xsl:text>
            </div>
          </div>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:body">
    <xsl:call-template name="objectData"/>

    <!-- Render metadata about physical object; either whole or in fragments (tei:div[@subtype='fragment']) -->
    <xsl:choose>
      <xsl:when test="//tei:div[@type='edition']/tei:div[@subtype='fragment']">
        <xsl:for-each select="//tei:div[@type='edition']//tei:div[@subtype='fragment']">
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

    <!-- <xsl:message>
      <xsl:value-of select="$fullN"/>
    </xsl:message> -->

    <!-- If there are multiple inscriptions, add title -->
    <div class="large-12">
      <div class="row">
        <div class="large-2 columns">
          <xsl:if test="self::tei:div[@subtype='inscription']/@n">
            <xsl:attribute name="class">
              <xsl:text>large-2 columns wrap</xsl:text>
            </xsl:attribute>
            <xsl:element name="{if ($nestedTitles=true()) then 'h4' else 'h2'}">
              <xsl:attribute name="class">
                <xsl:text>part</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="if ($lang='ru') then 'Надпись ' else 'Inscription '"/>
              <xsl:value-of select="@n"/>
              <xsl:text>.&#160;</xsl:text>
            </xsl:element>
          </xsl:if>



          <!-- Inscribed field -->

          <xsl:element
            name="{if (self::tei:div[@subtype='inscription']/@n)
                          then
                          if ($nestedTitles=true())
                          then 'h4'
                          else 'h2'
                          else 'h2'}">
            <xsl:attribute name="class">
              <xsl:text>field</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="if ($lang='ru') then 'Эпиграфическое поле' else 'Inscribed field'"
            />
          </xsl:element>
        </div>

        <div class="large-10 columns">
          <xsl:for-each select="//tei:layout[@n=$fullN or not(@n)]">
            <xsl:if test="@ana">

              <!-- Faces code -->
              <div class="row">
                <div class="large-2 columns">
                  <h3>
                    <xsl:value-of select="if ($lang='ru') then 'Код фаса' else 'Faces code'"/>
                  </h3>
                </div>
                <div class="large-10 columns">
                  <xsl:value-of select="@ana"/>
                  <xsl:text>.&#160;</xsl:text>
                </div>
              </div>
            </xsl:if>

            <!-- Placement of text (If exists) -->
            <xsl:if test="tei:seg">
              <div class="row">
                <div class="large-2 columns">
                  <h3>
                    <xsl:value-of
                      select="if ($lang='ru') then 'Местоположение' else 'Placement of text'"/>
                  </h3>
                </div>
                <div class="large-10 columns">
                  <xsl:value-of select="tei:seg[@xml:lang=$lang]"/>
                  <xsl:text>&#160;</xsl:text>
                </div>
              </div>
            </xsl:if>
          </xsl:for-each>

          <!-- Style of lettering (if exists) -->
          <xsl:if test="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:seg">
            <div class="row">
              <div class="large-2 columns">
                <h3>
                  <xsl:value-of
                    select="if ($lang='ru') then 'Стиль  письма' else 'Style of lettering'"/>
                </h3>
              </div>
              <div class="large-10 columns">
                <xsl:value-of
                  select="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/>
                <xsl:text>&#160;</xsl:text>
              </div>
            </div>
          </xsl:if>

          <!-- Letterheights (if exists) -->
          <xsl:if test="//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height">
            <div class="row">
              <div class="large-2 columns">
                <h3>
                  <xsl:value-of select="if ($lang='ru') then 'Высота букв' else 'Letterheights'"/>
                </h3>
              </div>
              <div class="large-10 columns">
                <xsl:value-of
                  select="if ($lang='ru') then //tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height else translate(//tei:handDesc/tei:handNote[@n=$fullN or not(@n)]/tei:height, ',', '.')"/>
                <xsl:text>&#160;</xsl:text>
              </div>
            </div>
          </xsl:if>


        </div>
      </div>

      <!-- Text -->
      <div class="row">
        <div class="large-2 columns">
          <!-- Text -->
          <xsl:element name="{if (@n) then if ($nestedTitles=true()) then 'h4' else 'h2' else 'h2'}">
            <xsl:attribute name="class">
              <xsl:text>field</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="if ($lang='ru') then 'Текст' else 'Text'"/>
          </xsl:element>
        </div>

        <div class="large-10 columns">

          <!-- Origin -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Происхождение текста' else 'Origin'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:value-of
                select="//tei:origPlace[@n = $fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Category -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Характер документа' else 'Category'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:value-of
                select="//tei:msContents/tei:summary/tei:seg[@n = $fullN or not(@n)][@xml:lang=$lang]"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Date -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Датировка текста' else 'Date'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:value-of
                select="//tei:history/tei:origin/tei:origDate[@n = $fullN or not(@n)]/tei:seg[@xml:lang=$lang]"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Dating Criteria -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of
                  select="if ($lang='ru') then 'Обоснование датировки' else 'Dating criteria'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:choose>
                <xsl:when test="$lang='ru'">
                  <xsl:value-of
                    select="translate(string-join(tokenize(//tei:origDate[1]/@evidence, ' '), ', '), '-', ' ')"/>
                  <xsl:text>.&#160;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="string-join(for $term in tokenize(//tei:origDate[1]/@evidence, ' ') return //crit//tei:label[lower-case(.)=lower-case(normalize-space(translate($term,'-',' ')))]/following-sibling::tei:item[1], ', ')"/>
                  <xsl:text>.&#160;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>

          <!-- Editions -->
          <div class="row">
            <div class="large-2 columns">
              <h3>
                <xsl:value-of select="if ($lang='ru') then 'Издания' else 'Editions'"/>
              </h3>
            </div>
            <div class="large-10 columns">
              <xsl:choose>
                <xsl:when
                  test="//tei:div[@type='bibliography'][tei:listBibl[@n = $fullN or not(@n)]]">
                  <xsl:for-each
                    select="//tei:div[@type='bibliography']/tei:listBibl[@n = $fullN or not(@n)]/tei:bibl">
                    <xsl:if test="@n">
                      <xsl:value-of select="@n"/>
                      <xsl:text/>
                    </xsl:if>
                    <xsl:variable name="target" select="tei:ptr/@target"/>
                    <xsl:for-each select="//bib//tei:biblStruct[@xml:id=$target]">
                      <xsl:value-of
                        select="normalize-space(descendant::tei:author[1]/descendant::tei:surname[if (not(@xml:lang)) then true() else @xml:lang=$lang][1])"/>
                      <xsl:if test="descendant::tei:author[2]">
                        <xsl:text>,</xsl:text>
                        <xsl:value-of
                          select="normalize-space(descendant::tei:author[2]//tei:surname[if (not(@xml:lang)) then true() else @xml:lang=$lang][1])"
                        />
                      </xsl:if>
                      <xsl:if test="count(//tei:biblStruct[@xml:id=$target]//tei:author[1])> 2">
                        <xml:text>, et al.</xml:text>
                      </xsl:if>
                      <xsl:text/>
                      <xsl:value-of select="normalize-space(descendant::tei:imprint[1]/tei:date[1])"
                      />
                    </xsl:for-each>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="following-sibling::tei:bibl">
                      <xsl:text>;</xsl:text>
                    </xsl:if>
                  </xsl:for-each>

                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="if ($lang='ru') then 'ined' else 'Unpublished'"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>.&#160;</xsl:text>
            </div>


            <!-- Actual Inscription Data -->
            <div class="row">
              <!-- Creates the inscription views from preprocessed files aggregated in the sitemap -->
              <div class="large-12 columns">
                <div class="section-container tabs" data-section="tabs">

                  <!-- Edition -->
                  <section>
                    <p class="title" data-section-title="data-section-title">
                      <a href="#edition{if (@n) then @n else '1'}">
                        <xsl:value-of select="if ($lang='ru') then 'Критическое' else 'Edition'"/>
                      </a>
                    </p>
                    <div id="edition{if (@n) then @n else '1'}" class="content"
                      data-section-content="data-section-content">
                      <!-- Only get current text part (inscription) if necessary -->
                      <xsl:choose>
                        <xsl:when test="@n">
                          <xsl:variable name="tet" select="@n"/>
                          <xsl:apply-templates
                            select="//v_in//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates
                            select="//v_in//div[@id='edition'][1]/*[not(self::h2)]"
                            mode="copyEpidoc"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </section>

                  <!-- Diplomatic -->
                  <section>
                    <p class="title" data-section-title="data-section-title">
                      <a href="#diplomatic{if (@n) then @n else '1'}">
                        <xsl:value-of
                          select="if ($lang='ru') then 'Дипломатическое' else 'Diplomatic'"/>
                      </a>
                    </p>
                    <div id="diplomatic{if (@n) then @n else '1'}" class="content"
                      data-section-content="data-section-content">
                      <xsl:choose>
                        <xsl:when test="@n">
                          <xsl:variable name="tet" select="@n"/>
                          <xsl:apply-templates
                            select="//v_di//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]"
                            mode="copyEpidoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates
                            select="//v_di//div[@id='edition'][1]/*[not(self::h2)]"
                            mode="copyEpidoc"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </section>

                  <!-- Epidoc XML -->
                  <section>
                    <p class="title" data-section-title="data-section-title">
                      <a href="#epidoc{if (@n) then @n else '1'}">
                        <xsl:value-of
                          select="if ($lang='ru') then 'EpiDoc (XML)' else 'EpiDoc (XML)'"/>
                      </a>
                    </p>
                    <div id="epidoc{if (@n) then @n else '1'}" class="content"
                      data-section-content="data-section-content">
                      <pre><code class="language-xml"><xsl:copy-of select="//v_ep/node()"/></code></pre>
                    </div>
                  </section>

                  <!-- Edition in Verse (If it exists)-->
                  <xsl:if test="descendant::tei:lg">
                    <section>
                      <p class="title" data-section-title="data-section-title">
                        <a href="#verse{if (@n) then @n else '1'}">
                          <xsl:value-of
                            select="if ($lang='ru') then 'В стихотворной форме' else 'Edition in Verse'"
                          />
                        </a>
                      </p>
                      <div id="verse{if (@n) then @n else '1'}" class="content"
                        data-section-content="data-section-content">
                        <xsl:choose>
                          <xsl:when test="@n">
                            <xsl:variable name="tet" select="@n"/>
                            <xsl:apply-templates
                              select="//v_ve//div[@id='edition'][1]//div[starts-with(@id,concat('div',$tet))]"
                              mode="copyEpidoc"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:apply-templates
                              select="//v_ve//div[@id='edition'][1]/*[not(self::h2)]"
                              mode="copyEpidoc"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </div>
                    </section>
                  </xsl:if>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>

      <!-- Apparatus Criticus -->

      <xsl:if
        test="//tei:div[@type='apparatus'][@n = $fullN or not(@n)][descendant::tei:app/descendant::text()]">
        <div class="row">
          <div class="large-2 columns">
            <h2>
              <xsl:value-of
                select="if ($lang='ru') then 'Критический аппарат' else 'Apparatus criticus'"/>
            </h2>
          </div>
          <div class="large-10 columns">
            <xsl:apply-templates mode="multipara"
              select="//tei:div[@type='apparatus'][@n = $fullN or not(@n)]"/>
          </div>
        </div>
      </xsl:if>

      <!-- Translation -->

      <div class="row">
        <div class="large-2 columns">
          <h2>
            <xsl:value-of select="if ($lang='ru') then 'Перевод' else 'Translation'"/>
          </h2>
        </div>
        <div class="large-10 columns">
          <!-- N.B. Leaving @n=none and @n=notyet even though they are not used in corpus yet -->
          <xsl:choose>
            <xsl:when test="//tei:div[@type='translation'][@n='none'][@xml:lang=$lang]">
              <xsl:value-of
                select="if ($lang='ru') then 'RU-not usefully translatable.' else ' not usefully translatable.'"
              />
            </xsl:when>
            <xsl:when test="//tei:div[@type='translation'][@n='notyet'][@xml:lang=$lang]">
              <xsl:value-of
                select="if ($lang='ru') then 'RU-No translation yet (2012).:' else 'No translation yet (2010).'"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@n">
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type='translation'][@xml:lang=$lang]/tei:div[@type='textpart'][@n=$fullN]"
                  />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type='translation'][@xml:lang=$lang]"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>

      <!-- Commenttary -->

      <div class="row">
        <div class="large-2 columns">
          <h2>
            <xsl:value-of select="if ($lang='ru') then 'Комментарий' else 'Commentary'"/>
          </h2>
        </div>
        <div class="large-10 columns">
          <xsl:choose>
            <xsl:when test="//tei:div[@type='commentary'][@xml:lang=$lang]//tei:p/text()">
              <xsl:choose>
                <xsl:when test="@n">
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type='commentary'][@xml:lang=$lang]/tei:div[@type='textpart'][@n=$fullN]"
                  />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="multipara"
                    select="//tei:div[@type='commentary'][@xml:lang=$lang]"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="if ($lang='ru') then 'RU-no comment.' else 'no comment.'"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>

      <!-- Images -->

      <xsl:if test="//tei:facsimile//tei:graphic">
        <div class="row">
          <div class="large-2 columns">
            <h2>
              <xsl:value-of select="if ($lang='ru') then 'Изображения' else 'Images'"/>
            </h2>
          </div>
          <div class="large-10 columns">
            <xsl:apply-templates select="//tei:facsimile//tei:graphic" mode="photograph"/>

          </div>
        </div>
      </xsl:if>
    </div>

    <xsl:apply-templates/>

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

  <!-- Mode multipara -->
  <xsl:template match="tei:p|tei:ab" mode="multipara">
    <p xsl:exclude-result-prefixes="tei">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <xsl:template match="tei:div/tei:head" mode="multipara"> </xsl:template>

</xsl:stylesheet>
