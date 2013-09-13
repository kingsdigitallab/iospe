<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitle">
    <!-- KFL - Inscriptions by Date gets title from tocs.xsl, all the rest get the title here -->
    <xsl:choose>
      <xsl:when test="$index='home'">
        <xsl:value-of select="if ($lang='en') then 'Indices' else 'Указатели'"/>
      </xsl:when>
      <xsl:when test="$index='words' and //str[@name='lang']='lat'">
        <xsl:value-of select="if ($lang='en') then 'Latin Words' else 'Латинские слова'"/>
      </xsl:when>
      <xsl:when test="$index='words' and //str[@name='lang']='grc'">
        <xsl:value-of select="if ($lang='en') then 'Greek Words' else 'Греческие слова'"/>
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='lat'">
        <xsl:value-of
          select="if ($lang='en') then 'Fragments of Text in Latin' else 'Фрагменты текстов на латинском языке'"
        />
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='grc'">
        <xsl:value-of
          select="if ($lang='en') then 'Fragments of Text in Greek' else 'Фрагменты текстов на греческом языке'"
        />
      </xsl:when>
      <xsl:when test="$index='attested' and //str[@name='persName-type']='attested'">
        <xsl:value-of select="if ($lang='en') then 'Personal Names' else 'Личные имена'"/>
      </xsl:when>
      <xsl:when test="$index='ruler' and //str[@name='persName-type']='ruler'">
        <xsl:value-of
          select="if ($lang='en') then 'Rulers of Rome, Byzantium or Bosporan Kingdoms' else 'Правители Рима, Византии или Боспорского царства'"
        />
      </xsl:when>
      <xsl:when test="$index='divine' and //str[@name='persName-type']='divine'">
        <xsl:value-of
          select="if ($lang='en') then 'Divine, religious or mythic figures' else 'Божественные, религиозные или мифические личности и персонажи'"
        />
      </xsl:when>
      <xsl:when test="$index='places'">
        <xsl:value-of
          select="if ($lang='en') then 'Mentioned places' else 'Места, упомянутые в надписях'"/>
      </xsl:when>
      <xsl:when test="$index='months'">
        <xsl:value-of select="if ($lang='en') then 'Months' else 'Месяцы'"/>
      </xsl:when>
      <xsl:when test="$index='symbols'">
        <xsl:value-of select="if ($lang='en') then 'Symbols' else 'Символы'"/>
      </xsl:when>
      <xsl:when test="$index='numerals'">
        <xsl:value-of select="if ($lang='en') then 'Numerals' else 'Числа'"/>
      </xsl:when>
      <xsl:when test="$index='ligatures'">
        <xsl:value-of
          select="if ($lang='en') then 'Ligatured characters' else 'RU: Ligatured characters'"/>
      </xsl:when>
      <xsl:when test="$index='abbr'">
        <xsl:value-of select="if ($lang='en') then 'Abbreviations' else 'Аббревиатуры'"/>
      </xsl:when>
      <xsl:when test="$index='death'">
        <xsl:value-of select="if ($lang='en') then 'Age at Death' else 'Возраст в момент смерти'"/>
      </xsl:when>
      <xsl:when test="$index=concat('findspot-',$lang)">
        <xsl:value-of select="if ($lang='en') then 'Find Places' else 'Месту находки'"/>
      </xsl:when>
      <xsl:when test="$index='persons'">
        <xsl:value-of
          select="if ($lang='en') then 'Attested Persons' else 'Идентифицированные лица'"/>
      </xsl:when>
      <xsl:when test="$index='attested'">
        <xsl:value-of select="if ($lang='en') then 'Personal names' else 'Личные имена'"/>
      </xsl:when>
      <xsl:when test="$index='monument-type'">
        <xsl:value-of
          select="if ($lang='en') then 'Inscriptions by Monument Type' else 'Надписи по типу памятника'"
        />
      </xsl:when>
      <xsl:when test="$index='document-type'">
        <xsl:value-of
          select="if ($lang='en') then 'Inscriptions by Category of Text' else 'Надписи по типу документа'"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Home -->
  <xsl:template name="indexHome">

    <ul>
      <i18n:text key="words_and_names"/>
      <li>
        <xsl:choose>
          <xsl:when test="//words-grc//result[@numFound &gt; 0]">
            <a href="words/grc/{//words-grc//str[@name='first-letter']}.html">
              <i18n:text key="greek_words"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text key="greek_words"/>
            <em><i18n:text key="no_results_found"/></em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//attested//result[@numFound &gt; 0]">
            <a href="names/{//attested//str[@name='first-letter']}.html">
              <i18n:text key="personal_names"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text key="personal_names"/><em><i18n:text key="no_results_found"/></em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//fragments-grc//result[@numFound &gt; 0]">
            <a href="fragments/grc/{//fragments-grc//str[@name='first-letter']}.html">
              <i18n:text key="fragments_of_text_in_greek"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text key="fragments_of_text_in_greek"/> <em><i18n:text key="no_results_found"/></em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </ul>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndex">
    <xsl:text>Proper Index</xsl:text>
  </xsl:template>


</xsl:stylesheet>
