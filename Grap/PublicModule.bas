Attribute VB_Name = "PublicModule"

'도움말을 쓰기 위한 함수
Public Declare Function ShellExecute _
 Lib "shell32.dll" _
 Alias "ShellExecuteA" ( _
 ByVal hwnd As Long, _
 ByVal lpOperation As String, _
 ByVal lpFile As String, _
 ByVal lpParameters As String, _
 ByVal lpDirectory As String, _
 ByVal nShowCmd As Long) _
 As Long

Function SelectedVariable(ParentDlgLbxValue, SelVar, _
         IsRowData As Boolean) As String
   
   Dim temp, m2, m3 As Long
   Dim TempSheet As Worksheet
   Dim tmp2, tmp As Range
   
   Set TempSheet = ActiveCell.Worksheet
   
   Dim Chk_Ver As Boolean
   Dim Cmp_R As Long
   Dim Cmp_C As Integer
   
   '파일 버전에 따른 행과 열의 비교값 정의,
   Chk_Ver = ChkVersion(ActiveWorkbook.Name)
   If Chk_Ver = True Then
        Cmp_R = 1048576
        Cmp_C = 16384
    Else
        Cmp_R = 65536
        Cmp_C = 256
    End If
    
   If IsRowData = True Then
       ' temp = Cells.CurrentRegion.Columns.Count
       temp = TempSheet.UsedRange.Columns.count
        For j = 1 To temp
           If StrComp(ParentDlgLbxValue, TempSheet.Cells(1, j).Value, 1) = 0 Then       'strcomp - 비교문 ,( str , str , [-1,0,1])
              Set tmp2 = TempSheet.Columns(j)
              m2 = tmp2.Cells(1, 1).End(xlDown).row
              If m2 <> Cmp_R Then
                 m3 = tmp2.Cells(m2, 1).End(xlDown).row
                 If m3 <> Cmp_R Then m2 = m3
              End If
              Set tmp = tmp2.Range(Cells(2, 1), Cells(m2, 1))
           End If
        Next j
   Else
        temp = Cells.CurrentRegion.Rows.count
        For j = 1 To temp
           If StrComp(ParentDlgLbxValue, TempSheet.Cells(j, 1).Value, 1) = 0 Then
              Set tmp2 = TempSheet.Rows(j)
              m2 = tmp2.Cells(1, 1).End(xlToRight).Column
              If m2 <> Cmp_C Then
                 m3 = tmp2.Cells(1, m2).End(xlToRight).Column
                 If m3 <> Cmp_C Then m2 = m3
              End If
              Set tmp = tmp2.Range(Cells(1, 2), Cells(1, m2))
           End If
        Next j
   End If
    
   Set SelVar = tmp
   
   If IsNull(ParentDlgLbxValue) = True Then
        SelectedVariable = ""
   Else: SelectedVariable = ParentDlgLbxValue
   End If

End Function

Sub SelectMultiRange(ParentDlg, Rn, Vname, _
        Optional ColumnNum As Integer = 0)
   
   Dim Cnt, temp, m2, m3, i, j As Long
   Dim TempSheet As Worksheet
   Dim tmp2 As Range
   
   Cnt = ParentDlg.ListBox2.ListCount
   Set TempSheet = ActiveSheet

   Dim Chk_Ver As Boolean   '파일 버전 체크
   Dim Cmp_R As Long        '파일 버전에 따른 비교 행의 값
   Dim Cmp_C As Integer     '파일 버전에 따른 비교 열의 값
   
   '파일 버전에 따른 행과 열의 비교값 정의
   Chk_Ver = ChkVersion(ActiveWorkbook.Name)
   If Chk_Ver = True Then
        Cmp_R = 1048576
        Cmp_C = 16384
    Else
        Cmp_R = 65536
        Cmp_C = 256
    End If
    
   'If ParentDlg.OptionButton1.Value = True Then
        temp = Cells.CurrentRegion.Columns.count
        For i = 1 To Cnt
            For j = 1 To temp
               If StrComp(ParentDlg.ListBox2.List(i - 1, ColumnNum), TempSheet.Cells(1, j).Value, 1) = 0 Then
                  Set tmp2 = TempSheet.Columns(j)
                  m2 = tmp2.Cells(1, 1).End(xlDown).row
                  If m2 <> Cmp_R Then
                     m3 = tmp2.Cells(m2, 1).End(xlDown).row
                     If m3 <> Cmp_R Then m2 = m3
                  End If
                  Set Rn(i) = tmp2.Range(Cells(2, 1), Cells(m2, 1))
                  Vname(i) = ParentDlg.ListBox2.List(i - 1, ColumnNum)
               End If
            Next j
        Next i

   
