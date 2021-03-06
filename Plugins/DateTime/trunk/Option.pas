unit Option;

interface

uses
  Windows, Forms, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Graphics,
  IniFiles, Memo, Dialogs, Julius, SysUtils;


type
  TColorPartConfig = class(TObject)
    Name: String;
    Color: TColor;
  end;

  TFontPartConfig = class(TObject)
    Name: String;
    FontName: String;
    FontSize: Integer;
    FontStyle: TFontStyles;
  end;

  TPartConfig = class(TObject)
    ColorPart: TColorPartConfig;
    FontPart: TFontPartConfig;
  end;

  TPartRect = class(TObject)
    Rect: TRect;
  end;


  TdlgOption = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    pnlDesign: TPanel;
    pbDesign: TPaintBox;
    Label1: TLabel;
    cmbParts: TComboBox;
    btnColor: TButton;
    dlgColor: TColorDialog;
    cmbColor: TComboBox;
    lblColor: TLabel;
    cmbFontName: TComboBox;
    cmbFontSize: TComboBox;
    cmbFontStyle: TComboBox;
    lblFontName: TLabel;
    lblFontSize: TLabel;
    lblFontStyle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmbPartsChange(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbDesignPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbDesignMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmbColorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbColorChange(Sender: TObject);
    procedure cmbFontNameChange(Sender: TObject);
    procedure cmbFontSizeChange(Sender: TObject);
    procedure cmbFontStyleChange(Sender: TObject);
  private
    OwnerWnd: HWND;

    FColorPartList: TList;
    FFontPartList: TList;
    FPartStringList: TStringList;

    FStringColor: TColorPartConfig;
    FStringFont: TFontPartConfig;
    FTodayColor: TColorPartConfig;
    FSundayColor: TColorPartConfig;
    FSaturdayColor: TColorPartConfig;
    FHolidayColor: TColorPartConfig;
    FMemoFont: TFontPartConfig;
    FLineColor: TColorPartConfig;
    FBackGroundColor: TColorPartConfig;

    procedure SetColor;
  public
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerWnd: HWND);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetOptions;
  end;

var
  dlgOption: TdlgOption;

implementation

uses Cal;

{$R *.DFM}

{ TdlgOption }

// コンストラクタ
constructor TdlgOption.CreateOwnedForm(AOwner: TComponent; AOwnerWnd: HWND);
begin
  OwnerWnd := AOwnerWnd;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgOption.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerWnd;
end;


procedure TdlgOption.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  Config: TPartConfig;
  c: TColor;
  i: Integer;
const
  PColor: array[0..7] of TColor = (clWhite, clBlack, clRed, clBlue, clLime, clFuchsia, clYellow, clAqua);
