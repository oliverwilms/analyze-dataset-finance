Class Riches.WizardUtils
{

ClassMethod GenerateCube() As %Status
{
    Do ##class(Riches.Util).DebugTEST("Riches.WizardUtils - GenerateCube")
    Set pSouceClass = "dc.data.finance.transact"
    Set pCubeName = "transact"
    Set pCubeClass = "Riches.BI.Cube"
    Set pAutoDelete = 1
    Set tSC = ##class(%DeepSee.WizardUtils).%GenerateCubeDefinition(pSouceClass,pCubeName,pCubeClass,pAutoDelete)
    Do ##class(Riches.Util).DebugStatus(tSC)
    Quit tSC
}

ClassMethod GenerateDash(pCubeName As %String, pVerbose As %Boolean = 0) As %Status
{
    Do ##class(Riches.Util).DebugTEST("Riches.WizardUtils - GenerateDash")
    Set pCubeName = "finance"
    Set pVerbose = 1
    // Given a cube name, generate a Dashboard
    Set tSC = ##class(AnalyzeThis.Generator).GenerateDash(pCubeName,pVerbose)
    Do ##class(Riches.Util).DebugStatus(tSC)
    Quit tSC
}

}
