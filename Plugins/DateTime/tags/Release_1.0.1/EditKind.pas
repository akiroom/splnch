unit EditKind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Memo;

type
  TdlgEditKind = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lstKind: TListBox;
    btnAdd: TButton;
    btnModify: TButton;
    btnRemove: TButton;
    btnUp: TButton;
    btnDown: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstKindDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    OwnerForm: TForm;
    FOnApply: TNotifyEvent;
    procedure KindListClear;
    procedure KindAddApply(Sender: TObject);
    procedure KindModifyApply(Sender: TObject);
  public
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgEditKind: TdlgEditKind;

implementation

uses Kind;

{$R *.DFM}

// コンストラクタ
constructor TdlgEditKind.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgEditKind.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;


procedure TdlgEditKind.FormCreate(Sender: TObject);
var
  i: Integer;
  KindData: TKindData;
begin
  KindListBegin;
  lstKind.Items.AddObject('標準', nil);
  for i := 0 to KindList.Count - 1 do
  begin
    KindData := TKindData.Create;
    KindData.Assign(TKindData(KindList.Objects[i]));
    lstKind.Items.AddObject(KindList[i], KindData);
  end;
  KindListEnd;
  lstKind.ItemIndex := 0;
end;

procedure TdlgEditKind.FormDestroy(Sender: TObject);
begin
  KindListClear;
  dlgEditKind := nil;
end;

procedure TdlgEditKind.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgEditKind.btnOkClick(Sender: TObject);
var
  i: Integer;
  KindData: TKindData;
begin
  KindListBegin;
  try
    for i := 0 to KindList.Count - 1 do
      TKindData(KindList.Objects[i]).Free;
    KindList.Clear;

    for i := 1 to lstKind.Items.Count - 1 do
    begin
      KindData := TKindData.Create;
      KindData.Assign(TKindData(lstKind.Items.Objects[i]));
      KindList.AddObject(lstKind.Items[i], KindData);
    end;
  finally
    KindListEnd;
  end;

  if Assigned(FOnApply) then
    FOnApply(Self);
end;

procedure TdlgEditKind.KindListClear;
var
  i: Integer;
begin
  for i := 0 to lstKind.Items.Count - 1 do
    TKindData(lstKind.Items.Objects[i]).Free;
  lstKind.Items.Clear;
end;

procedure TdlgEditKind.lstKindDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  y: Integer;
  KindData: TKindData;
  R: TRect;
  HighlightColor, ShadowColor, DarkColor: TColor;
begin
  with Control as TListBox do
  begin
    KindData := TKindData(Items.Objects[Index]);
    Canvas.FillRect(Rect);

    // 色
    if KindData = nil then
      Canvas.Brush.Color := NMKindColor
    else
      Canvas.Brush.Color := KindData.Color;
    Canvas.Font.Color := GetFontColorFromFaceColor(Canvas.Brush.Color);
    GetButtonBorderColor(Canvas.Brush.Color, HighlightColor, ShadowColor, DarkColor);

    y := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(Items[Index])) div 2;
    R := Classes.Rect(Rect.Left + 2, Rect.Top + y, Rect.Left + 2 + Canvas.TextWidth(Items[Index]), Rect.Top + y + Canvas.TextHeight(Items[Index]));

    // 上辺
    Canvas.Pen.Color := HighlightColor;
    Canvas.Moveto(R.Left-1, R.Top-1);
    Canvas.Lineto(R.Right, R.Top-1);
    // 下辺
    Canvas.Pen.Color := ShadowColor;
    Canvas.Moveto(R.Left-1, R.Bottom);
    Canvas.Lineto(R.Right, R.Bottom);
    // 左辺
    Canvas.Pen.Color := HighlightColor;
    Canvas.Moveto(R.Left-1, R.Top-1);
    Canvas.Lineto(R.Left-1, R.Bottom + 1);
    // 右辺
    Canvas.Pen.Color := ShadowColor;
    Canvas.Moveto(R.Right, R.Top-1);
    Canvas.Lineto(R.Right, R.Bottom + 1);

    Canvas.TextOut(R.Left, R.Top, Items[Index]);

    // なぜかこの３行を実行しないと正しく出ない。。。
    Canvas.Brush.Color := clWhite;
    Canvas.Font.Color := clBlack;
    Canvas.TextOut(0, 0, '');

  end;
end;

procedure TdlgEditKind.KindAddApply(Sender: TObject);
var
  KindData: TKindData;
begin
  if TdlgKind(Sender).edtKind.Text = '' then
    MessageBox(Handle, '種類を入力してください。', '確認', MB_ICONWARNING)
  else if lstKind.Items.IndexOf(TdlgKind(Sender).edtKind.Text) >= 0 then
    MessageBox(Handle, '同じ種類がすでに存在しています。', '確認', MB_ICONWARNING)
  else
  begin
    KindData := TKindData.Create;
    KindData.Color := TdlgKind(Sender).pnlColor.Color;
    lstKind.ItemIndex := lstKind.Items.AddObject(TdlgKind(Sender).edtKind.Text, KindData);
  end;
