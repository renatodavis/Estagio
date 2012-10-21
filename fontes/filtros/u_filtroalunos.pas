unit u_filtroalunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TFiltroAlunos = class(TFiltroPadrao)
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    rdgProfessor: TRadioGroup;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroAlunos: TFiltroAlunos;

implementation

uses u_relatorio_alunos, DateUtils;

{$R *.dfm}

procedure TFiltroAlunos.BitBtn1Click(Sender: TObject);
begin
  inherited;

  if RELAlunos=nil then
    Application.CreateForm(TRELAlunos,RELAlunos);

  case rdgProfessor.ItemIndex of
    0:begin
      RELAlunos.SQLQuery1.SQL.Text := 'SELECT * FROM ALUNO WHERE COD_PROFESSOR IS NOT NULL ORDER BY NOME_ALU';
      RELAlunos.lblOrientador.Caption :=  'Com professor orientador.';
    end;
    1:begin
      RELAlunos.SQLQuery1.SQL.Text := 'SELECT * FROM ALUNO WHERE COD_PROFESSOR IS NULL ORDER BY NOME_ALU';
      RELAlunos.lblOrientador.Caption :=  'Sem professor orientador.';
    end;
  end;

  RELAlunos.ClientDataSet1.Close;
  RELAlunos.ClientDataSet1.Open;
  RELAlunos.RLReport1.PreviewModal;

end;

procedure TFiltroAlunos.FormShow(Sender: TObject);
begin
  inherited;
    edit1.Text :=intTOStr(YearOf(Date));

end;

procedure TFiltroAlunos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroAlunos := nil;

end;

end.
