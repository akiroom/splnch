unit BtnPro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SetBtn, ImgList, ComCtrls, SetIcons, SetPlug, About,
  ActiveX, ComObj, ShlObj, pidl, IniFiles, ShlObjAdditional;

type
  TdlgBtnProperty = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    dlgBrowse: TOpenDialog;
    tmNormalIconChange: TTimer;
    imlType: TImageList;
    pcKind: TPageControl;
    tabNormal: TTabSheet;
    tabPlugin: TTabSheet;
    cmbNormalWindowSize: TComboBox;
    Label5: TLabel;
    Label3: TLabel;
    edtNormalFolder: TEdit;
    edtNormalOption: TEdit;
    Label4: TLabel;
    btnNormalBrowse: TButton;
    edtNormalFileName: TEdit;
    edtNormalName: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    btnNormalIcon: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    edtPluginName: TEdit;
    cmbPluginType: TComboBox;
    btnPluginOption: TButton;
    btnPluginInfo: TButton;
    edtPluginIDName: TEdit;
    edtPluginFileName: TEdit;
    edtPluginOwnerDraw: TEdit;
    Panel1: TPanel;
    edtClickCount: TEdit;
    udClickCount: TUpDown;
    Label6: TLabel;
    imgPluginIcon: TImage;
    imgNormalIcon: TImage;
    btnNormalRelativePath: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbKindDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure cmbPluginTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbPluginTypeClick(Sender: TObject);
    procedure btnPluginOptionClick(Sender: TObject);
    procedure btnPluginInfoClick(Sender: TObject);
    procedure btnNormalBrowseClick(Sender: TObject);
    procedure tmNormalIconChangeTimer(Sender: TObject);
    procedure edtNormalFileNameChange(Sender: TObject);
    procedure btnNormalIconClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNormalRelativePathClick(Sender: TObject);
  private
    FOnWindowActivate: TNotifyEvent;
    FOnWindowDeactivate: TNotifyEvent;
    FOnApply: TNotifyEvent;
    FOnClosed: TNotifyEvent;
    FNormalItemIDList: PItemIDList;
    FNormalIconFile: string;
    FNormalIconIndex: Integer;
    FAddMode: Boolean;
    function CheckAllItems: Boolean;
    procedure SetNormalItemIDList(const Value: PItemIDList);
    procedure SetNormalIconFile(const Value: string);
    procedure SetNormalIconIndex(const Value: Integer);
    function GetKindIsNormal: Boolean;
    procedure SetKindIsNormal(const Value: Boolean);
  public
    property OnWindowActivate: TNotifyEvent read FOnWindowActivate write FOnWindowActivate;
    property OnWindowDeactivate: TNotifyEvent read FOnWindowDeactivate write FOnWindowDeactivate;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    property OnClosed: TNotifyEvent read FOnClosed write FOnClosed;
    property NormalItemIDList: PItemIDList read FNormalItemIDList write SetNormalItemIDList;
    property NormalIconFile: string read FNormalIconFile write SetNormalIconFile;
    property NormalIconIndex: Integer read FNormalIconIndex write SetNormalIconIndex;
    property AddMode: Boolean read FAddMode;
    property KindIsNormal: Boolean read GetKindIsNormal write SetKindIsNormal;
    procedure SetOriginalButton(ButtonData: TButtonData);
    procedure SetPluginList;
    function CreateResultButton: TButtonData;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  end;

var
  BtnPropertyList: TList; 

const
  BTN_NORMAL = 0;
  BTN_PLUGIN = 1;
  BTN_SPACE = 2;
  BTN_RETURN = 3;
const
  ICO_PLUGIN = 1;

function ExtractFileNameWithoutExt(FileName: string): string;
function GetDosName(LongName: String): String;
function GetShellLinkInfo(const ShortCut: string; var FileName, Option, Folder,
  IconFile: string; var ItemIDList: PItemIDList; var IconIndex, WindowSize: Integer): Boolean;
procedure FileNameToNormalButton(FileName: string; NormalButton: TNormalButton);




implementation

uses IconChg;


{$R *.DFM}

// ファイル名のみを取得
function ExtractFileNameWithoutExt(FileName: string): string;
begin
  Result := ChangeFileExt(ExtractFileName(FileName), '');
