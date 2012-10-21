program SCE;

uses
  Forms,
  sysutils,
  u_menu in 'fontes\u_menu.pas' {FormMenu},
  u_formpadrao in 'fontes\u_formpadrao.pas' {FormPadrao},
  u_formaluno in 'fontes\u_formaluno.pas' {FormCad_Aluno},
  u_formprofessor in 'fontes\u_formprofessor.pas' {FormCad_Professor},
  u_formtipodocumento in 'fontes\u_formtipodocumento.pas' {FormCad_TipoDocumento},
  u_formtipoavaliacao in 'fontes\u_formtipoavaliacao.pas' {FormCad_TipoAvaliacao},
  u_formocorrencias in 'fontes\u_formocorrencias.pas' {FormCad_Ocorrencias},
  u_formempresa in 'fontes\u_formempresa.pas' {FormCad_Empresa},
  u_formferiado in 'fontes\u_formferiado.pas' {FormCad_Feriado},
  u_formcategoria in 'fontes\u_formcategoria.pas' {FormCad_Categoria},
  u_formcontroledocumento in 'fontes\u_formcontroledocumento.pas' {FormMovControleDocumentos},
  u_formparametro in 'fontes\u_formparametro.pas' {FormParametro},
  u_filtropadrao in 'fontes\filtros\u_filtropadrao.pas' {FiltroPadrao},
  u_filtroalunos in 'fontes\filtros\u_filtroalunos.pas' {FiltroAlunos},
  u_filtroalunosporprofessor in 'fontes\filtros\u_filtroalunosporprofessor.pas' {FiltroAlunosPorProfessor},
  u_filtroreferente in 'fontes\filtros\u_filtroreferente.pas' {FiltroFichaAvaliacao},
  u_filtroemitirnotas in 'fontes\filtros\u_filtroemitirnotas.pas' {FiltroEmitirNotas},
  u_filtroformulario in 'fontes\filtros\u_filtroformulario.pas' {FiltroFormulario},
  u_filtroescala in 'fontes\filtros\u_filtroescala.pas' {FiltroEscala},
  u_filtrototalbancasrh in 'fontes\filtros\u_filtrototalbancasrh.pas' {FiltroTotalBancasRH},
  u_filtrosolicitacaoequipamentos in 'fontes\filtros\u_filtrosolicitacaoequipamentos.pas' {FiltroSolicitacaoEquipamentos},
  u_bancasprofessor in 'fontes\filtros\u_bancasprofessor.pas' {FiltroBancasProfessor},
  u_relatorio_padrao in 'fontes\relatorios\u_relatorio_padrao.pas' {RELPadrao},
  u_relatorio_alunos in 'fontes\relatorios\u_relatorio_alunos.pas' {RELAlunos},
  u_relatorio_alunosprofessor in 'fontes\relatorios\u_relatorio_alunosprofessor.pas' {REL_AlunosProfessor},
  u_relatorio_alunosporprofessor in 'fontes\relatorios\u_relatorio_alunosporprofessor.pas' {RELAlunosPorProfessor},
  u_formbancas in 'fontes\u_formbancas.pas' {FormMovBancas},
  u_relatorio_totalalunosporprofessor in 'fontes\relatorios\u_relatorio_totalalunosporprofessor.pas' {RELTotalAlunosPorProfessor},
  u_relatorio_fichaespecrequisitos in 'fontes\relatorios\u_relatorio_fichaespecrequisitos.pas' {RELFichaEspecifRequisitos},
  u_relatorio_fichaprototipo in 'fontes\relatorios\u_relatorio_fichaprototipo.pas' {RELFichaPrototipo},
  u_relatorio_fichamanualanalise in 'fontes\relatorios\u_relatorio_fichamanualanalise.pas' {RELFichaManualAnalise},
  u_relatorio_notasespecrequisitos in 'fontes\relatorios\u_relatorio_notasespecrequisitos.pas' {RELNotasespecifRequisitos},
  u_relatorio_escalabancas in 'fontes\relatorios\u_relatorio_escalabancas.pas' {RELEscalaApresentacoesBancas},
  u_geral in 'fontes\u_geral.pas' {DmGeral: TDataModule},
  u_login in 'fontes\u_login.pas' {FRM_Login},
  u_rel_equipamentos in 'fontes\relatorios\u_rel_equipamentos.pas' {RELEquipamentos},
  u_rel_formacompanhamento in 'fontes\relatorios\u_rel_formacompanhamento.pas' {RELAcompanhamento},
  u_relatorio_etiquetas_professor in 'fontes\relatorios\u_relatorio_etiquetas_professor.pas' {RELEtiquetasProfessor},
  u_filtroetiquetaprofessor in 'fontes\filtros\u_filtroetiquetaprofessor.pas' {FiltroEtiquetaProfessor},
  u_consultaaluno in 'fontes\u_consultaaluno.pas' {ConsultaAlunos},
  u_consultapadrao in 'fontes\u_consultapadrao.pas' {ConsultaPadrao},
  u_consultacategoria in 'fontes\u_consultacategoria.pas' {ConsultaCategoria},
  u_formcontroleavaliacao in 'fontes\u_formcontroleavaliacao.pas' {FormMovControleAvaliacao},
  u_consultaturma in 'fontes\u_consultaturma.pas' {ConsultaTurma},
  u_consultabancas in 'fontes\u_consultabancas.pas' {ConsultaBancas},
  u_consultaempresa in 'fontes\u_consultaempresa.pas' {ConsultaEmpresa},
  u_consultaferiado in 'fontes\u_consultaferiado.pas' {ConsultaFeriado},
  u_consultaocorrencias in 'fontes\u_consultaocorrencias.pas' {ConsultaOcorrencias},
  u_consultatipoavaliacao in 'fontes\u_consultatipoavaliacao.pas' {ConsultaTipoavaliacao},
  u_consultatipodocumento in 'fontes\u_consultatipodocumento.pas' {ConsultaTipoDocumento},
  u_formturma in 'fontes\u_formturma.pas' {FormCad_Turma},
  u_consultaprofessor in 'fontes\u_consultaprofessor.pas' {ConsultaProfessor},
  u_formusuario in 'fontes\u_formusuario.pas' {FormCadUsuario},
  u_consultausuario in 'fontes\u_consultausuario.pas' {ConsultaUsuario},
  u_relatorio_etiquetas_empresa in 'fontes\relatorios\u_relatorio_etiquetas_empresa.pas' {REL_EtiquetasEmpresa},
  u_relatorio_notasprototipo in 'fontes\relatorios\u_relatorio_notasprototipo.pas' {RELNotasPrototipo},
  u_relatorio_notasmanual in 'fontes\relatorios\u_relatorio_notasmanual.pas' {RELNotasManual},
  u_relatorio_etiquetas_alunoprofessor in 'fontes\relatorios\u_relatorio_etiquetas_alunoprofessor.pas' {REL_EtiquetaAlunoProf},
  u_rel_totalbancasprof in 'fontes\relatorios\u_rel_totalbancasprof.pas' {REL_TotalBancasProfRH},
  u_sobre in 'fontes\u_sobre.pas' {FormSobre},
  u_abertura in 'fontes\u_abertura.pas' {FormAbertura},
  u_rel_bancasporprofessor in 'fontes\relatorios\u_rel_bancasporprofessor.pas' {RELBancasPorProfessor},
  u_relatorio_etiquetas_alunos in 'fontes\relatorios\u_relatorio_etiquetas_alunos.pas' {REL_Alunos};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SCE - Sistema Controle de Estágio';
  Application.CreateForm(TFormMenu, FormMenu);
  Application.CreateForm(TDmGeral, DmGeral);
  //Application.CreateForm(TFRM_Login, FRM_Login);

           FormMenu.MainMenu1.Items[0].Enabled := true;
         FormMenu.MainMenu1.Items[1].Enabled := true;
         FormMenu.MainMenu1.Items[2].Enabled := true;
         FormMenu.MainMenu1.Items[3].Enabled := true;
         FormMenu.MainMenu1.Items[4].Enabled := true;
         FormMenu.MainMenu1.Items[5].Enabled := true;

  //FRM_Login.Show;
  // if FRM_Login.Autenticado then
  // FreeAndNil(FRM_Login);
  Application.Run



end.
