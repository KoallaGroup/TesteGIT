#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php?wsdl&sigla=blue&servicekeywsdl=4f37592dde24496a11a7fd479bdaf8b1
Gerado em        11/30/16 13:34:06
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RRLIMHM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSHelpDeskService
------------------------------------------------------------------------------- */

WSCLIENT WSHelpDeskService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD obter
	WSMETHOD obterLista
	WSMETHOD obterFromSql

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSobterrequest           AS HelpDeskService_ObterRequest
	WSDATA   oWSobterreturn            AS HelpDeskService_ObterResult
	WSDATA   oWSobterListarequest      AS HelpDeskService_ObterListaRequest
	WSDATA   oWSobterListareturn       AS HelpDeskService_ObterListaResult
	WSDATA   oWSobterFromSqlrequest    AS HelpDeskService_ObterFromSqlRequest
	WSDATA   oWSobterFromSqlreturn     AS HelpDeskService_ObterFromSqlResult

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSHelpDeskService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150908] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSHelpDeskService
	::oWSobterrequest    := HelpDeskService_OBTERREQUEST():New()
	::oWSobterreturn     := HelpDeskService_OBTERRESULT():New()
	::oWSobterListarequest := HelpDeskService_OBTERLISTAREQUEST():New()
	::oWSobterListareturn := HelpDeskService_OBTERLISTARESULT():New()
	::oWSobterFromSqlrequest := HelpDeskService_OBTERFROMSQLREQUEST():New()
	::oWSobterFromSqlreturn := HelpDeskService_OBTERFROMSQLRESULT():New()
Return

WSMETHOD RESET WSCLIENT WSHelpDeskService
	::oWSobterrequest    := NIL 
	::oWSobterreturn     := NIL 
	::oWSobterListarequest := NIL 
	::oWSobterListareturn := NIL 
	::oWSobterFromSqlrequest := NIL 
	::oWSobterFromSqlreturn := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSHelpDeskService
Local oClone := WSHelpDeskService():New()
	oClone:_URL          := ::_URL 
	oClone:oWSobterrequest :=  IIF(::oWSobterrequest = NIL , NIL ,::oWSobterrequest:Clone() )
	oClone:oWSobterreturn :=  IIF(::oWSobterreturn = NIL , NIL ,::oWSobterreturn:Clone() )
	oClone:oWSobterListarequest :=  IIF(::oWSobterListarequest = NIL , NIL ,::oWSobterListarequest:Clone() )
	oClone:oWSobterListareturn :=  IIF(::oWSobterListareturn = NIL , NIL ,::oWSobterListareturn:Clone() )
	oClone:oWSobterFromSqlrequest :=  IIF(::oWSobterFromSqlrequest = NIL , NIL ,::oWSobterFromSqlrequest:Clone() )
	oClone:oWSobterFromSqlreturn :=  IIF(::oWSobterFromSqlreturn = NIL , NIL ,::oWSobterFromSqlreturn:Clone() )
Return oClone

// WSDL Method obter of Service WSHelpDeskService

