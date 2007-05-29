object frmCal: TfrmCal
  Left = 371
  Top = 463
  AutoScroll = False
  Caption = #12459#12524#12531#12480#12540
  ClientHeight = 245
  ClientWidth = 357
  Color = clWhite
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 357
    Height = 245
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    FullRepaint = False
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      353
      241)
    object pbCalendar: TPaintBox
      Left = 8
      Top = 36
      Width = 336
      Height = 197
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      OnDblClick = pbCalendarDblClick
      OnMouseDown = pbCalendarMouseDown
      OnMouseMove = pbCalendarMouseMove
      OnMouseUp = pbCalendarMouseUp
      OnPaint = pbCalendarPaint
    end
    object pbMonth: TPaintBox
      Left = 8
      Top = 4
      Width = 336
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      OnPaint = pbMonthPaint
    end
    object btnToday: TSpeedButton
      Left = 149
      Top = 209
      Width = 45
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #20170#26085
      OnClick = btnTodayClick
    end
    object btnPrev: TSpeedButton
      Left = 197
      Top = 209
      Width = 45
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #21069#26376
      OnClick = btnPrevClick
    end
    object btnNext: TSpeedButton
      Left = 245
      Top = 209
      Width = 45
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #27425#26376
      OnClick = btnNextClick
    end
    object btnClose: TSpeedButton
      Left = 293
      Top = 209
      Width = 45
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #38281#12376#12427
      OnClick = mnuCloseClick
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    OnPopup = PopupMenu1Popup
    Left = 54
    Top = 62
    object mnuMemoNew: TMenuItem
      Caption = #12513#12514#12398#26032#35215#20316#25104'(&N)...'
      OnClick = mnuMemoNewClick
    end
    object mnuMemoModify: TMenuItem
      Caption = #12513#12514#12398#22793#26356'(&M)...'
      OnClick = mnuMemoModifyClick
    end
    object mnuMemoDelete: TMenuItem
      Caption = #12513#12514#12398#21066#38500'(&D)'
      OnClick = mnuMemoDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuMemoFilter: TMenuItem
      Caption = #12513#12514#12398#12501#12451#12523#12479'(&F)...'
      OnClick = mnuMemoFilterClick
    end
    object mnuMemoNoFilter: TMenuItem
      Caption = #12501#12451#12523#12479#35299#38500'(&U)'
      OnClick = mnuMemoNoFilterClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuMemoList: TMenuItem
      Caption = #12513#12514#19968#35239'(&L)...'
      OnClick = mnuMemoListClick
    end
    object mnuOption: TMenuItem
      Caption = #35373#23450'(&O)...'
      OnClick = mnuOptionClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuClose: TMenuItem
      Caption = #38281#12376#12427'(&C)'
      OnClick = mnuCloseClick
    end
  end
end
