<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitle">
    <!-- KFL - Inscriptions by Date gets title from tocs.xsl, all the rest get the title here -->
    <xsl:choose>
      <xsl:when test="$index='home'">
        <i18n:text>Indices</i18n:text>
      </xsl:when>
      <xsl:when test="$index='words' and //str[@name='lang']='lat'">
        <i18n:text>Latin Words</i18n:text>
      </xsl:when>
      <xsl:when test="$index='words' and //str[@name='lang']='grc'">
        <i18n:text>Greek Words</i18n:text>
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='lat'">
        <i18n:text>Fragments of Text in Latin</i18n:text>
      </xsl:when>
      <xsl:when test="$index='fragments' and //str[@name='lang']='grc'">
        <i18n:text>Fragments of Text in Greek</i18n:text>
      </xsl:when>
      <xsl:when test="$index='attested' and //str[@name='persName-type']='attested'">
        <i18n:text>Personal Names</i18n:text>
      </xsl:when>
      <xsl:when test="$index='ruler' and //str[@name='persName-type']='ruler'">
        <i18n:text>Rulers of Rome, Byzantium or Bosporan Kingdoms</i18n:text>
      </xsl:when>
      <xsl:when test="$index='divine' and //str[@name='persName-type']='divine'">
        <i18n:text>Divine, religious or mythic figures</i18n:text>
      </xsl:when>
      <xsl:when test="$index='places'">
        <i18n:text>Mentioned places</i18n:text>
      </xsl:when>
      <xsl:when test="$index='months'">
        <i18n:text>Months</i18n:text>
      </xsl:when>
      <xsl:when test="$index='symbols'">
        <i18n:text>Symbols</i18n:text>
      </xsl:when>
      <xsl:when test="$index='numerals'">
        <i18n:text>Numerals</i18n:text>
      </xsl:when>
      <xsl:when test="$index='ligatures'">
        <i18n:text>Ligatured characters</i18n:text>
      </xsl:when>
      <xsl:when test="$index='abbr'">
        <i18n:text>Abbreviations</i18n:text>
      </xsl:when>
      <xsl:when test="$index='death'">
        <i18n:text>Age at Death</i18n:text>
      </xsl:when>
      <xsl:when test="$index=concat('findspot-',$lang)">
        <i18n:text>Find Places</i18n:text>
      </xsl:when>
      <xsl:when test="$index='persons'">
        <i18n:text>Attested Persons</i18n:text>
      </xsl:when>
      <xsl:when test="$index='attested'">
        <i18n:text>Personal names</i18n:text>
      </xsl:when>
      <xsl:when test="$index='monument-type'">
        <i18n:text>Inscriptions by Monument Type</i18n:text>
      </xsl:when>
      <xsl:when test="$index='document-type'">
        <i18n:text>Inscriptions by Category of Text</i18n:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Home -->
  <xsl:template name="indexHome">

    <h4>
      <i18n:text>Words and Names</i18n:text>
    </h4>
    <ul class="no-bullet">
      <li>
        <xsl:choose>
          <xsl:when test="//words-grc//result[@numFound &gt; 0]">
            <a href="words/grc/{//words-grc//str[@name='first-letter']}.html">
              <i18n:text>Greek words</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Greek words</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//attested//result[@numFound &gt; 0]">
            <a href="names/{//attested//str[@name='first-letter']}.html">
              <i18n:text>Personal names</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Personal names</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//fragments-grc//result[@numFound &gt; 0]">
            <a href="fragments/grc/{//fragments-grc//str[@name='first-letter']}.html">
              <i18n:text>Fragments of text in Greek</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Fragments of text in Greek</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </ul>

    <h4>
      <i18n:text>Prosopography and Geography</i18n:text>
    </h4>
    <ul class="no-bullet">
      <li>
        <a href="person/other.html">
          <i18n:text>Attested Persons</i18n:text>
        </a>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//ruler//result[@numFound &gt; 0]">
            <a href="person/ruler.html">
              <i18n:text>Rulers of Rome, Byzantium or Bosporan kingdoms</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Rulers of Rome, Byzantium or Bosporan kingdoms</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//divine//result[@numFound &gt; 0]">
            <a href="person/divine.html">
              <i18n:text>Divine, religious or mythic figures</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Divine, religious or mythic figures</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//places//result[@numFound &gt; 0]">
            <a href="places.html">
              <i18n:text>Mentioned places</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Mentioned places</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </ul>

    <h4>
      <i18n:text>Other Features</i18n:text>
    </h4>
    <ul class="no-bullet">
      <li>
        <xsl:choose>
          <xsl:when test="//abbr//result[@numFound &gt; 0]">
            <a href="abbr.html">
              <i18n:text>Abbreviations</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Abbreviations</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//symbols//result[@numFound &gt; 0]">
            <a href="symbols.html">
              <i18n:text>Symbols</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Symbols</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//numerals//result[@numFound &gt; 0]">
            <a href="numerals.html">
              <i18n:text>Numerals</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Numerals</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//months//result[@numFound &gt; 0]">
            <a href="months.html">
              <i18n:text>Months</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Months</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//death//result[@numFound &gt; 0]">
            <a href="death.html">
              <i18n:text>Age at death</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Age at death</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </ul>

    <h4>
      <i18n:text>Inscriptions</i18n:text>
    </h4>
    <ul class="no-bullet">
      <li>
        <a href="date/dated.html">
          <i18n:text>By date</i18n:text>
        </a>
      </li>
      <li>
        <a href="document-type.html">
          <i18n:text>By category of text</i18n:text>
        </a>
      </li>
      <li>
        <a href="monument-type.html">
          <i18n:text>By monument type</i18n:text>
        </a>
      </li>
      <li>
        <a href="findspot.html">
          <i18n:text>By find place</i18n:text>
        </a>
      </li>
    </ul>
  </xsl:template>

  <!-- Generate Index -->
  <xsl:template name="generateIndex">
    <xsl:text>Proper Index</xsl:text>
  </xsl:template>

</xsl:stylesheet>
