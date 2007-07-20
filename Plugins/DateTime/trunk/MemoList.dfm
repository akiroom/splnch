object dlgMemoList: TdlgMemoList
  Left = 382
  Top = 261
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = #12513#12514#19968#35239
  ClientHeight = 333
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object lvMemoList: TListView
    Left = 0
    Top = 0
    Width = 525
    Height = 314
    Align = alClient
    Columns = <
      item
        Caption = #20869#23481#12398#35211#20986#12375
        Tag = 1
        Width = 280
      end
      item
        Caption = #26085#20184
        Tag = 2
        Width = 150
      end
      item
        Caption = #31278#39006
        Tag = 3
      end>
    MultiSelect = True
    ReadOnly = True
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    SmallImages = imlIcons
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvMemoListColumnClick
    OnCompare = lvMemoListCompare
    OnDblClick = mnuModifyClick
    OnInfoTip = lvMemoListInfoTip
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 314
    Width = 525
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    OnPopup = PopupMenu1Popup
    Left = 166
    Top = 234
    object popNew: TMenuItem
      Caption = #26032#35215#20316#25104'(&N)...'
      OnClick = mnuNewClick
    end
    object popModify: TMenuItem
      Caption = #22793#26356'(&M)...'
      OnClick = mnuModifyClick
    end
    object popDelete: TMenuItem
      Caption = #21066#38500'(&D)'
      OnClick = mnuDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popFilter: TMenuItem
      Caption = #12501#12451#12523#12479'(&F)...'
      OnClick = mnuFilterClick
    end
    object popNoFilter: TMenuItem
      Caption = #12501#12451#12523#12479#35299#38500'(&U)'
      OnClick = mnuNoFilterClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object popOutput: TMenuItem
      Caption = #26360#12365#20986#12375'(&W)...'
      OnClick = mnuOutputClick
    end
  end
  object imlIcons: TImageList
    Left = 116
    Top = 244
  end
  object MainMenu1: TMainMenu
    Left = 208
    Top = 152
    object mnuMemo: TMenuItem
      Caption = #12513#12514'(&M)'
      OnClick = mnuMemoClick
      object mnuNew: TMenuItem
        Caption = #26032#35215#20316#25104'(&N)...'
        ShortCut = 16462
        OnClick = mnuNewClick
      end
      object mnuModify: TMenuItem
        Caption = #22793#26356'(&M)...'
        ShortCut = 13
        OnClick = mnuModifyClick
      end
      object mnuDelete: TMenuItem
        Caption = #21066#38500'(&D)'
        ShortCut = 46
        OnClick = mnuDeleteClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuCancel: TMenuItem
        Caption = #30772#26820#32066#20102'(&C)'
        OnClick = mnuCancelClick
      end
      object mnuOk: TMenuItem
        Caption = #20445#23384#32066#20102'(&X)'
        OnClick = mnuOkClick
      end
    end
    object mnuList: TMenuItem
      Caption = #19968#35239'(&L)'
      OnClick = mnuListClick
      object mnuFilter: TMenuItem
        Caption = #12501#12451#12523#12479'(&F)...'
        OnClick = mnuFilterClick
      end
      object mnuNoFilter: TMenuItem
        Caption = #12501#12451#12523#12479#35299#38500'(&U)'
        OnClick = mnuNoFilterClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuOutput: TMenuItem
        Caption = #26360#12365#20986#12375'(&W)...'
        OnClick = mnuOutputClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object memSL3: TMenuItem
        Caption = 'SL3 '#24418#24335#12398#12501#12449#12452#12523#12434#35501#12415#36796#12415'(&3)...'
        OnClick = memSL3Click
      end
    end
  end
  object dlgSave: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 204
    Top = 224
  end
  object dlgOpenSL3: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 272
    Top = 176
  end
end
