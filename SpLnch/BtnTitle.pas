unit BtnTitle;

interface

uses
  Windows, Messages, Forms, Classes, Controls, Graphics, ExtCtrls, StdCtrls;

type
  TfrmBtnTitle = class(TForm)
    tmShowHide: TTimer;
    lblTitle: TLabel;
    procedure tmShowHideTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    OwnerForm: TForm;
  public
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSettingChange(var Msg: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure SetTitle(Title: string; ARect: TRect);
  end;

var
  frmBtnTitle: TfrmBtnTitle;

procedure ShowTitle(Owner: TForm; Title: string; ARect: TRect);
procedure HideTitle;


implementation

{$R *.DFM}

// タイトル表示
procedure ShowTitle(Owner: TForm; Title: string; ARect: TRect);
begin
  HideTitle;
  frmBtnTitle := TfrmBtnTitle.CreateOwnedForm(Application, Owner);
  frmBtnTitle.SetTitle(Title, ARect);
end;

// タイトル消す
procedure HideTitle;
begin
  if frmBtnTitle <> nil then
  begin
    ShowWindow(frmBtnTitle.Handle, SW_HIDE);
    frmBtnTitle.Release;
    frmBtnTitle := nil;
  end;
end;


{ TfrmBtnTitle }

// コンストラクタ
constructor TfrmBtnTitle.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TfrmBtnTitle.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;

// フォームはじめ
procedure TfrmBtnTitle.FormCreate(Sender: TObject);
var
  NonClientMetrics: TNonClientMetrics;
begin
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  lblTitle.Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont);
  lblTitle.Font.Color := clInfoText;
end;

// コントロールパネルの変更
procedure TfrmBtnTitle.WMSettingChange(var Msg: TWMSettingChange);
var
  NonClientMetrics: TNonClientMetrics;
//  LogFont: TLogFont;
begin
  inherited;
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  lblTitle.Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont);
//  SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont), @LogFont, 0);
//  lblTitle.Font.Handle := CreateFontIndirect(LogFont);
  lblTitle.Font.Color := clInfoText;
end;

// タイトルをセット
procedure TfrmBtnTitle.SetTitle(Title: string; ARect: TRect);
var
  L, T, W, H: Integer;
begin
  lblTitle.Caption := Title;
  W := lblTitle.Width + 4;
  H := lblTitle.Height + 4;
  L := ARect.Left;
  T := ARect.Bottom + 5;
  if L + W > Screen.Width then
    L := Screen.Width - W;
  if L < 0 then
    L := 0;
  if T + H > Screen.Height then
    T := ARect.Top - H - 5;
  if T < 0 then
    T := 0;
  SetBounds(L, T, W, H);
  tmShowHide.Enabled := True;
end;

// 描画
procedure TfrmBtnTitle.FormPaint(Sender: TObject);
begin
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
end;


// 表示タイマー
procedure TfrmBtnTitle.tmShowHideTimer(Sender: TObject);
begin
  if tmShowHide.Interval = 5000 then
  begin
    HideTitle;
  end
  else
  begin
    ShowWindow(Handle, SW_SHOWNOACTIVATE);
    tmShowHide.Interval := 5000;
  end;

end;

// マウスダウン
procedure TfrmBtnTitle.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HideTitle;
end;

end.
