unit SetBtn;

interface

uses
  Windows, ShellAPI, SysUtils, Classes, Forms, ShlObj, pidl, Dialogs, SetInit;

type

  TButtonDataClass = class of TButtonData;

  // ボタンのデータ全般
  TButtonData = class(TObject)
    Name: string;
    ClickCount: Integer;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TButtonData); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
  end;

  // 空白
  TSpaceButton = class(TButtonData);

  // 改行
  TReturnButton = class(TButtonData);

  // ノーマルボタン
  TNormalButton = class(TButtonData)
  private
    FFileName: string;
    FItemIDList: PItemIDList;
    FOption: string;
    FFolder: string;
    FWindowSize: Integer;
    FIconFile: string;
    FIconIndex: Integer;
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    procedure SetItemIDList(const Value: PItemIDList);
  public
    property FileName: string read GetFileName write SetFileName;
    property ItemIDList: PItemIDList read FItemIDList write SetItemIDList;
    property Option: string read FOption write FOption;
    property Folder: string read FFolder write FFolder;
    property WindowSize: Integer read FWindowSize write FWindowSize;
    property IconFile: string read FIconFile write FIconFile;
    property IconIndex: Integer read FIconIndex write FIconIndex;
    destructor Destroy; override;
    procedure Assign(Source: TButtonData); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

  // プラグインボタン
  TPluginButton = class(TButtonData)
    PluginName: string;
    No: Integer;
    procedure Assign(Source: TButtonData); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

  // ボタングループ
  TButtonGroup = class(TList)
  private
    FName: string;
    function Get(Index: Integer): TButtonData;
    procedure Put(Index: Integer; const Value: TButtonData);
  public
    property Name: string read FName write FName;
    property Items[Index: Integer]: TButtonData read Get write Put; default;
    destructor Destroy; override;
    procedure Clear(WithData: Boolean); reintroduce;
    procedure Assign(Source: TButtonGroup);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

  // ボタングループ読み書き違反
  EButtonFileError = class(Exception);

  // ボタングループリスト
  TButtonGroups = class(TList)
  private
    function Get(Index: Integer): TButtonGroup;
  public
    property Items[Index: Integer]: TButtonGroup read Get; default;
    destructor Destroy; override;
    procedure Clear(WithData: Boolean); reintroduce;
    procedure Delete(Index: Integer);
    procedure Assign(Source: TButtonGroups);
    function Load(FileName: String): Boolean;
    procedure Save(FileName: String);
  end;

  // ボタン開くスレッド
  TOpenNormalButtonThread = class(TThread)
  private
    FWnd: HWND;
    FButton: TNormalButton;
  protected
    procedure Execute; override;
  public
    constructor Create(AWnd: HWND; AButton: TNormalButton);
    destructor Destroy; override;
  end;

  // ボタン開く
  function OpenNormalButton(AWnd: HWND; AButton: TNormalButton): Boolean;
  function OpenNormalButtonFolder(AWnd: HWND; AButton: TNormalButton): Boolean;

implementation

const
  BTNHEAD = 'Special Launch 4 Buttons File';

  bkTerminate = 0;
  bkSpace = 1;
  bkReturn = 2;
  bkNormal = 3;
  bkPlugin = 4;

  bpTerminate = 0;
  bpName = 1;
  bpClickCount = 2;

  npTerminate = 0;
  npFileName = 1;
  npItemIDList = 2;
  npOption = 3;
  npFolder = 4;
  npWindowSize = 5;
  npIconFile = 6;
  npIconIndex = 7;

  ppTerminate = 0;
  ppPluginName = 1;
  ppNo = 2;

  gpTerminate = 0;
  gpName = 1;

//
// TButtonData
/////////////////////////////////

// コンストラクタ
constructor TButtonData.Create;
begin
  inherited;
end;

// デストラクタ
destructor TButtonData.Destroy;
begin
  inherited;
end;


// アサイン
procedure TButtonData.Assign(Source: TButtonData);
begin
  Name := Source.Name;
  ClickCount := Source.ClickCount;
end;

// ストリームを読み込む
procedure TButtonData.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  ButtonProperty: Byte;
  pWork: PChar;
begin
  while True do
  begin
    Stream.Read(ButtonProperty, SizeOf(ButtonProperty));

    if ButtonProperty = bpTerminate then
      Break;

    Stream.Read(Size, SizeOf(Size));
    if Size = 0 then
      Break;

    case ButtonProperty of
      bpName:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          Name := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;

      bpClickCount:
        Stream.Read(ClickCount, Size)
    else
      Stream.Seek(Size, soFromCurrent);
    end;
  end;
