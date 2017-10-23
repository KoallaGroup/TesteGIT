#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"
                                                                                                             
/*
+-----------+---------+-------+---------------------------------------+------+------------+
| Programa  | IFINR08 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Junho/2014 |
+-----------+---------+-------+---------------------------------------+------+------------+
| Descricao | Relatorio de titulos por cliente (Crystal)								  |
+-----------+-----------------------------------------------------------------------------+
| Uso       | ISAPA																		  |
+-----------+-----------------------------------------------------------------------------+
*/

User Function IFINR08()
Local aPergs	:= {}
Local cParams	:= ""
Local cRefIni	:= ""
Local cRefFim	:= ""
Local _cQuery 	:= ""
Local n 		:= 0
Local aStru		:= {005,045,120,160}
Local nLinha	:= 6
Local lRet		:= .F.
Local aItens	:= {"1=PDF","2=Email"}
Local cAnexo	:= ""

Local dDtRef	:= CTOD("")
Local dVencDe	:= CTOD("")
Local dVencAte	:= CTOD("")
Local dDtEmi	:= CTOD("")
Local cZonaDe 	:= space(TamSx3("A1__REGTRP")[1])
Local cZonaAte 	:= space(TamSx3("A1__REGTRP")[1])
Local cCliDe	:= space(TamSx3("A1_COD")[1])
Local cCliAte	:= space(TamSx3("A1_COD")[1])
Local cLojDe	:= space(TamSx3("A1_LOJA")[1])
Local cLojAte	:= space(TamSx3("A1_LOJA")[1])
Local nList		:= " "        
Local cText1
Local cText2

Private cPerg	:= PADR("IFINR08",Len(SX1->X1_GRUPO))  
Private aSx1	:= {}
Private oDlgTMP
Private oCombo1

//                  1             2  3    4      5   6 						 7 8  9  10     11     12 13 14 15 16 17 18 19 20 21 22 23 24 25        						 36
Aadd(aPergs,{"Data Referencia"	,"","","mv_ch1","D",08						,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Vencimento De"	,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Vencimento Ate"	,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Zona De"	    	,"","","mv_ch4","C",TamSx3("A1__REGTRP")[1]	,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","GU9","","","",""})
Aadd(aPergs,{"Zona Ate" 		,"","","mv_ch5","C",TamSx3("A1__REGTRP")[1] ,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","GU9","","","",""})
Aadd(aPergs,{"Cliente De"		,"","","mv_ch6","C",TamSx3("A1_COD")[1]		,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Cliente Ate" 		,"","","mv_ch7","C",TamSx3("A1_COD")[1]		,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Loja De"			,"","","mv_ch8","C",TamSx3("A1_LOJA")[1]	,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Loja Ate" 		,"","","mv_ch9","C",TamSx3("A1_LOJA")[1]	,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Tipo" 		    ,"","","mv_cha","C",01						,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)
dDtRef		:= MV_PAR01 
dVencDe		:= MV_PAR02 
dVencAte	:= MV_PAR03 
dDtEmi		:= MV_PAR01
cZonaDe 	:= MV_PAR04
cZonaAte 	:= MV_PAR05
cCliDe		:= MV_PAR06
cCliAte		:= MV_PAR07
cLojDe		:= MV_PAR08
cLojAte		:= MV_PAR09
nList		:= MV_PAR10       

DEFINE MSDIALOG oDlgTMP TITLE "Relatorio de Extrato de Titulos por Cliente" FROM 0,0 TO 440,500 PIXEL
oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1] Say "Dt Referencia" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet dDtRef 					 Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Dt Emissao" 		 		 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet dDtEmi 					 Size 040,010 of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Vencimento de" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet dVencDe 				 Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Vencimento Ate" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet dVencAte 				 Size 040,010 of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Zona de" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cZonaDe 		F3 "GU9" Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Zona Ate" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cZonaAte 		F3 "GU9" Size 040,010 of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Cliente de" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cCliDe 			F3 "SA1LIK" Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Loja De" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cLojDe	 		F3 "SA1LIK" Size 040,010 of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Cliente Ate" 			 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet cCliAte			F3 "SA1LIK" Size 040,010 of oDlgTMP PIXEL
@ nLinha,aStru[3] Say "Loja Ate" 				 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet cLojAte 		F3 "SA1LIK" Size 040,010 of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Tipo" 					 SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MSCOMBOBOX oCombo1 VAR nList ITEMS aItens SIZE 100, 010 OF oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Texto" 			SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] Get cText1 MEMO 		SIZE 200,040 of oDlgTMP PIXEL
nLinha += 50

@ nLinha,aStru[1] Say "Texto" 			SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] Get cText2 MEMO 		SIZE 200,040 of oDlgTMP PIXEL
nLinha += 50

@ nLinha,060 	  Button "Confirmar" 	ACTION {|| lRet := .T.,oDlgTMP:End()} SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,160	  Button "Cancelar" 	ACTION {|| oDlgTMP:End()} SIZE 040,010 of oDlgTMP PIXEL

ACTIVATE MSDIALOG oDlgTMP CENTERED


If lRet              
	AADD(aSx1,;
		 {DTOS(dDtRef),;
		 DTOS(dVencDe),;
		 DTOS(dVencAte),;
		 cZonaDe,;
		 cZonaAte,;
		 cCliDe,;
		 cCliAte,;
		 cLojDe,;
		 cLojAte,;
		 alltrim(nList)})
	GravaSx1()

	If(select("TRB_SA1") > 0)
		TRB_SA1->(DbCloseArea())
	EndIf
	
	_cQuery += "SELECT *                                                         "
	_cQuery += "FROM " + retSqlname("SA1") + " SA1                               "
	_cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' AND                                   "
	_cQuery += "SA1.A1__REGTRP BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	_cQuery := ChangeQuery(_cQuery)
	TcQuery _cQuery New Alias "TRB_SA1"
	
	DbSelectArea("TRB_SA1")
	While !(eof())
		n++
		
		cParams := TRB_SA1->A1_COD + TRB_SA1->A1_LOJA + ";"
		cParams += DTOS(MV_PAR02) + ";" 			//Vencimento De
		cParams += DTOS(MV_PAR03) + ";" 			//Vencimento Ate
		cParams += DTOS(FirstDay(dDtRef)) + ";" 	//Primeiro dia do mes da Data  de Referencia
		cParams += DTOS(LastDay(dDtRef))			//Ultimo dia do mes da Data  de Referencia
		
		cOptions := "6;0;1;Titulos\Extrato_" + alltrim(TRB_SA1->A1_COD) + TRB_SA1->A1_LOJA + "_" + DTOS(Date())
		cAnexo	 := "\Relatorios\" + Substr(cOptions,7) + ".pdf"
		

			CallCrys('IFINCR01', cParams,cOptions)
		If(nList == "2")
//			U_IGENM02("rubenscruz88@gmail.com","Teste extrato","testando",cAnexo,"smtp.anadi.com.br:587","rubenscruz@anadi.com.br","",.T.) //cPara, cAssunto, cCorpo, cAnexo,cServer,cAccount,cPassword,lAutentica
		EndIf
		
		sleep(3000)
		DbSkip()
	EndDo
	
	TRB_SA1->(dbCloseArea())
	
EndIf

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
