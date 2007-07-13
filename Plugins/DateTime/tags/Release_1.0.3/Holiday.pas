unit Holiday;

interface

uses
  Windows, SysUtils, Classes, Julius;


type

  TOneDay = class(TObject)
    Name: String;
    BeginYear: Word;
    EndYear: Word;
    Month: Word;
    Kind: (dkDay, dkWeek);
    Day: Word;
    WeekCount: Integer;
    WeekNumber: Integer;
    function SetFileLine(S: String): Boolean;
    function DateCheck(D: TDateTime): Boolean;
  end;

  TMyHoliday = class(TObject)
  private
    procedure LoadHolidayFile;
  public
    FHolidays: TList;

    constructor Create;
    destructor Destroy; override;

    function GetHolidayStr(const yy, mm, dd: Word): String;
  end;

var
  MyHoliday: TMyHoliday;

implementation


function GengoToAD(Source: String): Word;
var
  i: Integer;
begin
  Result := 0;
  if Length(Source) = 0 then Exit;

  i := Pos(Source[1], 'MmTtSsHh');
  if i = 0 then
    Result := StrToInt(Source)
  else
  begin
    Result := StrToInt(Copy(Source, 2, MaxInt));
    case i of
      1, 2: Result := Result + 1867;
      3, 4: Result := Result + 1911;
      5, 6: Result := Result + 1925;
      7, 8: Result := Result + 1988;
    end;
  end;

end;

function TOneDay.SetFileLine(S: String): Boolean;

  function DevideFirstItem(S: String; var Item, Rest: String): Boolean;
  var
    i, l: Integer;
  begin
    Result := False;

    l := Length(S);
    i := 1;
    while (i <= l) and (S[i] > ' ') do
      Inc(i);

    if i > l then Exit;

    Item := Copy(S, 1, i - 1);
    Rest := Copy(S, i, MaxInt);
    Result := True;
  end;

var
  i: Integer;
  SD, SY, Work: String;
begin
  Result := False;

  // ƒRƒƒ“ƒg‚ğ‚È‚­‚·
  i := Pos('#', S);
  if i > 0 then
    S := Copy(s, 1, i - 1);
  S := Trim(S);

  if S = '' then
    Exit;

  // “ú•tA”NA–¼‘O‚ğ•¶š—ñ‚Åæ“¾
  if not DevideFirstItem(S, SD, S) then Exit;
  S := TrimLeft(S);
  if not DevideFirstItem(S, SY, S) then Exit;
  Name := TrimLeft(S);

  // Œ‚ğæ“¾
  i := Pos('/', SD);
  if i = 0 then Exit;
  try
    Month := StrToInt(Copy(SD, 1, i - 1));
  except
    Exit;
  end;

  // “ú‚ğæ“¾
  try
    SD := Copy(SD, i + 1, MaxInt);
    Work := Copy(SD, Length(SD) - 2, 3);
    if Work = '' then
    i := 0
    else
    begin
      CharUpper(PChar(Work));
      i := Pos(Work, 'SUN,MON,TUE,WED,THU,FRI,SAT');
    end;

    if i = 0 then
    begin
      Kind := dkDay;
      Day := StrToInt(SD);
    end
    else
    begin
      Kind := dkWeek;
      WeekCount := StrToInt(Copy(SD, 1, Length(SD) - 3));
      WeekNumber := i div 4 + 1;
    end;
  except
    Exit;
  end;

  // ”N‚ğæ“¾
  try
    i := Pos('-', SY);
    if i = 0 then
    begin
      BeginYear := GengoToAD(SY);
      EndYear := BeginYear;
    end
    else
    begin
      BeginYear := GengoToAD(Copy(SY, 1, i - 1));
      EndYear := GengoToAD(Copy(SY, i + 1, MaxInt));
    end;

  except
    Exit;
  end;

  Result := True;
end;

function TOneDay.DateCheck(D: TDateTime): Boolean;
var
  yy, mm, dd: Word;
  ww, wc: Integer;
