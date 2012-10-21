unit u_formbancas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, Grids, DBGrids, StdCtrls, DBCtrls,
  Mask, DBClient, Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, SimpleDS,
  jpeg,dateUtils;

type
  TFormMovBancas = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit6: TDBEdit;
    Edit7: TDBEdit;
    Edit8: TDBEdit;
    Edit9: TDBEdit;
    sqlProfBanca: TSQLQuery;
    cdsProfBanca: TClientDataSet;
    cdsProfBancaCOD_BANCA: TIntegerField;
    cdsProfBancaCOD_PROF: TIntegerField;
    cdsProfBancaSTATUS_PROF: TStringField;
    dsProfBanca: TDataSource;
    sqlUltimoRegistroMAX: TIntegerField;
    DBEdit1: TDBEdit;
    dsAlunos: TDataSource;
    iedtAnoLetivo: TDBEdit;
    DBEdit3: TDBEdit;
    dsLink: TDataSource;
    sdsAlunos: TSimpleDataSet;
    DBLookupComboBoxAluno: TDBLookupComboBox;
    sdsAlunosANO_LETIVO: TIntegerField;
    sdsAlunosRA_ALU: TIntegerField;
    sdsAlunosTURMA_ALU: TStringField;
    sdsAlunosNOME_ALU: TStringField;
    sdsAlunosEND_ALU: TStringField;
    sdsAlunosCIDADE_ALU: TStringField;
    sdsAlunosUF_ALU: TStringField;
    sdsAlunosFONE_ALU: TStringField;
    sdsAlunosCELULAR_ALU: TStringField;
    sdsAlunosFONE_COMER_ALU: TStringField;
    sdsAlunosEMAIL_ALU: TStringField;
    sdsAlunosCEP_ALU: TStringField;
    sdsAlunosDISP_ORINT_ALU: TStringField;
    sdsAlunosCRONOGRAMA_ALU: TStringField;
    sdsAlunosDATA_CANCELAMENTO_ALU: TDateField;
    sdsAlunosMOTIVO_CANCELAMENTO_ALU: TStringField;
    sdsAlunosCOD_PROFESSOR: TIntegerField;
    sdsProfessor: TSimpleDataSet;
    Label1: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    sdsExcluir: TSQLQuery;
    cdsProfBancanomeprofessor: TStringField;
    mEdit5: TMaskEdit;
    ClientDataSetCOD_BANCA: TIntegerField;
    ClientDataSetANO_LETIVO_BANCA: TIntegerField;
    ClientDataSetRA: TIntegerField;
    ClientDataSetDATA_BANCA: TDateField;
    ClientDataSetHORARIO_BANCA: TTimeField;
    ClientDataSetSEQUENCIA_BANCA: TIntegerField;
    ClientDataSetBLOCO_BANCA: TStringField;
    ClientDataSetSALA_BANCA: TStringField;
    ClientDataSetTITULO_TRAB_BANCA: TStringField;
    ClientDataSetEQUIPAMENTO: TStringField;
    ClientDataSetsqlProfBanca: TDataSetField;
    cbbOportunidade: TDBComboBox;
    ClientDataSetOPORTUNIDADE: TStringField;
    procedure dsProfessorStateChange(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dmedtDataBancaExit(Sender: TObject);
    procedure cdsProfBancaBeforePost(DataSet: TDataSet);
    procedure DBGrid1Enter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
    procedure ClientDataSetAfterPost(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure iedtAnoLetivoExit(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure btnConsultarClick(Sender: TObject);
    procedure ClientDataSetDATA_BANCAValidate(Sender: TField);
    procedure ClientDataSetANO_LETIVO_BANCAValidate(Sender: TField);
    procedure btngravarClick(Sender: TObject);
    procedure ClientDataSetAfterRefresh(DataSet: TDataSet);
    procedure ClientDataSetAfterOpen(DataSet: TDataSet);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure mEdit5KeyPress(Sender: TObject; var Key: Char);
    procedure cbbOportunidadeExit(Sender: TObject);
    procedure DBLookupComboBoxAlunoCloseUp(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cdsProfBancaCOD_PROFValidate(Sender: TField);
  private
  sUltimoRegistro,scodProfessor : String;
  //quar
  CodBanca        : integer;
  procedure BuscaUltimoRegistro;

  // Verifica se existe aluno cadastrado em alguma banca
  function VerificaAluno:Boolean;

  //Verifica se o professor ja possui , alguma banca nessa data e hora...
  function VerificaProfessor : boolean;

  function VerificaProfessorCadastrado : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMovBancas: TFormMovBancas;

implementation

uses u_geral, u_consultabancas;

{$R *.dfm}

procedure TFormMovBancas.dsProfessorStateChange(Sender: TObject);
begin
  inherited;
//  if dsProfBanca.State in [dsinsert,dsedit] then
//      cdsProfBancaCOD_BANCA.AsString := sUltimoRegistro;
end;

procedure TFormMovBancas.btnNovoClick(Sender: TObject);
begin
   inherited;
   CodBanca := 0;
   sUltimoRegistro := '0';
   scodProfessor   := '0';
   BuscaUltimoRegistro;
   DBEdit1.Text :=sUltimoRegistro;

   // traz o ano letivo atual
   iedtAnoLetivo.Text := IntToStr(YearOf(date));
   DBEdit3.SetFocus;
   cbbOportunidade.ItemIndex := 0;
   mEdit5.Clear;
end;

procedure TFormMovBancas.BuscaUltimoRegistro;
begin
//codigo automatico
  sqlUltimoRegistro.Close;
  sqlUltimoRegistro.Open;
  if sqlUltimoRegistro.Fields[0].IsNull then
    sUltimoRegistro := '1'
  else
    sUltimoRegistro :=intToStr(sqlUltimoRegistroMAX.AsInteger +1);

  sqlUltimoRegistro.Close;
end;

procedure TFormMovBancas.dmedtDataBancaExit(Sender: TObject);
begin
   inherited;
//   if (iedtAnoLetivo.text<>'')and (dmedtDataBanca.Text <> '') and not(DataSource.State in [dsinsert,dsedit]) then
//   begin
//      ClientDataSet.Close;
     // SQLQuery.ParamByName('ANO_LETIVO').AsString := iedtAnoLetivo.Text;
      //SQLQuery.ParamByName('DATA_BANCA').AsString := dmedtDataBanca.Text;
      //ClientDataSet.Open;
//   end;
end;

procedure TFormMovBancas.cdsProfBancaBeforePost(DataSet: TDataSet);
begin
  inherited;
  //passa o codigo da banca para o prof/banca
  if DataSource.State in [dsinsert,dsEdit]then
  begin
    cdsProfBancaCOD_BANCA.AsString := ClientDataSetCOD_BANCA.AsString;
    //cdsProfBancaCOD_PROF.AsString  := 
  end;
end;
  // AO ENTRAR NA GRID
procedure TFormMovBancas.DBGrid1Enter(Sender: TObject);
var
  codBanca : integer;
begin
  inherited;
  BuscaUltimoRegistro;
  if DataSource.State in [dsInsert,dsEdit] then
  begin
    sqlUltimoRegistro.open;

    ClientDataSetCOD_BANCA.asstring:= sUltimoRegistro;

    //grava na banca
    ClientDataSet.post;

    //quarda na variavel o ultimo registro + 1
    codBanca := StrToInt(sUltimoRegistro);

    ClientDataSet.Edit;
    //posiciona o registro novamente , no que estava inserindo
    if ClientDataSet.locate('COD_BANCA',codBanca,[])then
    begin
      //entra em estado de EDIÇÃO
      cdsProfBanca.Edit;
      //atribui o codigo da BANCA , para o codBanca da tabela PROF_BANCA
      cdsProfBancaCOD_BANCA.value := codBanca;
      //cdsProfBancaCOD_PROF.AsString := scodProfessor;

    end;

  end;
end;

procedure TFormMovBancas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClientDataSet.Close;
  sdsAlunos.CLOSE;
  FormMovBancas := nil;

end;
   // ANTES DE GRAVAR A BANCA
procedure TFormMovBancas.ClientDataSetBeforePost(DataSet: TDataSet);
begin
  inherited;
    // ATRIBUI O RA E TRATA A HORA
  ClientDataSetRA.Value := sdsAlunosRA_ALU.Value;
  if (mEdit5.Text = '  :  ') then
    ClientDataSetHORARIO_BANCA.AsString := '00:00:00'
  else
    ClientDataSetHORARIO_BANCA.AsString := mEdit5.Text;
end;

procedure TFormMovBancas.ClientDataSetAfterPost(DataSet: TDataSet);
begin
  inherited;

  //atualiza o campo HORARIO
  mEdit5.Clear;
  // SE TIVER GRAVADO 00 ENTAO GRAVA EM BRANCO
  if ClientDataSetHORARIO_BANCA.AsString = '00:00:00' then
    mEdit5.Text := '  :  '
  else
    mEdit5.Text := ClientDataSetHORARIO_BANCA.AsString;
  //oportunidade SETA A POSICAO DA COMBO
  if ClientDataSetOPORTUNIDADE.AsString = '1 Oportunidade' then
    cbbOportunidade.ItemIndex  := 0
  else
    cbbOportunidade.ItemIndex  := 1;

end;

procedure TFormMovBancas.FormShow(Sender: TObject);
begin
  //AO ABRIR O FORM
  inherited;
  sUltimoRegistro := '0';
  scodProfessor := '0';
  CodBanca := 0;
  sdsAlunos.Close;
  sdsAlunos.DataSet.Params[0].AsString := iedtAnoLetivo.Text;
  if iedtAnoLetivo.Text <> ''then
  begin
    sdsAlunos.Open;
    sdsProfessor.Open;
  end;

end;

procedure TFormMovBancas.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
//  ClientDataSet.Edit;
end;

procedure TFormMovBancas.iedtAnoLetivoExit(Sender: TObject);
begin
  inherited;
  // Filtra os alunos por ano letivo
  if DataSource.State in [dsInsert,dsEdit]then
  begin
    sdsAlunos.Close;
    sdsAlunos.DataSet.Params[0].AsString := iedtAnoLetivo.Text;
    sdsAlunos.Open;
  end;
end;

procedure TFormMovBancas.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
    sdsAlunos.Close;
    sdsAlunos.DataSet.Params[0].AsString := iedtAnoLetivo.Text;
    sdsAlunos.Open;
    //atualiza hora
    if ClientDataSetHORARIO_BANCA.AsString = '00:00:00' then
      mEdit5.Text := '  :  '
    else
      mEdit5.Text := ClientDataSetHORARIO_BANCA.AsString;

    //oportunidade
    if ClientDataSetOPORTUNIDADE.AsString = '1 Oportunidade' then
      cbbOportunidade.ItemIndex  := 0
    else
      cbbOportunidade.ItemIndex  := 1;

end;

procedure TFormMovBancas.btnConsultarClick(Sender: TObject);
begin
  inherited;
  if ConsultaBancas = nil then
    Application.CreateForm(TConsultaBancas,ConsultaBancas);
  ConsultaBancas.ShowModal;

  ClientDataSet.Locate('COD_BANCA',ConsultaBancas.cdsConsultaCOD_BANCA.AsString,[]);
  FreeAndNil(ConsultaBancas);
end;

function TFormMovBancas.VerificaAluno: Boolean;
var
  sqlQuery : TSQLQuery;
  wSQL     : WideString;
begin

  // verifica se o aluno esta cadastrado em alguma banca
  sqlQuery := TSQLQuery.Create(self);
  sqlQuery.Close;
  sqlQuery.SQLConnection := DmGeral.SQLConnection;
  wSQL := '';
  wSQL := 'SELECT COUNT(*)';
  wSQL := wSQL + 'FROM BANCA B ';
  wSQL := wSQL + 'WHERE B.ano_letivo_banca = :ANO AND B.ra = :RA ';

  // atribui o  SQL
  sqlQuery.SQL.Text      := wSQL;
  // atribui os parametros
  sqlQuery.ParamByName('ANO').AsString := iedtAnoLetivo.Text;//ClientDataSetANO_LETIVO_BANCA.AsString;
  sqlQuery.ParamByName('RA').AsString :=  sdsAlunosRA_ALU.AsString;
  sqlQuery.Open;

  //se for a 1 oportunidade
  if cbbOportunidade.ItemIndex = 0 then
    result := sqlQuery.Fields[0].Value >= 1
  else
    result := sqlQuery.Fields[0].Value >= 2;


  sqlQuery.close;
  FreeAndNil(sqlQuery);



end;

procedure TFormMovBancas.ClientDataSetDATA_BANCAValidate(Sender: TField);
begin
  inherited;
  // VALIDACAO DA DATA
  if ClientDataSetDATA_BANCA.AsDateTime < DATE then
  begin
    MessageDlg('Data não pode ser menor que a data atual!',mtInformation,[mbOk],0);
    DBEdit3.SetFocus;
  end;
end;

procedure TFormMovBancas.ClientDataSetANO_LETIVO_BANCAValidate(
  Sender: TField);
begin
  inherited;
  //verifica se o ano é valido ,
  if (iedtAnoLetivo.Text <> '') then
    if (StrToInt(iedtAnoLetivo.Text) < 1900) then
    begin
      MessageDlg('Ano inválido!',mtInformation,[mbOk],0);
      iedtAnoLetivo.SetFocus;
    end;;
end;

procedure TFormMovBancas.btngravarClick(Sender: TObject);
begin
  Try
    //sequencia
    if Edit6.Text = '' then
    begin
      messagedlg('Sequencia é obrigatório!',mtWarning,[mbOK],0);
      Edit6.SetFocus;
      exit;
    end;

    //sequencia =1 , o horario tem que ser obrigatorio
    if Edit6.Text = '1' then
    begin
      if mEdit5.Text = '  :  ' then
      begin
        messagedlg('Horário obrigatório!',mtWarning,[mbOK],0);
        mEdit5.SetFocus;
        exit;
      end;
    end;
    ClientDataSet.Post;
    ClientDataSet.ApplyUpdates(0);

    //grava
    //inherited;

  except
    //caso ocorra algum erro cancela tudo...
    ClientDataSet.CancelUpdates;
  end;
  {  try
      if DBGrid1.cdsprofbanca = '' then
    except
     ShowMessage(' O professor nao pode ser excluido);
    end;  }
end;

procedure TFormMovBancas.ClientDataSetAfterRefresh(DataSet: TDataSet);
begin
  inherited;
  mEdit5.Clear;
  if ClientDataSetHORARIO_BANCA.AsString = '00:00:00' then
    mEdit5.Text := '  :  '
  else
    mEdit5.Text := ClientDataSetHORARIO_BANCA.AsString;
end;

procedure TFormMovBancas.ClientDataSetAfterOpen(DataSet: TDataSet);
begin
  inherited;
  mEdit5.Clear;
  if ClientDataSetHORARIO_BANCA.AsString = '00:00:00' then
    mEdit5.Text := '  :  '
  else
    mEdit5.Text := ClientDataSetHORARIO_BANCA.AsString;

  //oportunidade
  if ClientDataSetOPORTUNIDADE.AsString = '1 Oportunidade' then
    cbbOportunidade.ItemIndex  := 0
  else
    cbbOportunidade.ItemIndex  := 1;
end;

procedure TFormMovBancas.Edit6Exit(Sender: TObject);
begin
  inherited;
  if Edit6.Text <> '' then
  begin
    //caso não for a primeira banca (sequencia 1)
    if StrToInt(Edit6.Text) = 1 then
    begin
      // o valor do horario é passado manualmente o no evento Beforpost do ClientDataSet
      if (mEdit5.Text = '  :  ') then
      begin
        MessageDlg('Horário obrigatório , para a sequência 1 !',mtInformation,[mbOk],0);
        mEdit5.SetFocus;
      end;

    end;
  end;
end;

procedure TFormMovBancas.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  //caso nao for numeros de 0 a 9 then , nao faz nada  (#8 <backspace>, #13 <enter>
  if not (key in['0'..'9',#8,#13]) then
    key := #0;
end;

procedure TFormMovBancas.mEdit5KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key in['0'..'9']  then
    ClientDataSet.Edit;
end;

procedure TFormMovBancas.cbbOportunidadeExit(Sender: TObject);
begin
  inherited;

  if (DataSource.State in[dsInsert,dsedit]) then
  begin
    // verifica se o aluno ja esta cadastrado em alguma banca, caso estiver inserindo
    if VerificaAluno  then
    begin
      MessageDlg('Aluno já cadastrado!',mtInformation,[mbok],0);
      DBLookupComboBoxAluno.SetFocus;
      exit;
    end;
  end;

end;

procedure TFormMovBancas.DBLookupComboBoxAlunoCloseUp(Sender: TObject);
begin
  inherited;
  if DataSource.State = dsINsert then
    cdsProfBanca.Insert
  else
    cdsProfBanca.edit;

  //JOGA O PROFESSOR ORIENTADOR PARA GRID
  cdsProfBancaCOD_PROF.Value := sdsAlunosCOD_PROFESSOR.Value;
  // Orientador ou Convidado
  cdsProfBancaSTATUS_PROF.Value := 'Orientador';
end;

procedure TFormMovBancas.Edit9Exit(Sender: TObject);
begin
  inherited;
  DBGrid1.SetFocus;
end;

procedure TFormMovBancas.DataSourceStateChange(Sender: TObject);
begin
  inherited;
  if DataSource.State = dsEdit then
  begin
    BuscaUltimoRegistro;
    sUltimoRegistro := intToStr(strToInt(sUltimoRegistro)-1);
  end;

end;

procedure TFormMovBancas.btnCancelarClick(Sender: TObject);
begin
  inherited;
  ClientDataSet.CancelUpdates;
end;

function TFormMovBancas.VerificaProfessor: boolean;
var
  sqlQuery : TSQLQuery;
  wSQL     : WideString;
begin

  // verifica se o aluno esta cadastrado em alguma banca, na  DATA E HORA especificada
  sqlQuery := TSQLQuery.Create(self);
  sqlQuery.Close;
  sqlQuery.SQLConnection := DmGeral.SQLConnection;
  wSQL := '';
  wSQL := wSQL +' SELECT COUNT(*) ';
  wSQL := wSQL +' FROM prof_banca PB ';
  wSQL := wSQL +' JOIN BANCA B ON (PB.cod_banca = B.cod_banca) ';
  wSQL := wSQL +' WHERE PB.cod_prof = :PROF AND B.data_banca = :DATA AND B.horario_banca = :HORA ';

  // atribui o  SQL
  sqlQuery.SQL.Text      := wSQL;
  // atribui os parametros
  sqlQuery.ParamByName('PROF').AsString := cdsProfBancaCOD_PROF.AsString;
  sqlQuery.ParamByName('DATA').AsString :=  FormatDateTime('mm/dd/yyyy',StrToDateTime(DBEdit3.Text));

  if mEdit5.Text <> '  :  ' then
    sqlQuery.ParamByName('HORA').AsString :=  FormatDateTime('hh:mm:ss',StrToTime(mEdit5.Text))
  else
    sqlQuery.ParamByName('HORA').AsString :=  '00:00:00';
  sqlQuery.Open;


  case cdsProfBanca.State of
    dsEdit : begin
      result := sqlQuery.Fields[0].Value > 1 ;
    end;
    dsInsert :begin
      result := sqlQuery.Fields[0].Value > 0 ;
    end;

  end;

  sqlQuery.close;
  FreeAndNil(sqlQuery);
end;

procedure TFormMovBancas.cdsProfBancaCOD_PROFValidate(Sender: TField);
begin
  inherited;
  //Verifica se o professor ja possui , alguma banca nessa data e hora...
  if VerificaProfessor then
  begin
    MessageDlg('Este professor possui banca nesta data e horario!',mtWarning,[mbOk],0);
    DBGrid1.SetFocus;
    exit;
  end;

  // Verifica se o professor ja esta sendo cadastrado, nao pode ter o professor
  // duas vezes na na mesma banca
    if VerificaProfessorCadastrado then
    begin
      MessageDlg('Professor já cadastrado!',mtWarning,[mbOk],0);
      DBGrid1.SetFocus;
      exit;

    end;


end;

function TFormMovBancas.VerificaProfessorCadastrado: boolean;
var
  sqlQuery : TSQLQuery;
  wSQL     : WideString;
begin

  // verifica se o aluno esta cadastrado em alguma banca
  sqlQuery := TSQLQuery.Create(self);
  sqlQuery.Close;
  sqlQuery.SQLConnection := DmGeral.SQLConnection;

  wSQL := '';
  wSQL := wSQL +' SELECT COUNT(*) ';
  wSQL := wSQL +' FROM prof_banca PB ';
  wSQL := wSQL +' join banca b on(pb.cod_banca = b.cod_banca) ';
  wSQL := wSQL +' WHERE PB.cod_prof = :PROF and pb.cod_banca = :banca ';
  sqlQuery.SQL.Clear;
  // atribui o  SQL
  sqlQuery.SQL.Text      := wSQL;
  // atribui os parametros
  sqlQuery.ParamByName('PROF').AsString := cdsProfBancaCOD_PROF.AsString;
  sqlQuery.ParamByName('banca').AsString :=  cdsProfBancaCOD_BANCA.AsString;
  sqlQuery.Open;

  case cdsProfBanca.State of
    dsEdit : begin
      result := sqlQuery.Fields[0].Value > 1 ;
    end;
    dsInsert :begin
      result := sqlQuery.Fields[0].Value > 0 ;
    end;

  end;

  sqlQuery.close;
  FreeAndNil(sqlQuery);


end;

end.

