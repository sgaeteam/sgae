<h1>${opcao}</h1>

<c:set var="plano" value="${usuarioSessao.unidadeLogada.planoid.nome}" />

<div class="tabs_links">
	<ul>
		<li><a href="#usuarios">Usu&aacute;rios</a></li>
		<li><a href="#feriados">Feriados</a></li>
		<li><a href="#precos">Pre&ccedil;os</a></li>
		<li><a href="#detran">DETRAN</a></li>
	</ul>
</div>

</div>
<!--Tabs-Box-Ends-->

<!-- MAIN BEGIN -->
<div id="main">
	<!-- CONTENT BEGIN -->
	<div id="content">

		<!--TAB 1 BEGINS-->
		<div class="tab_content" id="usuarios">
			<div class="element-box">
				<h1>Cadastrar Usu&aacute;rios</h1>
				<div style="position: absolute; left: 1160px; top: 210px;">
					<a href="<c:url value="/usuarios/novo"/>"
						class="button button-display"><i class="icon-user"></i> NOVO </a>
				</div>
				<br>
				<table cellpadding="0" cellspacing="0" border="0" class="display"
					id="example">
					<thead>
						<tr>
							<th align="left">C.P.F.</th>
							<th align="left">Nome</th>
							<th align="left">E-mail</th>
							<th align="left">Ativo</th>
							<th align="left">Cliente</th>
							<th align="left">Perfil</th>
							<th align="left">Editar</th>
							<th align="left">Excluir</th>
						</tr>
					</thead>
					<tbody>

						<c:forEach items="${usuarioList}" var="usuario">
							<tr>
								<td>${usuario.cpf}</td>
								<td>${usuario.nome}</td>
								<td>${usuario.email}</td>
								<td>${usuario.ativo}</td>
								<td>${usuario.clienteid.nomeFantasia}</td>
								<td>${usuario.perfilid.nome}</td>
								<td><a href="<c:url value="/usuarios/${usuario.cpf}"/>"
									class="button button-display"><i class="icon-edit"></i>Editar</a></td>
								<td><form
										action="<c:url value="/usuarios/rl/${usuario.cpf}}"/>"
										method="POST">
										<button class="button button-display" name="_method"
											value="DELETE">
											<i class="icon-trash"></i>Excluir
										</button>
										<input type="hidden" name="callBack"
											value="/administracao/formulario" />
									</form></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<!--TAB 1 ENDS-->

		<!--TAB 2 BEGINS-->
		<div class="tab_content" id="feriados">
			<div class="element-box">
				<p>Inserir formulário da tab 2 aqui</p>
			</div>
		</div>
		<!--TAB 2 ENDS-->

		<!--TAB 3 BEGINS-->
		<div class="tab_content" id="precos">
			<div class="element-box">
				<p>Inserir formulário da tab 3 aqui</p>
			</div>
		</div>
		<!--TAB 3 ENDS-->

		<!--TAB 4 BEGINS-->
		<c:choose>
			<c:when test="${ fn:endsWith(plano,'Basic')}">
				<div id="detran" class="tab_content" style="display: block;">
					<div class="element-box">
						<h1 style="text-align: center;">Ops! Desculpe, um erro
							ocorreu. Acesso proibido!</h1>
						<p style="text-align: center;">Desculpe, você não parece ter
							privilégio de acesso a este recurso! :(
							Conheça nossos planos: BASIC, PLUS, PREMIUM & GOLD</p>
						<table width="50%" cellspacing="5" align="center">
							<tbody>
								<tr>
									<td><img alt="Erro 403" src="../images/erro.gif"></td>
									<td><span class="errorNum">403</span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</c:when>
			<c:when test="${ fn:endsWith(plano,'Plus')}">
				<div id="detran" class="tab_content" style="display: block;">
					<div class="element-box">
						<h1 style="text-align: center;">Ops! Desculpe, um erro
							ocorreu. Acesso proibido!</h1>
						<p style="text-align: center;">Desculpe, você não parece ter
							privilégio de acesso a este recurso! :(
							Conheça nossos planos: BASIC, PLUS, PREMIUM & GOLD</p>
						<table width="50%" cellspacing="5" align="center">
							<tbody>
								<tr>
									<td><img alt="Erro 403" src="../images/erro.gif"></td>
									<td><span class="errorNum">403</span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</c:when>
			<c:when test="${ fn:endsWith(plano,'Gold')}">
				<div id="detran" class="tab_content" style="display: block;">
					<div class="element-box">
						<h1 style="text-align: center;">Ops! Desculpe, um erro
							ocorreu. Acesso proibido!</h1>
						<p style="text-align: center;">Desculpe, você não parece ter
							privilégio de acesso a este recurso! :(
							Conheça nossos planos: BASIC, PLUS, PREMIUM & GOLD</p>
						<table width="50%" cellspacing="5" align="center">
							<tbody>
								<tr>
									<td><img alt="Erro 403" src="../images/erro.gif"></td>
									<td><span class="errorNum">403</span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</c:when>						
			<c:otherwise>
				<div class="tab_content" id="detran">
					<p>Formulário DETRAN, acesse www.detran.ba.gov.br</p>
					<p>Várias informações relevantes que quem não pagou, não terá acesso! :P</p>
				</div>
			</c:otherwise>
		</c:choose>
		<!--TAB 4 ENDS-->

	</div>
	<!--CONTENT-END-->
</div>
<!--MAIN END-->
