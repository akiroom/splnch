unit Option;

interface

uses
  Windows, Forms, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls;


type
  TdlgOption = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Image1: TImage;
    Edit1: TEdit;
    udExitDelay: TUpDown;
    Label2: TLabel;
    Label3: TLabel;
    lblShutdown: TLabel;
    rdoShutdown: TRadioButton;
    rdoPowerOff: TRadioButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  dlgOption: TdlgOption;

implementation

{$R *.DFM}

procedure TdlgOption.FormCreate(Sender: TObject);
var
  VerInfo: TOSVersionInfo;
begin
  Image1.Picture.Icon.Handle := LoadIcon(hInstance, 'MAINICON');

  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  if VerInfo.dwPlatformId <> VER_PLATFORM_WIN32_NT then
  begin
    lblShutdown.Enabled := False;
    rdoShutdown.Enabled := False;
    rdoPowerOff.Enabled := False;
  end;


end;

end.
 