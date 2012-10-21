unit u_formferiado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, DBCtrls, jpeg;

type
  TFormCad_Feriado = class(TFormPadrao)
    GroupBox1: TGroupBox;
    LablData: TLabel;
    LblDescricao: TLabel;
    DBEDescricao: TDBEdit;
    SQLQueryDATA_FERIADO: TDateField;
    SQLQueryDESC_FERIADO: TStringField;
    ClientDataSetDATA_FERIADO: TDateField;
    ClientDataSetDESC_FERIADO: TStringField;
    MaskEdit1: TMaskEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConsultarClick(Sender: TObject);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Feriado: TFormCad_Feriado;

implementation

uses u_consultaferiado;

{$R *.dfm}

procedure TFormCad_Feriado.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCad_Feriado:=Nil;
end;



procedure TFormCad_Feriado.btnConsultarClick(Sender: TObject);
begin
  inherited;
   //chama o form consulta atraves do que esta selecionado
  if ConsultaFeriado = nil then
    Application.CreateForm(TConsultaFeriado,ConsultaFeriado);
  ConsultaFeriado.FormStyle := fsNormal;
  ConsultaFeriado.ShowModal;
  ClientDataSet.Locate('DATA_FERIADO',ConsultaFeriado.cdsConsultaDATA_FERIADO.AsString,[]);
  FreeAndNil(ConsultaFeriado);
end;

procedure TFormCad_Feriado.MaskEdit1Exit(Sender: TObject);
begin
  inherited;
    try
      StrToDate(MaskEdit1.Text);

    Except
      ShowMessage('Data Inválida!');
      MaskEdit1.SetFocus;
    end;
end;

procedure TFormCad_Feriado.ClientDataSetBeforePost(DataSet: TDataSet);
begin
  inherited;
  ClientDataSetDATA_FERIADO.AsString:= MaskEdit1.Text;
end;

end.
