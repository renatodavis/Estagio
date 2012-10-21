unit u_consultaaluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, DB, SqlExpr, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaAlunos = class(TConsultaPadrao)
    cdsConsultaANO_LETIVO: TIntegerField;
    cdsConsultaRA_ALU: TIntegerField;
    cdsConsultaTURMA_ALU: TStringField;
    cdsConsultaNOME_ALU: TStringField;
    cdsConsultaEND_ALU: TStringField;
    cdsConsultaCIDADE_ALU: TStringField;
    cdsConsultaUF_ALU: TStringField;
    cdsConsultaFONE_ALU: TStringField;
    cdsConsultaCELULAR_ALU: TStringField;
    cdsConsultaFONE_COMER_ALU: TStringField;
    cdsConsultaEMAIL_ALU: TStringField;
    cdsConsultaCEP_ALU: TStringField;
    cdsConsultaDISP_ORINT_ALU: TStringField;
    cdsConsultaCRONOGRAMA_ALU: TStringField;
    cdsConsultaDATA_CANCELAMENTO_ALU: TDateField;
    cdsConsultaMOTIVO_CANCELAMENTO_ALU: TStringField;
    cdsConsultaCOD_PROFESSOR: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaAlunos: TConsultaAlunos;

implementation


{$R *.dfm}

end.
