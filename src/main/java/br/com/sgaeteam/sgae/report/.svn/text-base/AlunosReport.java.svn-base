package br.com.sgaeteam.sgae.report;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import br.com.caelum.vraptor.jasperreports.Report;
import br.com.sgaeteam.sgae.model.Aluno;

public class AlunosReport implements Report<Aluno> {
	
	private final List<Aluno> data;
	private Map<String, Object> parameters;
	
	public AlunosReport(List<Aluno> data) {
		this.data = data;
		this.parameters = new HashMap<String, Object>();
	}

	public Report<Aluno> addParameter(String key, Object value) {
		this.parameters.put(key, value);
		return this;
	}

	public Collection<Aluno> getData() {
		return data;
	}

	public String getFileName() {
		return "relatorio_aluno_" + System.currentTimeMillis();
	}

	public Map<String, Object> getParameters() {
		return this.parameters;
	}

	public String getTemplate() {
		return "/templates/aluno.jasper";
	}

}
