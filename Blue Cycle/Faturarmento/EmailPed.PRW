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

Static cEmpInt	:= GetJobProfString('cEmpInt', '01' ) //--> Empresa onde ocorrerá a integração
Static cFilInt	:= GetJobProfString('cFilInt', '01' ) //--> Filial onde ocorrerá a integração


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////CORPO DA FUNCAO
User Function EmailPed(cPedido,_EMAIL,cOrc)

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
Private xCont := 0   
Private nProvent
Private nDescont                                                                     

DEFAULT cOrc = "2"
 
//PREPARE ENVIRONMENT Empresa "01" Filial "01" Modulo "FAT" Tables "SC5","SC6","SA1","SE4","SX6"


        
/////////////////////////EXECUTAR ROTINA SOMENTE PARA PEDIDO TIPO NORMAL////////////////////////////////////////////////////

        cAlias := GetNextAlias()
  
        cQuery := " SELECT C5_NUM, A1_NOME, C5_VEND1, C5_VEND2, C5_CONDPAG, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, E4_DESCRI, A1_EMAIL, C5_FRETE "
        cQuery += " FROM "+ RetSqlName("SC5") +" SC5"
        cQuery += " INNER JOIN "+ RetSqlName("SA1") +" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " 
        cQuery += " INNER JOIN "+ RetSqlName("SE4") +" SE4 ON E4_CODIGO = C5_CONDPAG  "
        cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SE4.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND C5_NUM = '"+cPedido+"' "            
 		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)       

              
        //TCQUERY cQuery ALIAS "TRB" NEW        
        

                                                                           
		nValPed := 0
		nValIpi := 0
		nValSt  := 0
		nValDesc:= 0

	  //	DbSelectArea("TRB")
	//	DbGoTop()                     
		
		

		        	 
/*			 	If ! TRB->RA_SITFOLH $ MV_PAR07 
			 		DbSelectArea("TRB")
			 		DbSkip()
			 	EndIf*/
		
		

				
				nProvent := 0		
				nDescont := 0
		
				_xto:= ""
	//			_xmail1:= _EMAIL   //PEGA DO GET DA PERGUTA
				_xmail1:= IIF(Empty(_EMAIL), (cAlias)->A1_EMAIL, _EMAIL)  //"valdemir.carmo@bluecycle.com.br" //  //PEGA DO GET DA PERGUTA				
				_xMail2 := POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_EMAIL")+';'+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_EMAIL")+';valdemir.carmo@bluecycle.com.br'
		  //		_xnumped:= cPEDIDO  //PEGA O NUMERO DO PEDIDO BLUE CYCLE
		
		  //      _cStatus := TRB->ZM_DESC
		        
				
		
				cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
				cMensagem += '<html>'
				cMensagem += '<head> '
				
				
				  
				cMensagem += '<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
				
				  
				cMensagem += '  <title>Conf_Ped</title> '
				cMensagem += '</head>      '
				
				
				cMensagem += '<body style="margin-left: 14px; width: 300px;">'
				
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="cabe&ccedil;alho" src="https://static.wixstatic.com/media/410f9c_6e7e49587cf14cf8ba57e7a722361f4a~mv2.png/v1/fill/w_594,h_47,al_c/410f9c_6e7e49587cf14cf8ba57e7a722361f4a~mv2.png"><br> '

				cMensagem += '<br>'   				
				
				cMensagem += '<span style="font-weight: bold; font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; Ol&aacute;, '+(cAlias)->A1_NOME+',</span><br style="font-family: Arial;">'
				
				cMensagem += '<br style="font-family: Tahoma;"><font size ="1">'    
				
				cMensagem += '<table style="text-align: left; font-family: Tahoma;  height: 60px; width: 600px;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody> '

				cMensagem += '    <tr> '
				
				cMensagem += '      <td ><font size ="1">'					
				
				If cOrc <> "1"
					cMensagem += '<span style="font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; O seu pedido N&ordm; '+(cAlias)->C5_NUM+' foi recebido com sucesso! Assim que avaliado e liberado iniciaremos sua entrega.<br>'
				Endif                   
				
