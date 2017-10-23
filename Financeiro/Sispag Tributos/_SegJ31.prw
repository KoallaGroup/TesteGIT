#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
------------- Valor Total CNAB Itaú Tributos -----------------
------------- HENRIQUE R. MARTINS ------------------
------------- DT. 07/07/2015------------------------
------------- Isapa --------------------------------  */

User Function _IsaSegJ31() 
Local _cSql  := ""
Local nVALOR := 0

_cSql += "SELECT SUM(E2_VALOR + E2__VOUTRA + E2_ACRESC - E2_DECRESC) AS TOTAL "
_cSql += "FROM " + retsqlname("SE2")+ " SE2 "
_cSql += "WHERE SE2.E2_NUMBOR >= '"+ ALLTRIM(MV_PAR01) +"' AND SE2.E2_NUMBOR <= '"+ ALLTRIM(MV_PAR02) +"' AND SE2.D_E_L_E_T_ = ' ' "
                         
TcQuery _cSql new ALIAS ("xSE2") 
                       
nVALOR := STRZERO(xSE2->TOTAL*100,14)

xSE2->(dbCloseArea())

RETURN ( nVALOR )

//Soma outras entidades
User Function _SegN01() 
Local _cSql  := ""
Local nVALOR := 0

_cSql += "SELECT SUM(E2__VOUTRA) AS TOTAL "
_cSql += "FROM " + retsqlname("SE2")+ " SE2 "
_cSql += "WHERE SE2.E2_NUMBOR >= '"+ ALLTRIM(MV_PAR01) +"' AND SE2.E2_NUMBOR <= '"+ ALLTRIM(MV_PAR02) +"' AND SE2.D_E_L_E_T_ = ' ' "
                         
TcQuery _cSql new ALIAS ("xSE2") 
                       
nVALOR := STRZERO(xSE2->TOTAL*100,14)

xSE2->(dbCloseArea())

RETURN ( nVALOR )


//Soma valor INSS
User Function _SegN02() 
Local _cSql  := ""
Local nVALOR := 0

//_cSql += "SELECT SUM(E2_VALOR - E2__VOUTRA) AS TOTAL "
_cSql += "SELECT SUM(E2_VALOR) AS TOTAL "
_cSql += "FROM " + retsqlname("SE2")+ " SE2 "
_cSql += "WHERE SE2.E2_NUMBOR >= '"+ ALLTRIM(MV_PAR01) +"' AND SE2.E2_NUMBOR <= '"+ ALLTRIM(MV_PAR02) +"' AND SE2.D_E_L_E_T_ = ' ' "
                         
TcQuery _cSql new ALIAS ("xSE2") 
                       
nVALOR := STRZERO(xSE2->TOTAL*100,14)

xSE2->(dbCloseArea())

RETURN ( nVALOR )