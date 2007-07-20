object dlgIconChange: TdlgIconChange
  Left = 422
  Top = 221
  BorderStyle = bsDialog
  Caption = #12450#12452#12467#12531#12398#22793#26356
  ClientHeight = 293
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 95
    Height = 12
    Caption = #29694#22312#12398#12450#12452#12467#12531'(&C):'
    FocusControl = lstIcon
  end
  object btnOk: TButton
    Left = 180
    Top = 260
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 260
    Top = 260
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 2
  end
  object btnBrowse: TButton
    Left = 216
    Top = 8
    Width = 115
    Height = 25
    Caption = #12501#12449#12452#12523#21442#29031'(&B)...'
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clBtnText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnBrowseClick
  end
  object lstIcon: TListBox
    Left = 8
    Top = 36
    Width = 329
    Height = 217
    Style = lbOwnerDrawFixed
    Columns = 8
    ItemHeight = 35
    TabOrder = 0
    OnDrawItem = lstIconDrawItem
  end
  object dlgBrowse: TOpenDialog
    Filter = #12377#12409#12390#12398#12450#12452#12467#12531'|*.exe;*.ico;*.dll;*.icl|'#12377#12409#12390#12398#12501#12449#12452#12523'(*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoDereferenceLinks, ofEnableSizing]
    Left = 240
    Top = 44
  end
end
