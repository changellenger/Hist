VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frameTwoTtest 
   OleObjectBlob   =   "frameTwoTtest.frx":0000
   Caption         =   "독립표본 t 검정"
   ClientHeight    =   6360
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   5295
   StartUpPosition =   1  '소유자 가운데
   TypeInfoVer     =   55
End
Attribute VB_Name = "frameTwoTtest"
Attribute VB_Base = "0{03E6A100-3F54-40DD-AAD6-474E8D85D54A}{EA102E55-B4AA-4D6A-B9D5-6AF940465899}"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Attribute VB_TemplateDerived = False
Attribute VB_Customizable = False

Private Sub Cancel1_Click()
    Unload Me
End Sub

Private Sub Cancel2_Click()
    Unload Me
End Sub

Private Sub CB1_Click()
    Dim i As Integer
    i = 0
    If Me.ListBox1.ListCount > 0 Then
        Do While i <= Me.ListBox1.ListCount - 1
            If Me.ListBox1.Selected(i) = True Then
               Me.ListBox2.AddItem Me.ListBox1.List(i)
               Me.ListBox1.RemoveItem (i)
               Exit Sub
            End If
            i = i + 1
        Loop
    End If
End Sub

Private Sub CB2_Click()
    If Me.ListBox2.ListCount <> 0 Then
        Me.ListBox1.AddItem Me.ListBox2.List(0)
        Me.ListBox2.RemoveItem (0)
    End If
End Sub

Private Sub CB3_Click()
    Dim i As Integer
    i = 0
    If Me.ListBox4.ListCount = 0 Then
        Do While i <= Me.ListBox3.ListCount - 1
            If Me.ListBox3.Selected(i) = True Then
               Me.ListBox4.AddItem Me.ListBox3.List(i)
               Me.ListBox3.RemoveItem (i)
               Me.CB3.Visible = False
               Me.CB4.Visible = True
               Exit Sub
            End If
            i = i + 1
        Loop
    End If
End Sub

Private Sub CB4_Click()
    If Me.ListBox4.ListCount <> 0 Then
        Me.ListBox3.AddItem ListBox4.List(0)
        Me.ListBox4.RemoveItem (0)
        Me.CB3.Visible = True
        Me.CB4.Visible = False
    End If
End Sub

Private Sub CB5_Click()
    Dim i As Integer
    i = 0
    If Me.ListBox5.ListCount = 0 Then
        Do While i <= Me.ListBox3.ListCount - 1
            If Me.ListBox3.Selected(i) = True Then
               Me.ListBox5.AddItem Me.ListBox3.List(i)
               Me.ListBox3.RemoveItem (i)
               Me.CB5.Visible = False
               Me.CB6.Visible = True
               Exit Sub
            End If
            i = i + 1
        Loop
    End If
End Sub

Private Sub CB6_Click()
    If Me.ListBox5.ListCount <> 0 Then
        Me.ListBox3.AddItem ListBox5.List(0)
        Me.ListBox5.RemoveItem (0)
        Me.CB5.Visible = True
        Me.CB6.Visible = False
    End If
End Sub



Private Sub ChB1_Click()
    If Me.ChB1.Value = True Then Me.TextBox2.Enabled = True
    If Me.ChB1.Value = False Then Me.TextBox2.Enabled = False
End Sub

Private Sub ChB2_Click()
    If Me.ChB2.Value = True Then Me.TextBox4.Enabled = True
    If Me.ChB2.Value = False Then Me.TextBox4.Enabled = False
End Sub


Private Sub ListBox1_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    Dim i As Integer
    i = 0
    If Me.ListBox1.ListCount > 0 Then
        Do While i <= Me.ListBox1.ListCount - 1
            If Me.ListBox1.Selected(i) = True Then
               Me.ListBox2.AddItem Me.ListBox1.List(i)
               Me.ListBox1.RemoveItem (i)
               Exit Sub
            End If
            i = i + 1
        Loop
    End If
End Sub

Private Sub ListBox2_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    If Me.ListBox2.ListCount <> 0 Then
        Me.ListBox1.AddItem Me.ListBox2.List(0)
        Me.ListBox2.RemoveItem (0)
    End If
End Sub

Private Sub Frame1_Click()

End Sub

Private Sub ListBox3_Click()

End Sub

Private Sub MultiPage1_Change()
    
    TModuleControl.InitializeDlg2 Me
        
End Sub

