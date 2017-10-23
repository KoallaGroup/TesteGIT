#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+-----------+---------+-------+---------------------------------------+------+--------------+
| Programa  | ICOMR06 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Outubro/2014 |
+-----------+---------+-------+---------------------------------------+------+--------------+
| Descricao | Emissão de Catálogo de BIKE (Crystal)	        							    |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/

User Function ICOMR06()
Local _cArea	:= getArea()
Local _lRet		:= .F.
Local cPath		:= alltrim(GetMV("MV__SB1IMG"))
Local aItens	:= {"1=Catálogo",;
					"2=Índice"}
Local nLinha	:= 5
Local cParams	:= "" 
Local cOptions  := "1;0;1;Catálogo de Produtos - Bike"
Local aStru		:= {010,065,115}
Local _cQuery	:= ""
Local nTotal	:= 0 
Local nQtPag	:= 4
Local nCol2		:= 0
Local nCol4		:= 0
Local _aCpo		:= {"Z8_COD","Z8_DESCRI","Z8_SEQUEN"}
Local _cQuery	:= "" 
Local _cTitulo	:= "Seleção de Identificações"
Local _cIdent	:= ""

Private _dRef		:= CTOD("  /  /    ")
Private _cSeg		:= "1 "//Space(TAMSX3("Z7_CODIGO")[1])
Private _cNmSeg		:= Posicione("SZ7",1,xFilial("SZ7")+'1 ',"Z7_DESCRIC")
Private _cTipo		:= " "

_cQuery	:= "SELECT Z8_COD,Z8_DESCRI, Z8_SEQUEN 		" + Chr(13)
_cQuery	+= "FROM " + RetSqlName("SZ8") + " SZ8 		" + Chr(13)
_cQuery	+= "WHERE SZ8.D_E_L_E_T_ = ' '         		" + Chr(13)
_cQuery	+= "	  AND SZ8.Z8_COLUNA IN ('2','4')    " + Chr(13)
_cQuery	+= "	  AND SZ8.Z8_SEGISP = '1 '          " + Chr(13)
_cQuery	+= "	  AND SZ8.Z8_IMPLP != '2'           " + Chr(13)
_cQuery	+= "ORDER BY Z8_COD ASC         	   		"   
 
DEFINE MSDIALOG oDlgTMP TITLE "Emissão de Catálogo Isapa" FROM 0,0 TO 185,420 PIXEL
oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1] Say "Data de Referência" 		SIZE 070,010 OF oDlgTMP PIXEL 
@ nLinha,aStru[2] MsGet _dRef	 				Size 040,010 OF oDlgTMP PIXEL WHEN _cTipo == '1'
@ nLinha,aStru[3] Button "Identificações" 		SIZE 040,010 OF oDlgTMP PIXEL ACTION {|| _cIdent := U_IGENM18(_aCpo,,_cQuery,_cTitulo)  }  
nLinha += 16

@ nLinha,aStru[1] Say "Segmento" 	 			SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet _cSeg 					Size 020,010 OF oDlgTMP PIXEL F3 "SZ7" VALID (Vazio() .OR. ValSeg()) WHEN .F. //_cTipo == '1'
@ nLinha,aStru[3] MsGet _cNmSeg 				Size 050,010 OF oDlgTMP PIXEL WHEN .F.
nLinha += 16

@ nLinha,aStru[1] Say "Tipo de Impressão" 		SIZE 070,010 OF oDlgTMP PIXEL 
@ nLinha,aStru[2] MSCOMBOBOX oCombo1 VAR _cTipo ITEMS aItens SIZE 060, 010 OF oDlgTMP PIXEL
nLinha += 26    

@ nLinha,040 	  Button "Confirmar" 		ACTION {|| _lRet := .T.,oDlgTMP:End()  } 	SIZE 040,015 OF oDlgTMP PIXEL
@ nLinha,130	  Button "Cancelar" 		ACTION {|| oDlgTMP:End() } 	SIZE 040,015 of oDlgTMP PIXEL

ACTIVATE MSDIALOG oDlgTMP CENTERED                            

If !_lRet 
	Return
EndIf
If (Empty(_cIdent) .AND. _cTipo == '1') 
	Alert("Nenhuma identificação selecionada") 
	Return
EndIf

_cIdent := FormatIn(_cIdent,";")

//Grava a ultima pagina das identificacoes antes de gerar o relatório

If Select("TR_SZ8") > 0
		TRB_SZ8->(DbCloseArea())
EndIf

