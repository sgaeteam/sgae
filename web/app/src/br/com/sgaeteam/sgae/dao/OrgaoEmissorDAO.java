package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.OrgaoEmissor;

@Component
public class OrgaoEmissorDAO {

	private final Session session;

	public OrgaoEmissorDAO(Session session) {
		this.session = session;
	}
	
	public void salva(OrgaoEmissor orgaoEmissor) {
		Transaction tx = session.beginTransaction();
		session.save(orgaoEmissor);
		tx.commit();
	}

	public void altera(OrgaoEmissor orgaoEmissor) {
		Transaction tx = session.beginTransaction();
		session.update(orgaoEmissor);
		tx.commit();
	}

	public void remove(OrgaoEmissor orgaoEmissor) {
		Transaction tx = session.beginTransaction();
		session.delete(orgaoEmissor);
		tx.commit();
	}
	
	public OrgaoEmissor carrega(Integer id) {
		return (OrgaoEmissor) session.load(OrgaoEmissor.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<OrgaoEmissor> listaTudo() {
		return this.session.getNamedQuery("OrgaoEmissor.findAll").list();
	}

	public OrgaoEmissor listaPorSigla(String sigla) {
		return (OrgaoEmissor) this.session.getNamedQuery("OrgaoEmissor.findBySigla")
							.setParameter("sigla", sigla)
							.uniqueResult();
	}

}
