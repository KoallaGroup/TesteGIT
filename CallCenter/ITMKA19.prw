#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Função : ITMKA19			 		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi							                 			|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Processo acionado pelo Gatilho na inclusão do pedido, para preenchimento 	  	|
|               do campo UA__FILIAL, C5__FILIAL ou ADE__FIL com a Filial sugerida para venda de |
|               acordo com o segmento do usuário                                                |
|-----------------------------------------------------------------------------------------------|
*/                                        

User Function ITMKA19(cCliente,cLoja,cSegto)

Local aArea 	:= GetArea()
Local cFil		:= Space(TamSX3("UA__FILIAL")[1])
Local cUf		:= Posicione('SA1',1,xFilial('SA1')+cCliente+cLoja,'A1_EST')

DbSelectArea("SZK")
DbSetOrder(1)
If DbSeek(xFilial("SZK") + cSegto + cUf)
	cFil := SZK->ZK_LOCFAT
	If FunName() == "TMKA271"
	   /*Jorge H. - Anadi
	   Código da tabela de preço será obtido da SZK
    	If SA1->A1_EST $ Alltrim(GetMv("MV__TABPUF")) .And. Val(M->UA__SEGISP) != 2
    		M->UA__UFTAB := SA1->A1_EST
    	Else
    		M->UA__UFTAB := "BR"
    	EndIf
        */
        M->UA__UFTAB := SZK->ZK_TABPAD
        
        If !Empty(M->UA__FILIAL)
            cFil := M->UA__FILIAL
        EndIf
    Else
        cFilAnt := IIF(!Empty(cFil),cFil,cFilAnt)    
    EndIf
EndIf

/* Jorge H
dbSelectArea("SZ1")
dbSetOrder(1) //Z1_FILIAL+Z1_CODUSR
If dbSeek(xFilial("SZ1")+__cUserId)
	cSeg	:= Z1_SEGISP
EndIf

If (select("TRBSZK") > 0)
	TRBSZK->(DbCloseArea())
EndIf

cQuery := "SELECT * "
cQuery += "FROM " + retSqlname("SZK") + " SZK "
cQuery += "WHERE SZK.D_E_L_E_T_ = ' ' AND "
If cSeg != "0"
	cQuery += "ZK_SEGISP = '" + cSeg + "' AND "
EndIf
cQuery += "ZK_UF LIKE '%" + cUf + "%' "
cQuery += "ORDER BY SZK.R_E_C_N_O_ "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TRBSZK"

DbSelectArea("TRBSZK")
DbGoTop()

cFil	:= TRBSZK->ZK_FILIAL

If(select("TRBSZK") > 0)
	TRBSZK->(DbCloseArea())
EndIf
*/

RestArea(aArea)

Return cFil