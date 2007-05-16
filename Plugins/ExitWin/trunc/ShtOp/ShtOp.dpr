program ShtOp;

uses
  Windows, Messages,
  SysUtils,
  getse_sd in 'getse_sd.pas';

{$R *.RES}
{$R SHTOP2.RES}

var
  UpParam: String;
  CanExit: Boolean;
  ExtMode: Integer;
  VerInfo: TOSVersionInfo;
  tpSv: TTokenPrivileges;
  i: Integer;
  w: HWND;
  s: String;
begin
  CanExit := False;
  ExtMode := 0;
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
    end;


  end;

  if CanExit then
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

