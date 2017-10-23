#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "HBUTTON.CH" 
#INCLUDE "TOTVS.CH"
#Include "Colors.ch"

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP02 | Autor | Rubens Cruz - Anadi Soluções 		   | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Gravacao dos dados no cadastro de identificacoes (SZ8)					   | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/           

User Function IFINP02I(aCols)           
Local nX	:= 1

For nX := 1 To Len(aCols)
    If(!aCols[nX][len(aCols[nX])]) 
		reclock("SZ8",.T.)
			SZ8->Z8_COD 	:= aCols[nX][1]
			SZ8->Z8_DESCRI	:= aCols[nX][2]
			SZ8->Z8_ABREV	:= aCols[nX][3]
			SZ8->Z8_ORDEM	:= aCols[nX][4]
			SZ8->Z8_MSBLQL	:= aCols[nX][5]
			SZ8->Z8_IMPLP  	:= aCols[nX][6]
			SZ8->Z8_PROMOC 	:= aCols[nX][7]
			SZ8->Z8_SEGISP	:= U_SETSEGTO()
//			SZ8->Z8_COLUNA	:= aCols[nX][8]
//			SZ8->Z8_PRIMPAG	:= aCols[nX][9]
//			SZ8->Z8_ULTPAG	:= aCols[nX][10]
		msUnlock()
    EndIf
Next nX

Return     

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP02P | Autor | Rubens Cruz - Anadi Soluções 	       | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Gravacao dos produtos na identificação				                       | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/           

User Function IFINP02P(aCols)           
Local nX			:= 1                          
Local _nPos_Tipo	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_TIPO" 	})
Local _nPos_Prod	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_PRODUTO" })
Local _nPos_Sufr	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_SUFRAMA"	})
Local _nPos_Desc	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_DESCRI" 	})
Local _nPos_Bloq	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_MSBLQL" 	})
Local _nPos_Pcat	:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_PAGCAT" 	})
Local _nPos_Seq		:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_SEQ" 	})
Local _nPos_Recno	:= len(oGetD:aHeader)
Local nLinInc		:= ASCAN(aCols, { |x| x[_nPos_Recno] = 0 })
Local nLinDel		:= ASCAN(aCols, { |x| x[Len(oGetD:aHeader)+1] = .T. })
Local nLinCont		:= 0
Local _cSeq			:= ""
Local nPag			:= 1
Local nPagCont		:= 0

// Ordena o Sequencial dos componentes
//aCols 	:= U_IFINP01K(aCols)
//_nPos_Seq:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_SEQ" 	})

//Verifica primeira alteração na lista (item deletado ou incluido)
If nLinInc > 0 .AND. nLinDel > 0 
	If nLinInc < nLinDel
		nLinCont := nLinInc
	Else
		nLinCont := nLinDel
	EndIf
ElseIf nLinInc > 0
	nLinCont := nLinInc
ElseIf nLinDel > 0 
	nLinCont := nLinDel
EndIf

//Recalcula sequencia dos itens no aCols
If nLinCont > 0
	_cSeq	:= IIF(nLinCont = 1,PadL('0',TamSX3('Z9_SEQ')[1],'0'),aCols[nLinCont-1][_nPos_Seq])
	For nX := nLinCont To Len(aCols)
		If(!aCols[nX][len(oGetD:aHeader)+1]) 
			aCols[nX][_nPos_Seq]	:= _cSeq := Soma1(_cSeq) 
		EndIf	
	Next nX
EndIf

//Recalcula sequencia de paginas no aCols
If nLinCont > 0
	For nX := 1 To Len(aCols)
		If(!aCols[nX][len(oGetD:aHeader)+1]) 
			If(Alltrim(aCols[nX][_nPos_Tipo]) == '1')
				nPagCont += 2
			Else
				nPagCont += 1
			EndIf            
			
			If(nPagCont > 40)
				nPag += 1
				nPagCont := 2
			EndIf

			aCols[nX][_nPos_Pcat] := StrZero(nPag,4,0)

		EndIf	   
	Next nX
