unit u_rel_totalbancasprof;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, DB, Provider, SqlExpr,
  DBClient;

type
  TREL_TotalBancasProfRH = class(TRELPadrao)
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1COUNT: TIntegerField;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLBand4: TRLBand;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  REL_TotalBancasProfRH: TREL_TotalBancasProfRH;

implementation

{$R *.dfm}

end.
