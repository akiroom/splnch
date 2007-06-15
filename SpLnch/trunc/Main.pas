unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Pad, PadTab, SetPads, SetBtn, SetInit, ExtCtrls, Menus,
  ImgList, SetIcons, Buttons, SetPlug, PadPro, BtnPro, BtnEdit, OleBtn, ActiveX,
  HTMLHelps, About, XPMan, VerCheck;

const
  UWM_TASKTRAYEVENT = WM_USER + 0;

type
  TfrmMain = class(TForm)
    popTaskTray: TPopupMenu;
    popExit: TMenuItem;
    tmMousePos: TTimer;
    N1: TMenuItem;
    popOption: TMenuItem;
    N2: TMenuItem;
    popComLine: TMenuItem;
    popSearchTopic: TMenuItem;
    popAbout: TMenuItem;
    N3: TMenuItem;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure popExitClick(Sender: TObject);
    procedure tmMousePosTimer(Sender: TObject);
    procedure popOptionClick(Sender: TObject);
    procedure popTaskTrayPopup(Sender: TObject);
    procedure popComLineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure popSearchTopicClick(Sender: TObject);
    procedure popAboutClick(Sender: TObject);
  private
    HHPopup: THH_Popup;
    procedure AppActivate(Sender: TObject);
    function AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
    procedure tmAppStartTimer(Sender: TObject);
  public
    function ChangeOptions: Boolean;
    procedure SetTaskTray(Visible: Boolean);
    procedure WMTaskTrayEvent(var Msg: TMessage); message UWM_TASKTRAYEVENT;
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
  end;

var
  frmMain: TfrmMain;

implementation

uses Option, ComLine;


{$R *.DFM}

// フォーム作成
procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmAppStart: TTimer;
begin
  // HTML Help の準備
  Application.HelpFile := ChangeFileExt(ParamStr(0),'.chm');
  Application.OnHelp := AppHelp;
  FillChar(HHPopup, SizeOf(THH_Popup), 0);
  HHPopup.cbStruct := SizeOf(THH_Popup);
  HHPopup.pt := Point(-1, -1);
  HHPopup.clrForeground := -1;
  HHPopup.clrBackground := -1;
  HHPopup.rcMargins := Rect(-1, -1, -1, -1);

  tmAppStart := TTimer.Create(Self);
  tmAppStart.OnTimer := tmAppStartTimer;
  tmAppStart.Interval := 100;
  tmAppStart.Enabled := True;
end;

// アプリケーションの準備タイマー
procedure TfrmMain.tmAppStartTimer(Sender: TObject);
var
  Msg: string;
  NextVerCheck: string;
  NowVerCheck: string;
begin
  TTimer(Sender).Free;

  Tag := -1;
  if not LoadAppInit then
  begin
    Close;
    Exit;
  end;

  Pads := TPads.Create;
  IconCache := TIconCache.Create;
  Plugins := TPlugins.Create;

  Application.OnActivate := AppActivate;
  if not ChangeOptions then
  begin
    Close;
    Exit;
  end;

  Tag := 0;
  try
    IconCache.Load(UserFolder + FileNameIco);
  except
    IconCache.Clear;
  end;

  try
    Pads.Load;
  except
    on E: Exception do
    begin
      Msg := 'パッドの読み込みに失敗しました。' + E.Message;
      Application.MessageBox(PChar(Msg), 'エラー', MB_ICONERROR);
    end;
  end;
  Plugins.BeginPlugins;
  Pads.BeginPads;

  // 更新チェック
  if UserIniFile.ReadBool(IS_OPTIONS, 'VerCheck', True) then
  begin
    NextVerCheck := UserIniFile.ReadString(IS_OPTIONS, 'NextVerCheck', '');
    DateTimeToString(NowVerCheck, 'yyyymmdd', Now);
    if NowVerCheck >= NextVerCheck then
    begin
      if dlgVerCheck = nil then
        dlgVerCheck := TdlgVerCheck.Create(nil);
    end;
    

  end;
  
end;

// フォーム破棄
procedure TfrmMain.FormDestroy(Sender: TObject);
var
  Msg: string;
