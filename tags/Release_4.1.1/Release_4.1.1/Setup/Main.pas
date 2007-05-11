unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, StdCtrls, SetBtn, ImgList, Registry, FileCtrl,
  IniFiles, SetFuncs, ShellAPI, XPMan;

type
  TfrmMain = class(TForm)
    PageControl: TPageControl;
    tabSL3Groups: TTabSheet;
    lblSL3Groups: TLabel;
    lvSL3Groups: TListView;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    tabSL4UserFolder: TTabSheet;
    lblSL4UserFolder: TLabel;
    edtSL4UserFolder: TEdit;
    Label4: TLabel;
    btnSL4UserFolder: TButton;
    tabInfo: TTabSheet;
    lblInfo: TLabel;
    memInfo: TMemo;
    btnRun: TButton;
    lvSL3GroupsAllYes: TButton;
    lvSL3GroupsAllNo: TButton;
    Image1: TImage;
    tabStart: TTabSheet;
    imgIcon: TImage;
    lblTitle: TLabel;
    tabTargetFolder: TTabSheet;
    lblTargetFolder: TLabel;
    Label8: TLabel;
    edtTargetFolder: TEdit;
    btnTargetFolder: TButton;
    rdoInstall: TRadioButton;
    rdoConvert: TRadioButton;
    rdoUninstall: TRadioButton;
    lblSL4UserFolderInfo: TLabel;
    tabInstallOptions: TTabSheet;
    lblInstallOptions: TLabel;
    chkProgramMenu: TCheckBox;
    chkStartup: TCheckBox;
    chkRegistry: TCheckBox;
    chkDesktop: TCheckBox;
    memDescription: TMemo;
    Label1: TLabel;
    tabUninstallOptions: TTabSheet;
    lblUninstallOptions: TLabel;
    chkDeleteData: TCheckBox;
    chkDeletePlugins: TCheckBox;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSL4UserFolderClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tabInfoShow(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure lvSL3GroupsAllYesClick(Sender: TObject);
    procedure lvSL3GroupsAllNoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnTargetFolderClick(Sender: TObject);
  private
    FUserName: String;
    FUpdateInstall: Boolean;

    FSL4PadName: String;
    FSL4PadCount: Integer;
    function GetTargetFolder: String;
    function GetSL4UserFolder: String;
    function VisiblePage(Page: TTabSheet): Boolean;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

// インストール先フォルダ
function TfrmMain.GetTargetFolder: String;
var
  Folder: String;
begin
  Folder := Trim(edtTargetFolder.Text);
  Folder := ExpandFileName(Folder);
  if not IsPathDelimiter(Folder, Length(Folder)) then
    Folder := Folder + '\';
  Result := Folder;
end;

// データフォルダ
function TfrmMain.GetSL4UserFolder: String;
var
  Folder: String;
begin
  Folder := Trim(edtSL4UserFolder.Text);
  Folder := ExpandFileName(Folder);
  if not IsPathDelimiter(Folder, Length(Folder)) then
    Folder := Folder + '\';
  Result := Folder;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
//  NonClientMetrics: TNonClientMetrics;

  UserSize: Cardinal;

  Buf: array[0..2024] of Char;

  RegIniFile: TRegIniFile;
  i: Integer;
  Title,
  BtnFile: String;
  Item: TListItem;

  Ini: TIniFile;
begin
  // フォント
//  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
//  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
//  Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);

  imgIcon.Picture.Icon := Application.Icon;
  lblTitle.Caption := Application.Title;
//  lblTitle.Font.Name := Font.Name;
//  lblTargetFolder.Font.Name := Font.Name;
//  lblInstallOptions.Font.Name := Font.Name;
//  lblSL4UserFolder.Font.Name := Font.Name;
//  lblSL3Groups.Font.Name := Font.Name;
//  lblUninstallOptions.Font.Name := Font.Name;
//  lblInfo.Font.Name := Font.Name;


  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := False;

  PageControl.ActivePage := PageControl.Pages[0];

  // 現在のユーザー名
  UserSize := SizeOf(Buf);
  if not GetUserName(Buf, UserSize) then
    Buf := '';
  if Buf = '' then
    Buf := 'Default';
  FUserName := StrPas(Buf);


  // SL3 ボタンファイル
  RegIniFile := TRegIniFile.Create('Software\SS Soft\Special Launch');
  try
    with RegIniFile do
    begin
      i := 0;
      while True do
      begin
        Title := ReadString('Groups', 'Name'+IntToStr(i), 'グループ' + IntToStr(i));
        BtnFile := ReadString('Groups', 'File'+IntToStr(i), '');
        if BtnFile = '' then
          Break;

        if FileExists(BtnFile) then
        begin
          Item := lvSL3Groups.Items.Add;
          Item.Caption := Title;
          Item.SubItems.Add(BtnFile);
          Item.Checked := False;
        end;
        inc(i);
      end;
      if lvSL3Groups.Items.Count > 0 then
        lvSL3Groups.Items[0].Focused := True;
    end;
  finally
    RegIniFile.Free;
  end;

  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  try
    // インストール済み
    if Ini.ReadBool('Install', 'Installed', False) = False then
    begin
      Title := 'このプログラムは Special Launch をコンピュータにインストールします。' + #13#10
        + #13#10
        + #13#10
        + '準備ができましたら［次へ］をクリックしてください。' + #13#10;
      memDescription.Text := Title;
      rdoInstall.Checked := True;
      rdoInstall.Visible := False;
      rdoConvert.Visible := False;
      rdoUninstall.Visible := False;
    end
    // インストール前
    else
    begin
      Title := 'このプログラムは Special Launch 3 のボタンファイルを Special Launch 4 の形式にコンバートしたり、 Special Launch をコンピュータから削除します。' + #13#10
        + #13#10
        + '動作を選択して［次へ］をクリックしてください。' + #13#10;
      memDescription.Text := Title;
      rdoInstall.Visible := False;
      rdoConvert.Enabled := lvSL3Groups.Items.Count > 0;
      if rdoConvert.Enabled then
        rdoConvert.Checked := True
      else
        rdoUninstall.Checked := True;
    end;
  finally
    Ini.Free;
  end;

  chkDeleteData.Checked := True;
  chkDeletePlugins.Checked := True;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  lvSL3Groups.Items.BeginUpdate;
  try
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      TButtonGroup(lvSL3Groups.Items[i].Data).Free;
    lvSL3Groups.Items.Clear;
  finally
    lvSL3Groups.Items.EndUpdate;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PageControlChange(PageControl);
end;

// ページ変更
procedure TfrmMain.PageControlChange(Sender: TObject);
begin
  btnPrev.Enabled := PageControl.ActivePage.PageIndex > 0;
  btnNext.Enabled := PageControl.ActivePage.PageIndex < PageControl.PageCount - 1;
  btnRun.Enabled := PageControl.ActivePage.PageIndex = PageControl.PageCount - 1;
  btnPrev.Cancel := btnPrev.Enabled;
  btnCancel.Cancel := not btnPrev.Enabled;
  btnNext.Default := btnNext.Enabled;
  btnRun.Default := btnRun.Enabled;

  if PageControl.ActivePage = tabStart then
  begin
    Caption := Application.Title;
    if rdoInstall.Checked and rdoInstall.Visible then
      rdoInstall.SetFocus
    else if rdoConvert.Checked and rdoConvert.Visible then
      rdoConvert.SetFocus
    else if rdoUninstall.Checked and rdoUninstall.Visible then
      rdoUninstall.SetFocus
    else
      btnNext.SetFocus;
  end
  else
  begin
    if PageControl.ActivePage = tabTargetFolder then
    begin
      edtTargetFolder.SetFocus;
      FUpdateInstall := False;
    end
    else if PageControl.ActivePage = tabInstallOptions then
      chkProgramMenu.SetFocus
    else if PageControl.ActivePage = tabSL4UserFolder then
      edtSL4UserFolder.SetFocus
    else if PageControl.ActivePage = tabSL3Groups then
      lvSL3Groups.SetFocus
    else if PageControl.ActivePage = tabUninstallOptions then
      chkDeleteData.SetFocus
    else if PageControl.ActivePage = tabInfo then
      memInfo.SetFocus;

    if rdoInstall.Checked then
    begin
      if FUpdateInstall then
        Caption := 'Special Launch 上書きインストール'
      else
        Caption := 'Special Launch インストール';
    end
    else if rdoConvert.Checked then
      Caption := 'Special Launch 3 → 4 コンバート'
    else if rdoUninstall.Checked then
      Caption := 'Special Launch アンインストール'
  end;
end;


// ページの表示チェック
function TfrmMain.VisiblePage(Page: TTabSheet): Boolean;
var
  IniFileName: String;
  UserFolder: String;
  Ini: TIniFile;
begin
  Result := False;

  // インストール先フォルダ
  if Page = tabTargetFolder then
  begin
    Result := rdoInstall.Checked;
  end

  // インストールオプション
  else if Page = tabInstallOptions then
  begin
    Result := rdoInstall.Checked;
  end

  // データフォルダ
  else if Page = tabSL4UserFolder then
  begin
    Result := (rdoInstall.Checked and not FUpdateInstall) or rdoConvert.Checked;
  end

  // SL3 ボタングループ
  else if Page = tabSL3Groups then
  begin
    Result := (lvSL3Groups.Items.Count > 0) and (rdoInstall.Checked or rdoConvert.Checked);
    if Result and rdoInstall.Checked then
    begin
      IniFileName := GetTargetFolder + 'SpLnch.ini';
      if FileExists(IniFileName) then
      begin
        Ini := TIniFile.Create(IniFileName);
        try
          UserFolder := Ini.ReadString('Users', FUserName, '');
        finally
          Ini.Free;
        end;
      end;

      if DirectoryExists(UserFolder) then
      begin
        edtSL4UserFolder.Text := UserFolder;
        Result := False;
      end;
    end;
  end

  // アンインストールオプション
  else if Page = tabUninstallOptions then
  begin
    Result := rdoUninstall.Checked;
  end

end;



// 戻るボタン
procedure TfrmMain.btnPrevClick(Sender: TObject);
var
  PrevPage: TTabSheet;
begin
  PrevPage := PageControl.FindNextPage(PageControl.ActivePage, False, False);
  while PrevPage.PageIndex > 0 do
  begin
    if VisiblePage(PrevPage) then
      Break;
    PrevPage := PageControl.FindNextPage(PrevPage, False, False);
  end;
  PageControl.ActivePage := PrevPage;
  PageControlChange(PageControl);
end;

// 次へボタン
procedure TfrmMain.btnNextClick(Sender: TObject);
var
  i: Integer;

  Buf: array[0..2024] of Char;
  TargetFolder: String;

  Folder, FileName: String;
  Ini: TIniFile;
  UserFolder: String;
  NextPage: TTabSheet;
begin
  // 最初のページ
  if PageControl.ActivePage = tabStart then
  begin

    // インストール先フォルダの初期化
    TargetFolder := GetRegistry;
    if TargetFolder = '' then
    begin
      if GetWindowsDirectory(Buf, SizeOf(Buf)) > 0 then
      begin
        TargetFolder := Copy(Buf, 1, 3) + 'Program Files\Special Launch 4\';
      end;
    end;
    edtTargetFolder.Text := TargetFolder;

    // インストールオプションの初期化
    chkProgramMenu.Checked := True;
    chkStartup.Checked := True;
    chkDesktop.Checked := False;
    chkRegistry.Checked := True;


    // データフォルダの初期化
    if rdoInstall.Checked then
    begin
      lblSL4UserFolder.Caption := '各種設定を保存するデータフォルダを指定してください。';
      lblSL4UserFolderInfo.Visible := True;
      edtSL4UserFolder.Text := '';
    end
    else
    begin
      lblSL4UserFolder.Caption := 'Special Launch 4 で各種設定を保存しているデータフォルダを指定してください。';
      lblSL4UserFolderInfo.Visible := False;

      FileName := ExtractFilePath(ParamStr(0)) + 'SpLnch.ini';
      if FileExists(FileName) then
      begin
        Ini := TIniFile.Create(FileName);
        try
          Folder := Ini.ReadString('Users', FUserName, '');
        finally
          Ini.Free;
        end;
      end;

      if DirectoryExists(Folder) then
        edtSL4UserFolder.Text := Folder;
    end;


    // SL3 ボタングループ
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      lvSL3Groups.Items[i].Checked := False;
  end;


  // インストール先フォルダ
  if PageControl.ActivePage = tabTargetFolder then
  begin
    FUpdateInstall := False;

    if Trim(edtTargetFolder.Text) = '' then
    begin
      Application.MessageBox('インストール先フォルダを指定してください。', '確認', MB_ICONWARNING);
      Exit;
    end;

    FileName := GetTargetFolder + 'SpLnch.ini';
    UserFolder := '';
    if FileExists(FileName) then
    begin
      Ini := TIniFile.Create(FileName);
      try
        UserFolder := Ini.ReadString('Users', FUserName, '');
      finally
        Ini.Free;
      end;
    end;
    FUpdateInstall := UserFolder <> '';
    if FUpdateInstall then
    begin
      edtSL4UserFolder.Text := UserFolder;
    end
    else
    begin
      edtSL4UserFolder.Text := GetTargetFolder + FUserName;
      edtSL4UserFolder.Text := GetSL4UserFolder;
      if UnknownFileExists(GetTargetFolder) then
      begin
        if Application.MessageBox(PChar('指定のフォルダ "' + GetTargetFolder
          + '" にはすでにファイルが存在しています。'
          + 'それらのファイルに影響を及ぼす恐れがありますが、'
          + 'このまま続行してよろしいですか?'),
                                  '確認', MB_ICONWARNING or MB_YESNO) = idNo then
          Exit;
      end;
    end;

    Ini := TIniFile.Create(GetTargetFolder + 'Setup.ini');
    try
      chkProgramMenu.Checked := Ini.ReadBool('Options', 'ProgramMenu', True);
      chkStartup.Checked := Ini.ReadBool('Options', 'Startup', True);
      chkDesktop.Checked := Ini.ReadBool('Options', 'Desktop', False);
      chkRegistry.Checked := Ini.ReadBool('Options', 'Registry', True);
    finally
      Ini.Free;
    end;

  end

  // データフォルダ
  else if PageControl.ActivePage = tabSL4UserFolder then
  begin
    if Trim(edtSL4UserFolder.Text) = '' then
    begin
      Application.MessageBox('データフォルダを指定してください。', '確認', MB_ICONWARNING);
      Exit;
    end;

    FileName := GetSL4UserFolder + 'SpLnch.ini';

    if rdoInstall.Checked then
    begin
      // 指定のフォルダにユーザー設定ファイルがある
      if FileExists(FileName) then
      begin
        if Application.MessageBox(PChar('指定のフォルダ "' + GetSL4UserFolder +
                                        '" にはすでに設定があります。この設定を利用しますか?'),
                                  '確認', MB_ICONQUESTION or MB_YESNO) = idNo then
          Exit;
      end
      else if DirectoryExists(GetSL4UserFolder) then
      begin
        if UnknownFileExists(GetSL4UserFolder) then
        begin
          if Application.MessageBox(PChar('指定のフォルダ "' + GetSL4UserFolder +
                                        '" にはすでに設定以外のファイルが存在しています。' +
                                        'このまま続行してよろしいですか?'),
                                    '確認', MB_ICONQUESTION or MB_YESNO) = idNo then
            Exit;
        end;
      end

    end
    else
    begin
      if not DirectoryExists(GetSL4UserFolder) then
      begin
        Application.MessageBox(PChar('指定のフォルダ "' + GetSL4UserFolder + '" は存在しません。'), '確認', MB_ICONWARNING);
        Exit;
      end;

      if not FileExists(FileName) then
      begin
        Application.MessageBox(PChar('指定のフォルダ "' + GetSL4UserFolder + '" には Special Launch のデータはありません。'), '確認', MB_ICONWARNING);
        Exit;
      end;

      Ini := TIniFile.Create(FileName);
      try
        if not Ini.SectionExists('User') then
        begin
          Application.MessageBox(PChar('指定のフォルダ "' + GetSL4UserFolder + '" には有効なユーザー設定がありません。'), '確認', MB_ICONWARNING);
          Exit;
        end;
      finally
        Ini.Free;
      end;
    end;


  end

  // SL3 ボタングループ
  else if PageControl.ActivePage = tabSL3Groups then
  begin
    if rdoConvert.Checked then
    begin
      i := 0;
      while i < lvSL3Groups.Items.Count do
      begin
        if lvSL3Groups.Items[i].Checked then
          Break;
        Inc(i);
      end;
      if i >= lvSL3Groups.Items.Count then
      begin
        Application.MessageBox('コンバートするボタングループが選択されていません。', '確認', MB_ICONWARNING);
        Exit;
      end;
    end;
  end;

  // 次のページ
  NextPage := PageControl.FindNextPage(PageControl.ActivePage, True, False);
  while NextPage.PageIndex < PageControl.PageCount - 1 do
  begin
    if VisiblePage(NextPage) then
      Break;
    NextPage := PageControl.FindNextPage(NextPage, True, False);
  end;
  PageControl.ActivePage := NextPage;
  PageControlChange(PageControl);
end;

// インストール先参照ボタン
procedure TfrmMain.btnTargetFolderClick(Sender: TObject);
var
  Folder: String;
begin
  if SelectDirectory('Special Launch をインストールするフォルダを指定してください。', '', Folder) then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    edtTargetFolder.Text := Folder;
  end;
end;

// SL4データフォルダ参照ボタン
procedure TfrmMain.btnSL4UserFolderClick(Sender: TObject);
var
  Folder: String;
begin
  if SelectDirectory('Special Launch のデータを保存するフォルダを指定してください。', '', Folder) then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    edtSL4UserFolder.Text := Folder;
  end;
end;

// SL3すべて選択ボタン
procedure TfrmMain.lvSL3GroupsAllYesClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvSL3Groups.Items.Count - 1 do
    lvSL3Groups.Items[i].Checked := True;
end;

// SL3すべて解除ボタン
procedure TfrmMain.lvSL3GroupsAllNoClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvSL3Groups.Items.Count - 1 do
    lvSL3Groups.Items[i].Checked := False;
end;


// キャンセルボタン
procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// 情報表示
procedure TfrmMain.tabInfoShow(Sender: TObject);
  procedure SetBrankLine;
  begin
    if memInfo.Lines.Count > 0 then
      memInfo.Lines.Add('');
  end;
var
  i: Integer;
  ConvertCount: Integer;
begin
  lblInfo.Caption := '以下の設定で';
  if rdoInstall.Checked then
    lblInfo.Caption := lblInfo.Caption + 'インストール'
  else if rdoConvert.Checked then
    lblInfo.Caption := lblInfo.Caption + 'コンバート'
  else if rdoUninstall.Checked then
    lblInfo.Caption := lblInfo.Caption + 'アンインストール';
  lblInfo.Caption := lblInfo.Caption + 'を実行します。';


  memInfo.Clear;

  if VisiblePage(tabTargetFolder) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('Special Launch をインストールするフォルダ');
    memInfo.Lines.Add(Format('   %s', [GetTargetFolder]));
  end;

  if VisiblePage(tabInstallOptions) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('インストールオプション');
    if chkProgramMenu.Checked then
      memInfo.Lines.Add('   プログラムメニューに登録する');
    if chkStartup.Checked then
      memInfo.Lines.Add('   Windows の起動時に Special Launch も起動する');
    if chkDesktop.Checked then
      memInfo.Lines.Add('   デスクトップにショートカットを作成する');
    if chkRegistry.Checked then
      memInfo.Lines.Add('   コントロールパネルの［プログラムの追加と削除］に登録する');
    if (not chkProgramMenu.Checked) and (not chkStartup.Checked) and
      (not chkDesktop.Checked) and (not chkRegistry.Checked) then
      memInfo.Lines.Add('   なし');
  end;

  if VisiblePage(tabSL4UserFolder) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('各種設定を保存するフォルダ');
    memInfo.Lines.Add(Format('   %s', [GetSL4UserFolder]));
  end;

  if VisiblePage(tabSL3Groups) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('Special Launch 3 からコンバートするボタングループ');
    ConvertCount := 0;
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      if lvSL3Groups.Items[i].Checked then
      begin
        memInfo.Lines.Add(Format('   %s [%s]', [lvSL3Groups.Items[i].Caption, lvSL3Groups.Items[i].SubItems[0]]));
        Inc(ConvertCount);
      end;

    if ConvertCount = 0 then
    begin
      FSL4PadName := '';
      FSL4PadCount := 0;
      memInfo.Lines.Add('   なし');
    end
    else
    begin
      i := 0;
      while True do
      begin
        FSL4PadName := GetSL4UserFolder + 'Pads\Pad' + IntToStr(i);
        if not FileExists(FSL4PadName + '.ini') then
          Break;
        Inc(i);
      end;
      FSL4PadCount := i + 1;
      SetBrankLine;
      memInfo.Lines.Add('Special Launch 4 で新しく作成するパッドファイル');
      memInfo.Lines.Add(Format('   %s.ini', [FSL4PadName]));
      memInfo.Lines.Add(Format('   %s.btn', [FSL4PadName]));
    end;
  end;

  if rdoUninstall.Checked then
  begin
    SetBrankLine;
    memInfo.Lines.Add('アンインストールオプション');
    if chkDeleteData.Checked then
      memInfo.Lines.Add('   各ユーザーのデータフォルダを削除する');
    if chkDeletePlugins.Checked then
      memInfo.Lines.Add('   プラグインフォルダを削除する');
    if (not chkDeleteData.Checked) and (not chkDeletePlugins.Checked) then
      memInfo.Lines.Add('   なし');
  end;

  memInfo.SelStart := 0;
  memInfo.SelLength := 0;
end;






// 実行ボタン
procedure TfrmMain.btnRunClick(Sender: TObject);
var
  i: Integer;
  ButtonGroups: TButtonGroups;
  ButtonGroup: TButtonGroup;
  Ini: TIniFile;
  DoClose: Boolean;
  Msg: String;
begin
  DoClose := True;

  if rdoInstall.Checked then
  begin
    // フォルダの作成
    DoClose := ForceDirectories(GetTargetFolder);
    if not DoClose then
      Application.MessageBox('インストール先フォルダを作成できませんでした。', 'エラー', MB_ICONSTOP);

    // ファイルコピー
    if DoClose then
      DoClose := SL4FileCopy(GetTargetFolder);

    // 必要なフォルダの作成
    if DoClose then
      DoClose := ForceDirectories(GetSL4UserFolder);
    if not DoClose then
      Application.MessageBox('データフォルダを作成できませんでした。', 'エラー', MB_ICONSTOP);
    if DoClose then
      DoClose := ForceDirectories(GetSL4UserFolder + 'Pads');
    if not DoClose then
      Application.MessageBox('パッドフォルダを作成できませんでした。', 'エラー', MB_ICONSTOP);
    if DoClose then
      DoClose := ForceDirectories(GetTargetFolder + 'Plugins');
    if not DoClose then
      Application.MessageBox('プラグインフォルダを作成できませんでした。', 'エラー', MB_ICONSTOP);
    if DoClose then
    begin
      Ini := TIniFile.Create(GetTargetFolder + 'SpLnch.ini');
      try
        Ini.WriteString('Users', FUserName, GetSL4UserFolder);
      finally
        Ini.Free;
      end;
    end;
    if DoClose then
    begin
      Ini := TIniFile.Create(GetSL4UserFolder + 'SpLnch.ini');
      try
        Ini.WriteString('User', 'Name', FUserName);
      finally
        Ini.Free;
      end;
    end;


    // プログラムメニュー登録
    if DoClose and chkProgramMenu.Checked then
    begin
      chkProgramMenu.Checked := SetProgramMenu(GetTargetFolder);
      if not chkProgramMenu.Checked then
        Application.MessageBox('プログラムメニューに登録できませんでした。', 'エラー', MB_ICONSTOP);
    end;

    // スタートアップ登録
    if DoClose and chkStartup.Checked then
    begin
      chkStartup.Checked := SetStartup(GetTargetFolder);
      if not chkStartup.Checked then
        Application.MessageBox('スタートアップに登録できませんでした。', 'エラー', MB_ICONSTOP);
    end;

    // デスクトップ登録
    if DoClose and chkDesktop.Checked then
    begin
      chkDesktop.Checked := SetDesktop(GetTargetFolder);
      if not chkDesktop.Checked then
        Application.MessageBox('デスクトップにショートカットを作成できませんでした。', 'エラー', MB_ICONSTOP);
    end;

    // レジストリ登録
    if DoClose and chkRegistry.Checked then
    begin
      chkRegistry.Checked := SetRegistry(GetTargetFolder);
      if not chkRegistry.Checked then
        Application.MessageBox('レジストリに登録できませんでした。', 'エラー', MB_ICONSTOP);
    end;
    
    // セットアップオプションを憶える
    if DoClose then
    begin
      Ini := TIniFile.Create(GetTargetFolder + 'Setup.ini');
      try
        Ini.WriteBool('Install', 'Installed', True);
        Ini.WriteBool('Options', 'ProgramMenu', chkProgramMenu.Checked);
        Ini.WriteBool('Options', 'Startup', chkStartup.Checked);
        Ini.WriteBool('Options', 'Desktop', chkDesktop.Checked);
        Ini.WriteBool('Options', 'Registry', chkRegistry.Checked);
      finally
        Ini.Free;
      end;
    end;

  end;

  if DoClose and (rdoInstall.Checked or rdoConvert.Checked) then
  begin

    ButtonGroups := TButtonGroups.Create;
    try
      DoClose := True;

      for i := 0 to lvSL3Groups.Items.Count - 1 do
        if lvSL3Groups.Items[i].Checked then
        begin
          ButtonGroup := TButtonGroup.Create;
          if SL3Load(lvSL3Groups.Items[i].Caption, lvSL3Groups.Items[i].SubItems[0], ButtonGroup) then
            ButtonGroups.Add(ButtonGroup)
          else
          begin
            Application.MessageBox('ボタンファイルの形式が違います。', 'エラー', MB_ICONSTOP);
            ButtonGroup.Free;
            DoClose := False;
            Break;
          end;
        end;

      if DoClose and (ButtonGroups.Count > 0) then
      begin
        ButtonGroups.Save(FSL4PadName + '.btn');
        Ini := TIniFile.Create(FSL4PadName + '.ini');
        try
          Ini.WriteInteger('PadOptions', 'GroupIndex', 0);
        finally
          Ini.Free;
        end;

        Ini := TIniFile.Create(GetSL4UserFolder + 'SpLnch.ini');
        try
          Ini.WriteInteger('Pads', 'Count', FSL4PadCount);
        finally
          Ini.Free;
        end;
      end;

    finally
      ButtonGroups.Free;
    end;

  end;

  if rdoUninstall.Checked then
  begin
    DoClose := UninstallTemp(chkDeleteData.Checked, chkDeletePlugins.Checked);
  end;


  if rdoInstall.Checked then
    Msg := 'インストール'
  else if rdoConvert.Checked then
    Msg := 'コンバート'
  else if rdoUninstall.Checked then
    Msg := 'アンインストール';

  if DoClose then
  begin
    if not rdoUninstall.Checked then
    begin
      Msg := Msg + 'が完了しました。';
      Application.MessageBox(PChar(Msg), '確認', MB_ICONINFORMATION);

      if rdoInstall.Checked then
      begin
        SL4Unlock;
        if Application.MessageBox('Special Launch をすぐに起動しますか?', '確認', MB_ICONQUESTION or MB_YESNO) = idYes then
          WinExec(PChar(GetTargetFolder + 'SpLnch.exe'), SW_SHOW);
        if not FUpdateInstall then
          if Application.MessageBox('Special Launch のヘルプを表示しますか?', '確認', MB_ICONQUESTION or MB_YESNO) = idYes then
            ShellExecute(Handle, nil, PChar(GetTargetFolder + 'SpLnch.chm'), nil, nil, SW_SHOW);
      end;
    end;

    Close;
  end
  else
  begin
    Msg := Msg + 'できませんでした。';
    Application.MessageBox(PChar(Msg), '確認', MB_ICONSTOP);
  end;


end;

end.
