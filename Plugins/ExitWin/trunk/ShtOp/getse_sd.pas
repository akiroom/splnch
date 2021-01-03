unit getse_sd;

interface

uses
  Windows;

function GetSE_SHUTDOWN(var tpSv:TTokenPrivileges): Boolean;
function ReleaseSE_SHUTDOWN(var tpSv:TTokenPrivileges): Boolean;

implementation

const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';

function GetSE_SHUTDOWN(var tpSv: TTokenPrivileges): Boolean;
var
  Luid : TLargeInteger;
  tpNew : TTokenPrivileges;
  dwDummy : DWORD;
  hToken : THandle;
begin
  Result := False;
  if not LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, Luid) then
    Exit;

  if not OpenProcessToken(GetCurrentProcess, TOKEN_WRITE or TOKEN_QUERY, hToken) then
    Exit;

  tpNew.PrivilegeCount:=1;
  tpNew.Privileges[0].Luid:=Luid;
  tpNew.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  if not AdjustTokenPrivileges(hToken, False, tpNew, SizeOf(tpSv), tpSv, dwDummy) then
    Exit;

  if not CloseHandle(hToken) then
    Exit;

  Result := True;
end;

function ReleaseSE_SHUTDOWN(var tpSv: TTokenPrivileges): Boolean;
var
  tpDummy : TTokenPrivileges;
  Dummy : DWORD;
  hToken : Thandle;
begin
  Result := False;
  if not OpenProcessToken(GetCurrentProcess, TOKEN_WRITE or TOKEN_QUERY,hToken) then
    Exit;

  if not AdjustTokenPrivileges(hToken, False, tpSv, SizeOf(tpDummy), tpDummy, Dummy) then
    Exit;

  if not CloseHandle(hToken) then
    Exit;

  Result := True;
end;

end.

