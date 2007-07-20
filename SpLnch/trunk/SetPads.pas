unit SetPads;

interface

uses
  Windows, SysUtils, Classes, Pad, SetInit, Forms, Graphics, SetBtn;

type
  TPads = class(TList)
  private
    FLastPadID: Integer;
    procedure SetPadID(frmPad: TfrmPad);
    function Get(Index: Integer): TfrmPad;
  public
    CtrlTabActivate: Boolean;
    Destroying: Boolean;
    property Items[Index: Integer]: TfrmPad read Get; default;
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function New(BasePad: TfrmPad): TfrmPad;
    procedure Close(frmPad: TfrmPad);
    procedure AllArrange;
    procedure Load;
    procedure SaveIni;
    procedure BeginPads;
    procedure EndPads;
    function IndexOfPadID(PadID: Integer): Integer;
    function PadOfID(PadID: Integer): TfrmPad;
  end;

var
  Pads: TPads;

implementation

constructor TPads.Create;
begin
  Destroying := False;
end;

destructor TPads.Destroy;
begin
  Destroying := True;
  Clear;
  inherited;
end;

procedure TPads.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Release;
  inherited;
end;

// PadID をセットする
procedure TPads.SetPadID(frmPad: TfrmPad);
  procedure IncID;
  begin
    Inc(FLastPadID);
    if FLastPadID <= 0 then
      FLastPadID := 1;
  end;
var
  i: Integer;
begin
  IncID;
  while True do
  begin
    i := 0;
    while i < Count do
    begin
      if Items[i].ID = FLastPadID then
        Break;
      Inc(i);
    end;
    if i = Count then
      Break;
    IncID;
  end;
  frmPad.ID := FLastPadID;
end;

// 取得
function TPads.Get(Index: Integer): TfrmPad;
begin
  Result := inherited Get(Index);
end;

// 新規パッド
function TPads.New(BasePad: TfrmPad): TfrmPad;
var
  frmPad: TfrmPad;
  ButtonGroup: TButtonGroup;
begin
  frmPad := TfrmPad.Create(nil);
  SetPadID(frmPad);
  Insert(0, frmPad);

  if BasePad = nil then
  begin
    ButtonGroup := TButtonGroup.Create;
    ButtonGroup.Name := '新規';
    frmPad.ButtonGroups.Add(ButtonGroup);
    frmPad.GroupIndex := 0;
  end
  else
  begin
    frmPad.Assign(BasePad);
  end;

  frmPad.Show;
  frmPad.EndUpdate;
  frmPad.SaveBtn;
  frmPad.SaveIni;
//  Save;

  Result := frmPad;
end;

// パッドを閉じる
procedure TPads.Close(frmPad: TfrmPad);
var
  IniFileName: string;
begin
  IniFileName := ChangeFileExt(frmPad.BtnFileName, '.ini');
  Remove(frmPad);
  if FileExists(IniFileName) then
    DeleteFile(IniFileName);
  if FileExists(frmPad.BtnFileName) then
    DeleteFile(frmPad.BtnFileName);
  frmPad.Release;
  
  if Count > 0 then
  begin
    // フォアグラウンドを移動しておかないと OnDestroy のあとに WM_KILLFOCUS がくる
    frmPad.Foreground := False;
    Items[0].Show;
  end;
end;




// すべてのパッドを再配置
procedure TPads.AllArrange;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].ButtonArrangement.Arrange;
//    Items[i].ArrangeButtons ではプラグインボタンの追加削除が探知できない

    Items[i].ArrangeScrolls;
    Items[i].ArrangeGroupMenu;
    Items[i].ArrangePluginMenu;
  end;
end;

// パッドをすべて読み込む
procedure TPads.Load;
var
  PadsFolder: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  BtnFileName: string;
  IniFileName: string;
  frmPad: TfrmPad;
  ButtonGroup: TButtonGroup;
  i, ID, Index: Integer;
