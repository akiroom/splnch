unit MemoList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Memo, Menus, ImgList, Clipbrd;

type
  TdlgMemoList = class(TForm)
    lvMemoList: TListView;
    PopupMenu1: TPopupMenu;
    popNew: TMenuItem;
    popModify: TMenuItem;
    popDelete: TMenuItem;
    imlIcons: TImageList;
    MainMenu1: TMainMenu;
    mnuMemo: TMenuItem;
    mnuOk: TMenuItem;
    mnuCancel: TMenuItem;
    N4: TMenuItem;
    mnuOutput: TMenuItem;
    mnuList: TMenuItem;
    mnuFilter: TMenuItem;
    mnuNoFilter: TMenuItem;
    mnuNew: TMenuItem;
    mnuModify: TMenuItem;
    mnuDelete: TMenuItem;
    N3: TMenuItem;
    StatusBar1: TStatusBar;
    N1: TMenuItem;
    popFilter: TMenuItem;
    popNoFilter: TMenuItem;
    N5: TMenuItem;
    popOutput: TMenuItem;
    dlgSave: TSaveDialog;
    dlgOpenSL3: TOpenDialog;
    N2: TMenuItem;
    memSL3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure lvMemoListColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMemoListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuModifyClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuFilterClick(Sender: TObject);
    procedure mnuOutputClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure mnuNoFilterClick(Sender: TObject);
    procedure mnuCancelClick(Sender: TObject);
    procedure mnuOkClick(Sender: TObject);
    procedure mnuMemoClick(Sender: TObject);
    procedure mnuListClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvMemoListInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure memSL3Click(Sender: TObject);
  private
    FSave: Boolean;
    OwnerForm: TForm;
    FOnApply: TNotifyEvent;
    FHideMemoList: TList;
    procedure MemoListClear;
    function AddMemo(DayMemo: TDayMemo): TListItem;
    procedure ModifyMemo(Item: TListItem);
    procedure ListDayMemo;
    procedure Apply;
    procedure EditMemoNewApply(Sender: TObject);
    procedure EditMemoModifyApply(Sender: TObject);
    procedure FilterApply(Sender: TObject);
  public
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
  end;

var
  dlgMemoList: TdlgMemoList;

implementation

uses EditMemo, Filter, Output;

{$R *.DFM}

// コンストラクタ
constructor TdlgMemoList.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgMemoList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;

// フォームの最大最小のサイズ
procedure TdlgMemoList.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  Msg.MinMaxInfo.ptMinTrackSize := Point(400, 230);
end;

procedure TdlgMemoList.FormCreate(Sender: TObject);
begin
  Icon.Handle := LoadIcon(hInstance, 'MAINICON');
  imlIcons.ResInstLoad(hInstance, rtBitmap, 'MEMO', clFuchsia);
  FHideMemoList := TList.Create;
end;

procedure TdlgMemoList.FormDestroy(Sender: TObject);
begin
  MemoListClear;
  FHideMemoList.Free;
  dlgMemoList := nil;
end;

procedure TdlgMemoList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgMemoList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FSave then
    Apply;
end;

procedure TdlgMemoList.FormShow(Sender: TObject);
var
  i: Integer;
  DayMemo: TDayMemo;
begin
  FSave := True;
  MemoStreamBegin;

  MemoListClear;
  for i := 0 to MemoStream.MemoList.Count - 1 do
  begin
    DayMemo := TDayMemo.Create;
    DayMemo.Assign(MemoStream.MemoList[i]);
    FHideMemoList.Add(DayMemo);
  end;

  ListDayMemo;
end;

procedure TdlgMemoList.FormHide(Sender: TObject);
begin
  MemoListClear;
  MemoStreamEnd;
end;

procedure TdlgMemoList.MemoListClear;
var
  i: Integer;
