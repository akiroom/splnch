unit Memo;

interface

uses
  Windows, Classes, SysUtils, Graphics, IniFiles, Julius;

type
  TDayMemo = class(TStringList)
  private
    FBeginDate: TDateTime;
    FEndDate: TDateTime;
    FKind: String;
    function GetTopLine: String;
  public
    property TopLine: String read GetTopLine;
    property BeginDate: TDateTime read FBeginDate write FBeginDate;
    property EndDate: TDateTime read FEndDate write FEndDate;
    property Kind: String read FKind write FKind;
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
  end;

  TMemoStream = class(TFileStream)
  private
    FMemoList: TList;
    procedure Load;
    procedure Save;
  public
    property MemoList: TList read FMemoList;

    constructor Create(FileName: String);
    destructor Destroy; override;
    procedure Sort;
    procedure Clear;
  end;

  TMemoRect = class(TObject)
    Memo: TDayMemo;
    Rect: TRect;
    Prev: TMemoRect;
    Next: TMemoRect;
    BeginDate: TDateTime;
    EndDate: TDateTime;
    StickOut: Boolean;
  end;

  TKindData = class(TObject)
    Color: TColor;
    procedure Assign(Source: TKindData);
  end;

  TMemoFilter = class(TObject)
  private
    FCheckMemo: Boolean;
    FCheckDate: Boolean;
    FCheckKind: Boolean;
    FMemo: String;
    FCheckMemoCase: Boolean;
    FBeginDate: TDateTime;
    FEndDate: TDateTime;
    FKindList: TStringList;
    procedure SetKindList(const Value: TStringList);
  public
    property CheckMemo: Boolean read FCheckMemo write FCheckMemo;
    property CheckDate: Boolean read FCheckDate write FCheckDate;
    property CheckKind: Boolean read FCheckKind write FCheckKind;
    property Memo: String read FMemo write FMemo;
    property CheckMemoCase: Boolean read FCheckMemoCase write FCheckMemoCase;
    property BeginDate: TDateTime read FBeginDate write FBeginDate;
    property EndDate: TDateTime read FEndDate write FEndDate;
    property KindList: TStringList read FKindList write SetKindList;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(MemoFilter: TMemoFilter);
    procedure Clear;
    function Match(DayMemo: TDayMemo): Boolean;
    function Filtering: Boolean;
  end;



var
  MemoStream: TMemoStream;
  MemoStreamCount: Integer;
  KindList: TStringList;
  KindListCount: Integer;
  MemoFilter: TMemoFilter;
  MemoFilterCount: Integer;
  InitFileName: string; // 設定ファイル名
  DataFileName: string; // 設定ファイル名

procedure GetButtonBorderColor(Face: TColor; var Highlight, Shadow, Dark: TColor);
function GetFontColorFromFaceColor(FaceColor: TColor): TColor;

procedure MemoStreamBegin;
procedure MemoStreamEnd;
procedure KindListBegin;
procedure KindListEnd;
procedure MemoFilterBegin;
procedure MemoFilterEnd;

function DayMemoCompare(Item1, Item2: Pointer): Integer;

const
  DFKindCount = 11;
  DFKind: array[0..DFKindCount - 1] of String = (
    '仕事',
    '出張',
    '休暇',
    'プライベート',
    '旅行',
    'デート',
    '食事',
    '飲み会',
    '発売日',
    '病院',
    '試合');

  DFKindColor: array[0..DFKindCount - 1] of TColor = (
    clGray,
    clOlive,
    clBlue,
    clYellow,
    clAqua,
    $008000FF,
    $00004080,
    clPurple,
    clFuchsia,
    clWhite,
    clGreen);
  NMKindColor: TColor = $DDDDDD;



implementation


procedure GetButtonBorderColor(Face: TColor; var Highlight, Shadow, Dark: TColor);
var
  C: LongInt;
  R, G, B: Word;
begin
  C := ColorToRGB(Face);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  if Face = clBtnFace then
  begin
    Highlight := clBtnHighlight;
    Shadow := clBtnShadow;
    Dark := clBlack;
  end
  else
  begin
    Highlight := RGB((R + $FF) div 2, (G + $FF) div 2, (B + $FF) div 2);
    Shadow := RGB(R div 2, G div 2, B div 2);
    Dark := RGB(R div 4, G div 4, B div 4);
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

