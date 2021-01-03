library TrnslPad;

uses
  SysUtils,
  Classes,
  PlugFunc in 'PlugFunc.pas',
  W2k in 'W2k.pas',
  InAlpha in 'InAlpha.pas' {dlgInAlpha},
  SLAPI in 'SLAPI.pas';

{$E slx}

{$R *.RES}

exports
  SLXGetName,
  SLXGetExplanation,
  SLXSetInitFile,
  SLXBeginPlugin,
  SLXEndPlugin,
  SLXChangeOptions,
  SLXChangePadForeground,
  SLXChangePadMouseEntered,
  SLXGetMenu,
  SLXMenuClick;
begin
end.
