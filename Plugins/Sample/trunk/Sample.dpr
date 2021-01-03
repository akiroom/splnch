library Sample;

{$R 'Resource.res' 'Resource.rc'}

uses
  Windows,
  SysUtils,
  Classes,
  PlugFunc in 'PlugFunc.pas',
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
  SLXChangePadMouseEntered,
  SLXChangePadForeground,
  SLXGetButton,
  SLXButtonCreate,
  SLXButtonDestroy,
  SLXButtonClick,
  SLXButtonDropFiles,
  SLXButtonDraw,
  SLXButtonDrawEx,
  SLXButtonUpdate,
  SLXButtonChip,
  SLXButtonOptions,
  SLXGetMenu,
  SLXMenuClick,
  SLXMenuCheck,
  SLXBeginSkin,
  SLXDrawDragBar,
  SLXDrawWorkspace,
  SLXDrawButtonFace,
  SLXDrawButtonFrame,
  SLXDrawButtonIcon,
  SLXDrawButtonCaption,
  SLXDrawButtonMask;
begin
end.