end;

// ストリームに書き込む
procedure TButtonData.SaveToStream(Stream: TStream);
var
  Size: Integer;
  ButtonProperty: Byte;
begin
  // Name
  ButtonProperty := bpName;
  Stream.Write(ButtonProperty, SizeOf(ButtonProperty));
  Size := Length(Name) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(Name)^, Size);
  // ClickCount
  ButtonProperty := bpClickCount;
  Stream.Write(ButtonProperty, SizeOf(ButtonProperty));
  Size := SizeOf(ClickCount);
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(ClickCount, Size);
  // Terminate
  ButtonProperty := bpTerminate;
  Stream.Write(ButtonProperty, SizeOf(ButtonProperty));
end;

//
// TNormalButton
/////////////////////////////////

// ファイル名取得
function TNormalButton.GetFileName: string;
var
  Work: array[0..MAX_PATH] of Char;
begin
  if SHGetPathFromIDList(FItemIDList, Work) then
    Result := Work
  else
    Result := FFileName;
end;

// ファイル名セット
procedure TNormalButton.SetFileName(const Value: string);
begin
  FFileName := Value;
  // ファイル名があるときは項目識別子は使わない
  ItemIDList := nil;
end;

// 項目識別子セット
procedure TNormalButton.SetItemIDList(const Value: PItemIDList);
begin
  if FItemIDList <> Value then
  begin
    Malloc.Free(FItemIDList);
    FItemIDList := Value;
    // 項目識別子があるときはファイル名は使わない
    FFileName := '';
  end;
end;

// デストラクタ
destructor TNormalButton.Destroy;
begin
  ItemIDList := nil; // SetItemIDListで解放する
  inherited;
end;


// アサイン
procedure TNormalButton.Assign(Source: TButtonData);
begin
  inherited;
  if Source is TNormalButton then
  begin
    if TNormalButton(Source).ItemIDList = nil then
      FileName := TNormalButton(Source).FileName
    else
      ItemIDList := CopyItemID(TNormalButton(Source).ItemIDList);
    Option := TNormalButton(Source).Option;
    Folder := TNormalButton(Source).Folder;
    WindowSize := TNormalButton(Source).WindowSize;
    IconFile := TNormalButton(Source).IconFile;
    IconIndex := TNormalButton(Source).IconIndex;
  end;
end;

// ストリームを読み込む
procedure TNormalButton.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  NormalProperty: Byte;
  pWork: PChar;
begin
  inherited;

  while True do
  begin
    Stream.Read(NormalProperty, SizeOf(NormalProperty));


    if NormalProperty = npTerminate then
      Break;

    Stream.Read(Size, SizeOf(Size));
    if Size = 0 then
      Break;

    case NormalProperty of
      npFileName:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          FileName := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;

      npItemIDList:
      begin
        if Size > 0 then
        begin
          ItemIDList := AllocItemID(Size);
          try
            Stream.Read(FItemIDList^, Size);
          except
            ItemIDList := nil;
          end;
        end;
      end;

      npOption:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          Option := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;

      npFolder:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          Folder := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;

      npWindowSize:
        Stream.Read(FWindowSize, Size);

      npIconFile:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          IconFile := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;

      npIconIndex:
        Stream.Read(FIconIndex, Size);

    else
      Stream.Seek(Size, soFromCurrent);
    end;
  end;

end;

// ストリームに書き込む
procedure TNormalButton.SaveToStream(Stream: TStream);
var
  Size: Integer;
  NormalProperty: Byte;
begin
  inherited;
  // FileName
  if FItemIDList = nil then
  begin
    NormalProperty := npFileName;
    Stream.Write(NormalProperty, SizeOf(NormalProperty));
    Size := Length(FFileName) + 1;
    Stream.Write(Size, SizeOf(Size));
    Stream.Write(PChar(FFileName)^, Size);
  end
  // ItemIDList
  else
  begin
    NormalProperty := npItemIDList;
    Stream.Write(NormalProperty, SizeOf(NormalProperty));
    Size := GetItemIDSize(FItemIDList);
    Stream.Write(Size, SizeOf(Size));
    Stream.Write(FItemIDList^, Size);
  end;
  // Option
  NormalProperty := npOption;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
  Size := Length(FOption) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(FOption)^, Size);
  // Folder
  NormalProperty := npFolder;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
  Size := Length(FFolder) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(FFolder)^, Size);
  // WindowSize
  NormalProperty := npWindowSize;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
  Size := SizeOf(FWindowSize);
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(FWindowSize, Size);
  // IconFile
  NormalProperty := npIconFile;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
  Size := Length(FIconFile) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(FIconFile)^, Size);
  // IconIndex
  NormalProperty := npIconIndex;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
  Size := SizeOf(FIconIndex);
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(FIconIndex, Size);
  // Terminate
  NormalProperty := npTerminate;
  Stream.Write(NormalProperty, SizeOf(NormalProperty));
