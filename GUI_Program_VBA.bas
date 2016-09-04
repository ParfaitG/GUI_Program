
'''''''''''''''''''''''
'' MS ACCESS VBA 
'''''''''''''''''''''''

Option Explicit
Option Compare Database

Private Sub Make_AfterUpdate()
    Me.Model.Requery
    Me.Engine.Requery
    Me.Transmission.Requery
    Me.FuelType.Requery
End Sub

Private Sub RunOutput_Click()
    Dim db As Database
    Dim qdef As QueryDef
    Dim dataSQL As New Collection
    Dim key As Variant
    Dim strSQL As String
    
    Set db = CurrentDb
    db.Execute "DELETE FROM GUIReport"
    
    Set dataSQL = FilterCriteria
    strSQL = dataSQL(1) _
             & " INSERT INTO GUIReport" _
             & " SELECT Vehicles.make, Vehicles.model, Vehicles.Year," _
             & " Vehicles.engId, Vehicles.trany, Vehicles.fuelType," _
             & " Avg(Vehicles.barrels08) AS AvgOfbarrels08, Avg(Vehicles.city08) AS AvgOfcity08, " _
             & " Avg(Vehicles.comb08) AS AvgOfcomb08, Avg(Vehicles.highway08) AS AvgOfhighway08, " _
             & " Ccur(Avg(Vehicles.fuelCost08)) AS AvgOffuelCost08" _
             & " FROM Vehicles" _
             & " WHERE " & dataSQL(2) _
             & " GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year," _
             & "          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;"
    
    ' SUBSET VEHICLES REPORT
    Set qdef = db.CreateQueryDef("", strSQL)
    
    For Each key In dataSQL(3).keys
        qdef.Parameters(key) = dataSQL(3)(key)
    Next key
    
    qdef.Execute dbFailOnError
    
    DoCmd.TransferText acExportDelim, , "GUIReport", Application.CurrentProject.Path & "\DATA\GUIData_ACC.csv", True
    MsgBox "Successfully outputted queried data to csv!", vbInformation, "SUCCESSFUL OUTPUT"
    
    Set qdef = Nothing
    Set db = Nothing
    
End Sub

Private Function FilterCriteria() As Collection
    Dim whereclauseItems As New Collection
    Dim strCriteria As String: strCriteria = "1=1"
    Dim strParams As String: strParams = "PARAMETERS"
    Dim params As Object
    
    Set params = CreateObject("Scripting.Dictionary")

    If Not IsNull(Forms!ReportMenu!Make) Then
        strParams = strParams & " [MakeParam] Text(255),"
        strCriteria = strCriteria & " AND make=[Makeparam]"
        params.Add "Makeparam", Forms!ReportMenu!Make
    End If

    If Not IsNull(Forms!ReportMenu!Model) Then
        strParams = strParams & " [ModelParam] Text(255),"
        strCriteria = strCriteria & " AND model=[Modelparam]"
        params.Add "Modelparam", Forms!ReportMenu!Model
    End If

    If Not IsNull(Forms!ReportMenu!AutoYearStart) And Not IsNull(Forms!ReportMenu!AutoYearEnd) Then
        strParams = strParams & " [YearEndparam] Integer, [YearStartparam] Integer,"
        strCriteria = strCriteria & " AND year BETWEEN [YearStartparam] AND [YearEndparam]"
        params.Add "YearStartparam", Forms!ReportMenu!AutoYearStart
        params.Add "YearEndparam", Forms!ReportMenu!AutoYearEnd
    End If

    If Not IsNull(Forms!ReportMenu!Engine) Then
        strParams = strParams & " [EngParam] Double,"
        strCriteria = strCriteria & " AND engId=[Engparam]"
        params.Add "Engparam", CDbl(Forms!ReportMenu!Engine)
    End If

    If Not IsNull(Forms!ReportMenu!Transmission) Then
        strParams = strParams & " [TransParam] Text(255),"
        strCriteria = strCriteria & " AND trany=[Transparam]"
        params.Add "Transparam", Forms!ReportMenu!Transmission
    End If

    If Not IsNull(Forms!ReportMenu!FuelType) Then
        strParams = strParams & " [FuelParam] Text(255),"
        strCriteria = strCriteria & " AND fueltype=[Fuelparam]"
        params.Add "Fuelparam", Forms!ReportMenu!FuelType
    End If

    strParams = Mid(strParams, 1, Len(strParams) - 1) & ";"
    
    whereclauseItems.Add strParams
    whereclauseItems.Add strCriteria
    whereclauseItems.Add params
    Set FilterCriteria = whereclauseItems
    
