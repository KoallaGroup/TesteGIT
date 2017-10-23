#INCLUDE "GPER1030.CH"

Static Function GP030HTM(lTerminal)

Local aSvArea		:= GetArea()
Local aGetArea		:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
Local cHtml			:= ""
Local cSubject		:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cTipo			:= ""
Local cTitTotal		:= STR0065
Local cTitTDesc		:= STR0066
Local cTitTLiq  	:= STR0067
Local cReferencia	:= ""
Local cVerbaLiq		:= ""
Local dDataPagto	:= Ctod("//")
Local nBase    		:= 0
Local nDesco
Local nZebrado		:= 0.00
Local nResto		:= 0.00
Local nProv
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario      
Local cDescUbigeo   := "" 

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

aGetArea	:= SRC->( GetArea() )
cTipo		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")

IF cTipoRot == "2"
	cVerbaLiq	:= PosSrv( "007ADT" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "1"
	cVerbaLiq	:= PosSrv( "047CAL" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "5"
	cVerbaLiq	:= PosSrv( "022C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "6"
	cVerbaLiq	:= PosSrv( "021C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF  cRoteiro == "EXT"
	cVerbaLiq	:= ""
EndIF

IF  cRoteiro <> "EXT"
	dDataPagto := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro) , SRA->RA_FILIAL , "RCH_DTPAGO")
EndIf

IF !( lTerminal )
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Busca parametros                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		Return
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se existe o SMTP Server                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se existe a CONTA                                   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se existe a Senha                                   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If 	Empty(cMailSenha)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
EndIF

If cPaisloc == "PER" .And. !( lTerminal )
	cDescUbigeo := fRDescUbig()
Endif

IF ( !Empty(Semana) .and. ( Semana # "99" ) .and. ( Upper(SRA->RA_TIPOPGT) == "S" ) )
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega Datas Referente a semana                             Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	PerSemana()
	cReferencia := STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" //"Semana  "###" a "

ElseIf cPaisloc == "BOL"
	cReferencia	:= cTipo
Else
	cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + "-" + cPeriodo + "/" + Semana + " )"
EndIf

cHtml +=	'<?xml version="1.0" encoding="iso-8859-1"?>'
cHtml +=	'<!doctype html public "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cHtml +=	'<html xmlns="http://www.w3.org/1999/xhtml">'
cHtml +=	'<head>'
IF !( lTerminal )
	
	cHtml += 		'<title>DEMONSTRATIVO DE PAGAMENTO II</title>'
	cHtml +=	'</head>'
	cHtml +=		'<body bgcolor="#F0F0F0"  topmargin="0" leftmargin="0">'
	cHtml +=			'<center>'
	cHtml +=				'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#000082" bgcolor="#000082" width=598 height="637">'

	//Cabecalho
	cHtml +=    				'<td width="598" height="181" bgcolor="#FFFFFF">'
	cHtml += 					'<center>'
	cHtml += 					'<font color="#000000">'
	cHtml +=					'<b>'
	cHtml += 					'<h4 size="03">'
	cHtml +=					'<br>'
	cHtml += 						STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 					'<br>'
	
Else
	
	cHtml += 		'<title>RH Online</title>' + CRLF
	cHtml += 		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += 		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">' + CRLF
	cHtml += 	'</head>' + CRLF
	cHtml += 	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += 		'<Table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	
	//Cabecalho completo - TERMINAL
	Do Case
	Case cPaisLoc == "ARG"
		cHtml += 			CabHtmlArg( cReferencia , dDataPagto , dDataRef )
	Case cPaisLoc == "BOL"
		cHtml += 			CabHtmlBOL( cReferencia , dDataPagto , dDataRef )
	Otherwise
		cHtml += 			CabecHtml( cReferencia , dDataPagto , dDataRef )
	EndCase	
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=	 				"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	cHtml +=			"<TABLE border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
EndIF

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
Else
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
EndIf

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Carrega Funcao do Funcion. de acordo com a Dt Referencia     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

IF !( lTerminal )

	If cPaisloc <> "PER"	
		cHtml += '</b></h4></font></center>'
	cHtml += '<hr width = 100% align=right color="#000082">'

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Dados da Empresa	                                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += '<!Dados da Empresa>'
	cHtml += '<p align=left  style="margin-top: 0">'
	cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;' + Desc_Fil+'</i></b></font><br>'  //Empresa
	cHtml += 	'<font color="#000082" face="Courier New" size="2">'
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;'+ STR0098  + Desc_End	+'<br>'		//EndereГo
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;' +STR0179  + Desc_Cid	+ '&nbsp;&nbsp;&nbsp;' + STR0180 + Desc_Est + '<br>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;'+ STR0099  + Transform( Desc_CGC , "@R 99.999.999/9999-99")  	//CNPJ
	cHtml += '</p></font>'

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Dados do funcionario                                         Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += '<hr width = 100% align=right color="#000082">'
		cHtml += '<!Dados do Funcionario>'
		cHtml += '<p align=left  style="margin-top: 0">'
		cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;' + SRA->RA_NOME + "- " + SRA->RA_MAT+'</i></b></font><br>'
	cHtml += 	'<font color="#000082" face="Courier New" size="2">'
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;' + STR0048 + cCodFunc + "  "+cDescFunc	+'<br>' //"Funcao    - "
	cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;' + STR0047 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
	cHtml +=    '&nbsp;&nbsp;&nbsp;&nbsp;' + STR0049 + SRA->RA_BCDEPSAL+" - "+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
	cHtml += '</p></font>'

		cHtml += '<!Proventos e Desconto>'
		cHtml += '<div align="center">'
		cHtml += '<Center>'
	cHtml += '<Table bgcolor="#F0F8FF" style="border: 1px #003366 solid;" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
	cHtml +=    '<tr bgcolor="A2B5CD">' 
	cHtml += 	'<td><font face="Arial" size="02" color="#000082"><b>' + STR0050 + '</b></font></td>' //"Cod  Descricao "
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + STR0051 + '</b></font></td>' //"Referencia"
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + STR0052 + '</b></font></td>' //"Valores"
	cHtml += 	'<td>&nbsp;</td>'
	cHtml += 	'</tr>'
	ELSE //Cabecalho utilizado pela localizacao Peru
		cHtml += '</b></h4></font></center>'                                  
		cHtml += '<hr whidth = 100% align=right color="#FF812D">'            
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Dados do funcionario                                         Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cHtml += '<!Dados do Funcionario>'
		cHtml += '<p align=left  style="margin-top: 0">'
		cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
		cHtml +=  	'&nbsp;&nbsp' + STR0001 + ":" + '&nbsp;' + SRA->RA_MAT + '&nbsp;' + "-" + '&nbsp;' + SRA->RA_NOME +'</i><br>' //Funcionario
		cHtml += 	'&nbsp;&nbsp' + "DNI" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  '&nbsp;' + SRA->RA_RG      + '&nbsp;&nbsp;' + STR0174 + '&nbsp;' +":"+ '&nbsp;' + AllTrim(STR(SRA->RA_HRSMES))+'<br>' //"DNI + Horas Mensais
		cHtml += 	'&nbsp;&nbsp' + "AFP" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  Space(1) + SRA->RA_CODAFP  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + "Ubigeo :" + '&nbsp;' + cDescUbigeo +'<br>' //"DNI + Horas Mensais
		cHtml += 	'&nbsp;&nbsp' + STR0103 + '&nbsp;&nbsp;' + ":" + '&nbsp;' + cCodFunc   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + STR0069 + '&nbsp;' + ":" + '&nbsp;' + cDescFunc	+'<br>' //"Funcao    - Descricao "
		cHtml +=  	'&nbsp;&nbsp' + STR0002 + '&nbsp;&nbsp'  + ":" + '&nbsp;' + SRA->RA_CC + '&nbsp;'+ "-" + '&nbsp;' + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
		cHtml +=    '&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
		cHtml += '</b></p></font>'
		cHtml += '<!Proventos e Desconto>'
		cHtml += '<div align="center">'
		cHtml += '<Center>'
		cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
		cHtml += '<TBody><Tr>'
		cHtml +=	'<font face="Arial" size="02" color="#000082"><b>'
		cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
		cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
		cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
		cHtml += 	'</b></font></tr>'
		cHtml += '<font color=#000082 face="Courier new"  size=2">'
	ENDIF
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Espacos Entre os Cabecalho e os Proventos/Descontos          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
Else
	
	//Cabecalho dos valores
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml += 							'<tr align="center">' + CRLF
	cHtml += 								'<td width="45" height="1">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="Left">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="left">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0070  + '</span></div>' + CRLF //Refer&ecirc;ncia
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0052 + '</span></div>' + CRLF //Valores
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right"> (+/-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml += 					'</TABLE>' + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Proventos                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nProv:=1 To Len( aProve )
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,2],'999.99')+'</b></font></td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,3],cPict3) + '</b></font></td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" vAlign=top height="1" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" vAlign=top height="1">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" vAlign=top="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nProv

IF ( lTerminal )
	cHtml +=							"</TR>" + CRLF
	cHtml +=							"<TR>" + CRLF
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Descontos                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nDesco := 1 to Len(aDesco)
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,2],'999.99') + '</b></font></td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,3],cPict3) + '</b></font></td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" align="center" height="19" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" align="center" height="19">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nDesco

