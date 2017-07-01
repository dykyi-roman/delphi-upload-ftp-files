unit NetStream;

interface

uses Windows, WinInet, Classes;

type
  EInternetStreamError = EStreamError;
  TNetStream = class(TStream)
  private
    fFile, fSession: HINTERNET;
  public
    constructor Create(AUrl: String; AUser: String = ''; APass: String = '');
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload;override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
  end;

implementation

constructor TNetStream.Create(AUrl: String; AUser: String = ''; APass: String = '');
begin
  inherited Create;
  fSession := InternetOpen(pchar('iexplorer'),INTERNET_OPEN_TYPE_PRECONFIG,nil,
    nil,INTERNET_FLAG_NEED_FILE);
  if(fSession=nil)then
    raise EInternetStreamError.Create('Session can''t create');
  fFile := InternetOpenUrl(fSession,pchar(AUrl),nil,0,INTERNET_FLAG_NEED_FILE,0);
  if(fFile=nil)then
    raise EInternetStreamError.Create('File not found');
end;

destructor TNetStream.Destroy;
begin
  InternetCloseHandle(fFile);
  InternetCloseHandle(fSession);
  inherited Destroy;
end;

function TNetStream.Read(var Buffer; Count: Longint): Longint;
var
  r: Cardinal;
begin
  InternetReadFile(fFile,@Buffer,Count,r);
  Result := r;
end;

function TNetStream.Write(const Buffer; Count: Longint): Longint;
var
  r: Cardinal;
begin
  InternetWriteFile(fFile,@Buffer,Count,r);
  Result := r;
end;

function TNetStream.Seek(Offset: Longint; Origin: Word): Longint;
var
  mm: Cardinal;
begin
  case Origin of
    soFromBeginning: mm := FILE_BEGIN;
    soFromCurrent: mm := FILE_CURRENT;
    soFromEnd: mm := FILE_END;
  else
    mm := FILE_CURRENT;
  end;
  Result := InternetSetFilePointer(fFile,Offset,nil,mm,0);
end;

function TNetStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var
  mm: Cardinal;
begin
  case Origin of
    soBeginning: mm := FILE_BEGIN;
    soCurrent: mm := FILE_CURRENT;
    soEnd: mm := FILE_END;
  else
    mm := FILE_CURRENT;
  end;
  Result := InternetSetFilePointer(fFile,Offset,nil,mm,0);
end;

end.