end;


//
// TPluginButton
/////////////////////////////////

// アサイン
procedure TPluginButton.Assign(Source: TButtonData);
begin
  inherited;
  PluginName := TPluginButton(Source).PluginName;
  No := TPluginButton(Source).No;
end;

// ストリームを読み込む
procedure TPluginButton.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  PluginProperty: Byte;
  pWork: PChar;
begin
  inherited;

  while True do
  begin
    Stream.Read(PluginProperty, SizeOf(PluginProperty));

    if PluginProperty = ppTerminate then
      Break;

    Stream.Read(Size, SizeOf(Size));
    if Size = 0 then
      Break;

    case PluginProperty of
      ppPluginName:
      begin
        pWork := StrAlloc(Size);
        try
          Stream.Read(pWork^, Size);
          PluginName := StrPas(pWork);
        finally
          StrDispose(pWork);
        end;
      end;
      ppNo:
        Stream.Read(No, Size);
    else
      Stream.Seek(Size, soFromCurrent);
    end;
  end;
end;

// ストリームに書き込む
procedure TPluginButton.SaveToStream(Stream: TStream);
var
  Size: Integer;
  PluginProperty: Byte;
begin
  inherited;
  // PluginName
  PluginProperty := ppPluginName;
  Stream.Write(PluginProperty, SizeOf(PluginProperty));
  Size := Length(PluginName) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(PluginName)^, Size);

  // No
  PluginProperty := ppNo;
  Stream.Write(PluginProperty, SizeOf(PluginProperty));
  Size := SizeOf(No);
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(No, SizeOf(No));

  // Terminate
  PluginProperty := ppTerminate;
  Stream.Write(PluginProperty, SizeOf(PluginProperty));
end;



//
// TButtonGroup
/////////////////////////////////

// 取得
function TButtonGroup.Get(Index: Integer): TButtonData;
begin
  Result := inherited Get(Index);
end;

// 置く
procedure TButtonGroup.Put(Index: Integer; const Value: TButtonData);
begin
  inherited Put(Index, Value);
end;


// デストラクタ
destructor TButtonGroup.Destroy;
begin
  Clear(True);
  inherited;
end;

// クリア
procedure TButtonGroup.Clear(WithData: Boolean);
var
  i: Integer;
begin
  if WithData then
  begin
    Name := '';
    for i := 0 to Count - 1 do
      Items[i].Free;
  end;
  inherited Clear;
end;

// アサイン
procedure TButtonGroup.Assign(Source: TButtonGroup);
var
  i: Integer;
  ButtonData: TButtonData;
begin
  Clear(True);
  for i := 0 to Source.Count - 1 do
  begin
    ButtonData := TButtonDataClass(TButtonData(Source[i]).ClassType).Create;
    ButtonData.Assign(Source[i]);
    Add(ButtonData);
  end;
  Name := Source.Name;
end;

// ストリームを読み込む
procedure TButtonGroup.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  Kind: Byte;
  GroupProperty: Byte;
  pWork: PChar;
  ButtonData: TButtonData;
  MemStream: TMemoryStream;
begin
  while True do
  begin
    Stream.Read(GroupProperty, SizeOf(GroupProperty));
    // Terminate
    if GroupProperty = gpTerminate then
      Break;

    Stream.Read(Size, SizeOf(Size));
    if Size = 0 then
      Break;

    // Name
    if GroupProperty = gpName then
    begin
      pWork := StrAlloc(Size);
      try
        Stream.Read(pWork^, Size);
        Name := StrPas(pWork);
      finally
        StrDispose(pWork);
      end;
    end
    // else
    else
    begin
      Stream.Seek(Size, soFromCurrent);
    end;
  end;

  MemStream := TMemoryStream.Create;
  try
    while True do
    begin
      Stream.Read(Kind, SizeOf(Kind));
      if Kind = bkTerminate then
        Break;

      ButtonData := nil;
      case Kind of
        bkSpace:
          ButtonData := TSpaceButton.Create;
        bkReturn:
          ButtonData := TReturnButton.Create;
        bkNormal:
          ButtonData := TNormalButton.Create;
        bkPlugin:
          ButtonData := TPluginButton.Create;
      end;

      Stream.Read(Size, SizeOf(Size));
      if Size = 0 then
        Break;
        
      MemStream.Clear;
      MemStream.CopyFrom(Stream, Size);
      if ButtonData <> nil then
      begin
        MemStream.Position := 0;
        ButtonData.LoadFromStream(MemStream);
        Add(ButtonData);
      end;
    end;
  finally
    MemStream.Free;
  end;
