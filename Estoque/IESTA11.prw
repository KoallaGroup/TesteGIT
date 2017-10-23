#DEFINE FIELD_POS_TRG	 1
#DEFINE FIELD_POS_SRC	 2
#DEFINE __nMAX_THREADS__ 2

#Include "Rwmake.ch"
#Include "Protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "SCOPECNT.CH"
#INCLUDE "DBSTRUCT.CH"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | IESTA11 | Autor: |    Rogério Alves     | Data: |    Julho/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Startjob para chamada da rotina de transferência automática        |
|            | do material no armazem da mesma filial                             |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function IESTA11()

Local aSM0Area, aSM0
Local nI, x, nX
Private lMsErroAuto := .F.

While !KillApp()
	
	aSM0 		:= FWLoadSM0()
	ASORT(aSM0, , , { | x,y | x[1] > y[1] } )
	
	For nX := 1 To Len(aSM0)
		
		StartJob("U_IESTA11B",GetEnvServer(),.F., { aSM0[nX][1], aSM0[nX][2] } )
		
		While ( !FreeThreads( .F. ) )
			IF ( lMsErroAuto )
				Break
			EndIF
		End While
		
	Next nX
	
EndDo

Return


/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | IESTA11B| Autor: |    Rogério Alves     | Data: |    Julho/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Chamada do fonte IESTA10 para execução da transferência            |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/


User Function IESTA11B(aCodigos)

Local _cEmp := aCodigos[01]
Local _cFil	:= aCodigos[02]
Local aInfo	:= {}

RpcClearEnv()
RpcSetType(3)
RpcSetEnv( _cEmp ,_cFil,,,"EST",GetEnvServer())

SetModulo( "SIGAEST", "EST" )

__cLogSiga := "NNNNNNNNNN"

aInfo := GetUserInfoArray()

for nI := 1 to len(aInfo)
	
	if aInfo[nI][3] <> Threadid()
		loop
	Else
		U_IESTA10({_cEmp,_cFil})
	endif
	
next nI

Return


/*
+------------+-------------+--------+----------------------+-------+--------------+
| Programa:  | FreeThreads | Autor: |    Rogério Alves     | Data: |  Julho/2014  |
+------------+-------------+--------+----------------------+-------+--------------+
| Descrição: | Verifica se as Threads Foram Liberadas                             |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

Static Function FreeThreads( lFreeAll )

Local aUserInfoArray	:= GetUserInfoArray()
Local cEnvServer		:= GetEnvServer()
Local cComputerName		:= GetComputerName()
Local nThreads			:= 0

aEval( aUserInfoArray , { |aThread| IF(;
( aThread[2] == cComputerName );
.and.;
( aThread[5] == "U_IESTA11B" );
.and.;
( aThread[6] == cEnvServer ),;
++nThreads,;
NIL;
);
};
)

DEFAULT lFreeAll	:= .F.
IF ( lFreeAll )
	lFreeThreads	:= ( nThreads == 0 )
Else
	lFreeThreads	:= ( nThreads <= Int( __nMAX_THREADS__ / 2 ) )
EndIF

Return( lFreeThreads )
