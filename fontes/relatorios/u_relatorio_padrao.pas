unit u_relatorio_padrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, FMTBcd, Provider, SqlExpr, DB, DBClient;

type
  TRELPadrao = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    SQLQuery1: TSQLQuery;
    DataSetProvider1: TDataSetProvider;
    RLPanel1: TRLPanel;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLPanel2: TRLPanel;
    RLPanel3: TRLPanel;
    rlInstituicao: TRLLabel;
    rlDisciplina: TRLLabel;
    rlCurso: TRLLabel;
    RLSystemInfo3: TRLSystemInfo;
    rlbTitulo: TRLBand;
    rlTitulo: TRLLabel;
    lblData: TRLLabel;
    lblHora: TRLLabel;
    lblPagina: TRLLabel;
    sqlParametros: TSQLQuery;
    sqlParametrosNOME_INSTITUICAO: TStringField;
    sqlParametrosNOME_CURSO: TStringField;
    sqlParametrosNOME_DISCIPLINA: TStringField;
    sqlParametrosNOME_COORD_CURSO: TStringField;
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RELPadrao: TRELPadrao;

implementation

uses u_geral;

{$R *.dfm}

procedure TRELPadrao.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
   sqlParametros.Close;
   sqlParametros.Open;
   rlInstituicao.Caption := sqlParametrosNOME_INSTITUICAO.AsString;
   rlDisciplina.Caption  := sqlParametrosNOME_DISCIPLINA.AsString;
   rlCurso.Caption       := sqlParametrosNOME_CURSO.AsString;
   sqlParametros.Close;
end;

procedure TRELPadrao.FormCreate(Sender: TObject);
begin
  SQLQuery1.SQLConnection := DmGeral.SQLConnection;
end;

end.