end;

// ストリームに書き込む
procedure TButtonGroup.SaveToStream(Stream: TStream);
var
  i: Integer;
  Size: Integer;

  Kind: Byte;
  GroupProperty: Byte;
  MemStream: TMemoryStream;
begin
  // Name
  GroupProperty := gpName;
  Stream.Write(GroupProperty, SizeOf(GroupProperty));
  Size := Length(Name) + 1;
  Stream.Write(Size, SizeOf(Size));
  Stream.Write(PChar(Name)^, Size);
  // Terminate
  GroupProperty := gpTerminate;
  Stream.Write(GroupProperty, SizeOf(GroupProperty));


  MemStream := TMemoryStream.Create;
  try
    for i := 0 to Count - 1 do
    begin
      MemStream.Clear;

      if Items[i] is TSpaceButton then
        Kind := bkSpace
      else if Items[i] is TReturnButton then
        Kind := bkReturn
      else if Items[i] is TNormalButton then
        Kind := bkNormal
      else if Items[i] is TPluginButton then
        Kind := bkPlugin;

      Stream.Write(Kind, SizeOf(Kind));

      Items[i].SaveToStream(MemStream);
      MemStream.Position := 0;

      Size := MemStream.Size;
      Stream.Write(Size, SizeOf(Size));
      Stream.CopyFrom(MemStream, MemStream.Size);
    end;
  finally
    MemStream.Free;
  end;
  Kind := bkTerminate;
  Stream.Write(Kind, SizeOf(Kind));
end;



//
// TButtonGroups
/////////////////////////////////

destructor TButtonGroups.Destroy;
begin
  Clear(True);
  inherited;
end;

// クリア
procedure TButtonGroups.Clear(WithData: Boolean);
var
  i: Integer;
begin
  if WithData then
  begin
    for i := 0 to Count - 1 do
      Items[i].Free;
  end;
  inherited Clear;
end;

// 削除
procedure TButtonGroups.Delete(Index: Integer);
begin
  Items[Index].Free;
  inherited;
end;


// 取得
function TButtonGroups.Get(Index: Integer): TButtonGroup;
begin
  Result := inherited Get(Index);
end;

// アサイン
procedure TButtonGroups.Assign(Source: TButtonGroups);
var
  ButtonGroup: TButtonGroup;
  i: Integer;
begin
  Clear(True);
  for i := 0 to Source.Count - 1 do
  begin
    ButtonGroup := TButtonGroup.Create;
    ButtonGroup.Assign(Source[i]);
    Add(ButtonGroup);
  end;
end;

// ボタンファイル読み込み
function TButtonGroups.Load(FileName: String): Boolean;
var
  ButtonGroup: TButtonGroup;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
  Size: Integer;
  pWork: PChar;
begin
  Clear(True);
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
    MemStream := TMemoryStream.Create;
    try
      MemStream.CopyFrom(FileStream, FileStream.Size);
      MemStream.Position := 0;

      Size := Length(BTNHEAD) + 1;
      pWork := StrAlloc(Size);
      try
        MemStream.Read(pWork^, Size);
        if StrPas(pWork) <> BTNHEAD then
          raise EButtonFileError.Create('ファイル形式が違います。');
      finally
        StrDispose(pWork);
      end;

      while MemStream.Position < MemStream.Size do
      begin
        ButtonGroup := TButtonGroup.Create;
        try
          ButtonGroup.LoadFromStream(MemStream);
          Add(ButtonGroup);
        except
          ButtonGroup.Free;
        end;
      end;
    finally
      FileStream.Free;
      MemStream.Free;
    end;
    Result := True;

  except
    on E: EButtonFileError do
    begin
      Result := Application.MessageBox(PChar('ボタンファイルを読み込めませんでした。' +
        E.Message + 'このまま続けますか？'), '確認', MB_ICONQUESTION or MB_YESNO) = idYes;
    end;
  else
    Result := True;
  end;

  if Result and (Count = 0) then
  begin
    ButtonGroup := TButtonGroup.Create;
    Add(ButtonGroup);
    ButtonGroup.Name := '標準';
  end;

