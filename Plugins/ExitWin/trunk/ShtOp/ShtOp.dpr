program ShtOp;

{$R 'Resource.res' 'Resource.rc'}

uses
  Windows,
  Messages,
  SysUtils,
  getse_sd in 'getse_sd.pas';

{$R *.RES}

type
  TIsPwrSuspendAllowed = function(): BOOL;stdcall;
  TIsPwrHibernateAllowed = function(): BOOL;stdcall;
  TSetSuspendState = function(Hibernate : BOOL; ForceCritical : BOOL; DisableWakeEvent : BOOL) : Boolean; stdcall;

var
  UpParam: String;
  CanExit: Boolean;
  HelpDisp: Boolean;
  ExtMode: Integer;
  HibernateMode: Boolean;
  SuspendFlag: Boolean;
  SystemPowerState: Boolean;
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
  HelpDisp := True;
  ExtMode := 0;
  HibernateMode := False;
  SuspendFlag := False;
  SystemPowerState := False;
  w := 0;
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  hPowrprof := LoadLibrary('PowrProf.dll');
  if hPowrprof <> 0 then
  begin
    @IsPwrSuspendAllowed := GetProcAddress(hPowrprof, 'IsPwrSuspendAllowed');
    @IsPwrHibernateAllowed := GetProcAddress(hPowrprof, 'IsPwrHibernateAllowed');
    @SetSuspendState := GetProcAddress(hPowrprof, 'SetSuspendState');
  end
  else
  begin
    IsPwrSuspendAllowed := nil;
    IsPwrHibernateAllowed := nil;
    SetSuspendState := nil;
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
      SystemPowerState := True;
      HibernateMode := False;
      SuspendFlag := True;
    end
    else if UpParam = 'HIBERNATION' then
    begin
      SystemPowerState := True;
      HibernateMode := True;
      SuspendFlag := True;
    end;
  end;

  if SuspendFlag and Assigned(@SetSuspendState) then
  begin
    // サスペンド処理を追加
    if SetSuspendState(HibernateMode, False, False) then
      SystemPowerState := False;
    HelpDisp := False;
  end;
  if SystemPowerState then
  begin
    if HibernateMode and Assigned(IsPwrHibernateAllowed) then
    begin
      // 休止状態の場合
      if not IsPwrHibernateAllowed() then
      begin
        SystemPowerState := False;
        s := '休止状態に移行できませんでした。' + #13#10;
      end;
    end;
    if not HibernateMode and Assigned(IsPwrSuspendAllowed) then
    begin
      // サスペンドの場合
      if not IsPwrSuspendAllowed() then
      begin
        SystemPowerState := False;
        s := 'サスペンドに移行できませんでした。' + #13#10;
      end;
    end;
    if SystemPowerState then
    begin
      if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
        GetSE_SHUTDOWN(tpSv);

      HibernateMode := not HibernateMode;
      SetSystemPowerState(HibernateMode, False);

      if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
        ReleaseSE_SHUTDOWN(tpSv);
    end
    else
    begin
      s := s + '電源オプションの設定を確認してください。';
      MessageBox(0, PChar(s), '情報', MB_ICONINFORMATION);
    end;
  end
  else if CanExit then
  begin
    if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      GetSE_SHUTDOWN(tpSv);

    if ExitWindowsEx(ExtMode, 0) then
    begin
      if (ExtMode = EWX_LOGOFF) then
      begin
        // Windows95のみ
        if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
          (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 0) then
        begin
          // 再ログオン後のエクスプローラを再起動する
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
  else if HelpDisp then
  begin
    s := 'Windows の終了を行います。' + #13#10
       + #13#10
       + 'ShtOp [shutdown|reboot|logoff|poweroff|suspend|hibernation] [force|forceifhung]' + #13#10
       + #13#10
       + 'shutdown' + #09#09 + 'コンピュータをシャットダウンします。'+ #13#10
       + 'reboot'+ #09#09 + 'コンピュータを再起動します。' + #13#10
       + 'logoff' + #09#09 + 'Windowsからログオフします。' + #13#10
       + 'poweroff' + #09#09 + 'コンピュータをシャットダウンし､ 電源を切ります。' + #13#10
       + 'suspend' +#09#09 + 'コンピュータをサスペンド状態に移行します。' + #13#10
       + 'hibernation' + #09 + 'コンピュータを休止状態に移行します。' + #13#10
       + #13#10
       + 'force' + #09#09 + 'プロセスを強制的に終了させます。' + #13#10
       + 'forceifhung' + #09 + 'プロセスが反応がない場合に強制的に終了させます。(Windows 2000 のみ有効）';
    MessageBox(0, PChar(s), '情報', MB_ICONINFORMATION);
  end;
end.


