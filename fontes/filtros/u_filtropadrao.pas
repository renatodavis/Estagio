unit u_filtropadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, jpeg,qt;

type
  TFiltroPadrao = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btnCancelar: TBitBtn;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    Label1: TLabel;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroPadrao: TFiltroPadrao;

implementation

{$R *.dfm}

procedure TFiltroPadrao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  
end;

procedure TFiltroPadrao.btnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFiltroPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    Key_Escape:btnCancelar.Click;
    Key_Enter,Key_Return:SelectNext(ActiveControl,True,True);
  end;
end;

end.
