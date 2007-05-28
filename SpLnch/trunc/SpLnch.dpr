program SpLnch;

{%ToDo 'SpLnch.todo'}

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
{$R DATA.RES}

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
