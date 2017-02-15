VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub RemoveRows(book As Workbook)

Dim i As Integer

i = 1

Do While i <= 500

    If book.Worksheets(1).Range("H2").Value < "0.01" Then
        book.Worksheets(1).Rows(2).EntireRow.Delete
    Else
        Exit Do
    End If
    
    i = i + 1
    
Loop

End Sub

Sub GetAvg()

Dim segments As Integer

segments = 5


Dim count As Integer

Dim segment_len As Integer

Dim total_rows As Long

Dim name As String

Dim mode As Integer

Dim student_num As Integer

Dim database_file As Workbook

Set database_file = ThisWorkbook

Dim dataset_base_row As Integer

dataset_base_row = 2
Dim k As Integer
For k = 1 To Workbooks.count - 1

    If Not Workbooks(k).name = database_file.name Then
    
        Dim book As Workbook
        
        Set book = Workbooks(k)
                               
        Call RemoveRows(book)
    
        With book.Worksheets(1)
        
            '**Get number and mode and add them to the database
        
            name = .Cells(2, 1).Value
        
            mode = Right(name, 1)
            
            student_num = Left(Right(name, 6), 1)
            Dim j As Integer
            For j = 0 To segments - 1
            'Fill student num and mode
                            
                ThisWorkbook.Worksheets(1).Cells(j + dataset_base_row, 1) = "Student " + CStr(student_num)
                
                ThisWorkbook.Worksheets(1).Cells(j + dataset_base_row, 2) = mode
            
            Next j
        
            '**Get results and add them to the database
            'Dim result_address As Range
            
            'result_address = ThisWorkbook.Worksheets(2).Cells(1, 1)
            
            'For Each Row In ThisWorkbook.Worksheets(2).Rows
            
            '    If Row.Cells(1, 4).Value = "Student " + CStr(student_num) Then
                
            '        result_address = Row.Cells(3, 3)
                    
            '        Exit For
                
            '    End If
            
            'Next Row
            
            

            '**Get averages and add them to the database

            total_rows = .Rows.count
            
            count = WorksheetFunction.count(.Range(.Cells(2, 8), .Cells(total_rows, 8)))
            
        End With
        
        segment_len = WorksheetFunction.RoundUp(count / segments, 0)
                    
        
        Dim cols_to_avg As Variant
        cols_to_avg = Array(8, 10, 15, 16, 17, 35)
            '(Velocity, Lane Changing, Steering, Acceleration, Braking, Headway Distance)
        Dim col_addresses As Variant
        col_addresses = Array(3, 12, 10, 9, 8, 11)
        
        For j = 0 To UBound(cols_to_avg)
            Dim i As Integer
            For i = 0 To segments - 1
                
                Dim segment As Range
    
                Dim avg As Double
    
                With book.Worksheets(1)
                    Set segment = .Range(.Cells(2 + i * segment_len, cols_to_avg(j)), .Cells(1 + (i + 1) * segment_len, cols_to_avg(j)))
                End With
                
                avg = WorksheetFunction.Average(segment)
                
                database_file.Sheets("Sheet1").Cells(i + dataset_base_row, col_addresses(j)).Value = avg
                        
            Next i
            
        Next j
                        
    dataset_base_row = dataset_base_row + segments

    End If
        
Next k

End Sub