begin
  Application.OnHelp := nil;

  try
    Msg := 'パッドの開放';
    Pads.Free;
    Pads := nil;
    Msg := 'プラグインの開放';
    Plugins.Free;
    Plugins := nil;
    Msg := '設定ファイルの開放';
    UserIniFile.Free;
    UserIniFile := nil;
    Msg := 'アイコンキャッシュの開放';
    IconCache.Free;
    IconCache := nil;
  except
    on E: Exception do
    begin
      Msg := Msg + 'にエラーが発生しました。' + E.Message;
      Application.MessageBox(PChar(Msg), 'エラー', MB_ICONERROR);
    end;
  end;

end;

// 閉じる
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Msg: string;
begin
  // OnCloseだとWindows終了時に呼ばれないのでここに書く
  if Tag = 0 then
  begin
    try
      Msg := 'パッドの終了';
      Pads.EndPads;
      Msg := 'プラグインの終了';
      Plugins.EndPlugins;
      Msg := 'パッドの設定の保存';
      Pads.SaveIni;
      Msg := 'アイコンキャッシュの保存';
      IconCache.Save(UserFolder + FileNameIco);
    except
      on E: Exception do
      begin
        Msg := Msg + 'にエラーが発生しました。' + E.Message;
        Application.MessageBox(PChar(Msg), 'エラー', MB_ICONERROR);
      end;
    end;
  end;

  SetTaskTray(False);
end;

// アプリケーションアクティブ
procedure TfrmMain.AppActivate(Sender: TObject);
begin
  ChangeOptions;
end;


// ヘルプ表示
function TfrmMain.AppHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
var
  Wnd: HWnd;
  FileName: String;
begin
  Result := False;
  CallHelp := False;
  FileName := Application.HelpFile;
  if not FileExists(FileName) then
    Exit;

    Wnd := Application.Handle;

  case Command of
    HELP_CONTENTS:
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TOPIC, 0);
    HELP_FINDER:
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TOPIC, Data);
    HELP_QUIT:
      HTMLHelp(Wnd, PChar(FileName), HH_CLOSE_ALL, Data);
    HELP_CONTEXT:
      HTMLHelp(Wnd, PChar(FileName), HH_HELP_CONTEXT, Data);
    HELP_CONTEXTPOPUP:
    begin
      HHPopup.idString := Data;
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TEXT_POPUP, DWORD(@HHPopup));
    end;
    HELP_SETPOPUP_POS:
      HHPopup.pt := Point(LoWord(Data), HiWord(Data));
  end;
  Result := True;
end;



// 画面のサイズと色数の変更
procedure TfrmMain.WMDisplayChange(var Msg: TWMDisplayChange);
begin
  inherited;
  IconCache.ColorBits := Msg.BitsPerPixel;
end;


// オプションの設定
function TfrmMain.ChangeOptions: Boolean;
begin
  Result := True;
  // タスクトレイのセット
  SetTaskTray(UserIniFile.ReadBool(IS_OPTIONS, 'TaskTray', True));
  // アイコンキャッシュの最大使用量
  IconCache.CacheMax := UserIniFile.ReadInteger(IS_OPTIONS, 'IconCache', 1000);
end;

// タスクトレイのセット
procedure TfrmMain.SetTaskTray(Visible: Boolean);
var
  Icon: hIcon;
  icn: NOTIFYICONDATA;
begin
  if Visible then
  begin
    Icon := IconCache.GetIcon(PChar(ParamStr(0)), ftIconPath, 0, True, True);
    try
      icn.cbSize := sizeof(NOTIFYICONDATA);
      icn.Wnd := Handle;
      icn.uID := 100;
      icn.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
      icn.uCallbackMessage := UWM_TASKTRAYEVENT;
      icn.hIcon := Icon;
      lstrcpy(icn.szTip, 'Special Launch');
      Shell_NotifyIcon(NIM_ADD, @icn);
    finally
      DestroyIcon(Icon);
    end;
  end
  else
  begin
    icn.cbSize := sizeof(NOTIFYICONDATA);
    icn.Wnd := Handle;
    icn.uID := 100;
    icn.uFlags := 0;
    Shell_NotifyIcon(NIM_DELETE, @icn);
  end;
end;


// タスクトレイのイベント
procedure TfrmMain.WMTaskTrayEvent(var Msg: TMessage);
var
  P: TPoint;
