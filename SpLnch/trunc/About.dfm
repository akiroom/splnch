object dlgAbout: TdlgAbout
  Left = 321
  Top = 259
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12496#12540#12472#12519#12531#24773#22577
  ClientHeight = 307
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    444
    307)
  PixelsPerInch = 96
  TextHeight = 12
  object lblVersion: TLabel
    Left = 357
    Top = 12
    Width = 77
    Height = 12
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #12496#12540#12472#12519#12531#30058#21495
    Transparent = True
    IsControl = True
  end
  object lblName: TLabel
    Left = 12
    Top = 12
    Width = 26
    Height = 12
    Caption = #21517#21069
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 12
    Top = 52
    Width = 24
    Height = 12
    Caption = #35500#26126
  end
  object Bevel1: TBevel
    Left = 12
    Top = 45
    Width = 421
    Height = 3
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object lblFileName: TLabel
    Left = 12
    Top = 28
    Width = 53
    Height = 12
    Caption = #12501#12449#12452#12523#21517
  end
  object btnOk: TButton
    Left = 357
    Top = 274
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object memExplanation: TMemo
    Left = 12
    Top = 68
    Width = 421
    Height = 198
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = True
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
end
