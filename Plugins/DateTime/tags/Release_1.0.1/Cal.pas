unit Cal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, Buttons, ExtCtrls, StdCtrls, Julius, Holiday, Menus, BtnTitle,
  Memo, PlugBtns, Types;

type
  TDragType = (dtNone, dtNormal, dtMemoBegin, dtMemoEnd, dtMemo);
  TChangeFocusDateType = (cfPrevYear, cfNextYear, cfPrevMonth, cfNextMonth,
    cfPrevWeek, cfNextWeek, cfPrevDay, cfNextDay, cfToday);

  TfrmCal = class(TForm)
    pnlMain: TPanel;
    pbCalendar: TPaintBox;
    pbMonth: TPaintBox;
    btnToday: TSpeedButton;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    btnClose: TSpeedButton;
    PopupMenu1: TPopupMenu;
    mnuClose: TMenuItem;
    mnuMemoNew: TMenuItem;
    N3: TMenuItem;
    mnuMemoModify: TMenuItem;
    mnuMemoDelete: TMenuItem;
    N1: TMenuItem;
    mnuMemoList: TMenuItem;
    mnuMemoNoFilter: TMenuItem;
    mnuMemoFilter: TMenuItem;
    N2: TMenuItem;
    mnuOption: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure pbCalendarPaint(Sender: TObject);
    procedure pbMonthPaint(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pbCalendarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pbCalendarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbCalendarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuMemoNewClick(Sender: TObject);
    procedure mnuMemoModifyClick(Sender: TObject);
    procedure mnuMemoDeleteClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure pbCalendarDblClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure mnuMemoListClick(Sender: TObject);
    procedure mnuMemoFilterClick(Sender: TObject);
    procedure mnuMemoNoFilterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuOptionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFocusDate: TDateTime;
    FMouseDate: TDateTime;
    FFocusMemo: TDayMemo;

    FSelBeginDate: TDateTime;
    FSelEndDate: TDateTime;
    FMyHoliday: TMyHoliday;
    FDragType: TDragType;

    FLastPos: TPoint;

    FMonthMemoList: TList;
    FDayRect: array[1..31] of TRect;
    FMemoRectList: TList;

    FDayLabelHeight: Integer;

    FDragMemoOffset: TDateTime;

    FBackGroundColor: TColor;
    FLineColor: TColor;
    FStringColor: TColor;
    FStringFontName: String;
    FStringFontSize: Integer;
    FStringFontStyle: TFontStyles;
    FTodayColor: TColor;
    FSundayColor: TColor;
    FSaturdayColor: TColor;
    FHolidayColor: TColor;
    FMemoFontName: String;
    FMemoFontSize: Integer;
    FMemoFontStyle: TFontStyles;


    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;

    procedure ClearDayRect;
    procedure ClearMemoRectList;

    procedure SetFocusDate(const Value: TDateTime);
    function GetMouseDate: TDateTime;
    procedure SetMouseDate(const Value: TDateTime);
    function GetMouseEntered: Boolean;
    procedure SetFocusMemo(const Value: TDayMemo);

    function GetDayWidth(Col: Integer): Integer;
    function GetDayHeight(Row: Integer): Integer;
    function GetWeekHeight: Integer;

    procedure MemoUpdate;
    procedure MonthMemoListUpdate;
    procedure ShowCaption(ADate: TDateTime);

    procedure MemoListApply(Sender: TObject);
    procedure EditMemoNewApply(Sender: TObject);
    procedure EditMemoModifyApply(Sender: TObject);
    procedure FilterApply(Sender: TObject);
  public
    property FocusDate: TDateTime read FFocusDate write SetFocusDate;
    property MouseDate: TDateTime read GetMouseDate write SetMouseDate;
    property MouseEntered: Boolean read GetMouseEntered;
    property FocusMemo: TDayMemo read FFocusMemo write SetFocusMemo;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawMonth;
    procedure DrawCalendar;
    procedure DrawMemo;
    procedure WMContextMenu(var Msg: TWMContextMenu); message WM_CONTEXTMENU;

    procedure ChangeFocusDate(ChangeType: TChangeFocusDateType);
    procedure FocusUp;
    procedure FocusDown;

    procedure SetOptions;
  end;



var
  frmCal: TfrmCal;


implementation

uses EditMemo, MemoList, Filter, Kind, EditKind, Option;

{$R *.DFM}


// CreateParams
procedure TfrmCal.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

// フォームの最大最小のサイズ
procedure TfrmCal.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  Msg.MinMaxInfo.ptMinTrackSize := Point(300, 200);
end;

// フォーム始め
procedure TfrmCal.FormCreate(Sender: TObject);
var
  Ini: TMemIniFile;
  WindowPlacement: TWindowPlacement;
begin
  Icon.Handle := LoadIcon(hInstance, 'MAINICON');
  SetClassLong(Handle, GCL_HICON, Icon.Handle);

  Left := 0;
  Top := 0;
  Width := 500;
  Height := 400;

  Ini := TMemIniFile.Create(InitFileName);
  try
    WindowPlacement.Length := SizeOf(WindowPlacement);
    GetWindowPlacement(Handle, @WindowPlacement);

    WindowPlacement.flags := Ini.ReadInteger('CalPlace', 'flags', WindowPlacement.flags);
    WindowPlacement.showCmd := Ini.ReadInteger('CalPlace', 'showCmd', WindowPlacement.showCmd);
    WindowPlacement.rcNormalPosition.Left := Ini.ReadInteger('CalPlace', 'rcNormalPositionLeft', WindowPlacement.rcNormalPosition.Left);
    WindowPlacement.rcNormalPosition.Top := Ini.ReadInteger('CalPlace', 'rcNormalPositionTop', WindowPlacement.rcNormalPosition.Top);
    WindowPlacement.rcNormalPosition.Right := Ini.ReadInteger('CalPlace', 'rcNormalPositionRight', WindowPlacement.rcNormalPosition.Right);
    WindowPlacement.rcNormalPosition.Bottom := Ini.ReadInteger('CalPlace', 'rcNormalPositionBottom', WindowPlacement.rcNormalPosition.Bottom);

    SetWindowPlacement(Handle, @WindowPlacement);
  finally
    Ini.Free;
  end;


  FMyHoliday := TMyHoliday.Create;
  FMonthMemoList := TList.Create;
  FMemoRectList := TList.Create;

  MemoStreamBegin;
  KindListBegin;

  pnlMain.DoubleBuffered := True;
  FSelBeginDate := Date;
  FSelEndDate := Date;
  FocusDate := Date;
end;

// フォーム見える
procedure TfrmCal.FormShow(Sender: TObject);
begin
  SetOptions;
end;

// フォーム閉じる
procedure TfrmCal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TMemIniFile;
  WindowPlacement: TWindowPlacement;
begin
  Action := caFree;

  Ini := TMemIniFile.Create(InitFileName);
  try
    WindowPlacement.Length := SizeOf(WindowPlacement);
    GetWindowPlacement(Handle, @WindowPlacement);

    Ini.WriteInteger('CalPlace', 'flags', WindowPlacement.flags);
    Ini.WriteInteger('CalPlace', 'showCmd', WindowPlacement.showCmd);
    Ini.WriteInteger('CalPlace', 'rcNormalPositionLeft', WindowPlacement.rcNormalPosition.Left);
    Ini.WriteInteger('CalPlace', 'rcNormalPositionTop', WindowPlacement.rcNormalPosition.Top);
    Ini.WriteInteger('CalPlace', 'rcNormalPositionRight', WindowPlacement.rcNormalPosition.Right);
    Ini.WriteInteger('CalPlace', 'rcNormalPositionBottom', WindowPlacement.rcNormalPosition.Bottom);

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;

  HideTitle;

  FMyHoliday.Free;

  FMonthMemoList.Free;
  ClearMemoRectList;
  FMemoRectList.Free;

  MemoStreamEnd;
  KindListEnd;

  frmCal := nil;
end;

// フォーム閉じる前
procedure TfrmCal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if dlgKind <> nil then
    CanClose := False;
  if dlgEditKind <> nil then
    CanClose := False;
  if dlgEditMemo <> nil then
    CanClose := False;
  if dlgFilter <> nil then
    CanClose := False;
  if dlgMemoList <> nil then
    CanClose := False;
end;


// DayRectをクリア
procedure TfrmCal.ClearDayRect;
var
  i: Integer;
begin
  for i := 1 to 31 do
    FDayRect[i] := Rect(0, 0, 0, 0);
end;

// MemoRectListのクリア
procedure TfrmCal.ClearMemoRectList;
var
  i: Integer;
begin
  for i := 0 to FMemoRectList.Count - 1 do
    TMemoRect(FMemoRectList[i]).Free;
  FMemoRectList.Clear;
end;

// メニューのポップアップ
procedure TfrmCal.PopupMenu1Popup(Sender: TObject);
begin
  HideTitle;

  mnuMemoModify.Enabled := FFocusMemo <> nil;
  mnuMemoDelete.Enabled := FFocusMemo <> nil;

  MemoFilterBegin;
  try
    mnuMemoNoFilter.Enabled := MemoFilter.Filtering;
  finally
    MemoFilterEnd;
  end;
end;

procedure TfrmCal.EditMemoNewApply(Sender: TObject);
var
  NewMemo: TDayMemo;
begin
  MemoFilterBegin;
  try
    NewMemo := TDayMemo.Create;
    NewMemo.Assign(TdlgEditMemo(Sender).DayMemo);
    if not MemoFilter.Match(NewMemo) then
      MessageBox(Handle, PChar('フィルタが有効になっているため新しいメモ "'
         + NewMemo.TopLine + '" は表示されませんが、登録はされています。'),
         '確認', MB_ICONINFORMATION);
    MemoStream.MemoList.Add(NewMemo);
    MemoUpdate;
    pbCalendar.Invalidate;

  finally
    MemoFilterEnd;
  end;
end;

// メモ作成メニュー
procedure TfrmCal.mnuMemoNewClick(Sender: TObject);
var
  NewMemo: TDayMemo;
begin
  if dlgEditMemo = nil then
    dlgEditMemo := TdlgEditMemo.CreateOwnedForm(Self, Self);

  dlgEditMemo.Caption := 'メモの新規作成';
  dlgEditMemo.OnApply := EditMemoNewApply;

  NewMemo := TDayMemo.Create;
  try
    NewMemo.BeginDate := FSelBeginDate;
    NewMemo.EndDate := FSelEndDate;
    dlgEditMemo.DayMemo := NewMemo;
  finally
    NewMemo.Free;
  end;
  dlgEditMemo.ShowModal;
end;

procedure TfrmCal.EditMemoModifyApply(Sender: TObject);
begin
  if FFocusMemo <> nil then
  begin

    MemoFilterBegin;
    try
      FFocusMemo.Assign(TdlgEditMemo(Sender).DayMemo);
      if not MemoFilter.Match(FFocusMemo) then
        MessageBox(Handle, PChar('フィルタが有効になっているため、変更されたメモ "'
           + FFocusMemo.TopLine + '" は表示されませんが、登録はされています。'), '確認', MB_ICONINFORMATION);
      MemoUpdate;
      pbCalendar.Invalidate;
    finally
      MemoFilterEnd;
    end;
  end;
end;

// メモ変更メニュー
procedure TfrmCal.mnuMemoModifyClick(Sender: TObject);
begin
  if FFocusMemo <> nil then
  begin
    if dlgEditMemo = nil then
      dlgEditMemo := TdlgEditMemo.CreateOwnedForm(Self, Self);

    dlgEditMemo.Caption := 'メモの変更';
    dlgEditMemo.OnApply := EditMemoModifyApply;
    dlgEditMemo.DayMemo := FFocusMemo;
    dlgEditMemo.ShowModal;
  end;
end;

// メモ削除メニュー
procedure TfrmCal.mnuMemoDeleteClick(Sender: TObject);
var
  Msg: String;
begin
  if FFocusMemo <> nil then
  begin
    Msg := 'メモ "' + FFocusMemo.TopLine + '" を削除します。';
    if MessageBox(Handle, PChar(Msg), '削除', MB_ICONINFORMATION or MB_OKCANCEL) = idOk then
    begin
      MemoStream.MemoList.Remove(FFocusMemo);
      FocusMemo := nil;
      MemoUpdate;
      pbCalendar.Invalidate;
    end;
  end;
end;

// メモ一覧メニュー
procedure TfrmCal.mnuMemoListClick(Sender: TObject);
begin
  if dlgMemoList = nil then
    dlgMemoList := TdlgMemoList.CreateOwnedForm(Self, Self);
  dlgMemoList.OnApply := MemoListApply;
  dlgMemoList.ShowModal;
end;

// メモ一覧の更新
procedure TfrmCal.MemoListApply(Sender: TObject);
begin
  MemoUpdate;
  pbCalendar.Invalidate;
end;

procedure TfrmCal.FilterApply(Sender: TObject);
begin
  MemoFilterBegin;
  try
    MemoFilter.Assign(TdlgFilter(Sender).MemoFilter);
    MemoUpdate;
  finally
    pbCalendar.Invalidate;
    MemoFilterEnd;
  end;
end;

// フィルタ
procedure TfrmCal.mnuMemoFilterClick(Sender: TObject);
begin
  if dlgFilter = nil then
    dlgFilter := TdlgFilter.CreateOwnedForm(Self, Self);
  dlgFilter.OnApply := FilterApply;
  MemoFilterBegin;
  try
    dlgFilter.MemoFilter := MemoFilter;
  finally
    MemoFilterEnd;
  end;
  dlgFilter.ShowModal;
end;

// フィルタ解除
procedure TfrmCal.mnuMemoNoFilterClick(Sender: TObject);
begin
  MemoFilterBegin;
  try
    MemoFilter.Clear;
    MemoUpdate;
  finally
    MemoFilterEnd;
    pbCalendar.Invalidate;
  end;
end;


// 閉じるメニュー
procedure TfrmCal.mnuCloseClick(Sender: TObject);
begin
  Close;
end;

// 今日ボタン
procedure TfrmCal.btnTodayClick(Sender: TObject);
begin
  ChangeFocusDate(cfToday);
end;

// 前月ボタン
procedure TfrmCal.btnPrevClick(Sender: TObject);
begin
  ChangeFocusDate(cfPrevMonth);
end;

// 後月ボタン
procedure TfrmCal.btnNextClick(Sender: TObject);
begin
  ChangeFocusDate(cfNextMonth);
end;


// キーダウン
procedure TfrmCal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // 上
  if Key=VK_UP then
//    ChangeFocusDate(cfPrevWeek)
    FocusUp

  // 下
  else if Key=VK_DOWN then
//    ChangeFocusDate(cfNextWeek)
    FocusDown

  // 左
  else if Key=VK_LEFT then
    ChangeFocusDate(cfPrevDay)

  // 右
  else if Key=VK_RIGHT then
    ChangeFocusDate(cfNextDay)

  // PageUp
  else if Key = VK_PRIOR then
  begin
    if Shift = [ssCtrl] then
      ChangeFocusDate(cfPrevYear)
    else
      ChangeFocusDate(cfPrevMonth)
  end

  // PageDown
  else if Key = VK_NEXT then
  begin
    if Shift = [ssCtrl] then
      ChangeFocusDate(cfNextYear)
    else
      ChangeFocusDate(cfNextMonth)
  end

  // Home
  else if Key = VK_HOME then
    ChangeFocusDate(cfToday)

  // Esc
  else if Key = VK_ESCAPE then
    mnuCloseClick(nil)

  // Delete
  else if Key = VK_DELETE then
    mnuMemoDeleteClick(nil)

  // Enter
  else if Key = VK_RETURN then
  begin
    if FFocusMemo = nil then
      mnuMemoNewClick(nil)
    else
      mnuMemoModifyClick(nil);
  end

end;

// ホイール
procedure TfrmCal.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta > 0 then
  begin
    if (ssMiddle in Shift) or (ssCtrl in Shift) then
      ChangeFocusDate(cfPrevYear)
    else
      ChangeFocusDate(cfPrevMonth);
  end
  else
  begin
    if (ssMiddle in Shift) or (ssCtrl in Shift) then
      ChangeFocusDate(cfNextYear)
    else
      ChangeFocusDate(cfNextMonth);
  end;
  Update;
end;

// ダブルクリック
procedure TfrmCal.pbCalendarDblClick(Sender: TObject);
begin
  if MouseEntered then
  begin
    if FFocusMemo = nil then
      mnuMemoNewClick(nil)
    else
      mnuMemoModifyClick(nil);
  end;
end;

// マウスダウン
procedure TfrmCal.pbCalendarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  MemoRect: TMemoRect;
  MouseDateWork: TDateTime;
  MouseMemo: TDayMemo;
begin
  // ダブルクリックの後にマウスダウンが発生しちゃうから
  if (GetKeyState(VK_LBUTTON) >= 0) and (GetKeyState(VK_RBUTTON) >= 0) then
    Exit;

  HideTitle;
  if (Button = mbLeft) or (Button = mbRight) then
  begin
    MouseDateWork := MouseDate;

    MouseMemo := nil;
    FDragType := dtNormal;
    for i := 0 to FMemoRectList.Count - 1 do
    begin
      MemoRect := FMemoRectList[i];
      if PtInRect(MemoRect.Rect, Point(X, Y)) then
      begin
        MouseMemo := MemoRect.Memo;
        FDragType := dtMemo;
      end;

      // メモの両端をつまむ
      if (Y >= MemoRect.Rect.Top) and (Y < MemoRect.Rect.Bottom) then
      begin
        if (MemoRect.Prev = nil) and (X >= MemoRect.Rect.Left - 3) and (X < MemoRect.Rect.Left + 3) then
        begin
          MouseMemo := MemoRect.Memo;
          FDragType := dtMemoBegin;
        end;
        if (MemoRect.Next = nil) and (X >= MemoRect.Rect.Right - 3) and (X < MemoRect.Rect.Right + 3) then
        begin
          MouseMemo := MemoRect.Memo;
          FDragType := dtMemoEnd;
        end;
      end;
    end;

    if Button = mbRight then
      FDragType := dtNone;

    FocusMemo := MouseMemo;

    if (FFocusMemo <> nil) and (FDragType = dtMemo) then
      FDragMemoOffset := MouseDateWork - FFocusMemo.BeginDate
    else
      FDragMemoOffset := 0;

    // 選択状態を変更
    if (Button = mbLeft) or (FSelBeginDate = FSelEndDate) then
    begin
      if not (ssShift in Shift) then
        FSelBeginDate := MouseDateWork;
      FocusDate := MouseDateWork;
    end;

  end
  else
    FDragType := dtNone;
end;

// マウスムーブ
procedure TfrmCal.pbCalendarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  i: Integer;
  MemoRect: TMemoRect;
  Cur: TCursor;
begin
  if (FLastPos.x = X) and (FLastPos.y = Y) then
    Exit;

  FLastPos.x := X;
  FLastPos.y := Y;

  if FDragType = dtNone then
  begin
    Cur := crDefault;
    for i := 0 to FMemoRectList.Count - 1 do
    begin
      MemoRect := FMemoRectList[i];
      if PtInRect(MemoRect.Rect, Point(X, Y)) then
        Cur := crDefault;

      if (Y >= MemoRect.Rect.Top) and (Y < MemoRect.Rect.Bottom) then
      begin
        // メモの両端のカーソル
        if ((MemoRect.Prev = nil) and (X >= MemoRect.Rect.Left - 3) and (X < MemoRect.Rect.Left + 3))
         or ((MemoRect.Next = nil) and (X >= MemoRect.Rect.Right - 3) and (X < MemoRect.Rect.Right + 3)) then
          Cur := crSizeWE;
      end;
    end;

    pbCalendar.Cursor := Cur;
  end
  else
  begin
    FocusDate := MouseDate;
  end;


  if MouseEntered then
  begin
    MouseDate := MouseDate;
  end
  else
    HideTitle;
end;

// マウスアップ
procedure TfrmCal.pbCalendarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FDragType := dtNone;
  end;
end;

// コンテキストメニュー表示
procedure TfrmCal.WMContextMenu(var Msg: TWMContextMenu);
var
  Pos: TPoint;
  FocusYear, FocusMonth, FocusDay: Word;
begin
  if (Msg.Pos.y < 0) and (Msg.Pos.x < 0) then
  begin
    DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);
    Pos := Point(FDayRect[FocusDay].Left, FDayRect[FocusDay].Bottom);
    Msg.Pos := PointToSmallPoint(pbCalendar.ClientToScreen(Pos));
  end;
  inherited;