begin
  if Pads = nil then
    Exit;

  // 操作不能
  if Pads.Count > 0 then
  begin
    if (Pads[0].frmPadTab.Hid and not IsWindowEnabled(Pads[0].frmPadTab.Handle)) or
      (not Pads[0].frmPadTab.Hid and not IsWindowEnabled(Pads[0].Handle)) then
      Exit;
  end;


  if Msg.LParam = WM_LBUTTONDOWN then
  begin
    if Pads.Count > 0 then
      SetForegroundWindow(Pads[0].Handle);
  end
  else if Msg.LParam = WM_RBUTTONDOWN then
  begin
    if Pads.Count > 0 then
      SetForegroundWindow(Pads[0].Handle);

    GetCursorPos(P);
    popTaskTray.Popup(P.X, P.Y);
  end;
end;

// タスクトレイのポップアップメニュー
procedure TfrmMain.popTaskTrayPopup(Sender: TObject);
begin
  popComLine.Enabled := dlgComLine = nil;
  popOption.Enabled := dlgOption = nil;
  popSearchTopic.Enabled := FileExists(Application.HelpFile);
end;

// タスクトレイの終了メニュー
procedure TfrmMain.popExitClick(Sender: TObject);
begin
  Close;
end;

// マウスポインタ位置監視タイマー
procedure TfrmMain.tmMousePosTimer(Sender: TObject);
var
  Form: TForm;
  FormRect: TRect;
  P: TPoint;

  i: Integer;
begin
  if Pads = nil then
    Exit;

  tmMousePos.Enabled := False;
  try
    GetCursorPos(P);
    for i := 0 to Pads.Count - 1 do
    begin
      if Pads[i].frmPadTab.Hid then
        Form := Pads[i].frmPadTab
      else
        Form := Pads[i];
      FormRect := Rect(Form.Left, Form.Top, Form.Left + Form.Width, Form.Top + Form.Height);
      InflateRect(FormRect, 1, 1);
      Pads[i].MouseEntered := PtInRect(FormRect, P);
    end;
  finally
    tmMousePos.Enabled := True;
  end;
end;

// 指定して実行
procedure TfrmMain.popComLineClick(Sender: TObject);
begin
  if dlgComLine = nil then
    dlgComLine := TdlgComLine.Create(nil);
  dlgComLine.Show;
end;

// 設定
procedure TfrmMain.popOptionClick(Sender: TObject);
begin
  if dlgOption = nil then
    dlgOption := TdlgOption.Create(nil);
  dlgOption.Show;
end;


// ヘルプ
procedure TfrmMain.popSearchTopicClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;


// バージョン情報
procedure TfrmMain.popAboutClick(Sender: TObject);
var
  lstReadme: TStringList;
  s: String;
  i: Integer;
  Plugin: TPlugin;
begin
  lstReadme := TStringList.Create;
  try
    // 本体
    lstReadme.Add('Special Launch ');
    lstReadme.Add(GetFileVersionString(ParamStr(0), True));
    lstReadme.Add('Copyright (C) SAWADA Shigeru');


    // Windows
    lstReadme.Add('--------------------------------------');
    s := 'Windows';
    case OSVersionInfo.dwPlatformId of
      VER_PLATFORM_WIN32s:
        s := 'Win32s on Windows3.1';
      VER_PLATFORM_WIN32_WINDOWS:
        s := 'Windows';
      VER_PLATFORM_WIN32_NT:
        s := 'Windows NT';
    end;
    with OSVersionInfo do
      s := Format('%s %d.%d.%d %s', [s, dwMajorVersion, dwMinorVersion, dwBuildNumber, szCSDVersion]);
    lstReadme.Add(s);
    s := 'Internet Explorer ' + GetFileVersionString('comctl32.dll', False);
    lstReadme.Add(s);
    lstReadme.Add(UserName);


    // プラグイン
    lstReadme.Add('--------------------------------------');
    for i := 0 to Plugins.Count - 1 do
    begin
      Plugin := TPlugin(Plugins.Objects[i]);
      if Plugin.Enabled then
        lstReadme.Add(Plugin.Name)
      else
        lstReadme.Add(Plugin.Name + '[Disabled]');
      s := Format(' %-15s %s', [ExtractFileName(Plugin.FileName), GetFileVersionString(Plugin.FileName, True)]);
      lstReadme.Add(s);
    end;


    ShowAbout('Special Launch', ParamStr(0), lstReadme.Text);
  finally
    lstReadme.Free;
  end;
end;


end.

