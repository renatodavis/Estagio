unit u_consultaempresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaEmpresa = class(TConsultaPadrao)
    cdsConsultaCOD_EMP: TIntegerField;
    cdsConsultaRAZAO_EMP: TStringField;
    cdsConsultaNOME_EMP: TStringField;
    cdsConsultaCNPJ_EMP: TFMTBCDField;
    cdsConsultaUF_EMP: TStringField;
    cdsConsultaCEP_EMP: TStringField;
    cdsConsultaFONE_EMP: TStringField;
    cdsConsultaFAX_EMP: TStringField;
    cdsConsultaEMAIL_EMP: TStringField;
    cdsConsultaORI_ATIV_EMP: TStringField;
    cdsConsultaCARGO_ORI_EMP: TStringField;
    sdsConsultaCOD_EMP: TIntegerField;
    sdsConsultaRAZAO_EMP: TStringField;
    sdsConsultaNOME_EMP: TStringField;
    sdsConsultaCNPJ_EMP: TFMTBCDField;
    sdsConsultaUF_EMP: TStringField;
    sdsConsultaCEP_EMP: TStringField;
    sdsConsultaFONE_EMP: TStringField;
    sdsConsultaFAX_EMP: TStringField;
    sdsConsultaEMAIL_EMP: TStringField;
    sdsConsultaORI_ATIV_EMP: TStringField;
    sdsConsultaCARGO_ORI_EMP: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaEmpresa: TConsultaEmpresa;

implementation

{$R *.dfm}

end.