begin
  FColorPartList := TList.Create;
  FFontPartList := TList.Create;
  FPartStringList := TStringList.Create;

  // 色の一覧作成
  cmbColor.Items.Add(IntToStr(0));
  cmbColor.Items.Add(IntToStr(0));
  for i := 0 to 8 do
  begin
    c := PColor[i];
    while c > 0 do
    begin
      cmbColor.Items.Add(IntToStr(c));
      c := c - PColor[i] div 5;
    end;
  end;

  // フォントの一覧作成
  for i := 0 to Screen.Fonts.Count - 1 do
    cmbFontName.Items.Add(Screen.Fonts[i]);
  for i := 6 to 28 do
    cmbFontSize.Items.Add(IntToStr(i));
  cmbFontStyle.Items.Add('標準');
  cmbFontStyle.Items.Add('太字');
  cmbFontStyle.Items.Add('斜体');
  cmbFontStyle.Items.Add('太字 斜体');


  Ini := TIniFile.Create(InitFileName);
  try
    // 通常文字のフォント
    FStringFont := TFontPartConfig.Create;
    FStringFont.Name := 'String';
    FStringFont.FontName := Ini.ReadString('Design', 'StringFontName', Font.Name);
    FStringFont.FontSize := Ini.ReadInteger('Design', 'StringFontSize', Font.Size);
    if Ini.ReadBool('Design', 'StringFontBold', False) then
      Include(FStringFont.FontStyle, fsBold);
    if Ini.ReadBool('Design', 'StringFontItalic', False) then
      Include(FStringFont.FontStyle, fsItalic);
    FFontPartList.Add(FStringFont);

    // 通常文字の色
    FStringColor := TColorPartConfig.Create;
    FStringColor.Name := 'String';
    FStringColor.Color := Ini.ReadInteger('Design', 'StringColor', clNavy);
    FColorPartList.Add(FStringColor);

    // 今日の色
    FTodayColor := TColorPartConfig.Create;
    FTodayColor.Name := 'Today';
    FTodayColor.Color := Ini.ReadInteger('Design', 'TodayColor', clYellow);
    FColorPartList.Add(FTodayColor);

    // 日曜日の色
    FSundayColor := TColorPartConfig.Create;
    FSundayColor.Name := 'Sunday';
    FSundayColor.Color := Ini.ReadInteger('Design', 'SundayColor', clRed);
    FColorPartList.Add(FSundayColor);

    // 土曜日の色
    FSaturdayColor := TColorPartConfig.Create;
    FSaturdayColor.Name := 'Saturday';
    FSaturdayColor.Color := Ini.ReadInteger('Design', 'SaturdayColor', clBlue);
    FColorPartList.Add(FSaturdayColor);

    // 休日の色
    FHolidayColor := TColorPartConfig.Create;
    FHolidayColor.Name := 'Holiday';
    FHolidayColor.Color := Ini.ReadInteger('Design', 'HolidayColor', clRed);
    FColorPartList.Add(FHolidayColor);

    // メモのフォント
    FMemoFont := TFontPartConfig.Create;
    FMemoFont.Name := 'Memo';
    FMemoFont.FontName := Ini.ReadString('Design', 'MemoFontName', Font.Name);
    FMemoFont.FontSize := Ini.ReadInteger('Design', 'MemoFontSize', Font.Size);
    if Ini.ReadBool('Design', 'MemoFontBold', False) then
      Include(FMemoFont.FontStyle, fsBold);
    if Ini.ReadBool('Design', 'MemoFontItalic', False) then
      Include(FMemoFont.FontStyle, fsItalic);
    FFontPartList.Add(FMemoFont);

    // 枠線の色
    FLineColor := TColorPartConfig.Create;
    FLineColor.Name := 'Line';
    FLineColor.Color := Ini.ReadInteger('Design', 'LineColor', clGray);
    FColorPartList.Add(FLineColor);

    // 背景の色
    FBackGroundColor := TColorPartConfig.Create;
    FBackGroundColor.Name := 'BackGround';
    FBackGroundColor.Color := Ini.ReadInteger('Design', 'BackGroundColor', clWhite);
    FColorPartList.Add(FBackGroundColor);




    // 通常文字
    Config := TPartConfig.Create;
    Config.ColorPart := FStringColor;
    Config.FontPart := FStringFont;
    cmbParts.Items.AddObject('通常文字', Config);

    // 今日
    Config := TPartConfig.Create;
    Config.ColorPart := FTodayColor;
    Config.FontPart := FStringFont;
    cmbParts.Items.AddObject('今日', Config);

    // 日曜日
    Config := TPartConfig.Create;
    Config.ColorPart := FSundayColor;
    Config.FontPart := FStringFont;
    cmbParts.Items.AddObject('日曜日', Config);

    // 土曜日
    Config := TPartConfig.Create;
    Config.ColorPart := FSaturdayColor;
    Config.FontPart := FStringFont;
    cmbParts.Items.AddObject('土曜日', Config);

    // 祝祭日
    Config := TPartConfig.Create;
    Config.ColorPart := FHolidayColor;
    Config.FontPart := FStringFont;
    cmbParts.Items.AddObject('祝祭日', Config);

    // メモ
    Config := TPartConfig.Create;
    Config.FontPart := FMemoFont;
    cmbParts.Items.AddObject('メモ', Config);

    // 枠線
    Config := TPartConfig.Create;
    Config.ColorPart := FLineColor;
    cmbParts.Items.AddObject('枠線', Config);

    // 背景
    Config := TPartConfig.Create;
    Config.ColorPart := FBackGroundColor;
    cmbParts.Items.AddObject('背景', Config);

  finally
    Ini.Free;
  end;

  cmbParts.ItemIndex := 0;
  cmbPartsChange(cmbParts);
