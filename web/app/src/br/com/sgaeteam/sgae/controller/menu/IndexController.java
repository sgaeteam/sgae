package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;

@Resource
@Path("/index")
public class IndexController {

	private final Result result;
	
	public IndexController(Result result) {
		this.result = result;
	}

	public void index() {
		this.result.include("opcao", "Painel de Controle");
	}

}
