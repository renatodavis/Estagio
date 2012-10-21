unit u_formpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, FMTBcd, DB, DBClient,
  Provider, SqlExpr,DBGrids,DBCtrls, jpeg;

type
  TFormPadrao = class(TForm)
    PnlTitulo: TPanel;
    StbPadrao: TStatusBar;
    Panel1: TPanel;
    btnNovo: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnCancelar: TBitBtn;
    btngravar: TBitBtn;
    btnFechar: TBitBtn;
    LblTitulo: TLabel;
    SQLQuery: TSQLQuery;
    DataSetProvider: TDataSetProvider;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    sqlUltimoRegistro: TSQLQuery;
    pnlRegistros: TPanel;
    DBNavigator1: TDBNavigator;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
    procedure ClientDataSetReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btngravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure ClientDataSetAfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    procedure GravaDados;
    procedure DesativaBuffer;
    procedure Foco(TabOrder : Integer);
    procedure ActivePageControl;
    { Private declarations }
  public
    function BuscaUltimoRegistro(Campo,Tabela :String):String;
    { Public declarations }
  end;

var
  FormPadrao: TFormPadrao;

implementation

uses u_geral;



{$R *.dfm}

procedure TFormPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   action:= caFree; //libera memoria

end;

procedure TFormPadrao.btnFecharClick(Sender: TObject);
begin
   close;
end;

procedure TFormPadrao.DataSourceStateChange(Sender: TObject);
const
   { esta constante é um array do tipo TDataSetState... para traduzir o estado
   do ClientDataSet... é usado para mostrar no StatusBar}
   Estados : Array [TDataSetState] of String = ('Fechado','Consultando','Alterando','Inserindo','','','','','','','','','Abrindo...');

begin
   { so habilita os campos caso sua funcao esteja habilitada.}

   {o botao gravar soh vai estar habilitado caso o usuario esteja
   alterando/inserindo alguma coisa }
   btnGravar.Enabled          := DataSource.State in [dsEdit, dsInsert];
   btnCancelar.Enabled := btngravar.Enabled;
   //pnlCentral.Enabled         := btngravar.Enabled;
   {o botao excluir só vai ser habilitado caso exista algum registro em buffer
   e o usuario nao esteja alterando}
   btnExcluir.Enabled         := not btnGravar.Enabled and not ClientDataSet.IsEmpty;

   {o botao excluir só vai estar habilitado caso o registro em buffer esteja em
   modo de leitura o nao tenha nenhum registro em buffer}
   btnFechar.Enabled          := DataSource.State in [dsBrowse, dsInactive];

   { joga o estado do cds no primeiro painel do StatusBar }
   stbPadrao.Panels[0].Text := Estados[DataSource.State];
end;

   //
procedure TFormPadrao.ClientDataSetReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
const
   { esta constante "Acao" vai permitir mostrar ao usuario em qual acao aconteceu
   o erro.
   Exemplo: caso o erro aconteça numa alteracao.. vai aparecer uma mensagem,
   dizendo que nao foi possivel ALTERAR o registro em questao }
   Acao : array [TUpdateKind] of string = ('MODIFICAR','INSERIR','EXCLUIR');

var
   Msg : String; //variavel auxiliar para armazenar a mensagem até que ela seja
                  //totalmente formulada para ser mostrada ao usuário

begin
   inherited;
   {
   Mensagem de tratamento dos relacionamentos

   Qdo é uma mensagem de relacionamentos, ela pode ser originada por dois motivos:
   1) uma delecao: outros registros dependem do registro
   2) uma alteracao/insercao: uma FK não está relacionado corretamente. (Isto é improvável,
   visto que a validacao dos campos é feita para cada chave-estrangeira)
   }

   //Caso seja localizada a string "FK_" dentro da mensagem que a excessão lançou
   if Pos('FK_',E.Message) > 0 then
   begin

      //verificamos em que acao aconteceu o erro
      if UpdateKind = ukDelete then
         Msg:='A integridade foi mantida. Outro(s) cadastro(s) depende(m) deste registro.'
      else
         Msg:='Verifique os dados. Existe(m) campo(s) que não está(ão) relacionado(s) corretamente.';

   end;

   {
   Mensagem de tratamento da chave-primária

   Qdo é uma mensagem de tratamento de chave-primaria, siginifica que os campos
   identificadores do registro (PK) já está sendo utilizado por outro registro.
   (Esta mensagem é improvável, visto que a chave-primaria é gerada pela funcao
   u_publica.Incrementa no evento BeforePost...)
   }

   if Pos('PK_',E.Message) > 0 then
      Msg:='Registro já cadastrado !';

   //Mostra a mensagem (agora totalmente formulada) para o usuário!
   ShowMessage(Format('Não foi possível %s o registro. %s',[Acao[UpdateKind], Msg]));

