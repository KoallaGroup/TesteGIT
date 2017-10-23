#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"

user function IESTA12()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

If TCSPExist("PMHA_INTER_REQUISICAO")

aResult := TCSPEXEC( xProcedures("TESTE_PMHA_INTER_REQUISICAO"),;
			"01",;
			"01" )

endif
			
reset environment
