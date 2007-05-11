object frmMain: TfrmMain
  Left = 436
  Top = 586
  Width = 234
  Height = 191
  Caption = 'Special Launch'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object popTaskTray: TPopupMenu
    OnPopup = popTaskTrayPopup
    Left = 32
    Top = 28
    object popComLine: TMenuItem
      Caption = #25351#23450#12375#12390#23455#34892'(&R)'
      OnClick = popComLineClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popOption: TMenuItem
      Caption = #20840#20307#12398#35373#23450'(&O)...'
      OnClick = popOptionClick
    end
    object N1: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object popSearchTopic: TMenuItem
      Caption = #12488#12500#12483#12463#12398#26908#32034'(&H)'
      OnClick = popSearchTopicClick
    end
    object popAbout: TMenuItem
      Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)...'
      OnClick = popAboutClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popExit: TMenuItem
      Caption = #32066#20102'(&X)'
      OnClick = popExitClick
    end
  end
  object tmMousePos: TTimer
    Interval = 125
    OnTimer = tmMousePosTimer
    Left = 32
    Top = 64
  end
  object XPManifest1: TXPManifest
    Left = 84
    Top = 52
  end
end
