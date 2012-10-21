unit u_relatorio_escalabancas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, Provider, SqlExpr, DB,
  DBClient, SimpleDS;

type
  TRELEscalaApresentacoesBancas = class(TRELPadrao)
    RLGroup1: TRLGroup;
    RLDetail: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    sqlProfConvidado: TSimpleDataSet;
    DataSource2: TDataSource;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1TURMA_ALU: TStringField;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1DATA_BANCA: TDateField;
    ClientDataSet1HORARIO_BANCA: TTimeField;
    ClientDataSet1SEQUENCIA_BANCA: TIntegerField;
    ClientDataSet1BLOCO_BANCA: TStringField;
    ClientDataSet1COD_PROF: TIntegerField;
    ClientDataSet1COD_BANCA: TIntegerField;
    sqlProfConvidadoCOD_PROF: TIntegerField;
    sqlProfConvidadoNOME_PROF: TStringField;
    lblProf1: TRLMemo;
    RLDBText7: TRLDBText;
    ClientDataSet1SALA_BANCA: TStringField;
    RLColumnHeader: TRLBand;
    RLProfessor: TRLLabel;
    RLDBText1: TRLDBText;
    RLColumnHeader2: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    procedure RLDetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLGroup1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELEscalaApresentacoesBancas: TRELEscalaApresentacoesBancas;

implementation

uses u_geral;

{$R *.dfm}

procedure TRELEscalaApresentacoesBancas.RLDetailBeforePrint(
  Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  sqlProfConvidado.Close;
  sqlProfConvidado.DataSet.ParamByname('PROFESSOR').AsString := ClientDataSet1COD_PROF.AsString;
  sqlProfConvidado.DataSet.ParamByName('BANCA').AsString := ClientDataSet1COD_BANCA.AsString;
  sqlProfConvidado.Open;


  lblProf1.Lines.Clear;
  while not sqlProfConvidado.Eof do
  begin
    if ClientDataSet1NOME_PROF.AsString <> sqlProfConvidadoNOME_PROF.AsString then
    BEGIN
      lblProf1.Lines.Add(sqlProfConvidadoNOME_PROF.AsString);
    end;
    sqlProfConvidado.next;
  end;
  sqlProfConvidado.Close;

end;

procedure TRELEscalaApresentacoesBancas.RLGroup1BeforePrint(
  Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  lblProf1.Lines.Clear;
end;

end.
