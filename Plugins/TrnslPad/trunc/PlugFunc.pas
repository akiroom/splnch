unit PlugFunc;

interface

uses
  Windows, Messages, SysUtils, ExtCtrls, Graphics, Classes, IniFiles, W2k,
  SLAPI, InAlpha, Forms;

// 構造体 ----------------------------------------------------------------------
type

  // メニューの情報
  PSLXMenuInfo = ^TSLXMenuInfo;
  TSLXMenuInfo = packed record
    Name: array[0..63] of Char; // メニュー名
    SCut: array[0..63] of Char; // ショートカットキー
  end;


// 全般の関数 ------------------------------------------------------------------

// プラグインの名前を返す
function SLXGetName(Name: PChar; Size: Word): BOOL; stdcall;
// プラグインの説明を返す
function SLXGetExplanation(Explanation: PChar; Size: Word): BOOL; stdcall;
// プラグインが使用できる設定ファイルをもらう
function SLXSetInitFile(InitFile: PChar): BOOL; stdcall;
// プラグインを開始
function SLXBeginPlugin: BOOL; stdcall;
// プラグインを終了
function SLXEndPlugin: BOOL; stdcall;
// 設定ダイアログを呼び出す
function SLXChangeOptions(hWnd: HWND): BOOL; stdcall;
// パッドがアクティブになったときの処理
function SLXChangePadForeground(Wnd: HWND; Foreground: BOOL): BOOL; stdcall;
// パッドにマウスが入ったときの処理
function SLXChangePadMouseEntered(Wnd: HWND; Entered: BOOL): BOOL; stdcall;

// メニュー用関数 --------------------------------------------------------------

// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;



// サンプル用定数 --------------------------------------------------------------
const
  // プラグインの名前
  PLUGIN_NAME = '半透明パッド';
  // プラグインの説明
  PLUGIN_EXPRANATION =
      #13#10
    + '半透明パッドプラグイン' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1996-2007' + #13#10
    + '              SAWADA Shigeru All rights reserved.' + #13#10
    + '                             制作・著作 : 沢田茂';

  // メニュー数
  MENU_COUNT = 1;

  // メニュー定義
  MENU_INFO: array[0..MENU_COUNT-1] of TSLXMenuInfo =
  (
    (
      Name: 'パッドの半透明化(&L)...';
      SCut: '';
    )
  );

type
  TLayerdPad = class(TObject)
    ID: Integer;
    Alpha: Integer;
    LastAlpha: Integer;
    NowAlpha: Integer;
    Foreground: Boolean;
    Entered: Boolean;
  end;


  TDummyControl = class(TObject)
    Timer: TTimer;
    constructor Create;
    destructor Destroy; override;
  private
    procedure TimerTimer(Sender: TObject);
  end;

var
  InitFileName: string; // 設定ファイル名
  LayerdPads: TList;
  DummyControl: TDummyControl;

procedure SetLayerdPad(ID, Alpha, LastAlpha: Integer);

implementation

// プラグインの名前を返す
function SLXGetName(Name: PChar; Size: Word): BOOL;
begin
  Result := True;
  StrPCopy(Name, Copy(PLUGIN_NAME, 1, Size - 1));
end;

// プラグインの説明を返す
function SLXGetExplanation(Explanation: PChar; Size: Word): BOOL;
begin
  Result := True;
  StrPCopy(Explanation, Copy(PLUGIN_EXPRANATION, 1, Size - 1));
end;

// プラグインが使用できる設定ファイルをもらう
function SLXSetInitFile(InitFile: PChar): BOOL;
begin
  Result := True;
  InitFileName := StrPas(InitFile);
end;

// プラグインを開始
function SLXBeginPlugin: BOOL;
var
  Ini: TIniFile;
  i: Integer;
  ID, Alpha: Integer;
begin
  if not ExistsSLAPI then
  begin
    MessageBox(0, 'Special Launch はこのプラグインをサポートしていません。', PLUGIN_NAME, MB_ICONERROR);
    Result := False;
    Exit;
  end;

  if @MySetLayeredWindowAttributes = nil then
  begin
    MessageBox(0, 'この Windows は半透明ウィンドウをサポートしていません。', PLUGIN_NAME, MB_ICONERROR);
    Result := False;
    Exit;
  end;

  Ini := TIniFile.Create(InitFileName);
  try
    i := 0;
    while True do
    begin

      ID := Ini.ReadInteger('LayerdPads', 'ID' + IntToStr(i), 0);
      Alpha := Ini.ReadInteger('LayerdPads', 'Alpha' + IntToStr(i), 0);

      if ID = 0 then
        Break;

      SetLayerdPad(ID, Alpha, Alpha);
      Inc(i);
    end;
  finally
    Ini.Free;
  end;

  Result := True;
end;

