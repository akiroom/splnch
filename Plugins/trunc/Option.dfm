object dlgOption: TdlgOption
  Left = 409
  Top = 389
  BorderStyle = bsDialog
  Caption = '�ݒ�'
  ClientHeight = 177
  ClientWidth = 323
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
  object Image1: TImage
    Left = 12
    Top = 12
    Width = 32
    Height = 32
  end
  object Label2: TLabel
    Left = 60
    Top = 16
    Width = 179
    Height = 12
    Caption = 'Windows ���I������܂ł̎���(&T):'
    FocusControl = Edit1
  end
  object Label3: TLabel
    Left = 136
    Top = 36
    Width = 12
    Height = 12
    Caption = '�b'
  end
  object lblShutdown: TLabel
    Left = 60
    Top = 64
    Width = 106
    Height = 12
    Caption = '�V���b�g�_�E���̓���'
  end
  object OKBtn: TButton
    Left = 159
    Top = 140
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 239
    Top = 140
    Width = 75
    Height = 25
    Cancel = True
    Caption = '�L�����Z��'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 80
    Top = 32
    Width = 37
    Height = 20
    TabOrder = 2
    Text = '0'
  end
  object udExitDelay: TUpDown
    Left = 117
    Top = 32
    Width = 15
    Height = 20
    Associate = Edit1
    Min = 0
    Position = 0
    TabOrder = 3
    Wrap = False
  end
  object rdoShutdown: TRadioButton
    Left = 80
    Top = 80
    Width = 213
    Height = 17
    Caption = '�d����؂��Ă����v�ȏ�Ԃ���(&S)'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object rdoPowerOff: TRadioButton
    Left = 80
    Top = 100
    Width = 97
    Height = 17
    Caption = '�d����؂�(&P)'
    TabOrder = 5
  end
end
