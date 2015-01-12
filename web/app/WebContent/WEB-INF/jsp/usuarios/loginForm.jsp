<p class="p-line">SGAE - Sistema para Gerenciamento de Auto Escolas</p>

<c:if test="${fn:length(errors)!=0}">
 <div style="float:left; width:318px; margin:0px 0px 0px 465px;">
  <div class="notification erro png_bg">
	<a href="#" class="close"><img src="<c:url value ="/images/icons/cross_grey_small.png"/>" title="Fechar mensagem" alt="Fechar"></a>
	<div>
	   <c:forEach var="error" items="${errors}">
		<strong>${error.category}</strong> : ${error.message}<br />
	   </c:forEach> 
	</div>
  </div>
 </div>
</c:if>

<div id="login_wrapper" class="form_wrapper">

	<form class="register">
		<h3>Solicita&ccedil;&atilde;o</h3>
		<div class="column">
			<div>
				<label>Nome:</label> <input type="text" class="input-text" /> <span
					class="error">This is an error</span>
			</div>
			<div>
				<label>Sobrenome:</label> <input type="text" class="input-text" />
				<span class="error">Campo em branco</span>
			</div>
		</div>
		<div class="column">
			<div>
				<label>Telefone:</label> <input type="text" class="input-text" id="telefone" name="telefone"/> <span
					class="error">Campo em branco</span>
			</div>
			<div>
				<label>Email:</label> <input type="text" class="input-text" /> <span
					class="error">Campo em branco</span>
			</div>
		</div>
		<div class="bottom">
			<div class="remember">
				<input type="checkbox" class="input-text" /> <span>Enviar-me
					atualiza&ccedil;&otilde;es</span>
			</div>
			<input type="submit" value="Solicitar" class="button" /> <a
				href="index.html" rel="login" class="linkform">Sua empresa
				j&aacute; tem conta? Acesse aqui</a>
			<div class="clear"></div>
		</div>
	</form>


	<form id="form_login" class="login active" action="<c:url value="/login"/>"	method="post"> 
		<h3 align="left">Autentica&ccedil;&atilde;o - SGAE</h3>
		<div>
			<label>CPF:</label> <input id="cpf1" maxlength="11" type="text" class="input-text"
				name="usuario.cpf" /> <span class="error"> </span>
		</div>
		<div id="unidade" >
			<label>Unidade:<br/> 
			<select id="unidades" class="input-text large" style="width:270px;" name="unidade.id"></select>
			</label>
		</div>
		<div id="senha">
			<label>Senha: <a href="forgot_password.html"
				rel="forgot_password" class="forgot linkform">Esqueceu sua
					senha?</a></label> <input id="password" type="password" class="input-text"
				name="usuario.senha" /> <span class="error">Campo em branco</span>
		</div>
		<div class="bottom">
			<input id="bt_entrar" type="submit" value="Entrar" class="button" /> <a
				href="register.html" rel="register" class="linkform">Sua empresa
				n&atilde;o tem conta? Solicite aqui</a>
			<div class="clear"></div>
		</div>
	</form>

	<form class="forgot_password">
		<h3>Esqueceu sua senha</h3>
		<div>
			<label>Usu&aacute;rio ou Email:</label> <input type="text"
				class="input-text" /> <span class="error">Campo em branco</span>
		</div>
		<div class="bottom">
			<input type="submit" class="button" value="Lembrar"></input> <a
				href="index.html" rel="login" class="linkform">Lembrou? Acesse
				aqui</a> <a href="register.html" rel="register" class="linkform">Sua
				empresa n&atilde;o tem conta? Solicite aqui</a>
			<div class="clear"></div>
		</div>
	</form>

</div>