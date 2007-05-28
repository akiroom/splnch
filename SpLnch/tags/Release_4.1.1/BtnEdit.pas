unit BtnEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SetBtn, SetPads, ExtCtrls, ComCtrls, ImgList, SetIcons, BtnPro,
  Menus, SetInit, OleBtn, ActiveX;

type
  TNewOldGroup = class(TObject)
    New: TButtonGroup;
    Old: TButtonGroup;
  end;


  TdlgButtonEdit = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    imlGroups: TImageList;
    pnlMain: TPanel;
    pnlGroups: TPanel;
    Splitter1: TSplitter;
    pnlButtons: TPanel;
    btnGroupsAdd: TButton;
    btnGroupsRename: TButton;
    btnGroupsCopy: TButton;
    btnGroupsDelete: TButton;
    btnGroupsUp: TButton;
    btnGroupsDown: TButton;
    lvGroups: TListView;
    lblGroups: TLabel;
    lvButtons: TListView;
    btnButtonsAdd: TButton;
    btnButtonsModify: TButton;
    btnButtonsCopy: TButton;
    btnButtonsDelete: TButton;
    btnButtonsUp: TButton;
    btnButtonsDown: TButton;
    lblButtons: TLabel;
    imlButtons: TImageList;
    tmListButton: TTimer;
    tmDragCheck: TTimer;
    btnButtonsSpace: TButton;
    btnButtonsReturn: TButton;
    popGroups: TPopupMenu;
    A1: TMenuItem;
    R1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    V1: TMenuItem;
    D1: TMenuItem;
    popButtons: TPopupMenu;
    N2: TMenuItem;
    M1: TMenuItem;
    Copy2: TMenuItem;
    S1: TMenuItem;
    L1: TMenuItem;
    Delete2: TMenuItem;
    N3: TMenuItem;
    U1: TMenuItem;
    B1: TMenuItem;
    popButtonNameModify: TMenuItem;
    tmIsEditing: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnGroupsAddClick(Sender: TObject);
    procedure btnGroupsRenameClick(Sender: TObject);
    procedure btnGroupsCopyClick(Sender: TObject);
    procedure btnGroupsDeleteClick(Sender: TObject);
    procedure btnGroupsUpClick(Sender: TObject);
    procedure btnGroupsDownClick(Sender: TObject);
    procedure lvGroupsEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure lvGroupsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure tmListButtonTimer(Sender: TObject);
    procedure btnButtonsUpClick(Sender: TObject);
    procedure btnButtonsDownClick(Sender: TObject);
    procedure lvButtonsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnButtonsCopyClick(Sender: TObject);
    procedure btnButtonsDeleteClick(Sender: TObject);
    procedure lvGroupsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvGroupsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvButtonsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvButtonsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lvEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure tmDragCheckTimer(Sender: TObject);
    procedure btnButtonsAddClick(Sender: TObject);
    procedure btnButtonsModifyClick(Sender: TObject);
    procedure btnButtonsSpaceClick(Sender: TObject);
    procedure btnButtonsReturnClick(Sender: TObject);
    procedure lvButtonsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure lvButtonsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure popButtonNameModifyClick(Sender: TObject);
    procedure lvGroupsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure tmIsEditingTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FOnWindowActivate: TNotifyEvent;
    FOnWindowDeactivate: TNotifyEvent;
    FOnApply: TNotifyEvent;
    FOnClosed: TNotifyEvent;
    FlvGroupsPreWndProc: TWndMethod;
    FlvButtonsPreWndProc: TWndMethod;
    FSelGroup: TButtonGroup;
    FDropTarget: TDropTarget;
    procedure lvGroupsWndProc(var Msg: TMessage);
    procedure lvButtonsWndProc(var Msg: TMessage);
    procedure dlgBtnPropertyApply(Sender: TObject); // dlgBtnPropertyのOnApply
    procedure SaveGroups;
    procedure SetSelGroup(Value: TButtonGroup);
    procedure SaveButtons;
    procedure ListViewDragDrop(ListView: TListView; TargetItem: TListItem);
    function ListViewItemAtY(ListView: TListView; Y: Integer): TListItem;

    function GetDropEnabled: Boolean;
    procedure SetDropEnabled(Value: Boolean);
    procedure OleDragEnter(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragOver(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragDrop(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragLeave;
  protected
    property SelGroup: TButtonGroup read FSelGroup write SetSelGroup;
  public
    property DropEnabled: Boolean Read GetDropEnabled write SetDropEnabled;
    property OnWindowActivate: TNotifyEvent read FOnWindowActivate write FOnWindowActivate;
    property OnWindowDeactivate: TNotifyEvent read FOnWindowDeactivate write FOnWindowDeactivate;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    property OnClosed: TNotifyEvent read FOnClosed write FOnClosed;
    procedure SetOriginalGroups(ButtonGroups: TButtonGroups);
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  end;

implementation


{$R *.DFM}

// MinMaxInfo
procedure TdlgButtonEdit.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  inherited;
  Msg.MinMaxInfo.ptMinTrackSize := Point(520, 350);
end;

// フォームはじめ
procedure TdlgButtonEdit.FormCreate(Sender: TObject);
begin
//  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  // ListView の WindowProc を置き換える
  FlvGroupsPreWndProc := lvGroups.WindowProc;
  lvGroups.WindowProc := lvGroupsWndProc;
  FlvButtonsPreWndProc := lvButtons.WindowProc;
  lvButtons.WindowProc := lvButtonsWndProc;
  // 画像読み込み
  imlGroups.ResInstLoad(hInstance, rtBitmap, 'GROUPS', clFuchsia);

  DropEnabled := True;

end;

// フォーム見える
procedure TdlgButtonEdit.FormShow(Sender: TObject);
begin
  btnApply.Enabled := False;
end;

procedure TdlgButtonEdit.WMActivate(var Msg: TWMActivate);
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


// TListViewのハンドラを書き換える
procedure TdlgButtonEdit.lvGroupsWndProc(var Msg: TMessage);
begin
  FlvGroupsPreWndProc(Msg);

  if Msg.Msg = CM_WANTSPECIALKEY then
  begin
    case TWMKey(Msg).CharCode of
      VK_ESCAPE,
      VK_RETURN:
        if lvGroups.IsEditing then
          Msg.Result := 1;
    end;
  end;
end;

// TListViewのハンドラを書き換える
procedure TdlgButtonEdit.lvButtonsWndProc(var Msg: TMessage);
begin
  FlvButtonsPreWndProc(Msg);

  if Msg.Msg = CM_WANTSPECIALKEY then
    case TWMKey(Msg).CharCode of
      VK_ESCAPE,
      VK_RETURN:
        if lvButtons.IsEditing then
          Msg.Result := 1;
    end;
end;

// フォーム終わり
procedure TdlgButtonEdit.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  DropEnabled := False;

  SelGroup := nil;
  for i := 0 to lvGroups.Items.Count - 1 do
  begin
    TNewOldGroup(lvGroups.Items[i].Data).New.Free;
    TNewOldGroup(lvGroups.Items[i].Data).Free;
  end;
end;

// フォーム閉じる
procedure TdlgButtonEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FOnClosed) then
    FOnClosed(Self);
end;


// ボタングループセット
procedure TdlgButtonEdit.SetOriginalGroups(ButtonGroups: TButtonGroups);
var
  i: Integer;
  Item: TListItem;
  NewOldGroup: TNewOldGroup;
begin
  if ButtonGroups is TButtonGroups then
  begin
    lvGroups.Items.BeginUpdate;
    for i := 0 to ButtonGroups.Count - 1 do
    begin
      NewOldGroup := TNewOldGroup.Create;
      NewOldGroup.New := TButtonGroup.Create;
      NewOldGroup.New.Assign(ButtonGroups[i]);
      NewOldGroup.Old := ButtonGroups[i];
      Item := lvGroups.Items.Add;
      Item.Caption := NewOldGroup.New.Name;
      Item.Data := NewOldGroup;
    end;
    lvGroups.Items.EndUpdate;
  end;
end;

// 保存
procedure TdlgButtonEdit.SaveGroups;
begin
  tmListButton.Enabled := False;

  SelGroup := nil;

  if lvGroups.Items.Count = 0 then
  begin
    Application.MessageBox('ボタングループが存在しないので作成します。', '確認', MB_ICONINFORMATION);
    btnGroupsAdd.Click;
  end;

  if Assigned(FOnApply) then
    FOnApply(Self);

  tmListButton.Enabled := True;
  btnApply.Enabled := False;
end;

// ＯＫボタン
procedure TdlgButtonEdit.btnOkClick(Sender: TObject);
begin
  SaveGroups;
  Close;
end;

// キャンセルボタン
procedure TdlgButtonEdit.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// 適用ボタン
procedure TdlgButtonEdit.btnApplyClick(Sender: TObject);
begin
  SaveGroups;
end;

// ボタングループリストの変更
procedure TdlgButtonEdit.lvGroupsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if Change = ctState then
  begin
    tmListButton.Enabled := False;
    btnGroupsRename.Enabled := (lvGroups.SelCount = 1) and not lvGroups.IsEditing;
    btnGroupsCopy.Enabled := lvGroups.SelCount > 0;
    btnGroupsDelete.Enabled := lvGroups.SelCount > 0;
    btnGroupsUp.Enabled := lvGroups.SelCount > 0;
    btnGroupsDown.Enabled := lvGroups.SelCount > 0;
    tmListButton.Enabled := True;
  end;

end;

// ボタングループ名変更後
procedure TdlgButtonEdit.lvGroupsEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin
  S := Trim(S);
  if TNewOldGroup(Item.Data).New.Name <> S then
  begin
    TNewOldGroup(Item.Data).New.Name := S;
    btnApply.Enabled := True;
  end;
end;

// ボタングループ名編集直前
procedure TdlgButtonEdit.lvGroupsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  lvGroups.PopupMenu := nil;
  tmIsEditing.Enabled := True;
end;


// グループ新規
procedure TdlgButtonEdit.btnGroupsAddClick(Sender: TObject);
var
  NewOldGroup: TNewOldGroup;
  Item: TListItem;
begin
  NewOldGroup := TNewOldGroup.Create;
  NewOldGroup.New := TButtonGroup.Create;
  NewOldGroup.New.Name := '新規';
  NewOldGroup.Old := nil;
  Item := lvGroups.Items.Add;
  Item.Caption := NewOldGroup.New.Name;
  Item.Data := NewOldGroup;
  Item.EditCaption;
  btnApply.Enabled := True;
end;

// グループ変更
procedure TdlgButtonEdit.btnGroupsRenameClick(Sender: TObject);
begin
  if lvGroups.Selected <> nil then
    lvGroups.Selected.EditCaption;
end;

// グループ複写
procedure TdlgButtonEdit.btnGroupsCopyClick(Sender: TObject);
var
  i: Integer;
  NewOldGroup: TNewOldGroup;
  Item: TListItem;
  List: TList;
begin
  SaveButtons;
  List := TList.Create;
  lvGroups.Items.BeginUpdate;
  try
    Item := lvGroups.Selected;
    while Item <> nil do
    begin
      List.Add(Item);
      Item := lvGroups.GetNextItem(Item, sdAll, [isSelected]);
    end;

    for i := 0 to List.Count - 1 do
    begin
      NewOldGroup := TNewOldGroup.Create;
      NewOldGroup.New := TButtonGroup.Create;
      NewOldGroup.New.Assign(TNewOldGroup(TListItem(List[i]).Data).New);
      NewOldGroup.Old := nil;
      Item := lvGroups.Items.Insert(TListItem(List[0]).Index);
      Item.Caption := NewOldGroup.New.Name;
      Item.Data := NewOldGroup;
    end;

  finally
    List.Free;
    lvGroups.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;

// グループ削除
procedure TdlgButtonEdit.btnGroupsDeleteClick(Sender: TObject);
var
  Item, Next: TListItem;
begin
  if lvGroups.SelCount = 0 then
    Exit;

  lvGroups.Items.BeginUpdate;
  try
    SelGroup := nil;
    Item := lvGroups.Selected;
    while Item <> nil do
    begin
      Next := lvGroups.GetNextItem(Item, sdAll, [isSelected]);
      TNewOldGroup(Item.Data).New.Free;
      TNewOldGroup(Item.Data).Free;
      Item.Delete;
      Item := Next;
    end;

  finally
    lvGroups.Items.EndUpdate;
  end;

  btnApply.Enabled := True;
end;

// グループ上へ
procedure TdlgButtonEdit.btnGroupsUpClick(Sender: TObject);
var
  i: Integer;
  DataBk: TObject;
  CaptionBk: string;
  ImageIndexBk: Integer;
begin
  if lvGroups.Selected = nil then
    Exit;

  lvGroups.Items.BeginUpdate;
  try

    for i := 1 to lvGroups.Items.Count - 1 do
    begin
      if lvGroups.Items[i].Selected then
        if not lvGroups.Items[i - 1].Selected then
        begin
          DataBk := lvGroups.Items[i - 1].Data;
          CaptionBk := lvGroups.Items[i - 1].Caption;
          ImageIndexBk := lvGroups.Items[i - 1].ImageIndex;
          lvGroups.Items[i - 1].Data := lvGroups.Items[i].Data;
          lvGroups.Items[i - 1].Caption := lvGroups.Items[i].Caption;
          lvGroups.Items[i - 1].ImageIndex := lvGroups.Items[i].ImageIndex;
          lvGroups.Items[i - 1].Selected := True;
          lvGroups.Items[i].Data := DataBk;
          lvGroups.Items[i].Caption := CaptionBk;
          lvGroups.Items[i].ImageIndex := ImageIndexBk;
          lvGroups.Items[i].Selected := False;
        end;
    end;

    lvGroups.Selected.MakeVisible(True);

  finally
    lvGroups.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;

// グループ下へ
procedure TdlgButtonEdit.btnGroupsDownClick(Sender: TObject);
var
  i: Integer;
  DataBk: TObject;
  CaptionBk: string;
  ImageIndexBk: Integer;
begin
  if lvGroups.Selected = nil then
    Exit;

  lvGroups.Items.BeginUpdate;
  try

    for i := lvGroups.Items.Count - 1 downto 1 do
    begin
      if lvGroups.Items[i - 1].Selected then
        if not lvGroups.Items[i].Selected then
        begin
          DataBk := lvGroups.Items[i - 1].Data;
          CaptionBk := lvGroups.Items[i - 1].Caption;
          ImageIndexBk := lvGroups.Items[i - 1].ImageIndex;
          lvGroups.Items[i - 1].Data := lvGroups.Items[i].Data;
          lvGroups.Items[i - 1].Caption := lvGroups.Items[i].Caption;
          lvGroups.Items[i - 1].ImageIndex := lvGroups.Items[i].ImageIndex;
          lvGroups.Items[i - 1].Selected := False;
          lvGroups.Items[i].Data := DataBk;
          lvGroups.Items[i].Caption := CaptionBk;
          lvGroups.Items[i].ImageIndex := ImageIndexBk;
          lvGroups.Items[i].Selected := True;
        end;
    end;

    lvGroups.Selected.MakeVisible(True);

  finally
    lvGroups.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;


// ボタン一覧の変更
procedure TdlgButtonEdit.lvButtonsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then
  begin
    btnButtonsModify.Enabled := (lvButtons.SelCount = 1) and
      ((TButtonData(lvButtons.Selected.Data) is TNormalButton) or
      (TButtonData(lvButtons.Selected.Data) is TPluginButton));
    btnButtonsCopy.Enabled := lvButtons.SelCount > 0;
    btnButtonsDelete.Enabled := lvButtons.SelCount > 0;
    btnButtonsUp.Enabled := lvButtons.SelCount > 0;
    btnButtonsDown.Enabled := lvButtons.SelCount > 0;
  end;
end;


// ボタンの一覧表示
procedure TdlgButtonEdit.tmListButtonTimer(Sender: TObject);
var
  Group: TButtonGroup;
begin
  tmListButton.Enabled := False;

  if lvGroups.SelCount = 1 then
    Group := TNewOldGroup(lvGroups.Selected.Data).New
  else
    Group := nil;

  SelGroup := Group;
end;

// ボタンデータを反映する
procedure TdlgButtonEdit.SaveButtons;
var
  i: Integer;
begin
  if FSelGroup <> nil then
  begin
    FSelGroup.Clear(False);
    for i := 0 to lvButtons.Items.Count - 1 do
      FSelGroup.Add(lvButtons.Items[i].Data);
  end;

end;

// 現在のグループを変更
procedure TdlgButtonEdit.SetSelGroup(Value: TButtonGroup);
var
  i: Integer;
  Item: TListItem;
  ButtonData: TButtonData;
  Icon: TIcon;
  Bitmap: TBitmap;
begin

  if Value = SelGroup then
    Exit;

  SaveButtons;

  lvButtons.Items.BeginUpdate;
  try
    imlButtons.Clear;
    imlButtons.ResInstLoad(hInstance, rtBitmap, 'BUTTONS', clFuchsia);

    lvButtons.Items.Clear;
    FSelGroup := Value;
    btnButtonsAdd.Enabled := FSelGroup <> nil;
    btnButtonsSpace.Enabled := FSelGroup <> nil;
    btnButtonsReturn.Enabled := FSelGroup <> nil;
    if FSelGroup <> nil then
    begin

      for i := 0 to FSelGroup.Count - 1 do
      begin
        ButtonData := FSelGroup[i];
        Item := lvButtons.Items.Add;
        Item.Data := ButtonData;

        if Item.Index = 0 then
          Item.Focused := True;

        // 空白
        if ButtonData is TSpaceButton then
        begin
          Item.Caption := '空白';
          Item.ImageIndex := BTN_SPACE;
        end

        // 改行
        else if ButtonData is TReturnButton then
        begin
          Item.Caption := '改行';
          Item.ImageIndex := BTN_RETURN;
        end

        // ノーマルボタン
        else if ButtonData is TNormalButton then
        begin
          Item.Caption := ButtonData.Name;
          Icon := TIcon.Create;
          Bitmap := TBitmap.Create;
          Bitmap.Canvas.Brush.Color := lvButtons.Color;
          try
            with TNormalButton(ButtonData) do
            begin
              if IconFile <> '' then
                Icon.Handle := IconCache.GetIcon(PChar(IconFile), ftIconPath, IconIndex, True, True)
              else if ItemIDList <> nil then
                Icon.Handle := IconCache.GetIcon(ItemIDList, ftPIDL, IconIndex, True, True)
              else
                Icon.Handle := IconCache.GetIcon(PChar(FileName), ftFilePath, IconIndex, True, True);
            end;
            Bitmap.Width := imlButtons.Width;
            Bitmap.Height := imlButtons.Height;
            DrawIconEx(Bitmap.Canvas.Handle, 0, 0, Icon.Handle, Bitmap.Width, Bitmap.Height, 0, 0, DI_NORMAL);
            Item.ImageIndex := imlButtons.Add(Bitmap, nil);
//            Item.ImageIndex := imlButtons.AddIcon(Icon);
          finally
            Icon.Free;
            Bitmap.Free;
          end;
        end

        // プラグイン
        else if ButtonData is TPluginButton then
        begin
          Item.Caption := ButtonData.Name;
          Item.ImageIndex := BTN_PLUGIN;
        end;

      end;

      FSelGroup.Clear(False);
    end;

  finally
    lvButtons.Items.EndUpdate;
  end;
end;

// ボタン複写
procedure TdlgButtonEdit.btnButtonsCopyClick(Sender: TObject);
var
  i: Integer;
  ButtonData: TButtonData;
  Item: TListItem;
  List: TList;
begin
  List := TList.Create;
  lvButtons.Items.BeginUpdate;
  try
    Item := lvButtons.Selected;
    while Item <> nil do
    begin
      List.Add(Item);
      Item := lvButtons.GetNextItem(Item, sdAll, [isSelected]);
    end;

    for i := 0 to List.Count - 1 do
    begin
      ButtonData := TButtonDataClass(TButtonData(TListItem(List[i]).Data).ClassType).Create;
      ButtonData.Assign(TListItem(List[i]).Data);
      Item := lvButtons.Items.Insert(TListItem(List[0]).Index);
      Item.Caption := TListItem(List[i]).Caption;
      Item.ImageIndex := TListItem(List[i]).ImageIndex;
      Item.Data := ButtonData;
    end;

    btnApply.Enabled := True;
  finally
    List.Free;
    lvButtons.Items.EndUpdate;
  end;
end;



// ボタン削除
procedure TdlgButtonEdit.btnButtonsDeleteClick(Sender: TObject);
var
  Item, Next: TListItem;
begin
  if lvButtons.SelCount = 0 then
    Exit;

  lvButtons.Items.BeginUpdate;
  try

    Item := lvButtons.Selected;
    while Item <> nil do
    begin
      Next := lvButtons.GetNextItem(Item, sdAll, [isSelected]);
      TButtonData(Item.Data).Free;
      Item.Delete;
      Item := Next;
    end;

  finally
    lvButtons.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;


// ボタン上
procedure TdlgButtonEdit.btnButtonsUpClick(Sender: TObject);
var
  i: Integer;
  DataBk: TObject;
  CaptionBk: string;
  ImageIndexBk: Integer;
begin
  if lvButtons.Selected = nil then
    Exit;

  lvButtons.Items.BeginUpdate;
  try

    for i := 1 to lvButtons.Items.Count - 1 do
    begin
      if lvButtons.Items[i].Selected then
        if not lvButtons.Items[i - 1].Selected then
        begin
          DataBk := lvButtons.Items[i - 1].Data;
          CaptionBk := lvButtons.Items[i - 1].Caption;
          ImageIndexBk := lvButtons.Items[i - 1].ImageIndex;
          lvButtons.Items[i - 1].Data := lvButtons.Items[i].Data;
          lvButtons.Items[i - 1].Caption := lvButtons.Items[i].Caption;
          lvButtons.Items[i - 1].ImageIndex := lvButtons.Items[i].ImageIndex;
          lvButtons.Items[i - 1].Selected := True;
          lvButtons.Items[i].Data := DataBk;
          lvButtons.Items[i].Caption := CaptionBk;
          lvButtons.Items[i].ImageIndex := ImageIndexBk;
          lvButtons.Items[i].Selected := False;
        end;
    end;

    lvButtons.Selected.MakeVisible(True);

  finally
    lvButtons.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;

// ボタン下
procedure TdlgButtonEdit.btnButtonsDownClick(Sender: TObject);
var
  i: Integer;
  DataBk: TObject;
  CaptionBk: string;
  ImageIndexBk: Integer;
begin
  if lvButtons.Selected = nil then
    Exit;

  lvButtons.Items.BeginUpdate;
  try

    for i := lvButtons.Items.Count - 1 downto 1 do
    begin
      if lvButtons.Items[i - 1].Selected then
        if not lvButtons.Items[i].Selected then
        begin
          DataBk := lvButtons.Items[i - 1].Data;
          CaptionBk := lvButtons.Items[i - 1].Caption;
          ImageIndexBk := lvButtons.Items[i - 1].ImageIndex;
          lvButtons.Items[i - 1].Data := lvButtons.Items[i].Data;
          lvButtons.Items[i - 1].Caption := lvButtons.Items[i].Caption;
          lvButtons.Items[i - 1].ImageIndex := lvButtons.Items[i].ImageIndex;
          lvButtons.Items[i - 1].Selected := False;
          lvButtons.Items[i].Data := DataBk;
          lvButtons.Items[i].Caption := CaptionBk;
          lvButtons.Items[i].ImageIndex := ImageIndexBk;
          lvButtons.Items[i].Selected := True;
        end;
    end;

    lvButtons.Selected.MakeVisible(True);

  finally
    lvButtons.Items.EndUpdate;
  end;
  btnApply.Enabled := True;
end;

// グループドラッグドロップ
procedure TdlgButtonEdit.lvGroupsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  i: Integer;
  TargetItem, Item: TListItem;
  ButtonGroup: TButtonGroup;
  List: TList;
begin
  TargetItem := lvGroups.GetItemAt(X, Y);
  if TargetItem = nil then
    Exit;


  // グループからグループ
  if Source = lvGroups then
  begin
    ListViewDragDrop(lvGroups, TargetItem);
  end

  // ボタンからグループ
  else if Source = lvButtons then
  begin

    ButtonGroup := TNewOldGroup(TargetItem.Data).New;
    if ButtonGroup = FSelGroup then
      Exit;

    List := TList.Create;
    lvButtons.Items.BeginUpdate;
    try

      Item := lvButtons.Selected;
      while Item <> nil do
      begin
        List.Add(Item);
        Item := lvButtons.GetNextItem(Item, sdAll, [isSelected]);
      end;


      for i := 0 to List.Count - 1 do
      begin
        ButtonGroup.Add(TListItem(List[i]).Data);
        TListItem(List[i]).Delete;
      end;

    finally
      List.Free;
      lvButtons.Items.EndUpdate;
    end;

  end;

  btnApply.Enabled := True;
end;

// グループドラッグオーバー
procedure TdlgButtonEdit.lvGroupsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  OverItem: TListItem;
begin

  if (Source <> lvGroups) and (Source <> lvButtons) then
  begin
    Accept := False;
    Exit;
  end;

  OverItem := lvGroups.GetItemAt(X, Y);

  if OverItem <> nil then
    Accept := not OverItem.Selected
  else
    Accept := False;
end;

// ボタンドラッグドロップ
procedure TdlgButtonEdit.lvButtonsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  TargetItem: TListItem;
begin
  TargetItem := lvButtons.GetItemAt(X, Y);
  if TargetItem = nil then
    Exit;

  // ボタンからボタン
  if Source = lvButtons then
  begin
    ListViewDragDrop(lvButtons, TargetItem);
  end;
  btnApply.Enabled := True;
end;


// ボタンドラッグオーバー
procedure TdlgButtonEdit.lvButtonsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  OverItem: TListItem;
begin
  if Source <> lvButtons then
  begin
    Accept := False;
    Exit;
  end;

  OverItem := lvButtons.GetItemAt(X, Y);

  if OverItem <> nil then
    Accept := not OverItem.Selected
  else
    Accept := False;
end;


// リストビューの編集終了
procedure TdlgButtonEdit.lvButtonsEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  S := Trim(S);
  if (TButtonData(lvButtons.Selected.Data) is TNormalButton) or
    (TButtonData(lvButtons.Selected.Data) is TPluginButton) then
  begin
    if TButtonData(lvButtons.Selected.Data).Name <> S then
    begin
      TButtonData(lvButtons.Selected.Data).Name := S;
      btnApply.Enabled := True;
    end;
  end;
end;

// リストビューの編集開始
procedure TdlgButtonEdit.lvButtonsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := (TButtonData(lvButtons.Selected.Data) is TNormalButton) or
    (TButtonData(lvButtons.Selected.Data) is TPluginButton);

  if AllowEdit then
  begin
    lvButtons.PopupMenu := nil;
    tmIsEditing.Enabled := True;
  end;
end;


// リストビューのドラッグで移動
procedure TdlgButtonEdit.ListViewDragDrop(ListView: TListView; TargetItem: TListItem);
var
  i: Integer;
  Item: TListItem;
  List: TList;
  NextInsert: Boolean;
begin
  if (TargetItem = nil) or (ListView.Selected = nil) then
    Exit;

  List := TList.Create;
  ListView.Items.BeginUpdate;
  try

    Item := ListView.Selected;
    while Item <> nil do
    begin
      List.Add(Item);
      Item := ListView.GetNextItem(Item, sdAll, [isSelected]);
    end;

    NextInsert := TargetItem.Index > ListView.Selected.Index;

    for i := 0 to List.Count - 1 do
    begin

      if NextInsert then
        TargetItem := ListView.Items.Insert(TargetItem.Index + 1)
      else
      begin
        TargetItem := ListView.Items.Insert(TargetItem.Index);
        NextInsert := True;
      end;

      Item := List[i];
      TargetItem.ImageIndex := Item.ImageIndex;
      TargetItem.Caption := Item.Caption;
      TargetItem.Data := Item.Data;
      TargetItem.Selected := True;
      Item.Delete;
    end;
    ListView.ItemFocused := ListView.Selected;

  finally
    List.Free;
    ListView.Items.EndUpdate;
  end;
end;

// ドラッグ開始
procedure TdlgButtonEdit.lvStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Sender = lvButtons then
    tmDragCheck.Tag := 1
  else
    tmDragCheck.Tag := 0;
  tmDragCheck.Enabled := True;
end;

// ドラッグ終了
procedure TdlgButtonEdit.lvEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  tmDragCheck.Enabled := False;
end;

// ドラッグ中のチェック
procedure TdlgButtonEdit.tmDragCheckTimer(Sender: TObject);
var
  ListView: TListView;
  CurPos: TPoint;
begin
  if tmDragCheck.Tag = 0 then
    ListView := lvGroups
  else
    ListView := lvButtons;

  GetCursorPos(CurPos);
  with ListView do
  begin
    CurPos := ScreenToClient(CurPos);
    if (CurPos.x >= 0) and (CurPos.x < ClientWidth) then
    begin
      if CurPos.y < 0 then
        Scroll(0, CurPos.y)
      else if CurPos.y > Height then
        Scroll(0, CurPos.y - Height);
    end;
  end;

  if tmDragCheck.Tag = 1 then
  begin
    GetCursorPos(CurPos);
    with lvGroups do
    begin
      CurPos := ScreenToClient(CurPos);
      if (CurPos.x >= 0) and (CurPos.x < ClientWidth) then
      begin
        if CurPos.y < 0 then
          Scroll(0, CurPos.y)
        else if CurPos.y > Height then
          Scroll(0, CurPos.y - Height);
      end;
    end;

  end;

end;

// ボタンの追加
procedure TdlgButtonEdit.btnButtonsAddClick(Sender: TObject);
var
  dlgBtnProperty: TdlgBtnProperty;
begin
  dlgBtnProperty := TdlgBtnProperty.Create(nil);
  try
    dlgBtnProperty.OnApply := dlgBtnPropertyApply;
    dlgBtnProperty.SetOriginalButton(nil);
    dlgBtnProperty.ShowModal;
  finally
    dlgBtnProperty.Release;
  end;
end;

// ボタンの名前変更
procedure TdlgButtonEdit.popButtonNameModifyClick(Sender: TObject);
begin
  if lvButtons.Selected <> nil then
    lvButtons.Selected.EditCaption;
end;

// ボタンの変更
procedure TdlgButtonEdit.btnButtonsModifyClick(Sender: TObject);
var
  dlgBtnProperty: TdlgBtnProperty;
begin
  if (lvButtons.SelCount = 1) and
      not (TButtonData(lvButtons.Selected.Data) is TSpaceButton) and
      not (TButtonData(lvButtons.Selected.Data) is TReturnButton) then
  begin
    dlgBtnProperty := TdlgBtnProperty.Create(nil);
    try
      dlgBtnProperty.OnApply := dlgBtnPropertyApply;
      dlgBtnProperty.SetOriginalButton(lvButtons.Selected.Data);
      dlgBtnProperty.ShowModal;
    finally
      dlgBtnProperty.Release;
    end;
  end;
end;

// ボタンのプロパティ適用
procedure TdlgButtonEdit.dlgBtnPropertyApply(Sender: TObject);
var
  ButtonData: TButtonData;
  AIcon: TIcon;
  Item, NewItem, NextItem: TListItem;
begin
  lvButtons.Items.BeginUpdate;
  try

    with (Sender as TdlgBtnProperty) do
    begin
      Show;

      ButtonData := CreateResultButton;

      // １つでも選択していたらその直後に追加する
      if lvButtons.SelCount = 0 then
      begin
        NewItem := lvButtons.Items.Add;
      end
      else
      begin

        NewItem := lvButtons.Items.Insert(lvButtons.Selected.Index + 1);
        Item := lvButtons.Selected;
        while Item <> nil do
        begin
          NextItem := lvButtons.GetNextItem(Item, sdAll, [isSelected]);

          if AddMode then
            Item.Selected := False
          else
          begin
            TButtonData(Item.Data).Free;
            Item.Delete;
          end;

          Item := NextItem;
        end;
      end;

      NewItem.Data := ButtonData;
      NewItem.Focused := True;
      NewItem.Selected := True;
      NewItem.MakeVisible(False);

      // ノーマルボタン
      if ButtonData is TNormalButton then
      begin
        NewItem.Caption := ButtonData.Name;
        AIcon := TIcon.Create;
        try
          with TNormalButton(ButtonData) do
          begin
            if IconFile <> '' then
              AIcon.Handle := IconCache.GetIcon(PChar(IconFile), ftIconPath, IconIndex, True, True)
            else if ItemIDList <> nil then
              AIcon.Handle := IconCache.GetIcon(ItemIDList, ftPIDL, IconIndex, True, True)
            else
              AIcon.Handle := IconCache.GetIcon(PChar(FileName), ftFilePath, IconIndex, True, True);
          end;
          NewItem.ImageIndex := imlButtons.AddIcon(AIcon);
        finally
          AIcon.Free;
        end;
      end

      // プラグイン
      else if ButtonData is TPluginButton then
      begin
        NewItem.Caption := ButtonData.Name;
        NewItem.ImageIndex := BTN_PLUGIN;
      end

      // ボタン以外
      else
      begin
        NewItem.Delete;
        ButtonData.Free;
      end;

      btnApply.Enabled := True;
    end;

  finally
    lvButtons.Items.EndUpdate;
  end;

end;

// 空白ボタン
procedure TdlgButtonEdit.btnButtonsSpaceClick(Sender: TObject);
var
  ButtonData: TButtonData;
  Item, NewItem: TListItem;
begin
  // １つでも選択していたらその直後に追加する
  if lvButtons.SelCount = 0 then
  begin
    NewItem := lvButtons.Items.Add;
  end
  else
  begin
    NewItem := lvButtons.Items.Insert(lvButtons.Selected.Index + 1);
    Item := lvButtons.Selected;
    while Item <> nil do
    begin
      Item.Selected := False;
      Item := lvButtons.GetNextItem(Item, sdAll, [isSelected]);
    end;
  end;

  ButtonData := TSpaceButton.Create;
  NewItem.Caption := '空白';
  NewItem.ImageIndex := BTN_SPACE;
  NewItem.Data := ButtonData;
  NewItem.Focused := True;
  NewItem.Selected := True;
  NewItem.MakeVisible(False);
  btnApply.Enabled := True;
end;

// 改行ボタン
procedure TdlgButtonEdit.btnButtonsReturnClick(Sender: TObject);
var
  ButtonData: TButtonData;
  Item, NewItem: TListItem;
begin
  // １つでも選択していたらその直後に追加する
  if lvButtons.SelCount = 0 then
  begin
    NewItem := lvButtons.Items.Add;
  end
  else
  begin
    NewItem := lvButtons.Items.Insert(lvButtons.Selected.Index + 1);
    Item := lvButtons.Selected;
    while Item <> nil do
    begin
      Item.Selected := False;
      Item := lvButtons.GetNextItem(Item, sdAll, [isSelected]);
    end;
  end;

  ButtonData := TReturnButton.Create;
  NewItem.Caption := '改行';
  NewItem.ImageIndex := BTN_RETURN;
  NewItem.Data := ButtonData;
  NewItem.Focused := True;
  NewItem.Selected := True;
  NewItem.MakeVisible(False);
  btnApply.Enabled := True;
end;

// 編集中かをチェック
procedure TdlgButtonEdit.tmIsEditingTimer(Sender: TObject);
begin
  if not lvGroups.IsEditing then
    lvGroups.PopupMenu := popGroups;
  if not lvButtons.IsEditing then
    lvButtons.PopupMenu := popButtons;
  tmIsEditing.Enabled := lvGroups.IsEditing or lvButtons.IsEditing;
end;


// エクスプローラからドロップ受付
function TdlgButtonEdit.GetDropEnabled: Boolean;
begin
  Result := FDropTarget <> nil;
end;

// エクスプローラからドロップ受付
procedure TdlgButtonEdit.SetDropEnabled(Value: Boolean);
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
    FDropTarget.OnDragDrop := OleDragDrop;
    FDropTarget.OnDragLeave := OleDragLeave;

    CoLockObjectExternal(FDropTarget, True, False);
    RegisterDragDrop(lvButtons.Handle, FDropTarget);
  end
  else
  begin
    RevokeDragDrop(lvButtons.Handle);
    CoLockObjectExternal(FDropTarget, False, True);
    FDropTarget := nil;
  end;
end;

// エクスプローラからドラッグ入る
procedure TdlgButtonEdit.OleDragEnter(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
begin
//  lvButtons.SetFocus;
end;

// エクスプローラからドラッグオーバー
procedure TdlgButtonEdit.OleDragOver(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
var
  Item: TListItem;
begin
  Point := lvButtons.ScreenToClient(Point);
  Item := ListViewItemAtY(lvButtons, Point.Y);

  if Item <> lvButtons.DropTarget then
  begin
    lvButtons.DropTarget := nil;
    lvButtons.DropTarget := Item;
  end;

  if SelGroup <> nil then
    dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK
  else
    dwEffect := DROPEFFECT_NONE;
end;

// エクスプローラからドラッグ離れる
procedure TdlgButtonEdit.OleDragLeave;
begin
  lvButtons.DropTarget := nil;
end;


// エクスプローラからドラッグドロップ
procedure TdlgButtonEdit.OleDragDrop(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
var
  i: Integer;
  DropItem, NewItem: TListItem;
  AIcon: TIcon;
  DropButtons: TButtonGroup;
begin
  lvButtons.DropTarget := nil;
  SetForegroundWindow(Handle);
  lvButtons.SetFocus;

  Point := lvButtons.ScreenToClient(Point);
  DropItem := ListViewItemAtY(lvButtons, Point.Y);
  lvButtons.Selected := nil;

  lvButtons.Items.BeginUpdate;
  DropButtons := TButtonGroup.Create;
  try
    DataObjectToButtonGroup(DataObject, DropButtons);

    dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;

    if DropButtons.Count > 0 then
    begin
      for i := 0 to DropButtons.Count - 1 do
      begin
        if DropItem = nil then
          NewItem := lvButtons.Items.Add
        else
          NewItem := lvButtons.Items.Insert(DropItem.Index);

        NewItem.Caption := DropButtons[i].Name;
        NewItem.Data := DropButtons[i];
        NewItem.Selected := True;
        if i = 0 then
        begin
          NewItem.Focused := True;
          NewItem.MakeVisible(True);
        end;
        AIcon := TIcon.Create;
        try
          with TNormalButton(DropButtons[i]) do
          begin
            if IconFile <> '' then
              AIcon.Handle := IconCache.GetIcon(PChar(IconFile), ftIconPath, IconIndex, True, True)
            else if ItemIDList <> nil then
              AIcon.Handle := IconCache.GetIcon(ItemIDList, ftPIDL, IconIndex, True, True)
            else
              AIcon.Handle := IconCache.GetIcon(PChar(FileName), ftFilePath, IconIndex, True, True);
          end;
          NewItem.ImageIndex := imlButtons.AddIcon(AIcon);
        finally
          AIcon.Free;
        end;
      end;
      btnApply.Enabled := True;
    end;
  finally
    DropButtons.Clear(False);
    DropButtons.Free;
    lvButtons.Items.EndUpdate;
  end;
end;

// ListView の Y 座標から ListItem を探す
function TdlgButtonEdit.ListViewItemAtY(ListView: TListView; Y: Integer): TListItem;
var
  i: Integer;
  ItemRect: TRect;
begin
  Result := nil;

  for i := 0 to ListView.Items.Count - 1 do
  begin
    ItemRect := ListView.Items[i].DisplayRect(drSelectBounds);

    if ((i = 0) and (Y < ItemRect.Top)) or ((Y >= ItemRect.Top) and (Y < ItemRect.Bottom)) then
    begin
      Result := ListView.Items[i];
      Break;
    end;
  end;
end;

end.
