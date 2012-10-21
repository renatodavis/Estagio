unit u_filtroemitirnotas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB,
  DBClient, SimpleDS;

type
  TFiltroEmitirNotas = class(TFiltroPadrao)
    Label2: TLabel;
    cbbReferente: TComboBox;
    Label3: TLabel;
    DataSource1: TDataSource;
    SimpleDataSet1: TSimpleDataSet;
    SimpleDataSet1ANO_LETIVO_AVAL: TIntegerField;
    SimpleDataSet1COD_AVAL: TIntegerField;
    SimpleDataSet1DESC_AVAL: TStringField;
    SimpleDataSet1DATA_BASE_ANUAL_AVAL: TDateField;
    SimpleDataSet1DATA_BASE_SEMESTRAL_AVAL: TDateField;
    SimpleDataSet1PESO_AVAL: TFMTBCDField;
    SimpleDataSet1OBS_AVAL: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroEmitirNotas: TFiltroEmitirNotas;

implementation

uses u_relatorio_notasespecrequisitos, u_relatorio_notasprototipo,
  u_relatorio_notasmanual;

{$R *.dfm}

procedure TFiltroEmitirNotas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroEmitirNotas := nil;

end;

procedure TFiltroEmitirNotas.BitBtn1Click(Sender: TObject);
begin
  inherited;

  case cbbReferente.ItemIndex of
    0:begin
      //referente ao especificacao de requisitos
      if RELNotasespecifRequisitos = nil then
        application.CreateForm(TRELNotasespecifRequisitos,RELNotasespecifRequisitos);
      RELNotasespecifRequisitos.SQLQuery1.Close;
      RELNotasespecifRequisitos.SQLQuery1.Params[0].AsString := cbbReferente.Text;
      RELNotasespecifRequisitos.ClientDataSet1.OPEN;
      RELNotasespecifRequisitos.RLReport1.PreviewModal;
      RELNotasespecifRequisitos.ClientDataSet1.Close;

    end;
    1:Begin
      //referente ao prototipo do sistema pegue o que estiver selecionado na combo
      if RELNotasPrototipo = nil then
        application.CreateForm(TRELNotasPrototipo,RELNotasPrototipo);
      RELNotasPrototipo.SQLQuery1.Close;
      RELNotasPrototipo.SQLQuery1.Params[0].AsString := cbbReferente.Text;
      RELNotasPrototipo.ClientDataSet1.OPEN;
      RELNotasPrototipo.RLReport1.PreviewModal;
      RELNotasPrototipo.ClientDataSet1.Close;
    end;
    2:begin //referente ao manual de analise
      if RELNotasManual = nil then
        application.CreateForm(TRELNotasManual,RELNotasManual);
      RELNotasManual.SQLQuery1.Close;
      RELNotasManual.SQLQuery1.Params[0].AsString := cbbReferente.Text;
      RELNotasManual.ClientDataSet1.OPEN;

      RELNotasManual.RLReport1.PreviewModal;
      RELNotasManual.ClientDataSet1.Close
    end;
  end;
end;

procedure TFiltroEmitirNotas.FormShow(Sender: TObject);
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

end.
