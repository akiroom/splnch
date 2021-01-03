unit SLAPI;

interface

uses
  Windows, ShlObj;

var
  ExistsSLAPI: Boolean;

const
  // PadX.ini �� DragBar �̒l
  DS_NONE = 0; // �\�����Ȃ�
  DS_LEFT = 1; // ��
  DS_TOP = 2; // ��
  DS_RIGHT = 3; // �E
  DS_BOTTOM = 4; // ��

  // PadX.ini �� DropAction �̒l
  DA_ADDHERE = 0; // �h���b�v�����ꏊ�ɒǉ�
  DA_ADDLAST = 1; // �Ō�ɒǉ�
  DA_OPENHERE = 2; // �h���b�v��̃{�^���ŊJ��
  DA_COPYNAME = 3; // �t�@�C�������R�s�[

  // PadX.ini �� BtnCaption �̒l
  CA_COMLINE = 0; // �w�肵�Ď��s���J��
  CA_BTNEDIT = 1; // �{�^���̕ҏW���J��
  CA_GRPCHANGE = 2; // �{�^���O���[�v�ύX���j���[���J��
  CA_NEXTGROUP = 3; // ���̃{�^���O���[�v�ֈړ�����
  CA_PADPRO = 4; // �p�b�h�̐ݒ���J��
  CA_OPTION = 5; // �S�̂̐ݒ���J��
  CA_HIDE = 6; // �p�b�h���B��

  // PadX.ini �� BtnCaption �̒l
  CP_NONE = 0; // �{�^������\�����Ȃ�
  CP_BOTTOM = 1; // �A�C�R���̉�
  CP_RIGHT = 2; // �A�C�R���̉E

type
  // �{�^���O���[�v�̏��
  PSLAGroup = ^TSLAGroup;
  TSLAGroup = packed record
    PadID: Integer; // ��������p�b�h��ID
    GroupIndex: Integer; // �O���[�v�̃C���f�b�N�X
    Name: array[0..1023] of Char; // �{�^���O���[�v��
    ButtonCount: Integer; // �{�^���̐�
  end;

const
  // TSLAButton �� Kind �̒l
  BK_SPACE = 0;
  BK_RETURN = 1;
  BK_NORMAL = 2;
  BK_PLUGIN = 3;

  // TSLAButton �� WindowSize �̒l
  BW_NORMAL = 0;
  BW_MINIMIZED = 1;
  BW_MAXMIZED = 2;

type
  // �{�^���̏��
  PSLAButton = ^TSLAButton;
  TSLAButton = packed record
    PadID: Integer; // ��������p�b�h��ID�i�ǂݎ��̂݁j
    GroupIndex: Integer; // �O���[�v�̃C���f�b�N�X�i�ǂݎ��̂݁j
    ButtonIndex: Integer; // �{�^���̃C���f�b�N�X�i�ǂݎ��̂݁j

    ScreenRect: TRect; // ��ʏ�ł̍��W�i�ǂݎ��̂݁j

    Name: array[0..1023] of Char; // �{�^����
    ClickCount: Integer; // �N���b�N��
    Kind: Integer; // �{�^���̎��

    FileName: array[0..1023] of Char; // �����N��̃t�@�C����
    ItemIDList: PItemIDList; // �����N���PIDL
    Option: array[0..1023] of Char; // ���s������
    Folder: array[0..1023] of Char; // ��Ɨp�t�H���_
    WindowSize: Integer; // ���s���̑傫��
    IconFile: array[0..1023] of Char; // �A�C�R���t�@�C��
    IconIndex: Integer; // �A�C�R���̃C���f�b�N�X

    PluginName: array[0..1023] of Char; // �v���O�C���̖��O
    PluginNo: Integer; // �v���O�C���{�^���̔ԍ�
  end;

const
  // SLAGetIcon �� FileType �̒l
  FT_ICONPATH = 0; // �A�C�R�����܂܂��t�@�C���ւ̃p�X
  FT_FILEPATH = 1; // �ʏ�̃t�@�C���ւ̃p�X
  FT_PIDL = 2; // PIDL

