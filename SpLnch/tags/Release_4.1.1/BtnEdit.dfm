object dlgButtonEdit: TdlgButtonEdit
  Left = 606
  Top = 304
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = #12508#12479#12531#12398#32232#38598
  ClientHeight = 432
  ClientWidth = 545
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
  OnShow = FormShow
  DesignSize = (
    545
    432)
  PixelsPerInch = 96
  TextHeight = 12
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 545
    Height = 392
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    FullRepaint = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 241
      Top = 0
      Width = 3
      Height = 392
      Cursor = crHSplit
      MinSize = 180
      ResizeStyle = rsUpdate
    end
    object pnlGroups: TPanel
      Left = 0
      Top = 0
      Width = 241
      Height = 392
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Constraints.MinWidth = 180
      FullRepaint = False
      TabOrder = 0
      DesignSize = (
        237
        388)
      object lblGroups: TLabel
        Left = 12
        Top = 8
        Width = 125
        Height = 12
        Caption = #12508#12479#12531#12464#12523#12540#12503#12398#19968#35239'(&I):'
        FocusControl = lvGroups
      end
      object btnGroupsAdd: TButton
        Left = 154
        Top = 24
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #36861#21152'(&O)'
        TabOrder = 1
        OnClick = btnGroupsAddClick
      end
      object btnGroupsRename: TButton
        Left = 154
        Top = 52
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #22793#26356'(&R)'
        Enabled = False
        TabOrder = 2
        OnClick = btnGroupsRenameClick
      end
      object btnGroupsCopy: TButton
        Left = 154
        Top = 80
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #35079#35069'(&P)'
        Enabled = False
        TabOrder = 3
        OnClick = btnGroupsCopyClick
      end
      object btnGroupsDelete: TButton
        Left = 154
        Top = 108
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #21066#38500'(&F)'
        Enabled = False
        TabOrder = 4
        OnClick = btnGroupsDeleteClick
      end
      object btnGroupsUp: TButton
        Left = 154
        Top = 326
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #19978#12408'(&V)'
        Enabled = False
        TabOrder = 5
        OnClick = btnGroupsUpClick
      end
      object btnGroupsDown: TButton
        Left = 154
        Top = 354
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #19979#12408'(&D)'
        Enabled = False
        TabOrder = 6
        OnClick = btnGroupsDownClick
      end
      object lvGroups: TListView
        Left = 12
        Top = 24
        Width = 138
        Height = 358
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = #21517#21069
            Width = -1
            WidthType = (
              -1)
          end>
        DragMode = dmAutomatic
        HideSelection = False
        MultiSelect = True
        PopupMenu = popGroups
        ShowColumnHeaders = False
        SmallImages = imlGroups
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvGroupsChange
        OnEdited = lvGroupsEdited
        OnEditing = lvGroupsEditing
        OnEndDrag = lvEndDrag
        OnDragDrop = lvGroupsDragDrop
        OnDragOver = lvGroupsDragOver
        OnStartDrag = lvStartDrag
      end
    end
    object pnlButtons: TPanel
      Left = 244
      Top = 0
      Width = 301
      Height = 392
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      FullRepaint = False
      TabOrder = 1
      DesignSize = (
        297
        388)
      object lblButtons: TLabel
        Left = 12
        Top = 8
        Width = 83
        Height = 12
        Caption = #12508#12479#12531#12398#19968#35239'(&T):'
        FocusControl = lvButtons
      end
      object lvButtons: TListView
        Left = 12
        Top = 24
        Width = 198
        Height = 357
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = #21517#21069
            Width = -1
            WidthType = (
              -1)
          end>
        DragMode = dmAutomatic
        HideSelection = False
        MultiSelect = True
        PopupMenu = popButtons
        ShowColumnHeaders = False
        SmallImages = imlButtons
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvButtonsChange
        OnDblClick = btnButtonsModifyClick
        OnEdited = lvButtonsEdited
        OnEditing = lvButtonsEditing
        OnEndDrag = lvEndDrag
        OnDragDrop = lvButtonsDragDrop
        OnDragOver = lvButtonsDragOver
        OnStartDrag = lvStartDrag
      end
      object btnButtonsAdd: TButton
        Left = 215
        Top = 24
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #36861#21152'(&N)...'
        Enabled = False
        TabOrder = 1
        OnClick = btnButtonsAddClick
      end
      object btnButtonsModify: TButton
        Left = 215
        Top = 52
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #22793#26356'(&M)...'
        Enabled = False
        TabOrder = 2
        OnClick = btnButtonsModifyClick
      end
      object btnButtonsCopy: TButton
        Left = 215
        Top = 80
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #35079#35069'(&C)'
        Enabled = False
        TabOrder = 3
        OnClick = btnButtonsCopyClick
      end
      object btnButtonsSpace: TButton
        Left = 215
        Top = 108
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #31354#30333'(&S)'
        Enabled = False
        TabOrder = 4
        OnClick = btnButtonsSpaceClick
      end
      object btnButtonsReturn: TButton
        Left = 215
        Top = 136
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #25913#34892'(&L)'
        Enabled = False
        TabOrder = 5
        OnClick = btnButtonsReturnClick
      end
      object btnButtonsDelete: TButton
        Left = 215
        Top = 164
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #21066#38500'(&E)'
        Enabled = False
        TabOrder = 6
        OnClick = btnButtonsDeleteClick
      end
      object btnButtonsUp: TButton
        Left = 215
        Top = 326
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #19978#12408'(&U)'
        Enabled = False
        TabOrder = 7
        OnClick = btnButtonsUpClick
      end
      object btnButtonsDown: TButton
        Left = 215
        Top = 354
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #19979#12408'(&B)'
        Enabled = False
        TabOrder = 8
        OnClick = btnButtonsDownClick
      end
    end
  end
  object btnOk: TButton
    Left = 298
    Top = 400
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 378
    Top = 400
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 458
    Top = 400
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #36969#29992'(&A)'
    TabOrder = 3
    OnClick = btnApplyClick
  end
  object imlGroups: TImageList
    Left = 40
    Top = 364
  end
  object imlButtons: TImageList
    Left = 68
    Top = 364
  end
  object tmListButton: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmListButtonTimer
    Left = 100
    Top = 364
  end
  object tmDragCheck: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmDragCheckTimer
    Left = 132
    Top = 364
  end
  object popGroups: TPopupMenu
    Left = 176
    Top = 394
    object A1: TMenuItem
      Caption = #36861#21152'(&O)'
      ShortCut = 16449
      OnClick = btnGroupsAddClick
    end
    object R1: TMenuItem
      Caption = #22793#26356'(&R)'
      ShortCut = 113
      OnClick = btnGroupsRenameClick
    end
    object Copy1: TMenuItem
      Caption = #35079#35069'(&P)'
      ShortCut = 16451
      OnClick = btnGroupsCopyClick
    end
    object Delete1: TMenuItem
      Caption = #21066#38500'(&F)'
      ShortCut = 46
      OnClick = btnGroupsDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object V1: TMenuItem
      Caption = #19978#12408'(&V)'
      ShortCut = 32806
      OnClick = btnGroupsUpClick
    end
    object D1: TMenuItem
      Caption = #19979#12408'(&D)'
      ShortCut = 32808
      OnClick = btnGroupsDownClick
    end
  end
  object popButtons: TPopupMenu
    Left = 258
    Top = 398
    object N2: TMenuItem
      Caption = #36861#21152'(&N)...'
      ShortCut = 16449
      OnClick = btnButtonsAddClick
    end
    object M1: TMenuItem
      Caption = #22793#26356'(&M)...'
      ShortCut = 32781
      OnClick = btnButtonsModifyClick
    end
    object popButtonNameModify: TMenuItem
      Caption = #21517#21069#22793#26356'(&A)'
      ShortCut = 113
      Visible = False
      OnClick = popButtonNameModifyClick
    end
    object Copy2: TMenuItem
      Caption = #35079#35069'(&C)'
      ShortCut = 16451
      OnClick = btnButtonsCopyClick
    end
    object S1: TMenuItem
      Caption = #31354#30333'(&S)'
      ShortCut = 16467
      OnClick = btnButtonsSpaceClick
    end
    object L1: TMenuItem
      Caption = #25913#34892'(&L)'
      ShortCut = 16397
      OnClick = btnButtonsReturnClick
    end
    object Delete2: TMenuItem
      Caption = #21066#38500'(&E)'
      ShortCut = 46
      OnClick = btnButtonsDeleteClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object U1: TMenuItem
      Caption = #19978#12408'(&U)'
      ShortCut = 32806
      OnClick = btnButtonsUpClick
    end
    object B1: TMenuItem
      Caption = #19979#12408'(&B)'
      ShortCut = 32808
      OnClick = btnButtonsDownClick
    end
  end
  object tmIsEditing: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmIsEditingTimer
    Left = 164
    Top = 364
  end
end
