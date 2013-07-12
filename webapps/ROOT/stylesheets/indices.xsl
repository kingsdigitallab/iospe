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
    xmlns:iospe="http://iospe.cch.kcl.ac.uk/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
        Handles indices.
        Raffaele Viglianti; started on March 20 2012
    -->

    <xsl:import href="default.xsl" />
    <xsl:import href="common/conversions.xsl" />

    <xsl:param name="filedir" />
    <xsl:param name="filename" />
    <xsl:param name="fileextension" />
    <xsl:param name="lang" select="'en'" />
    <xsl:param name="ancient-lang" select="'n/a'" />

    <xsl:param name="index"/>
    <xsl:param name="sort"/>

    <xsl:function name="iospe:sort-dur">
        <xsl:param name="w3cdur"/>
        <xsl:param name="request"/>
        <xsl:variable name="year">
            <xsl:analyze-string select="$w3cdur" regex="^P(\d+)Y">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="month">
            <xsl:analyze-string select="$w3cdur" regex="(\d+)M">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:analyze-string select="$w3cdur" regex="(\d+)D">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$request='Y'">
                <xsl:value-of select="$year"/>
            </xsl:when>
            <xsl:when test="$request='M'">
                <xsl:value-of select="$month"/>
            </xsl:when>
            <xsl:when test="$request='D'">
                <xsl:value-of select="$day"/>
            </xsl:when>
        </xsl:choose>


    </xsl:function>

    <!-- OVERRIDING TEMPLATES FROM default.xsl -->
    <xsl:template name="xmv:script">
        <script src="{$xmp:assets-path}/s/jquery-1.6.2.min.js" type="text/javascript">&#160;</script>
        <script src="{$xmp:assets-path}/s/superfish.js" type="text/javascript">&#160;</script>
        <script src="{$xmp:assets-path}/s/c.js" type="text/javascript">&#160;</script>
        <script src="{$xmp:assets-path}/s/awld/require.min.js" type="text/javascript">&#160;</script>
        <script src="{$xmp:assets-path}/s/awld/awld.js?autoinit" type="text/javascript">&#160;</script>
    </xsl:template>

    <!-- set title -->
    <xsl:variable name="xmg:title">
        <!-- KFL - Inscriptions by Date gets title from tocs.xsl, all the rest get the title here -->
        <xsl:choose>
            <xsl:when test="$index='home'">
                <xsl:value-of select="if ($lang='en') then 'Indices' else 'Указатели'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='words' and //str[@name='lang']='lat'">
                <xsl:value-of select="if ($lang='en') then 'Latin Words' else 'Латинские слова'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='words' and //str[@name='lang']='grc'">
                <xsl:value-of select="if ($lang='en') then 'Greek Words' else 'Греческие слова'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='fragments' and //str[@name='lang']='lat'">
                <xsl:value-of select="if ($lang='en') then 'Fragments of Text in Latin' else 'Фрагменты текстов на латинском языке'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='fragments' and //str[@name='lang']='grc'">
                <xsl:value-of select="if ($lang='en') then 'Fragments of Text in Greek' else 'Фрагменты текстов на греческом языке'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='attested' and //str[@name='persName-type']='attested'">
                <xsl:value-of select="if ($lang='en') then 'Personal Names' else 'Личные имена'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='ruler' and //str[@name='persName-type']='ruler'">
                <xsl:value-of select="if ($lang='en') then 'Rulers of Rome, Byzantium or Bosporan Kingdoms' else 'Правители Рима, Византии или Боспорского царства'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='divine' and //str[@name='persName-type']='divine'">
                <xsl:value-of select="if ($lang='en') then 'Divine, religious or mythic figures' else 'Божественные, религиозные или мифические личности и персонажи'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='places'">
                <xsl:value-of select="if ($lang='en') then 'Mentioned places' else 'Места, упомянутые в надписях'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='months'">
                <xsl:value-of select="if ($lang='en') then 'Months' else 'Месяцы'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='symbols'">
                <xsl:value-of select="if ($lang='en') then 'Symbols' else 'Символы'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='numerals'">
                <xsl:value-of select="if ($lang='en') then 'Numerals' else 'Числа'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='ligatures'">
                <xsl:value-of select="if ($lang='en') then 'Ligatured characters' else 'RU: Ligatured characters'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='abbr'">
                <xsl:value-of select="if ($lang='en') then 'Abbreviations' else 'Аббревиатуры'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='death'">
                <xsl:value-of select="if ($lang='en') then 'Age at Death' else 'Возраст в момент смерти'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index=concat('findspot-',$lang)">
                <xsl:value-of select="if ($lang='en') then 'Find Places' else 'Месту находки'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='persons'">
                <xsl:value-of select="if ($lang='en') then 'Attested Persons' else 'Идентифицированные лица'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='attested'">
                <xsl:value-of select="if ($lang='en') then 'Personal names' else 'Личные имена'"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$index='monument-type'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Monument Type' else 'Надписи по типу памятника'"/>
            </xsl:when>
            <xsl:when test="$index='document-type'">
                <xsl:value-of select="if ($lang='en') then 'Inscriptions by Category of Text' else 'Надписи по типу документа'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- Some indices require an upper-case grouping. Add the list here -->
    <!-- Pull the right transformation to keep the grouping key unchanged or make it uppercase -->
    <xsl:variable name="transformation">
        <xsl:choose>
            <xsl:when test="$index=('fragment', 'abbr')">
                <xsl:sequence select="$uppercase"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$lowercase"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- OVERRIDES -->
    <xsl:template name="xms:options1" /> 
    <xsl:template name="xms:options2" />

    <xsl:template name="xms:submenu" />

    <xsl:template name="xms:footnotes" />

    <xsl:template name="xms:content">

        <!-- Generate homepage with $index is 'home' -->
        <xsl:choose>
            <xsl:when test="$index='home' and $lang='en'">
                <ul>
                    Words and Names
                    <li>
                        <xsl:choose>
                            <xsl:when test="//words-grc//result[@numFound &gt; 0]">
                                <a href="words/grc/{//words-grc//str[@name='first-letter']}.html">
                                    Greek words
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Greek words <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!--<li>
                        <xsl:choose>
                        <xsl:when test="//words-lat//result[@numFound &gt; 0]">
                        <a href="words/lat/{//words-lat//str[@name='first-letter']}.html">
                        Latin words
                        </a>
                        </xsl:when>
                        <xsl:otherwise>
                        Latin words <em>(no results found)</em>
                        </xsl:otherwise>
                        </xsl:choose>
                        </li>-->
                    <li>
                        <xsl:choose>
                            <xsl:when test="//attested//result[@numFound &gt; 0]">
                                <a href="names/{//attested//str[@name='first-letter']}.html">
                                    Personal names
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Personal names <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//fragments-grc//result[@numFound &gt; 0]">
                                <a href="fragments/grc/{//fragments-grc//str[@name='first-letter']}.html">
                                    Fragments of text in Greek
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Fragments of text in Greek <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!--<li>
                        <xsl:choose>
                        <xsl:when test="//fragments-lat//result[@numFound &gt; 0]">
                        <a href="fragments/lat/{//fragments-lat//str[@name='first-letter']}.html">
                        Fragments of text in Latin
                        </a>
                        </xsl:when>
                        <xsl:otherwise>
                        Fragments of text in Latin <em>(no results found)</em>
                        </xsl:otherwise>
                        </xsl:choose>
                        </li>-->
                </ul>
                <ul>
                    Prosopography and Geography
                    <li>
                        <a href="person/other.html">
                            Attested Persons
                        </a>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//ruler//result[@numFound &gt; 0]">
                                <a href="person/ruler.html">
                                    Rulers of Rome, Byzantium or Bosporan kingdoms
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Rulers of Rome, Byzantium or Bosporan kingdoms <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//divine//result[@numFound &gt; 0]">
                                <a href="person/divine.html">
                                    Divine, religious or mythic figures
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Divine, religious or mythic figures  <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//places//result[@numFound &gt; 0]">
                                <a href="places.html">
                                    Mentioned places
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Mentioned places <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>
                <ul>
                    Other Features
                    <li>
                        <xsl:choose>
                            <xsl:when test="//abbr//result[@numFound &gt; 0]">
                                <a href="abbr.html">
                                    Abbreviations
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Abbreviations <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//symbols//result[@numFound &gt; 0]">
                                <a href="symbols.html">
                                    Symbols
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Symbols <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//numerals//result[@numFound &gt; 0]">
                                <a href="numerals.html">
                                    Numerals
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Numerals <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//months//result[@numFound &gt; 0]">
                                <a href="months.html">
                                    Months
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Months <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!--<li>
                        <xsl:choose>
                            <xsl:when test="//ligatures//result[@numFound &gt; 0]">
                                <a href="ligatures.html">
                                    Ligatured characters
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Ligatured characters <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>-->
                    <li>
                        <xsl:choose>
                            <xsl:when test="//death//result[@numFound &gt; 0]">
                                <a href="death.html">
                                    Age at death
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Age at death <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>
                <ul>
                    Inscriptions
                    <!--<li>
                        <a href="bynum.html">
                            All Inscriptions by Number
                        </a>
                    </li>-->
                    <li>
                        <a href="date/dated.html">
                            By date
                        </a>
                    </li>
                    <li>
                        <a href="document-type.html">
                            By category of text
                        </a>
                    </li>
                    <li>
                        <a href="monument-type.html">
                            By monument type
                        </a>
                    </li>
                    <li>
                        <a href="findspot.html">
                            By find place
                        </a>
                    </li>
                </ul>
            </xsl:when>
            <!-- RUSSIAN -->
            <xsl:when test="$index='home' and $lang='ru'">
                <ul>
                    Слова и имена собственные
                    <li>
                        <xsl:choose>
                            <xsl:when test="//words-grc//result[@numFound &gt; 0]">
                                <a href="words/grc/{//words-grc//str[@name='first-letter']}-ru.html">
                                    Греческие слова
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Греческие слова <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!--<li>
                        <xsl:choose>
                        <xsl:when test="//words-lat//result[@numFound &gt; 0]">
                        <a href="words/lat/{//words-lat//str[@name='first-letter']}-ru.html">
                        Латинские слова
                        </a>
                        </xsl:when>
                        <xsl:otherwise>
                        Латинские слова <em>(no results found)</em>
                        </xsl:otherwise>
                        </xsl:choose>
                        </li>-->
                    <li>
                        <xsl:choose>
                            <xsl:when test="//attested//result[@numFound &gt; 0]">
                                <a href="names/{//attested//str[@name='first-letter']}-ru.html">
                                    Личные имена
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Личные имена <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//fragments-grc//result[@numFound &gt; 0]">
                                <a href="fragments/grc/{//fragments-grc//str[@name='first-letter']}-ru.html">
                                    Фрагменты текстов на греческом языке
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Фрагменты текстов на греческом языке <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!--<li>
                        <xsl:choose>
                        <xsl:when test="//fragments-lat//result[@numFound &gt; 0]">
                        <a href="fragments/lat/{//fragments-lat//str[@name='first-letter']}-ru.html">
                        Фрагменты текстов на латинском языке
                        </a>
                        </xsl:when>
                        <xsl:otherwise>
                        Фрагменты текстов на латинском языке <em>(no results found)</em>
                        </xsl:otherwise>
                        </xsl:choose>
                        </li>-->
                </ul>
                <ul>
                    Просопография и география
                    <li>
                        <a href="person/other-ru.html">
                            Идентифицированные лица
                        </a>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//ruler//result[@numFound &gt; 0]">
                                <a href="person/ruler-ru.html">
                                    Правители Рима, Византии или Боспорского царства
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Правители Рима, Византии или Боспорского царства <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//divine//result[@numFound &gt; 0]">
                                <a href="person/divine-ru.html">
                                    Божественные, религиозные или мифические личности и персонажи
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Божественные, религиозные или мифические личности и персонажи <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//places//result[@numFound &gt; 0]">
                                <a href="places-ru.html">
                                    Места, упомянутые в надписях
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Места, упомянутые в надписях <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>
                <ul>
                    Другие категории
                    <li>
                        <xsl:choose>
                            <xsl:when test="//abbr//result[@numFound &gt; 0]">
                                <a href="abbr-ru.html">
                                    Аббревиатуры
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Аббревиатуры <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//symbols//result[@numFound &gt; 0]">
                                <a href="symbols-ru.html">
                                    Символы
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Символы <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//numerals//result[@numFound &gt; 0]">
                                <a href="numerals-ru.html">
                                    Числа
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Числа <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//months//result[@numFound &gt; 0]">
                                <a href="months-ru.html">
                                    Месяцы
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Месяцы <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="//death//result[@numFound &gt; 0]">
                                <a href="death-ru.html">
                                    Возраст в момент смерти
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                Возраст в момент смерти <em>(no results found)</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>
                <ul>
                    Надписи
                    <!--<li>
                        <a href="bynum-ru.html">
                            RU: All Inscriptions by Number
                        </a>
                    </li>-->
                    <li>
                        <a href="date/dated-ru.html">
                            по дате
                        </a>
                    </li>
                    <li>
                        <a href="document-type-ru.html">
                            по типу документа
                        </a>
                    </li>
                    <li>
                        <a href="monument-type-ru.html">
                            по типу памятника
                        </a>
                    </li>
                    <li>
                        <a href="findspot-ru.html">
                            по месту находки
                        </a>
                    </li>
                </ul>
            </xsl:when>

            <xsl:otherwise>
                <div class="index">
                    <div class="t01">
                        <xsl:choose>
                            <!-- Abbr needs double sorting - special case -->
                            <xsl:when test="$index='abbr'">
                                <dl>
                                    <xsl:for-each-group select="//doc" group-by="translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)">


                                        <xsl:if test="not(translate(str[@name='abbr'], ' ','') = '')">
                                            <dt>
                                               <xsl:value-of select="current-grouping-key()"/>
                                            </dt>

                                            <xsl:for-each-group select="//doc[translate(translate(normalize-space(str[@name='abbr']), '[].? - ', ''), $lowercase, $transformation)=current-grouping-key()]" group-by="translate(normalize-space(str[@name='expan']), '[].? - ', '')">
                                                <xsl:sort select="str[@name='expan-sort']"/>
                                                <dd>
                                                    <xsl:value-of select="current-grouping-key()"/>
                                                    <xsl:text> </xsl:text>
                                                    <ul class="oneline">
                                                        <xsl:for-each select="//doc[translate(normalize-space(str[@name='expan']), '[].? - ', '')=current-grouping-key()]">
                                                            <li>
                                                                <xsl:call-template name="link2inscription"/>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </dd>
                                            </xsl:for-each-group>
                                        </xsl:if>

                                    </xsl:for-each-group>
                                </dl>
                            </xsl:when>
                            <xsl:when test="$index=('divine', 'ruler')">
                                <dl>
                                    <xsl:for-each select="//AL//tei:listPerson">
                                        <h2><xsl:value-of select="tei:head[@xml:lang=$lang]"/></h2>

                                        <xsl:for-each select="tei:person[not(@xml:id) or @xml:id=(//result//doc/str[@name='persName-key'])]">
                                            <dt>
                                                <xsl:choose>
                                                    <xsl:when test="count(tei:persName[not(@type)][@xml:lang])>1">
                                                        <xsl:value-of select="tei:persName[not(@type)][@xml:lang='grc'][1]"/>
                                                        <xsl:if test="tei:persName[not(@type)][@xml:lang='la']">
                                                            <xsl:text> / </xsl:text>
                                                            <xsl:value-of select="tei:persName[not(@type)][@xml:lang='la'][1]"/>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="tei:persName[not(@type)][1]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </dt>
                                            <xsl:choose>
                                                <xsl:when test="@xml:id">
                                                    <xsl:for-each-group select="//result//doc[str[@name='persName-key']=current()/@xml:id]" group-by="str[@name='persName-full']">
                                                        <dd>
                                                            <xsl:value-of select="current-grouping-key()"/>
                                                            <xsl:text> </xsl:text>
                                                            <ul class="oneline">
                                                                <xsl:for-each select="current-group()">
                                                                    <li><xsl:call-template name="link2inscription"/></li>
                                                                </xsl:for-each>
                                                            </ul>
                                                        </dd>
                                                    </xsl:for-each-group>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <dd>See:
                                                        <xsl:choose>
                                                            <xsl:when test="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/count(tei:persName[@xml:lang])>1">
                                                                <xsl:value-of select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[@xml:lang='grc'][1]"/>
                                                                <xsl:if test="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[not(@type)][@xml:lang='la']">
                                                                    <xsl:text> / </xsl:text>
                                                                    <xsl:value-of select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[@xml:lang='la'][1]"/>
                                                                </xsl:if>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="//AL//tei:person[@xml:id=substring-after(current()/@sameAs,'#')]/tei:persName[1]"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </dd>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </dl>

                            </xsl:when>
                            <xsl:when test="$index='months'">
                                <dl>
                                    <xsl:for-each select="//AL//list">
                                        <h2><xsl:value-of select="head"/></h2>
                                        <xsl:for-each select="descendant::month">
                                            <dt>
                                                <xsl:choose>
                                                    <xsl:when test="count(name[not(@type)][@xml:lang])>1">
                                                        <xsl:value-of select="name[not(@type)][@xml:lang='grc'][1]"/>
                                                        <xsl:if test="name[not(@type)][@xml:lang='la']">
                                                            <xsl:text> / </xsl:text>
                                                            <xsl:value-of select="name[not(@type)][@xml:lang='la'][1]"/>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="name[not(@type)][1]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </dt>
                                            <xsl:choose>
                                                <xsl:when test="@xml:id">
                                                    <dd>
                                                        <ul>
                                                            <xsl:for-each select="//result//doc[str[@name='months-ref']=current()/@xml:id]">
                                                                <li>
                                                                    <xsl:call-template name="link2inscription"/>
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </dd>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </dl>

                            </xsl:when>
                            <xsl:when test="$index='places'">
                                <dl>
                                    <xsl:for-each select="//AL//tei:place[@xml:id=(//result//doc//str[@name='places-key'])]">
                                        <dt>
                                            <xsl:choose>
                                                <xsl:when test="count(tei:placeName[@xml:lang])>1">
                                                    <xsl:value-of select="translate(tei:placeName[@xml:lang='grc'][1],'.','')"/>
                                                    <xsl:if test="tei:placeName[@xml:lang='la']">
                                                        <xsl:text> / </xsl:text>
                                                        <xsl:value-of select="translate(tei:placeName[@xml:lang='la'][1],'.','')"/>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="translate(tei:placeName[1],'.','')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="tei:placeName[@xml:lang=$lang]">
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="string-join(translate(tei:placeName[@xml:lang=$lang],'.',''), ', ')"/>
                                                <xsl:text>)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test="tei:idno[@type='pleiades']">
                                                <xsl:text> [</xsl:text>
                                                <a href="{tei:idno[@type='pleiades']}">Pleiades</a>
                                                <xsl:text>]</xsl:text>
                                            </xsl:if>
                                        </dt>
                                        <xsl:choose>
                                            <xsl:when test="@xml:id">
                                                <xsl:for-each-group select="//result//doc[str[@name='places-key']=current()/@xml:id]" group-by="str[@name='places']">
                                                    <dd>
                                                        <xsl:value-of select="current-grouping-key()"/>
                                                        <xsl:text> </xsl:text>
                                                        <ul class="oneline">
                                                            <xsl:for-each select="current-group()">
                                                                <li><xsl:call-template name="link2inscription"/></li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </dd>
                                                </xsl:for-each-group>
                                            </xsl:when>
                                            <xsl:otherwise>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </dl>

                            </xsl:when>
                            <xsl:when test="$index='persons' and $sort='date'"> 
                                <xsl:call-template name="sort-option"/>
                                <dl>
                                    <xsl:for-each select="//persons//tei:person">
                                        <xsl:sort select="concat(tei:floruit[tei:seg[@xml:lang=$lang]]/@notBefore, 'X')"/>
                                        <xsl:sort select="tei:floruit[tei:seg[@xml:lang=$lang]]/@notAfter"/>
                                        <xsl:call-template name="person"/>
                                        
                                    </xsl:for-each>
                                </dl>
                            </xsl:when>                            
                            <xsl:when test="$index='persons'"> 
                                <xsl:call-template name="sort-option"/>
                                <dl>
                                <xsl:for-each select="//persons//tei:person">
                                    <xsl:sort select="concat(upper-case(replace(normalize-unicode(normalize-space(tei:persName[@xml:lang=$lang]),'NFKD'),'[^A-Za-z0-9А-Яа-я ]','')), 'ЯЯЯ')"/>
                                 <xsl:call-template name="person"/>
                                       
                                </xsl:for-each>
                                </dl>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- ALL OTHER INDICES, INCLUDING PAGINATED ONES -->

                                <!-- list of available letters, if present -->
                                <xsl:if test="//letters">
                                    <ul class="letters">
                                        <xsl:for-each select="//letters/letter">
                                            <li>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:choose>
                                                            <xsl:when test="$ancient-lang=('grc', 'all')">
                                                                <xsl:value-of select="translate(translate(., $unicode, $betacode),$lowercase, $uppercase)"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="."/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:value-of select="if ($lang='ru') then '-ru' else()"/>
                                                        <xsl:text>.html</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="$ancient-lang=('grc', 'all')">
                                                            <xsl:value-of select="translate(translate(., $betacode, $unicode),$lowercase, $uppercase)"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="."/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>

                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>


                                    <!-- grouping is typically done on the field named after the index,
                                        but sometimes it needs other fields. The switch is handled with XPath in @group-by -->
                                    <!-- These are the fields grouped in a non-standard manner: -->
                                    <xsl:choose>
                                        <!-- Tests if the index element is an array or a string
                                                Some solr fields are multivalued, documents can belong to more than one category
                                        -->
                                        <xsl:when test="//doc/str[@name=$index]">
                                            <xsl:for-each-group select="//doc" group-by="translate(normalize-space(str[@name=$index]), $lowercase, $transformation)">
                                                <xsl:call-template name="index_group" />
                                            </xsl:for-each-group>
                                        </xsl:when>
                                        <xsl:when test="//doc/arr[@name=concat($index, '-', $lang)]">
                                            <xsl:for-each-group select="//doc" group-by="arr[@name=concat($index, '-', $lang)]/str">
                                                <xsl:call-template name="index_group" />
                                            </xsl:for-each-group>
                                        </xsl:when>
                                        <!-- There is no default, if nothing is displayed something is very wrong in the indices -->
                                    </xsl:choose>

                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:otherwise>

        </xsl:choose>





    </xsl:template>


    <xsl:template name="link2inscription">
        <a href="/{str[@name='file']}.html">
            <xsl:if test="str[@name='sup']">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:if test="str[@name='cert']">
                <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:call-template name="formatInscrNum">
                <xsl:with-param name="num" select="str[@name='tei-id']"/>
            </xsl:call-template>
            <xsl:if test="arr[@name='divloc']">
                <xsl:for-each select="arr[@name='divloc']/str">
                    <xsl:if test="not(preceding-sibling::str)"><xsl:text>.</xsl:text></xsl:if>
                    <xsl:value-of select="translate(., '-', '.')"/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(str[@name='line']='0')">
                <xsl:choose>
                    <xsl:when test="not(str[@name='line'])"/>
                    <xsl:when test="arr[@name='divloc']"/>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="str[@name='line']"/>
            </xsl:if>
            <xsl:if test="str[@name='sup']">
                <xsl:text>]</xsl:text>
            </xsl:if>
        </a>
    </xsl:template>

    <xsl:template name="index_group">
        <!-- Only sort for death index (Solr does not handle ISO-duration -->
        <xsl:sort select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'Y')) else ()"/>
        <xsl:sort select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'M')) else ()"/>
        <xsl:sort select="if ($index='death') then number(iospe:sort-dur(current-grouping-key(), 'D')) else ()"/>
        
        <xsl:variable name="display_key">
            <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))"/><xsl:value-of select="substring(replace(current-grouping-key(), '_' , ' '), 2)"/>
        </xsl:variable>
        
        <p>
            <span class="head">
                <xsl:choose>
                    <xsl:when test="str[@name='num-value']">
                        <xsl:value-of select="$display_key"/>
                        <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-value']"/><xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="str[@name='num-atleast'] and str[@name='num-atmost']">
                        <xsl:value-of select="$display_key"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="str[@name='num-atleast']"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="str[@name='num-atmost']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="str[@name='num-atleast']">
                        <xsl:value-of select="$display_key"/>
                        <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-atleast']"/><xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="str[@name='num-atmost']">
                        <xsl:value-of select="$display_key"/>
                        <xsl:text> (</xsl:text><xsl:value-of select="str[@name='num-atmost']"/><xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$index='death'">
                        <xsl:variable name="y" select="iospe:sort-dur(current-grouping-key(), 'Y')"/>
                        <xsl:variable name="m" select="iospe:sort-dur(current-grouping-key(), 'M')"/>
                        <xsl:variable name="d" select="iospe:sort-dur(current-grouping-key(), 'D')"/>
                        <xsl:if test="$y!=''">
                            <xsl:value-of select="$y"/>
                            <xsl:text> year</xsl:text>
                            <xsl:if test="$y &gt; 1">s</xsl:if>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:if test="$m!=''">
                            <xsl:value-of select="$m"/>
                            <xsl:text> month</xsl:text>
                            <xsl:if test="$m &gt; 1">s</xsl:if>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:if test="$d!=''">
                            <xsl:value-of select="$m"/>
                            <xsl:text> day</xsl:text>
                            <xsl:if test="$m &gt; 1">s</xsl:if>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="normalize-space(current-grouping-key())">
                                <xsl:value-of select="$display_key"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Empty</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <ul class="oneline">
                <xsl:for-each select="current-group()">
                    <li>
                        <xsl:call-template name="link2inscription"/>
                    </li>
                </xsl:for-each>
            </ul>
        </p>
    </xsl:template>
    
    
    <xsl:template name="person">
        <dt id="{@xml:id}">
            <xsl:value-of select="tei:persName[@xml:lang=$lang]"/>
        </dt>
        <dd>
            <ul class="multiline">
                <li>
                    <xsl:for-each select="tei:persName[@xml:lang!='en'][@xml:lang!='ru']">
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </li>
                <li>
                    <xsl:if test="tei:floruit[tei:seg[@xml:lang=$lang]]">
                        <xsl:value-of select="if ($lang='en') then 'Attested: ' else 'Идентифицированный: '"/>
                        <xsl:value-of select="tei:floruit/tei:seg[@xml:lang=$lang]"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </li>
                <li>
                    <xsl:if test="tei:occupation">
                        <xsl:value-of select="tei:occupation"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </li>
                <li>
                    <xsl:for-each select="//persons/descendant::tei:relation[substring-after(@active, '#')=current()/@xml:id]">
                        <xsl:choose>
                            <xsl:when test="@name = 'father'">
                                <xsl:value-of select="if ($lang='en') then 'father of ' else 'отец имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'son'">
                                <xsl:value-of select="if ($lang='en') then 'son of ' else 'сын имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'mother'">
                                <xsl:value-of select="if ($lang='en') then 'mother of ' else 'мать имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'daughter'">
                                <xsl:value-of select="if ($lang='en') then 'daughter of ' else 'дочь имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'brother'">
                                <xsl:value-of select="if ($lang='en') then 'brother of ' else 'брат имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'sister'">
                                <xsl:value-of select="if ($lang='en') then 'sister of ' else 'сестра имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'related'">
                                <xsl:value-of select="if ($lang='en') then 'related to ' else 'родственник имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'fiancé'">
                                <xsl:value-of select="if ($lang='en') then 'fiancé of ' else 'жених той-то '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'fiancée'">
                                <xsl:value-of select="if ($lang='en') then 'fiancée of ' else 'невеста имярек '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'husband'">
                                <xsl:value-of select="if ($lang='en') then 'husband of ' else 'муж той-то '"/>
                            </xsl:when>
                            <xsl:when test="@name = 'wife'">
                                <xsl:value-of select="if ($lang='en') then 'wife of ' else 'жена имярек '"/>
                            </xsl:when>
                        </xsl:choose>
                        
                        <xsl:variable name="passives" select="tokenize(substring-after(@passive, '#'), ' #')" as="xs:sequence"/>
                        
                        <xsl:for-each select="//persons/descendant::tei:person[@xml:id=$passives]">
                            <a href="#{@xml:id}"><xsl:value-of select="tei:persName[@xml:lang=$lang]"/></a>
                            <xsl:if test="following::tei:person[@xml:id=$passives]">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        
                        <xsl:if test="following::tei:relation[@active=current()/@active]">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                        
                    </xsl:for-each>
                </li>
                <li><xsl:for-each select="//result/doc[substring-after(str[@name='persName-ref'], '#') = current()/@xml:id]">
                    <xsl:call-template name="link2inscription"/>
                </xsl:for-each></li>
            </ul>            
        </dd>        
    </xsl:template>
    
    <xsl:template name="sort-option">
        <xsl:value-of select="if ($lang='en') then 'Sort by: ' else 'Сортировать: '"/>
        <a href="?sort=date">
            <xsl:attribute name="class">
                <xsl:text>sort-option</xsl:text>
                <xsl:if test="$sort = 'date'">
                    <xsl:text> sort-selected</xsl:text>
                </xsl:if>
            </xsl:attribute>
            
            <xsl:value-of select="if ($lang='en') then 'Date' else 'дате'"/></a> 
        <xsl:text> </xsl:text>
        <a href="?sort=name">
            <xsl:attribute name="class">
                <xsl:text>sort-option</xsl:text>
                <xsl:if test="$sort = 'name' or $sort = ''">
                    <xsl:text> sort-selected</xsl:text>
                </xsl:if>
            </xsl:attribute>            
            
            <xsl:value-of select="if ($lang='en') then 'Name' else 'инеми'"/></a>
    </xsl:template>

</xsl:stylesheet>
