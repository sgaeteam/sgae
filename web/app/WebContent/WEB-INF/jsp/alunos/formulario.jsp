<%-- <form action="<c:url value="/alunos"/>" method="POST">
    <fieldset>
        <legend>Adicionar Aluno</legend>
        <label for="nome">Nome:</label>
        <input id="nome" type="text" name="aluno.nome" value="${aluno.nome}"/>
        <label for="matricula">Matricula:</label>
        <textarea id="matricula" name="aluno.matricula">${aluno.matricula}</textarea>
        <label for="cpf">C.P.F.:</label>
        <input id="cpf" type="text" name="aluno.cpf" value="${aluno.cpf}"/>
        <button type="submit">Enviar</button>
    </fieldset> 
</form> --%>
                   <div class="tab_content" id="alunos"  >
                    <div class="element-box">
                        <br/>                
                        <h1>Novo Aluno</h1>                                             
                        <div class="wizard-box">
		                <form id="feedbackform" action="<c:url value="/alunos"/>" method="POST">						
                          <fieldset class="sectionwrap">                          
                         <legend>Informações Básicas</legend>                            
                             <br/>
                             <div class="form-row">
                               <samp>Nome :</samp>
                               <input id= "nome" name="aluno.nome" value="${aluno.nome}" type="text" placeholder=" insira o nome completo..." class="input-text large">
                             </div>
                             <br />
<!--                              <div class="form-row"> -->
<!--                                <samp>Gênero :</samp> -->
<!--                                <label><input type="radio" class="styled" name="a" checked="checked" /> Masculino </label> &nbsp; &nbsp; -->
<!--                                <label><input type="radio" class="styled" name="a" /> Feminino </label> &nbsp; &nbsp; -->
<!--                              </div> -->
<!--                              <br /> -->
<!--                              <div class="form-row"> -->
<!--                                <samp>C.P.F. :</samp> -->
<%--                                 <input id="cpf" name="cpf" value="${aluno.cpf}" type="text" placeholder=" somente números..." class="input-text large"> --%>
<!--                              </div> -->
                          </fieldset>

<!--                           <fieldset class="sectionwrap"> -->
<!--                           <legend>Endereço</legend>                         -->
<!--                              <div class="form-row"> -->
<!--                                <samp>Logradouro :</samp> -->
<!--                                <input type="text" placeholder="rua, avenida, travessa..." class="input-text large"> -->
<!--                              </div> -->
<!--                              <br /> -->
<!--                              <div class="form-row"> -->
<!--                                <samp>Complemento :</samp> -->
<!--                                <textarea rows="7" class="input-text large"></textarea> -->
<!--                              </div> -->
<!--                           </fieldset> -->

<!--                           <fieldset class="sectionwrap"> -->
<!--                           <legend>Dados Complementares</legend>                             -->
<!--                              <div class="form-row"> -->
<!--                                <samp>Veículo :</samp> -->
<!--                                <input type="text" placeholder="breve descrição..." class="input-text large"> -->
<!--                              </div> -->
<!--                              <br /> -->
<!--                              <div class="form-row"> -->
<!--                                <samp>Habilitado :</samp> -->
<!--                                <label><input type="radio" class="styled" name="b" /> Sim </label> &nbsp; &nbsp; -->
<!--                                <label><input type="radio" class="styled" name="b" checked="checked" /> Não </label> &nbsp; &nbsp; -->
<!--                              </div> -->
<!--                              <br /> -->
<!--                              <div class="form-row"> -->
<!--                                <samp>Observações :</samp> -->
<!--                                <textarea rows="7" class="input-text large"></textarea> -->
<!--                              </div> -->
<!--                           </fieldset> -->
						  <div style="position:absolute; left:1170px; top:165px;">
						  <button type="submit" class="button button-display"><i class="icon-ok"></i> Ok </button>
						  </div>
						  <div style="position:absolute; left:1250px; top:165px;">
						  <a href="<c:url value="/cadastros/formulario"/>"  class="button button-display"><i class="icon-remove"></i> Cancelar </a>
				 		   </div>
				 		  <input type="hidden" name="aluno.valido" value="S" />
						  <input type="hidden" name="aluno.unidadeid.id" value="${usuarioSessao.unidade_id}" />
						  <input type="hidden" name="callBack" value="/cadastros/formulario" />                       
						  </form>
                       </div>
                       
                       
                    </div>
                    
                </div>
               <!--WIZARD ENDS-->
               