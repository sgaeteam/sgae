package br.com.sgaeteam.sgae.infra;

import java.math.BigInteger;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
//import java.util.ResourceBundle;




//import javax.faces.context.FacesContext;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
import javax.swing.text.MaskFormatter;

//import org.apache.commons.mail.EmailException;
//import org.apache.commons.mail.HtmlEmail;

//import br.gov.ipraj.vo.FuncionarioVO;
//import br.gov.ipraj.vo.UsuarioVO;

//import com.icesoft.faces.context.effects.JavascriptContext;

/**
 * Classe utilitária utilizada em toda a aplicação.
 * @author Luciano Verde
 * @version 1.0 15/08/2009 11:34
 */
public class Util {

	/**
	 * Retorna a data atual do Sistema no formato ('DD/MM/YYYY').
	 * @author Luciano Verde
	 */
	public static String getDataAtual() {
		// Data atual.
		Date dataAtual = new Date();

		String formato = "dd/MM/yyyy";

		SimpleDateFormat formatter = new SimpleDateFormat(formato);

		return formatter.format(dataAtual);
	}
	
	/**
	 * Retorna a data atual do Sistema no formato ('YYYY').
	 * @author Marcelo Zacarias
	 */
	public static String getDataAno() {
		// Data atual.
		Date dataAtual = new Date();

		String formato = "yyyy";

		SimpleDateFormat formatter = new SimpleDateFormat(formato);

		return formatter.format(dataAtual);
	}
	/**
	 * Retorna a data 30 de trinta dias atrás no formato ('DD/MM/YYYY').
	 * @author Alcides Mendes
	 */
	public static String getDataMesAnterior(String pFormato) {
		SimpleDateFormat lFormato = new SimpleDateFormat(pFormato);
		Calendar lCalendar = Calendar.getInstance();
		int lMes = lCalendar.get(Calendar.MONTH);
		String lData;

		lCalendar.set(Calendar.MONTH, lMes - 1);

		int ano = lCalendar.get(Calendar.YEAR);
		if (lMes == 0) {
			lCalendar.set(Calendar.MONTH, 11);
			lCalendar.set(Calendar.YEAR, ano - 1);
		}
		lData = lFormato.format(lCalendar.getTime());

		return lData;
	}

	/**
	 * Retorna a data atual do Sistema no formato informado.
	 * @author Paulo Santos
	 * @param formato
	 * @return
	 */
	public static String getDataAtual(String formato) {
		// Data atual.
		Date dataAtual = new Date();

		SimpleDateFormat formatter = new SimpleDateFormat(formato);

		return formatter.format(dataAtual);
	}

	/**
	 * Retorna a hora atual do Sistema no formato ('HH:mm:ss').
	 * @author Luciano Verde
	 */
	public static String getHoraAtual() {
		return new SimpleDateFormat("HH:mm:ss").format(new Date());
	}

	/**
	 * Retorna a hora atual do Sistema no formato escolhido.
	 * @param formato String
	 * @author Igor Almeida
	 */
	public static String getHoraAtual(String formato)
	{
		return new SimpleDateFormat(formato).format(new Date());
	}

	/**
	 * Valida data através do formato indicado
	 * @param data String
	 * @param formato String
	 * @author Igor Almeida
	 */
	
	public static Date getDataValida(String data,String formato) throws ParseException{   
       
		SimpleDateFormat format = new SimpleDateFormat(formato);   
		format.setLenient(false);   
		return format.parse(data);   
    }  

	
	/**
	 * Converte um objeto do tipo Date para String.
	 * @author Luciano Verde
	 * @param data Date.
	 * @return String
	 */
	public static String getConverteDataToString(Date data) {
		// Formato da data.
		String formato = "dd/MM/yyyy";

		SimpleDateFormat formatter = new SimpleDateFormat(formato);

		if (data == null) {
			return null;
		}

		return formatter.format(data);
	}

	/**
	 * Converte um objeto do tipo String para Date.
	 * @author Luciano Verde
	 * @param data String.
	 * @return Date
	 */
	public static Date getConverteStringToDate(String data) {
		// Formato da data.
		String formato = "dd/MM/yyyy";

		Date dataFormatada = null;

		try {
			if (Util.isNotNullOrEmpty(data) && data.length() == 10
					&& data.indexOf("/") == 2) {
				dataFormatada = new SimpleDateFormat(formato)
				.parse(data.trim());
				;
			}
		} catch (Exception e) {
			dataFormatada = null;
		}

		return dataFormatada;
	}

	/**
	 * Verifica nulidade de um objeto ou se um String é vazia.
	 * @author Igor Almeida
	 * @param pObj Object
	 * @return FALSE se o objeto é nulo e TRUE se o objeto não é nulo.
	 */
	public static boolean isNotNullOrEmpty(Object pObj) {

		if (pObj == null) {
			return false;
		}

		if (pObj instanceof String) {
			return !((String) pObj).trim().equals("");
		}

		if (pObj instanceof Object[]) {
			Object[] array = (Object[]) pObj;
			if (array.length > 0) {
				boolean vazio = false;
				for (int i = 0; i < array.length; i++) {
					if (array[i] != null) {
						vazio = true;
						break;
					}
				}
				return vazio;
			} else {
				return false;
			}

		}

		return true;
	}