Private Sub OK1_Click()
        
    Dim choice(3) As Variant                            '넘길 정보는 대립가설, 신뢰구간,검정방법 3개니까
    Dim dataRange As Range
    Dim i As Integer
    Dim activePt As Long                                '결과 분석이 시작되는 부분을 보여주기 위함
    
    '''
    '''변수를 선택하지 않았을 경우
    '''
    If Me.ListBox4.ListCount + Me.ListBox4.ListCount <> 2 Then
        MsgBox "2개의 변수를 선택해 주시기 바랍니다.", vbExclamation, "HIST"
        Exit Sub
    End If
    
    '''
    '''public 변수 선언 xlist2, DataSheet, RstSheet, m, k2, n2
    '''
    ReDim xlist2(2)
    xlist2(1) = Me.ListBox4.List(0)
    
    MsgBox xlist2(1), vbExclamation, "HIST"
    xlist2(2) = Me.ListBox5.List(0)
     MsgBox xlist2(2), vbExclamation, "HIST"
    
    DataSheet = ActiveSheet.Name                        'DataSheet : Data가 있는 Sheet 이름
    RstSheet = "_통계분석결과_"                       'RstSheet  : 결과를 보여주는 Sheet 이름
    
    
    '맨위에 입력
On Error GoTo Err_delete
Dim val3535 As Long '초기위치 저장할 공간'
Dim s3535 As Worksheet
val3535 = 2
    For Each s3535 In ActiveWorkbook.Sheets
        If s3535.Name = RstSheet Then
val3535 = Sheets(RstSheet).Cells(1, 1).Value
End If
Next s3535  '시트가 이미있으면 출력 위치 저장을하고, 없으면 2을 저장한다.


    
    Set dataRange = ActiveSheet.Cells.CurrentRegion
    m = dataRange.Columns.Count                         'm         : dataSheet에 있는 변수 개수
    
    tmp1 = 2
    ReDim xlist2(tmp1)                                  '변수이름들
    ReDim k2(tmp1)                                      '몇번째열의 변수인지
    ReDim n2(tmp1)                                      '데이타 몇개씩인지
    ReDim tmp(tmp1)
    
     i = 1
        tmp(1) = 0
        tmp(2) = 0
        For j = 1 To m
            If Me.ListBox4.List(0) = ActiveSheet.Cells(1, j) Then
                xlist2(1) = ActiveSheet.Cells(1, j)
                k2(1) = j
                n2(1) = ActiveSheet.Cells(1, j).End(xlDown).row - 1
            '    tmp(i) = tmp(i) + 1
            End If
               If Me.ListBox5.List(0) = ActiveSheet.Cells(1, j) Then
                xlist2(2) = ActiveSheet.Cells(1, j)
                k2(2) = j
                n2(2) = ActiveSheet.Cells(1, j).End(xlDown).row - 1
             '   tmp(i) = tmp(i) + 1
            End If
    Next j
    tmp(1) = 1
    tmp(2) = 1
    
    
    '''
    ''' 변수명이 같은 경우 - 마지막 열에 있는 변수만 입력되므로 에러처리한다.
    '''
    For i = 1 To tmp1
    If tmp(i) > 1 Then
        MsgBox xlist2(i) & "와 같은 변수명이 있습니다. " & vbCrLf & "변수명을 바꿔주시기 바랍니다.", vbExclamation, "HIST"
        Exit Sub
    End If
    Next i
    
         
    '''
    '''숫자와 문자가 혼합되어 있을 경우
    '''
    For i = 1 To tmp1
       If TModuleControl.FindingRangeError(xlist2(i)) = True Then
           MsgBox "다음의 분석변수에 문자나 공백이 있습니다." & Chr(10) & _
                    ": " & xlist2(i), vbExclamation, "HIST"
            Exit Sub
        End If
    Next i
        
    '''
    '''검정유형 선택결과 입력 - choice(1)
    '''
    choice(1) = 1
    'If Me.OB7.Value = True Then choice(1) = 1
    'If Me.OB8.Value = True Then choice(1) = 2
    
    If choice(1) = 2 Then
        If n2(1) <> n2(2) Then
        MsgBox "선택한 변수의 데이타개수가 다릅니다. 대응비교를 할 수 없습니다.", vbExclamation, "HIST": Exit Sub
        Exit Sub
        End If
    End If
    
    '''
    ''' 데이타 개수가 한개일 경우
    '''
    If n2(1) = 1 Or n2(2) = 1 Then
        MsgBox "한 개의 데이타로 검정을 시행할 수 없습니다.", vbExclamation, "HIST"
        Exit Sub
    End If

    '''
    '''신뢰구간을 잘못 입력한 경우
    '''
    If Me.ChB2.Value = True Then
        If IsNumeric(Me.TextBox4.Value) = False Then
            MsgBox "사용자 신뢰구간을 입력해 주시기 바랍니다.", vbExclamation, "HIST"
            Exit Sub
        ElseIf Me.TextBox4.Value < 0 Or Me.TextBox4.Value > 100 Then
            MsgBox "사용자 신뢰구간을 %단위로 입력해 주시기 바랍니다.", vbExclamation, "HIST"
            Exit Sub
        End If
    End If
    
    '''
    '''신뢰구간 입력 - choice(2)
    '''
    If Me.ChB2.Value = True Then choice(2) = Me.TextBox4.Value
    If Me.ChB2.Value = False Then choice(2) = -1
    
    '''
    '''귀무가설 선택결과 입력 - choice(3)
    '''
    If Me.OB4 = True Then choice(3) = 1
    If Me.OB5 = True Then choice(3) = 2
    If Me.OB6 = True Then choice(3) = 3
    
    '''
    '''결과 처리
    '''
    TModuleControl.SettingStatusBar True, "이표본 t-검정중입니다."
    Application.ScreenUpdating = False
    TModulePrint.makeOutputSheet (RstSheet)
    'Worksheets(RstSheet).Unprotect "prophet"
    activePt = Worksheets(RstSheet).Cells(1, 1).Value
    
    TModuleControl.TTest2 choice, 1
    
    
    'Worksheets(RstSheet).Protect Password:="prophet", DrawingObjects:=False, _
    '                                contents:=True, Scenarios:=True
    TModuleControl.SettingStatusBar False
    Application.ScreenUpdating = True
    Unload Me
    
    Worksheets(RstSheet).Activate
    
    '파일 버전 체크 후 비교값 정의
    Dim Cmp_Value As Long
    
    If PublicModule.ChkVersion(ActiveWorkbook.Name) = True Then
        Cmp_Value = 1048000
    Else
        Cmp_Value = 65000
    End If
    
    If Worksheets(RstSheet).Cells(1, 1).Value > Cmp_Value Then
        MsgBox "[_통계분석결과_]시트를 거의 모두 사용하였습니다." & vbCrLf & "이 시트의 이름을 바꾸거나 삭제해 주세요", vbExclamation, "HIST"
        Exit Sub
    End If

    Worksheets(RstSheet).Cells(activePt + 10, 1).Select
    Worksheets(RstSheet).Cells(activePt + 10, 1).Activate
                            '결과 분석이 시작되는 부분을 보여주며 마친다.
                                    
    
