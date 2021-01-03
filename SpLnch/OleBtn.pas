unit OleBtn;

interface

uses
  Windows, ActiveX, Classes, ShellAPI, ShlObj, SysUtils, OleData, SetBtn,
  pidl, BtnPro, Dialogs;

type
  //-------------------------------------------------------------------
  // IDropSource の実装
  //-------------------------------------------------------------------
  TDropSource = class (TInterfacedObject, IDropSource)
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
  end;

  //-------------------------------------------------------------------
  // IDropTarget の実装
  //-------------------------------------------------------------------
  TDropTargetEvent = procedure(var DataObject: IDataObject; KeyState: Longint;
    Point: TPoint; var dwEffect: Longint) of object;
  TDropTargetLeaveEvent = procedure of object;
  TDropTarget = class(TInterfacedObject, IDropTarget)
  private
    FFormatList:  PFormatList;
    FFormatCount: Integer;

    // ドラッグされたデータへの IDataObject インタフェースポインタ。
    FDataObject:  IDataObject;

    FOnDragEnter: TDropTargetEvent;
    FOnDragOver:  TDropTargetEvent;
    FOnDragLeave: TDropTargetLeaveEvent;
    FOnDragDrop:  TDropTargetEvent;

    // キーボードの状態からディフォルトの動作を決定する。
    function GetEffect(grfKeyState: Longint): Longint;

    // IDropTarget で定義されているメソッド
    function DragEnter(const dataObj: IDataObject;
      grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall;
    function DragLeave: HResult; virtual; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall;
  public
    // 受け取ることができるクリップボード形式を設定する。
    constructor Create(AFormatList: PFormatList;
      AFormatCount: Integer);
    destructor Destroy; override;

    // IDropTarget インターフェースのメソッドが呼ばれたときに呼ばれる
    // イベントハンドラ。
    property OnDragEnter: TDropTargetEvent read FOnDragEnter write FOnDragEnter;
    property OnDragOver: TDropTargetEvent read FOnDragOver write FOnDragOver;
    property OnDragLeave: TDropTargetLeaveEvent read FOnDragLeave write FOnDragLeave;
    property OnDragDrop: TDropTargetEvent read FOnDragDrop write FOnDragDrop;
  end;

  //-------------------------------------------------------------------
  // ボタングループのIDataObject
  //-------------------------------------------------------------------
  TButtonGroupDataObject = class(TDataObject)
  private
    FStream: TMemoryStream;
  protected
    function GetMedium(const FormatEtc: TFormatEtc; var Medium: TStgMedium;
      CreateMedium: Boolean): HResult; override;
  public
    constructor Create(AButtonGroup: TButtonGroup);
    destructor Destroy; override;
  end;

procedure DataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
function ButtonGroupInClipbord: Boolean;
function DataObjectIsButtonGroup(DataObject: IDataObject): Boolean;
function DataObjectIsFileName(DataObject: IDataObject; FindFile: Boolean): Boolean;
function DataObjectIsUrl(DataObject: IDataObject): Boolean;


var
  CF_SLBUTTONS: UINT;

  CF_IDLIST: UINT;
//  CF_FILENAMEMAP, CF_FILENAMEMAPW: UINT;
  CF_FILEGROUPDESCRIPTORA: UINT;
  CF_SHELLURL: UINT;

  CF_NETSCAPEBOOKMARK: UINT;



implementation

//--------------------------------------------------------------------
// IDropSource の実装
//--------------------------------------------------------------------
// ドラッグ操作を継続するかどうかを決定する
function TDropSource.QueryContinueDrag(
  fEscapePressed: BOOL;             // ユーザーが[ESC]キーを押したか  
  grfKeyState: Longint              // キーボード装飾キーの現在の状態 
  ): HResult; stdcall;
begin
  // マウスの左ボタンが押されていない，すなわちマウスの左ボタンが離された時
  if (grfKeyState and MK_LBUTTON) = 0 then
    Result := DRAGDROP_S_DROP       // ドロップ操作を発生させます
  // マウスの右ボタンが押された時
  else if (grfKeyState and MK_RBUTTON) <> 0 then
    Result := DRAGDROP_S_CANCEL     // ドラッグ動作を取り消します
  // ドラッグ動作がキャンセルされた時
  else if fEscapePressed then
    Result := DRAGDROP_S_CANCEL     // ドラッグ動作を取り消します
  else
    Result := S_OK;                 // ドラッグ操作を継続します
end;


// ドラッグ中の適切な視覚的効果を与える。               　　　　　　　
function TDropSource.GiveFeedback(
  dwEffect: Longint                 // IDropTarget からの戻り値       
  ): HResult; stdcall;
begin
  // マウスポインタはディフォルトのものを使用し，それ以外の
  // 視覚的動作（アイコンが移動するなど）は行わない。                 
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

//--------------------------------------------------------------------
// IDropTarget の実装
//--------------------------------------------------------------------
constructor TDropTarget.Create(AFormatList: PFormatList;
  AFormatCount: Integer);
begin
  inherited Create;
  FFormatCount := AFormatCount;

  // TFormatEtc 構造体のリストのコピーをオブジェクト内部に確保する。
  GetMem(FFormatList, SizeOf(TFormatList)*FFormatCount);
  CopyMemory(FFormatList, AFormatList,
    SizeOf(TFormatList)*FFormatCount);
end;

destructor TDropTarget.Destroy;
begin
  // オブジェクト内部に確保した TFormatEtc 構造体のリストを解放する。
  FreeMem(FFormatList);
  inherited Destroy;
end;

// キーボードの状態により行うべき操作を決定する
function TDropTarget.GetEffect(grfKeyState: Longint): Longint;
begin
  if (grfKeyState and MK_CONTROL) <> 0 then
  begin
    if (grfKeyState and MK_SHIFT) <> 0 then
    // [CTRL]+[SHIFT] が押されている時
      Result := DROPEFFECT_LINK
    else
    // [CTRL] が押されている時
      Result := DROPEFFECT_COPY;
  end
  else
    // それ以外の場合
    Result := DROPEFFECT_MOVE;
end;

function TDropTarget.DragEnter(
  const dataObj: IDataObject;       // ドロップしようとしているデータ
  grfKeyState: Longint;             // キーボード装飾キーの現在の状態
  pt: TPoint;                       // マウスポインタの場所
  var dwEffect: Longint             // ドロップした場合の動作
  ): HResult; stdcall;
var
  i: Integer;
begin
  FDataObject := nil;

  // 以下のループの中で指定した形式が使えない場合は、ドロップ操作を
  // 受け付けない。
  dwEffect := DROPEFFECT_NONE;
  for i := 0 to FFormatCount - 1 do
  begin
    // 要求したデータ形式が使用できるかを判断する
    if S_OK = dataObj.QueryGetData(FFormatList^[i]) then
    begin
      // データオブジェクトを内部に確保する。
      FDataObject := dataObj;
      Break;
    end;
  end;

  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // イベントハンドラが設定されている場合には、それを呼び出す。
    if Assigned(FOnDragEnter) then
      FOnDragEnter(FDataObject, grfKeyState, pt, dwEffect);
  end;

  Result := S_OK;                   // 関数は正常に終了しました
end;


function TDropTarget.DragOver(
  grfKeyState: Longint;             // キーボード装飾キーの現在の状態
  pt: TPoint;                       // マウスポインタの場所
  var dwEffect: Longint             // ドロップした場合の動作
  ): HResult; stdcall;
begin
  // ドロップ可能なデータ形式が含まれる場合は、その動作を決定する
  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // イベントハンドラが設定されている場合には、それを呼び出す。
    if Assigned(FOnDragOver) then
      FOnDragOver(FDataObject, grfKeyState, pt, dwEffect);
  end;

  Result := S_OK;                   // 関数は正常に終了しました
end;


function TDropTarget.DragLeave: HResult; stdcall;
begin
  // オブジェクト内部に確保した DataObject への参照を終了する。
  FDataObject := nil;
  if Assigned(FOnDragLeave) then
    FOnDragLeave;
  Result := S_OK;                   // 関数は正常に終了しました
end;

// IDataObject.Drop は，dataObj によって示されたソースデータを，この
// ターゲットアプリケーションにドロップする。
function TDropTarget.Drop(
  const dataObj: IDataObject;       // ドロップしようとしているデータ
  grfKeyState: Longint;             // キーボード装飾キーの現在の状態
  pt: TPoint;                       // マウスポインタの場所
  var dwEffect: Longint             // ドロップした場合の動作
  ): HResult; stdcall;
begin
  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // イベントハンドラが設定されている場合には、それを呼び出す。
    if Assigned(FOnDragDrop) then
      FOnDragDrop(FDataObject, grfKeyState, pt, dwEffect);
  end;

  // オブジェクト内部に確保した DataObject への参照を終了する。
  FDataObject := nil;
  Result := S_OK;                   // 関数は正常に終了しました
end;


//-------------------------------------------------------------------
// ボタングループのIDataObject
//-------------------------------------------------------------------
constructor TButtonGroupDataObject.Create(AButtonGroup: TButtonGroup);
var
  FormatEtc: TFormatEtc;
begin
  // テキストデータ転送の場合の形式を指定する。
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;

  inherited Create(@FormatEtc, 1);
  // テキストデータをオブジェクト内部に格納する。
  FStream := TMemoryStream.Create;
  AButtonGroup.SaveToStream(FStream);
end;

destructor TButtonGroupDataObject.Destroy;
begin
  FStream.Free;
  inherited;
end;

function TButtonGroupDataObject.GetMedium(const FormatEtc: TFormatEtc;
      var Medium: TStgMedium; CreateMedium: Boolean): HResult;
var
  hMem: HGLOBAL;
  pszDst: PChar;
  Size: Longint;
begin
  // このサンプルでは、GetDataHere には対応しない
  if not CreateMedium then
  begin
    Result := E_NOTIMPL;
    Exit;
  end;

  // ボタンバッファを準備
  FStream.Position := 0;
  Size := FStream.Size;

  // 転送メディアを作成する。
  hMem := GlobalAlloc(GHND, SizeOf(Size) + Size);
  if hMem <> 0 then
  begin
    pszDst := GlobalLock(hMem);

    PLongint(pszDst)^ := Size;
    Inc(pszDst, SizeOf(Size));
    FStream.Read(pszDst^, FStream.Size);
    GlobalUnlock(hMem);

    // 作成した転送メディアをターゲットに渡す。
    Medium.hGlobal := hMem;
    Medium.tymed   := FormatEtc.tymed;
    Result := S_OK
  end
  else
    // 転送メディアを確保できなかった場合。
    Result := STG_E_MEDIUMFULL;

end;









// ButtonGroupデータオブジェクトからボタングループに追加する
function ButtonGroupDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup): Boolean;
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  P: PChar;
  Size: Longint;
  MemStream: TMemoryStream;
