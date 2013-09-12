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
          <h6>
            <xsl:value-of select="if ($lang='ru') then 'Разновидность' else 'Type of monument'"/>
          </h6>
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
          <h6>
            <xsl:value-of select="if ($lang='ru') then 'Материал' else 'Material'"/>
          </h6>
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
          <h6>
            <xsl:value-of
              select="if ($lang='ru') then 'Описание  и состояние  документа' else 'Description and condition'"
            />
          </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Место  находки' else 'Find place'"/>
              </h6>
            </div>

            <div class="large-10 columns">
              <xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:placeName[@type='ancientFindspot']"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Find Circumnstances -->
          <div class="row">
            <div class="large-2 columns">
              <h6>
                <xsl:value-of
                  select="if ($lang='ru') then 'Условия  находки' else 'Find circumstances'"/>
              </h6>
            </div>

            <div class="large-10 columns">
              <xsl:value-of select="tei:seg[@xml:lang=$lang]/tei:rs[@type='circumstances']"/>
              <xsl:text>&#160;</xsl:text>
            </div>
          </div>

          <!-- Find context -->
          <div class="row">
            <div class="large-2 columns">
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Контекст находки' else 'Find context'"/>
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Место хранения' else 'Modern location'"
                />
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Размеры' else 'Dimensions'"/>
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Автопсия' else 'Autopsy'"/>
              </h6>
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
              <h6>
                <xsl:value-of
                  select="if ($lang='ru') then 'Институт  хранения' else 'Institution and inventory'"
                />
              </h6>
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
                  <h6>
                    <xsl:value-of select="if ($lang='ru') then 'Код фаса' else 'Faces code'"/>
                  </h6>
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
                  <h6>
                    <xsl:value-of
                      select="if ($lang='ru') then 'Местоположение' else 'Placement of text'"/>
                  </h6>
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
                <h6>
                  <xsl:value-of
                    select="if ($lang='ru') then 'Стиль  письма' else 'Style of lettering'"/>
                </h6>
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
                <h6>
                  <xsl:value-of select="if ($lang='ru') then 'Высота букв' else 'Letterheights'"/>
                </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Происхождение текста' else 'Origin'"/>
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Характер документа' else 'Category'"/>
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Датировка текста' else 'Date'"/>
              </h6>
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
              <h6>
                <xsl:value-of
                  select="if ($lang='ru') then 'Обоснование датировки' else 'Dating criteria'"/>
              </h6>
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
              <h6>
                <xsl:value-of select="if ($lang='ru') then 'Издания' else 'Editions'"/>
              </h6>
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

<!--     <xsl:apply-templates/>
 -->
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

  <xsl:template match="tei:div[@type='apparatus']" mode="multipara">
    <xsl:for-each select="descendant::tei:app">
      <xsl:if
        test="@loc and (not(preceding-sibling::tei:app) or @loc != preceding-sibling::tei:app[1]/@loc)">
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
          <tei:resp>
            <xsl:value-of select="."/>
          </tei:resp>
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
              <xsl:for-each
                select="$docSubset//tei:body//tei:div[@type='bibliography']/tei:listBibl[if (@n) then @n=$cur-n else true()]/tei:bibl//tei:ptr">
                <xsl:sequence select="$docSubset//tei:biblStruct[@xml:id=current()/@target]"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="cur-surname">
              <xsl:value-of
                select="normalize-space($biblio-subset//tei:biblStruct[@xml:id=current()][1]/(descendant::tei:surname[if (@xml:lang=$lang) then @xml:lang else if (not(@xml:lang)) then true() else false()])[1])"
              />
            </xsl:variable>
            <xsl:variable name="bibDate">
              <xsl:if
                test="count($biblio-subset//tei:biblStruct//tei:author[1]//tei:surname[if (@xml:lang=$lang) then @xml:lang=$lang else if (not(@xml:lang)) then true() else false()][normalize-space(.)=$cur-surname]) &gt; 1">
                <xsl:value-of
                  select="$biblio-subset//tei:biblStruct[@xml:id=current()]//tei:imprint[1]//tei:date"
                />
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

  <xsl:template match="tei:lb">
    <xsl:text>|</xsl:text>
  </xsl:template>
  <!-- FIGURES -->
  <xsl:template match="tei:facsimile//tei:graphic" mode="photograph">
    <span
      style="height: 100%; min-height: 106px; min-width: 106px; text-align: center; vertical-align: middle;">
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
            <xsl:value-of
              select="if ($lang='ru') then 'переход к надписи № ' else 'Link to inscription '"/>
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
            <xsl:value-of
              select="if ($lang='ru') then 'RU-Link to PHI Inscriptions (opens in new window)' else 'Link to PHI Inscriptions (opens in new window)'"
            />
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
            <xsl:value-of
              select="if ($lang='ru') then 'RU-Link to EDH Inscriptions (opens in new window)' else 'Link to EDH Inscriptions (opens in new window)'"
            />
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
