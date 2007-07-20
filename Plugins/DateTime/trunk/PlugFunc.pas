unit PlugFunc;

interface

uses
  Windows, SysUtils, Graphics, IniFiles, Option, PlugBtns, Cal, Memo, Forms;

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
// ボタンを描画
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// ボタンを更新
function SLXButtonUpdate(No: Integer): BOOL; stdcall;
// ボタンの独自チップ取得
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL; stdcall;

// メニュー用関数 --------------------------------------------------------------

// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// メニューにチェックが付いてるかを返す
function SLXMenuCheck(No: Integer): BOOL; stdcall;


const
  // プラグインの名前
  PLUGIN_NAME = 'カレンダーと時計';
  // プラグインの説明
  PLUGIN_EXPRANATION =
      #13#10
    + 'カレンダーと時計プラグイン' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1996-2002' + #13#10
    + '              SAWADA Shigeru All rights reserved.' + #13#10
    + '                             制作・著作 : 沢田茂';

  // ボタン数
  BUTTON_COUNT = 2;

  // ボタン定義
  BUTTON_INFO: array[0..BUTTON_COUNT-1] of TSLXButtonInfo =
  (
    (
      Name:           'カレンダー';       // ボタン名
      IconIndex:      0;                  // 描画機能がない場合のアイコンインデックス
      OwnerDraw:      True;               // 描画機能がある=True
      UpdateInterval: 50;                 // データの更新までの間隔(×0.1秒)
      OwnerChip:      True;               // 独自チップ機能がある=True
    ),
    (
      Name:           '時計';             // ボタン名
      IconIndex:      0;                  // 描画機能がない場合のアイコンインデックス
      OwnerDraw:      True;               // 描画機能がある=True
      UpdateInterval: 10;                 // データの更新までの間隔(×0.1秒)
      OwnerChip:      True;               // 独自チップ機能がある=True
    )
  );


  // メニュー数
  MENU_COUNT = 1;

  // メニュー定義
  MENU_INFO: array[0..MENU_COUNT-1] of TSLXMenuInfo =
  (
    (
      Name: 'カレンダー(&L)';     // ボタン名
      SCut: 'Ctrl+L';                   // ショートカットキー
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
  DataFileName := ChangeFileExt(InitFileName, '.dat');
end;

// プラグインを開始
function SLXBeginPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    if Ini.ReadBool('Calendar', 'Visible', False) then
    begin
      if frmCal = nil then
        frmCal := TfrmCal.Create(nil);
      frmCal.Show;
    end;

    ADigital := Ini.ReadBool('Watch', 'Digital', False);

  finally
    Ini.Free;
  end;

  UpdateDayInfo(True);
  UpdateTimeInfo;
  Result := True;
end;

// プラグインを終了
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.WriteBool('Calendar', 'Visible', frmCal <> nil);
    Ini.WriteBool('Watch', 'Digital', ADigital);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;

  if frmCal <> nil then
    frmCal.Close;

  Result := frmCal = nil;
end;

// 設定ダイアログを呼び出す
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  dlgOption := TdlgOption.CreateOwnedForm(nil, hWnd);
  try
    Result := dlgOption.ShowModal = idOk;
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
begin
  case No of
    0:
    begin
      if frmCal = nil then
      begin
        frmCal := TfrmCal.Create(nil);
        frmCal.Show;
      end
      else
        frmCal.Close;
      Result := True;
    end;
    1:
    begin
      ADigital := not ADigital;
      Result := True;
    end;
  else
    Result := False;
  end;
end;



// ボタンを描画
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
begin
  case No of
    0:
    begin
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      DrawDate(Canvas, ARect^);
      Canvas.Free;
      Result := True;
    end;
    1:
    begin
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      DrawWatch(Canvas, ARect^);
      Canvas.Free;
      Result := True;
    end;
  else
    Result := False;
  end;
end;

// ボタンを更新
function SLXButtonUpdate(No: Integer): BOOL;
begin
  Result := False;
  case No of
    0:
    begin
      Result := UpdateDayInfo(False);
    end;
    1:
    begin
      Result := UpdateTimeInfo;
    end;
  end;
end;

// ボタンの独自チップ取得
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL;
var
  S: String;
begin
  case No of
    0:
    begin
      S := ChipStr;
      StrPCopy(Value, Copy(S, 1, Size - 1));
      Result := True;
    end;
    1:
    begin
      S := FormatDateTime('tt', Now);
      StrPCopy(Value, Copy(S, 1, Size - 1));
      Result := True;
    end;

  else
    Result := False;
  end;
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
begin
  case No of
    0:
    begin
      if frmCal = nil then
      begin
        frmCal := TfrmCal.Create(nil);
        frmCal.Show;
      end
      else
        frmCal.Close;
      Result := True;
    end;
  else
    Result := False;
  end;
end;

// メニューにチェックが付いてるかを返す
function SLXMenuCheck(No: Integer): BOOL;
begin
  case No of
    0:
      Result := frmCal <> nil;
  else
    Result := False;
  end;
end;



end.
