unit u_formprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, DBCtrls, Mask, SimpleDS, jpeg;

type
  TFormCad_Professor = class(TFormPadrao)
    GroupBox1: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBMemo1: TDBMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SQLQueryCOD_PROF: TIntegerField;
    SQLQueryNOME_PROF: TStringField;
    SQLQueryFONE_PROF: TStringField;
    SQLQueryCELULAR_PROF: TStringField;
    SQLQueryEMAIL_PROF: TStringField;
    SQLQueryCATEGORIA_PROF: TIntegerField;
    ClientDataSetCOD_PROF: TIntegerField;
    ClientDataSetNOME_PROF: TStringField;
    ClientDataSetFONE_PROF: TStringField;
    ClientDataSetCELULAR_PROF: TStringField;
    ClientDataSetEMAIL_PROF: TStringField;
    ClientDataSetCATEGORIA_PROF: TIntegerField;
    dsCategoria: TDataSource;
    sdsCategoria: TSimpleDataSet;
    DBLookupComboBox1: TDBLookupComboBox;
    sqlUltimoRegistroMAX: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Professor: TFormCad_Professor;

implementation

uses u_formcategoria, u_geral, u_consultaprofessor;

{$R *.dfm}

procedure TFormCad_Professor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   sdsCategoria.Close;
  FormCad_Professor := nil;
end;

procedure TFormCad_Professor.btnNovoClick(Sender: TObject);
begin
  inherited;
  // codigo automatico
  sqlUltimoRegistro.OPEN;
  DBEdit1.Text := IntToStr(sqlUltimoRegistroMAX.value +1);
  sqlUltimoRegistro.Close;
  DBEdit2.SetFocus;
end;

procedure TFormCad_Professor.FormShow(Sender: TObject);
begin
  inherited;
  sdsCategoria.Open;
end;

procedure TFormCad_Professor.btnConsultarClick(Sender: TObject);
begin
  inherited;
   //chama o form consulta atraves do que esta selecionado
  if ConsultaProfessor = nil then
    Application.CreateForm(TConsultaProfessor,ConsultaProfessor);

  ConsultaProfessor.ShowModal;
  ClientDataSet.Locate('COD_PROF',ConsultaProfessor.cdsConsultaCOD_PROF.AsString,[]);
  FreeAndNil(ConsultaProfessor);
end;

end.