procedure MemoStreamBegin;
begin
  if MemoStreamCount = 0 then
  begin
    try
      MemoStream := TMemoStream.Create(DataFileName);
    except
      MemoStream := nil;
      MemoStreamCount := 0;
      Exit;
    end;
  end;
  Inc(MemoStreamCount);
end;

procedure MemoStreamEnd;
begin
  if MemoStreamCount > 0 then
  begin
    Dec(MemoStreamCount);
    if MemoStreamCount = 0 then
    begin
      MemoStream.Free;
      MemoStream := nil;
    end;
  end;
end;

procedure KindListBegin;
var
  Ini: TMemIniFile;
  Kind: String;
  KindData: TKindData;
  i: Integer;
begin
  if KindListCount = 0 then
  begin
    try
      KindList := TStringList.Create;

      Ini := TMemIniFile.Create(InitFileName);
      try
        i := 0;
        while Ini.ValueExists('Kinds', 'Kind' + IntToStr(i)) do
        begin
          Kind := Ini.ReadString('Kinds', 'Kind' + IntToStr(i), '');
          if Kind <> '' then
          begin
            KindData := TKindData.Create;
            KindData.Color := StringToColor(Ini.ReadString('Kinds', 'Color' + IntToStr(i), ColorToString(NMKindColor)));
            KindList.AddObject(Kind, KindData);
          end;
          Inc(i);
        end;

        if KindList.Count = 0 then
        begin
          for i := 0 to DFKindCount - 1 do
          begin
            KindData := TKindData.Create;
            KindData.Color := DFKindColor[i];
            KindList.AddObject(DFKind[i], KindData);
          end;
        end;

      finally
        Ini.Free;
      end;

    except
      KindList := nil;
      KindListCount := 0;
      Exit;
    end;
  end;
  Inc(KindListCount);
end;

procedure KindListEnd;
var
  Ini: TMemIniFile;
  i: Integer;
  KindData: TKindData;
begin
  if KindListCount > 0 then
  begin
    Dec(KindListCount);
    if KindListCount = 0 then
    begin
      Ini := TMemIniFile.Create(InitFileName);
      try
        Ini.EraseSection('Kinds');

        for i := 0 to KindList.Count - 1 do
        begin
          KindData := TKindData(KindList.Objects[i]);
          Ini.WriteString('Kinds', 'Kind' + IntToStr(i), KindList[i]);
          Ini.WriteString('Kinds', 'Color' + IntToStr(i), ColorToString(KindData.Color));
          KindData.Free;
        end;

        Ini.UpdateFile;
      finally
        Ini.Free;
      end;

      KindList.Free;
      KindList := nil;
    end;
  end;
end;

procedure MemoFilterBegin;
var
  Ini: TMemIniFile;
begin
  if MemoFilterCount = 0 then
  begin
    try
      MemoFilter := TMemoFilter.Create;
      MemoFilter.Clear;

      Ini := TMemIniFile.Create(InitFileName);
      try
        MemoFilter.CheckMemo := Ini.ReadBool('Filter', 'CheckMemo', MemoFilter.CheckMemo);
        MemoFilter.CheckDate := Ini.ReadBool('Filter', 'CheckDate', MemoFilter.CheckDate);
        MemoFilter.CheckKind := Ini.ReadBool('Filter', 'CheckKind', MemoFilter.CheckKind);
        MemoFilter.Memo := Ini.ReadString('Filter', 'Memo', MemoFilter.Memo);
        MemoFilter.CheckMemoCase := Ini.ReadBool('Filter', 'CheckMemoCase', MemoFilter.CheckMemoCase);
        MemoFilter.BeginDate := Ini.ReadFloat('Filter', 'BeginDate', MemoFilter.BeginDate);
        MemoFilter.EndDate := Ini.ReadFloat('Filter', 'EndDate', MemoFilter.EndDate);
        MemoFilter.KindList.CommaText := Ini.ReadString('Filter', 'KindList', MemoFilter.KindList.CommaText);
      finally
        Ini.Free;
      end;

    except
      MemoFilter := nil;
      MemoFilterCount := 0;
      Exit;
    end;
  end;
  Inc(MemoFilterCount);
end;

procedure MemoFilterEnd;
var
  Ini: TMemIniFile;
