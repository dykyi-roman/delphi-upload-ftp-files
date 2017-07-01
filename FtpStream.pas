unit FtpStream;


{************************************************}
{*                                              *}
{*                  SPS Team                    *}
{*                 Year: 2010                   *}
{*               Author: Dukuy R.O.             *}
{*               ICQ: 443-731-743               *}
{*           Mail: free_sps@yahoo.com           *}
{*                                              *}
{************************************************}


interface

uses Windows, WinInet, Classes,SysUtils,Dialogs;

type
  EInterFtpStreamError = EStreamError;
  TFtpStream = class(TStream)
  private
    FHostFileName: string;
    FHostDir: string;
    FHostPort: Integer;
    FFile, FFileSvr, FSession: HINTERNET;

    procedure SetHostFileName(const Value: string);
    procedure SetHostDir(const Value: string);
    procedure SetHostPort(const Value: Integer);
  public
    constructor Create(AHost: String; AUser: String = ''; APass: String = '');
    destructor Destroy; override;
    procedure ShowWinInetError(const AMsg: String);
    procedure ScanFtpDir(const AList: TStrings; sw_CurrDir: Boolean);
    function SetCurrentDir(const AName: string): LongBool;
    function GetCurrentDir(out AName: string): LongBool;
    function CreateDir(const AName: string): LongBool;
    function RenameFile(const AOldName, ANewName: string): LongBool;
    function Read(var Buffer; Count: LongInt): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Delete(const AName: string): LongBool;
  published
    property HostDir: string read FHostDir write SetHostDir;
    property HostFileName: string read FHostFileName write SetHostFileName;
    property HostPort: integer read FHostPort write SetHostPort default 21;
  end;

implementation

constructor TFtpStream.Create(AHost: String; AUser: String = ''; APass: String = '');
begin
  inherited Create;

  // Try connection to internet
  fSession := InternetOpen(pchar('iexplorer'),INTERNET_OPEN_TYPE_PRECONFIG,nil, nil,0);
  if (fSession = nil) then
    raise EInterFtpStreamError.Create('Session can not create');

  // Connection with Fpt Server
   fFileSvr := InternetConnect(
                        fSession,
                        PChar(AHost),
                        FHostPort,
                        PChar(AUser),
                        PChar(APass),
                        INTERNET_SERVICE_FTP,
                        0,
                        0);
  if(fFileSvr = nil)then
    raise EInterFtpStreamError.Create('File not found');
end;

destructor TFtpStream.Destroy;
begin
  InternetCloseHandle(fFile);
  InternetCloseHandle(fFileSvr);
  InternetCloseHandle(fSession);
 inherited Destroy;
end;

procedure TFtpStream.ShowWinInetError(const AMsg: String);
var
  Err, Ext, Len: DWORD;
  Buf: array[0..511] of Char;
  S: String;
  ExtErr: Cardinal;
