unit SLBtns;

interface

uses
  Windows, Messages, Classes, SysUtils, Graphics, Controls, Buttons, ExtCtrls, Menus;

type
  TSkinDrawEvent = function(Sender: TObject; Rect: TRect): Boolean of object;


  TSLButton = class(TGraphicControl)
  private
    FDragging: Boolean;
    FRepeatTimer: TTimer;
    FDragPos: TPoint;

    FFocusColor: TColor;
    FHighlightColor: TColor;
    FShadowColor: TColor;
    FDarkColor: TColor;
    FFocusEnter: Boolean;
    FActive: Boolean;
    FSelected: Boolean;
    FMouseEntered: Boolean;
    FSelTransparent: Boolean;
    FTransparent: Boolean;
    FRepeating: Boolean;
    FRepeatDelay: Integer;
    FRepeatInterval: Integer;
    FDragSrouce: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnStartDrag: TNotifyEvent;
    FOnSkinDrawFace: TSkinDrawEvent;
    FOnSkinDrawFrame: TSkinDrawEvent;
    FOnSkinDrawIcon: TSkinDrawEvent;
    FOnSkinDrawCaption: TSkinDrawEvent;
    FOnSkinDrawMask: TSkinDrawEvent;
    procedure SetRepeatTimer(Value: Boolean);
    procedure RepeatTimerTimer(Sender: TObject);
    procedure MouseTimerTimer(Sender: TObject);
    procedure SetActive(Value: Boolean);
    procedure SetSelected(Value: Boolean);
    procedure SetMouseEntered(Value: Boolean);
    procedure FocusCheck;
    procedure SetFocusColor(Value: TColor);
    procedure SetSelTransparent(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
  protected
    FState: TButtonState;
    procedure Paint; override;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure CMWinIniChange(var Msg: TMessage); message CM_WININICHANGE;
    procedure CMColorChanged(var Msg: TMessage); message CM_COLORCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DrawFrame(Canvas: TCanvas; ARect: TRect; Down: Boolean);
//    property Canvas: TCanvas read FCanvas write FCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Active: Boolean read FActive write SetActive;
    property Selected: Boolean read FSelected write SetSelected;
    property MouseEntered: Boolean read FMouseEntered write SetMouseEntered;
    property HighlightColor: TColor read FHighlightColor;
    property ShadowColor: TColor read FShadowColor;
    property DarkColor: TColor read FDarkColor;
  published
    property Enabled;
    property Color;
    property FocusColor: TColor read FFocusColor write SetFocusColor;
    property SelTransparent: Boolean read FSelTransparent write SetSelTransparent;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property Repeating: Boolean read FRepeating write FRepeating default False;
    property RepeatDelay: Integer read FRepeatDelay write FRepeatDelay default 400;
    property RepeatInterval: Integer read FRepeatInterval write FRepeatInterval default 100;
    property DragSource: Boolean read FDragSrouce write FDragSrouce;
    property OnClick;
    property OnMouseDown;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnStartDrag: TNotifyEvent read FOnStartDrag write FOnStartDrag;
    property OnSkinDrawFace: TSkinDrawEvent read FOnSkinDrawFace write FOnSkinDrawFace;
    property OnSkinDrawFrame: TSkinDrawEvent read FOnSkinDrawFrame write FOnSkinDrawFrame;
    property OnSkinDrawIcon: TSkinDrawEvent read FOnSkinDrawIcon write FOnSkinDrawIcon;
    property OnSkinDrawCaption: TSkinDrawEvent read FOnSkinDrawCaption write FOnSkinDrawCaption;
    property OnSkinDrawMask: TSkinDrawEvent read FOnSkinDrawMask write FOnSkinDrawMask;
  end;

  TSLScrollButtonKind = (skGUp, skUp, skDown, skGDown);
  TSLScrollButton = class(TSLButton)
  private
    FKind: TSLScrollButtonKind;
    FVertical: Boolean;
  protected
    procedure Paint; override;
    procedure SetKind(Value: TSLScrollButtonKind);
    procedure SetVertical(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Kind: TSLScrollButtonKind read FKind write SetKind;
    property Vertical: Boolean read FVertical write SetVertical;
  end;

  TSLBtnCaptionPosition = (cpNone, cpBottom, cpRight);
  TSLNormalButton = class(TSLButton)
  private
    FOwnerDraw: Boolean;
    FIconHandle: HIcon;
    FNarrowText:Boolean;
    FSpacing: Integer;
    FCaptionPosition: TSLBtnCaptionPosition;
    FSmallIcon: Boolean;
    procedure SetIconHandle(Value: HIcon);
    function GetIconSize: Integer;
    function GetSpacing: Integer;
    procedure SetSpacing(Value: Integer);
    procedure SetCaptionPosition(Value: TSLBtnCaptionPosition);
    procedure SetSmallIcon(Value: Boolean);
  protected
    procedure Paint; override;
  public
    property Canvas;
    property IconHandle: HIcon read FIconHandle write SetIconHandle;
    property IconSize: Integer read GetIconSize;
    property NarrowText: Boolean read FNarrowText;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
    property Spacing: Integer read GetSpacing write SetSpacing;
    property CaptionPosition: TSLBtnCaptionPosition read FCaptionPosition write SetCaptionPosition;
    property SmallIcon: Boolean read FSmallIcon write SetSmallIcon;
  end;

  TDrawButtonEvent = procedure (Sender: TObject; Rect: TRect; State: TButtonState) of object;

  TSLPluginButton = class(TSLNormalButton)
  private
    FOnDrawButton: TDrawButtonEvent;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnDrawButton: TDrawButtonEvent read FOnDrawButton write FOnDrawButton;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

const
  BUTTON_MARGIN = 4;

const
  COLOR_GRADIENTACTIVECAPTION  = 27;
  COLOR_GRADIENTINACTIVECAPTION = 28;
  clGradientActiveCaption  = $80000000 + COLOR_GRADIENTACTIVECAPTION;
  clGradientInactiveCaption = $80000000 + COLOR_GRADIENTINACTIVECAPTION;

type
  TDirection = (drLeftRight, drRightLeft, drBottomUp, drTopDown);

function DrawNarrowText(Canvas: TCanvas; ARect: TRect; const Text: string): Boolean;
procedure RotateTextOut(Canvas: TCanvas; ARect: TRect; Direction: TDirection; const Text: String);
procedure GradationRect(Canvas: TCanvas; ARect: TRect; Direction: TDirection; ColorA, ColorB: TColor);
procedure ColorBetween(Canvas: TCanvas; ARect: TRect; Color: TColor);
function GetFontColorFromFaceColor(FaceColor: TColor): TColor;
function GetShadowColor(FaceColor: TColor): TColor;

implementation

var
  MouseLastPos: TPoint;
  MouseInButton: TSLButton = nil;
  MouseTimer: TTimer = nil;


// 狭いテキストを描画
function DrawNarrowText(Canvas: TCanvas; ARect: TRect; const Text: string): Boolean;
var
  ComS, S: string;
  LastChar: string;
  MaxWidth: Integer;
begin
  Result := False;
  ComS := Text;
  S := Text;
  MaxWidth := ARect.Right - ARect.Left;
  while Canvas.TextWidth(ComS) > MaxWidth do
  begin
    Result := True;
    LastChar := StrPas(AnsiLastChar(S));
    if LastChar = S then
      Break;

    S := Copy(S, 1, Length(S) - Length(LastChar));
    ComS := S + '...';
  end;
  Canvas.TextOut(ARect.Left, ARect.Top, ComS);
end;

// 狭いテキストを指定の方向に描画
procedure RotateTextOut(Canvas: TCanvas; ARect: TRect; Direction: TDirection; const Text: String);
var
  ComS, S: string;
  LastChar: string;
  MaxWidth: Integer;
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
  X, Y: Integer;
begin
  GetObject(Canvas.Font.Handle, SizeOf(LogFont), @LogFont);

  case Direction of
    drLeftRight:
    begin
      LogFont.lfEscapement := 0;
      MaxWidth := ARect.Right - ARect.Left;
      X := ARect.Left;
      Y := ARect.Top;
    end;

    drRightLeft:
    begin
      LogFont.lfEscapement := 1800;
      MaxWidth := ARect.Right - ARect.Left;
      X := ARect.Right - 1;
      Y := ARect.Bottom - 1;
    end;

    drBottomUp:
    begin
      LogFont.lfEscapement := 900;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Left;
      Y := ARect.Bottom - 1;
    end;

    else
    begin
      LogFont.lfEscapement := 2700;
      MaxWidth := ARect.Bottom - ARect.Top;
      X := ARect.Right;
      Y := ARect.Top;
    end;
  end;

  ComS := Text;
  S := Text;
  while Canvas.TextWidth(ComS) > MaxWidth do
  begin
    LastChar := StrPas(AnsiLastChar(S));
    if LastChar = S then
      Break;

    S := Copy(S, 1, Length(S) - Length(LastChar));
    ComS := S + '...';
  end;

  NewFont := CreateFontIndirect(LogFont);
  try
    OldFont := SelectObject(Canvas.Handle, NewFont);
    TextOut(Canvas.Handle, x, y, PChar(ComS), Length(ComS));
    NewFont := SelectObject(Canvas.Handle, OldFont);
  finally
    DeleteObject(NewFont);
  end;
end;

// グラデーション描画
procedure GradationRect(Canvas: TCanvas; ARect: TRect; Direction: TDirection; ColorA, ColorB: TColor);
var
  C1, C2: LongInt;
  dr, dg, db: Double;
  nr, ng, nb: Double;
  dx, dy: Integer;
  R: TRect;
  DrawWidth: Integer;
  i: Integer;
begin
  C1 := ColorToRGB(ColorA);
  C2 := ColorToRGB(ColorB);
  R := ARect;
  case Direction of
    drLeftRight:
    begin
      dx := +1;
      dy := 0;
      R.Right := R.Left + 1;
      DrawWidth := ARect.Right - ARect.Left;
    end;
    drRightLeft:
    begin
      dx := -1;
      dy := 0;
      R.Left := R.Right - 1;
      DrawWidth := ARect.Right - ARect.Left;
    end;
    drTopDown:
    begin
      dx := 0;
      dy := +1;
      R.Bottom := R.Top + 1;
      DrawWidth := ARect.Bottom - ARect.Top;
    end;
    drBottomUp:
    begin
      dx := 0;
      dy := -1;
      R.Top := R.Bottom - 1;
      DrawWidth := ARect.Bottom - ARect.Top;
    end;
  else
    dx := +1;
    dy := 0;
    R.Right := R.Left + 1;
    DrawWidth := ARect.Right - ARect.Left;
  end;

  nr := GetRValue(C1);
  ng := GetGValue(C1);
  nb := GetBValue(C1);
  dr := (GetRValue(C2) - nr) / DrawWidth;
  dg := (GetGValue(C2) - ng) / DrawWidth;
  db := (GetBValue(C2) - nb) / DrawWidth;

  for i := 0 to DrawWidth - 1 do
  begin
    Canvas.Brush.Color := RGB(Trunc(nr), Trunc(ng), Trunc(nb));
    Canvas.FillRect(R);
    Inc(R.Left, dx);
    Inc(R.Right, dx);
    Inc(R.Top, dy);
    Inc(R.Bottom, dy);
    nr := nr + dr;
    ng := ng + dg;
    nb := nb + db;
  end;
end;

// 中間色に変更
procedure ColorBetween(Canvas: TCanvas; ARect: TRect; Color: TColor);
var
  x,y : integer;
  Bitmap : TBitmap;
  P : PByteArray;
  C: LongInt;
  R, G, B: Word;
begin
  Bitmap := TBitmap.Create;
  try
    C := ColorToRGB(Color);
    R := GetRValue(C);
    G := GetGValue(C);
    B := GetBValue(C);

    Bitmap.Width := ARect.Right - ARect.Left;
    Bitmap.Height := ARect.Bottom - ARect.Top;
    Bitmap.Canvas.CopyMode := cmSrcCopy;
    Bitmap.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, ARect);
    Bitmap.PixelFormat := pf24bit;
    for y := 0 to Bitmap.Height -1 do
    begin
      P := Bitmap.ScanLine[y];
      for x := 0 to Bitmap.Width * 3 -1 do
      begin
        case x mod 3 of
{          0: P[x] := (P[x] + B) div 2;
          1: P[x] := (P[x] + G) div 2;
          2: P[x] := (P[x] + R) div 2;}
          0: P[x] := (P[x] * 2 + B) div 3;
          1: P[x] := (P[x] * 2 + G) div 3;
          2: P[x] := (P[x] * 2 + R) div 3;
        end;
      end;
    end;
    Canvas.Draw(ARect.Left, ARect.Top ,Bitmap);
  finally
    Bitmap.Free;
  end;
end;

function GetFontColorFromFaceColor(FaceColor: TColor): TColor;
var
  C: LongInt;
  R, G, B: Word;
//  Y, MaxY: Integer;
  Y: Double;
begin
  case FaceColor of
    clActiveCaption:
      Result := clCaptionText;
    clInactiveCaption:
      Result := clInactiveCaptionText;
    clMenu:
      Result := clMenuText;
    clWindow:
      Result := clWindowText;
    clBtnFace:
      Result := clBtnText;
    clHighlight:
      Result := clHighlightText;
    clInfoBk:
      Result := clInfoText;
  else
    C := ColorToRGB(FaceColor);
    R := GetRValue(C);
    G := GetGValue(C);
    B := GetBValue(C);
{    Y := R * 299 + G * 587 + B * 114;
    MaxY := $FF * 299 + $FF * 587 + $FF * 114;
    if Y <= (MaxY / 2) then
      Result := clWhite
    else
      Result := clBlack;}

    Y := (0.24 * R + 0.67 * G + 0.08 * B) / 255;

    if Y >= 0.5 then
      Result := clBlack
    else
      Result := clWhite;

  end;
end;

function GetShadowColor(FaceColor: TColor): TColor;
var
  C: LongInt;
  R, G, B: Word;
begin
  C := ColorToRGB(FaceColor);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);
  Result := RGB(R * 2 div 3, G * 2 div 3, B * 2 div 3);
