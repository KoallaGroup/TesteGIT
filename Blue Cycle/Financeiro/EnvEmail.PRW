#include "fivewin.ch"
#include "tcbrowse.ch"                    
#Include "colors.ch"                                                                               
#include "vkey.ch"
#Include "Font.ch"                                   
#include "Ap5Mail.ch"

/*                   
__________________________________________________________________________________________________________
Programa: EnvEmail
Autor  	: Nilza
Data 	: 28/03/16
Desc.   : Envia Email
__________________________________________________________________________________________________________
*/

User Function EnvEmail()

   Private cMensagem	:= ''
   Private aLista      	:= {}                                                                                                                                         
   Private _CRLF       	:= chr(13)+chr(10)
   Private cMSG        	:= ""
   Private aFiles      	:= {}

   Private cPara 			:= alltrim(TRB->A1_EMAIL)
   Private _cCC  			:= 'carolina.pedroso@bluecycle.com.br;jeane.cunha@bluecycle.com.br'  //'nilza.men@worksis.com.br
   Private lEnviado    := .f.                                                                      
   Private lEnvia  		:= .T.
   Private cAccount  	:= "cobranca@bluecycle.com.br"   //AllTrim(GetMV("MV_RELACNT"))
   Private cPass     	:= "Co102030"    //AllTrim(GetMV("MV_RELPSW"))
   Private cServer  	:= AllTrim(GetMV("MV_RELSERV"))   //"200.207.76.244" //"10.10.1.254"
   Private lRelauth 	:= Getmv("MV_RELAUTH")
   
   EnvEmail()
   
Return

Static Function EnvEmail()     



	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek("01"+"01")
   
	cMsg := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">				  '
	cMsg += '<html>											    '
	cMsg += '<head>											      '
	cMsg += '<title></title>										      '
	
	cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=Windows-1252">		     '
	
	cMsg += '<meta http-equiv="Content-Style-Type" content="text/css">						'
	cMsg += '<meta name="GENERATOR" content="Dynamic HTML Editor v.6.8 - http://www.hexagora.com">		 '
	cMsg += '<link rel="stylesheet" type="text/css" href="preview.css">					'
	
	cMsg += '<script language="javascript" type="text/javascript" src="dhwe6x.min.js"></script>	       '
	cMsg += '<script language="javascript" type="text/javascript">					       '
	
	
	
	cMsg += '</script>											      '
	cMsg += '</head>											      '
	cMsg += '<body text="#000000" bgcolor="#FFFFFF" link="#0000FF" alink="#FF0000" vlink="#800080">	      '
	
	cMsg += '<div id="ldheTable1" style="position: absolute; left: 71px; top: 20px;"> '
	
	cMsg += '<table id="Table1" width="500" border="0" cellspacing="0" cellpadding="0">'
	cMsg += '<tr>'
	cMsg += '<td width="406" height="58" align="center" valign="middle" ><span class="verdana140FFFFFFt"><font size ="3"><IMG SRC="https://static.wixstatic.com/media/410f9c_5a170ac32e46406bab5b5644b5c4de13.png/v1/fill/w_198,h_50,al_c,usm_0.66_1.00_0.01/410f9c_5a170ac32e46406bab5b5644b5c4de13.png" ALT="?" BORDER=0>AVISO DE COBRANÇA</span></td></tr></table></div>'
	
	cMsg += '<div id="ldheTable2" style="position: absolute; left: 71px; top: 77px;">				       '
	
	cMsg += '<table id="Table2" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid">			       '
	cMsg += '<tr>													'
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+SM0->M0_NOMECOM+'</td> </tr>  '
	cMsg += '<tr>												       '
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+SM0->M0_ENDCOB+'</td></tr>  '
	cMsg += '<tr>												       '
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">Cidade: '+SM0->M0_CIDCOB+' - Estado: '+SM0->M0_ESTCOB+'</td></tr>  '
	cMsg += '<tr>												       '
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CNPJ: '+SM0->M0_CGC+'</td></tr> '
	cMsg += '</table></div>											  '
	
	cMsg += '<div id="ldheTable3" style=" position: absolute; left: 71px; top: 168px;">				    '

	cMsg += '<table id="Table3" width="500" border="0" cellspacing="0" cellpadding="0" style="border:1px #09C solid ">			      '
	cMsg += '<tr>												      '
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">'+TRB->E1_CLIENTE+"-"+POSICIONE("SA1",1,xFilial("SA1")+TRB->E1_CLIENTE,"A1_NOME")+'</td></tr> '
	cMsg += '<tr>													'
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">CNPJ: '+POSICIONE("SA1",1,xFilial("SA1")+TRB->E1_CLIENTE,"A1_CGC")+'</td></tr>	 '
	cMsg += '<tr>													'
