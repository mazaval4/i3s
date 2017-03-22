Attribute VB_Name = "Module1"
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
    segments = 6
    
    Dim xlApp As Excel.Application
    Set xlApp = New Excel.Application
    
    Dim count As Integer
    Dim segment_len As Integer
    Dim total_rows As Long
    Dim name As String
    Dim mode As Integer
    Dim student_num As Integer
    
    Dim database_file As Workbook
    Set database_file = ThisWorkbook
    
    Dim dataset_base_row As Integer
    dataset_base_row = WorksheetFunction.count(ThisWorkbook.Worksheets(1).Range("H2:H500")) + 2
    
    Dim index As Integer
    index = 1
    Dim k As Integer
    For k = 1 To Workbooks.count
        If Not Workbooks(index).name = database_file.name Then
            Dim book As Workbook
            Set book = Workbooks(index)
            Call RemoveRows(book)
            With book.Worksheets(1)
                '**Get number and mode and add them to the database
                name = .Cells(2, 1).Value
                mode = Right(name, 1)
                name = Replace(name, "Mode" + CStr(mode), "")
                name = Replace(name, "mode" + CStr(mode), "")
                name = Replace(name, "students", "")
                name = Replace(name, "student", "")
                name = Replace(name, "Student", "")
                name = Replace(name, "Students", "")
                student_num = CInt(name)
                
                Dim j As Integer
                For j = 0 To segments - 1
                    'Fill student num and mode
                    ThisWorkbook.Worksheets(1).Cells(j + dataset_base_row, 1) = CStr(student_num)
                    ThisWorkbook.Worksheets(1).Cells(j + dataset_base_row, 2) = mode
                Next j
            
                '**Get results and add them to the database
                Dim result_address As Range
                Set result_address = ThisWorkbook.Worksheets(2).Cells(1, 1)
                For Each rw In ThisWorkbook.Worksheets(2).Rows
                    If rw.Cells(1, 4).Value = "Student " + CStr(student_num) Then
                        Set result_address = rw.Cells(3, 3)
                        Exit For
                    End If
                Next rw
                
                Dim i As Integer
                'Populate Respose Times and errors
                For i = 0 To segments - 1
                    'CStr(mode) + "," + CStr(1 + i * 3)
                    database_file.Sheets("Sheet1").Cells(i + dataset_base_row, 5).Value = result_address.Cells(mode, 1 + i * 3)
                    database_file.Sheets("Sheet1").Cells(i + dataset_base_row, 4).Value = result_address.Cells(mode, 3 + i * 3)
                Next i
    
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
                For i = 0 To segments - 1
                    Dim segment As Range
                    Dim avg As Double
                    With book.Worksheets(1)
                        Set segment = .Range(.Cells(2 + i * segment_len, cols_to_avg(j)), .Cells(1 + (i + 1) * segment_len, cols_to_avg(j)))
                    End With
                    
                    database_file.Sheets("Sheet1").Cells(i + dataset_base_row, col_addresses(j)).Value = 0
                    On Error GoTo Handler
                    avg = xlApp.WorksheetFunction.Sum(segment) / segment.count
                    database_file.Sheets("Sheet1").Cells(i + dataset_base_row, col_addresses(j)).Value = avg
Handler:
                Next i
            Next j
            dataset_base_row = dataset_base_row + segments
            Call SaveCloseBook(book)
        Else
            index = index + 1
        End If
    Next k
End Sub


Sub SaveCloseBook(Wkb As Workbook)
    If Not Wkb.ReadOnly And Windows(Wkb.name).Visible Then
        Wkb.Save
        If Not Wkb.name = ThisWorkbook.name Then
            Wkb.Close
        End If
    End If
End Sub
