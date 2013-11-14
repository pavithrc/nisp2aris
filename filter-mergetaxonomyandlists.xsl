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

     2. Create connection elements which represents the relationship
        between profile and profiles/standard and between
        "coverstandards" and standards.

     3. All coverstandards (i.e. standards which have a refstandard
        descendant) will be embedded in a coverstandard element.

        Reason: As ARIS standards can not have a relation to other
        standards, we need to identify all coverstandards which 
        should be represented by the ARIS protocol element.

     ================================================================

     Copyright (c) 2013, Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

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


<!-- =================================================================
     (2) Replace standard element with coverstandard, if the standard
         is a coverstandard
     =================================================================
-->

<xsl:template match="standard[descendant::refstandard]">
  <coverstandard>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </coverstandard>
</xsl:template>


<!-- =======================================================
     (3) Copy all standards/profiles and create conntection
         (relation) elements
     =======================================================
-->

<xsl:template match="records">
  <records>
    <xsl:apply-templates/>
    <xsl:apply-templates select=".//refstandard"/>
  </records>
</xsl:template> 

<!-- Create relationship between profiles and profiles/standards -->

<xsl:template match="parts/refstandard">
  <connection from="{@refid}" relation="is-part-of">
    <xsl:attribute name="to">
      <xsl:value-of select="ancestor::profile/@id"/>
    </xsl:attribute>
  </connection>
</xsl:template>

<!-- Create relationship between coverstandards and standards -->

<xsl:template match="substandards/refstandard">
  <connection from="{@refid}" relation="is-sub-standard-of">
    <xsl:attribute name="to">
      <xsl:value-of select="ancestor::standard/@id"/>
    </xsl:attribute>
  </connection>
</xsl:template>

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
