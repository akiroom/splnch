object frmConfirm: TfrmConfirm
  Left = 348
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Windows �̏I��'
  ClientHeight = 98
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '�l�r �o�S�V�b�N'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object imgIcon: TImage
    Left = 8
    Top = 4
    Width = 32
    Height = 32
    AutoSize = True
  end
  object lblMessage: TLabel
    Left = 56
    Top = 16
    Width = 122
    Height = 12
    Caption = 'Windows ���I�����܂��B'
  end
  object btnOk: TButton
    Left = 153
    Top = 64
    Width = 97
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 257
    Top = 64
    Width = 97
    Height = 25
    Cancel = True
    Caption = '�L�����Z��'
    ModalResult = 2
    TabOrder = 1
  end
  object tmDelay: TTimer
    OnTimer = tmDelayTimer
    Left = 256
    Top = 12
  end
end