begin
  lvMemoList.Items.BeginUpdate;
  try
    for i := 0 to lvMemoList.Items.Count - 1 do
      TDayMemo(lvMemoList.Items[i]).Free;
    lvMemoList.Items.Clear;

    for i := 0 to FHideMemoList.Count - 1 do
      TDayMemo(FHideMemoList[i]).Free;
    FHideMemoList.Clear;

  finally
    lvMemoList.Items.EndUpdate;
  end;
end;

function TdlgMemoList.AddMemo(DayMemo: TDayMemo): TListItem;
begin
  Result := lvMemoList.Items.Add;
  Result.Caption := DayMemo.TopLine;
  if DayMemo.BeginDate = DayMemo.EndDate then
    Result.SubItems.Add(DateToStr(DayMemo.BeginDate))
  else
    Result.SubItems.Add(DateToStr(DayMemo.BeginDate) + '～' + DateToStr(DayMemo.EndDate));
  if DayMemo.Kind = '' then
    Result.SubItems.Add('標準')
  else
    Result.SubItems.Add(DayMemo.Kind);

  Result.Data := DayMemo;
  lvMemoList.Tag := 0;
end;

procedure TdlgMemoList.ModifyMemo(Item: TListItem);
var
  DayMemo: TDayMemo;
begin
  DayMemo := Item.Data;

  Item.Caption := DayMemo.TopLine;
  Item.SubItems.Clear;
  if DayMemo.BeginDate = DayMemo.EndDate then
    Item.SubItems.Add(DateToStr(DayMemo.BeginDate))
  else
    Item.SubItems.Add(DateToStr(DayMemo.BeginDate) + '～' + DateToStr(DayMemo.EndDate));
  if DayMemo.Kind = '' then
    Item.SubItems.Add('標準')
  else
    Item.SubItems.Add(DayMemo.Kind);
  lvMemoList.Tag := 0;
end;

procedure TdlgMemoList.ListDayMemo;
var
  i: Integer;
  DayMemo: TDayMemo;
  HitMemoList: TList;
begin
  MemoFilterBegin;
  HitMemoList := TList.Create;
  lvMemoList.Items.BeginUpdate;
  try

    for i := 0 to lvMemoList.Items.Count - 1 do
      FHideMemoList.Add(lvMemoList.Items[i].Data);
    lvMemoList.Items.Clear;

    for i := 0 to FHideMemoList.Count - 1 do
    begin
      DayMemo := FHideMemoList[i];
      if MemoFilter.Match(DayMemo) then
        HitMemoList.Add(DayMemo);
    end;

    HitMemoList.Sort(DayMemoCompare);

    for i := 0 to HitMemoList.Count - 1 do
    begin
      DayMemo := HitMemoList[i];
      FHideMemoList.Remove(DayMemo);
      AddMemo(DayMemo);
    end;

  finally
    lvMemoList.Items.EndUpdate;
    HitMemoList.Free;
    MemoFilterEnd;
  end;


end;

procedure TdlgMemoList.Apply;
var
  i: Integer;
  DayMemo: TDayMemo;
begin
  MemoStream.Clear;
  for i := 0 to lvMemoList.Items.Count - 1 do
  begin
    DayMemo := TDayMemo.Create;
    DayMemo.Assign(lvMemoList.Items[i].Data);
    MemoStream.MemoList.Add(DayMemo);
  end;
  for i := 0 to FHideMemoList.Count - 1 do
  begin
    DayMemo := TDayMemo.Create;
    DayMemo.Assign(FHideMemoList[i]);
    MemoStream.MemoList.Add(DayMemo);
  end;
  MemoStream.Sort;

  if Assigned(FOnApply) then
    FOnApply(Self);
end;

// カラムクリック
procedure TdlgMemoList.lvMemoListColumnClick(Sender: TObject;
  Column: TListColumn);
var
  ColumnIndex: Integer;
begin
  ColumnIndex := Column.Tag;

  if Abs(lvMemoList.Tag) = ColumnIndex then
    lvMemoList.Tag := - lvMemoList.Tag
  else
    lvMemoList.Tag := ColumnIndex;

  lvMemoList.AlphaSort;
