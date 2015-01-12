package br.com.sgaeteam.sgae.controller;

import static br.com.caelum.vraptor.view.Results.json;

import java.util.List;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.Validator;
import br.com.caelum.vraptor.validator.ValidationMessage;
import br.com.sgaeteam.sgae.controller.menu.IndexController;
import br.com.sgaeteam.sgae.dao.UnidadeDAO;
import br.com.sgaeteam.sgae.dao.UsuarioDAO;
import br.com.sgaeteam.sgae.infra.Perfil;
import br.com.sgaeteam.sgae.infra.Permissao;
import br.com.sgaeteam.sgae.infra.Publico;
import br.com.sgaeteam.sgae.infra.UsuarioSessao;
import br.com.sgaeteam.sgae.infra.Util;
import br.com.sgaeteam.sgae.model.Unidade;
import br.com.sgaeteam.sgae.model.Usuario;

@Resource
public class UsuariosController {

	private final UsuarioDAO usuarioDAO;
	private final UnidadeDAO unidadeDAO;
	private final Result result;
	private final Validator validator;
	private final UsuarioSessao usuarioSessao;

	public UsuariosController(UsuarioDAO usuarioDAO, UnidadeDAO unidadeDAO,
			Result result, Validator validator, UsuarioSessao usuarioSessao) {
		this.usuarioDAO = usuarioDAO;
		this.unidadeDAO = unidadeDAO;
		this.result = result;
		this.validator = validator;
		this.usuarioSessao = usuarioSessao;
	}

	/*
	 * A tag @Resource possibilita a chamada ao formulário loginForm.jsp O
	 * método abaixo é uma artimanha para direcionar à página correta.
	 */
	@Get
	@Path("/")
	@Publico
	public void loginForm() {
	}

	/*
	 * O método abaixo é realmente a realização do login no sistema. Ele
	 * carrega o usuário na sessão caso validado.
	 */
	@Post
	@Path("/login")
	@Publico
	public void login(Usuario usuario, Unidade unidade) {

		Usuario carregado = usuarioDAO.carrega(usuario);
		Unidade logada    = unidadeDAO.carrega(unidade.getId());

		if (carregado == null) {
			validator.add(new ValidationMessage(
					"C.P.F inv&aacute;lido ou senha incorreta. ", "Mensagem"));
		}
		validator.onErrorUsePageOf(UsuariosController.class).loginForm();

		usuarioSessao.login(carregado,logada);

		result.redirectTo(IndexController.class).index();

	}

	@Path("/logout")
	public void logout() {
		usuarioSessao.logout();
		result.redirectTo(this).loginForm();
	}

	/*
	 * A tag @Resource possibilita a chamada ao formulário novo.jsp O método
	 * abaixo é uma artimanha para direcionar à página correta.
	 */
	@Path("/usuarios/novo")
	public void novo() {
	}

	@Post
	@Path("/usuarios")
	public void adiciona(Usuario usuario) {

		if (usuarioDAO.existeUsuario(usuario)) {
			validator
					.add(new ValidationMessage("CPF j&aacute; existe", "usuario.cpf"));
		}
		validator.onErrorUsePageOf(UsuariosController.class).novo();

		usuario.setSenha(Util.converterMD5(usuario.getCpf()	+ usuario.getSenha()));
		usuarioDAO.adiciona(usuario);
		result.redirectTo(this).loginForm();
		return;
	}

	@Get
	@Path("/usuarios/{usuario.cpf}")
	@Publico
	public void unidades(Usuario usuario) {
		@SuppressWarnings("rawtypes")
		List unidade = usuarioDAO.listaUnidades(usuario);
		result.use(json()).from(unidade, "unidade").serialize();
	}
	
	@Get
	@Path("/usuarios")
	@Permissao({Perfil.ADM, Perfil.DIR, Perfil.SUP})
	public List<Usuario> lista() {	
		return usuarioDAO.listaTudo();
	}	
}