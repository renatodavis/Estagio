unit u_consultausuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_consultapadrao, FMTBcd, SqlExpr, DB, DBClient, Provider,
  Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TConsultaUsuario = class(TConsultaPadrao)
    cdsConsultaCOD_USUARIO: TIntegerField;
    cdsConsultaNOME: TStringField;
    cdsConsultaNIVEL: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConsultaUsuario: TConsultaUsuario;

implementation

{$R *.dfm}

end.
