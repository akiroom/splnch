program ShtOp;

uses
  Windows, Messages,
  SysUtils,
  getse_sd in 'getse_sd.pas';

{$R *.RES}
{$R SHTOP2.RES}

type
  TIsPwrSuspendAllowed = function(): BOOL;stdcall;
  TIsPwrHibernateAllowed = function(): BOOL;stdcall;
  TSetSuspendState = function(Hibernate : BOOL; ForceCritical : BOOL; DisableWakeEvent : BOOL) : Boolean; stdcall;

var
  UpParam: String;
  CanExit: Boolean;
  ExtMode: Integer;
  HibernateMode: Boolean;
  SuspendFlag: Boolean;
  VerInfo: TOSVersionInfo;
  tpSv: TTokenPrivileges;
  i: Integer;
  w: HWND;
  s: String;
  hPowrprof : HINST;
  IsPwrSuspendAllowed : TIsPwrSuspendAllowed;
  IsPwrHibernateAllowed : TIsPwrHibernateAllowed;
  SetSuspendState : TSetSuspendState;
begin
  CanExit := False;
  ExtMode := 0;
  HibernateMode := False;
  SuspendFlag := False;
  w := 0;
  hPowrprof := LoadLibrary('PowrProf.dll');
  if hPowrprof <> 0 then
  begin
    @IsPwrSuspendAllowed := GetProcAddress(hPowrprof, 'IsPwrSuspendAllowed');
    @IsPwrHibernateAllowed := GetProcAddress(hPowrprof, 'IsPwrHibernateAllowed');
    @SetSuspendState := GetProcAddress(hPowrprof, 'SetSuspendState');
  end;
  for i := 1 to ParamCount do
  begin
    UpParam := UpperCase(ParamStr(i));
    if UpParam = 'SHUTDOWN' then
    begin
      ExtMode := ExtMode or EWX_SHUTDOWN;
      CanExit := True;
    end
    else if UpParam = 'REBOOT' then
    begin
      ExtMode := ExtMode or EWX_REBOOT;
      CanExit := True;
    end
    else if UpParam = 'LOGOFF' then
    begin
      ExtMode := ExtMode or EWX_LOGOFF;
      CanExit := True;
    end
    else if UpParam = 'FORCE' then
    begin
      ExtMode := ExtMode or EWX_FORCE;
      CanExit := True;
    end
    else if UpParam = 'POWEROFF' then
    begin
      ExtMode := ExtMode or EWX_POWEROFF;
      CanExit := True;
    end
    else if UpParam = 'FORCEIFHUNG' then
    begin
      ExtMode := ExtMode or EWX_FORCEIFHUNG;
      CanExit := True;
    end
    else if UpParam = 'SUSPEND' then
    begin
      if Assigned(@IsPwrSuspendAllowed) and IsPwrSuspendAllowed() then
      begin
        HibernateMode := False;
        SuspendFlag := True;
      end;
    end
    else if UpParam = 'HIBERNATION' then
    begin
      if Assigned(@IsPwrHibernateAllowed) and IsPwrHibernateAllowed() then
        begin
          HibernateMode := True;
          SuspendFlag := True;
        end;
      end;
  end;

  if SuspendFlag and Assigned(@SetSuspendState) then
  begin
    // �T�X�y���h������ǉ�
    SetSuspendState(HibernateMode, False, False);
  end
  else if CanExit then
  begin
    VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

    GetVersionEx(VerInfo);

    if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      GetSE_SHUTDOWN(tpSv);

    if ExitWindowsEx(ExtMode, 0) then
    begin
      if (ExtMode = EWX_LOGOFF) then
      begin
        // Windows95�̂�
        if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
          (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 0) then
        begin
          // �ă��O�I����̃G�N�X�v���[�����ċN������
          while True do
          begin
            w := FindWindow('Progman', nil);
            if w <> 0 then
              Break;
            Sleep(500);
          end;
          PostMessage(w, WM_QUIT, 0, 0);
          while True do
          begin
            w := FindWindow('Progman', nil);
            if w = 0 then
              Break;
            Sleep(500);
          end;
          WinExec('explorer.exe', SW_SHOW);
        end;
      end;
    end;

    if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      ReleaseSE_SHUTDOWN(tpSv);
  end
  else
  begin
    s := 'Windows �̏I�����s���܂��B' + #13#10
       + #13#10
       + 'ShtOp [shutdown|reboot|logoff|poweroff|suspend|hibernation] [force|forceifhung]' + #13#10
       + #13#10
       + 'shutdown' + #09#09 + '�R���s���[�^���V���b�g�_�E�����܂��B'+ #13#10
       + 'reboot'+ #09#09 + '�R���s���[�^���ċN�����܂��B' + #13#10
       + 'logoff' + #09#09 + 'Windows���烍�O�I�t���܂��B' + #13#10
       + 'poweroff' + #09#09 + '�R���s���[�^���V���b�g�_�E����� �d����؂�܂��B' + #13#10
       + 'suspend' +#09#09 + '�R���s���[�^���T�X�y���h��ԂɈڍs���܂��B' + #13#10
       + 'hibernation' + #09 + '�R���s���[�^���x�~��ԂɈڍs���܂��B' + #13#10
       + #13#10
       + 'force' + #09#09 + '�v���Z�X�������I�ɏI�������܂��B' + #13#10
       + 'forceifhung' + #09 + '�v���Z�X���������Ȃ��ꍇ�ɋ����I�ɏI�������܂��B(Windows 2000 �̂ݗL���j';
    MessageBox(0, PChar(s), '���', MB_ICONINFORMATION);
  end;
end.