'맨뒤에 붙이기
Exit Sub
Err_delete:

For Each s3535 In ActiveWorkbook.Sheets
        If s3535.Name = RstSheet Then
Sheets(RstSheet).Range(Cells(val3535, 1), Cells(5000, 1000)).Select
Selection.Delete
Sheets(RstSheet).Cells(1, 1) = val3535
Sheets(RstSheet).Cells(val3535, 1).Select

If val3535 = 2 Then
Application.DisplayAlerts = False
Sheets(RstSheet).Delete
End If

End If


Next s3535

MsgBox ("프로그램에 문제가 있습니다.")
 'End sub 앞에다 붙인다.

''해석, 에러가 나면 Err_delete로 와서 첫셀이후로 지운다. 만약 첫셀이 2면 시트를 지운다.그리고 에러메시지 출력
'rSTsheet만들기도 전에 에러나는 경우에는 아무 동작도 하지 않고, 에러메시지만 띄운다.
        
End Sub

Private Sub OK2_Click()
    Dim choice(3) As Variant                            '넘길 정보는 대립가설, 신뢰구간,검정방법 3개니까
    Dim dataRange As Range
    Dim i As Integer
    Dim activePt As Long                                '결과 분석이 시작되는 부분을 보여주기 위함
    
    '''
    '''변수를 선택하지 않았을 경우
    '''
    If Me.ListBox4.ListCount = 0 Then
        MsgBox "분류변수를 선택해 주시기 바랍니다.", vbExclamation, "HIST"
        Exit Sub
    End If
    If Me.ListBox5.ListCount = 0 Then
        MsgBox "분석변수를 선택해 주시기 바랍니다.", vbExclamation, "HIST"
        Exit Sub
    End If
    
    '''
    '''public 변수 선언 xlist2, DataSheet, RstSheet, m, k2, n2
    '''
    ReDim xlist2(2)
    xlist2(1) = Me.ListBox4.List(0)
    xlist2(2) = Me.ListBox5.List(0)

    DataSheet = ActiveSheet.Name                        'DataSheet : Data가 있는 Sheet 이름
    RstSheet = "_통계분석결과_"                       'RstSheet  : 결과를 보여주는 Sheet 이름
    Set dataRange = ActiveSheet.Cells.CurrentRegion
    m = dataRange.Columns.Count                         'm         : dataSheet에 있는 변수 개수
    
    tmp1 = 2
    ReDim xlist2(tmp1)                                  '변수이름들
    ReDim k2(tmp1)                                      '몇번째열의 변수인지
    ReDim n2(tmp1)                                      '데이타 몇개씩인지
    ReDim tmp(tmp1)
    
    
    
    For i = 1 To tmp1
        tmp(i) = 0
        If i = 1 Then tmpList = Me.ListBox4.List(0)
        If i = 2 Then tmpList = Me.ListBox5.List(0)
        For j = 1 To m
            If tmpList = ActiveSheet.Cells(1, j) Then                   ' j 열
                xlist2(i) = ActiveSheet.Cells(1, j)                     '   변수이름저장 , 개수
                k2(i) = j
                n2(i) = ActiveSheet.Cells(1, j).End(xlDown).row - 1
                tmp(i) = tmp(i) + 1
            End If
    Next j
    Next i
    
        
                    ''''
                    '''' 임시로 배열의 1들은 분류변수 2들은 분석변수
                    ''''

    '''
    ''' 변수명이 같은 경우 - 마지막 열에 있는 변수만 입력되므로 에러처리한다.
    '''
    For i = 1 To tmp1
    If tmp(i) > 1 Then
        MsgBox xlist2(i) & "와 같은 변수명이 있습니다. " & vbCrLf & "변수명을 바꿔주시기 바랍니다.", vbExclamation, "HIST"
        Exit Sub
    End If
    Next i
    
         
    '''
    '''분석 변수에 숫자와 문자가 혼합되어 있을 경우
    '''
    'For i = 1 To tmp1
        If TModuleControl.FindingRangeError(Me.ListBox5.List(0)) = True Then
            MsgBox "다음의 분석변수에 문자나 공백이 있습니다." & Chr(10) & _
                    ": " & xlist2(i), vbExclamation, "HIST"
            Exit Sub
        End If
    'Next i
        
        
    '''
    ''' 고급입력이므로 분류변수, 분석변수따라 점검하기
    '''
        
    tmpList = 0
    tmp(1) = ActiveSheet.Cells(2, k2(1)).Value
    For i = 2 To n2(1)
        If tmpList = 1 And tmp(1) <> ActiveSheet.Cells(i + 1, k2(1)).Value And tmp(2) <> ActiveSheet.Cells(i + 1, k2(1)).Value Then
            MsgBox "분류변수는 2종류의 값만을 가지고 있어야 합니다." & Chr(10), vbExclamation, "HIST"
            Exit Sub
        End If
        If tmpList = 0 And tmp(1) <> ActiveSheet.Cells(i + 1, k2(1)).Value Then
            tmp(2) = ActiveSheet.Cells(i + 1, k2(1)).Value
            tmpList = tmpList + 1
        End If
        
    Next i
    
    If n2(1) <> n2(2) Then
        MsgBox "분류변수와 분석변수의 데이타 수는 같아야 합니다." & Chr(10), vbExclamation, "HIST"
        Exit Sub
    End If
    
    tmpList = n2(1)
    n2(1) = 0: n2(2) = 0
    For i = 1 To tmpList
        If ActiveSheet.Cells(i + 1, k2(1)) = tmp(1) Then n2(1) = n2(1) + 1
        If ActiveSheet.Cells(i + 1, k2(1)) = tmp(2) Then n2(2) = n2(2) + 1
    Next i



    '''
    '''검정유형 선택결과 입력 - choice(1), choice(2)
    '''
    
    choice(1) = 1
    '''If Me.OB9.Value = True Then choice(1) = 1
    '''If Me.OB10.Value = True Then choice(1) = 2
    
    If choice(1) = 2 Then
        If n2(1) <> n2(2) Then
        MsgBox "선택한 변수의 데이타개수가 다릅니다. 대응비교를 할 수 없습니다.", vbExclamation, "HIST": Exit Sub
        Exit Sub
        End If
    End If
    
    '''
    ''' 데이타 개수가 한개일 경우
    '''
    If n2(1) = 1 Or n2(2) = 1 Then
        MsgBox "한 개의 데이타로 검정을 시행할 수 없습니다.", vbExclamation, "HIST"
        Exit Sub
    End If

    
    '''
    '''신뢰구간을 잘못 입력한 경우
    '''
    If Me.ChB2.Value = True Then
        If IsNumeric(Me.TextBox4.Value) = False Then
            MsgBox "사용자 신뢰구간을 입력해 주시기 바랍니다.", vbExclamation, "HIST"
            Exit Sub
        ElseIf Me.TextBox4.Value < 0 Or Me.TextBox4.Value > 100 Then
            MsgBox "사용자 신뢰구간을 %단위로 입력해 주시기 바랍니다.", vbExclamation, "HIST"
            Exit Sub
        End If
    End If
    
    '''
    '''신뢰구간 입력 - choice(2)
    '''
    If Me.ChB2.Value = True Then choice(2) = Me.TextBox4.Value
    If Me.ChB2.Value = False Then choice(2) = -1
    
    '''
    '''귀무가설 선택결과 입력 - choice(3)
    '''
    If Me.OB4 = True Then choice(3) = 1
    If Me.OB5 = True Then choice(3) = 2
    If Me.OB6 = True Then choice(3) = 3
    
    '''
    '''결과 처리
    '''
    TModuleControl.SettingStatusBar True, "이표본 t-검정중입니다."
    Application.ScreenUpdating = False
    TModulePrint.makeOutputSheet (RstSheet)
    'Worksheets(RstSheet).Unprotect "prophet"
    activePt = Worksheets(RstSheet).Cells(1, 1).Value
    
    TModuleControl.TTest2 choice, 2
    
    
    'Worksheets(RstSheet).Protect Password:="prophet", DrawingObjects:=False, _
    '                                contents:=True, Scenarios:=True
    TModuleControl.SettingStatusBar False
    Application.ScreenUpdating = True
    Unload Me
    
    Worksheets(RstSheet).Activate
    
    '파일 버전 체크 후 비교값 정의
    Dim Cmp_Value As Long
    
    If PublicModule.ChkVersion(ActiveWorkbook.Name) = True Then
        Cmp_Value = 1048000
    Else
        Cmp_Value = 65000
    End If
    
    If Worksheets(RstSheet).Cells(1, 1).Value > Cmp_Value Then
        MsgBox "[_통계분석결과_]시트를 거의 모두 사용하였습니다." & vbCrLf & "이 시트의 이름을 바꾸거나 삭제해 주세요", vbExclamation, "HIST"
        Exit Sub
    End If

    Worksheets(RstSheet).Cells(activePt + 10, 1).Select
    Worksheets(RstSheet).Cells(activePt + 10, 1).Activate
                            '결과 분석이 시작되는 부분을 보여주며 마친다.
                                    
    
