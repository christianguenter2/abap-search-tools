CLASS zcl_sat_adt_discovery_app DEFINITION
  PUBLIC
  INHERITING FROM cl_adt_disc_res_app_base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_utils_root_scheme TYPE string VALUE 'http://www.devepos.com/adt/saat'.
    CONSTANTS c_utils_rel_scheme TYPE string VALUE 'http://www.devepos.com/adt/relations/saat'.
    CONSTANTS c_object_search_uri TYPE string VALUE '/objectsearch'.
    CONSTANTS c_sapaox_launcher_uri TYPE string VALUE '/sapaox'.
    CONSTANTS c_db_fields_info_uri TYPE string VALUE '/dbfields/info'.
    CONSTANTS c_ddic_repo_access_uri TYPE string VALUE '/ddicaccess'.
    CONSTANTS c_db_field_hierarchy_uri TYPE string VALUE '/dbfield/hierarchy'.
    CONSTANTS c_cds_analysis_uri TYPE string VALUE '/cds/analysis'.
    CONSTANTS c_element_info_uri TYPE string VALUE '/elementinfo'.
    CONSTANTS c_element_info_by_uri_uri TYPE string VALUE '/elementinfoByUri'.
    CONSTANTS c_nav_targets_uri TYPE string VALUE '/navigationtargets'.
    CONSTANTS c_static_uri TYPE string VALUE '/devepos/adt/saat'.
    CONSTANTS c_app_title TYPE string VALUE 'Discovery Provider for DB Browser Utils'.

    METHODS if_adt_rest_rfc_application~get_static_uri_path
        REDEFINITION.
  PROTECTED SECTION.
    METHODS: get_application_title REDEFINITION,
      register_resources REDEFINITION.
  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="en">Register object search</p>
    METHODS register_object_search_res
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Register value help providers</p>
    METHODS register_value_help_providers
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers element info for tree expansion</p>
    METHODS register_element_info
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers resources for SAP Analyis for Office Tools</p>
    METHODS register_sapaox_launcher
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers Resources for CDS Analysis Tools</p>
    METHODS register_cds_select_analysis
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers Resources for detecting navigation targets</p>
    METHODS register_navigation_targets
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers Resources for DB Field accesses</p>
    METHODS register_db_field_resources
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.
    "! <p class="shorttext synchronized" lang="en">Registers template for Object search</p>
    METHODS reg_object_search_template
      IMPORTING
        io_collection       TYPE REF TO if_adt_discovery_collection
        iv_search_type      TYPE zsat_obj_browser_mode
        iv_handler_class    TYPE string
        iv_search_type_term TYPE string.
    "! <p class="shorttext synchronized" lang="en">Registers resource for DDIC Repository Access</p>
    METHODS register_ddic_repo_access
      IMPORTING
        io_registry TYPE REF TO if_adt_disc_rest_rc_registry.

ENDCLASS.



CLASS zcl_sat_adt_discovery_app IMPLEMENTATION.


  METHOD get_application_title.
    result = c_app_title.
  ENDMETHOD.


  METHOD if_adt_rest_rfc_application~get_static_uri_path.
    result = c_static_uri.
  ENDMETHOD.


  METHOD register_resources.
    register_object_search_res( registry ).
    register_value_help_providers( registry ).
    register_element_info( registry ).
    register_sapaox_launcher( registry ).
    register_cds_select_analysis( registry ).
    register_navigation_targets( registry ).
    register_db_field_resources( registry ).
    register_ddic_repo_access( EXPORTING io_registry = registry ).
  ENDMETHOD.

  METHOD register_object_search_res.
    DATA(lo_search_collection) = io_registry->register_discoverable_resource(
        url             = c_object_search_uri
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-object_search
        description     = 'Extended Object Search'
        category_scheme = c_utils_root_scheme && c_object_search_uri
        category_term   = 'search'
    ).

    reg_object_search_template( io_collection       = lo_search_collection
                                iv_handler_class    = zif_sat_c_adt_utils=>c_resource_handler-object_search_cds
                                iv_search_type      = zif_sat_c_object_browser_mode=>cds_view
                                iv_search_type_term = |cds| ).
    reg_object_search_template( io_collection       = lo_search_collection
                                iv_handler_class    = zif_sat_c_adt_utils=>c_resource_handler-object_search_dbtabview
                                iv_search_type      = zif_sat_c_object_browser_mode=>database_table_view
                                iv_search_type_term = |dbtabview| ).
