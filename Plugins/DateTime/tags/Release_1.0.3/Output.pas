unit Output;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles, Memo;

type
  TdlgOutput = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    rdoMedia: TRadioGroup;
    chkHeader: TCheckBox;
    chkCSV: TCheckBox;
    chkSelected: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  dlgOutput: TdlgOutput;

implementation

{$R *.DFM}

procedure TdlgOutput.FormCreate(Sender: TObject);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    rdoMedia.ItemIndex := Ini.ReadInteger('Output', 'Media', rdoMedia.ItemIndex);
    chkHeader.Checked := Ini.ReadBool('Output', 'Header', chkHeader.Checked);
    chkCSV.Checked := Ini.ReadBool('Output', 'CSV', chkCSV.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TdlgOutput.btnOkClick(Sender: TObject);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(InitFileName);
  try
    Ini.WriteInteger('Output', 'Media', rdoMedia.ItemIndex);
    Ini.WriteBool('Output', 'Header', chkHeader.Checked);
    Ini.WriteBool('Output', 'CSV', chkCSV.Checked);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
