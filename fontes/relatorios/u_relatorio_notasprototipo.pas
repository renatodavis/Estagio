unit u_relatorio_notasprototipo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, DB, Provider, SqlExpr,
  DBClient;

type
  TRELNotasPrototipo = class(TRELPadrao)
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1NOTA_AVALIACAO: TFloatField;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELNotasPrototipo: TRELNotasPrototipo;

implementation

{$R *.dfm}

end.
