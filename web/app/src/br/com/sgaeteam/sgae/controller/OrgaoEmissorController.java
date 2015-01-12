package br.com.sgaeteam.sgae.controller;

import java.util.List;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.sgaeteam.sgae.dao.OrgaoEmissorDAO;
import br.com.sgaeteam.sgae.infra.Publico;
import br.com.sgaeteam.sgae.model.OrgaoEmissor;

@Resource
public class OrgaoEmissorController {

	private final OrgaoEmissorDAO dao;

	public OrgaoEmissorController(OrgaoEmissorDAO dao) {
		this.dao = dao;
	}

	@Get
	@Path("/orgaoemissor")
	@Publico
	public List<OrgaoEmissor> lista() {
		return dao.listaTudo();
	}

	@Get
	@Path("/orgaoemissor/{id}")
	@Publico
	public OrgaoEmissor edita(Integer id) {
		return dao.carrega(id);
	}
}
