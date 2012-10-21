unit u_relatorio_alunosporprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, DB, Provider, SqlExpr,
  DBClient;

type
  TRELAlunosPorProfessor = class(TRELPadrao)
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1TURMA_ALU: TStringField;
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLSystemInfo4: TRLSystemInfo;
    RLBand3: TRLBand;
    RLLabel1: TRLLabel;
    RLDBText1: TRLDBText;
    RLBand4: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELAlunosPorProfessor: TRELAlunosPorProfessor;

implementation

{$R *.dfm}

end.
