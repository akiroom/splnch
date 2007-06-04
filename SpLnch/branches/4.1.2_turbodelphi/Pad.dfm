object frmPad: TfrmPad
  Left = 403
  Top = 353
  BorderStyle = bsNone
  Caption = 'Special Launch'
  ClientHeight = 122
  ClientWidth = 225
  Color = clGray
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = popMain
  OnClose = FormClose
  OnContextPopup = FormContextPopup
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pnlMain: TPanel
    Left = 17
    Top = 0
    Width = 208
    Height = 122
    Align = alClient
    BevelOuter = bvNone
    FullRepaint = False
    ParentColor = True
    TabOrder = 0
    OnDblClick = pnlDragBarDblClick
    OnMouseMove = pnlDragBarMouseMove
    OnMouseUp = pnlDragBarMouseUp
    ExplicitWidth = 217
    ExplicitHeight = 129
    object pnlScrollBar: TPanel
      Left = 190
      Top = 0
      Width = 18
      Height = 122
      Align = alRight
      BevelOuter = bvNone
      FullRepaint = False
      ParentColor = True
      TabOrder = 0
      OnResize = pnlScrollBarResize
      ExplicitLeft = 199
      ExplicitHeight = 129
      object pbWallPaper2: TPaintBox
        Left = 0
        Top = 0
        Width = 18
        Height = 122
        Align = alClient
        Enabled = False
        Visible = False
        OnPaint = pbWallPaper1Paint
        ExplicitHeight = 129
      end
    end
    object pnlWorkSpace: TPanel
      Left = 0
      Top = 0
      Width = 190
      Height = 122
      Align = alClient
      BevelOuter = bvNone
      FullRepaint = False
      ParentColor = True
      TabOrder = 1
      OnDblClick = pnlDragBarDblClick
      OnMouseMove = pnlDragBarMouseMove
      OnMouseUp = pnlDragBarMouseUp
      ExplicitWidth = 199
      ExplicitHeight = 129
      object pnlButtons: TPanel
        Left = 0
        Top = 0
        Width = 96
        Height = 97
        BevelOuter = bvNone
        FullRepaint = False
        ParentColor = True
        TabOrder = 0
        OnDblClick = pnlDragBarDblClick
        OnMouseMove = pnlDragBarMouseMove
        OnMouseUp = pnlDragBarMouseUp
        object pbWallPaper1: TPaintBox
          Left = 0
          Top = 0
          Width = 96
          Height = 97
          Align = alClient
          Enabled = False
          Visible = False
          OnPaint = pbWallPaper1Paint
        end
      end
    end
  end
  object pnlDragBar: TPanel
    Left = 0
    Top = 0
    Width = 17
    Height = 122
    Align = alLeft
    BevelOuter = bvNone
    FullRepaint = False
    TabOrder = 1
    Visible = False
    OnDblClick = pnlDragBarDblClick
    OnMouseMove = pnlDragBarMouseMove
    OnMouseUp = pnlDragBarMouseUp
    ExplicitHeight = 129
    object pbDragBar: TPaintBox
      Left = 0
      Top = 0
      Width = 17
      Height = 122
      Align = alClient
      Enabled = False
      OnPaint = pbDragBarPaint
      ExplicitHeight = 129
    end
  end
  object popMain: TPopupMenu
    AutoPopup = False
    OnPopup = popMainPopup
    Left = 44
    Top = 68
    object popComLine: TMenuItem
      Caption = #25351#23450#12375#12390#23455#34892'(&R)'
      ShortCut = 16466
      OnClick = popComLineClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popButtonEdit: TMenuItem
      Caption = #12508#12479#12531#12398#32232#38598'(&E)...'
      ShortCut = 16453
      OnClick = popButtonEditClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object popButton: TMenuItem
      Caption = #12508#12479#12531'(&B)'
      object popButtonAdd: TMenuItem
        Caption = #36861#21152'(&A)...'
        ShortCut = 16449
        OnClick = popButtonAddClick
      end
      object popButtonModify: TMenuItem
        Caption = #22793#26356'(&M)...'
        ShortCut = 32781
        OnClick = popButtonModifyClick
      end
      object popButtonFolder: TMenuItem
        Caption = '1 '#12388#19978#12398#12501#12457#12523#12480#12434#38283#12367'(&F)'
        ShortCut = 8205
        OnClick = popButtonFolderClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object popButtonCut: TMenuItem
        Caption = #20999#12426#21462#12426'(&T)'
        ShortCut = 16472
        OnClick = popButtonCutClick
      end
      object popButtonCopy: TMenuItem
        Caption = #12467#12500#12540'(&C)'
        ShortCut = 16451
        OnClick = popButtonCopyClick
      end
      object popButtonPaste: TMenuItem
        Caption = #36028#12426#20184#12369'(&P)'
        ShortCut = 16470
        OnClick = popButtonPasteClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object popButtonSpace: TMenuItem
        Caption = #31354#30333#12398#25407#20837'(&S)'
        ShortCut = 16416
        OnClick = popButtonSpaceClick
      end
      object popButtonReturn: TMenuItem
        Caption = #25913#34892#12398#25407#20837'(&R)'
        ShortCut = 16397
        OnClick = popButtonReturnClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object popButtonDelete: TMenuItem
        Caption = #21066#38500'(&D)'
        ShortCut = 46
        OnClick = popButtonDeleteClick
      end
      object popButtonBackSpace: TMenuItem
        Caption = '1 '#12388#21069#12434#21066#38500'(&B)'
        ShortCut = 8
        OnClick = popButtonBackSpaceClick
      end
      object popButtonNextDelete: TMenuItem
        Caption = '1 '#12388#24460#12434#21066#38500'(&N)'
        ShortCut = 8238
        OnClick = popButtonNextDeleteClick
      end
    end
    object popGroup: TMenuItem
      Caption = #12508#12479#12531#12464#12523#12540#12503'(&G)'
    end
    object popPad: TMenuItem
      Caption = #12497#12483#12489'(&P)'
      object popPadNew: TMenuItem
        Caption = #26032#35215#20316#25104'(&N)'
        OnClick = popPadNewClick
      end
      object popPadCopy: TMenuItem
        Caption = #35079#35069#20316#25104'(&C)'
        OnClick = popPadCopyClick
      end
      object popPadDeleteSep: TMenuItem
        Caption = '-'
      end
      object popPadHide: TMenuItem
        Caption = #38560#12377'(&H)'
        ShortCut = 27
        OnClick = popPadHideClick
      end
      object popPadDelete: TMenuItem
        Caption = #21066#38500'(&D)'
        OnClick = popPadDeleteClick
      end
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object popTopMost: TMenuItem
      Caption = #24120#12395#25163#21069#12395#34920#31034'(&T)'
      OnClick = popTopMostClick
    end
    object popHideAuto: TMenuItem
      Caption = #33258#21205#30340#12395#38560#12377'(&U)'
      OnClick = popHideAutoClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popPadProperty: TMenuItem
      Caption = #12497#12483#12489#12398#35373#23450'(&D)...'
      ShortCut = 16464
      OnClick = popPadPropertyClick
    end
    object popOption: TMenuItem
      Caption = #20840#20307#12398#35373#23450'(&O)...'
      ShortCut = 16463
      OnClick = popOptionClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object popHelp: TMenuItem
      Caption = #12504#12523#12503'(&H)'
      object popSearchTopic: TMenuItem
        Caption = #12488#12500#12483#12463#12398#26908#32034'(&H)'
        Enabled = False
        ShortCut = 112
        OnClick = popSearchTopicClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object popRegistration: TMenuItem
        Caption = #12518#12540#12470#12540#30331#37682'(&R)...'
        Visible = False
        OnClick = popRegistrationClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object popAbout: TMenuItem
        Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)...'
        OnClick = popAboutClick
      end
    end
    object popPluginBegin: TMenuItem
      Caption = '-'
    end
    object popPluginEnd: TMenuItem
      Caption = '-'
    end
    object popExit: TMenuItem
      Caption = #32066#20102'(&X)'
      ShortCut = 16465
      OnClick = popExitClick
    end
  end
  object tmHideScreen: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmHideScreenTimer
    Left = 36
    Top = 32
  end
  object popRightDrop: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    OnPopup = popRightDropPopup
    Left = 73
    Top = 68
    object popDropAddHere: TMenuItem
      Caption = #12371#12371#12395#30331#37682'(&R)'
      OnClick = popRightDropAction
    end
    object popDropAddLast: TMenuItem
      Tag = 1
      Caption = #26368#24460#12395#30331#37682'(&L)'
      OnClick = popRightDropAction
    end
    object N8: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object popDropOpenHere: TMenuItem
      Tag = 2
      Caption = #12371#12398#12508#12479#12531#12391#38283#12367'(&O)'
      OnClick = popRightDropAction
    end
    object N9: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object popDropCopyName: TMenuItem
      Tag = 3
      Caption = #12501#12449#12452#12523#21517#12434#12467#12500#12540'(&C)'
      OnClick = popRightDropAction
    end
    object N5: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object N10: TMenuItem
      Tag = -1
      Caption = #12461#12515#12531#12475#12523
    end
  end
  object popDblClick: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Left = 112
    Top = 68
  end
end
