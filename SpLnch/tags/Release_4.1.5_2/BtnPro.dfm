object dlgBtnProperty: TdlgBtnProperty
  Left = 534
  Top = 265
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12508#12479#12531#12398#12503#12525#12497#12486#12451
  ClientHeight = 294
  ClientWidth = 374
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
    374
    294)
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 211
    Top = 261
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
    ExplicitLeft = 216
  end
  object btnCancel: TButton
    Left = 291
    Top = 261
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
    ExplicitLeft = 296
  end
  object pcKind: TPageControl
    Left = 8
    Top = 8
    Width = 358
    Height = 237
    ActivePage = tabNormal
    Anchors = [akLeft, akTop, akRight]
    Style = tsButtons
    TabOrder = 0
    ExplicitWidth = 363
    object tabNormal: TTabSheet
      Caption = #12494#12540#12510#12523
      ExplicitWidth = 393
      ExplicitHeight = 203
      DesignSize = (
        350
        207)
      object Label5: TLabel
        Left = 4
        Top = 183
        Width = 96
        Height = 12
        Caption = #23455#34892#26178#12398#22823#12365#12373'(&S):'
        FocusControl = cmbNormalWindowSize
      end
      object Label3: TLabel
        Left = 4
        Top = 157
        Width = 101
        Height = 12
        Caption = #20316#26989#29992#12501#12457#12523#12480#65438'(&W):'
        FocusControl = edtNormalFolder
      end
      object Label4: TLabel
        Left = 4
        Top = 131
        Width = 78
        Height = 12
        Caption = #23455#34892#26178#24341#25968'(&O):'
        FocusControl = edtNormalOption
      end
      object Label2: TLabel
        Left = 4
        Top = 75
        Width = 57
        Height = 12
        Caption = #12522#12531#12463#20808'(&L):'
        FocusControl = edtNormalFileName
      end
      object Label1: TLabel
        Left = 4
        Top = 47
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
        Left = 111
        Top = 180
        Width = 235
        Height = 20
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 3
        ItemHeight = 12
        TabOrder = 7
        Items.Strings = (
          #36890#24120#12398#12454#12451#12531#12489#12454
          #26368#23567#21270
          #26368#22823#21270)
        ExplicitWidth = 278
      end
      object edtNormalFolder: TEdit
        Left = 112
        Top = 154
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        ExplicitWidth = 278
      end
      object edtNormalOption: TEdit
        Left = 112
        Top = 128
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        ExplicitWidth = 278
      end
      object btnNormalBrowse: TButton
        Left = 232
        Top = 97
        Width = 115
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #12501#12449#12452#12523#21442#29031'(&B)...'
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clBtnText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnNormalBrowseClick
        ExplicitLeft = 275
      end
      object edtNormalFileName: TEdit
        Left = 112
        Top = 72
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = edtNormalFileNameChange
        ExplicitWidth = 278
      end
      object edtNormalName: TEdit
        Left = 112
        Top = 44
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        ExplicitWidth = 278
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
      object btnNormalRelativePath: TButton
        Left = 111
        Top = 97
        Width = 115
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #30456#23550#12497#12473#12395#22793#25563'(&R)'
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clBtnText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnNormalRelativePathClick
        ExplicitLeft = 154
      end
    end
    object tabPlugin: TTabSheet
      Caption = #12503#12521#12464#12452#12531
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 24
      ExplicitWidth = 393
      DesignSize = (
        350
        207)
      object Label8: TLabel
        Left = 3
        Top = 47
        Width = 42
        Height = 12
        Caption = #21517#21069'(&N):'
        FocusControl = edtPluginName
      end
      object Label9: TLabel
        Left = 3
        Top = 75
        Width = 41
        Height = 12
        Caption = #31278#39006'(&K):'
        FocusControl = cmbPluginType
      end
      object Label10: TLabel
        Left = 3
        Top = 135
        Width = 70
        Height = 12
        Caption = #12501#12449#12452#12523#21517'(&F):'
        FocusControl = edtPluginFileName
      end
      object Label11: TLabel
        Left = 3
        Top = 156
        Width = 42
        Height = 12
        Caption = #25551#30011'(&D):'
        FocusControl = edtPluginOwnerDraw
      end
      object Label13: TLabel
        Left = 3
        Top = 111
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
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitWidth = 278
      end
      object cmbPluginType: TComboBox
        Left = 112
        Top = 72
        Width = 235
        Height = 26
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 20
        TabOrder = 1
        OnClick = cmbPluginTypeClick
        OnDrawItem = cmbPluginTypeDrawItem
        ExplicitWidth = 278
      end
      object btnPluginOption: TButton
        Left = 192
        Top = 182
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #35373#23450'(&O)...'
        Enabled = False
        TabOrder = 5
        OnClick = btnPluginOptionClick
        ExplicitLeft = 235
      end
      object btnPluginInfo: TButton
        Left = 272
        Top = 182
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #24773#22577'(&I)...'
        Enabled = False
        TabOrder = 6
        OnClick = btnPluginInfoClick
        ExplicitLeft = 315
      end
      object edtPluginIDName: TEdit
        Left = 112
        Top = 108
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
        ExplicitWidth = 278
      end
      object edtPluginFileName: TEdit
        Left = 112
        Top = 132
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
        ExplicitWidth = 278
      end
      object edtPluginOwnerDraw: TEdit
        Left = 112
        Top = 156
        Width = 235
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
        ExplicitWidth = 278
      end
    end
  end
  object Panel1: TPanel
    Left = 231
    Top = 8
    Width = 135
    Height = 29
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 274
    object Label6: TLabel
      Left = 4
      Top = 6
      Width = 64
      Height = 12
      Caption = #23455#34892#22238#25968'(&R)'
    end
    object edtClickCount: TEdit
      Left = 72
      Top = 4
      Width = 41
      Height = 20
      TabOrder = 0
      Text = '0'
    end
    object udClickCount: TUpDown
      Left = 113
      Top = 4
      Width = 15
      Height = 20
      Associate = edtClickCount
      Max = 32767
      TabOrder = 1
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
