unit MemCheck;

interface

uses Windows, SysUtils;

implementation

var
  GetMemCount: Integer;
  OldMemMgr: TMemoryManager;

function NewGetMem(Size: Integer): Pointer;
begin
  if Size>0 then Inc(GetMemCount);
  Result := OldMemMgr.GetMem(Size);
end;

function NewFreeMem(P: Pointer): Integer;
begin
  if P<>nil then Dec(GetMemCount);
  Result := OldMemMgr.FreeMem(P);
end;

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  if (Size=0) and (P<>nil) then
  begin
    Dec(GetMemCount);
  end else if (Size>0) and (P<>nil) then
  begin
    Dec(GetMemCount);
    Inc(GetMemCount);
  end else
    Inc(GetMemCount);

  Result := OldMemMgr.ReallocMem(P, Size);
end;

const
  NewMemMgr: TMemoryManager = (
  GetMem: NewGetMem;
  FreeMem: NewFreeMem;
  ReallocMem: NewReallocMem);

initialization
  GetMemoryManager(OldMemMgr);
  SetMemoryManager(NewMemMgr);
finalization
  SetMemoryManager(OldMemMgr);
  if GetMemCount>0 then
    MessageBox(0, PChar(Format('%d 回メモリーを解放し忘れています', [GetMemCount])), 'メモリーリークエラー', MB_OK or MB_ICONEXCLAMATION);
end.
