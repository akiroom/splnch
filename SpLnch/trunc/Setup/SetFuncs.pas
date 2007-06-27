unit SetFuncs;

interface

uses
  Windows, SysUtils, Classes, SetBtn, IniFiles, ShellAPI, Forms, Dialogs,
  Registry, ShlObj, ActiveX, ComObj, pidl;

procedure SetupUnlock;

function GetFileVersionNo(FileName: string; var Mj, Mn, Rl, Bl: Cardinal): Boolean;
function UnknownFileExists(Folder: String): Boolean;
function SL3Load(GroupName, FileName: String; var DestGroup: TButtonGroup): Boolean;
function SL4FileCopy(Folder: string): Boolean;
function SetRegistry(Folder: string): Boolean;
function DeleteRegistry: Boolean;
function GetRegistry: String;
function GetSpecialFolder(nFolder: Integer): String;
function SetProgramMenu(TargetFolder: String): Boolean;
function SetStartup(TargetFolder: String): Boolean;
function SetDesktop(TargetFolder: String): Boolean;
function UninstallTemp(DeleteData, DeletePlugins: Boolean): Boolean;
function SL4FileDelete: Boolean;

const
  MUTEX_NAME = 'Special Launch Mutex';
  SETUP_MUTEX_NAME = 'Special Launch Setup Mutex';
var
  hSetupMutex: THandle;

implementation


procedure SetupUnlock;
begin
  if hSetupMutex <> 0 then
  begin
    ReleaseMutex(hSetupMutex);
    CloseHandle(hSetupMutex);
  end;
  hSetupMutex := 0;
end;


function CreateShortCut(ShortcutFile, FileName, Arguments, Description: String): Boolean;
var
  Unknown: IUnknown;
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  WideFileName: WideString;
begin
  Unknown := CreateComObject(CLSID_ShellLink);
  ShellLink := Unknown as IShellLink;
  PersistFile := Unknown as IPersistFile;

  ShellLink.SetPath(PChar(FileName));
  ShellLink.SetArguments(PChar(Arguments));
  ShellLink.SetDescription(PChar(Description));

  WideFileName := ShortcutFile;

  Result := SUCCEEDED(PersistFile.Save(PWChar(WideFileName), TRUE));
end;

// ファイルバージョン番号取得
function GetFileVersionNo(FileName: string; var Mj, Mn, Rl, Bl: Cardinal): Boolean;
var
  Work: Cardinal;
  VerInfo: Pointer;
  VerInfoSize: Cardinal;
  FileInfo: PVSFixedFileInfo;
  FileInfoSize: Cardinal;
begin
  Result := False;
  Work := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Work);
  if VerInfoSize <> 0 then
  begin

    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', Pointer(FileInfo), FileInfoSize) then
        begin
          Mj := HiWord(FileInfo^.dwProductVersionMS);
          Mn := LoWord(FileInfo^.dwProductVersionMS);
          Rl := HiWord(FileInfo^.dwProductVersionLS);
          Bl := LoWord(FileInfo^.dwProductVersionLS);
          Result := True;
        end;
      end;

    finally
      FreeMem(VerInfo);
    end;

  end;
end;

