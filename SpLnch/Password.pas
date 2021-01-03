unit Password;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdlgPassword = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edtPassword: TEdit;
    lblMessage: TLabel;
    Label1: TLabel;
    procedure edtPasswordChange(Sender: TObject);
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
  end;

var
  dlgPassword: TdlgPassword;

implementation

{$R *.DFM}

procedure TdlgPassword.edtPasswordChange(Sender: TObject);
begin
  btnOk.Enabled := Length(edtPassword.Text) > 0;
end;

end.
 