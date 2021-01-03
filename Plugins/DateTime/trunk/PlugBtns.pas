unit PlugBtns;

interface

uses
  Windows, Classes, SysUtils, Graphics, Memo, Holiday;

// ì˙ïtçXêV
function UpdateDayInfo(Force: Boolean): Boolean;
// éûåvçXêV
function UpdateTimeInfo: Boolean;
// ì˙ïtï`âÊ
procedure DrawDate(ACanvas: TCanvas; ARect: TRect);
// éûåvï`âÊèàóù
procedure DrawWatch(ACanvas: TCanvas; ARect: TRect);

const
  sWeek: array[1..7] of String = ('SUN','MON','TUE','WED','THU','FRI','SAT');
var
  LastDate: TDateTime;
  LastTime: TDateTime;
  ChipStr: String;
  IsHoliday: Boolean;
  ExistsMemo: Boolean;
  QueryUpdate: Boolean;

  ADigital: Boolean;

implementation

// ì˙ïtçXêV
function UpdateDayInfo(Force: Boolean): Boolean;
var
  Year, Month, Day: Word;
  MyHoliday: TMyHoliday;
  Memo: TDayMemo;
  i, j: Integer;
begin
  if (not Force) and (LastDate = Date) then
  begin
    Result := QueryUpdate;
    Exit;
  end;

  QueryUpdate := True;
  Result := True;
  LastDate := Date;

  ExistsMemo := False;
  MemoStreamBegin;
  MyHoliday := TMyHoliday.Create;


  MemoFilterBegin;
  try
    DecodeDate(LastDate, Year, Month, Day);

    ChipStr := MyHoliday.GetHolidayStr(Year, Month, Day);
    IsHoliday := ChipStr <> '';
    if IsHoliday then
      ChipStr := FormatDateTime('dddddd', LastDate) + ' ' + ChipStr
    else
      ChipStr := FormatDateTime('dddddd', LastDate);

    MemoStream.Sort;
    for i := 0 to MemoStream.MemoList.Count - 1 do
    begin
      Memo := MemoStream.MemoList[i];

      if MemoFilter.Match(Memo) and (LastDate >= Memo.BeginDate) and (LastDate <= Memo.EndDate) then
      begin
        ExistsMemo := True;
        for j := 0 to Memo.Count - 1 do
        begin
          if ChipStr <> '' then
            ChipStr := ChipStr + #13#10;
          if j = 0 then
            ChipStr := ChipStr + 'Å°' + Memo[j]
          else
            ChipStr := ChipStr + 'Å|' + Memo[j];
        end;
      end;
    end;

  finally
    MyHoliday.Free;
    MemoStreamEnd;
    MemoFilterEnd;
  end;

end;

// éûåvçXêV
function UpdateTimeInfo: Boolean;
var
  LH, LM, LS, LN: Word;
  NH, NM, NS, NN: Word;
  NewTime: TDateTime;
begin
  NewTime := Now;
  DecodeTime(LastTime, LH, LM, LS, LN);
  DecodeTime(Now, NH, NM, NS, NN);
  Result := (LH <> NH) or (LM <> NM);
  LastTime := NewTime;
end;

// ì˙ïtï`âÊ
procedure DrawDate(ACanvas: TCanvas; ARect: TRect);
var
  work: string;
  CRect: TRect;
  yy, mm, dd: Word;
  ww: Integer;
  Width, Height: Integer;
begin
  QueryUpdate := False;

  DecodeDate(Now, yy, mm, dd);
  ww := DayOfWeek(Now);

  Width := ARect.Right - ARect.Left;
  Height := ARect.Bottom - ARect.Top;
  if Width > Height then
  begin
    ARect.Left := ARect.Left + (Width - Height) div 2;
    ARect.Right := ARect.Left + Height;
  end
  else if Height > Width then
  begin
    ARect.Top := ARect.Top + (Height - Width) div 2;
    ARect.Bottom := ARect.Top + Width;
  end;

  with ACanvas do
  begin
    Pen.Color := clGray;
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    Rectangle(ARect);


    Brush.Style := bsClear;
    Font.Name := 'ÇlÇr ÇoÉSÉVÉbÉN';

    if IsHoliday or (ww = 1) then
      Font.Color := clRed
    else if ww = 7 then
      Font.Color := clBlue
    else
      Font.Color := clMaroon;

    if ExistsMemo then
      Font.Style := [fsBold]
    else
      Font.Style := [];


    Work := sWeek[ww];
    CRect := Rect(ARect.Left,
              ARect.Top,
              ARect.Right,
              ARect.Top + (ARect.Bottom - ARect.Top) * 4 div 10);
    Font.Height := - (CRect.Bottom - CRect.Top) + 2;
    DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_BOTTOM);

    Work := Format('%d', [dd]);
    CRect := Rect(ARect.Left,
              ARect.Top + (ARect.Bottom - ARect.Top) * 4 div 10,
              ARect.Right,
              ARect.Bottom);
    Font.Height := - (CRect.Bottom - CRect.Top) + 2;
    DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_TOP);

  end;
end;

// éûåvï`âÊèàóù
procedure DrawWatch(ACanvas: TCanvas; ARect: TRect);
var
  i: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  hh,mm: Real;
  hx,hy,mx,my: Real;
  x,y: Integer;
  work: string;
  Width, Height: Integer;
  CRect: TRect;
