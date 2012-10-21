unit u_formdocumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, StdCtrls, DBCtrls, Mask, DB, DBClient,
  Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, jpeg;

type
  TFormMovDocumentos = class(TFormPadrao)
    GroupBox1: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBComboBox1: TDBComboBox;
    DBMemo1: TDBMemo;
    Label6: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMovDocumentos: TFormMovDocumentos;

implementation

{$R *.dfm}

end.
