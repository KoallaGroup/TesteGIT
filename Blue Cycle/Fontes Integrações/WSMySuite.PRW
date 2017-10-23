#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php?wsdl&sigla=blue&servicekeywsdl=4f37592dde24496a11a7fd479bdaf8b1
Gerado em        01/13/17 09:20:26
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _JYRUHHS ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSFormularioHelpDeskService
------------------------------------------------------------------------------- */

WSCLIENT WSFormularioHelpDeskService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD obter
	WSMETHOD obterLista

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSobterrequest           AS FormularioHelpDeskService_ObterRequest
	WSDATA   oWSobterreturn            AS FormularioHelpDeskService_ObterResult
	WSDATA   oWSobterListarequest      AS FormularioHelpDeskService_ObterListaRequest
	WSDATA   oWSobterListareturn       AS FormularioHelpDeskService_ObterListaResult

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSFormularioHelpDeskService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150908] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSFormularioHelpDeskService
	::oWSobterrequest    := FormularioHelpDeskService_OBTERREQUEST():New()
	::oWSobterreturn     := FormularioHelpDeskService_OBTERRESULT():New()
	::oWSobterListarequest := FormularioHelpDeskService_OBTERLISTAREQUEST():New()
	::oWSobterListareturn := FormularioHelpDeskService_OBTERLISTARESULT():New()
Return

WSMETHOD RESET WSCLIENT WSFormularioHelpDeskService
	::oWSobterrequest    := NIL 
	::oWSobterreturn     := NIL 
	::oWSobterListarequest := NIL 
	::oWSobterListareturn := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSFormularioHelpDeskService
Local oClone := WSFormularioHelpDeskService():New()
	oClone:_URL          := ::_URL 
	oClone:oWSobterrequest :=  IIF(::oWSobterrequest = NIL , NIL ,::oWSobterrequest:Clone() )
	oClone:oWSobterreturn :=  IIF(::oWSobterreturn = NIL , NIL ,::oWSobterreturn:Clone() )
	oClone:oWSobterListarequest :=  IIF(::oWSobterListarequest = NIL , NIL ,::oWSobterListarequest:Clone() )
	oClone:oWSobterListareturn :=  IIF(::oWSobterListareturn = NIL , NIL ,::oWSobterListareturn:Clone() )
Return oClone

// WSDL Method obter of Service WSFormularioHelpDeskService

