package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.sgaeteam.sgae.controller.UsuariosController;
import br.com.sgaeteam.sgae.infra.UsuarioSessao;

@Resource
@Path("/administracao")
public class AdministracaoController {

	private final Result result;
	private final UsuariosController usuariosController;
	private final UsuarioSessao usuarioSessao;

	public AdministracaoController(Result result,
			UsuariosController usuariosController, UsuarioSessao usuarioSessao) {
		this.result = result;
		this.usuariosController = usuariosController;
		this.usuarioSessao = usuarioSessao;
	}

	@Get
	public void formulario() {
		if (!(this.usuarioSessao.getUnidadeLogada().getPlanoid().getNome().equals("Basic")) &&
		    !(this.usuarioSessao.getUnidadeLogada().getPlanoid().getNome().equals("Plus")) &&  
		    !(this.usuarioSessao.getUnidadeLogada().getPlanoid().getNome().equals("Gold"))) 
		{
			this.result.include("opcao","Administra&ccedil;&atilde;o");
			this.result.include("usuarioList",usuariosController.lista());
		}
	}
}