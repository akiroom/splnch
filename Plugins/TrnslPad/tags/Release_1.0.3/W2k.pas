unit W2k;

interface

uses
  Windows;

{APIêÈåæ}
var
  MySetLayeredWindowAttributes: function(Wnd: HWND; Color: DWORD; Trans: BYTE; Flag: DWORD): Boolean; stdcall;
  MyAnimateWindow: function(hWnd: HWND; dwTime: DWORD; dwFlags: DWORD): BOOL; stdcall;

const
  WS_EX_LAYERED = $80000;
  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;

implementation

var
  hLibUser32: THandle;

initialization
  hLibUser32 := LoadLibraryA('user32.dll');
  if hLibUser32 <> 0 then
  begin
    MySetLayeredWindowAttributes := GetProcAddress(hLibUser32, 'SetLayeredWindowAttributes');
    MyAnimateWindow := GetProcAddress(hLibUser32, 'AnimateWindow');
  end;
finalization
  if hLibUser32 <> 0 then
  begin
    FreeLibrary(hLibUser32);
    hLibUser32 := 0;
  end;

end.

