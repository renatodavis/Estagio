unit u_formempresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, DBCtrls, jpeg;

type
  TFormCad_Empresa = class(TFormPadrao)
    ClientDataSetCOD_EMP: TIntegerField;
    ClientDataSetRAZAO_EMP: TStringField;
    ClientDataSetNOME_EMP: TStringField;
    ClientDataSetCNPJ_EMP: TFMTBCDField;
    ClientDataSetUF_EMP: TStringField;
    ClientDataSetCEP_EMP: TStringField;
    ClientDataSetFONE_EMP: TStringField;
    ClientDataSetFAX_EMP: TStringField;
    ClientDataSetEMAIL_EMP: TStringField;
    ClientDataSetORI_ATIV_EMP: TStringField;
    ClientDataSetCARGO_ORI_EMP: TStringField;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure DBEdit5Exit(Sender: TObject);
  private
    bAchou : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Empresa: TFormCad_Empresa;

implementation

uses u_consultaempresa, u_geral;

{$R *.dfm}

procedure TFormCad_Empresa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   FormCad_Empresa := nil;
end;

procedure TFormCad_Empresa.btnNovoClick(Sender: TObject);
begin
  inherited;
  // busca utimo registro
  ClientDataSetCOD_EMP.AsString := BuscaUltimoRegistro('COD_EMP','EMPRESA');
  DBEdit2.SetFocus;
end;

procedure TFormCad_Empresa.btnConsultarClick(Sender: TObject);
begin
  inherited;
   //chama o form consulta atraves do que esta selecionado
  if ConsultaEmpresa = nil then
    Application.CreateForm(TConsultaEmpresa,ConsultaEmpresa);

  ConsultaEmpresa.FormStyle := fsNormal;
  ConsultaEmpresa.ShowModal;
  ClientDataSet.Locate('COD_EMP',ConsultaEmpresa.cdsConsultaCOD_EMP.AsString,[]);
  FreeAndNil(ConsultaEmpresa);
end;

procedure TFormCad_Empresa.DBEdit5Exit(Sender: TObject);
begin
  inherited;
  bAchou := false;

  if DBEdit5.Text = 'PR' then
    bAchou := true
  else if DBEdit5.Text = 'SP' then
    bAchou := True
  else if DBEdit5.Text = 'SC' then
    bAchou := True
  else if DBEdit5.Text = 'RS' then
    bAchou := True
  else if DBEdit5.Text = 'RJ' then
    bAchou := True
  else if DBEdit5.Text = 'ES' then
    bAchou := True
  else if DBEdit5.Text = 'RO' then
    bAchou := True
  else if DBEdit5.Text = 'MT' then
    bAchou := True
  else if DBEdit5.Text = 'MS' then
    bAchou := True
  else if DBEdit5.Text = 'GO' then
    bAchou := True
  else if DBEdit5.Text = 'NO' then
    bAchou := True
  else if DBEdit5.Text = 'MG' then
    bAchou := True
  else if DBEdit5.Text = 'TO' then
    bAchou := True
  else if DBEdit5.Text = 'AL' then
    bAchou := True
  else if DBEdit5.Text = 'AM' then
    bAchou := True
  else if DBEdit5.Text = 'PR' then
    bAchou := true;

  if not bAchou then
  begin
    Messagedlg('Estado Inválido!',mtWarning,[mbOk],0);
    DBEdit5.SetFocus;
  end;

end;

end.
