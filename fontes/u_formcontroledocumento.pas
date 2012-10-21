unit u_formcontroledocumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, StdCtrls, Mask, DBCtrls, Grids, DBGrids,
  DB, DBClient, Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls, jpeg;

type
  TFormMovControleDocumentos = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label11: TLabel;
    DBGrid1: TDBGrid;
    Label3: TLabel;
    Label1: TLabel;
    dbDataEntrega: TDBEdit;
    CDSAluno: TClientDataSet;
    dsAluno: TDataSource;
    SQLaLUNO: TSQLQuery;
    cdsDocumento: TClientDataSet;
    dspDucumento: TDataSetProvider;
    dsDocumento: TDataSource;
    sqlQueryDocumento: TSQLQuery;
    cdsDocumentoCOD_DOC: TIntegerField;
    cdsDocumentoDESC_DOS: TStringField;
    cdsDocumentoOBS_DOC: TStringField;
    cdsTurma: TClientDataSet;
    dspTurma: TDataSetProvider;
    dsTurma: TDataSource;
    sqlTurma: TSQLQuery;
    dspAluno: TDataSetProvider;
    SQLaLUNOANO_LETIVO: TIntegerField;
    SQLaLUNORA_ALU: TIntegerField;
    SQLaLUNOTURMA_ALU: TStringField;
    SQLaLUNONOME_ALU: TStringField;
    SQLaLUNOEND_ALU: TStringField;
    SQLaLUNOCIDADE_ALU: TStringField;
    SQLaLUNOUF_ALU: TStringField;
    SQLaLUNOFONE_ALU: TStringField;
    SQLaLUNOCELULAR_ALU: TStringField;
    SQLaLUNOFONE_COMER_ALU: TStringField;
    SQLaLUNOEMAIL_ALU: TStringField;
    SQLaLUNOCEP_ALU: TStringField;
    SQLaLUNODISP_ORINT_ALU: TStringField;
    SQLaLUNOCRONOGRAMA_ALU: TStringField;
    SQLaLUNODATA_CANCELAMENTO_ALU: TDateField;
    SQLaLUNOMOTIVO_CANCELAMENTO_ALU: TStringField;
    SQLaLUNOCOD_PROFESSOR: TIntegerField;
    CDSAlunoANO_LETIVO: TIntegerField;
    CDSAlunoRA_ALU: TIntegerField;
    CDSAlunoTURMA_ALU: TStringField;
    CDSAlunoNOME_ALU: TStringField;
    CDSAlunoEND_ALU: TStringField;
    CDSAlunoCIDADE_ALU: TStringField;
    CDSAlunoUF_ALU: TStringField;
    CDSAlunoFONE_ALU: TStringField;
    CDSAlunoCELULAR_ALU: TStringField;
    CDSAlunoFONE_COMER_ALU: TStringField;
    CDSAlunoEMAIL_ALU: TStringField;
    CDSAlunoCEP_ALU: TStringField;
    CDSAlunoDISP_ORINT_ALU: TStringField;
    CDSAlunoCRONOGRAMA_ALU: TStringField;
    CDSAlunoDATA_CANCELAMENTO_ALU: TDateField;
    CDSAlunoMOTIVO_CANCELAMENTO_ALU: TStringField;
    CDSAlunoCOD_PROFESSOR: TIntegerField;
    cdsTurmaCOD_TURMA: TIntegerField;
    cdsTurmaDESCRICAO: TStringField;
    comboturma: TComboBox;
    comboDocumentos: TComboBox;
    ClientDataSetANO_LETIVO: TIntegerField;
    ClientDataSetRA: TIntegerField;
    ClientDataSetDESC_DOS: TStringField;
    ClientDataSetENTREGUE: TStringField;
    SQLQueryANO_LETIVO: TIntegerField;
    SQLQueryRA: TIntegerField;
    SQLQueryDESC_DOS: TStringField;
    SQLQueryENTREGUE: TStringField;
    SQLQueryDATA_ENTREGA: TDateField;
    ClientDataSetDATA_ENTREGA: TDateField;
    SQLQueryCOD_DOCUMENTO: TIntegerField;
    ClientDataSetCOD_DOCUMENTO: TIntegerField;
    dbAno: TEdit;
    chbEntregue: TDBCheckBox;
    SQLaLUNOENTREGUE: TStringField;
    CDSAlunoENTREGUE: TStringField;
    procedure comboDocumentosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comboDocumentosChange(Sender: TObject);
    procedure comboTurmaChange(Sender: TObject);
    procedure CDSAlunoBeforeRowRequest(Sender: TObject;
      var OwnerData: OleVariant);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
    procedure dbAnoKeyPress(Sender: TObject; var Key: Char);
    procedure dbAnoExit(Sender: TObject);
    procedure chbEntregueClick(Sender: TObject);
    procedure ClientDataSetAfterPost(DataSet: TDataSet);
    procedure comboDocumentosCloseUp(Sender: TObject);
    procedure btngravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMovControleDocumentos: TFormMovControleDocumentos;

