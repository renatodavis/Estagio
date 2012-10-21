unit u_consultacategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, DB, SqlExpr, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaCategoria = class(TConsultaPadrao)
    cdsConsultaCOD_CAT: TIntegerField;
    cdsConsultaDESC_CAT: TStringField;
    cdsConsultaREC_POR_ORIENTADOR_CAT: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaCategoria: TConsultaCategoria;

implementation

uses Math;

{$R *.dfm}

end.
