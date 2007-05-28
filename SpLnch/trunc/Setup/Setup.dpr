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
      Msg := 'Special Launch ���N�����Ă��邩�A�֘A�̃c�[�������b�N���Ă��܂��B'
        + '�Y������v���O�������I�����čēx���s���Ă��������B';
      MessageBox(GetDesktopWindow, PChar(Msg),
        '�m�F', MB_ICONINFORMATION);
      Exit;
    end;

    SL4Lock;

    Application.Initialize;
    Application.Title := 'Special Launch �Z�b�g�A�b�v';
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    SL4Unlock;
  end;
end.
