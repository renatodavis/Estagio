unit u_menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, jpeg, ExtCtrls, StdCtrls, Buttons,shellapi;

type
  TFormMenu = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Alunos1: TMenuItem;
    Movimentaes1: TMenuItem;
    Relatrios1: TMenuItem;
    Sair1: TMenuItem;
    Empresas1: TMenuItem;
    Professor1: TMenuItem;
    ipoDocumento1: TMenuItem;
    Ocorrncias1: TMenuItem;
    Feriado1: TMenuItem;
    Categoria1: TMenuItem;
    N1ControlarDocumentos1: TMenuItem;
    N2ControlarAvaliao1: TMenuItem;
    N3Controlarbanca1: TMenuItem;
    N9Parmetros1: TMenuItem;
    N1RelatriodeAlunos1: TMenuItem;
    N31: TMenuItem;
    N6EscaladeApresentaes1: TMenuItem;
    N7TotaldeBancasporprofessorRH1: TMenuItem;
    N8SolicitaodeEquipamentos1: TMenuItem;
    N9BancasProfessor1: TMenuItem;
    Etiquetas1: TMenuItem;
    N1: TMenuItem;
    Professores1: TMenuItem;
    ProfessorOrientador1: TMenuItem;
    Empresa1: TMenuItem;
    Gerais1: TMenuItem;
    N61: TMenuItem;
    N2AlunoeProfessorOrientador1: TMenuItem;
    N3AlunosporProfessorOrientador1: TMenuItem;
    N2FichadeAvaliao1: TMenuItem;
    N3Notas1: TMenuItem;
    N4Formulrio1: TMenuItem;
    StatusBar1: TStatusBar;
    N9TipoAvaliao1: TMenuItem;
    AcompanhamentodeEstagio1: TMenuItem;
    N3Utilitarios1: TMenuItem;
    N5Ajuda2: TMenuItem;
    N32Backup1: TMenuItem;
    Ajuda1: TMenuItem;
    SobreeSCE1: TMenuItem;
    Finalizar1: TMenuItem;
    N10Turma1: TMenuItem;
    Image1: TImage;
    procedure Alunos1Click(Sender: TObject);
    procedure Empresas1Click(Sender: TObject);
    procedure Professor1Click(Sender: TObject);
    procedure ipoDocumento1Click(Sender: TObject);
    procedure Ocorrncias1Click(Sender: TObject);
    procedure Feriado1Click(Sender: TObject);
    procedure Categoria1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N3Controlarbanca1Click(Sender: TObject);
    procedure N9Parmetros1Click(Sender: TObject);
    procedure N1ControlarDocumentos1Click(Sender: TObject);
    procedure N2ControlarAvaliao1Click(Sender: TObject);
    procedure N1RelatriodeAlunos1Click(Sender: TObject);
    procedure N2Totaldealunosporprofessororientador1Click(Sender: TObject);
    procedure N3FichadeAvaliao1Click(Sender: TObject);
    procedure N5Formulario1Click(Sender: TObject);
    procedure N6EscaladeApresentaes1Click(Sender: TObject);
    procedure N8SolicitaodeEquipamentos1Click(Sender: TObject);
    procedure N9BancasProfessor1Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure RefaEspecificaodeRequisitos1Click(Sender: TObject);
    procedure N3AlunosporProfessorOrientador1Click(Sender: TObject);
    procedure N2AlunoeProfessorOrientador1Click(Sender: TObject);
    procedure N9TipoAvaliao1Click(Sender: TObject);
    procedure Login1Click(Sender: TObject);
    procedure AcompanhamentodeEstagio1Click(Sender: TObject);
    procedure Finalizar1Click(Sender: TObject);
    procedure Professores1Click(Sender: TObject);
    procedure N10Turma1Click(Sender: TObject);
    procedure N31CadastrodeUsurios1Click(Sender: TObject);
    procedure Empresa1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N7TotaldeBancasporprofessorRH1Click(Sender: TObject);
    procedure SobreeSCE1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure N2FichadeAvaliao1Click(Sender: TObject);
    procedure N3Notas1Click(Sender: TObject);
    procedure ProfessorOrientador1Click(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure N32Backup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMenu: TFormMenu;

implementation

uses u_formaluno, u_formempresa, u_formprofessor, u_formtipodocumento,
  u_formocorrencias,  u_formferiado, u_formcategoria,
  u_formparametro, u_formcontroledocumento, u_formcontroleavaliacao,
  u_filtroalunos, u_filtroalunosporprofessor, u_filtroreferente,
  u_filtroemitirnotas, u_filtroformulario,  u_filtroescala,
  u_filtrosolicitacaoequipamentos, u_bancasprofessor, u_formbancas,
  u_relatorio_totalalunosporprofessor, u_relatorio_fichaespecrequisitos,
  u_relatorio_fichamanualanalise, u_relatorio_fichaprototipo,
  u_relatorio_alunosporprofessor, 
  u_relatorio_alunosprofessor, u_formtipoavaliacao, u_login,
  u_rel_formacompanhamento, u_relatorio_notasespecrequisitos,
  u_rel_equipamentos, u_relatorio_etiquetas_professor,
  u_filtroetiquetaprofessor, u_formturma, u_formusuario,
  u_relatorio_etiquetas_empresa, u_relatorio_notasprototipo,
  u_relatorio_notasmanual, u_relatorio_etiquetas_alunoprofessor,
  u_rel_totalbancasprof, u_sobre, u_abertura, u_rel_bancasporprofessor,
  u_relatorio_etiquetas_alunos;

{$R *.dfm}

procedure TFormMenu.Alunos1Click(Sender: TObject);
begin
   if FormCad_Aluno  = nil then
      application.CreateForm(TFormCad_Aluno,FormCad_Aluno);
       FormCad_Aluno.show;
end;

procedure TFormMenu.Empresas1Click(Sender: TObject);
begin
   if FormCad_Empresa = nil then
      application.CreateForm(TFormCad_Empresa,FormCad_Empresa);
   FormCad_Empresa.show;
end;

procedure TFormMenu.Professor1Click(Sender: TObject);
begin
   if FormCad_Professor = nil then
      application.CreateForm(TFormCad_Professor,FormCad_Professor);
   FormCad_Professor.show;
end;

procedure TFormMenu.ipoDocumento1Click(Sender: TObject);
begin
   if FormCad_TipoDocumento = nil then
      Application.CreateForm(TFormCad_TipoDocumento,FormCad_TipoDocumento);
   FormCad_TipoDocumento.show;
end;

procedure TFormMenu.Ocorrncias1Click(Sender: TObject);
begin
   if FormCad_Ocorrencias = nil then
      application.CreateForm(TFormCad_Ocorrencias,FormCad_Ocorrencias);
   FormCad_Ocorrencias.show;
end;

procedure TFormMenu.Feriado1Click(Sender: TObject);
begin
   if FormCad_Feriado = nil then
      Application.CreateForm(TFormCad_Feriado,FormCad_Feriado);
   FormCad_Feriado.show;
end;

procedure TFormMenu.Categoria1Click(Sender: TObject);
begin
   if FormCad_Categoria = nil then
      Application.CreateForm(TFormCad_Categoria,FormCad_Categoria);
   FormCad_Categoria.show;
end;

procedure TFormMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if MessageDlg('Deseja realmente sair do sistema ?',mtInformation,[mbYes,mbNo],0)= mrYes then
      Application.Terminate
   else
      action := caNone;


end;

procedure TFormMenu.N3Controlarbanca1Click(Sender: TObject);
begin

 // if FormBancas = nil then
 //   Application.CreateForm(TFormBancas,FormBancas);
 //  FormBancas.Show;

   if FormMovBancas = nil then
      Application.CreateForm(TFormMovBancas,FormMovBancas);
   FormMovBancas.Show;
end;

procedure TFormMenu.N9Parmetros1Click(Sender: TObject);
begin
   if FormParametro = nil then
      Application.CreateForm(TFormParametro,FormParametro);
   FormParametro.show;
end;

procedure TFormMenu.N1ControlarDocumentos1Click(Sender: TObject);
begin
   if FormMovControleDocumentos = nil then
      application.CreateForm(TFormMovControleDocumentos,FormMovControleDocumentos);
   FormMovControleDocumentos.show;
end;

procedure TFormMenu.N2ControlarAvaliao1Click(Sender: TObject);
begin
   if FormMovControleAvaliacao = nil then
      application.CreateForm(TFormMovControleAvaliacao,FormMovControleAvaliacao);
      FormMovControleAvaliacao.show;
end;

procedure TFormMenu.N1RelatriodeAlunos1Click(Sender: TObject);
begin
   if FiltroAlunos = nil then
      Application.CreateForm(TFiltroAlunos,FiltroAlunos);
      FiltroAlunos.show;
end;

procedure TFormMenu.N2Totaldealunosporprofessororientador1Click(
  Sender: TObject);
begin
   if FiltroAlunosPorProfessor = nil then
      application.CreateForm(TFiltroAlunosPorProfessor,FiltroAlunosPorProfessor);
   FiltroAlunosPorProfessor.show;
end;

procedure TFormMenu.N3FichadeAvaliao1Click(Sender: TObject);
begin
   if FiltroFichaAvaliacao = nil then
      Application.CreateForm(TFiltroFichaAvaliacao,FiltroFichaAvaliacao);
   FiltroFichaAvaliacao.show;
end;

procedure TFormMenu.N5Formulario1Click(Sender: TObject);
begin
   if FiltroFormulario = nil then
      application.CreateForm(TFiltroFormulario,FiltroFormulario);
   FiltroFormulario.show;
end;

procedure TFormMenu.N6EscaladeApresentaes1Click(Sender: TObject);
begin
   if FiltroEscala = nil then
   Application.CreateForm(TFiltroEscala,FiltroEscala);
   FiltroEscala.show;
end;

procedure TFormMenu.N8SolicitaodeEquipamentos1Click(Sender: TObject);
begin
  if RELEquipamentos = nil then
    application.CreateForm(TRELEquipamentos,RELEquipamentos);
  RELEquipamentos.ClientDataSet1.OPEN;
  RELEquipamentos.RLReport1.PreviewModal;
end;

procedure TFormMenu.N9BancasProfessor1Click(Sender: TObject);
begin
   if RELBancasPorProfessor = nil then
      application.CreateForm(TRELBancasPorProfessor,RELBancasPorProfessor);
   RELBancasPorProfessor.ClientDataSet1.Open;
   RELBancasPorProfessor.RLReport1.PreviewModal;
   RELBancasPorProfessor.ClientDataSet1.Close;
   FreeAndNil(RELBancasPorProfessor);

end;

procedure TFormMenu.N61Click(Sender: TObject);
begin

   if RELTotalAlunosPorProfessor = nil then
      application.CreateForm(TRELTotalAlunosPorProfessor,RELTotalAlunosPorProfessor);
      RELTotalAlunosPorProfessor.ClientDataSet1.close;
      RELTotalAlunosPorProfessor.ClientDataSet1.Open;
      RELTotalAlunosPorProfessor.RLReport1.Preview(nil);
      FreeAndNil(RELTotalAlunosPorProfessor);
end;

procedure TFormMenu.RefaEspecificaodeRequisitos1Click(Sender: TObject);
begin
{  if RELFichaEspecifRequisitos = nil then
    Application.CreateForm(TRELFichaEspecifRequisitos,RELFichaEspecifRequisitos);
  RELFichaEspecifRequisitos.ClientDataSet1.Open;
  RELFichaEspecifRequisitos.RLReport1.Preview(NIL);
    RELFichaEspecifRequisitos.ClientDataSet1.Close;;
  FreeAndNil(RELFichaEspecifRequisitos);}
end;

procedure TFormMenu.N3AlunosporProfessorOrientador1Click(Sender: TObject);
begin
   if RELAlunosPorProfessor = nil then
      Application.CreateForm(TRELAlunosPorProfessor,RELAlunosPorProfessor);
   RELAlunosPorProfessor.ClientDataSet1.Close;
   RELAlunosPorProfessor.ClientDataSet1.Open;
   RELAlunosPorProfessor.RLReport1.Preview(nil);
   FreeAndNil(RELAlunosPorProfessor);
end;

procedure TFormMenu.N2AlunoeProfessorOrientador1Click(Sender: TObject);
begin

   if REL_AlunosProfessor = nil then
      Application.CreateForm(TREL_AlunosProfessor,REL_AlunosProfessor);
   REL_AlunosProfessor.ClientDataSet1.Close;
   REL_AlunosProfessor.ClientDataSet1.Open;
   REL_AlunosProfessor.RLReport1.Preview(nil);
   FreeAndNil(REL_AlunosProfessor);

end;

procedure TFormMenu.N9TipoAvaliao1Click(Sender: TObject);
begin
  if FormCad_TipoAvaliacao = nil then
    application.CreateForm(TFormCad_TipoAvaliacao,FormCad_TipoAvaliacao);
  FormCad_TipoAvaliacao.show;
end;

procedure TFormMenu.Login1Click(Sender: TObject);
begin
  if Frm_Login = nil then
    Application.CreateForm(TFrm_Login,Frm_Login);
  Frm_Login.show;

end;

procedure TFormMenu.AcompanhamentodeEstagio1Click(Sender: TObject);
begin
  if RELAcompanhamento = nil then
    application.CreateForm(TRELAcompanhamento,RELAcompanhamento);
  //RELAcompanhamento.ClientDataSet1.Open;
  RELAcompanhamento.RLReport1.PreviewModal;
end;

procedure TFormMenu.Finalizar1Click(Sender: TObject);
begin
  application.Terminate;;
end;

procedure TFormMenu.Professores1Click(Sender: TObject);
begin
  if FiltroEtiquetaProfessor = nil then
    Application.CreateForm(TFiltroEtiquetaProfessor,FiltroEtiquetaProfessor);

  FiltroEtiquetaProfessor.show;
end;

procedure TFormMenu.N10Turma1Click(Sender: TObject);
begin
  if FormCad_Turma = nil then
    Application.CreateForm(TFormCad_Turma,FormCad_Turma);
  FormCad_Turma.Show;
end;

procedure TFormMenu.N31CadastrodeUsurios1Click(Sender: TObject);
begin
  if FormCadUsuario = nil then
    application.CreateForm(TFormCadUsuario,FormCadUsuario);
    FormCadUsuario.Show;

end;

procedure TFormMenu.Empresa1Click(Sender: TObject);
begin
  if Rel_EtiquetasEmpresa = nil then
    Application.CreateForm(TRel_EtiquetasEmpresa,Rel_EtiquetasEmpresa);
  Rel_EtiquetasEmpresa.sdsEmpresa.Open;
  Rel_EtiquetasEmpresa.RLReport1.PreviewModal;
  Rel_EtiquetasEmpresa.sdsEmpresa.Close;
  FreeAndNil(Rel_EtiquetasEmpresa);
end;

procedure TFormMenu.N1Click(Sender: TObject);
begin

  if REL_Alunos = nil then
    REL_Alunos := TREL_Alunos.Create(self);
  REL_Alunos.sdsProfessor.Open;
  REL_Alunos.RLReport1.PreviewModal;
  REL_Alunos.sdsProfessor.close;
  FreeAndNil(REL_Alunos.RLReport1);



end;

procedure TFormMenu.N7TotaldeBancasporprofessorRH1Click(Sender: TObject);
begin
  if REL_TotalBancasProfRH = nil then
    Application.CreateForm(TREL_TotalBancasProfRH,REL_TotalBancasProfRH);
  REL_TotalBancasProfRH.ClientDataSet1.open;
  REL_TotalBancasProfRH.RLReport1.Preview(nil);
  REL_TotalBancasProfRH.ClientDataSet1.close;
end;

procedure TFormMenu.SobreeSCE1Click(Sender: TObject);
begin
  if FormSobre = nil then
    Application.createForm(TFormSobre,FormSobre);
  FormSobre.ShowModal;
end;

procedure TFormMenu.BitBtn1Click(Sender: TObject);
begin
  IF FormAbertura = NIL THEN
    Application.CreateForm(TFormAbertura,FormAbertura);
  FormAbertura.SHOWMODAL;
end;

procedure TFormMenu.N2FichadeAvaliao1Click(Sender: TObject);
begin
  if FiltroFichaAvaliacao = nil then
    FiltroFichaAvaliacao := TFiltroFichaAvaliacao.Create(self);
  FiltroFichaAvaliacao.Show;

end;

procedure TFormMenu.N3Notas1Click(Sender: TObject);
begin
  if FiltroEmitirNotas = nil then
    FiltroEmitirNotas := TFiltroEmitirNotas.Create(FiltroEmitirNotas);
  FiltroEmitirNotas.show;

end;

procedure TFormMenu.ProfessorOrientador1Click(Sender: TObject);
begin
    if REL_EtiquetaAlunoProf = nil then
    REL_EtiquetaAlunoProf := TREL_EtiquetaAlunoProf.Create(self);
  REL_EtiquetaAlunoProf.sdsProfessor.Open;
  REL_EtiquetaAlunoProf.RLReport1.Preview(nil);
  REL_EtiquetaAlunoProf.sdsProfessor.close;

end;

procedure TFormMenu.Ajuda1Click(Sender: TObject);
begin
  if FileExists('D:\DadosRenato\Estágio 2004\ajuda\ESTAGIO.HLP') then
    ShellExecute(Handle, 'open','D:\DadosRenato\Estágio 2004\ajuda\ESTAGIO.HLP', nil, nil, SW_SHOWNORMAL);

end;

procedure TFormMenu.N32Backup1Click(Sender: TObject);
begin
  if FileExists('c:\sce\backuprestore.exe') then
    WinExec(PChar('c:\sce\backuprestore.exe c:\sce\banco\banco.fb c:\sce\banco sce'),SW_SHOW);
end;

end.
