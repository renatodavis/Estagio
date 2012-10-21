unit u_consultaferiado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaFeriado = class(TConsultaPadrao)
    cdsConsultaDATA_FERIADO: TDateField;
    cdsConsultaDESC_FERIADO: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaFeriado: TConsultaFeriado;

implementation

{$R *.dfm}

end.
