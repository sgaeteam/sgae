package br.com.sgaeteam.sgae.infra;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import br.com.caelum.vraptor.ioc.ApplicationScoped;
import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.ComponentFactory;



/**
 * @author mart97
 * FabricaDeSessoes.java
 * Respons�vel em abrir sess�es necess�rias para as transa��es do Hibernate.
 */

@Component
@ApplicationScoped
public class FabricaDeSessoes implements ComponentFactory<SessionFactory> {
	
	private SessionFactory factory;
	
	@PostConstruct
	public void abre() {
		Configuration configuration = new Configuration();
		configuration.configure();
		
		this.factory = configuration.buildSessionFactory();
		System.out.println("SGAE: Abrindo a f�brica de sess�es..."); // Estudar o uso do log4j
	}

	public SessionFactory getInstance() {
		return this.factory;
	}

	@PreDestroy
	public void fecha() {
		this.factory.close();
		System.out.println("SGAE: Fechando a f�brica de sess�es..."); // Estudar o uso do log4j
	}
}