end;


// ボタンファイル書き込み
procedure TButtonGroups.Save(FileName: String);
var
  i: Integer;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
  Size: Integer;
begin
  if not UserIniReadOnly then
  begin
    MemStream := TMemoryStream.Create;
    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      Size := Length(BTNHEAD) + 1;
      MemStream.Write(BTNHEAD, Size);

      for i := 0 to Count - 1 do
        Items[i].SaveToStream(MemStream);

      MemStream.Position := 0;
      FileStream.CopyFrom(MemStream, MemStream.Size);
    finally
      MemStream.Free;
      FileStream.Free;
    end;
  end;
end;

//
// TOpenNormalButtonThread
/////////////////////////////////

constructor TOpenNormalButtonThread.Create(AWnd: HWND; AButton: TNormalButton);
begin
  FWnd := AWnd;
  FButton := TNormalButton.Create;
  FButton.Assign(AButton);
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TOpenNormalButtonThread.Destroy;
begin
  FButton.Free;
  inherited;
end;

procedure TOpenNormalButtonThread.Execute;
begin
  OpenNormalButton(FWnd, FButton);
  Sleep(1);
end;


// ボタン開く
function OpenNormalButton(AWnd: HWND; AButton: TNormalButton): Boolean;
var
  ExecInfo: TShellExecuteInfo;

begin
  // カレントディレクトリ移動
  ChDir(ExtractFilePath(ParamStr(0)));

  with ExecInfo do
  begin
    cbSize := SizeOf(TShellExecuteInfo);

    if AButton.ItemIDList = nil then
    begin
      fMask := SEE_MASK_DOENVSUBST;
      lpFile := PChar(AButton.FileName);
      lpParameters := PChar(AButton.Option);
      lpDirectory := PChar(ExpandUNCFileName(AButton.Folder));
      lpIDList := nil;
    end
    else
    begin
//      fMask := SEE_MASK_IDLIST; // これだとコントロールパネルの項目が開けない
      fMask := SEE_MASK_INVOKEIDLIST;
      lpFile := nil;
      lpParameters := nil;
      lpDirectory := nil;
      lpIDList := AButton.ItemIDList;
    end;

    Wnd := AWnd;
    lpVerb := nil; //デフォルトはopen
    case AButton.WindowSize of
      0: nShow := SW_SHOWNORMAL;
      1: nShow := SW_SHOWMINIMIZED;
      2: nShow := SW_SHOWMAXIMIZED;
    end;
    hInstApp := 0;
    lpClass := nil;
    hkeyClass := 0;
    dwHotKey := 0;
    hIcon := 0;
    hProcess := 0;
  end;

  Result := ShellExecuteEx(@ExecInfo);
end;

function OpenNormalButtonFolder(AWnd: HWND; AButton: TNormalButton): Boolean;
var
  NormalButton: TNormalButton;

  ItemID, NextID, FolderID: PItemIDList;
  FoundPath: array[0..MAX_PATH] of Char;
  Len: Integer;
  FilePart: PChar;
begin
  Result := True;

  // カレントディレクトリ移動
  ChDir(ExtractFilePath(ParamStr(0)));

  NormalButton := TNormalButton.Create;
  try

    if AButton.ItemIDList = nil then
    begin
      ItemID := GetIDListFromPath(AButton.FileName);

      if ItemID = nil then
      begin
        Len := SearchPath(nil, PChar(AButton.FileName), nil, MAX_PATH, FoundPath, FilePart);
        if Len > 0 then
          ItemID := GetIDListFromPath(FoundPath);
      end;

    end
    else
      ItemID := AButton.ItemIDList;

    if ItemID <> nil then
    begin
      Len := 0;
      FolderID := ItemID;
      NextID := GetNextItemID(FolderID);
      while NextID^.mkid.cb <> 0 do
      begin
        Inc(Len, FolderID^.mkid.cb);
        FolderID := NextID;
        NextID := GetNextItemID(NextID);
      end;

      if Len > 0 then
      begin
        FolderID := AllocItemID(Len + SizeOf(ItemID.mkid.cb));
        Move(ItemID^, FolderID^, Len);
      end
      else
        Result := False;
      if Result then
        NormalButton.ItemIDList := FolderID;

    end
    else
      Result := False;

    if Result then
    begin
      Result := OpenNormalButton(AWnd, NormalButton);
    end;

  finally
    NormalButton.Free;
  end;
end;

end.
