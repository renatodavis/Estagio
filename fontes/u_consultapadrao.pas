unit u_consultapadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, ComCtrls, FMTBcd,
  SqlExpr, DB, DBClient, Provider;

type
  TConsultaPadrao = class(TForm)
    stbConsulta: TStatusBar;
    Panel3: TPanel;
    Panel1: TPanel;
    btnFechar: TBitBtn;
    btnOK: TBitBtn;
    Panel2: TPanel;
    pnlTitulo: TPanel;
    Panel5: TPanel;
    Image1: TImage;
    Panel4: TPanel;
    sedtPesquisa: TEdit;
    Button1: TButton;
    Panel6: TPanel;
    gridConsulta: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblRecordCount: TLabel;
    dspConsulta: TDataSetProvider;
    cdsConsulta: TClientDataSet;
    dsConsulta: TDataSource;
    sdsConsulta: TSQLDataSet;
    procedure Button1Click(Sender: TObject);
    procedure sedtPesquisaChange(Sender: TObject);
    procedure gridConsultaColEnter(Sender: TObject);
    procedure gridConsultaColExit(Sender: TObject);
    procedure gridConsultaDblClick(Sender: TObject);
    procedure gridConsultaExit(Sender: TObject);
    procedure gridConsultaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridConsultaKeyPress(Sender: TObject; var Key: Char);
    procedure gridConsultaTitleClick(Column: TColumn);
    procedure cdsConsultaAfterOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
  private
      sCampo, sPalavra : String;
      sqlOriginal : TStringList;

      procedure PesquisaDinamica(Pesquisa: TEdit;
      Query: TSQLDataSet; DataSet: TClientDataSet; Campo: String; const sFixos: String);
      procedure CriaScriptPesquisa(Valor: Boolean);
      procedure AdicionaLetra(Letra: String);
      procedure LimpaPalavra;
      procedure DeletaLetra;
      procedure Localiza;
      procedure DestacaColunaAtiva;


    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaPadrao: TConsultaPadrao;

implementation

uses u_geral;

{$R *.dfm}

procedure TConsultaPadrao.AdicionaLetra(Letra: String);
begin
   sPalavra:=sPalavra+Letra;

   stbConsulta.SimpleText:='Pesquisando por: '+sPalavra;

end;

procedure TConsultaPadrao.Button1Click(Sender: TObject);
begin
   PesquisaDinamica(sedtPesquisa, sdsConsulta, cdsConsulta, sCampo, '');

   DestacaColunaAtiva;

   cdsConsulta.IndexFieldNames :=sCampo;

   cdsConsulta.First;

   sedtPesquisa.SetFocus;

end;

procedure TConsultaPadrao.CriaScriptPesquisa(Valor: Boolean);
begin
   if Valor then
   begin
      if sqlOriginal = nil then
         sqlOriginal:=TStringList.Create;

      sqlOriginal.Clear;
   end
   else
   begin
      FreeAndNil(sqlOriginal);
   end;

end;

procedure TConsultaPadrao.DeletaLetra;
begin
   sPalavra:=Copy(sPalavra, 1, Length(sPalavra) -1);
   stbConsulta.SimpleText:='Pesquisando por: '+sPalavra;

end;

procedure TConsultaPadrao.DestacaColunaAtiva;
var
   i : Integer;
begin
   for i:= 0 to gridConsulta.Columns.Count -1 do
      if gridConsulta.Columns[i].FieldName = sCampo then
         gridConsulta.Columns[i].Title.Color:=$0099A8AE;



end;

procedure TConsultaPadrao.LimpaPalavra;
begin
   sPalavra:='';
   stbConsulta.SimpleText:='';

end;

procedure TConsultaPadrao.Localiza;
begin
   if cdsConsulta.Active then
      if sPalavra <> '' then
         cdsConsulta.Locate(gridConsulta.SelectedField.FieldName , sPalavra, [loPartialKey]);

end;

procedure TConsultaPadrao.PesquisaDinamica(Pesquisa: TEdit;
  Query: TSQLDataSet; DataSet: TClientDataSet; Campo: String;
  const sFixos: String);
var
   sqlTemporario: TStringList;
   i: Byte;
   TamanhoCampo: Integer;
   Fixos : Array[0..10] of Integer;

   procedure PreencheFixos;
   var
      i,k : Byte;
      Aux : String;
   begin

      k:=0;
      if sFixos <> '' then
      begin
         for i := 1 to Length(sFixos) do
         begin

            if sFixos[i] <> ',' then
            begin
               Aux:=Aux + sFixos[i];
            end
            else
            begin
               Fixos[k]:=StrToInt(Aux);
               k:=k+1;
               Aux:='';
            end;

         end;
      end;


   end;

   function NomeChavePrimaria : String;
   begin

      if Campo <> '' then
      begin

         TamanhoCampo:=DataSet.FieldByName(Campo).DisplayWidth;
         Result:= Campo;
      end
      else
      begin
         TamanhoCampo:=DataSet.Fields[0].DisplayWidth;
         Result:= DataSet.Fields[0].FieldName;

      end;

   end;

