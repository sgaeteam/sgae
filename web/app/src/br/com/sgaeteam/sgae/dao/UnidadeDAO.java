package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Unidade;

@Component
public class UnidadeDAO {

	private final Session session;

	public UnidadeDAO(Session session) {
		this.session = session;
	}

	public void salva(Unidade unidade) {
		Transaction tx = session.beginTransaction();
		session.save(unidade);
		tx.commit();
	}

	public void altera(Unidade unidade) {
		Transaction tx = session.beginTransaction();
		session.update(unidade);
		tx.commit();
	}

	public void remove(Unidade unidade) {
		Transaction tx = session.beginTransaction();
		session.delete(unidade);
		tx.commit();
	}

	public Unidade carrega(Integer id) {
		 return (Unidade) session.createCriteria(Unidade.class)
 								 .add(Restrictions.eq("id", id))
 								 .uniqueResult();
	}

	@SuppressWarnings("unchecked")
	public List<Unidade> listaTudo() {
		return this.session.getNamedQuery("Unidade.findAll").list();
	}
}
