Class Riches.BI.Cube Extends %DeepSee.CubeDefinition [ DependsOn = dc.data.finance.transact, ProcedureBlock ]
{

XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube name="transact"
caption="transact- Generated by Utility"
description="Generated by Utility"
defaultListing="Listing"
nullReplacement="Missing Value"
sourceClass="dc.data.finance.transact">
<listing name="Listing" displayName=" Default Listing "
	fieldList=",ID,TranDate,CheckNumber,Merchant,Category,SubCategory,Memo,Credit,Debit,BillPay,DebitCard,Account,Status" />

<measure name="CheckNumber" sourceProperty="CheckNumber" />
<measure name="Credit" sourceProperty="Credit" />
<measure name="Debit" sourceProperty="Debit" />

<dimension name="TranDate" type = "time" sourceProperty="TranDate" >
<hierarchy name="H1">
<level name="YearTranDate" timeFunction='Year'/>
<level name="MonthTranDate" timeFunction='MonthYear'/>
<level name="DayTranDate" timeFunction='DayMonthYear'/>
</hierarchy>
</dimension>

<dimension name="Merchant">
<hierarchy name="H1">
<level name="Merchant" sourceProperty="Merchant" />
</hierarchy>
</dimension>

<dimension name="Category">
<hierarchy name="H1">
<level name="Category" sourceProperty="Category" />
</hierarchy>
</dimension>

<dimension name="SubCategory">
<hierarchy name="H1">
<level name="SubCategory" sourceProperty="SubCategory" />
</hierarchy>
</dimension>

<dimension name="Memo">
<hierarchy name="H1">
<level name="Memo" sourceProperty="Memo" />
</hierarchy>
</dimension>

<dimension name="BillPay">
<hierarchy name="H1">
<level name="BillPay" sourceProperty="BillPay" />
</hierarchy>
</dimension>

<dimension name="DebitCard">
<hierarchy name="H1">
<level name="DebitCard" sourceProperty="DebitCard" />
</hierarchy>
</dimension>

<dimension name="Account">
<hierarchy name="H1">
<level name="Account" sourceProperty="Account" />
</hierarchy>
</dimension>

<dimension name="Status">
<hierarchy name="H1">
<level name="Status" sourceProperty="Status" />
</hierarchy>
</dimension>

</cube>
}

}