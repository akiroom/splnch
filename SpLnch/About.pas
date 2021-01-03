unit About;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, StdCtrls, Classes, ExtCtrls;


type
  TdlgAbout = class(TForm)
    lblVersion: TLabel;
    lblName: TLabel;
    btnOk: TButton;
    memExplanation: TMemo;
    lblInfo: TLabel;
    Bevel1: TBevel;
    lblFileName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    procedure CreateParams(var Params: TCreateParams); override;
  end;


var
  dlgAbout: TdlgAbout;

  OSVersionInfo: TOSVersionInfo;


procedure ShowAbout(Name, FileName, Explanation: string);
function GetFileVersionString(FileName: string; Long: Boolean): string;
function GetFileVersion(FileName: string; var Mj, Mn, Rl, Bl: Cardinal): Boolean;



implementation

{$R *.DFM}

// バージョン情報表示
procedure ShowAbout(Name, FileName, Explanation: string);
begin
  if dlgAbout = nil then
    dlgAbout := TdlgAbout.Create(nil);
  dlgAbout.lblName.Caption := Name;
  dlgAbout.lblFileName.Caption := FileName;
  dlgAbout.lblVersion.Caption := GetFileVersionString(FileName, True);
  dlgAbout.memExplanation.Text := Explanation;
  dlgAbout.Show;
end;

// ファイルバージョン取得
function GetFileVersionString(FileName: string; Long: Boolean): string;
var
  Work: Cardinal;
  VerInfo: Pointer;
  VerInfoSize: Cardinal;
  FileInfo: PVSFixedFileInfo;
  FileInfoSize: Cardinal;

  Mj, Mn, Rl, Bl: Cardinal;
begin
  Result := '';
  Work := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Work);
  if VerInfoSize <> 0 then
  begin

    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', Pointer(FileInfo), FileInfoSize) then
        begin
          Mj := HiWord(FileInfo^.dwProductVersionMS);
          Mn := LoWord(FileInfo^.dwProductVersionMS);
          Rl := HiWord(FileInfo^.dwProductVersionLS);
          Bl := LoWord(FileInfo^.dwProductVersionLS);

          if Long then
            Result := Format('%d.%d.%d Build %d', [Mj, Mn, Rl, Bl])
          else
            Result := Format('%d.%d.%d.%d', [Mj, Mn, Rl, Bl]);

          if (FileInfo^.dwFileFlags and VS_FF_PRERELEASE) <> 0 then
            Result := Result + ' Prerelease';
        end;
      end;

    finally
      FreeMem(VerInfo);
    end;

  end;
end;

function GetFileVersion(FileName: string; var Mj, Mn, Rl, Bl: Cardinal): Boolean;
var
  Work: Cardinal;
  VerInfo: Pointer;
  VerInfoSize: Cardinal;
  FileInfo: PVSFixedFileInfo;
  FileInfoSize: Cardinal;
begin
  Result := False;
  Work := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Work);
  if VerInfoSize <> 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', Pointer(FileInfo), FileInfoSize) then
        begin
          Mj := HiWord(FileInfo^.dwProductVersionMS);
          Mn := LoWord(FileInfo^.dwProductVersionMS);
          Rl := HiWord(FileInfo^.dwProductVersionLS);
          Bl := LoWord(FileInfo^.dwProductVersionLS);
          Result := True;
        end;
      end;

    finally
      FreeMem(VerInfo);
    end;

  end;
end;

// CreateParams
procedure TdlgAbout.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

// フォームはじめ
procedure TdlgAbout.FormCreate(Sender: TObject);
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);
end;

// フォーム終わり
procedure TdlgAbout.FormDestroy(Sender: TObject);
begin
  dlgAbout := nil;
end;

// 閉じる
procedure TdlgAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// OKボタン
procedure TdlgAbout.btnOkClick(Sender: TObject);
begin
  Close;
end;

initialization
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(OSVersionInfo);
end.
