unit u_formcontroleavaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, Grids, DBGrids, StdCtrls, DBCtrls, DB,
  DBClient, Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, Mask, jpeg,
  SimpleDS;

type
  TFormMovControleAvaliacao = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    dsTipoAvaliacao: TDataSource;
    sdsTipoAvaliacao: TSimpleDataSet;
    sdsProfessor: TSimpleDataSet;
    dsProfessor: TDataSource;
    sdsProfessorNOME_PROF: TStringField;
    ComboBox1: TComboBox;
    DBGrid2: TDBGrid;
    sdsAluno: TSimpleDataSet;
    dsAluno: TDataSource;
    sdsAlunoNOME_ALU: TStringField;
    sdsProfessorCOD_PROF: TIntegerField;
    sdsAlunoANO_LETIVO: TIntegerField;
    sdsAlunoRA_ALU: TIntegerField;
    sdsAlunoTURMA_ALU: TStringField;
    sdsAlunoEND_ALU: TStringField;
    sdsAlunoCIDADE_ALU: TStringField;
    sdsAlunoUF_ALU: TStringField;
    sdsAlunoFONE_ALU: TStringField;
    sdsAlunoCELULAR_ALU: TStringField;
    sdsAlunoFONE_COMER_ALU: TStringField;
    sdsAlunoEMAIL_ALU: TStringField;
    sdsAlunoCEP_ALU: TStringField;
    sdsAlunoDISP_ORINT_ALU: TStringField;
    sdsAlunoCRONOGRAMA_ALU: TStringField;
    sdsAlunoDATA_CANCELAMENTO_ALU: TDateField;
    sdsAlunoMOTIVO_CANCELAMENTO_ALU: TStringField;
    sdsAlunoCOD_PROFESSOR: TIntegerField;
    sdsAlunoCOD_EMPRESA: TIntegerField;
    sdsAlunoCOD_TURMA: TIntegerField;
    sdsAlunoBAIRRO: TStringField;
    ComboBox2: TComboBox;
    sdsTipoAvaliacaoANO_LETIVO_AVAL: TIntegerField;
    sdsTipoAvaliacaoCOD_AVAL: TIntegerField;
    sdsTipoAvaliacaoDESC_AVAL: TStringField;
    sdsTipoAvaliacaoDATA_BASE_ANUAL_AVAL: TDateField;
    sdsTipoAvaliacaoDATA_BASE_SEMESTRAL_AVAL: TDateField;
    sdsTipoAvaliacaoPESO_AVAL: TFMTBCDField;
    sdsTipoAvaliacaoOBS_AVAL: TStringField;
    dbEdit1: TEdit;
    SQLQueryANO_LETIVO: TIntegerField;
    SQLQueryRA: TIntegerField;
    SQLQueryCOD_AVALIACAO: TIntegerField;
    SQLQueryDATA_ENTREGA: TDateField;
    SQLQueryNOTA_PROF: TFloatField;
    SQLQueryPERC_DESCONTO: TFMTBCDField;
    SQLQueryOBS: TStringField;
    SQLQueryNOTA_AVALIACAO: TFloatField;
    ClientDataSetANO_LETIVO: TIntegerField;
    ClientDataSetRA: TIntegerField;
    ClientDataSetCOD_AVALIACAO: TIntegerField;
    ClientDataSetDATA_ENTREGA: TDateField;
    ClientDataSetNOTA_PROF: TFloatField;
    ClientDataSetPERC_DESCONTO: TFMTBCDField;
    ClientDataSetOBS: TStringField;
    ClientDataSetNOTA_AVALIACAO: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure ComboBox2CloseUp(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClientDataSetDATA_ENTREGAValidate(Sender: TField);
    procedure ClientDataSetNOTA_PROFValidate(Sender: TField);
    procedure ClientDataSetBeforeRefresh(DataSet: TDataSet);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClientDataSetPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  private
    iDiasAtraso : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMovControleAvaliacao: TFormMovControleAvaliacao;

implementation

uses u_geral, DateUtils, Math;

{$R *.dfm}

procedure TFormMovControleAvaliacao.FormShow(Sender: TObject);
begin
  inherited;
  DBEdit1.Text :=IntToStr(YearOf(date));
  ClientDataSet.open;
  sdsProfessor.open;
  sdsTipoAvaliacao.DataSet.Params[0].VALUE := DBEdit1.Text;

  sdsTipoAvaliacao.open;
  while not sdsProfessor.Eof do
  begin
    ComboBox1.AddItem(sdsProfessorNOME_PROF.AsString,sender);
    sdsProfessor.Next;
  end;

  while not sdsTipoAvaliacao.Eof do
  begin
    ComboBox2.AddItem(sdsTipoAvaliacaoDESC_AVAL.AsString,sender);
    sdsTipoAvaliacao.Next;
  end;


end;

procedure TFormMovControleAvaliacao.ComboBox1CloseUp(Sender: TObject);
begin
  inherited;
   // ANO NAO PODE SER VAZIO(PARAMETRO)
  if DBEdit1.Text<>'' then
  begin
    sdsAluno.CLOSE;
    sdsProfessor.Locate('NOME_PROF',ComboBox1.Items[ComboBox1.ItemIndex],[]);
    sdsAluno.DataSet.Params[0].AsString := sdsProfessorCOD_PROF.AsString;
    sdsAluno.DataSet.Params[1].AsString := DBEdit1.Text;
    sdsAluno.OPEN;
  end;
end;

procedure TFormMovControleAvaliacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   FormMovControleAvaliacao := NIL;
end;

procedure TFormMovControleAvaliacao.ClientDataSetBeforePost(
  DataSet: TDataSet);
begin
  inherited;
  //ANTES DE GRAVAR PASSA OS VALORES
  ClientDataSetRA.Value := sdsAlunoRA_ALU.Value;
  ClientDataSetANO_LETIVO.AsString  := sdsAlunoANO_LETIVO.AsString;
  ClientDataSetCOD_AVALIACAO.AsString := sdsTipoAvaliacaoCOD_AVAL.AsString;

end;

procedure TFormMovControleAvaliacao.DBGrid2CellClick(Column: TColumn);
begin
  inherited;
  //caso o ano , o RA_ALU, e o Tipo Avaliação nao forem vazio, entao busca os valores do aluno selecionado
  if (dbEdit1.Text<> '') and (sdsAlunoRA_ALU.AsString<>'')and (sdsTipoAvaliacaoCOD_AVAL.AsString<>'') then
  begin
    sqlquery.CLOSE;

    SQLQuery.ParamByName('ANO_LETIVO').AsString := dbEdit1.Text;
    sqlquery.ParamByName('RA').AsString := sdsAlunoRA_ALU.AsString;
    sqlquery.ParamByName('COD_AVALIACAO').AsString := sdsTipoAvaliacaoCOD_AVAL.AsString;
    ClientDataSet.Close;
    ClientDataSet.Open;
    if not ClientDataSet.IsEmpty then
    begin
      ClientDataSet.Refresh;
      ClientDataSet.Locate('ANO_LETIVO;RA',VarArrayOf([sdsAlunoANO_LETIVO.Value,sdsAlunoRA_ALU.Value]),[]);
    end;
  end;

end;
 //COMBO TIPO AVAL
procedure TFormMovControleAvaliacao.ComboBox2CloseUp(Sender: TObject);
begin
  inherited;
  if DBEdit1.Text<>'' then
  begin
    sdsTipoAvaliacao.CLOSE;
    sdsTipoAvaliacao.DataSet.Params[0].AsString := DBEdit1.Text;
    sdsTipoAvaliacao.OPEN;
    sdsTipoAvaliacao.Locate('DESC_AVAL',ComboBox2.Items[ComboBox2.ItemIndex],[]);
  end;
  DBGrid2.OnCellClick(nil);

end;

procedure TFormMovControleAvaliacao.DBGrid2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  case key of
    VK_UP,VK_DOWN : DBGrid2.OnCellClick(nil);
  end;
end;

procedure TFormMovControleAvaliacao.ClientDataSetDATA_ENTREGAValidate(
  Sender: TField);
begin
  inherited;
  iDiasAtraso := 0;
  //verifica se o cronograma do aluno é semestral ou anual
  if sdsAlunoCRONOGRAMA_ALU.AsString = 'Anual' then
  begin
    iDiasAtraso:= DaysBetween(ClientDataSetDATA_ENTREGA.AsDateTime,sdsTipoAvaliacaoDATA_BASE_ANUAL_AVAL.AsDateTime);
  end
  else
  begin
    iDiasAtraso:= DaysBetween(ClientDataSetDATA_ENTREGA.AsDateTime,sdsTipoAvaliacaoDATA_BASE_SEMESTRAL_AVAL.AsDateTime);
  end;
  MessageDlg('Atenção, '+sdsTipoAvaliacaoDESC_AVAL.AsString+ ' com '+intToStr(iDiasAtraso)+' dias de atraso. ',mtInformation,[mbok],0);
end;

procedure TFormMovControleAvaliacao.ClientDataSetNOTA_PROFValidate(
  Sender: TField);

var i: integer;
    fValorAux,fValor : real;

begin
  i := 0;

  fValor := ClientDataSetNOTA_PROF.AsFloat;
  fValorAux := (ClientDataSetNOTA_PROF.AsFloat * 0.10);
  // dias de atraso é pego quando é digitado a data da entrega.
  while not (i=iDiasAtraso)  do
  begin
    inc(i);
    fValor := fValor -fValorAux;

  end;

  //joga o valor FIXO de 10%
  DBGrid1.Fields[2].AsFloat := 10;
  //Joga o valor calculado no campo Valor Da nota
  DBGrid1.Fields[3].AsFloat := fValor;

  //caso o falor for menor que zero(0) entao , joga o valor =0
  if fValor <  0 then
    fValor := 0;

  ClientDataSetNOTA_AVALIACAO.AsFloat := fValor;
  inherited;
end;

procedure TFormMovControleAvaliacao.ClientDataSetBeforeRefresh(
  DataSet: TDataSet);
begin
  inherited;
  ClientDataSet.ApplyUpdates(0);
end;

procedure TFormMovControleAvaliacao.DBGrid1ColEnter(Sender: TObject);
begin
  inherited;
  //verifica se foi selecionado um orientador , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox1.ItemIndex = -1 then
  begin
    messagedlg('Selecione um orientador!',mtInformation,[mbOk],0);
    ComboBox1.SetFocus;
    exit;
  end;
  //verifica se foi selecionado o tipo de avaliação , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox2.ItemIndex = -1 then
  begin
    messagedlg('Selecione o Tipo de Avaliação!',mtInformation,[mbOk],0);
    ComboBox2.SetFocus;
    exit;
  end;

end;

procedure TFormMovControleAvaliacao.DBGrid1CellClick(Column: TColumn);
begin
  inherited;
  //verifica se foi selecionado um orientador , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox1.ItemIndex = -1 then
  begin
    messagedlg('Selecione um orientador!',mtInformation,[mbOk],0);
    ComboBox1.SetFocus;
    exit;
  end;
  //verifica se foi selecionado o tipo de avaliação , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox2.ItemIndex = -1 then
  begin
    messagedlg('Selecione o Tipo de Avaliação!',mtInformation,[mbOk],0);
    ComboBox2.SetFocus;
    exit;
  end;

end;

procedure TFormMovControleAvaliacao.DBGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  //verifica se foi selecionado um orientador , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox1.ItemIndex = -1 then
  begin
    messagedlg('Selecione um orientador!',mtInformation,[mbOk],0);
    ComboBox1.SetFocus;
    ClientDataSet.Cancel;
    exit;
  end;
  //verifica se foi selecionado o tipo de avaliação , senão mostra uma mensagem e joga o foco para a combo oirientador
  if ComboBox2.ItemIndex = -1 then
  begin
    messagedlg('Selecione o Tipo de Avaliação!',mtInformation,[mbOk],0);
    ComboBox2.SetFocus;
    ClientDataSet.Cancel;
    exit;
  end;

end;

procedure TFormMovControleAvaliacao.ClientDataSetPostError(
  DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
begin
    if Pos('Key violation',E.Message) > 0 then
     begin
        MessageDlg('Registro já cadastrado !',mtError,[mbOK],0);
        ClientDataSet.Cancel;
        ClientDataSet.CancelUpdates;
        DBGrid1.SetFocus;
     end;


end;

end.
