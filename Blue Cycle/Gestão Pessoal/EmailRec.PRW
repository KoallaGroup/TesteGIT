#INCLUDE "RWMAKE.CH" 
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'
/*                                                                                                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PEDVENASEMAILºAutor ³ALEXANDRE J PASCO º Data ³  16/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio o pedido de e-mail para os e-mail cadastro nos       º±±
±±º          ³ Clientes, vendedores, contatos e e-mail digitados no pedidoº±±                                
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BLUE CYCLE                                                 º±±                                   
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RECIBOEMAIL()
Local cFiltro:= Space(58)              

DEFINE MSDIALOG oDlg FROM 0,0 TO 210,780 PIXEL TITLE " E N V I A   O   P E D I D O   P O R   E M A I L ? " 
@ 22,15 Say OemToAnsi("EMAIL: ") Of oDlg Pixel
@ 22,36 MsGet oFiltro Var cFiltro Picture "@" of oDlg Pixel Valid (cFiltro)
@ 67,48 BUTTON oButton  PROMPT  " ENVIA "  SIZE 73,11   OF oDlg PIXEL ACTION RECEMAIL2(cFiltro) 
@ 67,124 BUTTON oButton2 PROMPT " CANCELA " SIZE 73,11   OF oDlg PIXEL ACTION oDlg:End() 
ACTIVATE MSDIALOG oDlg CENTERED 

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////TELA AGUARDE
Static Function RECEMAIL2(_EMAIL)

MsgRun("Enviando o e-mail ","Aguarde...",{|| EmailRec(_EMAIL) })

Return()


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////CORPO DA FUNCAO
	User Function EmailRec(_EMAIL)

Private nI
Private cUsrname
Private cUsrmail
Private nI
Private lRet := .T.
Private xval := 0
Private xqtd := 0
Private cFILIAL:= "" 
Private cPEDIDO:= ""
Private xStatus:= ""
Private xMARCA:= ""
Private _cStatus:= ""
Private xCont := 0   
Private nProvent
Private nDescont       
Private nBase 
Private cTpVerba



//pergunte("EMAILREC",.T.)
	//	If Select("TRB") > 0
	//		DbSelectArea("TRB")
	//		DbCloseArea("TRB")
	//	End If          
If !Pergunte("EMAILREC")
      return
EndIf

 		
//        cFILIAL:= SC5->C5_FILIAL 
//        cPEDIDO:= SC5->C5_NUM
        

  
        cQuery := " SELECT RA_FILIAL, RA_NOME, RA_MAT, RA_CODFUNC, RA_CC, RA_BCDEPSA, RA_CTDEPSA, RA_ADMISSA, CTT_DESC01, RJ_DESC, RA_EMAIL, RA_SITFOLH, SUBSTR(RC_DATA,1,6) RC_DATA FROM SRA010 SRA "
        cQuery += " INNER JOIN SRJ010 SRJ ON "
        cQuery += " RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ = ' ' " 
        cQuery += " INNER JOIN CTT010 CTT ON "
        cQuery += " CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ = ' ' "            
        
        cQuery += " INNER JOIN SRC010 SRC ON "
        cQuery += " RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRC.D_E_L_E_T_ = ' ' "         
        

        
        cQuery += " WHERE SRA.RA_SITFOLH <> 'D' AND SRA.D_E_L_E_T_ <> '*' AND SRA.RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
        cQuery += " AND SRA.RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 
        cQuery += " AND SRA.RA_CC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND RA_EMAIL <> ' ' "  
        cQuery += " GROUP BY RA_FILIAL, RA_NOME, RA_MAT, RA_CODFUNC, RA_CC, RA_BCDEPSA, RA_CTDEPSA, RA_ADMISSA, CTT_DESC01, RJ_DESC, RA_EMAIL, RA_SITFOLH,SUBSTR(RC_DATA,1,6) "
        cQuery += " ORDER BY SRA.RA_MAT " 
              
        TCQUERY cQuery ALIAS "TRB" NEW        
        



	  //	DbSelectArea("TRB")
	//	DbGoTop()                     
		
		
		DbSelectArea("TRB")
		DbGoTop()  		
		Do While !Eof("TRB")     
		        	 
/*			 	If ! TRB->RA_SITFOLH $ MV_PAR07 
			 		DbSelectArea("TRB")
			 		DbSkip()
			 	EndIf*/
		
		
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbSeek("01"+TRB->RA_FILIAL)
				
				nProvent := 0		
				nDescont := 0
		        nBase    := 0
				_xto:= ""
	//			_xmail1:= _EMAIL   //PEGA DO GET DA PERGUTA
				_xmail1:= TRB->RA_EMAIL   //PEGA DO GET DA PERGUTA				
		  //		_xnumped:= cPEDIDO  //PEGA O NUMERO DO PEDIDO BLUE CYCLE
		
		  //      _cStatus := TRB->ZM_DESC
		
		
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
				cMensagem += '<td width="406" height="58" align="center" valign="middle" ><span class="verdana140FFFFFFt"><font size ="2"><IMG SRC="https://static.wixstatic.com/media/410f9c_5a170ac32e46406bab5b5644b5c4de13.png/v1/fill/w_198,h_50,al_c,usm_0.66_1.00_0.01/410f9c_5a170ac32e46406bab5b5644b5c4de13.png" ALT="?" BORDER=0>DEMONSTRATIVO DE PAGAMENTO - Mes: '+SUBSTR(TRB->RC_DATA,5,2)+'/'+SUBSTR(TRB->RC_DATA,1,4)+'</span></td></tr></table></div>'
				
				cMensagem += '<div id="ldheTable2" style="position: absolute; left: 71px; top: 77px;">				       '
				
				cMensagem += '<table id="Table2" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid">			       '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+SM0->M0_NOMECOM+'</td> </tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+SM0->M0_ENDCOB+'</td></tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CIDADE: '+SM0->M0_CIDCOB+' - ESTADO: '+SM0->M0_ESTCOB+'</td></tr>  '
				cMensagem += '<tr>												       '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CNPJ: '+SM0->M0_CGC+'</td></tr> '
				cMensagem += '</table></div>											  '
				
				cMensagem += '<div id="ldheTable3" style=" position: absolute; left: 71px; top: 168px;">				    '