begin
  DecodeDate(D, yy, mm, dd);
  if Kind = dkDay then
    Result := (dd = Day) and (mm = Month) and (yy >= BeginYear) and (yy <= EndYear)
  else
  begin
    wc := (dd - 1) div 7 + 1;
    ww := DayOfWeek(D);
    Result := (wc = WeekCount) and (ww = WeekNumber) and (mm = Month) and (yy >= BeginYear) and (yy <= EndYear)
  end;
end;




constructor TMyHoliday.Create;
begin
  inherited Create;
  FHolidays := TList.Create;
  LoadHolidayFile;
end;

destructor TMyHoliday.Destroy;
var
  i: Integer;
begin
  for i := 0 to FHolidays.Count - 1 do
    TOneDay(FHolidays[i]).Free;
  FHolidays.Free;
  inherited Destroy;
end;

procedure TMyHoliday.LoadHolidayFile;
var
  FileName: String;
  i: Integer;
  lstWork: TStringList;
  OneDay: TOneDay;
  DLLFile: array[0..255] of Char;
begin
//  FileName := ExtractFilePath(ParamStr(0)) + 'Holiday.tbl';

  GetModuleFileName(HInstance, DLLFile, SizeOf(DLLFile));
  FileName := ExtractFilePath(DLLFile) + 'Holiday.tbl';

  if not FileExists(FileName) then
    Exit;

  lstWork := TStringList.Create;
  try

    lstWork.LoadFromFile(FileName);

    for i := 0 to lstWork.Count - 1 do
    begin

      OneDay := TOneDay.Create;
      if OneDay.SetFileLine(lstWork[i]) then
        FHolidays.Add(OneDay)
      else
        OneDay.Free;
    end;

  finally
    lstWork.Free;
  end;
end;

function TMyHoliday.GetHolidayStr(const yy, mm, dd: Word): String;
var
  i: Integer;
  S: String;
  D: TDateTime;
  W: Integer;
  jy, jm, jd: Integer;
  TransferHoliday: Boolean;
begin
  if yy < 1873 then
    Exit;

  D := EncodeDate(yy, mm, dd);
  W := DayOfWeek(D);

  TransferHoliday := False;
  S := '';
  for i := 0 to FHolidays.Count - 1 do
  begin
    if W = 2 then // Œ—j“ú
      if TOneDay(FHolidays[i]).DateCheck(D - 1) then
      begin
        TransferHoliday := True;
      end;

    if TOneDay(FHolidays[i]).DateCheck(D) then
    begin
      if S <> '' then
        S := S + #13#10;
      S := S + TOneDay(FHolidays[i]).Name;
    end;
  end;

  // t•ª‚Ì“ú‚ÌŠm”F
  if mm = 3 then
  begin
    JDToYMD(GetSpringEquinox(yy), jy, jm, jd);
    if jd = dd then
    begin
      if (S <> '') and (yy >= 1879) then
        S := S + #13#10;
      if yy >= 1949 then
        S := S + 't•ª‚Ì“ú'
      else if yy >= 1879 then
        S := S + 't‹Gc—ìÕ'
    end;

    // U‘Ö‹x“ú‚È‚ç
    if (W = 2) and (jd = (dd - 1)) then
    begin
      TransferHoliday := True;
    end;
  end;

  // H•ª‚Ì“ú‚ÌŠm”F
  if mm = 9 then
  begin
    JDToYMD(GetAutumnEquinox(yy), jy, jm, jd);
    if jd = dd then
    begin
      if (S <> '') and (yy >= 1878) then
        S := S + #13#10;
      if yy >= 1948 then
        S := S + 'H•ª‚Ì“ú'
      else if yy >= 1878 then
        S := S + 'H‹Gc—ìÕ'
    end;

    // U‘Ö‹x“ú‚È‚ç
    if (W = 2) and (jd = (dd - 1)) then
    begin
      TransferHoliday := True;
    end;
  end;

  if (S = '') and TransferHoliday and (D >= EncodeDate(1973, 4, 12)) then
    S := 'U‘Ö‹x“ú';

  Result := S;
end;

end.
