<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

  <xsl:param name="index"/>
  <xsl:param name="sort"/>

  <xsl:template match="/"/>

  <!-- set title -->
  <xsl:template name="indexTitleHome">
    <i18n:text>Indices</i18n:text>
  </xsl:template>
  <!-- Home -->
  <xsl:template name="indexHome">

    <h2>
      <i18n:text>Words and Names</i18n:text>
    </h2>
    <ul class="no-bullet">
      <li>
        <xsl:choose>
          <xsl:when test="//words-grc//result[@numFound &gt; 0]">
            <a href="words/grc/{//words-grc//str[@name='first-letter']}{$kiln:url-lang-suffix}.html">
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
          <xsl:when test="//anthroponymic//result[@numFound &gt; 0]">
            <a href="names/{//anthroponymic//str[@name='first-letter']}{$kiln:url-lang-suffix}.html">
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
            <a
              href="fragments/grc/{//fragments-grc//str[@name='first-letter']}{$kiln:url-lang-suffix}.html">
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

    <h2>
      <i18n:text>Prosopography and Geography</i18n:text>
    </h2>
    <ul class="no-bullet">
      <li>
        <xsl:choose>
          <xsl:when test="//person//result[@numFound &gt; 0]">
            <a href="person/letters/A{$kiln:url-lang-suffix}.html">
              <i18n:text>Attested Persons</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Attested Persons</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//ruler//result[@numFound &gt; 0]">
            <a href="person/ruler{$kiln:url-lang-suffix}.html">
              <i18n:text>Rulers</i18n:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <i18n:text>Rulers</i18n:text>
            <em>
              <i18n:text>(no results found)</i18n:text>
            </em>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        <xsl:choose>
          <xsl:when test="//divine//result[@numFound &gt; 0]">
            <a href="person/divine{$kiln:url-lang-suffix}.html">
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
            <a href="places{$kiln:url-lang-suffix}.html">
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

    <h2>
      <i18n:text>Other Features</i18n:text>
    </h2>
    <ul class="no-bullet">
      <li>
        <xsl:choose>
          <xsl:when test="//abbr//result[@numFound &gt; 0]">
            <a href="abbr{$kiln:url-lang-suffix}.html">
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
            <a href="symbols{$kiln:url-lang-suffix}.html">
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
            <a href="numerals{$kiln:url-lang-suffix}.html">
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
            <a href="months{$kiln:url-lang-suffix}.html">
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
      <!--<li>
        <xsl:choose>
          <xsl:when test="//death//result[@numFound &gt; 0]">
            <a href="death{$kiln:url-lang-suffix}.html">
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
      </li>-->
    </ul>

    <h2>
      <i18n:text>Inscriptions</i18n:text>
    </h2>
    <ul class="no-bullet">
      <li>
        <a href="date/dated{$kiln:url-lang-suffix}.html">
          <i18n:text>By date</i18n:text>
        </a>
      </li>
      <li>
        <a href="document-type{$kiln:url-lang-suffix}.html">
          <i18n:text>By category of text</i18n:text>
        </a>
      </li>
      <li>
        <a href="monument-type{$kiln:url-lang-suffix}.html">
          <i18n:text>By monument type</i18n:text>
        </a>
      </li>
      <li>
        <a href="findspot{$kiln:url-lang-suffix}.html">
          <i18n:text>By find place</i18n:text>
        </a>
      </li>
    </ul>
  </xsl:template>

</xsl:stylesheet>