implementation

uses DateUtils;

{$R *.dfm}

procedure TFormMovControleDocumentos.comboDocumentosClick(Sender: TObject);
begin
  inherited;
   cdsDocumento.close;
   cdsDocumento.Open;

end;

procedure TFormMovControleDocumentos.FormShow(Sender: TObject);
begin
   inherited;

  dbAno.Text := IntToStr(YearOf(date));
  cdsDocumento.open;
  cdsTurma.open;
  //CARREGA os tipos de documentos
  while not cdsDocumento.Eof DO
  begin
    comboDocumentos.Items.Add(cdsDocumentoDESC_DOS.AsString);
    cdsDocumento.Next;
  end;
  cdsDocumento.close;
  comboDocumentos.ItemIndex := 0;
  //carrega as turmas
  while not cdsTurma.Eof DO
  begin
    comboTurma.Items.Add(cdsTurmaDESCRICAO.AsString);
    cdsTurma.Next;
  end;
  cdsTurma.close;
 comboturma.ItemIndex := 0;
 SQLaLUNO.ParamByName('ANO_LETIVO').AsString := dbAno.Text;
 SQLaLUNO.ParamByName('TURMA').AsString      := comboTurma.Text;
 CDSAluno.open;


  end;

procedure TFormMovControleDocumentos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FormMovControleDocumentos := NIL;
  cdsDocumento.Close;
  CDSAluno.Close;
end;

procedure TFormMovControleDocumentos.comboDocumentosChange(Sender: TObject);
begin
  inherited;
  //faz atualizacao da grid
  CDSAluno.CLOSE;
  SQLaLUNO.ParamByName('ANO_LETIVO').AsString := dbAno.Text;
  SQLaLUNO.ParamByName('TURMA').AsString := cdsTurmaCOD_TURMA.AsString;
  CDSAluno.open;
end;

procedure TFormMovControleDocumentos.comboTurmaChange(Sender: TObject);
begin
  inherited;
//   ClientDataSet.Close;
 //  SQLQuery.ParamByName('COD_DOC').AsString := cdsDocumentoCOD_DOC.AsString;
//   SQLQuery.ParamByName('ANO_LETIVO').AsString := dbAno.Text;
 //  SQLQuery.ParamByName('TURMA').AsString      := comboTurma.Text;

  CDSAluno.Close;
  SQLaLUNO.ParamByName('ANO_LETIVO').AsString := dbAno.Text;
  SQLaLUNO.ParamByName('TURMA').AsString :=  comboTurma.Text;

  cdsAluno.Open;
  DBGrid1.OnCellClick(nil);
  DBGrid1.SelectedIndex:= 0;
end;

procedure TFormMovControleDocumentos.CDSAlunoBeforeRowRequest(
  Sender: TObject; var OwnerData: OleVariant);
begin
  inherited;
  //atualizacao da grid
  SQLQuery.ParamByName('RA').AsString := CDSAlunoRA_ALU.AsString;
  SQLQuery.ParamByName('ANO').AsString:= CDSAlunoANO_LETIVO.AsString;
  SQLQuery.ParamByName('DOCUMENTO').AsString := comboDocumentos.Text;
  ClientDataSet.Open;
  if ClientDataSet.IsEmpty then
    DBGrid1.Columns[2].PickList[0];
end;

procedure TFormMovControleDocumentos.DBGrid1CellClick(Column: TColumn);
begin
  inherited;
  // atualiza o grid e muda o chbox ENTERGUE NAO ENTREGUE
  ClientDataSet.close;
  SQLQuery.ParamByName('RA').AsString := CDSAlunoRA_ALU.AsString;
  SQLQuery.ParamByName('ANO').AsString:= CDSAlunoANO_LETIVO.AsString;
  SQLQuery.ParamByName('DOCUMENTO').AsString := comboDocumentos.Text;
  ClientDataSet.open;
  //Checked := ClientDataSetENTREGUE.AsString = 'Sim';
