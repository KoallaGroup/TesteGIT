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
   Private _cCC  			:= 'carolina.pedroso@bluecycle.com.br;marcio.almeida@bluecycle.com.br'  //'nilza.men@worksis.com.br'

   Private lEnviado    := .f.
   Private lEnvia  		:= .T.
   Private cAccount  	:= "cobranca@bluecycle.com.br"   //AllTrim(GetMV("MV_RELACNT"))
   Private cPass     	:= "Co102030"    //AllTrim(GetMV("MV_RELPSW"))
   Private cServer  	:= AllTrim(GetMV("MV_RELSERV"))   //"200.207.76.244" //"10.10.1.254"
   Private lRelauth 	:= Getmv("MV_RELAUTH")
   
   EnvEmail()
   
Return

Static Function EnvEmail()
   
   cMsg += '<html>' //+ _CRLF
   cMsg += '<head>' //+ _CRLF
   cMsg += '<title>Titulo em aberto: ' + Trim(TRB->E1_NUM)+ '</title>' //+ _CRLF
   cMsg += '</head>' //+ _CRLF
   cMsg += '<BODY>'

   cMsg += '<font size="2" face="Arial">Prezado cliente, ' + '</font><BR>' + _CRLF
   cMsg += '<font size="2" face="Arial">Até o momento não identificamos o pagamento da duplicata mencionada abaixo. '+ ' </font><BR>' //+ _CRLF
   cMsg += '<font size="2" face="Arial">Favor nos informar sobre o pagamento.' + '</font><BR>' + _CRLF
   cMsg += '<font size="4" face="Arial"><I>Dados do titulo:  ' +'</I></font><BR>' + _CRLF
   cMsg += '<font size="4" face="Arial">Nota fiscal: '+TRB->E1_PREFIXO+TRB->E1_NUM+If(!Empty(TRB->E1_PARCELA),"-"+TRB->E1_PARCELA,"") + '</font><BR>' //+ _CRLF
   cMsg += '<font size="4" face="Arial">Cliente:     '+TRB->E1_CLIENTE+"-"+POSICIONE("SA1",1,xFilial("SA1")+TRB->E1_CLIENTE,"A1_NOME") + '</font><BR>' //+ _CRLF
   cMsg += '<font size="4" face="Arial">Emissao:    '+transform(TRB->E1_EMISSAO,"@D") + '</font><BR>' //+ _CRLF
   cMsg += '<font size="4" face="Arial">Vencimento: '+transform(TRB->E1_VENCREA,"@E") + '</font><BR>' //+ _CRLF
   cMsg += '<font size="4" face="Arial">Valor: R$ '+transform(TRB->E1_SALDO,"@E 99,999,999.99") + '</font><BR>' //+ _CRLF0->Z0_PRVNEW,"@E 99,999,999.99")+'</font><BR>' //+ _CRLF
   cMsg += '<BR>' + _CRLF
   cMsg += '<BR>' + _CRLF

//   cMsg += '<font color="#0000FF" size="2" face="Arial">'+Substr(cUsuario,7,15)+'</font><BR>' //+ _CRLF
   cMsg += '<ADDRESS><I>Depto de cobrança</I></ADDRESS>'
   cMsg += '<ADDRESS><I>BlueCycle</I></ADDRESS>'
   cMsg += '<ADDRESS><N>Telefone: (11) 3475-5352 / 5309</N></ADDRESS>'
// cMsg += '<ADDRESS><I>Email: ' + _Email + '</I></ADDRESS>' + _CRLF
      
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BR>'
   cMsg += '</BODY>' + _CRLF
   cMsg += '</html>' + _CRLF

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