//style="border:1px #6FC solid				
				cMensagem += '<table id="Table3" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">			      '
				cMensagem += '<tr>												      '
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+TRB->RA_NOME+' - ' +TRB->RA_MAT+'</td></tr> '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">FUNÇÃO: '+TRB->RA_CODFUNC+' - '+TRB->RJ_DESC+'</td></tr>	 '
				cMensagem += '<tr>													'
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">C. CUSTOS:: '+TRB->RA_CC +' - '+TRB->CTT_DESC01+'</td></tr>  '
				cMensagem += '<tr>												       '                                                                  
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">BCO/CONTA: '+TRB->RA_BCDEPSA + ' / '+TRB->RA_CTDEPSA+'   DT. ADMISS.: '+AllTrim(DToC(SToD(TRB->RA_ADMISSA)))+'</td></tr>'
				//cMensagem += '<tr>												       '                                                                  
				//cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">INFORMAMOS QUE O CREDITO DE SALARIO REFERENTE A FEV/2017 SERA FEITO EM 24/02, DEVIDO AO EXPEDIENTE BANCARIO DURANTE</td></tr>'				
				//cMensagem += '<tr>	
			    //cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">O CARNAVAL. TENHA UM BOM CARNAVAL E DIVIRTA-SE.</td></tr>'				
				//cMensagem += '<tr>	
				//cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CREDITO DE SALARIO SERA FEITO EM 29/12/16.</td></tr>'				
				cMensagem += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1"> ' +ALLTRIM(MV_PAR09)+'</td></tr>'
				cMensagem += '</table></div> '	
				

				
//				cMensagem += '<div id="ldheTable4" style=" border:1px #09C solid " position: relative; left: 71px; top: 264px;">					      ' 
				cMensagem += '<div id="ldheTable4" style=" position: absolute; left: 71px; top: 264px;">					      '
//				cMensagem += '<div id="ldheTable6" style=" position: relative; left: 71px; top: 299px;">'
				cMensagem += '<table id="Table4" width="500" border="0"  cellspacing="0" cellpadding="0" style="border:1px #09C solid ">		     '
				
				
