unit u_filtroescala;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_filtropadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls, FMTBcd,
  DBCtrls, SqlExpr, Provider, DB, DBClient;

type
  TFiltroEscala = class(TFiltroPadrao)
    Label2: TLabel;
    Label3: TLabel;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    SQLQuery1: TSQLQuery;
    ClientDataSet1COD_PROF: TIntegerField;
    ClientDataSet1NOME_PROF: TStringField;
    ClientDataSet1FONE_PROF: TStringField;
    ClientDataSet1CELULAR_PROF: TStringField;
    ClientDataSet1EMAIL_PROF: TStringField;
    ClientDataSet1CATEGORIA_PROF: TIntegerField;
    cbbProfessor: TComboBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientDataSet1AfterOpen(DataSet: TDataSet);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBCombobox1CloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbProfessorCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltroEscala: TFiltroEscala;

implementation

uses u_relatorio_escalabancas, u_geral;

{$R *.dfm}

procedure TFiltroEscala.BitBtn1Click(Sender: TObject);
var
  wSQL : WideString;
begin
  inherited;
   if RELEscalaApresentacoesBancas = nil then
      application.CreateForm(TRELEscalaApresentacoesBancas,RELEscalaApresentacoesBancas);
      RELEscalaApresentacoesBancas.SQLQuery1.clOSE;
      wSQL:='';
      wSQL:= wSQL + 'SELECT PB.cod_prof, A.NOME_ALU,A.TURMA_ALU,P.NOME_PROF,B.DATA_BANCA,B.HORARIO_BANCA,B.SEQUENCIA_BANCA,B.BLOCO_BANCA,B.COD_BANCA,B.SALA_BANCA ';
      wSQL:= wSQL + 'FROM ALUNO A ';
      wSQL:= wSQL + 'JOIN PROFESSOR P ON(A.COD_PROFESSOR = P.COD_PROF) ';
      wSQL:= wSQL + '    JOIN PROF_BANCA PB ON(PB.COD_PROF = P.COD_PROF) ';
      wSQL:= wSQL + '    JOIN BANCA B ON(B.ANO_LETIVO_BANCA = A.ANO_LETIVO AND B.RA = A.RA_ALU) ';


      // busca todas as bancas
      if cbbProfessor.Text <> 'TODOS' then
      begin
        wSQL:= wSQL + 'WHERE pb.cod_prof = :PROFESSOR ';
        wSQL:= wSQL + 'GROUP BY PB.cod_prof, A.NOME_ALU,A.TURMA_ALU,P.NOME_PROF,B.DATA_BANCA,B.HORARIO_BANCA,B.SEQUENCIA_BANCA,B.BLOCO_BANCA,B.COD_BANCA,B.SALA_BANCA ';
        wSQL:= wSQL + 'order by p.nome_prof,b.data_banca';
        RELEscalaApresentacoesBancas.SQLQuery1.SQL.Text := wSQL;
        RELEscalaApresentacoesBancas.SQLQuery1.Params[0].Value := ClientDataSet1COD_PROF.Value;
      end
      else
      begin
         // busca de acordo com o professor selecionado
        wSQL:= wSQL + 'GROUP BY PB.cod_prof, A.NOME_ALU,A.TURMA_ALU,P.NOME_PROF,B.DATA_BANCA,B.HORARIO_BANCA,B.SEQUENCIA_BANCA,B.BLOCO_BANCA,B.COD_BANCA,B.SALA_BANCA ';
        wSQL:= wSQL + 'order by p.nome_prof,b.data_banca';
        RELEscalaApresentacoesBancas.SQLQuery1.SQL.Text := wSQL;
      end;


      RELEscalaApresentacoesBancas.ClientDataSet1.close;
      RELEscalaApresentacoesBancas.ClientDataSet1.Open;
      RELEscalaApresentacoesBancas.RLReport1.Preview(nil);
      RELEscalaApresentacoesBancas.ClientDataSet1.close;
      FreeAndNil(RELEscalaApresentacoesBancas);
end;

procedure TFiltroEscala.FormShow(Sender: TObject);
begin
  inherited;
  ClientDataSet1.Close;
  ClientDataSet1.OPEN;
  ClientDataSet1.Locate('NOME_PROF',cbbProfessor.Text,[]);

end;

procedure TFiltroEscala.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClientDataSet1.CLOSE;
  FiltroEscala := nil;
end;

procedure TFiltroEscala.ClientDataSet1AfterOpen(DataSet: TDataSet);
begin
  inherited;
  ClientDataSet1.First;
  cbbProfessor.Clear;
  cbbProfessor.AddItem('TODOS',SELF);
  WHILE NOT ClientDataSet1.Eof DO
  begin
    cbbProfessor.AddItem(ClientDataSet1NOME_PROF.AsString,self);
    ClientDataSet1.next;
  end;
  cbbProfessor.ItemIndex := 0;

end;

procedure TFiltroEscala.BitBtn3Click(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TFiltroEscala.DBCombobox1CloseUp(Sender: TObject);
begin
  inherited;
//  ClientDataSet1.Locate('NOME_PROF',DBComboBox1.Text,[]);
end;

procedure TFiltroEscala.FormCreate(Sender: TObject);
begin
  inherited;
  SQLQuery1.SQLConnection := DmGeral.SQLConnection;
end;

procedure TFiltroEscala.cbbProfessorCloseUp(Sender: TObject);
begin
  inherited;
  ClientDataSet1.Locate('NOME_PROF',cbbProfessor.Text,[]);

end;

end.
