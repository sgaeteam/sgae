package br.com.sgaeteam.sgae.controller.menu;

import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.sgaeteam.sgae.controller.AlunosController;
import br.com.sgaeteam.sgae.controller.EstadosController;
import br.com.sgaeteam.sgae.controller.OrgaoEmissorController;

@Resource
@Path("/cadastros")
public class CadastrosController {

	private final Result result;
	private final AlunosController alunosController;
	private final EstadosController estadosController;
	private final OrgaoEmissorController orgaoEmissorController;
	
	public CadastrosController(Result result, AlunosController alunosController, EstadosController estadosController, OrgaoEmissorController orgaoEmissorController) {
		this.result = result;
		this.alunosController = alunosController;
		this.estadosController = estadosController;
		this.orgaoEmissorController = orgaoEmissorController;
	}

	@Get
	@Path("/formulario")
	public void formulario() {
		this.result.include("opcao", "Cadastros");
		this.result.include("alunoList", alunosController.lista());
		this.result.include("estadoList",estadosController.lista());
		this.result.include("orgaoEmissorList",orgaoEmissorController.lista());
	}
}
