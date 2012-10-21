unit u_consultaturma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaTurma = class(TConsultaPadrao)
    cdsConsultaCOD_TURMA: TIntegerField;
    cdsConsultaDESCRICAO: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaTurma: TConsultaTurma;

implementation

{$R *.dfm}

end.