end;

procedure TdlgOption.FormShow(Sender: TObject);
begin
  SetOptions;
end;

procedure TdlgOption.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FColorPartList.Count - 1 do
    TColorPartConfig(FColorPartList[i]).Free;
  FColorPartList.Free;
  for i := 0 to FFontPartList.Count - 1 do
    TFontPartConfig(FFontPartList[i]).Free;
  FFontPartList.Free;
  for i := 0 to cmbParts.Items.Count - 1 do
    TPartConfig(cmbParts.Items.Objects[i]).Free;
  cmbParts.Items.Clear;

  for i := 0 to FPartStringList.Count - 1 do
    TPartRect(FPartStringList.Objects[i]).Free;
  FPartStringList.Free;
end;

procedure TdlgOption.OKBtnClick(Sender: TObject);
var
  Ini: TIniFile;
  i: Integer;
begin
  Ini := TIniFile.Create(InitFileName);
  try
    for i := 0 to FColorPartList.Count - 1 do
      Ini.WriteInteger('Design', TColorPartConfig(FColorPartList[i]).Name + 'Color',
        TColorPartConfig(FColorPartList[i]).Color);

    for i := 0 to FFontPartList.Count - 1 do
    begin
      Ini.WriteString('Design', TFontPartConfig(FFontPartList[i]).Name + 'FontName',
        TFontPartConfig(FFontPartList[i]).FontName);
      Ini.WriteInteger('Design', TFontPartConfig(FFontPartList[i]).Name + 'FontSize',
        TFontPartConfig(FFontPartList[i]).FontSize);
      Ini.WriteBool('Design', TFontPartConfig(FFontPartList[i]).Name + 'FontBold',
        fsBold in TFontPartConfig(FFontPartList[i]).FontStyle);
      Ini.WriteBool('Design', TFontPartConfig(FFontPartList[i]).Name + 'FontItalic',
        fsItalic in TFontPartConfig(FFontPartList[i]).FontStyle);
    end;

  finally
    Ini.Free;
  end;

  if frmCal <> nil then
    frmCal.SetOptions;
end;

procedure TdlgOption.SetOptions;
begin
  pnlDesign.Color := FBackGroundColor.Color;
  pbDesign.Invalidate;
end;

// サンプル描画
procedure TdlgOption.pbDesignPaint(Sender: TObject);
  procedure AddPartRect(Left, Top, Width, Height: Integer; Part: String);
  var
    PartRect: TPartRect;
  begin
    PartRect := TPartRect.Create;
    PartRect.Rect := Rect(Left, Top, Left + Width, Top + Height);
    FPartStringList.AddObject(Part, PartRect);
  end;

var
  x, y: Integer;
  r: TRect;
  s: String;
  sw, sh: Integer;
  DayLabelRect: TRect;
  MemoRect: TRect;
  MemoHeight: Integer;
  i: Integer;
