unit u_relatorio_etiquetas_professor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, DBClient, SimpleDS;

type
  TRELEtiquetasProfessor = class(TForm)
    RLReport1: TRLReport;
    sdsProfessor: TSimpleDataSet;
    sdsProfessorCOD_PROF: TIntegerField;
    sdsProfessorNOME_PROF: TStringField;
    sdsProfessorFONE_PROF: TStringField;
    sdsProfessorCELULAR_PROF: TStringField;
    sdsProfessorEMAIL_PROF: TStringField;
    sdsProfessorCATEGORIA_PROF: TIntegerField;
    dsProfessor: TDataSource;
    RLDetailGrid2: TRLDetailGrid;
    RLDBText1: TRLDBText;
    RLLabel1: TRLLabel;
    RLLabel3: TRLLabel;
    rlTipoAvaliacao: TRLLabel;
    rlAno: TRLLabel;
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure RLDetailGrid2BeforePrint(Sender: TObject;
      var PrintIt: Boolean);
  private
    sTipoAvaliacao : String;

    { Private declarations }
  public
    property pTipoAvaliacao : String read sTipoAvaliacao write sTipoAvaliacao; 
    { Public declarations }
  end;

var
  RELEtiquetasProfessor: TRELEtiquetasProfessor;

implementation

uses u_geral, DateUtils;

{$R *.dfm}

procedure TRELEtiquetasProfessor.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  rlTipoAvaliacao.Caption := sTipoAvaliacao;
end;

procedure TRELEtiquetasProfessor.FormCreate(Sender: TObject);
begin
  sdsProfessor.Connection := DmGeral.SQLConnection;
end;

procedure TRELEtiquetasProfessor.RLDetailGrid2BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
   rlAno.Caption := IntToStr(YearOf(date));
end;

end.