End Sub


Private Sub OptionButton1_Click()
   
   Dim myRange As Range
   Dim myArray()
   Dim arrName As Variant
   Dim TempSheet As Worksheet
   Set TempSheet = ActiveCell.Worksheet
   
    ReDim arrName(TempSheet.UsedRange.Columns.Count)
' Reading Data
    For i = 1 To TempSheet.UsedRange.Columns.Count
        arrName(i) = TempSheet.Cells(1, i)
    Next i
   
   Me.ListBox3.Clear
'-------------
  'Set myRange = Cells.CurrentRegion.Rows(1)
   'cnt = myRange.Cells.Count
   'ReDim myArray(cnt - 1)
  ' For i = 1 To cnt
  '   myArray(i - 1) = myRange.Cells(i)
  ' Next i
   'Me.ListBox1.List() = myArray
'-----------
    ReDim myArray(TempSheet.UsedRange.Columns.Count - 1)
    a = 0
   For i = 1 To TempSheet.UsedRange.Columns.Count
   If arrName(i) <> "" Then                     '빈칸제거
   myArray(a) = arrName(i)
   a = a + 1
   
   Else:
   End If
   Next i
   
   
   
   Me.ListBox3.List() = myArray
   
 '  For i = 1 To TempSheet.UsedRange.Columns.Count
 '   rngFirst.Offset(i, 1) = myArray(i - 1)
 ' Next i
  
End Sub

Private Sub UserForm_Click()

End Sub