end;

// ロングファイル名からＤＯＳファイル名を取得
function GetDosName(LongName: String): String;
var
  ShortName: array[0..2047] of Char;
begin
  if GetShortPathName(PChar(LongName), ShortName, 2048) <> 0 then
    Result := ShortName
  else
    Result := '';
end;



// ショートカットを解析
function GetShellLinkInfo(const ShortCut: string; var FileName, Option, Folder,
  IconFile: string; var ItemIDList: PItemIDList; var IconIndex, WindowSize: Integer): Boolean;
var
  Unknown: IUnknown;
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  ShellLinkDataList: IShellLinkDataList;
  WideShortCut: WideString;
  Win32FindData: TWin32FindData;
  Path, WorkingDirectory, Arguments, IconLocation: array[0..MAX_PATH] of Char;
  ShowCmd: Integer;
  Flags: DWORD;
begin
  Result := False;

  if AnsiLowerCase(ExtractFileExt(ShortCut)) <> '.lnk' then
    Exit;

  Unknown := CreateComObject(CLSID_ShellLink);
  ShellLink := Unknown as IShellLink;
  PersistFile := Unknown as IPersistFile;
  WideShortCut := ShortCut;


  if Succeeded(PersistFile.Load(PWideChar(WideShortCut), STGM_READ)) then
    if Succeeded(ShellLink.Resolve(Application.Handle, SLR_ANY_MATCH)) then
    begin
      Flags := 0;
      try
        ShellLinkDataList := Unknown as IShellLinkDataList;
        if ShellLinkDataList.GetFlags(Flags) <> S_OK then
          Flags := 0;
      except
        Flags := 0;
      end;

      ShellLink.GetPath(Path, MAX_PATH, Win32FindData, SLGP_UNCPRIORITY);
      ShellLink.GetIDList(ItemIDList);
      ShellLink.GetWorkingDirectory(WorkingDirectory, MAX_PATH);
      ShellLink.GetArguments(Arguments, MAX_PATH);
      ShellLink.GetIconLocation(IconLocation, MAX_PATH, IconIndex);
      ShellLink.GetShowCmd(ShowCmd);
      FileName := Path;
      Option := Arguments;
      Folder := WorkingDirectory;
      IconFile := IconLocation;

      if ShowCmd = SW_SHOWMINNOACTIVE then
        WindowSize := 1
      else if ShowCmd = SW_SHOWMAXIMIZED then
        WindowSize := 2
      else
        WindowSize := 0;

      if FileName = '' then
      begin
        if ItemIDList = nil then
          FileName := ShortCut;
      end
      else
      begin
        Malloc.Free(ItemIDList);
        ItemIDList := nil;
      end;

      if (Folder = '') and (FileName <> '') then
        Folder := ExtractFileDir(FileName);

      Result := (FileName <> '') or (ItemIDList <> nil);

      // Windows Installer の場合はショートカットはそのまんま
      if (Flags and SLDF_HAS_DARWINID) <> 0 then
        Result := False;
    end;
end;

// ファイル名からノーマルボタンを作成
procedure FileNameToNormalButton(FileName: string; NormalButton: TNormalButton);
var
  AName, AFileName, AUrl, AOption, AFolder, AIconFile: string;
  AItemIDList: PItemIDList;
  AIconIndex, AWindowSize: Integer;
  Ini: TIniFile;
begin
  AName := ExtractFileNameWithoutExt(FileName);
  if AName = '' then
    AName := FileName;

  if GetShellLinkInfo(FileName, AFileName, AOption, AFolder, AIconFile,
    AItemIDList, AIconIndex, AWindowSize) then
  begin
    if AFileName <> '' then
      AItemIDList := nil
  end
  else
  begin
    AFileName := FileName;
    AItemIDList := nil;
    AOption := '';
    AFolder := ExtractFileDir(AFileName);
    AWindowSize := 0;
    AIconFile := '';
    AIconIndex := 0;
  end;

  // URLのショートカット
  if (AnsiLowerCase(ExtractFileExt(AFileName)) = '.url') and FileExists(AFileName) then
  begin
    Ini := TIniFile.Create(AFileName);
    try
      AUrl := Ini.ReadString('InternetShortcut', 'URL', AFileName);
      if AIconFile = '' then
        AIconFile := AFileName;
      AFileName := AUrl;
    finally
      Ini.Free;
    end;
  end;

  NormalButton.Name := AName;
  NormalButton.FileName := AFileName;
  NormalButton.ItemIDList := AItemIDList;
  NormalButton.Option := AOption;
  NormalButton.Folder := AFolder;
  NormalButton.WindowSize := AWindowSize;
  NormalButton.IconFile := AIconFile;
  NormalButton.IconIndex := AIconIndex;
