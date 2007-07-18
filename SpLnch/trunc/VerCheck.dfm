object dlgVerCheck: TdlgVerCheck
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Special Launch '#12398#26356#26032#12434#30906#35469
  ClientHeight = 251
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object lblMessage: TLabel
    Left = 16
    Top = 21
    Width = 189
    Height = 12
    Caption = #12477#12501#12488#12454#12455#12450#12398#26356#26032#12434#30906#35469#12375#12390#12356#12414#12377'...'
  end
  object btnOk: TButton
    Left = 312
    Top = 16
    Width = 113
    Height = 25
    Caption = #12480#12454#12531#12525#12540#12489#12469#12452#12488
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 350
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = #38281#12376#12427
    ModalResult = 2
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object memInfo: TMemo
    Left = 16
    Top = 56
    Width = 409
    Height = 154
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object wbVersion: TWebBrowser
    Left = 40
    Top = 351
    Width = 300
    Height = 150
    TabOrder = 3
    OnNavigateComplete2 = wbVersionNavigateComplete2
    OnNavigateError = wbVersionNavigateError
    ControlData = {
      4C000000021F0000810F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