begin
  FLastPadID := UserIniFile.ReadInteger(IS_PADS, 'LastPadID', 0);

  // パッドのフォルダ
  PadsFolder := UserFolder + 'Pads\';
  if not DirectoryExists(PadsFolder) then
    ForceDirectories(PadsFolder);

  FindHandle := FindFirstFile(PChar(PadsFolder + 'Pad*.btn'), Win32FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then
  begin
    while True do
    begin
      BtnFileName := PadsFolder + Win32FindData.cFileName;
      IniFileName := ChangeFileExt(BtnFileName, '.ini');

      frmPad := TfrmPad.Create(nil);
      frmPad.LoadBtn(BtnFileName);
      frmPad.LoadIni(IniFileName);
      frmPad.ButtonArrangement.Clear;
      if frmPad.ID = 0 then
        SetPadID(frmPad);
      Add(frmPad);

      if not FindNextFile(FindHandle, Win32FindData) then
        Break;
    end;
    Windows.FindClose(FindHandle)
  end;

  // パッドの順番
  i := 0;
  while True do
  begin
    ID := UserIniFile.ReadInteger(IS_PADSZORDER, IntToStr(i), 0);
    if ID = 0 then
      Break;
    Index := IndexOf(PadOfID(ID));
    if (Index >= 0) and (i < Count) then
      Move(Index, i);
    Inc(i);
  end;

  // １つもなければ作る
  if Count = 0 then
  begin
    frmPad := TfrmPad.Create(nil);
    SetPadID(frmPad);
    Add(frmPad);

    ButtonGroup := TButtonGroup.Create;
    ButtonGroup.Name := '新規';
    frmPad.ButtonGroups.Add(ButtonGroup);
    frmPad.GroupIndex := 0;
    frmPad.SaveBtn;
    frmPad.SaveIni;
  end;
end;

// パッドをすべて書き込む
procedure TPads.SaveIni;
var
  i: Integer;
begin
  if not UserIniReadOnly then
  begin
    UserIniFile.WriteInteger(IS_PADS, 'LastPadID', FLastPadID);
    UserIniFile.EraseSection(IS_PADSZORDER);

    // 書き込み
    for i := 0 to Count - 1 do
    begin
      UserIniFile.WriteInteger(IS_PADSZORDER, IntToStr(i), Items[i].ID);
      try
        Items[i].SaveIni;
      except
        on E: Exception do
          Application.MessageBox(PChar(E.Message), 'エラー', MB_ICONERROR);
      end;
    end;

    UserIniFile.UpdateFile;
  end;
end;

// すべてのパッドを開始
procedure TPads.BeginPads;
var
  i: Integer;
  ShowList: TList;
begin
  AllArrange;

  ShowList := TList.Create;
  try
    for i := 0 to Pads.Count - 1 do
      ShowList.Add(Items[i]);
    for i := ShowList.Count - 1 downto 0 do
    begin
      TfrmPad(ShowList[i]).Show;
      TfrmPad(ShowList[i]).EndUpdate;
    end;
  finally
    ShowList.Free;
  end;

  if Items[0].Handle <> GetForegroundWindow then
    Items[0].Foreground := False;
end;

// すべてのパッドを終了
procedure TPads.EndPads;
var
  i: Integer;
begin
  for i := 0 to Pads.Count - 1 do
    Items[i].ButtonArrangement.Clear;
end;

// PadID のパッドのインデックスを取得
function TPads.IndexOfPadID(PadID: Integer): Integer;
var
  i: Integer;
begin
  i := 0;
  Result := -1;
  while i < Pads.Count do
  begin
    if Pads[i].ID = PadID then
    begin
      Result := i;
      Break;
    end;
    Inc(i);
  end;
end;

// PadID からパッドを取得
function TPads.PadOfID(PadID: Integer): TfrmPad;
var
  Index: Integer;
begin
  Index := IndexOfPadID(PadID);
  if Index < 0 then
    Result := nil
  else
    Result := Items[Index];
end;

end.