//	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">Vago: '+'XXXXXXXXXXXX' +'</td></tr>  '
	cMsg += '<tr>												       '
	cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="1">Não identificamos o pagamento da duplucata mencionada abaixo, por gentileza informar sobre o pagamento. Caso já tenha efetuado o pagamento, favor desconsiderar este e-mail.</td></tr>'
	cMsg += '</table></div>											    '
	

	cMsg += '<div id="ldheTable4" style=" position: absolute; left: 71px; top: 264px;">					      '

	cMsg += '<table id="Table4" width="500" border="0"  cellspacing="0" cellpadding="0" style="border:1px #09C solid ">		     '
	
	
	cMsg += '<tr bgcolor="#0099CC">'
	cMsg += '<td width="79" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">Documento</span></td>'	       
	cMsg += '<td width="115" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">Emissão</span></td> '    
	cMsg += '<td width="124" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">Vencimento</span></td>'   
	cMsg += '<td width="86" height="16" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1"><font color="#FFFFFF">Valor</span></td></tr>' 


	cMsg += '<tr>													    '  		
	cMsg += '<td width="79" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+TRB->E1_PREFIXO+TRB->E1_NUM+If(!Empty(TRB->E1_PARCELA),"-"+TRB->E1_PARCELA,"")+'</span></td>		    '
	cMsg += '<td width="115" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+transform(TRB->E1_EMISSAO,"@D") +'</span></td>	    '
	cMsg += '<td width="124" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+transform(TRB->E1_VENCREA,"@E") +'</span></td>	    '
	cMsg += '<td width="86" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+transform(TRB->E1_SALDO,"@E 99,999,999.99")+'</span></td></tr>'


	cMsg += '</table></div>'
  
   cMsg += '<ADDRESS><I>Depto de cobrança</I></ADDRESS>'
   cMsg += '<ADDRESS><I>BlueCycle</I></ADDRESS>'
   cMsg += '<ADDRESS><N>Telefone: (11) 3475-5309</N></ADDRESS>'
// cMsg += '<ADDRESS><I>Email: ' + _Email + '</I></ADDRESS>' + _CRLF
      
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'	

	cMsg += '</body>'
	cMsg += '</html> '

   Aadd( aLista, cPara )
 
   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass     Result lConectou

   If lConectou == .F.
      MSGALERT("Servidor de E-Mail - " + cServer + " Não Conectado ")
   Endif

	If lRelauth //.OR. .T.
		lRet := Mailauth(cAccount,cPass)
	Else
		lRet := .t.
	Endif

	If lRet
   		SEND MAIL FROM 'cobranca@bluecycle.com.br' ;  
   		TO aLista[1] ;  
   		CC _cCC  ;
   		SUBJECT + 'Titulo em aberto: ' + Trim(TRB->E1_NUM)+If(!Empty(TRB->E1_PARCELA),"-"+TRB->E1_PARCELA,"")  ;
   		BODY cMsg ;
   		RESULT lEnviado
	Endif

   	If lEnviado
      //MSGALERT("E-Mail Enviado")
   	Else
      	cMensagem := ""
     	GET MAIL ERROR cMensagem 
      	MSGALERT(cMensagem)
   	Endif

   DISCONNECT SMTP SERVER Result lDisConectou

   If !lDisConectou
      Alert("Problema ao desconectar do servidor de E-Mail - " + cServer)
   Endif

Return
