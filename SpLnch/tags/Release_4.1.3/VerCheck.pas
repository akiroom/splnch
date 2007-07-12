unit VerCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, About, mshtml, SetBtn, SetInit, SetPlug;

type
  TdlgVerCheck = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    memInfo: TMemo;
    wbVersion: TWebBrowser;
    lblMessage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure wbVersionNavigateError(ASender: TObject; const pDisp: IDispatch;
      var URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure wbVersionNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    RequestError: Boolean;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgVerCheck: TdlgVerCheck;

implementation

{$R *.dfm}

type
  TNewPluginVersion = class(TObject)
    Name: string;
    CurrentVersion: string;
    Version: string;
    Date: string;
  end;


// �L�����Z���{�^��
procedure TdlgVerCheck.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// OK �{�^��
procedure TdlgVerCheck.btnOkClick(Sender: TObject);
var
  NormalButton: TNormalButton;
begin
  NormalButton := TNormalButton.Create;
  try
    NormalButton.FileName := 'http://splnch.sourceforge.jp/download.php';
    OpenNormalButton(GetDesktopWindow, NormalButton);
  finally
    NormalButton.Free;
  end;
end;

// CreateParams
procedure TdlgVerCheck.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

// ����
procedure TdlgVerCheck.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// ����O
procedure TdlgVerCheck.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Enabled;
end;

// �t�H�[���͂���
procedure TdlgVerCheck.FormCreate(Sender: TObject);
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  RequestError := False;
  wbVersion.Navigate('http://splnch.sourceforge.jp/download.php');
end;

// �t�H�[���I���
procedure TdlgVerCheck.FormDestroy(Sender: TObject);
begin
  dlgVerCheck := nil;
end;

// �ǂݍ��ݏI��
procedure TdlgVerCheck.wbVersionNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  Update: Boolean;
  I: Integer;
  All: IHtmlElementCollection;
  Item: IHtmlElement;
  SLCurrentVersion: string;
  CurrentVersion: string;
  TargetVersion: string;
  NewVersion: string;
  NewDate: string;
  Plugin: TPlugin;
  NewPluginVersion: TNewPluginVersion;
  NewPluginVersionList: TList;

  NextVerCheck: string;
begin
  Update := False;
  if not RequestError then
  begin
    memInfo.Lines.BeginUpdate;
    NewPluginVersionList := TList.Create;
    try
      memInfo.Lines.Clear;
      NewVersion := '';
      NewPluginVersion := nil;
      All := (wbVersion.Document as IHTMLDocument2).all;
      for I := 0 to All.length - 1 do
      begin
        Item := All.item(I, 0) as IHtmlElement;
        if Item.className = 'slversion' then
        begin
          CurrentVersion := GetFileVersionString(ParamStr(0), True);
          TargetVersion := item.innerText;
          if TargetVersion > CurrentVersion then
          begin
            SLCurrentVersion := CurrentVersion;
            NewVersion := TargetVersion;
          end;
        end
        else if (Item.className = 'sldate') then
        begin
          NewDate := item.innerText;
        end
        else if (Item.className = 'plugininnername') then
        begin
          if NewPluginVersion <> nil then
            NewPluginVersionList.Add(NewPluginVersion);
          NewPluginVersion := nil;
          Plugin := Plugins.FindPlugin(item.innerText);
          if Plugin <> nil then
          begin
            CurrentVersion := GetFileVersionString(Plugin.FileName, True);
            NewPluginVersion := TNewPluginVersion.Create;
            NewPluginVersion.Name := item.innerText;
            NewPluginVersion.CurrentVersion := CurrentVersion;
          end;
        end
        else if (Item.className = 'pluginversion') then
        begin
          if NewPluginVersion <> nil then
          begin
            TargetVersion := item.innerText;
            if TargetVersion > NewPluginVersion.CurrentVersion then
              NewPluginVersion.Version := TargetVersion
            else
              NewPluginVersion := nil;
          end;
        end
        else if (Item.className = 'plugindate') then
        begin
          if NewPluginVersion <> nil then
            NewPluginVersion.Date := item.innerText;
        end;
      end;
      if NewPluginVersion <> nil then
        NewPluginVersionList.Add(NewPluginVersion);

      if NewVersion <> '' then
      begin
        Update := True;
        memInfo.Lines.Add('Special Launch �{�̂��o�[�W�����A�b�v���Ă��܂��B');
        if Length(NewDate) > 0 then
          memInfo.Lines.Add(SLCurrentVersion + '��' + NewVersion + '�i' + NewDate + '�j')
        else
          memInfo.Lines.Add(SLCurrentVersion + '��' + NewVersion);
      end;

      if NewPluginVersionList.Count > 0 then
      begin
        if Update then
          memInfo.Lines.Add('');

        Update := True;
        memInfo.Lines.Add('�v���O�C�����o�[�W�����A�b�v���Ă��܂��B');
        for I := 0 to NewPluginVersionList.Count - 1 do
        begin
          NewPluginVersion := NewPluginVersionList[i];
          memInfo.Lines.Add('�y' + NewPluginVersion.Name + '�z');
          if Length(NewPluginVersion.Date) > 0 then
            memInfo.Lines.Add(NewPluginVersion.CurrentVersion + '��' + NewPluginVersion.Version + '�i' + NewPluginVersion.Date + '�j')
          else
            memInfo.Lines.Add(NewPluginVersion.CurrentVersion + '��' + NewPluginVersion.Version);
        end;
      end;
      memInfo.SelStart := 0;
      memInfo.SelLength := 0;

      lblMessage.Font.Style := lblMessage.Font.Style + [fsBold];
      if Update then
      begin
        lblMessage.Caption := '�ŐV�ł� Web �T�C�g����_�E�����[�h�ł��܂��B';
        btnOk.Default := True;
        memInfo.Enabled := True;
      end
      else
      begin
        lblMessage.Caption :='���g���� Special Launch �͍ŐV�o�[�W�����ł��B';
      end;
    finally
      memInfo.Lines.EndUpdate;
      NewPluginVersionList.Free;
    end;

    DateTimeToString(NextVerCheck, 'yyyymmdd', Now + 7);
    UserIniFile.WriteString(IS_OPTIONS, 'NextVerCheck', NextVerCheck);

  end;

  if Visible then
  begin
    if Update then
      btnOk.SetFocus
    else
      btnCancel.SetFocus
  end
  else
  begin
    if Update then
    begin
      Show;
      btnOk.SetFocus;
    end
    else
      Close;
  end;
end;

// �G���[
procedure TdlgVerCheck.wbVersionNavigateError(ASender: TObject;
  const pDisp: IDispatch; var URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  lblMessage.Font.Style := lblMessage.Font.Style + [fsBold];
  lblMessage.Caption := 'Special Launch �̍X�V���m�F�ł��܂���ł����B';
  RequestError := True;
end;

end.