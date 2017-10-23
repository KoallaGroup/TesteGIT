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

User Function PEDVENDASEMAIL()
Local cFiltro:= Space(58)              

DEFINE MSDIALOG oDlg FROM 0,0 TO 210,780 PIXEL TITLE " E N V I A   O   P E D I D O   P O R   E M A I L ? " 
@ 22,15 Say OemToAnsi("EMAIL: ") Of oDlg Pixel
@ 22,36 MsGet oFiltro Var cFiltro Picture "@" of oDlg Pixel Valid (cFiltro)
@ 67,48 BUTTON oButton  PROMPT  " ENVIA "  SIZE 73,11   OF oDlg PIXEL ACTION ENVIEMAIL2(cFiltro) 
@ 67,124 BUTTON oButton2 PROMPT " CANCELA " SIZE 73,11   OF oDlg PIXEL ACTION oDlg:End() 
ACTIVATE MSDIALOG oDlg CENTERED 

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////TELA AGUARDE
Static Function ENVIEMAIL2(_EMAIL)

MsgRun("Enviando o e-mail ","Aguarde...",{|| ENVIEMAIL(_EMAIL) })

//MsgRun("Enviando o e-mail ","Aguarde...",{|| U_EMAILPED(SC5->C5_NUM, _EMAIL, IIF(FunName()<>"LMG415","2","1")) })

