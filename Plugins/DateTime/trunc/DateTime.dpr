library DateTime;

{$R 'Resource.res' 'Resource.rc'}
{%TogetherDiagram 'ModelSupport_DateTime\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Memo\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Option\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\MemoList\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\EditKind\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\PlugFunc\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\PlugBtns\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\DateTime\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Julius\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Output\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\EditMemo\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Kind\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Holiday\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Cal\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\BtnTitle\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\Filter\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DateTime\default.txvpck'}
{%TogetherDiagram 'ModelSupport_DateTime\BtnTitle\default.txvpck'}
{%TogetherDiagram 'ModelSupport_DateTime\DateTime\default.txvpck'}
{%TogetherDiagram 'ModelSupport_DateTime\Cal\default.txvpck'}

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
