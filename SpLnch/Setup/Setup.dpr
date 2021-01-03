program Setup;

{$R 'Resource.res' 'Resource.rc'}
{%TogetherDiagram 'ModelSupport_Setup\default.txaPackage'}

uses
  Forms,
  Windows,
  Messages,
  Main in 'Main.pas' {frmMain},
  SetBtn in 'SetBtn.pas',
  pidl in 'pidl.pas',
  SetFuncs in 'SetFuncs.pas';

{$R *.RES}

var
  hMutex: THandle;
  Msg: String;
  Wnd: hWnd;
begin
  if ParamStr(1) = '-deletefile' then
  begin
    SL4FileDelete;
  end
  else
  begin
    // Special Launch を確認
    hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
    if hMutex <> 0 then
    begin
      Wnd := FindWindow('TApplication', 'Special Launch');
      if Wnd <> 0 then
      begin
        Msg := 'Special Launch を終了してセットアップを続行します。';
        if MessageBox(GetDesktopWindow, PChar(Msg), '確認', MB_ICONINFORMATION or MB_OKCANCEL) <> idOk then
        begin
          Exit;
        end;

        try
          ReleaseMutex(hMutex);
          CloseHandle(hMutex);
          SendMessage(Wnd, WM_CLOSE, 0, 0);
        except
          // 初期化が終わってないと例外発生
          Wnd := 0;
        end;
      end;

      if Wnd = 0 then
      begin
        Msg := 'Special Launch がセットアップをロックしています。'
            + 'Special Launchを終了して再度実行してください。';
        MessageBox(GetDesktopWindow, PChar(Msg),
          '確認', MB_ICONINFORMATION);
        Exit;
      end;
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

    hSetupMutex := CreateMutex(nil, False, SETUP_MUTEX_NAME);

    Application.Initialize;
    Application.Title := 'Special Launch セットアップ';
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    ReleaseMutex(hSetupMutex);
  end;
end.
