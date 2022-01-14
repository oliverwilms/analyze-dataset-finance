Class Riches.WizardUtils
{

ClassMethod GenerateCube() As %Status
{
    Set pSouceClass = "dc.data.finance.transact"
    Set pCubeName = "transact"
    Set pCubeClass = "Riches.BI.Cube"
    Set pAutoDelete = 1
    Set tSC = ##class(%DeepSee.WizardUtils).%GenerateCubeDefinition(pSouceClass,pCubeName,pCubeClass,pAutoDelete)
    Quit tSC
}

}
