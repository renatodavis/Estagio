unit u_rel_formacompanhamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, DB, Provider, SqlExpr, DBClient,
  RLReport;

type
  TRELAcompanhamento = class(TRELPadrao)
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1NOME_ALU: TStringField;
    RLGroup1: TRLGroup;
    SQLQuery1NOME_PROF: TStringField;
    SQLQuery1NOME_ALU: TStringField;
    RLBand4: TRLBand;
    RLLabel2: TRLLabel;
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLBand5: TRLBand;
    RLPanel4: TRLPanel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLMemo1: TRLMemo;
    RLPanel5: TRLPanel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLMemo2: TRLMemo;
    RLPanel6: TRLPanel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    RLMemo3: TRLMemo;
    RLPanel7: TRLPanel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel18: TRLLabel;
    RLMemo4: TRLMemo;
    RLPanel8: TRLPanel;
    RLMemo5: TRLMemo;
    RLPanel9: TRLPanel;
    RLLabel19: TRLLabel;
    RLLabel20: TRLLabel;
    RLLabel21: TRLLabel;
    RLLabel22: TRLLabel;
    RLMemo6: TRLMemo;
    RLPanel10: TRLPanel;
    RLLabel23: TRLLabel;
    RLLabel24: TRLLabel;
    RLLabel25: TRLLabel;
    RLLabel26: TRLLabel;
    RLMemo7: TRLMemo;
    RLPanel11: TRLPanel;
    RLLabel27: TRLLabel;
    RLLabel28: TRLLabel;
    RLLabel29: TRLLabel;
    RLLabel30: TRLLabel;
    RLMemo8: TRLMemo;
    RLPanel12: TRLPanel;
    RLLabel31: TRLLabel;
    RLLabel32: TRLLabel;
    RLLabel33: TRLLabel;
    RLLabel34: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELAcompanhamento: TRELAcompanhamento;

implementation

{$R *.dfm}

end.