//				cMensagem += '&nbsp;&nbsp;&nbsp; &nbsp;e liberado,&nbsp;</span><span style="font-family: Arial;">iniciaremos sua entrega.</span><br style="font-family: Arial;">'
				
				cMensagem += '<br style="font-family: Tahoma;"><font size ="1">'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; Veja abaixo informa&ccedil;&otilde;es do seu ' + IIF(cOrc <> "1", "pedido", "or&ccedil;amento") + ':</span><br style="font-family: Arial;">'
				
				cMensagem += '<br style="font-family: Tahoma;">'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; Vendedor Interno: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_NOME")+' </span><br>'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; Vendedor Externo: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_NOME")+' </span><br>'
				
				cMensagem += '<br>'    
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="1">****' + IIF(cOrc <> "1", "PEDIDO", "OR&Ccedil;AMENTO") + ' SUJEITO À DISPONIBILIDADE DE ESTOQUE****</span><br>'
				
				cMensagem += '<br>'   				
				
							
				
				If (cAlias)->C5_CONDPAG = '001'  
				
					cMensagem += '<span style="font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; ATENÇÃO: Por se tratar de um pedido com forma de pagamento antecipada, o mesmo só será expedido após a confirmação do pagamento.</span><br>'
					
					cMensagem += '<br>'				
				EndIf      
				
				cMensagem += '  </td> '
				
				cMensagem += ' 	</tr>'          

				cMensagem += '  </tbody>'
				cMensagem += '</table>'					
				
					cMensagem += '<img style="width: 603px; height: 85px;" alt="Infped" src="https://static.wixstatic.com/media/410f9c_f4523e4b3c9f48b2b8cf65fd34abec92~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_f4523e4b3c9f48b2b8cf65fd34abec92~mv2.png"><br> '
					
					cMensagem += '<table style="text-align: left; font-family: Tahoma; height: 65px; width: 518px; margin-left: 90px;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '  <tbody>'
					
					cMensagem += '    <tr>'
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_NOME+'</td> '
					
					cMensagem += '      <td style="width: 152px;"><font size ="1">'+(cAlias)->C5_CONDPAG+'</td>'
					
					cMensagem += '    </tr>  '
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_END+'</td>  '
					
					cMensagem += '      <td style="width: 152px;"><font size ="1">'+(cAlias)->E4_DESCRI+'</td> '
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_BAIRRO+'</td> '
					
					cMensagem += '      <td style="width: 152px;"></td>'
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_MUN+' - '+(cAlias)->A1_EST+'</td> '
					                                        
					cMensagem += '      <td style="width: 152px;"></td> '
					
					cMensagem += '    </tr> '
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">CEP: '+(cAlias)->A1_CEP+'</td> '
					
					cMensagem += '      <td style="width: 152px;"></td>'
					
					cMensagem += '    </tr>'
					
					  
					cMensagem += '  </tbody> '
					cMensagem += '</table> '
					
					cMensagem += '<br>'
			                                                                                 
				cMensagem += '<img style="width: 603px; height: 85px;" alt="itemped" src="https://static.wixstatic.com/media/410f9c_980a282c1b3c4c19a6e0cf485d169439~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_980a282c1b3c4c19a6e0cf485d169439~mv2.png"><br>'				
			   //	cMensagem += '<img style="width: 603px; height: 85px;" alt="itemped" src="https://static.wixstatic.com/media/410f9c_68d1630f6277474489e9caca237930ed~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_68d1630f6277474489e9caca237930ed~mv2.png"><br>'
			
				cMensagem += '<table style="text-align: left; font-family: Tahoma;  margin-left: 90px; height: 60px; width: 451px;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody> '
				
				cQuery2 := " SELECT C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_PRUNIT,"
				cQuery2 += " B1_DESC," 
				cQuery2 += " (CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) AS VALIPI," 
				cQuery2 += " (CASE WHEN F4_ICM = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*F7_ALIQEXT ELSE 0 END) AS VALICM,"
				cQuery2 += " (CASE WHEN F7_MARGEM > 0 THEN (C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) "
				cQuery2 += " +((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM)ELSE 0 END) AS BASE_ST," 
				cQuery2 += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM))/100)*(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN (((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END))/100)*F7_ALIQEXT ELSE 0 END)" 
				cQuery2 += " ELSE 0 END) AS VALOR_ST"         
				
				cQuery2 += " FROM "+ RetSqlName("SC6") +" SC6"
				cQuery2 += " JOIN "+ RetSqlName("SB1") +" SB1 ON (SB1.B1_FILIAL = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO)" 
				cQuery2 += " JOIN "+ RetSqlName("SF4") +" SF4 ON (SF4.F4_FILIAL = ' ' AND SF4.F4_CODIGO = SC6.C6_TES)" 
				cQuery2 += " JOIN "+ RetSqlName("SA1") +" SA1 ON A1_FILIAL = ' ' AND A1_COD = C6_CLI AND A1_LOJA = C6_LOJA" 
				cQuery2 += " JOIN "+ RetSqlName("SC5") +" SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM  "
				cQuery2 += " LEFT JOIN SF7010 SF7 ON F7_FILIAL = C6_FILIAL AND F7_GRTRIB = B1_GRTRIB AND F7_GRPCLI = A1_GRPTRIB AND F7_EST = A1_EST "		        
				cQuery2 += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = '"+(cAlias)->C5_NUM+"' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*'  AND SC6.D_E_L_E_T_ = ' '"
				cQuery2 += " AND SA1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' '"
				cQuery2 += " ORDER BY SC6.C6_ITEM,SC6.C6_PRODUTO "
				
		               
		        TCQUERY cQuery2 ALIAS "TRB2" NEW        
		        
		
		
				DbSelectArea("TRB2")
				DbGoTop()  		
				Do While !Eof("TRB2")             
				    
				
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 100px;"><font size ="1">'+TRB2->C6_PRODUTO+' - '+SUBSTR(TRB2->B1_DESC,1,19)+'</td>'
					
					cMensagem += '      <td style="text-align: right; width: 15px;"><font size ="1">'+Transform(TRB2->C6_QTDVEN,"@! 99,999")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_PRUNIT,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '      <td style="text-align: right; width: 30px;"><font size ="1">'+Transform(TRB2->VALIPI,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->VALOR_ST,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_PRUNIT - TRB2->C6_PRCVEN,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_VALOR+TRB2->VALOR_ST+TRB2->VALIPI,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '    </tr>'          
					
					nValPed := nValPed + TRB2->C6_VALOR
					nValIpi := nValIpi + TRB2->VALIPI
					nValSt  := nValSt + TRB2->VALOR_ST
					nValDesc:= nValDesc + TRB2->C6_QTDVEN * (TRB2->C6_PRUNIT - TRB2->C6_PRCVEN)
					
				DbSkip() 
		  
							
				EndDo						
				
				DbCloseArea("TRB2")
				  
				cMensagem += '  </tbody>'
				cMensagem += '</table>'
				
				cMensagem += '<br>'
				
				cMensagem += '<img style="width: 600px; height: 120px;" alt="pedaprov" src="https://static.wixstatic.com/media/410f9c_6c8eb10916014c22b57d0d4f05401f16~mv2.png/v1/fill/w_584,h_160,al_c/410f9c_6c8eb10916014c22b57d0d4f05401f16~mv2.png"><br>'
				
				cMensagem += '<br> '
				
				cMensagem += '<table style="text-align: left; width: 296px; margin-left: 90px; font-family: Tahoma;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody>'
				
				cMensagem += '    <tr> '
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">VALOR DO PRODUTOS:</td> '
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValPed,"@e 999,999,999.99")+'</td> '
				
				cMensagem += '    </tr>'
				
				cMensagem += '    <tr> '
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">VALOR DO FRETE</td>  '
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform((cAlias)->C5_FRETE,"@e 999,999,999.99")+'</td>  '
				
				cMensagem += '    </tr> '
				
				cMensagem += '    <tr>'
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">VALOR DO IPI:</td>'
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValIpi,"@e 999,999,999.99")+'</td>'
				
				cMensagem += '    </tr>  '  
				
				cMensagem += '    <tr>'
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">VALOR DO ICMS ST:</td>'
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValSt,"@e 999,999,999.99")+'</td>'
				
				cMensagem += '    </tr>  '				
				
				cMensagem += '    <tr> '
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">DESCONTOS:</td> '
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValDesc,"@e 999,999,999.99")+'</td>'
				
				cMensagem += '    </tr>'
				
				cMensagem += '    <tr>'
				
				cMensagem += '      <td style="width: 150px;"><font size ="1">TOTAL:</td> '
				
				cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValPed+nValIpi+nValSt+(cAlias)->C5_FRETE,"@e 999,999,999.99")+'</td>'
				
				cMensagem += '    </tr>'
				
				  
				cMensagem += '  </tbody>'
				cMensagem += '</table>'
				
				cMensagem += '<br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-weight: bold; font-family: Arial;">&nbsp;&nbsp;&nbsp; Duvidas? 0800 940 03 03</span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial;">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial; font-weight: bold;">&nbsp;&nbsp;&nbsp; Obrigado por comprar com a Blue Cycle!</span><br>'
				
				cMensagem += '<br>'
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png/v1/fill/w_570,h_41,al_c/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png"><br>'
				
				
				cMensagem += '</body>'
				cMensagem += '</html> '

				
			
		
		
				cBody := cMensagem
				cBCC:= ""
				xLocal:= "\system\ImgPedidos\"
			        //xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
				arqu:= "itemped.png;"
				//arqu:="pedido_.html" 
				MemoWrite(xLocal+arqu,cMensagem)  
				cFrom := "vendas@bluecycle.com.br" //GetMv("MV_EMAILPE")  //conta de email para envio
				cTos:= _xmail1
		        cBCC:= _xMail2    // email de copia para vendedor - copia oculta
				cSubject := IIF(cOrc <> "1",'CONFIRMAÇÃO - RECEBIMENTO DE PEDIDO ','ORÇAMENTO N° ') + (cAlias)->C5_NUM  //cSubject := 'CONFIRMAÇÃO - RECEBIMENTO DE PEDIDO '+(cAlias)->C5_NUM // +  _xnumped
	//			AADD(cAttachment,{"\system\imgpedidos\itemped.png;"} )
	  //			AADD(cAttachment,{"\system\imgpedidos\cabecalho.png;"} )
				//cAttachment := ''+xLocal+arqu+chr(13)+chr(10)     //atacha a imagem antes do pedido 
				//cAttachment := "\system\imgpedidos\cabecalho.png;"
				cAttachment = '' //+xLocal+"infped.png" //;itemped.png;pedaprov.png;rodape.png;separacao.png
				xmen:= cMensagem
				CONNECT SMTP SERVER "smtp-relay.gmail.com:587" ACCOUNT "vendas@bluecycle.com.br" PASSWORD "SHIMANO2015" RESULT lOk
				// o comando CONNECT conecta ao servidor smtp
				// atraves da conta contida em cAccount
				// repare na senha, eh como se voce utilizasse o Outlook Express
				
				If lOk    // teste se a conexao com o servidor smtp teve sucesso
					//If GetMV('MV_RELAUTH')
						Mailauth("vendas@bluecycle.com.br","SHIMANO2015")
				   //	EndIf
					If cAttachment == ""
					   	SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen RESULT lEnv
					Else
						SEND MAIL FROM cFrom TO cTos BCC cBCC SUBJECT cSubject BODY xmen ATTACHMENT cAttachment RESULT lEnv
					Endif
					// o comando sendmail envia a mensagem pela conta cAccount,
					// utilizando a lista de destinatarios em cTos
					// com a mensagem contida em cMensagem
					
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
				Else
					lRet := .F.
		 		    //MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
				Endif 
		//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL
		
	

  
					
		//DbCloseArea("TRB")
		
		 	

