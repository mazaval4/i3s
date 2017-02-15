VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub RemoveRows()

Dim i As Integer

i = 1

Do While i <= 500

    If ActiveWorkbook.ActiveSheet.Range("H2").Value < "0.01" Then
        ActiveWorkbook.ActiveSheet.Rows(2).EntireRow.Delete
    End If
    
    i = i + 1
    
Loop

End Sub

Sub GetAvg()

Dim segments As Integer

segments = 6


Dim count As Integer

Dim segment_len As Integer

Dim total_rows As Long

Dim name As String

Dim mode As Integer

Dim student_num As Integer

With ActiveWorkbook.ActiveSheet

    name = .Cells(2, 1).Value

    mode = Right(name, 1)
    
    student_num = Left(Right(name, 6), 1)

    total_rows = .Rows.count
    
    count = WorksheetFunction.count(.Range(.Cells(2, 8), .Cells(total_rows, 8)))
    
    segment_len = WorksheetFunction.RoundUp(count / segments, 0)
    
    'temp
    .Range("B227").Value = segment_len
    .Range("C227").Value = student_num
    .Range("D227").Value = mode
    
    Dim segment As Range
    
    Dim avg As Double
    
    Dim cols_to_avg As Variant
                        
    cols_to_avg = Array(8, 10, 15, 16, 17, 35)
        '(Velocity, Lane Changing, Steering, Acceleration, Braking, Headway Distance)
    
    For j = 0 To UBound(cols_to_avg)
        
        For i = 0 To segments - 1
        
            Set segment = .Range(.Cells(2 + i * segment_len, cols_to_avg(j)), .Cells(1 + (i + 1) * segment_len, cols_to_avg(j)))
            
            avg = WorksheetFunction.Average(segment)
            
            .Range("A228").Cells(i + 1, 1 + j) = avg
                    
        Next i
        
    Next j
    
End With

End Sub

