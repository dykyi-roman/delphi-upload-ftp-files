unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, StdCtrls ;

type
  TForm1 = class(TForm)
    Button4: TButton;
    Memo1: TMemo;
    btnRead: TButton;
    Button6: TButton;
    btnFree: TButton;
    btnCreate: TButton;
    btnWrite: TButton;
    edwrite: TEdit;
    Button5: TButton;
    btnDelete: TButton;
    btnrename: TButton;
    btnCreateDir: TButton;
    Button1: TButton;
    Button2: TButton;
    Button7: TButton;
    procedure Button4Click(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btnFreeClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCreateDirClick(Sender: TObject);
    procedure btnrenameClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private


  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


uses WinInet,FtpStream;

{$R *.dfm}

var    FTPStream: TFtpStream;

{
  http://netcode.ru/cpp/?lang=&katID=19&skatID=164&artID=5004
}

procedure ShowWinInetError(const AMsg: String);
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

      SetString(S, Buf, Len);
      S := Format('Error %d: %s', [ExtErr, S]);
    end else begin
      S := 'Unknown Error';
    end;
  end else begin
    S := Format('Error %d: %s', [Err, SysErrorMessage(Err)]);
  end;
  ShowMessage(AMsg + #13 + S);
end;

function DownloadFile(
    const url: string;
    const destinationFileName: string): boolean;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  localFile: File;
  buffer: array[1..1023] of byte;
  bytesRead: DWORD;


    f1,f2:text;
    I: integer;


       stream: TStream;

  f3: Integer;

begin
  result := False;
  hInet := InternetOpen(PChar(application.title),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin

     for I := 1 to 1024 do
      buffer[i] := 0;


{  f3 := FileCreate('e:\2.txt');
  try
    if not InternetReadFile(hFile, @buffer, SizeOf(buffer), bytesRead) then
    begin
      ShowMessage('error');
    end else begin
      FileWrite(f3, @buffer[0], bytesRead);
    end;
  finally
    FileClose(f3);                        }

    AssignFile(localFile,destinationFileName);
    Rewrite(localFile,1);
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      BlockWrite(localFile,buffer,bytesRead);
    until bytesRead = 0;
    CloseFile(localFile);

    result := true;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 s: String;
begin
 if FtpStream.GetCurrentDir(s) then
   ShowMessage('Current Dir: "' + s + '"');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if FtpStream.SetCurrentDir('/htdocs/') then
 ShowMessage('Sucassful');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 if DownloadFile(
    'http://www.jurnalist.ho.ua/my/file/3.png',
    'e:\5.png')
then
  ShowMessage('Success')
else
  ShowMessage('Failed to download file');
end;

procedure TForm1.Button5Click(Sender: TObject);
var

 DataWritten: Cardinal;
 P: Pointer;
 buf: array[1..1024] of Byte;

 localFile: file;
  bytesRead: DWORD;
begin

  try
   P := AllocMem(sizeof(buf));
   p := @buf;

    AssignFile(localFile,'e:\1.txt');
      Rewrite(localFile,1);
       DataWritten := FTPStream.Read(P^,SizeOf(buf));
       BlockWrite(localFile,buf,DataWritten);

  finally
    CloseFile(localFile);
  end;
end;

procedure TForm1.btnReadClick(Sender: TObject);
 var
   s: AnsiString;
   DataWritten: Cardinal;
   P: Pointer;
   buf: array[1..1024] of Byte;
begin
   P := AllocMem(sizeof(buf));
   p := @buf;
   DataWritten := FTPStream.Read(P^,SizeOf(buf));

   // читаєм текст з файлу
   SetString(s,PAnsiChar(P), DataWritten);
   Memo1.Lines.Clear;
   Memo1.Lines.Add(s);
end;

procedure TForm1.btnrenameClick(Sender: TObject);
begin
if FtpStream.RenameFile('/htdocs/2.txt','/htdocs/1.txt')
 then ShowMessage('Succesfull');
end;

procedure TForm1.btnWriteClick(Sender: TObject);
var
   str: AnsiString;
   P: PByte;
   DataWritten: Cardinal;
begin
   str := edwrite.Text + #13#10 + 'new str';
   p := Pbyte(Pointer(str));
   DataWritten := FTPStream.Write(P^,Length(Str) * SizeOf(AnsiChar));
end;

procedure TForm1.Button6Click(Sender: TObject);

procedure ftp(var buffer; Count: Cardinal);
var
 d: AnsiString;
 r: Cardinal;
begin
 SetString(d,PAnsiChar(@buffer),Count);
 ShowMessage(d);
end;

 var
  p: PByte;
  s: string[10];
  str: AnsiString;
begin
  str := 'ftpStreem string';
  p := Pbyte(Pointer(str));
  // p := @s;

  ftp(p^,Length(Str) * SizeOf(AnsiChar));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 FtpStream.ScanFtpDir(Memo1.Lines, true);
end;

procedure TForm1.btnCreateDirClick(Sender: TObject);
begin
if FtpStream.CreateDir('/htdocs/my/xp')
 then ShowMessage('Succesfull');
end;

procedure TForm1.btnCreateClick(Sender: TObject);
begin
  FTPStream := TFtpStream.Create('jurnalist.ho.ua','jurnalist','N3NQaBq0kR');
  FTPStream.HostDir := '/htdocs/my/';
  FTPStream.HostFileName := '1.txt';
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
if FtpStream.Delete('/htdocs/2.txt')
 then ShowMessage('Succesfull')

end;

procedure TForm1.btnFreeClick(Sender: TObject);
begin
   FTPStream.Free;
end;

end.