end;

// キャプション表示
procedure TfrmCal.ShowCaption(ADate: TDateTime);
var
  Year, Month, Day: Word;
  CalCaption, HolidayStr, MemoStr: String;
  i, j: Integer;
  Memo: TDayMemo;
  Pos: TPoint;
begin
  DecodeDate(ADate, Year, Month, Day);
  HolidayStr := FMyHoliday.GetHolidayStr(Year, Month, Day);

  MemoStr := '';
  for i := 0 to FMonthMemoList.Count - 1 do
  begin
    Memo := FMonthMemoList[i];
    if (ADate >= Memo.BeginDate) and (ADate <= Memo.EndDate) then
    begin
      for j := 0 to Memo.Count - 1 do
      begin
        if MemoStr <> '' then
          MemoStr := MemoStr + #13#10;
        if j = 0 then
          MemoStr := MemoStr + '■' + Memo[j]
        else
          MemoStr := MemoStr + '－' + Memo[j];
      end;
    end;
  end;

  CalCaption := FormatDateTime('dddddd', ADate);

  if HolidayStr <> '' then
  begin
    CalCaption := CalCaption + ' ' + HolidayStr;
  end;

  if MemoStr <> '' then
  begin
    CalCaption := CalCaption + #13#10 + MemoStr;
  end;

  if (HolidayStr <> '') or (MemoStr <> '') then
  begin
    Pos.x := FDayRect[Day].Left;
    Pos.y := FDayRect[Day].Bottom + 5;
    Pos := pbCalendar.ClientToScreen(Pos);

    ShowTitle(Self, CalCaption, Pos.x, Pos.y);
  end
  else
    HideTitle;