begin
  if MemoFilterCount > 0 then
  begin
    Dec(MemoFilterCount);
    if MemoFilterCount = 0 then
    begin
      Ini := TMemIniFile.Create(InitFileName);
      try
        Ini.WriteBool('Filter', 'CheckMemo', MemoFilter.CheckMemo);
        Ini.WriteBool('Filter', 'CheckDate', MemoFilter.CheckDate);
        Ini.WriteBool('Filter', 'CheckKind', MemoFilter.CheckKind);
        Ini.WriteString('Filter', 'Memo', MemoFilter.Memo);
        Ini.WriteBool('Filter', 'CheckMemoCase', MemoFilter.CheckMemoCase);
        Ini.WriteFloat('Filter', 'BeginDate', MemoFilter.BeginDate);
        Ini.WriteFloat('Filter', 'EndDate', MemoFilter.EndDate);
        Ini.WriteString('Filter', 'KindList', MemoFilter.KindList.CommaText);

        Ini.UpdateFile;
      finally
        Ini.Free;
      end;

      MemoFilter.Free;
      MemoFilter := nil;
    end;
  end;
end;


function DayMemoCompare(Item1, Item2: Pointer): Integer;
var
  DayMemo1, DayMemo2: TDayMemo;
begin
  DayMemo1 := Item1;
  DayMemo2 := Item2;
  Result := Trunc(DayMemo1.BeginDate) - Trunc(DayMemo2.BeginDate);
  if Result = 0 then
    Result := Trunc(DayMemo1.EndDate) - Trunc(DayMemo2.EndDate);
  if Result = 0 then
    Result := CompareText(DayMemo1.TopLine, DayMemo2.TopLine);
end;

{ TDayMemo }

constructor TDayMemo.Create;
begin
  inherited;
  Clear;
end;

procedure TDayMemo.Assign(Source: TPersistent);
begin
  if Source = nil then
  begin
    Clear;
  end
  else
  begin
    inherited;
    if TDayMemo(Source).BeginDate <= TDayMemo(Source).EndDate then
    begin
      BeginDate := TDayMemo(Source).BeginDate;
      EndDate := TDayMemo(Source).EndDate;
    end
    else
    begin
      BeginDate := TDayMemo(Source).EndDate;
      EndDate := TDayMemo(Source).BeginDate;
    end;
    Kind := TDayMemo(Source).Kind;
  end;
end;

procedure TDayMemo.Clear;
begin
  inherited;
  BeginDate := Date;
  EndDate := Date;
  Kind := '';
end;

function TDayMemo.GetTopLine: String;
var
  i: Integer;
begin
  Result := '';
  i := 0;
  while i < Count do
  begin
    Result := Trim(Strings[i]);
    if Result <> '' then
      Break;
    Inc(i);
  end;
end;

{ TMemoStream }

constructor TMemoStream.Create(FileName: String);
begin
  FMemoList := TList.Create;

  // ファイル開く
  try
    inherited Create(FileName, fmOpenReadWrite or fmShareExclusive);
    Load;
  except
    inherited Create(FileName, fmCreate or fmShareExclusive);
  end;

end;

destructor TMemoStream.Destroy;
begin
  Save;
  Clear;
  FMemoList.Free;
  inherited;
end;

procedure TMemoStream.Sort;
begin
  FMemoList.Sort(DayMemoCompare);
end;

procedure TMemoStream.Clear;
var
  i: Integer;
begin
  for i := 0 to FMemoList.Count - 1 do
    TDayMemo(FMemoList[i]).Free;
  FMemoList.Clear;
end;

procedure TMemoStream.Load;
var
  Lines: TStringList;
  DayMemo: TDayMemo;
  i: Integer;
  Line: String;
  Kind: Char;
  Year, Month, Day: Word;
  DateWork: TDateTime;
