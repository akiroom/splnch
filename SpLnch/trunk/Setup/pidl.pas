{-----------------------------------------------------------------------------}
{                                                                             }
{  「Delphi によるシェルプログラミング入門」サンプルプログラム                }
{                                                                             }
{  「項目識別子に対する処理」の実装例                                         }
{                                                                             }
{   Copyright 1998 Masahiro Arai                                              }
{                                                                             }
{-----------------------------------------------------------------------------}
unit pidl;

interface

uses
  Windows, SysUtils, ShellAPI, ShlObj, ActiveX, Classes;

// 項目識別子（リスト）を格納するためのメモリを確保する
function AllocItemID  (Size: integer): PItemIDList;

// 項目識別子（リスト）のサイズを求める
function GetItemIDSize(ItemIDList: PItemIDList): integer;

// 項目識別子（リスト）のコピーを作成する
function CopyItemID   (ItemIDList: PItemIDList): PItemIDList;

// 項目識別子（リスト）を連結して新しい項目識別子を作成する
function ConcatItemID (ItemIDList1, ItemIDList2: PItemIDList):
  PItemIDList;

// 項目識別子リスト中の「次の項目識別子」を見つける
function GetNextItemID(ItemIDList: PItemIDList): PItemIDList;

// 項目識別子（リスト）を表す文字列を取得する
function GetItemIDName(Folder: IShellFolder; ItemID: PItemIDList;
  Flags: integer): string;

// 項目識別子（リスト）を表すアイコンのインデックスを取得する
function GetItemIDIcon(ItemIDList: PItemIDList; Flags: integer):
  integer;

// ２つの項目識別子を比較する
function CompareItemID(ShellFolder: IShellFolder;
  ItemID1, ItemID2: PItemIDList): Integer;

// 項目識別子リストに含まれる項目識別子をリストアップする
// ※リスト内の各要素は、シェルメモリーアロケーターによって解放すること
function DivItemIDList(ItemIDList: PItemIDList): TList;

var
  Malloc: IMalloc;

implementation

// 項目識別子（リスト）を格納するためのメモリを確保する
function AllocItemID(Size: integer): PItemIDList;
var
  ItemIDList: PItemIDList;
begin

  // 項目識別子（リスト）を格納するためのメモリを確保
  ItemIDList := Malloc.Alloc(Size);
  // 取得したメモリの内容を初期化
  if Assigned(ItemIDList) then
    FillChar(ItemIDList^, Size, 0);
  Result := ItemIDList;
end;

// 項目識別子（リスト）のサイズを求める
function GetItemIDSize(ItemIDList: PItemIDList): integer;
var
  Total: integer;
begin
  Total := 0;
  if Assigned(ItemIDList) then
  begin
    // 項目識別子を順番に検索する
    while (ItemIDList^.mkid.cb > 0) do
    begin
      inc(Total, ItemIDList^.mkid.cb);
      ItemIDList := GetNextItemID(ItemIDList);
    end;
    // 項目識別子リストの最後に加わるターミネーターの大きさを加算
    Total := Total + SizeOf(ItemIDList^.mkid.cb);
  end;
  Result := Total;
end;

// 項目識別子（リスト）のコピーを作成する
// ※受け取った項目識別子（リスト）は Malloc.Free(ItemID) を用いて
//   破棄しなければならない
function CopyItemID(ItemIDList: PItemIDList): PItemIDList;
var
  NewItemID: PItemIDList;
  CopySize: integer;
begin
  // 「空の項目識別子」はコピーしない
  Result := nil;
  if not Assigned(ItemIDList) then
    Exit;

  // 項目識別子リストの大きさを取得
  CopySize := GetItemIDSize(ItemIDList);
  // メモリを確保
  NewItemID := AllocItemID(CopySize);
  // 項目識別子リストのコピー
  Move(ItemIDList^, NewItemID^, CopySize);
  Result := NewItemID;
end;

// 項目識別子（リスト）を連結して新しい項目識別子を作成する
// ※受け取った項目識別子（リスト）は Malloc.Free(ItemID) を用いて
//   破棄しなければならない
function ConcatItemID(ItemIDList1, ItemIDList2: PItemIDList):
  PItemIDList;
var
  NewItemIDlist: PChar;
  ItemSize1, ItemSize2: integer;
