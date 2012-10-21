{
@abstract(Classe para compactar arquivo ou diretorio para ZIP.)
@created(01 de outubro de 2004)
@lastmod(01 de outubro de 2004)
}
unit lib_compacta;

interface

uses lib_zip,QForms, SysUtils, Classes, ZipMstr, QComCtrls;

type
   {
   @abstract(Classe para compactar arquivo ou diretorio para ZIP.)
   @created(01 de outubro de 2004)
   @lastmod(01 de outubro de 2004)
   }
   TCompacta = class(TZip)

   public
      { Utilize este método para iniciar a compactação do arquivo ou diretório }
      procedure Iniciar; 
   end;

implementation

procedure TCompacta.Iniciar;
begin
   inherited;
   //caso seja diretorio compactar todos os subdiretorios
   if DirectoryExists(FOrigem) then
      FZipMaster.AddOptions:=[AddDirNames, AddRecurseDirs,AddSeparateDirs];

   fZipMaster.ZipFileName:=fDestino;
   fZipMaster.FSpecArgs.Add(fOrigem);
   fZipMaster.Add;

   DoWorkEnd;

end;

end.