end;

// フォーム始め
procedure TdlgBtnProperty.FormCreate(Sender: TObject);
begin
  imlType.Clear;
  imlType.ResInstLoad(hInstance, rtBitmap, 'BUTTONS', clFuchsia);

  cmbNormalWindowSize.ItemIndex := 0;

  SetPluginList;

  BtnPropertyList.Add(Self);
end;

// フォーム終わり
procedure TdlgBtnProperty.FormDestroy(Sender: TObject);
begin
  NormalItemIDList := nil;
  BtnPropertyList.Remove(Self);
end;

// フォーム閉じる
procedure TdlgBtnProperty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FOnClosed) then
    FOnClosed(Self);
end;


// フォーム見える
procedure TdlgBtnProperty.FormShow(Sender: TObject);
begin
  if KindIsNormal then
    edtNormalName.SetFocus
  else
    cmbPluginType.SetFocus;
end;


// OK／追加
procedure TdlgBtnProperty.btnOkClick(Sender: TObject);
begin
  if not CheckAllItems then
    Exit;

  if Assigned(FOnApply) then
  begin
    FOnApply(Self);
    Show;
  end;

  if FAddMode then
  begin
    udClickCount.Position := 0;

    NormalItemIDList := nil;
    NormalIconFile := '';
    NormalIconIndex := 0;
    tmNormalIconChangeTimer(Sender);
    edtNormalName.Text := '';
    edtNormalFileName.Text := '';
    edtNormalOption.Text := '';
    edtNormalFolder.Text := '';
    cmbNormalWindowSize.ItemIndex := 0;

    imgPluginIcon.Picture.Icon.Handle := 0;
    edtPluginName.Text := '';
    cmbPluginType.ItemIndex := -1;
    cmbPluginTypeClick(Sender);

  end
  else
    Close;
end;

// キャンセル／閉じる
procedure TdlgBtnProperty.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// 種類の描画
procedure TdlgBtnProperty.cmbKindDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  y: Integer;
const
  ButtonBitmap: array[0..1] of Integer = (BTN_NORMAL, BTN_PLUGIN);
begin
  with Control as TComboBox do
  begin
    Canvas.FillRect(Rect);
    imlType.Draw(Canvas, Rect.Left + 2, Rect.Top + 2, ButtonBitmap[Index]);

    y := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(Items[Index])) div 2;
    Canvas.TextOut(Rect.Left + 22, Rect.Top + y, Items[Index]);
  end;
end;


// ノーマルボタンの参照
procedure TdlgBtnProperty.btnNormalBrowseClick(Sender: TObject);
var
  Ext: string;
  NormalButton: TNormalButton;
begin
  if FileExists(edtNormalFileName.Text) then
  begin
    dlgBrowse.FileName := edtNormalFileName.Text;
    dlgBrowse.InitialDir := ExtractFileDir(edtNormalFileName.Text);
    Ext := ExtractFileExt(edtNormalFileName.Text);
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

      edtNormalName.Text := NormalButton.Name;
      edtNormalFileName.Text := NormalButton.FileName;
      NormalItemIDList := NormalButton.ItemIDList; 
      edtNormalOption.Text := NormalButton.Option;
      edtNormalFolder.Text := NormalButton.Folder;
      NormalIconFile := NormalButton.IconFile;
      NormalIconIndex := NormalButton.IconIndex;
      cmbNormalWindowSize.ItemIndex := NormalButton.WindowSize;
    finally
      NormalButton.Free;
    end;

    tmNormalIconChangeTimer(Sender);
  end;
end;

// ノーマルアイコン表示
procedure TdlgBtnProperty.tmNormalIconChangeTimer(Sender: TObject);
var
  LIcon, SIcon: HIcon;
  Ret: Boolean;
