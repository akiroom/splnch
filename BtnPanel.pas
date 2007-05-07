unit BtnPanel;

interface

uses
  Windows, Messages, Classes, Controls, Graphics;


const
  DS_NONE = 0; // ï\é¶ÇµÇ»Ç¢
  DS_LEFT = 1; // ç∂
  DS_TOP = 2; // è„
  DS_RIGHT = 3; // âE
  DS_BOTTOM = 4; // â∫

type
  TButtonState = class(TObject)
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    State: set of (bsPushed, bsEnabled, bsEntered, bsActived);
    procedure DrawFace;
    procedure DrawFrame;
    procedure DrawIcon;
  end;


{ TButtonPanel }
  TButtonPanel = class(TGraphicControl)
  private
    FOffscreen: TBitmap;
    FWallpaper: TBitmap;
    FHighlightColor: TColor;
    FShadowColor: TColor;
    FDarkColor: TColor;

    FFaceColor: TColor;
    FWallpaperFile: String;
    FFocusColor: TColor;
    FSelTransparent: Boolean;
    FTransparent: Boolean;
    procedure SetFaceColor(const Value: TColor);
    procedure SetWallpaperFile(const Value: String);
    procedure SetFocusColor(const Value: TColor);
    procedure SetSelTransparent(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure DrawFrame(ARect: TRect; Down: Boolean);
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure Draw; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Color;
    property FaceColor: TColor read FFaceColor write SetFaceColor;
    property WallpaperFile: String read FWallpaperFile write SetWallpaperFile;
    property FocusColor: TColor read FFocusColor write SetFocusColor;
    property SelTransparent: Boolean read FSelTransparent write SetSelTransparent;
    property Transparent: Boolean read FTransparent write SetTransparent;
  end;

{ TScrollButtonPanel }
  TScrollButtonPanel = class(TButtonPanel)
  private
    FButtonStates: array[0..3] of TButtonState;
    FPosition: Integer;
    FShowGroupButton: Boolean;
    FShowScrollButton: Boolean;
    FVertical: Boolean;
    procedure SetPosition(const Value: Integer);
    procedure SetRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw; override;

    property Position: Integer read FPosition write SetPosition;
    property ShowGroupButton: Boolean read FShowGroupButton write FShowGroupButton;
    property ShowScrollButton: Boolean read FShowScrollButton write FShowScrollButton;
    property Vertical: Boolean read FVertical write FVertical;
  end;

implementation

{ TButtonState }
procedure TButtonState.DrawFace;
begin
end;

procedure TButtonState.DrawFrame;
begin
end;

procedure TButtonState.DrawIcon;
begin
end;



{ TButtonPanel }

procedure TButtonPanel.SetFaceColor(const Value: TColor);
var
  C: LongInt;
  R, G, B: Word;
begin
  if FFaceColor = Value then
    Exit;

  FFaceColor := Value;
  C := ColorToRGB(FFaceColor);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  if FFaceColor = clBtnFace then
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
end;

procedure TButtonPanel.SetWallpaperFile(const Value: String);
begin
  if FWallpaperFile = Value then
    Exit;
  FWallpaperFile := Value;

  if FWallpaperFile = '' then
  begin
    FWallpaper.Free;
    FWallpaper := nil;
  end
  else
  begin
    if FWallpaper = nil then
      FWallpaper := TBitmap.Create;
    try
      FWallpaper.LoadFromFile(FWallpaperFile);
      FOffScreen.Canvas.Brush.Bitmap := FWallpaper;
    except
      FWallpaper.Free;
      FWallpaper := nil;
    end;
  end;

end;

procedure TButtonPanel.SetFocusColor(const Value: TColor);
begin
  FFocusColor := Value;
end;

procedure TButtonPanel.SetSelTransparent(const Value: Boolean);
begin
  FSelTransparent := Value;
end;

procedure TButtonPanel.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

procedure TButtonPanel.DrawFrame(ARect: TRect; Down: Boolean);
begin
  with ARect do
  begin
    if Down then
    begin
      FOffScreen.Canvas.Pen.Color := FHighlightColor;
      FOffScreen.Canvas.Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left, Bottom - 1)]);
      FOffScreen.Canvas.Pen.Color := FDarkColor;
      FOffScreen.Canvas.Polyline([Point(Left, Bottom - 1), Point(Left, Top), Point(Right - 1, Top)]);
      FOffScreen.Canvas.Pen.Color := FShadowColor;
      FOffScreen.Canvas.Polyline([Point(Left + 1, Bottom - 2), Point(Left + 1, Top + 1), Point(Right - 2, Top + 1)]);
    end
    else
    begin
      FOffScreen.Canvas.Pen.Color := FHighlightColor;
      FOffScreen.Canvas.Polyline([Point(Left, Bottom - 1), Point(Left, Top), Point(Right - 1, Top)]);
      FOffScreen.Canvas.Pen.Color := FShadowColor;
      FOffScreen.Canvas.Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left, Bottom - 1)]);
    end;
  end;