begin

   sqlTemporario := TStringList.Create;
   try
      DataSet.Close;

      PreencheFixos;
      //sempre manter o sql original do form de pesquisa
      if Trim(sqlOriginal.Text) = '' then
      begin
         sqlOriginal.Add(Query.CommandText)
      end
      else
      begin
         Query.CommandText:=sqlOriginal.Text;
      end;

      sqlTemporario.Clear;
      sqlTemporario.Add(sqlOriginal.Text);

      if Query.Params.Count = 0 then
         sqlTemporario.Add(' WHERE UPPER(' + NomeChavePrimaria + ') LIKE UPPER(:PARAMETRO) ')
      else
         sqlTemporario.Add(' AND UPPER(' + NomeChavePrimaria + ') LIKE UPPER(:PARAMETRO)');


      Query.CommandText:=sqlTemporario.Text;

      for i := 0 to Query.Params.Count - 1 do
      begin

         if not (Query.Params[i].Name = 'PARAMETRO') then
            Query.Params[i].Value := Fixos[i];

      end;

      if Length(Pesquisa.Text) < TamanhoCampo then
         Query.ParamByName('PARAMETRO').Value := Pesquisa.Text + '%'
      else
         Query.ParamByName('PARAMETRO').Value := Pesquisa.Text;

      { abre o clientdataset }
      DataSet.Open;
   finally
      FreeAndNil(sqlTemporario);
   end;
end;

procedure TConsultaPadrao.sedtPesquisaChange(Sender: TObject);
begin
   if sedtPesquisa.Text <> '' then
   begin

      if Char(sedtPesquisa.Text[1]) in ['0'..'9'] then
      begin
         sedtPesquisa.MaxLength := 6;
         //sedtPesquisa.CursorPos := Length(sedtPesquisa.Text);
      end
      else
      begin
         sedtPesquisa.MaxLength := 40;
         //sedtPesquisa.CursorPos := Length(sedtPesquisa.Text);
      end;

   end;

end;

procedure TConsultaPadrao.gridConsultaColEnter(Sender: TObject);
begin
   LimpaPalavra;
end;

procedure TConsultaPadrao.gridConsultaColExit(Sender: TObject);
begin
   LimpaPalavra;
end;

procedure TConsultaPadrao.gridConsultaDblClick(Sender: TObject);
begin
   btnOk.Click;
end;

procedure TConsultaPadrao.gridConsultaExit(Sender: TObject);
begin
   LimpaPalavra;

end;

procedure TConsultaPadrao.gridConsultaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   case key of
     VK_RETURN : btnOK.Click;
     VK_DOWN,VK_UP : LimpaPalavra;
   end;
end;

procedure TConsultaPadrao.gridConsultaKeyPress(Sender: TObject;
  var Key: Char);
begin
   { pesquisa incremental... o usuario vai digitando e o sistema vai posicionando
   a grid }
   if (Key in ['A'..'Z','a'..'z','0'..'9']) then
   begin

     AdicionaLetra(UpperCase(Key));
     Localiza;

   end
   else if (Key = #8) then //backspace
   begin
     DeletaLetra;
     Localiza;

   end;

end;

procedure TConsultaPadrao.gridConsultaTitleClick(Column: TColumn);
   procedure RestauraCorTitulo;
   var
      i : Byte;
   begin
      for i:= 0 to gridConsulta.Columns.Count -1 do
         gridConsulta.Columns[i].Title.Color:=clBackground;
   end;

begin

   if cdsConsulta.Active then
   begin

      RestauraCorTitulo;

      Column.Title.Color := $0099A8AE;

      sCampo                      :=Column.FieldName;

      cdsConsulta.IndexFieldNames :=sCampo;

      cdsConsulta.First;
   end;



end;

procedure TConsultaPadrao.cdsConsultaAfterOpen(DataSet: TDataSet);
begin
   { atualiza o lblRecordCount com o numero de registros retornados para o DataSet }
   lblRecordCount.Caption := Format('Total de %d registro(s) encontrado(s).',[DataSet.RecordCount]);

end;

procedure TConsultaPadrao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   CriaScriptPesquisa(False);
//   Action := caFree;

end;

procedure TConsultaPadrao.FormShow(Sender: TObject);
begin
   CriaScriptPesquisa(True);
   Caption := 'Consultando';

   cdsConsulta.Close;

   { joga o foco para o edit }
   sedtPesquisa.Clear;
   sedtPesquisa.SetFocus;

  //limpar a grid, no momento que o form é mostrado
   gridConsulta.Columns.Clear;

   { detacando a coluna ativa }
   sCampo:=cdsConsulta.Fields[0].FieldName;
   DestacaColunaAtiva;

end;

procedure TConsultaPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { travando o Ctrl + Delete do gridPesquisa }
   if (Shift = [ssCtrl]) and (Key = 46) Then
      KEY := 0;

   case Key of

      VK_ESCAPE : btnFechar.Click;

   end;

end;

procedure TConsultaPadrao.btnFecharClick(Sender: TObject);
begin
   Close;
end;

end.
