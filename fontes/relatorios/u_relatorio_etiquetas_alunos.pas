unit u_relatorio_etiquetas_alunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, SimpleDS, RLReport;

type
  TREL_Alunos = class(TForm)
    RLReport1: TRLReport;
    RLDetailGrid2: TRLDetailGrid;
    RLDBText1: TRLDBText;
    RLLabel3: TRLLabel;
    sdsProfessor: TSimpleDataSet;
    sdsProfessorNOME_ALU: TStringField;
    sdsProfessorNOME_PROF: TStringField;
    dsProfessor: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  REL_Alunos: TREL_Alunos;

implementation

{$R *.dfm}

end.
