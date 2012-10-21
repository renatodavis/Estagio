unit u_rel_equipamentos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_relatorio_padrao, FMTBcd, DB, Provider, SqlExpr, DBClient,
  RLReport, SimpleDS;

type
  TRELEquipamentos = class(TRELPadrao)
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    ClientDataSet1COD_BANCA: TIntegerField;
    ClientDataSet1ANO_LETIVO_BANCA: TIntegerField;
    ClientDataSet1RA: TIntegerField;
    ClientDataSet1DATA_BANCA: TDateField;
    ClientDataSet1HORARIO_BANCA: TTimeField;
    ClientDataSet1SEQUENCIA_BANCA: TIntegerField;
    ClientDataSet1BLOCO_BANCA: TStringField;
    ClientDataSet1SALA_BANCA: TStringField;
    ClientDataSet1TITULO_TRAB_BANCA: TStringField;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    ClientDataSet1EQUIPAMENTO: TStringField;
    RLBand4: TRLBand;
    sdsBuscaParametro: TSimpleDataSet;
    procedure RLBand3BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1AfterPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELEquipamentos: TRELEquipamentos;

implementation

uses u_geral, Math;

{$R *.dfm}

procedure TRELEquipamentos.RLBand3BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;
  RLDBText5.Text := '';
  if ClientDataSet1.FieldByName('EQUIPAMENTO').IsNull then
    RLDBText5.Text := sdsBuscaParametro.Fields[0].AsString
  else
    RLDBText5.Text := ClientDataSet1EQUIPAMENTO.AsString;

end;

procedure TRELEquipamentos.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;
  sdsBuscaParametro.open;
end;

procedure TRELEquipamentos.RLReport1AfterPrint(Sender: TObject);
begin
  inherited;
  sdsBuscaParametro.Close;
end;

end.
