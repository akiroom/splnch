program SpLnch;

{%ToDo 'SpLnch.todo'}
{%TogetherDiagram 'ModelSupport_SpLnch\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetArrg\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\PadPro\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetInit\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SpLnch\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\Option\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\About\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetBtn\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SLBtns\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\BtnEdit\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\pidl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\ShlObjAdditional\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\OleData\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetPlug\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\InitFld\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\OleBtn\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetIcons\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SetPads\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\SLAPI\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\Password\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\BtnPro\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\BtnTitle\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\IconChg\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\ComLine\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\PadTab\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\Pad\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SpLnch\default.txvpck'}
{$R 'Resource.res' 'Resource.rc'}

uses
  Forms,
  Windows,
  Main in 'Main.pas' {frmMain},
  Pad in 'Pad.pas' {frmPad},
  SetInit in 'SetInit.pas',
  Option in 'Option.pas' {dlgOption},
  InitFld in 'InitFld.pas' {dlgInitFolder},
  SetPads in 'SetPads.pas',
  PadTab in 'PadTab.pas' {frmPadTab},
  PadPro in 'PadPro.pas' {dlgPadProperty},
  SetBtn in 'SetBtn.pas',
  BtnEdit in 'BtnEdit.pas' {dlgButtonEdit},
  SetIcons in 'SetIcons.pas',
  About in 'About.pas' {dlgAbout},
  SLBtns in 'SLBtns.pas',
  SetArrg in 'SetArrg.pas',
  BtnTitle in 'BtnTitle.pas' {frmBtnTitle},
  SetPlug in 'SetPlug.pas',
  BtnPro in 'BtnPro.pas' {dlgBtnProperty},
  IconChg in 'IconChg.pas' {dlgIconChange},
  pidl in 'pidl.pas',
  OleData in 'OleData.pas',
  OleBtn in 'OleBtn.pas',
  ComLine in 'ComLine.pas' {dlgComLine},
  HTMLHelps in 'HTMLHelps.pas',
  Password in 'Password.pas' {dlgPassword},
  SLAPI in 'SLAPI.pas',
  ShlObjAdditional in 'ShlObjAdditional.pas';

{$R *.RES}

exports
  SLAGetPadCount,
  SLAGetPadID,
  SLAGetNextPadID,
  SLAGetPadWnd,
  SLAGetPadTabWnd,
  SLAGetPadInit,
  SLASetPadInit,
  SLAChangePluginButtons,
  SLAChangePluginMenus,
  SLARedrawPluginButtons,
  SLAGetGroupCount,
  SLAGetGroup,
  SLAInsertGroup,
  SLARenameGroup,
  SLACopyGroup,
  SLADeleteGroup,
  SLAGetButton,
  SLAInsertButton,
  SLAChangeButton,
  SLADeleteButton,
  SLACopyButton,
  SLAPasteButton,
  SLAButtonInClipbord,
  SLARunButton,
  SLAGetIcon;


const
  MUTEX_NAME = 'Special Launch Mutex';
var
  hMutex: THandle;
  Msg: String;
begin

  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
  if hMutex <> 0 then
  begin
    Msg := 'Special Launch が起動しているか、関連のツールがロックしています。'
        + '該当するプログラムを終了して再度実行してください。';
    MessageBox(GetDesktopWindow, PChar(Msg),
      '確認', MB_ICONINFORMATION);
    Exit;
  end;

  hMutex := CreateMutex(nil, False, MUTEX_NAME);

  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Special Launch';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

  ReleaseMutex(hMutex);

end.
