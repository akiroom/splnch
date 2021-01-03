unit EditMemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  Memo, IniFiles, ComCtrls;


type
  TdlgEditMemo = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lblBegin: TLabel;
    lblEnd: TLabel;
    lblMemo: TLabel;
    memMemo: TMemo;
    dtpBegin: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    cmbKind: TComboBox;
    lblKind: TLabel;
    btnEditKind: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dtpBeginChange(Sender: TObject);
    procedure dtpEndChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbKindDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnEditKindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  private
    OwnerForm: TForm;
    FDayMemo: TDayMemo;
    FOnApply: TNotifyEvent;
    function GetDayMemo: TDayMemo;
    procedure SetDayMemo(Value: TDayMemo);
    procedure KindListSet;
    procedure KindListClear;
    procedure EditKindApply(Sender: TObject);
  public
    property DayMemo: TDayMemo read GetDayMemo write SetDayMemo;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  end;

var
  dlgEditMemo: TdlgEditMemo;

implementation

uses EditKind;

{$R *.DFM}

// コンストラクタ
constructor TdlgEditMemo.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgEditMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;

// フォームの最大最小のサイズ
procedure TdlgEditMemo.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  Msg.MinMaxInfo.ptMinTrackSize := Point(400, 230);
end;

procedure TdlgEditMemo.FormCreate(Sender: TObject);
begin
  Icon.Handle := LoadIcon(hInstance, 'MAINICON');
  FDayMemo := TDayMemo.Create;

  KindListSet;
end;

procedure TdlgEditMemo.FormDestroy(Sender: TObject);
begin
  KindListClear;
  FDayMemo.Free;
  dlgEditMemo := nil;
end;

procedure TdlgEditMemo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TdlgEditMemo.FormShow(Sender: TObject);
begin
  memMemo.SetFocus;
end;

procedure TdlgEditMemo.btnOkClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
    FOnApply(Self);
end;

function TdlgEditMemo.GetDayMemo: TDayMemo;
var
  i: Integer;
begin
  FDayMemo.Clear;
  FDayMemo.BeginDate := Int(dtpBegin.Date);
  FDayMemo.EndDate := Int(dtpEnd.Date);
  if cmbKind.ItemIndex > 0 then
    FDayMemo.Kind := cmbKind.Items[cmbKind.ItemIndex];
  for i := 0 to memMemo.Lines.Count - 1 do
    FDayMemo.Add(memMemo.Lines[i]);
  Result := FDayMemo;
end;

procedure TdlgEditMemo.SetDayMemo(Value: TDayMemo);
var
  i: Integer;
begin
  FDayMemo.Assign(Value);

  memMemo.Lines.Clear;
  dtpBegin.Date := FDayMemo.BeginDate;
  dtpEnd.Date := FDayMemo.EndDate;
  for i := 1 to cmbKind.Items.Count - 1 do
    if cmbKind.Items[i] = FDayMemo.Kind then
    begin
      cmbKind.ItemIndex := i;
      Break;
    end;
  for i := 0 to FDayMemo.Count - 1 do
    memMemo.Lines.Add(FDayMemo[i]);
end;

procedure TdlgEditMemo.KindListSet;
var
  i: Integer;
  KindData: TKindData;
begin
  KindListClear;
  KindListBegin;
  cmbKind.Items.AddObject('標準', nil);
  for i := 0 to KindList.Count - 1 do
  begin
    KindData := TKindData.Create;
    KindData.Assign(TKindData(KindList.Objects[i]));
    cmbKind.Items.AddObject(KindList[i], KindData);
  end;
  KindListEnd;
  cmbKind.ItemIndex := 0;
end;

procedure TdlgEditMemo.KindListClear;
var
  i: Integer;
begin
  for i := 1 to cmbKind.Items.Count - 1 do
    TKindData(cmbKind.Items.Objects[i]).Free;
  cmbKind.Clear;
end;

procedure TdlgEditMemo.dtpBeginChange(Sender: TObject);
begin
  if dtpEnd.Date < dtpBegin.Date then
    dtpEnd.Date := dtpBegin.Date;
end;

procedure TdlgEditMemo.dtpEndChange(Sender: TObject);
begin
  if dtpBegin.Date > dtpEnd.Date then
    dtpBegin.Date := dtpEnd.Date;
end;

procedure TdlgEditMemo.cmbKindDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  y: Integer;
  KindData: TKindData;
  R: TRect;
  HighlightColor, ShadowColor, DarkColor: TColor;
begin
  with Control as TComboBox do
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

procedure TdlgEditMemo.EditKindApply(Sender: TObject);
var
  Kind: String;
begin
  Kind := '';
  if cmbKind.ItemIndex >= 0 then
    Kind := cmbKind.Items[cmbKind.ItemIndex];

  KindListSet;

  if kind = '' then
    cmbKind.ItemIndex := 0
  else
    cmbKind.ItemIndex := cmbKind.Items.IndexOf(Kind);
end;

procedure TdlgEditMemo.btnEditKindClick(Sender: TObject);
var
  Kind: String;
begin
  if dlgEditKind = nil then
    dlgEditKind := TdlgEditKind.CreateOwnedForm(Self, Self);
  dlgEditKind.OnApply := EditKindApply;

  Kind := '';
  if cmbKind.ItemIndex >= 0 then
    Kind := cmbKind.Items[cmbKind.ItemIndex];
  dlgEditKind.lstKind.ItemIndex := dlgEditKind.lstKind.Items.IndexOf(Kind);

  dlgEditKind.ShowModal;
end;

end.
