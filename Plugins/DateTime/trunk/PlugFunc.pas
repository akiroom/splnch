unit PlugFunc;

interface

uses
  Windows, SysUtils, Graphics, IniFiles, Option, PlugBtns, Cal, Memo, Forms;

// �\���� ----------------------------------------------------------------------
type

  // �{�^���̏��
  PSLXButtonInfo = ^TSLXButtonInfo;
  TSLXButtonInfo = packed record
    Name: array[0..63] of Char; // �{�^����
    IconIndex: Integer;         // �`��@�\���Ȃ��ꍇ�̃A�C�R���C���f�b�N�X
    OwnerDraw: BOOL;            // �`��@�\������=True
    UpdateInterval: Integer;    // �f�[�^�̍X�V�܂ł̊Ԋu(�~0.1�b)
    OwnerChip: BOOL;            // �Ǝ��`�b�v�@�\������=True
  end;

  // ���j���[�̏��
  PSLXMenuInfo = ^TSLXMenuInfo;
  TSLXMenuInfo = packed record
    Name: array[0..63] of Char; // ���j���[��
    SCut: array[0..63] of Char; // �V���[�g�J�b�g�L�[
  end;


// �S�ʂ̊֐� ------------------------------------------------------------------

// �v���O�C���̖��O��Ԃ�
function SLXGetName(Name: PChar; Size: Word): BOOL; stdcall;
// �v���O�C���̐�����Ԃ�
function SLXGetExplanation(Explanation: PChar; Size: Word): BOOL; stdcall;
// �v���O�C�����g�p�ł���ݒ�t�@�C�������炤
function SLXSetInitFile(InitFile: PChar): BOOL; stdcall;
// �v���O�C�����J�n
function SLXBeginPlugin: BOOL; stdcall;
// �v���O�C�����I��
function SLXEndPlugin: BOOL; stdcall;
// �ݒ�_�C�A���O���Ăяo��
function SLXChangeOptions(hWnd: HWND): BOOL; stdcall;


// �{�^���p�֐� ----------------------------------------------------------------

// �{�^���̏��(PSLXButtonInfo)�����X�ɕԂ�
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL; stdcall;
// �{�^���������ꂽ�Ƃ��̏���
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// �{�^����`��
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// �{�^�����X�V
function SLXButtonUpdate(No: Integer): BOOL; stdcall;
// �{�^���̓Ǝ��`�b�v�擾
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL; stdcall;

// ���j���[�p�֐� --------------------------------------------------------------

// ���j���[�̏��(PSLXMenuInfo)�����X�ɕԂ�
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// ���j���[���I�����ꂽ�Ƃ��̏���
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// ���j���[�Ƀ`�F�b�N���t���Ă邩��Ԃ�
function SLXMenuCheck(No: Integer): BOOL; stdcall;


const
  // �v���O�C���̖��O
  PLUGIN_NAME = '�J�����_�[�Ǝ��v';
  // �v���O�C���̐���
  PLUGIN_EXPRANATION =
      #13#10
    + '�J�����_�[�Ǝ��v�v���O�C��' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1996-2002' + #13#10
    + '              SAWADA Shigeru All rights reserved.' + #13#10
    + '                             ����E���� : ��c��';

  // �{�^����
  BUTTON_COUNT = 2;

  // �{�^����`
  BUTTON_INFO: array[0..BUTTON_COUNT-1] of TSLXButtonInfo =
  (
    (
      Name:           '�J�����_�[';       // �{�^����
      IconIndex:      0;                  // �`��@�\���Ȃ��ꍇ�̃A�C�R���C���f�b�N�X
      OwnerDraw:      True;               // �`��@�\������=True
      UpdateInterval: 50;                 // �f�[�^�̍X�V�܂ł̊Ԋu(�~0.1�b)
      OwnerChip:      True;               // �Ǝ��`�b�v�@�\������=True
    ),
    (
      Name:           '���v';             // �{�^����
      IconIndex:      0;                  // �`��@�\���Ȃ��ꍇ�̃A�C�R���C���f�b�N�X
      OwnerDraw:      True;               // �`��@�\������=True
      UpdateInterval: 10;                 // �f�[�^�̍X�V�܂ł̊Ԋu(�~0.1�b)
      OwnerChip:      True;               // �Ǝ��`�b�v�@�\������=True
    )
  );


  // ���j���[��
  MENU_COUNT = 1;

  // ���j���[��`
  MENU_INFO: array[0..MENU_COUNT-1] of TSLXMenuInfo =
  (
    (
      Name: '�J�����_�[(&L)';     // �{�^����
      SCut: 'Ctrl+L';                   // �V���[�g�J�b�g�L�[
    )
  );


