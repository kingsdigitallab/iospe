<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../epidoc-views/common.xsl"/>


  <xsl:function as="xs:string" name="local:sort_id">
    <xsl:param name="tei_id"/>

    <xsl:variable name="sort-num">
      <xsl:choose>
        <xsl:when test="contains($tei_id, '.')">
          <xsl:analyze-string select="normalize-space($tei_id)"
            regex="([0-9]{{1,2}})\.([0-9]{{1,4}})([a-z]?)">
            <xsl:matching-substring>
              <!-- corpus number -->
              <xsl:variable name="b_sort" as="xs:integer">
                <xsl:value-of select="regex-group(1)"/>
              </xsl:variable>

              <!-- inscription number -->
              <xsl:variable name="i_sort" as="xs:integer">
                <xsl:value-of select="regex-group(2)"/>
              </xsl:variable>

              <!-- inscription letter index 0 if nothing, 1-26 if a-z-->
              <xsl:variable name="s_sort" as="xs:integer">
                <xsl:value-of
                  select="
                    if (regex-group(3))
                    then
                      string-length(substring-before($lowercase, regex-group(3))) + 1
                    else
                      0"
                />
              </xsl:variable>
              <xsl:value-of select="((($b_sort * 10000) + $i_sort) * 100) + $s_sort"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:value-of select="0"/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:when>
        <xsl:when test="starts-with($tei_id, 'PE')">
          <xsl:value-of select="substring-after($tei_id, 'PE')"/>
        </xsl:when>
        <xsl:otherwise>foo</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$sort-num"/>

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