End Sub

'''SheetName의 시트를 만든다.
'''이미 만들어져 있을 경우는 다시 만들지 않는다.
'''A1셀에 인쇄할 장소를 적어둔다.
Sub OpenOutSheet(SheetName, Optional IsAddress As Boolean = False)
    
    Dim s, CurS As Worksheet
    
    Application.ScreenUpdating = False
    For Each s In ActiveWorkbook.Sheets
        If s.Name = SheetName Then Exit Sub
    Next s
    Set CurS = ActiveSheet: Set s = Worksheets.Add
    With ActiveWindow
        .DisplayGridlines = False
'        .DisplayHeadings = False
    End With
    
    With Cells
         .Font.Name = "굴림"
         .Font.Size = 9
         .HorizontalAlignment = xlRight
    End With

    s.Name = SheetName: CurS.Activate
    With Worksheets(SheetName).Range("a1")
        .Value = 2
        '''If IsAddress = True Then .Value = "A2"
        .Font.ColorIndex = 2
    End With
    Worksheets(SheetName).Rows(1).Hidden = True

    's.Protect Password:="prophet", DrawingObjects:=False, contents:=True, Scenarios:=True
    Application.ScreenUpdating = True
    
End Sub

Sub ChartOutControl(PrintPosi, StartIndex As Boolean)               ''''"_그래프출력_"

    Static s As Worksheet
    Static position As Range
    
    On Error GoTo sbcError
    If StartIndex = True Then
        OpenOutSheet "_통계분석결과_"
        Set s = Worksheets("_통계분석결과_")
        Set position = s.Range("a1")
        PrintPosi(0) = s.Cells(position.Value + 6, 2).Left
        PrintPosi(1) = s.Cells(position.Value + 6, 2).Top
    Else
        's.Unprotect "prophet"
        '''이때는 PrintPosi가 차트의 세로길이를 나타내는 인자임.
        position.Value = position.Value + Int(PrintPosi / s.Range("a2").Height) + 4
        's.Protect Password:="prophet", DrawingObjects:=False, contents:=True, Scenarios:=True
    End If
    Exit Sub

sbcError:
    MsgBox "출력시트를 정할 수 없습니다." & Chr(10) & _
    "[_통계분석결과_]이라는 이름의 시트를 삭제해 주십시오.", vbExclamation, title:="출력 오류"

End Sub

Sub Title1(OutputSheet, contents As String)
    Dim Flag As Long
    Dim mySheet As Worksheet
    Dim tmpSign
    
    '''
    tmpSign = 0
    Set mySheet = OutputSheet
    If Left(mySheet.Range("a1"), 1) = "$" Then
        mySheet.Cells(1, 1) = Right(mySheet.Cells(1, 1).Value, Len(mySheet.Cells(1, 1).Value) - 3)
        tmpSign = 1
    End If
    
    Flag = mySheet.Cells(1, 1).Value
    yp = mySheet.Cells(Flag + 2, 1).Top
    
    On Error Resume Next
    
    Set title = mySheet.Shapes.AddShape(msoShapeRectangle, 3.75, yp + 2.25, 300, 25#)
    With title
        .Fill.ForeColor.SchemeColor = 9
        .Line.DashStyle = msoLineSolid
        .Line.Style = msoLineSingle
        .Line.Weight = 1
        .Line.Visible = msoTrue
        .Shadow.Type = msoShadow1
    End With
   
    With title.TextFrame.Characters
        .Text = contents
        .Font.Name = "굴림"
        .Font.FontStyle = "굵게"
        .Font.Size = 14
        .Font.ColorIndex = 41
    End With
    title.TextFrame.HorizontalAlignment = xlCenter
    
    mySheet.Cells(1, 1) = Flag + 4
    
    '''
    If tmpSign = 1 Then
        mySheet.Cells(1, 1) = "$A$" & mySheet.Cells(1, 1).Value
    End If
    
    
End Sub

