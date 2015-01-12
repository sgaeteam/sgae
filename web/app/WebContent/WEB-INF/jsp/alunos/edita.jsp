<div class="tab_content" id="alunos">
	<div class="element-box">
		<br />
		<h1>Editar Aluno</h1>
		<div class="wizard-box">
			<form action="<c:url value="/alunos/${aluno.id}"/>" method="POST">
				<fieldset>
					<label for="nome">Nome:</label>
					<div class="form-row">
						<input id="nome" type="text" name="aluno.nome"
							value="${aluno.nome}" class="input-text medium" />
					</div>
					<label for="cpf">C.P.F.:</label>
					<div class="form-row">
						<input id="cpf" type="text" name="aluno.cpf" value="${aluno.cpf}"
							class="input-text small" />
					</div>
					<div style="position: absolute; left: 1170px; top: 165px;">
						<button type="submit" name="_method" value="PUT"
							class="button button-display">
							<i class="icon-ok"></i> Ok
						</button>
					</div>
					<div style="position: absolute; left: 1250px; top: 165px;">
						<a href="<c:url value="/cadastros/formulario"/>"  class="button button-display"><i class="icon-remove"></i> Cancelar </a>
				    </div>
					<input type="hidden" name="aluno.matricula" value="${aluno.matricula}" />
					<input type="hidden" name="aluno.unidadeid.id" value="${aluno.unidadeid.id}" />
					<input type="hidden" name="aluno.valido" value="${aluno.valido}" />					
					<input type="hidden" name="callBack" value="/cadastros/formulario" />
				</fieldset>
			</form>
		</div>
	</div>
</div>
<!--                   <h1>Top Labeled Forms Style</h1>
                    <br />
                    Small Input Text
                    <div class="form-row">
                     <input type="text" class="input-text small" /> <span><img src="images/icons/error.gif" alt="/" /> An Error Message</span>
                    </div>
                    <br />
                    Medium Input Text
                    <div class="form-row">
                     <input type="text" class="input-text medium" /> <span><img src="images/icons/success.gif" alt="/" /> An Success Message</span>
                    </div>
                    <br />
                    Large Input Text
                    <div class="form-row">
                     <input type="text" class="input-text large" /> <span><img src="images/icons/warning.gif" alt="/" /> An Attention Message</span>
                    </div> -->