begin
  Result := False;
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  if DataObject.GetData(FormatEtc, Medium) = S_OK then
  begin
    try
      MemStream := TMemoryStream.Create;
      P := GlobalLock(Medium.hGlobal);
      try
        Size := PLongint(P)^;
        Inc(P, SizeOf(Size));
        MemStream.Write(P^, Size);
        MemStream.Position := 0;
        ButtonGroup.LoadFromStream(MemStream);
        Result := True;
      finally
        GlobalUnlock(Medium.hGlobal);
        MemStream.Free;
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;
end;

// Urlデータオブジェクトからボタングループに追加する
function UrlDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup): Boolean;
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  Url, UrlName: String;
  pUrl: PChar;
  NormalButton: TNormalButton;
  FileGroupDescriptor: PFileGroupDescriptor;
begin
  Result := False;

  Url := '';
  UrlName := '';

  with FormatEtc do
  begin
    cfFormat := CF_SHELLURL;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  if DataObject.GetData(FormatEtc, Medium) = S_OK then
  begin
    try
      pUrl := PChar(GlobalLock(Medium.hGlobal));
      try
        Url := pUrl;
      finally
        GlobalUnlock(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;

  if Url = '' then
  begin
    // NetscapeのUrl
    with FormatEtc do
    begin
      cfFormat := CF_NETSCAPEBOOKMARK;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        pUrl := PChar(GlobalLock(Medium.hGlobal));
        try
          Url := pUrl;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;
  end;

  if Url <> '' then
  begin
    Result := True;
    // リンク名
    with FormatEtc do
    begin
      cfFormat := CF_FILEGROUPDESCRIPTORA;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        FileGroupDescriptor := PFileGroupDescriptor(GlobalLock(Medium.hGlobal));
        try
          if FileGroupDescriptor^.cItems >= 1 then
            UrlName := FileGroupDescriptor^.fgd[0].cFileName;
        finally
          if Medium.hGlobal <> 0 then
            GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;

    NormalButton := TNormalButton.Create;
    if UrlName <> '' then
    begin
      NormalButton.Name := ExtractFileNameWithoutExt(UrlName);
      NormalButton.IconFile := UrlName;
    end
    else
    begin
      NormalButton.Name := Url;
      NormalButton.IconFile := 'dammy.url';
    end;
    NormalButton.FileName := Url;

    ButtonGroup.Add(NormalButton);
  end;

end;


// ファイルデータオブジェクトからボタングループに追加する
procedure FileDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  FileList: TStringList;
  DropFiles: PDropFiles;
  pFileName: PChar;
  FileName: String;

  DesktopFolder: IShellFolder;
  CIDAList, PIDLList: TList;
  pInt: ^UINT;
  pCIDA: PIDA;
  i, Index: Integer;
  ButtonData: TButtonData;
  cPath: array[0..MAX_PATH] of Char;
begin
  FileList := TStringList.Create;
  try

    with FormatEtc do
    begin
      cfFormat := CF_HDROP;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        DropFiles := PDropFiles(GlobalLock(Medium.hGlobal));
        try
          pFileName := PChar(DropFiles) + DropFiles^.pFiles;
          while (pFileName^ <> #0) do
          begin
            if (DropFiles^.fWide) then // -> NT4 & Asian compatibility
            begin
              FileName := PWideChar(pFileName);
              Inc(pFileName, (Length(PWideChar(pFileName)) + 1) * 2);
            end
            else
            begin
              FileName := pFileName;
              Inc(pFileName, Length(pFileName) + 1);
            end;
            FileName := AnsiUpperCase(GetDosName(FileName));
            FileList.Add(FileName);
          end;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;


    with FormatEtc do
    begin
      cfFormat := CF_IDLIST;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try

        SHGetDesktopFolder(DesktopFolder);
        CIDAList := TList.Create;
        PIDLList := TList.Create;

        pCIDA := PIDA(GlobalLock(Medium.hGlobal));
        try
          pInt := @(pCIDA^.aoffset[0]);
          for i := 0 to pCIDA^.cidl do
          begin
            CIDAList.Add(Pointer(UINT(pCIDA)+ pInt^));
            Inc(pInt);
          end;

          // １つめとそれ以外をつなげる
          for i := 1 to CIDAList.Count - 1 do
          begin
            PIDLList.Add(ConcatItemID(CIDAList[0], CIDAList[i]));
          end;

          for i := 0 to PIDLList.Count - 1 do
          begin
            ButtonData := TNormalButton.Create;
            try
              if SHGetPathFromIDList(PIDLList[i], cPath) then
              begin
                FileNameToNormalButton(cPath, TNormalButton(ButtonData));
                FileName := AnsiUpperCase(GetDosName(cPath));
                Index := FileList.IndexOf(FileName);
                if Index >= 0 then
                  FileList.Delete(Index);
              end
              else
              begin
                with TNormalButton(ButtonData) do
                begin
                  ClickCount := 0;
                  Name := GetItemIDName(DesktopFolder, PIDLList[i], SHGDN_NORMAL);
                  FileName := '';
                  ItemIDList := PIDLList[i];
                  Option := '';
                  Folder := '';
                  WindowSize := 0;
                  IconFile := '';
                  IconIndex := 0;
                end;
              end;
              ButtonGroup.Add(ButtonData);
            except
              ButtonData.Free;
            end;
          end;

        finally
          GlobalUnlock(Medium.hGlobal);
          CIDAList.Free;
          PIDLList.Free;
          DesktopFolder := nil;
        end;


      finally
        ReleaseStgMedium(Medium);
      end;
    end;

    // ファイル一覧はあるがPIDLにないファイルを追加
    for i := 0 to FileList.Count - 1 do
    begin
      ButtonData := TNormalButton.Create;
      try
        FileNameToNormalButton(FileList[i], TNormalButton(ButtonData));
        ButtonGroup.Add(ButtonData);
      except
        ButtonData.Free;
      end;
    end;

  finally
    FileList.Free;
  end;
end;

// データオブジェクトからボタンをボタングループに追加する
procedure DataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
begin
  // ButtonGroup
  if ButtonGroupDataObjectToButtonGroup(DataObject, ButtonGroup) then
    Exit;

  // Url
  if UrlDataObjectToButtonGroup(DataObject, ButtonGroup) then
    Exit;

  // ファイル
  FileDataObjectToButtonGroup(DataObject, ButtonGroup);
end;

function ButtonGroupInClipbord: Boolean;
var
  DataObject: IDataObject;
  i: Integer;
  FormatEtc: array[0..4] of TFormatEtc;
begin
  Result := False;
  if OleGetClipboard(DataObject) = S_OK then
  begin
    for i := 0 to 4 do
    begin
      with FormatEtc[i] do
      begin
        dwAspect := DVASPECT_CONTENT;
        ptd := nil;
        tymed := TYMED_HGLOBAL;
        lindex := -1;
      end;
    end;
    FormatEtc[0].cfFormat := CF_SLBUTTONS;
    FormatEtc[1].cfFormat := CF_HDROP;
    FormatEtc[2].cfFormat := CF_IDLIST;
    FormatEtc[3].cfFormat := CF_SHELLURL;
    FormatEtc[4].cfFormat := CF_NETSCAPEBOOKMARK;

    for i := 0 to 4 do
    begin
      Result := DataObject.QueryGetData(FormatEtc[i]) = S_OK;
      if Result then
        Break;
    end;
  end;
end;

function DataObjectIsButtonGroup(DataObject: IDataObject): Boolean;
var
  FormatEtc:  TFormatEtc;
  Ret: Integer;
begin
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Ret := DataObject.QueryGetData(FormatEtc);
  Result := Ret = S_OK;

  if Result then
  begin
    // なぜか Outlook は CF_SLBUTTONS も含まれるのでファイルの場合は False にする
    with FormatEtc do
    begin
      cfFormat := CF_HDROP;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    Ret := DataObject.QueryGetData(FormatEtc);
    Result := Ret <> S_OK;
  end;

end;

function DataObjectIsFileName(DataObject: IDataObject; FindFile: Boolean): Boolean;
var
  FormatEtc:  TFormatEtc;

  Medium: TStgMedium;
  FileList: TStringList;
  DropFiles: PDropFiles;
  pFileName: PChar;
  FileName: String;

  i: Integer;
  FindData: TWIN32FindData;
  FindHandle: THandle;

begin
  with FormatEtc do
  begin
    cfFormat := CF_HDROP;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Result := DataObject.QueryGetData(FormatEtc) = S_OK;

  if FindFile and Result then
  begin
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      FileList := TStringList.Create;
      try
        DropFiles := PDropFiles(GlobalLock(Medium.hGlobal));
        try
          pFileName := PChar(DropFiles) + DropFiles^.pFiles;
          while (pFileName^ <> #0) do
          begin
            if (DropFiles^.fWide) then // -> NT4 & Asian compatibility
            begin
              FileName := PWideChar(pFileName);
              Inc(pFileName, (Length(PWideChar(pFileName)) + 1) * 2);
            end
            else
            begin
              FileName := pFileName;
              Inc(pFileName, Length(pFileName) + 1);
            end;
            FileName := AnsiUpperCase(GetDosName(FileName));
            if FileName <> '' then
              FileList.Add(FileName);
          end;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;

        if FileList.Count = 0 then
          Result := False;

        for i := 0 to FileList.Count - 1 do
        begin
          if FileList[i] <> '' then
          begin
            FindHandle := FindFirstFile(PChar(FileList[i]), FindData);
            if FindHandle = INVALID_HANDLE_VALUE then
            begin
              Result := False;
              Break;
            end;
            Windows.FindClose(FindHandle);
          end;
        end;

      finally
        FileList.Free;
        ReleaseStgMedium(Medium);
      end;
    end;


  end;
end;

function DataObjectIsUrl(DataObject: IDataObject): Boolean;
var
  FormatEtc:  TFormatEtc;
begin
  with FormatEtc do
  begin
    cfFormat := CF_SHELLURL;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Result := DataObject.QueryGetData(FormatEtc) = S_OK;
  if not Result then
  begin
    with FormatEtc do
    begin
      cfFormat := CF_NETSCAPEBOOKMARK;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    Result := DataObject.QueryGetData(FormatEtc) = S_OK;
  end;
end;

initialization
  // Special Launchオリジナル
  CF_SLBUTTONS := RegisterClipboardFormat('Special Launch Buttons');
  // NewShell用
  CF_IDLIST := RegisterClipboardFormat(CFSTR_SHELLIDLIST);
//  CF_FILENAMEMAP := RegisterClipboardFormat(CFSTR_FILENAMEMAPA);
//  CF_FILENAMEMAPW := RegisterClipboardFormat(CFSTR_FILENAMEMAPW);
  CF_FILEGROUPDESCRIPTORA := RegisterClipboardFormat(CFSTR_FILEDESCRIPTORA);
  CF_SHELLURL := RegisterClipboardFormat(CFSTR_SHELLUrl);
  // Netscape用
  CF_NETSCAPEBOOKMARK := RegisterClipboardFormat('Netscape Bookmark');
end.
