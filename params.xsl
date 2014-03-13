<?xml version="1.0" encoding="utf-8"?>

<!-- ================================================================
     This stylesheet contain user defined parameteres used to configure the
     nisp2aris-p3.xsl stylesheet.

     ================================================================

     Copyright (c) 2013, Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>


<!-- What standard and profile attributes should be displayed -->

<xsl:param name="show.nisp.id" select="1"/>
<xsl:param name="show.nisp.orgid" select="1"/>
<xsl:param name="show.nisp.pubnum" select="1"/>
<xsl:param name="show.nisp.title" select="1"/>
<xsl:param name="show.nisp.date" select="1"/>
<xsl:param name="show.nisp.version" select="1"/>
<xsl:param name="show.nisp.applicability" select="1"/>
<xsl:param name="show.nisp.status" select="1"/>
<xsl:param name="show.nisp.uri" select="1"/>

<!-- Use assignments -->

<xsl:param name="use.assignment" select="0"/>

<!-- Use multiple language parameter -->

<xsl:param name="use.secondary.language" select="1"/>

<!-- By default we use US English as primary and Danish as secondary language -->

<xsl:param name="primary.lang.locale" select="'1033'"/>  <!-- LCID: us-en -->
<xsl:param name="primary.lang.codepage" select="'1252'"/>  <!-- Windows-1252 Latin Codepage -->
<xsl:param name="primary.lang.languageName" select="'English'"/>

<xsl:param name="secondary.alt.lang.locale" select="'1030'"/>  <!-- LCID: da -->
<xsl:param name="secondary.alt.lang.codepage" select="'1252'"/> <!-- Windows-1252 Latin Codepage -->
<xsl:param name="secondary.alt.lang.languageName" select="'Danish'"/>


<!-- Name of NISP to ARIS attribute mapping -->

<xsl:param name="nisp.attributes.file" select="'nisp-attributes-map.xml'"/>




</xsl:stylesheet>
