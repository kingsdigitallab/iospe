<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://www.cch.kcl.ac.uk/kiln/local/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../epidoc-views/common.xsl"/>


  <xsl:function as="xs:string" name="local:sort_id">
    <!-- input = value of <tei:idno type="filename">
         output = a 12 character string of digits where
         first two digits represent the volume number
         second two represent the fascicle number
         third two represent  the collection number
         next four digits represent the inscription number
         last two digits represent the letter suffix value 
         (which is 00 if no letter suffic present)
         Eg. 5.849a gives string 050000084901
         Eg. 2.1.1.72 gives string 020101007200
    -->
    <xsl:param name="tei_id"/>
    
    <xsl:variable name="sort-num">
      <xsl:choose>
        
        <!-- this WHEN section deals with $tei_id values from volumes 1, 3, and 5 -->
        <!-- expecting, eg. 3.1, 1.75, 5.849a, with potentially 4 digits after period, and possibly a letter suffix -->
        <xsl:when
          test="(contains($tei_id, '.')) and (starts-with($tei_id, '1') or starts-with($tei_id, '3') or starts-with($tei_id, '5'))">
          <xsl:variable name="tokenized_A" select="tokenize(normalize-space($tei_id), '\.')"/>
          
          <!-- volume number: the first digit group -->
          <xsl:variable name="vol_sort_A">
            <xsl:choose>
              <xsl:when test="string-length($tokenized_A[1]) = 1">
                <xsl:value-of select="concat('9', $tokenized_A[1])"/>
              </xsl:when>
              <xsl:when test="string-length($tokenized_A[1]) = 2">
                <xsl:value-of select="$tokenized_A[1]"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <!-- inscription number: the second group, + possible letter suffix -->
          
          <!-- establish a value for the letter suffix (or absence thereof) -->
          <xsl:variable name="last_char_A" select="substring($tokenized_A[2], string-length($tokenized_A[2]), 1)"/>
          <xsl:variable name="let_suff_A" select="if ($last_char_A = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'))
            then true()
            else false()"/>
          <xsl:variable name="let_sort_A">
            <xsl:choose>
              <xsl:when
                test="$last_char_A = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')">
                <xsl:if test="$last_char_A = 'a'">01</xsl:if>
                <xsl:if test="$last_char_A = 'b'">02</xsl:if>
                <xsl:if test="$last_char_A = 'c'">03</xsl:if>
                <xsl:if test="$last_char_A = 'd'">04</xsl:if>
                <xsl:if test="$last_char_A = 'e'">05</xsl:if>
                <xsl:if test="$last_char_A = 'f'">06</xsl:if>
                <xsl:if test="$last_char_A = 'g'">07</xsl:if>
                <xsl:if test="$last_char_A = 'h'">08</xsl:if>
                <xsl:if test="$last_char_A = 'i'">09</xsl:if>
                <xsl:if test="$last_char_A = 'j'">10</xsl:if>
                <xsl:if test="$last_char_A = 'k'">11</xsl:if>
                <xsl:if test="$last_char_A = 'l'">12</xsl:if>
                <xsl:if test="$last_char_A = 'm'">13</xsl:if>
                <xsl:if test="$last_char_A = 'n'">14</xsl:if>
                <xsl:if test="$last_char_A = 'o'">15</xsl:if>
                <xsl:if test="$last_char_A = 'p'">16</xsl:if>
                <xsl:if test="$last_char_A = 'q'">17</xsl:if>
                <xsl:if test="$last_char_A = 'r'">18</xsl:if>
                <xsl:if test="$last_char_A = 's'">19</xsl:if>
                <xsl:if test="$last_char_A = 't'">20</xsl:if>
                <xsl:if test="$last_char_A = 'u'">21</xsl:if>
                <xsl:if test="$last_char_A = 'v'">22</xsl:if>
                <xsl:if test="$last_char_A = 'w'">23</xsl:if>
                <xsl:if test="$last_char_A = 'x'">24</xsl:if>
                <xsl:if test="$last_char_A = 'y'">25</xsl:if>
                <xsl:if test="$last_char_A = 'z'">26</xsl:if>
              </xsl:when>
              <xsl:otherwise>00</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <!-- create the value for the inscription number  -->
          <xsl:variable name="ins_sort_A">
            <!-- create a variable which compensates for the lack of fascicle and collection numbers -->
            <xsl:variable name="fas_coll_default" select="'0000'"/>
            <xsl:choose>
              <xsl:when test="$let_suff_A = true()">
                <!-- there is a letter suffix, so the string we are interested ends at the penultimate char of $tokenized_A[2] -->
                <xsl:variable name="digit_string_A" select="substring-before($tokenized_A[2], $last_char_A)"/>
                <xsl:choose>
                  <xsl:when test="string-length($digit_string_A) = 1">
                    <xsl:value-of select="concat($fas_coll_default, '000', $digit_string_A)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_A) = 2">
                    <xsl:value-of select="concat($fas_coll_default, '00', $digit_string_A)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_A) = 3">
                    <xsl:value-of select="concat($fas_coll_default, '0', $digit_string_A)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_A) = 4">
                    <xsl:value-of select="concat($fas_coll_default, $digit_string_A)"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              
              <xsl:when test="$let_suff_A = false()">
                <!-- there is no letter suffix, so the string we are interested is all of $tokenized_A[2] -->
                <xsl:choose>
                  <xsl:when test="string-length($tokenized_A[2]) = 1">
                    <xsl:value-of select="concat($fas_coll_default, '000', $tokenized_A[2])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_A[2]) = 2">
                    <xsl:value-of select="concat($fas_coll_default, '00', $tokenized_A[2])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_A[2]) = 3">
                    <xsl:value-of select="concat($fas_coll_default, '0', $tokenized_A[2])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_A[2]) = 4">
                    <xsl:value-of select="concat($fas_coll_default, $tokenized_A[2])"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:value-of select="concat($vol_sort_A,$ins_sort_A,$let_sort_A)"/>
       
        </xsl:when>
        
        <!-- this WHEN section deals with $tei_id values from volume 2 -->
        <!-- Volume 2 files include fascicle and collection numbers,
          so expecting four digit groups plus possible letter suffix -->
        <xsl:when test="(contains($tei_id, '.')) and (starts-with($tei_id, '2'))">
          <xsl:variable name="tokenized_B" select="tokenize(normalize-space($tei_id), '\.')"/>
          
          <!-- volume number: the first digit group -->
          <xsl:variable name="vol_sort_B">
            <xsl:choose>
              <xsl:when test="string-length($tokenized_B[1]) = 1">
                <xsl:value-of select="concat('9', $tokenized_B[1])"/>
              </xsl:when>
              <xsl:when test="string-length($tokenized_B[1]) = 2">
                <xsl:value-of select="$tokenized_B[1]"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <!-- fascicle number: the second digit group -->
          <xsl:variable name="fasc_sort_B">
            <xsl:choose>
              <xsl:when test="string-length($tokenized_B[2]) = 1">
                <xsl:value-of select="concat('0', $tokenized_B[2])"/>
              </xsl:when>
              <xsl:when test="string-length($tokenized_B[2]) = 2">
                <xsl:value-of select="$tokenized_B[2]"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <!-- collection number: the third digit group -->
          <xsl:variable name="coll_sort_B">
            <xsl:choose>
              <xsl:when test="string-length($tokenized_B[3]) = 1">
                <xsl:value-of select="concat('0', $tokenized_B[3])"/>
              </xsl:when>
              <xsl:when test="string-length($tokenized_B[3]) = 2">
                <xsl:value-of select="$tokenized_B[3]"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <!-- inscription number: the fourth group, + possible letter suffix -->
          
          <!-- establish a value for the letter suffix (or absence thereof) -->
          <xsl:variable name="last_char_B" select="substring($tokenized_B[4], string-length($tokenized_B[4]), 1)"/>
          <xsl:variable name="let_suff_B" select="if ($last_char_B = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'))
            then true()
            else false()"/>
          <xsl:variable name="let_sort_B">
            <xsl:choose>
              <xsl:when
                test="$last_char_B = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')">
                <xsl:if test="$last_char_B = 'a'">01</xsl:if>
                <xsl:if test="$last_char_B = 'b'">02</xsl:if>
                <xsl:if test="$last_char_B = 'c'">03</xsl:if>
                <xsl:if test="$last_char_B = 'd'">04</xsl:if>
                <xsl:if test="$last_char_B = 'e'">05</xsl:if>
                <xsl:if test="$last_char_B = 'f'">06</xsl:if>
                <xsl:if test="$last_char_B = 'g'">07</xsl:if>
                <xsl:if test="$last_char_B = 'h'">08</xsl:if>
                <xsl:if test="$last_char_B = 'i'">09</xsl:if>
                <xsl:if test="$last_char_B = 'j'">10</xsl:if>
                <xsl:if test="$last_char_B = 'k'">11</xsl:if>
                <xsl:if test="$last_char_B = 'l'">12</xsl:if>
                <xsl:if test="$last_char_B = 'm'">13</xsl:if>
                <xsl:if test="$last_char_B = 'n'">14</xsl:if>
                <xsl:if test="$last_char_B = 'o'">15</xsl:if>
                <xsl:if test="$last_char_B = 'p'">16</xsl:if>
                <xsl:if test="$last_char_B = 'q'">17</xsl:if>
                <xsl:if test="$last_char_B = 'r'">18</xsl:if>
                <xsl:if test="$last_char_B = 's'">19</xsl:if>
                <xsl:if test="$last_char_B = 't'">20</xsl:if>
                <xsl:if test="$last_char_B = 'u'">21</xsl:if>
                <xsl:if test="$last_char_B = 'v'">22</xsl:if>
                <xsl:if test="$last_char_B = 'w'">23</xsl:if>
                <xsl:if test="$last_char_B = 'x'">24</xsl:if>
                <xsl:if test="$last_char_B = 'y'">25</xsl:if>
                <xsl:if test="$last_char_B = 'z'">26</xsl:if>
              </xsl:when>
              <xsl:otherwise>00</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <!-- create the value for the inscription number  -->
          <xsl:variable name="ins_sort_B">
            <xsl:choose>
              <xsl:when test="$let_suff_B = true()">
                <!-- there is a letter suffix, so the string we are interested ends at the penultimate char of $tokenized_B[4] -->
                <xsl:variable name="digit_string_B" select="substring-before($tokenized_B[4], $last_char_B)"/>
                <xsl:choose>
                  <xsl:when test="string-length($digit_string_B) = 1">
                    <xsl:value-of select="concat('000', $digit_string_B)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_B) = 2">
                    <xsl:value-of select="concat('00', $digit_string_B)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_B) = 3">
                    <xsl:value-of select="concat('0', $digit_string_B)"/>
                  </xsl:when>
                  <xsl:when test="string-length($digit_string_B) = 4">
                    <xsl:value-of select="$digit_string_B"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              
              <xsl:when test="$let_suff_B = false()">
                <!-- there is no letter suffix, so the string we are interested is all of $tokenized_B[4] -->
                <xsl:choose>
                  <xsl:when test="string-length($tokenized_B[4]) = 1">
                    <xsl:value-of select="concat('000', $tokenized_B[4])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_B[4]) = 2">
                    <xsl:value-of select="concat('00', $tokenized_B[4])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_B[4]) = 3">
                    <xsl:value-of select="concat('0', $tokenized_B[4])"/>
                  </xsl:when>
                  <xsl:when test="string-length($tokenized_B[4]) = 4">
                    <xsl:value-of select="$tokenized_B[4]"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:value-of select="concat($vol_sort_B,$fasc_sort_B,$coll_sort_B,$ins_sort_B,$let_sort_B)"/>
          
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
