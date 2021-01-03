unit InAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, W2k;


type
  TdlgInAlpha = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    tbAlpha: TTrackBar;
    lblPercent: TLabel;
    imgIcon: TImage;
    procedure tbAlphaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    hWnd: HWND;
  end;

var
  dlgInAlpha: TdlgInAlpha;

implementation

{$R *.DFM}

procedure TdlgInAlpha.tbAlphaChange(Sender: TObject);
var
  Alpha: Integer;
begin
  lblPercent.Caption := IntToStr(tbAlpha.Position * 100 div 255) + '%';
  Alpha := tbAlpha.Position;
  MySetLayeredWindowAttributes(hWnd, 0, Byte(Alpha), LWA_ALPHA);
end;

procedure TdlgInAlpha.FormCreate(Sender: TObject);
begin
  imgIcon.Picture.Icon.Handle := LoadIcon(hInstance, 'MAINICON');
end;

end.