// プラグインを終了
function SLXEndPlugin: BOOL;
var
  Ini: TIniFile;
  i: Integer;
  LayerdPad: TLayerdPad;
  PadWnd, PadTabWnd: HWND;
begin
  Ini := TIniFile.Create(InitFileName);
  try
    Ini.EraseSection('LayerdPads');
    Ini.UpdateFile;
    for i := 0 to LayerdPads.Count - 1 do
    begin
      LayerdPad := TLayerdPad(LayerdPads[i]);
      Ini.WriteInteger('LayerdPads', 'ID' + IntToStr(i), LayerdPad.ID);
      Ini.WriteInteger('LayerdPads', 'Alpha' + IntToStr(i), LayerdPad.Alpha);

      PadWnd := SLAGetPadWnd(LayerdPad.ID);
      PadTabWnd := SLAGetPadTabWnd(LayerdPad.ID);
      SetWindowLong(PadWnd, GWL_EXSTYLE, GetWindowLong(PadWnd, GWL_EXSTYLE) and not WS_EX_LAYERED);
      SetWindowLong(PadTabWnd, GWL_EXSTYLE, GetWindowLong(PadTabWnd, GWL_EXSTYLE) and not WS_EX_LAYERED);
    end;
  finally
    Ini.Free;
  end;

  Result := True;
end;

// 設定ダイアログを呼び出す
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  MessageBox(hWnd, '設定項目はありません。', '確認', MB_ICONINFORMATION);
  Result := False;
end;

// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL;
begin
  case No of
    0..MENU_COUNT-1:
    begin
      Result := True;
      MenuInfo^ := MENU_INFO[No];
    end;
  else
    Result := False;
  end;
end;

// パッドのマウス状態とフォーカス状態をチェック
function PadActive(Pad: TLayerdPad): Boolean;
var
  Active: Boolean;
  PadWnd, PadTabWnd: HWND;
begin
  Active := Pad.Foreground or Pad.Entered;
  if Active then
  begin
    Pad.LastAlpha := 255;
    Pad.NowAlpha := 255;
    PadWnd := SLAGetPadWnd(Pad.ID);
    PadTabWnd := SLAGetPadTabWnd(Pad.ID);
    MySetLayeredWindowAttributes(PadWnd, 0, Byte(255), LWA_ALPHA);
    MySetLayeredWindowAttributes(PadTabWnd, 0, Byte(255), LWA_ALPHA);
  end
  else
  begin
    Pad.LastAlpha := Pad.Alpha;
  end;
  Result := Active;
end;

// パッドがアクティブになったときの処理
function SLXChangePadForeground(Wnd: HWND; Foreground: BOOL): BOOL; stdcall;
var
  ID: Integer;
  i: Integer;
  TimerEnabled: Boolean;
  PadWnd, PadTabWnd: HWND;
begin
  Result := True;

  TimerEnabled := False;
  ID := SLAGetPadID(Wnd);
  for i := 0 to LayerdPads.Count - 1 do
  begin
    if TLayerdPad(LayerdPads[i]).ID = ID then
    begin
      TLayerdPad(LayerdPads[i]).Foreground := Foreground;
      PadActive(TLayerdPad(LayerdPads[i]));
    end;
    if TLayerdPad(LayerdPads[i]).NowAlpha <> TLayerdPad(LayerdPads[i]).LastAlpha then
      TimerEnabled := True;
  end;
  DummyControl.Timer.Enabled := TimerEnabled;
end;

// パッドにマウスが入ったときの処理
function SLXChangePadMouseEntered(Wnd: HWND; Entered: BOOL): BOOL;
var
  ID: Integer;
  i: Integer;
  TimerEnabled: Boolean;
  PadWnd, PadTabWnd: HWND;
begin
  Result := True;

  TimerEnabled := False;
  ID := SLAGetPadID(Wnd);
  for i := 0 to LayerdPads.Count - 1 do
  begin
    if TLayerdPad(LayerdPads[i]).ID = ID then
    begin
      TLayerdPad(LayerdPads[i]).Entered := Entered;
      PadActive(TLayerdPad(LayerdPads[i]));
    end;
    if TLayerdPad(LayerdPads[i]).NowAlpha <> TLayerdPad(LayerdPads[i]).LastAlpha then
      TimerEnabled := True;
  end;
  DummyControl.Timer.Enabled := TimerEnabled;
end;



// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL;
var
  ID, Alpha: Integer;
  i: Integer;
begin
  Result := True;

  ID := SLAGetPadID(hWnd);

  Alpha := 255;
  i := LayerdPads.Count - 1;
  while i >= 0 do
  begin
    if TLayerdPad(LayerdPads[i]).ID = ID then
    begin
      Alpha := TLayerdPad(LayerdPads[i]).Alpha;
      LayerdPads.Delete(i);
    end;
    Dec(i);
  end;

  dlgInAlpha := TdlgInAlpha.Create(nil);
  try
    SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) or WS_EX_LAYERED);
    dlgInAlpha.hWnd := hWnd;
    dlgInAlpha.tbAlpha.Position :=  Alpha;
    if dlgInAlpha.ShowModal = idOk then
    begin
      Alpha := dlgInAlpha.tbAlpha.Position;
    end;
  finally
    dlgInAlpha.Release;
    dlgInAlpha := nil;
  end;

  SetLayerdPad(ID, Alpha, 255);