End Function



'''''''''''''''''''''''
'' MS EXCEL VBA 
'''''''''''''''''''''''

Option Explicit

'' BEHIND Report_Menu UserForm
Dim conn As Object, cmd As Object, rst As Object

Private Sub MakeCbo_AfterUpdate()
On Error GoTo ErrHandle
    Dim strSQL As String
    Const adCmdText = 1, adParamInput = 1, adVarChar = 200
        
    ' MODEL UPDATE
    Set cmd = CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = conn
        .CommandText = "SELECT DISTINCT [Model] FROM vehicles WHERE [Make] = ? ORDER BY [Model];"
        .CommandType = adCmdText
        .CommandTimeout = 15
    End With
    cmd.Parameters.Append cmd.CreateParameter("userparam", adVarChar, adParamInput, 255, Me.MakeCbo)
    Set rst = cmd.Execute
    
    rst.MoveFirst
    Me.ModelCbo.Clear
    Do While Not rst.EOF
        Me.ModelCbo.AddItem rst![Model]
        rst.MoveNext
    Loop
    rst.Close
    
    ' ENGINE UPDATE
    Set cmd = CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = conn
        .CommandText = "SELECT DISTINCT [engId] FROM vehicles WHERE [Make] = ? ORDER BY [engId];"
        .CommandType = adCmdText
        .CommandTimeout = 15
    End With
    cmd.Parameters.Append cmd.CreateParameter("userparam", adVarChar, adParamInput, 255, Me.MakeCbo)
    Set rst = cmd.Execute
    
    Me.EngineCbo.Clear
    rst.MoveFirst
    Do While Not rst.EOF
        Me.EngineCbo.AddItem rst![engId]
        rst.MoveNext
    Loop
    rst.Close
    
    ' TRANSMISSION UPDATE
    Set cmd = CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = conn
        .CommandText = "SELECT DISTINCT [trany] FROM vehicles WHERE [Make] = ? ORDER BY [trany];"
        .CommandType = adCmdText
        .CommandTimeout = 15
    End With
    cmd.Parameters.Append cmd.CreateParameter("userparam", adVarChar, adParamInput, 255, Me.MakeCbo)
    Set rst = cmd.Execute
    
    Me.TransmissionCbo.Clear
    rst.MoveFirst
    Do While Not rst.EOF
        Me.TransmissionCbo.AddItem rst![trany]
        rst.MoveNext
    Loop
    rst.Close
        
    ' FUEL TYPE UPDATE
    Set cmd = CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = conn
        .CommandText = "SELECT DISTINCT [fueltype] FROM vehicles WHERE [Make] = ? ORDER BY [fueltype];"
        .CommandType = adCmdText
        .CommandTimeout = 15
    End With
    cmd.Parameters.Append cmd.CreateParameter("userparam", adVarChar, adParamInput, 255, Me.MakeCbo)
    Set rst = cmd.Execute
        
    rst.MoveFirst
    Me.FuelTypeCbo.Clear
    Do While Not rst.EOF
        Me.FuelTypeCbo.AddItem rst![FuelType]
        rst.MoveNext
    Loop
    rst.Close
    
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