end;

// メモに変更があった
procedure TfrmCal.MemoUpdate;
begin
  MemoStream.Sort;
  MonthMemoListUpdate;
  UpdateDayInfo(True);
end;

// 月に含まれるメモの更新
procedure TfrmCal.MonthMemoListUpdate;
var
  i: Integer;
  NewYear, NewMonth, NewDay: Word;
  FirstDate, LastDate: TDateTime;
  Memo: TDayMemo;
begin
  DecodeDate(FFocusDate, NewYear, NewMonth, NewDay);

  FMonthMemoList.Clear;
  FirstDate := EncodeDate(NewYear, NewMonth, 1);
  LastDate := EncodeDate(NewYear, NewMonth, GetNumberOfDays(NewYear, NewMonth));

  MemoFilterBegin;
  try

    for i := 0 to MemoStream.MemoList.Count - 1 do
    begin
      Memo := MemoStream.MemoList[i];

      if (Memo.EndDate >= FirstDate) and (Memo.BeginDate <= LastDate) then
        if MemoFilter.Match(Memo) then
          FMonthMemoList.Add(Memo);
    end;

  finally
    MemoFilterEnd;
  end;
end;


// カレントの日付をセット
procedure TfrmCal.SetFocusDate(const Value: TDateTime);
var
  OldYear, OldMonth, OldDay: Word;
  NewYear, NewMonth, NewDay: Word;
  MemoDays: TDateTime;
