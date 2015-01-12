package br.com.sgaeteam.sgae.infra;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.ElementType;

/* Esta anotação possui um único elemento que é um array de Perfil
 * que por ser o único atributo existente nessa anotação, é chamado 
 * de value por boas práticas. Com isso podemos utilizar anotações 
 * em classes e métodos de forma simples.
 * */

@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Permissao {

	Perfil[] value();

}
