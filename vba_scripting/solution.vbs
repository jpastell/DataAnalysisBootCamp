'Structure used as data container for
'lower or higer value comparison
Type DataCont
     Init As Boolean    'When set to true means the value is initlized
     ContVal As Double  'Value dfor the item to recond
     Ticker As String   'Ticker associated to teh value
End Type


Private Sub InitDatCont(ByRef Container As DataCont)
    'Function used to initilize a data container
    'Args:
    '  Container (DataCont): Container reference to the container
    'Returns:
    '   None
    Container.Init = False
    Container.ContVal = 0
    Container.Ticker = ""
End Sub

Private Sub UpdateMax(ByRef Container As DataCont, Ticker As String, NewVal As Double)
    'Function used to update the container if the input is higher
    'Args:
    '   Container (DataCont): Container reference to the container
    '   Ticker (String) :   Ticker associated to the value to compare
    '   NewVal (Double) :   Value to compare
    'Returns:
    '   None

    If Container.Init Then
        If NewVal > Container.ContVal Then
            Container.ContVal = NewVal
            Container.Ticker = Ticker
        End If
    Else
        Container.ContVal = NewVal
        Container.Init = True
    End If
End Sub

Private Sub UpdateMin(ByRef Container As DataCont, Ticker As String, NewVal As Double)
    'Function used to update the container if the input is lower
    'Args:
    '   Container (DataCont): Container reference to the container
    '   Ticker (String) :   Ticker associated to the value to compare
    '   NewVal (Double) :   Value to compare
    'Returns:
    '   None

    If Container.Init Then
        If NewVal < Container.ContVal Then
            Container.ContVal = NewVal
            Container.Ticker = Ticker
        End If
    Else
        Container.ContVal = NewVal
        Container.Init = True
    End If
End Sub

Private Sub UpdateGratest(ByRef MyWs As Worksheet, ByRef MyInc  As DataCont, ByRef MyDec  As DataCont, ByRef MyVol  As DataCont)
    'Function used to update the gratest values
    'Args:
    '   MyWs (Worksheet):   Reference to the worksheet
    '   MyInc (DataCont):   Reference to the greatest increase
    '   MyDec (DataCont):   Reference to the greatest decrease
    '   MyVol (DataCont):   Reference to the greatest total volume
    'Returns:
    '   None

    'Constant x,y coordinates to populate the summary
    Const RowStart As Integer = 1
    Const ColumnStart As Integer = 14
    'Varibale to move arround the table
    Dim ColumnIndex as Integer
    Dim RowIndex as Integer

    'Headers moving arround columns
    ColumnIndex = ColumnStart
    RowIndex = RowStart
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Category"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Ticker"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Value"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    'Update Greatest increase
    ColumnIndex = ColumnStart
    RowIndex = RowIndex+1 
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest % Increase"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyInc.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyInc.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).NumberFormat = "0.00%"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    'Update Greatest decrease
    ColumnIndex = ColumnStart
    RowIndex = RowIndex+1 
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest % Decrease"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyDec.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyDec.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).NumberFormat = "0.00%"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    'Update Greatest Volume
    ColumnIndex = ColumnStart
    RowIndex = RowIndex+1 
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest Total Volume"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyVol.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex=ColumnIndex+1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyVol.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
End Sub



