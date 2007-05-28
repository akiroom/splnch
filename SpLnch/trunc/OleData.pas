unit OleData;

interface

uses
  Windows, ActiveX, Classes, ShellAPI, ShlObj, SysUtils;

type
  PFormatList = ^TFormatList;
  TFormatList = array[0..0] of TFormatEtc;

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;
    FIndex: Integer;
  public
    constructor Create(FormatList: PFormatList;
      FormatCount, Index: Integer);
    { IEnumFormatEtc で定義されているメソッド                        }
    function Next(celt: Longint; out elt; pceltFetched: PLongint):
      HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enum: IEnumFormatEtc): HResult; stdcall;
  end;

  TDataObject = class(TInterfacedObject, IDataObject)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;

    { IDataObject で定義されているメソッド                           }
    function GetData(const formatetcIn: TFormatEtc;
      out medium: TStgMedium): HResult; virtual; stdcall;
    function GetDataHere(const formatetc: TFormatEtc;
      out medium: TStgMedium): HResult; virtual; stdcall;
    function QueryGetData(const formatetc: TFormatEtc): HResult;
      virtual; stdcall;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
      out formatetcOut: TFormatEtc): HResult; virtual; stdcall;
    function SetData(const formatetc: TFormatEtc;
      var medium: TStgMedium; fRelease: BOOL): HResult; virtual;
      stdcall;
    function EnumFormatEtc(dwDirection: Longint; out enumFormatEtc:
      IEnumFormatEtc): HResult; virtual; stdcall;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint;
      const advSink: IAdviseSink; out dwConnection: Longint): HResult;
      virtual; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; virtual;
      stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult;
      virtual; stdcall;
  protected
    function GetMedium(const FormatEtc: TFormatEtc; var Medium: TStgMedium;
      CreateMedium: Boolean): HResult; virtual; abstract;
  public
    constructor Create(AFormatList: PFormatList;
      AFormatCount: Integer);
    destructor Destroy; override;
  end;

implementation

// IEnumFormatEtc
constructor TEnumFormatEtc.Create(FormatList: PFormatList;
  FormatCount, Index: Integer);
begin
  inherited Create;
  FFormatList := FormatList;
  FFormatCount := FormatCount;
  FIndex := Index;
end;

// 現在のインデックスからスタートして指定された数の FORMATETC 構造体を返します
function TEnumFormatEtc.Next(celt: Longint; out elt;
  pceltFetched: PLongint): HResult;
var
  I: Integer;
begin
  I := 0;
  // FORMATETC 構造体を celt 個列挙する
  while (I < celt) and (FIndex < FFormatCount) do
  begin
    TFormatList(elt)[I] := FFormatList[FIndex];
    Inc(FIndex);
    Inc(I);
  end;
  // 列挙した数を返す
  if pceltFetched <> nil then
    pceltFetched^ := I;
  // 要求された FORMATETC 構造体の数と、列挙した数が同じなら S_OK
  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

// このメソッドは、指定された数だけFORMATETC 構造体のリストをスキップします。
function TEnumFormatEtc.Skip(celt: Longint): HResult;
begin
  if celt <= FFormatCount - FIndex then
  begin
    FIndex := FIndex + celt;
    Result := S_OK;
  end else
  begin
    FIndex := FFormatCount;
    Result := S_FALSE;
  end;
end;

function TEnumFormatEtc.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

function TEnumFormatEtc.Clone(out enum: IEnumFormatEtc): HResult;
begin
  enum := TEnumFormatEtc.Create(FFormatList, FFormatCount, FIndex);
  Result := S_OK;
end;

// IDataObject の実装例                                               }
constructor TDataObject.Create(AFormatList: PFormatList;
  AFormatCount: Integer);
var
  CopySize: Integer;
begin
  inherited Create;
  { オブジェクト内部に TFormatEtc 構造体のリストのコピーを確保する。 }
  FFormatCount := AFormatCount;
  CopySize := SizeOf(TFormatList) * FFormatCount;
  GetMem(FFormatList, CopySize);
  CopyMemory(FFormatList, AFormatList, CopySize);
end;

destructor TDataObject.Destroy;
begin
  { オブジェクト内部に確保した TFormatEtc 構造体のリストを解放する。 }
  FreeMem(FFormatList);
  inherited Destroy;
end;

