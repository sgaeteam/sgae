package br.com.sgaeteam.sgae.infra;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.ElementType;

/* Esta anota��o possui um �nico elemento que � um array de Perfil
 * que por ser o �nico atributo existente nessa anota��o, � chamado 
 * de value por boas pr�ticas. Com isso podemos utilizar anota��es 
 * em classes e m�todos de forma simples.
 * */

@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Permissao {

	Perfil[] value();

}
