unit Option;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, SetInit, ImgList, SetPlug, About, SetIcons,
  SetPads, MMSystem, IniFiles, SetBtn;


type
  TdlgOption = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl: TPageControl;
    tabGeneral: TTabSheet;
    tabPlugins: TTabSheet;
    lblPlugins: TLabel;
    btnPluginOption: TButton;
    imlPlugins: TImageList;
    btnPluginInfo: TButton;
    lvPlugins: TListView;
    grpIconCache: TGroupBox;
    lblIconCache: TLabel;
    lblNowIconCache: TLabel;
    edtIconCache: TEdit;
    udIconCache: TUpDown;
    btnCacheClear: TButton;
    chkTaskTray: TCheckBox;
    dlgOpen: TOpenDialog;
    btnPluginEnable: TButton;
    btnPluginDisable: TButton;
    gbSound: TGroupBox;
    lblSounds: TLabel;
    cmbSounds: TComboBox;
    edtSoundName: TEdit;
    lblSoundName: TLabel;
    btnSoundTest: TButton;
    btnSoundClear: TButton;
    btnSoundBrowse: TButton;
    tabRestrictions: TTabSheet;
    Label1: TLabel;
    grpRestrictions: TGroupBox;
    chkLockBtnEdit: TCheckBox;
    chkLockPadProperty: TCheckBox;
    chkLockOption: TCheckBox;
    btnLockRestrictions: TButton;
    btnUnlockRestrictions: TButton;
    chkLockBtnDrag: TCheckBox;
    tabUserFolder: TTabSheet;
    Label2: TLabel;
    edtUserFolder: TEdit;
    btnUserFolderReset: TButton;
    btnUserFolderOpen: TButton;
    btnHelp: TButton;
    chkLockPlugin: TCheckBox;
    chkLockBtnFolder: TCheckBox;
    chkVerCheck: TCheckBox;
    chkSettingForAllUser: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPluginOptionClick(Sender: TObject);
    procedure btnPluginInfoClick(Sender: TObject);
    procedure lvPluginsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCacheClearClick(Sender: TObject);
    procedure cmbSoundsChange(Sender: TObject);
    procedure edtSoundNameChange(Sender: TObject);
    procedure btnSoundClearClick(Sender: TObject);
    procedure btnSoundBrowseClick(Sender: TObject);
    procedure btnSoundTestClick(Sender: TObject);
    procedure btnPluginEnableClick(Sender: TObject);
    procedure btnPluginDisableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLockRestrictionsClick(Sender: TObject);
    procedure btnUnlockRestrictionsClick(Sender: TObject);
    procedure chkTaskTrayClick(Sender: TObject);
    procedure chkLockBtnEditClick(Sender: TObject);
    procedure chkLockBtnFolderClick(Sender: TObject);
    procedure chkLockBtnDragClick(Sender: TObject);
    procedure chkLockPadPropertyClick(Sender: TObject);
    procedure chkLockOptionClick(Sender: TObject);
    procedure chkLockPluginClick(Sender: TObject);
    procedure edtIconCacheChange(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure btnUserFolderResetClick(Sender: TObject);
    procedure btnUserFolderOpenClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure chkVerCheckClick(Sender: TObject);
  private
    FRestrictionsPassword: String;
    FEnabledApplyBk: Boolean;
    function SaveIni: Boolean;
    procedure EnabledCheck;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TSoundFile = class(TObject)
    FileName: String;
  end;

var
  dlgOption: TdlgOption;

implementation

uses Main, Password;

{$R *.DFM}

// CreateParams
procedure TdlgOption.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;


// フォームはじめ
procedure TdlgOption.FormCreate(Sender: TObject);
var
  Work: String;
  SoundAction: String;
  SoundFile: TSoundFile;
  i: Integer;
  Plugin: TPlugin;
  ListItem: TListItem;
  Icon:TIcon;
  Ini: TIniFile;
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  PageControl.ActivePage := PageControl.Pages[0];

  for i := 0 to lvPlugins.Columns.Count - 1 do
    lvPlugins.Columns[i].Width := UserIniFile.ReadInteger(IS_WINDOWS,
      Format('OptionPluginColumns%d', [i]), lvPlugins.Columns[i].Width);

  // 更新チェック
  chkVerCheck.Checked := UserIniFile.ReadBool(IS_OPTIONS, 'VerCheck', True);

  // タスクトレイ
  chkTaskTray.Checked := UserIniFile.ReadBool(IS_OPTIONS, 'TaskTray', True);

  // アイコンキャッシュ
  udIconCache.Position := UserIniFile.ReadInteger(IS_OPTIONS, 'IconCache', 1000);
  lblNowIconCache.Caption := Format('現在の使用量 : %d', [IconCache.CacheCount]);

  // サウンド
  for i := 0 to cmbSounds.Items.Count - 1 do
  begin
    SoundFile := TSoundFile.Create;
    cmbSounds.Items.Objects[i] := SoundFile;
    case i of
      0: SoundAction := 'ButtonClick';
      1: SoundAction := 'GroupChange';
      2: SoundAction := 'MoveHide';
      3: SoundAction := 'MoveShow';
    else
      SoundAction := '';
    end;
    if SoundAction <> '' then
    begin
      Work := UserIniFile.ReadString(IS_SOUNDS, SoundAction, '');
      if Work <> '' then
      begin
        SoundFile.FileName := Work;
      end;
    end;
  end;
  cmbSounds.ItemIndex := 0;
  cmbSoundsChange(cmbSounds);

  // 制限
  chkLockBtnDrag.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnDrag', False);
  chkLockBtnEdit.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnEdit', False);
  chkLockBtnFolder.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnFolder', False);
  chkLockPadProperty.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPadProperty', False);
  chkLockOption.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockOption', False);
  chkLockPlugin.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPlugin', False);
  FRestrictionsPassword :=  UserIniFile.ReadString(IS_RESTRICTIONS, 'Password', '');

  // データフォルダ
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    chkSettingForAllUser.Checked := Ini.ReadBool(IS_APPGENERAL, 'SettingForAllUser', False);
    edtUserFolder.Text := Ini.ReadString(IS_USERS, UserName, '');
    if edtUserFolder.Text = '' then
      btnUserFolderReset.Click;
  finally
    Ini.Free;
  end;


  EnabledCheck;

  // プラグイン
  lvPlugins.Items.BeginUpdate;
  try
    for i := 0 to Plugins.Count - 1 do
    begin
      Plugin := TPlugin(Plugins.Objects[i]);
      ListItem := lvPlugins.Items.Add;
      ListItem.Caption := Plugin.Name;
      if Plugin.Enabled then
        ListItem.SubItems.Add('起動')
      else
        ListItem.SubItems.Add('停止');

      ListItem.SubItems.Add(ExtractFileName(Plugin.FileName));
      ListItem.SubItems.Add(GetFileVersionString(Plugin.FileName, True));
      ListItem.Data := Plugin;
      Icon := TIcon.Create;
      try
        Icon.Handle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, 0, False, False);
        ListItem.ImageIndex := imlPlugins.AddIcon(Icon);
      finally
        Icon.Free;
      end;

      if i = 0 then
        ListItem.Focused := True;
    end;
  finally
    lvPlugins.Items.EndUpdate;
  end;
