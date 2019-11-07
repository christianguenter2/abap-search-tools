"! <p class="shorttext synchronized" lang="en">Searcher for ABAP Classes</p>
CLASS zcl_sat_ob_class_searcher DEFINITION
  PUBLIC
  INHERITING FROM zcl_sat_ob_generic_searcher
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_sat_object_searcher.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sat_ob_class_searcher IMPLEMENTATION.
  METHOD zif_sat_object_searcher~search.
    " Table for classes/interfaces: seoclass (simple) / seoclassdf (definition with more properties)
    " Text Table                  : seoclasstx
    " Friend Table                : seofriends
    " Relationships (interfaces,
    "    inheritence, ...)        : seometarel - Fieldinfo: (reltype(1) = interface, reltype(2) = inheritence, refclsname = (using interface / super class)
    " Method/Attribute            : seocompodf (different columns for getting information about method/attribute type)
  ENDMETHOD.

ENDCLASS.
