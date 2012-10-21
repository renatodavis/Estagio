unit u_formtipoavaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, DBCtrls, jpeg;

type
  TFormCad_TipoAvaliacao = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    DBMemo1: TDBMemo;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label1: TLabel;
    ClientDataSetANO_LETIVO_AVAL: TIntegerField;
    ClientDataSetCOD_AVAL: TIntegerField;
    ClientDataSetDESC_AVAL: TStringField;
    ClientDataSetDATA_BASE_ANUAL_AVAL: TDateField;
    ClientDataSetDATA_BASE_SEMESTRAL_AVAL: TDateField;
    ClientDataSetPESO_AVAL: TFMTBCDField;
    ClientDataSetOBS_AVAL: TStringField;
    sqlUltimoRegistroMAX: TIntegerField;
    DBEdit6: TDBEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEdit1Exit(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure ClientDataSetAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_TipoAvaliacao: TFormCad_TipoAvaliacao;

implementation

uses u_geral, u_consultatipodocumento, u_consultatipoavaliacao;

{$R *.dfm}

procedure TFormCad_TipoAvaliacao.FormShow(Sender: TObject);
begin
  inherited;
ClientDataSet.Open;

end;

procedure TFormCad_TipoAvaliacao.btnNovoClick(Sender: TObject);
begin
  inherited;
  // codigo automatico
  sqlUltimoRegistro.OPEN;
  ClientDataSetCOD_AVAL.Value := sqlUltimoRegistroMAX.Value + 1;
  DBEdit6.Text :=IntToStr(sqlUltimoRegistroMAX.Value + 1);

end;

procedure TFormCad_TipoAvaliacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCad_TipoAvaliacao := nil;

end;

procedure TFormCad_TipoAvaliacao.DBEdit1Exit(Sender: TObject);
begin
  inherited;
  // validacao do ano letivo caso invalido da mensagm e joga foco para o ano
  if (DBEdit1.Text)<> '' then
    if StrToInt(DBEdit1.Text)< 2004 then
    begin
      messageDlg('Ano Inválido',mtError,[mbOk],0);
      DBEdit1.SetFocus;
    end;
end;

procedure TFormCad_TipoAvaliacao.btnConsultarClick(Sender: TObject);
begin
  inherited;
  //chama o form consulta atraves do que esta selecionado
  if ConsultaTipoavaliacao = nil then
    application.CreateForm(TConsultaTipoavaliacao,ConsultaTipoavaliacao);
  ConsultaTipoavaliacao.ShowModal;
  ClientDataSet.Locate('ANO_LETIVO,COD_AVAL',varArrayOf([ConsultaTipoavaliacao.cdsConsultaANO_LETIVO_AVAL2.AsString,ConsultaTipoavaliacao.cdsConsultaCOD_AVAL.AsString]),[]);
  FreeAndNil(ConsultaTipoavaliacao);
end;

procedure TFormCad_TipoAvaliacao.ClientDataSetAfterPost(DataSet: TDataSet);
begin
  inherited;
  ClientDataSet.ApplyUpdates(0);
  ClientDataSet.Close;
  ClientDataSet.Open;

end;

end.
