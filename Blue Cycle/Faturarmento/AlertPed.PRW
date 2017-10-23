#INCLUDE "RWMAKE.CH" 
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'




User Function AlertPed(cPedido)

Private nI
Private cUsrname
Private cUsrmail
Private nI
Private lRet := .T.
Private xval := 0
Private xqtd := 0
Private cFILIAL:= "" 
Private xStatus:= ""
Private xMARCA:= ""
Private _cStatus:= ""   
Private nProvent
Private nDescont
















        cQuery := " SELECT C5_NUM,C5_CLIENTE, C5_LOJACLI, C5_TRANSP, C5_VEND1, C5_VEND2, C5_CONDPAG, "
        cQuery += " A1_NOME, A4_NOME, A3VDE.A3_NOME VDE, A3VDI.A3_NOME VDI, E4_DESCRI, A1_CGC, A1_EST, A1_MUN, SUM(C6_QTDVEN * C6_PRCVEN) VLRPED FROM "
        cQuery += " SC5010 "
        cQuery += " INNER JOIN SC6010 "
        cQuery += " ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM "
        cQuery += " INNER JOIN SA1010 "
        cQuery += " ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
        cQuery += " LEFT JOIN SA3010 A3VDE "
        cQuery += " ON A3VDE.A3_COD = C5_VEND1 AND A3VDE.D_E_L_E_T_ = ' '  "
        cQuery += " LEFT JOIN SA3010 A3VDI "
        cQuery += " ON A3VDI.A3_COD = C5_VEND2 AND A3VDI.D_E_L_E_T_ = ' ' "
        cQuery += " INNER JOIN SE4010 ON "
        cQuery += " E4_CODIGO = C5_CONDPAG AND SE4010.D_E_L_E_T_ = ' ' "
        cQuery += " LEFT JOIN SA4010 ON  "
        cQuery += " A4_COD = C5_TRANSP AND SA4010.D_E_L_E_T_ = ' ' "
        cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = '"+cPedido+"' AND SC5010.D_E_L_E_T_ = ' ' AND SC6010.D_E_L_E_T_ = ' ' "
        cQuery += " GROUP BY C5_NUM,C5_CLIENTE, C5_LOJACLI, C5_TRANSP, C5_VEND1, C5_VEND2, C5_CONDPAG, "
        cQuery += " A1_NOME, A4_NOME, A3VDE.A3_NOME, A3VDI.A3_NOME, E4_DESCRI, A1_CGC, A1_EST, A1_MUN        " 
        
        TCQUERY cQuery ALIAS "TRB" NEW  
        
                //Alert('Query finalizada!')
				cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">				  '
				cMensagem += '<html>											    '
				cMensagem += '<head>											      '
				cMensagem += '<title></title>										      '
				
				cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=Windows-1252">		     '
				
				cMensagem += '<meta http-equiv="Content-Style-Type" content="text/css">						'
				cMensagem += '<meta name="GENERATOR" content="Dynamic HTML Editor v.6.8 - http://www.hexagora.com">		 '
				cMensagem += '<link rel="stylesheet" type="text/css" href="preview.css">					'
				
				cMensagem += '<script language="javascript" type="text/javascript" src="dhwe6x.min.js"></script>	       '
				cMensagem += '<script language="javascript" type="text/javascript">					       '
				
				
				
				cMensagem += '</script>											      '
				cMensagem += '</head>											      '
				cMensagem += '<body text="#000000" bgcolor="#FFFFFF" link="#0000FF" alink="#FF0000" vlink="#800080">	      '
				
				cMensagem += '<div id="ldheTable1" style="position: absolute; left: 71px; top: 20px;"> '
				
				cMensagem += '<table id="Table1" width="500" border="0" cellspacing="0" cellpadding="0">'
				cMensagem += '<tr>'
				cMensagem += '<td width="406" height="58" align="center" valign="middle" ><span class="verdana140FFFFFFt"><font size ="4"><IMG SRC="https://static.wixstatic.com/media/410f9c_5a170ac32e46406bab5b5644b5c4de13.png/v1/fill/w_198,h_50,al_c,usm_0.66_1.00_0.01/410f9c_5a170ac32e46406bab5b5644b5c4de13.png" ALT="?" BORDER=0>ATEN플O!!!</span></td></tr></table></div>'
				
				cMensagem += '<div id="ldheTable2" style="position: absolute; left: 71px; top: 77px;">				       '
				
				cMensagem += '<table id="Table2" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid">			       '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="2">HOUVE UM PROBLEMA NA INTEGRA플O ERP x WMS E O PEDIDO '+TRB->C5_NUM+' EST� PARADO AGUARDANDO SUA INTERVEN플O PARA CORRE플O E ENVIO.</td> </tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">PEDIDO: '+TRB->C5_NUM+'  - CLIENTE: '+TRB->C5_CLIENTE + ' - '+TRB->C5_LOJACLI+' - '+TRB->A1_NOME+'</td></tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CIDADE:  '+TRB->A1_MUN+' - ESTADO: '+TRB->A1_EST+'</td></tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CNPJ: '+TRB->A1_CGC+'</td></tr> '
				cMensagem += '</table></div>											  '
				
				cMensagem += '<div id="ldheTable3" style=" position: absolute; left: 71px; top: 168px;">				    '
			
				cMensagem += '<table id="Table3" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">			      '
				cMensagem += '<tr>												      '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">VENDEDOR EXTERNO: '+TRB->VDE+'</td></tr> '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">VENDEDOR INTERNO: '+TRB->VDI+'</td></tr>	 '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">COND. PAGTO.: '+TRB->E4_DESCRI +'</td></tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">TRANSPORTADORA: '+TRB->A4_NOME+' </td></tr>'
				cMensagem += '</table></div>											    '
				
				
		
		

				
				cMensagem += '<table id="Table6" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">'
				
				cMensagem += '<tr bgcolor="#0099CC">									 '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">TOTAL PEDIDO: </span></td>'
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(TRB->VLRPED,"@e 999,999,999.99")+'</span></td></tr>	     '
/*				cMensagem += '<tr>													      '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">TOTAL DE DESCONTOS: </span></td>'
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(nDescont,"@e 999,999,999.99")+'</span></td></tr>		    '
				cMensagem += '<tr>														     '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">LIQUIDO A RECEBER: </span></td>    '
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(nProvent-nDescont,"@e 999,999,999.99")+'</span></td></tr>'*/
				//cMensagem += '</tbody>'
				cMensagem += '</table></div>'
		  		cMensagem += '</body>'
				cMensagem += '</html> '	
				_xmail1 := 'adm.comercial@bluecycle.com.br'
				
				
				cBody := cMensagem
				cBCC:= ""
				xLocal:= ""
		        //xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
				arqu:=""
				//arqu:="pedido_.html"
				MemoWrite(xLocal+arqu,cMensagem)
				cFrom := GetMv("MV_EMAILPE")  //conta de email para envio
				cTos:= _xmail1
		      //  cBCC:= GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3")+TRB->C5_VEND1,1,"")    // email de copia para vendedor - copia oculta
				cSubject := 'ALERTA!! PEDIDO '+TRB->C5_NUM+' - PARADO' // +  _xnumped
				cAttachment := ''+xLocal+arqu     //atacha a imagem antes do pedido 
				xmen:= cMensagem
				//CONNECT SMTP SERVER GetMv("MV_RELSERV") ACCOUNT GetMv("MV_RELACNT") PASSWORD GetMv("MV_RELPSW") RESULT lOk 
				CONNECT SMTP SERVER GetMv("MV_RELSERV") ACCOUNT GetMv("MV_EMAILPE") PASSWORD GetMv("MV_SENHAPE") RESULT lOk
				// o comando CONNECT conecta ao servidor smtp
				// atraves da conta contida em cAccount
				// repare na senha, eh como se voce utilizasse o Outlook Express
				
				If lOk    // teste se a conexao com o servidor smtp teve sucesso
					If GetMV('MV_RELAUTH')
						Mailauth(GetMv("MV_EMAILPE"),GetMv("MV_SENHAPE"))
													
					EndIf
					If cAttachment == ""
						SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen RESULT lEnv
					Else
						SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen ATTACHMENT cAttachment RESULT lEnv
					Endif
					// o comando sendmail envia a mensagem pela conta cAccount,
					// utilizando a lista de destinatarios em cTos
					// com a mensagem contida em cMensagem
					
					If ! (lEnv)  // testa se a mensagem foi enviada com sucesso
						lRet := .F.
		  		        MsgAlert("Ocorreu uma falha no envio do email para:  "+cTos)
		            ELSE
		   		        MsgAlert("Comunicado de pedido parado enviado com sucesso para:  "+cTos)
		 			Endif
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
				Else
					lRet := .F.
		 		    MsgAlert("OCORREU FALHA NA CONEX홒 COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
				Endif 


DbCloseArea("TRB")

Return()	  

		