begin
  DecodeDate(Now, Year, Month, Day);
  DecodeTime(Now, Hour, Min, Sec, MSec);

  if not ADigital then
  begin
    Width := ARect.Right - ARect.Left;
    Height := ARect.Bottom - ARect.Top;
    CRect := ARect;
    if Width > Height then
    begin
      CRect.Left := CRect.Left + (Width - Height) div 2;
      Width := Height;
      CRect.Right := CRect.Left + Height;
    end
    else if Height > Width then
    begin
      CRect.Top := CRect.Top + (Height - Width) div 2;
      Height := Width;
      CRect.Bottom := CRect.Top + Width;
    end;

    ACanvas.Pen.Color := clGray;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Ellipse(CRect.Left, CRect.Top, CRect.Right, CRect.Bottom);

    ACanvas.Pen.Width := Width div 20;

    {ñ⁄ê∑ÇÃï\é¶}
    ACanvas.Pen.Color := clPurple;
    for i := 0 to 11 do
    begin
      hh := i;
      hh := hh * 30;   {ñ⁄ê∑ÇÃäpìx}
      hx :=   sin(hh * PI / 180) * Width / 2.7 + Width / 2;
      hy := - cos(hh * PI / 180) * Height / 2.7 + Height / 2;
      x := Round(hx);
      y := Round(hy);
      ACanvas.MoveTo(CRect.Left + x, CRect.Top + y);
      ACanvas.LineTo(CRect.Left + x+1, CRect.Top + y);
    end;

    hh := Hour;
    mm := Min;

    if hh > 12 then hh := hh - 12;
    hh := hh + mm / 60;
    hh := hh * 30;   {íZêjÇÃäpìx}
    mm := mm * 6;    {í∑êjÇÃäpìx}

    {íZêjÇÃåvéZÇ∆ï\é¶}
    hx :=   sin(hh * PI / 180) * Width / 3.0 + Width / 2;
    hy := - cos(hh * PI / 180) * Height / 3.0 + Height / 2;
    x := Round(hx);
    y := Round(hy);
    ACanvas.pen.color := clSilver;
    ACanvas.MoveTo(CRect.Left + (Width div 2 + 1), CRect.Top + (Height div 2 + 1));
    ACanvas.LineTo(CRect.Left + (x+1), CRect.Top + (y+1));
    ACanvas.pen.color := clMaroon;
    ACanvas.MoveTo(CRect.Left + (Width div 2), CRect.Top + (Height div 2));
    ACanvas.LineTo(CRect.Left + x, CRect.Top + y);

    {í∑êjÇÃåvéZÇ∆ï\é¶}
    mx :=   sin(mm * PI / 180) * Width / 2.3 + Width / 2;
    my := - cos(mm * PI / 180) * Height / 2.3 + Height / 2;
    x := Round(mx);
    y := Round(my);
    ACanvas.pen.color := clSilver;
    ACanvas.MoveTo(CRect.Left + (Width div 2 + 1), CRect.Top + (Height div 2 + 1));
    ACanvas.LineTo(CRect.Left + (x+1), CRect.Top + (y+1));
    ACanvas.pen.color := clMaroon;
    ACanvas.MoveTo(CRect.Left + (Width div 2), CRect.Top + (Height div 2));
    ACanvas.LineTo(CRect.Left + x, CRect.Top + y);

    ACanvas.pen.color := clPurple;
    ACanvas.Ellipse(CRect.Left + (Width div 2 -1), CRect.Top + (Height div 2 - 1)
                   ,CRect.Left + (Width div 2 +1), CRect.Top + (Height div 2 +1));

  end
  else
  begin
    with ACanvas do
    begin
      Brush.Style := bsClear;

      Work := Format('%d/%d', [Month, Day]);
      CRect := Rect(ARect.Left + 1,
                ARect.Top + 1,
                ARect.Right + 1,
                ARect.Top + (ARect.Bottom - ARect.Top) div 2  + 1);
      Font.Name := 'ÇlÇr ÇoÉSÉVÉbÉN';
      Font.Height := - (CRect.Bottom - CRect.Top) * 5 div 6;
      Font.Color := clBtnHighLight;
      DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_BOTTOM);
      CRect := Rect(CRect.Left-1, CRect.Top-1, CRect.Right-1, CRect.Bottom-1);
      Font.Color := clNavy;
      DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_BOTTOM);

      Work := Format('%d:%0.2d', [Hour, Min]);
      CRect := Rect(ARect.Left + 1,
                ARect.Bottom - (ARect.Bottom - ARect.Top) div 2 + 1,
                ARect.Right + 1,
                ARect.Bottom + 1);
      Font.Height := - (CRect.Bottom - CRect.Top) * 5 div 6;
      Font.Color := clBtnHighLight;
      DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_TOP);
      CRect := Rect(CRect.Left-1, CRect.Top-1, CRect.Right-1, CRect.Bottom-1);
      Font.Color := clNavy;
      DrawText(Handle, PChar(Work), Length(Work), CRect, DT_SINGLELINE or DT_CENTER or DT_TOP);

    end;
  end;
end;


end.
