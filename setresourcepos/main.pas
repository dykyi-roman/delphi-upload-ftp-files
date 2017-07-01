unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, WinInet;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtURL: TEdit;
    edtFile: TEdit;
    btnDownload: TButton;
    btnStop: TButton;
    ProgressBar: TProgressBar;
    procedure btnDownloadClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FIsDownloading: Boolean;
    FPos: Integer;
    function GetResourceSize(const AURL: string): Integer;
    function DownloadAtPos(const AURL, AFileName: string; APos: Integer): Integer;
    procedure DoProgress(ACompleted: Integer);
    procedure ParseURL(const AURL: string; var AHost, AResource: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnDownloadClick(Sender: TObject);
var
  Size: Integer;
begin
  if FIsDownloading then Exit;
  FIsDownloading := True;
  try
    Size := GetResourceSize(edtURL.Text);
    if (Size = 0) or (not FileExists(edtFile.Text)) then
    begin
      FPos := 0;
    end;
    ProgressBar.Max := Size;
    ProgressBar.Position := FPos;
    FPos := DownloadAtPos(edtURL.Text, edtFile.Text, FPos);
    if (FPos = Size) then
    begin
      FPos := 0;
    end;
    if FIsDownloading then
    begin
      ShowMessage('The file has been downloaded');
    end;
  finally
    FIsDownloading := False;
  end;
end;

function TMainForm.GetResourceSize(const AURL: string): Integer;
var
  hOpen, hConnect, hResource: HINTERNET;
  host, resource: string;
  buflen, tmp: DWORD;
begin
  ParseURL(AURL, host, resource);

  hOpen := InternetOpen('WinInet resuming sample', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  hConnect := InternetConnect(hOpen, PChar(host), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
  hResource := HttpOpenRequest(hConnect, 'HEAD', PChar(resource), nil, nil, nil, 0, 0);
  HttpSendRequest(hResource, nil, 0, nil, 0);

  buflen := SizeOf(Result);
  tmp := 0;
  Result := 0;
  HttpQueryInfo(hResource, HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER,
    @Result, buflen, tmp);

  InternetCloseHandle(hConnect);
  InternetCloseHandle(hOpen);
end;

function TMainForm.DownloadAtPos(const AURL, AFileName: string; APos: Integer): Integer;
const
  FileOpenModes: array[Boolean] of DWORD = (fmCreate, fmOpenWrite);
var
  FileStream: TFileStream;
  hOpen, hConnect, hResource: HINTERNET;
  host, resource: string;
  DataProceed: array[0..8191] of Byte;
  numread: DWORD;
begin
  ParseURL(AURL, host, resource);

  hOpen := InternetOpen('WinInet resuming sample', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  hConnect := InternetConnect(hOpen, PChar(host), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
  hResource := HttpOpenRequest(hConnect, 'GET', PChar(resource), nil, nil, nil, 0, 0);
  HttpSendRequest(hResource, nil, 0, nil, 0);

  Result := APos;
  if (Result > 0) then
  begin
    if not (Integer(InternetSetFilePointer(hResource, Result, nil, FILE_BEGIN, 0)) > 0) then
    begin
      Result := 0;
    end;
  end;
  FileStream := TFileStream.Create(AFileName, FileOpenModes[FileExists(AFileName)]);
  try
    FileStream.Position := Result;
    repeat
      ZeroMemory(@DataProceed, SizeOf(DataProceed));
      InternetReadFile(hResource, @DataProceed, SizeOf(DataProceed), numread);
      if (numread <= 0) then Break;
      FileStream.Write(DataProceed, numread);
      Result := Result + Integer(numread);
      DoProgress(Result);
    until (not FIsDownloading);
  finally
    FileStream.Free();
    InternetCloseHandle(hConnect);
    InternetCloseHandle(hOpen);
  end;
end;

procedure TMainForm.DoProgress(ACompleted: Integer);
begin
  ProgressBar.Position := ACompleted;
  Application.ProcessMessages();
end;

procedure TMainForm.ParseURL(const AURL: string; var AHost, AResource: string);
  procedure CleanArray(var Arr: array of Char);
  begin
    ZeroMemory(Arr + 0, High(Arr) - Low(Arr) + 1);
  end;

var
  UrlComponents: TURLComponents;
  scheme: array[0..INTERNET_MAX_SCHEME_LENGTH - 1] of Char;
  host: array[0..INTERNET_MAX_HOST_NAME_LENGTH - 1] of Char;
  user: array[0..INTERNET_MAX_USER_NAME_LENGTH - 1] of Char;
  password: array[0..INTERNET_MAX_PASSWORD_LENGTH - 1] of Char;
  urlpath: array[0..INTERNET_MAX_PATH_LENGTH - 1] of Char;
  fullurl: array[0..INTERNET_MAX_URL_LENGTH - 1] of Char;
  extra: array[0..1024 - 1] of Char;
begin
  CleanArray(scheme);
  CleanArray(host);
  CleanArray(user);
  CleanArray(password);
  CleanArray(urlpath);
  CleanArray(fullurl);
  CleanArray(extra);
  ZeroMemory(@UrlComponents, SizeOf(TURLComponents));

  UrlComponents.dwStructSize := SizeOf(TURLComponents);
  UrlComponents.lpszScheme := scheme;
  UrlComponents.dwSchemeLength := High(scheme) + 1;
  UrlComponents.lpszHostName := host;
  UrlComponents.dwHostNameLength := High(host) + 1;
  UrlComponents.lpszUserName := user;
  UrlComponents.dwUserNameLength := High(user) + 1;
  UrlComponents.lpszPassword := password;
  UrlComponents.dwPasswordLength := High(password) + 1;
  UrlComponents.lpszUrlPath := urlpath;
  UrlComponents.dwUrlPathLength := High(urlpath) + 1;
  UrlComponents.lpszExtraInfo := extra;
  UrlComponents.dwExtraInfoLength := High(extra) + 1;

  InternetCrackUrl(PChar(AURL), Length(AURL), ICU_DECODE or ICU_ESCAPE, UrlComponents);

  AHost := host;
  AResource := urlpath;
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  FIsDownloading := False;
  ShowMessage('The downloading is stopped');
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FIsDownloading;
  if (not CanClose) then
  begin
    ShowMessage('The downloading is in progress');
  end;
end;

end.
