unit u_relatorio_totalalunosporprofessor;

interface                                            

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, Provider, SqlExpr, DB,
  DBClient;

type
  TRELTotalAlunosPorProfessor = class(TRELPadrao)
    RLGroup1: TRLGroup;
    RLBand3: TRLBand;
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLDBText1: TRLDBText;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1QTDEALUNOS: TIntegerField;
    RLDBText2: TRLDBText;
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  RELTotalAlunosPorProfessor: TRELTotalAlunosPorProfessor;

implementation

{$R *.dfm}

end.
