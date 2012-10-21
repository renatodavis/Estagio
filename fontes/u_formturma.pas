unit u_formturma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, StdCtrls, Mask, DBCtrls, DB, DBClient,
  Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, jpeg;

type
  TFormCad_Turma = class(TFormPadrao)
    ClientDataSetCOD_TURMA: TIntegerField;
    ClientDataSetDESCRICAO: TStringField;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    sqlUltimoRegistroMAX: TIntegerField;
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Turma: TFormCad_Turma;

implementation

uses u_geral, u_consultaturma, u_consultausuario;

{$R *.dfm}

procedure TFormCad_Turma.btnNovoClick(Sender: TObject);
begin
  inherited;
  // codigo automatico
  sqlUltimoRegistro.Open;
  DBEdit1.Text :=  IntToStr(sqlUltimoRegistroMAX.VALUE + 1);
  sqlUltimoRegistro.Close;

end;

procedure TFormCad_Turma.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCad_Turma := NIL;
end;

procedure TFormCad_Turma.btnConsultarClick(Sender: TObject);
begin
  inherited;
   //chama o form consulta atraves do que esta selecionado
  if ConsultaTurma = nil then
    application.CreateForm(TConsultaTurma,ConsultaTurma);
  ConsultaTurma.Showmodal;

  ClientDataSet.Locate('COD_TURMA',ConsultaTurma.cdsConsultaCOD_TURMA.AsString,[]);

  FreeAndNil(ConsultaTurma);
end;

end.