end;

procedure TdlgEditKind.btnAddClick(Sender: TObject);
begin
  if dlgKind = nil then
    dlgKind := TdlgKind.CreateOwnedForm(Self, Self);
  dlgKind.OnApply := KindAddApply;
  dlgKind.pnlColor.Color := NMKindColor;
  dlgKind.pnlColor.Font.Color := GetFontColorFromFaceColor(dlgKind.pnlColor.Color);
  dlgKind.ShowModal;
end;

procedure TdlgEditKind.KindModifyApply(Sender: TObject);
var
  i: Integer;
begin
  if TdlgKind(Sender).edtKind.Text = '' then
    MessageBox(Handle, '種類を入力してください。', '確認', MB_ICONWARNING)
  else
  begin
    i := 0;
    while i < lstKind.Items.Count do
    begin
      if (lstKind.ItemIndex <> i) and (lstKind.Items[i] = TdlgKind(Sender).edtKind.Text) then
        Break;
      Inc(i);
    end;

    if i < lstKind.Items.Count then
      MessageBox(Handle, '同じ種類がすでに存在しています。', '確認', MB_ICONWARNING)
    else
    begin
      lstKind.Items[lstKind.ItemIndex] := TdlgKind(Sender).edtKind.Text;
      TKindData(lstKind.Items.Objects[lstKind.ItemIndex]).Color := TdlgKind(Sender).pnlColor.Color;
      lstKind.Invalidate;
    end;
  end;
end;

procedure TdlgEditKind.btnModifyClick(Sender: TObject);
begin
  if lstKind.ItemIndex = 0 then
  begin
    MessageBox(Handle, '"標準" は変更できません。', '確認', MB_ICONWARNING);
    Exit;
  end;
  if lstKind.ItemIndex < 0 then
  begin
    MessageBox(Handle, '種類が選択されていません。', '確認', MB_ICONWARNING);
    Exit;
  end;

  if dlgKind = nil then
    dlgKind := TdlgKind.CreateOwnedForm(Self, Self);
  dlgKind.OnApply := KindModifyApply;

  dlgKind.edtKind.Text := lstKind.Items[lstKind.ItemIndex];
  if lstKind.ItemIndex >= 1 then
    dlgKind.pnlColor.Color := TKindData(lstKind.Items.Objects[lstKind.ItemIndex]).Color
  else
    dlgKind.pnlColor.Color := NMKindColor;
  dlgKind.pnlColor.Font.Color := GetFontColorFromFaceColor(dlgKind.pnlColor.Color);
  dlgKind.ShowModal;
end;
procedure TdlgEditKind.btnRemoveClick(Sender: TObject);
begin
  if lstKind.ItemIndex = 0 then
  begin
    MessageBox(Handle, '"標準" は削除できません。', '確認', MB_ICONWARNING);
    Exit;
  end;
  if lstKind.ItemIndex < 0 then
  begin
    MessageBox(Handle, '種類が選択されていません。', '確認', MB_ICONWARNING);
    Exit;
  end;

  TKindData(lstKind.Items.Objects[lstKind.ItemIndex]).Free;
  lstKind.Items.Delete(lstKind.ItemIndex);
end;

procedure TdlgEditKind.btnUpClick(Sender: TObject);
var
  Index: Integer;
begin
  if (lstKind.ItemIndex = 0) or (lstKind.ItemIndex = 1) then
  begin
    MessageBox(Handle, '"標準" は移動できません。', '確認', MB_ICONWARNING);
    Exit;
  end;
  if lstKind.ItemIndex < 0 then
  begin
    MessageBox(Handle, '種類が選択されていません。', '確認', MB_ICONWARNING);
    Exit;
  end;

  Index := lstKind.ItemIndex;
  lstKind.Items.Move(Index, Index - 1);
  lstKind.ItemIndex := Index - 1;
end;

procedure TdlgEditKind.btnDownClick(Sender: TObject);
var
  Index: Integer;
begin
  if lstKind.ItemIndex = 0 then
  begin
    MessageBox(Handle, '"標準" は移動できません。', '確認', MB_ICONWARNING);
    Exit;
  end;
  if lstKind.ItemIndex < 0 then
  begin
    MessageBox(Handle, '種類が選択されていません。', '確認', MB_ICONWARNING);
    Exit;
  end;
  if lstKind.ItemIndex >= lstKind.Items.Count - 1 then
  begin
    MessageBox(Handle, 'これ以上移動できません。', '確認', MB_ICONWARNING);
    Exit;
  end;

  Index := lstKind.ItemIndex;
  lstKind.Items.Move(Index, Index + 1);
  lstKind.ItemIndex := Index + 1;
end;

end.