	/**
	 * Verifica nulidade de um objeto ou se um String é vazia.
	 * @author Igor Almeida
	 * @param pObj Object
	 * @return TRUE se o objeto é nulo e FALSE se o objeto não é nulo.
	 */
	public static boolean isNullOrEmpty(Object pObj) {

		if (pObj == null) {
			return true;
		}

		if (pObj instanceof String) {
			return ((String) pObj).trim().equals("");
		}

		if (pObj instanceof Object[]) {
			Object[] array = (Object[]) pObj;
			if (array.length > 0) {
				boolean vazio = true;
				for (int i = 0; i < array.length; i++) {
					if (array[i] != null) {
						vazio = false;
						break;
					}
				}
				return vazio;
			} else {
				return true;
			}

		}

		return false;
	}

	/**
	 * Método que adiciona um zero à esquerda em um número menor que 10
	 * @author Igor Almeida
	 * @return numero String
	 */
	public static String addZero(Integer pNum) {

		if (isNullOrEmpty(pNum)) {
			return null;
		}

		String numero = String.valueOf(pNum);

		if (pNum.intValue() > 9) {
			return numero;
		} else {

			return "0".concat(numero);
		}
	}

	/**
	 * Função para criar hash da senha informada
	 * @author Igor Almeida
	 * @param senha String
	 * @return String 
	 */
	public static String converterMD5(String senha) {
		String sen = "";
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			return null;
		}
		BigInteger hash = new BigInteger(1, md.digest(senha.getBytes()));
		sen = hash.toString(16);
		return sen;
	}

	/**
	 * Retorna a mensagem com do dicionário substituindo o delimitador (#).
	 * @author Luciano Verde
	 * @param constanteMSGPadrao Mensagem com o delimitador (#).
	 * @param mensagem String
	 * @return String.
	 */
/*	public static String getMensagemDicionario(String constanteMSGPadrao,
			String mensagem) {
		String novaMensagem;

		// Retorna vazio caso esteja nulo.
		if (isNullOrEmpty(constanteMSGPadrao)) {
			return "";
		}

		// Atualizado por Igor Almeida
		else if (isNullOrEmpty(mensagem)) {

			constanteMSGPadrao = constanteMSGPadrao.replace(
					Constantes.DELIMITADOR, "");

			return constanteMSGPadrao;
		}

		// Nova Mensagem a ser exibida.
		novaMensagem = constanteMSGPadrao.replace(Constantes.DELIMITADOR,
				mensagem);

		return novaMensagem;
	}*/

	/**
	 * Verifica se uma string é um valor númerico
	 * @author Luciano Verde
	 * @param valor String
	 * @return valido boolean
	 */
	public static boolean isNumerico(String valor) {
		boolean valido = true;

		// Se retornar NULO ou VAZIO
		if (isNullOrEmpty(valor)) {
			return false;
		}

		for (int i = 0; i < valor.length(); i++) {
			Character caractere = valor.charAt(i);
			if (!Character.isDigit(caractere)) {
				valido = false;
				break;
			}
		}
		return valido;
	}

	/**
	 * Retira todos os caracteres que não são números.
	 * @author Luciano Verde
	 * @param texto String
	 * @return String
	 */
	public static String somenteNumero(String texto) {
		String novoTexto = "";

		// Caso seja nulo ou vazio retorna em branco.
		if (texto == null || texto.equals("")) {
			return novoTexto;
		}
		// Percorre o texto caractere a caractere.
		for (int i = 0; i < texto.length(); i++) {
			Character caractere = texto.charAt(i);

			// Se o caractere for número.
			if (Character.isDigit(caractere)) {
				novoTexto += texto.charAt(i);
			}
		}
		return novoTexto;
	}

	/**
	 * Obtém o usuário da sessão.
	 * @author Igor Almeida
	 * @return UsuarioVO
	 */
/*	public static UsuarioVO getUserSession() {

		HttpSession session = (HttpSession) FacesContext.getCurrentInstance()
		.getExternalContext().getSession(true);

		return (UsuarioVO) session.getAttribute("usuarioLogado");
	}
*/
	/**
	 * Obtem o endereco Ip do usuario.
	 * @author Marcelo Zacarias
	 * @return String
	 */
