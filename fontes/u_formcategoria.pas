unit u_formcategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, DBCtrls, jpeg;

type
  TFormCad_Categoria = class(TFormPadrao)
    GroupBox1: TGroupBox;
    LblCodigo: TLabel;
    LblDescricao: TLabel;
    DBECodigo: TDBEdit;
    DBEDescricao: TDBEdit;
    SQLQueryCOD_CAT: TIntegerField;
    SQLQueryDESC_CAT: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    ClientDataSetCOD_CAT: TIntegerField;
    ClientDataSetDESC_CAT: TStringField;
    SQLQueryREC_POR_ORIENTADOR_CAT: TIntegerField;
    ClientDataSetREC_POR_ORIENTADOR_CAT: TIntegerField;
    cbbSimNao: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
    procedure btnNovoClick(Sender: TObject);
    procedure ClientDataSetAfterRefresh(DataSet: TDataSet);
    procedure btnConsultarClick(Sender: TObject);
    procedure ClientDataSetAfterOpen(DataSet: TDataSet);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure cbbSimNaoChange(Sender: TObject);
    procedure btngravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Categoria: TFormCad_Categoria;

implementation

uses u_consultacategoria, Math, u_geral;

{$R *.dfm}

procedure TFormCad_Categoria.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   FormCad_Categoria := nil;
end;

procedure TFormCad_Categoria.ClientDataSetBeforePost(DataSet: TDataSet);
begin
  inherited;
  ClientDataSetREC_POR_ORIENTADOR_CAT.AsInteger := cbbSimNao.ItemIndex;
end;

procedure TFormCad_Categoria.btnNovoClick(Sender: TObject);
begin
  inherited;
  ClientDataSetCOD_CAT.AsString:=  BuscaUltimoRegistro('Cod_Cat','Categoria');
  DBEDescricao.SetFocus;
end;

procedure TFormCad_Categoria.ClientDataSetAfterRefresh(DataSet: TDataSet);
begin
  inherited;
  //atualiza a combobox de acordo com o valor gravado . ex 0-nao 1-sim

end;

procedure TFormCad_Categoria.btnConsultarClick(Sender: TObject);
begin
  inherited;
  if ConsultaCategoria = nil then
    Application.CreateForm(TConsultaCategoria,ConsultaCategoria);
  ConsultaCategoria.showmodal;
  ClientDataSet.Locate('COD_CAT',ConsultaCategoria.cdsConsultaCOD_CAT.AsString,[]);
  FreeAndNil(ConsultaCategoria);   
end;

procedure TFormCad_Categoria.ClientDataSetAfterOpen(DataSet: TDataSet);
begin
  inherited;
  cbbSimNao.ItemIndex := ClientDataSetREC_POR_ORIENTADOR_CAT.AsInteger;
end;

procedure TFormCad_Categoria.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  cbbSimNao.ItemIndex := ClientDataSetREC_POR_ORIENTADOR_CAT.AsInteger;
end;

procedure TFormCad_Categoria.cbbSimNaoChange(Sender: TObject);
begin
  inherited;
  ClientDataSet.Edit;
end;

procedure TFormCad_Categoria.btngravarClick(Sender: TObject);
begin
  if cbbSimNao.ItemIndex = -1 then
  begin
    MessageDlg('Campo obrigatório!',mtInformation,[mbok],0);
    cbbSimNao.SetFocus;
  end
  else
  inherited;

end;

end.
