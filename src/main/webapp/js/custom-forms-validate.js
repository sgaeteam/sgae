/**
 * Jquery para personaliza��o de valida��es para os formul�rios
 */
$(document).ready(function () {	   
	    
        //Defini��o de m�scaras para campos de qualquer formul�rio.
        $(".cpf").mask("999.999.999-99");
        $('.cnpj').mask("99.999.999/9999-99");
        $('.cep').mask("99.999-999");
        $('.telefone').mask("(99) 999?9-9999");
        $(".hora").mask("99:99");
        $(".data").mask("99/99/9999");
        
        //Configura��o da dire��o do Tooltip para os campos do formul�rio do cadastro de 
        $('#feedbackform :input').tipsy({ trigger: 'manual', fade: true, gravity: 'w' });
        //Regras para os campos do formul�rio
        $('#feedbackform').validate({
            rules: {
                nome: {required:true, minlength: 5},
                cpf:  {required:true, cpf: true}
            },

            messages: {
                nome: {required:"O campo nome &eacute; obrigat&oacute;rio", minlength:"O campo nome deve conter no m&iacute;nimo 5 caracteres."},
                cpf:  {required:"O campo CPF &eacute; obrigat&oacute;rio", cpf: 'Informe um CPF v&aacute;lido.'}
            },

            success: function (label) {
                $(label).each(function () {
                    $('#' + this.htmlFor).tipsy('hide');
                });
            },

            errorPlacement: function (error, element) {
                element.attr('title', error.text());
                element.tipsy('show');
            }
        });

    });