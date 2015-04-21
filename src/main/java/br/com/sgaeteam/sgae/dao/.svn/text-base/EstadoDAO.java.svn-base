package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Estado;

@Component
public class EstadoDAO {

	private final Session session;

	public EstadoDAO(Session session) {
		this.session = session;
	}
	
	public void salva(Estado estado) {
		Transaction tx = session.beginTransaction();
		session.save(estado);
		tx.commit();
	}

	public void altera(Estado estado) {
		Transaction tx = session.beginTransaction();
		session.update(estado);
		tx.commit();
	}

	public void remove(Estado estado) {
		Transaction tx = session.beginTransaction();
		session.delete(estado);
		tx.commit();
	}

	public Estado carrega(Integer id) {
		return (Estado) session.load(Estado.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Estado> listaTudo() {
		return this.session.getNamedQuery("Estado.findAll").list();
	}

	public Estado listaPorSigla(String sigla) {
		return (Estado) this.session.getNamedQuery("Estado.findBySigla")
							.setParameter("sigla", sigla)
							.uniqueResult();
	}

}