WSMETHOD obter WSSEND oWSobterrequest WSRECEIVE oWSobterreturn WSCLIENT WSHelpDeskService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obter xmlns:q1="http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php">'
cSoap += WSSoapValue("request", ::oWSobterrequest, oWSobterrequest , "ObterRequest", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obter>"

oXmlRet := SvcSoapCall(	Self,cSoap,;                                                       
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php#obter",; 
	"RPCX","http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php",,,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php")

::Init()
::oWSobterreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","ObterResult",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Method obterLista of Service WSHelpDeskService

WSMETHOD obterLista WSSEND oWSobterListarequest WSRECEIVE oWSobterListareturn WSCLIENT WSHelpDeskService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterLista xmlns:q1="http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php">'
cSoap += WSSoapValue("request", ::oWSobterListarequest, oWSobterListarequest , "ObterListaRequest", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterLista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php#obterlista",; 
	"RPCX","http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php",,,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php")

::Init()
::oWSobterListareturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","ObterListaResult",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterFromSql of Service WSHelpDeskService

WSMETHOD obterFromSql WSSEND oWSobterFromSqlrequest WSRECEIVE oWSobterFromSqlreturn WSCLIENT WSHelpDeskService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterFromSql xmlns:q1="http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php">'
cSoap += WSSoapValue("request", ::oWSobterFromSqlrequest, oWSobterFromSqlrequest , "ObterFromSqlRequest", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterFromSql>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php#obterFromSql",; 
	"RPCX","http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php",,,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/helpdesk.php")

::Init()
::oWSobterFromSqlreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","ObterFromSqlResult",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ObterRequest

WSSTRUCT HelpDeskService_ObterRequest
	WSDATA   oWSdados                  AS HelpDeskService_ObterRequestDados OPTIONAL
	WSDATA   csigla                    AS string OPTIONAL
	WSDATA   cservicekey               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterRequest
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterRequest
	Local oClone := HelpDeskService_ObterRequest():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:csigla               := ::csigla
	oClone:cservicekey          := ::cservicekey
Return oClone

WSMETHOD SOAPSEND WSCLIENT HelpDeskService_ObterRequest
	Local cSoap := ""
	cSoap += WSSoapValue("dados", ::oWSdados, ::oWSdados , "ObterRequestDados", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("sigla", ::csigla, ::csigla , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("servicekey", ::cservicekey, ::cservicekey , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterRequestDados

WSSTRUCT HelpDeskService_ObterRequestDados
	WSDATA   ncodticket                AS int OPTIONAL
	WSDATA   cincluiprivadas           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterRequestDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterRequestDados
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterRequestDados
	Local oClone := HelpDeskService_ObterRequestDados():NEW()
	oClone:ncodticket           := ::ncodticket
	oClone:cincluiprivadas      := ::cincluiprivadas
Return oClone

WSMETHOD SOAPSEND WSCLIENT HelpDeskService_ObterRequestDados
	Local cSoap := ""
	cSoap += WSSoapValue("codticket", ::ncodticket, ::ncodticket , "int", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("incluiprivadas", ::cincluiprivadas, ::cincluiprivadas , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterResult

WSSTRUCT HelpDeskService_ObterResult
	WSDATA   oWSdados                  AS HelpDeskService_ObterResultDados OPTIONAL
	WSDATA   cstatusRetorno            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterResult
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterResult
	Local oClone := HelpDeskService_ObterResult():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:cstatusRetorno       := ::cstatusRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterResult
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_DADOS","ObterResultDados",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSdados := HelpDeskService_ObterResultDados():New()
		::oWSdados:SoapRecv(oNode1)
	EndIf
	::cstatusRetorno     :=  WSAdvValue( oResponse,"_STATUSRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterListaRequest

WSSTRUCT HelpDeskService_ObterListaRequest
	WSDATA   oWSdados                  AS HelpDeskService_ObterListaRequestDados OPTIONAL
	WSDATA   csigla                    AS string OPTIONAL
	WSDATA   cservicekey               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterListaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterListaRequest
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterListaRequest
	Local oClone := HelpDeskService_ObterListaRequest():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:csigla               := ::csigla
	oClone:cservicekey          := ::cservicekey
Return oClone

WSMETHOD SOAPSEND WSCLIENT HelpDeskService_ObterListaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("dados", ::oWSdados, ::oWSdados , "ObterListaRequestDados", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("sigla", ::csigla, ::csigla , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("servicekey", ::cservicekey, ::cservicekey , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterListaResult

WSSTRUCT HelpDeskService_ObterListaResult
	WSDATA   oWSdados                  AS HelpDeskService_ArrayOfObterListaResultDados OPTIONAL
	WSDATA   cstatusRetorno            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterListaResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterListaResult
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterListaResult
	Local oClone := HelpDeskService_ObterListaResult():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:cstatusRetorno       := ::cstatusRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterListaResult
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_DADOS","ArrayOfObterListaResultDados",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSdados := HelpDeskService_ArrayOfObterListaResultDados():New()
		::oWSdados:SoapRecv(oNode1)
	EndIf
	::cstatusRetorno     :=  WSAdvValue( oResponse,"_STATUSRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterFromSqlRequest

WSSTRUCT HelpDeskService_ObterFromSqlRequest
	WSDATA   csigla                    AS string OPTIONAL
	WSDATA   cservicekey               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterFromSqlRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterFromSqlRequest
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterFromSqlRequest
	Local oClone := HelpDeskService_ObterFromSqlRequest():NEW()
	oClone:csigla               := ::csigla
	oClone:cservicekey          := ::cservicekey
Return oClone

WSMETHOD SOAPSEND WSCLIENT HelpDeskService_ObterFromSqlRequest
	Local cSoap := ""
	cSoap += WSSoapValue("sigla", ::csigla, ::csigla , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("servicekey", ::cservicekey, ::cservicekey , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterFromSqlResult

WSSTRUCT HelpDeskService_ObterFromSqlResult
	WSDATA   cteste                    AS string OPTIONAL
	WSDATA   cstatusRetorno            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterFromSqlResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterFromSqlResult
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterFromSqlResult
	Local oClone := HelpDeskService_ObterFromSqlResult():NEW()
	oClone:cteste               := ::cteste
	oClone:cstatusRetorno       := ::cstatusRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterFromSqlResult
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cteste             :=  WSAdvValue( oResponse,"_TESTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cstatusRetorno     :=  WSAdvValue( oResponse,"_STATUSRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterResultDados

WSSTRUCT HelpDeskService_ObterResultDados
	WSDATA   ncodticket                AS int OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   ndtabertura               AS int OPTIONAL
	WSDATA   nbloqueado                AS int OPTIONAL
	WSDATA   noperadorleu              AS int OPTIONAL
	WSDATA   navaliacao                AS int OPTIONAL
	WSDATA   ncodclass                 AS int OPTIONAL
	WSDATA   nhorasnaolido             AS int OPTIONAL
	WSDATA   ndtfechamento             AS int OPTIONAL
	WSDATA   ndtleituracliente         AS int OPTIONAL
	WSDATA   ndtalteracao              AS int OPTIONAL
	WSDATA   nprioridade               AS int OPTIONAL
	WSDATA   ntempoalteracao           AS int OPTIONAL
	WSDATA   ntempocriacao             AS int OPTIONAL
	WSDATA   ndtprevisao               AS int OPTIONAL
	WSDATA   nagora                    AS int OPTIONAL
	WSDATA   ntempoprevisao            AS int OPTIONAL
	WSDATA   nordemprevisao            AS int OPTIONAL
	WSDATA   ncodstatus                AS int OPTIONAL
	WSDATA   cstatus                   AS string OPTIONAL
	WSDATA   ncoddepartamento          AS int OPTIONAL
	WSDATA   ncodcategoria             AS int OPTIONAL
	WSDATA   ncodusuario               AS int OPTIONAL
	WSDATA   cusuario                  AS string OPTIONAL
	WSDATA   ncodempresa               AS int OPTIONAL
	WSDATA   cempresa                  AS string OPTIONAL
	WSDATA   ccodigooriginalempresa    AS string OPTIONAL
	WSDATA   ncodcliente               AS int OPTIONAL
	WSDATA   cnomecompleto             AS string OPTIONAL
	WSDATA   ccodigooriginalcliente    AS string OPTIONAL
	WSDATA   cclassificacao            AS string OPTIONAL
	WSDATA   ncodunidade               AS int OPTIONAL
	WSDATA   cdescricaounidade         AS string OPTIONAL
	WSDATA   cordemprevisaodtalteracao AS string OPTIONAL
	WSDATA   cdtprevisaostring         AS string OPTIONAL
	WSDATA   oWSinteracoes             AS HelpDeskService_ArrayOfObterResultDadosInteracao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterResultDados
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterResultDados
	Local oClone := HelpDeskService_ObterResultDados():NEW()
	oClone:ncodticket           := ::ncodticket
	oClone:ctitulo              := ::ctitulo
	oClone:ndtabertura          := ::ndtabertura
	oClone:nbloqueado           := ::nbloqueado
	oClone:noperadorleu         := ::noperadorleu
	oClone:navaliacao           := ::navaliacao
	oClone:ncodclass            := ::ncodclass
	oClone:nhorasnaolido        := ::nhorasnaolido
	oClone:ndtfechamento        := ::ndtfechamento
	oClone:ndtleituracliente    := ::ndtleituracliente
	oClone:ndtalteracao         := ::ndtalteracao
	oClone:nprioridade          := ::nprioridade
	oClone:ntempoalteracao      := ::ntempoalteracao
	oClone:ntempocriacao        := ::ntempocriacao
	oClone:ndtprevisao          := ::ndtprevisao
	oClone:nagora               := ::nagora
	oClone:ntempoprevisao       := ::ntempoprevisao
	oClone:nordemprevisao       := ::nordemprevisao
	oClone:ncodstatus           := ::ncodstatus
	oClone:cstatus              := ::cstatus
	oClone:ncoddepartamento     := ::ncoddepartamento
	oClone:ncodcategoria        := ::ncodcategoria
	oClone:ncodusuario          := ::ncodusuario
	oClone:cusuario             := ::cusuario
	oClone:ncodempresa          := ::ncodempresa
	oClone:cempresa             := ::cempresa
	oClone:ccodigooriginalempresa := ::ccodigooriginalempresa
	oClone:ncodcliente          := ::ncodcliente
	oClone:cnomecompleto        := ::cnomecompleto
	oClone:ccodigooriginalcliente := ::ccodigooriginalcliente
	oClone:cclassificacao       := ::cclassificacao
	oClone:ncodunidade          := ::ncodunidade
	oClone:cdescricaounidade    := ::cdescricaounidade
	oClone:cordemprevisaodtalteracao := ::cordemprevisaodtalteracao
	oClone:cdtprevisaostring    := ::cdtprevisaostring
	oClone:oWSinteracoes        := IIF(::oWSinteracoes = NIL , NIL , ::oWSinteracoes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterResultDados
	Local oNode36
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ncodticket         :=  WSAdvValue( oResponse,"_CODTICKET","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ctitulo            :=  WSAdvValue( oResponse,"_TITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ndtabertura        :=  WSAdvValue( oResponse,"_DTABERTURA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbloqueado         :=  WSAdvValue( oResponse,"_BLOQUEADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::noperadorleu       :=  WSAdvValue( oResponse,"_OPERADORLEU","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::navaliacao         :=  WSAdvValue( oResponse,"_AVALIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodclass          :=  WSAdvValue( oResponse,"_CODCLASS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nhorasnaolido      :=  WSAdvValue( oResponse,"_HORASNAOLIDO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtfechamento      :=  WSAdvValue( oResponse,"_DTFECHAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtleituracliente  :=  WSAdvValue( oResponse,"_DTLEITURACLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtalteracao       :=  WSAdvValue( oResponse,"_DTALTERACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nprioridade        :=  WSAdvValue( oResponse,"_PRIORIDADE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempoalteracao    :=  WSAdvValue( oResponse,"_TEMPOALTERACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempocriacao      :=  WSAdvValue( oResponse,"_TEMPOCRIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtprevisao        :=  WSAdvValue( oResponse,"_DTPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nagora             :=  WSAdvValue( oResponse,"_AGORA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempoprevisao     :=  WSAdvValue( oResponse,"_TEMPOPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nordemprevisao     :=  WSAdvValue( oResponse,"_ORDEMPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodstatus         :=  WSAdvValue( oResponse,"_CODSTATUS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cstatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncoddepartamento   :=  WSAdvValue( oResponse,"_CODDEPARTAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodcategoria      :=  WSAdvValue( oResponse,"_CODCATEGORIA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodusuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cusuario           :=  WSAdvValue( oResponse,"_USUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodempresa        :=  WSAdvValue( oResponse,"_CODEMPRESA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cempresa           :=  WSAdvValue( oResponse,"_EMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigooriginalempresa :=  WSAdvValue( oResponse,"_CODIGOORIGINALEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodcliente        :=  WSAdvValue( oResponse,"_CODCLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cnomecompleto      :=  WSAdvValue( oResponse,"_NOMECOMPLETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigooriginalcliente :=  WSAdvValue( oResponse,"_CODIGOORIGINALCLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cclassificacao     :=  WSAdvValue( oResponse,"_CLASSIFICACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodunidade        :=  WSAdvValue( oResponse,"_CODUNIDADE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cdescricaounidade  :=  WSAdvValue( oResponse,"_DESCRICAOUNIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cordemprevisaodtalteracao :=  WSAdvValue( oResponse,"_ORDEMPREVISAODTALTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtprevisaostring  :=  WSAdvValue( oResponse,"_DTPREVISAOSTRING","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode36 :=  WSAdvValue( oResponse,"_INTERACOES","ArrayOfObterResultDadosInteracao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode36 != NIL
		::oWSinteracoes := HelpDeskService_ArrayOfObterResultDadosInteracao():New()
		::oWSinteracoes:SoapRecv(oNode36)
	EndIf
Return

// WSDL Data Structure ObterListaRequestDados

WSSTRUCT HelpDeskService_ObterListaRequestDados
	WSDATA   cdtaberturaini            AS string OPTIONAL
	WSDATA   cdtaberturafim            AS string OPTIONAL
	WSDATA   cdtalteracaoini           AS string OPTIONAL
	WSDATA   cdtalteracaofim           AS string OPTIONAL
	WSDATA   cdtfechamentoini          AS string OPTIONAL
	WSDATA   cdtfechamentofim          AS string OPTIONAL
	WSDATA   cdtprevisaoini            AS string OPTIONAL
	WSDATA   cdtprevisaofim            AS string OPTIONAL
	WSDATA   cticketsabertos           AS string OPTIONAL
	WSDATA   cticketsnaoabertos        AS string OPTIONAL
	WSDATA   cticketslidos             AS string OPTIONAL
	WSDATA   cticketsnaolidos          AS string OPTIONAL
	WSDATA   cticketscomanexo          AS string OPTIONAL
	WSDATA   cticketssemanexo          AS string OPTIONAL
	WSDATA   cticketslidosseminteracao AS string OPTIONAL
	WSDATA   cticketslidoscominteracao AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterListaRequestDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterListaRequestDados
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterListaRequestDados
	Local oClone := HelpDeskService_ObterListaRequestDados():NEW()
	oClone:cdtaberturaini       := ::cdtaberturaini
	oClone:cdtaberturafim       := ::cdtaberturafim
	oClone:cdtalteracaoini      := ::cdtalteracaoini
	oClone:cdtalteracaofim      := ::cdtalteracaofim
	oClone:cdtfechamentoini     := ::cdtfechamentoini
	oClone:cdtfechamentofim     := ::cdtfechamentofim
	oClone:cdtprevisaoini       := ::cdtprevisaoini
	oClone:cdtprevisaofim       := ::cdtprevisaofim
	oClone:cticketsabertos      := ::cticketsabertos
	oClone:cticketsnaoabertos   := ::cticketsnaoabertos
	oClone:cticketslidos        := ::cticketslidos
	oClone:cticketsnaolidos     := ::cticketsnaolidos
	oClone:cticketscomanexo     := ::cticketscomanexo
	oClone:cticketssemanexo     := ::cticketssemanexo
	oClone:cticketslidosseminteracao := ::cticketslidosseminteracao
	oClone:cticketslidoscominteracao := ::cticketslidoscominteracao
Return oClone

WSMETHOD SOAPSEND WSCLIENT HelpDeskService_ObterListaRequestDados
	Local cSoap := ""
	cSoap += WSSoapValue("dtaberturaini", ::cdtaberturaini, ::cdtaberturaini , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtaberturafim", ::cdtaberturafim, ::cdtaberturafim , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtalteracaoini", ::cdtalteracaoini, ::cdtalteracaoini , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtalteracaofim", ::cdtalteracaofim, ::cdtalteracaofim , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtfechamentoini", ::cdtfechamentoini, ::cdtfechamentoini , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtfechamentofim", ::cdtfechamentofim, ::cdtfechamentofim , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtprevisaoini", ::cdtprevisaoini, ::cdtprevisaoini , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtprevisaofim", ::cdtprevisaofim, ::cdtprevisaofim , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsabertos", ::cticketsabertos, ::cticketsabertos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsnaoabertos", ::cticketsnaoabertos, ::cticketsnaoabertos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketslidos", ::cticketslidos, ::cticketslidos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsnaolidos", ::cticketsnaolidos, ::cticketsnaolidos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketscomanexo", ::cticketscomanexo, ::cticketscomanexo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketssemanexo", ::cticketssemanexo, ::cticketssemanexo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketslidosseminteracao", ::cticketslidosseminteracao, ::cticketslidosseminteracao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketslidoscominteracao", ::cticketslidoscominteracao, ::cticketslidoscominteracao , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ArrayOfObterListaResultDados

WSSTRUCT HelpDeskService_ArrayOfObterListaResultDados
	WSDATA   oWSObterListaResultDados  AS HelpDeskService_ObterListaResultDados OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ArrayOfObterListaResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ArrayOfObterListaResultDados
	::oWSObterListaResultDados := {} // Array Of  HelpDeskService_OBTERLISTARESULTDADOS():New()
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ArrayOfObterListaResultDados
	Local oClone := HelpDeskService_ArrayOfObterListaResultDados():NEW()
	oClone:oWSObterListaResultDados := NIL
	If ::oWSObterListaResultDados <> NIL 
		oClone:oWSObterListaResultDados := {}
		aEval( ::oWSObterListaResultDados , { |x| aadd( oClone:oWSObterListaResultDados , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ArrayOfObterListaResultDados
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterListaResultDados , HelpDeskService_ObterListaResultDados():New() )
  			::oWSObterListaResultDados[len(::oWSObterListaResultDados)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfObterResultDadosInteracao

WSSTRUCT HelpDeskService_ArrayOfObterResultDadosInteracao
	WSDATA   oWSObterResultDadosInteracao AS HelpDeskService_ObterResultDadosInteracao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracao
	::oWSObterResultDadosInteracao := {} // Array Of  HelpDeskService_OBTERRESULTDADOSINTERACAO():New()
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracao
	Local oClone := HelpDeskService_ArrayOfObterResultDadosInteracao():NEW()
	oClone:oWSObterResultDadosInteracao := NIL
	If ::oWSObterResultDadosInteracao <> NIL 
		oClone:oWSObterResultDadosInteracao := {}
		aEval( ::oWSObterResultDadosInteracao , { |x| aadd( oClone:oWSObterResultDadosInteracao , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracao
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterResultDadosInteracao , HelpDeskService_ObterResultDadosInteracao():New() )
  			::oWSObterResultDadosInteracao[len(::oWSObterResultDadosInteracao)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ObterListaResultDados

WSSTRUCT HelpDeskService_ObterListaResultDados
	WSDATA   ncodticket                AS int OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   ndtabertura               AS int OPTIONAL
	WSDATA   nbloqueado                AS int OPTIONAL
	WSDATA   noperadorleu              AS int OPTIONAL
	WSDATA   navaliacao                AS int OPTIONAL
	WSDATA   ncodclass                 AS int OPTIONAL
	WSDATA   nhorasnaolido             AS int OPTIONAL
	WSDATA   ndtfechamento             AS int OPTIONAL
	WSDATA   ndtleituracliente         AS int OPTIONAL
	WSDATA   ndtalteracao              AS int OPTIONAL
	WSDATA   nprioridade               AS int OPTIONAL
	WSDATA   ntempoalteracao           AS int OPTIONAL
	WSDATA   ntempocriacao             AS int OPTIONAL
	WSDATA   ndtprevisao               AS int OPTIONAL
	WSDATA   nagora                    AS int OPTIONAL
	WSDATA   ntempoprevisao            AS int OPTIONAL
	WSDATA   nordemprevisao            AS int OPTIONAL
	WSDATA   ncodstatus                AS int OPTIONAL
	WSDATA   cstatus                   AS string OPTIONAL
	WSDATA   ncoddepartamento          AS int OPTIONAL
	WSDATA   csetor                    AS string OPTIONAL
	WSDATA   ncodcategoria             AS int OPTIONAL
	WSDATA   ccategoria                AS string OPTIONAL
	WSDATA   ncodusuario               AS int OPTIONAL
	WSDATA   cusuario                  AS string OPTIONAL
	WSDATA   ncodempresa               AS int OPTIONAL
	WSDATA   cempresa                  AS string OPTIONAL
	WSDATA   ccodigooriginalempresa    AS string OPTIONAL
	WSDATA   ncodcliente               AS int OPTIONAL
	WSDATA   cnomecompleto             AS string OPTIONAL
	WSDATA   ccodigooriginalcliente    AS string OPTIONAL
	WSDATA   cclassificacao            AS string OPTIONAL
	WSDATA   ncodunidade               AS int OPTIONAL
	WSDATA   cdescricaounidade         AS string OPTIONAL
	WSDATA   cdtprevisaostring         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterListaResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterListaResultDados
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterListaResultDados
	Local oClone := HelpDeskService_ObterListaResultDados():NEW()
	oClone:ncodticket           := ::ncodticket
	oClone:ctitulo              := ::ctitulo
	oClone:ndtabertura          := ::ndtabertura
	oClone:nbloqueado           := ::nbloqueado
	oClone:noperadorleu         := ::noperadorleu
	oClone:navaliacao           := ::navaliacao
	oClone:ncodclass            := ::ncodclass
	oClone:nhorasnaolido        := ::nhorasnaolido
	oClone:ndtfechamento        := ::ndtfechamento
	oClone:ndtleituracliente    := ::ndtleituracliente
	oClone:ndtalteracao         := ::ndtalteracao
	oClone:nprioridade          := ::nprioridade
	oClone:ntempoalteracao      := ::ntempoalteracao
	oClone:ntempocriacao        := ::ntempocriacao
	oClone:ndtprevisao          := ::ndtprevisao
	oClone:nagora               := ::nagora
	oClone:ntempoprevisao       := ::ntempoprevisao
	oClone:nordemprevisao       := ::nordemprevisao
	oClone:ncodstatus           := ::ncodstatus
	oClone:cstatus              := ::cstatus
	oClone:ncoddepartamento     := ::ncoddepartamento
	oClone:csetor               := ::csetor
	oClone:ncodcategoria        := ::ncodcategoria
	oClone:ccategoria           := ::ccategoria
	oClone:ncodusuario          := ::ncodusuario
	oClone:cusuario             := ::cusuario
	oClone:ncodempresa          := ::ncodempresa
	oClone:cempresa             := ::cempresa
	oClone:ccodigooriginalempresa := ::ccodigooriginalempresa
	oClone:ncodcliente          := ::ncodcliente
	oClone:cnomecompleto        := ::cnomecompleto
	oClone:ccodigooriginalcliente := ::ccodigooriginalcliente
	oClone:cclassificacao       := ::cclassificacao
	oClone:ncodunidade          := ::ncodunidade
	oClone:cdescricaounidade    := ::cdescricaounidade
	oClone:cdtprevisaostring    := ::cdtprevisaostring
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterListaResultDados
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ncodticket         :=  WSAdvValue( oResponse,"_CODTICKET","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ctitulo            :=  WSAdvValue( oResponse,"_TITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ndtabertura        :=  WSAdvValue( oResponse,"_DTABERTURA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbloqueado         :=  WSAdvValue( oResponse,"_BLOQUEADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::noperadorleu       :=  WSAdvValue( oResponse,"_OPERADORLEU","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::navaliacao         :=  WSAdvValue( oResponse,"_AVALIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodclass          :=  WSAdvValue( oResponse,"_CODCLASS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nhorasnaolido      :=  WSAdvValue( oResponse,"_HORASNAOLIDO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtfechamento      :=  WSAdvValue( oResponse,"_DTFECHAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtleituracliente  :=  WSAdvValue( oResponse,"_DTLEITURACLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtalteracao       :=  WSAdvValue( oResponse,"_DTALTERACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nprioridade        :=  WSAdvValue( oResponse,"_PRIORIDADE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempoalteracao    :=  WSAdvValue( oResponse,"_TEMPOALTERACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempocriacao      :=  WSAdvValue( oResponse,"_TEMPOCRIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtprevisao        :=  WSAdvValue( oResponse,"_DTPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nagora             :=  WSAdvValue( oResponse,"_AGORA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ntempoprevisao     :=  WSAdvValue( oResponse,"_TEMPOPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nordemprevisao     :=  WSAdvValue( oResponse,"_ORDEMPREVISAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodstatus         :=  WSAdvValue( oResponse,"_CODSTATUS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cstatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncoddepartamento   :=  WSAdvValue( oResponse,"_CODDEPARTAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csetor             :=  WSAdvValue( oResponse,"_SETOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodcategoria      :=  WSAdvValue( oResponse,"_CODCATEGORIA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ccategoria         :=  WSAdvValue( oResponse,"_CATEGORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodusuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cusuario           :=  WSAdvValue( oResponse,"_USUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodempresa        :=  WSAdvValue( oResponse,"_CODEMPRESA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cempresa           :=  WSAdvValue( oResponse,"_EMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigooriginalempresa :=  WSAdvValue( oResponse,"_CODIGOORIGINALEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodcliente        :=  WSAdvValue( oResponse,"_CODCLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cnomecompleto      :=  WSAdvValue( oResponse,"_NOMECOMPLETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigooriginalcliente :=  WSAdvValue( oResponse,"_CODIGOORIGINALCLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cclassificacao     :=  WSAdvValue( oResponse,"_CLASSIFICACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodunidade        :=  WSAdvValue( oResponse,"_CODUNIDADE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cdescricaounidade  :=  WSAdvValue( oResponse,"_DESCRICAOUNIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtprevisaostring  :=  WSAdvValue( oResponse,"_DTPREVISAOSTRING","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterResultDadosInteracao

WSSTRUCT HelpDeskService_ObterResultDadosInteracao
	WSDATA   ncodticketitem            AS int OPTIONAL
	WSDATA   ncodticket                AS int OPTIONAL
	WSDATA   nprivado                  AS int OPTIONAL
	WSDATA   ndtitem                   AS int OPTIONAL
	WSDATA   ncodusuario               AS int OPTIONAL
	WSDATA   narquivoanexo             AS int OPTIONAL
	WSDATA   curl                      AS string OPTIONAL
	WSDATA   nanexodeletado            AS int OPTIONAL
	WSDATA   cnomeoperador             AS string OPTIONAL
	WSDATA   ccodigooriginalusuario    AS string OPTIONAL
	WSDATA   cnomecliente              AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   ncodform                  AS int OPTIONAL
	WSDATA   ncodcliente               AS int OPTIONAL
	WSDATA   clatitude                 AS string OPTIONAL
	WSDATA   clongitude                AS string OPTIONAL
	WSDATA   oWSarquivos               AS HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterResultDadosInteracao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterResultDadosInteracao
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterResultDadosInteracao
	Local oClone := HelpDeskService_ObterResultDadosInteracao():NEW()
	oClone:ncodticketitem       := ::ncodticketitem
	oClone:ncodticket           := ::ncodticket
	oClone:nprivado             := ::nprivado
	oClone:ndtitem              := ::ndtitem
	oClone:ncodusuario          := ::ncodusuario
	oClone:narquivoanexo        := ::narquivoanexo
	oClone:curl                 := ::curl
	oClone:nanexodeletado       := ::nanexodeletado
	oClone:cnomeoperador        := ::cnomeoperador
	oClone:ccodigooriginalusuario := ::ccodigooriginalusuario
	oClone:cnomecliente         := ::cnomecliente
	oClone:cdescricao           := ::cdescricao
	oClone:ncodform             := ::ncodform
	oClone:ncodcliente          := ::ncodcliente
	oClone:clatitude            := ::clatitude
	oClone:clongitude           := ::clongitude
	oClone:oWSarquivos          := IIF(::oWSarquivos = NIL , NIL , ::oWSarquivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterResultDadosInteracao
	Local oNode17
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ncodticketitem     :=  WSAdvValue( oResponse,"_CODTICKETITEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodticket         :=  WSAdvValue( oResponse,"_CODTICKET","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nprivado           :=  WSAdvValue( oResponse,"_PRIVADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndtitem            :=  WSAdvValue( oResponse,"_DTITEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodusuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::narquivoanexo      :=  WSAdvValue( oResponse,"_ARQUIVOANEXO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::curl               :=  WSAdvValue( oResponse,"_URL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nanexodeletado     :=  WSAdvValue( oResponse,"_ANEXODELETADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cnomeoperador      :=  WSAdvValue( oResponse,"_NOMEOPERADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigooriginalusuario :=  WSAdvValue( oResponse,"_CODIGOORIGINALUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomecliente       :=  WSAdvValue( oResponse,"_NOMECLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodform           :=  WSAdvValue( oResponse,"_CODFORM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodcliente        :=  WSAdvValue( oResponse,"_CODCLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::clatitude          :=  WSAdvValue( oResponse,"_LATITUDE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::clongitude         :=  WSAdvValue( oResponse,"_LONGITUDE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode17 :=  WSAdvValue( oResponse,"_ARQUIVOS","ArrayOfObterResultDadosInteracaoArquivo",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode17 != NIL
		::oWSarquivos := HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo():New()
		::oWSarquivos:SoapRecv(oNode17)
	EndIf
Return

// WSDL Data Structure ArrayOfObterResultDadosInteracaoArquivo

WSSTRUCT HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	WSDATA   oWSObterResultDadosInteracaoArquivo AS HelpDeskService_ObterResultDadosInteracaoArquivo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	::oWSObterResultDadosInteracaoArquivo := {} // Array Of  HelpDeskService_OBTERRESULTDADOSINTERACAOARQUIVO():New()
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	Local oClone := HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo():NEW()
	oClone:oWSObterResultDadosInteracaoArquivo := NIL
	If ::oWSObterResultDadosInteracaoArquivo <> NIL 
		oClone:oWSObterResultDadosInteracaoArquivo := {}
		aEval( ::oWSObterResultDadosInteracaoArquivo , { |x| aadd( oClone:oWSObterResultDadosInteracaoArquivo , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterResultDadosInteracaoArquivo , HelpDeskService_ObterResultDadosInteracaoArquivo():New() )
  			::oWSObterResultDadosInteracaoArquivo[len(::oWSObterResultDadosInteracaoArquivo)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ObterResultDadosInteracaoArquivo

WSSTRUCT HelpDeskService_ObterResultDadosInteracaoArquivo
	WSDATA   ncodticketitem            AS int OPTIONAL
	WSDATA   ncodsequencial            AS int OPTIONAL
	WSDATA   ncodarquivo               AS int OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   curl                      AS string OPTIONAL
	WSDATA   narquivoanexo             AS int OPTIONAL
	WSDATA   ndeletado                 AS int OPTIONAL
	WSDATA   ncodusuariodeletou        AS int OPTIONAL
	WSDATA   ndatadeletou              AS int OPTIONAL
	WSDATA   ncodticketitemdeletou     AS int OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cnomeoperadordeletou      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT HelpDeskService_ObterResultDadosInteracaoArquivo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT HelpDeskService_ObterResultDadosInteracaoArquivo
Return

WSMETHOD CLONE WSCLIENT HelpDeskService_ObterResultDadosInteracaoArquivo
	Local oClone := HelpDeskService_ObterResultDadosInteracaoArquivo():NEW()
	oClone:ncodticketitem       := ::ncodticketitem
	oClone:ncodsequencial       := ::ncodsequencial
	oClone:ncodarquivo          := ::ncodarquivo
	oClone:cnome                := ::cnome
	oClone:curl                 := ::curl
	oClone:narquivoanexo        := ::narquivoanexo
	oClone:ndeletado            := ::ndeletado
	oClone:ncodusuariodeletou   := ::ncodusuariodeletou
	oClone:ndatadeletou         := ::ndatadeletou
	oClone:ncodticketitemdeletou := ::ncodticketitemdeletou
	oClone:cdescricao           := ::cdescricao
	oClone:cnomeoperadordeletou := ::cnomeoperadordeletou
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT HelpDeskService_ObterResultDadosInteracaoArquivo
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ncodticketitem     :=  WSAdvValue( oResponse,"_CODTICKETITEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodsequencial     :=  WSAdvValue( oResponse,"_CODSEQUENCIAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodarquivo        :=  WSAdvValue( oResponse,"_CODARQUIVO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cnome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::curl               :=  WSAdvValue( oResponse,"_URL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::narquivoanexo      :=  WSAdvValue( oResponse,"_ARQUIVOANEXO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndeletado          :=  WSAdvValue( oResponse,"_DELETADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodusuariodeletou :=  WSAdvValue( oResponse,"_CODUSUARIODELETOU","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndatadeletou       :=  WSAdvValue( oResponse,"_DATADELETOU","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ncodticketitemdeletou :=  WSAdvValue( oResponse,"_CODTICKETITEMDELETOU","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomeoperadordeletou :=  WSAdvValue( oResponse,"_NOMEOPERADORDELETOU","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