begin
  Err := GetLastError();
  if Err = ERROR_INTERNET_EXTENDED_ERROR then
  begin
    Len := 512;
    if InternetGetLastResponseInfo(ExtErr, Buf, Len) then
    begin

      S := string(PChar(@Buf));
      S := Format('Error %d: %s', [ExtErr, S]);
    end else begin
      S := 'Unknown Error';
    end;
  end else begin
    S := Format('Error %d: %s', [Err, SysErrorMessage(Err)]);
  end;
  ShowMessage(AMsg + #13 + S);
end;

function TFtpStream.Read(var Buffer; Count: LongInt): Longint;
var
  s: AnsiString;
  DataWritten: Cardinal;
begin
  // Open File
    fFile := FtpOpenFile(
                    fFileSvr,
                    PChar(FHostDir + FHostFileName),
                    GENERIC_READ,
                    FTP_TRANSFER_TYPE_BINARY,
                    0);
   if(fFile = nil)then
    raise EInterFtpStreamError.Create('can not open file on path: ' + FHostDir + FHostFileName);

  // Rread File
  try
    if not InternetReadFile(FFile, @buffer, Count, DataWritten) then
     raise EInterFtpStreamError.Create('can not read file on path: ' + FHostDir + FHostFileName);
  finally
   Result := DataWritten;
   InternetCloseHandle(FFile);
  end;
end;

function TFtpStream.CreateDir(const AName: string): LongBool;
begin
  if not FtpCreateDirectory(FFileSvr,PChar(AName)) then
   begin
    Result := false;
    raise EInterFtpStreamError.Create('Can not Create dir: ' +  AName);
   end
    else
      Result := True;
end;

function TFtpStream.SetCurrentDir(const AName: string): LongBool;
begin
  if not FtpSetCurrentDirectory(FFileSvr,PChar(AName)) then
   begin
    Result := false;
    raise EInterFtpStreamError.Create('Can not Set Current dir: ' +  AName);
   end
    else
      Result := True;
end;

function TFtpStream.GetCurrentDir(out AName: string): LongBool;
var
 r: DWORD;
 nam: array[1..255] of char;
 s: string;
 p: Integer;
begin
  r := SizeOf(nam);
  if not FtpGetCurrentDirectory(FFileSvr,@nam,&r) then
   begin
    Result := false;
    raise EInterFtpStreamError.Create('Can not Get Current dir');
   end
    else
     begin
      AName := string(PChar(@nam));
      Result := True;
     end;
end;

function TFtpStream.RenameFile(const AOldName, ANewName: string): LongBool;
begin
  if not FtpRenameFile(FFileSvr,PChar(AOldName),PChar(ANewName)) then
   begin
    Result := false;
    raise EInterFtpStreamError.Create('Can not Rename File: ' +  AOldName + ' to ' + ANewName);
   end
    else
      Result := True;
end;

function TFtpStream.Delete(const AName: string): LongBool;
begin
  if not FtpDeleteFile(FFileSvr,PChar(AName)) then
   begin
    Result := false;
    raise EInterFtpStreamError.Create('Can not delete file: ' + AName);
   end
    else
      Result := True;
end;


function TFtpStream.Write(const Buffer; Count: LongInt): Longint;
var
  s: AnsiString;
  DataWritten: Cardinal;
begin
  // Open File
    fFile := FtpOpenFile(
                    fFileSvr,
                    PChar(FHostDir + FHostFileName),
                    GENERIC_WRITE,
                    FTP_TRANSFER_TYPE_BINARY,
                    0);
   if(fFile = nil)then
    raise EInterFtpStreamError.Create('can not open file on path: ' + FHostDir + FHostFileName);

  // Write File
  try
    if not InternetWriteFile(FFile, @buffer, Count, DataWritten) then
     raise EInterFtpStreamError.Create('can not write file on path: ' + FHostDir + FHostFileName);
  finally
   Result := DataWritten;
   InternetCloseHandle(FFile);
  end;
end;

procedure TFtpStream.ScanFtpDir(const AList: TStrings; sw_CurrDir: Boolean);
var
  hSearch: HINTERNET;
  findData: WIN32_FIND_DATA;
  cur_dir,tmp: string;
begin
  hSearch := FtpFindFirstFile(FFileSvr,nil,findData,0,0);
  if (hSearch = nil) then
   raise EInterFtpStreamError.Create('Can not find file');
   try
    GetCurrentDir(cur_dir);
    IncludeTrailingBackslash(cur_dir);
    repeat
     tmp := string(Pchar(@findData.cFileName));
     if sw_CurrDir then tmp := cur_dir + tmp;
     AList.Add(tmp); tmp := '';
    until not InternetFindNextFile(hSearch,@findData);
   finally
    InternetCloseHandle(hSearch);
   end;
end;

procedure TFtpStream.SetHostFileName(const Value: string);
begin
  if Value <> FHostFileName then
   FHostFileName := Value;
end;

procedure TFtpStream.SetHostPort(const Value: Integer);
begin
  if Value <> FHostPort then
   FHostPort := Value;
end;

procedure TFtpStream.SetHostDir(const Value: string);
begin
  if Value <> FHostDir then
   FHostDir := Value;
end;


end.
