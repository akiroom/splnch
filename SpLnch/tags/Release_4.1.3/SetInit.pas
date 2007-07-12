unit SetInit;

interface

uses
  Windows, SysUtils, Forms, IniFiles;

var
  UserName: string;
  UserFolder: string;
  UserIniFile: TIniFile = nil;

function LoadAppInit: Boolean;

const
  IS_GENERAL = 'General';
  IS_OPTIONS = 'Options';
  IS_PADOPTIONS = 'PadOptions';


var
  FileNameIni: String;
  FileNameIco: String = 'Icons.dat';


implementation

uses
  InitFld;

function LoadAppInit: Boolean;
var
  cWork: array[0..255] of Char;
  UserSize: DWORD;
  Ini: TIniFile;
  UserInit: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  UnknownFileExist: Boolean;
begin
  Result := True;

  // Ini�t�@�C���̖��O
  FileNameIni := ExtractFileName(ChangeFileExt(ParamStr(0), '.ini'));


  // ���݂̃��[�U�[�����擾
  UserSize := 255;
  if not GetUserName(cWork, UserSize) then
    cWork := '';
  if cWork = '' then
    cWork := 'Default';
  UserName := StrPas(cWork);

  // ���[�U�[�t�H���_���擾
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    UserFolder := Ini.ReadString('Users', UserName, '');
  finally
    Ini.Free;
  end;

  // ���[�U�[�ݒ�t�@�C��
  if UserFolder = '' then
    UserInit := ''
  else
  begin
    if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
      UserFolder := UserFolder + '\';
    UserInit := UserFolder + FileNameIni;
  end;

  // ���[�U�[�ݒ�t�@�C�����Ȃ�
  if not FileExists(UserInit) then
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'Setup.ini') then
      Application.MessageBox(
        PChar('Special Launch �������p���������A���ɂ��肪�Ƃ��������܂��B' + #13#10 +
       #13#10 +
       'Special Launch �̐ݒ�́A���̂��Ǝw�肷��f�[�^�t�H���_�ɂ��ׂĕۑ�����܂��B' +
       'Special Launch �̐ݒ���o�b�N�A�b�v�������ꍇ�́A���̃f�[�^�t�H���_����' +
       '�t�@�C�������ׂăo�b�N�A�b�v���Ă��������B'),
       'Special Launch', MB_ICONINFORMATION);


    dlgInitFolder := TdlgInitFolder.Create(nil);
    try
      UserFolder := ExtractFilePath(ParamStr(0)) + UserName;
      if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
        UserFolder := UserFolder + '\';

      while True do
      begin

        // �_�C�A���O�̕\��
        dlgInitFolder.edtInitFolder.Text := UserFolder;
        if dlgInitFolder.ShowModal = idOk then
        begin
          UserFolder := dlgInitFolder.edtInitFolder.Text;

          if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
            UserFolder := UserFolder + '\';
          UserInit := UserFolder + FileNameIni;

          // �w��̃t�H���_�Ƀ��[�U�[�ݒ�t�@�C��������
          if FileExists(UserInit) then
          begin
            if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                            '" �ɂ͂��łɐݒ肪����܂��B���̐ݒ�𗘗p���܂����H'),
                                      '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
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
              if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                            '" �ɂ͂��łɐݒ�ȊO�̃t�@�C�������݂��Ă��܂��B' +
                                            '���̂܂ܑ��s���Ă�낵���ł���?'),
                                        '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
                Break;
            end
            else
            begin
              if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder + '" �ɐݒ��ۑ����܂��B'),
                                        '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOK then
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
                Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                             '" �͍쐬�ł��܂���ł����B�������t�H���_�����w�肵�Ă��������B'),
                                    '�G���[', MB_ICONSTOP);
            except
              Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                           '" �͍쐬�ł��܂���ł����B�������t�H���_�����w�肵�Ă��������B'),
                                    '�G���[', MB_ICONSTOP);
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

    // ���[�U�[�t�H���_��ۑ�
    Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    try
      try
        Ini.WriteString('Users', UserName, UserFolder);
      except
        Result := False;
        Application.MessageBox(PChar('�ݒ�t�@�C�� "' + Ini.FileName + '" �ɏ������߂܂���B'),
                               '�G���[', MB_ICONSTOP);
      end;
    finally
      Ini.Free;
    end;

  end;

  if not Result then
    Exit;




  // ���[�U�[�ݒ�t�@�C�����쐬
  UserIniFile := TIniFile.Create(UserInit);
  try
    UserIniFile.WriteString('User', 'Name', UserName);
    UserIniFile.UpdateFile;
  except
    Result := False;
    UserIniFile.Free;
    UserIniFile := nil;
    Application.MessageBox(PChar('�ݒ�t�@�C�� "' + UserInit +
                                 '" �ɏ������߂܂���B'),
                           '�G���[', MB_ICONSTOP);
  end;

end;

end.
