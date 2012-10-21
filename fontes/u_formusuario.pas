unit u_formusuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, StdCtrls, Mask, DBCtrls, DB, DBClient,
  Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, jpeg;

type
  TFormCadUsuario = class(TFormPadrao)
    ClientDataSetCOD_USUARIO: TIntegerField;
    ClientDataSetNOME: TStringField;
    ClientDataSetNIVEL: TIntegerField;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    sqlUltimoRegistroMAX: TIntegerField;
    procedure btnConsultarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadUsuario: TFormCadUsuario;

implementation

uses u_consultausuario, u_geral;

{$R *.dfm}

procedure TFormCadUsuario.btnConsultarClick(Sender: TObject);
begin
  inherited;
  if ConsultaUsuario = nil then
    application.CreateForm(TConsultaUsuario,ConsultaUsuario);
  ConsultaUsuario.showmodal;
  ClientDataSet.Locate('COD_USUARIO',ConsultaUsuario.cdsConsultaCOD_USUARIO.AsString,[]);
  FreeAndNil(ConsultaUsuario);

end;

procedure TFormCadUsuario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCadUsuario:= nil;
end;

procedure TFormCadUsuario.btnNovoClick(Sender: TObject);
begin
  inherited;
  sqlUltimoRegistro.Open;
  if not sqlUltimoRegistro.IsEmpty then
    DBEdit1.Text := IntTostr(sqlUltimoRegistroMAX.VALUE + 1)
  else
    DBEdit1.Text := '1';
end;

end.
