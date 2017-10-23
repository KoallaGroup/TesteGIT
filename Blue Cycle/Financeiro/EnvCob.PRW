#include "fivewin.ch"
#include "tcbrowse.ch"                    
#Include "colors.ch"                                                                               
#include "vkey.ch"
#Include "Font.ch"                                   
#include "Ap5Mail.ch"   
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'     

Static cEmpInt	:= GetJobProfString('cEmpInt', '01' ) //--> Empresa onde ocorrerá a integração
Static cFilInt	:= GetJobProfString('cFilInt', '01' ) //--> Filial onde ocorrerá a integração

/*                   
__________________________________________________________________________________________________________
Programa: EnvEmail
Autor  	: Nilza
Data 	: 28/03/16
Desc.   : Envia Email
__________________________________________________________________________________________________________
*/

User Function EnvCob()

   Private cMensagem	:= ''
   Private aLista      	:= {}                                                                                                                                         
   Private _CRLF       	:= chr(13)+chr(10)
   Private cMSG        	:= ""
   Private aFiles      	:= {}

   Private cPara 			:= "" //alltrim(TRB->A1_EMAIL)
   Private _cCC  			:= 'carolina.pedroso@bluecycle.com.br;jeane.cunha@bluecycle.com.br'  //'nilza.men@worksis.com.br'

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
	
	
	
 	cQuery := " SELECT * FROM SE1010 WHERE E1_VENCREA = CASE WHEN to_char(sysdate,'D') = '6' THEN to_char(SYSDATE+3, 'yyyymmdd') ELSE to_char(SYSDATE+1, 'yyyymmdd') END AND D_E_L_E_T_ = ' ' AND E1_TIPO = 'NF' AND E1_SALDO > 0 AND E1_CLIENTE NOT LIKE '9%' "
    TCQUERY cQuery ALIAS "TRB" NEW        
        

	
	
	DbSelectArea("TRB")
	DbGoTop()  		
	Do While !Eof("TRB")   
		
		cPara := POSICIONE("SA1",1,xFilial("SA1")+TRB->E1_CLIENTE+TRB->E1_LOJA,"A1_EMAIL")
   
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
		cMsg += '<td width="406" height="58" align="center" valign="middle" ><span class="verdana140FFFFFFt"><font size ="3">AVISO DE VENCIMENTO</span></td></tr></table></div>'
		
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
		cMsg += '<td width="406" height="22" align="left" valign="top"><span class="verdana100FFFFFFt"></span><font size="2">ATENÇÃO! O título abaixo vence no próximo dia últil, '+AllTrim(DToC(SToD(TRB->E1_VENCREA)))+'. Caso não tenha recebido o boleto, favor entrar em contato.</td></tr>'
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
		cMsg += '<td width="115" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+AllTrim(DToC(SToD(TRB->E1_EMISSAO)))+'</span></td>	    '
		cMsg += '<td width="124" height="15" align="left" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+AllTrim(DToC(SToD(TRB->E1_VENCREA))) +'</span></td>	    '
		cMsg += '<td width="86" height="15" align="right" valign="top"><span class="verdana100FFFFFFt"><font size="1">'+transform(TRB->E1_SALDO,"@E 99,999,999.99")+'</span></td></tr>'
	
	
		cMsg += '</table></div>'
	    cMsg += '<IMG SRC="https://static.wixstatic.com/media/410f9c_5a170ac32e46406bab5b5644b5c4de13.png/v1/fill/w_198,h_50,al_c,usm_0.66_1.00_0.01/410f9c_5a170ac32e46406bab5b5644b5c4de13.png" ALT="?" BORDER=0>'
//	   cMsg += '<ADDRESS><I></I></ADDRESS>'
	   cMsg += '<ADDRESS><span class="verdana100FFFFFFt"></span><font size="3"> +55 (11) 3475-5309</br></ADDRESS>'
	   cMsg += '<ADDRESS><N></N></ADDRESS>'
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
	   		TO cPara ;  
	   		CC _cCC  ;
	   		SUBJECT + 'Aviso de vencimento: ' + Trim(TRB->E1_NUM)+If(!Empty(TRB->E1_PARCELA),"-"+TRB->E1_PARCELA,"")  ;
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
              

	DbSelectArea("TRB")
	DbSkip() 
	  
				
	EndDo
	
	DbCloseArea("TRB")
	
	DbCloseArea("SM0")

Return 






User Function EnvCobJ()

Local aTables := { "SE1", "SM0", "SA1" }

If Empty( cEmpInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Aviso de  Vencimento - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

If Empty( cFilInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Aviso de  Vencimento - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

RPCSetType(3)
RpcSetEnv (cEmpInt, cFilInt, Nil, Nil, "FAT", Nil, aTables)

While !KillApp()
	U_EnvCob()
	Exit
EndDo

Return
