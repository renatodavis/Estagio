unit u_formtipodocumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, DBCtrls, Mask, jpeg;

type
  TFormCad_TipoDocumento = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    ClientDataSetCOD_DOC: TIntegerField;
    ClientDataSetDESC_DOS: TStringField;
    ClientDataSetOBS_DOC: TStringField;
    procedure btnNovoClick(Sender: TObject);
    procedure btngravarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_TipoDocumento: TFormCad_TipoDocumento;

implementation

uses u_consultatipodocumento;

{$R *.dfm}

procedure TFormCad_TipoDocumento.btnNovoClick(Sender: TObject);
begin
  inherited;
    ClientDataSetCOD_DOC.AsString := BuscaUltimoRegistro('COD_DOC','TIPO_DOCUMENTO');
  DBEdit1.SetFocus;
end;

procedure TFormCad_TipoDocumento.btngravarClick(Sender: TObject);
begin
  inherited;
  DBEdit1.SetFocus;
end;

procedure TFormCad_TipoDocumento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCad_TipoDocumento := nil;
end;

procedure TFormCad_TipoDocumento.btnConsultarClick(Sender: TObject);
begin
  inherited;
  //chama a tela de consulta atraves do campo que esta selecionado
  if ConsultaTipoDocumento = nil then
    Application.CreateForm(TConsultaTipoDocumento,ConsultaTipoDocumento);

  ConsultaTipoDocumento.FormStyle := fsNormal;
  ConsultaTipoDocumento.ShowModal;
  ClientDataSet.Locate('COD_DOC',ConsultaTipoDocumento.cdsConsultaCOD_DOC.AsString,[]);
  FreeAndNil(ConsultaTipoDocumento);

end;

end.
