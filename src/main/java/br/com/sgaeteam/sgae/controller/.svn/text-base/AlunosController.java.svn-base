package br.com.sgaeteam.sgae.controller;

import static br.com.caelum.vraptor.jasperreports.formats.Formats.Pdf;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import br.com.caelum.vraptor.Delete;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Put;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.interceptor.download.Download;
import br.com.caelum.vraptor.jasperreports.Report;
import br.com.caelum.vraptor.jasperreports.ReportDownload;
import br.com.sgaeteam.sgae.report.AlunosReport;
import br.com.sgaeteam.sgae.dao.AlunoDAO;
import br.com.sgaeteam.sgae.infra.Perfil;
import br.com.sgaeteam.sgae.infra.Permissao;
import br.com.sgaeteam.sgae.infra.UsuarioSessao;
import br.com.sgaeteam.sgae.infra.Util;
import br.com.sgaeteam.sgae.model.Aluno;

@Resource
public class AlunosController {

	private final AlunoDAO alunoDao;
	private final Result result;
	private final UsuarioSessao usuarioSessao;

	public AlunosController(AlunoDAO alunoDao, Result result, UsuarioSessao usuarioSessao) {
		
		this.alunoDao = alunoDao;
		this.result = result;
		this.usuarioSessao = usuarioSessao;
		
	}

	@Get
	@Path("/alunos/novo")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
	public void formulario() {
	}

	@Post
	@Path("/alunos")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
	public void adiciona(final Aluno aluno, String callBack) {

		/* Gera Matricula do Aluno */
		int unidadeId = usuarioSessao.getUnidade_id();
		int clienteId = usuarioSessao.getUnidadeLogada().getClienteid().getId();  
		List<Aluno> totalAlunos = alunoDao.listaAlunosUnidade(unidadeId);
		String matricula = Util.gerarMatricula(clienteId, unidadeId, totalAlunos.size());
		aluno.setMatricula(matricula);
		aluno.setDtInscricao(new Date());
		alunoDao.salva(aluno);
		
		result.include("notice","Aluno salvo com sucesso.");
		result.redirectTo(callBack);
		
	}

	@Get
	@Path("/alunos/{id}")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
	public Aluno edita(Long id) {
		
		return alunoDao.carrega(id);
		
	}

	@Put
	@Path("/alunos/{aluno.id}")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
	public void altera(Aluno aluno, String callBack) {
		
		alunoDao.altera(aluno);
		result.include("notice","Aluno editado com sucesso.");
		result.redirectTo(callBack);
		
	}

	@Get
	@Path("/alunos/rl/{id}")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR})
	public void removeLogico(Long id) {
		
		String callBack ="/cadastros/formulario";
		Aluno aluno = alunoDao.carrega(id);
		aluno.setValido("N");
		alunoDao.altera(aluno);
		result.include("notice","Aluno exclu&iacute;do com sucesso.");
		result.redirectTo(callBack);
		
	}	
	
	@Delete
	@Path("/alunos/rf/{id}")
	@Permissao(Perfil.ADM)
	public void removeFisico(Long id, String callBack) {
		
		Aluno aluno = alunoDao.carrega(id);
		alunoDao.remove(aluno);
		result.redirectTo(callBack);
		
	}
	
	@Get
	@Path("/alunos")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP, Perfil.OPR, Perfil.USR})
	public List<Aluno> lista() {	
		
		return alunoDao.listaAlunosValidosUnidade(usuarioSessao.getUnidade_id());
		
	}
	
	@Get
	@Path("/alunos/pdf/{id}")
	public Download pdfReport(Long id) {
		
		Report<Aluno> report = generateReport(id);
		return new ReportDownload(report, Pdf());
	
	}
	
	private Report<Aluno> generateReport(Long id){
	
		List<Aluno> data = new ArrayList<Aluno>();
		 data.add(alunoDao.carrega(id));
		return new AlunosReport(data);
	
	}
	
}