object dlgFilter: TdlgFilter
  Left = 468
  Top = 423
  BorderStyle = bsDialog
  Caption = 'メモのフィルタ'
  ClientHeight = 338
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'ＭＳ Ｐゴシック'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object lblEndDate: TLabel
    Left = 192
    Top = 109
    Width = 61
    Height = 12
    Caption = 'いつまで(&E):'
    Enabled = False
    FocusControl = dtpEndDate
  end
  object lblBeginDate: TLabel
    Left = 16
    Top = 109
    Width = 62
    Height = 12
    Caption = 'いつから(&B):'
    Enabled = False
    FocusControl = dtpBeginDate
  end
  object lblDate: TLabel
    Left = 16
    Top = 36
    Width = 88
    Height = 12
    Caption = '含まれる言葉(&W):'
    Enabled = False
    FocusControl = edtMemo
  end
  object lblKind: TLabel
    Left = 16
    Top = 160
    Width = 41
    Height = 12
    Caption = '種類(&K):'
    Enabled = False
    FocusControl = lstKind
  end
  object btnOk: TButton
    Left = 198
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 278
    Top = 304
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'キャンセル'
    ModalResult = 2
    TabOrder = 8
  end
  object chkMemo: TCheckBox
    Left = 16
    Top = 12
    Width = 169
    Height = 17
    Caption = '内容でフィルタリングする(&T)'
    TabOrder = 0
    OnClick = chkMemoClick
  end
  object chkDate: TCheckBox
    Left = 16
    Top = 84
    Width = 165
    Height = 17
    Caption = '日付でフィルタリングする(&D)'
    TabOrder = 3
    OnClick = chkDateClick
  end
  object dtpEndDate: TDateTimePicker
    Left = 260
    Top = 105
    Width = 93
    Height = 20
    CalAlignment = dtaLeft
    Date = 36599.6399090046
    Time = 36599.6399090046
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
    OnChange = dtpEndDateChange
  end
  object dtpBeginDate: TDateTimePicker
    Left = 84
    Top = 105
    Width = 93
    Height = 20
    CalAlignment = dtaLeft
    Date = 36599
    Time = 36599
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
    OnChange = dtpBeginDateChange
  end
  object chkCharCase: TCheckBox
    Left = 108
    Top = 56
    Width = 149
    Height = 17
    Caption = '大文字小文字の区別(&C)'
    Enabled = False
    TabOrder = 2
  end
  object edtMemo: TEdit
    Left = 108
    Top = 32
    Width = 245
    Height = 20
    Enabled = False
    TabOrder = 1
  end
  object chkKind: TCheckBox
    Left = 16
    Top = 136
    Width = 165
    Height = 17
    Caption = '種類でフィルタリングする(&I)'
    TabOrder = 6
    OnClick = chkKindClick
  end
  object lstKind: TListBox
    Left = 64
    Top = 160
    Width = 289
    Height = 121
    Enabled = False
    ItemHeight = 16
    MultiSelect = True
    Style = lbOwnerDrawFixed
    TabOrder = 9
    OnDrawItem = lstKindDrawItem
  end
end
