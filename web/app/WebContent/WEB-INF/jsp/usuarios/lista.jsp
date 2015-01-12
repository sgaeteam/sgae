<head>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<link href="css/reset.css" rel="stylesheet" type="text/css" />
<link href="css/custom.css" rel="stylesheet" type="text/css" />
<link href="css/data-table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.fancybox.css" rel="stylesheet" type="text/css" />
<link href="css/ui-slider.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.miniColors.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/custom.js"></script>

<script type="text/javascript" language="javascript"
	src="js/jquery.dataTables.js"></script>

<script type="text/javascript" src="js/jquery.fancybox.js"></script>

<script src="js/jquery-ui-1.8.13.custom.min.js" type="text/javascript"
	charset="utf-8"></script>

<script type="text/javascript" src="js/vertlib.min.js"></script>
<!-- Right Menu Fixed Scroll-->
<script type="text/javascript" src="js/StickyScroller.min.js"></script>
<!-- Right Menu Fixed Scroll-->

<script type="text/javascript" src="js/jquery.miniColors.js"></script>

<script type='text/javascript' src='js/fullcalendar.min.js'></script>
<script src="js/elfinder.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<h1>${opcao}</h1>

<div class="tabs_links">
	<ul>
		<li><a href="/sgae/alunos">Alunos</a></li>
		<li><a href="#information">Instrutores</a></li>
		<li><a href="#invoice">Extras</a></li>
		<li><a href="#full-calendar">Financeiro</a></li>
		<li><a href="#full-calendar">Estoques</a></li>
		<li><a href="#full-calendar">Fornecedores</a></li>
	</ul>
</div>

<!--Tabs-Box-Ends-->



<div id="main">

	<div id="content">

		<div class="tab_content" id="tables">

			<div class="element-box">

				<table cellpadding="0" cellspacing="0" border="0" class="table"
					id="example">
					<thead>
						<tr>
							<th align="left">Nome</th>
							<th align="left">C.P.F</th>
							<th align="left">Alterar</th>
							<th align="left">Excluir</th>
						</tr>
					</thead>
					<tbody>

						<c:forEach items="${usuarioList}" var="usuario">
							<tr>
								<td>${usuario.nome}</td>
								<td>${usuario.cpf}</td>
								<td><a href="<c:url value="/alunos/${aluno.id}"/>">Editar</a>
								</td>
								<td>
									<form action="<c:url value="/alunos/${aluno.id}"/>"
										method="POST">									
										<button class="link" name="_method" value="DELETE">Remover</button>
									</form></td>
							</tr>
						</c:forEach>

					</tbody>
				</table>
				<input type="hidden" name="callBack" value="/cadastros/formulario"/>
			</div>
		</div>
		<!--TABLES TAB ENDS-->


		<div class="tab_content" id="information">

			<div class="element-box">
				<h1>About Eternity Admin Theme</h1>
				<p>Somting Abot Eternity Admin</p>
				<br />
				<p>Eternity Admin!!! The designer’s choice. This template is the
					perfect way to design a website with hundreds of possible features
					and plugins required while designing/developing a Website. It gives
					you different layouts and plugins to design a dashboard or a
					webform. Based on Jquery, the interface is light,responsive and
					ready to use. Eternity Admin provides custom layouts, error pages
					and themes to be used with your website. One of the main features
					of Eternity Admin is that it is compatible with all browsers. With
					more than 100 different buttons styles and grid layouts, this
					template becomes even more powerful.</p>
				<p>Eternity Admin provides also provides an admin template with
					features such as Left Menu and more. The tool can also be used to
					create web features such as Calendars, Contact Lists, HTML Player
					and wizards. The mobile version of Eternity Admin is also available
					which is also compatible with different mobile web browsers. The
					template also provides an image gallery with latest graphics.</p>
				<p>Eternity Admin’s left menu template is available with
					different features such as expandable menu controls, search
					capability. One can also extract templates for google maps and
					different notifications.</p>
			</div>

		</div>
		<!--INFORMATION TAB ENDS-->



		<div class="tab_content" id="full-calendar">

			<div class="element-box">
				<h1>Programa&ccedil;&atilde;o de aulas</h1>
				<p>Arraste e solte qualquer aula para qualquer data e
					vo&ccedil;&ecirc; pode clicar em qualquer data para adicionar uma
					aula.</p>
				<br />

				<div id="calendar"></div>

			</div>

		</div>
		<!--CALENDAR TAB ENDS-->




		<div class="tab_content" id="invoice">

			<div class="element-box">
				<h1>Invoice Design Sample</h1>
				<p>Invoice details</p>
				<br />

				<ul class="client_details">
					<li><strong class="name">John Doe Inc.</strong></li>
					<li>1600 Pennsylvania Ave NW</li>
					<li>Orlando, FL, Doe City</li>
					<li>Washington DC</li>
					<li>Phone: (888) 707-8822</li>
					<li>Email: info@infynitix.com</li>
				</ul>

				<ul class="invoice_details">
					<li>Number: 11047</li>
					<li>Customer ID: 123</li>
					<li>Invoice Number: #5487</li>
					<li>Invoice Date: 05/09/1990</li>
					<li>Job Number: WEB-2345</li>
				</ul>

				<table class="table">

					<thead>
						<tr>
							<th>Qty</th>
							<th>Unit</th>
							<th>Description</th>
							<th class="price">Taxed</th>
							<th class="total">Amount</th>
						</tr>
					</thead>

					<tbody>
						<tr>
							<td>4</td>
							<td>Hours</td>
							<td>Service Fee</td>
							<td class="price">100.00</td>
							<td class="total">$2350.00</td>
						</tr>
						<tr>
							<td>7</td>
							<td>Hours</td>
							<td>Labor : 5hours at $75/hr</td>
							<td class="price">75.00</td>
							<td class="total">$750.00</td>
						</tr>
						<tr>
							<td>2</td>
							<td>Product</td>
							<td>Parts</td>
							<td class="price">3500.20</td>
							<td class="total">$3500.20</td>
						</tr>
						<tr>
							<td>13</td>
							<td>Product</td>
							<td>Parts</td>
							<td class="price">2587.00</td>
							<td class="total">$2145.15</td>
						</tr>
						<tr>
							<td colspan="3" class="sub_total"></td>
							<td class="sub_total">Subtotal:</td>
							<td class="sub_total">$7584.30</td>
						</tr>
						<tr class="total_bar">
							<td colspan="3" class="grand_total"></td>
							<td class="grand_total">Total:</td>
							<td class="grand_total">$7584.30</td>
						</tr>
					</tbody>
				</table>



			</div>
			<!--OTHER TAB-->


		</div>
		<!--INVOIVE-END-->

	</div>
	<!--CONTENT-END-->


</div>
<!--MAIN END-->