<h1>${opcao}</h1>

<div class="tabs_links">
	<ul>
		<li><a href="#alunos">Alunos</a></li>
		<li><a href="#instrutores">Instrutores</a></li>
		<li><a href="#extras">Extras</a></li>
		<li><a href="#financeiro">Financeiro</a></li>
		<li><a href="#estoques">Estoques</a></li>
		<li><a href="#fornecedores">Fornecedores</a></li>
	</ul>
</div>

</div> <!-- Div da linha das abas. Não remover. -->

<!--Tabs-Box-Ends-->

<div id="main">

	<div id="content"> 

		<div class="tab_content" id="alunos">

			<div class="element-box">
				<h1>Cadastrar Alunos</h1>
				
				<c:if test="${fn:length(notice)!=0}">
                <div class="notification success png_bg">
				    <a class="close" href="#"><img alt="Fechar" title="Fechar essa mensagem" src="../images/icons/cross_grey_small.png"></a>
	                 <div>
					    <strong>Mensagem</strong> : ${notice}
				     </div>
			    </div>
				</c:if>
 				 
				<div style="position: absolute; left: 1160px; top: 210px;">
					<a id="botao_aluno_new" href="<c:url value="/alunos/novo"/>"
						class="button button-display"><i class="icon-user"></i> NOVO </a>
				</div> 
				
				<br>
				
				<table cellpadding="0" cellspacing="0" border="0" class="display"
					id="example">
					<thead>
						<tr>
							<th align="left">Nome</th>
							<th align="left">Matrícula</th>
							<th align="left">C.P.F</th>
							<th align="left">Email</th>
							<th align="left">Fone</th>
							<th align="left">Op&ccedil;&atilde;o</th>
						</tr>
					</thead>
					<tbody>

					 <c:forEach items="${alunoList}" var="aluno">
							<tr>
								<td>${aluno.nome}</td>
								<td>${aluno.matricula}</td>
								<td>${aluno.cpf}</td>
								<td>${aluno.contatoid.email}</td>
								<td>${aluno.contatoid.telCelular}</td>
								<td>
								    <a id="${aluno.id}" class="link_aluno_view" href="<c:url value="/alunos/${aluno.id}"/>" title="Visualizar"><img	id="view_user" src="../images/view_user.png" height="17" width="17"></a> 
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    <a id="${aluno.id}" class="link_aluno_edit" href="<c:url value="/alunos/${aluno.id}"/>" title="Editar"><img	id="edit_user" src="../images/edit_user.png" height="17" width="17"></a> 
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<a class="link_aluno_delete" href="<c:url value="/alunos/rl/${aluno.id}"/>" title="Excluir"><img id="remove_user" src="../images/remove_user.png" height="17" width="17"></a>
								</td>
							</tr>
							<!-- Form para edição -->
							<div id="form_aluno_edit_${aluno.id}" style="display:none;">
                    		 <div style="overflow-x:auto;">
			        			<h1 style="color:#FFFFFF">Editar Aluno</h1>
								  </br>
								  <form action="<c:url value="/alunos/${aluno.id}"/>" method="POST">
									  <div class="form-row-modal">
									    <samp>Nome</samp>
									    <input id="nome" type="text" name="aluno.nome" value="${aluno.nome}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									   <samp>C.P.F</samp>
									   <input id="cpf" type="text" name="aluno.cpf" value="${aluno.cpf}" class="input-text small cpf" />
									   <label style="color:#FFFFFF">Data de nascimento</label>
									    <fmt:formatDate var='dtNascimentoFmt' value="${aluno.dtNascimento}" pattern="dd/MM/yyyy" />
									    <input id="form_aluno_edit_dt_nascimento_${aluno.id}" type="date" name="aluno.dtNascimento" value="${dtNascimentoFmt}" class="input-text small data calendario-popup" />									    
									  </div>
									  <div class="form-row-modal">
									    <samp>R.G</samp>
									    <input id="rgNum" type="text" name="aluno.rgNum" value="${aluno.rgNum}" class="input-text small" />
									    <label style="color:#FFFFFF">Órgão Emissor</label>
									    <select id="rgExp" name="aluno.rgExp.id" class="input-text small">
									      <c:forEach var="orgaoEmissor" items="${orgaoEmissorList}">  
            								<option title="${orgaoEmissor.descricao}" value="${orgaoEmissor.id}" ${orgaoEmissor.id eq aluno.rgExp.id ? "selected" : "" }>${orgaoEmissor.sigla}</option>  
        								  </c:forEach>  
    									</select> 
										<select id="rgOrg" name="aluno.rgOrg.id" class="input-text smallest">
									      <c:forEach var="estado" items="${estadoList}">  
            								<option title="${estado.descricao}" value="${estado.id}" ${estado.id eq aluno.rgOrg.id ? "selected" : "" }>${estado.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									    <samp>E-mail</samp>
									    <input id="email" type="text" name="aluno.contatoid.email" value="${aluno.contatoid.email}" class="input-text medium" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Celular</samp>
									    <input id="telCelular" type="text" name="aluno.contatoid.telCelular" value="${aluno.contatoid.telCelular}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Telefone residencial</label>
									    <input id="telResidencial" type="text" name="aluno.contatoid.telResidencial" value="${aluno.contatoid.telResidencial}" class="input-text small telefone" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Telefone comercial</samp>
									    <input id="telComercial" type="text" name="aluno.contatoid.telComercial" value="${aluno.contatoid.telComercial}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Outro telefone</label>
									    <input id="telOutro" type="text" name="aluno.contatoid.telOutro" value="${aluno.contatoid.telOutro}" class="input-text small telefone" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Nome do pai</samp>
									    <input id="pai" type="text" name="aluno.pai" value="${aluno.pai}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Nome do mãe</samp>
									    <input id="mae" type="text" name="aluno.mae" value="${aluno.mae}" class="input-text large" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Endereço</samp>
									    <input id="logradouro" type="text" name="aluno.enderecoid.logradouro" value="${aluno.enderecoid.logradouro}" class="input-text medium" />
									    <label style="color:#FFFFFF">Número</label>
									    <input id="numero" type="text" name="aluno.enderecoid.numero" value="${aluno.enderecoid.numero}" class="input-text small" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Bairro</samp>
									    <input id="bairro" type="text" name="aluno.enderecoid.bairro" value="${aluno.enderecoid.bairro}" class="input-text medium" />
									    <label style="color:#FFFFFF">C.E.P</label>
									    <input id="cep" type="text" name="aluno.enderecoid.cep" value="${aluno.enderecoid.cep}" class="input-text small cep" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Cidade</samp>
									    <input id="cidade" type="text" name="aluno.enderecoid.cidade" value="${aluno.enderecoid.cidade}" class="input-text medium" />
									    <label style="color:#FFFFFF">Estado</label>
									    <select id="estado" name="aluno.enderecoid.estado.id" class="input-text smallest">
									      <c:forEach var="estadoEndereco" items="${estadoList}">  
            								<option title="${estadoEndereco.descricao}" value="${estadoEndereco.id}" ${estadoEndereco.id eq aluno.enderecoid.estado.id ? "selected" : "" }>${estadoEndereco.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									  <samp></samp>
									    <button type="submit" name="_method" value="PUT" class="button button-display"><i class="icon-ok"></i>Alterar</button>
									  </div>
									  <fmt:formatDate var='dtInscricaoFmt' value="${aluno.dtInscricao}" pattern="dd/MM/yyyy hh:mm:ss" />
									  <input type="hidden" name="aluno.dtInscricao" value="${dtInscricaoFmt}" />
									  <input type="hidden" name="aluno.matricula" value="${aluno.matricula}" />
									  <input type="hidden" name="aluno.unidadeid.id" value="${aluno.unidadeid.id}" />
									  <input type="hidden" name="aluno.enderecoid.id" value="${aluno.enderecoid.id}" />
									  <input type="hidden" name="aluno.contatoid.id" value="${aluno.contatoid.id}" />
									  <input type="hidden" name="aluno.valido" value="${aluno.valido}" />					
									  <input type="hidden" name="callBack" value="/cadastros/formulario" />
								   </form>
                    		 </div>
		           			</div>
		           			<!-- Form para visualização -->
		           			<div id="form_aluno_view_${aluno.id}" style="display:none;">
                    		 <div style="overflow-x:auto;">
			        			<h1 style="color:#FFFFFF">Visualizar Aluno</h1>
								  </br>
								   <form action="<c:url value="/alunos/pdf/${aluno.id}"/>" method="POST">
									  <div class="form-row-modal">
									    <samp>Nome</samp>
									    <input onfocus="handler" readonly id="nome" type="text" name="aluno.nome" value="${aluno.nome}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									   <samp>C.P.F</samp>
									   <input readonly id="cpf" type="text" name="aluno.cpf" value="${aluno.cpf}" class="input-text small cpf" />
									   <label style="color:#FFFFFF">Data de nascimento</label>
									   <fmt:formatDate var='dtNascimentoFmt' value="${aluno.dtNascimento}" pattern="dd/MM/yyyy" />
									   <input readonly id="dt_nascimento" type="text" name="aluno.dtNascimento" value="${dtNascimentoFmt}" class="input-text small data" />
									  </div>
									  <div class="form-row-modal">
									    <samp>R.G</samp>
									    <input readonly id="rgNum" type="text" name="aluno.rgNum" value="${aluno.rgNum}" class="input-text small" />
									    <label style="color:#FFFFFF">Órgão Emissor</label>
									    <select readonly id="rgExp" name="aluno.rgExp.id" class="input-text small">
									      <c:forEach var="orgaoEmissor" items="${orgaoEmissorList}">  
            								<option title="${orgaoEmissor.descricao}" value="${orgaoEmissor.id}" ${orgaoEmissor.id eq aluno.rgExp.id ? "selected" : "" }>${orgaoEmissor.sigla}</option>  
        								  </c:forEach>  
    									</select> 
										<select readonly id="rgOrg" name="aluno.rgOrg.id" class="input-text smallest">
									      <c:forEach var="estado" items="${estadoList}">  
            								<option title="${estado.descricao}" value="${estado.id}" ${estado.id eq aluno.rgOrg.id ? "selected" : "" }>${estado.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									    <samp>E-mail</samp>
									    <input readonly id="email" type="text" name="aluno.contatoid.email" value="${aluno.contatoid.email}" class="input-text medium" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Celular</samp>
									    <input readonly id="telCelular" type="text" name="aluno.contatoid.telCelular" value="${aluno.contatoid.telCelular}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Telefone residencial</label>
									    <input readonly id="telResidencial" type="text" name="aluno.contatoid.telResidencial" value="${aluno.contatoid.telResidencial}" class="input-text small telefone" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Telefone comercial</samp>
									    <input readonly id="telComercial" type="text" name="aluno.contatoid.telComercial" value="${aluno.contatoid.telComercial}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Outro telefone</label>
									    <input readonly id="telOutro" type="text" name="aluno.contatoid.telOutro" value="${aluno.contatoid.telOutro}" class="input-text small telefone" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Nome do pai</samp>
									    <input readonly id="pai" type="text" name="aluno.pai" value="${aluno.pai}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Nome do mãe</samp>
									    <input readonly id="mae" type="text" name="aluno.mae" value="${aluno.mae}" class="input-text large" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Endereço</samp>
									    <input readonly id="logradouro" type="text" name="aluno.enderecoid.logradouro" value="${aluno.enderecoid.logradouro}" class="input-text medium" />
									    <label style="color:#FFFFFF">Número</label>
									    <input readonly id="numero" type="text" name="aluno.enderecoid.numero" value="${aluno.enderecoid.numero}" class="input-text small" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Bairro</samp>
									    <input readonly id="bairro" type="text" name="aluno.enderecoid.bairro" value="${aluno.enderecoid.bairro}" class="input-text medium" />
									    <label style="color:#FFFFFF">C.E.P</label>
									    <input readonly id="cep" type="text" name="aluno.enderecoid.cep" value="${aluno.enderecoid.cep}" class="input-text small cep" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Cidade</samp>
									    <input readonly id="cidade" type="text" name="aluno.enderecoid.cidade" value="${aluno.enderecoid.cidade}" class="input-text medium" />
									    <label style="color:#FFFFFF">Estado</label>
									    <select readonly id="estado" name="aluno.enderecoid.estado.id" class="input-text smallest">
									      <c:forEach var="estadoEndereco" items="${estadoList}">  
            								<option title="${estadoEndereco.descricao}" value="${estadoEndereco.id}" ${estadoEndereco.id eq aluno.enderecoid.estado.id ? "selected" : "" }>${estadoEndereco.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									  <samp></samp>
									    <button type="submit" name="_method" value="GET" class="button button-display"><i class="icon-print"></i>Imprimir</button>
									  </div>
								   </form>
                    		 </div>
		           			</div>
						</c:forEach>
					</tbody>
				</table>
				<!-- Form para inclusão -->
				<div id="form_aluno_new" style="display:none;">
                    		 <div style="overflow-x:auto;">
			        			<h1 style="color:#FFFFFF">Cadastrar Aluno</h1>
								  </br>
								  <form action="<c:url value="/alunos"/>" method="POST">
									  <div class="form-row-modal">
									    <samp>Nome</samp>
									    <input id="nome" type="text" name="aluno.nome" value="${aluno.nome}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									   <samp>C.P.F</samp>
									   <input id="cpf" type="text" name="aluno.cpf" value="${aluno.cpf}" class="input-text small cpf" />
									   <label style="color:#FFFFFF">Data de nascimento</label>
									   <fmt:formatDate var='dtNascimentoFormatada' value="${aluno.dtNascimento}" pattern="yyyy-MM-dd" />
									   <input id="form_aluno_new_dt_nascimento" type="text" name="aluno.dtNascimento" value="${dtNascimentoFormatada}" class="input-text small data calendario-popup" />
									  </div>
									  <div class="form-row-modal">
									    <samp>R.G</samp>
									    <input id="rgNum" type="text" name="aluno.rgNum" value="${aluno.rgNum}" class="input-text small" />
									    <label style="color:#FFFFFF">Órgão Emissor</label>
									    <select id="rgExp" name="aluno.rgExp.id" class="input-text small">
									      <c:forEach var="orgaoEmissor" items="${orgaoEmissorList}">  
            								<option title="${orgaoEmissor.descricao}" value="${orgaoEmissor.id}">${orgaoEmissor.sigla}</option>  
        								  </c:forEach>  
    									</select> 
									    <select id="rgOrg" name="aluno.rgOrg.id" class="input-text smallest">
									      <c:forEach var="estado" items="${estadoList}">  
            								<option title="${estado.descricao}" value="${estado.id}">${estado.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									    <samp>E-mail</samp>
									    <input id="email" type="text" name="aluno.contatoid.email" value="${aluno.contatoid.email}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Celular</samp>
									    <input id="telCelular" type="text" name="aluno.contatoid.telCelular" value="${aluno.contatoid.telCelular}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Telefone residencial</label>
									    <input id="telResidencial" type="text" name="aluno.contatoid.telResidencial" value="${aluno.contatoid.telResidencial}" class="input-text small telefone" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Telefone comercial</samp>
									    <input id="telComercial" type="text" name="aluno.contatoid.telComercial" value="${aluno.contatoid.telComercial}" class="input-text small telefone" />
									    <label style="color:#FFFFFF">Outro telefone</label>
									    <input id="telOutro" type="text" name="aluno.contatoid.telOutro" value="${aluno.contatoid.telOutro}" class="input-text small telefone" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Nome do pai</samp>
									    <input id="pai" type="text" name="aluno.pai" value="${aluno.pai}" class="input-text large" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Nome do mãe</samp>
									    <input id="mae" type="text" name="aluno.mae" value="${aluno.mae}" class="input-text large" />
									  </div>
									  <hr>
									  <div class="form-row-modal">
									    <samp>Endereço</samp>
									    <input id="logradouro" type="text" name="aluno.enderecoid.logradouro" value="${aluno.enderecoid.logradouro}" class="input-text medium" />
									    <label style="color:#FFFFFF">Número</label>
									    <input id="numero" type="text" name="aluno.enderecoid.numero" value="${aluno.enderecoid.numero}" class="input-text small" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Bairro</samp>
									    <input id="bairro" type="text" name="aluno.enderecoid.bairro" value="${aluno.enderecoid.bairro}" class="input-text medium" />
									    <label style="color:#FFFFFF">C.E.P</label>
									    <input id="cep" type="text" name="aluno.enderecoid.cep" value="${aluno.enderecoid.cep}" class="input-text small cep" />
									  </div>
									  <div class="form-row-modal">
									    <samp>Cidade</samp>
									    <input id="cidade" type="text" name="aluno.enderecoid.cidade" value="${aluno.enderecoid.cidade}" class="input-text medium" />
									    <label style="color:#FFFFFF">Estado</label>
									    <select id="estado" name="aluno.enderecoid.estado.id" class="input-text smallest">
									      <c:forEach var="estadoEndereco" items="${estadoList}">  
            								<option title="${estadoEndereco.descricao}" value="${estadoEndereco.id}">${estadoEndereco.sigla}</option>  
        								  </c:forEach>  
    									</select>
									  </div>
									  <div class="form-row-modal">
									  <samp></samp>
									    <button type="submit" name="_method" value="POST" class="button button-display"><i class="icon-ok"></i>Salvar</button>
									    <button type="reset"  class="button button-display"><i class="icon-remove"></i>Limpar</button>
									  </div>
									  <input type="hidden" name="aluno.valido" value="S" />
						 			  <input type="hidden" name="aluno.unidadeid.id" value="${usuarioSessao.unidade_id}" />
						  			  <input type="hidden" name="callBack" value="/cadastros/formulario" />
								   </form>
		    </div>
		</div>
		</div>
	</div>
	
	<div class="tab_content" id="instrutores">Tab1</div>
	<div class="tab_content" id="extras">Tab2</div>
	<div class="tab_content" id="financeiro">Tab3</div>
	<div class="tab_content" id="estoques">Tab4</div>
	<div class="tab_content" id="fornecedores">Tab5</div>

  </div> <!--CONTENT-END-->
	
</div><!--MAIN END-->