end;


/////////////////////
// TSLButton
constructor TSLButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 32, 32);
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  Color := clBtnFace;
  FocusColor := clBlue;
  FRepeatDelay := 400;
  FRepeatInterval := 100;
end;

destructor TSLButton.Destroy;
begin
  if MouseEntered then // マウスが入ってるとタイマー等が動いたままになる
    MouseEntered := False;
  inherited Destroy;
end;

procedure TSLButton.CMTextChanged(var Msg: TMessage);
begin
  Invalidate;
end;

procedure TSLButton.Paint;
begin
end;

procedure TSLButton.CMWinIniChange(var Msg: TMessage);
var
  LogFont: TLogFont;
begin
  SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont), @LogFont, 0);
  Font.Handle := CreateFontIndirect(LogFont);
end;


procedure TSLButton.CMColorChanged(var Msg: TMessage);
var
  C: LongInt;
  R, G, B: Word;
begin
  C := ColorToRGB(Color);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  if Color = clBtnFace then
  begin
    FHighlightColor := clBtnHighlight;
    FShadowColor := clBtnShadow;
    FDarkColor := clBlack;
  end
  else
  begin
    FHighlightColor := RGB((R + $FF) div 2, (G + $FF) div 2, (B + $FF) div 2);
    FShadowColor := RGB(R div 2, G div 2, B div 2);
    FDarkColor := RGB(R div 4, G div 4, B div 4);
  end;

  Invalidate;
