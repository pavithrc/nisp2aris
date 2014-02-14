<!--
% Importing NISP into an ARIS/NAF3 architecture repository
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% 4. december 2013
-->

# Introduction

The enclosed stylesheets enables import of the NATO Interoperability
Standards and Profiles (NISP) database into an ARIS v. 7.x repository
where the Defence Solution (NAF3) filter has been installed. The
transformation is done by creating a pipeline of three transformation
steps, where the output of the first two steps are used as input to
the next step in the transformation process.

Piping output from one transformation step to the next is implemented
using a propriatary extension of the XSLT processor Saxon - the
stylesheets have been tested with version 9.1 of Saxon.


Transformation of the NISP standard database `standards.xml` to a ARIS
Markup Language (AML) document, which can be imported into the ARIS
repository is done by running the command:

~~~ {.Bash}
    saxon -o nisp-as-aris-aml.xml standards.xml nis2aris.xsl
~~~


# Generation of an AML file

The three transformations necessary to transform the NISP database into
a format, which can be imported into an ARIS repository are implemented
in the three files: `nisp2aris.xsl`, `nisp2aris-p2.xsl` and
`nisp2aris-p3.xsl`. The three transformations are

`nisp2aris.xsl`
:   Remove all standards and profiles, which are not
    explicitly marked as mandatory, emerging or fading in a NISP select
    statement. Also standards which have an implicit relationsho a
    selected standard/profile are included. This relationship will exist
    if e.g. a standard is part of seleted standard.

`nisp2aris-p2.xsl`
:   Merge all select statement into the taxonomy. Remove all standards and profiles with a status of *retired* or *rejected*. 

`nisp2aris-p3.xsl`
:   This is where the actual generation of the AML document takes place.


The stylesheets are described in more detail in comments embedded in each stylesheet.

If all standards and profiles, except retired and rejected standards
and profiles should be imported, the first transformation step can be
skipped by running the command:


~~~ {.Bash}
    saxon -o nisp-as-aris-aml.xml standards.xml nis2aris-p2.xsl
~~~


## Sturcture of a NISP import

An import of NISP with create the following hierachy of ARIS groups

~~~

  NISP-import-yyyy-mm-dd
        |
        ------ Artifacts
        |
        ------ Relations
        |
        ------ Taxonomy

~~~


The subfolders in the hierachy contains the following 


Artifacts
:    All NISP standards and profiles are place in the folder as ARIS standard objects 

Relations
:   This folder contain models which describes the
    relationship between a profile and it child standards an
    profiles. The name of the model represents the parent standard or
    profile and the ARIS standard objects in the model represents the
    children if the parent.


Taxonomy
:   The taxonomy group contains all nodes in the C3 taxonomy
    represented as ARIS groups. In each ARIS group there is óne ARIS
    model with ARIS standards, which represents the standard and
    profiles, which are marked as mandatory, emerging or fading for
    the specific position of the C3 taxonomy.


## Configuration of the stylesheets

Parameters used to configure the stylesheet are placed in the
file `params.xsl`.


## Standard attributes

The properties of a standard or profile are in NISP represented as XML
elements and attributes. Some of these elements and attributes are
usefull for the architect and are therefore imported as attributes to the
ARIS/NAF3 standard element.


All elements in an ARIS repository (group and objects) are given
universaly unique identifier (UUID) at creation time.  If an imported
element in an AML file do not have an UUID one is created
automatically. We utilize this property of the import process to
ensure, that all NISP standard and profiles are uniquely identified
once by the NISP uuid element and any subsequent import of the NISP
database will not create new uuid for standards and profiles.


Some NISP element and attributes are representaed using standard ARIS
attributes, they are

| ARIS name | NISP XML name | ARIS Type | 
|-----------|---------------|-----------|
| - | @tag | AT_NAME |
| Full Name | @title | AT_FULL_NAME |
| Description/Definition | \<applicability\> | AT_DESC |

: mapping between NISP elements/attributes and ARIS types 





| ARIS name | NISP XML name |
|-----------|---------------|
| NISP ID | @id |
| NISP PUBNUM | @pubnum |
| NISP TYPE | - |
| NISP DATE | @date |
| NISP VERSION | @version |
| NISP Std Organisation | @orgid |



~~~ {.xml}
<?xml version="1.0"?>
<!-- Map between NISP attribute types and similar attribute types
     defined your ARIS filter. -->

<!-- The values below are implemented by the Danish extended 
     NAF3 filter. Replace with your own, as these values will
     differ for each ARIS installation -->
 
<nisp-attributes>
  <!-- ARIS Label: GUUID (Predefined in ARIS)
       Use the NISP element uuid 

       ARIS Label: Name (Predefined in ARIS)
       Use the NISP attribute @tag

       ARIS Label: Full name (Predefined in ARIS)
       Use the NISP attribute document/@title
  
       ARIS Label: Description/Definition (Predefined in ARIS)
       Use the NISP element applicability

       ARIS Label: Link 1
       Use the NISP attribute status/uri

  -->

  <!-- ARIS Label: Standard Identifier -->
  <nkey nisp.attribute="id"      aris.type="db7dbe50-0162-11e2-4df7-00155d5f8f19"/>
  
  <!-- ARIS Label: Standard Publisher -->
  <nkey nisp.attribute="orgid"   aris.type="0eb1f570-0163-11e2-4df7-00155d5f8f19"/>

  <!-- ARIS Label: NISP PUBNUM -->
  <nkey nisp.attribute="pubnum"  aris.type="1d2ee9a0-0163-11e2-4df7-00155d5f8f19"/>

  <!-- ARIS Label: Standard Ratification Date -->
  <nkey nisp.attribute="date"    aris.type="c8d548e0-0162-11e2-4df7-00155d5f8f19"/>

  <!-- ARIS Label: Standard Version -->
  <nkey nisp.attribute="version" aris.type="30006ae0-0163-11e2-4df7-00155d5f8f19"/>

  <!-- ARIS Label: NISP Status -->
  <nkey nisp.attribute="status"  aris.type="3b35d530-0163-11e2-4df7-00155d5f8f19"/>

  <!-- ARIS Label: NISP TYPE -->
  <nkey nisp.attribute="type"    aris.type="45f5e870-0163-11e2-4df7-00155d5f8f19"/>
</nisp-attributes>
~~~



# Importing the the NISP

TBD

# Files

The files which are part of the distribution are

* ARIS-Export.dtd - DTD for the ARIS XML export format (version 7.2.4)
* nisp2aris.xsl - Transformation of NISP to ARIS part 1
* nisp2aris-p2.xsl - Transformation of NISP to ARIS part 2
* nisp2aris-p3.xsl - Transformation of NISP to ARIS part 3
* nisp-attribute-map - Mapping between NISP attributes and ARIS attributes types
* params.xsl - User defined configuration parameters
* README.md - This file (Pandoc Markdown sources)
* README.html - This file in HTML5



Cavecats
========





TODO
=====

+ Create an URL in Link 1 attribute
+ CS, S and P as long names
* Model med mandatory standards
* Model med emerging standards
* Model med fading standards
* Model med unmarked standards
* Relations - Brug tag navn i stedet for ID
+ Relations modeller - Tilføj CS og P på modeller



