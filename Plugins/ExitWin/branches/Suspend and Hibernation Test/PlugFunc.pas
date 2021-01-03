unit PlugFunc;

interface

uses
  Windows, SysUtils, IniFiles, Confirm, Option;

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

// ���j���[�p�֐� --------------------------------------------------------------

// ���j���[�̏��(PSLXMenuInfo)�����X�ɕԂ�
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// ���j���[���I�����ꂽ�Ƃ��̏���
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;



// �T���v���p�萔 --------------------------------------------------------------
const
  // �v���O�C���̖��O
  PLUGIN_NAME = 'Exit Windows Plugin.';
  // �v���O�C���̐���
  PLUGIN_EXPRANATION =
      #13#10
    + 'Windows �̏I���v���O�C��' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1995-2007' + #13#10
    + '             Special Launch Open Source Project.';

  // �{�^���̐�
  BUTTON_COUNT = 5;
  // �{�^����`
  BUTTON_INFO: array[0..BUTTON_COUNT-1] of TSLXButtonInfo =
  (
    (
      Name:           '�V���b�g�_�E��';   
      IconIndex:      1;                  
      OwnerDraw:      False;              
      UpdateInterval: 0;                  
      OwnerChip:      False;
    ),
    (
      Name:           '�ċN��';
      IconIndex:      2;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           '���O�I�t';
      IconIndex:      3;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           '�T�X�y���h';
      IconIndex:      4;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           '�x�~���';
      IconIndex:      5;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    )
  );

  // ���j���[�̐�
  MENU_COUNT = 8;
  // ���j���[��`
  MENU_INFO: array[0..MENU_COUNT-1] of TSLXMenuInfo =
  (
    (
      Name: 'Windows �̏I��(&W)';
      SCut: '';
    ),
    (
      Name: '�V���b�g�_�E��(&D)';
      SCut: 'Ctrl+Alt+J';
    ),
    (
      Name: '�ċN��(&R)';
      SCut: 'Ctrl+Alt+K';
    ),
    (
      Name: '-';
      SCut: '';
    ),
    (
      Name: '�T�X�y���h(&S)';
      SCut: 'Ctrl+Alt+U';
    ),
    (
      Name: '�x�~���(&H)';
      SCut: 'Ctrl+Alt+M';
    ),
    (
      Name: '-';
      SCut: '';
    ),
    (
      Name: '���O�I�t(&F)';
      SCut: 'Ctrl+Alt+L';
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
end;

// �v���O�C�����J�n
function SLXBeginPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    ExitDelay := Ini.ReadInteger('Exit Windows', 'ExitDelay', 5);
    PowerOff := Ini.ReadBool('Exit Windows', 'PowerOff', False);
  finally
    Ini.Free;
  end;
  Result := True;
end;

// �v���O�C�����I��
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.WriteInteger('Exit Windows', 'ExitDelay', ExitDelay);
    Ini.WriteBool('Exit Windows', 'PowerOff', PowerOff);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
  Result := True;
end;

// �ݒ�_�C�A���O���Ăяo��
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  dlgOption := TdlgOption.Create(nil);
  try
    dlgOption.udExitDelay.Position := ExitDelay;
    dlgOption.rdoPowerOff.Checked := PowerOff;
    Result := dlgOption.ShowModal = idOk;
    if Result then
    begin
      ExitDelay := dlgOption.udExitDelay.Position;
      PowerOff := dlgOption.rdoPowerOff.Checked;
    end;
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
var
  ExitKind: TExitKind;
begin
  Result := frmConfirm = nil;
  ExitKind := ekShutdown;
  case No of
    0: ExitKind := ekShutdown;
    1: ExitKind := ekReboot;
    2: ExitKind := ekLogoff;
    3: ExitKind := ekSuspend;
    4: ExitKind := ekHibernation;
  else
    Result := False;
  end;

  if Result then
    RunExitWindows(ExitKind, ExitDelay);
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
var
  ExitKind: TExitKind;
begin
  Result := frmConfirm = nil;
  ExitKind := ekShutdown;
  case No of
    1: ExitKind := ekShutdown;
    2: ExitKind := ekReboot;
    4: ExitKind := ekSuspend;
    5: ExitKind := ekHibernation;
    7: ExitKind := ekLogoff;
  else
    Result := False;
  end;

  if Result then
    RunExitWindows(ExitKind, ExitDelay);
end;

end.
