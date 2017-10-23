#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
#INCLUDE "FIVEWIN.CH"
#Include "TbiConn.ch"


User Function HistCom(_cFilial, _cDoc, _cSerie, _cFornece, _cLoja)  




cAlias := GetNextAlias()


cQuery := " SELECT D1_HIST FROM "+    RetSqlName("SD1") + " SD1 "
cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' AND D1_FILIAL = '"+_cFilial+"' AND D1_DOC = '"+_cDoc+"' AND D1_SERIE = '"+_cSerie+"' "
cQuery += " AND D1_FORNECE = '"+_cFornece+"' AND D1_LOJA = '"+_cLoja+"' AND D1_ITEM = '0001' "

Query := ChangeQuery(cQuery)          

TcQuery cQuery NEW ALIAS (cAlias) 
     
                                                                  







Return((cAlias)->D1_HIST)