#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#INCLUDE 'COLORS.CH'

/*
+-------------+---------+--------+--------------------+-------+---------------+
| Programa:   | IGENM18 | Autor: | Rubens Cruz        | Data: | Dezembro/2014 |
+-------------+---------+--------+--------------------+-------+---------------+
| Descrição:  | Consulta para selecionar as identificacoes e retorna uma      |
|			  | string com a seleção               							  |
+-------------+---------------------------------------------------------------+
| Uso:        | Isapa                                                         |
+-------------+---------------------------------------------------------------+
| Parametros: | _aHeaderCpo := Array contendo  os campos que serão exibidos	  |
|			  | _cChave		:= Campos que será usado para o retorno			  |
|			  | _cQuery		:= Query para o preenchimento do MarkBrowse		  |
|			  | _cTitulo	:= Titulo da janela                               |
+-------------+---------------------------------------------------------------+
*/

User Function IGENM18(_aHeaderCpo,_cChave,_cQuery,_cTitulo)
Local aSize 		:= {}
Local aObjects 		:= {}
Local aInfo 		:= {}
Local aPosObj		:= {}
Local _lRet 		:= .F. 
Local bOk 			:= {||_lRet:=.T.,oDlgTMP:End()  } 
Local bCancel 		:= {|| oDlgTMP:End() 			} 
Local _aStruTrb 	:= {} //estrutura do temporario
Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
Local _cRet			:= ""

Private lInverte := .F. //Variaveis para o MsSelect
Private cMarca := "XD"//GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect
Private oDlgTMP

Default _cChave		:= _aHeaderCpo[1]
Default _cTitulo	:= "Seleção de registros"

aSize := MsAdvSize()
	
AAdd( aObjects, { 100, 100, .t., .t. } )
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3,3}
aPosObj := MsObjSize(aInfo, aObjects)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define campos do TRB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(_aStruTrb,{"OK" ,"C",02,0}) 
aadd(_aBrowse,{"OK" ,,"" })
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(_aHeaderCpo)
    If SX3->(DbSeek(_aHeaderCpo[nX]))
      Aadd(_aStruTrb, {_aHeaderCpo[nX],SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
      Aadd(_aBrowse,  {_aHeaderCpo[nX],,SX3->X3_TITULO})
    Endif
  Next nX

//aadd(_aStruTrb,{"Z8_COD" 	,"C",06,0})
//aadd(_aStruTrb,{"Z8_DESCRI" ,"C",02,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define campos do MsSelect ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//aadd(_aBrowse,{"Z8_COD",,"Codigo" })
//aadd(_aBrowse,{"Z8_DESCRI",,"Loja" })

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)

dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

//Aqui você monta sua query que serve para gravar os dados no arquivo temporario...

TCQuery _cQuery new Alias (cAlias:=GetNextAlias())

While (cAlias)->(!Eof())
	
	RecLock("TRB",.T.)
	
	TRB->OK := space(2)
	For nX := 1 To Len(_aHeaderCpo)
		TRB->&(_aHeaderCpo[nX]) := (cAlias)->&(_aHeaderCpo[nX]) 
    Next nX
	
	MsUnlock()
	
	(cAlias)->(DbSkip())
	
Enddo

(cAlias)->(DbCloseArea())

//@ 001,001 TO 400,700 DIALOG oDlgTMP TITLE OemToAnsi("Titulos a Vencer")
	DEFINE MSDIALOG oDlgTMP TITLE _cTitulo From aSize[7],0 To aSize[6],700 OF oMainWnd PIXEL

	oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-15,350})
	
	oBrwTrb:oBrowse:lCanAllmark := .T.                        
	
	Eval(oBrwTrb:oBrowse:bGoTop)
	
	oBrwTrb:oBrowse:Refresh()
	
	@ aPosObj[1,3]-07,005	Button oButton PROMPT "Nenhum" 	 SIZE 040,015 OF oDlgTMP PIXEL ACTION (MRCDADOS(.F.)			 )
	@ aPosObj[1,3]-07,055 	Button oButton PROMPT "Todos" 	 SIZE 040,015 OF oDlgTMP PIXEL ACTION (MRCDADOS(.T.)			 )
	@ aPosObj[1,3]-07,305 	Button oButton PROMPT "Retornar" SIZE 040,015 OF oDlgTMP PIXEL ACTION (_lRet := .T.,oDlgTMP:End())

	ACTIVATE MSDIALOG oDlgTMP CENTERED 

If _lRet
	TRB->(DbGotop())
	Do While TRB->(!Eof())
		If !Empty(TRB->OK) //se usuario marcou o registro
			_cRet += TRB->&(_cChave) + ";"
		EndIf
		TRB->(DbSkip())
	EndDo
Endif

//fecha area de trabalho e arquivo temporário criados

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()

	Ferase(_cArqEmp+OrdBagExt())
Endif

If(len(_cRet) > 1)
	_cRet := Substr(_cRet,1,Len(_cRet)-1)
EndIf

Return _cRet                        

/*
+------------+----------+--------+--------------------+-------+---------------+
| Programa:  | MRCDADOS | Autor: | Rubens Cruz        | Data: | Dezembro/2014 |
+------------+----------+--------+--------------------+-------+---------------+
| Descrição: | Consulta para selecionar as identificacoes e retorna uma       |
|			 | string com a seleção               							  |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/

Static Function MRCDADOS(lMarca)
Local _cMar := IIF(lMarca,cMarca,"")

TRB->( DbGoTop() )

Do While TRB->( !EoF() )
	RecLock("TRB",.F.)
			TRB->OK := _cMar
	TRB->( MsUnlock() )
	TRB->( DbSkip() )
Enddo
		
Eval(oBrwTrb:oBrowse:bGoTop)

oBrwTrb:oBrowse:Refresh()

Return