Return 
           





User Function EmailApv(cPedido)

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
Private xCont := 0   
Private nProvent
Private nDescont



        
/////////////////////////EXECUTAR ROTINA SOMENTE PARA PEDIDO TIPO NORMAL////////////////////////////////////////////////////

        cAlias := GetNextAlias()
  
        cQuery := " SELECT C5_NUM, A1_NOME, C5_VEND1, C5_VEND2, C5_CONDPAG, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, E4_DESCRI, A1_EMAIL, C5_FRETE, C5_NOTA, C5_CLIENTE, C5_LOJACLI "
        cQuery += " FROM "+ RetSqlName("SC5") +" SC5"
        cQuery += " INNER JOIN "+ RetSqlName("SA1") +" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " 
        cQuery += " INNER JOIN "+ RetSqlName("SE4") +" SE4 ON E4_CODIGO = C5_CONDPAG  "
        cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SE4.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND C5_NUM = '"+cPedido+"' AND C5_TIPO = 'N' "            
        
 		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  
              

        

                                                                           
		nValPed := 0
		nValIpi := 0
		nValSt  := 0
		nValDesc:= 0

	  //	DbSelectArea("TRB")
	//	DbGoTop()                     
		
		

		        	 
/*			 	If ! TRB->RA_SITFOLH $ MV_PAR07 
			 		DbSelectArea("TRB")
			 		DbSkip()
			 	EndIf*/
		
		

				
				nProvent := 0		
				nDescont := 0
		
				_xto:= ""
	//			_xmail1:= _EMAIL   //PEGA DO GET DA PERGUTA
				_xmail1:= (cAlias)->A1_EMAIL //"valdemir.carmo@bluecycle.com.br" //TRB->RA_EMAIL   //PEGA DO GET DA PERGUTA				
				_xMail2 := POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_EMAIL")+';'+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_EMAIL")+';valdemir.carmo@bluecycle.com.br'
		  //		_xnumped:= cPEDIDO  //PEGA O NUMERO DO PEDIDO BLUE CYCLE
		
		  //      _cStatus := TRB->ZM_DESC
		
		
				cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
				cMensagem += '<html>'
				cMensagem += '<head> '
				
				
				  
				cMensagem += '<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
				
				  
				cMensagem += '  <title>Conf_Ped</title> '
				cMensagem += '</head>      '
				
				
				cMensagem += '<body style="margin-left: 14px; width: 1036px;">'
				
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="cabe&ccedil;alho" src="https://static.wixstatic.com/media/410f9c_7fe17f3f380647f68ddf9cc6be60eb2f~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_7fe17f3f380647f68ddf9cc6be60eb2f~mv2.png"><br> '
				
				cMensagem += '<br>'
				
				cMensagem += '<span style="font-weight: bold; font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Ol&aacute;, '+(cAlias)->A1_NOME+',</span><br style="font-family: Arial;">'
				
				
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'
				
			
				cMensagem += '<table style="text-align: left; font-family: Tahoma;  height: 60px; width: 600px;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody> '

				cMensagem += '    <tr> '
				
				cMensagem += '      <td><font size ="2">'				
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; O seu pedido N&ordm; '+(cAlias)->C5_NUM+'; foi aprovado e processado! Em breve você receberá notícias sobre o andamento de seu pedido.<br>'
						
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'
				
			
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Interno: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_NOME")+' </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Externo: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_NOME")+' </span><br>'
				
				cMensagem += '<br>'    
				
				cMensagem += '  </td> '
				
				cMensagem += ' 	</tr>'          

				cMensagem += '  </tbody>'
				cMensagem += '</table>'				
				

				
				cMensagem += '<img style="width: 600px; height: 120px;" alt="pedaprov" src="https://static.wixstatic.com/media/410f9c_beb3a12b660a4ad48e35a01bd2bb8c4f~mv2.png/v1/fill/w_584,h_157,al_c/410f9c_beb3a12b660a4ad48e35a01bd2bb8c4f~mv2.png"><br>'
				
				cMensagem += '<br> '
				

				
				cMensagem += '<br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-weight: bold; font-family: Arial;">&nbsp;&nbsp;&nbsp; Duvidas? 0800 940 03 03</span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial;">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial; font-weight: bold;">&nbsp;&nbsp;&nbsp; Obrigado por comprar com a Blue Cycle!</span><br>'
				
				cMensagem += '<br>'
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png/v1/fill/w_570,h_41,al_c/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png"><br>'
				
				
				cMensagem += '</body>'
				cMensagem += '</html> '

				
			
		
		
				cBody := cMensagem
				cBCC:= ""
				xLocal:= "\system\ImgPedidos\"
		        //xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
				arqu:= "itemped.png;"
				//arqu:="pedido_.html" 
				MemoWrite(xLocal+arqu,cMensagem)  
				cFrom := GetMv("MV_EMAILPE")  //conta de email para envio
				cTos:= _xmail1
		        cBCC:= _xMail2   // email de copia para vendedor - copia oculta
				cSubject := 'PEDIDO '+(cAlias)->C5_NUM+' APROVADO' // _xnumped
	//			AADD(cAttachment,{"\system\imgpedidos\itemped.png;"} )
	  //			AADD(cAttachment,{"\system\imgpedidos\cabecalho.png;"} )
				//cAttachment := ''+xLocal+arqu+chr(13)+chr(10)     //atacha a imagem antes do pedido 
				//cAttachment := "\system\imgpedidos\cabecalho.png;"
				cAttachment = '' //+xLocal+"infped.png" //;itemped.png;pedaprov.png;rodape.png;separacao.png
				xmen:= cMensagem
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
					
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
				Else
					lRet := .F.
		 		    //MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
				Endif 
		//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL
		
	

  
					
        
	   //	DbCloseArea("TRB")
	
		 	

