object dlgEditKind: TdlgEditKind
  Left = 455
  Top = 207
  BorderStyle = bsDialog
  Caption = '��ނ̕ҏW'
  ClientHeight = 261
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '�l�r �o�S�V�b�N'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 12
    Top = 8
    Width = 76
    Height = 12
    Caption = '��ނ̈ꗗ(&L):'
    FocusControl = lstKind
  end
  object btnDown: TButton
    Left = 296
    Top = 188
    Width = 75
    Height = 25
    Caption = '����(&D)'
    TabOrder = 5
    OnClick = btnDownClick
  end
  object btnUp: TButton
    Left = 296
    Top = 160
    Width = 75
    Height = 25
    Caption = '���(&U)'
    TabOrder = 4
    OnClick = btnUpClick
  end
  object btnOk: TButton
    Left = 218
    Top = 228
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 298
    Top = 228
    Width = 75
    Height = 25
    Cancel = True
    Caption = '�L�����Z��'
    ModalResult = 2
    TabOrder = 7
  end
  object lstKind: TListBox
    Left = 8
    Top = 24
    Width = 273
    Height = 189
    ItemHeight = 16
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnDblClick = btnModifyClick
    OnDrawItem = lstKindDrawItem
  end
  object btnAdd: TButton
    Left = 296
    Top = 24
    Width = 75
    Height = 25
    Caption = '�ǉ�(&A)'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnModify: TButton
    Left = 296
    Top = 52
    Width = 75
    Height = 25
    Caption = '�ύX(&M)'
    TabOrder = 2
    OnClick = btnModifyClick
  end
  object btnRemove: TButton
    Left = 296
    Top = 80
    Width = 75
    Height = 25
    Caption = '�폜(&R)'
    TabOrder = 3
    OnClick = btnRemoveClick
  end
end