Function FindingRangeError(Rn) As Boolean
    
    Dim tmp1 As Range: Dim tmp2 As Range
    Dim tmp3 As Range
    
    On Error Resume Next
    
    If Application.CountBlank(Rn) >= 1 Then
        FindingRangeError = True
        Exit Function
    End If
    Set tmp1 = Rn.SpecialCells(xlCellTypeConstants, 22)
    Set tmp2 = Rn.SpecialCells(xlCellTypeFormulas, 22)
    'Set tmp3 = Rn.SpecialCells(xlCellTypeBlanks)
    
    If Rn.count = 1 And IsNumeric(Rn.Cells(1, 1)) = True Then
        FindingRangeError = False
    Else
        If tmp1 Is Nothing And tmp2 Is Nothing Then             'And tmp3 Is Nothing then 앞에 붙여넣기
            FindingRangeError = False
        Else: FindingRangeError = True
        End If
    End If
    
End Function

Sub DlgShow1(ParentDlg As Object)
    
    Dim ErrSignforDataSheet As Integer
    
    ErrSignforDataSheet = InitializeDlg1(ParentDlg)
    
    Select Case ErrSignforDataSheet
    Case 0: ParentDlg.Show
    Case -1
        MsgBox "시트가 보호상태에 있습니다." & Chr(10) & _
               "데이타를 읽을 수 없습니다.", _
                vbExclamation, "HIST"
    Case 1
        MsgBox "시트에 데이타가 있는지 확인하십시오." & Chr(10) & _
               "1행1열부터 변수이름을 입력해야 합니다.", _
               vbExclamation, "HIST"
    Case Else
    End Select

End Sub
Function InitializeDlg1(ParentDlg) As Integer
   
   Dim myRange As Range: Dim Cnt As Long
   Dim myArray() As String
   
   On Error GoTo ErrorFlag
   
   Set myRange = ActiveSheet.Cells.CurrentRegion
   If myRange.count = 1 And myRange.Cells(1, 1) = "" Then
        InitializeDlg1 = 1: Exit Function
   End If
   Set myRange = ActiveSheet.Cells.CurrentRegion.Rows(1)
   ParentDlg.ListBox4.Clear: ParentDlg.ListBox5.Clear
   Cnt = myRange.Cells.count
   
   ReDim myArray(0 To Cnt - 1)
   For i = 1 To Cnt
     myArray(i - 1) = myRange.Cells(i)
   Next i
   ParentDlg.ListBox4.List() = myArray
   InitializeDlg1 = 0
   Exit Function
   
ErrorFlag:
   InitializeDlg1 = -1
   
End Function
Sub SetUpforPage2(ParentDlg, opt As Integer)

   Dim myRange As Range: Dim Cnt As Long
   Dim myArray() As String
   
   Set myRange = ActiveSheet.Cells.CurrentRegion.Rows(1)
   ParentDlg.ListBox1.Clear: ParentDlg.ListBox2.Clear: ParentDlg.ListBox3.Clear
   If opt = 2 Then
        ParentDlg.ListBox4.Clear
        ParentDlg.CommandButton19.Visible = False
        ParentDlg.CommandButton18.Visible = True
   End If
   'If opt <> 3 Then ParentDlg.CheckBox2.Value = True
   'ParentDlg.CheckBox3.Value = True
   'If opt = 3 Then ParentDlg.CheckBox4.Value = True
   'ParentDlg.CommandButton13.Visible = False
   'ParentDlg.CommandButton12.Visible = True
   'ParentDlg.CommandButton14.Visible = False
   'ParentDlg.CommandButton11.Visible = True
   Cnt = myRange.Cells.count
   
   
   ReDim myArray(0 To Cnt - 1)
   For i = 1 To Cnt
     myArray(i - 1) = myRange.Cells(i)
   Next i
   ParentDlg.ListBox1.List() = myArray
   
End Sub




