unit u_filtroetiquetaprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, jpeg, ExtCtrls, Buttons, ComCtrls;

type
  TFiltroEtiquetaProfessor = class(TFiltroPadrao)
    cbbTipoAvaliacao: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroEtiquetaProfessor: TFiltroEtiquetaProfessor;

implementation

uses u_relatorio_etiquetas_professor;

{$R *.dfm}

procedure TFiltroEtiquetaProfessor.BitBtn1Click(Sender: TObject);
begin
  inherited;
  if cbbTipoAvaliacao.ItemIndex = -1 then
  begin
    MessageDlg('Selecione uma opção!',mtInformation,[mbOk],0);
    exit;
  end;
  if RELEtiquetasProfessor = nil then
    Application.CreateForm(TRELEtiquetasProfessor,RELEtiquetasProfessor);
  RELEtiquetasProfessor.sdsProfessor.open;
  RELEtiquetasProfessor.pTipoAvaliacao := cbbTipoAvaliacao.Text;

  RELEtiquetasProfessor.RLReport1.PreviewModal;

end;

procedure TFiltroEtiquetaProfessor.BitBtn3Click(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TFiltroEtiquetaProfessor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroEtiquetaProfessor := nil;
end;

end.
