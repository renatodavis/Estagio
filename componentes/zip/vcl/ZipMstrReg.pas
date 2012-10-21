unit ZipMstrReg;

interface
             
procedure Register;

implementation

uses
  Classes, ZipMstr;
    
procedure Register;
begin
  RegisterComponents('Delphi Zip beta', [TZipMaster]);
end;

end.
