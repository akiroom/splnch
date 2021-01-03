unit PlugFunc;

interface

uses
  Windows, Messages, SysUtils, Graphics, IniFiles, SLAPI, Types;

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
// ボタンがパッドに作成される
function SLXButtonCreate(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
// ボタンがパッドから削除される
function SLXButtonDestroy(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
// ボタンが押されたときの処理
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// ボタンにファイルをドロップ
function SLXButtonDropFiles(No: Integer; hWnd: HWND; Files: PChar): BOOL; stdcall;
// ボタンを描画
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// ボタンを描画（hWnd と ButtonIndex 付き）
function SLXButtonDrawEx(No: Integer; hWnd: HWND; GroupIndex, ButtonIndex: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
// ボタンを更新
function SLXButtonUpdate(No: Integer): BOOL; stdcall;
// ボタンの独自チップ取得
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL; stdcall;
// ボタンの設定ダイアログを呼び出す
function SLXButtonOptions(No: Integer; hWnd: HWND): BOOL; stdcall;


// メニュー用関数 --------------------------------------------------------------

// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL; stdcall;
// メニューにチェックが付いてるかを返す
function SLXMenuCheck(No: Integer): BOOL; stdcall;

// スキン用関数
function SLXBeginSkin(hWnd: HWND): BOOL; stdcall;
function SLXDrawDragBar(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; Position: Integer; Caption: PChar): BOOL; stdcall;
function SLXDrawWorkspace(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; IsScrollBar: BOOL): BOOL; stdcall;
function SLXDrawButtonFace(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
function SLXDrawButtonFrame(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
function SLXDrawButtonIcon(hWnd: HWND; DC: HDC; ARect: PRect; NormalIcon: HICON; SmallIcon: HICON; State: Integer): BOOL; stdcall;
function SLXDrawButtonCaption(hWnd: HWND; DC: HDC; ARect: PRect; Caption: PChar; State: Integer): BOOL; stdcall;
function SLXDrawButtonMask(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;

// ボタンの状態
const
  BS_ENABLED = 1;
  BS_SELECTED = 2;
  BS_MOUSEENTERED = 4;
  BS_PADACTIVE = 8;
  BS_ISDRAWPLUGIN = 16;


  
// サンプル用定数 --------------------------------------------------------------
const
  // プラグインの名前
  PLUGIN_NAME = 'プラグインサンプル';
  // プラグインの説明
  PLUGIN_EXPRANATION =
      #13#10
    + 'プラグイン開発用サンプル' + #13#10
    + '________________________________________________' + #13#10
    + '                           Copyright(C)1996-2007' + #13#10
    + '              SAWADA Shigeru All rights reserved.' + #13#10
    + '                             制作・著作 : 沢田茂';

  // ボタン数
  DEFAULT_BUTTONCOUNT = 7;

  BUTTON_NORMAL = 0;
  BUTTON_CHIP = 1;
  BUTTON_NORMALDRAW = 2;
  BUTTON_SECDRAW = 3;
  BUTTON_PLUGINDRAW = 4;
  BUTTON_DRAWORDER = 5;
  BUTTON_POS = 6;

  // ボタン定義
  BUTTON_INFO: array[0..DEFAULT_BUTTONCOUNT-1] of TSLXButtonInfo =
  (
    // BUTTON_NORMAL
    (
      Name:           'ふつうのボタン';   // ボタン名
      IconIndex:      1;                  // 描画機能がない場合のアイコンインデックス
      OwnerDraw:      False;              // 描画機能がある=True
      UpdateInterval: 0;                  // データの更新までの間隔(×0.1秒)
      OwnerChip:      False;              // 独自チップ機能がある=True
    ),

    // BUTTON_CHIP
    (
      Name:           'チップが変わるボタン';
      IconIndex:      2;
      OwnerDraw:      False;
      UpdateInterval: 10;
      OwnerChip:      True;
    ),

    // BUTTON_NORMALDRAW
    (
      Name:           '普通に描画するボタン';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_SECDRAW
    (
      Name:           '1 秒に 1 回 SpLnch が再描画を指示するボタン';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 10;
      OwnerChip:      False;
    ),
    // BUTTON_PLUGINDRAW
    (
      Name:           'プラグインが再描画を指示するボタン';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_DRAWORDER
    (
      Name:           '再描画を指示するボタン';
      IconIndex:      0;
      OwnerDraw:      False;
      UpdateInterval: 0;
      OwnerChip:      False;
    ),
    // BUTTON_POS
    (
      Name:           'ボタンの座標を描画するボタン';
      IconIndex:      0;
      OwnerDraw:      True;
      UpdateInterval: 10;
      OwnerChip:      False;
    )

  );

  // ボタン定義
  ADD_BUTTON_INFO: TSLXButtonInfo =
  (
    Name:           '追加されたのボタン１';
    IconIndex:      0;
    OwnerDraw:      False;
    UpdateInterval: 0;
    OwnerChip:      False;              
  );


  // メニュー数
  DEFAULT_MENUCOUNT = 19;

  // メニュー定義
  MENU_INFO: array[0..DEFAULT_MENUCOUNT-1] of TSLXMenuInfo =
  (
    // 0
    (
      Name: 'サンプルプラグイン(&S)';     // メニュー名
      SCut: '';                           // ショートカットキー
    ),
    // 1
    (
      Name: 'チェックがつく(&1)';
      SCut: 'Ctrl+Alt+1';
    ),
    // 2
    (
      Name: '-';
      SCut: '';
    ),
    // 3
    (
      Name: 'すべてパッドのプロパティを取得(&2)';
      SCut: 'Ctrl+Alt+2';
    ),
    // 4
    (
      Name: 'パッドをエクスプローラの「小さいアイコン」のように変更する(&3)';
      SCut: 'Ctrl+Alt+3';
    ),
    // 5
    (
      Name: '次のボタングループに切り替える';
      SCut: '';
    ),
    // 6
    (
      Name: 'プラグインボタンの情報を取得しなおして種類を 1 つ増やす';
      SCut: '';
    ),
    // 7
    (
      Name: 'プラグインメニューの情報を取得しなおして種類を 1 つ増やす';
      SCut: '';
    ),
    // 8
    (
      Name: 'すべてのボタン情報を取得する';
      SCut: '';
    ),
    // 9
    (
      Name: 'ボタングループを挿入する';
      SCut: '';
    ),
    // 10
    (
      Name: 'ボタングループの名前を変更する';
      SCut: '';
    ),
    // 11
    (
      Name: 'ボタングループを複製する';
      SCut: '';
    ),
    // 12
    (
      Name: 'ボタングループを削除する';
      SCut: '';
    ),
    // 13
    (
      Name: 'ボタンを追加する';
      SCut: '';
    ),
    // 14
    (
      Name: 'ボタンを変更する';
      SCut: '';
    ),
    // 15
    (
      Name: 'ボタンを削除する';
      SCut: '';
    ),
    // 16
    (
      Name: 'ボタンをコピーする';
      SCut: '';
    ),
    // 17
    (
      Name: 'ボタンを貼り付ける';
      SCut: '';
    ),
    // 18
    (
      Name: 'メモ帳とペイントを実行';
      SCut: '';
    )
  );


  // 追加用メニュー定義
  ADD_MENU_INFO: TSLXMenuInfo =
  (
    Name: '追加されたメニュー(&A)';   // メニュー名
    SCut: '';                         // ショートカットキー
  );


// サンプル用変数 --------------------------------------------------------------
var
  InitFileName: string; // 設定ファイル名
  MenuChecked: BOOL; // メニューのチェック状態
  ButtonCount: Integer = DEFAULT_BUTTONCOUNT; // ボタンの数
  MenuCount: Integer = DEFAULT_MENUCOUNT; // メニューの数


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
    MenuChecked := Ini.ReadBool('Menu', 'Checked', False);
  finally
    Ini.Free;
  end;
  Randomize;
  Result := True;
end;

// プラグインを終了
function SLXEndPlugin: BOOL;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.ReadBool('Menu', 'Checked', MenuChecked);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
  Result := True;
end;

// 設定ダイアログを呼び出す
function SLXChangeOptions(hWnd: HWND): BOOL;
begin
  Result := MessageBox(hWnd, '設定したつもりになる？',
    '確認', MB_ICONQUESTION or MB_YESNO) = idYes;
end;

// ボタンの情報(PSLXButtonInfo)を次々に返す
function SLXGetButton(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL;
begin
  Result := False;
  if No >= 0 then
  begin
    if No < DEFAULT_BUTTONCOUNT then
    begin
      Result := True;
      ButtonInfo^ := BUTTON_INFO[NO];
    end
    else if No < ButtonCount then
    begin
      Result := True;
      ButtonInfo^ := ADD_BUTTON_INFO;
    end;
  end;
end;

// ボタンがパッドに作成される
function SLXButtonCreate(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL;
begin
  Result := True;
  Windows.Beep(660, 50);
  Windows.Beep(880, 50);
end;

// ボタンがパッドから削除される
function SLXButtonDestroy(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL;
begin
  Result := True;
  Windows.Beep(880, 50);
  Windows.Beep(660, 50);
end;

// ボタンが押されたときの処理
function SLXButtonClick(No: Integer; hWnd: HWND): BOOL;
begin
  Result := True;

  if ExistsSLAPI and (No = BUTTON_DRAWORDER) then
  begin
    if not SLARedrawPluginButtons(PLUGIN_NAME, 4) then
      MessageBox(hWnd, '更新できません。', '確認', MB_ICONINFORMATION);
  end;

end;

// ボタンにファイルをドロップ
function SLXButtonDropFiles(No: Integer; hWnd: HWND; Files: PChar): BOOL;
var
  Msg: string;
begin
  Result := True;
  Msg := Files + 'をドロップした。';
  MessageBox(hWnd, PChar(Msg), 'ボタン', MB_ICONINFORMATION);
end;


// ボタンを描画
function SLXButtonDraw(No: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
begin
  Result := False;

  case No of
    BUTTON_NORMALDRAW, BUTTON_PLUGINDRAW, BUTTON_SECDRAW:
    begin
      Result := True;
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(ARect^.Left, ARect^.Top, IntToStr(Random(1000)));
      Canvas.Free;
    end;
  end;
end;

function SLXButtonDrawEx(No: Integer; hWnd: HWND; GroupIndex, ButtonIndex: Integer; DC: HDC; ARect: PRect): BOOL;
var
  Canvas: TCanvas;
  ID: Integer;
  SLAButton: TSLAButton;
  Msg: String;
begin
  Result := False;
  if not ExistsSLAPI then
    Exit;

  case No of
    BUTTON_POS:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      SLAGetButton(ID, GroupIndex, ButtonIndex, @SLAButton);
      Canvas := TCanvas.Create;
      Canvas.Handle := DC;
      Canvas.Brush.Style := bsClear;
      Msg := 'X:' + IntToStr(SLAButton.ScreenRect.Left) + #13#10 +
             'Y:' + IntToStr(SLAButton.ScreenRect.Top) + #13#10 +
             'W:' + IntToStr(SLAButton.ScreenRect.Right - SLAButton.ScreenRect.Left) + #13#10 +
             'H:' + IntToStr(SLAButton.ScreenRect.Bottom - SLAButton.ScreenRect.Top);
      DrawText(Canvas.Handle, PChar(Msg), Length(Msg), ARect^, 0);
      Canvas.Free;
    end;
  end;

end;

// ボタンを更新
function SLXButtonUpdate(No: Integer): BOOL;
begin
  // True を返すとそのボタンの再描画が起きる
  Result := True;
end;

// ボタンの独自チップ取得
function SLXButtonChip(No: Integer; Value: PChar; Size: Word): BOOL;
var
  S: String;
begin
  Result := True;
  s := '';
  case Random(3) of
    0: S := '毎回違う';
    1: S := 'チップが';
    2: S := '表示される';
  end;
  StrPCopy(Value, Copy(S, 1, Size - 1));
end;


// ボタンの設定ダイアログを呼び出す
function SLXButtonOptions(No: Integer; hWnd: HWND): BOOL; stdcall;
var
  S: String;
begin
  Result := True;
  s := IntToStr(No) + ' のボタンの設定';
  MessageBox(hWnd, PChar(s), '確認', MB_ICONINFORMATION);
end;





// メニューの情報(PSLXMenuInfo)を次々に返す
function SLXGetMenu(No: Integer; MenuInfo: PSLXMenuInfo): BOOL;
begin
  Result := False;
  if No >= 0 then
  begin
    if No < DEFAULT_MENUCOUNT then
    begin
      Result := True;
      MenuInfo^ := MENU_INFO[NO];
    end
    else if No < MenuCount then
    begin
      Result := True;
      MenuInfo^ := ADD_MENU_INFO;
    end;
  end;
end;

// メニューが選択されたときの処理
function SLXMenuClick(No: Integer; hWnd: HWND): BOOL;
var
  Msg: string;
  ID: Integer;
  Count: Integer;
  i, j: Integer;
  mr: Integer;
  SLAGroup: TSLAGroup;
  SLAButton: TSLAButton;
  Buf: array[0..1023] of Char;
begin
  Result := False;
  if not ExistsSLAPI then
  begin
    MessageBox(hWnd, 'SLAPI が見つかりません。', '確認', MB_ICONINFORMATION);
    Exit;
  end;


  case No of
    0:
    begin
      Result := True;
    end;
    1:
    begin
      Result := True;
      MenuChecked := not MenuChecked;
    end;
    3:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      Count := SLAGetPadCount;

      for i := 0 to Count - 1 do
      begin
        Msg := 'パッドの数 : ' + IntToStr(SLAGetPadCount) + #13#10;
        Msg := Msg + 'ID : ' + IntToStr(ID) + #13#10;
        Msg := Msg + 'ウィンドウハンドル : ' + IntToStr(SLAGetPadWnd(ID)) + #13#10;
        Msg := Msg + '隠れてるときのウィンドウハンドル : ' + IntToStr(SLAGetPadTabWnd(ID)) + #13#10;
        if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
          Msg := Msg + 'グループインデックス : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'TopLineIndex', Buf, 1024) then
          Msg := Msg + '一番上の行番号 : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
          Msg := Msg + 'カレントボタンのインデックス : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Left', Buf, 1024) then
          Msg := Msg + '左端座標 : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Top', Buf, 1024) then
          Msg := Msg + '上端座標 : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Cols', Buf, 1024) then
          Msg := Msg + '列数 : ' + Buf + #13#10;
        if SLAGetPadInit(ID, 'Rows', Buf, 1024) then
          Msg := Msg + '行数 : ' + Buf + #13#10;
        Msg := Msg + '  ... などなどなど ...';

        if MessageBox(hWnd, PChar(Msg), '確認', MB_OKCANCEL) = idCancel then
          Break;
        ID := SLAGetNextPadID(ID);
      end;

    end;
    4:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);

// ディレイが入ってますが、動作がわかるようにしてあるだけですので、
// 無くても大丈夫です。      
      Result := Result and SLASetPadInit(ID, 'BtnSmallIcon', '1');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnSquare', '0');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnWidth', '100');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'BtnHeight', '16');
      Sleep(500);
      StrPCopy(Buf, IntToStr(CP_RIGHT));
      Result := Result and SLASetPadInit(ID, 'BtnCaption', Buf);
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'Cols', '2');
      Sleep(500);
      Result := Result and SLASetPadInit(ID, 'Rows', '15');
      Sleep(500);

      if Result then
        MessageBox(hWnd, '変更しました。', '確認', MB_ICONINFORMATION)
      else
        MessageBox(hWnd, '変更できませんでした。', '確認', MB_ICONINFORMATION);

    end;
    5:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);

      Count := SLAGetGroupCount(ID);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf) + 1;
        if i >= Count then
          i := 0;
        StrPCopy(Buf, IntToStr(i));
        if SLASetPadInit(ID, 'GroupIndex', Buf) then
          Result := True;
      end;
    end;
    6:
    begin
      Result := True;
      Inc(ButtonCount);
      SLAChangePluginButtons(PLUGIN_NAME);
    end;
    7:
    begin
      Result := True;
      Inc(MenuCount);
      SLAChangePluginMenus(PLUGIN_NAME);
    end;
    8:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);

      Count := SLAGetGroupCount(ID);
      mr := idOk;
      for i := 0 to Count - 1 do
      begin
        SLAGetGroup(ID, i, @SLAGroup);
        for j := 0 to SLAGroup.ButtonCount - 1 do
        begin
          SLAGetButton(ID, i, j, @SLAButton);
          Msg := 'ボタングループの数 : ' + IntToStr(Count) + #13#10;
          Msg := Msg + 'ボタングループのインデックス : ' + IntToStr(i) + #13#10;
          Msg := Msg + 'ボタングループ名 : ' + SLAGroup.Name + #13#10;
          Msg := Msg + 'ボタンの数 : ' + IntToStr(SLAGroup.ButtonCount) + #13#10;
          Msg := Msg + 'ボタンのインデックス : ' + IntToStr(j) + #13#10;
          case SLAButton.Kind of
            BK_SPACE:
            begin
              Msg := Msg + 'ボタンの種類 : 空白' + #13#10;
            end;
            BK_RETURN:
            begin
              Msg := Msg + 'ボタンの種類 : 改行' + #13#10;
            end;
            BK_NORMAL:
            begin
              Msg := Msg + 'ボタンの種類 : ノーマル' + #13#10;
              Msg := Msg + 'ボタン名 : ' + SLAButton.Name + #13#10;
              Msg := Msg + 'クリック回数 : ' + IntToStr(SLAButton.ClickCount) + #13#10;
              Msg := Msg + 'リンク先のファイル名 : ' + SLAButton.FileName + #13#10;
              Msg := Msg + 'リンク先のPIDL : ' + IntToHex(Word(SLAButton.ItemIDList), 8) + #13#10;
              Msg := Msg + '実行時引数 : ' + SLAButton.Option + #13#10;
              Msg := Msg + '作業用フォルダ : ' + SLAButton.Folder + #13#10;
              Msg := Msg + '実行時の大きさ : ' + IntToStr(SLAButton.WindowSize) + #13#10;
              Msg := Msg + 'アイコンファイル : ' + SLAButton.IconFile + #13#10;
              Msg := Msg + 'アイコンのインデックス : ' + IntToStr(SLAButton.IconIndex) + #13#10;
            end;
            BK_PLUGIN:
            begin
              Msg := Msg + 'ボタンの種類 : プラグイン' + #13#10;
              Msg := Msg + 'ボタン名 : ' + SLAButton.Name + #13#10;
              Msg := Msg + 'クリック回数 : ' + IntToStr(SLAButton.ClickCount) + #13#10;
              Msg := Msg + 'プラグイン名 : ' + SLAButton.PluginName + #13#10;
              Msg := Msg + 'プラグインのボタン番号 : ' + IntToStr(SLAButton.PluginNo) + #13#10;
            end;

          end;
          mr := MessageBox(hWnd, PChar(Msg), '確認', MB_OKCANCEL);
          if mr = idCancel then
            Break;
        end;
        if mr = idCancel then
          Break;
      end;
    end;
    9:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);

      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLAInsertGroup(ID, i, '挿入したボタングループ');
      end;
    end;
    10:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLARenameGroup(ID, i, '名前が変更されたボタングループ');
      end;

    end;
    11:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLACopyGroup(ID, i, 0);
      end;
    end;
    12:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        Result := True;
        i := StrToInt(Buf);
        SLADeleteGroup(ID, i);
      end;
    end;
    13:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '追加されたボタン';
          SLAButton.Kind := BK_NORMAL;
          SLAButton.Filename := 'Explorer.exe';
          SLAInsertButton(ID, i, j, @SLAButton);

          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '追加されたボタン';
          SLAButton.Kind := BK_PLUGIN;
          SLAButton.PluginName := PLUGIN_NAME;
          SLAButton.PluginNo := 1;
          SLAInsertButton(ID, i, j, @SLAButton);
        end;
      end;

    end;
    14:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
{          FillChar(SLAButton, SizeOf(SLAButton), 0);
          SLAButton.Name := '変更されたボタン';
          SLAButton.Kind := BK_PLUGIN;
          SLAButton.PluginName := PLUGIN_NAME;
          SLAButton.PluginNo := 1;
          SLAChangeButton(ID, i, j, @SLAButton);}
          SLAGetButton(ID, i, j, @SLAButton);
          SLAButton.IconFile := '';
          SLAChangeButton(ID, i, j, @SLAButton);
        end;
      end;

    end;
    15:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          SLADeleteButton(ID, i, j);
        end;
      end;
    end;
    16:
    begin
      Result := False;
      ID := SLAGetPadID(hWnd);
      if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
      begin
        i := StrToInt(Buf);
        if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
        begin
          j := StrToInt(Buf);

          Result := True;
          SLACopyButton(ID, i, j);
        end;
      end;

    end;
    17:
    begin
      Result := False;
      if SLAButtonInClipbord then
      begin
        ID := SLAGetPadID(hWnd);
        if SLAGetPadInit(ID, 'GroupIndex', Buf, 1024) then
        begin
          i := StrToInt(Buf);
          if SLAGetPadInit(ID, 'ButtonIndex', Buf, 1024) then
          begin
            j := StrToInt(Buf);

            Result := True;
            SLAPasteButton(ID, i, j);
          end;
        end;
      end
      else
      begin
        MessageBox(hWnd, 'クリップボードには貼り付けられるデータがありません。', '確認', MB_ICONINFORMATION);
      end;
    end;
    18:
    begin
      Result := True;
      ID := SLAGetPadID(hWnd);
      FillChar(SLAButton, SizeOf(SLAButton), 0);
      SLAButton.Kind := BK_NORMAL;
      SLAButton.FileName := 'notepad.exe';
      SLARunButton(ID, @SLAButton);
      SLAButton.FileName := 'mspaint.exe';
      SLARunButton(ID, @SLAButton);
    end;
  else
    if (No >= DEFAULT_MENUCOUNT) and (No < MenuCount) then
    begin
      Result := True;
      MessageBox(hWnd, '追加されたメニューを選択しました。', '確認', MB_ICONINFORMATION);
    end
    else
    begin
      Result := False;
    end;
  end;
end;

// メニューにチェックが付いてるかを返す
function SLXMenuCheck(No: Integer): BOOL;
begin
  case No of
    1:
      Result := MenuChecked;
  else
    Result := False;
  end;
end;

// 狭いテキストを指定の方向に描画
procedure RotateTextOut(Canvas: TCanvas; ARect: TRect; Position: Integer; const Text: String);
var
  ComS, S: string;
  LastChar: string;
  MaxWidth: Integer;
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
  X, Y: Integer;
begin
  GetObject(Canvas.Font.Handle, SizeOf(LogFont), @LogFont);

  case Position of
    DS_TOP, DS_BOTTOM:
    begin
      LogFont.lfEscapement := 0;
      MaxWidth := ARect.Right - ARect.Left;
      X := ARect.Left;
      Y := ARect.Top;
    end;

    DS_LEFT:
    begin
      LogFont.lfEscapement := 900;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Left;
      Y := ARect.Bottom - 1;
    end;

    DS_RIGHT:
    begin
      LogFont.lfEscapement := 2700;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Right;
      Y := ARect.Top;
    end;

    else
      Exit;
  end;

  ComS := Text;
  S := Text;
  while Canvas.TextWidth(ComS) > MaxWidth do
  begin
    LastChar := StrPas(AnsiLastChar(S));
    if LastChar = S then
      Break;

    S := Copy(S, 1, Length(S) - Length(LastChar));
    ComS := S + '...';
  end;

  NewFont := CreateFontIndirect(LogFont);
  try
    OldFont := SelectObject(Canvas.Handle, NewFont);
    TextOut(Canvas.Handle, x, y, PChar(ComS), Length(ComS));
    NewFont := SelectObject(Canvas.Handle, OldFont);
  finally
    DeleteObject(NewFont);
  end;
end;


// スキン用関数
function SLXBeginSkin(hWnd: HWND): BOOL;
//var
//  ID: Integer;
begin
// Beep;
//  ID := SLAGetPadID(hWnd);
//  SLASetPadInit(ID, 'DragBarSize', '50');
  Result := True;
end;

function SLXDrawDragBar(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; Position: Integer; Caption: PChar): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    if Foreground then
    begin
      Canvas.Brush.Color := clGray;
      Canvas.Font.Color := clWhite;
    end
    else
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.Font.Color := clSilver;
    end;
    Canvas.FillRect(ARect^);
    RotateTextOut(Canvas, ARect^, Position, Caption);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawWorkspace(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; IsScrollBar: BOOL): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    if Foreground then
      Canvas.Brush.Color := clGray
    else
      Canvas.Brush.Color := clSilver;
    Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonFace(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Inc(ARect^.Left);
    Inc(ARect^.Top);
    Canvas.Handle := DC;
    Canvas.Pen.Style := psClear;
    Canvas.Brush.Color := clWhite;
    Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonFrame(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  if (State and BS_MOUSEENTERED) <> 0 then
  begin
    Canvas := TCanvas.Create;
    try
      Inc(ARect^.Left);
      Inc(ARect^.Top);
      Canvas.Handle := DC;
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Style := bsClear;
      Canvas.RoundRect(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom, 10, 10);
    finally
      Canvas.Free;
    end;
  end;
end;

function SLXDrawButtonIcon(hWnd: HWND; DC: HDC; ARect: PRect; NormalIcon: HICON; SmallIcon: HICON; State: Integer): BOOL;
begin
  Result := True;
  DrawIconEx(DC, ARect^.Top + 5, ARect^.Left + 5, SmallIcon, 16, 16, 0, 0, DI_NORMAL);
end;

function SLXDrawButtonCaption(hWnd: HWND; DC: HDC; ARect: PRect; Caption: PChar; State: Integer): BOOL;
var
  Canvas: TCanvas;
begin
  Result := True;
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DC;
    Canvas.Brush.Style := bsClear;
    if ((State and BS_PADACTIVE) <> 0) or ((State and BS_MOUSEENTERED) <> 0) then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clSilver;
    Canvas.TextOut(ARect^.Left + 3, ARect^.Top + 22, Caption);
  finally
    Canvas.Free;
  end;
end;

function SLXDrawButtonMask(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL;
var
  Canvas: TCanvas;
  y: Integer;
begin
  Result := True;
  if ((State and BS_SELECTED) <> 0) and ((State and BS_PADACTIVE) <> 0) and ((State and BS_ISDRAWPLUGIN) = 0) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      Canvas.Pen.Color := clRed;
      y := ARect^.Top + 22 + Canvas.TextHeight('a');
      Canvas.MoveTo(ARect^.Left + 3, y);
      Canvas.LineTo(ARect^.Right - 2, y);
    finally
      Canvas.Free;
    end;
  end;
end;

end.
