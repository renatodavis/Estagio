unit u_login;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QExtCtrls,qt, DBXpress, DB, DBClient, SimpleDS,
  SqlExpr,Variants;

type
  TFRM_Login = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    sedtUsuario: TEdit;
    sedtSenha: TEdit;
    SQLConnection1: TSQLConnection;
    sdsUsuario: TSimpleDataSet;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure sedtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
  private
     Autenticacao : boolean;
     sUsuario     : String;
     sSenha       : String;
     i:integer;

    { Private declarations }
  public

     property Autenticado : Boolean Read Autenticacao;
     property UsuarioDigitado : String Read sUsuario Write sUsuario;
     property SenhaDigitada   : String Read sSenha Write sSenha;

    { Public declarations }
  end;

var
  FRM_Login: TFRM_Login;

implementation

uses u_menu;


{$R *.xfm}

procedure TFRM_Login.FormShow(Sender: TObject);
begin
   sedtUsuario.Clear;
   sedtSenha.clear;
   FormMenu.MainMenu1.Items[0].Enabled := false;
   FormMenu.MainMenu1.Items[1].Enabled := false;
   FormMenu.MainMenu1.Items[2].Enabled := false;



end;

procedure TFRM_Login.btnOkClick(Sender: TObject);
begin

   {busca o usuario cadastrado no banco}
   if (sedtUsuario.text<>'') and (sedtSenha.Text <> '')then
   begin
      sdsUsuario.open;
      if sdsUsuario.Locate('NOME;SENHA',varArrayof([sedtUsuario.Text,sedtSenha.Text]),[]) then
      begin
         sUsuario := sedtUsuario.Text;
         sSenha := sedtSenha.text;
         Autenticacao:= true;
         FormMenu.StatusBar1.Panels[4].Text := 'Usuario ['+sUsuario+']';
         FormMenu.MainMenu1.Items[0].Enabled := true;
         FormMenu.MainMenu1.Items[1].Enabled := true;
         FormMenu.MainMenu1.Items[2].Enabled := true;
         FormMenu.MainMenu1.Items[3].Enabled := true;
         FormMenu.MainMenu1.Items[4].Enabled := true;
         FormMenu.MainMenu1.Items[5].Enabled := true;
         FormMenu.SetFocus;
         close;
         FRM_Login.Free;
         FRM_Login := NIL;
      end
      else
      begin
         showmessage('Usuário inválido!');
         Autenticacao := false;
         sedtUsuario.SetFocus;
        // se digitar a senha ou usuario errado 3 vezes , finaliza a aplicação
        if i >= 3 then
        begin
          close;
        end;

     end;


   end
   else
   begin
     showmessage('Informe o usuário e senha para logar no sistema');
     Inc(I);

     // se digitar a senha ou usuario errado 3 vezes , finaliza a aplicação
     if i >= 3 then
     begin
       close;
     end;
   end;
end;

procedure TFRM_Login.sedtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  // key := NumerosInteiros(key);
end;

procedure TFRM_Login.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   CASE key  OF
   Key_alt+key_f4 :Application.Terminate;
   end;

end;

procedure TFRM_Login.FormCreate(Sender: TObject);
begin
   i:= 0;

end;

procedure TFRM_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FRM_Login := NIL;
end;

procedure TFRM_Login.btnCancelarClick(Sender: TObject);
begin
  CLOSE;
end;

end.
