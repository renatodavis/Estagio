unit ZipMstrReg;

interface
             
procedure Register;

implementation

uses
  Classes, ZipMstr;
    
procedure Register;
begin
  RegisterComponents('Delphi Zip', [TZipMaster]);
end;

end.
