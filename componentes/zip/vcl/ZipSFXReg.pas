unit ZipSFXReg;

interface
             
procedure Register;

implementation
uses
  Classes, ZipSFX;
    
procedure Register;
begin
  RegisterComponents('Delphi Zip beta', [TZipSFX]);
end; 

end.
