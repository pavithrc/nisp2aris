# NISP2ARIS



Importing the NATO Interoperability Standards and Profiles into an ARIS NAF3 based architecture repository


Issues

* Attributes in standards and profiles - use attribute mapping



Initial import NAF

* her gemmes kopi af uploaded version

* hvad nu, hvis denne fjernes

*  


An import of NISP with create the following hierachy of ARIS groups



  NISP-import-yyyy-mm-dd
        |
        ------ Artifacts
        |
        ------ Relations
        |
        ------ Taxonomy




The subfolders in the hierachy contains the following 


Artifacts

    All NISP standards and profiles are place in the folder as Objects

Relations


Taxonomy

    The taxonomy group contains all nodes in the C3 taxonomy repesented as groupps. For each folder in the taxonomy


Files
=====

* ARIS-Export.dtd - DTD for the ARIS XML export format (version 7.2.4)
* nisp2aris.xsl - Transformation of NISP to ARIS part 1
* nisp2aris-p2.xsl - Transformation of NISP to ARIS part 2
* nisp2aris-p3.xsl - Transformation of NISP to ARIS part 3
* nisp-attribute-map - Mapping between NISP attributes and ARIS attributes types
* README.md - This file (Pandoc Markdown sources)
* README.html - This file in HTML5

TODO
=====

* Create DB structure - Done
* Enable alt language - Done
* Alg:
    Put all standards/profiles in artifacts dir - Done
    Create model for all dependencies 
    Crete Groups/model for all taxonomy nodes - Done




Problems
========




