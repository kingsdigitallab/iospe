<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:function as="xs:string" name="local:sort_id">
    <xsl:param name="tei_id"/>

    <!-- corpus number -->
    <xsl:variable name="b_sort" as="xs:integer">
      <xsl:analyze-string select="$tei_id" regex="\d\.\d{{1,3}}">
        <xsl:matching-substring>
          <xsl:value-of select="concat('0', substring-before(., '.'))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="0"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <!-- inscription number -->
    <xsl:variable name="i_sort" as="xs:integer">
      <xsl:analyze-string select="$tei_id" regex="\d\.\d{{1,3}}">
        <xsl:matching-substring>
          <xsl:value-of select="concat('0', substring-after(., '.'))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="0"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:value-of select="(10000 * $b_sort) + $i_sort"/>

  </xsl:function>


  <xsl:function as="xs:string" name="local:clean">
    <xsl:param name="value"/>

    <xsl:value-of select="normalize-space(replace($value, '\(\?\)', ''))"/>
  </xsl:function>

  <xsl:function as="xs:integer" name="local:get-year-from-date">
    <xsl:param name="date"/>

    <xsl:variable name="year">
      <xsl:analyze-string regex="(-?)(\d{{4}})(-\d{{2}})?(-\d{{2}})?" select="$date">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
          <xsl:value-of select="regex-group(2)"/>
        </xsl:matching-substring>
        <xsl:fallback>
          <xsl:value-of select="."/>
        </xsl:fallback>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:value-of select="$year"/>
  </xsl:function>

  <xsl:function as="xs:string" name="local:replace-spaces">
    <xsl:param name="value"/>

    <xsl:value-of select="normalize-space(replace($value, '\s', '_'))"/>
  </xsl:function>

</xsl:stylesheet>
