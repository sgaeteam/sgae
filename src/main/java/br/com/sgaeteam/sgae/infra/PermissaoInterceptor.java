package br.com.sgaeteam.sgae.infra;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import br.com.caelum.vraptor.InterceptionException;
import br.com.caelum.vraptor.Intercepts;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.core.InterceptorStack;
import br.com.caelum.vraptor.interceptor.Interceptor;
import br.com.caelum.vraptor.resource.ResourceMethod;
import br.com.caelum.vraptor.view.Results;
import br.com.sgaeteam.sgae.controller.UsuariosController;

@Intercepts
public class PermissaoInterceptor implements Interceptor {

	private UsuarioSessao usuarioSessao;
	private Result result;  
	
	public PermissaoInterceptor(UsuarioSessao usuarioSessao, Result result) {
		this.usuarioSessao = usuarioSessao;
		this.result = result;
	}
	
	/*
	 * Nao interceptar nem os metodos nem os controllers que estiverem anotados
	 * com @Publico.
	 */
	@Override
	public boolean accepts(ResourceMethod method) {
		
		return !(method.getMethod().isAnnotationPresent(Publico.class) || method
				.getResource().getType().isAnnotationPresent(Publico.class));

	}

	/* Logica das restricoes: 
	 * */
	@Override
	public void intercept(InterceptorStack stack, ResourceMethod method,
			Object resource) throws InterceptionException {

		Permissao methodPermission = method.getMethod().getAnnotation(Permissao.class);
		Permissao controllerPermission = method.getResource().getType().getAnnotation(Permissao.class);
		
		/* Se o usuario nao estiver na sessao, redirecionar para tela de login */
		if (!this.usuarioSessao.isLogado()) {
			System.out.println("----------------------------------------------------");
			System.out.println("-- Sessao perdida! Redirecionando para o Login... --");
			System.out.println("----------------------------------------------------");
	  		this.result.use(Results.logic()).redirectTo(UsuariosController.class).loginForm();
		}
		
		if (this.hasAccess(methodPermission) && this.hasAccess(controllerPermission)) {
			stack.next(method, resource);
		} 
		else {
			result.use(Results.http()).sendError(403,"Acesso Negado!");
		}

	}

	/* O metodo abaixo que responde se o usuario tem permissao de acesso ao 
	 * recurso requisitado. Caso tenha, é chamado o metodo next do InterceptorStack, 
	 * que da continuidade ao fluxo, caso contrario o usuario é redirecionado para a 
	 * pagina de Acesso Negado.
	*/
	private boolean hasAccess(Permissao permissao) {
		if (permissao == null) {
			return true;
		}

		Collection<Perfil> perfilList = Arrays.asList(permissao.value());
		List<String> perfis = new ArrayList<String>();
		for (Perfil value: perfilList){
			perfis.add(value.sigla());
		}

		return perfis.contains(usuarioSessao.getPerfilSigla());
	}
}
