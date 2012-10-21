{
@abstract(Classe base para operacoes com arquivos zip.)
@created(01 de outubro de 2004)
@lastmod(01 de outubro de 2004)
}
unit lib_zip;

interface

uses QForms, SysUtils, Classes, ZipMstr, QComCtrls;

type


   //procedure para ser usanda pelo programador para manipular
   //o evento OnProgress da operacao com o arquivo zip
   TProgress = procedure(Sender: TObject; TamanhoArquivo,
      PercentualConcluido : Real) of object;

   TWorkBegin = procedure(Sender: TObject) of object;
   TWorkEnd = procedure(Sender: TObject) of object;

   {
   @abstract(Classe base para operacoes com arquivos zip.)
   @created(01 de outubro de 2004)
   @lastmod(01 de outubro de 2004)
   }
   TZip = class(TComponent)

   protected
      FOnProgress : TProgress;
      FOnWorkBegin: TWorkBegin;
      FOnWorkEnd : TWorkEnd;

      { Usado para fazer a compressao/descompressao }
      FZipMaster : TZipMaster;

      { Arquivo que será compactado ou descompactado }
      FOrigem: String;

      { Arquivo ZIP que será gerado ou o diretorio de destino, qdo estiver
      descompactando }
      FDestino : String;

   private
      function getOrigem: String;
      procedure setOrigem(const Value: String);
      function getDestino: String;
      procedure setDestino(const Value: String);

      procedure ZipMasterTotalProgress(Sender: TObject; TotalSize: Cardinal;
        PerCent: Integer);

   protected
      //
      procedure DoProgress(TamanhoArquivo, PercentualConcluido : Real);
      procedure DoWorkBegin();
      procedure DoWorkEnd();
   public
      constructor Create(AOwner: TComponent); reintroduce;
      destructor Destroy; reintroduce;

      { Método utilizado para iniciar a operacao com arquivos zip }
      procedure Iniciar;

   published
      { Indique o arquivo de origem para a operacao ser realizada}
      property Origem : String read getOrigem write setOrigem;

      { Arquivo de destino para a operacao ser realizada }
      property Destino : String read getDestino write setDestino;


      //evento OnProgress :)
      property OnProgress : TProgress read FOnProgress write FOnProgress;

      //evento.. ao iniciar o zip
      property OnWorkBegin : TWorkBegin read FOnWorkBegin write FOnWorkBegin;

      //evento ao terminar o zip
      property OnWorkEnd : TWorkEnd read FOnWorkEnd write FOnWorkEnd;
   end;

implementation

{ TZip }


constructor TZip.Create(AOwner: TComponent);
begin
   FZipMaster:= TZipMaster.Create(Application);
   FZipMaster.DLLDirectory:='';
   FZipMaster.Load_Zip_Dll;
   FZipMaster.Load_Unz_Dll;

   FZipMaster.AddOptions:=[];
   FZipMaster.FSpecArgs.Clear;

   //FZipMaster.OnTotalProgress:= ZipMasterTotalProgress;
end;

destructor TZip.Destroy;
begin
   FZipMaster.Unload_Zip_Dll;
   FZipMaster.Unload_Unz_Dll;

   FZipMaster.Free;
end;

procedure TZip.DoProgress(TamanhoArquivo, PercentualConcluido: Real);
begin
   if Assigned(FOnProgress) then
      FOnProgress(Self, TamanhoArquivo, PercentualConcluido);
end;


procedure TZip.DoWorkBegin;
begin
//   if Assigned(FOnWorkBegin) then
//      FOnWorkBegin(Self);
end;

procedure TZip.DoWorkEnd;
begin
//   if Assigned(FOnWorkEnd) then
//      FOnWorkEnd(Self);
end;

function TZip.getDestino: String;
begin
   Result:=FDestino;
end;

function TZip.getOrigem: String;
begin
   Result:=FOrigem;
end;


procedure TZip.Iniciar;
begin
   DoWorkBegin();
end;

procedure TZip.setDestino(const Value: String);
begin
   FDestino :=Value;
end;

procedure TZip.setOrigem(const Value: String);
begin
   if FileExists(Value) or DirectoryExists(Value) then
   begin
      FOrigem :=Value;
   end
   else
   begin
      raise Exception.Create('Arquivo ou diretório de origem inválido.');
   end;

end;


procedure TZip.ZipMasterTotalProgress(Sender: TObject; TotalSize: Cardinal;
  PerCent: Integer);
begin
//   DoProgress(TotalSize, PerCent);
end;

end.
