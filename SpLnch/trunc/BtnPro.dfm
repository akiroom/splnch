object dlgBtnProperty: TdlgBtnProperty
  Left = 534
  Top = 265
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12508#12479#12531#12398#12503#12525#12497#12486#12451
  ClientHeight = 292
  ClientWidth = 365
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
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 196
    Top = 259
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 276
    Top = 259
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object pcKind: TPageControl
    Left = 8
    Top = 8
    Width = 349
    Height = 241
    ActivePage = tabPlugin
    Style = tsButtons
    TabIndex = 1
    TabOrder = 0
    object tabNormal: TTabSheet
      Caption = #12494#12540#12510#12523
      object Label5: TLabel
        Left = 4
        Top = 188
        Width = 96
        Height = 12
        Caption = #23455#34892#26178#12398#22823#12365#12373'(&S):'
        FocusControl = cmbNormalWindowSize
      end
      object Label3: TLabel
        Left = 4
        Top = 160
        Width = 101
        Height = 12
        Caption = #20316#26989#29992#12501#12457#12523#12480#65438'(&W):'
        FocusControl = edtNormalFolder
      end
      object Label4: TLabel
        Left = 4
        Top = 132
        Width = 78
        Height = 12
        Caption = #23455#34892#26178#24341#25968'(&O):'
        FocusControl = edtNormalOption
      end
      object Label2: TLabel
        Left = 4
        Top = 76
        Width = 57
        Height = 12
        Caption = #12522#12531#12463#20808'(&L):'
        FocusControl = edtNormalFileName
      end
      object Label1: TLabel
        Left = 4
        Top = 48
        Width = 42
        Height = 12
        Caption = #21517#21069'(&N):'
        FocusControl = edtNormalName
      end
      object imgNormalIcon: TImage
        Left = 4
        Top = 4
        Width = 32
        Height = 32
      end
      object cmbNormalWindowSize: TComboBox
        Left = 112
        Top = 184
        Width = 221
        Height = 20
        Style = csDropDownList
        DropDownCount = 3
        ItemHeight = 12
        TabOrder = 6
        Items.Strings = (
          #36890#24120#12398#12454#12451#12531#12489#12454
          #26368#23567#21270
          #26368#22823#21270)
      end
      object edtNormalFolder: TEdit
        Left = 112
        Top = 156
        Width = 221
        Height = 20
        TabOrder = 5
      end
      object edtNormalOption: TEdit
        Left = 112
        Top = 128
        Width = 221
        Height = 20
        TabOrder = 4
      end
      object btnNormalBrowse: TButton
        Left = 216
        Top = 96
        Width = 115
        Height = 25
        Caption = #12501#12449#12452#12523#21442#29031'(&B)...'
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clBtnText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnNormalBrowseClick
      end
      object edtNormalFileName: TEdit
        Left = 112
        Top = 72
        Width = 221
        Height = 20
        TabOrder = 2
        OnChange = edtNormalFileNameChange
      end
      object edtNormalName: TEdit
        Left = 112
        Top = 44
        Width = 221
        Height = 20
        TabOrder = 1
      end
      object btnNormalIcon: TButton
        Left = 64
        Top = 12
        Width = 129
        Height = 25
        Caption = #12450#12452#12467#12531#12398#22793#26356'(&I)...'
        TabOrder = 0
        OnClick = btnNormalIconClick
      end
    end
    object tabPlugin: TTabSheet
      Caption = #12503#12521#12464#12452#12531
      ImageIndex = 1
      object Label8: TLabel
        Left = 4
        Top = 48
        Width = 42
        Height = 12
        Caption = #21517#21069'(&N):'
        FocusControl = edtPluginName
      end
      object Label9: TLabel
        Left = 4
        Top = 76
        Width = 41
        Height = 12
        Caption = #31278#39006'(&K):'
        FocusControl = cmbPluginType
      end
      object Label10: TLabel
        Left = 4
        Top = 136
        Width = 70
        Height = 12
        Caption = #12501#12449#12452#12523#21517'(&F):'
        FocusControl = edtPluginFileName
      end
      object Label11: TLabel
        Left = 4
        Top = 156
        Width = 42
        Height = 12
        Caption = #25551#30011'(&D):'
        FocusControl = edtPluginOwnerDraw
      end
      object Label13: TLabel
        Left = 4
        Top = 112
        Width = 49
        Height = 12
        Caption = #20869#37096#21517'(&I):'
        FocusControl = edtPluginIDName
      end
      object imgPluginIcon: TImage
        Left = 4
        Top = 4
        Width = 32
        Height = 32
      end
      object edtPluginName: TEdit
        Left = 112
        Top = 44
        Width = 221
        Height = 20
        TabOrder = 0
      end
      object cmbPluginType: TComboBox
        Left = 112
        Top = 72
        Width = 221
        Height = 26
        Style = csOwnerDrawFixed
        ItemHeight = 20
        TabOrder = 1
        OnClick = cmbPluginTypeClick
        OnDrawItem = cmbPluginTypeDrawItem
      end
      object btnPluginOption: TButton
        Left = 176
        Top = 180
        Width = 75
        Height = 25
        Caption = #35373#23450'(&O)...'
        Enabled = False
        TabOrder = 5
        OnClick = btnPluginOptionClick
      end
      object btnPluginInfo: TButton
        Left = 256
        Top = 180
        Width = 75
        Height = 25
        Caption = #24773#22577'(&I)...'
        Enabled = False
        TabOrder = 6
        OnClick = btnPluginInfoClick
      end
      object edtPluginIDName: TEdit
        Left = 112
        Top = 108
        Width = 221
        Height = 20
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
      object edtPluginFileName: TEdit
        Left = 112
        Top = 132
        Width = 221
        Height = 20
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object edtPluginOwnerDraw: TEdit
        Left = 112
        Top = 156
        Width = 221
        Height = 20
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
      end
    end
  end
  object Panel1: TPanel
    Left = 216
    Top = 4
    Width = 133
    Height = 33
    BevelOuter = bvNone
    TabOrder = 3
    object Label6: TLabel
      Left = 4
      Top = 8
      Width = 64
      Height = 12
      Caption = #23455#34892#22238#25968'(&R)'
    end
    object edtClickCount: TEdit
      Left = 72
      Top = 6
      Width = 41
      Height = 20
      TabOrder = 0
      Text = '0'
    end
    object udClickCount: TUpDown
      Left = 113
      Top = 6
      Width = 15
      Height = 20
      Associate = edtClickCount
      Min = 0
      Max = 32767
      Position = 0
      TabOrder = 1
      Wrap = False
    end
  end
  object dlgBrowse: TOpenDialog
    Filter = #12503#12525#12464#12521#12512'(*.exe;*.lnk;*.url)|*.exe;*.lnk;*.url|'#12377#12409#12390#12398#12501#12449#12452#12523'(*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoDereferenceLinks, ofEnableSizing]
    Left = 24
    Top = 252
  end
  object tmNormalIconChange: TTimer
    Interval = 500
    OnTimer = tmNormalIconChangeTimer
    Left = 56
    Top = 252
  end
  object imlType: TImageList
    Left = 88
    Top = 252
  end
end