implementation

// �v���O�C���̖��O��Ԃ�
function SLXGetName(Name: PChar; Size: Word): BOOL;
begin
  Result := True;
  StrPCopy(Name, Copy(PLUGIN_NAME, 1, Size - 1));
end;

// �v���O�C���̐�����Ԃ�
function SLXGetExplanation(Explanation: PChar; Size: Word): BOOL;
begin
  Result := True;
  StrPCopy(Explanation, Copy(PLUGIN_EXPRANATION, 1, Size - 1));
end;

// �v���O�C�����g�p�ł���ݒ�t�@�C�������炤
function SLXSetInitFile(InitFile: PChar): BOOL;
begin
  Result := True;
  InitFileName := StrPas(InitFile);
  DataFileName := ChangeFileExt(InitFileName, '.dat');
end;

// �v���O�C�����J�n
function SLXBeginPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    if Ini.ReadBool('Calendar', 'Visible', False) then
    begin
      if frmCal = nil then
        frmCal := TfrmCal.Create(nil);
      frmCal.Show;
    end;

    ADigital := Ini.ReadBool('Watch', 'Digital', False);

  finally
    Ini.Free;
  end;

  UpdateDayInfo(True);
  UpdateTimeInfo;
  Result := True;
end;

// �v���O�C�����I��
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.WriteBool('Calendar', 'Visible', frmCal <> nil);
    Ini.WriteBool('Watch', 'Digital', ADigital);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;

  if frmCal <> nil then
    frmCal.Close;

  Result := frmCal = nil;
end;

// �ݒ�_�C�A���O���Ăяo��
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  dlgOption := TdlgOption.CreateOwnedForm(nil, hWnd);
  try
    Result := dlgOption.ShowModal = idOk;
  finally
    dlgOption.Release;
  end;
end;

// �{�^���̏��(PSLXButtonInfo)�����X�ɕԂ�
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL;
begin
  case No of
    0..BUTTON_COUNT-1:
    begin
      Result := True;
      ButtonInfo^ := BUTTON_INFO[NO];
    end;
  else
    Result := False;
  end;
end;

// �{�^���������ꂽ�Ƃ��̏���
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL;
begin
  case No of
    0:
    begin
      if frmCal = nil then
      begin
        frmCal := TfrmCal.Create(nil);
        frmCal.Show;
      end
      else
        frmCal.Close;
      Result := True;
    end;
    1:
    begin
      ADigital := not ADigital;
      Result := True;
    end;
  else
    Result := False;
  end;
end;



// �{�^����`��
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
begin
  case No of
    0:
    begin
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      DrawDate(Canvas, ARect^);
      Canvas.Free;
      Result := True;
    end;
    1:
    begin
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      DrawWatch(Canvas, ARect^);
      Canvas.Free;
      Result := True;
    end;
  else
    Result := False;
  end;
end;

// �{�^�����X�V
function SLXButtonUpdate(No: Integer): BOOL;
begin
  Result := False;
  case No of
    0:
    begin
      Result := UpdateDayInfo(False);
    end;
    1:
    begin
      Result := UpdateTimeInfo;
    end;
  end;
end;

// �{�^���̓Ǝ��`�b�v�擾
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL;
var
  S: String;
begin
  case No of
    0:
    begin
      S := ChipStr;
      StrPCopy(Value, Copy(S, 1, Size - 1));
      Result := True;
    end;
    1:
    begin
      S := FormatDateTime('tt', Now);
      StrPCopy(Value, Copy(S, 1, Size - 1));
      Result := True;
    end;

  else
    Result := False;
  end;
end;


// ���j���[�̏��(PSLXMenuInfo)�����X�ɕԂ�
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL;
begin
  case No of
    0..MENU_COUNT-1:
    begin
      Result := True;
      MenuInfo^ := MENU_INFO[No];
    end;
  else
    Result := False;
  end;
end;

// ���j���[���I�����ꂽ�Ƃ��̏���
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL;
begin
  case No of
    0:
    begin
      if frmCal = nil then
      begin
        frmCal := TfrmCal.Create(nil);
        frmCal.Show;
      end
      else
        frmCal.Close;
      Result := True;
    end;
  else
    Result := False;
  end;
end;

// ���j���[�Ƀ`�F�b�N���t���Ă邩��Ԃ�
function SLXMenuCheck(No: Integer): BOOL;
begin
  case No of
    0:
      Result := frmCal <> nil;
  else
    Result := False;
  end;
end;



end.
