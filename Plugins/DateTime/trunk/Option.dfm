object dlgOption: TdlgOption
  Left = 476
  Top = 349
  BorderStyle = bsDialog
  Caption = #12459#12524#12531#12480#12540#12392#26178#35336#12503#12521#12464#12452#12531#12398#35373#23450
  ClientHeight = 408
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object OKBtn: TButton
    Left = 259
    Top = 372
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 339
    Top = 372
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 409
    Height = 357
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #12487#12470#12452#12531
      object Label1: TLabel
        Left = 48
        Top = 200
        Width = 83
        Height = 12
        Caption = #25351#23450#12377#12427#37096#20998'(&I):'
      end
      object lblColor: TLabel
        Left = 184
        Top = 276
        Width = 30
        Height = 12
        Caption = #33394'(&C):'
        FocusControl = cmbColor
      end
      object lblFontName: TLabel
        Left = 48
        Top = 232
        Width = 68
        Height = 12
        Caption = #12501#12457#12531#12488#21517'(&N):'
        FocusControl = cmbFontName
      end
      object lblFontSize: TLabel
        Left = 260
        Top = 232
        Width = 51
        Height = 12
        Caption = #12469#12452#12474'(&S):'
        FocusControl = cmbFontSize
      end
      object lblFontStyle: TLabel
        Left = 48
        Top = 276
        Width = 59
        Height = 12
        Caption = #12473#12479#12452#12523'(&T):'
        FocusControl = cmbFontStyle
      end
      object pnlDesign: TPanel
        Left = 16
        Top = 12
        Width = 365
        Height = 173
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clWhite
        TabOrder = 0
        object pbDesign: TPaintBox
          Left = 0
          Top = 0
          Width = 361
          Height = 169
          Align = alClient
          OnMouseDown = pbDesignMouseDown
          OnPaint = pbDesignPaint
        end
      end
      object cmbParts: TComboBox
        Left = 136
        Top = 196
        Width = 221
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 1
        OnChange = cmbPartsChange
      end
      object btnColor: TButton
        Left = 248
        Top = 292
        Width = 77
        Height = 21
        Caption = #12381#12398#20182'(&B)...'
        TabOrder = 6
        OnClick = btnColorClick
      end
      object cmbColor: TComboBox
        Left = 184
        Top = 292
        Width = 61
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 5
        OnChange = cmbColorChange
        OnDrawItem = cmbColorDrawItem
      end
      object cmbFontName: TComboBox
        Left = 48
        Top = 248
        Width = 209
        Height = 20
        ItemHeight = 12
        TabOrder = 2
        OnChange = cmbFontNameChange
      end
      object cmbFontSize: TComboBox
        Left = 260
        Top = 248
        Width = 65
        Height = 20
        ItemHeight = 12
        TabOrder = 3
        OnChange = cmbFontSizeChange
      end
      object cmbFontStyle: TComboBox
        Left = 48
        Top = 292
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 4
        OnChange = cmbFontStyleChange
      end
    end
  end
  object dlgColor: TColorDialog
    Options = [cdFullOpen]
    Left = 96
    Top = 319
  end
end
