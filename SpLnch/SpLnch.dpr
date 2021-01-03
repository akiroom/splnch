program SpLnch;

{$R 'Resource.res' 'Resource.rc'}
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

uses
  Forms,
  Windows,
  Messages,
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
  ShlObjAdditional in 'ShlObjAdditional.pas',
  VerCheck in 'VerCheck.pas' {dlgVerCheck};

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
  SETUP_MUTEX_NAME = 'Special Launch Setup Mutex';
var
  hMutex: THandle;
  Msg: String;
  Wnd: hWnd;
begin

  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
  if hMutex <> 0 then
  begin
    Wnd := FindWindow('TApplication', 'Special Launch');
    if Wnd <> 0 then
    begin
      try
        SetForegroundWindow(Wnd);
      except
        // 初期化が終わってないと例外発生
        Wnd := 0;
      end;
    end;
    if Wnd = 0 then
    begin
      Msg := 'Special Launch 関連のツールがロックしています。'
          + '該当するプログラムを終了して再度実行してください。';
      MessageBox(GetDesktopWindow, PChar(Msg),
        '確認', MB_ICONINFORMATION);
    end;

    Exit;
  end;

  // セットアップを確認
  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, SETUP_MUTEX_NAME);
  if hMutex <> 0 then
  begin
    Wnd := FindWindow('TApplication', 'Special Launch セットアップ');
    if Wnd <> 0 then
    begin
      try
        SetForegroundWindow(Wnd);
      except
        // 初期化が終わってないと例外発生
        Wnd := 0;
      end;
    end;
    if Wnd = 0 then
    begin
      Msg := 'Special Launch セットアップがロックしています。'
          + 'プログラムを終了して再度実行してください。';
      MessageBox(GetDesktopWindow, PChar(Msg),
        '確認', MB_ICONINFORMATION);
    end;

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
