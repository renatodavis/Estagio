unit u_consultatipoavaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaTipoavaliacao = class(TConsultaPadrao)
    cdsConsultaANO_LETIVO_AVAL2: TIntegerField;
    cdsConsultaCOD_AVAL: TIntegerField;
    cdsConsultaDESC_AVAL: TStringField;
    cdsConsultaDATA_BASE_ANUAL_AVAL: TDateField;
    cdsConsultaDATA_BASE_SEMESTRAL_AVAL: TDateField;
    cdsConsultaPESO_AVAL: TFMTBCDField;
    cdsConsultaOBS_AVAL: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaTipoavaliacao: TConsultaTipoavaliacao;

implementation

{$R *.dfm}

end.
