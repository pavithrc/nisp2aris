<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                extension-element-prefixes="date"
                version='2.0'
                exclude-result-prefixes="date xs">

<xsl:output indent="yes" doctype-system="ARIS-Export.dtd"/>



<!-- What standard and profile attributes should be displayed -->

<xsl:param name="show.nisp.id" select="1"/>
<xsl:param name="show.nisp.orgid" select="1"/>
<xsl:param name="show.nisp.pubnum" select="1"/>
<xsl:param name="show.nisp.title" select="1"/>
<xsl:param name="show.nisp.date" select="0"/>
<xsl:param name="show.nisp.version" select="1"/>
<xsl:param name="show.nisp.applicability" select="1"/>
<xsl:param name="show.nisp.status" select="1"/>


<!-- Use multiple language parameter -->

<xsl:param name="use.secondary.language" select="1"/>

<!-- By default we use US English as primary and Danish as secondary language -->

<xsl:param name="primary.lang.locale" select="'1033'"/>  <!-- LCID: us-en -->
<xsl:param name="primary.lang.codepage" select="'1252'"/>  <!-- Windows-1252 Latin Codepage -->
<xsl:param name="primary.lang.languageName" select="'English'"/>

<xsl:param name="secondary.alt.lang.locale" select="'1030'"/>  <!-- LCID: da -->
<xsl:param name="secondary.alt.lang.codepage" select="'1252'"/> <!-- Windows-1252 Latin Codepage -->
<xsl:param name="secondary.alt.lang.languageName" select="'Danish'"/>


<!-- NISP to ARIS attribute mapping -->

<xsl:param name="nisp.attributes.file" select="'nisp-attributes-map.xml'"/>

<xsl:param name="nisp.attributes.map" select="document($nisp.attributes.file)"/>


<xsl:variable name="now" select="translate(xs:string(current-dateTime()), ':', '.')"/>

<xsl:variable name="dt" select="substring($now, 1, 16)"/>


<xsl:template match="standards">
  <AML>
    <Header-Info ArisExeVersion="71"/>
    <Language LocaleId="{$primary.lang.locale}" Codepage="{$primary.lang.codepage}">
      <LanguageName><xsl:value-of select="$primary.lang.languageName"/></LanguageName>
      <LogFont FaceName="Arial" Height="-13" Width="0" Escapement="0" Orientation="0"
               Weight="400" Italic="NO" Underline="NO" StrikeOut="NO" CharSet="0"
               OutPrecision="3" ClipPrecision="2" Quality="1" PitchAndFamily="0"
               Color="0"/>      
    </Language>
    <xsl:if test="$use.secondary.language = 1">
      <Language LocaleId="{$secondary.alt.lang.locale}" Codepage="{$secondary.alt.lang.codepage}">
        <LanguageName><xsl:value-of select="$secondary.alt.lang.languageName"/></LanguageName>
        <LogFont FaceName="Arial" Height="-13" Width="0" Escapement="0" Orientation="0"
                 Weight="400" Italic="NO" Underline="NO" StrikeOut="NO" CharSet="0"
                 OutPrecision="3" ClipPrecision="2" Quality="1" PitchAndFamily="0"
                 Color="0"/>      
      </Language>
    </xsl:if>
    <Group Group.ID="Group.Root">
      <Group Group.ID="Group.import-{$dt}">
        <xsl:call-template name="create.AttrDef">
          <xsl:with-param name="type" select="'AT_NAME'"/>
          <xsl:with-param name="value" select="concat('NISP Import ', $dt)"/>
        </xsl:call-template>
        <Group Group.ID="Group.artifacts-{$dt}">
          <xsl:call-template name="create.AttrDef">
            <xsl:with-param name="type" select="'AT_NAME'"/>
            <xsl:with-param name="value" select="'Artifacts'"/>
          </xsl:call-template>
          <xsl:apply-templates select="records/*"/>
        </Group>  
        <Group Group.ID="Group.taxonomy-{$dt}">
          <xsl:call-template name="create.AttrDef">
            <xsl:with-param name="type" select="'AT_NAME'"/>
            <xsl:with-param name="value" select="'Taxonomy'"/>
          </xsl:call-template>
          <xsl:apply-templates select="taxonomy/servicearea"/>
        </Group>  
        <Group Group.ID="Group.relations-{$dt}">
          <xsl:call-template name="create.AttrDef">
            <xsl:with-param name="type" select="'AT_NAME'"/>
            <xsl:with-param name="value" select="'Relations'"/>
          </xsl:call-template>
          <xsl:apply-templates select="coverstandard" mode="relations"/>
          <xsl:apply-templates select="profile" mode="relations"/>
        </Group>
      </Group>
    </Group>
  </AML>
