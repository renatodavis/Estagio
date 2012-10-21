unit u_filtronotasfinais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFiltroNotasFinais = class(TFiltroPadrao)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroNotasFinais: TFiltroNotasFinais;

implementation

{$R *.dfm}

procedure TFiltroNotasFinais.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroNotasFinais := nil;

end;

end.