end;

procedure TButtonPanel.Resize;
begin
  inherited;
  FOffscreen.Width := Width;
  FOffscreen.Height := Height;
end;

procedure TButtonPanel.Paint;
begin
  inherited;
  Canvas.Draw(0, 0, FOffscreen);
end;

procedure TButtonPanel.Draw;
begin
  // ï«éÜï`âÊ
  if FWallpaper = nil then
    FOffScreen.Canvas.Brush.Color := Color
  else
    FOffScreen.Canvas.Brush.Bitmap := FWallpaper;
  FOffScreen.Canvas.FillRect(Rect(0, 0, FOffScreen.Width, FOffScreen.Height));
end;

constructor TButtonPanel.Create(AOwner: TComponent);
begin
  inherited;
  FOffscreen := TBitmap.Create;
  Color := clAppWorkSpace;
  FaceColor := clBtnFace;
end;

destructor TButtonPanel.Destroy;
begin
  FWallpaperFile := '';

  FOffscreen.Free;
  inherited;
end;

{ TScrollButtonPanel }

constructor TScrollButtonPanel.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited;

  for i := 0 to 3 do
  begin
    FButtonStates[i] := TButtonState.Create;
  end;
end;

destructor TScrollButtonPanel.Destroy;
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    FButtonStates[i].Free;
  end;

  inherited;
end;

procedure TScrollButtonPanel.SetPosition(const Value: Integer);
begin
  FPosition := Value;
  case Value of
    DS_LEFT:
      Align := alLeft;
    DS_TOP:
      Align := alTop;
    DS_RIGHT:
      Align := alRight;
    DS_BOTTOM:
      Align := alBottom;
  end;
  Visible := Value <> DS_NONE;
end;

procedure TScrollButtonPanel.SetRect;
var
  i: Integer;
  W: Integer;
  Half, Long: Integer;
begin
  if FPosition in [DS_LEFT, DS_RIGHT] then
  begin
    W := ClientWidth;
    Half := ClientHeight div 2;
    for i := 0 to 3 do
    begin
      FButtonStates[i].Left := 0;
      FButtonStates[i].Width := W;
    end;

    if FShowScrollButton and FShowGroupButton then
    begin
      Long := Half - ClientWidth;
      if Long < ClientWidth then
        Long := ClientHeight div 4;
      FButtonStates[0].Top := 0;
      FButtonStates[0].Height := Half - Long;
      FButtonStates[1].Top := Half - Long;
      FButtonStates[1].Height := Long;
      FButtonStates[2].Top := Half;
      FButtonStates[2].Height := Long;
      FButtonStates[3].Top := Half + Long;
      FButtonStates[3].Height := ClientHeight - Long - Half;
    end
    else
    begin
    end;
  end
  else
  begin
    W := ClientHeight;
    Half := ClientWidth div 2;
    if FShowScrollButton and FShowGroupButton then
    begin
    end
    else
    begin
    end;
  end;
end;

procedure TScrollButtonPanel.Draw;
var
  i, x, y: Integer;
  P, PD: array[0..2] of TPoint;
begin
  inherited;
  SetRect;
  for i := 0 to 3 do
  begin
    DrawFrame(Rect(FButtonStates[i].Left, FButtonStates[i].Top, FButtonStates[i].Left + FButtonStates[i].Width, FButtonStates[i].Top + FButtonStates[i].Height), False); 

    if ((i in [0, 3]) and FShowGroupButton) or ((i in [1, 2]) and FShowScrollButton)then
    begin

    end;
  end;

  Invalidate;
end;


end.