end;

procedure TSLButton.SetActive(Value: Boolean);
begin
  if FActive = Value then
    Exit;

  FActive := Value;

  FocusCheck;
end;

procedure TSLButton.SetSelected(Value: Boolean);
begin
  if FSelected = Value then
    Exit;

  FSelected := Value;

  FocusCheck;
end;

procedure TSLButton.SetMouseEntered(Value: Boolean);
var
  P: TPoint;
begin
  if FMouseEntered = Value then
    Exit;


  if Value then
  begin
    if (MouseInButton <> Self) and (MouseInButton <> nil) then
      MouseInButton.MouseEntered := False;

    // 本当にマウスポインタが入ってるか？
    GetCursorPos(P);
    P := ScreenToClient(P);
    if PtInRect(ClientRect, P) then
    begin
      FMouseEntered := Value;

      MouseInButton := Self;
      if Assigned(FOnMouseEnter) then
        FOnMouseEnter(Self);

      if MouseTimer = nil then
        MouseTimer := TTimer.Create(Self)
      else
        MouseTimer.Enabled := False;
      MouseTimer.Interval := 125;
      MouseTimer.OnTimer := MouseTimerTimer;
      MouseTimer.Enabled := True;
    end;

  end
  else
  begin
    if MouseTimer <> nil then
      MouseTimer.Free;
    MouseTimer := nil;
    MouseInButton := nil;
    FMouseEntered := Value;
    if Assigned(FOnMouseLeave) then
    begin
      FOnMouseLeave(Self);
    end;
  end;

  FocusCheck;
