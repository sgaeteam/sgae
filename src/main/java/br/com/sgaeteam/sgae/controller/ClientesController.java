package br.com.sgaeteam.sgae.controller;

import java.util.List;

import br.com.caelum.vraptor.Delete;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Put;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.Validator;
import br.com.caelum.vraptor.validator.Validations;
import br.com.sgaeteam.sgae.dao.ClienteDAO;
import br.com.sgaeteam.sgae.infra.Perfil;
import br.com.sgaeteam.sgae.infra.Permissao;
import br.com.sgaeteam.sgae.model.Cliente;

@Resource
public class ClientesController {

	private final ClienteDAO dao;
	private final Result result;
	private final Validator validator;

	public ClientesController(ClienteDAO dao, Result result, Validator validator) {
		this.dao = dao;
		this.result = result;
		this.validator = validator;
	}

	@Get
	@Path("/clientes/novo")
	@Permissao(Perfil.ADM)
	public void formulario() {
	}

	@Post
	@Path("/clientes")
	@Permissao(Perfil.ADM)
	public void adiciona(final Cliente cliente, String callBack) {

//		validator.checking(new Validations() {
//			{
//				that(cliente.getNome() != null && cliente.getNome().length() >= 3,
//						"cliente.nome", "nome.obrigatorio");
//				that(cliente.getMatricula() != null, "cliente.matricula",
//						"matricula.obrigatoria");
//				that(cliente.getCpf() != null, "cliente.cpf", "cpf.obrigatorio");
//			}
//		});
//		validator.onErrorUsePageOf(ClientesController.class).formulario();


		/* Insere o cliente */		
		dao.salva(cliente);
		
		System.out.println("----------------------------------------------------");
		System.out.println("-- Call Back: " + callBack);
		System.out.println("----------------------------------------------------");
		result.redirectTo(callBack);
	}

	@Get
	@Path("/clientes/{id}")
	@Permissao(Perfil.ADM)
	public Cliente edita(Integer id) {
		
		return dao.carrega(id);
	}

	@Put
	@Path("/clientes/{cliente.id}")
	@Permissao(Perfil.ADM)
	public void altera(Cliente cliente, String callBack) {
		
		dao.altera(cliente);
		
		System.out.println("----------------------------------------------------");
		System.out.println("-- Call Back: " + callBack);
		System.out.println("----------------------------------------------------");
		result.redirectTo(callBack);
	}

	@Delete
	@Path("/clientes/rl/{id}")
	@Permissao(Perfil.ADM)
	public void removeLogico(Integer id, String callBack) {
		
		Cliente cliente = dao.carrega(id);
		//cliente.setValido("N"); --> Se houver necessidade, sera criada posteriormente
		dao.altera(cliente);
		
		System.out.println("----------------------------------------------------");
		System.out.println("-- Call Back: " + callBack);
		System.out.println("----------------------------------------------------");
		result.redirectTo(callBack);
	}	
	
	@Delete
	@Path("/clientes/rf/{id}")
	@Permissao(Perfil.ADM)
	public void removeFisico(Integer id, String callBack) {
		
		Cliente cliente = dao.carrega(id);
		dao.remove(cliente);
		
		System.out.println("----------------------------------------------------");
		System.out.println("-- Call Back: " + callBack);
		System.out.println("----------------------------------------------------");
		result.redirectTo(callBack);
	}
	
	@Get
	@Path("/clientes")
	@Permissao(Perfil.ADM)
	public List<Cliente> lista() {	
		return dao.listaTudo();
	}	
}