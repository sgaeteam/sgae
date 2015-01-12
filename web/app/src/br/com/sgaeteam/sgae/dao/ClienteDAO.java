package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Cliente;

@Component
public class ClienteDAO {

	private final Session session;

	public ClienteDAO(Session session) {
		this.session = session;
	}

	public void salva(Cliente cliente) {
		Transaction tx = session.beginTransaction();
		session.save(cliente);
		tx.commit();
	}

	public void altera(Cliente cliente) {
		Transaction tx = session.beginTransaction();
		session.update(cliente);
		tx.commit();
	}

	public void remove(Cliente cliente) {
		Transaction tx = session.beginTransaction();
		session.delete(cliente);
		tx.commit();
	}

	public Cliente carrega(Integer id) {
		return (Cliente) session.createCriteria(Cliente.class)
								.add(Restrictions.eq("id", id))
								.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	public List<Cliente> listaTudo() {
		return this.session.getNamedQuery("Cliente.findAll").list();
	}

}