begin
  tmNormalIconChange.Enabled := False;

  // カレントディレクトリ移動
  ChDir(ExtractFilePath(ParamStr(0)));

  if FNormalIconFile <> '' then
    Ret := GetIconHandle(PChar(FNormalIconFile), ftIconPath, FNormalIconIndex, LIcon, SIcon)
  else if FNormalItemIDList <> nil then
    Ret := GetIconHandle(FNormalItemIDList, ftPIDL, FNormalIconIndex, LIcon, SIcon)
  else
    Ret := GetIconHandle(PChar(edtNormalFileName.Text), ftFilePath, FNormalIconIndex, LIcon, SIcon);

  if Ret then
  begin
    imgNormalIcon.Picture.Icon.Handle := LIcon;
    DestroyIcon(SIcon);
  end
  else
    imgNormalIcon.Picture.Icon.Handle := 0;
end;

// ノーマルファイル変更
procedure TdlgBtnProperty.edtNormalFileNameChange(Sender: TObject);
begin
  NormalItemIDList := nil;
  NormalIconFile := '';
  NormalIconIndex := 0;
end;

// ノーマル項目識別子変更
procedure TdlgBtnProperty.SetNormalItemIDList(const Value: PItemIDList);
var
  DesktopFolder: IShellFolder;
begin
  if FNormalItemIDList <> Value then
  begin
    Malloc.Free(FNormalItemIDList);
    NormalIconFile := '';
    NormalIconIndex := 0;
    if Value <> nil then
    begin
      SHGetDesktopFolder(DesktopFolder);
      try
        edtNormalFileName.ParentColor := True;
        edtNormalFileName.Enabled := False;
        edtNormalFileName.Text := GetItemIDName(DesktopFolder, Value, SHGDN_NORMAL);
        btnNormalRelativePath.Enabled := False;
        edtNormalOption.ParentColor := True;
        edtNormalOption.Enabled := False;
        edtNormalOption.Text := '';
        edtNormalFolder.ParentColor := True;
        edtNormalFolder.Enabled := False;
        edtNormalFolder.Text := '';
      finally
        DesktopFolder := nil;
      end;
    end
    else
    begin
      edtNormalFileName.Color := clWindow;
      edtNormalFileName.Enabled := True;
      btnNormalRelativePath.Enabled := True;
      edtNormalOption.Color := clWindow;
      edtNormalOption.Enabled := True;
      edtNormalFolder.Color := clWindow;
      edtNormalFolder.Enabled := True;
    end;

    // ファイル名を変更するので
    // FNormalItemIDListを変更するのは最後
    FNormalItemIDList := CopyItemID(Value);
  end;
end;

// ノーマルアイコンファイル変更
procedure TdlgBtnProperty.SetNormalIconFile(const Value: string);
begin
  FNormalIconFile := Trim(Value);
  tmNormalIconChange.Enabled := False;
  tmNormalIconChange.Enabled := True;
end;

// ノーマルアイコンインデックス変更
procedure TdlgBtnProperty.SetNormalIconIndex(const Value: Integer);
begin
{  if Value >= 0 then
    FNormalIconIndex := Value
  else
    FNormalIconIndex := 0;}
  FNormalIconIndex := Value;
  tmNormalIconChange.Enabled := False;
  tmNormalIconChange.Enabled := True;
end;

// ノーマルアイコンの変更
procedure TdlgBtnProperty.btnNormalIconClick(Sender: TObject);
begin
  dlgIconChange := TdlgIconChange.Create(nil);
  try
    if FNormalIconFile <> '' then
      dlgIconChange.IconFile := FNormalIconFile
    else if FNormalItemIDList <> nil then
      dlgIconChange.ItemIDList := FNormalItemIDList
    else
      dlgIconChange.IconFile := edtNormalFileName.Text;
    dlgIconChange.lstIcon.ItemIndex := FNormalIconIndex;
    if dlgIconChange.ShowModal = idOk then
    begin
      NormalIconFile := dlgIconChange.IconFile;
      NormalIconIndex := dlgIconChange.lstIcon.ItemIndex;
      tmNormalIconChangeTimer(Sender);
    end;
  finally
    dlgIconChange.Release;
  end;
