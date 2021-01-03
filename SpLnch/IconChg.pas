unit IconChg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SetIcons, ShlObj;


type
  TdlgIconChange = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    btnBrowse: TButton;
    lstIcon: TListBox;
    dlgBrowse: TOpenDialog;
    procedure lstIconDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    FIconFile: string;
    FItemIDList: PItemIDList;
    procedure SetIconFile(const Value: string);
    procedure SetItemIDList(const Value: PItemIDList);
    procedure DeleteIcons;
  public
    property IconFile: string read FIconFile write SetIconFile;
    property ItemIDList: PItemIDList read FItemIDList write SetItemIDList;
  end;

var
  dlgIconChange: TdlgIconChange;

implementation

{$R *.DFM}

{ TdlgIconChange }

// フォーム終わり
procedure TdlgIconChange.FormDestroy(Sender: TObject);
begin
  DeleteIcons;
end;

// アイコン削除
procedure TdlgIconChange.DeleteIcons;
var
  i: Integer;
begin
  for i := 0 to lstIcon.Items.Count - 1 do
    TIcon(lstIcon.Items.Objects[i]).Free;
  lstIcon.Clear;
end;

// アイコンセット
procedure TdlgIconChange.SetIconFile(const Value: string);
var
  Icon: TIcon;
  LIcon, SIcon: HIcon;
  i: Integer;
begin
  if FIconFile = Value then
    Exit;

  ItemIDList := nil;
  DeleteIcons;
  i := 0;
  while True do
  begin
    if not GetIconHandle(PChar(Value), ftIconPath, i, LIcon, SIcon) then
      Break;
    Icon := TIcon.Create;
    Icon.Handle := LIcon;
    DestroyIcon(SIcon);
    lstIcon.Items.AddObject('', Icon);
    Inc(i);
  end;
  if lstIcon.Items.Count > 0 then
    lstIcon.ItemIndex := 0;

  FIconFile := Value;
end;

// 項目識別子セット
procedure TdlgIconChange.SetItemIDList(const Value: PItemIDList);
var
  Icon: TIcon;
  LIcon, SIcon: HIcon;
begin
  if FItemIDList = Value then
    Exit;

  IconFile := '';
  DeleteIcons;
  if Value <> nil then
  begin
    if GetIconHandle(Value, ftPIDL, 0, LIcon, SIcon) then
    begin
      Icon := TIcon.Create;
      Icon.Handle := LIcon;
      DestroyIcon(SIcon);
      lstIcon.Items.AddObject('', Icon);
      lstIcon.ItemIndex := 0;
    end;
  end;
  FItemIDList := Value;
end;

// アイコン描画
procedure TdlgIconChange.lstIconDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  icoWrk: TIcon;
  x: Integer;
begin
  with (Control as TListBox),Canvas do
  begin
    FillRect(Rect);
    icoWrk := TIcon(Items.Objects[Index]);
    if icoWrk <> nil then
    begin
      x := Rect.Left + (Rect.Right - Rect.Left - 32) div 2;
      Draw(x, Rect.Top + 1, icoWrk);
    end;
  end;
end;

// 参照
procedure TdlgIconChange.btnBrowseClick(Sender: TObject);
var
  Ext: string;
begin
  with dlgBrowse do
  begin
    if FileExists(IconFile) then
    begin
      FileName := IconFile;
      InitialDir := ExtractFileDir(IconFile);
      Ext := ExtractFileExt(IconFile);
      Ext := AnsiLowerCase(Ext);
      if (Ext = '.exe') or (Ext = '.ico') or (Ext = '.dll') or (Ext = '.icl') then
        FilterIndex := 1
      else
        FilterIndex := 2;
    end;

    if Execute then
      IconFile := FileName
  end;
end;

end.
 