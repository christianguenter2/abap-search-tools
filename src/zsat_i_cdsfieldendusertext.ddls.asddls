@AbapCatalog.sqlViewName: 'ZSATICFEUTXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Enduser Text Labels for CDS field'

define view ZSAT_I_CDSFieldEndUserText
  as select from ddfieldanno
{
  name
}
