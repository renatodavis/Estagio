unit u_filtroreferente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls, FMTBcd,
  DB, SqlExpr, DBCtrls, DBClient, SimpleDS;

type
  TFiltroFichaAvaliacao = class(TFiltroPadrao)
    Label2: TLabel;
    Label3: TLabel;
    SimpleDataSet1: TSimpleDataSet;
    SimpleDataSet1ANO_LETIVO_AVAL: TIntegerField;
    SimpleDataSet1COD_AVAL: TIntegerField;
    SimpleDataSet1DESC_AVAL: TStringField;
    SimpleDataSet1DATA_BASE_ANUAL_AVAL: TDateField;
    SimpleDataSet1DATA_BASE_SEMESTRAL_AVAL: TDateField;
    SimpleDataSet1PESO_AVAL: TFMTBCDField;
    SimpleDataSet1OBS_AVAL: TStringField;
    DataSource1: TDataSource;
    cbbReferente: TComboBox;
    Memo1: TMemo;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroFichaAvaliacao: TFiltroFichaAvaliacao;

implementation

uses u_geral, u_relatorio_fichaespecrequisitos,
  u_relatorio_notasespecrequisitos, u_relatorio_fichaprototipo,
  u_relatorio_fichamanualanalise;

{$R *.dfm}

procedure TFiltroFichaAvaliacao.FormShow(Sender: TObject);
begin
  inherited;

  cbbReferente.Items.Clear;
  SimpleDataSet1.CLose;
  SimpleDataSet1.open;
  while not SimpleDataSet1.Eof do
  begin
    cbbReferente.Items.Add(SimpleDataSet1DESC_AVAL.AsString);
    SimpleDataSet1.Next;
  end;
  SimpleDataSet1.Close;

end;

procedure TFiltroFichaAvaliacao.BitBtn1Click(Sender: TObject);
begin
  inherited;
  case cbbReferente.ItemIndex of
  0:begin
    if RELFichaEspecifRequisitos = nil then
      application.CreateForm(TRELFichaEspecifRequisitos,RELFichaEspecifRequisitos);
    RELFichaEspecifRequisitos.SQLQuery1.Close;
    RELFichaEspecifRequisitos.SQLQuery1.Params[0].AsString := cbbReferente.Text;
    RELFichaEspecifRequisitos.ClientDataSet1.OPEN;
    RELFichaEspecifRequisitos.RLReport1.PreviewModal;
    RELFichaEspecifRequisitos.ClientDataSet1.Close;
    FreeAndNil(RELFichaEspecifRequisitos);

  end;
  1:begin
   if RELFichaManualAnalise = nil then
      Application.CreateForm(TRELFichaManualAnalise,RELFichaManualAnalise);
   RELFichaManualAnalise.rlMemo.Lines.Clear;
   RELFichaManualAnalise.rlMemo.Lines.Text := Memo1.Lines.Text;
   RELFichaManualAnalise.ClientDataSet1.Open;
   RELFichaManualAnalise.RLReport1.PreviewModal;
   RELFichaManualAnalise.ClientDataSet1.Close;
   FreeAndNil(RELFichaManualAnalise);

  end;
  2:begin

    if  RELFichaPrototipo = nil then
      Application.CreateForm(TRELFichaPrototipo,RELFichaPrototipo);
   RELFichaPrototipo.rlMemo.Lines.Clear;
   RELFichaPrototipo.rlMemo.Lines.Text := Memo1.Lines.Text;
   RELFichaPrototipo.ClientDataSet1.Open;
   RELFichaPrototipo.RLReport1.PreviewModal;
   RELFichaPrototipo.ClientDataSet1.Close;
   FreeAndNil(RELFichaPrototipo);

  end;

end;

end;

procedure TFiltroFichaAvaliacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroFichaAvaliacao := nil;

end;

end.
