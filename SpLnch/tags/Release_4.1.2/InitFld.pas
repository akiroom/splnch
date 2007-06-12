unit InitFld;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FileCtrl;


type
  TdlgInitFolder = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edtInitFolder: TEdit;
    Label2: TLabel;
    btnBrowse: TButton;
    pbMessage: TPaintBox;
    imgIcon: TImage;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbMessagePaint(Sender: TObject);
  private
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgInitFolder: TdlgInitFolder;

implementation

{$R *.DFM}

procedure TdlgInitFolder.FormCreate(Sender: TObject);
//var
//  NonClientMetrics: TNonClientMetrics;
begin
  SetClassLong(Handle, GCL_HICON, LoadIcon(hInstance, 'MAINICON'));

  imgIcon.Picture.Icon := Application.Icon;

//  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
//  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
//  Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure TdlgInitFolder.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  SetForegroundWindow(Handle);
end;

procedure TdlgInitFolder.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

procedure TdlgInitFolder.btnBrowseClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if SelectDirectory('データを保存するフォルダを指定してください。', 'desktop', S) then
  begin
    if not IsPathDelimiter(S, Length(S)) then
      S := S + '\';
    if S <> '\' then
      edtInitFolder.Text := S;
  end;
end;

procedure TdlgInitFolder.pbMessagePaint(Sender: TObject);
var
  Msg: String;
  R: TRect;
begin
  Msg := 'Special Launch のデータを保存するフォルダを指定してください。' + #13#10 +
         'このフォルダをバックアップすることで Special Launch の設定等の情報を復旧することができます。';
  R := pbMessage.ClientRect;
  DrawText(pbMessage.Canvas.Handle, PChar(Msg), -1, R, DT_WORDBREAK);
end;

end.
 