WSMETHOD obter WSSEND oWSobterrequest WSRECEIVE oWSobterreturn WSCLIENT WSFormularioHelpDeskService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obter xmlns:q1="http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php">'
cSoap += WSSoapValue("request", ::oWSobterrequest, oWSobterrequest , "ObterRequest", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obter>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php#obter",; 
	"RPCX","http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php",,,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php")

::Init()
::oWSobterreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","ObterResult",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterLista of Service WSFormularioHelpDeskService

WSMETHOD obterLista WSSEND oWSobterListarequest WSRECEIVE oWSobterListareturn WSCLIENT WSFormularioHelpDeskService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterLista xmlns:q1="http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php">'
cSoap += WSSoapValue("request", ::oWSobterListarequest, oWSobterListarequest , "ObterListaRequest", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterLista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php#obterLista",; 
	"RPCX","http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php",,,; 
	"http://www.mysuite2.com.br/empresas/blue/webservices/formulariohelpdesk.php")

::Init()
::oWSobterListareturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","ObterListaResult",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ObterRequest

WSSTRUCT FormularioHelpDeskService_ObterRequest
	WSDATA   oWSdados                  AS FormularioHelpDeskService_ObterRequestDados OPTIONAL
	WSDATA   oWSopcoesClientes         AS FormularioHelpDeskService_OpcoesClientes OPTIONAL
	WSDATA   oWSopcoesUsuarios         AS FormularioHelpDeskService_OpcoesUsuarios OPTIONAL
	WSDATA   csigla                    AS string OPTIONAL
	WSDATA   cservicekey               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterRequest
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterRequest
	Local oClone := FormularioHelpDeskService_ObterRequest():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:oWSopcoesClientes    := IIF(::oWSopcoesClientes = NIL , NIL , ::oWSopcoesClientes:Clone() )
	oClone:oWSopcoesUsuarios    := IIF(::oWSopcoesUsuarios = NIL , NIL , ::oWSopcoesUsuarios:Clone() )
	oClone:csigla               := ::csigla
	oClone:cservicekey          := ::cservicekey
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_ObterRequest
	Local cSoap := ""
	cSoap += WSSoapValue("dados", ::oWSdados, ::oWSdados , "ObterRequestDados", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("opcoesClientes", ::oWSopcoesClientes, ::oWSopcoesClientes , "OpcoesClientes", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("opcoesUsuarios", ::oWSopcoesUsuarios, ::oWSopcoesUsuarios , "OpcoesUsuarios", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("sigla", ::csigla, ::csigla , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("servicekey", ::cservicekey, ::cservicekey , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterRequestDados

WSSTRUCT FormularioHelpDeskService_ObterRequestDados
	WSDATA   ccodticket                AS string OPTIONAL
	WSDATA   ccoddepartamento          AS string OPTIONAL
	WSDATA   ccodcategoria             AS string OPTIONAL
	WSDATA   ccodclass                 AS string OPTIONAL
	WSDATA   ccodstatus                AS string OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cdivisor1                 AS string OPTIONAL
	WSDATA   ccodusuario               AS string OPTIONAL
	WSDATA   ccodusuarioitem           AS string OPTIONAL
	WSDATA   cprioridade               AS string OPTIONAL
	WSDATA   cavaliacao                AS string OPTIONAL
	WSDATA   cticketsabertos           AS string OPTIONAL
	WSDATA   cticketsnaolidos          AS string OPTIONAL
	WSDATA   cticketscomanexo          AS string OPTIONAL
	WSDATA   cticketslidosseminteracao AS string OPTIONAL
	WSDATA   cbloqueado                AS string OPTIONAL
	WSDATA   cdivisor2                 AS string OPTIONAL
	WSDATA   cdtabertura               AS string OPTIONAL
	WSDATA   cdtalteracao              AS string OPTIONAL
	WSDATA   cdtfechamento             AS string OPTIONAL
	WSDATA   cdtprevisao               AS string OPTIONAL
	WSDATA   cdtitem                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterRequestDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterRequestDados
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterRequestDados
	Local oClone := FormularioHelpDeskService_ObterRequestDados():NEW()
	oClone:ccodticket           := ::ccodticket
	oClone:ccoddepartamento     := ::ccoddepartamento
	oClone:ccodcategoria        := ::ccodcategoria
	oClone:ccodclass            := ::ccodclass
	oClone:ccodstatus           := ::ccodstatus
	oClone:ctitulo              := ::ctitulo
	oClone:cdescricao           := ::cdescricao
	oClone:cdivisor1            := ::cdivisor1
	oClone:ccodusuario          := ::ccodusuario
	oClone:ccodusuarioitem      := ::ccodusuarioitem
	oClone:cprioridade          := ::cprioridade
	oClone:cavaliacao           := ::cavaliacao
	oClone:cticketsabertos      := ::cticketsabertos
	oClone:cticketsnaolidos     := ::cticketsnaolidos
	oClone:cticketscomanexo     := ::cticketscomanexo
	oClone:cticketslidosseminteracao := ::cticketslidosseminteracao
	oClone:cbloqueado           := ::cbloqueado
	oClone:cdivisor2            := ::cdivisor2
	oClone:cdtabertura          := ::cdtabertura
	oClone:cdtalteracao         := ::cdtalteracao
	oClone:cdtfechamento        := ::cdtfechamento
	oClone:cdtprevisao          := ::cdtprevisao
	oClone:cdtitem              := ::cdtitem
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_ObterRequestDados
	Local cSoap := ""
	cSoap += WSSoapValue("codticket", ::ccodticket, ::ccodticket , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("coddepartamento", ::ccoddepartamento, ::ccoddepartamento , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codcategoria", ::ccodcategoria, ::ccodcategoria , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codclass", ::ccodclass, ::ccodclass , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codstatus", ::ccodstatus, ::ccodstatus , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("titulo", ::ctitulo, ::ctitulo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("descricao", ::cdescricao, ::cdescricao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("divisor1", ::cdivisor1, ::cdivisor1 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codusuario", ::ccodusuario, ::ccodusuario , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codusuarioitem", ::ccodusuarioitem, ::ccodusuarioitem , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("prioridade", ::cprioridade, ::cprioridade , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("avaliacao", ::cavaliacao, ::cavaliacao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsabertos", ::cticketsabertos, ::cticketsabertos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsnaolidos", ::cticketsnaolidos, ::cticketsnaolidos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketscomanexo", ::cticketscomanexo, ::cticketscomanexo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketslidosseminteracao", ::cticketslidosseminteracao, ::cticketslidosseminteracao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("bloqueado", ::cbloqueado, ::cbloqueado , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("divisor2", ::cdivisor2, ::cdivisor2 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtabertura", ::cdtabertura, ::cdtabertura , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtalteracao", ::cdtalteracao, ::cdtalteracao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtfechamento", ::cdtfechamento, ::cdtfechamento , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtprevisao", ::cdtprevisao, ::cdtprevisao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtitem", ::cdtitem, ::cdtitem , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure OpcoesClientes

WSSTRUCT FormularioHelpDeskService_OpcoesClientes
	WSDATA   cct_codigo                AS string OPTIONAL
	WSDATA   cloja                     AS string OPTIONAL
	WSDATA   cnomeempresa              AS string OPTIONAL
	WSDATA   crazaosocial              AS string OPTIONAL
	WSDATA   ccnpj                     AS string OPTIONAL
	WSDATA   cinscest                  AS string OPTIONAL
	WSDATA   cinscmun                  AS string OPTIONAL
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   ccodmunicipio             AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   ctelefone                 AS string OPTIONAL
	WSDATA   cemailcli                 AS string OPTIONAL
	WSDATA   ccontato                  AS string OPTIONAL
	WSDATA   cvde                      AS string OPTIONAL
	WSDATA   cnomevde                  AS string OPTIONAL
	WSDATA   cvdi                      AS string OPTIONAL
	WSDATA   cnomevdi                  AS string OPTIONAL
	WSDATA   ccodtransportadora        AS string OPTIONAL
	WSDATA   cnometransportadora       AS string OPTIONAL
	WSDATA   cobs                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_OpcoesClientes
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_OpcoesClientes
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_OpcoesClientes
	Local oClone := FormularioHelpDeskService_OpcoesClientes():NEW()
	oClone:cct_codigo           := ::cct_codigo
	oClone:cloja                := ::cloja
	oClone:cnomeempresa         := ::cnomeempresa
	oClone:crazaosocial         := ::crazaosocial
	oClone:ccnpj                := ::ccnpj
	oClone:cinscest             := ::cinscest
	oClone:cinscmun             := ::cinscmun
	oClone:cendereco            := ::cendereco
	oClone:cbairro              := ::cbairro
	oClone:ccodmunicipio        := ::ccodmunicipio
	oClone:cmunicipio           := ::cmunicipio
	oClone:cuf                  := ::cuf
	oClone:ccep                 := ::ccep
	oClone:ctelefone            := ::ctelefone
	oClone:cemailcli            := ::cemailcli
	oClone:ccontato             := ::ccontato
	oClone:cvde                 := ::cvde
	oClone:cnomevde             := ::cnomevde
	oClone:cvdi                 := ::cvdi
	oClone:cnomevdi             := ::cnomevdi
	oClone:ccodtransportadora   := ::ccodtransportadora
	oClone:cnometransportadora  := ::cnometransportadora
	oClone:cobs                 := ::cobs
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_OpcoesClientes
	Local cSoap := ""
	cSoap += WSSoapValue("ct_codigo", ::cct_codigo, ::cct_codigo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("loja", ::cloja, ::cloja , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nomeempresa", ::cnomeempresa, ::cnomeempresa , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("razaosocial", ::crazaosocial, ::crazaosocial , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("cnpj", ::ccnpj, ::ccnpj , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("inscest", ::cinscest, ::cinscest , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("inscmun", ::cinscmun, ::cinscmun , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codmunicipio", ::ccodmunicipio, ::ccodmunicipio , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("telefone", ::ctelefone, ::ctelefone , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("emailcli", ::cemailcli, ::cemailcli , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("contato", ::ccontato, ::ccontato , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("vde", ::cvde, ::cvde , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nomevde", ::cnomevde, ::cnomevde , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("vdi", ::cvdi, ::cvdi , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nomevdi", ::cnomevdi, ::cnomevdi , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codtransportadora", ::ccodtransportadora, ::ccodtransportadora , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nometransportadora", ::cnometransportadora, ::cnometransportadora , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("obs", ::cobs, ::cobs , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure OpcoesUsuarios

WSSTRUCT FormularioHelpDeskService_OpcoesUsuarios
	WSDATA   cnomecompleto             AS string OPTIONAL
	WSDATA   cnotenabled               AS string OPTIONAL
	WSDATA   ctelefone                 AS string OPTIONAL
	WSDATA   cdepto                    AS string OPTIONAL
	WSDATA   cemail1                   AS string OPTIONAL
	WSDATA   cemail2                   AS string OPTIONAL
	WSDATA   cbzpgrupo                 AS string OPTIONAL
	WSDATA   ccodempresa               AS string OPTIONAL
	WSDATA   cobs                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_OpcoesUsuarios
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_OpcoesUsuarios
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_OpcoesUsuarios
	Local oClone := FormularioHelpDeskService_OpcoesUsuarios():NEW()
	oClone:cnomecompleto        := ::cnomecompleto
	oClone:cnotenabled          := ::cnotenabled
	oClone:ctelefone            := ::ctelefone
	oClone:cdepto               := ::cdepto
	oClone:cemail1              := ::cemail1
	oClone:cemail2              := ::cemail2
	oClone:cbzpgrupo            := ::cbzpgrupo
	oClone:ccodempresa          := ::ccodempresa
	oClone:cobs                 := ::cobs
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_OpcoesUsuarios
	Local cSoap := ""
	cSoap += WSSoapValue("nomecompleto", ::cnomecompleto, ::cnomecompleto , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("notenabled", ::cnotenabled, ::cnotenabled , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("telefone", ::ctelefone, ::ctelefone , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("depto", ::cdepto, ::cdepto , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("email1", ::cemail1, ::cemail1 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("email2", ::cemail2, ::cemail2 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("bzpgrupo", ::cbzpgrupo, ::cbzpgrupo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codempresa", ::ccodempresa, ::ccodempresa , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("obs", ::cobs, ::cobs , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterResult

WSSTRUCT FormularioHelpDeskService_ObterResult
	WSDATA   oWSdados                  AS FormularioHelpDeskService_ObterResultDados OPTIONAL
	WSDATA   cstatusRetorno            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterResult
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterResult
	Local oClone := FormularioHelpDeskService_ObterResult():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:cstatusRetorno       := ::cstatusRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterResult
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_DADOS","ObterResultDados",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSdados := FormularioHelpDeskService_ObterResultDados():New()
		::oWSdados:SoapRecv(oNode1)
	EndIf
	::cstatusRetorno     :=  WSAdvValue( oResponse,"_STATUSRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterListaRequest

WSSTRUCT FormularioHelpDeskService_ObterListaRequest
	WSDATA   oWSdados                  AS FormularioHelpDeskService_ObterListaRequestDados OPTIONAL
	WSDATA   oWSopcoesClientes         AS FormularioHelpDeskService_OpcoesClientes OPTIONAL
	WSDATA   oWSopcoesUsuarios         AS FormularioHelpDeskService_OpcoesUsuarios OPTIONAL
	WSDATA   csigla                    AS string OPTIONAL
	WSDATA   cservicekey               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterListaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterListaRequest
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterListaRequest
	Local oClone := FormularioHelpDeskService_ObterListaRequest():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:oWSopcoesClientes    := IIF(::oWSopcoesClientes = NIL , NIL , ::oWSopcoesClientes:Clone() )
	oClone:oWSopcoesUsuarios    := IIF(::oWSopcoesUsuarios = NIL , NIL , ::oWSopcoesUsuarios:Clone() )
	oClone:csigla               := ::csigla
	oClone:cservicekey          := ::cservicekey
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_ObterListaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("dados", ::oWSdados, ::oWSdados , "ObterListaRequestDados", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("opcoesClientes", ::oWSopcoesClientes, ::oWSopcoesClientes , "OpcoesClientes", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("opcoesUsuarios", ::oWSopcoesUsuarios, ::oWSopcoesUsuarios , "OpcoesUsuarios", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("sigla", ::csigla, ::csigla , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("servicekey", ::cservicekey, ::cservicekey , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ObterListaResult

WSSTRUCT FormularioHelpDeskService_ObterListaResult
	WSDATA   oWSdados                  AS FormularioHelpDeskService_ArrayOfObterListaResultDados OPTIONAL
	WSDATA   cstatusRetorno            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterListaResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterListaResult
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterListaResult
	Local oClone := FormularioHelpDeskService_ObterListaResult():NEW()
	oClone:oWSdados             := IIF(::oWSdados = NIL , NIL , ::oWSdados:Clone() )
	oClone:cstatusRetorno       := ::cstatusRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterListaResult
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_DADOS","ArrayOfObterListaResultDados",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSdados := FormularioHelpDeskService_ArrayOfObterListaResultDados():New()
		::oWSdados:SoapRecv(oNode1)
	EndIf
	::cstatusRetorno     :=  WSAdvValue( oResponse,"_STATUSRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterResultDados

WSSTRUCT FormularioHelpDeskService_ObterResultDados
	WSDATA   ccodticket                AS string OPTIONAL
	WSDATA   ccoddepartamento          AS string OPTIONAL
	WSDATA   ccodcategoria             AS string OPTIONAL
	WSDATA   ccodclass                 AS string OPTIONAL
	WSDATA   ccodstatus                AS string OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cdivisor1                 AS string OPTIONAL
	WSDATA   ccodusuario               AS string OPTIONAL
	WSDATA   ccodusuarioitem           AS string OPTIONAL
	WSDATA   cprioridade               AS string OPTIONAL
	WSDATA   cavaliacao                AS string OPTIONAL
	WSDATA   cticketsabertos           AS string OPTIONAL
	WSDATA   cticketsnaolidos          AS string OPTIONAL
	WSDATA   cticketscomanexo          AS string OPTIONAL
	WSDATA   cticketslidosseminteracao AS string OPTIONAL
	WSDATA   cbloqueado                AS string OPTIONAL
	WSDATA   cdivisor2                 AS string OPTIONAL
	WSDATA   cdtabertura               AS string OPTIONAL
	WSDATA   cdtalteracao              AS string OPTIONAL
	WSDATA   cdtfechamento             AS string OPTIONAL
	WSDATA   cdtprevisao               AS string OPTIONAL
	WSDATA   cdtitem                   AS string OPTIONAL
	WSDATA   oWSobterResultDadosInteracao AS FormularioHelpDeskService_ArrayOfObterResultDadosInteracao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterResultDados
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterResultDados
	Local oClone := FormularioHelpDeskService_ObterResultDados():NEW()
	oClone:ccodticket           := ::ccodticket
	oClone:ccoddepartamento     := ::ccoddepartamento
	oClone:ccodcategoria        := ::ccodcategoria
	oClone:ccodclass            := ::ccodclass
	oClone:ccodstatus           := ::ccodstatus
	oClone:ctitulo              := ::ctitulo
	oClone:cdescricao           := ::cdescricao
	oClone:cdivisor1            := ::cdivisor1
	oClone:ccodusuario          := ::ccodusuario
	oClone:ccodusuarioitem      := ::ccodusuarioitem
	oClone:cprioridade          := ::cprioridade
	oClone:cavaliacao           := ::cavaliacao
	oClone:cticketsabertos      := ::cticketsabertos
	oClone:cticketsnaolidos     := ::cticketsnaolidos
	oClone:cticketscomanexo     := ::cticketscomanexo
	oClone:cticketslidosseminteracao := ::cticketslidosseminteracao
	oClone:cbloqueado           := ::cbloqueado
	oClone:cdivisor2            := ::cdivisor2
	oClone:cdtabertura          := ::cdtabertura
	oClone:cdtalteracao         := ::cdtalteracao
	oClone:cdtfechamento        := ::cdtfechamento
	oClone:cdtprevisao          := ::cdtprevisao
	oClone:cdtitem              := ::cdtitem
	oClone:oWSobterResultDadosInteracao := IIF(::oWSobterResultDadosInteracao = NIL , NIL , ::oWSobterResultDadosInteracao:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterResultDados
	Local oNode24
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ccodticket         :=  WSAdvValue( oResponse,"_CODTICKET","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccoddepartamento   :=  WSAdvValue( oResponse,"_CODDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodcategoria      :=  WSAdvValue( oResponse,"_CODCATEGORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodclass          :=  WSAdvValue( oResponse,"_CODCLASS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodstatus         :=  WSAdvValue( oResponse,"_CODSTATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctitulo            :=  WSAdvValue( oResponse,"_TITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdivisor1          :=  WSAdvValue( oResponse,"_DIVISOR1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodusuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodusuarioitem    :=  WSAdvValue( oResponse,"_CODUSUARIOITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cprioridade        :=  WSAdvValue( oResponse,"_PRIORIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cavaliacao         :=  WSAdvValue( oResponse,"_AVALIACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketsabertos    :=  WSAdvValue( oResponse,"_TICKETSABERTOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketsnaolidos   :=  WSAdvValue( oResponse,"_TICKETSNAOLIDOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketscomanexo   :=  WSAdvValue( oResponse,"_TICKETSCOMANEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketslidosseminteracao :=  WSAdvValue( oResponse,"_TICKETSLIDOSSEMINTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbloqueado         :=  WSAdvValue( oResponse,"_BLOQUEADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdivisor2          :=  WSAdvValue( oResponse,"_DIVISOR2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtabertura        :=  WSAdvValue( oResponse,"_DTABERTURA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtalteracao       :=  WSAdvValue( oResponse,"_DTALTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtfechamento      :=  WSAdvValue( oResponse,"_DTFECHAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtprevisao        :=  WSAdvValue( oResponse,"_DTPREVISAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtitem            :=  WSAdvValue( oResponse,"_DTITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode24 :=  WSAdvValue( oResponse,"_OBTERRESULTDADOSINTERACAO","ArrayOfObterResultDadosInteracao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode24 != NIL
		::oWSobterResultDadosInteracao := FormularioHelpDeskService_ArrayOfObterResultDadosInteracao():New()
		::oWSobterResultDadosInteracao:SoapRecv(oNode24)
	EndIf
Return

// WSDL Data Structure ObterListaRequestDados

WSSTRUCT FormularioHelpDeskService_ObterListaRequestDados
	WSDATA   ccodticket                AS string OPTIONAL
	WSDATA   ccoddepartamento          AS string OPTIONAL
	WSDATA   ccodcategoria             AS string OPTIONAL
	WSDATA   ccodclass                 AS string OPTIONAL
	WSDATA   ccodstatus                AS string OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cdivisor1                 AS string OPTIONAL
	WSDATA   ccodusuario               AS string OPTIONAL
	WSDATA   ccodusuarioitem           AS string OPTIONAL
	WSDATA   cprioridade               AS string OPTIONAL
	WSDATA   cavaliacao                AS string OPTIONAL
	WSDATA   cticketsabertos           AS string OPTIONAL
	WSDATA   cticketsnaolidos          AS string OPTIONAL
	WSDATA   cticketscomanexo          AS string OPTIONAL
	WSDATA   cticketslidosseminteracao AS string OPTIONAL
	WSDATA   cbloqueado                AS string OPTIONAL
	WSDATA   cdivisor2                 AS string OPTIONAL
	WSDATA   cdtabertura               AS string OPTIONAL
	WSDATA   cdtalteracao              AS string OPTIONAL
	WSDATA   cdtfechamento             AS string OPTIONAL
	WSDATA   cdtprevisao               AS string OPTIONAL
	WSDATA   cdtitem                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterListaRequestDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterListaRequestDados
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterListaRequestDados
	Local oClone := FormularioHelpDeskService_ObterListaRequestDados():NEW()
	oClone:ccodticket           := ::ccodticket
	oClone:ccoddepartamento     := ::ccoddepartamento
	oClone:ccodcategoria        := ::ccodcategoria
	oClone:ccodclass            := ::ccodclass
	oClone:ccodstatus           := ::ccodstatus
	oClone:ctitulo              := ::ctitulo
	oClone:cdescricao           := ::cdescricao
	oClone:cdivisor1            := ::cdivisor1
	oClone:ccodusuario          := ::ccodusuario
	oClone:ccodusuarioitem      := ::ccodusuarioitem
	oClone:cprioridade          := ::cprioridade
	oClone:cavaliacao           := ::cavaliacao
	oClone:cticketsabertos      := ::cticketsabertos
	oClone:cticketsnaolidos     := ::cticketsnaolidos
	oClone:cticketscomanexo     := ::cticketscomanexo
	oClone:cticketslidosseminteracao := ::cticketslidosseminteracao
	oClone:cbloqueado           := ::cbloqueado
	oClone:cdivisor2            := ::cdivisor2
	oClone:cdtabertura          := ::cdtabertura
	oClone:cdtalteracao         := ::cdtalteracao
	oClone:cdtfechamento        := ::cdtfechamento
	oClone:cdtprevisao          := ::cdtprevisao
	oClone:cdtitem              := ::cdtitem
Return oClone

WSMETHOD SOAPSEND WSCLIENT FormularioHelpDeskService_ObterListaRequestDados
	Local cSoap := ""
	cSoap += WSSoapValue("codticket", ::ccodticket, ::ccodticket , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("coddepartamento", ::ccoddepartamento, ::ccoddepartamento , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codcategoria", ::ccodcategoria, ::ccodcategoria , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codclass", ::ccodclass, ::ccodclass , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codstatus", ::ccodstatus, ::ccodstatus , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("titulo", ::ctitulo, ::ctitulo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("descricao", ::cdescricao, ::cdescricao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("divisor1", ::cdivisor1, ::cdivisor1 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codusuario", ::ccodusuario, ::ccodusuario , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("codusuarioitem", ::ccodusuarioitem, ::ccodusuarioitem , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("prioridade", ::cprioridade, ::cprioridade , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("avaliacao", ::cavaliacao, ::cavaliacao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsabertos", ::cticketsabertos, ::cticketsabertos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketsnaolidos", ::cticketsnaolidos, ::cticketsnaolidos , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketscomanexo", ::cticketscomanexo, ::cticketscomanexo , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ticketslidosseminteracao", ::cticketslidosseminteracao, ::cticketslidosseminteracao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("bloqueado", ::cbloqueado, ::cbloqueado , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("divisor2", ::cdivisor2, ::cdivisor2 , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtabertura", ::cdtabertura, ::cdtabertura , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtalteracao", ::cdtalteracao, ::cdtalteracao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtfechamento", ::cdtfechamento, ::cdtfechamento , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtprevisao", ::cdtprevisao, ::cdtprevisao , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("dtitem", ::cdtitem, ::cdtitem , "string", .F. , .T., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ArrayOfObterListaResultDados

WSSTRUCT FormularioHelpDeskService_ArrayOfObterListaResultDados
	WSDATA   oWSObterListaResultDados  AS FormularioHelpDeskService_ObterListaResultDados OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ArrayOfObterListaResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ArrayOfObterListaResultDados
	::oWSObterListaResultDados := {} // Array Of  FormularioHelpDeskService_OBTERLISTARESULTDADOS():New()
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ArrayOfObterListaResultDados
	Local oClone := FormularioHelpDeskService_ArrayOfObterListaResultDados():NEW()
	oClone:oWSObterListaResultDados := NIL
	If ::oWSObterListaResultDados <> NIL 
		oClone:oWSObterListaResultDados := {}
		aEval( ::oWSObterListaResultDados , { |x| aadd( oClone:oWSObterListaResultDados , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ArrayOfObterListaResultDados
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterListaResultDados , FormularioHelpDeskService_ObterListaResultDados():New() )
  			::oWSObterListaResultDados[len(::oWSObterListaResultDados)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfObterResultDadosInteracao

WSSTRUCT FormularioHelpDeskService_ArrayOfObterResultDadosInteracao
	WSDATA   oWSObterResultDadosInteracao AS FormularioHelpDeskService_ObterResultDadosInteracao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracao
	::oWSObterResultDadosInteracao := {} // Array Of  FormularioHelpDeskService_OBTERRESULTDADOSINTERACAO():New()
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracao
	Local oClone := FormularioHelpDeskService_ArrayOfObterResultDadosInteracao():NEW()
	oClone:oWSObterResultDadosInteracao := NIL
	If ::oWSObterResultDadosInteracao <> NIL 
		oClone:oWSObterResultDadosInteracao := {}
		aEval( ::oWSObterResultDadosInteracao , { |x| aadd( oClone:oWSObterResultDadosInteracao , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracao
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterResultDadosInteracao , FormularioHelpDeskService_ObterResultDadosInteracao():New() )
  			::oWSObterResultDadosInteracao[len(::oWSObterResultDadosInteracao)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ObterListaResultDados

WSSTRUCT FormularioHelpDeskService_ObterListaResultDados
	WSDATA   ccodticket                AS string OPTIONAL
	WSDATA   ccoddepartamento          AS string OPTIONAL
	WSDATA   ccodcategoria             AS string OPTIONAL
	WSDATA   ccodclass                 AS string OPTIONAL
	WSDATA   ccodstatus                AS string OPTIONAL
	WSDATA   ctitulo                   AS string OPTIONAL
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   cdivisor1                 AS string OPTIONAL
	WSDATA   ccodusuario               AS string OPTIONAL
	WSDATA   ccodusuarioitem           AS string OPTIONAL
	WSDATA   cprioridade               AS string OPTIONAL
	WSDATA   cavaliacao                AS string OPTIONAL
	WSDATA   cticketsabertos           AS string OPTIONAL
	WSDATA   cticketsnaolidos          AS string OPTIONAL
	WSDATA   cticketscomanexo          AS string OPTIONAL
	WSDATA   cticketslidosseminteracao AS string OPTIONAL
	WSDATA   cbloqueado                AS string OPTIONAL
	WSDATA   cdivisor2                 AS string OPTIONAL
	WSDATA   cdtabertura               AS string OPTIONAL
	WSDATA   cdtalteracao              AS string OPTIONAL
	WSDATA   cdtfechamento             AS string OPTIONAL
	WSDATA   cdtprevisao               AS string OPTIONAL
	WSDATA   cdtitem                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterListaResultDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterListaResultDados
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterListaResultDados
	Local oClone := FormularioHelpDeskService_ObterListaResultDados():NEW()
	oClone:ccodticket           := ::ccodticket
	oClone:ccoddepartamento     := ::ccoddepartamento
	oClone:ccodcategoria        := ::ccodcategoria
	oClone:ccodclass            := ::ccodclass
	oClone:ccodstatus           := ::ccodstatus
	oClone:ctitulo              := ::ctitulo
	oClone:cdescricao           := ::cdescricao
	oClone:cdivisor1            := ::cdivisor1
	oClone:ccodusuario          := ::ccodusuario
	oClone:ccodusuarioitem      := ::ccodusuarioitem
	oClone:cprioridade          := ::cprioridade
	oClone:cavaliacao           := ::cavaliacao
	oClone:cticketsabertos      := ::cticketsabertos
	oClone:cticketsnaolidos     := ::cticketsnaolidos
	oClone:cticketscomanexo     := ::cticketscomanexo
	oClone:cticketslidosseminteracao := ::cticketslidosseminteracao
	oClone:cbloqueado           := ::cbloqueado
	oClone:cdivisor2            := ::cdivisor2
	oClone:cdtabertura          := ::cdtabertura
	oClone:cdtalteracao         := ::cdtalteracao
	oClone:cdtfechamento        := ::cdtfechamento
	oClone:cdtprevisao          := ::cdtprevisao
	oClone:cdtitem              := ::cdtitem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterListaResultDados
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ccodticket         :=  WSAdvValue( oResponse,"_CODTICKET","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccoddepartamento   :=  WSAdvValue( oResponse,"_CODDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodcategoria      :=  WSAdvValue( oResponse,"_CODCATEGORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodclass          :=  WSAdvValue( oResponse,"_CODCLASS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodstatus         :=  WSAdvValue( oResponse,"_CODSTATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctitulo            :=  WSAdvValue( oResponse,"_TITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdivisor1          :=  WSAdvValue( oResponse,"_DIVISOR1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodusuario        :=  WSAdvValue( oResponse,"_CODUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodusuarioitem    :=  WSAdvValue( oResponse,"_CODUSUARIOITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cprioridade        :=  WSAdvValue( oResponse,"_PRIORIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cavaliacao         :=  WSAdvValue( oResponse,"_AVALIACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketsabertos    :=  WSAdvValue( oResponse,"_TICKETSABERTOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketsnaolidos   :=  WSAdvValue( oResponse,"_TICKETSNAOLIDOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketscomanexo   :=  WSAdvValue( oResponse,"_TICKETSCOMANEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cticketslidosseminteracao :=  WSAdvValue( oResponse,"_TICKETSLIDOSSEMINTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbloqueado         :=  WSAdvValue( oResponse,"_BLOQUEADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdivisor2          :=  WSAdvValue( oResponse,"_DIVISOR2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtabertura        :=  WSAdvValue( oResponse,"_DTABERTURA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtalteracao       :=  WSAdvValue( oResponse,"_DTALTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtfechamento      :=  WSAdvValue( oResponse,"_DTFECHAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtprevisao        :=  WSAdvValue( oResponse,"_DTPREVISAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdtitem            :=  WSAdvValue( oResponse,"_DTITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterResultDadosInteracao

WSSTRUCT FormularioHelpDeskService_ObterResultDadosInteracao
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
	WSDATA   oWSarquivos               AS FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracao
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracao
	Local oClone := FormularioHelpDeskService_ObterResultDadosInteracao():NEW()
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

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracao
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
		::oWSarquivos := FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo():New()
		::oWSarquivos:SoapRecv(oNode17)
	EndIf
Return

// WSDL Data Structure ArrayOfObterResultDadosInteracaoArquivo

WSSTRUCT FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	WSDATA   oWSObterResultDadosInteracaoArquivo AS FormularioHelpDeskService_ObterResultDadosInteracaoArquivo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	::oWSObterResultDadosInteracaoArquivo := {} // Array Of  FormularioHelpDeskService_OBTERRESULTDADOSINTERACAOARQUIVO():New()
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	Local oClone := FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo():NEW()
	oClone:oWSObterResultDadosInteracaoArquivo := NIL
	If ::oWSObterResultDadosInteracaoArquivo <> NIL 
		oClone:oWSObterResultDadosInteracaoArquivo := {}
		aEval( ::oWSObterResultDadosInteracaoArquivo , { |x| aadd( oClone:oWSObterResultDadosInteracaoArquivo , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ArrayOfObterResultDadosInteracaoArquivo
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSObterResultDadosInteracaoArquivo , FormularioHelpDeskService_ObterResultDadosInteracaoArquivo():New() )
  			::oWSObterResultDadosInteracaoArquivo[len(::oWSObterResultDadosInteracaoArquivo)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ObterResultDadosInteracaoArquivo

WSSTRUCT FormularioHelpDeskService_ObterResultDadosInteracaoArquivo
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

WSMETHOD NEW WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracaoArquivo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracaoArquivo
Return

WSMETHOD CLONE WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracaoArquivo
	Local oClone := FormularioHelpDeskService_ObterResultDadosInteracaoArquivo():NEW()
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

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FormularioHelpDeskService_ObterResultDadosInteracaoArquivo
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


