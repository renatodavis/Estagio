unit u_rel_bancasporprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, RLReport, DB, Provider, SqlExpr,
  DBClient;

type
  TRELBancasPorProfessor = class(TRELPadrao)
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1DATA_BANCA: TDateField;
    ClientDataSet1HORARIO_BANCA: TTimeField;
    ClientDataSet1BLOCO_BANCA: TStringField;
    ClientDataSet1SALA_BANCA: TStringField;
    RLGroup1: TRLGroup;
    RLBand3: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText1: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELBancasPorProfessor: TRELBancasPorProfessor;

implementation

{$R *.dfm}

end.