begin
  if (Value < EncodeDate(1, 1, 1)) or (Value > EncodeDate(2999, 12, 31)) then
  begin
    Exit;
  end;

  if FFocusDate <> Value then
  begin

    HideTitle;

    DecodeDate(FFocusDate, OldYear, OldMonth, OldDay);
    DecodeDate(Value, NewYear, NewMonth, NewDay);

    FFocusDate := Value;

    // 月が変わった
    if (OldYear <> NewYear) or (OldMonth <> NewMonth) then
    begin
      MonthMemoListUpdate;
    end;

    // ドラッグ中
    if (FDragType <> dtNone) and (FocusMemo <> nil) then
    begin
      FSelBeginDate := Value;

      // メモをドラッグ中
      if FDragType = dtMemo then
      begin
        MemoDays := FocusMemo.EndDate - FocusMemo.BeginDate;
        FocusMemo.BeginDate := Value - FDragMemoOffset;
        FocusMemo.EndDate := FocusMemo.BeginDate + MemoDays;
        MemoUpdate;
      end

      // メモの最初をドラッグ中
      else if FDragType = dtMemoBegin then
      begin
        if FocusMemo.EndDate >= Value then
          FocusMemo.BeginDate := Value
        else
          FocusMemo.BeginDate := FocusMemo.EndDate;
        MemoUpdate;
      end

      // メモの最後をドラッグ中
      else if FDragType = dtMemoEnd then
      begin
        if FocusMemo.BeginDate <= Value then
          FocusMemo.EndDate := Value
        else
          FocusMemo.EndDate := FocusMemo.BeginDate;
        MemoUpdate;
      end;
    end;

  end;

  // Shiftキーも左ボタンも押されてなければ
  if (GetKeyState(VK_SHIFT) >= 0) and (GetKeyState(VK_LBUTTON) >= 0) then
    FSelBeginDate := Value;
  FSelEndDate := Value;

  pbMonth.Invalidate;
  pbCalendar.Invalidate;
end;


// マウスのある日をゲット
function TfrmCal.GetMouseDate: TDateTime;
var
  FocusYear, FocusMonth, FocusDay: Word;
  Pos: TPoint;
  Day: Integer;
begin
  if GetCursorPos(Pos) then
  begin
    DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);
    Pos := pbCalendar.ScreenToClient(Pos);
    Day := 1;
    while Day <= 31 do
    begin
      if PtInRect(FDayRect[Day], Pos) then
        Break;
      Inc(Day);
    end;

    if Day <= 31 then
      Result := EncodeDate(FocusYear, FocusMonth, Day)
    else
      Result := FFocusDate;
  end
  else
    Result := FFocusDate;
end;

// マウスがある日をセット
procedure TfrmCal.SetMouseDate(const Value: TDateTime);
begin
  if FMouseDate = Value then
    Exit;

  FMouseDate := Value;
  ShowCaption(Value);
end;

// マウスが日付の上にあるかを確認
function TfrmCal.GetMouseEntered: Boolean;
var
  FocusYear, FocusMonth, FocusDay: Word;
  Pos: TPoint;
  Day: Integer;
begin
  Result := False;
  if GetCursorPos(Pos) then
  begin
    DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);
    Pos := pbCalendar.ScreenToClient(Pos);
    Day := 1;
    while Day <= 31 do
    begin
      if PtInRect(FDayRect[Day], Pos) then
      begin
        Result := True;
        Break;
      end;
      Inc(Day);
    end;

  end;