//  if not ClientDataSet.isEmpty then
  begin
    if ClientDataSet.Locate('ANO_LETIVO;RA;DESC_DOS',VarArrayOf([CDSAlunoANO_LETIVO.AsString,CDSAlunoRA_ALU.AsString,comboDocumentos.Text]),[]) then
    if ClientDataSetENTREGUE.AsString = 'Sim' then
      //chbEntregue.Checked := true;
     // DBGrid1=: true;
    if chbEntregue.Checked then
     // DBGrid1=: false;
     // dbDataEntrega.Enabled := false
    else
      dbDataEntrega.Enabled := true;
  end;
end;

procedure TFormMovControleDocumentos.ClientDataSetBeforePost(
  DataSet: TDataSet);
begin
  inherited;
  // BUSCA DADOS DO TIPO DOC DE ACORDO COM A SELECAO DA COMBO
  sqlQueryDocumento.Close;
  sqlQueryDocumento.SQL.Text := 'select * from tipo_documento t where t.desc_dos = :descricao';
  sqlQueryDocumento.Params[0].AsString := comboDocumentos.Text;
  cdsDocumento.Open;
  ClientDataSetCOD_DOCUMENTO.AsString := cdsDocumentoCOD_DOC.AsString;
  ClientDataSetRA.AsString :=  CDSAlunoRA_ALU.AsString;
  ClientDataSetANO_LETIVO.AsString := dbAno.Text;

    if chbEntregue.Checked then
    begin
    // validacao da data
      if dbDataEntrega.Text = '  /  /    'then
      begin
        showmessage('Informe a data da entrega!');
        ClientDataSet.CancelUpdates;
        dbDataEntrega.SetFocus;
        exit;
      end;
      // verificao se entergue SIM OU NÃO
      ClientDataSetENTREGUE.AsString := 'Sim'
    end
    else
    begin
      ClientDataSet.Edit;
      ClientDataSetDATA_ENTREGA.AsString := '' ;
      ClientDataSetENTREGUE.AsString := 'Nao';
    end;

end;

procedure TFormMovControleDocumentos.dbAnoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  // #8 backspace
  //#13 <ENTER>
  if not (key in['0'..'9']) and (key <>#8) and (key <>#13)then
    key := #0;
end;

procedure TFormMovControleDocumentos.dbAnoExit(Sender: TObject);
begin
  inherited;
  //validacao do ano letivo
  if dbAno.Text <> ''then
    if StrToInt(dbAno.Text) < YearOf(date) then
    begin
      MessageDlg('O Ano não pode ser menor que o ano atual!',mtError,[mbok],0);
      dbAno.SetFocus;
    end;
end;

procedure TFormMovControleDocumentos.chbEntregueClick(Sender: TObject);
begin
  inherited;
    // VALIDACAO DO ENTREGUE E NAO ENTREGUE
  if chbEntregue.Checked then
    chbEntregue.Caption := 'Entregue'
  else
  begin
    chbEntregue.Caption := 'Não entregue';
    dbDataEntrega.Enabled := true;
  end;
   // JOGA FOCO PARA DATA
  if dbDataEntrega.Enabled then
    dbDataEntrega.SetFocus;
end;

procedure TFormMovControleDocumentos.ClientDataSetAfterPost(
  DataSet: TDataSet);
begin
  inherited;
  ClientDataSet.ApplyUpdates(0);
  ClientDataSet.Close;
  ClientDataSet.open;
  //Atualiza a grid
  CDSAluno.Refresh;

  DBGrid1.OnCellClick(nil);
  DBGrid1.SetFocus;
end;

procedure TFormMovControleDocumentos.comboDocumentosCloseUp(
  Sender: TObject);
begin
  inherited;
  //executa o click da grid
  DBGrid1.OnCellClick(nil);
end;

procedure TFormMovControleDocumentos.btngravarClick(Sender: TObject);
begin
  // VALIDACAO DA DATA SE DATA FOR MENOR OU IGUAL A DATA ATUAL
  if (dbDataEntrega.Text <> '  /  /    ')then
  begin
    if StrToDateTime(dbDataEntrega.Text) <=  date then
      inherited
    else
    begin
      messageDlg('A data não pode ser maior que a data atual !!',mtWarning,[mbOk],0);
      dbDataEntrega.SetFocus;
    end;

  end
  else
  begin
    messageDlg('Informe a data da entrega!',mtWarning,[mbOk],0);
    dbDataEntrega.SetFocus;

  end;

end;

end.
