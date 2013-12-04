% Importing NISP into an ARIS/NAF3 architecture repository
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% 4. december 2013

# Introduction

The enclosed stylesheets enables import of the NATO Interoperability
Standards and Profiles (NISP) database into an ARIS v. 7.x repository
where the Defence Solution (NAF3) filter has been implemented. The
transformation is done by creating a pipeline of three transformation
steps, where the output of the first two steps are used as input to
the next step in the transformation process.

Piping output from one transformation step to the next is implemented
using a propriatary extension of the XSLT processor Saxon - the
stylesheets have been tested with version 9.1 of Saxon.


Transformation of the NISP standard database `standards.xml` to a ARIS
Markup Language (AML) document, which can be imported into the ARIS
repository is done by running the command:

~~~

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
and profiles, should be imported the first transformation step can be
skipped by running the command:


~~~

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
elements and attributes. Some of the elements and attributes are the
the AML version of NISP used to describe the standard and profile.

All elements in an ARIS repository (group and objects) are asigned an
UUID at creation time. If an element in an AML file do not have an
UUID during import, a new UUID is created automatically. We utilize
this property of the import process to ensure, that all NISP standard
and profiles are uniquely identified once by the BISP uuid element and
any subsequent import of the NISP database will not create new uuid
for standards and profiles.

TBD


# Importing the NISP into the ARIS repository

TBD

# Files

The files which are part of the distribution ar

* ARIS-Export.dtd - DTD for the ARIS XML export format (version 7.2.4)
* nisp2aris.xsl - Transformation of NISP to ARIS part 1
* nisp2aris-p2.xsl - Transformation of NISP to ARIS part 2
* nisp2aris-p3.xsl - Transformation of NISP to ARIS part 3
* nisp-attribute-map - Mapping between NISP attributes and ARIS attributes types
* params.xsl - User defined parameters used to configure the the transformation
* README.md - This file (Pandoc Markdown sources)
* README.html - This file in HTML5



Problems
========




