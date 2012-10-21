unit u_consultatipodocumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaTipoDocumento = class(TConsultaPadrao)
    cdsConsultaCOD_DOC: TIntegerField;
    cdsConsultaDESC_DOS: TStringField;
    cdsConsultaOBS_DOC: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaTipoDocumento: TConsultaTipoDocumento;

implementation

{$R *.dfm}

end.
