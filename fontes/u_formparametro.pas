unit u_formparametro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, StdCtrls, Mask, DBCtrls, DB, DBClient,
  Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, jpeg;

type
  TFormParametro = class(TFormPadrao)
    GroupBox1: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ClientDataSetNOME_INSTITUICAO: TStringField;
    ClientDataSetNOME_CURSO: TStringField;
    ClientDataSetNOME_DISCIPLINA: TStringField;
    ClientDataSetNOME_COORD_CURSO: TStringField;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    ClientDataSetEQUIPAMENTO: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormParametro: TFormParametro;

implementation

{$R *.dfm}

procedure TFormParametro.FormShow(Sender: TObject);
begin
  inherited;
  ClientDataSet.Open;
end;

procedure TFormParametro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormParametro := nil;

end;

end.