end;

// ソート比較
procedure TdlgMemoList.lvMemoListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Memo1, Memo2: TDayMemo;
begin
  case Abs(lvMemoList.Tag) of
    1:
    begin
      Compare := CompareText(Item1.Caption, Item2.Caption);
      if Compare = 0 then
        Compare := DayMemoCompare(Item1.Data, Item2.Data);
    end;
    2:
      Compare := DayMemoCompare(Item1.Data, Item2.Data);
    3:
    begin
      KindListBegin;
      try
        Memo1 := Item1.Data;
        Memo2 := Item2.Data;
        Compare := KindList.IndexOf(Memo1.Kind) - KindList.IndexOf(Memo2.Kind);
        if Compare = 0 then
          Compare := DayMemoCompare(Item1.Data, Item2.Data);
      finally
        KindListEnd;
      end;
    end;
  end;

  if lvMemoList.Tag < 0 then
    Compare := - Compare;
end;

// ポップアップ
procedure TdlgMemoList.PopupMenu1Popup(Sender: TObject);
begin
  popModify.Enabled := lvMemoList.SelCount = 1;
  popDelete.Enabled := lvMemoList.SelCount > 0;

  MemoFilterBegin;
  try
    popNoFilter.Enabled := MemoFilter.Filtering;
  finally
    MemoFilterEnd;
  end;
end;

// メモメニュー
procedure TdlgMemoList.mnuMemoClick(Sender: TObject);
begin
  mnuModify.Enabled := lvMemoList.SelCount = 1;
  mnuDelete.Enabled := lvMemoList.SelCount > 0;
end;

// 一覧メニュー
procedure TdlgMemoList.mnuListClick(Sender: TObject);
begin
  MemoFilterBegin;
  try
    mnuNoFilter.Enabled := MemoFilter.Filtering;
  finally
    MemoFilterEnd;
  end;
end;

procedure TdlgMemoList.EditMemoNewApply(Sender: TObject);
var
  NewMemo: TDayMemo;
  Item: TListItem;
begin
  NewMemo := TDayMemo.Create;
  NewMemo.Assign(TdlgEditMemo(Sender).DayMemo);
  Item := AddMemo(NewMemo);
  lvMemoList.Selected := nil;
  lvMemoList.Selected := Item;
  Item.Focused := True;
  Item.MakeVisible(False);
end;

// 新規作成
procedure TdlgMemoList.mnuNewClick(Sender: TObject);
var
  NewMemo: TDayMemo;
begin
  if dlgEditMemo = nil then
    dlgEditMemo := TdlgEditMemo.CreateOwnedForm(Self, Self);
  dlgEditMemo.Caption := 'メモの新規作成';
  dlgEditMemo.OnApply := EditMemoNewApply;

  NewMemo := TDayMemo.Create;
  try
    NewMemo.BeginDate := Date;
    NewMemo.EndDate := Date;
    dlgEditMemo.DayMemo := NewMemo;
  finally
    NewMemo.Free;
  end;
  dlgEditMemo.ShowModal;
end;

procedure TdlgMemoList.EditMemoModifyApply(Sender: TObject);
var
  Item: TListItem;
  DayMemo: TDayMemo;
begin
  if lvMemoList.SelCount = 1 then
  begin
    Item := lvMemoList.Selected;
    DayMemo := Item.Data;
    DayMemo.Assign(TdlgEditMemo(Sender).DayMemo);
    ModifyMemo(Item);

  end;
end;

// 変更
procedure TdlgMemoList.mnuModifyClick(Sender: TObject);
var
  Item: TListItem;
  DayMemo: TDayMemo;
begin
  if lvMemoList.SelCount = 1 then
  begin
    Item := lvMemoList.Selected;
    DayMemo := Item.Data;

    if dlgEditMemo = nil then
      dlgEditMemo := TdlgEditMemo.CreateOwnedForm(Self, Self);

    dlgEditMemo.Caption := 'メモの変更';
    dlgEditMemo.OnApply := EditMemoModifyApply;
    dlgEditMemo.DayMemo := DayMemo;
    dlgEditMemo.ShowModal;
  end;
