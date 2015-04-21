package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;

@Resource
@Path("/utilitarios")
public class UtilitariosController {

	private final Result result;

	public UtilitariosController(Result result) {
		this.result = result;
	}

	@Get
	public void formulario() {
		this.result.include("opcao", "Utilit&aacute;rios");
	}
}
