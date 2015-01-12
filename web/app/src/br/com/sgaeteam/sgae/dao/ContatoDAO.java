package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Contato;

@Component
public class ContatoDAO {

	private final Session session;

	public ContatoDAO(Session session) {
		this.session = session;
	}
	
	public void salva(Contato contato) {
		Transaction tx = session.beginTransaction();
		session.save(contato);
		tx.commit();
	}

	public void altera(Contato contato) {
		Transaction tx = session.beginTransaction();
		session.update(contato);
		tx.commit();
	}

	public void remove(Contato contato) {
		Transaction tx = session.beginTransaction();
		session.delete(contato);
		tx.commit();
	}

	public Contato carrega(Integer id) {
		return (Contato) session.load(Contato.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Contato> listaTudo() {
		return this.session.getNamedQuery("Contato.findAll").list();
	}

}
