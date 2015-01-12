package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;

@Resource
@Path("/ajuda")
public class AjudaController {

	private final Result result;

	public AjudaController(Result result) {
		this.result = result;
	}

	@Get
	public void formulario() {
		this.result.include("opcao", "Ajuda");
	}
}
