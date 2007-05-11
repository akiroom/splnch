object frmBtnTitle: TfrmBtnTitle
  Left = 515
  Top = 365
  BorderStyle = bsNone
  ClientHeight = 41
  ClientWidth = 271
  Color = clInfoBk
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 12
  object lblTitle: TLabel
    Left = 2
    Top = 2
    Width = 35
    Height = 12
    Caption = 'lblTitle'
    ShowAccelChar = False
    OnMouseDown = FormMouseDown
  end
  object tmShowHide: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmShowHideTimer
    Left = 52
    Top = 12
  end
end