Private Sub TotalVal(SheetName As String)
    'Function used to perform the data analysis per sheet
    'Args:
    '   SheetName (string) : name of the worksheet to process
    'Returns:
    '   None

    '-----------------------------------------
    'Constant definition
    '-----------------------------------------
    'Row and colum start for Ticker
    Const TickerRowStart As Integer = 2
    Const TickerColumnIndex As Integer = 1
    'Row and Column definition for results
    Const SumTickerHeaderColumn As Integer = 9
    Const YearChangeHeadColumn As Integer = 10
    Const PerChgHeader As Integer = 11
    Const TotalVolHeaderColumn As Integer = 12
    Const RowStartSumart As Integer = 2
    Const RowSumHeader As Integer = RowStartSumart - 1
    'Open Stock Column
    Const OpenStockColumn As Integer = 3
    'Close Stock Column
    Const CloseStockColumn As Integer = 6
    'Column defined for volume
    Const VolumneColumn As Integer = 7
    '-----------------------------------------
    'Variable definition
    '-----------------------------------------
    ' Variable used to iterate using rows
    Dim RowIndex As Long
    'Varible used to place yhe ticker summary
    Dim RowSumIndex As Long
    'Variable used to save the total Volume
    Dim VolVal As Double
    'String for messaging
    Dim MsgStr As String
    'Variable used for accessing the work-sheet
    Dim MWs As Worksheet
    'Open year stock
    Dim OpenStock As Double
    'Close year stock
    Dim StockDiff As Double
    'Percent change
    Dim PercentChange As Double
    'Variable used to store ticker name
    Dim TickerName As String
    'Varibles used to get the max increase
    Dim MaxInc As DataCont
    'Varibles used to get the max decrease
    Dim MaxDec As DataCont
    'Variable used to get the max volume
    Dim MaxVol As DataCont
    '-----------------------------------------
    
    'Construct the work sheet object
    Set MWs = ActiveWorkbook.Worksheets(SheetName)
    
    'Initilize the iterator to the first intex
    RowIndex = TickerRowStart
    'Initilize the volume value to 0
    VolVal = 0
    'Initilize the iteraot for displayig results
    RowSumIndex = RowStartSumart
    'Initialize the open stock value
    OpenStock = MWs.Cells(RowIndex, OpenStockColumn).Value

    'Initilize the variables for max calulation
    InitDatCont Container:=MaxInc
    InitDatCont Container:=MaxDec
    InitDatCont Container:=MaxVol

    'Set the headers for summary
    '[-]Protect aginst negative values for the header
    If RowStartSumart > 1 Then
        'Enougth space, set the headers and format
        '[-] Ticker
        MWs.Cells(RowSumHeader, SumTickerHeaderColumn).Value = "Ticker"
        MWs.Cells(RowSumHeader, SumTickerHeaderColumn).EntireColumn.AutoFit
        MWs.Cells(RowSumHeader, SumTickerHeaderColumn).Font.Bold = True
        '[-] Total Volume
        MWs.Cells(RowSumHeader, TotalVolHeaderColumn).Value = "Total Stock Volume"
        MWs.Cells(RowSumHeader, TotalVolHeaderColumn).EntireColumn.AutoFit
        MWs.Cells(RowSumHeader, TotalVolHeaderColumn).Font.Bold = True
        '[-] Year Change
        MWs.Cells(RowSumHeader, YearChangeHeadColumn).Value = "Yearly Change"
        MWs.Cells(RowSumHeader, YearChangeHeadColumn).EntireColumn.AutoFit
        MWs.Cells(RowSumHeader, YearChangeHeadColumn).Font.Bold = True
        '[-] Year Change
        MWs.Cells(RowSumHeader, PerChgHeader).Value = "Percentage Change"
        MWs.Cells(RowSumHeader, PerChgHeader).EntireColumn.AutoFit
        MWs.Cells(RowSumHeader, PerChgHeader).Font.Bold = True
    Else
        'Display warning
        MsgStr = "Not enough space to set the headers plase update "
        MsgStr = MsgStr + "RowStartSumart with a value higer than 1"
        MsgBox MsgStr, vbCritical, "Header error:"
    End If
    
    '[-] This loop iterates the RowIndex
    While Not IsEmpty(MWs.Cells(RowIndex, TickerColumnIndex).Value)
        'It is not necesary to check if the next row is empty in excel
        'Capture the current value
        VolVal = VolVal + MWs.Cells(RowIndex, VolumneColumn).Value
        ' Check if the ticker is diferent
        If MWs.Cells(RowIndex, TickerColumnIndex).Value <> MWs.Cells(RowIndex + 1, TickerColumnIndex).Value And OpenStock Then
            'Update the total value in the proper cell
            TickerName = MWs.Cells(RowIndex, TickerColumnIndex).Value
            MWs.Cells(RowSumIndex, SumTickerHeaderColumn).Value = TickerName
            MWs.Cells(RowSumIndex, TotalVolHeaderColumn).Value = VolVal
            'Now that volume has been updated, update the data container asociated with volume
            UpdateMax Container:=MaxVol, Ticker:=TickerName, NewVal:=VolVal
            'Calculate the stock diference and percentage change
            'Get the close value
            StockDiff = MWs.Cells(RowIndex, CloseStockColumn).Value
            StockDiff = StockDiff - OpenStock
            'Calculate Percentage change
            'If OpenStock Then
            '    PercentChange = StockDiff / OpenStock
            'Else
            '    PercentChange = StockDiff
            'End If
            'Update cells
            PercentChange = StockDiff / OpenStock
            '[-]   Percentage
            MWs.Cells(RowSumIndex, PerChgHeader).Value = PercentChange
            MWs.Cells(RowSumIndex, PerChgHeader).NumberFormat = "0.00%"
            'Once the percentage is calculated, update the max values
            UpdateMax Container:=MaxInc, Ticker:=TickerName, NewVal:=PercentChange
            'Once the percentage is calculated, update the min values
            UpdateMin Container:=MaxDec, Ticker:=TickerName, NewVal:=PercentChange
            '[-]   Stock diference
            MWs.Cells(RowSumIndex, YearChangeHeadColumn).Value = StockDiff
            If StockDiff < 0 Then
                MWs.Cells(RowSumIndex, YearChangeHeadColumn).Interior.Color = RGB(245, 183, 177)
                MWs.Cells(RowSumIndex, YearChangeHeadColumn).Font.Color = RGB(148, 49, 38)
            Else
                MWs.Cells(RowSumIndex, YearChangeHeadColumn).Interior.Color = RGB(169, 223, 191)
                MWs.Cells(RowSumIndex, YearChangeHeadColumn).Font.Color = RGB(25, 111, 61)
            End If
            ' Update the row for display
            RowSumIndex = RowSumIndex + 1
            'Get the new Open value
            OpenStock = MWs.Cells(RowIndex + 1, OpenStockColumn).Value
            'Reset the total value
            VolVal = 0
        End If
        ' Increment the row value, move to the next row
        RowIndex = RowIndex + 1
    Wend
    '------------------------------------------------
    'Update the results for the totals
    UpdateGratest MyWs:=MWs, MyInc:=MaxInc, MyDec:=MaxDec, MyVol:=MaxVol

End Sub


Sub Stocks()
    Dim t As Single
    t = Timer
    For Each CurrentWs In Worksheets
        TotalVal CurrentWs.Name
    Next
    MsgBox Timer - t
End Sub




