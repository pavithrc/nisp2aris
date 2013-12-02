<?xml version="1.0"?> 

<!-- ============================================================
     This stylesheet is used to copy the NISP standards database,
     but filter out all those standards and profiles, which are 
     not through a select statement marked as mandatory, emerging
     or fading.

     N.B. If we want to import all standards, we can ignore this
     step.

     Input:  The NISP Standard database
     Output: A NISP DTD compliant database
     ============================================================

     Copyright (c) 2013, Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output saxon:next-in-chain="nisp2aris-p2.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:preserve-space elements="standards records lists community-of-interest community"/>



<!-- Add only standards and profiles, which are directly or indirectly refered to with a select element -->

<xsl:template match="records">
  <records>
    <xsl:apply-templates select="/standards/lists//select" mode="copyrecord"/>
  </records>
</xsl:template>


<!-- Identify all standards/profiles refered to from the select element -->

<xsl:template match="select" mode="copyrecord">
  <xsl:variable name="sid" select="@id"/>
  <xsl:apply-templates select="/standards/records/standard[@id=$sid]" mode="copyrecord"/>
  <xsl:apply-templates select="/standards/records/profile[@id=$sid]" mode="copyrecord"/>
</xsl:template>


<!-- Copy a standard/profile and search for standards/profiles
     referred to - through the refstandard element -->

<xsl:template match="standard|profile" mode="copyrecord">
  <xsl:copy-of select="."/>
  <xsl:call-template name="blankline"/>
  <xsl:apply-templates select=".//refstandard" mode="copyrecord"/>
</xsl:template>

<!-- Identify all standards/profiles refered to from this element -->

<xsl:template match="refstandard" mode="copyrecord">
  <xsl:variable name="refid" select="@refid"/>
  <xsl:apply-templates select="/standards/records/standard[@id=$refid]" mode="copyrecord"/>
  <xsl:apply-templates select="/standards/records/profile[@id=$refid]" mode="copyrecord"/>
</xsl:template>

<!-- Put a blank line after all standards/profiles -->

<xsl:template name="blankline">
  <xsl:text>

  </xsl:text>
</xsl:template>

<!-- Copy the rest -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
