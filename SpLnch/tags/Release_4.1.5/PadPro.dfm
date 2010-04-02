object dlgPadProperty: TdlgPadProperty
  Left = 331
  Top = 279
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12497#12483#12489#12398#35373#23450
  ClientHeight = 428
  ClientWidth = 475
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
  object PageControl: TPageControl
    Left = 4
    Top = 4
    Width = 465
    Height = 385
    ActivePage = tabDesign
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    object tabDesign: TTabSheet
      Caption = #12487#12470#12452#12531
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblParts: TLabel
        Left = 24
        Top = 168
        Width = 83
        Height = 12
        Caption = #25351#23450#12377#12427#37096#20998'(&I):'
        FocusControl = cmbParts
      end
      object scrDesign: TScrollBox
        Left = 16
        Top = 4
        Width = 421
        Height = 153
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Color = clTeal
        Ctl3D = True
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 0
        OnMouseDown = scrDesignMouseDown
        object pnlPad: TPanel
          Left = 12
          Top = 12
          Width = 317
          Height = 141
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          TabOrder = 0
          object pnlDragBar: TPanel
            Left = 1
            Top = 1
            Width = 33
            Height = 139
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object pbDragBar: TPaintBox
              Left = 0
              Top = 0
              Width = 33
              Height = 139
              Align = alClient
              OnPaint = pbDragBarPaint
            end
          end
          object pnlWorkspace: TPanel
            Left = 34
            Top = 1
            Width = 282
            Height = 139
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object pnlScrollBar: TPanel
              Left = 220
              Top = 0
              Width = 62
              Height = 139
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 0
              object pbScrollBar: TPaintBox
                Left = 0
                Top = 0
                Width = 62
                Height = 139
                Align = alClient
                OnPaint = pbScrollBarPaint
              end
            end
            object pnlButtons: TPanel
              Left = 0
              Top = 0
              Width = 220
              Height = 139
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object pbWorkspace: TPaintBox
                Left = 0
                Top = 0
                Width = 220
                Height = 139
                Align = alClient
                OnPaint = pbWorkspacePaint
              end
            end
          end
        end
        object pnlHide: TPanel
          Left = 207
          Top = 0
          Width = 185
          Height = 17
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 1
          object pbHide: TPaintBox
            Left = 0
            Top = 0
            Width = 185
            Height = 17
            Align = alClient
            OnPaint = pbHidePaint
          end
        end
        object pnlButtonLabel: TPanel
          Left = 276
          Top = 12
          Width = 41
          Height = 17
          Caption = #12508#12479#12531
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnClick = PartLabelClick
        end
        object pnlSelButtonLabel: TPanel
          Left = 276
          Top = 32
          Width = 93
          Height = 17
          Caption = #36984#25246#12373#12428#12383#12508#12479#12531
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          OnClick = PartLabelClick
        end
        object pnlDragBarLabel: TPanel
          Left = 276
          Top = 52
          Width = 73
          Height = 17
          Caption = #12489#12521#12483#12464#12496#12540
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          OnClick = PartLabelClick
        end
        object pnlScrollBarLabel: TPanel
          Left = 276
          Top = 72
          Width = 85
          Height = 17
          Caption = #12473#12463#12525#12540#12523#12496#12540
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 5
          OnClick = PartLabelClick
        end
        object pnlWorkSpaceLabel: TPanel
          Left = 276
          Top = 92
          Width = 85
          Height = 17
          Caption = #12527#12540#12463#12473#12506#12540#12473
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 6
          OnClick = PartLabelClick
        end
        object pnlHideLabel: TPanel
          Left = 276
          Top = 112
          Width = 89
          Height = 17
          Caption = #38560#12428#12390#12356#12427#29366#24907
          Color = clInfoBk
          Ctl3D = False
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ParentBackground = False
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 7
          OnClick = PartLabelClick
        end
      end
      object cmbParts: TComboBox
        Left = 120
        Top = 164
        Width = 133
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
        OnChange = cmbPartsChange
      end
      object chkVisiblePartLabels: TCheckBox
        Left = 264
        Top = 165
        Width = 169
        Height = 17
        Caption = #25351#23450#12377#12427#37096#20998#12434#34920#31034#12377#12427'(&V)'
        TabOrder = 2
        OnClick = chkVisiblePartLabelsClick
      end
      object pnlTabButton: TPanel
        Left = 24
        Top = 172
        Width = 321
        Height = 149
        TabOrder = 3
        object lblBtnCaption: TLabel
          Left = 0
          Top = 104
          Width = 60
          Height = 12
          Caption = #12508#12479#12531#21517'(&N):'
          FocusControl = cmbBtnCaption
        end
        object shpBtnColor: TShape
          Left = 96
          Top = 4
          Width = 53
          Height = 21
        end
        object lblBtnColor: TLabel
          Left = 0
          Top = 8
          Width = 14
          Height = 12
          Caption = #33394':'
        end
        object lblBtnWidth: TLabel
          Left = 96
          Top = 52
          Width = 31
          Height = 12
          Caption = #24133'(&W):'
          FocusControl = edtBtnWidth
        end
        object lblBtnHeight: TLabel
          Left = 208
          Top = 52
          Width = 39
          Height = 12
          Caption = #39640#12373'(&H):'
          FocusControl = edtBtnHeight
        end
        object Label2: TLabel
          Left = 0
          Top = 52
          Width = 36
          Height = 12
          Caption = #12469#12452#12474':'
        end
        object cmbBtnCaption: TComboBox
          Left = 96
          Top = 100
          Width = 129
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 8
          OnChange = cmbBtnCaptionChange
          Items.Strings = (
            #34920#31034#12375#12394#12356
            #12450#12452#12467#12531#12398#19979#12395#34920#31034
            #12450#12452#12467#12531#12398#21491#12395#34920#31034)
        end
        object chkBtnSmallIcon: TCheckBox
          Left = 96
          Top = 124
          Width = 149
          Height = 17
          Caption = #23567#12373#12356#12450#12452#12467#12531#12434#20351#12358'(&S)'
          TabOrder = 9
          OnClick = chkBtnSmallIconClick
        end
        object btnBtnColor: TButton
          Left = 156
          Top = 4
          Width = 65
          Height = 21
          Caption = #22793#26356'(&C)...'
          TabOrder = 0
          OnClick = btnBtnColorClick
        end
        object chkBtnTransparent: TCheckBox
          Left = 96
          Top = 28
          Width = 65
          Height = 17
          Caption = #36879#26126'(&T)'
          TabOrder = 2
          OnClick = chkBtnTransparentClick
        end
        object edtBtnWidth: TEdit
          Left = 136
          Top = 48
          Width = 37
          Height = 20
          TabOrder = 3
          Text = '8'
          OnChange = edtBtnWidthChange
        end
        object udBtnWidth: TUpDown
          Left = 173
          Top = 48
          Width = 16
          Height = 20
          Associate = edtBtnWidth
          Min = 8
          Max = 128
          Increment = 4
          Position = 8
          TabOrder = 4
        end
        object edtBtnHeight: TEdit
          Left = 256
          Top = 48
          Width = 37
          Height = 20
          TabOrder = 5
          Text = '8'
          OnChange = edtBtnHeightChange
        end
        object chkBtnSquare: TCheckBox
          Left = 96
          Top = 72
          Width = 117
          Height = 17
          Caption = #24133#12392#39640#12373#12398#32113#19968'(&U)'
          TabOrder = 7
          OnClick = chkBtnSquareClick
        end
        object btnBtnColorDefault: TButton
          Left = 224
          Top = 4
          Width = 93
          Height = 21
          Caption = 'Windows '#33394'(&D)'
          TabOrder = 1
          OnClick = btnDefaultColorClick
        end
        object udBtnHeight: TUpDown
          Left = 293
          Top = 48
          Width = 16
          Height = 20
          Associate = edtBtnHeight
          Min = 8
          Max = 128
          Increment = 4
          Position = 8
          TabOrder = 6
        end
      end
      object pnlTabSelButton: TPanel
        Left = 88
        Top = 208
        Width = 333
        Height = 53
        TabOrder = 4
        object lblBtnFocusColor: TLabel
          Left = 0
          Top = 8
          Width = 14
          Height = 12
          Caption = #33394':'
        end
        object shpBtnFocusColor: TShape
          Left = 96
          Top = 4
          Width = 53
          Height = 21
        end
        object btnBtnFocusColor: TButton
          Left = 156
          Top = 4
          Width = 65
          Height = 21
          Caption = #22793#26356'(&C)...'
          TabOrder = 0
          OnClick = btnBtnFocusColorClick
        end
        object chkBtnSelTransparent: TCheckBox
          Left = 96
          Top = 28
          Width = 149
          Height = 17
          Caption = #12371#12398#33394#12391#12508#12479#12531#12434#35206#12358'(&R)'
          TabOrder = 2
          OnClick = chkBtnSelTransparentClick
        end
        object btnBtnFocusColorDefault: TButton
          Left = 224
          Top = 4
          Width = 93
          Height = 21
          Caption = 'Windows '#33394'(&D)'
          TabOrder = 1
          OnClick = btnDefaultColorClick
        end
      end
      object pnlTabDragBar: TPanel
        Left = 40
        Top = 236
        Width = 285
        Height = 85
        TabOrder = 5
        object lblDragBar: TLabel
          Left = 0
          Top = 8
          Width = 41
          Height = 12
          Caption = #20301#32622'(&P):'
          FocusControl = cmbDragBar
        end
        object lblDragBarSize: TLabel
          Left = 96
          Top = 56
          Width = 51
          Height = 12
          Caption = #12469#12452#12474'(&S):'
          FocusControl = edtDragBarSize
        end
        object cmbDragBar: TComboBox
          Left = 96
          Top = 4
          Width = 121
          Height = 26
          Style = csOwnerDrawFixed
          ItemHeight = 20
          TabOrder = 0
          OnChange = cmbDragBarChange
          OnDrawItem = LayoutComboBoxDrawItem
          Items.Strings = (
            #34920#31034#12375#12394#12356
            #24038#12395#34920#31034
            #19978#12395#34920#31034
            #21491#12395#34920#31034
            #19979#12395#34920#31034)
        end
        object chkGroupName: TCheckBox
          Left = 96
          Top = 32
          Width = 189
          Height = 17
          Caption = #12508#12479#12531#12464#12523#12540#12503#21517#12434#34920#31034#12377#12427'(&T)'
          Enabled = False
          TabOrder = 1
          OnClick = chkGroupNameClick
        end
        object edtDragBarSize: TEdit
          Left = 156
          Top = 52
          Width = 45
          Height = 20
          TabOrder = 2
          Text = '4'
          OnChange = edtDragBarSizeChange
        end
        object udDragBarSize: TUpDown
          Left = 201
          Top = 52
          Width = 16
          Height = 20
          Associate = edtDragBarSize
          Min = 4
          Position = 4
          TabOrder = 3
        end
      end
      object pnlTabScrollBar: TPanel
        Left = 12
        Top = 268
        Width = 345
        Height = 105
        TabOrder = 6
        object lblScrollBar: TLabel
          Left = 0
          Top = 8
          Width = 41
          Height = 12
          Caption = #20301#32622'(&P):'
          FocusControl = cmbScrollBar
        end
        object lblScrollSize: TLabel
          Left = 96
          Top = 80
          Width = 51
          Height = 12
          Caption = #12469#12452#12474'(&S):'
          FocusControl = edtScrollSize
        end
        object cmbScrollBar: TComboBox
          Left = 96
          Top = 4
          Width = 121
          Height = 26
          Style = csOwnerDrawFixed
          ItemHeight = 20
          TabOrder = 0
          OnChange = cmbScrollBarChange
          OnDrawItem = LayoutComboBoxDrawItem
          Items.Strings = (
            #34920#31034#12375#12394#12356
            #24038#12395#34920#31034
            #19978#12395#34920#31034
            #21491#12395#34920#31034
            #19979#12395#34920#31034)
        end
        object chkScrollBtn: TCheckBox
          Left = 96
          Top = 32
          Width = 185
          Height = 17
          Caption = #12473#12463#12525#12540#12523#12508#12479#12531#12434#34920#31034#12377#12427'(&B)'
          Enabled = False
          TabOrder = 1
          OnClick = chkScrollBtnClick
        end
        object edtScrollSize: TEdit
          Left = 156
          Top = 76
          Width = 45
          Height = 20
          TabOrder = 3
          Text = '4'
          OnChange = edtScrollSizeChange
        end
        object udScrollSize: TUpDown
          Left = 201
          Top = 76
          Width = 16
          Height = 20
          Associate = edtScrollSize
          Min = 4
          Position = 4
          TabOrder = 4
        end
        object chkGroupBtn: TCheckBox
          Left = 96
          Top = 52
          Width = 245
          Height = 17
          Caption = #12508#12479#12531#12464#12523#12540#12503#20999#12426#26367#12360#12508#12479#12531#12434#34920#31034#12377#12427'(&G)'
          Enabled = False
          TabOrder = 2
          OnClick = chkGroupBtnClick
        end
      end
      object pnlTabWorkspace: TPanel
        Left = 48
        Top = 292
        Width = 349
        Height = 125
        TabOrder = 7
        object lblBackColor: TLabel
          Left = 0
          Top = 8
          Width = 14
          Height = 12
          Caption = #33394':'
        end
        object shpBackColor: TShape
          Left = 96
          Top = 4
          Width = 53
          Height = 21
        end
        object lblWallPaper: TLabel
          Left = 0
          Top = 36
          Width = 43
          Height = 12
          Caption = #22721#32025'(&W):'
          FocusControl = edtWallPaper
        end
        object lblLayout: TLabel
          Left = 0
          Top = 88
          Width = 84
          Height = 12
          Caption = #12508#12479#12531#12398#37197#32622'(&A):'
          FocusControl = cmbLayout
        end
        object btnBackColor: TButton
          Left = 156
          Top = 4
          Width = 65
          Height = 21
          Caption = #22793#26356'(&C)...'
          TabOrder = 0
          OnClick = btnBackColorClick
        end
        object edtWallPaper: TEdit
          Left = 96
          Top = 32
          Width = 237
          Height = 20
          TabOrder = 2
          OnChange = edtWallPaperChange
        end
        object btnWallPaperClear: TButton
          Left = 200
          Top = 56
          Width = 65
          Height = 21
          Caption = #12463#12522#12450'(&L)'
          TabOrder = 3
          OnClick = btnWallPaperClearClick
        end
        object btnWallPaper: TButton
          Left = 268
          Top = 56
          Width = 65
          Height = 21
          Caption = #21442#29031'(&B)...'
          TabOrder = 4
          OnClick = btnWallPaperClick
        end
        object cmbLayout: TComboBox
          Left = 96
          Top = 84
          Width = 125
          Height = 26
          Style = csOwnerDrawFixed
          ItemHeight = 20
          TabOrder = 5
          OnChange = cmbLayoutChange
          OnDrawItem = LayoutComboBoxDrawItem
          Items.Strings = (
            #27178#26041#21521#12395#37197#32622
            #32294#26041#21521#12395#37197#32622)
        end
        object btnBackColorDefault: TButton
          Left = 224
          Top = 4
          Width = 93
          Height = 21
          Caption = 'Windows '#33394'(&D)'
          TabOrder = 1
          OnClick = btnDefaultColorClick
        end
      end
      object pnlTabHide: TPanel
        Left = 112
        Top = 264
        Width = 321
        Height = 89
        TabOrder = 8
        object lblHideColor: TLabel
          Left = 0
          Top = 8
          Width = 14
          Height = 12
          Caption = #33394':'
        end
        object shpHideColor: TShape
          Left = 96
          Top = 4
          Width = 53
          Height = 21
        end
        object lblHideSize: TLabel
          Left = 0
          Top = 60
          Width = 51
          Height = 12
          Caption = #12469#12452#12474'(&S):'
          FocusControl = edtHideSize
        end
        object btnHideColor: TButton
          Left = 156
          Top = 4
          Width = 65
          Height = 21
          Caption = #22793#26356'(&C)...'
          TabOrder = 0
          OnClick = btnHideColorClick
        end
        object edtHideSize: TEdit
          Left = 96
          Top = 56
          Width = 37
          Height = 20
          TabOrder = 3
          Text = '0'
          OnChange = edtHideSizeChange
        end
        object udHideSize: TUpDown
          Left = 133
          Top = 56
          Width = 16
          Height = 20
          Associate = edtHideSize
          TabOrder = 4
        end
        object chkHideGroupName: TCheckBox
          Left = 96
          Top = 32
          Width = 189
          Height = 17
          Caption = #12508#12479#12531#12464#12523#12540#12503#21517#12434#34920#31034#12377#12427'(&T)'
          TabOrder = 2
          OnClick = chkHideGroupNameClick
        end
        object btnHideColorDefault: TButton
          Left = 224
          Top = 4
          Width = 93
          Height = 21
          Caption = 'Windows '#33394'(&D)'
          TabOrder = 1
          OnClick = btnDefaultColorClick
        end
      end
    end
    object tabMove: TTabSheet
      Caption = #21205#20316
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblActiveKey: TLabel
        Left = 216
        Top = 12
        Width = 154
        Height = 12
        Caption = #12450#12463#12486#12451#12502#12395#12377#12427#12507#12483#12488#12461#12540'(&H):'
        FocusControl = hkActiveKey
      end
      object lblDropAction: TLabel
        Left = 24
        Top = 64
        Width = 182
        Height = 12
        Caption = #12501#12449#12452#12523#12434#12489#12525#12483#12503#12375#12383#12392#12365#12398#21205#20316'(&D):'
        FocusControl = cmbDropAction
      end
      object lblDblClickAction: TLabel
        Left = 24
        Top = 108
        Width = 181
        Height = 12
        Caption = #12527#12540#12463#12473#12506#12540#12473#12398#12480#12502#12523#12463#12522#12483#12463'(&W):'
        FocusControl = cmbDblClickAction
      end
      object lblHideCorner: TLabel
        Left = 24
        Top = 236
        Width = 141
        Height = 12
        Caption = #30011#38754#12398#22235#38533#12391#12398#38560#12428#12427#21205#20316
      end
      object lblHideDelay: TLabel
        Left = 24
        Top = 292
        Width = 159
        Height = 12
        Caption = #38560#12428#12427#21205#20316#12398#36933#24310#26178#38291'(ms)(&H):'
        FocusControl = edtHideDelay
      end
      object lblShowDelay: TLabel
        Left = 24
        Top = 264
        Width = 159
        Height = 12
        Caption = #29694#12428#12427#21205#20316#12398#36933#24310#26178#38291'(ms)(&V):'
        FocusControl = edtShowDelay
      end
      object Label1: TLabel
        Left = 68
        Top = 216
        Width = 236
        Height = 12
        Caption = #8251' '#12489#12525#12483#12503#26178#12399#12371#12398#35373#23450#12395#20418#12431#12425#12378#29694#12428#12414#12377#12290
      end
      object chkTopMost: TCheckBox
        Left = 24
        Top = 12
        Width = 145
        Height = 17
        Caption = #24120#12395#25163#21069#12395#34920#31034#12377#12427'(&M)'
        TabOrder = 0
        OnClick = chkTopMostClick
      end
      object chkSmoothScroll: TCheckBox
        Left = 24
        Top = 32
        Width = 189
        Height = 17
        Caption = #12473#12463#12525#12540#12523#12434#12394#12417#12425#12363#12395#12377#12427'(&S)'
        TabOrder = 1
        OnClick = chkSmoothScrollClick
      end
      object hkActiveKey: THotKey
        Left = 264
        Top = 28
        Width = 141
        Height = 18
        HotKey = 0
        Modifiers = []
        TabOrder = 2
        OnEnter = hkActiveKeyEnter
      end
      object cmbDropAction: TComboBox
        Left = 72
        Top = 80
        Width = 253
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 3
        OnChange = cmbDropActionChange
        Items.Strings = (
          #12489#12525#12483#12503#12375#12383#22580#25152#12395#30331#37682#12377#12427
          #26368#24460#12395#30331#37682#12377#12427
          #12489#12525#12483#12503#20808#12398#12508#12479#12531#12391#38283#12367
          #12501#12449#12452#12523#21517#12434#12467#12500#12540#12377#12427' ')
      end
      object cmbDblClickAction: TComboBox
        Left = 72
        Top = 124
        Width = 253
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 4
        OnChange = cmbDblClickActionChange
        Items.Strings = (
          #25351#23450#12375#12390#23455#34892#12434#38283#12367
          #12508#12479#12531#12398#32232#38598#12434#38283#12367
          #12508#12479#12531#12464#12523#12540#12503#22793#26356#12513#12491#12517#12540#12434#38283#12367
          #27425#12398#12508#12479#12531#12464#12523#12540#12503#12408#31227#21205#12377#12427
          #12497#12483#12489#12398#35373#23450#12434#38283#12367
          #20840#20307#12398#35373#23450#12434#38283#12367
          #12497#12483#12489#12434#38560#12377)
      end
      object chkHideAuto: TCheckBox
        Left = 24
        Top = 156
        Width = 109
        Height = 17
        Caption = #33258#21205#30340#12395#38560#12377'(&U)'
        TabOrder = 5
        OnClick = chkHideAutoClick
      end
      object rdoHideHorizontal: TRadioButton
        Left = 172
        Top = 234
        Width = 97
        Height = 17
        Caption = #24038#21491#12434#20778#20808'(&L)'
        Checked = True
        TabOrder = 8
        TabStop = True
        OnClick = rdoHideHorizontalClick
      end
      object rdoHideVertical: TRadioButton
        Left = 268
        Top = 234
        Width = 97
        Height = 17
        Caption = #19978#19979#12434#20778#20808'(&T)'
        TabOrder = 9
        OnClick = rdoHideHorizontalClick
      end
      object chkHideSmooth: TCheckBox
        Left = 24
        Top = 176
        Width = 189
        Height = 17
        Caption = #38560#12428#12427#21205#20316#12434#12394#12417#12425#12363#12395#12377#12427'(&S)'
        TabOrder = 6
        OnClick = chkHideSmoothClick
      end
      object edtHideDelay: TEdit
        Left = 188
        Top = 288
        Width = 37
        Height = 20
        TabOrder = 12
        Text = '400'
        OnChange = edtShowDelayChange
      end
      object udHideDelay: TUpDown
        Left = 225
        Top = 288
        Width = 16
        Height = 20
        Associate = edtHideDelay
        Min = 1
        Max = 2000
        Increment = 10
        Position = 400
        TabOrder = 13
      end
      object edtShowDelay: TEdit
        Left = 188
        Top = 260
        Width = 37
        Height = 20
        TabOrder = 10
        Text = '100'
        OnChange = edtShowDelayChange
      end
      object udShowDelay: TUpDown
        Left = 225
        Top = 260
        Width = 16
        Height = 20
        Associate = edtShowDelay
        Min = 1
        Max = 2000
        Increment = 10
        Position = 100
        TabOrder = 11
      end
      object chkHideMouseCheck: TCheckBox
        Left = 24
        Top = 196
        Width = 317
        Height = 17
        Caption = #38560#12428#12390#12356#12427#29366#24907#12391#12399#12510#12454#12473#12509#12452#12531#12479#12398#36890#36942#12391#29694#12428#12427'(&M)'
        TabOrder = 7
        OnClick = chkHideMouseCheckClick
      end
    end
    object tabSkins: TTabSheet
      Caption = #12473#12461#12531
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblPlugins: TLabel
        Left = 24
        Top = 12
        Width = 102
        Height = 12
        Caption = #12473#12461#12531#12503#12521#12464#12452#12531'(&P):'
      end
      object btnPluginInfo: TButton
        Left = 348
        Top = 76
        Width = 75
        Height = 25
        Caption = #24773#22577'(&I)...'
        Enabled = False
        TabOrder = 0
      end
      object cmbSkins: TComboBox
        Left = 24
        Top = 28
        Width = 401
        Height = 42
        Style = csOwnerDrawFixed
        ItemHeight = 36
        TabOrder = 1
        OnChange = cmbSkinsChange
        OnDrawItem = cmbSkinsDrawItem
      end
      object btnPluginOption: TButton
        Left = 268
        Top = 76
        Width = 75
        Height = 25
        Caption = #35373#23450'(&O)...'
        Enabled = False
        TabOrder = 2
      end
    end
  end
  object btnOk: TButton
    Left = 231
    Top = 396
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 311
    Top = 396
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 391
    Top = 396
    Width = 75
    Height = 25
    Caption = #36969#29992'(&A)'
    TabOrder = 4
    OnClick = btnApplyClick
  end
  object btnHelp: TButton
    Left = 8
    Top = 396
    Width = 75
    Height = 25
    Caption = #12504#12523#12503'(&H)'
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object dlgColor: TColorDialog
    Options = [cdFullOpen]
    Left = 68
    Top = 451
  end
  object dlgOpen: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 104
    Top = 452
  end
  object imlLayout: TImageList
    Left = 32
    Top = 452
  end
  object imlPlugins: TImageList
    Height = 32
    Width = 32
    Left = 140
    Top = 395
  end
end
