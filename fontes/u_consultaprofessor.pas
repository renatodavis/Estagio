unit u_consultaprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, DB, SqlExpr, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaProfessor = class(TConsultaPadrao)
    cdsConsultaCOD_PROF: TIntegerField;
    cdsConsultaNOME_PROF: TStringField;
    cdsConsultaFONE_PROF: TStringField;
    cdsConsultaCELULAR_PROF: TStringField;
    cdsConsultaEMAIL_PROF: TStringField;
    cdsConsultaCATEGORIA_PROF: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaProfessor: TConsultaProfessor;

implementation

{$R *.dfm}

end.