</xsl:template>


<xsl:template match="standard">
  <ObjDef TypeNum="OT_NW_PROT" SymbolNum="ST_STANDARD">
    <xsl:attribute name="ObjDef.ID">
      <xsl:text>ObjDef.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <GUID><xsl:value-of select="uuid"/></GUID>
    <xsl:call-template name="create.AttrDef">
      <xsl:with-param name="type" select="'AT_NAME'"/>
      <xsl:with-param name="value" select="@tag"/>
    </xsl:call-template>
    <xsl:call-template  name="create.AttrDef">
      <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='type']/@aris.type"/>
      <xsl:with-param name="value" select="'S'"/>
    </xsl:call-template>
    <xsl:if test="$show.nisp.id = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='id']/@aris.type"/>
        <xsl:with-param name="value" select="@id"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.orgid = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='orgid']/@aris.type"/>
        <xsl:with-param name="value" select="document/@orgid"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.pubnum = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='pubnum']/@aris.type"/>
        <xsl:with-param name="value" select="document/@pubnum"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.title = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_NAME_FULL'"/>
        <xsl:with-param name="value" select="document/@title"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.date = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='date']/@aris.type"/>
        <xsl:with-param name="value" select="document/@date"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="($show.nisp.version = 1) and (document/@version != '')">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='version']/@aris.type"/>
        <xsl:with-param name="value" select="document/@version"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.applicability = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_DESC'"/>
        <xsl:with-param name="value" select="applicability"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.status = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='status']/@aris.type"/>
        <xsl:with-param name="value" select="status/@mode"/>
      </xsl:call-template>
    </xsl:if>
  </ObjDef>
</xsl:template>


<xsl:template match="coverstandard">
  <ObjDef TypeNum="OT_NW_PROT" SymbolNum="ST_STANDARD">
    <xsl:attribute name="ObjDef.ID">
      <xsl:text>ObjDef.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:if test="$use.assignment =1">
    </xsl:if>
    <GUID><xsl:value-of select="uuid"/></GUID>
    <xsl:call-template name="create.AttrDef">
      <xsl:with-param name="type" select="'AT_NAME'"/>
      <xsl:with-param name="value" select="concat(@tag, ' (CS)')"/>
    </xsl:call-template>
    <xsl:call-template  name="create.AttrDef">
      <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='type']/@aris.type"/>
      <xsl:with-param name="value" select="'CS'"/>
    </xsl:call-template>
    <xsl:if test="$show.nisp.id = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='id']/@aris.type"/>
        <xsl:with-param name="value" select="@id"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.orgid = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='orgid']/@aris.type"/>
        <xsl:with-param name="value" select="document/@orgid"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.pubnum = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='pubnum']/@aris.type"/>
        <xsl:with-param name="value" select="document/@pubnum"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.title = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_NAME_FULL'"/>
        <xsl:with-param name="value" select="document/@title"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.date = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='date']/@aris.type"/>
        <xsl:with-param name="value" select="document/@date"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="($show.nisp.version = 1) and (document/@version != '')">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='version']/@aris.type"/>
        <xsl:with-param name="value" select="document/@version"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.applicability = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_DESC'"/>
        <xsl:with-param name="value" select="applicability"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.status = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='status']/@aris.type"/>
        <xsl:with-param name="value" select="status/@mode"/>
      </xsl:call-template>
    </xsl:if>
  </ObjDef>
</xsl:template>