end;

// 保存
function TdlgOption.SaveIni: Boolean;
var
  i: Integer;
  SoundAction: String;
  Ini: TIniFile;
begin
  Result := True;

  if not UserIniReadOnly then
  begin
    try
      // 更新チェック
      UserIniFile.WriteBool(IS_OPTIONS, 'VerCheck', chkVerCheck.Checked);

      // タスクトレイ
      UserIniFile.WriteBool(IS_OPTIONS, 'TaskTray', chkTaskTray.Checked);

      // アイコンキャッシュ
      UserIniFile.WriteInteger(IS_OPTIONS, 'IconCache', udIconCache.Position);

      // サウンド
      for i := 0 to cmbSounds.Items.Count - 1 do
      begin
        case i of
          0: SoundAction := 'ButtonClick';
          1: SoundAction := 'GroupChange';
          2: SoundAction := 'MoveHide';
          3: SoundAction := 'MoveShow';
        else
          SoundAction := '';
        end;

        if SoundAction <> '' then
        begin
          UserIniFile.WriteString(IS_SOUNDS, SoundAction, TSoundFile(cmbSounds.Items.Objects[i]).FileName);
        end;
      end;

      // 制限
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnDrag', chkLockBtnDrag.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnEdit', chkLockBtnEdit.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnFolder', chkLockBtnFolder.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockPadProperty', chkLockPadProperty.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockOption', chkLockOption.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockPlugin', chkLockPlugin.Checked);
      UserIniFile.WriteString(IS_RESTRICTIONS, 'Password', FRestrictionsPassword);

      UserIniFile.UpdateFile;

    except
      Result := False;
      MessageBox(Handle, PChar('設定ファイル "' + UserIniFile.FileName +
                                   '" に書き込めません。'),
                             'エラー', MB_ICONSTOP);
    end;


    // ユーザーフォルダを削除
    if Result then
    begin
      if not btnUserFolderReset.Enabled then
      begin
        Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
        try
          try
            Ini.WriteString(IS_USERS, UserName, '');
          except
            Result := False;
            Application.MessageBox(PChar('設定ファイル "' + Ini.FileName + '" に書き込めません。'),
                                   'エラー', MB_ICONSTOP);
          end;
        finally
          Ini.Free;
        end;
      end;
    end;

    EnabledCheck;
    frmMain.ChangeOptions;

  end;
  
  if Result then
    btnApply.Enabled := False;