//				cMensagem += '<table id="Table6" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">'				
				//cMensagem += '<tbody>'		
				cMensagem += '<tr bgcolor="#0099CC">'
				cMensagem += '<td width="79" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">TIPO </span></td>'	       
				cMensagem += '<td width="115" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">DESCRIÇÃO</span></td> '    
				cMensagem += '<td width="124" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">REFERÊNCIA</span></td>'   
				cMensagem += '<td width="86" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">VALORES</span></td></tr>' 

                If MV_PAR08 = 4
			        cQuery2 := " SELECT RI_PD RC_PD, RI_VALOR RC_VALOR, RV_TIPOCOD, RV_DESC, RI_HORAS RC_HORAS FROM SRI010 SRC "
			        cQuery2 += " INNER JOIN SRV010 SRV ON "
			        cQuery2 += " RI_PD = RV_COD AND SRV.D_E_L_E_T_ = ' ' " 
			        cQuery2 += " WHERE SRC.D_E_L_E_T_ <> '*' AND SRC.RI_MAT = '"+TRB->RA_MAT+"' AND SRC.RI_FILIAL = '"+TRB->RA_FILIAL+"' AND RV_TIPOCOD <> '3'" 		                           
			        cQuery2 += " ORDER BY SRV.RV_TIPOCOD, SRC.RI_PD "
			        
				Else
				
			        cQuery2 := " SELECT * FROM SRC010 SRC "
			        cQuery2 += " INNER JOIN SRV010 SRV ON "
			        cQuery2 += " RC_PD = RV_COD AND SRV.D_E_L_E_T_ = ' ' " 
			        cQuery2 += " WHERE SRC.D_E_L_E_T_ <> '*' AND SRC.RC_MAT = '"+TRB->RA_MAT+"' AND SRC.RC_FILIAL = '"+TRB->RA_FILIAL+"' AND (RV_TIPOCOD <> '3' OR RV_COD = '711')" 
			  
			        If MV_PAR08 = 1 
			        	cQuery2 += " AND SRV.RV_CODFOL IN ('0006','0008','0009','0012') "
			        ElseIf MV_PAR08 = 3
			        	cQuery2 += " AND SRV.RV_CODFOL IN ('0022','0108','0109') "
			        ElseIf MV_PAR08 = 5                                         
			        	cQuery2 += " AND SRV.RV_COD IN ('122','146','147','158','159','188','491','495','461','207','244','447','491','488','121') "      
			        	 //      	//'120',, '125' '121, 126 125 488               
			        ElseIf MV_PAR08 = 2
			        	cQuery2 += " AND SRV.RV_COD NOT IN ('122','146','147','158','159','188','495','461','207','244','404','447','120','125','121','126','488','491') "
			        	//'120',, '125' '121, 126 125 488
			        EndIf
			        

			         
			        
			        cQuery2 += " ORDER BY SRV.RV_TIPOCOD, SRC.RC_PD "
			    EndIf	        
		        	
		        //cQuery2 += " ORDER BY SRV.RV_TIPOCOD, SRC.RC_PD "
		               
		        TCQUERY cQuery2 ALIAS "TRB2" NEW        
		        
		
		        xCont := 264
		
				DbSelectArea("TRB2")
				DbGoTop()  		
				Do While !Eof("TRB2")             
				    
					If TRB2->RV_TIPOCOD = '1'
						nProvent := nProvent + TRB2->RC_VALOR 
						cTpVerba := "PROVENTO"
					Elseif TRB2->RV_TIPOCOD = '2'
						nDescont := nDescont + TRB2->RC_VALOR
						cTpVerba := "DESCONTO"  
					ElseIf  TRB2->RV_TIPOCOD = '3'
						nBase := nBase + TRB2->RC_VALOR
						cTpVerba := "BASE"  						
					Endif                                           
					
					
					cMensagem += '<tr>													    '  		
					cMensagem += '<td width="79" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+cTpVerba+'</span></td>		    '
					cMensagem += '<td width="115" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+TRB2->RV_DESC+'</span></td>	    '
					cMensagem += '<td width="124" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+If(TRB2->RC_HORAS <> 0,Transform(TRB2->RC_HORAS,"@! 9999.99"),"")+'</span></td>	    '
					cMensagem += '<td width="86" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(TRB2->RC_VALOR,"@e 999,999,999.99")+'</span></td></tr>'
				    xCont := xCont +18
				DbSkip() 
		  
							
				EndDo
				//DbSelectArea("TRB2")
				//DbGoTop()		
		                   
				xCont := xCont + 3
		        DbCloseArea("TRB2")

				//cMensagem += '</tbody>'
				cMensagem += '</table></div>'
				
		        //Alert(cValtoChar(xCont))
		
				cMensagem += '<div id="ldheTable6" style=" position: absolute; left: 71px; top: '+cValtoChar(xCont)+'px;">'
				
				cMensagem += '<table id="Table6" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">'
				
				cMensagem += '<tr>									 '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">TOTAL BRUTO: </span></td>'
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(nProvent,"@e 999,999,999.99")+'</span></td></tr>	     '
				cMensagem += '<tr>													      '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">TOTAL DE DESCONTOS: </span></td>'
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(nDescont,"@e 999,999,999.99")+'</span></td></tr>		    '
				cMensagem += '<tr>														     '
				cMensagem += '<td width="300" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">LIQUIDO A RECEBER: </span></td>    '
				cMensagem += '<td width="105" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+Transform(nProvent-nDescont,"@e 999,999,999.99")+'</span></td></tr>'
				//cMensagem += '</tbody>'
				cMensagem += '</table></div>'
		  		cMensagem += '</body>'
				cMensagem += '</html> '	
				
			
		
		
				cBody := cMensagem
				cBCC:= ""
				xLocal:= "\system\RECIBOS\"
		        //xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
				arqu:= "RECIBO_"+AllTrim(TRB->RA_MAT)+".html"
				//arqu:="pedido_.html"
				MemoWrite(xLocal+arqu,cMensagem)
				cFrom := 'rh@bluecycle.com.br'  //conta de email para envio
				cTos:= _xmail1
		      //  cBCC:= GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3")+TRB->C5_VEND1,1,"")    // email de copia para vendedor - copia oculta
				cSubject := 'DEMONSTRATIVO DE PAGAMENTO' // +  _xnumped
				cAttachment := ''+xLocal+arqu     //atacha a imagem antes do pedido 
				xmen:= cMensagem
				CONNECT SMTP SERVER GetMv("MV_RELSERV") ACCOUNT GetMv("MV_RELACNT") PASSWORD GetMv("MV_RELPSW") RESULT lOk
				// o comando CONNECT conecta ao servidor smtp
				// atraves da conta contida em cAccount
				// repare na senha, eh como se voce utilizasse o Outlook Express
				
				If lOk    // teste se a conexao com o servidor smtp teve sucesso
					If GetMV('MV_RELAUTH')
						Mailauth(GetMv("MV_RELACNT"),GetMv("MV_RELPSW"))
					EndIf
					If cAttachment == ""
						SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen RESULT lEnv
					Else
						SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen ATTACHMENT cAttachment RESULT lEnv
					Endif
					// o comando sendmail envia a mensagem pela conta cAccount,
					// utilizando a lista de destinatarios em cTos
					// com a mensagem contida em cMensagem
					
/*					If ! (lEnv)  // testa se a mensagem foi enviada com sucesso
						lRet := .F.
		  		        MsgAlert("Ocorreu uma falha no envio do email para:  "+cTos)
		            ELSE
		   		        MsgAlert("Seu email foi enviado com sucesso para:  "+cTos)
		 			Endif*/
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
				Else
					lRet := .F.
		 		    MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom+" EMAIL DE ENVIO: "+_xMail1)
				Endif 
		//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL
		
			//oDlg:End()   //FECHA A JANELA DE PERGUNTAS		
		DbSelectArea("TRB")
		DbSkip() 
  
					
		EndDo
	//	DbSelectArea("TRB")
	//	DbGoTop("TRB")		
		MsgAlert("E-mails enviados!")
		DbCloseArea("TRB")
		DbCloseArea("TRB2")
		 	

Return lRet