***    reg_object_search_template( io_collection       = lo_search_collection
***                                iv_handler_class    = zif_sat_c_adt_utils=>c_resource_handler-object_search_all
***                                iv_search_type      = zif_sat_c_object_browser_mode=>all
***                                iv_search_type_term = |all| ).
  ENDMETHOD.

  METHOD reg_object_search_template.
    DATA(lv_template) = |{ c_object_search_uri }/{ iv_search_type_term }\{?{ zif_sat_c_adt_utils=>c_search_query_parameter-object_name }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-max_rows }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-user }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-package }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-description }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-get_all_results }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-use_and_for_filters }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-read_package_hierarchy }*\}|.

    CASE iv_search_type.

      WHEN zif_sat_c_object_browser_mode=>all.

      WHEN zif_sat_c_object_browser_mode=>cds_view.
        lv_template = lv_template && |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-field }*\}| &&
                                     |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-param }*\}| &&
                                     |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-params }*\}| &&
                                     |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-select_from }*\}| &&
                                     |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-association }*\}| &&
                                     |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-annotation }*\}|.

        IF sy-saprl >= 751.
          lv_template = lv_template &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-release_state }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-read_api_state }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-extended_by }*\}| &&
                        |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-type }*\}|.
        ENDIF.

      WHEN zif_sat_c_object_browser_mode=>database_table_view.
        lv_template = lv_template && |\{&{ zif_sat_c_adt_utils=>c_search_query_parameter-field }*\}|.

    ENDCASE.

    io_collection->register_disc_res_w_template(
      template      = lv_template
      handler_class = iv_handler_class
      relation      = 'http://www.devepos.com/adt/relations/saat/objectsearch/' && iv_search_type_term
    ).
  ENDMETHOD.

  METHOD register_element_info.
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
        url             = c_element_info_uri
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-element_info
        description     = 'Element info provider'
        category_scheme = c_utils_root_scheme && c_element_info_uri
        category_term   = 'elementinfo'
    ).

*.. Register URI template for element information resource
    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_element_info_uri }\{?{ zif_sat_c_adt_utils=>c_element_info_parameter-name },| &&
                      |{ zif_sat_c_adt_utils=>c_element_info_parameter-object_type }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_cds_elem_info_parameter-show_association_name }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_element_info_parameter-basic_info }*\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-element_info
      relation      = 'http://www.devepos.com/adt/relations/saat/elementinfo'
    ).

*.. Register resource template for element info by uri
    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_element_info_by_uri_uri }\{?{ zif_sat_c_adt_utils=>c_element_info_parameter-uri }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_cds_elem_info_parameter-show_association_name }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_element_info_parameter-basic_info }*\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-element_info_by_uri
      relation      = 'http://www.devepos.com/adt/relations/saat/elementinfo/byUri'
    ).

*.. Register special URI template for CDS secondary element information retrieval
    lo_element_info_collection->register_disc_res_w_template(
      template      = '/elementinfo/cds/secondary' &&
                      |\{?{ zif_sat_c_adt_utils=>c_element_info_parameter-name }\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-cds_secondary_element_info
      relation      = 'http://www.devepos.com/adt/relations/saat/elementinfo/cds/secondary'
    ).
  ENDMETHOD.


  METHOD register_value_help_providers.

    DATA(lv_object_search_scheme) = c_utils_root_scheme && c_object_search_uri.

    io_registry->register_discoverable_resource(
        url             = '/cdsfield'
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-cds_fields
        description     = 'Search for CDS View field.'
        category_scheme = lv_object_search_scheme
        category_term   = 'cdsfield'
    ).
    io_registry->register_discoverable_resource(
        url             = '/tablefield'
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-db_table_fields
        description     = 'Search for Table Field'
        category_scheme = lv_object_search_scheme
        category_term   = 'tablefield'
    ).
    IF sy-saprl >= 752.
      io_registry->register_discoverable_resource(
          url             = '/annotation'
          handler_class   = zif_sat_c_adt_utils=>c_resource_handler-annotations
          description     = 'Search for Annotation'
          category_scheme = lv_object_search_scheme
          category_term   = 'annotation'
      ).
      io_registry->register_discoverable_resource(
          url             = '/annotationvalue'
          handler_class   = zif_sat_c_adt_utils=>c_resource_handler-annotation_values
          description     = 'Search for Annotation Values'
          category_scheme = lv_object_search_scheme
          category_term   = 'annotationvalue'
      ).
    ENDIF.
    io_registry->register_discoverable_resource(
        url             = '/dbentity'
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-database_entities
        description     = 'Search for Database entities'
        category_scheme = lv_object_search_scheme
        category_term   = 'dbentity'
    ).
    IF sy-saprl >= 751.
      io_registry->register_discoverable_resource(
          url             = '/releasestate'
          handler_class   = zif_sat_c_adt_utils=>c_resource_handler-release_api_states
          description     = 'Search for Release API states'
          category_scheme = lv_object_search_scheme
          category_term   = 'releasestate'
      ).
      io_registry->register_discoverable_resource(
          url             = '/cdstype'
          handler_class   = zif_sat_c_adt_utils=>c_resource_handler-cds_types
          description     = 'Search for CDS source types'
          category_scheme = lv_object_search_scheme
          category_term   = 'cdstype'
      ).
    ENDIF.

    io_registry->register_discoverable_resource(
        url             = '/cdsextension'
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-cds_extensions
        description     = 'Search for CDS Extension'
        category_scheme = lv_object_search_scheme
        category_term   = 'cdsextension'
    ).

  ENDMETHOD.

  METHOD register_sapaox_launcher.
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
        url             = c_sapaox_launcher_uri
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-sapaox_launcher
        description     = 'Analysis for Office Launcher'
        category_scheme = c_utils_root_scheme && c_sapaox_launcher_uri
        category_term   = 'sapaox'
    ).

