object dlgInitFolder: TdlgInitFolder
  Left = 527
  Top = 571
  BorderStyle = bsDialog
  Caption = #12487#12540#12479#12501#12457#12523#12480#12398#25351#23450
  ClientHeight = 179
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 28
    Top = 76
    Width = 93
    Height = 12
    Caption = #12487#12540#12479#12501#12457#12523#12480'(&F):'
    FocusControl = edtInitFolder
  end
  object pbMessage: TPaintBox
    Left = 64
    Top = 16
    Width = 417
    Height = 41
    OnPaint = pbMessagePaint
  end
  object imgIcon: TImage
    Left = 12
    Top = 16
    Width = 32
    Height = 32
  end
  object btnOk: TButton
    Left = 292
    Top = 136
    Width = 86
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 384
    Top = 136
    Width = 86
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 3
  end
  object edtInitFolder: TEdit
    Left = 28
    Top = 92
    Width = 361
    Height = 20
    TabOrder = 0
  end
  object btnBrowse: TButton
    Left = 392
    Top = 92
    Width = 75
    Height = 20
    Caption = #21442#29031'(&B)...'
    TabOrder = 1
    OnClick = btnBrowseClick
  end
end