end;

// フォーカスのあるメモの変更
procedure TfrmCal.SetFocusMemo(const Value: TDayMemo);
begin
  if FFocusMemo = Value then
    Exit;

  FFocusMemo := Value;

  pbMonth.Invalidate;
  pbCalendar.Invalidate;
end;

// 日の幅
function TfrmCal.GetDayWidth(Col: Integer): Integer;
begin
  Result := (pbCalendar.Width - 1) div 7;
  if ((pbCalendar.Width - 1) mod 7) > 0 then
    if (Col + 1) <= ((pbCalendar.Width - 1) mod 7) then
      Result := Result + 1;
end;

// 日の高さ
function TfrmCal.GetDayHeight(Row: Integer): Integer;
begin
  Result := ((pbCalendar.Height - 1) - GetWeekHeight) div 6;
  if (((pbCalendar.Height - 1) - GetWeekHeight) mod 6) > 0 then
    if (Row + 1) <= (((pbCalendar.Height - 1) - GetWeekHeight) mod 6) then
      Result := Result + 1;
end;

// 週の高さ
function TfrmCal.GetWeekHeight: Integer;
begin
  Result := Round(pbCalendar.Canvas.TextHeight('あ') * 1.4);
end;

// 月描画
procedure TfrmCal.pbMonthPaint(Sender: TObject);
begin
  DrawMonth;
end;

// カレンダー描画
procedure TfrmCal.pbCalendarPaint(Sender: TObject);
begin
  DrawCalendar;
end;

// 月描画
procedure TfrmCal.DrawMonth;
var
  FocusYear, FocusMonth, FocusDay: Word;

  MValue, MStr, YGen: String;
  MRect, r: TRect;
begin
  DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);

  with pbMonth do
  begin
    MValue := IntToStr(FocusMonth);
    case FocusMonth of
      1:  MStr := 'January';
      2:  MStr := 'February';
      3:  MStr := 'March';
      4:  MStr := 'April';
      5:  MStr := 'May';
      6:  MStr := 'June';
      7:  MStr := 'July';
      8:  MStr := 'August';
      9:  MStr := 'September';
      10: MStr := 'October';
      11: MStr := 'November';
      12: MStr := 'December';
    end;
    MStr := MStr + ' ' + FormatDateTime('yyyy', FFocusDate);


    YGen := FormatDateTime('ggge"年"', FFocusDate);

    r := ClientRect;
//    r.Right := ((Width - 1) div 7) * 7;

    Canvas.Font.Color := FStringColor;
    Canvas.Font.Name := FStringFontName;
    Canvas.Font.Size := Trunc(FStringFontSize * 1.8);
    Canvas.Font.Style := FStringFontStyle;
//    Canvas.Font.Height := - (Height - 2);

    MRect := r;
    MRect.Left := MRect.Left + 5;
    MRect.Right := MRect.Left + Canvas.TextWidth(MValue);
//    DrawText(Canvas.Handle, PChar(MValue), Length(MValue), MRect, DT_SINGLELINE or DT_BOTTOM or DT_LEFT);
    Canvas.TextOut(MRect.Left, MRect.Bottom - Canvas.TextHeight(MValue), MValue);

    MRect.Left := MRect.Right + 5;
    MRect.Right := r.Right;
    Canvas.Font.Size := FStringFontSize;
//    DrawText(Canvas.Handle, PChar(MStr), Length(MStr), MRect, DT_SINGLELINE or DT_BOTTOM or DT_LEFT);
    Canvas.TextOut(MRect.Left, MRect.Bottom - Canvas.TextHeight(MStr), MStr);

    MRect := r;
    MRect.Right := MRect.Right - 5;
    if (FocusYear >= 1869) and (FocusYear <= 2087) then
//      DrawText(Canvas.Handle, PChar(YGen), Length(YGen), r, DT_SINGLELINE or DT_BOTTOM or DT_RIGHT);
      Canvas.TextOut(MRect.Right - Canvas.TextWidth(YGen), MRect.Bottom - Canvas.TextHeight(YGen), YGen);

  end;
end;

// カレンダー描画
procedure TfrmCal.DrawCalendar;
var
  Day, Week, MaxDay: Integer;
  FocusYear, FocusMonth, FocusDay: Word;
  FirstDayOfWeek: Integer;
  DrawDate: TDateTime;
  SelFirstDate, SelLastDate: TDateTime;
  WeekStr, DayStr, HolidayStr: String;

  x, y, Row: Integer;
  DayRect, DayLabelRect, HolidayRect, FocusRect: TRect;
  DayFontColor, DayBackColor: TColor;
begin
  ClearDayRect;
  ClearMemoRectList;

  pbCalendar.Canvas.Font.Name := FStringFontName;
  pbCalendar.Canvas.Font.Size := FStringFontSize;
  pbCalendar.Canvas.Font.Style := FStringFontStyle;

  FDayLabelHeight := pbCalendar.Canvas.TextHeight('あ');

  DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);

  MaxDay := GetNumberOfDays(FocusYear, FocusMonth);
  FirstDayOfWeek := JDToDayOfWeek(YMDToJD(FocusYear, FocusMonth, 1));
  if FSelBeginDate <= FSelEndDate then
  begin
    SelFirstDate := FSelBeginDate;
    SelLastDate := FSelEndDate;
  end
  else
  begin
    SelFirstDate := FSelEndDate;
    SelLastDate := FSelBeginDate;
  end;

  with pbCalendar do
  begin
    // 曜日を描画
    x := 0;
    y := 0;
    for Week := 1 to 7 do
    begin
      WeekStr := WeekNames[Week - 1];

      case Week of
        1: Canvas.Font.Color := FSundayColor;
        7: Canvas.Font.Color := FSaturdayColor;
      else
        Canvas.Font.Color := FStringColor;
      end;


      DayRect.Left := x;
      DayRect.Top := y;
      DayRect.Right := x + GetDayWidth(Week - 1);
      DayRect.Bottom := y + GetWeekHeight;

      Canvas.Pen.Color := FLineColor;
      Canvas.Polyline([Point(DayRect.Left + 2, DayRect.Bottom - 1),
                       Point(DayRect.Right - 1, DayRect.Bottom - 1),
                       Point(DayRect.Right - 1, DayRect.Top + 2)]);

      DrawText(Canvas.Handle, PChar(WeekStr), Length(WeekStr), DayRect, DT_SINGLELINE or DT_VCENTER or DT_CENTER);

      x := DayRect.Right;
    end;



    // 日を描画
    x := 0;
    for Week := 1 to FirstDayOfWeek - 1 do
      x := x + GetDayWidth(Week - 1);
    y := GetWeekHeight;
    Row := 0;
    Week := FirstDayOfWeek;
    for Day := 1 to MaxDay do
    begin
      DrawDate := EncodeDate(FocusYear, FocusMonth, Day);

      DayStr := Format('%2d', [Day]);
      HolidayStr := FMyHoliday.GetHolidayStr(FocusYear, FocusMonth, Day);

      case Week of
        1:    DayFontColor := FSundayColor;
        7:    DayFontColor := FSaturdayColor;
      else
        DayFontColor := FStringColor;
      end;
      if HolidayStr <> '' then
        DayFontColor := FHolidayColor;
      if DrawDate = Date then
        DayBackColor := FTodayColor
      else
        DayBackColor := FBackGroundColor;

      DayRect.Left := x;
      DayRect.Top := y;
      DayRect.Right := x + GetDayWidth(Week - 1);
      DayRect.Bottom := y + GetDayHeight(Row);
      FDayRect[Day] := DayRect;

      Canvas.Pen.Color := FLineColor;
      Canvas.Polyline([Point(DayRect.Left + 2, DayRect.Bottom - 1),
                       Point(DayRect.Right - 1, DayRect.Bottom - 1),
                       Point(DayRect.Right - 1, DayRect.Top + 2)]);

      // 選択
      if (DrawDate >= SelFirstDate) and (DrawDate <= SelLastDate) then
      begin
        Canvas.Font.Color := DayBackColor;
        Canvas.Brush.Color := DayFontColor;
      end
      else
      begin
        Canvas.Font.Color := DayFontColor;
        Canvas.Brush.Color := DayBackColor;
      end;

      DayLabelRect := DayRect;
      InflateRect(DayLabelRect, -2, -2);
      DayLabelRect.Bottom := DayLabelRect.Top + FDayLabelHeight;
      HolidayRect := DayLabelRect;
      HolidayRect.Left := HolidayRect.Left + Canvas.TextWidth('88') + 3;
      FocusRect := DayLabelRect;
      InflateRect(FocusRect, 1, 1);