end;

procedure TFormPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case Key of

      VK_RETURN: {Enter}
         begin

            //caso os objetos com o foco nao seja o DBGrid ou o TDBMemoFoco entao,
            //o foco é lançado para o próximo controle ativo
            Try
            if (not (ActiveControl is TDBGrid)) and (not (ActiveControl is TDBMemo)) then
               SelectNext(ActiveControl, True, True);
            except

            end;
         end;

      VK_F4: {Consultar}
         begin

            //if btnConsultar.Visible then
            //   btnConsultar.Click;

         end;

      VK_F2: {Gravar}
         begin
            if btnGravar.Enabled then
               btnGravar.Click;
         end;

      VK_F3: {Excluir}
         begin
            if btnExcluir.Enabled then
               btnExcluir.Click;
         end;

      VK_F9: {Cancelar}
         begin
            if btnCancelar.Enabled then
               btnCancelar.Click;
         end;

      VK_ESCAPE: {Fechar}
         begin
            if btnFechar.Enabled then
               btnFechar.Click;
         end;
   end;
end;

procedure TFormPadrao.GravaDados;

   { essa rotina percorre todos os "Fields" do ClientDataSet e verifica quais
   estao com a propriedade Required = True... em seguida verifica se o valor
   dakele campo nao é nulo... }
   function ValidaPreenchidos(ClientDataSet: TClientDataSet): Boolean;
   var
      i, j: Integer;
   begin

      Result := True;

      for i := 0 to ClientDataSet.FieldCount - 1 do
      begin

         if ClientDataSet.Fields[i].Required then
         begin

            if (ClientDataSet.Fields[i].IsNull) or (ClientDataSet.Fields[i].AsString = '') then
            begin

               Result := False;
               ShowMessage('Campo(s) requerido(s) pelo sistema está(ão) vazio(s).');

               for j := 0 to ComponentCount - 1 do
               begin

                  { DBEdit }
                  if Components[j] is TDBEdit then
                  begin
                     if (Components[j] as TDBEdit).DataField = ClientDataSet.Fields[i].FieldName then
                     begin
                        if (Components[j] as TDBEdit).Parent is TTabSheet then
                           ((Components[j] as TDBEdit).Parent as TTabSheet).Show;

                        (Components[j] as TDBEdit).SetFocus;

                        Break;
                     end;

                  end;

                  { DBComboBox }
                  if Components[j] is TDBComboBox then
                  begin

                     if (Components[j] as TDBComboBox).DataField = ClientDataSet.Fields[i].FieldName then
                     begin
                        if (Components[j] as TDBComboBox).Parent is TTabSheet then
                           ((Components[j] as TDBComboBox).Parent as TTabSheet).Show;

                        (Components[j] as TDBComboBox).SetFocus;

                        Break;
                     end;

                  end;
               end; {for}
            end;

         end;

         { abortando o looping principal }
         if not Result then
            Break;
      end;

   end;

begin
   inherited;
   { posiciona o cursor no próximo controle ativo. Isto é feito para garantir que,
   o foco sai do campo ativo, caso o usuário use teclas de atalho para gravar o
   registro (F2) }
   SelectNext(ActiveControl, True, True);

   { somente irá passar para a rotina de gravacao se estiver inserindo/alterando algo }
   if ClientDataSet.State in [dsEdit, dsInsert] then
   begin

      //se todos os campos obrigatorios estiverem preenchidos, irá gravar os buffer no BD
      if ValidaPreenchidos(ClientDataSet) then
      begin

         //grava
         ClientDataSet.Post;


         { caso ocorra algum erro na gravacao do registro, o estado continuará
         sendo o de edicao... e uma msg será mostrada ao usuário }
         if ClientDataSet.ApplyUpdates(0) > 0 then  //commit
         begin
            //mantem o registro em modo de edição
            ClientDataSet.Edit;

            //joga o foco para o campo com tabOrder = 0
            Foco(0);
         end
         else
         begin

            //caso o registro em buffer tenha sido gravado com sucesso, é lançada
            //uma mensagem no statusBar
            stbPadrao.Panels[0].Text := 'Gravado com sucesso.';

            //joga o foco para o campo com tabOrder = 0
            Foco(0);
         end;

      end;

   end;

end;

procedure TFormPadrao.DesativaBuffer;
var
   i: Integer;
begin
   //caso exista algum campo no "cdsCadastro"
   if ClientDataSet.FieldCount > 0 then
   begin

      ClientDataSet.Close;

      //percorre todos os parametros do "sqlCadastro", limpando-os
      for i := 0 to sqlQuery.Params.Count - 1 do
         sqlQuery.Params[i].Clear;

      ClientDataSet.Open;

   end;

end;

procedure TFormPadrao.Foco(TabOrder: Integer);
var
   i, j: Integer;