*.. Build template for Analysis for Office Launcher
    DATA(lv_template) = |{ c_sapaox_launcher_uri }\{?{ zif_sat_c_adt_utils=>c_element_info_parameter-name }\}|.

*.. Register URI template for Analyis for Office launcher
    lo_element_info_collection->register_disc_res_w_template(
      template      = lv_template
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-sapaox_launcher
      relation      = c_utils_rel_scheme && c_sapaox_launcher_uri
    ).

  ENDMETHOD.


  METHOD register_cds_select_analysis.
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
        url             = c_cds_analysis_uri
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-cds_analysis
        description     = 'Resource for CDS Analysis'
        category_scheme = c_utils_root_scheme && c_cds_analysis_uri
        category_term   = 'cdsanalysis'
    ).

*.. Register URI template for Analyis of CDS Views
    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_cds_analysis_uri }\{?{ zif_sat_c_adt_utils=>c_cds_analysis_parameter-cds_name }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_cds_analysis_parameter-with_associations }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_cds_analysis_parameter-usage_analysis }*\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-cds_analysis
      relation      = c_utils_rel_scheme && c_cds_analysis_uri
    ).
  ENDMETHOD.

  METHOD register_navigation_targets.
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
        url             = c_nav_targets_uri
        handler_class   = zif_sat_c_adt_utils=>c_resource_handler-navigation_targets
        description     = 'Resource for Navigation targets'
        category_scheme = c_utils_root_scheme && c_nav_targets_uri
        category_term   = 'navigationtargets'
    ).

    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_nav_targets_uri }\{?{ zif_sat_c_adt_utils=>c_element_info_parameter-name }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_element_info_parameter-object_type }\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-navigation_targets
      relation      = c_utils_rel_scheme && c_nav_targets_uri
    ).

  ENDMETHOD.

  METHOD register_db_field_resources.

*.. Register resource for reading the hierarchy or where-used list of Table / View / CDS Field
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
       url             = c_db_field_hierarchy_uri
       handler_class   = zif_sat_c_adt_utils=>c_resource_handler-db_fields_hierarchy
       description     = 'Resource for resolving the Hierarchy of a CDS Field'
       category_scheme = c_utils_root_scheme && c_db_field_hierarchy_uri
       category_term   = 'db-fields-hierarchy'
    ).

    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_db_field_hierarchy_uri }\{?{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-name }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-type }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-field }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-mode }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-search_calc_fields }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_db_fields_info_parameter-search_db_views }*\}|
      handler_class   = zif_sat_c_adt_utils=>c_resource_handler-db_fields_hierarchy
      relation      = c_utils_rel_scheme && c_db_field_hierarchy_uri
    ).
  ENDMETHOD.


  METHOD register_ddic_repo_access.
**.. Register resource for DDIC Repository access
    DATA(lo_element_info_collection) = io_registry->register_discoverable_resource(
       url             = c_db_fields_info_uri
       handler_class   = zif_sat_c_adt_utils=>c_resource_handler-ddic_repo_access
       description     = 'Resource for Repository DDIC Access'
       category_scheme = c_utils_root_scheme && c_ddic_repo_access_uri
       category_term   = 'ddicAccess'
    ).

    lo_element_info_collection->register_disc_res_w_template(
      template      = |{ c_ddic_repo_access_uri }\{?{ zif_sat_c_adt_utils=>c_ddic_repo_access_params-access_mode }\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_ddic_repo_access_params-uri }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_ddic_repo_access_params-paths }*\}| &&
                      |\{&{ zif_sat_c_adt_utils=>c_ddic_repo_access_params-filters }*\}|
      handler_class = zif_sat_c_adt_utils=>c_resource_handler-ddic_repo_access
      relation      = c_utils_rel_scheme && c_ddic_repo_access_uri
    ).
  ENDMETHOD.

ENDCLASS.