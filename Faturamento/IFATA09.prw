#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
                                            
/*
+-----------+---------+-------+-------------------------------------+------+----------------+
| Programa  | IFATA09 | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Marco/2014		|
+-----------+---------+-------+-------------------------------------+------+----------------+
| Descricao | Consulta de UF															    |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA													 					    |
+-----------+-------------------------------------------------------------------------------+
*/   

Static _cIFATA09I := Space(40)

User Function IFATA09()
Local cTitulo := MvParDef := _cSQL := _cTab := _cRet := "", _aCad := {}
Private _aRet := {},  _aSepara := {}

	//Filtra os Códigos das regiões
	_cTab := GetNextAlias()
	_cSQL := "Select Distinct X5_CHAVE,X5_DESCRI From " + RetSqlName("SX5") + " X5 "
	_cSQL += "Where X5_FILIAL = '" + xFilial("SX5") + "' And X5_TABELA = '12' And X5.D_E_L_E_T_ = ' ' "
	_cSQL += "Order By X5_CHAVE"

	If Select(_cTab) > 0
		DbSelectArea(_cTab)
		DbCloseArea()
	EndIf	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
	
	DbSelectArea(_cTab)
	DbGoTop()
	
	While !Eof()
		
		If aScan(_aSepara,(_cTab)->X5_CHAVE) == 0	
			AADD(_aSepara,(_cTab)->X5_CHAVE + " - " + Upper(Alltrim((_cTab)->X5_DESCRI)))
		EndIf	
		
		DbSelectArea(_cTab)
		DbSkip()
	EndDo
	
	cTitulo 	:= "Consulta de UF"
	
	For nx := 1 To Len(_aSepara)
		MvParDef += SubStr(_aSepara[nx],1,6)
	Next
	
	If f_Opcoes(@_aRet,cTitulo,_aSepara,MvParDef,Len(_aSepara),TamSX3("X5_DESCRI")[1],.f.,TamSX3("X5_CHAVE")[1],30,.t.,.f.,"",.f.,.f.,.t.) // Chama funcao f_Opcoes
		
//		_cRet := Alltrim(M->A1__REGION)
		For nx := 1 To Len(_aRet)
			_cRet += IIF(Empty(_cRet),Alltrim(_aRet[nx]), "," + Alltrim(_aRet[nx]))
		Next
	EndIf
	
	If Select(_cTab) > 0
		DbSelectArea(_cTab)
		DbCloseArea()
	EndIf
	     	
	//_cIFATA09I := _cRet
	
Return _cRet

/*
Function f_Opcoes(	uVarRet			,;	//Variavel de Retorno
					cTitulo			,;	//Titulo da Coluna com as opcoes
					aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
					cOpcoes			,;	//String de Opcoes para Retorno
					nLin1			,;	//Quantidade de linhas
					nCol1			,;	//Nao Utilizado
					l1Elem			,;	//Se a Selecao sera de apenas 1 Elemento por vez
					nTam			,;	//Tamanho da Chave
					nElemRet		,;	//No maximo de elementos na variavel de retorno
					lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
					lComboBox		,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
					cCampo			,;	//Qual o Campo para a Montagem do aOpcoes
					lNotOrdena		,;	//Nao Permite a Ordenacao
					lNotPesq		,;	//Nao Permite a Pesquisa	
					lForceRetArr    ,;	//Forca o Retorno Como Array
					cF3				 ;	//Consulta F3	
				  )
*/  

User Function IFATA09I()

Return _cIFATA09I