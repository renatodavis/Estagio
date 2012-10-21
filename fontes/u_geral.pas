unit u_geral;

interface

uses
  SysUtils, Classes, DBXpress, DB, SqlExpr;

type
  TDmGeral = class(TDataModule)
    SQLConnection: TSQLConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmGeral: TDmGeral;

implementation

uses u_abertura;

{$R *.dfm}

procedure TDmGeral.DataModuleCreate(Sender: TObject);
begin
  DmGeral.SQLConnection.Connected := false;
end;

end.
