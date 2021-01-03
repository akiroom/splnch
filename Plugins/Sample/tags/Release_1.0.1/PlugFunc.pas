unit PlugFunc;

interface

uses
  Windows, Messages, SysUtils, Graphics, IniFiles, SLAPI, Types;

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
// �{�^�����p�b�h�ɍ쐬�����
function SLXButtonCreate(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
// �{�^�����p�b�h����폜�����
function SLXButtonDestroy(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
// �{�^���������ꂽ�Ƃ��̏���
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// �{�^���Ƀt�@�C�����h���b�v
function SLXButtonDropFiles(No: Integer; hWnd: HWND; Files: PChar): BOOL; stdcall;
// �{�^����`��
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// �{�^����`��ihWnd �� ButtonIndex �t���j
function SLXButtonDrawEx(No: Integer; hWnd: HWND; GroupIndex, ButtonIndex: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// �{�^�����X�V
function SLXButtonUpdate(No: Integer): BOOL; stdcall;
// �{�^���̓Ǝ��`�b�v�擾
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL; stdcall;
// �{�^���̐ݒ�_�C�A���O���Ăяo��
function SLXButtonOptions(No: Integer; hWnd: HWND): BOOL; stdcall;


// ���j���[�p�֐� --------------------------------------------------------------

// ���j���[�̏��(PSLXMenuInfo)�����X�ɕԂ�
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// ���j���[���I�����ꂽ�Ƃ��̏���
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// ���j���[�Ƀ`�F�b�N���t���Ă邩��Ԃ�
function SLXMenuCheck(No: Integer): BOOL; stdcall;

// �X�L���p�֐�
function SLXBeginSkin(hWnd: HWND): BOOL; stdcall;
function SLXDrawDragBar(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; Position: Integer; Caption: PChar): BOOL; stdcall;
function SLXDrawWorkspace(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; IsScrollBar: BOOL): BOOL; stdcall;
function SLXDrawButtonFace(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
function SLXDrawButtonFrame(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
function SLXDrawButtonIcon(hWnd: HWND; DC: HDC; ARect: PRect; NormalIcon: HICON; SmallIcon: HICON; State: Integer): BOOL; stdcall;
function SLXDrawButtonCaption(hWnd: HWND; DC: HDC; ARect: PRect; Caption: PChar; State: Integer): BOOL; stdcall;
function SLXDrawButtonMask(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;

// �{�^���̏��
const
  BS_ENABLED = 1;
  BS_SELECTED = 2;
  BS_MOUSEENTERED = 4;
  BS_PADACTIVE = 8;
  BS_ISDRAWPLUGIN = 16;


  
// �T���v���p�萔 --------------------------------------------------------------
const
  // �v���O�C���̖��O
  PLUGIN_NAME = '�v���O�C���T���v��';
  // �v���O�C���̐���
  PLUGIN_EXPRANATION =
      #13#10
    + '�v���O�C���J���p�T���v��' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1996-2007' + #13#10
    + '              SAWADA Shigeru All rights reserved.' + #13#10
    + '                             ����E���� : ��c��';

  // �{�^����
  DEFAULT_BUTTONCOUNT = 7;

  BUTTON_NORMAL = 0;
  BUTTON_CHIP = 1;
  BUTTON_NORMALDRAW = 2;
  BUTTON_SECDRAW = 3;
  BUTTON_PLUGINDRAW = 4;
  BUTTON_DRAWORDER = 5;
  BUTTON_POS = 6;

  // �{�^����`
  BUTTON_INFO: array[0..DEFAULT_BUTTONCOUNT-1] of TSLXButtonInfo =
  (
    // BUTTON_NORMAL
    (
      Name:           '�ӂ��̃{�^��';   // �{�^����
      IconIndex:      1;                  // �`��@�\���Ȃ��ꍇ�̃A�C�R���C���f�b�N�X
      OwnerDraw:      False;              // �`��@�\������=True
      UpdateInterval: 0;                  // �f�[�^�̍X�V�܂ł̊Ԋu(�~0.1�b)
      OwnerChip:      False;              // �Ǝ��`�b�v�@�\������=True
    ),

    // BUTTON_CHIP
    (
      Name:           '�`�b�v���ς��{�^��';
      IconIndex:      2;
      OwnerDraw:      False;
      UpdateInterval: 10;
      OwnerChip:      True;
    ),

    // BUTTON_NORMALDRAW
    (
      Name:           '���ʂɕ`�悷��{�^��';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_SECDRAW
    (
      Name:           '1 �b�� 1 �� SpLnch ���ĕ`����w������{�^��';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 10;
      OwnerChip:      False;
    ),
    // BUTTON_PLUGINDRAW
    (
      Name:           '�v���O�C�����ĕ`����w������{�^��';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_DRAWORDER
    (
      Name:           '�ĕ`����w������{�^��';
      IconIndex:      0;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_POS
    (
      Name:           '�{�^���̍��W��`�悷��{�^��';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 10;
      OwnerChip:      False;
    )

  );

  // �{�^����`
  ADD_BUTTON_INFO: TSLXButtonInfo =
  (
    Name:           '�ǉ����ꂽ�̃{�^���P';
    IconIndex:      0;
    OwnerDraw:      False;
    UpdateInterval: 0;
    OwnerChip:      False;              
  );


  // ���j���[��
  DEFAULT_MENUCOUNT = 19;

  // ���j���[��`
  MENU_INFO: array[0..DEFAULT_MENUCOUNT-1] of TSLXMenuInfo =
  (
    // 0
    (
      Name: '�T���v���v���O�C��(&S)';     // ���j���[��
      SCut: '';                           // �V���[�g�J�b�g�L�[
    ),
    // 1
    (
      Name: '�`�F�b�N����(&1)';
      SCut: 'Ctrl+Alt+1';
    ),
    // 2
    (
      Name: '-';
      SCut: '';
    ),
    // 3
    (
      Name: '���ׂăp�b�h�̃v���p�e�B���擾(&2)';
      SCut: 'Ctrl+Alt+2';
    ),
    // 4
    (
      Name: '�p�b�h���G�N�X�v���[���́u�������A�C�R���v�̂悤�ɕύX����(&3)';
      SCut: 'Ctrl+Alt+3';
    ),
    // 5
    (
      Name: '���̃{�^���O���[�v�ɐ؂�ւ���';
      SCut: '';
    ),
    // 6
    (
      Name: '�v���O�C���{�^���̏����擾���Ȃ����Ď�ނ� 1 ���₷';
      SCut: '';
    ),
    // 7
    (
      Name: '�v���O�C�����j���[�̏����擾���Ȃ����Ď�ނ� 1 ���₷';
      SCut: '';
    ),
    // 8
    (
      Name: '���ׂẴ{�^�������擾����';
      SCut: '';
    ),
    // 9
    (
      Name: '�{�^���O���[�v��}������';
      SCut: '';
    ),
    // 10
    (
      Name: '�{�^���O���[�v�̖��O��ύX����';
      SCut: '';
    ),
    // 11
    (
      Name: '�{�^���O���[�v�𕡐�����';
      SCut: '';
    ),
    // 12
    (
      Name: '�{�^���O���[�v���폜����';
      SCut: '';
    ),
    // 13
    (
      Name: '�{�^����ǉ�����';
      SCut: '';
    ),
    // 14
    (
      Name: '�{�^����ύX����';
      SCut: '';
    ),
    // 15
    (
      Name: '�{�^�����폜����';
      SCut: '';
    ),
    // 16
    (
      Name: '�{�^�����R�s�[����';
      SCut: '';
    ),
    // 17
    (
      Name: '�{�^����\��t����';
      SCut: '';
    ),
    // 18
    (
      Name: '�������ƃy�C���g�����s';
      SCut: '';
    )
  );


  // �ǉ��p���j���[��`
  ADD_MENU_INFO: TSLXMenuInfo =
  (
    Name: '�ǉ����ꂽ���j���[(&A)';   // ���j���[��
    SCut: '';                         // �V���[�g�J�b�g�L�[
  );


// �T���v���p�ϐ� --------------------------------------------------------------
var
  InitFileName: string; // �ݒ�t�@�C����
  MenuChecked: BOOL; // ���j���[�̃`�F�b�N���
  ButtonCount: Integer = DEFAULT_BUTTONCOUNT; // �{�^���̐�
  MenuCount: Integer = DEFAULT_MENUCOUNT; // ���j���[�̐�


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
    MenuChecked := Ini.ReadBool('Menu', 'Checked', False);
  finally
    Ini.Free;
  end;
  Randomize;
  Result := True;
end;

// �v���O�C�����I��
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.ReadBool('Menu', 'Checked', MenuChecked);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
  Result := True;
end;

// �ݒ�_�C�A���O���Ăяo��
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  Result := MessageBox(hWnd, '�ݒ肵������ɂȂ�H',
    '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes;
end;

// �{�^���̏��(PSLXButtonInfo)�����X�ɕԂ�
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL;
begin
  Result := False;
  if No >= 0 then
  begin
    if No < DEFAULT_BUTTONCOUNT then
    begin
      Result := True;
      ButtonInfo^ := BUTTON_INFO[NO];
    end
    else if No < ButtonCount then
    begin
      Result := True;
      ButtonInfo^ := ADD_BUTTON_INFO;
    end;
  end;
end;

// �{�^�����p�b�h�ɍ쐬�����
function SLXButtonCreate(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL;
begin
  Result := True;
  Windows.Beep(660, 50);
  Windows.Beep(880, 50);
end;

// �{�^�����p�b�h����폜�����
function SLXButtonDestroy(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL;
begin
  Result := True;
  Windows.Beep(880, 50);
  Windows.Beep(660, 50);
end;

// �{�^���������ꂽ�Ƃ��̏���
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL;
begin
  Result := True;

  if ExistsSLAPI and (No = BUTTON_DRAWORDER) then
  begin
    if not SLARedrawPluginButtons(PLUGIN_NAME, 4) then
      MessageBox(hWnd, '�X�V�ł��܂���B', '�m�F', MB_ICONINFORMATION);
  end;

end;

// �{�^���Ƀt�@�C�����h���b�v
function SLXButtonDropFiles(No: Integer; hWnd: HWND; Files: PChar): BOOL;
var
  Msg: string;
begin
  Result := True;
  Msg := Files + '���h���b�v�����B';
  MessageBox(hWnd, PChar(Msg), '�{�^��', MB_ICONINFORMATION);
end;


// �{�^����`��
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
begin
  Result := False;

  case No of
    BUTTON_NORMALDRAW, BUTTON_PLUGINDRAW, BUTTON_SECDRAW:
    begin
      Result := True;
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(ARect^.Left, ARect^.Top, IntToStr(Random(1000)));
      Canvas.Free;
    end;
  end;
end;

function SLXButtonDrawEx(No: Integer; hWnd: HWND; GroupIndex, ButtonIndex: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
  ID: Integer;
  SLAButton: TSLAButton;
  Msg: String;
begin
  Result := False;
  if not ExistsSLAPI then
    Exit;

  case No of
    BUTTON_POS:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      SLAGetButton(ID, GroupIndex, ButtonIndex, @SLAButton);
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      Canvas.Brush.Style := bsClear;
      Msg := 'X:' + IntToStr(SLAButton.ScreenRect.Left) + #13#10 +
             'Y:' + IntToStr(SLAButton.ScreenRect.Top) + #13#10 +
             'W:' + IntToStr(SLAButton.ScreenRect.Right - SLAButton.ScreenRect.Left) + #13#10 +
             'H:' + IntToStr(SLAButton.ScreenRect.Bottom - SLAButton.ScreenRect.Top);
      DrawText(Canvas.Handle, PChar(Msg), Length(Msg), ARect^, 0);
      Canvas.Free;
    end;
  end;

end;

// �{�^�����X�V
function SLXButtonUpdate(No: Integer): BOOL;
begin
  // True ��Ԃ��Ƃ��̃{�^���̍ĕ`�悪�N����
  Result := True;
end;

// �{�^���̓Ǝ��`�b�v�擾
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL;
var
  S: String;
begin
  Result := True;
  s := '';
  case Random(3) of
    0: S := '����Ⴄ';
    1: S := '�`�b�v��';
    2: S := '�\�������';
  end;
  StrPCopy(Value, Copy(S, 1, Size - 1));
end;


// �{�^���̐ݒ�_�C�A���O���Ăяo��
function SLXButtonOptions(No: Integer; hWnd: HWND): BOOL; stdcall;
var
  S: String;
begin
  Result := True;
  s := IntToStr(No) + ' �̃{�^���̐ݒ�';
  MessageBox(hWnd, PChar(s), '�m�F', MB_ICONINFORMATION);
end;





// ���j���[�̏��(PSLXMenuInfo)�����X�ɕԂ�
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL;
begin
  Result := False;
  if No >= 0 then
  begin
    if No < DEFAULT_MENUCOUNT then
    begin
      Result := True;
      MenuInfo^ := MENU_INFO[NO];
    end
    else if No < MenuCount then
    begin
      Result := True;
      MenuInfo^ := ADD_MENU_INFO;
    end;
  end;
end;

// ���j���[���I�����ꂽ�Ƃ��̏���
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL;
var
  Msg: string;
  ID: Integer;
  Count: Integer;
  i, j: Integer;
  mr: Integer;
  SLAGroup: TSLAGroup;
  SLAButton: TSLAButton;
  Buf: array[0..1023] of Char;
begin
  Result := False;
  if not ExistsSLAPI then
  begin
    MessageBox(hWnd, 'SLAPI ��������܂���B', '�m�F', MB_ICONINFORMATION);
    Exit;
  end;


  case No of
    0:
    begin
      Result := True;
    end;
    1:
    begin
      Result := True;
      MenuChecked := not MenuChecked;
    end;
    3:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      Count := SLAGetPadCount;

      for i := 0 to Count - 1 do
      begin
        Msg := '�p�b�h�̐� : ' + IntToStr(SLAGetPadCount) + #13#10;
        Msg := Msg + 'ID : ' + IntToStr(ID) + #13#10;
        Msg := Msg + '�E�B���h�E�n���h�� : ' + IntToStr(SLAGetPadWnd(ID)) + #13#10;
        Msg := Msg + '�B��Ă�Ƃ��̃E�B���h�E�n���h�� : ' + IntToStr(SLAGetPadTabWnd(ID)) + #13#10;
        if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
          Msg := Msg + '�O���[�v�C���f�b�N�X : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'TopLineIndex', Buf, 1024) then
          Msg := Msg + '��ԏ�̍s�ԍ� : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
          Msg := Msg + '�J�����g�{�^���̃C���f�b�N�X : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Left', Buf, 1024) then
          Msg := Msg + '���[���W : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Top', Buf, 1024) then
          Msg := Msg + '��[���W : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Cols', Buf, 1024) then
          Msg := Msg + '�� : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Rows', Buf, 1024) then
          Msg := Msg + '�s�� : ' + Buf + #13#10;
        Msg := Msg + '  ... �ȂǂȂǂȂ� ...';

        if MessageBox(hWnd, PChar(Msg), '�m�F', MB_OKCANCEL) = idCancel then
          Break;
        ID := SLAGetNextPadID(ID);
      end;

    end;
    4:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);

// �f�B���C�������Ă܂����A���삪�킩��悤�ɂ��Ă��邾���ł��̂ŁA
// �����Ă����v�ł��B      
      Result := Result and SLASetPadInit(ID, 'BtnSmallIcon', '1');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnSquare', '0');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnWidth', '100');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnHeight', '16');
      Sleep(500);
      StrPCopy(Buf, IntToStr(CP_RIGHT));
      Result := Result and SLASetPadInit(ID, 'BtnCaption', Buf);
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'Cols', '2');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'Rows', '15');
      Sleep(500);

      if Result then
        MessageBox(hWnd, '�ύX���܂����B', '�m�F', MB_ICONINFORMATION)
      else
        MessageBox(hWnd, '�ύX�ł��܂���ł����B', '�m�F', MB_ICONINFORMATION);

    end;
    5:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);

      Count := SLAGetGroupCount(ID);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf) + 1;
        if i >= Count then
          i := 0;
        StrPCopy(Buf, IntToStr(i));
        if SLASetPadInit(ID, 'GroupIndex', Buf) then
          Result := True;
      end;
    end;
    6:
    begin
      Result := True;
      Inc(ButtonCount);
      SLAChangePluginButtons(PLUGIN_NAME);
    end;
    7:
    begin
      Result := True;
      Inc(MenuCount);
      SLAChangePluginMenus(PLUGIN_NAME);
    end;
    8:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);

      Count := SLAGetGroupCount(ID);
      mr := idOk;
      for i := 0 to Count - 1 do
      begin
        SLAGetGroup(ID, i, @SLAGroup);
        for j := 0 to SLAGroup.ButtonCount - 1 do
        begin
          SLAGetButton(ID, i, j, @SLAButton);
          Msg := '�{�^���O���[�v�̐� : ' + IntToStr(Count) + #13#10;
          Msg := Msg + '�{�^���O���[�v�̃C���f�b�N�X : ' + IntToStr(i) + #13#10;
          Msg := Msg + '�{�^���O���[�v�� : ' + SLAGroup.Name + #13#10;
          Msg := Msg + '�{�^���̐� : ' + IntToStr(SLAGroup.ButtonCount) + #13#10;
          Msg := Msg + '�{�^���̃C���f�b�N�X : ' + IntToStr(j) + #13#10;
          case SLAButton.Kind of
            BK_SPACE:
            begin
              Msg := Msg + '�{�^���̎�� : ��' + #13#10;
            end;
            BK_RETURN:
            begin
              Msg := Msg + '�{�^���̎�� : ���s' + #13#10;
            end;
            BK_NORMAL:
            begin
              Msg := Msg + '�{�^���̎�� : �m�[�}��' + #13#10;
              Msg := Msg + '�{�^���� : ' + SLAButton.Name + #13#10;
              Msg := Msg + '�N���b�N�� : ' + IntToStr(SLAButton.ClickCount) + #13#10;
              Msg := Msg + '�����N��̃t�@�C���� : ' + SLAButton.FileName + #13#10;
              Msg := Msg + '�����N���PIDL : ' + IntToHex(Word(SLAButton.ItemIDList), 8) + #13#10;
              Msg := Msg + '���s������ : ' + SLAButton.Option + #13#10;
              Msg := Msg + '��Ɨp�t�H���_ : ' + SLAButton.Folder + #13#10;
              Msg := Msg + '���s���̑傫�� : ' + IntToStr(SLAButton.WindowSize) + #13#10;
              Msg := Msg + '�A�C�R���t�@�C�� : ' + SLAButton.IconFile + #13#10;
              Msg := Msg + '�A�C�R���̃C���f�b�N�X : ' + IntToStr(SLAButton.IconIndex) + #13#10;
            end;
            BK_PLUGIN:
            begin
              Msg := Msg + '�{�^���̎�� : �v���O�C��' + #13#10;
              Msg := Msg + '�{�^���� : ' + SLAButton.Name + #13#10;
              Msg := Msg + '�N���b�N�� : ' + IntToStr(SLAButton.ClickCount) + #13#10;
              Msg := Msg + '�v���O�C���� : ' + SLAButton.PluginName + #13#10;
              Msg := Msg + '�v���O�C���̃{�^���ԍ� : ' + IntToStr(SLAButton.PluginNo) + #13#10;
            end;

          end;
          mr := MessageBox(hWnd, PChar(Msg), '�m�F', MB_OKCANCEL);
          if mr = idCancel then
            Break;
        end;
        if mr = idCancel then
          Break;
      end;
    end;
    9:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);

      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLAInsertGroup(ID, i, '�}�������{�^���O���[�v');
      end;
    end;
    10:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLARenameGroup(ID, i, '���O���ύX���ꂽ�{�^���O���[�v');
      end;

    end;
    11:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLACopyGroup(ID, i, 0);
      end;
    end;
    12:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLADeleteGroup(ID, i);
      end;
    end;
    13:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '�ǉ����ꂽ�{�^��';
          SLAButton.Kind := BK_NORMAL;
          SLAButton.Filename := 'Explorer.exe';
          SLAInsertButton(ID, i, j, @SLAButton);

          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '�ǉ����ꂽ�{�^��';
          SLAButton.Kind := BK_PLUGIN;
          SLAButton.PluginName := PLUGIN_NAME;
          SLAButton.PluginNo := 1;
          SLAInsertButton(ID, i, j, @SLAButton);
        end;
      end;

    end;
    14:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
{          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '�ύX���ꂽ�{�^��';
          SLAButton.Kind := BK_PLUGIN;
          SLAButton.PluginName := PLUGIN_NAME;
          SLAButton.PluginNo := 1;
          SLAChangeButton(ID, i, j, @SLAButton);}
          SLAGetButton(ID, i, j, @SLAButton);
          SLAButton.IconFile := '';
          SLAChangeButton(ID, i, j, @SLAButton);
        end;
      end;

    end;
    15:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          SLADeleteButton(ID, i, j);
        end;
      end;
    end;
    16:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          SLACopyButton(ID, i, j);
        end;
      end;

    end;
    17:
    begin
      Result := False;
      if SLAButtonInClipbord then
      begin
        ID := SLAGetPadID(hWnd);
        if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
        begin
          i := StrToInt(Buf);
          if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
          begin
            j := StrToInt(Buf);

            Result := True;
            SLAPasteButton(ID, i, j);
          end;
        end;
      end
      else
      begin
        MessageBox(hWnd, '�N���b�v�{�[�h�ɂ͓\��t������f�[�^������܂���B', '�m�F', MB_ICONINFORMATION);
      end;
    end;
    18:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      FillChar(SLAButton, SizeOf(SLAButton), 0);
      SLAButton.Kind := BK_NORMAL;
      SLAButton.FileName := 'notepad.exe';
      SLARunButton(ID, @SLAButton);
      SLAButton.FileName := 'mspaint.exe';
      SLARunButton(ID, @SLAButton);
    end;
  else
    if (No >= DEFAULT_MENUCOUNT) and (No < MenuCount) then
    begin
      Result := True;
      MessageBox(hWnd, '�ǉ����ꂽ���j���[��I�����܂����B', '�m�F', MB_ICONINFORMATION);
    end
    else
    begin
      Result := False;
    end;
  end;
end;

// ���j���[�Ƀ`�F�b�N���t���Ă邩��Ԃ�
function SLXMenuCheck(No: Integer): BOOL;
begin
  case No of
    1:
      Result := MenuChecked;
  else
    Result := False;
  end;
end;

// �����e�L�X�g���w��̕����ɕ`��
procedure RotateTextOut(Canvas: TCanvas; ARect: TRect; Position: Integer; const Text: String);
var
  ComS, S: string;
  LastChar: string;
  MaxWidth: Integer;
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
  X, Y: Integer;
begin
  GetObject(Canvas.Font.Handle, SizeOf(LogFont), @LogFont);

  case Position of
    DS_TOP, DS_BOTTOM:
    begin
      LogFont.lfEscapement := 0;
      MaxWidth := ARect.Right - ARect.Left;
      X := ARect.Left;
      Y := ARect.Top;
    end;

    DS_LEFT:
    begin
      LogFont.lfEscapement := 900;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Left;
      Y := ARect.Bottom - 1;
    end;

    DS_RIGHT:
    begin
      LogFont.lfEscapement := 2700;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Right;
      Y := ARect.Top;
    end;

    else
      Exit;
  end;

  ComS := Text;
  S := Text;
  while Canvas.TextWidth(ComS) > MaxWidth do
  begin
    LastChar := StrPas(AnsiLastChar(S));
    if LastChar = S then
      Break;

    S := Copy(S, 1, Length(S) - Length(LastChar));
    ComS := S + '...';
  end;

  NewFont := CreateFontIndirect(LogFont);
  try
    OldFont := SelectObject(Canvas.Handle, NewFont);
    TextOut(Canvas.Handle, x, y, PChar(ComS), Length(ComS));
    NewFont := SelectObject(Canvas.Handle, OldFont);
  finally
    DeleteObject(NewFont);
  end;
end;


// �X�L���p�֐�
function SLXBeginSkin(hWnd: HWND): BOOL;
//var
//  ID: Integer;
begin
// Beep;
//  ID := SLAGetPadID(hWnd);
//  SLASetPadInit(ID, 'DragBarSize', '50');
  Result := True;
end;

function SLXDrawDragBar(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; Position: Integer; Caption: PChar): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    if Foreground then
    begin
      Canvas.Brush.Color := clGray;
      Canvas.Font.Color := clWhite;
    end
    else
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.Font.Color := clSilver;
    end;
    Canvas.FillRect(ARect^);
    RotateTextOut(Canvas, ARect^, Position, Caption);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawWorkspace(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; IsScrollBar: BOOL): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    if Foreground then
      Canvas.Brush.Color := clGray
    else
      Canvas.Brush.Color := clSilver;
    Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonFace(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Inc(ARect^.Left);
    Inc(ARect^.Top);
    Canvas.Handle := DC;
    Canvas.Pen.Style := psClear;
    Canvas.Brush.Color := clWhite;
    Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonFrame(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  if (State and BS_MOUSEENTERED) <> 0 then
  begin
    Canvas := TCanvas.Create;
    try
      Inc(ARect^.Left);
      Inc(ARect^.Top);
      Canvas.Handle := DC;
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Style := bsClear;
      Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
    finally
      Canvas.Free;
    end;
  end;
end;

function SLXDrawButtonIcon(hWnd: HWND; DC: HDC; ARect: PRect; NormalIcon: HICON; SmallIcon: HICON; State: Integer): BOOL;
begin
  Result := True;
  DrawIconEx(DC, ARect^.Top + 5, ARect^.Left + 5, SmallIcon, 16, 16, 0, 0, DI_NORMAL);
end;

function SLXDrawButtonCaption(hWnd: HWND; DC: HDC; ARect: PRect; Caption: PChar; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    Canvas.Brush.Style := bsClear;
    if ((State and BS_PADACTIVE) <> 0) or ((State and BS_MOUSEENTERED) <> 0) then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clSilver;
    Canvas.TextOut(ARect^.Left + 3, ARect^.Top + 22, Caption);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonMask(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
  y: Integer;
begin
  Result := True;
  if ((State and BS_SELECTED) <> 0) and ((State and BS_PADACTIVE) <> 0) and ((State and BS_ISDRAWPLUGIN) = 0) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      Canvas.Pen.Color := clRed;
      y := ARect^.Top + 22 + Canvas.TextHeight('a');
      Canvas.MoveTo(ARect^.Left + 3, y);
      Canvas.LineTo(ARect^.Right - 2, y);
    finally
      Canvas.Free;
    end;
  end;
end;

end.
