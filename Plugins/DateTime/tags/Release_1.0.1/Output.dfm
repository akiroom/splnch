object dlgOutput: TdlgOutput
  Left = 483
  Top = 416
  BorderStyle = bsDialog
  Caption = '�����o��'
  ClientHeight = 162
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '�l�r �o�S�V�b�N'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 130
    Top = 124
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 210
    Top = 124
    Width = 75
    Height = 25
    Cancel = True
    Caption = '�L�����Z��'
    ModalResult = 2
    TabOrder = 1
  end
  object rdoMedia: TRadioGroup
    Left = 16
    Top = 8
    Width = 265
    Height = 41
    Caption = '�����o����(&M)'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '�t�@�C��'
      '�N���b�v�{�[�h')
    TabOrder = 2
  end
  object chkHeader: TCheckBox
    Left = 28
    Top = 80
    Width = 97
    Height = 17
    Caption = '���o���̂�(&H)'
    TabOrder = 3
  end
  object chkCSV: TCheckBox
    Left = 28
    Top = 100
    Width = 93
    Height = 17
    Caption = 'CSV�`��(&C)'
    TabOrder = 4
  end
  object chkSelected: TCheckBox
    Left = 28
    Top = 60
    Width = 109
    Height = 17
    Caption = '�I�����ڂ̂�(&S)'
    TabOrder = 5
  end
end