begin
  for i := 0 to FPartStringList.Count - 1 do
    TPartRect(FPartStringList.Objects[i]).Free;
  FPartStringList.Clear;


  with pbDesign do
  begin
    // 背景
    Canvas.Brush.Color := FBackGroundColor.Color;
    Canvas.FillRect(ClientRect);

    // メモの高さ
    Canvas.Font.Name := FMemoFont.FontName;
    Canvas.Font.Size := FMemoFont.FontSize;
    Canvas.Font.Style := FMemoFont.FontStyle;
    MemoHeight := Canvas.TextHeight('メモ');

    // 月
    Canvas.Font.Name := FStringFont.FontName;
    Canvas.Font.Size := Trunc(FStringFont.FontSize * 1.8);
    Canvas.Font.Style := FStringFont.FontStyle;
    Canvas.Font.Color := FStringColor.Color;
    x := 8;
    y := 8;
    s := '5';
    sw := Canvas.TextWidth(s);
    sh := Canvas.TextHeight(s);
    Canvas.TextOut(x, y, s);
    AddPartRect(x, y, sw, sh, '通常文字');
    x := x + sw + 5;
    y := y + sh;

    Canvas.Font.Size := FStringFont.FontSize;
    s := 'May 2000';
    sw := Canvas.TextWidth(s);
    sh := Canvas.TextHeight(s);
    y := y - sh;
    Canvas.TextOut(x, y, s);
    AddPartRect(x, y, sw, sh, '通常文字');

    s := '平成12年';
    sw := Canvas.TextWidth(s);
    sh := Canvas.TextHeight(s);
    x := ClientWidth - 8 - sw;
    Canvas.TextOut(x, y, s);
    AddPartRect(x, y, sw, sh, '通常文字');
    y := y + sh;

    // 曜日
    y := y + 8;
    x := 8;
    for i := 0 to 6 do
    begin
      s := WeekNames[i];
      sw := Canvas.TextWidth(s);
      sh := Canvas.TextHeight(s);

      case i of
        0: Canvas.Font.Color := FSundayColor.Color;
        6: Canvas.Font.Color := FSaturdayColor.Color;
      else
        Canvas.Font.Color := FStringColor.Color;
      end;

      r.Left := x;
      r.Right := x + (ClientWidth - 8 - 8) div 7;
      if  ((ClientWidth - 8 - 8) mod 7 > 0) and (i < (ClientWidth - 8 - 8) mod 7) then
        r.Right := r.Right + 1;
      r.Top := y;
      r.Bottom := y + Round(sh * 1.4);

      Canvas.Pen.Color := FLineColor.Color;
      Canvas.Polyline([Point(r.Left + 2, r.Bottom - 1),
                       Point(r.Right - 1, r.Bottom - 1),
                       Point(r.Right - 1, r.Top + 2)]);
      AddPartRect(r.Left + 2, r.Bottom - 2, r.Right - 1 - r.Left - 2, 3, '枠線');
      AddPartRect(r.Right - 2, r.Top + 2, 3, r.Bottom - 1 - r.Top - 2, '枠線');

      DrawText(Canvas.Handle, PChar(s), Length(s), r, DT_SINGLELINE or DT_VCENTER or DT_CENTER);
      case i of
        0: AddPartRect(r.Left + ((r.Right - r.Left) - sw) div 2, r.Top + ((r.Bottom - r.Top) - sh) div 2, sw, sh, '日曜日');
        6: AddPartRect(r.Left + ((r.Right - r.Left) - sw) div 2, r.Top + ((r.Bottom - r.Top) - sh) div 2, sw, sh, '土曜日');
      else
        AddPartRect(r.Left + ((r.Right - r.Left) - sw) div 2, r.Top + ((r.Bottom - r.Top) - sh) div 2, sw, sh, '通常文字');
      end;
      x := r.Right;
    end;






    // 各日
    for i := 0 to 31 do
    begin
      s := Format('%2d', [i]);
      sw := Canvas.TextWidth(s);
      sh := Canvas.TextHeight(s);


      if i mod 7 = 0 then
        Canvas.Font.Color := FSundayColor.Color
      else if i mod 7 = 6 then
        Canvas.Font.Color := FSaturdayColor.Color
      else if i in [3, 4, 5] then
        Canvas.Font.Color := FHolidayColor.Color
      else
        Canvas.Font.Color := FStringColor.Color;

      if (i mod 7) = 0 then
      begin
        x := 8;
        y := r.Bottom;
      end;

      r.Left := x;
      r.Right := x + (ClientWidth - 8 - 8) div 7;
      if  ((ClientWidth - 8 - 8) mod 7 > 0) and ((i mod 7) < (ClientWidth - 8 - 8) mod 7) then
        r.Right := r.Right + 1;
      r.Top := y;
      r.Bottom := y + sh + 4 + Round(MemoHeight * 1.5) + 4;


      if i = 1 then
      begin
        MemoRect.Left := r.Left + 2;
        MemoRect.Top := r.Top + sh + 4;
      end;
      if i = 3 then
        MemoRect.Right := r.Right - 3;



      if i > 0 then
      begin
        Canvas.Pen.Color := FLineColor.Color;
        Canvas.Polyline([Point(r.Left + 2, r.Bottom - 1),
                         Point(r.Right - 1, r.Bottom - 1),
                         Point(r.Right - 1, r.Top + 2)]);
        AddPartRect(r.Left + 2, r.Bottom - 2, r.Right - 1 - r.Left - 2, 3, '枠線');
        AddPartRect(r.Right - 2, r.Top + 2, 3, r.Bottom - 1 - r.Top - 2, '枠線');

        DayLabelRect := r;
        InflateRect(DayLabelRect, -2, -2);
        DayLabelRect.Bottom := DayLabelRect.Top + sh;


        if i = 2 then
        begin
          Canvas.Brush.Color := FTodayColor.Color;
          Canvas.FillRect(DayLabelRect);
        end
        else
          Canvas.Brush.Color := FBackGroundColor.Color;

        DrawText(Canvas.Handle, PChar(s), Length(s), DayLabelRect, DT_SINGLELINE or DT_TOP);

        if i mod 7 = 0 then
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '日曜日')
        else if i mod 7 = 6 then
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '土曜日')
        else if i in [3, 4, 5] then
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '祝祭日')
        else if i = 2 then
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, DayLabelRect.Right - DayLabelRect.Left, DayLabelRect.Bottom - DayLabelRect.Top, '今日')
        else
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '通常文字')


