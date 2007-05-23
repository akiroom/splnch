library DateTime;

uses
  SysUtils,
  Classes,
  PlugFunc in 'PlugFunc.pas',
  Option in 'Option.pas' {dlgOption},
  Cal in 'Cal.pas' {frmCal},
  Julius in 'Julius.pas',
  Holiday in 'Holiday.pas',
  BtnTitle in 'BtnTitle.pas' {frmBtnTitle},
  Memo in 'Memo.pas',
  EditMemo in 'EditMemo.pas' {dlgEditMemo},
  PlugBtns in 'PlugBtns.pas',
  MemoList in 'MemoList.pas' {dlgMemoList},
  Filter in 'Filter.pas' {dlgFilter},
  EditKind in 'EditKind.pas' {dlgEditKind},
  Kind in 'Kind.pas' {dlgKind},
  Output in 'Output.pas' {dlgOutput};

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
  SLXButtonDraw,
  SLXButtonUpdate,
  SLXButtonChip,
  SLXGetMenu,
  SLXMenuClick,
  SLXMenuCheck;
begin
end.
