package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Aluno;

@Component
public class AlunoDAO {

	private final Session session;

	public AlunoDAO(Session session) {
		this.session = session;
	}

	public void salva(Aluno aluno) {
		Transaction tx = session.beginTransaction();
		session.save(aluno.getEnderecoid());
		session.save(aluno.getContatoid());
		session.save(aluno);
		tx.commit();
	}

	public void altera(Aluno aluno) {
		Transaction tx = session.beginTransaction();
		session.update(aluno.getEnderecoid());
		session.update(aluno.getContatoid());
		session.update(aluno);
		tx.commit();
	}

	public void remove(Aluno aluno) {
		Transaction tx = session.beginTransaction();
		session.delete(aluno);
		tx.commit();
	}

	public Aluno carrega(Long id) {
		return (Aluno) session.load(Aluno.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Aluno> listaTudo() {
		return this.session.getNamedQuery("Aluno.findAll").list();
	}

	@SuppressWarnings("unchecked")
	public List<Aluno> listaTudoValido() {
		return this.session.getNamedQuery("Aluno.findByValido").setParameter("valido","S").list();
	}
	@SuppressWarnings("unchecked")
	public List<Aluno> listaAlunosUnidade() {
		return this.session.getNamedQuery("Aluno.findByUnidadeId").setParameter("valido","S").list();
	}

	@SuppressWarnings("unchecked")
	public List<Aluno> listaAlunosUnidade(Integer id) {
		return this.session.getNamedQuery("Aluno.findByUnidadeId")
			    		   .setParameter("UnidadeId", id.intValue())
			    		   .list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Aluno> listaAlunosValidosUnidade(Integer id) {
		return this.session.getNamedQuery("Aluno.findByUnidadeIdValido")
			    		   .setParameter("UnidadeId", id.intValue())
			    		   .setParameter("valido","S")
			    		   .list();
	}
		
}