Return 





User Function EmailSep()

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
Private xTpPrazo := ""
Private xCont := 0   
Private nProvent
Private nDescont



        
/////////////////////////EXECUTAR ROTINA SOMENTE PARA PEDIDO TIPO NORMAL////////////////////////////////////////////////////

        cAlias := GetNextAlias()
  
        cQuery := " SELECT C5_NUM, A1_NOME, C5_VEND1, C5_VEND2, C5_CONDPAG, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, E4_DESCRI, A1_EMAIL, C5_FRETE, C5__STATUS, C5_TRANSP, C5_NOTA, C5_MAILSEP, C5_MAILEXP, C5_CLIENTE, C5_LOJACLI, "
        cQuery += " A1_COD_MUN, GU7_NRCID , GUN_PRAZO, GUN_TPPRAZ  "
        cQuery += " FROM "+ RetSqlName("SC5") +" SC5"
        cQuery += " INNER JOIN "+ RetSqlName("SA1") +" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " 
        cQuery += " INNER JOIN "+ RetSqlName("SE4") +" SE4 ON E4_CODIGO = C5_CONDPAG  " 
        cQuery += " LEFT JOIN "+ RetSqlName("SA4") +" SA4 ON SA4.A4_COD = C5_TRANSP AND	SA4.D_E_L_E_T_ = ' ' "
        
		cQuery += " LEFT JOIN "+ RetSqlName("GU7") +" GU7 ON SUBSTR(GU7_NRCID,3,5) = A1_COD_MUN AND GU7_CDUF = A1_EST AND GU7.D_E_L_E_T_ = ' ' "
		cQuery += " LEFT JOIN "+ RetSqlName("GUN") +" GUN1 ON GUN_NRCIDS = GU7_NRCID AND GUN1.D_E_L_E_T_ = ' ' AND GUN_CDTRP = A4_CGC "
        
        
        cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SE4.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND C5__STATUS IN ('11','6','7','8','9') "            
        cQuery += " AND (C5_MAILSEP = ' ' OR C5_MAILEXP = ' ') AND C5_TIPO = 'N' AND C5_CLIENTE NOT LIKE '9%' "                    


		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)          
        //TCQUERY cQuery ALIAS "TRB" NEW        
        
                                                                                                                                                               

	
		//nValQry = Len(cQuery)
		
		//Alert(cValtoChar(nValQry))     
		
		
		
		DbSelectArea(cAlias)
		DbGoTop()  		
		Do While !Eof(cAlias)     		
                //Alert(TRB->C5__STATUS+' - '+TRB->C5_MAILSEP+' - '+TRB->C5_MAILEXP)
		        If (((cAlias)->C5__STATUS = "6" .Or. (cAlias)->C5__STATUS = "7" .Or. (cAlias)->C5__STATUS = "8";
		        .Or. (cAlias)->C5__STATUS = "9")  .And. (cAlias)->C5_MAILSEP = "S") .Or. ((cAlias)->C5__STATUS = "11" .And. (cAlias)->C5_MAILEXP = "S") 
		            //DbSelectArea("TRB")
					dbSkip()
					Loop
				EndIf		        
				

				nValPed := 0
				nValIpi := 0
				nValSt  := 0
				nValDesc:= 0 



		        If (cAlias)->GUN_TPPRAZ = '0' 
		        	xTpPrazo := "dias úteis"
		        ElseIf (cAlias)->GUN_TPPRAZ = '1'
		        	xTpPrazo := "dias corridos"
		        Else
		        	xTpPrazo := "horas"
		        EndIf
                                                                           

				//Alert(TRB->C5__STATUS + ' - '+TRB->C5_NUM)
				
				_xto:= ""

				_xmail1:= (cAlias)->A1_EMAIL//"valdemir.carmo@bluecycle.com.br" //TRB->RA_EMAIL   //PEGA DO GET DA PERGUTA				
				_xMail2 := POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_EMAIL")+';'+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_EMAIL")+';valdemir.carmo@bluecycle.com.br'
		
		
				cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
				cMensagem += '<html>'
				cMensagem += '<head> '
				
				
				  
				cMensagem += '<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
				
				  
				cMensagem += '  <title>Conf_Ped</title> '
				cMensagem += '</head>      '
				
				
				cMensagem += '<body style="margin-left: 14px; width: 300px;">'
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="cabe&ccedil;alho" src="https://static.wixstatic.com/media/410f9c_6e7e49587cf14cf8ba57e7a722361f4a~mv2.png/v1/fill/w_594,h_47,al_c/410f9c_6e7e49587cf14cf8ba57e7a722361f4a~mv2.png"><br> '
				
				cMensagem += '<span style="font-weight: bold; font-family: Tahoma;"><font size ="1">&nbsp;&nbsp;&nbsp; Ol&aacute;, '+(cAlias)->A1_NOME+',</span><br style="font-family: Arial;">'
				
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'

				cMensagem += '<table style="text-align: left; font-family: Tahoma;  height: 60px; width: 600px;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody> '

				cMensagem += '    <tr> '
				
				cMensagem += '      <td><font size ="2">'
					

				
				If (cAlias)->C5__STATUS <> '11'
					cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; O seu pedido N&ordm; '+(cAlias)->C5_NUM+' está em separação em nosso estoque. Após a separação ele será conferido, embalado e preparado para entrega.<br>'
				Else
				  	cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Temos ótimas notícias! Seu pedido '+(cAlias)->C5_NUM+' já está com nossa transportadora '+POSICIONE("SA4",1,xFilial("SA4")+(cAlias)->C5_TRANSP,"A4_NOME")+' e em breve será entregue no seu endereço. Nota fiscal Nº '+(cAlias)->C5_NOTA+'. <br>' 
				  	If !Empty((cAlias)->GUN_PRAZO)
				  		cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; O prazo previsto para entrega do seu pedido é '+Transform((cAlias)->GUN_PRAZO,"@! 999")+' '+xTpPrazo+'.  <br>' 
				  	EndIf	
				  	//cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; no seu endereço. Nota fiscal Nº '+TRB->C5_NOTA+' <br>'
				EndIf
						
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'
				
			
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Interno: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_NOME")+' </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Externo: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_NOME")+' </span><br>'
				
				cMensagem += '<br>'
				
                		
				cMensagem += '  </td> '
				
				cMensagem += ' 	</tr>'          

				cMensagem += '  </tbody>'
				cMensagem += '</table>'

				If (cAlias)->C5__STATUS <> '11'
					cMensagem += '<img style="width: 600px; height: 120px;" alt="pedaprov" src="https://static.wixstatic.com/media/410f9c_dffa85538e884dcc96309be9963e6ae9~mv2.png/v1/fill/w_584,h_160,al_c/410f9c_dffa85538e884dcc96309be9963e6ae9~mv2.png"><br>'
				Else
					
					cMensagem += '<img style="width: 603px; height: 85px;" alt="Infped" src="https://static.wixstatic.com/media/410f9c_f4523e4b3c9f48b2b8cf65fd34abec92~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_f4523e4b3c9f48b2b8cf65fd34abec92~mv2.png"><br> '
					
					cMensagem += '<table style="text-align: left; font-family: Tahoma; height: 65px; width: 518px; margin-left: 90px;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '  <tbody>'
					
					cMensagem += '    <tr>'
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_NOME+'</td> '
					
					cMensagem += '      <td style="width: 152px;"><font size ="1">'+(cAlias)->C5_CONDPAG+'</td>'
					
					cMensagem += '    </tr>  '
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_END+'</td>  '
					
					cMensagem += '      <td style="width: 152px;"><font size ="1">'+(cAlias)->E4_DESCRI+'</td> '
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_BAIRRO+'</td> '
					
					cMensagem += '      <td style="width: 152px;"></td>'
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">'+(cAlias)->A1_MUN+' - '+(cAlias)->A1_EST+'</td> '
					                                        
					cMensagem += '      <td style="width: 152px;"></td> '
					
					cMensagem += '    </tr> '
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 213px;"><font size ="1">CEP: '+(cAlias)->A1_CEP+'</td> '
					
					cMensagem += '      <td style="width: 152px;"></td>'
					
					cMensagem += '    </tr>'
					
					  
					cMensagem += '  </tbody> '
					cMensagem += '</table> '
					
					cMensagem += '<br>'
					
					cMensagem += '<img style="width: 603px; height: 85px;" alt="itemped" src="https://static.wixstatic.com/media/410f9c_980a282c1b3c4c19a6e0cf485d169439~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_980a282c1b3c4c19a6e0cf485d169439~mv2.png"><br>'
					
					cMensagem += '<table style="text-align: left; font-family: Tahoma;  margin-left: 90px; height: 60px; width: 451px;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '  <tbody> '
					
					cQuery2 := " SELECT C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_PRUNIT,"
					cQuery2 += " B1_DESC," 
					cQuery2 += " (CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) AS VALIPI," 
					cQuery2 += " (CASE WHEN F4_ICM = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*F7_ALIQEXT ELSE 0 END) AS VALICM,"
					cQuery2 += " (CASE WHEN F7_MARGEM > 0 THEN (C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) "
					cQuery2 += " +((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM)ELSE 0 END) AS BASE_ST," 
					cQuery2 += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM))/100)*(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN (((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI((cAlias)->C5_NUM,"1"))+") END))/100)*F7_ALIQEXT ELSE 0 END)" 
					cQuery2 += " ELSE 0 END) AS VALOR_ST"         
					
					cQuery2 += " FROM "+ RetSqlName("SC6") +" SC6"
					cQuery2 += " JOIN "+ RetSqlName("SB1") +" SB1 ON (SB1.B1_FILIAL = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO)" 
					cQuery2 += " JOIN "+ RetSqlName("SF4") +" SF4 ON (SF4.F4_FILIAL = ' ' AND SF4.F4_CODIGO = SC6.C6_TES)" 
					cQuery2 += " JOIN "+ RetSqlName("SA1") +" SA1 ON A1_FILIAL = ' ' AND A1_COD = C6_CLI AND A1_LOJA = C6_LOJA" 
					cQuery2 += " JOIN "+ RetSqlName("SC5") +" SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM"
					cQuery2 += " LEFT JOIN SF7010 SF7 ON F7_FILIAL = C6_FILIAL AND F7_GRTRIB = B1_GRTRIB AND F7_GRPCLI = A1_GRPTRIB AND F7_EST = A1_EST "		        
					cQuery2 += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = '"+(cAlias)->C5_NUM+"' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*'  AND SC6.D_E_L_E_T_ = ' '"
					cQuery2 += " AND SA1.D_E_L_E_T_ = ' '  AND SC5.D_E_L_E_T_ = ' '"
					cQuery2 += " ORDER BY SC6.C6_ITEM,SC6.C6_PRODUTO "    
					

					
			               
			        TCQUERY cQuery2 ALIAS "TRB2" NEW        
			        
			
			
					DbSelectArea("TRB2")
					DbGoTop()  		
					Do While !Eof("TRB2")             
					    
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 100px;"><font size ="1">'+TRB2->C6_PRODUTO+' - '+SUBSTR(TRB2->B1_DESC,1,19)+'</td>'
					
					cMensagem += '      <td style="text-align: right; width: 15px;"><font size ="1">'+Transform(TRB2->C6_QTDVEN,"@! 99,999")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_PRUNIT,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '      <td style="text-align: right; width: 30px;"><font size ="1">'+Transform(TRB2->VALIPI,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->VALOR_ST,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_PRUNIT - TRB2->C6_PRCVEN,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '      <td style="text-align: right; width: 33px;"><font size ="1">'+Transform(TRB2->C6_VALOR+TRB2->VALOR_ST+TRB2->VALIPI,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '    </tr>'          
						
						nValPed := nValPed + TRB2->C6_VALOR
						nValIpi := nValIpi + TRB2->VALIPI
						nValSt  := nValSt + TRB2->VALOR_ST
						nValDesc:= nValDesc + TRB2->C6_QTDVEN * (TRB2->C6_PRUNIT - TRB2->C6_PRCVEN)
							
					DbSkip() 
			  
								
					EndDo						
					
					DbCloseArea("TRB2")
					  
					cMensagem += '  </tbody>'
					cMensagem += '</table>'					
					
					
					cMensagem += ' <BR>'
					
					
					cMensagem += '<img style="width: 600px; height: 120px;" alt="pedaprov" src="https://static.wixstatic.com/media/410f9c_7b75f62372a142e3b49964230062067c~mv2.png/v1/fill/w_584,h_167,al_c/410f9c_7b75f62372a142e3b49964230062067c~mv2.png"><br>'
					
					cMensagem += '<br> '
					
					cMensagem += '<table style="text-align: left; width: 296px; margin-left: 90px; font-family: Tahoma;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '  <tbody>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">VALOR DO PRODUTOS:</td> '
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValPed,"@e 999,999,999.99")+'</td> '
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">VALOR DO FRETE</td>  '
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform((cAlias)->C5_FRETE,"@e 999,999,999.99")+'</td>  '
					
					cMensagem += '    </tr> '
					
					cMensagem += '    <tr>'
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">VALOR DO IPI:</td>'
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValIpi,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '    </tr>  '  
					
					cMensagem += '    <tr>'
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">VALOR DO ICMS ST:</td>'
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValSt,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '    </tr>  '				
					
					cMensagem += '    <tr> '
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">DESCONTOS:</td> '
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValDesc,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '    </tr>'
					
					cMensagem += '    <tr>'
					
					cMensagem += '      <td style="width: 183px;"><font size ="1">TOTAL:</td> '
					
					cMensagem += '      <td style="width: 100px; text-align: right;"><font size ="1">'+Transform(nValPed+nValIpi+nValSt+(cAlias)->C5_FRETE,"@e 999,999,999.99")+'</td>'
					
					cMensagem += '    </tr>'
					
					  
					cMensagem += '  </tbody>'
					cMensagem += '</table>'

					cMensagem += '<br>'	                                                                                                                                                                                                                      
					
					cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_292066d8dbae44d1b2a092ed144cdcc2~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_292066d8dbae44d1b2a092ed144cdcc2~mv2.png"><br>'				

					cMensagem += '<table style="text-align: left; font-family: Tahoma;  margin-left: 90px; height: 60px; width: 458px;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '  <tbody> '

					
					cQuery3 := " SELECT E1_NUM, E1_PARCELA, E1_VENCTO, E1_VALOR "
					cQuery3 += " FROM "+ RetSqlName("SE1") +" SE1"
					cQuery3 += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND SE1.E1_NUM = '"+(cAlias)->C5_NOTA+"' AND SE1.D_E_L_E_T_ <> '*' AND E1_CLIENTE = '"+(cAlias)->C5_CLIENTE+"'  AND E1_LOJA = '"+(cAlias)->C5_LOJACLI+"' "
					cQuery3 += " ORDER BY E1_PARCELA "
					
			               
			        TCQUERY cQuery3 ALIAS "TRB3" NEW        					
			        
					DbSelectArea("TRB3")
					DbGoTop()  		
					Do While !Eof("TRB3")             
					    
					
						cMensagem += '    <tr> '
						
						cMensagem += '      <td style="width: 75px;"><font size ="1">'+TRB3->E1_NUM+'</td>'
						
						cMensagem += '      <td style="text-align: right; width: 65px;"><font size ="1">'+TRB3->E1_PARCELA+'</td> '
						
						cMensagem += '      <td style="text-align: right; width: 95px;"><font size ="1">'+AllTrim(DToC(SToD(TRB3->E1_VENCTO)))+'</td>'
						
						cMensagem += '      <td style="text-align: right; width: 50px;"><font size ="1">'+Transform(TRB3->E1_VALOR,"@e 999,999,999.99")+'</td> '
						
						cMensagem += '    </tr>'          
						
					DbSelectArea("TRB3")		
					DbSkip() 
			  
								
					EndDo						
					  
					DbCloseArea("TRB3")
					
					cMensagem += '  </tbody>'
					cMensagem += '</table>'					
					
					
					cMensagem += ' <BR>'			        

					
					cMensagem += '<br>'	                                                                                                                                                                                                                      
					
					cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_29de96e33dd14931a0df33a37b743111~mv2.png/v1/fill/w_592,h_66,al_c/410f9c_29de96e33dd14931a0df33a37b743111~mv2.png"><br>'				
					
					cMensagem += '<br>'                                                                                                   
					
				   //	cMensagem += '<table style="text-align: left; width: 296px; margin-left: 15px; font-family: Tahoma;" border="0" cellpadding="0" cellspacing="0">'
					
					cMensagem += '<table style="text-align: left; width: 600px; font-family: Tahoma;" border="0" cellpadding="0" cellspacing="0">'
					cMensagem += '  <tbody>'
					cMensagem += '    <tr>'
					cMensagem += '      <td><font size ="1">Ao receber sua mercadoria &eacute; de extrema '
					cMensagem += 'import&atilde;ncia &nbsp;que confira com cautela o n&uacute;mero de'
					cMensagem += 'volumes recebidos e o n&uacute;mero de volumes em nota fiscal.<br>'
					cMensagem += 'Confira se h&aacute; alguma viola&ccedil;&atilde;o nos principais'
					cMensagem += 'pontos que fecham a caixa. N&atilde;o receba a mercadoria e n&atilde;o'
					cMensagem += 'assine o conhecimento de transporte em caso de diverg&ecirc;ncia.<br>'
					cMensagem += 'Em caso de recebimento de mercadoria com fita adesiva da'
					cMensagem += 'transportadora, fa&ccedil;a uma ressalva no verso do conhecimento de'
					cMensagem += 'transporte.<br>'
					cMensagem += '      <br>'
					cMensagem += 'Ressaltamos que os prazos para reclama&ccedil;&otilde;es s&atilde;o:<br>'
					cMensagem += '      <br>'
					cMensagem += '      <div style="margin-left: 40px;"><ul><li>AVARIAS: 3 DIAS &Uacute;TEIS;</li><br>'
					cMensagem += '<li>DIVERG&Ecirc;NCIAS OU TROCA DE ITENS: 10 DIAS &Uacute;TEIS;</li><br>'
					cMensagem += '<li>DIVERG&Ecirc;NCIAS QUANTO AO N&Uacute;MERO DE VOLUMES: FAZER RESASSALVA NO CONHECIMENTO DE TRANSPORTE NO ATO DO RECEBIMENTO.</li></ul></div>'
					cMensagem += '      </td>'
					cMensagem += '    </tr>'
					cMensagem += '  </tbody>'
					cMensagem += '</table>'					
					
				EndIf
				
				cMensagem += '<br> '
				

				
				cMensagem += '<br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-weight: bold; font-family: Arial;">&nbsp;&nbsp;&nbsp; Duvidas? 0800 940 03 03</span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial;">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial; font-weight: bold;">&nbsp;&nbsp;&nbsp; Obrigado por comprar com a Blue Cycle!</span><br>'
				
				cMensagem += '<br>'
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png/v1/fill/w_570,h_41,al_c/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png"><br>'
				
				
				cMensagem += '</body>'
				cMensagem += '</html> '

                  
		
		       
				cBody := cMensagem
				cBCC:= ""
				xLocal:= "\system\ImgPedidos\"

				arqu:= "itemped.png;"

				MemoWrite(xLocal+arqu,cMensagem)  
				cFrom := GetMV("MV_EMAILPE")  //conta de email para envio
				cTos:= _xmail1
				cBCC := _xmail2
                If (cAlias)->C5__STATUS <> '11' 
					cSubject := 'PEDIDO '+(cAlias)->C5_NUM+' EM SEPARAÇÃO' // +  _xnumped
				Else                                                       
					cSubject := 'PEDIDO '+(cAlias)->C5_NUM+' EXPEDIDO' // +  _xnumped
				EndIf
					
				
	//			AADD(cAttachment,{"\system\imgpedidos\itemped.png;"} )
	  //			AADD(cAttachment,{"\system\imgpedidos\cabecalho.png;"} )
				//cAttachment := ''+xLocal+arqu+chr(13)+chr(10)     //atacha a imagem antes do pedido 
				//cAttachment := "\system\imgpedidos\cabecalho.png;"
				cAttachment = '' //+xLocal+"infped.png" //;itemped.png;pedaprov.png;rodape.png;separacao.png
				xmen:= cMensagem
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
					
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
					
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+(cAlias)->C5_NUM)

				        RecLock("SC5",.F.)
				        If (cAlias)->C5__STATUS <> '11'
		                	SC5->C5_MAILSEP := 'S' 
		          		Else
		          			SC5->C5_MAILEXP := 'S'
		          		EndIf
		                MsUnlock("SC5")					
		            EndIf
					
				Else
					lRet := .F.
		 		    //MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
				Endif 
		//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL
		



	             
		DbSelectArea(cAlias)
		DbSkip() 
        Enddo
					


	   //	DbCloseArea("TRB")
	
		 	

Return        




User Function MAILPED

Local aTables := {"SC5","SC6","SA1","SE4","SX6"}

If Empty( cEmpInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Envio de email automatico - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

If Empty( cFilInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Envio de email automatico - Na configuracao da JOB ajustar o parametro cFilInt - Filial onde ocorrerá a integração " )
	Return
Endif

RPCSetType( 3 )
RpcSetEnv ( cEmpInt, cFilInt, Nil, Nil, "FAT", Nil, aTables )

While !KillApp()
	U_EMAILSEP( .T. )
	Exit
End

Return
			 
