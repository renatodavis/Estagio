unit u_bancasprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFiltroBancasProfessor = class(TFiltroPadrao)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroBancasProfessor: TFiltroBancasProfessor;

implementation

{$R *.dfm}

procedure TFiltroBancasProfessor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroBancasProfessor := nil;

end;

end.
