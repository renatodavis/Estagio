unit u_relatorio_notasmanual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, DB, RLReport, Provider, SqlExpr,
  DBClient;

type
  TRELNotasManual = class(TRELPadrao)
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLBand3: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1NOTA_AVALIACAO: TFloatField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELNotasManual: TRELNotasManual;

implementation

{$R *.dfm}

end.
