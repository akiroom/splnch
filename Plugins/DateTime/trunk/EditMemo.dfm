object dlgEditMemo: TdlgEditMemo
  Left = 405
  Top = 217
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'ÉÅÉÇ'
  ClientHeight = 312
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'ÇlÇr ÇoÉSÉVÉbÉN'
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
    Left = 272
    Top = 276
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 276
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'ÉLÉÉÉìÉZÉã'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 420
    Height = 262
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'ÉÅÉÇ'
      object lblBegin: TLabel
        Left = 12
        Top = 180
        Width = 42
        Height = 12
        Anchors = [akLeft, akBottom]
        Caption = 'äJén(&B):'
        FocusControl = dtpBegin
      end
      object lblEnd: TLabel
        Left = 168
        Top = 180
        Width = 41
        Height = 12
        Anchors = [akLeft, akBottom]
        Caption = 'èIóπ(&E):'
        FocusControl = dtpEnd
      end
      object lblMemo: TLabel
        Left = 12
        Top = 8
        Width = 42
        Height = 12
        Caption = 'ì‡óe(&D):'
        FocusControl = memMemo
      end
      object lblKind: TLabel
        Left = 12
        Top = 209
        Width = 41
        Height = 12
        Anchors = [akLeft, akBottom]
        Caption = 'éÌóﬁ(&K):'
        FocusControl = cmbKind
      end
      object memMemo: TMemo
        Left = 8
        Top = 24
        Width = 393
        Height = 145
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'ÇlÇr ÉSÉVÉbÉN'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object dtpBegin: TDateTimePicker
        Left = 64
        Top = 176
        Width = 93
        Height = 20
        Anchors = [akLeft, akBottom]
        CalAlignment = dtaLeft
        Date = 36599
        Time = 36599
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
        OnChange = dtpBeginChange
      end
      object dtpEnd: TDateTimePicker
        Left = 216
        Top = 176
        Width = 93
        Height = 20
        Anchors = [akLeft, akBottom]
        CalAlignment = dtaLeft
        Date = 36599.6399090046
        Time = 36599.6399090046
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 2
        OnChange = dtpEndChange
      end
      object cmbKind: TComboBox
        Left = 64
        Top = 204
        Width = 133
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akBottom]
        ItemHeight = 16
        TabOrder = 3
        OnDrawItem = cmbKindDrawItem
      end
      object btnEditKind: TButton
        Left = 208
        Top = 204
        Width = 85
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'éÌóﬁÇÃï“èW(&I)...'
        TabOrder = 4
        OnClick = btnEditKindClick
      end
    end
  end
end