end;

// プラグインのタイプの描画
procedure TdlgBtnProperty.cmbPluginTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  y: Integer;
  ButtonInfo: TButtonInfo;
  Plugin: TPlugin;
  AIcon: TIcon;
begin
  with Control as TComboBox do
  begin
    Canvas.FillRect(Rect);

    ButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[Index]);
    Plugin := TPlugin(ButtonInfo.Owner);
    if Plugin <> nil then
    begin
      if ButtonInfo.OwnerDraw then
        imlType.Draw(Canvas, Rect.Left + 2, Rect.Top + 2, BTN_PLUGIN)
      else
      begin
        AIcon := TIcon.Create;
        try
          AIcon.Handle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, ButtonInfo.IconIndex, True, True);
          DrawIconEx(Canvas.Handle, Rect.Left + 2, Rect.Top + 2, AIcon.Handle, 16, 16, 0, 0, DI_NORMAL);
        finally
          AIcon.Free;
        end;
      end;

    end;
    y := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(Items[Index])) div 2;
    Canvas.TextOut(Rect.Left + 22, Rect.Top + y, Items[Index]);
  end;
end;

// プラグインのタイプ変更
procedure TdlgBtnProperty.cmbPluginTypeClick(Sender: TObject);
var
  ButtonInfo: TButtonInfo;
  Plugin: TPlugin;
begin
  if cmbPluginType.ItemIndex >= 0 then
  begin
    ButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[cmbPluginType.ItemIndex]);
    Plugin := TPlugin(ButtonInfo.Owner);

    if ButtonInfo.OwnerDraw then
      imgPluginIcon.Picture.Icon.Handle := IconCache.GetIcon(PChar(ParamStr(0)), ftIconPath, ICO_PLUGIN, False, True)
    else
      imgPluginIcon.Picture.Icon.Handle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, ButtonInfo.IconIndex, False, True);

    edtPluginName.Text := ButtonInfo.Name;
    edtPluginIDName.Text := Plugin.Name;
    edtPluginFileName.Text := ExtractFileName(Plugin.FileName);
    if ButtonInfo.OwnerDraw then
      edtPluginOwnerDraw.Text := '描画機能あり'
    else
      edtPluginOwnerDraw.Text := '描画機能なし';

    btnPluginOption.Enabled := True;
    btnPluginInfo.Enabled := True;
  end
  else
  begin
    edtPluginIDName.Text := '';
    edtPluginFileName.Text := '';
    edtPluginOwnerDraw.Text := '';

    btnPluginOption.Enabled := False;
    btnPluginInfo.Enabled := False;
  end;
end;

// プラグインの設定
procedure TdlgBtnProperty.btnPluginOptionClick(Sender: TObject);
var
  ButtonInfo: TButtonInfo;
  Plugin: TPlugin;
  No: Integer;
  i: Integer;
begin
  if cmbPluginType.ItemIndex >= 0 then
  begin
    ButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[cmbPluginType.ItemIndex]);
    Plugin := TPlugin(ButtonInfo.Owner);


    if @Plugin.SLXButtonOptions <> nil then
    begin
      Enabled := False;
      try
        No := Plugin.Buttons.IndexOf(ButtonInfo);
        if Plugin.SLXButtonOptions(No, Handle) then
          Plugin.UpdateButton(ButtonInfo);
      finally
        Enabled := True;
        Show;
      end;
    end
    else if @Plugin.SLXChangeOptions <> nil then
    begin
      Enabled := False;
      try
        if Plugin.SLXChangeOptions(Handle) then
          for i := 0 to Plugin.Buttons.Count - 1 do
            Plugin.UpdateButton(TButtonInfo(Plugin.Buttons[i]));
      finally
        Enabled := True;
        Show;
      end;
    end;

  end;
end;

// 相対パスに変換
procedure TdlgBtnProperty.btnNormalRelativePathClick(Sender: TObject);
begin
  if btnNormalRelativePath.Enabled then
  begin
    edtNormalFileName.Text := ExtractRelativePath(ExtractFilePath(ParamStr(0)), edtNormalFileName.Text);
    edtNormalFolder.Text := '';
  end;
end;