end;


procedure TSLButton.FocusCheck;
var
  NewFocusEnter: Boolean;
begin
  NewFocusEnter := (FSelected and FActive) or FMouseEntered;

  if FFocusEnter <> NewFocusEnter then
  begin
    FFocusEnter := NewFocusEnter;
    Invalidate;
  end;
end;


procedure TSLButton.SetFocusColor(Value: TColor);
begin
  if FFocusColor = Value then
    Exit;
  FFocusColor := Value;
  Invalidate;
end;

procedure TSLButton.SetSelTransparent(Value: Boolean);
begin
  if FSelTransparent = Value then
    Exit;
  FSelTransparent := Value;
  Invalidate;
end;

procedure TSLButton.SetTransparent(Value: Boolean);
begin
  if FTransparent = Value then
    Exit;
  FTransparent := Value;
  Invalidate;
end;

procedure TSLButton.SetRepeatTimer(Value: Boolean);
begin
  if Value = (FRepeatTimer <> nil) then
    Exit;

  FRepeatTimer.Free;
  FRepeatTimer := nil;
  if Value then
  begin
    FRepeatTimer := TTimer.Create(Self);
    FRepeatTimer.Interval := FRepeatDelay;
    FRepeatTimer.OnTimer := RepeatTimerTimer;
    FRepeatTimer.Enabled := True;
  end;
