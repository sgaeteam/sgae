package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.sgaeteam.sgae.infra.Util;

@Resource
@Path("/index")
public class IndexController {

	private final Result result;
	
	public IndexController(Result result) {
		this.result = result;
	}

	public void index() {
		this.result.include("opcao", "Painel de Controle");
		try {
			this.result.include("ip", Util.getIpAddress());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			this.result.include("ip", "0.0.0.0");
			e.printStackTrace();
		}
	}

}
