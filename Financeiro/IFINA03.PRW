#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#include "tbiconn.ch"           

/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | IFINA03 | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Fevereiro/2014|
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Rotina para copiar o numero bancario no CNAB para o título				   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/   
        
User function IFINA03()
Local cQuery	:= ""
Local _aAreaB	:= {}
//Local cBanco	:= Alltrim(posicione("SX1",1,"AFI200    06","X1_CNT01"))   
Local cPasta	:= ""
Local _cFilOld	:= ""                    
                       
conout("Inicia Job")                 
                 
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO 'EST' //TABLES "SF2","SF3"

cPasta 		:= Alltrim(GETMV("MV__CAMBOL"))
_cFilOld	:= cFilAnt

_cQuery := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO " + Chr(13)
_cQuery += " FROM " + retSqlName("SE1") + " SE1 " + Chr(13)
_cQuery += " WHERE SE1.E1__AUTBOL = ' ' " + Chr(13)
_cQuery += "   AND SE1.E1_NUMBCO <> ' ' " + Chr(13)
_cQuery += "   AND SE1.E1_PORTADO <> ' ' "  + Chr(13)
_cQuery += "      AND SE1.E1_EMISSAO > '20150504'  " + Chr(13)
_cQuery += "      AND SE1.E1_SALDO > 0  " + Chr(13)
_cQuery += "      AND SE1.E1_VENCREA >= TO_CHAR(SYSDATE,'RRRRMMDD')  " + Chr(13)
_cQuery += "   AND SE1.D_E_L_E_T_ <> '*' "

tcQuery _cQuery new alias "TRB_SE1"
                 
do While !TRB_SE1->(Eof())
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(TRB_SE1->E1_FILIAL+TRB_SE1->E1_PREFIXO+TRB_SE1->E1_NUM+TRB_SE1->E1_PARCELA+TRB_SE1->E1_TIPO)

		cFilAnt := TRB_SE1->E1_FILIAL
	
		conout(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
	
		reclock("SE1",.F.)
			conout("locado : " + SE1->E1_NUM + '-' + SE1->E1_SERIE + '/' + SE1->E1_NUMBCO)
			SE1->E1__AUTBOL := Date()                                                              	
		msUnlock()
	
		Do Case
			Case E1_PORTADO == '341' //Boletos do Itaú
				u_ifinr01(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '237' //Boletos do Bradesco
				u_ifinr02(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '001' //Boletos do Banco do Brasil
				u_ifinr03(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '422' //Boletos do Safra
				u_ifinr05(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '399' //Boletos do HSBC
				u_ifinr06(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
		EndCase 
	
	EndIf
		
	TRB_SE1->(DbSkip())
EndDo

TRB_SE1->(DbCloseArea())

cFilAnt := _cFilOld
 
reset environment

conout("termina Job")                 

Return                                      

