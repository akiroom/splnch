object dlgOption: TdlgOption
  Left = 443
  Top = 291
  ActiveControl = edtUserFolder
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #20840#20307#12398#35373#23450
  ClientHeight = 359
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 236
    Top = 326
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 316
    Top = 326
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 396
    Top = 326
    Width = 75
    Height = 25
    Caption = #36969#29992'(&A)'
    ModalResult = 2
    TabOrder = 4
    OnClick = btnApplyClick
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 465
    Height = 305
    ActivePage = tabUserFolder
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    object tabGeneral: TTabSheet
      Caption = #20840#33324
      ImageIndex = 1
      object grpIconCache: TGroupBox
        Left = 16
        Top = 188
        Width = 377
        Height = 57
        Caption = #12450#12452#12467#12531#12461#12515#12483#12471#12517
        TabOrder = 3
        object lblIconCache: TLabel
          Left = 12
          Top = 28
          Width = 83
          Height = 12
          Caption = #26368#22823#20351#29992#37327'(&M): '
          FocusControl = edtIconCache
        end
        object lblNowIconCache: TLabel
          Left = 168
          Top = 28
          Width = 82
          Height = 12
          Caption = #29694#22312#12398#20351#29992#37327' : '
        end
        object edtIconCache: TEdit
          Left = 100
          Top = 24
          Width = 41
          Height = 20
          TabOrder = 0
          Text = '0'
          OnChange = edtIconCacheChange
        end
        object udIconCache: TUpDown
          Left = 141
          Top = 24
          Width = 15
          Height = 20
          Associate = edtIconCache
          Max = 1000
          Increment = 10
          TabOrder = 1
        end
        object btnCacheClear: TButton
          Left = 296
          Top = 24
          Width = 71
          Height = 21
          Caption = #12463#12522#12450'(&L)'
          TabOrder = 2
          OnClick = btnCacheClearClick
        end
      end
      object chkTaskTray: TCheckBox
        Left = 16
        Top = 40
        Width = 205
        Height = 17
        Caption = #12479#12473#12463#12488#12524#12452#12395#12450#12452#12467#12531#12434#34920#31034#12377#12427'(&I)'
        TabOrder = 1
        OnClick = chkTaskTrayClick
      end
      object gbSound: TGroupBox
        Left = 16
        Top = 64
        Width = 377
        Height = 113
        Caption = #12469#12454#12531#12489
        TabOrder = 2
        object lblSounds: TLabel
          Left = 16
          Top = 24
          Width = 98
          Height = 12
          Caption = #38899#12434#40180#12425#12377#22580#38754'(&V):'
          FocusControl = cmbSounds
        end
        object lblSoundName: TLabel
          Left = 16
          Top = 56
          Width = 70
          Height = 12
          Caption = #12469#12454#12531#12489#21517'(&F):'
          FocusControl = edtSoundName
        end
        object cmbSounds: TComboBox
          Left = 120
          Top = 20
          Width = 245
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          OnChange = cmbSoundsChange
          Items.Strings = (
            #12508#12479#12531#12434#25276#12377
            #12508#12479#12531#12464#12523#12540#12503#12434#20999#12426#26367#12360#12427
            #30011#38754#12398#32257#12395#38560#12428#12427
            #30011#38754#12398#32257#12363#12425#29694#12428#12427)
        end
        object edtSoundName: TEdit
          Left = 120
          Top = 52
          Width = 245
          Height = 20
          TabOrder = 1
          OnChange = edtSoundNameChange
        end
        object btnSoundTest: TButton
          Left = 128
          Top = 76
          Width = 75
          Height = 25
          Caption = #12486#12473#12488'(&T)'
          TabOrder = 2
          OnClick = btnSoundTestClick
        end
        object btnSoundClear: TButton
          Left = 208
          Top = 76
          Width = 75
          Height = 25
          Caption = #12463#12522#12450'(&C)'
          TabOrder = 3
          OnClick = btnSoundClearClick
        end
        object btnSoundBrowse: TButton
          Left = 288
          Top = 76
          Width = 75
          Height = 25
          Caption = #21442#29031'(&B)...'
          TabOrder = 4
          OnClick = btnSoundBrowseClick
        end
      end
      object chkVerCheck: TCheckBox
        Left = 16
        Top = 17
        Width = 265
        Height = 17
        Caption = #23450#26399#30340#12395' Special Launch '#12398#26356#26032#12434#30906#35469#12377#12427'(&O)'
        TabOrder = 0
        OnClick = chkVerCheckClick
      end
    end
    object tabUserFolder: TTabSheet
      Caption = #12487#12540#12479#12501#12457#12523#12480
      ImageIndex = 3
      object Label2: TLabel
        Left = 24
        Top = 69
        Width = 129
        Height = 12
        Caption = #29694#22312#12398#12487#12540#12479#12501#12457#12523#12480'(&F):'
        FocusControl = edtUserFolder
      end
      object edtUserFolder: TEdit
        Left = 24
        Top = 85
        Width = 313
        Height = 20
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object btnUserFolderReset: TButton
        Left = 240
        Top = 113
        Width = 183
        Height = 25
        Caption = #27425#22238#36215#21205#26178#12395#22793#26356#12377#12427'(&C)'
        TabOrder = 3
        OnClick = btnUserFolderResetClick
      end
      object btnUserFolderOpen: TButton
        Left = 348
        Top = 85
        Width = 73
        Height = 20
        Caption = #38283#12367'(&O)'
        TabOrder = 2
        OnClick = btnUserFolderOpenClick
      end
      object chkSettingForAllUser: TCheckBox
        Left = 24
        Top = 33
        Width = 245
        Height = 17
        Caption = #12377#12409#12390#12398#12518#12540#12470#12540#12391#21516#12376#35373#23450#12434#20351#12358'(&A)'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 0
      end
    end
    object tabPlugins: TTabSheet
      Caption = #12503#12521#12464#12452#12531
      ImageIndex = 2
      object lblPlugins: TLabel
        Left = 12
        Top = 8
        Width = 69
        Height = 12
        Caption = #12503#12521#12464#12452#12531'(&P):'
        FocusControl = lvPlugins
      end
      object Label1: TLabel
        Left = 168
        Top = 8
        Width = 277
        Height = 12
        Alignment = taRightJustify
        AutoSize = False
        Caption = #8251' '#12371#12371#12398#35373#23450#12399#22793#26356#12392#21516#26178#12395#21453#26144#12373#12428#12414#12377#12290
      end
      object lvPlugins: TListView
        Left = 12
        Top = 25
        Width = 433
        Height = 176
        Columns = <
          item
            Caption = #21517#21069
            Width = 160
          end
          item
            Caption = #29366#24907
            Width = 40
          end
          item
            Caption = #12501#12449#12452#12523#21517
            Width = 80
          end
          item
            Caption = #12496#12540#12472#12519#12531
            Width = 90
          end>
        ColumnClick = False
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        SmallImages = imlPlugins
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvPluginsChange
        OnDblClick = btnPluginOptionClick
      end
      object btnPluginInfo: TButton
        Left = 368
        Top = 208
        Width = 75
        Height = 25
        Caption = #24773#22577'(&I)...'
        Enabled = False
        TabOrder = 4
        OnClick = btnPluginInfoClick
      end
      object btnPluginOption: TButton
        Left = 288
        Top = 208
        Width = 75
        Height = 25
        Caption = #35373#23450'(&O)...'
        Enabled = False
        TabOrder = 3
        OnClick = btnPluginOptionClick
      end
      object btnPluginEnable: TButton
        Left = 12
        Top = 208
        Width = 75
        Height = 25
        Caption = #36215#21205'(&B)'
        Enabled = False
        TabOrder = 1
        OnClick = btnPluginEnableClick
      end
      object btnPluginDisable: TButton
        Left = 92
        Top = 208
        Width = 75
        Height = 25
        Caption = #20572#27490'(&E)'
        Enabled = False
        TabOrder = 2
        OnClick = btnPluginDisableClick
      end
    end
    object tabRestrictions: TTabSheet
      Caption = #27231#33021#21046#38480
      ImageIndex = 2
      object grpRestrictions: TGroupBox
        Left = 16
        Top = 16
        Width = 217
        Height = 181
        Caption = #21046#38480#38917#30446
        TabOrder = 0
        object chkLockBtnEdit: TCheckBox
          Left = 16
          Top = 48
          Width = 141
          Height = 17
          Caption = #12508#12479#12531#12398#32232#38598#12434#31105#27490'(&E)'
          TabOrder = 1
          OnClick = chkLockBtnEditClick
        end
        object chkLockPadProperty: TCheckBox
          Left = 16
          Top = 96
          Width = 141
          Height = 17
          Caption = #12497#12483#12489#12398#35373#23450#12434#31105#27490'(&P)'
          TabOrder = 3
          OnClick = chkLockPadPropertyClick
        end
        object chkLockOption: TCheckBox
          Left = 16
          Top = 120
          Width = 137
          Height = 17
          Caption = #20840#20307#12398#35373#23450#12434#31105#27490'(&O)'
          TabOrder = 4
          OnClick = chkLockOptionClick
        end
        object chkLockBtnDrag: TCheckBox
          Left = 16
          Top = 24
          Width = 157
          Height = 17
          Caption = #12508#12479#12531#12398#12489#12521#12483#12464#12434#31105#27490'(&D)'
          TabOrder = 0
          OnClick = chkLockBtnDragClick
        end
        object chkLockPlugin: TCheckBox
          Left = 16
          Top = 144
          Width = 189
          Height = 17
          Caption = #12503#12521#12464#12452#12531#12398#36215#21205#12392#20572#27490#12434#31105#27490'(&I)'
          TabOrder = 5
          OnClick = chkLockPluginClick
        end
        object chkLockBtnFolder: TCheckBox
          Left = 16
          Top = 72
          Width = 189
          Height = 17
          Caption = '1 '#12388#19978#12398#12501#12457#12523#12480#12434#38283#12367#12434#31105#27490'(&F)'
          TabOrder = 2
          OnClick = chkLockBtnFolderClick
        end
      end
      object btnLockRestrictions: TButton
        Left = 244
        Top = 24
        Width = 201
        Height = 25
        Caption = #12497#12473#12527#12540#12489#12395#12424#12427#21046#38480#12398#12525#12483#12463'(&L)...'
        TabOrder = 1
        OnClick = btnLockRestrictionsClick
      end
      object btnUnlockRestrictions: TButton
        Left = 244
        Top = 56
        Width = 201
        Height = 25
        Caption = #12497#12473#12527#12540#12489#12395#12424#12427#12525#12483#12463#12398#35299#38500'(&U)...'
        TabOrder = 2
        OnClick = btnUnlockRestrictionsClick
      end
    end
  end
  object btnHelp: TButton
    Left = 12
    Top = 326
    Width = 75
    Height = 25
    Caption = #12504#12523#12503'(&H)'
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object imlPlugins: TImageList
    Height = 32
    Width = 32
    Left = 88
    Top = 325
  end
  object dlgOpen: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 148
    Top = 325
  end
end
