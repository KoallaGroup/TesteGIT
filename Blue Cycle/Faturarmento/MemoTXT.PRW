#include "protheus.ch"
#include "topconn.ch"

USER FUNCTION MEMOtxt(_tabela,_campo,_chave,_retorno)


Local _cSQL
Local _resultado := ""


_cSQL := "SELECT UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR("+_retorno+", 2000, 1))  MEMO FROM "+_tabela+"010 WHERE "+_campo+" = '"+_chave+"' AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),"TRD",.T.,.T.)

dbSelectArea("TRD")

TRD->(dbGoTop())
WHILE !TRD->(EOF())

	_resultado := TRD->MEMO

TRD->(DBSKIP())

ENDDO

TRD->(dbCloseArea())

return _resultado