//      FocusRect := DayRect;
//      FocusRect.Right := FocusRect.Right - 1;
//      FocusRect.Bottom := FocusRect.Bottom - 1;

      Canvas.FillRect(DayLabelRect);
      DrawText(Canvas.Handle, PChar(DayStr), Length(DayStr), DayLabelRect, DT_SINGLELINE or DT_TOP);
      DrawText(Canvas.Handle, PChar(HolidayStr), Length(HolidayStr), HolidayRect, DT_SINGLELINE or DT_NOPREFIX or DT_TOP);

      // フォーカス
      if (Day = FocusDay) and (FFocusMemo = nil) then
      begin
        // なぜかこの３行を実行しないと正しく出ない。。。
        Canvas.Brush.Color := FBackGroundColor;
        Canvas.Font.Color := clBlack;
        DrawText(Canvas.Handle, '', 0, FocusRect, 0);

        Canvas.DrawFocusRect(FocusRect);
      end;

      x := DayRect.Right;
      Inc(Week);
      if Week > 7 then
      begin
        Week := 1;
        x := 0;
        y := DayRect.Bottom;
        Inc(Row);
      end;

    end;
  end;
  DrawMemo;
end;

// メモ描画
procedure TfrmCal.DrawMemo;

  procedure AddMemoRect(Day: Integer; Memo: TDayMemo; DrawDate, FirstDate, LastDate: TDateTime);
  var
    TextHeight: Integer;
    MemoRect: TMemoRect;
    MemoRectWork: TMemoRect;
    Offset: Integer;
    i: Integer;
  begin
    TextHeight := pbCalendar.Canvas.TextHeight('a');
    MemoRect := TMemoRect.Create;
    MemoRect.Memo := Memo;
    MemoRect.Rect.Top := FDayRect[Day].Top + FDayLabelHeight + 4;
    MemoRect.Rect.Bottom := MemoRect.Rect.Top + TextHeight + 4;
    MemoRect.Rect.Left := FDayRect[Day].Left + 2;
    MemoRect.Rect.Right := FDayRect[Day].Right - 3;
    MemoRect.BeginDate := DrawDate;
    MemoRect.EndDate := DrawDate;

    // 前の月から
    if MemoRect.Memo.BeginDate < FirstDate then
      MemoRect.Prev := MemoRect;
    // 次の月まで
    if MemoRect.Memo.EndDate > LastDate then
      MemoRect.Next := MemoRect;

    // 前後関係をつなげる
    for i := 0 to FMemoRectList.Count - 1 do
    begin
      MemoRectWork := TMemoRect(FMemoRectList[i]);
      if MemoRect.Memo = MemoRectWork.Memo then
      begin
        MemoRect.Prev := MemoRectWork;
        MemoRectWork.Next := MemoRect;
      end;
    end;

    // 重なりを調べる
    i := 0;
    while i < FMemoRectList.Count do
    begin
      MemoRectWork := TMemoRect(FMemoRectList[i]);

      if (MemoRect.Rect.Top = MemoRectWork.Rect.Top) and
         (MemoRect.Rect.Left <= MemoRectWork.Rect.Right) and
         (MemoRect.Rect.Right >= MemoRectWork.Rect.Left) then
      begin
        Offset := TextHeight + 4 + 1;

        // はみ出す分を修正
        if MemoRect.Rect.Bottom + Offset > FDayRect[Day].Bottom - 2 then
        begin
          Offset := FDayRect[Day].Bottom - 2 - MemoRect.Rect.Bottom;
          if Offset > 0 then
            OffsetRect(MemoRect.Rect, 0, Offset);
          Break;
        end;

        OffsetRect(MemoRect.Rect, 0, Offset);
        i := 0;
      end
      else
        Inc(i);
    end;




    if MemoRect.Rect.Bottom > FDayRect[Day].Bottom - 2 then
    begin
      MemoRect.Rect.Bottom := FDayRect[Day].Bottom - 2;
      MemoRect.StickOut := True;
    end;
    FMemoRectList.Add(MemoRect);
  end;


var
  Day, MaxDay: Integer;
  FocusYear, FocusMonth, FocusDay: Word;
  DrawDate, FirstDate, LastDate: TDateTime;
  i, j: Integer;
  Memo: TDayMemo;
  MemoRect: TMemoRect;
  y: Integer;
  LineChange: Boolean;
  TextRect: TRect;
  TopLine: String;
  FaceColor, HighlightColor, ShadowColor, DarkColor: TColor;