// 指定のフォルダにファイルがないかを確認
function UnknownFileExists(Folder: String): Boolean;
var
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
begin
  Result := False;
  FindHandle := FindFirstFile(PChar(Folder + '*.*'), Win32FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then
  begin
    while True do
    begin
      if (Win32FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        Result := True;
        Break;
      end;

      if not FindNextFile(FindHandle, Win32FindData) then
        Break;
    end;
    Windows.FindClose(FindHandle)
  end;
end;

// SL3 読み込み
function SL3Load(GroupName, FileName: String; var DestGroup: TButtonGroup): Boolean;
var
  i: Integer;
  lstWork: TStringList;
  ButtonData: TButtonData;
  NormalButton: TNormalButton;
//  Item: TListItem;
begin
  Result := False;

  lstWork := TStringList.Create;
  try
    lstWork.LoadFromFile(FileName);
    if lstWork.Count > 0 then
    begin
      if lstWork[0] = 'Special Launch Button File' then
      begin
        DestGroup := TButtonGroup.Create;
        try
          i := 1;
          while i < lstWork.Count do
          begin
            if lstWork[i] = '<改行>' then
            begin
              ButtonData := TReturnButton.Create;
              try
                inc(i, 7);
                DestGroup.Add(ButtonData);
              except
                ButtonData.Free;
              end;
            end
            else if (lstWork[i] = '') and (lstWork[i] = '') then
            begin
              ButtonData := TSpaceButton.Create;
              try
                inc(i, 7);
                DestGroup.Add(ButtonData);
              except
                ButtonData.Free;
              end;
            end
            else
            begin
              NormalButton := TNormalButton.Create;
              ButtonData := NormalButton;
              try
                // タイトル
                NormalButton.Name := lstWork[i];
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                // 実行ファイル
                NormalButton.FileName := lstWork[i];
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                {オプション}
                NormalButton.Option := lstWork[i];
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                {作業フォルダ}
                NormalButton.Folder := lstWork[i];
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                {ウィンドウサイズ}
                NormalButton.WindowSize   := StrToInt(lstWork[i]);
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                {アイコンファイル}
                NormalButton.IconFile := lstWork[i];
                inc(i);
                if i >= lstWork.Count then
                  Exception.Create('');

                {アイコンインデックス}
                NormalButton.IconIndex := StrToInt(lstWork[i]);
                inc(i);
                DestGroup.Add(NormalButton);
              except
                ButtonData.Free;
              end;
            end;
          end;

          DestGroup.Name := GroupName;
          Result := True;
        except

        end;
      end;
    end;


  finally
    lstWork.Free;
  end;
end;


// ファイルコピー
function SL4FileCopy(Folder: string): Boolean;
var
  FileList: TStringList;
  Ini: TIniFile;
  i: Integer;
  s: String;
  LpFileOp: TSHFILEOPSTRUCT;
begin


  FileList := TStringList.Create;
  try
    Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    try
      i := 0;
      while True do
      begin
        s := Ini.ReadString('Files', IntToStr(i), '');
        if s = '' then
          Break;
        FileList.Add(s);
        Inc(i);
      end;
    finally
      Ini.Free;
    end;

    s := '';
    for i := 0 to FileList.Count - 1 do
      s := s + FileList[i] + #0;
    s := s + #0;

    with LpFileOp do
    begin
      Wnd := Application.Handle;
      wFunc := FO_COPY;
      pFrom := PChar(s);
      pTo:= PChar(Folder);
      fFlags := FOF_NOCONFIRMATION;
      hNameMappings := nil;
      lpszProgressTitle := nil;
    end;
    Result := SHFileOperation(LpFileOp) = 0;



  finally
    FileList.Free;
  end;

end;

// レジストリ書き込み
function SetRegistry(Folder: string): Boolean;
var
  Key: String;
  Reg: TRegistry;
begin
  Result := False;

  Key := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\';
  Reg:= TRegistry.Create;
  with Reg do
  begin
    try
      RootKey:= HKEY_LOCAL_MACHINE;

      if KeyExists(Key) then
      begin
        OpenKey(Key + 'Special Launch 4', true);
        WriteString('DisplayName', 'Special Launch 4');
        WriteString('UninstallString', '"' + Folder + 'Setup.exe"');
        CloseKey;
        Result := True;
      end
    finally
     free;
    end;
  end;
end;


function GetRegistry: String;
var
  Key: String;
  Reg: TRegistry;
begin
  Key := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\';
  Reg:= TRegistry.Create;
  Result := '';
  with Reg do
  begin
    try
      RootKey:= HKEY_LOCAL_MACHINE;
      if KeyExists(Key) then
      begin
        OpenKey(Key + 'Special Launch 4', False);
        try
          Result := ReadString('UninstallString');
        finally
          CloseKey;
        end;
      end;
    finally
     free;
    end;
  end;

  if Result <> '' then
  begin
    Result := ExtractFilePath(Result);
    if Result[1] = '"' then
      Result := Copy(Result, 2, MaxInt);
  end;
end;

function DeleteRegistry: Boolean;
var
  Key: String;
  Reg: TRegistry;
begin
  Result := False;
  Key := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Special Launch 4';
  Reg:= TRegistry.Create;
  with Reg do
  begin
    try
      RootKey:= HKEY_LOCAL_MACHINE;

      if KeyExists(Key) then
        Result := DeleteKey(Key);
    finally
     Free;
    end;
  end;
end;

function GetSpecialFolder(nFolder: Integer): String;
var
  ItemIDList: PItemIDList;
  cWork: array[0..255] of Char;
begin
  Result := '';
  if SHGetSpecialFolderLocation(Application.Handle, nFolder, ItemIDList) = NOERROR then
  begin
    SHGetPathFromIDList(ItemIDList, cWork);
    Result := cWork;
    Malloc.Free(ItemIDList);
  end;
end;

function SetProgramMenu(TargetFolder: String): Boolean;
var
  Folder: String;
begin
  Result := False;
  Folder := GetSpecialFolder(CSIDL_PROGRAMS);
  if Folder <> '' then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    Folder := Folder + 'Special Launch 4\';
    Result := ForceDirectories(Folder);
  end;

  if Result then
  begin
    Result := CreateShortCut(Folder + 'Special Launch 4.lnk', TargetFolder + 'SpLnch.exe', '', '')
      and CreateShortCut(Folder + 'Special Launch 4 セットアップ.lnk', TargetFolder + 'Setup.exe', '', 'ボタンファイルのコンバート、および Special Launch 4 のアンインストールができます。')
      and CreateShortCut(Folder + 'Special Launch 4 ヘルプ.lnk', TargetFolder + 'SpLnch.chm', '', 'Special Launch の操作説明を参照できます。');
  end;
end;

function SetStartup(TargetFolder: String): Boolean;
var
  Folder: String;
begin
  Result := False;
  Folder := GetSpecialFolder(CSIDL_STARTUP);
  if Folder <> '' then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    Result := CreateShortCut(Folder + 'Special Launch 4.lnk', TargetFolder + 'SpLnch.exe', '', '');
  end;

end;

function SetDesktop(TargetFolder: String): Boolean;
var
  Folder: String;
begin
  Result := False;
  Folder := GetSpecialFolder(CSIDL_DESKTOP);
  if Folder <> '' then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    Result := CreateShortCut(Folder + 'Special Launch 4.lnk', TargetFolder + 'SpLnch.exe', '', '');
  end;
end;

function UninstallTemp(DeleteData, DeletePlugins: Boolean): Boolean;
var
  Ini: TIniFile;
  cWork: array[0..255] of Char;
  Folder: String;
begin
  Result := GetTempPath(SizeOf(cWork), cWork) > 0;

  if Result then
  begin
    Folder := cWork;
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';

    Ini := TIniFile.Create(Folder + 'Setup.ini');
    try
      Ini.WriteString('Uninstall', 'Folder', ExtractFileDir(ParamStr(0)));
      Ini.WriteInteger('Uninstall', 'ProcessID', GetCurrentProcessID);
      Ini.WriteBool('Uninstall', 'DeleteData', DeleteData);
      Ini.WriteBool('Uninstall', 'DeletePlugins', DeletePlugins);
    finally
      Ini.Free;
    end;

    Result := CopyFile(PChar(ParamStr(0)), PChar(Folder + 'Setup.exe'), False);
  end;

  if Result then
  begin
    WinExec(PChar('"' + Folder + 'Setup.exe" -deletefile'), SW_SHOW);
  end;
end;

function SL4FileDelete: Boolean;
var
  Ini: TIniFile;
  TargetFolder, ProgramFolder, SpecialFolder, FileName: String;
  ProcessID: DWORD;
  DeleteData, DeletePlugins: Boolean;

  ProcessHandle: THandle;
  FileList: TStringList;
  SectionData: TStringList;

  i: Integer;
  LpFileOp: TSHFILEOPSTRUCT;
begin
  Result := False;
  if Application.MessageBox('Special Launch をコンピュータから削除します。ご利用ありがとうございました。', 'ファイル削除', MB_ICONINFORMATION or MB_OKCANCEL) = idCancel then
    Exit;

  SetCurrentDir(ExtractFileDir(ParamStr(0)));

  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    TargetFolder := Ini.ReadString('Uninstall', 'Folder', '');
    if not IsPathDelimiter(TargetFolder, Length(TargetFolder)) then
      TargetFolder := TargetFolder + '\';
    ProcessID := Ini.ReadInteger('Uninstall', 'ProcessID', 0);
    DeleteData := Ini.ReadBool('Uninstall', 'DeleteData', False);
    DeletePlugins := Ini.ReadBool('Uninstall', 'DeletePlugins', False);
  finally
    Ini.Free;
  end;

  ProcessHandle := OpenProcess(SYNCHRONIZE, False, ProcessID);
  if ProcessHandle <> 0 then
    WaitForSingleObject(ProcessHandle, INFINITE);


  FileList := TStringList.Create;
  SectionData := TStringList.Create;
  try
    // プログラムファイル
    Ini := TIniFile.Create(TargetFolder + 'Setup.ini');
    try
      Ini.ReadSection('Files', SectionData);
      for i := 0 to SectionData.Count - 1 do
      begin
        FileName := Ini.ReadString('Files', SectionData[i], '');
        if FileName <> '' then
          FileList.Add(TargetFolder + FileName);
      end;
    finally
      Ini.Free;
    end;

    // データフォルダ
    if DeleteData then
    begin
      Ini := TIniFile.Create(TargetFolder + 'SpLnch.ini');
      try
        Ini.ReadSection('Users', SectionData);
        for i := 0 to SectionData.Count - 1 do
        begin
          FileName := Ini.ReadString('Users', SectionData[i], '');
          if Length(FileName) > 3 then
          begin
            if IsPathDelimiter(FileName, Length(FileName)) then
              FileName := Copy(FileName, 1, Length(FileName) - 1);
            FileList.Add(FileName);
          end;
        end;
      finally
        Ini.Free;
      end;
      FileList.Add(TargetFolder + 'SpLnch.ini');
    end;

    // プラグインフォルダ
    if DeletePlugins then
      FileList.Add(TargetFolder + 'Plugins');

    // プログラムメニュー
    ProgramFolder := GetSpecialFolder(CSIDL_PROGRAMS);
    if ProgramFolder <> '' then
    begin
      if not IsPathDelimiter(ProgramFolder, Length(ProgramFolder)) then
        ProgramFolder := ProgramFolder + '\';
      ProgramFolder := ProgramFolder + 'Special Launch 4\';
      if FileExists(ProgramFolder + 'Special Launch 4.lnk') then
        FileList.Add(ProgramFolder + 'Special Launch 4.lnk');
      if FileExists(ProgramFolder + 'Special Launch 4 セットアップ.lnk') then
        FileList.Add(ProgramFolder + 'Special Launch 4 セットアップ.lnk');
      if FileExists(ProgramFolder + 'Special Launch 4 ヘルプ.lnk') then
        FileList.Add(ProgramFolder + 'Special Launch 4 ヘルプ.lnk');
    end;
    SpecialFolder := GetSpecialFolder(CSIDL_STARTUP);
    if SpecialFolder <> '' then
    begin
      if not IsPathDelimiter(SpecialFolder, Length(SpecialFolder)) then
        SpecialFolder := SpecialFolder + '\';
      if FileExists(SpecialFolder + 'Special Launch 4.lnk') then
        FileList.Add(SpecialFolder + 'Special Launch 4.lnk');
    end;
    SpecialFolder := GetSpecialFolder(CSIDL_DESKTOP);
    if SpecialFolder <> '' then
    begin
      if not IsPathDelimiter(SpecialFolder, Length(SpecialFolder)) then
        SpecialFolder := SpecialFolder + '\';
      if FileExists(SpecialFolder + 'Special Launch 4.lnk') then
        FileList.Add(SpecialFolder + 'Special Launch 4.lnk');
    end;


    FileName := '';
    for i := 0 to FileList.Count - 1 do
      FileName := FileName + FileList[i] + #0;
    FileName := FileName + #0;

    with LpFileOp do
    begin
      Wnd := Application.Handle;
      wFunc := FO_DELETE;
      pFrom := PChar(FileName);
      pTo:= nil;
      fFlags := FOF_NOCONFIRMATION;
      hNameMappings := nil;
      lpszProgressTitle := nil;
    end;
    Result := SHFileOperation(LpFileOp) = 0;
    DeleteRegistry;

  finally
    FileList.Free;
    SectionData.Free;
  end;

  RemoveDirectory(PChar(ProgramFolder));
  RemoveDirectory(PChar(TargetFolder));
  DeleteFile(ChangeFileExt(ParamStr(0), '.ini'));
  MoveFileEx(PChar(ParamStr(0)), nil, MOVEFILE_DELAY_UNTIL_REBOOT);
end;

end.
