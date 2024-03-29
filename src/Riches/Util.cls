Class Riches.Util
{

ClassMethod DebugMerge(
	strMessage As %String = "",
	ByRef pArray) As %Status
{
	Merge ^TESTunit($I(^TESTunit)) = pArray
	Set tValue = ""
	If $Get(pArray) '= "" Set tValue = " = "_pArray
	Set ^TESTunit(^TESTunit) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage_tValue
	Quit $$$OK
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTunit($I(^TESTunit)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod GetStatusText(pStatus As %Status) As %String
{
	If $$$ISOK(pStatus) Quit "OK"
	Set tErrorText = $SYSTEM.Status.GetErrorText(pStatus)
	Set tReturn = $REPLACE(tErrorText,"ERROR #5001:","")
	Quit tReturn
}

ClassMethod EncodeLogicalDisplay(
	pLogical As %String = "",
	pDisplay As %String = "") As %String
{
	Set delim = "^"
	If (pLogical [ delim) {
		Set pLogical = $Replace(pLogical,delim,"?")
	}
	If (pDisplay [ delim) {
		Set pDisplay = $Replace(pDisplay,delim,"?")
	}
	Set tLogicalDisplay = delim_pLogical_delim_pDisplay
	Quit tLogicalDisplay
}

ClassMethod ExecuteQueryOneValue(
	pQuery As %String,
	ByRef pResult As %String) As %Status
{
	Do ..DebugTEST("Riches.Util - ExecuteQueryOneValue")
	Do ..DebugTEST("pQuery = "_pQuery)
	Set pResult = ""
	Set rs = ##class(%ResultSet).%New()
	Set tSC = rs.Prepare(pQuery)
	Do ..DebugStatus(tSC)
	If $$$ISOK(tSC) {
		Set tSC = rs.Execute()
		Do ..DebugStatus(tSC)
		If $$$ISOK(tSC), rs.Next() Set pResult = rs.GetData(1)
	}
	Do rs.Close()
	Set rs = ""
	Do ..DebugTEST("pResult = "_pResult)
	Quit tSC
}

ClassMethod GetDateValue(pValue As %String) As %Date
{
	If ($Get(pValue) ? 1.N1"/"1.N1"/"1.N) {
		Set tDate = $ZDATEH(pValue,8)
		Quit tDate
	}
	If ($Get(pValue) ? 1.N1"-"1.N1"-"1.N) {
		Set tDate = $ZDATEH(pValue,8)
	}
	Quit $Get(tDate,0)
}

ClassMethod GetOptionsTableColumns(
	pClassname As %String = "",
	Output pOptions As %String) As %String
{
	/*
	Set q = """"
	Set qValue = q_""_q
	Set tOption0 = "<option value="_qValue_"></option>"
	Set qValue = q_"Nickname"_q
	Set tOption1 = "<option value="_qValue_">Nickname</option>"
	Set qValue = q_"SortOrder"_q
	Set tOption2 = "<option value="_qValue_">Sort</option>"
	Set qValue = q_"Type"_q
	Set tOption3 = "<option value="_qValue_">Type</option>"
	*/
	Set q = """"
	Set qValue = q_""_q
	Set pOptions = "<option value="_qValue_"></option>"
	If (pClassname = "") Set pClassname = "Riches.Category"
	Try {
		Set tSC = $CLASSMETHOD(pClassname,"GetColumns",.pColumns)
	} Catch {
	}
	For ii = 1:1:$Get(pColumns,0) {
		Set tLogicalDisplay = $Get(pColumns(ii))
		Set delim = $Extract(tLogicalDisplay,1)
		Set tLogical = $Piece(tLogicalDisplay,delim,2)
		Set tDisplay = $Piece(tLogicalDisplay,delim,3)
		Set qValue = q_tLogical_q
		Set pOptions = pOptions_"<option value="_qValue_">"_tDisplay_"</option>"
	}
	Quit pOptions
}

ClassMethod GetOptionsTableNames(
	pSelected As %String = "",
	Output pOptions As %String) As %String
{
	/*
  <option value="Riches.Category">Category</option>
  <option value="Riches.Merchant">Merchant</option>
  <option value="Riches.Transact">Transact</option>
	*/
	Set q = """"
	Set qValue = q_""_q
	Set pOptions = "<option value="_qValue_"></option>"
	For ii = "Category", "Merchant", "Transact" {
		Set tLogical = "Riches."_ii
		Set tDisplay = ii
		Set qValue = q_tLogical_q
		Set selected = $Select((tLogical = pSelected):" selected",1:"")
		Set pOptions = pOptions_"<option value="_qValue_selected_">"_tDisplay_"</option>"
	}
	Quit pOptions
}

ClassMethod ImportCSV(
	pCSV As %String = "",
	pMaxRows As %Integer = 9999) As %Status
{
	If (pCSV = "") {
		Set tExport = "/usr/irissys/lib/irisapp/export.CSV"
		If ##class(%File).Exists(tExport) Set pCSV = tExport
	}
	If (pCSV = "") {
		Set tExport = "/opt/irisapp/data/export.csv"
		If ##class(%File).Exists(tExport) Set pCSV = tExport
	}
	If (pCSV = "") {
		Set tExport = "/opt/irisapp/export.CSV"
		If ##class(%File).Exists(tExport) Set pCSV = tExport
	}
	Write "ImportCSV ",pCSV,!
	Set timeout = 1
	Open pCSV:("R"):timeout  // read
	If ($TEST = 0) {
		Set msg = "Unable to Open "_pCSV
		Write msg,!
		Quit $$$ERROR($$$GeneralError,msg)
	}
	If 
	Set comma = ","
	Set rows = -1
	Set cAccount = 0
	Set cCategory = 0
	Set cCheck = 0
	Set cCredit = 0
	Set cDate = 0
	Set cDebit = 0
	Set cMemo = 0
	Set cMerchant = 0
	Set cStatus = 0
	Set cSubategory = 0
	Try {
		Use pCSV
		Set tColumns = "Account,TranDate,Merchant,Category,AmountDebit,AmountCredit"
		Set tQuery = "Insert into Riches.Transact ("_tColumns_") values "
		For {
			Read line
			If ($Increment(rows) = 0) {
				If ($Get(line) = "") {
					Set msg = "Headers not found in "_pCSV
					Use 0
					Write msg,!
					Quit  // For loop
				}
				Set headers = line
				For ii = 1:1:$Length(headers,comma) {
					Set title = $Piece(headers,comma,ii)
					Set tSC = ##class(Riches.Util).UnQuote(title,.title)
					If (title = "Account") Set cAccount = ii
					If (title = "Check") Set cCheck = ii
					If (title = "Credit") Set cCredit = ii
					If (title = "Date") Set cDate = ii
					If (title = "Debit") Set cDebit = ii
					If (title = "Memo") Set cMemo = ii
					If (title = "Merchant") Set cMerchant = ii
					If (title = "Status") Set cStatus = ii
					If (title = "Subategory") Set cSubategory = ii
					If '(title [ "SubCategory"),(title [ "Category") Set cCategory = ii
				}
				Continue
			}
			If (rows > pMaxRows) { Quit }
			Set tValues = "("
			If cAccount Set tValues = tValues_$Piece(line,comma,cAccount)
			Set tValues = tValues_comma
			If cDate Set tValues = tValues_$Piece(line,comma,cDate)
			Set tValues = tValues_comma
			If cMerchant Set tValues = tValues_$Piece(line,comma,cMerchant)
			Set tValues = tValues_comma
			If cCategory Set tValues = tValues_$Piece(line,comma,cCategory)
			Set tValues = tValues_comma
			If cDebit Set tValues = tValues_$Piece(line,comma,cDebit)
			Set tValues = tValues_comma
			If cCredit Set tValues = tValues_$Piece(line,comma,cCredit)
			Set tValues = tValues_")"
			Set tSQL = tQuery_tValues
			Set tSC = ##class(Riches.REST).PostSQL(tSQL,rows)
		}
	} Catch {
	}
	Close pCSV
	Quit $$$OK
}

ClassMethod InstallHelper() As %Status
{
	Set tSC = $$$OK
	Do EnableDeepSee^%SYS.cspServer("/csp/user/")
	//Set tSC = ##class(Riches.Util).SQLGrantAccess()
	//Set tSC = ##class(Riches.Util).ImportCSV()
	Kill ^TESTunit
	Set tSC = ##class(Riches.WizardUtils).GenerateCube()
	//Set tSC = ##class(%DeepSee.Utils).%BuildCube("transact")
	//ERROR #5002: ObjectScript error: <CLASS DOES NOT EXIST>%BuildCube+87^%DeepSee.Utils.1 *(No name)No Meta Data Found
	//Set tSC = ##class(Riches.WizardUtils).GenerateDash()
	Set tSC = ##class(%DeepSee.Utils).%BuildCube("finance")
	Set tSC = ##class(Riches.WizardUtils).GenerateDash("finance")
	Quit tSC
}

ClassMethod OutputDebug(
	pAccount As %String = "",
	pTable As %String = "",
	pDebug As %String = "") As %Status
{
	Do ..DebugTEST("Riches.Util - OutputDebug")
	Do ..DebugTEST("pAccount = "_pAccount)
	Do ..DebugTEST("pTable = "_pTable)
	If ($Data(^RichesDEBUG) = 0) Quit $$$OK
	If (pDebug = "") {
		//Set pTable = pDebug
		Set pDebug = "PREVIEW"
	}
	Write "<table border=1>",!
	If (pDebug = "PREVIEW") {
		Set pp = ""
		For {
			Set pp = $Order(^RichesDEBUG(pp))
			If (pp = "") Quit
			Set qq = $Order(^RichesDEBUG(pp,""))
			If (qq = "") Continue
			Set tDebugLine = $Get(^RichesDEBUG(pp,qq))
			Set pDebug = 0
			Set tSC = ..OutputDebugLine(tDebugLine,(pp = 0),pp,pAccount,pTable,pDebug)
			If $$$ISERR(tSC) Quit
		}
	}
	Write "</table>",!
	Quit $$$OK
}

ClassMethod OutputDebugLine(
	pDebugLine As %String = "",
	pHeader As %String = 0,
	pId As %String = "",
	pAccount As %String = "",
	pTable As %String = "",
	pDebug As %String = 0) As %Status
{
	Do:pDebug ..DebugTEST("Riches.Util - OutputDebugLine")
	Do:pDebug ..DebugTEST("pDebugLine = "_pDebugLine)
	Set q = """"
	Set delim = ","
	Set tLen = $Length(pDebugLine,delim)
	For pp=1:1:tLen {
		Set tDebugPiece = $Piece(pDebugLine,delim,pp)
		If (pp = 1) {
			Set tLineId = tDebugPiece  // Is tLineId same as pId ?
			Write "<tr id=",q,"tr_",pId,q,">",!
			Set qID = q_"div_"_pId_"_0"_q
			Set tDiv = "<div id="_qID_">"_tDebugPiece_"</div>"
			Set tSC = ..OutputDebugPiece(tDiv,pHeader,pDebug)
			If $$$ISERR(tSC) Quit
			// Add a table cell for iAccount
			Set tDebugPiece = $Get(pAccount)
		}
		Set qID = q_"div_"_pId_"_"_pp_q
		Set tDiv = "<div id="_qID_">"_tDebugPiece_"</div>"
		Set tSC = ..OutputDebugPiece(tDiv,pHeader,pDebug)
		If $$$ISERR(tSC) Quit
	}
	Write "<th>",!
	If (pHeader = 0) {
		Set qClick = q_"goClickLine("_tLineId_")"_q
		Set qType = q_"button"_q
		Write "<button type=",qType," onclick=",qClick,">Import</button>",!
	}
	Write "</th>",!
	Write "</tr>",!
	If (pHeader = 0) Quit $$$OK
	// Row of <select> for choosing table column to import to
	Set tClassname = pTable
	//Set tClassname = "Riches.Category"
	Set q = """"
	Set tSelect2 = "</select>"
	Set onchange = "onchangeSel(this)"
	Write "<tr>",!
	For pp=1:1:tLen {
		If (pp = 1) {
			Set qID = q_"div_col_count"_q
			Set qStyle = q_"display:none"_q
			Set tDebugPiece = "<div id="_qID_" style="_qStyle_">"_tLen_"</div>"
			Set tSC = ..OutputDebugPiece(tDebugPiece,0)
			If $$$ISERR(tSC) Quit
			// Add a <select> for iAccount
		}
		Set qName = q_"sel_"_pp_q
		Set qID = q_"sel_"_pp_q
		Set tSelect1 = "<select name="_qName_" id="_qID_"onchange="_q_onchange_q_">"
		Set tDebugPiece = "<div>"_tSelect1_..GetOptionsTableColumns(tClassname)_tSelect2_"</div>"
		Set tSC = ..OutputDebugPiece(tDebugPiece,0)
	}
	Write "</tr>",!
	Quit $$$OK
}

ClassMethod OutputDebugPiece(
	pDebugPiece As %String = "",
	pHeader As %String = 0,
	pDebug As %String = 0) As %Status
{
	Do:pDebug ..DebugTEST("Riches.Util - OutputDebugPiece")
	Do:pDebug ..DebugTEST("pDebugPiece = "_pDebugPiece)
	If pHeader {
		Set td1 = "<th>"
	} Else {
		Set td1 = "<td>"
	}
	Write td1
	Write pDebugPiece
	If pHeader {
		Set td1 = "</th>"
	} Else {
		Set td1 = "</td>"
	}
	Write td1,!
	Quit $$$OK
}

ClassMethod OutputRadio(
	pName As %String = "",
	pID As %String = "",
	pCaption As %String) As %Status
{
	Set q = """"
	Set qRadio = q_"radio"_q
	Set qName = q_pName_q
	Set qID = q_pID_q
	Write "<input type=",qRadio," id=",qID," name=",qName," value=",qID,">",!
	Write "<label for=",qID,">",pCaption,"</label><br>",!
	Quit $$$OK
}

ClassMethod OutputSelectTable(
	pName As %String = "iTable",
	pID As %String = "iTable",
	pCaption As %String = "Insert into table:",
	pSelected As %String) As %Status
{
	/*
<label for="iTable">Insert into table:</label>

<select name="iTable" id="iTable" onchange="onchangeTable(this.value)">
  <option value="Riches.Category">Category</option>
  <option value="Riches.Merchant">Merchant</option>
  <option value="Riches.Transact">Transact</option>
</select>
	*/
	Set pDebug = 1
	Do:pDebug ..DebugTEST("Riches.Util - OutputSelectTable")
	Do:pDebug ..DebugTEST("pSelected = "_$Get(pSelected))
	Set q = """"
	Set qName = q_pName_q
	Set qID = q_pID_q
	Write "<label for=",qID,">",pCaption,"</label>",!
	Write "<select name=",qName," id=",qID," onchange=",q,"onchangeTable(this.value)",q,">",!
	Write ..GetOptionsTableNames($Get(pSelected))
	Write "</select>",!
	Quit $$$OK
}

ClassMethod QuoteJSLogicalDisplay(
	pLogical As %String = "",
	pDisplay As %String = "") As %String
{
	Set tLogicalDisplay = ..EncodeLogicalDisplay(pLogical,pDisplay)
	Quit ##class(%CSP.Page).QuoteJS(tLogicalDisplay)
}

ClassMethod SQLGrantAccess() As %Status
{
	&sql(GRANT INSERT,SELECT,UPDATE ON Riches.Account,Riches.Category,Riches.Merchant,Riches.SubCategory,Riches.Transact TO UnknownUser)
	if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(%SQLCODE,"Grant roles")
	Quit $$$OK
}

ClassMethod UnQuote(
	pQuote As %String = "",
	Output pUnQuote As %String,
	pOutQuote As %String = "",
	pVerbose As %Integer = 0) As %Status
{
	Do:pVerbose ..DebugTEST("Riches.Util - UnQuote")
	Do:pVerbose ..DebugTEST("pQuote = "_pQuote)
	Set boolContinue = 1
	While boolContinue {
		Set tFirst = $Extract(pQuote,1)
		Set tLast = $Extract(pQuote,*)
		If (tFirst = "'") {
			If (tFirst = tLast) {
				Set pQuote = $Extract(pQuote,2,*-1)
			} Else { Set boolContinue = 0 }
		} ElseIf (tFirst = """") {
			If (tFirst = tLast) {
				Set pQuote = $Extract(pQuote,2,*-1)
			} Else { Set boolContinue = 0 }
		} Else { Set boolContinue = 0 }
	}
	/*
	// Problem with ' or #
	Set pEscape1 = ##class(%CSP.Page).EscapeHTML(pQuote)
	Set pEscape2 = ##class(%CSP.Page).EscapeURL(pQuote)
	If (pQuote [ "'") {
		Do ..DebugTEST("pEscape1 = "_pEscape1)
		Do ..DebugTEST("pEscape2 = "_pEscape2)
		If '(pEscape1 [ "'") {
			Set pUnQuote = "'"_pEscape1_"'"
		} ElseIf '(pEscape2 [ "'") {
			Set pUnQuote = "'"_pEscape2_"'"
		} Else {
			Set pUnQuote = ""
		}
	} Else {
		Set pUnQuote = "'"_pQuote_"'"
	}
	*/
	// Problem with ' or #
	Set pEscape = ##class(%CSP.Page).EscapeHTML(pQuote)
		Do:pVerbose ..DebugTEST("pEscape = "_pEscape)
	If (pQuote '= pEscape) {
		//Do ..DebugTEST("pEscape = "_pEscape)
	}
	Set pUnQuote = pOutQuote_pEscape_pOutQuote
	If (pUnQuote = "") Set pUnQuote = "''"
	Do:pVerbose ..DebugTEST("pUnQuote = "_pUnQuote)
	Quit $$$OK
}

}
