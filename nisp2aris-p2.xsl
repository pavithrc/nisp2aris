<?xml version="1.0"?> 

<!-- ================================================================
     This stylesheet modifies the NISP standard database and creates
     additional elements in order to simplify the transformation from
     NISP to the ARIS Modelling Language (AML).

     The following changes are made:

     1. Merge the sp-list elements into the taxonomy. Spliting these
        two structures make no sence, since XML by design is a
        heiracical structure, and this artificial construct
        significantly complicates writing XSLT stylesheets.

     2. Remove all retired/rejected standards

     3. All coverstandards (i.e. standards which have a refstandard
        descendant) will be embedded in a coverstandard element.

        Reason: As ARIS standards can not have a relation to other
        standards, we need to identify all coverstandards which 
        should be represented by the ARIS protocol element.


     4. Remove duplicate standards

     Input: The NISP Standard database
     Output: 

     ================================================================

     Copyright (c) 2013, Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version="2.0">


<xsl:output indent="yes" saxon:next-in-chain="nisp2aris-p3.xsl"/>



<!-- ====================================
     (1) Merge sp-list into the taxonomy
     ====================================
 -->

<xsl:template match="servicearea|subarea|servicecategory|category|subcategory">
  <xsl:variable name="thisid" select="@id"/>
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:copy-of select="/standards/lists/sp-list[@tref=$thisid]"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="lists"/>



<!-- ==========================================
     (2) Remove all retired/rejected standards
     ==========================================
-->


<xsl:template match="standard[statue/@mode != 'unknown']"/> 



<!-- =================================================================
     (3) Replace standard element with coverstandard, if the standard
         is a coverstandard
     =================================================================
-->

<xsl:template match="standard[descendant::refstandard]">
  <coverstandard>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </coverstandard>
</xsl:template>



<!-- =================================================================
     (4) Remove duplicate standards and profiles
     =================================================================
-->

<xsl:template match="standard[not(@id=preceding-sibling::standard/@id)]" priority="1"/>

<xsl:template match="profile[not(@id=preceding-sibling::profile/@id)]" priority="1"/>


<!-- ===================
       Copy the rest 
     ===================
-->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