begin
  Lines := TStringList.Create;
  try
    Lines.LoadFromStream(Self);

    DayMemo := nil;
    for i := 0 to Lines.Count - 1 do
    begin
      Line := Lines[i];
      if Length(Line) > 0 then
      begin
        Kind := Line[1];
        Line := Copy(Line, 2, MaxInt);

        // 日付
        if Kind = '+' then
        begin
          DayMemo := TDayMemo.Create;
          try
            Year := StrToInt(Copy(Line, 1, 4));
            Month := StrToInt(Copy(Line, 5, 2));
            Day := StrToInt(Copy(Line, 7, 2));
            DayMemo.BeginDate := EncodeDate(Year, Month, Day);
            Year := StrToInt(Copy(Line, 9, 4));
            Month := StrToInt(Copy(Line, 13, 2));
            Day := StrToInt(Copy(Line, 15, 2));
            DayMemo.EndDate := EncodeDate(Year, Month, Day);

            if DayMemo.BeginDate > DayMemo.EndDate then
            begin
              DateWork := DayMemo.BeginDate;
              DayMemo.BeginDate := DayMemo.EndDate;
              DayMemo.EndDate := DateWork;
            end;


            FMemoList.Add(DayMemo);
          except
            DayMemo.Free;
            DayMemo := nil;
          end;
        end

        // 色
        else if Kind = '%' then
        begin
          if DayMemo <> nil then
          begin
            DayMemo.Kind := Line;
          end;
        end

        // メモ
        else if Kind = '-' then
        begin
          if DayMemo <> nil then
          begin
            DayMemo.Add(Line);
          end;
        end;
      end;
    end;

    Sort;
  finally
    Lines.Free;
  end;
end;

procedure TMemoStream.Save;
var
  Lines: TStringList;
  DayMemo: TDayMemo;
  i, j: Integer;
begin
  Lines := TStringList.Create;
  try
    Sort;
    for i := 0 to FMemoList.Count - 1 do
    begin
      DayMemo := FMemoList[i];
      Lines.Add('+' + FormatDateTime('yyyymmdd', DayMemo.BeginDate) + FormatDateTime('yyyymmdd', DayMemo.EndDate));
      if DayMemo.Kind <> '' then
        Lines.Add('%' + DayMemo.Kind);
      for j := 0 to DayMemo.Count - 1 do
        Lines.Add('-' + DayMemo[j]);
      Lines.Add('');
    end;

    Size := 0;
    Lines.SaveToStream(Self);
  finally
    Lines.Free;
  end;
end;

{ TKindData }

procedure TKindData.Assign(Source: TKindData);
begin
  Color := Source.Color;
end;

{ TMemoFilter }

procedure TMemoFilter.SetKindList(const Value: TStringList);
begin
  FKindList.Assign(Value);
end;

constructor TMemoFilter.Create;
begin
  inherited;
  FKindList := TStringList.Create;
end;

destructor TMemoFilter.Destroy;
begin
  FKindList.Free;
  inherited;
end;

procedure TMemoFilter.Assign(MemoFilter: TMemoFilter);
begin
  CheckMemo := MemoFilter.CheckMemo;
  CheckDate := MemoFilter.CheckDate;
  CheckKind := MemoFilter.CheckKind;
  Memo := MemoFilter.Memo;
  CheckMemoCase := MemoFilter.CheckMemoCase;
  BeginDate := MemoFilter.BeginDate;
  EndDate := MemoFilter.EndDate;
  KindList := MemoFilter.KindList;
end;

procedure TMemoFilter.Clear;
var
  Year, Month, Day, MaxDay: Word;
begin
  CheckMemo := False;
  CheckDate := False;
  CheckKind := False;
  Memo := '';
  CheckMemoCase := False;

  DecodeDate(Date, Year, Month, Day);
  MaxDay := GetNumberOfDays(Year, Month);
  BeginDate := EncodeDate(Year, Month, 1);
  EndDate := EncodeDate(Year, Month, MaxDay);

  KindList.Clear;
end;

function TMemoFilter.Filtering: Boolean;
begin
  Result := CheckMemo or CheckDate or CheckKind;
end;

function TMemoFilter.Match(DayMemo: TDayMemo): Boolean;
var
  s1, s2: String;
begin
  Result := True;

  // 内容
  if CheckMemo then
  begin
    if CheckMemoCase then
    begin
      s1 := DayMemo.Text;
      s2 := Memo;
    end
    else
    begin
      s1 := AnsiUpperCase(DayMemo.Text);
      s2 := AnsiUpperCase(Memo);
    end;

    Result := AnsiPos(s2, s1) > 0;
  end;

  // 日付
  if Result and CheckDate then
  begin
    Result := (DayMemo.EndDate >= BeginDate)
      and (DayMemo.BeginDate <= EndDate);
  end;

  // 種類
  if Result and CheckKind then
  begin
    Result := KindList.IndexOf(DayMemo.Kind) >= 0;
  end;
end;

end.