{        case i of
          0, 7: AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '日曜日');
          6, 13: AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '土曜日');
          3..5: AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '祝祭日');
          2: // ２日は今日で何もしない
        else
          AddPartRect(DayLabelRect.Left, DayLabelRect.Top, sw, sh, '通常文字');
        end;}
      end;

      x := r.Right;
    end;

    // メモ
    s := 'メモ';
    Canvas.Font.Name := FMemoFont.FontName;
    Canvas.Font.Size := FMemoFont.FontSize;
    Canvas.Font.Style := FMemoFont.FontStyle;
    Canvas.Font.Color := clBtnText;
    Canvas.Brush.Color := clBtnFace;
//    sw := Canvas.TextWidth(s);
    sh := Canvas.TextHeight(s);

    MemoRect.Bottom := MemoRect.Top + sh + 4;

    Canvas.FillRect(MemoRect);
    Canvas.Pen.Color := clBtnHighlight;
    Canvas.MoveTo(MemoRect.Left, MemoRect.Bottom - 1);
    Canvas.LineTo(MemoRect.Left, MemoRect.Top);
    Canvas.LineTo(MemoRect.Right - 1, MemoRect.Top);
    Canvas.Pen.Color := clBtnShadow;
    Canvas.LineTo(MemoRect.Right - 1, MemoRect.Bottom - 1);
    Canvas.LineTo(MemoRect.Left, MemoRect.Bottom - 1);

    AddPartRect(MemoRect.Left, MemoRect.Top, MemoRect.Right - MemoRect.Left, MemoRect.Bottom - MemoRect.Top, 'メモ');
    InflateRect(MemoRect, -2, -2);
    DrawText(Canvas.Handle, PChar(s), Length(s), MemoRect, DT_SINGLELINE or DT_NOPREFIX or DT_TOP or DT_LEFT);

  end;

end;

procedure TdlgOption.pbDesignMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  Hit: Boolean;
begin
  Hit := False;
  for i := FPartStringList.Count - 1 downto 0 do
  begin
    if PtInRect(TPartRect(FPartStringList.Objects[i]).Rect, Point(X, Y)) then
    begin
      cmbParts.ItemIndex := cmbParts.Items.IndexOf(FPartStringList[i]);
      Hit := True;
      Break;
    end;
  end;

  if not Hit then
    cmbParts.ItemIndex := cmbParts.Items.IndexOf('背景');

  cmbPartsChange(cmbParts);
end;