{ 指定記憶メディアを使って指定形式のデータを展開する。               }
function TDataObject.GetData(
  const formatetcIn: TFormatEtc;    { データを戻すために使う形式     }
  out medium: TStgMedium            { 記憶メディアへのポインタ       }
  ): HResult; stdcall;
begin
  { 初期値：指定されたメディアはサポートできません                   }
  Result := DV_E_FORMATETC;

  { 構造体の初期化                                                   }
  medium.tymed := 0;
  medium.hGlobal := 0;
  medium.UnkForRelease := nil;

  try
    { サポート可能な形式であるかを確認する                           }
    if (S_OK = QueryGetData(formatetcIn)) then
      { 転送メディアは TDataObject から派生したクラスが作成する。    }
      Result := GetMedium(formatetcIn, medium, TRUE);
  except
    { エラーが発生した場合。                                         }
    Result := E_UNEXPECTED;
  end;
end;

{ 指定された確保済み記憶媒体にデータを展開する                       }
function TDataObject.GetDataHere(const formatetc: TFormatEtc;
  out medium: TStgMedium): HResult; stdcall;
begin
  { 初期値：指定されたメディアはサポートできません                   }
  Result := DV_E_FORMATETC;         { = DATA_E_FORMATETC (Win16)     }
  try
    { サポート可能な形式であるかを確認する                           }
    if (S_OK = QueryGetData(formatetc)) then
      { 転送メディアは TDataObject から派生したクラスが作成する。    }
      Result := GetMedium(formatetc, medium, FALSE);
  except
    { エラーが発生した場合。                                         }
    Result := E_UNEXPECTED;
  end;
end;

{ formatetc を GetData に渡した場合、処理が成功するかを判断する。　　}
function TDataObject.QueryGetData(
  const formatetc: TFormatEtc         { データを受け取るための形式   }
  ): HResult; stdcall;
var
  i: integer;
begin
  { 初期値：指定されたメディアはサポートできない }
  Result := DV_E_FORMATETC;

  { オブジェクト内部に確保した TFormatEtc 構造体のリストと比較する。 }
  for i := 0 to FFormatCount - 1 do
    if (formatetc.cfFormat = FFormatList^[i].cfFormat) and
       (formatetc.dwAspect = FFormatList^[i].dwAspect) and
       Bool(formatetc.tymed and FFormatList^[i].tymed) then
      begin
        Result := NOERROR;
        Break;
      end;
end;

{ 表示デバイスに固有な展開処理を行なわない場合の実装例               }
function TDataObject.GetCanonicalFormatEtc(
  const formatetc: TFormatEtc; out formatetcOut: TFormatEtc): HResult;
  stdcall;
begin
  formatetcOut := formatetc;
  formatetcOut.ptd := nil;
  Result := DATA_S_SAMEFORMATETC;
end;

{ この実装例においては、この関数はサポートしない                     }
function TDataObject.SetData(
  const formatetc: TFormatEtc;
  var medium: TStgMedium;
  fRelease: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

{ GetData メソッドでデータを取得するために利用可能な形式を列挙する。 }
function TDataObject.EnumFormatEtc(
  dwDirection: Longint;               { データをやり取りする方向     }
  out enumFormatEtc: IEnumFormatEtc   { 列挙オブジェクトのｲﾝﾀﾌｪｰｽ    }
  ): HResult; stdcall;
begin
  Result := E_NOTIMPL;
  enumFormatEtc := nil;

  if dwDirection = DATADIR_GET then
  begin
    { TFormatEtc 構造体から IEnumFormatEtc インタフェースを持つ      }
    { オブジェクトを作成する                                         }
    enumFormatEtc :=
      TEnumFormatEtc.Create(FFormatList, FFormatCount, 0);
    if Assigned(enumFormatEtc) then
      Result := S_OK;
  end
end;

{ この関数はサポートしない                                           }
function TDataObject.DAdvise(const formatetc: TFormatEtc;
  advf: Longint; const advSink: IAdviseSink;
  out dwConnection: Longint): HResult; stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

{ この関数はサポートしない                                           }
function TDataObject.DUnadvise(dwConnection: Longint): HResult;
  stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

{ この関数はサポートしない                                           }
function TDataObject.EnumDAdvise(out enumAdvise: IEnumStatData):
  HResult; stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

initialization
  OleInitialize(nil);               { OLE ライブラリの初期化を行う   }
finalization
  OleFlushClipboard;
  OleUninitialize;                  { OLE ライブラリの初期化を解除   }
end.
