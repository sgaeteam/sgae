package br.com.sgaeteam.sgae.controller;

import java.util.List;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.sgaeteam.sgae.dao.PerfilDAO;
import br.com.sgaeteam.sgae.infra.Publico;
import br.com.sgaeteam.sgae.model.Perfil;

@Resource
public class PerfisController {

	private final PerfilDAO dao;

	public PerfisController(PerfilDAO dao) {
		this.dao = dao;
	}

	@Get
	@Path("/perfis")
	@Publico
	public List<Perfil> lista() {
		return dao.listaTudo();
	}

	@Get
	@Path("/perfis/{id}")
	@Publico
	public Perfil edita(Integer id) {
		return dao.carrega(id);
	}
}
