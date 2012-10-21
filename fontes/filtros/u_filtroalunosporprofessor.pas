unit u_filtroalunosporprofessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFiltroAlunosPorProfessor = class(TFiltroPadrao)
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroAlunosPorProfessor: TFiltroAlunosPorProfessor;

implementation

{$R *.dfm}

procedure TFiltroAlunosPorProfessor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FiltroAlunosPorProfessor := nil;
end;

end.
