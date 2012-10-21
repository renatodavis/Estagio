unit ZipXcpt;

(* Exception class for ZipMaster
  - retrieves all strings via ZipStrs.ZipLoadStr
*)
interface

uses
  SysUtils;

type
  EZipMaster = class(Exception)
  public
    FDisplayMsg: Boolean; // We do not always want to see a message after an exception.
    // We also save the Resource ID in case the resource is not linked in the application.
    FResIdent: Integer;

    constructor Create(const msg: String);
    constructor CreateResFmt(Ident: Integer; const Args: array of const);
    constructor CreateDisp(const Message: String; const Display: Boolean);
    constructor CreateResDisp(Ident: Integer; const Display: Boolean);
    constructor CreateResDisk(Ident: Integer; const DiskNo: Shortint);
    constructor CreateResDrive(Ident: Integer; const Drive: String);
    constructor CreateResFile(Ident: Integer; const File1, File2: String);
    property ResId: Integer Read FResIdent;
  end;


implementation

uses
  ZipStrs, ZipMsg;

const              {
  RESOURCE_ERROR: string  =
    'ZipMsgXX.res is probably not linked to the executable' + #10 +
    'Missing String ID is: %d ';    }
  RESOURCE_ERROR1: String =
    #10 + 'ZipMsgXX.res is probably not linked to the executable';

constructor EZipMaster.Create(const msg: String);
begin
  inherited Create(msg);
  FDisplayMsg := True;
  FResIdent   := DS_UnknownError;
end;

constructor EZipMaster.CreateResFmt(Ident: Integer; const Args: array of const);
begin
  inherited Create(ZipLoadStr(Ident));

  if Message = '' then
    Message := Format('id = %d %s', [ident, RESOURCE_ERROR1])
  else
    Message := Format(Message, Args);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

constructor EZipMaster.CreateDisp(const Message: String; const Display: Boolean);
begin
  inherited Create(Message);
  FDisplayMsg := Display;
end;

constructor EZipMaster.CreateResDisp(Ident: Integer; const Display: Boolean);
begin
  inherited Create(ZipLoadStr(Ident));

  if Message = '' then
    Message := Format('id = %d %s', [ident, RESOURCE_ERROR1]);
  FDisplayMsg := Display;
  FResIdent := Ident;
end;

constructor EZipMaster.CreateResDisk(Ident: Integer; const DiskNo: Shortint);
begin
  inherited Create(ZipLoadStr(Ident));

  if Message = '' then
    Message := Format('id = %d [disk = %d]%s', [ident, DiskNo, RESOURCE_ERROR1])
  else
    Message := Format(Message, [DiskNo]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

constructor EZipMaster.CreateResDrive(Ident: Integer; const Drive: String);
begin
  inherited Create(ZipLoadStr(Ident));

  if Message = '' then
    Message := Format('id = %d [drive = %s]%s', [ident, Drive, RESOURCE_ERROR1])
  else
    Message := Format(Message, [Drive]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

constructor EZipMaster.CreateResFile(Ident: Integer; const File1, File2: String);
begin
  inherited Create(ZipLoadStr(Ident));

  if Message = '' then
    Message := Format('id = %d [files = %s, %s]%s', [ident, File1,
      File2, RESOURCE_ERROR1])
  else
    Message := Format(Message, [File1, File2]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

end.
