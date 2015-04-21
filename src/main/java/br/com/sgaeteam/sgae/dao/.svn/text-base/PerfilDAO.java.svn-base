package br.com.sgaeteam.sgae.dao;

import java.util.List;

import org.hibernate.Session;

import br.com.caelum.vraptor.ioc.Component;
import br.com.sgaeteam.sgae.model.Perfil;

@Component
public class PerfilDAO {

	private final Session session;

	public PerfilDAO(Session session) {
		this.session = session;
	}

	public Perfil carrega(Integer id) {
		return (Perfil) session.load(Perfil.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<Perfil> listaTudo() {
		return this.session.getNamedQuery("Perfil.findAll").list();
	}

	public Perfil listaPorSigla(String sigla) {
		return (Perfil) this.session.getNamedQuery("Perfil.findBySigla")
							.setParameter("sigla", sigla)
							.uniqueResult();
	}

}
