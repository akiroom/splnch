object frmPadTab: TfrmPadTab
  Left = 579
  Top = 525
  BorderStyle = bsNone
  Caption = 'Special Launch (Hid)'
  ClientHeight = 41
  ClientWidth = 115
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pbDragBar: TPaintBox
    Left = 0
    Top = 0
    Width = 17
    Height = 41
    Align = alLeft
    Visible = False
    OnMouseDown = pbDragBarMouseDown
    OnPaint = pbDragBarPaint
  end
  object PopupMenu1: TPopupMenu
    Left = 28
    Top = 12
    object popPadShowEsc: TMenuItem
      Caption = #29694#12428#12427
      ShortCut = 27
      OnClick = popPadShowClick
    end
  end
end