Private Sub OutputBtn_Click()
On Error GoTo ErrHandle
    Dim strSQL As String, strFile As String
    Dim sqlCollection As New Collection
    Dim key As Variant
    Dim col As Integer
    Dim newb As Workbook
    Const adCmdText = 1, adParamInput = 1, adVarChar = 200
    
    ThisWorkbook.Worksheets("RESULTS").Range("A:L").Columns.Delete xlShiftToLeft
    
    Set sqlCollection = FilterCriteria
    
    ' PREPARE COMMAND
    strSQL = "SELECT Vehicles.Make, Vehicles.Model, Vehicles.Year," _
                & " Vehicles.EngId, Vehicles.Trany, Vehicles.FuelType," _
                & " Avg(Vehicles.barrels08) AS BarrelsAvg, Avg(Vehicles.city08) AS CityMPGAvg, " _
                & " Avg(Vehicles.comb08) AS CombinedMPGAvg, Avg(Vehicles.highway08) AS HighwayMPGAvg, " _
                & " Avg(Vehicles.fuelCost08) AS FuelCostAvg" _
                & " FROM Vehicles" _
                & " WHERE " & sqlCollection(1) _
                & " GROUP BY Vehicles.make, Vehicles.model, Vehicles.Year," _
                & "          Vehicles.engId, Vehicles.trany, Vehicles.fuelType;"
    
    Set cmd = CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = conn
        .CommandText = strSQL
        .CommandType = adCmdText
        .CommandTimeout = 15
    End With
    
    ' BIND PARAMETERS
    For Each key In sqlCollection(2).keys
        cmd.Parameters.Append cmd.CreateParameter(key, adVarChar, adParamInput, 255, sqlCollection(2)(key))
    Next key
    
    ' RUN RECORDSET
    Set rst = cmd.Execute
    
    ' CREATE CSV FILE
    Set newb = Workbooks.Add
    With newb.Sheets(1)
        For col = 1 To rst.Fields.Count
            .Cells(1, col) = rst.Fields(col - 1).Name
        Next col
    
        .Range("A2").CopyFromRecordset rst
    End With
    
    strFile = ThisWorkbook.Path & "\DATA\GUIData_XL.csv"
    If Len(Dir(strFile, vbDirectory)) > 0 Then Kill strFile
    
    newb.SaveAs strFile, xlCSV
    newb.Close True
            
    MsgBox "Successfully exported queried data to csv!", vbInformation, "SUCCESSFUL OUTPUT"
    Unload Me
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

Private Function FilterCriteria() As Collection
    Dim sqlCollection As New Collection
    Dim strCriteria As String
    Dim params As Object
    
    Set params = CreateObject("Scripting.Dictionary")
    strCriteria = "1 = 1"
            
    If Len(Me.MakeCbo) > 0 Then
        strCriteria = strCriteria & " AND make = ?"
        params.Add "Makeparam", Me.MakeCbo
    End If

    If Len(Me.ModelCbo) > 0 Then
        strCriteria = strCriteria & " AND model= ?"
        params.Add "Modelparam", Me.ModelCbo
    End If

    If Len(Me.YearStartTxt) > 0 And Len(Me.YearEndTxt) > 0 Then
        strCriteria = strCriteria & " AND [Year] BETWEEN ? AND ?"
        params.Add "YearStartparam", Me.YearStartTxt
        params.Add "YearEndparam", Me.YearEndTxt
    End If

    If Len(Me.EngineCbo) > 0 Then
        strCriteria = strCriteria & " AND engId= ? "
        params.Add "Engineparam", Me.EngineCbo
    End If

    If Len(Me.TransmissionCbo) > 0 Then
        strCriteria = strCriteria & " AND trany = ?"
        params.Add "Transparam", Me.TransmissionCbo
    End If

    If Len(Me.FuelTypeCbo) > 0 Then
        strCriteria = strCriteria & " AND fueltype = ?"
        params.Add "Fuelparam", Me.FuelTypeCbo
    End If

    sqlCollection.Add strCriteria
    sqlCollection.Add params
    
    Set FilterCriteria = sqlCollection
    
End Function

Private Sub UserForm_Deactivate()

    ' FREE RESOURCES
    rst.Close
    Set rst = Nothing
    Set cmd = Nothing
    Set conn = Nothing
    
End Sub

Private Sub UserForm_Initialize()
On Error GoTo ErrHandle
    Set conn = CreateObject("ADODB.Connection")
    Set rst = CreateObject("ADODB.Recordset")
    
    conn.Open "DRIVER=SQLite3 ODBC Driver;Database=" & ActiveWorkbook.Path & "\DATA\Vehicles.db;"
    rst.Open "SELECT DISTINCT [Make] FROM vehicles ORDER BY [Make];", conn
    
    rst.MoveFirst
    Do While Not rst.EOF
        Me.MakeCbo.AddItem rst![Make]
        rst.MoveNext
    Loop
    rst.Close
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

