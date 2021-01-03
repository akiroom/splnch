object dlgKind: TdlgKind
  Left = 271
  Top = 355
  BorderStyle = bsDialog
  Caption = '種類'
  ClientHeight = 100
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'ＭＳ Ｐゴシック'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 41
    Height = 12
    Caption = '種類(&K):'
  end
  object edtKind: TEdit
    Left = 60
    Top = 8
    Width = 221
    Height = 20
    TabOrder = 0
  end
  object btnColor: TButton
    Left = 204
    Top = 32
    Width = 75
    Height = 21
    Caption = '色変更(&C)...'
    TabOrder = 1
    OnClick = btnColorClick
  end
  object pnlColor: TPanel
    Left = 120
    Top = 32
    Width = 81
    Height = 21
    Caption = '色サンプル'
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 128
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 208
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'キャンセル'
    ModalResult = 2
    TabOrder = 4
  end
  object dlgColor: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 40
    Top = 52
  end
end
