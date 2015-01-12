package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Endereco;

@Component
public class EnderecoDAO {

	private final Session session;

	public EnderecoDAO(Session session) {
		this.session = session;
	}
	
	public void salva(Endereco endereco) {
		Transaction tx = session.beginTransaction();
		session.save(endereco);
		tx.commit();
	}

	public void altera(Endereco endereco) {
		Transaction tx = session.beginTransaction();
		session.update(endereco);
		tx.commit();
	}

	public void remove(Endereco endereco) {
		Transaction tx = session.beginTransaction();
		session.delete(endereco);
		tx.commit();
	}
	
	public Endereco carrega(Integer id) {
		return (Endereco) session.load(Endereco.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Endereco> listaTudo() {
		return this.session.getNamedQuery("Endereco.findAll").list();
	}

}