end;

// フォーム終わり
procedure TdlgOption.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cmbSounds.Items.Count - 1 do
    TSoundFile(cmbSounds.Items.Objects[i]).Free;

  imlPlugins.Clear;
  if not UserIniReadOnly then
  begin
    for i := 0 to lvPlugins.Columns.Count - 1 do
      UserIniFile.WriteInteger(IS_WINDOWS, Format('OptionPluginColumns%d', [i]), lvPlugins.Columns[i].Width);
    UserIniFile.UpdateFile;
  end;

  dlgOption := nil;
end;

// 閉じる
procedure TdlgOption.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// 閉じる前
procedure TdlgOption.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Enabled;
end;

// フォーム見える
procedure TdlgOption.FormShow(Sender: TObject);
begin
  PageControl.ActivePage.SetFocus;

  btnHelp.Enabled := FileExists(Application.HelpFile);
  btnApply.Enabled := False;
end;

// ＯＫボタン
procedure TdlgOption.btnOkClick(Sender: TObject);
begin
  if SaveIni then
    Close;
end;

// キャンセルボタン
procedure TdlgOption.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// 適用ボタン
procedure TdlgOption.btnApplyClick(Sender: TObject);
begin
  SaveIni;
end;

// タブを切り替える
procedure TdlgOption.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  FEnabledApplyBk := btnApply.Enabled;
end;

// タブを切り替える
procedure TdlgOption.PageControlChange(Sender: TObject);
begin
  btnApply.Enabled := FEnabledApplyBk;
end;

// 定期的に Special Launch の更新を確認する
procedure TdlgOption.chkVerCheckClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// タスクトレイにアイコンを表示する
procedure TdlgOption.chkTaskTrayClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// 音を鳴らす場面の変更
procedure TdlgOption.cmbSoundsChange(Sender: TObject);
begin
  FEnabledApplyBk := btnApply.Enabled;
  if cmbSounds.ItemIndex >= 0 then
    edtSoundName.Text := TSoundFile(cmbSounds.Items.Objects[cmbSounds.ItemIndex]).FileName;
  btnApply.Enabled := FEnabledApplyBk;
end;

// サウンド名の変更
procedure TdlgOption.edtSoundNameChange(Sender: TObject);
begin
  if cmbSounds.ItemIndex >= 0 then
  begin
    TSoundFile(cmbSounds.Items.Objects[cmbSounds.ItemIndex]).FileName := edtSoundName.Text;
    btnApply.Enabled := True;
  end;
end;

// サウンドのテスト
procedure TdlgOption.btnSoundTestClick(Sender: TObject);
begin
  if edtSoundName.Text <> '' then
    PlaySound(PChar(edtSoundName.Text), 0, SND_ASYNC);
end;

// サウンド名のクリア
procedure TdlgOption.btnSoundClearClick(Sender: TObject);
begin
  edtSoundName.Text := '';
end;

// サウンド名の参照
procedure TdlgOption.btnSoundBrowseClick(Sender: TObject);
begin
  if FileExists(edtSoundName.Text) then
    dlgOpen.FileName := edtSoundName.Text
  else
    dlgOpen.FileName := '';

  dlgOpen.Filter := 'サウンド(*.wav)|*.wav|すべてのファイル(*.*)|*.*';
  dlgOpen.FilterIndex := 1;

  if dlgOpen.Execute then
    edtSoundName.Text := dlgOpen.FileName;
