object dlgComLine: TdlgComLine
  Left = 738
  Top = 690
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #25351#23450#12375#12390#23455#34892
  ClientHeight = 95
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object lblName: TLabel
    Left = 12
    Top = 16
    Width = 42
    Height = 12
    Caption = #21517#21069'(&N):'
    FocusControl = cmbName
  end
  object cmbName: TComboBox
    Left = 64
    Top = 12
    Width = 361
    Height = 20
    ItemHeight = 0
    TabOrder = 0
    OnChange = cmbNameChange
  end
  object btnOk: TButton
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 272
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnBrowse: TButton
    Left = 352
    Top = 56
    Width = 75
    Height = 25
    Caption = #21442#29031'(&B)...'
    TabOrder = 3
    OnClick = btnBrowseClick
  end
  object dlgBrowse: TOpenDialog
    Filter = #12503#12525#12464#12521#12512'(*.exe;*.lnk;*.url)|*.exe;*.lnk;*.url|'#12377#12409#12390#12398#12501#12449#12452#12523'(*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoDereferenceLinks, ofEnableSizing]
    Left = 148
    Top = 44
  end
end