begin
  pbCalendar.Canvas.Font.Name := FMemoFontName;
  pbCalendar.Canvas.Font.Size := FMemoFontSize;
  pbCalendar.Canvas.Font.Style := FMemoFontStyle;


  DecodeDate(FFocusDate, FocusYear, FocusMonth, FocusDay);
  MaxDay := GetNumberOfDays(FocusYear, FocusMonth);
  FirstDate := EncodeDate(FocusYear, FocusMonth, 1);
  LastDate := EncodeDate(FocusYear, FocusMonth, MaxDay);

  y := 0;
  LineChange := False;
  for Day := 1 to MaxDay do
  begin
    DrawDate := EncodeDate(FocusYear, FocusMonth, Day);

    // 行が変わる
    if y < FDayRect[Day].Top then
    begin
      y := FDayRect[Day].Top;
      LineChange := True;
    end;


    for i := 0 to FMonthMemoList.Count - 1 do
    begin
      Memo := FMonthMemoList[i];

      if (DrawDate >= Memo.BeginDate) and (DrawDate <= Memo.EndDate) then
      begin
        MemoRect := nil;
        j := FMemoRectList.Count - 1;
        while j >= 0 do
        begin
          MemoRect := FMemoRectList[j];
          if MemoRect.Memo = Memo then
            Break;
          Dec(j);
        end;

        if j >= 0 then
        begin
          if LineChange then
          begin
            AddMemoRect(Day, Memo, DrawDate, FirstDate, LastDate);
          end
          else
          begin
            MemoRect.Rect.Right := FDayRect[Day].Right - 3;
            MemoRect.EndDate := DrawDate;
          end;
        end
        else
        begin
          AddMemoRect(Day, Memo, DrawDate, FirstDate, LastDate);
        end

      end;
    end;
    LineChange := False;
  end;

  for i := 0 to FMemoRectList.Count - 1 do
  begin
    MemoRect := FMemoRectList[i];

    if MemoRect.Rect.Top < MemoRect.Rect.Bottom then
    begin

      FaceColor := NMKindColor;

      if MemoRect.Memo = FFocusMemo then
        FaceColor := clHighlight
      else if MemoRect.Memo.Kind <> '' then
      begin
        j := KindList.IndexOf(MemoRect.Memo.Kind);
        if j >= 0 then
          FaceColor := TKindData(KindList.Objects[j]).Color;
      end;

      GetButtonBorderColor(FaceColor, HighlightColor, ShadowColor, DarkColor);

      pbCalendar.Canvas.Brush.Color := FaceColor;
      pbCalendar.Canvas.Font.Color := GetFontColorFromFaceColor(FaceColor);
      pbCalendar.Canvas.FillRect(MemoRect.Rect);

      // 上辺
      pbCalendar.Canvas.Pen.Color := HighlightColor;
      pbCalendar.Canvas.Moveto(MemoRect.Rect.Left, MemoRect.Rect.Top);
      pbCalendar.Canvas.Lineto(MemoRect.Rect.Right, MemoRect.Rect.Top);
      // 下辺
      if not MemoRect.StickOut then
      begin
        pbCalendar.Canvas.Pen.Color := ShadowColor;
        pbCalendar.Canvas.Moveto(MemoRect.Rect.Left, MemoRect.Rect.Bottom - 1);
        pbCalendar.Canvas.Lineto(MemoRect.Rect.Right, MemoRect.Rect.Bottom - 1);
      end;
      // 左辺
      if MemoRect.Prev = nil then
      begin
        pbCalendar.Canvas.Pen.Color := HighlightColor;
        pbCalendar.Canvas.Moveto(MemoRect.Rect.Left, MemoRect.Rect.Top);
        pbCalendar.Canvas.Lineto(MemoRect.Rect.Left, MemoRect.Rect.Bottom - 1);
      end;
      // 右辺
      if MemoRect.Next = nil then
      begin
        pbCalendar.Canvas.Pen.Color := ShadowColor;
        pbCalendar.Canvas.Moveto(MemoRect.Rect.Right - 1, MemoRect.Rect.Top);
        pbCalendar.Canvas.Lineto(MemoRect.Rect.Right - 1, MemoRect.Rect.Bottom - 1);
      end;

      TextRect := MemoRect.Rect;
      InflateRect(TextRect, -2, -2);
      TopLine := MemoRect.Memo.TopLine;
      DrawText(pbCalendar.Canvas.Handle, PChar(TopLine), Length(TopLine), TextRect, DT_SINGLELINE or DT_NOPREFIX or DT_TOP or DT_LEFT);

      if MemoRect.Memo = FFocusMemo then
        pbCalendar.Canvas.DrawFocusRect(MemoRect.Rect);

    end;

  end;
end;


// フォーカスの移動
procedure TfrmCal.ChangeFocusDate(ChangeType: TChangeFocusDateType);
var
  MaxDay: Integer;
  yy, mm, dd: Word;
begin
  FocusMemo := nil;

  DecodeDate(FocusDate, yy, mm, dd);

  case ChangeType of
    // 前の年
    cfPrevYear:
    begin
      if yy >= 1 then
      begin
        Dec(yy);

        MaxDay := GetNumberOfDays(yy, mm);
        if dd > MaxDay then
          dd := MaxDay;

        FocusDate := EncodeDate(yy, mm, dd);
      end;
    end;
    // 次の年
    cfNextYear:
    begin
      if yy < 2999 then
      begin
        Inc(yy);

        MaxDay := GetNumberOfDays(yy, mm);
        if dd > MaxDay then
          dd := MaxDay;

        FocusDate := EncodeDate(yy, mm, dd);
      end;
    end;

    // 前の月
    cfPrevMonth:
    begin
      if (yy > 1) or (mm > 1) then
      begin
        Dec(mm);
        if mm < 1 then
        begin
          dec(yy);
          mm := 12;
        end;

        MaxDay := GetNumberOfDays(yy, mm);
        if dd > MaxDay then
          dd := MaxDay;

        FocusDate := EncodeDate(yy, mm, dd);
      end;
    end;

    // 次の月
    cfNextMonth:
    begin
      DecodeDate(FocusDate, yy, mm, dd);

      if (yy < 2999) or (mm < 12) then
      begin
        Inc(mm);
        if mm > 12 then
        begin
          inc(yy);
          mm := 1;
        end;

        MaxDay := GetNumberOfDays(yy, mm);
        if dd > MaxDay then
          dd := MaxDay;

        FocusDate := EncodeDate(yy, mm, dd);
      end;
    end;

    // 前の週
    cfPrevWeek:
      FocusDate := FFocusDate - 7;

    // 次の週
    cfNextWeek:
      FocusDate := FFocusDate + 7;

    // 前の日
    cfPrevDay:
      FocusDate := FFocusDate - 1;

    // 次の日
    cfNextDay:
      FocusDate := FFocusDate + 1;

    // 今日
    cfToday:
      FocusDate := Date;
  end;
end;

// カーソル上
procedure TfrmCal.FocusUp;
  function CompRect(RectA, RectB: TMemoRect; RectList: TList): Integer;
  begin
    if RectA = nil then
      Result := -1
    else if RectB = nil then
      Result := 1
    else
    begin
      Result := RectA.Rect.Top - RectB.Rect.Top;
      if Result = 0 then
        Result := RectList.IndexOf(RectA) - RectList.IndexOf(RectB);
    end;
  end;

