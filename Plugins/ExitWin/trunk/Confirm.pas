unit Confirm;

interface

uses
  Windows, Forms, Controls, StdCtrls, Classes, ExtCtrls, SysUtils, ImgList;

type
  TExitKind = (ekShutdown, ekReboot, ekLogoff);
  TfrmConfirm = class(TForm)
    imgIcon: TImage;
    lblMessage: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    tmDelay: TTimer;
    procedure tmDelayTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    DelayRest: Integer;
  end;

procedure RunExitWindows(Kind: TExitKind; Delay: Integer);

var
  frmConfirm: TfrmConfirm = nil;
  InitFileName: string;
  ExitDelay: Integer;
  PowerOff: Boolean;


implementation

{$R *.DFM}

procedure RunExitWindows(Kind: TExitKind; Delay: Integer);
var
  ComLine, Msg, IconName: String;
  DLLFile: array[0..255] of Char;
  VerInfo: TOSVersionInfo;
begin
  if frmConfirm <> nil then
    Exit;

  GetModuleFileName(HInstance, DLLFile, SizeOf(DLLFile));
  ComLine := ExtractFilePath(DLLFile) + 'ShtOp.exe ';

  case Kind of
    ekShutdown:
    begin
      VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
      GetVersionEx(VerInfo);
      if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      begin
        if PowerOff then
          ComLine := Comline + 'PowerOff'
        else
          ComLine := Comline + 'Shutdown';
      end
      else
        ComLine := Comline + 'Shutdown';


      Msg := 'Windows をシャットダウンします。';
      IconName := 'MAINICON1';
    end;
    ekReboot:
    begin
      ComLine := Comline + 'Reboot';
      Msg := 'Windows を再起動します。';
      IconName := 'MAINICON2';
    end;
    ekLogoff:
    begin
      ComLine := Comline + 'Logoff';
      Msg := 'Windows からログオフします。';
      IconName := 'MAINICON3';
    end;
  end;

  frmConfirm := TfrmConfirm.Create(nil);
  try

    frmConfirm.lblMessage.Caption := Msg;
    frmConfirm.DelayRest := Delay;
    frmConfirm.imgIcon.Picture.Icon.Handle := LoadIcon(hInstance, PChar(IconName));

    if (Delay <= 0) or (frmConfirm.ShowModal = idOk) then
    begin
      WinExec(PChar(ComLine), SW_SHOW);
    end;
  finally
    frmConfirm.Release;
    frmConfirm := nil;
  end;
end;

{ TfrmConfirm }

procedure TfrmConfirm.tmDelayTimer(Sender: TObject);
begin
  Dec(DelayRest);
  btnOk.Caption := '終了まで ' + IntToStr(DelayRest) + '秒';
  if DelayRest <= 0 then
    ModalResult := mrOk;
end;

procedure TfrmConfirm.FormShow(Sender: TObject);
begin
  btnOk.Caption := '終了まで ' + IntToStr(DelayRest) + '秒';
end;

end.
