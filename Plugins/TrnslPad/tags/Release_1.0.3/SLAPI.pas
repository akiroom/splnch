unit SLAPI;

interface

uses
  Windows, ShlObj;

var
  ExistsSLAPI: Boolean;

const
  // PadX.ini の DragBar の値
  DS_NONE = 0; // 表示しない
  DS_LEFT = 1; // 左
  DS_TOP = 2; // 上
  DS_RIGHT = 3; // 右
  DS_BOTTOM = 4; // 下

  // PadX.ini の DropAction の値
  DA_ADDHERE = 0; // ドロップした場所に追加
  DA_ADDLAST = 1; // 最後に追加
  DA_OPENHERE = 2; // ドロップ先のボタンで開く
  DA_COPYNAME = 3; // ファイル名をコピー

  // PadX.ini の BtnCaption の値
  CA_COMLINE = 0; // 指定して実行を開く
  CA_BTNEDIT = 1; // ボタンの編集を開く
  CA_GRPCHANGE = 2; // ボタングループ変更メニューを開く
  CA_NEXTGROUP = 3; // 次のボタングループへ移動する
  CA_PADPRO = 4; // パッドの設定を開く
  CA_OPTION = 5; // 全体の設定を開く
  CA_HIDE = 6; // パッドを隠す

  // PadX.ini の BtnCaption の値
  CP_NONE = 0; // ボタン名を表示しない
  CP_BOTTOM = 1; // アイコンの下
  CP_RIGHT = 2; // アイコンの右

type
  // ボタングループの情報
  PSLAGroup = ^TSLAGroup;
  TSLAGroup = packed record
    PadID: Integer; // 所属するパッドのID
    GroupIndex: Integer; // グループのインデックス
    Name: array[0..1023] of Char; // ボタングループ名
    ButtonCount: Integer; // ボタンの数
  end;

const
  // TSLAButton の Kind の値
  BK_SPACE = 0;
  BK_RETURN = 1;
  BK_NORMAL = 2;
  BK_PLUGIN = 3;

  // TSLAButton の WindowSize の値
  BW_NORMAL = 0;
  BW_MINIMIZED = 1;
  BW_MAXMIZED = 2;

type
  // ボタンの情報
  PSLAButton = ^TSLAButton;
  TSLAButton = packed record
    PadID: Integer; // 所属するパッドのID（読み取りのみ）
    GroupIndex: Integer; // グループのインデックス（読み取りのみ）
    ButtonIndex: Integer; // ボタンのインデックス（読み取りのみ）

    ScreenRect: TRect; // 画面上での座標（読み取りのみ）

    Name: array[0..1023] of Char; // ボタン名
    ClickCount: Integer; // クリック回数
    Kind: Integer; // ボタンの種類

    FileName: array[0..1023] of Char; // リンク先のファイル名
    ItemIDList: PItemIDList; // リンク先のPIDL
    Option: array[0..1023] of Char; // 実行時引数
    Folder: array[0..1023] of Char; // 作業用フォルダ
    WindowSize: Integer; // 実行時の大きさ
    IconFile: array[0..1023] of Char; // アイコンファイル
    IconIndex: Integer; // アイコンのインデックス

    PluginName: array[0..1023] of Char; // プラグインの名前
    PluginNo: Integer; // プラグインボタンの番号
  end;

const
  // SLAGetIcon の FileType の値
  FT_ICONPATH = 0; // アイコンが含まれるファイルへのパス
  FT_FILEPATH = 1; // 通常のファイルへのパス
  FT_PIDL = 2; // PIDL

