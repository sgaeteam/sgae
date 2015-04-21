<div class="tabber">
     <div class="tabbertab">
	  <h2>Dados Pessoais</h2>
	  <p>&nbsp;</p>
          <fieldset> <legend>Criar novo usu&aacute;rio</legend>
           <form id="usuariosForm" action="<c:url value="/usuarios"/>"  method="POST">
            <p><label for="nome">Nome:</label> <input class="required" name="usuario.nome" id="nome" value="${usuario.nome }" type="text" /></p>
            <p><label for="login">Login:</label> <input class="required" name="usuario.login" id="login" value="${usuario.login }" type="text" /></p>
            <p><label for="senha">Senha:</label> <input id="senha" class="required" type="password" name="usuario.senha"/></p>
            <p><label for="confirmacao">Confirme a senha:</label> <input id="confirmacao" equalTo="#senha" type="password"/></p>
           <!-- <p><label for="message">Message:</label> <textarea cols="60" rows="11" name="message" id="message"></textarea></p> --> 
            <p><input name="enviar" class="formbutton" value="Enviar" type="submit" /></p>
           </form>
          </fieldset>
    
	 </div>

     <div class="tabbertab">
	  <h2>Endere&ccedil;o</h2>
	  	<h2>Examples</h2>
		<h1>Heading H1</h1>
		<h2>Heading H2</h2>
		<h3>Heading H3</h3>
		<h4>Heading H4</h4>
		<h5>Heading H5</h5>
		<p>&nbsp;</p>
		<h3>Lists</h3>
		<ul>
			<li>List item</li>
			<li>List item</li>
			<li>List item</li>
		</ul>
		<ol>
			<li>List item</li>
			<li>List item</li>
			<li>List item</li>
		</ol>

     </div>
    
     <div class="tabbertab">
	  <h2>Contatos</h2>
	  <p>&nbsp;</p>
	  <h3>Code and blockquote</h3>
	  <code>&lt;? echo('Hello world'); ?&gt;</code>
	  <blockquote>
	   <p>Mauris sit amet tortor in urna tincidunt aliquam.
	      Pellentesque habitant morbi tristique senectus et netus et malesuada
	      fames ac turpis egestas</p>
          </blockquote>
          <p>&nbsp;</p>
	  <h3>Table</h3>
	   <table cellspacing="0">
              <tbody>
                <tr>
                 <th>ID</th>
                 <th>Nome</th>
                 <th>Idade</th>
                </tr>
                <tr>
                 <td>1</td>
                 <td>John Smith</td>
                 <td>28</td>
                </tr>
                <tr>
                 <td>2</td>
                 <td>Fred James</td>
                 <td>49</td>
                </tr>
                <tr>
                 <td>3</td>
                 <td>Rachel Johnson</td>
                 <td>19</td>
                </tr>
              </tbody>
            </table>
		</div>

</div>