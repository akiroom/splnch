unit Filter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Julius, Memo;

type
  TdlgFilter = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    chkMemo: TCheckBox;
    chkDate: TCheckBox;
    dtpEndDate: TDateTimePicker;
    lblEndDate: TLabel;
    dtpBeginDate: TDateTimePicker;
    lblBeginDate: TLabel;
    chkCharCase: TCheckBox;
    edtMemo: TEdit;
    lblDate: TLabel;
    chkKind: TCheckBox;
    lblKind: TLabel;
    lstKind: TListBox;
    procedure chkMemoClick(Sender: TObject);
    procedure chkDateClick(Sender: TObject);
    procedure dtpBeginDateChange(Sender: TObject);
    procedure dtpEndDateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkKindClick(Sender: TObject);
    procedure lstKindDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  private
    OwnerForm: TForm;
    FMemoFilter: TMemoFilter;
    FOnApply: TNotifyEvent;
    function GetMemoFilter: TMemoFilter;
    procedure SetMemoFilter(const Value: TMemoFilter);
  public
    property MemoFilter: TMemoFilter read GetMemoFilter write SetMemoFilter;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;

    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgFilter: TdlgFilter;

implementation

{$R *.DFM}

// コンストラクタ
constructor TdlgFilter.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgFilter.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;

procedure TdlgFilter.FormCreate(Sender: TObject);
var
  KindData: TKindData;
  i: Integer;
begin
  KindListBegin;
  lstKind.ItemIndex := lstKind.Items.AddObject('標準', nil);
  for i := 0 to KindList.Count - 1 do
  begin
    KindData := TKindData.Create;
    KindData.Assign(TKindData(KindList.Objects[i]));
    lstKind.Items.AddObject(KindList[i], KindData);
  end;
  KindListEnd;

  FMemoFilter := TMemoFilter.Create;
end;

procedure TdlgFilter.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lstKind.Items.Count - 1 do
    TKindData(lstKind.Items.Objects[i]).Free;
  lstKind.Items.Clear;
  FMemoFilter.Free;
  dlgFilter := nil;
end;

procedure TdlgFilter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgFilter.btnOkClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
    FOnApply(Self);
end;


procedure TdlgFilter.chkMemoClick(Sender: TObject);
begin
  lblDate.Enabled := chkMemo.Checked;
  chkCharCase.Enabled := chkMemo.Checked;
  edtMemo.Enabled := chkMemo.Checked;
end;

procedure TdlgFilter.chkDateClick(Sender: TObject);
begin
  lblEndDate.Enabled := chkDate.Checked;
  lblBeginDate.Enabled := chkDate.Checked;
  dtpEndDate.Enabled := chkDate.Checked;
  dtpBeginDate.Enabled := chkDate.Checked;
end;

procedure TdlgFilter.chkKindClick(Sender: TObject);
begin
  lblKind.Enabled := chkKind.Checked;
  lstKind.Enabled := chkKind.Checked;
end;


procedure TdlgFilter.dtpBeginDateChange(Sender: TObject);
begin
  if dtpEndDate.Date < dtpBeginDate.Date then
    dtpEndDate.Date := dtpBeginDate.Date;
end;

procedure TdlgFilter.dtpEndDateChange(Sender: TObject);
begin
  if dtpBeginDate.Date > dtpEndDate.Date then
    dtpBeginDate.Date := dtpEndDate.Date;
end;

procedure TdlgFilter.lstKindDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
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
    if odDisabled in State then
    begin
      Canvas.Brush.Color := clWindow;
      Canvas.FillRect(Rect);
      Canvas.Brush.Color := clBtnFace;
      Canvas.Font.Color := clGrayText;
    end
    else
    begin
      if KindData = nil then
        Canvas.Brush.Color := NMKindColor
      else
        Canvas.Brush.Color := KindData.Color;
      Canvas.Font.Color := GetFontColorFromFaceColor(Canvas.Brush.Color);
    end;
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

function TdlgFilter.GetMemoFilter: TMemoFilter;
var
  i: Integer;
begin
  FMemoFilter.Clear;
  FMemoFilter.CheckMemo := chkMemo.Checked;
  FMemoFilter.CheckDate := chkDate.Checked;
  FMemoFilter.CheckKind := chkKind.Checked;
  FMemoFilter.Memo := edtMemo.Text;
  FMemoFilter.CheckMemoCase := chkCharCase.Checked;
  FMemoFilter.BeginDate := dtpBeginDate.Date;
  FMemoFilter.EndDate := dtpEndDate.Date;

  for i := 0 to lstKind.Items.Count - 1 do
  begin
    if lstKind.Selected[i] then
    begin
      if i = 0 then
        FMemoFilter.KindList.Add('')
      else
        FMemoFilter.KindList.Add(lstKind.Items[i]);
    end;
  end;
  Result := FMemoFilter;
end;

procedure TdlgFilter.SetMemoFilter(const Value: TMemoFilter);
var
  i: Integer;
begin
  FMemoFilter.Assign(Value);
  chkMemo.Checked := FMemoFilter.CheckMemo;
  chkDate.Checked := FMemoFilter.CheckDate;
  chkKind.Checked := FMemoFilter.CheckKind;
  edtMemo.Text := FMemoFilter.Memo;
  chkCharCase.Checked := FMemoFilter.CheckMemoCase;
  dtpBeginDate.Date := FMemoFilter.BeginDate;
  dtpEndDate.Date := FMemoFilter.EndDate;
  for i := 0 to lstKind.Items.Count - 1 do
  begin
    if i = 0 then
      lstKind.Selected[i] := FMemoFilter.KindList.IndexOf('') >= 0
    else
      lstKind.Selected[i] := FMemoFilter.KindList.IndexOf(lstKind.Items[i]) >= 0;
  end;
end;

end.