begin
   //Ativa a 1a TabSheet do PageControl, caso exista o PageControl.
   ActivePageControl;

   for i := 0 to ComponentCount - 1 do
   begin

      if Components[i] is TDBEdit then
      begin

         if (Components[i] as TDBEdit).TabOrder = TabOrder then
         begin

            if (Components[i] as TDBEdit).Parent is TTabSheet then
               ((Components[i] as TDBEdit).Parent as TTabSheet).Show;

            if (Components[i] as TDBEdit).Enabled then
            begin
               if (Components[i] as TDBEdit).Showing then
               begin

                  (Components[i] as TDBEdit).SetFocus;
                  (Components[i] as TDBEdit).SetFocus;

                  Exit;
               end;
            end;


         end;

      end
      else if Components[i] is TFrame then
      begin

         for j := 0 to (Components[i] as TFrame).ComponentCount -1 do
         begin

            if (Components[i] as TFrame).Components[j] is TDBEdit then
            begin

               if ((Components[i] as TFrame).Components[j] as TDBEdit).Enabled then
               begin
                  if ((Components[i] as TFrame).Components[j] as TDBEdit).Showing then
                  begin

                     ((Components[i] as TFrame).Components[j] as TDBEdit).SetFocus;
                     ((Components[i] as TFrame).Components[j] as TDBEdit).SetFocus;

                     Exit;
                  end;
               end;


            end;

         end;

      end;
   end;
end;
procedure TFormPadrao.ActivePageControl;
var
  i: Integer;
begin

  for i := 0 to ComponentCount - 1 do
  begin

     if Components[i] is TPageControl then
     begin

        (Components[i] as TPageControl).ActivePageIndex := 0;

        Exit;
     end;

  end;
end;

procedure TFormPadrao.btngravarClick(Sender: TObject);
begin
  GravaDados;

end;

procedure TFormPadrao.btnCancelarClick(Sender: TObject);
begin
   ClientDataSet.Cancel;
   // confirma o cancelamento
   ClientDataSet.CancelUpdates;

   //limpa o buffer local
   DesativaBuffer;

   //joga o foco para o campo com a propriedade "TabOrder" igual à 0 (zero)
   Foco(0);
end;

procedure TFormPadrao.btnExcluirClick(Sender: TObject);
begin
   if messagedlg('Deseja excluir o registro atual?',mtconfirmation,[mbYes,mbNo],0)=mryes then
   begin

      ClientDataSet.Delete;

      { caso a delecao nao aconteca o metodo "ApplyUpdates" irá retornar um valor
      maior que zero, dai o evento "ReconcileError" será ativado e irá ser
      mostrada uma msg para o usuário }
      if ClientDataSet.ApplyUpdates(0) > 0 then  //commmit
      begin
         ClientDataSet.CancelUpdates;  //cancela a operacao //rollback
      end
      else
      begin
         stbPadrao.Panels[0].Text := 'Excluído com sucesso.';
         Foco(0);
      end;
     // ClientDataSet.Close;

   end;
end;

procedure TFormPadrao.btnNovoClick(Sender: TObject);
begin
   ClientDataSet.open;
   ClientDataSet.insert;
   Foco(0);
end;

procedure TFormPadrao.FormShow(Sender: TObject);
begin
   //Altera o caption do Form para "Cadastros"
   Caption := 'Cadastros';

   //Desativa o buffer
   //Ao desativar o buffer, os botoes sao habilitados, de acordo com sua função
   //A rotina de habilitar botoes está no dsCadastro.OnStateChange
   DesativaBuffer;

   //Joga o foco para o campo com a propriedade "TabOrder" igual à 0 (zero)
   //Ao jogar o foco, é setado o "Show" na primeira TabSheet, caso exista!

   Foco(0);
end;

procedure TFormPadrao.btnConsultarClick(Sender: TObject);
begin

  Foco(0);
end;

function TFormPadrao.BuscaUltimoRegistro(Campo,Tabela :String):String;

begin
  try
    sqlUltimoRegistro.Close;
    sqlUltimoRegistro.SQL.Text := 'SELECT MAX('+Campo+') FROM '+Tabela;
    sqlUltimoRegistro.Open;
    if sqlUltimoRegistro.Fields[0].IsNull then
      Result := '1'
    else
      Result := IntToStr(sqlUltimoRegistro.Fields[0].AsInteger +1);
  finally
    sqlUltimoRegistro.Close;
  end;

end;

procedure TFormPadrao.ClientDataSetAfterPost(DataSet: TDataSet);   //commmit
begin
  //ClientDataSet.ApplyUpdates(0);
end;

procedure TFormPadrao.FormCreate(Sender: TObject);
begin
  // atribui a conexao ao criar o formulario
  SQLQuery.SQLConnection := DmGeral.SQLConnection;
end;

end.
