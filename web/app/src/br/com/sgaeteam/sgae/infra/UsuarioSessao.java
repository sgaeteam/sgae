package br.com.sgaeteam.sgae.infra;

import java.io.Serializable;

import br.com.caelum.vraptor.ioc.Component;
import br.com.caelum.vraptor.ioc.SessionScoped;
import br.com.sgaeteam.sgae.model.Unidade;
import br.com.sgaeteam.sgae.model.Usuario;

/*
 "Quando o usuaÌ�rio faz o login, precisamos guardar a informacÌ§aÌƒo 
 de que ele jaÌ� estaÌ� logado. A melhor forma eÌ� guardar a informacÌ§aÌƒo
 de login na sessaÌƒo, que manteÌ�m os dados enquanto o usuaÌ�rio estiver 
 navegando pela aplicacÌ§aÌƒo. Para isso, vamos criar uma classe que 
 guarda o usuaÌ�rio logado. Essa classe seraÌ� acessada nos jsps para 
 acessar as informacÌ§oÌƒes do usuaÌ�rio, entaÌƒo adicionamos alguns getters 
 para expor as informacÌ§oÌƒes relevantes." (CAELUM FJ28, pÃ¡g. 115/116).
 */

@Component
@SessionScoped
public class UsuarioSessao implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Usuario usuarioLogado;
	private Unidade unidadeLogada;

	public void login(Usuario usuario, Unidade unidade) {
		this.usuarioLogado = usuario;
		this.unidadeLogada = unidade;
	}
	
	public void logout() {
		this.usuarioLogado = null;
		this.unidadeLogada = null;
	}
	
	public String getNome() {
		return usuarioLogado.getNome();
	}
	
	public String getNomeUnidadeLogada() {
		return unidadeLogada.getNome();
	}

	public Unidade getUnidadeLogada() {
		return this.unidadeLogada;
	}
		
	public String getCpf() {
		return usuarioLogado.getCpf();
	}
	
	public int getPerfil_id() {
		return usuarioLogado.getPerfilid().getId();
	}
	
	public String getPerfilSigla() {
		return usuarioLogado.getPerfilid().getSigla();
	}
	
	public int getUnidade_id() {
		return unidadeLogada.getId();
	}
	
	public boolean isLogado() {
		return usuarioLogado != null;
	}
}