end;

procedure TSLButton.RepeatTimerTimer(Sender: TObject);
var
  P: TPoint;
begin
  FRepeatTimer.Interval := FRepeatInterval;
  GetCursorPos(P);
  P := ScreenToClient(P);
  if Enabled and Repeating and FDragging and MouseCapture and PtInRect(ClientRect, P) then
    Click;
end;

procedure TSLButton.MouseTimerTimer(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  MouseEntered := PtInRect(ClientRect, P);
end;

procedure TSLButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  MouseEntered := True;
  if (Button = mbLeft) and Enabled then
  begin
    FDragging := True;
    FDragPos.X := X;
    FDragPos.Y := Y;
    FState := bsDown;
    Repaint;
    if FRepeating then
    begin
      Click;
      SetRepeatTimer(True);
    end;
  end
  else
  begin
    FDragging := False;
    if FState <> bsUp then
    begin
      FState := bsUp;
      Invalidate;
    end;
  end;
end;

procedure TSLButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  MousePos: TPoint;
  NewState: TButtonState;
begin
  inherited;

  // マウスポインタが動いてなければMouseEnteredは変更しない
  MousePos := ClientToScreen(Point(X, Y));
  if (MouseLastPos.x <> MousePos.x) or (MouseLastPos.y <> MousePos.y) then
  begin
    MouseLastPos := MousePos;
    MouseEntered := PtInRect(ClientRect, Point(X, Y));
  end;

  if FDragging and FDragSrouce and Assigned(FOnStartDrag) then
  begin
    if (Abs(FDragPos.X - X) > 10) or (Abs(FDragPos.Y - Y) > 10) then
    begin
      FDragging := False;
      if FState <> bsUp then
      begin
        FState := bsUp;
        Invalidate;
      end;
      FOnStartDrag(Self);
      Exit;
    end;
  end;


  if FDragging then
  begin
    if FMouseEntered then
      NewState := bsDown
    else
      NewState := bsUp;
    SetRepeatTimer(FRepeating and (NewState = bsDown));
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TSLButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  SetRepeatTimer(False);
  inherited;
  if FDragging then
  begin
    FDragging := False;
    if FState <> bsUp then
    begin
      FState := bsUp;
      Invalidate;
    end;
    if PtInRect(ClientRect, Point(X, Y)) and not FRepeating then
      Click;
  end;
end;

procedure TSLButton.Click;
begin
  inherited Click;
end;



procedure TSLButton.DrawFrame(Canvas: TCanvas; ARect: TRect; Down: Boolean);
begin
  with ARect do
  begin
    if Down then
    begin
      Canvas.Pen.Color := FHighlightColor;
      Canvas.Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left, Bottom - 1)]);
      Canvas.Pen.Color := FDarkColor;
      Canvas.Polyline([Point(Left, Bottom - 1), Point(Left, Top), Point(Right - 1, Top)]);
      Canvas.Pen.Color := FShadowColor;
      Canvas.Polyline([Point(Left + 1, Bottom - 2), Point(Left + 1, Top + 1), Point(Right - 2, Top + 1)]);
    end
    else
    begin
      Canvas.Pen.Color := FHighlightColor;
      Canvas.Polyline([Point(Left, Bottom - 1), Point(Left, Top), Point(Right - 1, Top)]);
      Canvas.Pen.Color := FShadowColor;
      Canvas.Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left, Bottom - 1)]);
    end;
  end;