// プラグインの情報
procedure TdlgBtnProperty.btnPluginInfoClick(Sender: TObject);
var
  ButtonInfo: TButtonInfo;
  Plugin: TPlugin;
  cWork: array[0..2000] of Char;
begin
  if cmbPluginType.ItemIndex >= 0 then
  begin
    ButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[cmbPluginType.ItemIndex]);
    Plugin := TPlugin(ButtonInfo.Owner);
    cWork := '';
    if @Plugin.SLXGetExplanation <> nil then
      Plugin.SLXGetExplanation(cWork, 2048);
    ShowAbout(Plugin.Name, Plugin.FileName, cWork);
  end;
end;

// 元になるボタンデータを設定
procedure TdlgBtnProperty.SetOriginalButton(ButtonData: TButtonData);
var
  ButtonInfo: TButtonInfo;
  i: Integer;
begin
  if ButtonData is TNormalButton then
  begin
    KindIsNormal := True;
    FAddMode := False;

    udClickCount.Position := ButtonData.ClickCount;
    with TNormalButton(ButtonData) do
    begin
      edtNormalName.Text := Name;
      if ItemIDList = nil then
      begin
        edtNormalFileName.Text := FileName;
        NormalItemIDList := nil;
      end
      else
      begin
        edtNormalFileName.Text := '';
        NormalItemIDList := ItemIDList;
      end;
      edtNormalOption.Text := Option;
      edtNormalFolder.Text := Folder;
      cmbNormalWindowSize.ItemIndex := WindowSize;
      NormalIconFile := IconFile;
      NormalIconIndex := IconIndex;
      tmNormalIconChangeTimer(tmNormalIconChange);
    end;

  end
  else if ButtonData is TPluginButton then
  begin
    KindIsNormal := False;
    FAddMode := False;
    udClickCount.Position := ButtonData.ClickCount;
    with TPluginButton(ButtonData) do
    begin
      ButtonInfo := Plugins.FindButtonInfo(PluginName, No);
      i := 0;
      while i < cmbPluginType.Items.Count do
      begin
        if cmbPluginType.Items.Objects[i] = ButtonInfo then
        begin
          cmbPluginType.ItemIndex := i;
          cmbPluginTypeClick(cmbPluginType);
          Break;
        end;
        Inc(i);
      end;
      edtPluginName.Text := Name;
    end;
  end
  else
  begin
    KindIsNormal := True;
    FAddMode := True;
    udClickCount.Position := 0;
  end;

  if FAddMode then
  begin
    Caption := 'ボタンの追加';
    btnOk.Caption := '追加';
    btnCancel.Caption := '閉じる';
  end
  else
  begin
    Caption := 'ボタンの変更';
    btnOk.Caption := 'OK';
    btnCancel.Caption := 'キャンセル';
  end;

end;

// 個々のデータが正しいかをチェック
function TdlgBtnProperty.CheckAllItems: Boolean;
begin
  Result := False;

  // ノーマル
  if KindIsNormal then
  begin
    edtNormalName.Text := Trim(edtNormalName.Text);
    edtNormalFileName.Text := Trim(edtNormalFileName.Text);
    edtNormalOption.Text := Trim(edtNormalOption.Text);
    edtNormalFolder.Text := Trim(edtNormalFolder.Text);

    if cmbNormalWindowSize.ItemIndex >= 0 then
    begin
      if edtNormalFileName.Text <> '' then
      begin
        Result := True;
        if FileExists(edtNormalFileName.Text) then
        begin
          if edtNormalName.Text = '' then
            edtNormalName.Text := ExtractFileNameWithoutExt(edtNormalFileName.Text);
          if edtNormalFolder.Text = '' then
            edtNormalFolder.Text := ExtractFileDir(edtNormalFileName.Text);
        end
        else
        begin
          if edtNormalName.Text = '' then
            edtNormalName.Text := edtNormalFileName.Text;
        end;
      end
      else
      begin
        Application.MessageBox('リンク先を指定して下さい。', '確認', MB_ICONWARNING);
        edtNormalFileName.SetFocus;
      end;
    end
    else
    begin
      Application.MessageBox('サイズを指定して下さい。', '確認', MB_ICONWARNING);
      cmbNormalWindowSize.SetFocus;
    end;
  end

  // プラグイン
  else
  begin
    edtPluginName.Text := Trim(edtPluginName.Text);

    if cmbPluginType.ItemIndex >= 0 then
    begin
      Result := True;
      if edtPluginName.Text = '' then
        edtPluginName.Text := cmbPluginType.Text;
    end
    else
    begin
      Application.MessageBox('タイプを指定して下さい。', '確認', MB_ICONWARNING);
      cmbPluginType.SetFocus;
    end;

  end;