end;

// 半透明化
procedure SetLayerdPad(ID, Alpha, LastAlpha: Integer);
var
  LayerdPad: TLayerdPad;
  PadWnd, PadTabWnd: HWND;
begin
  PadWnd := SLAGetPadWnd(ID);
  PadTabWnd := SLAGetPadTabWnd(ID);

  if Alpha = 255 then
  begin
    SetWindowLong(PadWnd, GWL_EXSTYLE, GetWindowLong(PadWnd, GWL_EXSTYLE) and not WS_EX_LAYERED);
    SetWindowLong(PadTabWnd, GWL_EXSTYLE, GetWindowLong(PadTabWnd, GWL_EXSTYLE) and not WS_EX_LAYERED);
    Exit;
  end;

  LayerdPad := TLayerdPad.Create;
  LayerdPad.ID := ID;
  LayerdPad.Alpha := Alpha;
  LayerdPad.LastAlpha := LastAlpha;
  LayerdPad.NowAlpha := Alpha;
  LayerdPads.Add(LayerdPad);

  SetWindowLong(PadWnd, GWL_EXSTYLE, GetWindowLong(PadWnd, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetWindowLong(PadTabWnd, GWL_EXSTYLE, GetWindowLong(PadTabWnd, GWL_EXSTYLE) or WS_EX_LAYERED);
  MySetLayeredWindowAttributes(PadWnd, 0, Byte(Alpha), LWA_ALPHA);
  MySetLayeredWindowAttributes(PadTabWnd, 0, Byte(Alpha), LWA_ALPHA);
  DummyControl.Timer.Enabled := True;
end;

// タイマー
constructor TDummyControl.Create;
begin
  Timer := TTimer.Create(nil);
  Timer.Enabled := False;
  Timer.OnTimer := TimerTimer;
  Timer.Interval := 50;
end;

destructor TDummyControl.Destroy;
begin
  Timer.Free;
  inherited;
end;

procedure TDummyControl.TimerTimer(Sender: TObject);
var
  ID, Alpha, NowAlpha, LastAlpha: Integer;
  AlphaDiff: Integer;
  i: Integer;
  PadWnd, PadTabWnd: HWND;
  TimerEnabled: Boolean;
begin
//      OutputDebugString(PChar(IntToStr(ID) + ':' + IntToStr(NowAlpha)));

  TimerEnabled := False;
  for i := 0 to LayerdPads.Count - 1 do
  begin
    ID := TLayerdPad(LayerdPads[i]).ID;
    Alpha := TLayerdPad(LayerdPads[i]).Alpha;
    LastAlpha := TLayerdPad(LayerdPads[i]).LastAlpha;
    NowAlpha := TLayerdPad(LayerdPads[i]).NowAlpha;
    if NowAlpha < LastAlpha  then
    begin
      AlphaDiff := Abs(Alpha - LastAlpha) div 2 + 1;
      NowAlpha := NowAlpha + AlphaDiff;
      if NowAlpha > LastAlpha then
        NowAlpha := LastAlpha;
    end
    else
    if NowAlpha > LastAlpha  then
    begin
      AlphaDiff := Abs(NowAlpha - LastAlpha) div 10 + 1;
      NowAlpha := NowAlpha - AlphaDiff;
      if NowAlpha < LastAlpha then
        NowAlpha := LastAlpha;
    end;

    if NowAlpha <> TLayerdPad(LayerdPads[i]).NowAlpha then
    begin
      PadWnd := SLAGetPadWnd(ID);
      PadTabWnd := SLAGetPadTabWnd(ID);
      MySetLayeredWindowAttributes(PadWnd, 0, Byte(NowAlpha), LWA_ALPHA);
      MySetLayeredWindowAttributes(PadTabWnd, 0, Byte(NowAlpha), LWA_ALPHA);
      TLayerdPad(LayerdPads[i]).NowAlpha := NowAlpha;
    end;

    if NowAlpha <> LastAlpha then
    begin
      TimerEnabled := True;
    end;

  end;
  TTimer(Sender).Enabled := TimerEnabled;
end;

procedure Init;
begin
  LayerdPads := TList.Create;
  DummyControl := TDummyControl.Create;
end;

procedure Fin;
var
  i: Integer;
begin
  for i := 0 to LayerdPads.Count - 1 do
    TLayerdPad(LayerdPads[i]).Free;
  LayerdPads.Free;
  DummyControl.Free;
end;


initialization
  Init;
finalization
  Fin;
end.