'''DlgOpt=1:히스토그램의 경우
'''DlgOpt=2:줄기잎그림의 경우
'''DlgOpt=3:상자그림의 경우
'''DlgOpt=4:산점도의 경우
'''DlgOpt=5,6:t-검정의 경우
'''DlgOpt=7:기초통계량 계산
Sub DlgShow(ParentDlg As Object, DlgOpt As Integer)
    
    Dim ErrSignforDataSheet As Integer
    
    ErrSignforDataSheet = InitializeDlg(ParentDlg, DlgOpt)
    
    Select Case ErrSignforDataSheet
    Case 0: ParentDlg.Show
    Case -1
        MsgBox "시트가 보호상태에 있습니다." & Chr(10) & _
               "데이타를 읽을 수 없습니다.", _
                vbExclamation, "HIST"
    Case 1
        MsgBox "시트에 데이타가 있는지 확인하십시오." & Chr(10) & _
               "1행1열부터 변수이름을 입력해야 합니다.", _
               vbExclamation, "HIST"
    Case Else
    End Select

End Sub
Function InitializeDlg(ParentDlg, DlgOpt As Integer) As Integer
   
   Dim myRange As Range: Dim Cnt As Long
   Dim myArray() As String
   
   On Error GoTo ErrorFlag
   
   Set myRange = ActiveSheet.Cells.CurrentRegion
   If myRange.count = 1 And myRange.Cells(1, 1) = "" Then
        InitializeDlg = 1: Exit Function
   End If
   Set myRange = ActiveSheet.Cells.CurrentRegion.Rows(1)
   ParentDlg.ListBox1.Clear
   If DlgOpt = 1 Then
        ParentDlg.OptionButton1 = True
        ParentDlg.Image1.Picture = LoadPicture("")
   ElseIf DlgOpt = 2 Then
        ParentDlg.ListBox1.Clear: ParentDlg.Previewtxt.Text = ""
        ParentDlg.OptionButton1 = True
   ElseIf DlgOpt = 4 Then
        ParentDlg.ListBox2.Clear: ParentDlg.ListBox3.Clear
        ParentDlg.CheckBox1.Value = False
        ParentDlg.CheckBox2.Value = True
        ParentDlg.CommandButton3.Visible = False
        ParentDlg.CommandButton2.Visible = True
        ParentDlg.CommandButton7.Visible = False
        ParentDlg.CommandButton1.Visible = True
   ElseIf DlgOpt = 5 Then
        ParentDlg.ListBox2.Clear
   ElseIf DlgOpt = 3 Or DlgOpt = 7 Then
        ParentDlg.ListBox2.Clear
        ParentDlg.OptionButton1 = True
   ElseIf DlgOpt = 6 Then
        ParentDlg.CommandButton3.Visible = False
        ParentDlg.CommandButton2.Visible = True
        ParentDlg.CommandButton7.Visible = False
        ParentDlg.CommandButton1.Visible = True
        ParentDlg.ListBox2.Clear
        ParentDlg.ListBox3.Clear
   End If
   Cnt = myRange.Cells.count
   
   ReDim myArray(0 To Cnt - 1)
   For i = 1 To Cnt
     myArray(i - 1) = myRange.Cells(i)
   Next i
   ParentDlg.ListBox1.List() = myArray
   InitializeDlg = 0
   Exit Function
   
ErrorFlag:
   InitializeDlg = -1
   
End Function

''임시시트 만들기
Function OpenTempWorkSheet(tmpWS As Worksheet, _
    WSName As String, Optional StartNum As Integer = 1) As Boolean
    
    Dim Flag As Boolean: Dim ws As Worksheet
    
    For Each ws In Worksheets
        If ws.Name = WSName Then
            Flag = True
            Set tmpWS = ws
            Exit For
        End If
    Next ws
    
    If Flag = False Then
        Set tmpWS = Worksheets.Add
        tmpWS.Name = WSName
        tmpWS.Cells(1, 1) = StartNum
        tmpWS.Visible = xlSheetHidden
    End If
    
    OpenTempWorkSheet = True
        
End Function

