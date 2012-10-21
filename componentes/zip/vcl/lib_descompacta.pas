{
@abstract(Classe para descompactar arquivos zip.)
@created(01 de outubro de 2004)
@lastmod(01 de outubro de 2004)
}
unit lib_descompacta;

interface

uses lib_zip, ZipMstr;


type
   {
   @abstract(Classe para descompactar arquivos zip.)
   @created(01 de outubro de 2004)
   @lastmod(01 de outubro de 2004)
   }
   TDescompacta = class(TZip)

   public

      { Após passar os parametros, use este metodo para iniciar a descompactação do arquivo ZIP }
      procedure Iniciar; overload;
   end;

implementation

procedure TDescompacta.Iniciar;
begin
   inherited;

   with fZipMaster do
   begin
      
      ZipFileName:=Origem;
      { If we don't specify filenames, we will extract them all. }
      { Of course, in this little demo there is only 1 file in the ZIP. }
      //FSpecArgs.Add('*.*');
      ExtrBaseDir:=Destino;
      { if the file to be extracted already exists, overwrite it }
      ExtrOptions:=ExtrOptions+[ExtrOverwrite];
      Extract;

   end;

   DoWorkEnd;

      
end;
end.