end;


// 戻り値を作成
function TdlgBtnProperty.CreateResultButton: TButtonData;
var
  ButtonInfo: TButtonInfo;
  AIcon: HIcon;
  Plugin: TPlugin;
begin
  Result := nil;

  if not CheckAllItems then
    Exit;

  if KindIsNormal then
  begin
    Result := TNormalButton.Create;
    with TNormalButton(Result) do
    begin
      ClickCount := udClickCount.Position;
      Name := edtNormalName.Text;
      if NormalItemIDList = nil then
        FileName := edtNormalFileName.Text
      else
        ItemIDList := CopyItemID(NormalItemIDList);
      Option := edtNormalOption.Text;
      Folder := edtNormalFolder.Text;
      WindowSize := cmbNormalWindowSize.ItemIndex;
      IconFile := NormalIconFile;
      IconIndex := NormalIconIndex;
      // アイコンキャッシュを新しくする
      if IconFile <> '' then
        AIcon := IconCache.GetIcon(PChar(IconFile), ftIconPath, IconIndex, False, False)
      else if ItemIDList <> nil then
        AIcon := IconCache.GetIcon(ItemIDList, ftPIDL, IconIndex, False, False)
      else
        AIcon := IconCache.GetIcon(PChar(FileName), ftFilePath, IconIndex, False, False);
      DestroyIcon(AIcon);
    end;
  end
  else
  begin
    Result := TPluginButton.Create;
    with TPluginButton(Result) do
    begin
      ClickCount := udClickCount.Position;
      Name := edtPluginName.Text;

      ButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[cmbPluginType.ItemIndex]);
      Plugin := ButtonInfo.Owner as TPlugin;
      PluginName := Plugin.Name;
      No := Plugin.Buttons.IndexOf(ButtonInfo);
    end;
  end;

end;


function TdlgBtnProperty.GetKindIsNormal: Boolean;
begin
  Result := pcKind.ActivePage = tabNormal;
end;

procedure TdlgBtnProperty.SetKindIsNormal(const Value: Boolean);
begin
  if Value then
    pcKind.ActivePage := tabNormal
  else
    pcKind.ActivePage := tabPlugin;
end;

procedure TdlgBtnProperty.WMActivate(var Msg: TWMActivate);
begin
  inherited;

  if Msg.Active = WA_INACTIVE then
  begin
    if Assigned(OnWindowDeactivate) then
      OnWindowDeactivate(Self);
  end
  else
  begin
    if Assigned(OnWindowActivate) then
      OnWindowActivate(Self);
  end;
end;

// プラグインボタンの一覧をセット
procedure TdlgBtnProperty.SetPluginList;
var
  Plugin: TPlugin;
  SelButtonInfo, ButtonInfo: TButtonInfo;
  i, j: Integer;
begin
  if cmbPluginType.ItemIndex >= 0 then
    SelButtonInfo := TButtonInfo(cmbPluginType.Items.Objects[cmbPluginType.ItemIndex])
  else
    SelButtonInfo := nil;

  cmbPluginType.Items.Clear;
  for i := 0 to Plugins.Count - 1 do
  begin
    Plugin := TPlugin(Plugins.Objects[i]);
    for j := 0 to Plugin.Buttons.Count - 1 do
    begin
      ButtonInfo := Plugin.Buttons[j];
      if ButtonInfo = SelButtonInfo then
        cmbPluginType.ItemIndex := cmbPluginType.Items.AddObject(ButtonInfo.Name, ButtonInfo)
      else
        cmbPluginType.Items.AddObject(ButtonInfo.Name, ButtonInfo);
    end;
  end;
  cmbPluginTypeClick(cmbPluginType);
end;

initialization
  BtnPropertyList := TList.Create;
finalization
  BtnPropertyList.Free;
end.
