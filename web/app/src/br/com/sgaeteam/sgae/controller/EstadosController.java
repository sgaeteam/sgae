package br.com.sgaeteam.sgae.controller;

import java.util.List;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.sgaeteam.sgae.dao.EstadoDAO;
import br.com.sgaeteam.sgae.infra.Publico;
import br.com.sgaeteam.sgae.model.Estado;

@Resource
public class EstadosController {

	private final EstadoDAO dao;

	public EstadosController(EstadoDAO dao) {
		this.dao = dao;
	}

	@Get
	@Path("/estados")
	@Publico
	public List<Estado> lista() {
		return dao.listaTudo();
	}

	@Get
	@Path("/estados/{id}")
	@Publico
	public Estado edita(Integer id) {
		return dao.carrega(id);
	}
}
