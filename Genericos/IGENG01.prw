#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IGENG01			  		| 	Outubro de 2014                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Alves - Anadi                                                         |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Gatilho para validar CPgto de acordo com o segmento e a operação do usuário  	|
|-----------------------------------------------------------------------------------------------|
*/                                                                                    

User Function IGENG01(cTabela)

Local cSegto 	:= ""
Local cComVen 	:= ""
Local cFiltro	:= ""                      
Local lRet 		:= .F.

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    Return .t. 
EndIf  

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	cSegto := SZ1->Z1_SEGISP
Else
	cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])	
Endif

Do Case
	//Operações de Compra
	Case 	Alltrim(Upper(funname())) $ Alltrim(Upper(GETMV("MV__OPECOM")))
			cComVen := "2"
	//Operações de Venda
	Case 	Alltrim(Upper(funname())) $ Alltrim(Upper(GETMV("MV__OPEVEN"))) 
			cComVen := "1"
EndCase 

dbSelectArea("SE4")
SE4->(dbSetorder(1))
If cTabela == "SC5"
	If dbSeek(xFilial("SE4")+M->C5_CONDPAG)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
              lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen) 
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
	    		lRet := .F.
   			EndIF	
   		EndIF
   	EndIf
ElseIF cTabela == "SC7"
	If dbSeek(xFilial("SE4")+M->C7_COND)
		If !Empty(cComVen)
		    If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
		      lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen) 
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf	
ElseIF cTabela == "SC8"
	If dbSeek(xFilial("SE4")+M->C8_COND)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
                lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen) 
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf 
ElseIF cTabela == "SCJ"
	If dbSeek(xFilial("SE4")+M->CJ_CONDPAG)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
                lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen)  
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf	  
ElseIF cTabela == "SF1"
	If dbSeek(xFilial("SE4")+M->F1_COND)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
                lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen)  
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf	
ElseIF cTabela == "SUA"
	If dbSeek(xFilial("SE4")+M->UA_CONDPG)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
                lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen) 
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf
ElseIf cTabela == "ICOMA12"
	If dbSeek(xFilial("SE4")+cPlano)
		If !Empty(cComVen)
            If Val(cSegto) == 0 .And. (SE4->E4__COMVEN == cComVen)
                lRet := .t.
   			ElseIf (SE4->E4__SEGISP == cSegto .Or. SE4->E4__SEGISP == PADR('0',TamSX3("Z1_SEGISP")[1])) .And. (SE4->E4__COMVEN == cComVen) 
	   			lRet := .T.
   			Else   
	   			MSGINFO("Favor selecionar condicao de pagamento exibida na consulta (F3).")
   			EndIF	
   		EndIF
   	EndIf
EndIf

return lRet