IF ( lTerminal )
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Terminal - Impressao de Bases                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF cBaseAux = "S"

		For nBase:=1 To Len( aBases )
	
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										aBases[nBase,1] + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,2],'999.99') + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,3],cPict1) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF

        Next

		If Len( aBases ) > 0   // Espaco apos impressao bases

			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc"></td>'
			cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_18_AlignL"></td>'
			cHtml += 	'</tr>'
		
		EndIf

	EndIf
EndIF

IF !( lTerminal )
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Espacos Entre os Proventos e Descontos e os Totais           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Totais                                                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTVENC,cPict3) + '</b></font></td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTDESC,cPict3) +  '</b></font></td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>'
	cHtml += 		'<td align=right height="18" width="95" Style=border-top:1px solid #000082 bgcolor=#4B87C2">'
	cHtml +=        '<font color="#000082">' + Transform((TOTVENC-TOTDESC),cPict3) + '</font></td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
	
Else
	
	If cPaisLoc == "ARG"
		cTitTotal := AllTrim(SubsTr(STR0094,2))
		cTitTDesc := AllTrim(SubsTr(STR0095,2))
		cTitTLiq  := AllTrim(SubsTr(STR0096,2))
	EndIf

	//Total de Proventos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTotal + '</div>' + CRLF //"Total Bruto: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTVENC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	//Total de Descontos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTDesc + '</div>' + CRLF //"Total de Descontos: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTDESC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	
	//Liquido
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas">' + cTitTLiq  + '</div>' + CRLF //"L&iacute;quido a Receber: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (=) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Espacos Entre os Totais e as Bases                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF !( lTerminal )
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Salario Base                                                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml +=	'<tr>'
	cHtml +=		'<td class="tdPrinc"><p class="pStyle1">'+STR0181+'</p></td>' //"Salario Base
	cHtml +=		'<td class="td26_94_AlignR"><p></p></td>'
	cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nSalario,cPict1)+ '</b></font></td>'
	cHtml += '</tr>'
	
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Base de Adiantamento                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cTipoRot = "2"
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !( lTerminal )
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict1)+ '</b></font></td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
			cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,cPict3) + '</div></td>' + CRLF
			cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,cPict3) + '</div></td>' + CRLF
			cHtml += '</tr>'
		EndIF
	Endif
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Base de Folha e de 13o 20 Parc.                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ElseIf (cTipoRot = "1" .Or. cTipoRot = "6") .And. cPaisloc == "BRA"
	
	IF cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0056 +'</p></td>'//"Base FGTS/Valor FGTS"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict3)+ '</b></font></td>'
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts    ,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0057 +'</p></td>'//"Base IRRF Folha/Ferias"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict3)+ '</b></font></td>'
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIrfe,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'                                   
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0116 +'</p></td>'//"Base INSS"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nAteLim,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas'>"
			cHtml +=										STR0057 + CRLF //"Base IRRF Folha/Ferias"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados'>" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nBaseIr,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados'>"  + CRLF
			cHtml += 										"<div align='right'>" + Transform(nBaseIrFe,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados'>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas' bgcolor='#FAFBFC' >"
			cHtml +=										STR0116 + CRLF //"Base INSS"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas" bgcolor="#FAFBFC"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nAteLim,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados' bgcolor='#FAFBFC' >"  + CRLF
			cHtml += 										"<div align='right'></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
		EndIF
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁMotivo: Permitir que possam ser exibidos no rodape do recibo de pagamento valores de verbas especificasЁ
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ExistBlock("GP30BASEHTM")
			cHtmlAux := ExecBlock("GP30BASEHTM",.F.,.F.)
			If ValType(cHtmlAux) = "C"
				cHtml  += cHtmlAux
			Endif	
		Endif
	EndIF
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Bases de FGTS e FGTS Depositado da 1╕ Parcela                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ElseIf cTipoRot = "5" .And. cPaisloc == "BRA"
	
	If cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc">'
			cHtml +=		'<p class="pStyle1">'+ STR0056 +'</td>' //"Base FGTS / Valor FGTS"
			cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict1) + '</b></font></td>'
			cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts,cPict2) + '</b></font></td>'
			cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
			cHtml += 	'</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
		EndIF
		
	Endif
	
EndIF

IF !( lTerminal )
	
	cHtml += '</font></i></b>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#000082">'
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Espaco para Observacoes/mensagens                            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor="#FFFFFF" border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082"><b>'+STR0146+'</b></font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	If Month(dDataRef) == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Arial" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
	
Else
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=			 		"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Rodape
	cHtml +=	RodaHtml()
	
	cHtml += 		'</TABLE>' + CRLF
	cHtml += 		'<p align="right"><a href="javascript:self.print()"><img src="imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += 	'</body>' + CRLF
	cHtml += '</html>' + CRLF
	
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia e-mail p/funcionario                                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF !( lTerminal )
	lEnvioOK := GPEMail(cSubject,cHtml,cEMail)
EndIF

RestArea( aSvArea )

Return( IF( lTerminal , cHtml , NIL ) )