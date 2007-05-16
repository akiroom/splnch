library ExitWin;

uses
  SysUtils,
  Classes,
  PlugFunc in 'PlugFunc.pas',
  Confirm in 'Confirm.pas' {frmConfirm},
  Option in 'Option.pas' {dlgOption};

{$E slx}

{$R *.RES}
{$R DATA.RES}

exports
  SLXGetName,
  SLXGetExplanation,
  SLXSetInitFile,
  SLXBeginPlugin,
  SLXEndPlugin,
  SLXChangeOptions,
  SLXGetButton,
  SLXButtonClick,
  SLXGetMenu,
  SLXMenuClick;
begin
end.
