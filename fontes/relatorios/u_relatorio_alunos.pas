unit u_relatorio_alunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, RLReport, FMTBcd, Provider, SqlExpr, DB,
  DBClient, StdCtrls;

type
  TRELAlunos = class(TRELPadrao)
    ClientDataSet1ANO_LETIVO: TIntegerField;
    ClientDataSet1RA_ALU: TIntegerField;
    ClientDataSet1TURMA_ALU: TStringField;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1END_ALU: TStringField;
    ClientDataSet1CIDADE_ALU: TStringField;
    ClientDataSet1UF_ALU: TStringField;
    ClientDataSet1FONE_ALU: TStringField;
    ClientDataSet1CELULAR_ALU: TStringField;
    ClientDataSet1FONE_COMER_ALU: TStringField;
    ClientDataSet1EMAIL_ALU: TStringField;
    ClientDataSet1CEP_ALU: TStringField;
    ClientDataSet1DISP_ORINT_ALU: TStringField;
    ClientDataSet1CRONOGRAMA_ALU: TStringField;
    ClientDataSet1DATA_CANCELAMENTO_ALU: TDateField;
    ClientDataSet1MOTIVO_CANCELAMENTO_ALU: TStringField;
    ClientDataSet1COD_PROFESSOR: TIntegerField;
    lblOrientador: TRLLabel;
    sqlProf: TSQLQuery;
    sqlProfNOME_PROF: TStringField;
    RLBand2: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel1: TRLLabel;
    RLLabel3: TRLLabel;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    rldbNomeProf: TRLLabel;
    procedure RLBand3BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELAlunos: TRELAlunos;

implementation

uses u_geral;

{$R *.dfm}

procedure TRELAlunos.RLBand3BeforePrint(Sender: TObject;
  var PrintIt: Boolean);

begin
  inherited;
  sqlProf.Close;
  if ClientDataSet1COD_PROFESSOR.AsString = '' then
   sqlProf.Params[0].AsString := 'null'
  else
    sqlProf.Params[0].AsString := ClientDataSet1COD_PROFESSOR.AsString;
  sqlProf.Open;
  rldbNomeProf.Caption := sqlProfNOME_PROF.AsString;
  sqlProf.Close;
end;

end.
