#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"
                                                                                                             
/*
+-----------+---------+-------+---------------------------------------+------+------------+
| Programa  | IFATR02 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Junho/2014 |
+-----------+---------+-------+---------------------------------------+------+------------+
| Descricao | Relatorio de lista de preço Auto (Crystal)								  |
+-----------+-----------------------------------------------------------------------------+
| Uso       | ISAPA																		  |
+-----------+-----------------------------------------------------------------------------+
*/

User Function IFATR02()
Local aPergs	:= {}    
Local cParams	:= ""
Local cRefIni	:= ""
Local cRefFim	:= ""
Local _cQuery 	:= ""
Local n 		:= 0
Local aStru		:= {005,055,130,180}
Local aStru2	:= {005,055,150,210,230,310}
Local nLinha	:= 6
Local lRet		:= .F.                               
Local aItens	:= {"1=Marca",;
					"2=Identificação"}
Local aLista	:= {}

Local nList		:= " "        
Local nList2	:= " "             
Local dBaseCod	:= CTOD("")
Local cSeg		:= space(TamSx3("Z7_CODIGO")[1])
Local cIdenDe	:= space(TamSx3("Z8_COD")[1])
Local cIdenAte	:= space(TamSx3("Z8_COD")[1])
Local cMarcDe	:= space(TamSx3("Z5_CODIGO")[1])
Local cMarcAte	:= space(TamSx3("Z5_CODIGO")[1])
Local cTitulo	:= space(30)
Local nDesc		:= 0
Local nCount	:= 0

Private cPerg		:= PADR("IFATR02",Len(SX1->X1_GRUPO))  
Private aSx1		:= {}
Private oDlgTMP
Private oCombo1
Private oCombo2
Private oChkMar1
Private oChkMar2
Private oChkMar3
Private oChkMar4
Private oFont14	   	:= tFont():New("Tahoma",,-14,,.t.)
Private lChk1		:= .F.      
Private lChk2		:= .F.      
Private lChk3		:= .F.      
Private lChk4		:= .F.      

