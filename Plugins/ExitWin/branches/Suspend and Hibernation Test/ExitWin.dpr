library ExitWin;

{$R 'Resource.res' 'Resource.rc'}

uses
  SysUtils,
  Classes,
  PlugFunc in 'PlugFunc.pas',
  Confirm in 'Confirm.pas' {frmConfirm},
  Option in 'Option.pas' {dlgOption};

{$E slx}

{$R *.RES}

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
