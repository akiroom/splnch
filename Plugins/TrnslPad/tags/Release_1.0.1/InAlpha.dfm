object dlgInAlpha: TdlgInAlpha
  Left = 429
  Top = 450
  BorderStyle = bsDialog
  Caption = '不透明度の指定'
  ClientHeight = 99
  ClientWidth = 360
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
  object Label1: TLabel
    Left = 52
    Top = 8
    Width = 66
    Height = 12
    Caption = '不透明度(&A):'
    FocusControl = tbAlpha
  end
  object lblPercent: TLabel
    Left = 296
    Top = 12
    Width = 45
    Height = 12
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = '100%'
    ParentBiDiMode = False
  end
  object imgIcon: TImage
    Left = 8
    Top = 8
    Width = 32
    Height = 32
    AutoSize = True
  end
  object OKBtn: TButton
    Left = 187
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 267
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'キャンセル'
    ModalResult = 2
    TabOrder = 2
  end
  object tbAlpha: TTrackBar
    Left = 52
    Top = 24
    Width = 297
    Height = 25
    Max = 255
    Min = 1
    Orientation = trHorizontal
    Frequency = 10
    Position = 10
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbAlphaChange
  end
end