//                  1             2  3    4      5   6 						 7 8  9  10     11     12 13 14 15 16 17 18 19 20 21 22 23 24 25        						 36
Aadd(aPergs,{"Lista 1"			,"","","mv_ch1","C",01						,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Data Base"		,"","","mv_ch2","D",08						,00,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Segmento"	    	,"","","mv_ch3","C",TamSx3("Z7_CODIGO")[1]	,00,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","GU9","","","",""})
Aadd(aPergs,{"Identificacao De"	,"","","mv_ch4","C",TamSx3("Z8_COD")[1] 	,00,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","GU9","","","",""})
Aadd(aPergs,{"Identificacao Ate","","","mv_ch5","C",TamSx3("Z8_COD")[1]		,00,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Marca De" 		,"","","mv_ch6","C",TamSx3("Z5_CODIGO")[1]	,00,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Marca Ate"		,"","","mv_ch7","C",TamSx3("Z5_CODIGO")[1]	,00,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Titulo" 			,"","","mv_ch8","C",30						,00,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Desconto"		    ,"","","mv_ch9","N",05						,02,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)
nList		:= MV_PAR01        
dBaseCod	:= MV_PAR02
cSeg		:= MV_PAR03 //space(TamSx3("Z7_CODIGO")[1]
cIdenDe		:= MV_PAR04 //space(TamSx3("Z8_COD")[1])
cIdenAte	:= MV_PAR05 //space(TamSx3("Z8_COD")[1])
cMarcDe		:= MV_PAR06 //space(TamSx3("Z5_CODIGO")[1])
cMarcAte	:= MV_PAR07 //space(TamSx3("Z5_CODIGO")[1])
cTitulo		:= MV_PAR08 //space(30)
nDesc		:= MV_PAR09

If(select("TRB_ZX5") > 0)
	TRB_ZX5->(DbCloseArea())
EndIf
	
_cQuery := "SELECT ROWNUM AS SEQ,                 "
_cQuery += "		 ZX5_DSCGRP,                  "
_cQuery += "       ZX5_DSCITE                     "
_cQuery += "FROM " + retSqlname("ZX5") + " ZX5    "
_cQuery += "WHERE ZX5_GRUPO = '000007' AND        "
_cQuery += "      ZX5_SEGISP = '" + cSeg + "' AND "
_cQuery += "      ZX5.D_E_L_E_T_ = ' '            "
_cQuery += "ORDER BY ZX5_CODIGO                   " 

TCQUERY _cQuery NEW ALIAS "TRB_ZX5"

DbSelectArea("TRB_ZX5")

While(!eof())
	nCount += 1
		
	AADD(aLista,{nCount,;
	 				 TRB_ZX5->ZX5_DSCGRP,;
	 				 TRB_ZX5->ZX5_DSCITE}) 

/*	AADD(aLista,{TRB_ZX5->SEQ,;
	 				 TRB_ZX5->ZX5_DSCGRP,;
	 				 TRB_ZX5->ZX5_DSCITE}) */
	 				 
	DbSkip()
EndDo

DbCloseArea()

//Primeira janela de parametros
DEFINE MSDIALOG oDlgTMP TITLE "Emissão de Lista de Preço" FROM 0,0 TO 500,500 PIXEL
oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1] Say "Tipo de Lista"			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MSCOMBOBOX oCombo1 VAR nList ITEMS aItens SIZE 060, 010 OF oDlgTMP PIXEL 
          
@003,002 To nLinha+17,250 PIXEL
nLinha += 25

@nLinha-5,002 To nLinha+80,250 PIXEL
@ nLinha,aStru2[1] Say "Colunas de Preço"			 SIZE 080,010 OF oDlgTMP PIXEL FONT oFont14 
nLinha += 16

@ nLinha,aStru2[1] Say "Tabela da Coluna 1" 	 				SIZE 080,010 OF oDlgTMP PIXEL 
@ nLinha,aStru2[2] MsGet aLista[1][2]			 				Size 080,010 of oDlgTMP PIXEL WHEN .F.
@ nLinha,aStru2[3] CheckBox oChkMar1 Var lChk1  Prompt "Imprime ?" Size 035,007 Of oDlgTMP PIXEL 
oChkMar1:bGotFocus := {|| ValChkBox(lChk1,1) }
nLinha += 16

@ nLinha,aStru2[1] Say "Tabela da Coluna 2" 	 				SIZE 080,010 OF oDlgTMP PIXEL 
@ nLinha,aStru2[2] MsGet aLista[2][2]			 				Size 080,010 of oDlgTMP PIXEL WHEN .F.
@ nLinha,aStru2[3] CheckBox oChkMar2 Var lChk2  Prompt "Imprime ?" Size 035,007 Of oDlgTMP PIXEL VALID (ValChkBox(lChk2,2))  
oChkMar2:bGotFocus := {|| ValChkBox(lChk2,2) }
nLinha += 16

@ nLinha,aStru2[1] Say "Tabela da Coluna 3" 	 				SIZE 080,010 OF oDlgTMP PIXEL 
@ nLinha,aStru2[2] MsGet aLista[3][2]			 				Size 080,010 of oDlgTMP PIXEL WHEN .F.
@ nLinha,aStru2[3] CheckBox oChkMar3 Var lChk3  Prompt "Imprime ?" Size 035,007 Of oDlgTMP PIXEL VALID (ValChkBox(lChk3,3))  
oChkMar3:bGotFocus := {|| ValChkBox(lChk3,3) }
nLinha += 16

@ nLinha,aStru2[1] Say "Tabela da Coluna 4" 	 				SIZE 080,010 OF oDlgTMP PIXEL 
@ nLinha,aStru2[2] MsGet aLista[4][2]			 				Size 080,010 of oDlgTMP PIXEL WHEN .F.
@ nLinha,aStru2[3] CheckBox oChkMar4 Var lChk4  Prompt "Imprime ?" Size 035,007 Of oDlgTMP PIXEL VALID (ValChkBox(lChk4,4)) 
oChkMar4:bGotFocus := {|| ValChkBox(lChk4,4) }
nLinha += 26

@nLinha-5,002 To nLinha+70,250 PIXEL

@ nLinha,aStru[1] Say "Data Base" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet dBaseCod 			 Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Segmento" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cSeg 				 	 Size 020,010 F3 "SZ7" of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Identificação De" 	 SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cIdenDe 				 Size 040,010 F3 "SZ8" of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Identificação Até"  SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cIdenAte				 Size 040,010 F3 "SZ8" of oDlgTMP PIXEL
nLinha += 16    

@ nLinha,aStru[1] Say "Marca De" 	 		 SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cMarcDe 				 Size 040,010 F3 "SZ5" of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Marca Até"  			 SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cMarcAte				 Size 040,010 F3 "SZ5" of oDlgTMP PIXEL
nLinha += 16    

@ nLinha,aStru[1] Say "Título" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cTitulo 				 Size 100,010 of oDlgTMP PIXEL
@ nLinha,170	 	Say "Desconto (%)" 		 SIZE 100,010 OF oDlgTMP PIXEL
@ nLinha,210 		MsGet nDesc	 				 Size 030,010 of oDlgTMP PICTURE "@E 999.99" PIXEL
nLinha += 30

@ nLinha,060 	  Button "Confirmar" 	ACTION {|| lRet := .T.,oDlgTMP:End()} SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,160	  Button "Cancelar" 	ACTION {|| oDlgTMP:End()} SIZE 040,010 of oDlgTMP PIXEL

ACTIVATE MSDIALOG oDlgTMP CENTERED

If !lRet
	return
EndIf

cParams := cSeg + ";"  					//Segmento
cParams += DTOS(dBaseCod) + ";" 		//Data Base
cParams += cMarcDe + ";" 				//Marca De
cParams += cMarcAte + ";" 				//Marca Ate
cParams += cIdenDe + ";"				//Identificacao De
cParams += cIdenAte + ";"				//Identificacao Ate
cParams += alltrim(str(nDesc)) + ";"	//Desconto        
cParams += cTitulo + ";"				//Titulo 
cParams += IIF(lChk1,"1","2") + ";"		//Preco 1
cParams += IIF(lChk2,"1","2") + ";"		//Preco 2
cParams += IIF(lChk3,"1","2") + ";"		//Preco 3
cParams += IIF(lChk4,"1","2") 			//Preco 4

cOptions := "1;0;1;Emissão de Lista de Preço"
	
Do Case
	Case nList == "1"
			CallCrys('IFATCR03A', cParams,cOptions)
	Case nList == "2"
			CallCrys('IFATCR03B', cParams,cOptions)
	Case nList == "3"
EndCase

AADD(aSx1,;
	 {nList,;
	 DTOS(dBaseCod),;
	 cSeg,;
	 cIdenDe,;
	 cIdenAte,;
	 cMarcDe,;
	 cMarcAte,;
	 cTitulo,;
	 alltrim(str(nDesc))})
GravaSx1()

Return .T.

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | GravaSX1 | Autor | Rubens Cruz - Anadi Soluções 		   | Data | Julho/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Grava valores na SX1														   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA		  																   |
+-----------+------------------------------------------------------------------------------+
*/

Static Function GravaSx1()
Local nX := 1

Dbselectarea("SX1")
DbsetOrder(1)
If Dbseek(cPerg+"01")
	Do While ( !(Eof()) .AND. SX1->X1_GRUPO == cPerg )
		Reclock("SX1",.F.)
		SX1->X1_CNT01:= aSX1[1][nX]
		SX1->(MsUnlock())
		nX++
		DbSkip()
	EndDo
EndIf

Return
                               

/*
+-----------+-----------+-------+---------------------------------------+------+---------------+
| Programa  | ValChkBox | Autor | Rubens Cruz - Anadi Soluções 		    | Data | Dezembro/2014 |
+-----------+-----------+-------+---------------------------------------+------+---------------+
| Descricao | Grava valores na SX1														       |
+-----------+----------------------------------------------------------------------------------+
| Uso       | ISAPA		  																   	   |
+-----------+----------------------------------------------------------------------------------+
*/

Static Function ValChkBox(lParam,_nChk)
If !lParam
	Do Case
		Case (_nChk = 1)
			lChk2 := .F.
			lChk3 := .F.
			lChk4 := .F.
		Case (_nChk = 2)
			lChk1 := .F.
			lChk3 := .F.
			lChk4 := .F.
		Case (_nChk = 3)
			lChk1 := .F.
			lChk2 := .F.
			lChk4 := .F.
		Case (_nChk = 4)
			lChk1 := .F.
			lChk2 := .F.
			lChk3 := .F.
	EndCase
EndIf

Return