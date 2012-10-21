unit u_relatorio_fichamanualanalise;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, Provider, SqlExpr, DB, DBClient,
  RLReport;

type
  TRELFichaManualAnalise = class(TRELPadrao)
    RLBand2: TRLBand;
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
    SQLQuery1ANO_LETIVO: TIntegerField;
    SQLQuery1RA: TIntegerField;
    SQLQuery1COD_AVALIACAO: TIntegerField;
    SQLQuery1DATA_ENTREGA: TDateField;
    SQLQuery1PERC_DESCONTO: TFMTBCDField;
    SQLQuery1OBS: TStringField;
    SQLQuery1NOME_ALU: TStringField;
    SQLQuery1NOME_PROF: TStringField;
    SQLQuery1NOTA_PROF: TFloatField;
    SQLQuery1NOTA_AVALIACAO: TFloatField;
    ClientDataSet1NOTA_PROF: TFloatField;
    ClientDataSet1NOTA_AVALIACAO: TFloatField;
    RLGroup1: TRLGroup;
    RLMemo: TRLMemo;
    RLBand4: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLBand3: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELFichaManualAnalise: TRELFichaManualAnalise;

implementation

{$R *.dfm}

end.
