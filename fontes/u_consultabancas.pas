unit u_consultabancas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaBancas = class(TConsultaPadrao)
    cdsConsultaCOD_BANCA: TIntegerField;
    cdsConsultaANO_LETIVO_BANCA: TIntegerField;
    cdsConsultaRA: TIntegerField;
    cdsConsultaDATA_BANCA: TDateField;
    cdsConsultaHORARIO_BANCA: TTimeField;
    cdsConsultaSEQUENCIA_BANCA: TIntegerField;
    cdsConsultaBLOCO_BANCA: TStringField;
    cdsConsultaSALA_BANCA: TStringField;
    cdsConsultaTITULO_TRAB_BANCA: TStringField;
    cdsConsultaNOME_ALU: TStringField;
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaBancas: TConsultaBancas;

implementation

uses u_geral;

{$R *.dfm}

end.