<xsl:template match="profile">
  <ObjDef TypeNum="OT_NW_PROT" SymbolNum="ST_STANDARD">
    <xsl:attribute name="ObjDef.ID">
      <xsl:text>ObjDef.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <GUID><xsl:value-of select="uuid"/></GUID>
    <xsl:call-template name="create.AttrDef">
      <xsl:with-param name="type" select="'AT_NAME'"/>
      <xsl:with-param name="value" select="concat(@tag, ' (P)')"/>
    </xsl:call-template>
    <xsl:call-template  name="create.AttrDef">
      <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='type']/@aris.type"/>
      <xsl:with-param name="value" select="'P'"/>
    </xsl:call-template>
    <xsl:if test="$show.nisp.id = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='id']/@aris.type"/>
        <xsl:with-param name="value" select="@id"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.orgid = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='orgid']/@aris.type"/>
        <xsl:with-param name="value" select="document/@orgid"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.pubnum = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='pubnum']/@aris.type"/>
        <xsl:with-param name="value" select="document/@pubnum"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.title = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_NAME_FULL'"/>
        <xsl:with-param name="value" select="document/@title"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.date = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='date']/@aris.type"/>
        <xsl:with-param name="value" select="document/@date"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="($show.nisp.version = 1) and (document/@version != '')">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='version']/@aris.type"/>
        <xsl:with-param name="value" select="document/@version"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.applicability = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="'AT_DESC'"/>
        <xsl:with-param name="value" select="applicability"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$show.nisp.status = 1">
      <xsl:call-template name="create.AttrDef">
        <xsl:with-param name="type" select="$nisp.attributes.map/nisp-attributes/nkey[@nisp.attribute='status']/@aris.type"/>
        <xsl:with-param name="value" select="status/@mode"/>
      </xsl:call-template>
    </xsl:if>
  </ObjDef>
</xsl:template>


<xsl:template match="servicearea|subarea|servicecategory|category|subcategory|node">
  <Group>
    <xsl:attribute name="Group.ID">
      <xsl:text>Group.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:call-template name="create.AttrDef">
      <xsl:with-param name="type" select="'AT_NAME'"/>
      <xsl:with-param name="value" select="@title"/>
    </xsl:call-template>
    <xsl:if test="count(sp-list) != 0">
      <Model Model.Type="MT_DEFENSE" AttrHandling="BREAKATTR" CxnMode="ONLYVERTICAL" GridUse="YES"
      			GridSize="50" Scale="100" PrintScale="100" BackColor="16777215"
			CurveRadius="0" ArcRadius="0"  LastUpdated="06:57:03.000;11/06/2013">
        <xsl:attribute name="Model.ID">
          <xsl:text>Model.</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <Flag>4c0</Flag>
        <TypeGUID>f4e31b30-3378-11de-7dee-000c29c116d3</TypeGUID>
        <TemplateGUID>2ed57d10-68c8-11d7-5d85-000bcd25c95f</TemplateGUID>
        <Lane Lane.Type="LT_DEFAULT" Orientation="VERTICAL" StartBorder="0" EndBorder="50000">
          <Pen Color="0" Style="0" Width="0"/>
          <Brush Color="7f7f7f" Color2="0" BrushType="SOLID"/>
          <xsl:call-template name="create.AttrDef">
            <xsl:with-param name="type" select="'AT_NAME'"/>
            <xsl:with-param name="value" select="'.'"/>
          </xsl:call-template>
        </Lane>
        <Lane Lane.Type="LT_DEFAULT" Orientation="HORIZONTAL" StartBorder="0" EndBorder="50000">
          <Pen Color="0" Style="0" Width="0"/>
          <Brush Color="7f7f7f" Color2="0" BrushType="SOLID"/>
          <xsl:call-template name="create.AttrDef">
            <xsl:with-param name="type" select="'AT_NAME'"/>
            <xsl:with-param name="value" select="'.'"/>
          </xsl:call-template>
        </Lane>
        <xsl:call-template name="create.AttrDef">
          <xsl:with-param name="type" select="'AT_NAME'"/>
          <xsl:with-param name="value" select="@title"/>
        </xsl:call-template>
        <xsl:apply-templates select="sp-list" mode="visual"/>
      </Model> 
    </xsl:if>
    <xsl:apply-templates/>
  </Group>
