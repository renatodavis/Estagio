unit u_consultaocorrencias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaOcorrencias = class(TConsultaPadrao)
    cdsConsultaDATA_OCORRENCIA: TDateField;
    cdsConsultaHORA_OCORRENCIA: TTimeField;
    cdsConsultaDESC_OCORRENCIA: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaOcorrencias: TConsultaOcorrencias;

implementation

{$R *.dfm}

end.
