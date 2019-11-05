@AbapCatalog.sqlViewName: 'ZSATICLASS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Properties of a Class'

/*
 * Table for classes/interfaces: seoclass (simple) / seoclassdf (definition with more properties)
 * Text Table                  : seoclasstx
 * Friend Table                : seofriends
 * Relationships (interfaces,
 *    inheritence, ...)        : seometarel - Fieldinfo: (reltype(1) = interface, reltype(2) = inheritence, refclsname = (using interface / super class)
 * Method/Attribute            : seocompodf (different columns for getting information about method/attribute type)
 */
define view ZSAT_I_Class
  as select from seoclassdf as Class
{
      //Class
  key clsname  as ClassName,
  key version  as Version,
      category as Category,
      exposure as Exposure,
      state    as State,
      release  as ReleaseState,
      author as CreatedBy,
      createdon as CreatedOn,
      changedby as ChangedBy,
      changedon as ChangedOn,
      chgdanyby as ChangedAnyBy,
      chgdanyon as ChangedAnyOn,
      clsembed,
      clsabstrct,
      clsfinal,
      clsccincl,
      clsdefatt,
      clsdefmtd,
      refclsname,
      fixpt,
      varcl,
      unicode,
      rstat,
      clsbcimpl,
      r3release,
      clsbctrans,
      clsbccat,
      clsbcnodel,
      clsaddon,
      msg_id,
      clsproxy,
      clssharedmemory,
      with_unit_tests,
      duration_type,
      risk_level,
      within_package
}
