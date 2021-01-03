unit ComLine;

interface

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, SetBtn, Dialogs,
  SysUtils, BtnPro, SetInit, SetPads, OleBtn, ActiveX;

type
  TdlgComLine = class(TForm)
    lblName: TLabel;
    cmbName: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    btnBrowse: TButton;
    dlgBrowse: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure cmbNameChange(Sender: TObject);
  private
    FDropTarget: TDropTarget;
    function RunComLine: Boolean;
    function GetDropEnabled: Boolean;
    procedure SetDropEnabled(Value: Boolean);
    procedure OleDragEnter(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragOver(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragDrop(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragLeave;
  public
    property DropEnabled: Boolean Read GetDropEnabled write SetDropEnabled;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgComLine: TdlgComLine;

implementation

{$R *.DFM}

procedure DevideComLine(ComLine: String; var FileName, Option: String);
var
  s, Work: String;
  SepStr: String;
  SepCol: Integer;
begin
  s := Trim(ComLine);
  FileName := '';
  Option := '';

  if Copy(s, 1, 1) = '"' then
    SepStr := '" '
  else
    SepStr := ' ';

  Work := Copy(s, 2, MaxInt);
  SepCol := Pos(SepStr, Work) + 1;
  if SepCol > 1 then
  begin
    FileName := Copy(s, 1, SepCol);
    Option := Copy(s, SepCol + 1, MaxInt);
  end
  else
    FileName := s;

  FileName := Trim(FileName);
  Option := Trim(Option);
end;

// CreateParams
procedure TdlgComLine.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

// フォーム始め
procedure TdlgComLine.FormCreate(Sender: TObject);
var
  Hist: String;
  i: Integer;
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  i := 0;
  cmbName.Items.Clear;
  while cmbName.Items.Count <= 32 do
  begin
    Hist := UserIniFile.ReadString(IS_COMMANDLINE, IntToStr(i), '');
    if Hist = '' then
      Break;
    cmbName.Items.Add(Hist);
    Inc(i);
  end;
  if cmbName.Items.Count > 0 then
    cmbName.ItemIndex := 0;
  cmbNameChange(cmbName);

  DropEnabled := True;
end;

// フォーム終わり
procedure TdlgComLine.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  DropEnabled := False;
  dlgComLine := nil;

  if not UserIniReadOnly then
  begin
    UserIniFile.EraseSection(IS_COMMANDLINE);
    UserIniFile.UpdateFile;
    for i := 0 to cmbName.Items.Count - 1 do
      UserIniFile.WriteString(IS_COMMANDLINE, IntToStr(i), cmbName.Items[i]);
  end;
end;

// フォーム閉じる
procedure TdlgComLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// コマンドライン
procedure TdlgComLine.cmbNameChange(Sender: TObject);
var
  ComLine: String;
begin
  ComLine := Trim(cmbName.Text);
  btnOk.Enabled := ComLine <> '';
end;

// OKボタン
procedure TdlgComLine.btnOkClick(Sender: TObject);
begin
  if RunComLine then
    Close;
end;

// キャンセルボタン
procedure TdlgComLine.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// コマンドライン実行
function TdlgComLine.RunComLine: Boolean;
var
  NormalButton: TNormalButton;
  FileName, Option: String;
  ComLine: String;
  i: Integer;
begin
  Result := False;

  ComLine := Trim(cmbName.Text);
  if ComLine = '' then
    Exit;

  DevideComLine(ComLine, FileName, Option);

  NormalButton := TNormalButton.Create;
  try
    NormalButton.FileName := FileName;
    NormalButton.Option := Option;
    Result := OpenNormalButton(GetDesktopWindow, NormalButton);

    if Result then
    begin
      i := cmbName.Items.IndexOf(ComLine);
      if i >= 0 then
        cmbName.Items.Delete(i);
      cmbName.Items.Insert(0, ComLine);

      while cmbName.Items.Count > 32 do
        cmbName.Items.Delete(cmbName.Items.Count - 1);
    end;


  finally
    NormalButton.Free;
  end;
end;

// 参照ボタン
procedure TdlgComLine.btnBrowseClick(Sender: TObject);
var
  Ext: string;
  NormalButton: TNormalButton;
begin
  if FileExists(cmbName.Text) then
  begin
    dlgBrowse.FileName := cmbName.Text;
    dlgBrowse.InitialDir := ExtractFileDir(cmbName.Text);
    Ext := ExtractFileExt(cmbName.Text);
    Ext := AnsiLowerCase(Ext);
    if Ext = '.exe' then
      dlgBrowse.FilterIndex := 1
    else
      dlgBrowse.FilterIndex := 2;
  end;

  if dlgBrowse.Execute then
  begin
    NormalButton := TNormalButton.Create;
    try
      FileNameToNormalButton(dlgBrowse.FileName, NormalButton);
      if Pos(' ', NormalButton.FileName) = 0 then
        cmbName.Text := NormalButton.FileName
      else
        cmbName.Text := '"' + NormalButton.FileName + '"';

      if NormalButton.Option <> '' then
      begin
        if cmbName.Text <> '' then
          cmbName.Text := cmbName.Text + ' ';
        cmbName.Text := cmbName.Text + NormalButton.Option;
      end;

      cmbNameChange(cmbName);
    finally
      NormalButton.Free;
    end;

    cmbName.SetFocus;
  end;
end;



// ドロップ受付
function TdlgComLine.GetDropEnabled: Boolean;
begin
  Result := FDropTarget <> nil;
end;

// ドロップ受付
procedure TdlgComLine.SetDropEnabled(Value: Boolean);
var
  FormatEtc: array[0..3] of TFormatEtc;
  i: Integer;
begin
  if DropEnabled = Value then
    Exit;

  if Value then
  begin
    for i := 0 to 3 do
    begin
      with FormatEtc[i] do
      begin
        dwAspect := DVASPECT_CONTENT;
        ptd := nil;
        tymed := TYMED_HGLOBAL;
        lindex := -1;
      end;
    end;
    FormatEtc[0].cfFormat := CF_HDROP;
    FormatEtc[1].cfFormat := CF_IDLIST;
    FormatEtc[2].cfFormat := CF_SHELLURL;
    FormatEtc[3].cfFormat := CF_NETSCAPEBOOKMARK;

    FDropTarget := TDropTarget.Create(@FormatEtc, 4);
    FDropTarget.OnDragEnter := OleDragEnter;
    FDropTarget.OnDragOver := OleDragOver;
    FDropTarget.OnDragLeave := OleDragLeave;
    FDropTarget.OnDragDrop := OleDragDrop;

    CoLockObjectExternal(FDropTarget, True, False);
    RegisterDragDrop(Handle, FDropTarget);
  end
  else
  begin
    RevokeDragDrop(Handle);
    CoLockObjectExternal(FDropTarget, False, True);
    FDropTarget := nil;
  end;
end;

// ドラッグ入る
procedure TdlgComLine.OleDragEnter(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
begin
  dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;
end;

// ドラッグオーバー
procedure TdlgComLine.OleDragOver(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
begin
  dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;
end;


// ドラッグ離れる
procedure TdlgComLine.OleDragLeave;
begin
end;

// ドラッグドロップ
procedure TdlgComLine.OleDragDrop(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
var
  DropButtons: TButtonGroup;
  NormalButton: TNormalButton;
  AddText: String;
begin
  SetForegroundWindow(Handle);

  DropButtons := TButtonGroup.Create;
  try
    DataObjectToButtonGroup(DataObject, DropButtons);

    dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;

    if DropButtons.Count > 0 then
    begin
      if DropButtons[0] is TNormalButton then
      begin
        NormalButton := TNormalButton(DropButtons[0]);
        if Pos(' ', NormalButton.FileName) = 0 then
          AddText := NormalButton.FileName
        else
          AddText := '"' + NormalButton.FileName + '"';
        if (cmbName.Text <> '') and (AddText <> '') then
          cmbName.Text := cmbName.Text + ' ';
        cmbName.Text := cmbName.Text + AddText;
        cmbNameChange(cmbName);
      end;
    end;
  finally
    DropButtons.Clear(True);
    DropButtons.Free;
  end;
end;


end.
