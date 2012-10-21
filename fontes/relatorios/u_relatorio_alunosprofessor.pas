unit u_relatorio_alunosprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, Provider, SqlExpr, DB, DBClient,
  RLReport;

type
  TREL_AlunosProfessor = class(TRELPadrao)
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLSystemInfo4: TRLSystemInfo;
    RLBand4: TRLBand;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  REL_AlunosProfessor: TREL_AlunosProfessor;

implementation

{$R *.dfm}

end.