end;

// アイコンキャッシュ
procedure TdlgOption.edtIconCacheChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;


// アイコンキャッシュのクリア
procedure TdlgOption.btnCacheClearClick(Sender: TObject);
begin
  IconCache.Clear;
  Pads.AllArrange;
  lblNowIconCache.Caption := Format('現在の使用量 : %d', [IconCache.CacheCount]);
  EnabledCheck
end;



// プラグイン一覧の変更
procedure TdlgOption.lvPluginsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then
  begin
    EnabledCheck;
  end;
end;

// プラグインの起動
procedure TdlgOption.btnPluginEnableClick(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  for i := 0 to Pads.Count - 1 do
    Pads[i].ButtonArrangement.Clear;

  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    TPlugin(Item.Data).Enabled := True;
    if TPlugin(Item.Data).Enabled then
    begin
      Item.SubItems[0] := '起動'
    end
    else
    begin
      MessageBox(Handle, 'プラグインが起動できませんでした。', '確認', MB_ICONWARNING);
      Item.SubItems[0] := '停止';
    end;
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
  end;
  Plugins.SaveEnabled;
  Pads.AllArrange;
  EnabledCheck;
end;

// プラグインの停止
procedure TdlgOption.btnPluginDisableClick(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  for i := 0 to Pads.Count - 1 do
    Pads[i].ButtonArrangement.Clear;

  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    TPlugin(Item.Data).Enabled := False;
    if TPlugin(Item.Data).Enabled then
    begin
      MessageBox(Handle, 'プラグインが停止できませんでした。', '確認', MB_ICONWARNING);
      Item.SubItems[0] := '起動'
    end
    else
      Item.SubItems[0] := '停止';
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
  end;
  Plugins.SaveEnabled;
  Pads.AllArrange;
  EnabledCheck;
end;

// プラグインの設定
procedure TdlgOption.btnPluginOptionClick(Sender: TObject);
var
  i: Integer;
  Plugin: TPlugin;
begin
  if lvPlugins.Selected <> nil then
  begin
    Plugin := lvPlugins.Selected.Data;

    if @Plugin.SLXChangeOptions <> nil then
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

// プラグインの情報
procedure TdlgOption.btnPluginInfoClick(Sender: TObject);
var
  Plugin: TPlugin;
  cWork: array[0..2047] of Char;
  Explanation: String;
begin
  if lvPlugins.Selected <> nil then
  begin

    Plugin := lvPlugins.Selected.Data;
    if Plugin.Enabled then
    begin
      cWork := '';
      if @Plugin.SLXGetExplanation <> nil then
      begin
        Plugin.SLXGetExplanation(cWork, 2048);
        Explanation := cWork;
      end
      else
      begin
        Explanation := 'このプラグインには説明がありません。';
      end;
    end
    else
    begin
      Explanation := 'このプラグインは起動していないため、説明を取得できません。';
    end;

    ShowAbout(Plugin.Name, Plugin.FileName, Explanation);
  end;
end;

// ボタンのドラッグを禁止
procedure TdlgOption.chkLockBtnDragClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// ボタンの編集を禁止
procedure TdlgOption.chkLockBtnEditClick(Sender: TObject);
begin
  if chkLockBtnEdit.Checked then
  begin
    chkLockBtnDrag.Checked := True;
  end;

  EnabledCheck;
  btnApply.Enabled := True;
end;

// パッドの設定を禁止
procedure TdlgOption.chkLockPadPropertyClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// 全体の設定を禁止
procedure TdlgOption.chkLockOptionClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// プラグインの設定を禁止
procedure TdlgOption.chkLockPluginClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// 1 つ上のフォルダを開くを禁止
procedure TdlgOption.chkLockBtnFolderClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;



// 制限パスワードロック
procedure TdlgOption.btnLockRestrictionsClick(Sender: TObject);
var
  sWork: String;
begin
  if FRestrictionsPassword <> '' then
    Exit;

  dlgPassword := TdlgPassword.Create(Self);
  try
    while True do
    begin
      dlgPassword.edtPassword.Text := '';
      dlgPassword.lblMessage.Caption := '制限をロックするパスワードを入力してください。';
      if dlgPassword.ShowModal = idOk then
      begin
        sWork := dlgPassword.edtPassword.Text;
        dlgPassword.edtPassword.Text := '';
        dlgPassword.lblMessage.Caption := '確認のため再度入力してください。';
        if dlgPassword.ShowModal = idOk then
        begin
          if sWork = dlgPassword.edtPassword.Text then
          begin
            FRestrictionsPassword := dlgPassword.edtPassword.Text;
            btnApply.Enabled := True;
            Break;
          end
          else
            MessageBox(Handle, 'パスワードが一致しません。', '確認', MB_ICONWARNING);
        end
        else
          Break;
      end
      else
        Break;
    end;

  finally
    dlgPassword.Release;
  end;

  EnabledCheck;

end;

// 制限パスワード解除
procedure TdlgOption.btnUnlockRestrictionsClick(Sender: TObject);
begin
  dlgPassword := TdlgPassword.Create(Self);
  try
    while True do
    begin
      dlgPassword.edtPassword.Text := '';
      dlgPassword.lblMessage.Caption := '制限のロックを解除するパスワードを入力してください。';
      if dlgPassword.ShowModal = idOk then
      begin
        if FRestrictionsPassword = dlgPassword.edtPassword.Text then
        begin
          FRestrictionsPassword := '';
          btnApply.Enabled := True;
          Break;
        end
        else
          MessageBox(Handle, 'パスワードが違います。', '確認', MB_ICONWARNING);
      end
      else
        Break;
    end;

  finally
    dlgPassword.Release;
  end;

  EnabledCheck;
end;

procedure TdlgOption.EnabledCheck;
var
  bLockOption: Boolean;
  bLockPlugin: Boolean;
  OneEnabled, OneDisabled: Boolean;
  Item: TListItem;
begin
  bLockOption := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockOption', False);
  bLockPlugin := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPlugin', False);

  tabGeneral.TabVisible := not bLockOption;
  tabUserFolder.TabVisible := not bLockOption;



  btnCacheClear.Enabled := IconCache.CacheCount > 0;

  grpRestrictions.Enabled := FRestrictionsPassword = '';
  chkLockBtnDrag.Enabled := (FRestrictionsPassword = '') and (not chkLockBtnEdit.Checked);
  chkLockBtnEdit.Enabled := FRestrictionsPassword = '';
  chkLockPadProperty.Enabled := FRestrictionsPassword = '';
  chkLockOption.Enabled := FRestrictionsPassword = '';
  chkLockPlugin.Enabled := FRestrictionsPassword = '';
  chkLockBtnFolder.Enabled := FRestrictionsPassword = '';
  btnLockRestrictions.Enabled := FRestrictionsPassword = '';
  btnUnlockRestrictions.Enabled := FRestrictionsPassword <> '';

  OneEnabled := False;
  OneDisabled := False;
  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    OneEnabled := OneEnabled or TPlugin(Item.Data).Enabled;
    OneDisabled := OneDisabled or (not TPlugin(Item.Data).Enabled);
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
    if OneEnabled and OneDisabled then
      Break;
  end;
  btnPluginEnable.Enabled := OneDisabled and not bLockPlugin;
  btnPluginDisable.Enabled := OneEnabled and not bLockPlugin;

  btnPluginOption.Enabled := (lvPlugins.SelCount = 1) and not OneDisabled;
  btnPluginInfo.Enabled := (lvPlugins.SelCount = 1) and not OneDisabled;

end;

// データフォルダを変更する
procedure TdlgOption.btnUserFolderResetClick(Sender: TObject);
begin
  btnUserFolderReset.Enabled := False;
  btnUserFolderOpen.Enabled := False;

  edtUserFolder.Enabled := False;
  edtUserFolder.Text := 'データフォルダは次回起動時に指定します。';
  btnApply.Enabled := True;
end;

// データフォルダを開く
procedure TdlgOption.btnUserFolderOpenClick(Sender: TObject);
var
  NormalButton: TNormalButton;
begin
  if not btnUserFolderOpen.Enabled then
    Exit;

  NormalButton := TNormalButton.Create;
  try
    NormalButton.FileName := edtUserFolder.Text;
    OpenNormalButton(Handle, NormalButton);
  finally
    NormalButton.Free;
  end;

end;

// ヘルプ
procedure TdlgOption.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 4);
end;

end.