'''상태표시줄을 이용하여 프로그램 진행에 대한 정보주기
Sub SettingStatusBar(SettingChoice As Boolean, _
        Optional NewString As String = "")

    Static oldStatusBar As String
    
    If SettingChoice = True Then
        oldStatusBar = Application.DisplayStatusBar
        Application.DisplayStatusBar = True
        Application.StatusBar = NewString
    Else
        Application.StatusBar = False
        Application.DisplayStatusBar = oldStatusBar
    End If
    
End Sub

Sub MoveBtwnListBox(ParentD, FromLNum, ToLNum)

    Dim i As Integer
    i = 0
    Do While i <= ParentD.Controls(FromLNum).ListCount - 1
        If ParentD.Controls(FromLNum).Selected(i) = True Then
           ParentD.Controls(ToLNum).AddItem ParentD.Controls(FromLNum).List(i)
           ParentD.Controls(FromLNum).RemoveItem i
           i = i - 1
        End If
        i = i + 1
    Loop

End Sub

Sub OptBtn12Click(ParentD, IsColumn As Boolean)
   
   Dim myRange As Range
   Dim myArray()
   
   ParentD.ListBox1.Clear: ParentD.ListBox2.Clear
   If IsColumn = True Then
      Set myRange = Cells.CurrentRegion.Rows(1)
   Else
      Set myRange = Cells.CurrentRegion.Columns(1)
   End If
   Cnt = myRange.Cells.count
   ReDim myArray(Cnt - 1)
   For i = 1 To Cnt
     myArray(i - 1) = myRange.Cells(i)
   Next i
   ParentD.ListBox1.List() = myArray
   
End Sub

'''셀에 괘선을 그리기 위함.
Sub DesignOutPutCell(TargetCell, Direction, myLineStyle, _
    myWeight, myColorIndex)
    
    With TargetCell.Borders(Direction)
        .LineStyle = myLineStyle
        .Weight = myWeight
        .ColorIndex = myColorIndex
    End With

End Sub

'''축조절을 위한 함수
'''숫자 자리수만큼의 스트링을 만듬(음수일 경우만)
Function CStrNumPoint(DataWid, DataCount) As String
    
    Dim i As Integer: Dim LogScale As Double
    Dim temp As String
    
    i = 0: temp = "0."
    LogScale = Application.Power(10, _
             Int(Application.Log10(DataWid / DataCount)))
    If LogScale >= 1 Then
        CStrNumPoint = "0"
    Else
        Do
            temp = temp & "0": i = i + 1
            If LogScale = 10 ^ (-i) Then Exit Do
        Loop While (1)
        CStrNumPoint = CStr(temp)
    End If

End Function


'파일 버전 체크
Function ChkVersion(File_Name) As Boolean
    
    If Right(File_Name, 4) = ".xls" Or Right(File_Name, 4) = ".XLS" Then
        ChkVersion = False
    Else
        ChkVersion = True
    End If
End Function

'상자그림
Function FindingRangeError2(Rn) As Boolean
    
    Dim tmp1 As Range: Dim tmp2 As Range
    Dim tmp3 As Range
    
    On Error Resume Next
    
    If Application.CountBlank(Rn) >= 1 Then
        FindingRangeError2 = True
        Exit Function
    End If
    Set tmp1 = Rn.SpecialCells(xlCellTypeConstants, 22)
    Set tmp2 = Rn.SpecialCells(xlCellTypeFormulas, 22)
    Set tmp3 = Rn.SpecialCells(xlCellTypeBlanks)
    
    If Rn.count = 1 And IsNumeric(Rn.Cells(1, 1)) = True Then
        FindingRangeError2 = False
    Else
        If tmp1 Is Nothing And tmp2 Is Nothing And tmp3 Is Nothing Then
            FindingRangeError2 = False
        Else: FindingRangeError2 = True
        End If
    End If
    
End Function
Sub OpenOutSheet2(SheetName, Optional IsAddress As Boolean = False) ''파레토
    
    Dim s, CurS As Worksheet
    
    Application.ScreenUpdating = False
    For Each s In ActiveWorkbook.Sheets
        If s.Name = SheetName Then Exit Sub
    Next s
    Set CurS = ActiveSheet: Set s = Worksheets.Add
    With ActiveWindow
        .DisplayGridlines = False
'        .DisplayHeadings = False
    End With
    
    With Cells
         .Font.Name = "굴림"
         .Font.Size = 9
         .HorizontalAlignment = xlRight
    End With

    s.Name = SheetName: CurS.Activate
    With Worksheets(SheetName).Range("a1")
        .Value = 2
        If IsAddress = True Then .Value = "A2"
        .Font.ColorIndex = 2
    End With
    Worksheets(SheetName).Rows(1).Hidden = True
    Worksheets(SheetName).Activate
    Cells.Select
    Selection.RowHeight = 13.5
    

   ' s.Protect Password:="prophet", DrawingObjects:=False, contents:=True, Scenarios:=True
    Application.ScreenUpdating = True
    
End Sub
