#include 'rwmake.ch' 
#include 'apwebex.ch'
#include 'TOPCONN.ch'
#include 'TbiConn.ch'
#include 'TbiCode.ch'
#include 'ap5mail.ch'          
#include "Protheus.Ch"
#Include "TOtvs.ch"
                          
/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | IGENM02  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Julho/2014    |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Funcao generica para envio de e-mail										   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
| Parametros: | cPara		= Email do destinatário											   |
|			  | cAssunto  	= Assunto do email 									   			   |
|			  | cCorpo  	= Conteudo do corpo do email									   |
|			  | cAnexo  	= Caminha do arquivo anexo dentro do Roothpath					   |
|			  | cServer  	= Nome do servidor de envio de email							   |
|			  | cAccount  	= Conta utilizada no envio de email								   |
|			  | cPassword  	= Determina se o Servidor de Email necessita de Autenticação	   |
|			  | lAutentica 	= Código da tabela de produto									   |
+-------------+--------------------------------------------------------------------------------+
*/        

User Function IGENM02(cPara, cAssunto, cCorpo, cAnexo,cServer,cAccount,cPassword,lAutentica)  
Local lRet			:= .F.
Local cMensagem		:= ""

Default cServer    	:= ALLTRIM(GetMv("MV_RELSERV")) //Nome do servidor de envio de e-mail
Default cAccount   	:= ALLTRIM(GetMv("MV_RELACNT")) //Conta a ser utilizada no envio de e-mail
Default cPassword  	:= ALLTRIM(GetMv("MV_RELPSW")) 	//Senha da conta de e-mail para envio
Default lAutentica 	:= GetMv("MV_RELAUTH")        	//Determina se o Servidor de Email necessita de Autenticação
Default cAnexo		:= ""							//Anexo do e-mail

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lOk

If !lOk
   conout("Erro ao conectar serviço de e-mail")
Endif

If lAutentica
	if !MailAuth(cAccount,cPassword)
    	conout("Erro de autenticação!")
    	DISCONNECT SMTP SERVER
    Else      
    	SEND MAIL 	FROM cAccount;
                  	TO cPara;
        			SUBJECT cAssunto;
               		BODY cCorpo;
          			ATTACHMENT cAnexo;
     	RESULT lEnviado
      	If lEnviado
        	conout("E-mail enviado para conta cadastrada")
        	lRet := .T.
      	Else
        	GET MAIL ERROR cMensagem 
        	conout("Erro ao enviar: " + cMensagem)
      	Endif
	Endif
	
	DISCONNECT SMTP SERVER Result lDisconectou
	
Endif

Return lRet


/*
+------------+----------+--------+---------------------------------+-------+----------------+
| Programa:  | IGENENV2 | Autor: | Jorge H. Alves - Anadi Soluções | Data: | Fevereiro/2015 |
+------------+----------+--------+---------------------------------+-------+----------------+
| Descrição: | Rotina para enviar e-mail de acordo com os parametros recebidos              |
+-------------------------------------------------------------------------------------------+
| Parametros:| _cServer     -> Endereço servidor SMTP                                       |
|            | _cConta      -> Conta para login no servidor SMTP                            |
|            | _cPass       -> Senha da Conta SMTP                                          |
|            | _nPort       -> Porta de conexão com o servidor SMTP                         |
|            | _lAuth       -> Indica se o servidor necessita de autenticação p/ envio      |
|            | _cSubj       -> Assunto do E-mail                                            |
|            | _cMsg        -> Corpo do E-mail                                              |
|            | _cReply      -> Conta que receberá resposta caso e-mail seja respondido      |
|            | _cFrom       -> Nome/conta do remetente da mensagem                          |
|            | _cTo         -> E-mail Destinatário                                          |
|            | _cCC         -> E-mail que estarão em cópia                                  |
|            | _cBCC        -> E-mail que estarão em cópia oculta                           |
|            | _cType       -> Tipo de mensagem. Default: "text/html"                       |
|            | _cFiles      -> Arquivo(s) a ser(em) anexado(s). ***A partir do rootpath     |   
+-------------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                        |
+------------+------------------------------------------------------------------------------+
*/

User Function IGENENV2(_cServer,_cConta,_cPass,_nPort,_lAuth,_cSubj,_cMsg,_cReply,_cFrom,_cTo,_cCC,_cBCC,_cType,_cFiles)
Local _oServer, _oMsg, _nErro := nx := 0, _aLog := {0,""} 
Default _cServer := "", _cConta := "", _cPass := "",_cSubj := "", _cTo := "", _cCC := "", _cBCC := ""
Default _cMsg := "", _cReply := "", _cFrom := "", _cFiles := "", _nPort := 0, _lAuth := .f., _cType := "text/html"

//Nova instância das classes p/ conexão e envio 
_oServer := TMailManager():New()
_oMsg    := TMailMessage():New()

_oServer:Init("", _cServer, _cConta, _cPass, ,_nPort )
_oServer:SetSmtpTimeOut(120)

//Conexão com server SMTP
_nErro := _oServer:SmtpConnect()
If _nErro != 0
    _aLog := {_nErro,"Falha na conexão com o server SMTP - " + _oServer:GetErrorString(_nErro)}
    _oServer:SMTPDisconnect()
    Return _aLog
EndIf

//Autenticação com o server
If _lAuth
    _nErro := _oServer:SmtpAuth(Alltrim(_cConta),Alltrim(_cPass))    
    If _nErro != 0
        _aLog := {_nErro,"Falha na autenticação " + _oServer:GetErrorString(_nErro)}
        _oServer:SMTPDisconnect()
        Return _aLog
    EndIf
EndIf

_oMsg:Clear()
_oMsg:cFrom     := _cFrom
_oMsg:cReplyTo  := _cReply
_oMsg:cTo       := alltrim(_cTo)
_oMsg:cCc       := alltrim(_cCC)
_oMsg:cBCc      := alltrim(_cBCC)
_oMsg:cSubject  := _cSubj
_oMsg:cBody     := _cMsg
_oMsg:MsgBodyType(_cType)

//Anexos do e-mail
If ValType(_cFiles) == "C" .And. !Empty(_cFiles)

    _nErro := _oMsg:AttachFile(_cFiles)
    
    If _nErro < 0
        _aLog := {_nErro,"Erro ao anexar arquivo " + _cFiles + " - " + _oServer:GetErrorString(_nErro)}
        _oServer:SMTPDisconnect()
        Return _aLog    
    EndIf  

ElseIf ValType(_cFiles) == "A" .And. Len(_cFiles) > 0

    For nx := 1 To Len(_cFiles)
        _oMsg:AttachFile(_cFiles[nx])
        
        If _nErro < 0
            _aLog := {_nErro,"Erro ao anexar arquivo " + _cFiles[nx] + " - " + _oServer:GetErrorString(_nErro)}
            _oServer:SMTPDisconnect()
            Return _aLog    
        EndIf        
    Next
    
EndIf

//Envio do e-mail
_nErro := _oMsg:Send(_oServer)
If _nErro != 0
    
    If _nErro != 0
        _aLog := {_nErro,"Erro ao enviar e-mail " + _oServer:GetErrorString(_nErro)}
        _oServer:SMTPDisconnect()
        Return _aLog
    EndIf
    
EndIf

//Encerra conexão SMTP
_oServer:SMTPDisconnect()
Return _aLog