/*	public static String getRemoteAddress() throws Exception{

		 HttpServletRequest request = (HttpServletRequest)  FacesContext.getCurrentInstance().getExternalContext().getRequest(); 
		 
		 return request.getRemoteAddr();
		
	
	}*/
	
	public static String getIpAddress() throws Exception {
		
		InetAddress ipAddress;
		String ip = "0.0.0.0";
		
		 try {
			 	ipAddress = InetAddress.getByName("localhost");
			 	ip = ipAddress.getHostAddress();
	     } 
		 catch (UnknownHostException e) {
			 
	            System.err.println("Cannot find host");
	            System.exit(1);
	     } 

	     System.out.println("IP Address: " + ip);	          
	     return ip;
	}

	/**
	 * Formata o CPF.
	 * @param cpf String
	 * @autor Luciano verde
	 * @return String
	 */
	public static String formatarCPF(String cpf) {
		try {
			if (isNullOrEmpty(cpf)) {
				return "";
			}
			if (cpf.length() == 11) {
				MaskFormatter mf = new MaskFormatter("###.###.###-##");
				mf.setValueContainsLiteralCharacters(false);
				cpf = mf.valueToString(cpf);
			}

		} catch (ParseException pe) {
		}

		return cpf;
	}

	/**
	 * Formata a matrícula colocando o hifen na penultimo posição da String
	 * @autor Paulo Santos
	 * @param matricula String
	 * @return String
	 */
	public static String formatarMatricula(String matricula) {

		if (isNullOrEmpty(matricula)) {
			return "";
		}

		if (matricula.length() > 1) {
			matricula = matricula.substring(0, matricula.length() - 1);
			matricula += "-";
			matricula += matricula.substring(matricula.length() - 1);
		}
		return matricula;

	}

	/**
	 * Máscara para CPF.
	 * @author Luciano Verde
	 * @param cpf String
	 */
	public static String mascaraCPF(String cpf) {
		try {
			// Verificar se NULO ou VAZIO.
			if (Util.isNotNullOrEmpty(cpf)) {
				// Retorna SOMENTE números.
				cpf = Util.somenteNumero(cpf);

				MaskFormatter maskFormatter = null;

				// CPF tamanho = 3 Máscara ("###.").
				if (cpf.length() == 3) {
					maskFormatter = new MaskFormatter("###.");
					maskFormatter.setValueContainsLiteralCharacters(false);
					cpf = maskFormatter.valueToString(cpf);
				}
				// CPF tamanho = 6 Máscara ("###.###.").
				else if (cpf.length() == 6) {
					maskFormatter = new MaskFormatter("###.###.");
					maskFormatter.setValueContainsLiteralCharacters(false);
					cpf = maskFormatter.valueToString(cpf);
				}
				// CPF tamanho = 9 Máscara ("###.###.###-").
				else if (cpf.length() == 9) {
					maskFormatter = new MaskFormatter("###.###.###-");
					maskFormatter.setValueContainsLiteralCharacters(false);
					cpf = maskFormatter.valueToString(cpf);
				}
				// CPF tamanho = 11 Máscara ("###.###.###-##").
				else if (cpf.length() == 11) {
					maskFormatter = new MaskFormatter("###.###.###-##");
					maskFormatter.setValueContainsLiteralCharacters(false);
					cpf = maskFormatter.valueToString(cpf);
				}
				// Retorna o CPF com o caractere ("_").
				else {
					cpf = cpf + "_";
				}
			}
		} catch (Exception e) {
		}

		return cpf;
	}
	

	/**
	 * Método que gera o popup de relatórios
	 * @param url
	 * @throws Exception
	 */
/*	public static void gerarReport(String caminho) throws Exception {

		StringBuffer retorno = new StringBuffer("javascript:var w = window.open('");

		retorno.append(Util.getProperty("url.servidor.relatorios"))
		.append(caminho)
		.append("','Relatorio','resizable=yes,menubar=no,")
		.append("scrollbars=no,status=no,toolbar=no,fullscreen=no,")
		.append("dependent=no,width=758,height=600,left=500,top=300');")
		.append(" if (window.execScript) { ")
		.append(" window.execScript(w); ")
		.append(" } else eval(w); ");

		JavascriptContext.addJavascriptCall(FacesContext.getCurrentInstance(),String.valueOf(retorno));	  
	}*/

	/**
	 * Método que valida E-mail
	 * @author Igor Almeida
	 * @param email
	 * @return boolean.
	 */
	public static boolean validarEmail(String email) {

		String mask = "[A-Za-z0-9\\._-]+@[A-Za-z0-9\\.]+\\.[A-Za-z]+";

		return email.matches(mask);
	}	


	/**
	 * Metodo que retorna a mensagem do arquivo de propriedade
	 * @author Alcides Mendes
	 * @param messageKey
	 * @return mensagem do propertie
	 */
/*	public static String getProperty(String messageKey) throws Exception {
		
		ResourceBundle bundle = ResourceBundle.getBundle(FacesContext
				.getCurrentInstance().getApplication().getMessageBundle());
		String mensagem = bundle.getString(messageKey);

		return mensagem;
	}
	
	
	public static void main(String[] args) {
		
	

		
	}
	*/
	
	/**
	 * Funcao para Gerar Matricula
	 * @author Marcelo Zacarias
	 * @param  int unidade, int totalLinhas
	 * @return String 
	 */
	public static String gerarMatricula(int clienteId, int unidadeId, int totalAlunosUnidade) {
	
		return getDataAno() + "C" + clienteId + "U" + unidadeId + "S" + (++totalAlunosUnidade);
	}
}



