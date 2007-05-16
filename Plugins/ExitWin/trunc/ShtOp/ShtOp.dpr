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

    if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then      ReleaseSE_SHUTDOWN(tpSv);  end  else  begin    s := 'Windows �̏I�����s���܂��B' + #13#10       + #13#10       + 'ShtOp [shutdown|reboot|logoff|poweroff] [force|forceifhung]' + #13#10       + #13#10       + 'shutdown   �R���s���[�^���V���b�g�_�E�����܂��B'+ #13#10       + 'reboot   �R���s���[�^���ċN�����܂��B' + #13#10       + 'logoff   Windows���烍�O�I�t���܂��B' + #13#10       + 'poweroff   �R���s���[�^���V���b�g�_�E����� �d����؂�܂��B' + #13#10       + #13#10       + 'force   �v���Z�X�������I�ɏI�������܂��B' + #13#10       + 'forceifhung   �v���Z�X���������Ȃ��ꍇ�ɋ����I�ɏI�������܂��B(Windows 2000 �̂ݗL���j';    MessageBox(0, PChar(s), '���', MB_ICONINFORMATION);  end;end.