var
  // �p�b�h�̐����擾����
  SLAGetPadCount: function: Integer; stdcall;
  // hWnd ���� PadID ���擾����
  SLAGetPadID: function(hWnd: HWND): Integer; stdcall;
  // PadID ���玟�� PadID ���擾����
  SLAGetNextPadID: function(ID: Integer): Integer; stdcall;
  // PadID ����p�b�h�̃E�B���h�E�n���h�����擾����
  SLAGetPadWnd: function(ID: Integer): HWND; stdcall;
  // PadID ����p�b�h�̉B��Ă��鎞�̃E�B���h�E�n���h�����擾����
  SLAGetPadTabWnd: function(ID: Integer): HWND; stdcall;
  // �p�b�h�̃v���p�e�B�� 1 �擾
  SLAGetPadInit: function(ID: Integer; Key: PChar; Buf: PChar; BufSize: Integer): BOOL; stdcall;
  // �p�b�h�̃v���p�e�B�� 1 �Z�b�g
  SLASetPadInit: function(ID: Integer; Key: PChar; Item: PChar): BOOL; stdcall;

  // �v���O�C���{�^�����ēx�擾����
  SLAChangePluginButtons: function(Name: PChar): BOOL; stdcall;
  // �v���O�C�����j���[���ēx�擾����
  SLAChangePluginMenus: function(Name: PChar): BOOL; stdcall;
  // �v���O�C���{�^�����ĕ`�悷��
  SLARedrawPluginButtons: function(Name: PChar; No: Integer): BOOL; stdcall;

  // �{�^���O���[�v�̐����擾����
  SLAGetGroupCount: function(ID: Integer): Integer; stdcall;
  // �{�^���O���[�v�̏����擾����
  SLAGetGroup: function(ID, GroupIndex: Integer; Group: PSLAGroup): BOOL; stdcall;
  // �{�^���O���[�v��}������
  SLAInsertGroup: function(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
  // �{�^���O���[�v�̖��O��ύX����
  SLARenameGroup: function(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
  // �{�^���O���[�v�𕡐�����
  SLACopyGroup: function(ID, GroupIndex, NewIndex: Integer): BOOL; stdcall;
  // �{�^���O���[�v���폜����
  SLADeleteGroup: function(ID, GroupIndex: Integer): BOOL; stdcall;

  // �{�^���̏����擾����
  SLAGetButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // �{�^����}������
  SLAInsertButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // �{�^����ύX����
  SLAChangeButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // �{�^�����폜����
  SLADeleteButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // �{�^�����N���b�v�{�[�h�ɃR�s�[����
  SLACopyButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // �{�^�����N���b�v�{�[�h����\��t����
  SLAPasteButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // �N���b�v�{�[�h�Ƀ{�^���œ\��t������f�[�^�����邩��Ԃ�
  SLAButtonInClipbord: function: BOOL; stdcall;
  // �{�^���f�[�^�����s����
  SLARunButton: function (ID: Integer; Button: PSLAButton): BOOL; stdcall;

  // �A�C�R�����擾����
  SLAGetIcon: function(FilePoint: Pointer; FileType, IconIndex: Integer; SmallIcon, UseCache: BOOL): HIcon; stdcall;

var
  InstSpLnch: THandle;

implementation

procedure InitAPI;
begin
  InstSpLnch := GetModuleHandle(nil);
  if  InstSpLnch < HINSTANCE_ERROR then
  begin
    InstSpLnch := 0;
    Exit;
  end;
  @SLAGetPadCount := GetProcAddress(InstSpLnch, 'SLAGetPadCount');
  @SLAGetPadID := GetProcAddress(InstSpLnch, 'SLAGetPadID');
  @SLAGetNextPadID := GetProcAddress(InstSpLnch, 'SLAGetNextPadID');
  @SLAGetPadWnd := GetProcAddress(InstSpLnch, 'SLAGetPadWnd');
  @SLAGetPadTabWnd := GetProcAddress(InstSpLnch, 'SLAGetPadTabWnd');
  @SLAGetPadInit := GetProcAddress(InstSpLnch, 'SLAGetPadInit');
  @SLASetPadInit := GetProcAddress(InstSpLnch, 'SLASetPadInit');
  @SLAChangePluginButtons := GetProcAddress(InstSpLnch, 'SLAChangePluginButtons');
  @SLAChangePluginMenus := GetProcAddress(InstSpLnch, 'SLAChangePluginMenus');
  @SLARedrawPluginButtons := GetProcAddress(InstSpLnch, 'SLARedrawPluginButtons');
  @SLAGetGroupCount := GetProcAddress(InstSpLnch, 'SLAGetGroupCount');
  @SLAGetGroup := GetProcAddress(InstSpLnch, 'SLAGetGroup');
  @SLAInsertGroup := GetProcAddress(InstSpLnch, 'SLAInsertGroup');
  @SLARenameGroup := GetProcAddress(InstSpLnch, 'SLARenameGroup');
  @SLACopyGroup := GetProcAddress(InstSpLnch, 'SLACopyGroup');
  @SLADeleteGroup := GetProcAddress(InstSpLnch, 'SLADeleteGroup');
  @SLAGetButton := GetProcAddress(InstSpLnch, 'SLAGetButton');
  @SLAInsertButton := GetProcAddress(InstSpLnch, 'SLAInsertButton');
  @SLAChangeButton := GetProcAddress(InstSpLnch, 'SLAChangeButton');
  @SLADeleteButton := GetProcAddress(InstSpLnch, 'SLADeleteButton');
  @SLACopyButton := GetProcAddress(InstSpLnch, 'SLACopyButton');
  @SLAPasteButton := GetProcAddress(InstSpLnch, 'SLAPasteButton');
  @SLAButtonInClipbord := GetProcAddress(InstSpLnch, 'SLAButtonInClipbord');
  @SLARunButton := GetProcAddress(InstSpLnch, 'SLARunButton');
  @SLAGetIcon := GetProcAddress(InstSpLnch, 'SLAGetIcon');

  ExistsSLAPI :=
    (@SLAGetPadCount <> nil) and
    (@SLAGetPadID <> nil) and
    (@SLAGetNextPadID <> nil) and
    (@SLAGetPadWnd <> nil) and
    (@SLAGetPadTabWnd <> nil) and
    (@SLAGetPadInit <> nil) and
    (@SLASetPadInit <> nil) and
    (@SLAChangePluginButtons <> nil) and
    (@SLAChangePluginMenus <> nil) and
    (@SLARedrawPluginButtons <> nil) and
    (@SLAGetGroupCount <> nil) and
    (@SLAGetGroup <> nil) and
    (@SLAInsertGroup <> nil) and
    (@SLARenameGroup <> nil) and
    (@SLACopyGroup <> nil) and
    (@SLADeleteGroup <> nil) and
    (@SLAGetButton <> nil) and
    (@SLAInsertButton <> nil) and
    (@SLAChangeButton <> nil) and
    (@SLADeleteButton <> nil) and
    (@SLACopyButton <> nil) and
    (@SLAPasteButton <> nil) and
    (@SLAButtonInClipbord <> nil) and
    (@SLARunButton <> nil) and
    (@SLAGetIcon <> nil);
end;



initialization
  InitAPI;
end.
