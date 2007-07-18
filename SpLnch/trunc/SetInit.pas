unit SetInit;

interface

uses
  Windows, SysUtils, Forms, IniFiles;

var
  UserName: string;
  UserFolder: string;
  UserIniFile: TIniFile = nil;
  UserIniReadOnly: Boolean = False;

function LoadAppInit: Boolean;

const
  // アプリケーションルートの設定
  IS_USERS = 'Users';
  IS_APPGENERAL = 'General';

  // ユーザー別の設定
  IS_USER = 'User';
  IS_PADS = 'Pads';
  IS_SOUNDS = 'Sounds';
  IS_RESTRICTIONS = 'Restrictions';
  IS_COMMANDLINE = 'CommandLine';
  IS_ENABLEPLUGINS = 'EnablePlugins';
  IS_DISABLEPLUGINS = 'DisablePlugins';
  IS_PADSZORDER = 'PadsZOrder';
  IS_WINDOWS = 'Windows';
  IS_OPTIONS = 'Options';

  // パッドの設定
  IS_GENERAL = 'General';
  IS_PADOPTIONS = 'PadOptions';

var
  FileNameIni: String;
  FileNameIco: String = 'Icons.dat';


implementation

uses
  InitFld;

function LoadAppInit: Boolean;
var
  SettingForAllUser: Boolean;
  cWork: array[0..255] of Char;
  UserSize: DWORD;
  Ini: TIniFile;
  UserInit: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  UnknownFileExist: Boolean;
begin
  Result := True;

  // Iniファイルの名前
  FileNameIni := ExtractFileName(ChangeFileExt(ParamStr(0), '.ini'));


  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    SettingForAllUser := Ini.ReadBool(IS_APPGENERAL, 'SettingForAllUser', False);

    UserName := 'Default';
    if not SettingForAllUser then
    begin
      // 現在のユーザー名を取得
      UserSize := 255;
      if GetUserName(cWork, UserSize) then
        UserName := StrPas(cWork)
    end;

    // ユーザーフォルダを取得
    UserFolder := Ini.ReadString(IS_USERS, UserName, '');
  finally
    Ini.Free;
  end;

  // ユーザー設定ファイル
  if UserFolder = '' then
    UserInit := ''
  else
  begin
    if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
      UserFolder := UserFolder + '\';
    UserInit := UserFolder + FileNameIni;
  end;

  // ユーザー設定ファイルがない
  if not FileExists(UserInit) then
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'Setup.ini') then
      Application.MessageBox(
        PChar('Special Launch をご利用いただき、誠にありがとうございます。' + #13#10 +
       #13#10 +
       'Special Launch の設定は、このあと指定するデータフォルダにすべて保存されます。' +
       'Special Launch の設定をバックアップしたい場合は、そのデータフォルダ内の' +
       'ファイルをすべてバックアップしてください。'),
       'Special Launch', MB_ICONINFORMATION);


    dlgInitFolder := TdlgInitFolder.Create(nil);
    try
      UserFolder := ExtractFilePath(ParamStr(0)) + UserName + '\';
      dlgInitFolder.edtInitFolder.Text := UserFolder;
      while True do
      begin
        // ダイアログの表示
        if dlgInitFolder.ShowModal = idOk then
        begin
          UserFolder := dlgInitFolder.edtInitFolder.Text;

          if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
            UserFolder := UserFolder + '\';
          UserInit := UserFolder + FileNameIni;

          // 指定のフォルダにユーザー設定ファイルがある
          if FileExists(UserInit) then
          begin
            if Application.MessageBox(PChar('指定のフォルダ "' + UserFolder +
                                            '" にはすでに設定があります。この設定を利用しますか？'),
                                      '確認', MB_ICONQUESTION or MB_YESNO) = idYes then
              Break;
          end
          else if DirectoryExists(UserFolder) then
          begin
            UnknownFileExist := False;
            FindHandle := FindFirstFile(PChar(UserFolder + '*.*'), Win32FindData);
            if FindHandle <> INVALID_HANDLE_VALUE then
            begin
              while True do
              begin
                if (Win32FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
                begin
                  UnknownFileExist := True;
                  Break;
                end;

                if not FindNextFile(FindHandle, Win32FindData) then
                  Break;
              end;
              Windows.FindClose(FindHandle)
            end;

            if UnknownFileExist then
            begin
              if Application.MessageBox(PChar('指定のフォルダ "' + UserFolder +
                                            '" にはすでに設定以外のファイルが存在しています。' +
                                            'このまま続行してよろしいですか?'),
                                        '確認', MB_ICONQUESTION or MB_YESNO) = idYes then
                Break;
            end
            else
            begin
              if Application.MessageBox(PChar('指定のフォルダ "' + UserFolder + '" に設定を保存します。'),
                                        '確認', MB_ICONINFORMATION or MB_OKCANCEL) = idOK then
                Break;
            end;
          end
          else
          begin
            try
              ForceDirectories(UserFolder);
              if DirectoryExists(UserFolder) then
                Break
              else
                Application.MessageBox(PChar('指定のフォルダ "' + UserFolder +
                                             '" は作成できませんでした。正しいフォルダ名を指定してください。'),
                                    'エラー', MB_ICONSTOP);
            except
              Application.MessageBox(PChar('指定のフォルダ "' + UserFolder +
                                           '" は作成できませんでした。正しいフォルダ名を指定してください。'),
                                    'エラー', MB_ICONSTOP);
            end;
          end;

        end
        else
        begin
          Result := False;
          Break;
        end;

      end;

    finally
      dlgInitFolder.Release;
    end;

    if Result then
    begin
      // ユーザーフォルダを保存
      Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      try
        try
          Ini.WriteString(IS_USERS, UserName, UserFolder);
        except
          Result := False;
          Application.MessageBox(PChar('設定ファイル "' + Ini.FileName + '" に書き込めません。'),
                                 'エラー', MB_ICONSTOP);
        end;
      finally
        Ini.Free;
      end;
    end;

  end;

  if not Result then
    Exit;




  // ユーザー設定ファイルを作成
  UserIniFile := TIniFile.Create(UserInit);
  if UserIniFile.ReadString(IS_USER, 'Name', '') = '' then
  begin
    UserIniReadOnly := False;
    try
      UserIniFile.WriteString(IS_USER, 'Name', UserName);
      UserIniFile.UpdateFile;
    except
      Result := False;
      UserIniFile.Free;
      UserIniFile := nil;
      Application.MessageBox(PChar('設定ファイル "' + UserInit +
                                   '" に書き込めません。'),
                             'エラー', MB_ICONSTOP);
    end;
  end
  else
  begin
    UserIniReadOnly := False;
    FindHandle := FindFirstFile(PChar(UserInit), Win32FindData);
    if FindHandle <> INVALID_HANDLE_VALUE then
    begin
      // 読み取り専用属性（CD-R等）
      if (Win32FindData.dwFileAttributes and FILE_ATTRIBUTE_READONLY) <> 0 then
      begin
        UserIniReadOnly := True;
      end;
      Windows.FindClose(FindHandle)
    end;
    if not UserIniReadOnly then
    begin
      try
        UserIniFile.WriteString(IS_USER, 'Name', UserName);
        UserIniFile.UpdateFile;
      except
        // 書き込み時エラー
        UserIniReadOnly := True;
      end;
    end;
  end;


end;

end.