end;

// 削除
procedure TdlgMemoList.mnuDeleteClick(Sender: TObject);
var
  Item, NextItem: TListItem;
begin
  lvMemoList.Items.BeginUpdate;
  try
    Item := lvMemoList.Selected;
    while Item <> nil do
    begin
      NextItem := lvMemoList.GetNextItem(Item, sdAll, [isSelected]);
      TDayMemo(Item.Data).Free;
      Item.Delete;
      Item := NextItem;
    end;
  finally
    lvMemoList.Items.EndUpdate;
  end;
end;


// 破棄終了
procedure TdlgMemoList.mnuCancelClick(Sender: TObject);
begin
  FSave := False;
  Close;
end;

// 保存終了
procedure TdlgMemoList.mnuOkClick(Sender: TObject);
begin
  Close;
end;

procedure TdlgMemoList.FilterApply(Sender: TObject);
begin
  MemoFilterBegin;
  try
    MemoFilter.Assign(TdlgFilter(Sender).MemoFilter);
    ListDayMemo;
  finally
    MemoFilterEnd;
  end;
end;

// フィルタ
procedure TdlgMemoList.mnuFilterClick(Sender: TObject);
begin
  if dlgFilter = nil then
    dlgFilter := TdlgFilter.CreateOwnedForm(Self, Self);
  dlgFilter.OnApply := FilterApply;
  MemoFilterBegin;
  try
    dlgFilter.MemoFilter := MemoFilter;
  finally
    MemoFilterEnd;
  end;
  dlgFilter.ShowModal;
end;

// フィルタ解除
procedure TdlgMemoList.mnuNoFilterClick(Sender: TObject);
begin
  MemoFilterBegin;
  try
    MemoFilter.Clear;
    ListDayMemo;
  finally
    MemoFilterEnd;
  end;
end;

// チップ
procedure TdlgMemoList.lvMemoListInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
var
  i: Integer;
  DayMemo: TDayMemo;
begin
  DayMemo := Item.Data;
  InfoTip := '';
  for i := 0 to DayMemo.Count - 1 do
  begin
    if InfoTip <> '' then
      InfoTip := InfoTip + #13#10;
    InfoTip := InfoTip + DayMemo[i];
  end;
end;

// ファイル書き出し
procedure TdlgMemoList.mnuOutputClick(Sender: TObject);
var
  lstOne, lstAll: TStringList;
  i, j: Integer;
  Item: TListItem;
  DayMemo: TDayMemo;
  MemoText: String;
