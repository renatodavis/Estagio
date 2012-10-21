unit u_relatorio_fichaespecrequisitos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, Provider, SqlExpr, DB, DBClient,
  RLReport;

type
  TRELFichaEspecifRequisitos = class(TRELPadrao)
    RLBand4: TRLBand;
    RLLabel1: TRLLabel;
    RLDBText1: TRLDBText;
    ClientDataSet1ANO_LETIVO: TIntegerField;
    ClientDataSet1RA: TIntegerField;
    ClientDataSet1COD_AVALIACAO: TIntegerField;
    ClientDataSet1DATA_ENTREGA: TDateField;
    ClientDataSet1PERC_DESCONTO: TFMTBCDField;
    ClientDataSet1OBS: TStringField;
    ClientDataSet1NOME_ALU: TStringField;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1NOTA_PROF: TFloatField;
    ClientDataSet1NOTA_AVALIACAO: TFloatField;
    rlMemo: TRLMemo;
    RLGroup1: TRLGroup;
    RLMemo1: TRLMemo;
    RLBand2: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLBand3: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    lblTrabalho: TRLLabel;
    lblOrientacao: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELFichaEspecifRequisitos: TRELFichaEspecifRequisitos;

implementation

{$R *.dfm}

end.
