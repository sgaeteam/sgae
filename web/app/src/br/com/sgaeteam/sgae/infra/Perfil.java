package br.com.sgaeteam.sgae.infra;

/* Quando falamos em permiss›es, logo pensamos em perfis, 
 * j‡ que uma permiss‹o estar‡ ligada diretamente a estes. 
 * Com isso ser‡ criado um Enum com alguns nomes de perfil 
 * para ser usado como indicadores das permiss›es.
 * */

public enum Perfil {

	ADM(1, "ADM"), DIR(2, "DIR"), SUP(3, "SUP"), OPR(4, "OPR"), USR(5, "USR");

	private final int id;
	private final String sigla;

	public int id() {
		return this.id;
	}

	public String sigla() {
		return this.sigla;
	}

	private Perfil(int id, String sigla) {
		this.id = id;
		this.sigla = sigla;
	}
}