end;


/////////////////////
// TSLScrollButton
constructor TSLScrollButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSLScrollButton.Destroy;
begin
  inherited Destroy;
end;

procedure TSLScrollButton.Paint;
var
  i, x, y: Integer;
  P, PD: array[0..2] of TPoint;
  Bmp: TBitmap;
  ACanvas: TCanvas;
  BackColor: TColor;
begin
  inherited;

  if FTransparent then
  begin
    Bmp := nil;
    ACanvas := Canvas;
  end
  else
  begin
    Bmp := TBitmap.Create;
    Bmp.Width := ClientWidth;
    Bmp.Height := ClientHeight;
    ACanvas := Bmp.Canvas;
  end;

  try
    // 選択状態を透明でなく表示
    if Enabled and FFocusEnter and not FSelTransparent then
    begin
      BackColor := FFocusColor;
      ACanvas.Brush.Color := FFocusColor;
      ACanvas.FillRect(ClientRect);
    end
    else
    begin
      BackColor := Color;
      ACanvas.Brush.Color := Color;
      if not FTransparent then
        ACanvas.FillRect(ClientRect);
    end;

    DrawFrame(ACanvas, ClientRect, FState = bsDown);

    if (FState = bsDown)
      and (Width >= 10) and (Height >= 10)
      or ((Width >= 12) and (Height >= 12)) then
    begin
      x := Width div 2;
      y := Height div 2;
      if FVertical then
      begin
        if FKind in [skGUp, skUp] then
        begin
          P[0] := Point(x, y - 2);
          P[1] := Point(x - 3, y + 1);
          P[2] := Point(x + 3, y + 1);
        end
        else
        begin
          P[0] := Point(x, y + 2);
          P[1] := Point(x - 3, y - 1);
          P[2] := Point(x + 3, y - 1);
        end;
      end
      else
      begin
        if FKind in [skGUp, skUp] then
        begin
          P[0] := Point(x - 2, y);
          P[1] := Point(x + 1, y - 3);
          P[2] := Point(x + 1, y + 3);
        end
        else
        begin
          P[0] := Point(x + 2, y);
          P[1] := Point(x - 1, y - 3);
          P[2] := Point(x - 1, y + 3);
        end;
      end;

      if FState = bsDown then
        for i := 0 to 2 do
        begin
          Inc(P[i].x);
          Inc(P[i].y);
        end;

      if Enabled then
        ACanvas.Pen.Color := GetFontColorFromFaceColor(BackColor)
      else
      begin
        for i := 0 to 2 do
        begin
          PD[i].x := P[i].x + 1;
          PD[i].y := P[i].y + 1;
        end;

        ACanvas.Pen.Color := HighlightColor;
        ACanvas.Brush.Color := ACanvas.Pen.Color;
        ACanvas.Polygon(PD);

        ACanvas.Pen.Color := ShadowColor;
      end;

      ACanvas.Brush.Color := ACanvas.Pen.Color;
      ACanvas.Polygon(P);
    end;

    if FSelTransparent then
    begin
      if Enabled and FFocusEnter then
        ColorBetween(ACanvas, ClientRect, FFocusColor);
      if FState = bsDown then
        ColorBetween(ACanvas, ClientRect, clBlack);
    end;

    if not FTransparent then
    begin
      Canvas.Draw(0, 0, Bmp);
    end;
  finally
    Bmp.Free;
  end;

end;

procedure TSLScrollButton.SetKind(Value: TSLScrollButtonKind);
begin
  if FKind = Value then
    Exit;
  FKind := Value;
  Invalidate;
end;

procedure TSLScrollButton.SetVertical(Value: Boolean);
begin
  if FVertical = Value then
    Exit;
  FVertical := Value;
  Invalidate;
end;



/////////////////////
// TSLNormalButton
constructor TSLNormalButton.Create(AOwner: TComponent);
var
  LogFont: TLogFont;
begin
  inherited Create(AOwner);
  SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont), @LogFont, 0);
  Font.Handle := CreateFontIndirect(LogFont);
  FSpacing := 4;
  FNarrowText := False;
end;

destructor TSLNormalButton.Destroy;
begin
  IconHandle := 0;
  inherited Destroy;
end;