EndIf                   

DbSelectArea("SZ9")

For nX := 1 To Len(aCols)
	if(aCols[nX][_nPos_Prod] != "")
		If(aCols[nX][_nPos_Recno] == 0)   
		    If(!aCols[nX][len(oGetD:aHeader)+1]) 
				reclock("SZ9",.T.)
					SZ9->Z9_COD 	:= SZ8->Z8_COD
					SZ9->Z9_TIPO	:= aCols[nX][_nPos_Tipo]
					SZ9->Z9_SUFRAMA	:= aCols[nX][_nPos_Sufr]
					SZ9->Z9_PRODUTO	:= aCols[nX][_nPos_Prod]
					SZ9->Z9_DESCRI	:= aCols[nX][_nPos_Desc]
					SZ9->Z9_PAGCAT	:= aCols[nX][_nPos_Pcat]
					SZ9->Z9_MSBLQL	:= aCols[nX][_nPos_Bloq]
  					SZ9->Z9_SEQ		:= aCols[nX][_nPos_Seq]
				msUnlock()
			EndIf
		Else
			If(!aCols[nX][len(oGetD:aHeader)+1]) 
			    DbGoTo(aCols[nX][_nPos_Recno])
				reclock("SZ9",.F.)
					SZ9->Z9_COD 	:= SZ8->Z8_COD
					SZ9->Z9_TIPO	:= aCols[nX][_nPos_Tipo]
					SZ9->Z9_SUFRAMA	:= aCols[nX][_nPos_Sufr]
					SZ9->Z9_PRODUTO:= aCols[nX][_nPos_Prod]
					SZ9->Z9_DESCRI	:= aCols[nX][_nPos_Desc]
					SZ9->Z9_PAGCAT	:= aCols[nX][_nPos_Pcat]
					SZ9->Z9_MSBLQL	:= aCols[nX][_nPos_Bloq]
					SZ9->Z9_SEQ		:= aCols[nX][_nPos_Seq]
				msUnlock()
			Else
		   		DbGoTo(aCols[nX][_nPos_Recno])
					reclock("SZ9",.F.)
						delete
					msUnlock()	
		    EndIf
		EndIf 	 
	EndIf
Next nX 

Return      

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP02R | Autor | Rubens Cruz - Anadi Soluções 	       | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Gravacao dos representantes na identificação				                   | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/           

User Function IFINP02R(aCols)           
Local nX	:= 1

DbSelectArea("SZ9")

For nX := 1 To Len(aCols)
	If(aCols[nX][3] == 0)   
	    If(!aCols[nX][4]) 
			reclock("SZ9",.T.)
				SZ9->Z9_COD 	:= SZ8->Z8_COD
				SZ9->Z9_VEND	:= aCols[nX][1]
			msUnlock()
		EndIf
	Else
		If(!aCols[nX][4]) 
		    	DbGoTo(aCols[nX][3])
				reclock("SZ9",.F.)
					SZ9->Z9_COD 	:= SZ8->Z8_COD
					SZ9->Z9_VEND	:= aCols[nX][1]
				msUnlock()
		Else
	   		DbGoTo(aCols[nX][3])
				reclock("SZ9",.F.)
					delete
				msUnlock()	
	    EndIf
	EndIf 	 
Next nX 

Return

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP02A | Autor | Rubens Cruz - Anadi Soluções 	       | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Alteração dos dados da SZ8				                   | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/             
                         
User Function IFINP02A()  
Local cCod := SZ8->Z8_COD

AxAltera("SZ8",SZ1->(Recno()),4,,,,,'cCodNew := SZ8->Z8_COD')  

if (cCod != cCodNew) 
	dbSelectArea("SZ9")
	dbSetOrder(1)          
	dbSeek(xFilial("SZ9") + cCod) 
		While ! Eof() .AND. SZ9->Z9_COD == cCod
			if(reclock("SZ9", .F.))
				SZ9->Z9_COD	:= cCodNew
				MsUnlock()
			EndIf 
		EndDo
EndIf

Return .t.     

