unit u_formaluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, DBClient, Provider, SqlExpr, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, DBCtrls, SimpleDS, jpeg,dateUtils;

type
  TFormCad_Aluno = class(TFormPadrao)
    ClientDataSetANO_LETIVO: TIntegerField;
    ClientDataSetRA_ALU: TIntegerField;
    ClientDataSetTURMA_ALU: TStringField;
    ClientDataSetNOME_ALU: TStringField;
    ClientDataSetEND_ALU: TStringField;
    ClientDataSetCIDADE_ALU: TStringField;
    ClientDataSetUF_ALU: TStringField;
    ClientDataSetFONE_ALU: TStringField;
    ClientDataSetCELULAR_ALU: TStringField;
    ClientDataSetFONE_COMER_ALU: TStringField;
    ClientDataSetEMAIL_ALU: TStringField;
    ClientDataSetCEP_ALU: TStringField;
    ClientDataSetDISP_ORINT_ALU: TStringField;
    ClientDataSetCRONOGRAMA_ALU: TStringField;
    ClientDataSetDATA_CANCELAMENTO_ALU: TDateField;
    ClientDataSetMOTIVO_CANCELAMENTO_ALU: TStringField;
    ClientDataSetCOD_PROFESSOR: TIntegerField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    dbEditRa: TDBEdit;
    DBEdit2: TDBEdit;
    dbEditAno: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    TabSheet2: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    SpeedButton2: TSpeedButton;
    DBEdit14: TDBEdit;
    DBMemo1: TDBMemo;
    Label18: TLabel;
    sdsEmpresa: TSimpleDataSet;
    sdsOrientador: TSimpleDataSet;
    sdsCronograma: TSimpleDataSet;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBComboBox1: TDBComboBox;
    ClientDataSetCOD_EMPRESA: TIntegerField;
    dsEmpresa: TDataSource;
    dsOrientador: TDataSource;
    DBLookupComboBox3: TDBLookupComboBox;
    ClientDataSetCOD_TURMA: TIntegerField;
    sdsTurma: TSimpleDataSet;
    sdsTurmaCOD_TURMA: TIntegerField;
    sdsTurmaDESCRICAO: TStringField;
    dsTurma: TDataSource;
    ClientDataSetBAIRRO: TStringField;
    sqlBuscaAluno: TSQLQuery;
    sdsOrientadorCOD_PROF: TIntegerField;
    sdsOrientadorNOME_PROF: TStringField;
    sdsOrientadorFONE_PROF: TStringField;
    sdsOrientadorCELULAR_PROF: TStringField;
    sdsOrientadorEMAIL_PROF: TStringField;
    sdsOrientadorCATEGORIA_PROF: TIntegerField;
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btngravarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbEditRaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnConsultarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClientDataSetDATA_CANCELAMENTO_ALUValidate(Sender: TField);
    procedure DBEdit14Exit(Sender: TObject);
    procedure DBEdit6Exit(Sender: TObject);
    procedure dbEditAnoEnter(Sender: TObject);
    procedure ClientDataSetBeforePost(DataSet: TDataSet);
  private
      bAchou  : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCad_Aluno: TFormCad_Aluno;



implementation

uses u_formempresa, u_formprofessor, u_consultaaluno, u_geral;



{$R *.dfm}

