unit u_relatorio_notasespecrequisitos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, Provider, SqlExpr, DB, DBClient,
  RLReport;

type
  TRELNotasespecifRequisitos = class(TRELPadrao)
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLLabel1: TRLLabel;
    RLDBText2: TRLDBText;
    SQLQuery1NOME_ALU: TStringField;
    SQLQuery1NOTA_AVALIACAO: TFloatField;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1NOTA_AVALIACAO: TFloatField;
    RLDBText3: TRLDBText;
    RLLabel2: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELNotasespecifRequisitos: TRELNotasespecifRequisitos;

implementation

{$R *.dfm}

end.
