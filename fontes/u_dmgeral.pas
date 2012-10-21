unit u_dmgeral;

interface

uses
  SysUtils, Classes, DBXpress, DB, SqlExpr, RLFilters, RLDraftFilter;

type
  TdmGeral = class(TDataModule)
    SQLConnection: TSQLConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmGeral: TdmGeral;

implementation

{$R *.dfm}

end.
