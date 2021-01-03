unit Kind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Memo;

type
  TdlgKind = class(TForm)
    Label1: TLabel;
    edtKind: TEdit;
    btnColor: TButton;
    pnlColor: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    dlgColor: TColorDialog;
    procedure btnColorClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  private
    OwnerForm: TForm;
    FOnApply: TNotifyEvent;
  public
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    constructor CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgKind: TdlgKind;

implementation

{$R *.DFM}

// コンストラクタ
constructor TdlgKind.CreateOwnedForm(AOwner: TComponent; AOwnerForm: TForm);
begin
  OwnerForm := AOwnerForm;
  inherited Create(AOwner);
end;

// CreateParams
procedure TdlgKind.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := OwnerForm.Handle;
end;

procedure TdlgKind.FormDestroy(Sender: TObject);
begin
  dlgKind := nil;
end;

procedure TdlgKind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgKind.btnOkClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
    FOnApply(Self);
end;

procedure TdlgKind.btnColorClick(Sender: TObject);
begin
  dlgColor.Color := pnlColor.Color;
  if dlgColor.Execute then
  begin
    pnlColor.Color := dlgColor.Color;
    pnlColor.Font.Color := GetFontColorFromFaceColor(pnlColor.Color);
  end;
end;

end.
 