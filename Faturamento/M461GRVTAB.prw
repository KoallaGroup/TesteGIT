#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
+----------+-------------+-------+--------------------------+------+-------------+
|Programa  | M461GRVTAB  | Autor |  Marcus Feixas  - Anadi  | Data | Dez  /2014  |
+----------+-------------+-------+--------------------------+------+-------------+
|Descricao | Acerta os valores das parcelas baseado na regra que o Marcelo       |
|          | solicitou para arredondar o valor das proximas parcelas e jogar     |
|          | todas na primeira parcela .                                         |
+----------+---------------------------------------------------------------------+
|Uso       | Isapa                                                               |
+----------+---------------------------------------------------------------------+

*/

User Function M461GRVTAB(_xaRec)
// 
Local _cArea := GetArea()

_cSqlSe1 := "select count(*) QTDSE1 , sum(E1_VALOR) VALORSE1 from " + retsqlname("SE1") + " SE1 where "
_cSqlSe1 += "     E1_FILIAL = '" + SF2->F2_FILIAL + "' and "
_cSqlSe1 += "     E1_PREFIXO = '" + SF2->F2_SERIE + "' and "
_cSqlSe1 += "     E1_NUM = '" + SF2->F2_DOC + "' and "
_cSqlSe1 += "     E1_TIPO= 'NF' and "
_cSqlSe1 += "     E1_CLIENTE = '" + SF2->F2_CLIENTE + "' and "
_cSqlSe1 += "     SE1.D_E_L_E_T_ = ' '  "         
tcquery _cSqlSe1 NEW ALIAS "XSE1" 
_cQtdSe1 := XSE1->QTDSE1  
dbselectarea("XSE1")
DbCloseArea()
//
if _cQtdSe1 = 1
   restarea(_cArea)
   return (_xaRec)     // apenas uma parcela nao faz nada e retorna
endif
_nDifSe1 := 0
For nLoop := 1 to Len( _xaRec )
    SE1->( dbGoto( _xaRec[ nLoop ] ) ) 
    if SE1->E1_PARCELA <> 1
        reclock("SE1",.f.)
        _nDifSe1 += (SE1->E1_VALOR - int(SE1->E1_VALOR))
        SE1->E1_VALOR := int(SE1->E1_VALOR)
        msunlock()
    endif
next
//
// ==> Agora vamos gravar tudo na Primeira Parcela
//
For nLoop := 1 to Len( _xaRec )
    SE1->( dbGoto( _xaRec[ nLoop ] ) ) 
    if SE1->E1_PARCELA <> 1
       loop
    endif
    reclock("SE1",.f.)
    SE1->E1_VALOR := SE1->E1_VALOR + _nDifSe1
    msunlock()
next    
//
restarea(_cArea)
return (_xaRec)