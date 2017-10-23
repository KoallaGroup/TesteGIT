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
| Programa  | FFATP05 | Autor | Jorge Henrique Alves - Anadi Soluções | Data | Agosto/2012 |
+-----------+---------+-------+---------------------------------------+------+-------------+
| Descricao | JOB para impressão automática do DANFE, após autorização da NF-e			   |
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

//    DbSelectArea("SM0")
//    DbGoTop()
    
//    While !Eof()
    
        _aArea := SM0->(GetArea())
        //StartJob("U_FFATP05A",GetEnvServer(),.F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
        U_FFATP05A(SM0->M0_CODIGO,SM0->M0_CODFIL)
        RestArea(_aArea)
        
//        DbSelectArea("SM0")
//        DbSkip()
//    EndDo
    Sleep(60000) //Pausa de 1,5 minutos
EndDo

RestArea(_aArea)

PrcClearEnv()

Return


/*
+-----------+----------+-------+---------------------------------------+------+-------------+
| Programa  | FFATP05A | Autor | Jorge Henrique Alves - Anadi Soluções | Data | Agosto/2012 |
+-----------+----------+-------+---------------------------------------+------+-------------+
| Descricao | Verifica as notas não impressas e faz o envio para a impressora				|
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/

User Function FFATP05A(_cEmp,_cFil)
Local _cSQL := _cTab := _cIdent := _cFile := "",oSetup
Default _cEmp := "01", _cFil := "01"
//RpcSetType(3) // Seta job para nao consumir licensas
//RpcSetEnv(_cEmp,_cFil,,,"FAT") // Seta job para empresa filial desejada

//Localiza a Identidade da Empresa nas tabelas do SPED
_cTab := GetNextAlias()
_cSQL := "Select ID_ENT From SPED001 "
_cSQL += "Where CNPJ = '" + SM0->M0_CGC + "' And D_E_L_E_T_ = ' ' "

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    _cIdent := (_cTab)->ID_ENT
    
    DbSelectArea(_cTab)
    DbCloseArea()
    
    //Busca pelas notas não impressas e autorizadas
    _cSQL := "Select F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO From " + RetSqlName("SF2") + " F2 "
    _cSQL +=    "Inner Join SPED050 SP On ID_ENT = '" + _cIdent + "' And NFE_ID = (F2_SERIE + F2_DOC) And STATUS = 6 And SP.D_E_L_E_T_ = ' ' "
    _cSQL += "Where F2_FILIAL = '" + xFilial("SF2") + "' And F2_FIMP = ' ' And F2.D_E_L_E_T_ = ' ' "
    
    If Select(_cTab) > 0
        DbSelectArea(_cTab)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
    
    DbSelectArea(_cTab)
    DbGoTop() 
    
    //Efetua a impressão do DANFE de cada nota
    While !Eof()
        DbSelectArea("SF2")
        DbSetOrder(1)
        DbSeek(xFilial("SF2") + (_cTab)->F2_DOC + (_cTab)->F2_SERIE + (_cTab)->F2_CLIENTE + (_cTab)->F2_LOJA)
        
                                                                                            
        _cFile := "DANFE_"+_cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
        lDisableSetup  := .t.
        lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
        oDanfe := FWMSPrinter():New(_cFile, IMP_SPOOL, lAdjustToLegacy, /*cPathInServer*/, lDisableSetup)
            
        U_DANFE_P1(_cIdEnt,,,oDanfe, oSetup)
        
        DbSelectArea(_cTab)
        DbSkip()    
    EndDo
    
EndIf

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

PrcClearEnv()
Return 