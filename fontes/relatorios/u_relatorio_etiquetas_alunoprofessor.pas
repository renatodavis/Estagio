unit u_relatorio_etiquetas_alunoprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, SimpleDS, RLReport;

type
  TREL_EtiquetaAlunoProf = class(TForm)
    RLReport1: TRLReport;
    RLDetailGrid2: TRLDetailGrid;
    RLDBText1: TRLDBText;
    RLLabel1: TRLLabel;
    RLLabel3: TRLLabel;
    sdsProfessor: TSimpleDataSet;
    dsProfessor: TDataSource;
    RLDBText2: TRLDBText;
    sdsProfessorNOME_ALU: TStringField;
    sdsProfessorNOME_PROF: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  REL_EtiquetaAlunoProf: TREL_EtiquetaAlunoProf;

implementation

uses u_geral;

{$R *.dfm}

end.