procedure TSLNormalButton.SetIconHandle(Value: HIcon);
begin
  if FIconHandle = Value then
    Exit;
  if FIconHandle <> 0 then
    DestroyIcon(FIconHandle);
  FIconHandle := Value;
  Invalidate;
end;

function TSLNormalButton.GetIconSize: Integer;
var
  H: Integer;
begin
  if FIconHandle = 0 then
    Result := 0
  else if FSmallIcon then
    Result := 16
  else
  begin
    Result := GetSystemMetrics(SM_CXICON);
    H := GetSystemMetrics(SM_CYICON);
    if Result > H then
      Result := H;
  end;
end;

function TSLNormalButton.GetSpacing: Integer;
begin
  if FIconHandle <> 0 then
    Result := FSpacing
  else
    Result := 0;
end;

procedure TSLNormalButton.SetSpacing(Value: Integer);
begin
  if FSpacing = Value then
    Exit;
  FSpacing := Value;
  Invalidate;
end;

procedure TSLNormalButton.SetCaptionPosition(Value: TSLBtnCaptionPosition);
begin
  if FCaptionPosition = Value then
    Exit;
  FCaptionPosition := Value;
  Invalidate;
end;

procedure TSLNormalButton.SetSmallIcon(Value: Boolean);
begin
  if FSmallIcon = Value then
    Exit;
  FSmallIcon := Value;
  Invalidate;
end;

procedure TSLNormalButton.Paint;
var
  BrushStyleBack: TBrushStyle;
  IconX, IconY, IconS: Integer;
  TextX, TextY, TextW, TextH: Integer;
  Bmp: TBitmap;
  ACanvas: TCanvas;
  BackColor: TColor;
begin
  inherited;

  if FTransparent or Assigned(FOnSkinDrawFace) then
  begin
    Bmp := nil;
    ACanvas := Canvas;
  end
  else
  begin
    Bmp := TBitmap.Create;
    Bmp.Width := ClientWidth;
    Bmp.Height := ClientHeight;
    ACanvas := Bmp.Canvas;
  end;

  try

    // スキンによる表面の描画
    if Assigned(FOnSkinDrawFace) and FOnSkinDrawFace(Self, ClientRect) then
    begin
      // 選択状態を透明でなく表示
      if Enabled and FFocusEnter and not FSelTransparent then
        BackColor := FFocusColor
      else
        BackColor := Color;
    end
    else
    begin
      // 選択状態を透明でなく表示
      if Enabled and FFocusEnter and not FSelTransparent then
      begin
        BackColor := FFocusColor;
        ACanvas.Brush.Color := FFocusColor;
        ACanvas.FillRect(ClientRect);
      end
      else
      begin
        BackColor := Color;
        ACanvas.Brush.Color := Color;
        if not FTransparent then
          ACanvas.FillRect(ClientRect);
      end;
    end;