var
  i: Integer;
  CandiRectList: TList;
  MemoRect: TMemoRect;
  FocusRect: TMemoRect;
  CandiRect: TMemoRect;
begin
  if GetKeyState(VK_SHIFT) < 0 then
  begin
    ChangeFocusDate(cfPrevWeek);
    Exit;
  end;

  // 選択した日に選択したメモがなければ上の日に移動
  if FFocusMemo = nil then
  begin
    ChangeFocusDate(cfPrevWeek);
    pbCalendar.Update;
  end
  else if (FFocusDate < FFocusMemo.BeginDate) or (FFocusDate > FFocusMemo.EndDate) then
  begin
    FocusMemo := nil;
    ChangeFocusDate(cfPrevWeek);
    pbCalendar.Update;
  end;

  CandiRectList := TList.Create;
  try

    // 選択した日が含まれるTMemoRectを抜き出す
    FocusRect := nil;
    for i := 0 to FMemoRectList.Count - 1 do
    begin
      MemoRect := TMemoRect(FMemoRectList[i]);
      if (FFocusDate >= MemoRect.BeginDate)
        and (FFocusDate <= MemoRect.EndDate) then
      begin
        CandiRectList.Add(MemoRect);
        if MemoRect.Memo = FFocusMemo then
          FocusRect := MemoRect;
      end;
    end;

    CandiRect := nil;
    for i := 0 to CandiRectList.Count - 1 do
    begin
      MemoRect := CandiRectList[i];
      if (CompRect(CandiRect, MemoRect, CandiRectList) < 0)
        and ((FocusRect = nil) or (CompRect(FocusRect, MemoRect, CandiRectList) > 0)) then
        CandiRect := MemoRect;
    end;

    if CandiRect <> nil then
      FocusMemo := CandiRect.Memo
    else
      FocusMemo := nil;


  finally
    CandiRectList.Free;
  end;
end;

// カーソル下
procedure TfrmCal.FocusDown;
  function CompRect(RectA, RectB: TMemoRect; RectList: TList): Integer;
  begin
    if RectA = nil then
      Result := 1
    else if RectB = nil then
      Result := -1
    else
    begin
      Result := RectA.Rect.Top - RectB.Rect.Top;
      if Result = 0 then
        Result := RectList.IndexOf(RectA) - RectList.IndexOf(RectB);
    end;
  end;

var
  i: Integer;
  CandiRectList: TList;
  MemoRect: TMemoRect;
  FocusRect: TMemoRect;
  CandiRect: TMemoRect;
begin
  if GetKeyState(VK_SHIFT) < 0 then
  begin
    ChangeFocusDate(cfNextWeek);
    Exit;
  end;

  CandiRectList := TList.Create;
  try

    // 選択した日が含まれるTMemoRectを抜き出す
    FocusRect := nil;
    for i := 0 to FMemoRectList.Count - 1 do
    begin
      MemoRect := TMemoRect(FMemoRectList[i]);
      if (FFocusDate >= MemoRect.BeginDate)
        and (FFocusDate <= MemoRect.EndDate) then
      begin
        CandiRectList.Add(MemoRect);
        if MemoRect.Memo = FFocusMemo then
          FocusRect := MemoRect;
      end;
    end;

    CandiRect := nil;
    for i := 0 to CandiRectList.Count - 1 do
    begin
      MemoRect := CandiRectList[i];
      if (CompRect(CandiRect, MemoRect, CandiRectList) > 0)
        and ((FocusRect = nil) or (CompRect(FocusRect, MemoRect, CandiRectList) < 0)) then
        CandiRect := MemoRect;
    end;

    if CandiRect <> nil then
      FocusMemo := CandiRect.Memo
    else
      FocusMemo := nil;

  finally
    CandiRectList.Free;
  end;

  // 選択した日に選択したメモがなければ下の日に移動
  if FFocusMemo = nil then
    ChangeFocusDate(cfNextWeek)
  else if (FFocusDate < FFocusMemo.BeginDate) or (FFocusDate > FFocusMemo.EndDate) then
  begin
    FocusMemo := nil;
    ChangeFocusDate(cfNextWeek);
  end;


end;



procedure TfrmCal.SetOptions;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(InitFileName);
  try

    FBackGroundColor := Ini.ReadInteger('Design', 'BackGroundColor', clWhite);
    FLineColor := Ini.ReadInteger('Design', 'LineColor', clGray);
    FStringColor := Ini.ReadInteger('Design', 'StringColor', clNavy);
    FStringFontName := Ini.ReadString('Design', 'StringFontName', Font.Name);
    FStringFontSize := Ini.ReadInteger('Design', 'StringFontSize', Font.Size);
    FStringFontStyle := [];
    if Ini.ReadBool('Design', 'StringFontBold', False) then
      Include(FStringFontStyle, fsBold);
    if Ini.ReadBool('Design', 'StringFontItalic', False) then
      Include(FStringFontStyle, fsItalic);
    FTodayColor := Ini.ReadInteger('Design', 'TodayColor', clYellow);
    FSundayColor := Ini.ReadInteger('Design', 'SundayColor', clRed);
    FSaturdayColor := Ini.ReadInteger('Design', 'SaturdayColor', clBlue);
    FHolidayColor := Ini.ReadInteger('Design', 'HolidayColor', clRed);
    FMemoFontName := Ini.ReadString('Design', 'MemoFontName', Font.Name);
    FMemoFontSize := Ini.ReadInteger('Design', 'MemoFontSize', Font.Size);
    FMemoFontStyle := [];
    if Ini.ReadBool('Design', 'MemoFontBold', False) then
      Include(FMemoFontStyle, fsBold);
    if Ini.ReadBool('Design', 'MemoFontItalic', False) then
      Include(FMemoFontStyle, fsItalic);

    Color := FBackGroundColor;
  finally
    Ini.Free;
  end;

  pbMonth.Canvas.Font.Color := FStringColor;
  pbMonth.Canvas.Font.Name := FStringFontName;
  pbMonth.Canvas.Font.Size := Trunc(FStringFontSize * 1.8);
  pbMonth.Canvas.Font.Style := FStringFontStyle;

  pbMonth.SetBounds(8, 8, ClientWidth - 8 - 8 - 8, Abs(pbMonth.Canvas.Font.Height) + 2);
  pbCalendar.SetBounds(pbMonth.Left, pbMonth.Top + pbMonth.Height + 8, pbMonth.Width,
    ClientHeight - (pbMonth.Top + pbMonth.Height + 8) - 8);

  pbMonth.Invalidate;
  pbCalendar.Invalidate;
end;

procedure TfrmCal.mnuOptionClick(Sender: TObject);
begin
  dlgOption := TdlgOption.CreateOwnedForm(nil, Handle);
  try
    dlgOption.ShowModal;
  finally
    dlgOption.Release;
  end;
end;

end.
