package br.com.sgaeteam.sgae.infra;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.ElementType;

/* Esta anota��o servir� para indicar que o recurso 
 * � p�blico e n�o possui restri��es.
 * */

@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Publico {

}