//    DrawFrame(ACanvas, ClientRect, FState = bsDown);

    ACanvas.Font.Assign(Font);
    case FCaptionPosition of
      cpBottom:
      begin
        IconS := IconSize;
        if IconS > Width - BUTTON_MARGIN then
          IconS := Width - BUTTON_MARGIN;
        if IconS > Height - BUTTON_MARGIN then
          IconS := Height - BUTTON_MARGIN;
        TextW := ACanvas.TextWidth(Caption);
        TextH := ACanvas.TextHeight(Caption);
        if TextW > Width - BUTTON_MARGIN then
          TextW := Width - BUTTON_MARGIN;

        IconX := (Width - IconS) div 2;
        IconY := (Height - IconS - TextH - Spacing) div 2;
        if IconY < BUTTON_MARGIN div 2 then
          IconY := BUTTON_MARGIN div 2;
        TextX := (Width - TextW) div 2;
        TextY := IconY + IconS + Spacing;
        if (TextY + TextH) > Height - BUTTON_MARGIN then
          TextY := Height - BUTTON_MARGIN - TextH;
      end;
      cpRight:
      begin
        IconS := IconSize;
        if IconS > Width - BUTTON_MARGIN then
          IconS := Width - BUTTON_MARGIN;
        if IconS > Height - BUTTON_MARGIN then
          IconS := Height - BUTTON_MARGIN;
        TextW := ACanvas.TextWidth(Caption);
        TextH := ACanvas.TextHeight(Caption);
        if TextW > Width - IconS - Spacing - BUTTON_MARGIN then
          TextW := Width - IconS - Spacing - BUTTON_MARGIN;

        IconX := BUTTON_MARGIN div 2;
        IconY := (Height - IconS) div 2;
        TextX := IconX + IconS + Spacing;
        TextY := (Height - TextH) div 2;
      end;
      else
      begin
        if Width < Height then
          IconS := Width - BUTTON_MARGIN
        else
          IconS := Height - BUTTON_MARGIN;
        TextW := 0;
        TextH := 0;

        IconX := (Width - IconS) div 2;
        IconY := (Height - IconS) div 2;
        TextX := 0;
        TextY := 0;
      end;
    end;

    if FState = bsDown then
    begin
      Inc(IconX);
      Inc(IconY);
      Inc(TextX);
      Inc(TextY);
    end;

    if IconHandle <> 0 then
    begin
      if not Assigned(FOnSkinDrawIcon) or not FOnSkinDrawIcon(Self, ClientRect) then
        DrawIconEx(ACanvas.Handle, IconX, IconY, IconHandle, IconS, IconS, 0, 0, DI_NORMAL);
    end;

    if not Assigned(FOnSkinDrawCaption) or not FOnSkinDrawCaption(Self, ClientRect) then
    begin
      if (Caption <> '') and (FCaptionPosition <> cpNone) then
      begin
        BrushStyleBack := ACanvas.Brush.Style;
        ACanvas.Font.Color := GetFontColorFromFaceColor(BackColor);
        ACanvas.Brush.Style := bsClear;
        try
          FNarrowText := DrawNarrowText(ACanvas, Bounds(TextX, TextY, TextW, TextH), Caption);
        finally
          ACanvas.Brush.Style := BrushStyleBack;
        end;
      end;
    end;

    if not Assigned(FOnSkinDrawFrame) or not FOnSkinDrawFrame(Self, ClientRect) then
      DrawFrame(ACanvas, ClientRect, FState = bsDown);

    if not Assigned(FOnSkinDrawMask) or not FOnSkinDrawMask(Self, ClientRect) then
    begin
      if FSelTransparent then
      begin
        if Enabled and FFocusEnter then
          ColorBetween(ACanvas, ClientRect, FFocusColor);
        if FState = bsDown then
          ColorBetween(ACanvas, ClientRect, clBlack);
      end;
    end;

    if ACanvas <> Canvas then
    begin
      Canvas.Draw(0, 0, Bmp);
    end;
  finally
    Bmp.Free;
  end;
end;


/////////////////////
// TSLPluginButton
constructor TSLPluginButton.Create(AOwner: TComponent);
begin
  inherited;
  if Assigned(FOnCreate) then
    FOnCreate(Self);
end;

destructor TSLPluginButton.Destroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
  inherited;
end;

procedure TSLPluginButton.Paint;
var
  DrawRect: TRect;
begin
  if FOwnerDraw and Assigned(FOnDrawButton) then
  begin
    // スキンによる表面の描画
    if not Assigned(FOnSkinDrawFace) or not FOnSkinDrawFace(Self, ClientRect) then
    begin
      // 選択状態を透明でなく表示
      if Enabled and FFocusEnter and not FSelTransparent then
      begin
        Canvas.Brush.Color := FFocusColor;
        Canvas.FillRect(ClientRect);
      end
      else
      begin
        Canvas.Brush.Color := Color;
        if not FTransparent then
          Canvas.FillRect(ClientRect);
      end;
    end;



    DrawRect.Left := ClientRect.Left + 2;
    DrawRect.Top := ClientRect.Top + 2;
    DrawRect.Right := ClientRect.Right - 2;
    DrawRect.Bottom := ClientRect.Bottom - 2;
    if FState = bsDown then
    begin
      Inc(DrawRect.Left);
      Inc(DrawRect.Top);
      Inc(DrawRect.Right);
      Inc(DrawRect.Bottom);
    end;

    FOnDrawButton(Self, DrawRect, FState);

    if not Assigned(FOnSkinDrawFrame) or not FOnSkinDrawFrame(Self, ClientRect) then
      DrawFrame(Canvas, ClientRect, FState = bsDown);


    if not Assigned(FOnSkinDrawMask) or not FOnSkinDrawMask(Self, ClientRect) then
    begin
      if FSelTransparent then
      begin
        if Enabled and FFocusEnter then
          ColorBetween(Canvas, ClientRect, FFocusColor);
        if FState = bsDown then
          ColorBetween(Canvas, ClientRect, clBlack);
      end;
    end;


  end
  else
    inherited
end;




end.
