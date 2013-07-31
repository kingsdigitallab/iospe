<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- For the main menu, display only the top level items. -->
  <xsl:template match="/aggregation/div[@type='menu']" mode="main-menu">
    <xsl:apply-templates mode="main-menu" />
  </xsl:template>

  <!-- <xsl:template match="li/ul" mode="main-menu" >
    <xsl:apply-templates mode="main-menu" />
  </xsl:template> -->

  <xsl:template match="li" mode="main-menu">

    <xsl:variable name="hasdropdown">
      <xsl:choose>
        <xsl:when test="count(ul) > 0">has-dropdown</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="isactive">
      <xsl:choose>
        <xsl:when test="@class='active-menu-item'">active</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li class="{$hasdropdown} {$isactive}">
      <xsl:apply-templates mode="main-menu" />
    </li>
  </xsl:template>



  <xsl:template match="li/ul" mode="main-menu">
    <ul class="dropdown">
      <xsl:apply-templates mode="main-menu" />
    </ul>
  </xsl:template>




  <!-- For the local menu, display only the siblings of the active
       item. -->
  <xsl:template match="/aggregation/div[@type='menu']"
                mode="local-menu">
    <ul>
      <xsl:apply-templates
          select=".//ul[li/@class='active-menu-item']/li"
          mode="local-menu" />
    </ul>
  </xsl:template>

  <xsl:template match="li/ul" mode="local-menu" />

  <xsl:template match="@*|node()" mode="main-menu">
    <xsl:copy>
      <xsl:apply-templates mode="main-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|node()" mode="local-menu">
    <xsl:copy>
      <xsl:apply-templates mode="local-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
