unit u_filtroformulario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFiltroFormulario = class(TFiltroPadrao)
    Label2: TLabel;
    Label3: TLabel;
    cbbReferente: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroFormulario: TFiltroFormulario;

implementation

{$R *.dfm}

procedure TFiltroFormulario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroFormulario := nil;

end;

end.
