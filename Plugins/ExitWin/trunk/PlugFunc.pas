unit PlugFunc;

interface

uses
  Windows, SysUtils, IniFiles, Confirm, Option;

// 構造体 ----------------------------------------------------------------------
type

  // ボタンの情報
  PSLXButtonInfo = ^TSLXButtonInfo;
  TSLXButtonInfo = packed record
    Name: array[0..63] of Char; // ボタン名
    IconIndex: Integer;         // 描画機能がない場合のアイコンインデックス
    OwnerDraw: BOOL;            // 描画機能がある=True
    UpdateInterval: Integer;    // データの更新までの間隔(×0.1秒)
    OwnerChip: BOOL;            // 独自チップ機能がある=True
  end;

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


// ボタン用関数 ----------------------------------------------------------------

// ボタンの情報(PSLXButtonInfo)を次々に返す
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL; stdcall;
// ボタンが押されたときの処理
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL; stdcall;

// メニュー用関数 --------------------------------------------------------------

// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;



// サンプル用定数 --------------------------------------------------------------
const
  // プラグインの名前
  PLUGIN_NAME = 'Exit Windows Plugin.';
  // プラグインの説明
  PLUGIN_EXPRANATION =
      #13#10
    + 'Windows の終了プラグイン' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1995-2007' + #13#10
    + '             Special Launch Open Source Project.';

  // ボタンの数
  BUTTON_COUNT = 5;
  // ボタン定義
  BUTTON_INFO: array[0..BUTTON_COUNT-1] of TSLXButtonInfo =
  (
    (
      Name:           'シャットダウン';   
      IconIndex:      1;                  
      OwnerDraw:      False;              
      UpdateInterval: 0;                  
      OwnerChip:      False;
    ),
    (
      Name:           '再起動';
      IconIndex:      2;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           'ログオフ';
      IconIndex:      3;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           'サスペンド';
      IconIndex:      4;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    (
      Name:           '休止状態';
      IconIndex:      5;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    )
  );

  // メニューの数
  MENU_COUNT = 8;
  // メニュー定義
  MENU_INFO: array[0..MENU_COUNT-1] of TSLXMenuInfo =
  (
    (
      Name: 'Windows の終了(&W)';
      SCut: '';
    ),
    (
      Name: 'シャットダウン(&D)';
      SCut: 'Ctrl+Alt+J';
    ),
    (
      Name: '再起動(&R)';
      SCut: 'Ctrl+Alt+K';
    ),
    (
      Name: '-';
      SCut: '';
    ),
    (
      Name: 'サスペンド(&S)';
      SCut: 'Ctrl+Alt+U';
    ),
    (
      Name: '休止状態(&H)';
      SCut: 'Ctrl+Alt+M';
    ),
    (
      Name: '-';
      SCut: '';
    ),
    (
      Name: 'ログオフ(&F)';
      SCut: 'Ctrl+Alt+L';
    )
  );


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
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    ExitDelay := Ini.ReadInteger('Exit Windows', 'ExitDelay', 5);
    PowerOff := Ini.ReadBool('Exit Windows', 'PowerOff', False);
  finally
    Ini.Free;
  end;
  Result := True;
end;

// プラグインを終了
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.WriteInteger('Exit Windows', 'ExitDelay', ExitDelay);
    Ini.WriteBool('Exit Windows', 'PowerOff', PowerOff);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
  Result := True;
end;

// 設定ダイアログを呼び出す
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  dlgOption := TdlgOption.Create(nil);
  try
    dlgOption.udExitDelay.Position := ExitDelay;
    dlgOption.rdoPowerOff.Checked := PowerOff;
    Result := dlgOption.ShowModal = idOk;
    if Result then
    begin
      ExitDelay := dlgOption.udExitDelay.Position;
      PowerOff := dlgOption.rdoPowerOff.Checked;
    end;
  finally
    dlgOption.Release;
  end;
end;

// ボタンの情報(PSLXButtonInfo)を次々に返す
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL;
begin
  case No of
    0..BUTTON_COUNT-1:
    begin
      Result := True;
      ButtonInfo^ := BUTTON_INFO[NO];
    end;
  else
    Result := False;
  end;
end;

// ボタンが押されたときの処理
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL;
var
  ExitKind: TExitKind;
begin
  Result := frmConfirm = nil;
  ExitKind := ekShutdown;
  case No of
    0: ExitKind := ekShutdown;
    1: ExitKind := ekReboot;
    2: ExitKind := ekLogoff;
    3: ExitKind := ekSuspend;
    4: ExitKind := ekHibernation;
  else
    Result := False;
  end;

  if Result then
    RunExitWindows(ExitKind, ExitDelay);
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

// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL;
var
  ExitKind: TExitKind;
begin
  Result := frmConfirm = nil;
  ExitKind := ekShutdown;
  case No of
    1: ExitKind := ekShutdown;
    2: ExitKind := ekReboot;
    4: ExitKind := ekSuspend;
    5: ExitKind := ekHibernation;
    7: ExitKind := ekLogoff;
  else
    Result := False;
  end;

  if Result then
    RunExitWindows(ExitKind, ExitDelay);
end;

end.
