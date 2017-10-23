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

/*
+-----------+---------+-------+---------------------------------------+------+-------------+
| Programa  | FFATP05 | Autor | Jorge Henrique Alves - Anadi Solu��es | Data | Agosto/2012 |
+-----------+---------+-------+---------------------------------------+------+-------------+
| Descricao | JOB para impress�o autom�tica do DANFE, ap�s autoriza��o da NF-e			   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/

User Function FFATP05()
Local _aArea := {}

RpcSetType(3)                  // Seta job para nao consumir licensas
RpcSetEnv("01","01",,,"LOJA")  // Seta job para empresa filial desejada
_aArea := SM0->(GetArea())

While !KillApp()

    DbSelectArea("SM0")
    DbGoTop()
    
    While !Eof()
    
        _aArea := SM0->(GetArea())
        //StartJob("U_FFATP05A",GetEnvServer(),.F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
        U_FFATP05A(SM0->M0_CODIGO,SM0->M0_CODFIL)
        RestArea(_aArea)
        
        DbSelectArea("SM0")
        DbSkip()
    EndDo
//    Sleep(60000) //Pausa de 1,5 minutos
EndDo

RestArea(_aArea)

//PrcClearEnv()

Return


/*
+-----------+----------+-------+---------------------------------------+------+-------------+
| Programa  | FFATP05A | Autor | Jorge Henrique Alves - Anadi Solu��es | Data | Agosto/2012 |
+-----------+----------+-------+---------------------------------------+------+-------------+
| Descricao | Verifica as notas n�o impressas e faz o envio para a impressora				|
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/

User Function FFATP05A(_cEmp,_cFil)
Local _cSQL := _cTab := _cIdent := _cFile := "",oSetup
//Default _cEmp := "01", _cFil := "01"
//RpcSetType(3) // Seta job para nao consumir licensas
//RpcSetEnv(_cEmp,_cFil,,,"FAT") // Seta job para empresa filial desejada

    //Busca pelas notas n�o impressas e autorizadas
    _cSQL := "Select F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO From " + RetSqlName("SF2") + " F2 "
    _cSQL +=    "Inner Join SPED050 SP On NFE_ID = (F2_SERIE || F2_DOC) And STATUS = 6 And SP.D_E_L_E_T_ = ' ' "
//    _cSQL += "Where F2_FILIAL = '" + xFilial("SF2") + "' 
//    _cSQL += " And F2_FIMP = ' ' And F2.D_E_L_E_T_ = ' ' "
    
   
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
    
    DbSelectArea(_cTab)
    DbGoTop() 
    
    //Efetua a impress�o do DANFE de cada nota
    While !Eof()
        DbSelectArea("SF2")
        DbSetOrder(1)
        DbSeek(xFilial("SF2") + (_cTab)->F2_DOC + (_cTab)->F2_SERIE + (_cTab)->F2_CLIENTE + (_cTab)->F2_LOJA)
                      
        _cLocal:= "c:\relato\"                                                                              
        
        _cFile := "DANFE_"+_cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
        lDisableSetup  := .t.
        lAdjustToLegacy := .F. // Inibe legado de resolu��o com a TMSPrinter

		oDanfe := FWMSPrinter():New(_cFile, IMP_PDF, lAdjustToLegacy, cLocal, lDisableSetup)
		
		U_DANFE_P1(cIdEnt,,,oDanfe, oSetup)	

		oDanfe:Preview()   
		exit         
        
        DbSelectArea(_cTab)
        DbSkip()    
    EndDo
    

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

PrcClearEnv()
Return 