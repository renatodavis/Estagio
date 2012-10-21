unit u_filtrosolicitacaoequipamentos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFiltroSolicitacaoEquipamentos = class(TFiltroPadrao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroSolicitacaoEquipamentos: TFiltroSolicitacaoEquipamentos;

implementation

uses u_rel_equipamentos;

{$R *.dfm}

end.
