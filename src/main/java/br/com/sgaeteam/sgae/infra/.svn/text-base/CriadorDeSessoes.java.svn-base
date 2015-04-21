package br.com.sgaeteam.sgae.infra;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.ComponentFactory;
import br.com.caelum.vraptor.ioc.RequestScoped;



/**
 * @author mart97
 * CriadorDeSessoes.java
 * Responsável em conseguir sessões da Fábrica necessárias para as transações do Hibernate.
 */

@Component
@RequestScoped
public class CriadorDeSessoes implements ComponentFactory<Session> {

	private final SessionFactory sessionFactory;
	public Session session;

	public CriadorDeSessoes(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	@PostConstruct
	public void abre() {
		this.session = this.sessionFactory.openSession();
		System.out.println("SGAE: Abrindo a sessão..."); // Estudar o uso do log4j
	}

	public Session getInstance() {
		return this.session;
	}

	@PreDestroy
	public void fecha() {
		this.session.close();
		System.out.println("SGAE: Fechando a sessão..."); // Estudar o uso do log4j
	}
}
