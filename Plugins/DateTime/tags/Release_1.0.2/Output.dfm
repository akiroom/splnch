object dlgOutput: TdlgOutput
  Left = 483
  Top = 416
  BorderStyle = bsDialog
  Caption = '書き出し'
  ClientHeight = 162
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'ＭＳ Ｐゴシック'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 130
    Top = 124
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 210
    Top = 124
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'キャンセル'
    ModalResult = 2
    TabOrder = 1
  end
  object rdoMedia: TRadioGroup
    Left = 16
    Top = 8
    Width = 265
    Height = 41
    Caption = '書き出し先(&M)'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ファイル'
      'クリップボード')
    TabOrder = 2
  end
  object chkHeader: TCheckBox
    Left = 28
    Top = 80
    Width = 97
    Height = 17
    Caption = '見出しのみ(&H)'
    TabOrder = 3
  end
  object chkCSV: TCheckBox
    Left = 28
    Top = 100
    Width = 93
    Height = 17
    Caption = 'CSV形式(&C)'
    TabOrder = 4
  end
  object chkSelected: TCheckBox
    Left = 28
    Top = 60
    Width = 109
    Height = 17
    Caption = '選択項目のみ(&S)'
    TabOrder = 5
  end
end