var
  // パッドの数を取得する
  SLAGetPadCount: function: Integer; stdcall;
  // hWnd から PadID を取得する
  SLAGetPadID: function(hWnd: HWND): Integer; stdcall;
  // PadID から次の PadID を取得する
  SLAGetNextPadID: function(ID: Integer): Integer; stdcall;
  // PadID からパッドのウィンドウハンドルを取得する
  SLAGetPadWnd: function(ID: Integer): HWND; stdcall;
  // PadID からパッドの隠れている時のウィンドウハンドルを取得する
  SLAGetPadTabWnd: function(ID: Integer): HWND; stdcall;
  // パッドのプロパティを 1 つ取得
  SLAGetPadInit: function(ID: Integer; Key: PChar; Buf: PChar; BufSize: Integer): BOOL; stdcall;
  // パッドのプロパティを 1 つセット
  SLASetPadInit: function(ID: Integer; Key: PChar; Item: PChar): BOOL; stdcall;

  // プラグインボタンを再度取得する
  SLAChangePluginButtons: function(Name: PChar): BOOL; stdcall;
  // プラグインメニューを再度取得する
  SLAChangePluginMenus: function(Name: PChar): BOOL; stdcall;
  // プラグインボタンを再描画する
  SLARedrawPluginButtons: function(Name: PChar; No: Integer): BOOL; stdcall;

  // ボタングループの数を取得する
  SLAGetGroupCount: function(ID: Integer): Integer; stdcall;
  // ボタングループの情報を取得する
  SLAGetGroup: function(ID, GroupIndex: Integer; Group: PSLAGroup): BOOL; stdcall;
  // ボタングループを挿入する
  SLAInsertGroup: function(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
  // ボタングループの名前を変更する
  SLARenameGroup: function(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
  // ボタングループを複製する
  SLACopyGroup: function(ID, GroupIndex, NewIndex: Integer): BOOL; stdcall;
  // ボタングループを削除する
  SLADeleteGroup: function(ID, GroupIndex: Integer): BOOL; stdcall;

  // ボタンの情報を取得する
  SLAGetButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // ボタンを挿入する
  SLAInsertButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // ボタンを変更する
  SLAChangeButton: function(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
  // ボタンを削除する
  SLADeleteButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // ボタンをクリップボードにコピーする
  SLACopyButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // ボタンをクリップボードから貼り付ける
  SLAPasteButton: function(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
  // クリップボードにボタンで貼り付けられるデータがあるかを返す
  SLAButtonInClipbord: function: BOOL; stdcall;
  // ボタンデータを実行する
  SLARunButton: function (ID: Integer; Button: PSLAButton): BOOL; stdcall;

  // アイコンを取得する
  SLAGetIcon: function(FilePoint: Pointer; FileType, IconIndex: Integer; SmallIcon, UseCache: BOOL): HIcon; stdcall;

var
  InstSpLnch: THandle;

implementation

procedure InitAPI;
begin
  InstSpLnch := GetModuleHandle(nil);
  if  InstSpLnch < HINSTANCE_ERROR then
  begin
    InstSpLnch := 0;
    Exit;
  end;
  @SLAGetPadCount := GetProcAddress(InstSpLnch, 'SLAGetPadCount');
  @SLAGetPadID := GetProcAddress(InstSpLnch, 'SLAGetPadID');
  @SLAGetNextPadID := GetProcAddress(InstSpLnch, 'SLAGetNextPadID');
  @SLAGetPadWnd := GetProcAddress(InstSpLnch, 'SLAGetPadWnd');
  @SLAGetPadTabWnd := GetProcAddress(InstSpLnch, 'SLAGetPadTabWnd');
  @SLAGetPadInit := GetProcAddress(InstSpLnch, 'SLAGetPadInit');
  @SLASetPadInit := GetProcAddress(InstSpLnch, 'SLASetPadInit');
  @SLAChangePluginButtons := GetProcAddress(InstSpLnch, 'SLAChangePluginButtons');
  @SLAChangePluginMenus := GetProcAddress(InstSpLnch, 'SLAChangePluginMenus');
  @SLARedrawPluginButtons := GetProcAddress(InstSpLnch, 'SLARedrawPluginButtons');
  @SLAGetGroupCount := GetProcAddress(InstSpLnch, 'SLAGetGroupCount');
  @SLAGetGroup := GetProcAddress(InstSpLnch, 'SLAGetGroup');
  @SLAInsertGroup := GetProcAddress(InstSpLnch, 'SLAInsertGroup');
  @SLARenameGroup := GetProcAddress(InstSpLnch, 'SLARenameGroup');
  @SLACopyGroup := GetProcAddress(InstSpLnch, 'SLACopyGroup');
  @SLADeleteGroup := GetProcAddress(InstSpLnch, 'SLADeleteGroup');
  @SLAGetButton := GetProcAddress(InstSpLnch, 'SLAGetButton');
  @SLAInsertButton := GetProcAddress(InstSpLnch, 'SLAInsertButton');
  @SLAChangeButton := GetProcAddress(InstSpLnch, 'SLAChangeButton');
  @SLADeleteButton := GetProcAddress(InstSpLnch, 'SLADeleteButton');
  @SLACopyButton := GetProcAddress(InstSpLnch, 'SLACopyButton');
  @SLAPasteButton := GetProcAddress(InstSpLnch, 'SLAPasteButton');
  @SLAButtonInClipbord := GetProcAddress(InstSpLnch, 'SLAButtonInClipbord');
  @SLARunButton := GetProcAddress(InstSpLnch, 'SLARunButton');
  @SLAGetIcon := GetProcAddress(InstSpLnch, 'SLAGetIcon');

  ExistsSLAPI :=
    (@SLAGetPadCount <> nil) and
    (@SLAGetPadID <> nil) and
    (@SLAGetNextPadID <> nil) and
    (@SLAGetPadWnd <> nil) and
    (@SLAGetPadTabWnd <> nil) and
    (@SLAGetPadInit <> nil) and
    (@SLASetPadInit <> nil) and
    (@SLAChangePluginButtons <> nil) and
    (@SLAChangePluginMenus <> nil) and
    (@SLARedrawPluginButtons <> nil) and
    (@SLAGetGroupCount <> nil) and
    (@SLAGetGroup <> nil) and
    (@SLAInsertGroup <> nil) and
    (@SLARenameGroup <> nil) and
    (@SLACopyGroup <> nil) and
    (@SLADeleteGroup <> nil) and
    (@SLAGetButton <> nil) and
    (@SLAInsertButton <> nil) and
    (@SLAChangeButton <> nil) and
    (@SLADeleteButton <> nil) and
    (@SLACopyButton <> nil) and
    (@SLAPasteButton <> nil) and
    (@SLAButtonInClipbord <> nil) and
    (@SLARunButton <> nil) and
    (@SLAGetIcon <> nil);
end;



initialization
  InitAPI;
end.