</xsl:template>


<xsl:template match="sp-list"/>


<!-- Create Models with Object Occurences  -->


<xsl:template match="sp-list" mode="visual">
  <xsl:apply-templates select=".//select" mode="visual"/>
</xsl:template>


<xsl:template match="select" mode="visual">
  <xsl:variable name="sid" select="@id"/>
  <xsl:apply-templates select="/standards/records/standard[@id=$sid]" mode="visual">
     <xsl:with-param name="vid" select="generate-id(..)"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="/standards/records/coverstandard[@id=$sid]" mode="visual">
     <xsl:with-param name="vid" select="generate-id(..)"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="/standards/records/profile[@id=$sid]" mode="visual">  
     <xsl:with-param name="vid" select="generate-id(..)"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="standard|coverstandard|profile" mode="visual">
  <xsl:param name="vid"/>
  <ObjOcc SymbolNum="ST_STANDARD">
    <xsl:attribute name="ObjOcc.ID">
      <xsl:text>ObjOcc.</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>-</xsl:text>
      <!-- Since a standard may occur in multiple models, we need to add something unique
      to the ID for the object occurrence ID (ObjOcc.ID) -->
      <xsl:value-of select="$vid"/> 
    </xsl:attribute>
    <xsl:attribute name="ObjDef.IdRef">
      <xsl:text>ObjDef.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <ExternalGUID>4420106e-4773-11e3-4df7-00155d5f8f19</ExternalGUID>
    <AttrOcc AttrTypeNum="AT_NAME" Port="CENTER" OrderNum="0" Alignment="CENTER" SymbolFlag="TEXT"/>
  </ObjOcc>
</xsl:template>

<!--
<xsl:template match="coverstandard|profile" mode="visual">
  <xsl:param name="vid"/>
  <ObjOcc SymbolNum="ST_STANDARD">
    <xsl:attribute name="ObjOcc.ID">
      <xsl:text>ObjOcc.</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$vid"/> 
    </xsl:attribute>
    <xsl:attribute name="ObjDef.IdRef">
      <xsl:text>ObjDef.</xsl:text>
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <ExternalGUID>4420106e-4773-11e3-4df7-00155d5f8f19</ExternalGUID>
    <AttrOcc AttrTypeNum="AT_NAME" Port="CENTER" OrderNum="0" Alignment="CENTER" SymbolFlag="TEXT"/>
  </ObjOcc>
</xsl:template>
-->

<!-- Create relationship models -->


<xsl:template match="coverstandard" mode="relations"/>


<xsl:template match="profile" mode="relations"/>



<!-- Named templates -->


<xsl:template name="create.AttrDef">
  <xsl:param name="type" select="''"/>
  <xsl:param name="value" select="''"/>

  <AttrDef AttrDef.Type="{$type}">
    <AttrValue LocaleId="{$primary.lang.locale}">
      <StyledElement>
        <Paragraph Alignment="UNDEFINED" Indent="0"/>
	<StyledElement>
	  <PlainText TextValue="{$value}"/>
	</StyledElement>      
      </StyledElement>
    </AttrValue>
    <xsl:if test="$use.secondary.language = 1">
      <AttrValue LocaleId="{$secondary.alt.lang.locale}">
        <StyledElement>
          <Paragraph Alignment="UNDEFINED" Indent="0"/>
          <StyledElement>
            <PlainText TextValue="{$value}"/>
	  </StyledElement>      
        </StyledElement>
      </AttrValue>
    </xsl:if>
  </AttrDef>
</xsl:template>


<!-- Handle Docbook elements -->


<xsl:template match="*">
  <xsl:message terminate="yes">
    <xsl:text>Element </xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text> in namespace '</xsl:text>
    <xsl:value-of select="namespace-uri(.)"/>
    <xsl:text>' encountered</xsl:text>
    <xsl:if test="parent::*">
      <xsl:text> in </xsl:text>
      <xsl:value-of select="name(parent::*)"/>
    </xsl:if>
    <xsl:text>, but no template matches.</xsl:text>
  </xsl:message>
</xsl:template>


</xsl:stylesheet>