// 指定する部分
procedure TdlgOption.cmbPartsChange(Sender: TObject);
var
  Config: TPartConfig;
  Index: Integer;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  SetColor;

  if Config.FontPart <> nil then
  begin
    cmbFontName.Text := Config.FontPart.FontName;
    Index := cmbFontName.Items.IndexOf(cmbFontName.Text);
    if Index >= 0 then
      cmbFontName.ItemIndex := Index;
    cmbFontSize.Text := IntToStr(Config.FontPart.FontSize);
    Index := cmbFontSize.Items.IndexOf(cmbFontSize.Text);
    if Index >= 0 then
      cmbFontSize.ItemIndex := Index;

    if Config.FontPart.FontStyle = [fsBold] then
      cmbFontStyle.ItemIndex := 1
    else if Config.FontPart.FontStyle = [fsItalic] then
      cmbFontStyle.ItemIndex := 2
    else if Config.FontPart.FontStyle = [fsBold, fsItalic] then
      cmbFontStyle.ItemIndex := 3
    else
      cmbFontStyle.ItemIndex := 0;

  end
  else
  begin
    cmbFontName.Text := '';
    cmbFontSize.Text := '';
    cmbFontStyle.ItemIndex := -1;
  end;




  lblColor.Enabled := Config.ColorPart <> nil;
  cmbColor.Enabled := Config.ColorPart <> nil;
  btnColor.Enabled := Config.ColorPart <> nil;
  lblFontName.Enabled := Config.FontPart <> nil;
  cmbFontName.Enabled := Config.FontPart <> nil;
  lblFontSize.Enabled := Config.FontPart <> nil;
  cmbFontSize.Enabled := Config.FontPart <> nil;
  lblFontStyle.Enabled := Config.FontPart <> nil;
  cmbFontStyle.Enabled := Config.FontPart <> nil;

end;

// 色コンボ描画
procedure TdlgOption.cmbColorDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with cmbColor do
  begin
    if Enabled then
      Canvas.Brush.Color := StrToInt(Items[Index]);
    Canvas.FillRect(Rect);
  end;
end;

// 色変更
procedure TdlgOption.cmbColorChange(Sender: TObject);
var
  Config: TPartConfig;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;
  if cmbColor.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  if Config.ColorPart <> nil then
  begin
    Config.ColorPart.Color := StrToInt(cmbColor.Items[cmbColor.ItemIndex]);
    SetOptions;
  end;
end;

// 色変更
procedure TdlgOption.SetColor;
var
  Config: TPartConfig;
  i: Integer;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);
  if Config.ColorPart <> nil then
  begin
    i := cmbColor.Items.IndexOf(IntToStr(ColorToRGB(Config.ColorPart.Color)));
    if i < 0 then
    begin
      cmbColor.Items[0] := IntToStr(ColorToRGB(Config.ColorPart.Color));
      cmbColor.ItemIndex := 0
    end
    else
      cmbColor.ItemIndex := i;
  end;
end;

// その他の色
procedure TdlgOption.btnColorClick(Sender: TObject);
var
  Config: TPartConfig;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  if Config.ColorPart <> nil then
  begin
    dlgColor.Color := Config.ColorPart.Color;
    if dlgColor.Execute then
    begin
      Config.ColorPart.Color := dlgColor.Color;
      SetColor;
      SetOptions;
    end;
  end;
end;


// フォント名変更
procedure TdlgOption.cmbFontNameChange(Sender: TObject);
var
  Config: TPartConfig;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  if Config.FontPart <> nil then
  begin
    Config.FontPart.FontName := cmbFontName.Text;
    SetOptions;
  end;

end;

// フォントサイズ変更
procedure TdlgOption.cmbFontSizeChange(Sender: TObject);
var
  Config: TPartConfig;
  New: Integer;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  if Config.FontPart <> nil then
  begin
    try
      New := StrToInt(cmbFontSize.Text);
      Config.FontPart.FontSize := New;
      SetOptions;
    except
    end;
  end;

end;

// フォントスタイル変更
procedure TdlgOption.cmbFontStyleChange(Sender: TObject);
var
  Config: TPartConfig;
begin
  if cmbParts.ItemIndex < 0 then
    Exit;

  Config := TPartConfig(cmbParts.Items.Objects[cmbParts.ItemIndex]);

  if Config.FontPart <> nil then
  begin
    case cmbFontStyle.ItemIndex of
      0: Config.FontPart.FontStyle := [];
      1: Config.FontPart.FontStyle := [fsBold];
      2: Config.FontPart.FontStyle := [fsItalic];
      3: Config.FontPart.FontStyle := [fsBold, fsItalic];
    end;
    SetOptions;
  end;
end;

end.
