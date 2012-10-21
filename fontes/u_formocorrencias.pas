unit u_formocorrencias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, DBCtrls, Mask, jpeg;

type
  TFormCad_Ocorrencias = class(TFormPadrao)
    ClientDataSetDATA_OCORRENCIA: TDateField;
    ClientDataSetHORA_OCORRENCIA: TTimeField;
    ClientDataSetDESC_OCORRENCIA: TStringField;
    GroupBox1: TGroupBox;
    LblData: TLabel;
    LblHora: TLabel;
    LblDescricao: TLabel;
    DBMDescricao: TDBMemo;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEdit1Exit(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Ocorrencias: TFormCad_Ocorrencias;

implementation

uses u_consultaocorrencias, u_consultaferiado;

{$R *.dfm}

procedure TFormCad_Ocorrencias.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormCad_Ocorrencias := NIL;
end;

procedure TFormCad_Ocorrencias.DBEdit1Exit(Sender: TObject);
begin
  inherited;
  try
    // validacao da data
    if (DBEdit1.Text<>'  /  /    ') then
      StrToDate(DBEdit1.Text);
  except
    MessageDlg('Data Inválida!',mtError,[mbOk],0);
    DBEdit1.SetFocus;
  end;
end;

procedure TFormCad_Ocorrencias.btnConsultarClick(Sender: TObject);
begin
  inherited;
   //chama o form consulta atraves do que esta selecionado
  if ConsultaOcorrencias = nil then
    Application.CreateForm(TConsultaOcorrencias,ConsultaOcorrencias);
  ConsultaOcorrencias.FormStyle := fsNormal;
  ConsultaOcorrencias.ShowModal;
  ClientDataSet.Locate('DATA_OCORRENCIA',ConsultaOcorrencias.cdsConsultaDATA_OCORRENCIA.AsString,[]);
  FreeAndNil(ConsultaFeriado);
end;

end.
