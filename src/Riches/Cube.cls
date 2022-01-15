/// 
Class Riches.Cube Extends %DeepSee.CubeDefinition [ DependsOn = dc.data.finance.transact, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="finance" displayName="finance" disabled="false" abstract="false" sourceClass="dc.data.finance.transact" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="CategoryD" disabled="false" hasAll="false" allCaption="All CategoryD" allDisplayName="CategoryD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Category" disabled="false" sourceProperty="Category" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="MerchantD" disabled="false" hasAll="false" allCaption="All MerchantD" allDisplayName="MerchantD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Merchant" disabled="false" sourceProperty="Merchant" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TranDateD" disabled="false" hasAll="false" allCaption="All TranDateD" allDisplayName="TranDateD" sourceProperty="TranDate" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Month_Year" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <listing name="Listing" displayName=" Default Listing " fieldList=",ID,Account,Credit,Debit,Category,CheckNumber,Memo,Merchant,SubCategory,TranDate" />
  <measure name="Credit" disabled="false" sourceProperty="Credit" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="Debit" disabled="false" sourceProperty="Debit" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
</cube>
}

Parameter DOMAIN;

}