Return()


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////CORPO DA FUNCAO
Static Function ENVIEMAIL(_EMAIL)

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
//Private _xdescri:= ""
//Private _xPARTNUMBER:= ""

		
		If Select("TRB") > 0
			DbSelectArea("TRB")
			DbCloseArea("TRB")
		End If
 		
        cFILIAL:= SC5->C5_FILIAL 
        cPEDIDO:= SC5->C5_NUM
        

  
        cQuery := " SELECT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_TPFRETE,C5_CONDPAG,C5_MENNOTA,C5_VEND1, C5_VEND2,C5_TRANSP,C5__STATUS,C5_FRETE, " 
        cQuery += " A1_EMAIL,A1_END,A1_MUN,A1_BAIRRO,A1_EST,A1_CEP,A1_TEL,A1_NOME,A1_CGC, "
        cQuery += " C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_UM,C6_PRCVEN,C6_VALOR,C6_YCORTE, " 
        cQuery += " B1_PN,B1_DESC,B1_MARCA, "
        cQuery += " (CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) AS VALIPI, ZM_DESC, "
        cQuery += " (CASE WHEN F4_ICM = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*F7_ALIQEXT ELSE 0 END) AS VALICM,
        cQuery += " (CASE WHEN F7_MARGEM > 0 THEN (C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END) "
        cQuery += " +((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(SC5->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM)ELSE 0 END) AS BASE_ST, "
        cQuery += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(SC5->C5_NUM,"1"))+" ) END)+((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(SC5->C5_NUM,"1"))+" ) END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM))/100)*(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN (((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(SC5->C5_NUM,"1"))+" ) END))/100)*F7_ALIQEXT ELSE 0 END) "
        cQuery += " ELSE 0 END) AS VALOR_ST "       
        
        
         
        cQuery += " FROM "+retsqlname("SC5")+" SC5 " 
        cQuery += " JOIN "+retsqlname("SC6")+" SC6  ON (SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND  SC6.D_E_L_E_T_ <> '*') " 
        cQuery += " JOIN "+retsqlname("SA1")+" SA1  ON (SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ <> '*') " 
        cQuery += " JOIN "+retsqlname("SB1")+" SB1 ON (SB1.B1_COD = SC6.C6_PRODUTO) "
        cQuery += " JOIN "+retsqlname("SF4")+" SF4 ON (SF4.F4_CODIGO = SC6.C6_TES) "
        cQuery += " JOIN "+retsqlname("SZM")+" SZM ON (SZM.ZM_COD = SC5.C5__STATUS) " 
        cQuery += " LEFT JOIN "+retsqlname("SF7")+" SF7 ON F7_FILIAL = C5_FILIAL AND F7_GRTRIB = B1_GRTRIB AND F7_GRPCLI = A1_GRPTRIB AND F7_EST = A1_EST "
        
        cQuery += " WHERE SC5.C5_FILIAL = '"+cFILIAL+"' AND SC5.C5_NUM = '"+cPEDIDO+"' AND SC5.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' " 
        cQuery += " ORDER BY SC6.C6_ITEM,SC6.C6_PRODUTO "
               
        TCQUERY cQuery ALIAS "TRB" NEW        

		DbSelectArea("TRB")
		DbGoTop()
		
		_xto:= ""
		_xmail1:= _EMAIL   //PEGA DO GET DA PERGUTA
		_xnumped:= cPEDIDO  //PEGA O NUMERO DO PEDIDO BLUE CYCLE

        _cStatus := TRB->ZM_DESC

		cMensagem :='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
		cMensagem +='<html xmlns="http://www.w3.org/1999/xhtml">
		cMensagem +='<head>'
		cMensagem +='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
		cMensagem +='<title>Pedido'+AllTrim(TRB->C5_NUM)+ '</title>'
		cMensagem +='</head>'
		cMensagem +='<body>'
		cMensagem +='<hr style="color: rgb(0, 0, 0); background-color: rgb(102, 102, 102); height: 10px; width: 100%;" /><br />'
		cMensagem +='<table style="text-align: left; width: 1293px; height: 122px;" border="1" cellpadding="2" cellspacing="2">'
		cMensagem +='<tbody>'
		cMensagem +='<tr>'
		cMensagem +='<td style="text-align: center;"><img style="width: 269px; height: 109px;" alt="" src="logoblue.png" /></td>'

		cMensagem += '<td style="font-family: Arial;"><big><span style="font-weight: bold;">Prezado Cliente</span></big><br />'

		cMensagem += ' <big>Obrigado por adquirir um produto Blue Cycle.</big><br />'

		cMensagem += 'O seu pedido<b> '+AllTrim(TRB->C5_NUM)+ '</b> foi processado com sucesso. Abaixo voc&ecirc; encontrar&aacute; informa&ccedil;&otilde;es importantes sobre a sua solicita&ccedil;&atilde;o de compra.'//+Chr(13)+Chr(10)
		cMensagem += 'Caso tenha alguma d&uacute;vida por favor entre em contato com o seu vendedor Blue Cycle.</td>'
		cMensagem += '</tr>'
		cMensagem += '</tbody>'
		cMensagem += '</table>'
		cMensagem += '<p style="font-family: Arial;"><span style="font-weight: bold; align = "right" ">'				 
		cMensagem += 'STATUS PEDIDO:  '+_cStatus+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
		cMensagem += '&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
		cMensagem += '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
		cMensagem += '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
		cMensagem += '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
		cMensagem += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;</span><br />'
		cMensagem += '</p>'
		cMensagem += '<table style="text-align: left; width: 1279px; height: 202px;" border="0" cellpadding="0" cellspacing="0">'
		cMensagem += '<tbody>'
		cMensagem += '<tr>'
		cMensagem += '<td style="font-family: Arial; height: 42px;"><span style="font-weight: bold;">Cliente:</span> '+AllTrim(TRB->A1_NOME)+'</td>'
		cMensagem += '<td style="font-family: Arial; height: 42px;">Condi&ccedil;&atilde;o de Pagamento:<span style="font-weight: bold;">'+GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+TRB->C5_CONDPAG,1,"")+''   
		cMensagem += '</span></td>'
		cMensagem += '<td style="font-family: Arial; height: 42px;"><br />'
		cMensagem += 'Municipio: <span style="font-weight: bold;">'+AllTrim(TRB->A1_MUN)+'</span></td>'
		cMensagem += '</tr>'
		cMensagem += '<tr>'
		cMensagem += '<td style="font-family: Arial; height: 41px;"><span style="font-weight: bold;">N&ordm; Cliente:</span> '+AllTrim(TRB->C5_CLIENTE)+'</td>'
		cMensagem += '<td style="font-family: Arial; height: 41px;">Modalidade do Frete: <span style="font-weight: bold;">'+Iif(AllTrim(TRB->C5_TPFRETE)== 'F','FOB','CIF')+' </span></td>'
		cMensagem += '<td style="font-family: Arial; height: 41px;">Bairro: <span style="font-weight: bold;">'+AllTrim(TRB->A1_BAIRRO)+'</span></td>'
		cMensagem += '</tr>'
		cMensagem += '<tr>'
		cMensagem += '<td style="font-family: Arial; height: 42px;"><span style="font-weight: bold;">CNPJ:'+AllTrim(TRB->A1_CGC)+'</span></td>'
		cMensagem += '<td style="font-family: Arial; height: 42px;">Transportadora:<span style="font-weight: bold;"> '+GetAdvFVal("SA4","A4_NOME",xFilial("SA4")+TRB->C5_TRANSP,1,"")+'</span></td>'
		cMensagem += '<td style="font-family: Arial; height: 42px;">Estado:<span style="font-weight: bold;">'+AllTrim(TRB->A1_EST)+'</span></td>'
		cMensagem += '</tr>'
		cMensagem += '<tr>'
		cMensagem += '<td style="font-family: Arial; height: 22px;"><span style="font-weight: bold;">Pedido do Cliente</span>: '+AllTrim(TRB->C5_NUM)+'</td>
		cMensagem += '<td style="font-family: Arial; height: 22px;"><span style="font-weight: bold;"><br />'
		cMensagem += '</span>Endere&ccedil;o de Faturamento:<span style="font-weight: bold;">'+AllTrim(TRB->A1_END)+'</span></td>'
		cMensagem += '<td style="font-family: Arial; height: 22px;">CEP:<span style="font-weight: bold;"> '+AllTrim(TRB->A1_CEP)+'</span></td>'
		cMensagem += '</tr>'
		cMensagem += '<tr>'
		cMensagem += '<td style="font-family: Arial; height: 35px;">'
		cMensagem += '<p style="height: 5px;">'
		cMensagem += 'Data de Processamento: <span style="font-weight: bold;">'+AllTrim(DToC(SToD(TRB->C5_EMISSAO)))+'</span><br />'		
		cMensagem += '</p>'		
		cMensagem += '</td>'		
		cMensagem += '<td style="font-family: Arial; height: 35px;">Telefone para Contato:<span style="font-weight: bold;"> '+AllTrim(TRB->A1_TEL)+' </span></td>'	
		cMensagem += '</tr>'		
		cMensagem += '</tbody>'		
		cMensagem += '<span style="font-family: Arial;"><span style="font-weight: bold;"></span></span><br style="font-family: Arial;" />'		
		cMensagem += '<span style="font-family: Arial;"><span style="font-weight: bold;"></span><span style="font-weight: bold;"></span></span><span '		
		cMensagem += 'style="font-family: Arial;"><span style="font-weight: bold;"></span></span><span style="font-family: Arial;"><span style="font-weight: '		
		cMensagem += 'bold;"><br />'		
		cMensagem += '</span></span>'		
		cMensagem += '<table style="text-align: left; width: 1289px; height: 146px;" border="1" cellpadding="2" cellspacing="2">'    
		cMensagem += '<tbody>'		
		cMensagem += '<tr>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; width: 48px; background-color: #008ED3; color: rgb(255, 255, 255);">Item</td> '		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; width: 166px; background-color: #008ED3; color: rgb(255, 255, 255);">Produto</td>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; background-color: #008ED3; color: rgb(255, 255, 255); width: 105px;">Part Number</td>'		
		cMensagem += '<td style="background-color: #008ED3; color: rgb(255, 255, 255); width: 158px;" align="left"><span style="font-family: Arial; font-weight: bold;">Marca</span></td>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; background-color: #008ED3; color: rgb(255, 255, 255); width: 294px;">Descri&ccedil;&atilde;o</td>'		
		cMensagem += ' <td style="font-family: Arial; font-weight: bold; background-color: #008ED3; color: rgb(255, 255, 255); width: 48px;">Qtd</td>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; background-color: #008ED3; color: rgb(255, 255, 255); width: 47px;">Unidade</td>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; width: 104px; background-color: #008ED3; color: rgb(255, 255, 255);">Valor Unit&aacute;rio</td>'		
		cMensagem += '<td style="font-family: Arial; font-weight: bold; width: 83px; background-color: #008ED3; color: rgb(255, 255, 255);">Valor Total</td>'
		cMensagem += '<td style="background-color: #008ED3; color: rgb(255, 255, 255); width: 156px;"><span style="font-family: Arial; font-weight: bold;">Total c/ Impostos</span></td>'  
		cMensagem += '<td style="background-color: #008ED3; color: rgb(255, 255, 255); width: 158px;" align="left"><span style="font-family: Arial; font-weight: bold;">Status</span></td>'		
	
		Do While !Eof("TRB")
			xval := xval + ((TRB->C6_PRCVEN*TRB->C6_QTDVEN)+TRB->VALIPI+TRB->VALOR_ST)   //soma valor com impostos
			xqtd := xqtd + TRB->C6_QTDVEN
 //			_xdescri:= GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+TRB->C6_PRODUTO,1,"")
 //			_xPARTNUMBER:= GetAdvFVal("SB1","B1_PN",xFilial("SB1")+TRB->C6_PRODUTO,1,"")
 			xMARCA:= GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"ZW"+TRB->B1_MARCA,1,"")
 
			IF (TRB->C5__STATUS = "3 " .or. TRB->C5__STATUS = "2 " .or. TRB->C5__STATUS = "1 ")         //LOGICA DO CAMPO STATUS
			   xStatus:= 'PENDENTE'
			ELSE
			    IF TRB->C6_QTDVEN = 0 
			       xStatus:= 'INDISPONIVEL' 
			    ELSE
			       IF TRB->C6_YCORTE > 0 
			         xStatus:= 'PARCIAL'
			       ELSE
			         xStatus:= 'OK'
			       ENDIF
			    ENDIF
			ENDIF
			
			cMensagem +='</tr>' 
			cMensagem +='<tr>' 			
			cMensagem +='<td style="font-family: Arial; width: 48px;">'+TRB->C6_ITEM+'</td>'
			cMensagem +='<td style="font-family: Arial; width: 166px;">'+AllTrim(TRB->C6_PRODUTO)+'</td>'
			cMensagem +='<td style="font-family: Arial; height: 26px;">'+TRB->B1_PN+'</td>'          //partnumber blue cycle
			cMensagem +=' <td style="height: 26px; ">'+xMARCA+'</td>'      
			cMensagem +=' <td style="font-family: Arial; height: 26px;">'+TRB->B1_DESC+'</td>'        //DESCRICAO DO PRODUTO
			cMensagem +='<td align = "right" style="font-family: Arial; height: 26px;">'+  Transform(TRB->C6_QTDVEN,"@! 9999.99") +'</td>'
		   	cMensagem +=' <td style="font-family: Arial; height: 26px;">'+AllTrim(TRB->C6_UM)+'</td>'      
			cMensagem +=' <td align = "right" style="font-family: Arial; width: 104px;">'+ Transform(TRB->C6_PRCVEN,"@e 999,999,999.99")+'</td>'
			cMensagem +='<td align = "right"  style="font-family: Arial; width: 83px;"> '+ Transform((TRB->C6_PRCVEN*TRB->C6_QTDVEN),"@e 999,999,999.99")+'</td>'
			cMensagem +=' <td align = "right" style="font-family: Arial; height: 26px;">'+ Transform((TRB->C6_PRCVEN*TRB->C6_QTDVEN)+TRB->VALIPI+TRB->VALOR_ST,"@e 999,999,999.99")+'</td>
			cMensagem +=' <td style="height: 26px; ">'+xStatus+'</td>'      
			
			cMensagem +='</tr>'
			DbSkip() 
  
					
		End Do
		DbSelectArea("TRB")
		DbGoTop()

		cMensagem +='</tbody>'
		cMensagem +='</table>' 
		cMensagem +='<span style="font-family: Arial;"><span style="font-weight: bold;"><br />'
		cMensagem +='</span></span>'
		cMensagem +='<table style="text-align: left; width: 218px; margin-left: 1068px;" border="1" cellpadding="2" cellspacing="2">'		
		cMensagem +='<tbody>'		
		cMensagem +='<tr>'		
		cMensagem +='<td style="width: 106px;"><span style="font-family: Arial; font-weight: bold;">Total Geral</span></td>'		
		cMensagem +='<td align = "right" style="width: 92px;">&nbsp;<span style="font-weight: bold; font-family: Arial;">'+Transform(xval+TRB->C5_FRETE,"@e 999,999,999.99") +'</span></td>		
		cMensagem +='</tr>'		
		cMensagem +='</tbody>'		
		cMensagem +='</table>'		
		cMensagem +='<span style="font-family: Arial;"><span style="font-weight: bold;"></span></span><br />'		
		cMensagem +='<p><span style="font-family: Arial;">Vendedor: <span style="font-weight: bold;">'+GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+TRB->C5_VEND1,1,"")+'</span></span><br style="font-family: Arial;" />'
		cMensagem +='<span style="font-family: Arial;">Observa&ccedil;&otilde;es: <span style="font-weight: bold;">'+AllTrim(TRB->C5_MENNOTA)+'</span></span></p>'		
		cMensagem +='<p><span style="font-family: Arial;"><span style="font-weight: bold;"></span></span><span style="font-family: Arial;">Caso voc&ecirc; ' 		
		cMensagem +='n&atilde;o esteja visualizando este e-mail entre em contato: </span><br style="font-family: Arial;" />'		
		cMensagem +='<span style="font-family: Arial;">Vendedor Interno &nbsp; :<span style="font-weight: bold;">&nbsp;'+GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+TRB->C5_VEND2,1,"")+'</span><br></span><brstyle="font-family: Arial;" />' 		
		cMensagem +='<span style="font-family: Arial;">Vendedor Externo : <span style="font-weight: bold;">'+GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+TRB->C5_VEND1,1,"")+'</span></span><span style="font-family: '		
		cMensagem +='Arial;"><span style="font-weight: bold;"></span></span></p>'		
		cMensagem +='<p><span style="font-family: Arial; font-weight: bold;">***Itens sujeitos &agrave; altera&ccedil;&atilde;o por disponibilidade de '		
		cMensagem +='estoque***</span><span style="font-family: Arial;"><span style="font-weight: bold;"></span></span></p>'		
		cMensagem +='<p><span style="font-family: Arial;"><span style="font-weight: bold;"></span></span></p>'		
		cMensagem +='<hr style="color: rgb(0, 0, 0); background-color: rgb(102, 102, 102); height: 10px; width: 100%;" />'		
		cMensagem +='<p></p>'		
		cMensagem +='</body>'		
		cMensagem +='</html>'		
		
		cBCC:= ""
		xLocal:= ""
        xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
		arqu:=""
		arqu:="pedido_"+AllTrim(_xnumped)+".html"
		MemoWrite(xLocal+arqu,cMensagem)
		cFrom := GetMv("MV_EMAILPE") //'vendas@bluecycle.com.br'  //conta de email para envio
		//cFrom := 'leonardothieme@r7.com'  //conta de email para envio
		cTos:= _xmail1
        cBCC:= GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3")+TRB->C5_VEND1,1,"")    // email de copia para vendedor - copia oculta
		cSubject := 'Pedido nº  ' +  _xnumped
		cAttachment := '\system\logoblue.png; '+xLocal+arqu     //atacha a imagem antes do pedido 
		xmen:= 'Segue confirmação do processamento de seu pedido.'
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
   		        MsgAlert("Seu email foi enviado com sucesso para:  "+cTos)
 			Endif
			
			DISCONNECT SMTP SERVER;
			RESULT lFim
			
			If ! (lFim)   // testa desconexao do serv. smtp
				lRet := .F.
			Endif
		Else
			lRet := .F.
 		    MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
		Endif 
//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL

 oDlg:End()   //FECHA A JANELA DE PERGUNTAS

Return lRet