_cQuery	:= "SELECT SZ9.Z9_COD,                                                             " + Chr(13)
_cQuery	+= "       SZ8.Z8_DESCRI,                                                          " + Chr(13)
_cQuery	+= "       SZ8.Z8_COLUNA,                                                          " + Chr(13)
_cQuery	+= "       COUNT(SZ9.Z9_PRODUTO) AS QUANT                                          " + Chr(13)
_cQuery	+= "FROM " + retSqlname("SZ9") + " SZ9                                             " + Chr(13)
_cQuery	+= "INNER JOIN " + retSqlname("SB1") + " SB1 ON SB1.B1_FILIAL = '  '               " + Chr(13)
_cQuery	+= "                         AND SB1.B1_COD = SZ9.Z9_PRODUTO                       " + Chr(13)
_cQuery	+= "                         AND SB1.D_E_L_E_T_ = ' '                              " + Chr(13)
_cQuery	+= "                         AND SB1.B1_MSBLQL <> '1'                              " + Chr(13)
_cQuery	+= "                         AND SB1.B1_ATIVO = 'S'	                               " + Chr(13)
_cQuery	+= "INNER JOIN " + retSqlname("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = SZ9.Z9_FILIAL AND  " + Chr(13)
_cQuery	+= "                         SZ8.Z8_COD = SZ9.Z9_COD AND                           " + Chr(13)
_cQuery	+= "                         SZ8.Z8_MSBLQL <> '1' AND                              " + Chr(13)
_cQuery	+= "                         SZ8.D_E_L_E_T_ = ' '                                  " + Chr(13)
/*_cQuery	+= "INNER JOIN " + retSqlname("DA1") + " DA1 ON DA1.DA1_FILIAL = '  '              " + Chr(13)
_cQuery	+= "                         AND DA1.DA1_CODPRO = SB1.B1_COD                       " + Chr(13)
//_cQuery	+= "                         AND DA1.DA1_DATVIG <= TO_CHAR(SYSDATE,'YYYYMMDD')     " + Chr(13)
_cQuery	+= "                         AND DA1.DA1_ESTADO = ' '                              " + Chr(13)
_cQuery	+= "                         AND DA1.D_E_L_E_T_ = ' '                              " + Chr(13)
_cQuery	+= "                                                  AND DA1.DA1_DATVIG = (SELECT MAX(DA1.DA1_DATVIG)                                 " + Chr(13)
_cQuery	+= "                                                                         FROM " + retSqlname("DA1") + " DA1                        " + Chr(13)
_cQuery	+= "                                                                         WHERE DA1.D_E_L_E_T_ = ' '                                " + Chr(13)
_cQuery	+= "                                                                               AND DA1.DA1_CODPRO = SB1.B1_COD                     " + Chr(13)
_cQuery	+= "                                                                               AND  DA1.DA1_DATVIG <= TO_CHAR(SYSDATE,'YYYYMMDD')  " + Chr(13)
_cQuery	+= "                                                                               AND DA1.DA1_ESTADO = '  ') "*/
_cQuery	+= "WHERE SZ9.D_E_L_E_T_ = ' ' AND                                                 " + Chr(13)
_cQuery	+= "      SZ8.Z8_SEGISP = '" + _cSeg + "'                                          " + Chr(13)
_cQuery	+= "      AND SZ8.Z8_IMPLP != '2'	                           				   	   " + Chr(13)
_cQuery	+= "      AND SZ9.Z9_MSBLQL <> '1'                               				   " + Chr(13)
_cQuery	+= "      AND SZ9.Z9_TIPO = '1'	                               				   	   " + Chr(13)
_cQuery	+= "      AND SZ9.D_E_L_E_T_ = ' '                            				   	   " + Chr(13)
_cQuery	+= "      AND SZ8.Z8_COLUNA IN ('2','4')                                           "
If(_cTipo == '1')
	_cQuery	+= "     AND SZ8.Z8_COD IN " + _cIdent + "             						   " + Chr(13)
EndIf
_cQuery	+= "GROUP BY SZ9.Z9_COD, SZ8.Z8_COLUNA,SZ8.Z8_DESCRI                               "
TcQuery _cQuery New Alias "TRB_SZ8"

DbSelectArea("SZ8")
DbSetOrder(1)

while TRB_SZ8->(!eof())
	nTotal := Ceiling(TRB_SZ8->QUANT / (TRB_SZ8->Z8_COLUNA * nQtPag))

	Do Case
		Case (TRB_SZ8->Z8_COLUNA = 2)
			nCol2++
		Case (TRB_SZ8->Z8_COLUNA = 4)
			nCol4++
	EndCase
	
	MSSeek(xFilial("SZ8")+TRB_SZ8->Z9_COD)		
	Reclock("SZ8",.F.)
		Z8_CATPAG := padL(Alltrim(Str(nTotal)),3,"0")
	MsUnlock()

	TRB_SZ8->(dbSkip())
EndDo

cParams := DTOS(_dRef) + ';' // Data de referencia
cParams += _cIdent + ';'	 // Identificações formatadas para In de Query
cParams += _cSeg + ';'    	 // Segmento
      
If(_cTipo == '1')
	cParams += cPath
	
	If(nCol2 > 0)
		CallCrys('ICOMCR06B', cParams,cOptions)
	EndIf 
	If(nCol4 > 0)
		CallCrys('ICOMCR06A', cParams,cOptions)
	EndIf
Else
	CallCrys('ICOMCR06C', cParams,cOptions)
EndIf  


TRB_SZ8->(DbCloseArea())
RestArea(_cArea)

Return                          

/*
+-----------+---------+-------+---------------------------------------+------+---------------+
| Programa  | ValSeg  | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Dezembro/2014 |
+-----------+---------+-------+---------------------------------------+------+---------------+
| Descricao | Valida Segmento selecionado												     |
+-----------+--------------------------------------------------------------------------------+
| Uso       | ISAPA																		     |
+-----------+--------------------------------------------------------------------------------+
*/

Static Function ValSeg()
Local lRet 		:= .T.
Local _aArea 	:= GetArea()

DbSelectArea("SZ7")
If DbSeek(xFilial("SZ7")+_cSeg)
	_cNmSeg := SZ7->Z7_DESCRIC
Else     
	_cNmSeg := ""
	lret 	:= .F.
EndIf

RestArea(_aArea)

Return lRet  
