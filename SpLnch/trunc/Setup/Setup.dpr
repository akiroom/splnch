program Setup;

uses
  Forms,
  Windows,
  Main in 'Main.pas' {frmMain},
  SetBtn in 'SetBtn.pas',
  pidl in 'pidl.pas',
  SetFuncs in 'SetFuncs.pas';

{$R *.RES}
{$R DATA.RES}

var
  Msg: String;
begin
  if ParamStr(1) = '-deletefile' then
  begin
    SL4FileDelete;
  end
  else
  begin
    if SL4Locked then
    begin
      Msg := 'Special Launch が起動しているか、関連のツールがロックしています。'
        + '該当するプログラムを終了して再度実行してください。';
      MessageBox(GetDesktopWindow, PChar(Msg),
        '確認', MB_ICONINFORMATION);
      Exit;
    end;

    SL4Lock;

    Application.Initialize;
    Application.Title := 'Special Launch セットアップ';
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    SL4Unlock;
  end;
end.