begin
  // コピーを行うサイズを取得
  if Assigned(ItemIDList1) then
    // ターミネーターはコピーしない
    ItemSize1 := GetItemIDSize(ItemIDList1)
      - SizeOf(ItemIDList1^.mkid.cb)
  else
    Itemsize1 := 0;
  ItemSize2 := GetItemIDSize(ItemIDList2);

  // 新しい項目識別子リストを格納するメモリの取得
  NewItemIDList := PChar(AllocItemID(ItemSize1 + ItemSize2));

  // NewItemIDList は以下の処理で加工するので、戻り値を予め設定する。
  Result := PItemIDList(NewItemIDList);

  // 項目識別子（リスト）のコピー
  if Assigned(NewItemIDList) then
  begin
    if Assigned(ItemIDList1) then
      Move(ItemIDList1^, NewItemIDList^, ItemSize1);
    // ポインタのオフセットを行う
    inc(NewItemIDList, ItemSize1);

    Move(ItemIDList2^, NewItemIDList^, ItemSize2);
  end;
end;

// 項目識別子（リスト）を表す文字列を取得する
function GetItemIDName(Folder: IShellFolder; ItemID: PItemIDList;
  Flags: integer): string;
var
  StrRet:  TStrRet;
  Chars:   PChar;
begin
  Result := '';
  if (NOERROR = Folder.GetDisplayNameOf(ItemID, Flags, StrRet)) then
  begin
    case StrRet.uType of
      STRRET_WSTR:
      begin
        //PWideChar から string へのコピー
        Result := StrRet.pOleStr;
      end;

      STRRET_OFFSET:
      begin
        //ポインタのオフセット
        Chars := PChar(ItemID);
        inc(Chars, StrRet.uOffset);
        //PChar から string へのコピー
        Result := Chars;
      end;

      STRRET_CSTR:
        //PChar から string へのコピー
        Result := StrRet.cStr;
    end;
  end;
end;

// 項目識別子リスト中の「次の項目識別子」を見つける
function GetNextItemID(ItemIDList: PItemIDList): PItemIDList;
var
  NextItemID: PChar;
begin
  // inc を用いてオフセットを行うために PChar 型にキャストする
  NextItemID := PChar(ItemIDList);

  // ポインタのオフセットを行い、次の要素を指す
  inc(NextItemID, ItemIDList^.mkid.cb);

  if ItemIDList^.mkid.cb = 0 then
    Result := nil
  else
    Result := PItemIDList(NextItemID);
end;

// 項目識別子（リスト）を表すアイコンのインデックスを取得する
function GetItemIDIcon(ItemIDList: PItemIDList; Flags: integer):
  integer;
var
  SHFileInfo: TSHFileInfo;
begin
  SHGetFileInfo(pchar(ItemIDList), 0, SHFileInfo, Sizeof(TSHFileInfo),
    SHGFI_PIDL or Flags);
  Result := SHFileInfo.iIcon;
end;

// 項目識別子を比較する
function CompareItemID(ShellFolder: IShellFolder;
  ItemID1, ItemID2: PItemIDList): Integer;
begin
  Result := SHORT($FFFF and ShellFolder.CompareIDs(0, ItemID1, ItemID2));
end;

// 項目識別子リストに含まれる項目識別子をリストアップする
// ※リスト内の各要素は、シェルメモリーアロケーターによって解放すること
function DivItemIDList(ItemIDList: PItemIDList): TList;
var
  ItemSize: Integer;
  NewItemID: PItemIDList;
begin
  Result := TList.Create;
  while Assigned(ItemIDList) do
  begin
    // リスト内の各要素のサイズを取得する
    ItemSize := ItemIDList^.mkid.cb;
    // 要素がヌルターミネーターであれば処理を終了
    if ItemSize = 0 then
      Exit;
    // 一階層分の項目を抽出する
    NewItemID := AllocItemID(ItemSize+SizeOf(ItemIDList^.mkid.cb));
    Move(ItemIDList^, NewItemID^, ItemSize);
    Result.Add(NewItemID);
    // 次の項目を指す
    ItemIDList := GetNextItemID(ItemIDList)
  end;
end;

initialization
  //シェル・メモリ・アロケーターを確保する
  SHGetMalloc(Malloc);
finalization
  Malloc := nil;
end.