procedure TFormCad_Aluno.btnFecharClick(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TFormCad_Aluno.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
    sdsEmpresa.Close;
  sdsOrientador.Close;
    sdsTurma.close;
  FormCad_Aluno := nil;

end;

procedure TFormCad_Aluno.btnNovoClick(Sender: TObject);
begin
   inherited;
   dbEditAno.Text := intTostr(yearOf(date));
   dbEditRa.SetFocus;
end;

procedure TFormCad_Aluno.btngravarClick(Sender: TObject);
begin
   if DBComboBox1.ItemIndex = -1 then
   begin
     TabSheet2.Show;
     messagedlg('Informe o cronograma do aluno!',mtInformation,[mbOk],0);
     DBComboBox1.SetFocus;
     exit;
   end;
   if DBLookupComboBox1.Text = '' then
   begin
     TabSheet2.Show;
     messagedlg('Informe a empresa do aluno!',mtInformation,[mbOk],0);
     DBLookupComboBox1.SetFocus;
     exit;
   end;
   if DBLookupComboBox2.Text = '' then
   begin
     TabSheet2.Show;
     messagedlg('Informe o orientador do aluno!',mtInformation,[mbOk],0);
     DBLookupComboBox2.SetFocus;
     exit;
   end;
   if DataSource.State in [dsInsert] then
   begin

     sqlBuscaAluno.Close;
     sqlBuscaAluno.Params[0].AsString := dbEditRa.Text;
     sqlBuscaAluno.Params[1].AsString := dbEditAno.Text;
     sqlBuscaAluno.Params[2].AsString := sdsOrientadorCOD_PROF.AsString;
     sqlBuscaAluno.Open;
     if sqlBuscaAluno.Fields[0].Value > 0 then
     begin
       messagedlg('Aluno não pode ser cadastrado, pois o mesmo já possui orientador !',mtInformation,[mbOk],0);
       ClientDataSet.Cancel;
       exit;
     end;
   end;
   //grava
   inherited;
   TabSheet1.Show;
   dbEditRa.SetFocus;
end;

procedure TFormCad_Aluno.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case key of
    VK_F4 :btnConsultar.Click;
  end;
end;

procedure TFormCad_Aluno.dbEditRaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  hint := 'Precione <F4> para pesquisar.';
end;

procedure TFormCad_Aluno.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  Hint := '';
  
end;

procedure TFormCad_Aluno.btnConsultarClick(Sender: TObject);
begin
  inherited;
  if ConsultaAlunos   = nil then
    Application.CreateForm(TConsultaAlunos,ConsultaAlunos);

  ConsultaAlunos.ShowModal;
  ClientDataSet.Locate('ANO_LETIVO;RA_ALU',VarArrayOf([ConsultaAlunos.cdsConsultaANO_LETIVO.AsString,ConsultaAlunos.cdsConsultaRA_ALU.AsString]),[]);
  FreeAndNil(ConsultaAlunos);
end;

procedure TFormCad_Aluno.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if FormCad_Empresa = nil then
    Application.CreateForm(TFormCad_Empresa, FormCad_Empresa);
    FormCad_Empresa.Show;
end;

procedure TFormCad_Aluno.SpeedButton2Click(Sender: TObject);
begin
  inherited;
    if FormCad_Professor = nil then
    Application.CreateForm(TFormCad_Professor, FormCad_Professor);
    FormCad_Professor.Show;
end;

procedure TFormCad_Aluno.FormShow(Sender: TObject);
begin
  inherited;
  sdsEmpresa.Open;
  sdsOrientador.Open;
  sdsTurma.open;
end;

procedure TFormCad_Aluno.ClientDataSetDATA_CANCELAMENTO_ALUValidate(
  Sender: TField);
begin
  inherited;
  try
//    ClientDataSetDATA_CANCELAMENTO_ALU.AsDateTime  ;

  except
     ShowMessage('Data Invalida');
  end;
end;

procedure TFormCad_Aluno.DBEdit14Exit(Sender: TObject);
begin
  //inherited;
  Try
    //caso estiver vazio, não trata a data
    if (DBEdit14.Text<>'  /  /    ') then
      StrTodate(DBEdit14.Text);
  except
    messagedlg('Data inválida',mtError,[mbok],0);
  end;
end;

procedure TFormCad_Aluno.DBEdit6Exit(Sender: TObject);
begin
  inherited;
  bAchou := false;

  if DBEdit6.Text = 'PR' then
    bAchou := true
  else if DBEdit6.Text = 'SP' then
    bAchou := True
  else if DBEdit6.Text = 'SC' then
    bAchou := True
  else if DBEdit6.Text = 'RS' then
    bAchou := True
  else if DBEdit6.Text = 'RJ' then
    bAchou := True
  else if DBEdit6.Text = 'ES' then
    bAchou := True
  else if DBEdit6.Text = 'RO' then
    bAchou := True
  else if DBEdit6.Text = 'MT' then
    bAchou := True
  else if DBEdit6.Text = 'MS' then
    bAchou := True
  else if DBEdit6.Text = 'GO' then
    bAchou := True
  else if DBEdit6.Text = 'NO' then
    bAchou := True
  else if DBEdit6.Text = 'MG' then
    bAchou := True
  else if DBEdit6.Text = 'TO' then
    bAchou := True
  else if DBEdit6.Text = 'AL' then
    bAchou := True
  else if DBEdit6.Text = 'AM' then
    bAchou := True
  else if DBEdit6.Text = 'PR' then
    bAchou := true;

  if not bAchou then
  begin
    Messagedlg('Estado Inválido!',mtWarning,[mbOk],0);
    DBEdit6.SetFocus;
  end;

end;

procedure TFormCad_Aluno.dbEditAnoEnter(Sender: TObject);
begin
   inherited;
   dbEditAno.Text := intTostr(yearOf(date));
end;

procedure TFormCad_Aluno.ClientDataSetBeforePost(DataSet: TDataSet);
begin
  inherited;
  ClientDataSetTURMA_ALU.AsString := sdsTurmaDESCRICAO.AsString;
end;

end.