begin
  dlgOutput := TdlgOutput.Create(Self);
  lstOne := TStringList.Create;
  lstAll := TStringList.Create;
  try
    dlgOutput.chkSelected.Enabled := lvMemoList.SelCount > 0;
    dlgOutput.chkSelected.Checked := lvMemoList.SelCount > 0;

    if dlgOutput.ShowModal = idOk then
    begin
      for i := 0 to lvMemoList.Items.Count - 1 do
      begin
        Item := lvMemoList.Items[i];
        DayMemo := TDayMemo(Item.Data);
        if dlgOutput.chkHeader.Checked then
          MemoText := DayMemo.TopLine
        else
        begin
          MemoText := '';
          for j := 0 to DayMemo.Count - 1 do
          begin
            if MemoText <> '' then
              MemoText := MemoText + #10; {Excel対策 なぜかLFのみ}
            MemoText := MemoText + DayMemo[j];
          end;
        end;


        if Item.Selected or (not dlgOutput.chkSelected.Checked) then
        begin
          // CSV
          if dlgOutput.chkCSV.Checked then
          begin
            lstOne.Clear;
            lstOne.Add(FormatDateTime('dddddd', DayMemo.BeginDate));
            if DayMemo.BeginDate = DayMemo.EndDate then
              lstOne.Add('')
            else
              lstOne.Add(FormatDateTime('dddddd', DayMemo.EndDate));
            if DayMemo.Kind = '' then
              lstOne.Add('標準')
            else
              lstOne.Add(DayMemo.Kind);

            lstOne.Add(MemoText);

            lstAll.Add(lstOne.CommaText);
          end

          // 標準
          else
          begin
            if DayMemo.BeginDate = DayMemo.EndDate then
              lstAll.Add('【' + FormatDateTime('dddddd', DayMemo.BeginDate) + '】')
            else
              lstAll.Add('【' + FormatDateTime('dddddd', DayMemo.BeginDate) + '～' + FormatDateTime('dddddd', DayMemo.EndDate) + '】');
            if DayMemo.Kind = '' then
              lstAll.Add('（標準）')
            else
              lstAll.Add('（' + DayMemo.Kind + '）');
            lstAll.Add(MemoText);
            lstAll.Add('');
          end;

        end;

      end;

      if dlgOutput.rdoMedia.ItemIndex = 0 then
      begin
        if dlgOutput.chkCSV.Checked then
        begin
          dlgSave.FileName := '書き出しファイル.csv';
          dlgSave.DefaultExt := 'csv';
          dlgSave.Filter := 'CSV ファイル(*.csv)|*.csv|すべてのファイル(*.*)|*.*';
        end
        else
        begin
          dlgSave.FileName := '書き出しファイル.txt';
          dlgSave.DefaultExt := 'txt';
          dlgSave.Filter := 'テキスト ファイル(*.txt)|*.txt|すべてのファイル(*.*)|*.*';
        end;

        if dlgSave.Execute then
          lstAll.SaveToFile(dlgSave.FileName);
      end
      else
      begin
        Clipboard.AsText := lstAll.Text;
      end;


    end;
  finally
    dlgOutput.Release;
    lstOne.Free;
    lstAll.Free;
  end;
end;


// SL3 形式のファイルの読み込み
procedure TdlgMemoList.memSL3Click(Sender: TObject);
var
  lstText: TStringList;
  i: Integer;
  DayMemo: TDayMemo;
  Year, Month, Day: Word;
begin
  dlgOpenSL3.DefaultExt := 'smm';
  dlgOpenSL3.Filter := 'SL3 書き出しファイル(*.smm)|*.smm|すべてのファイル(*.*)|*.*';
  if dlgOpenSL3.Execute then
  begin
    lstText := TStringList.Create;
    try
      try
        lstText.LoadFromFile(dlgOpenSL3.FileName);
        if lstText.Count = 0 then
          raise Exception.Create('ファイル形式が違います。');
        if lstText[0] <> 'Special Launch Memo File' then
          raise Exception.Create('ファイル形式が違います。');

        DayMemo := nil;
        for i := 1 to lstText.Count - 1 do
        begin
          if lstText[i][1] = '#' then
          begin
            if DayMemo <> nil then
              AddMemo(DayMemo);
            DayMemo := TDayMemo.Create;
            Year := StrToInt(Copy(lstText[i], 2, 4));
            Month := StrToInt(Copy(lstText[i], 6, 2));
            Day := StrToInt(Copy(lstText[i], 8, 2));
            DayMemo.BeginDate := EncodeDate(Year, Month, Day);
            DayMemo.EndDate := DayMemo.BeginDate;
          end;

          if (lstText[i][1] = '$') and (DayMemo <> nil) then
          begin
            DayMemo.Add(Copy(lstText[i], 2, MaxInt));
          end;
        end;
        if DayMemo <> nil then
          AddMemo(DayMemo);



      except
        on E: Exception do
          MessageBox(Handle, PChar('読み込み時にエラーが発生しました。'
            + E.Message), 'エラー', MB_ICONERROR);
      end;
    finally
      lstText.Free;
    end;
  end;

end;

end.
