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

ClassMethod GenerateDash(pCubeName As %String, pVerbose As %Boolean = 0) As %Status
{
    Set pCubeName = "transact"
    Set pVerbose = 1
    // Given a cube name, generate a Dashboard
    Set tSC = ##class(AnalyzeThis.Generator).GenerateDash(pCubeName,pVerbose)
    Quit tSC
}

}
