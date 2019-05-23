'VBA module used to perform stock data analysis using excel
'Author Juan Pablo Castellanos

Type DataCont
    'Structure used as data container for
    'lower or higher value comparison
     Init As Boolean    'When set to true means the value is unitized
     ContVal As Double  'Value for the item to record
     Ticker As String   'Ticker associated to the value
End Type


Private Sub InitDatCont(ByRef Container As DataCont)
    'Function used to initialize a data container
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

Private Sub UpdateGratest(ByRef MyWs As Worksheet, ByRef MyInc As DataCont, ByRef MyDec As DataCont, ByRef MyVol As DataCont)
    'Function used to update the greatest values
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
    Dim ColumnIndex As Integer
    Dim RowIndex As Integer

    'Headers moving arround columns
    ColumnIndex = ColumnStart
    RowIndex = RowStart
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Category"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Ticker"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Value"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    'Update Greatest increase
    ColumnIndex = ColumnStart
    RowIndex = RowIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest % Increase"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyInc.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyInc.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).NumberFormat = "0.00%"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    'Update Greatest decrease
    ColumnIndex = ColumnStart
    RowIndex = RowIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest % Decrease"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyDec.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyDec.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).NumberFormat = "0.00%"
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    'Update Greatest Volume
    ColumnIndex = ColumnStart
    RowIndex = RowIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = "Greatest Total Volume"
    MyWs.Cells(RowIndex, ColumnIndex).Font.Bold = True
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyVol.Ticker
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
    ColumnIndex = ColumnIndex + 1
    MyWs.Cells(RowIndex, ColumnIndex).Value = MyVol.ContVal
    MyWs.Cells(RowIndex, ColumnIndex).EntireColumn.AutoFit
End Sub

Private Sub EraseTable(ByRef MWs As Worksheet, RowPar As Long, ColPar As Long)
    'Function used to erase a table, a column and row are passed as
    'parameters for the upper left corner of the table. The function
    'will iterate columns and rows until it finds and empty cells and
    'erase the content in the matrix
    '
    'Args:
    '   MWs (Worksheet):   Reference to the worksheet
    '   RowPar (Long):      Row for upper left corner of the table to erase
    '   ColPar (Long):      Column for upper left corner of the table to erase
    'Returns:
    '   None
    'Variable used for sheet management
    'Row and Columns variables 
    Dim RowIndex As Long
    Dim ColIndex As Long
    
    'Init row and column for table erasing
    RowIndex = RowPar
    ColIndex = ColPar

    ' [-] Row loop
    While Not IsEmpty(MWs.Cells(RowIndex, ColIndex).Value)
        '  Reset the colum value for each row iteration
         ColIndex = ColPar
        ' [-] Column loop
        While Not IsEmpty(MWs.Cells(RowIndex, ColIndex).Value)
            'Clear the cell value and format
            MWs.Cells(RowIndex, ColIndex).ClearContents
            MWs.Cells(RowIndex, ColIndex).ClearFormats
            ' Increment the column value
            ColIndex = ColIndex + 1
        Wend
        ' Increment the row value, move to the next row
        RowIndex = RowIndex + 1
        ' Reset Colum Value to avoid exit the loop
        ColIndex = ColPar
    Wend
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
        ' Check if the ticker is diferent, adding OpenStock to the if condition to ignore 0 values for Open Stock
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
            'Calculate Percentage change if OpenStock set to 0 display a message
            If OpenStock Then
                PercentChange = StockDiff / OpenStock
            Else
                MsgStr = "Program not able to ignore open stock set to 0"
                MsgBox MsgStr, vbCritical, "Null Open Stock"
                PercentChange = StockDiff
            End If
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


Sub StockAnalysis()
    'Function used to perform the data analysis per workbook
    'every sheet will be opened and processed looking for the
    'same parameters. A message will be displayed after the
    'analysis is performed 
    'Args:
    '   None
    'Returns:
    '   None 
    For Each CurrentWs In Worksheets
        TotalVal CurrentWs.Name
    Next
    MsgBox "Stock analysis completed", vbInformation, "Operation completed"
End Sub

Sub CleanStockAnalysis()
    'Function used to clear the data analysis per workbook
    'every sheet will be opened and processed looking for the
    'same parameters. A message will be displayed after the
    'analysis clean up is performed 
    'Args:
    '   None
    'Returns:
    '   None 
    Const SumTableRow As Integer = 1
    Const SumTableCol As Integer = 9
    Const MaxTableRow As Integer = 1
    Const MaxTableCol As Integer = 14
    Dim MWs As Worksheet
    For Each CurrentWs In Worksheets
        Set MWs = ActiveWorkbook.Worksheets(CurrentWs.Name)
        EraseTable MWs:=MWs, RowPar:=SumTableRow, ColPar:=SumTableCol
        EraseTable MWs:=MWs, RowPar:=MaxTableRow, ColPar:=MaxTableCol
    Next
    MsgBox "Stock analysis clean up completed", vbInformation, "Operation completed"
End Sub


Public Sub AnalysisSelection()
    'Function as entry point for the macro, a really simple GUI
    'was implemented using InputBox interface 
    'Args:
    '   None
    'Returns:
    '   None     
    Dim myInputBoxVariable As String
    myInputBoxVariable = InputBox("Please type the number for one of the following options" & vbLf & vbLf & "1. Perform stock analysis" & vbLf & "2. Clean stock analysis ")
    Select Case myInputBoxVariable
            Case 1
                StockAnalysis
            Case 2
                CleanStockAnalysis
            Case Else
                MsgBox "No operation was performed", vbCritical, "Warning"
        End Select
End Sub


