#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"
                                                                                                             
/*
+-----------+---------+-------+---------------------------------------+------+--------------+
| Programa  | ICOMR08 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Outubro/2014 |
+-----------+---------+-------+---------------------------------------+------+--------------+
| Descricao | Relatorio de Lista de Preço - Bike (Crystal)								  	|
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		  	|
+-----------+-------------------------------------------------------------------------------+
*/

User Function ICOMR08()
Local aPergs	:= {}    
Local cParams	:= ""
Local cRefIni	:= ""
Local cRefFim	:= ""
Local _cQuery 	:= ""                                                                                          
Local n 		:= 0
Local aStru		:= {010,055,140,190}
//Local aStru2	:= {005,055,150,210,230,310}
Local nLinha	:= 10
Local lRet		:= .F.                               
Local aItens1	:= {"1=Imprimir Toda a Lista",;
					"2=Imprimir Por Identificação"}
Local aItens2	:= {"S=Sim",;
					"N=Não"}
Local aLista	:= {}
Local cList3	:= " "             

Local dBaseCod	:= CTOD("")
Local cSeg		:= space(TamSx3("Z7_CODIGO")[1])
Local cMarcDe	:= space(TamSx3("Z5_CODIGO")[1])
Local cMarcAte	:= space(TamSx3("Z5_CODIGO")[1])
Local cTitulo	:= space(30)
Local nDesc		:= 0

Private oDlgTMP
Private oGetTM1
Private aHeaderB
Private aColsB		:= {{space(TamSx3("Z3_PRODUTO")[1]),"",.F.}}
Private oCombo1
Private oCombo2
Private oCombo3
Private oIdenDe
Private oIdenAte
Private oFont14	   	:= tFont():New("Tahoma",,-14,,.t.)
Private dBase		:= CTOD("  /  /    ")
Private cList		:= "1"        
Private cList2		:= "N"             
Private cUFs		:= Space(80)
Private cIdenDe		:= space(TamSx3("Z8_COD")[1])
Private cIdenAte	:= space(TamSx3("Z8_COD")[1])
Private cObs		:= ""

	
DEFINE MSDIALOG oDlgTMP TITLE "Emissão de Lista de Preço" FROM 0,0 TO 205,530 PIXEL

oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1] Say "Data da Lista"			SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,aStru[2] MsGet dBase	 				Size 040,010 of oDlgTMP PIXEL 
@ nLinha,aStru[3] Say "Impressão Oficial"		SIZE 080,010 OF oDlgTMP PIXEL 
@ nLinha,aStru[4] MSCOMBOBOX oCombo2 VAR cList2 ITEMS aItens2 SIZE 040, 010 OF oDlgTMP PIXEL 
nLinha += 16

@ nLinha,aStru[1] Say "Tipo Impressão" 			SIZE 070,010 OF oDlgTMP PIXEL 
@ nLinha,aStru[2] MSCOMBOBOX oCombo1 VAR cList ITEMS aItens1 SIZE 070, 010 OF oDlgTMP PIXEL 
@ nLinha,aStru[3] Say "UF Lista" 	 			SIZE 070,010 OF oDlgTMP PIXEL 
@ nLinha,aStru[4] MsGet cUFs	 				Size 070,010 F3 "SX512A" of oDlgTMP PIXEL
nLinha += 16

@ nLinha,aStru[1] Say "Identificação De" 	 	SIZE 070,010 OF oDlgTMP PIXEL    
@ nLinha,aStru[2] MsGet oIdenDe  VAR cIdenDe 	Size 040,010 F3 "SZ8" of oDlgTMP PIXEL WHEN cList != '1'
@ nLinha,aStru[3] Say "Identificação Até"  		SIZE 070,010 OF oDlgTMP PIXEL
@ nLinha,aStru[4] MsGet oIdenAte VAR cIdenAte	Size 040,010 F3 "SZ8" of oDlgTMP PIXEL WHEN cList != '1'

//@ nLinha,aStru[3] Say "Impressão Shimano"		SIZE 080,010 OF oDlgTMP PIXEL 
//@ nLinha,aStru[4] MSCOMBOBOX oCombo3 VAR cList3 ITEMS aItens2 SIZE 040, 010 OF oDlgTMP PIXEL 
nLinha += 26    

@ nLinha,010 	  Button "Itens Avulsos" 	ACTION {|| U_ICOMR08A()  }  				SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,100 	  Button "Confirmar" 		ACTION {|| MsAguarde({||GravImport()})  } 	SIZE 040,010 OF oDlgTMP PIXEL
@ nLinha,190	  Button "Cancelar" 		ACTION {|| oDlgTMP:End() } 					SIZE 040,010 of oDlgTMP PIXEL

If cList == "1"
	oIdenDe:lActive		:= .f.
	oIdenAte:lActive	:= .f.
EndIf

oCombo1:bChange  := {|| AtuTpImp(cList)}

ACTIVATE MSDIALOG oDlgTMP CENTERED                            


Return

/*
+-----------+----------+-------+---------------------------------------+------+---------------+
| Programa  | ICOMR08A | Autor | Rubens Cruz - Anadi Soluções 		   | Data | Novembro/2014 |
+-----------+----------+-------+---------------------------------------+------+---------------+
| Descricao | Relatorio de Lista de Preço - Bike (Crystal)								  	  |
+-----------+---------------------------------------------------------------------------------+
| Uso       | ISAPA																		  	  |
+-----------+---------------------------------------------------------------------------------+
*/

User Function ICOMR08A()   
	Local aSize 		:= {}
	Local aObjects 		:= {}
	Local aInfo 		:= {}
	Local aPosObj		:= {}
	Local nLinha		:= 5, _cFilAtu := cFilAnt                                   
	Local nStyle    	:= GD_INSERT+GD_DELETE+GD_UPDATE
	Local aStru			:= {010,080,140}
	Local aCpoHeader	:= {"UB_PRODUTO","B1_DESC"}
 
	Private _cFilial	:= cFilAnt
	Private _cNmFil		:= Posicione("SZE",1,cEmpAnt+cFilAnt,"ZE_FILIAL")        
	Private aEdit		:= {"PROD"}
	Private _cPedido	:= space(TamSx3("Z2_CODIGO")[1])
	Private aTela[0][0],aGets[0],aHeader[0]
	Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)

	aSize := MsAdvSize()
	
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3,3}
	aPosObj := MsObjSize(aInfo, aObjects)	

	CriaHeader(aCpoHeader)

	DEFINE MSDIALOG oDlgTM1 TITLE "Itens Avulsos" From aSize[7],0 To aSize[6],700 OF oMainWnd PIXEL

	@ nLinha,aStru[1] Say "Filial: " 					SIZE 040,010 OF oDlgTM1 PIXEL FONT oFont12 
	@ nLinha,aStru[2] MsGet _cFilial  		   F3 "DLB" Size 010,010 of oDlgTM1 PIXEL FONT oFont12 VALID ValFil(_cFilial)
	@ nLinha,aStru[3] MsGet _cNmFil  					Size 120,010 OF oDlgTM1 PIXEL FONT oFont12 WHEN .F.
	nLinha += 16
	
	@ nLinha,aStru[1] Say "Pedido Importação: " 		SIZE 080,010 OF oDlgTM1 PIXEL FONT oFont12 
	@ nLinha,aStru[2] MsGet _cPedido  					Size 010,010 OF oDlgTM1 PIXEL FONT oFont12 VALID ValProc(_cFilial,_cPedido)
	@ nLinha,aStru[3] Button oButton PROMPT "Adicionar" SIZE 040,010 OF oDlgTM1 PIXEL ACTION AddImport(_cPedido)
	nLinha += 16
	
	oGetTM1 := MsNewGetDados():New(aPosObj[1,1]+35,aPosObj[1,2],aPosObj[1,3]-40,350, nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , 9999, , , , oDlgTM1, aHeaderB, aColsB)

	@ aPosObj[1,3]-35,aStru[1] Say "Pedidos Incluídos: " SIZE 080,010 OF oDlgTM1 PIXEL FONT oFont12 
//	@ aPosObj[1,3]-35,aStru[2] Get cObs MEMO 			 SIZE 250,040 of oDlgTM1 WHEN .F. PIXEL
	@ aPosObj[1,3]-35,aStru[2] Say cObs  			 	 SIZE 250,022 of oDlgTM1 PIXEL
	@ aPosObj[1,3]-37,aStru[2]-2 To aPosObj[1,3]-35+26,aStru[2]+250

	@ aPosObj[1,3]-07,305 	   Button oButton PROMPT "Retornar" SIZE 040,015 OF oDlgTM1 PIXEL ACTION (oDlgTM1:End())

	ACTIVATE MSDIALOG oDlgTM1 CENTERED 
	
	cFilAnt := _cFilAtu

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValFil				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial e Preenchimento do Acols								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValFil(_cFilial)
Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SZE")

If(dbSeek(cEmpAnt+_cFilial) .OR. Vazio())
	_cNmFil :=  SZE->ZE_FILIAL
	cFilant := _cFilial
Else
	_cNmFil := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZE)
RestArea(_aArea)

Return lRet  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValProc				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial e Preenchimento do Acols								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValProc(_cFilial,_cPedido)
Local _aArea	:= GetArea()
Local _aAreaSZ2	:= SZ2->(GetArea())
Local lRet 		:= .T.
                         
If Empty(_cPedido)
	Return lRet
EndIf

If Empty(_cFilial)
	Alert("Filial não preenchida")
	lRet := .F.
	Return lRet
EndIf

DbSelectArea("SZ2")
DbSetOrder(1)

If !dbSeek(_cFilial+_cPedido) 
	Alert("Processo de importação não cadastrado na filial " + _cFilial)
	lRet := .F.
EndIf

RestArea(_aAreaSZ2)
RestArea(_aArea)

Return lRet  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Novembro de 2014				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()
aHeaderB    := {}
aCpoHeader	:= {"B1_DESC"}

Aadd(aHeaderB, {"Produto","PROD","",15,0,"U_ICOMR08B()",,"C","SB1LIK",,,})

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_RELACAO		,;
		SX3->X3_F3	    	,;
		SX3->X3_Context		,;
		SX3->X3_OBRIGAT		})
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

Return Nil 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMR08B				 			| 	Novembro de 2014				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Preenche nome do produto do acols após digitar o codigo						  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMR08B()
Local _aArea	:= GetArea()
Local _aAreaSB1	:= SB1->(GetArea())
Local lRet := .T.

If(ASCAN(oGetTM1:aCols, { |x| AllTrim(x[1]) == alltrim(M->PROD) }) > 0 )
	alert("Produto já incluso")
	lRet := .F.
EndIf

DbSelectArea("SB1")
If DbSeek(xFilial("SB1")+M->PROD)
	oGetTM1:Acols[oGetTM1:nAt][2] := SB1->B1_DESC
	aColsB := oGetTM1:Acols
Else
	lRet := .F.
EndIf

RestArea(_aAreaSB1)
RestArea(_aArea)

Return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AddImport			 			| 	Novembro de 2014				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function AddImport(_cPedido,_cFilial)
Local _cQuery	:= ""
Local _PosDesc	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_DESC" })
Local _PosProd	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "PROD" })
Local _nAtu		:= Len(aColsB) //Len(oGetTM1:aCols)
Local aObsAux	:= Separa(cObs,";")

Default _cPedido := ""
Default _cFilial := cFilAnt

//Validacoes para inclusao do pedido no acols
If Empty(_cPedido)
	Alert("Pedido não informado")
	Return
EndIf
If (_cPedido $ cObs)
	Alert("Pedido já incluso")
	Return
EndIf 

If Select("TRB_SZ2") > 0
	DbSelectArea("TRB_SZ2")
	DbCloseArea()
EndIf

_cQuery	:= "SELECT DISTINCT Z3_PRODUTO,                                                          " + Chr(13)
_cQuery	+= "       B1_DESC                                                                       " + Chr(13)
_cQuery	+= "FROM " + RetSqlName("SZ2") + " SZ2                                                   " + Chr(13)
_cQuery	+= "INNER JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = SZ2.Z2_FILIAL            " + Chr(13)
_cQuery	+= "                         AND Z3_CODIGO = Z2_CODIGO                                   " + Chr(13)
_cQuery	+= "                         AND SZ3.D_E_L_E_T_ = ' '                                    " + Chr(13)
_cQuery	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + Chr(13)
_cQuery	+= "                         AND SB1.B1_COD = Z3_PRODUTO                                 " + Chr(13)
_cQuery	+= "                         AND SB1.D_E_L_E_T_ = ' '                                    " + Chr(13)
//Querry alterada por solicitação do Sérgio para se o Item não estiver na tabela de preço, ignora o mesmo
/*_cQuery	+= "LEFT JOIN " + RetSqlName("DA1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + Chr(13)
_cQuery	+= "                         AND SB1.B1_COD = Z3_PRODUTO                                 " + Chr(13)
_cQuery	+= "                         AND SB1.D_E_L_E_T_ = ' '                                    " + Chr(13)*/
//Fim da modificacao
_cQuery	+= "WHERE SZ2.D_E_L_E_T_ = ' '                                                           " + Chr(13)
_cQuery	+= "      AND SZ2.Z2_CODIGO = '" + _cPedido + "'                                         " + Chr(13)
_cQuery	+= "      AND SZ2.Z2_FILIAL = '" + _cFilial + "'                                         " + Chr(13)
_cQuery	+= "ORDER BY Z3_PRODUTO ASC                                                              "
TcQuery _cQuery New Alias "TRB_SZ2"

DbSelectArea("TRB_SZ2")

While !(Eof())
	If(ASCAN(aColsB, { |x| AllTrim(x[1]) == alltrim(TRB_SZ2->Z3_PRODUTO) }) = 0)
		if(_nAtu > 1 .OR. !Empty(aColsB[_nAtu][_PosProd]) )
			aAdd( aColsB,array(Len(aHeaderB)+1) )	
			_nAtu++
		EndIf
	
		aColsB[_nAtu][_PosProd] := TRB_SZ2->Z3_PRODUTO
		aColsB[_nAtu][_PosDesc] := TRB_SZ2->B1_DESC
		aColsB[_nAtu][Len(oGetTM1:aHeader)+1] := .F. 
			
	EndIf
	DbSkip()
EndDo

//oGetTM1:nAt := _nAtu

If(!Empty(aObsAux) .AND. Len(aObsAux) % 8 = 0)
	cObs += _cPedido + ";" + Chr(10) + Chr(13)
Else
	cObs += _cPedido + ";"
EndIf

oGetTM1:aCols := aColsB

TRB_SZ2->(dbCloseArea())

Return           

/*
+-----------+------------+-------+---------------------------------------+------+---------------+
| Programa  | GravImport | Autor | Rubens Cruz - Anadi Soluções 		 | Data | Dezembro/2014 |
+-----------+------------+-------+---------------------------------------+------+---------------+
| Descricao | Grava dados da importação na Tabela PA2 e roda Proc para gerar relatório			|
+-----------+-----------------------------------------------------------------------------------+
| Uso       | ISAPA																		  	    |
+-----------+-----------------------------------------------------------------------------------+
*/

Static Function GravImport() 
Local _dData	:= Date()
Local _cHora	:= Time()
Local _cQuery	:= ""
Local _cTab		:= GetMV("MV__TABBRA")
Local _cLocPad	:= GetMV("MV__LOCPAD")
Local aGrpSuf	:= Separa(GetMV("MV__GRPSUF"),',')
Local aResult	:= {} 
Local nIdLista	:= 0 
Local _nNumId	:= val(GETSXENUM("PA2","PA2_NUMID"))
Local cOptions 	:= "1;0;1;Emissão de Lista de Preço - Bike"
Local cParams	:= ""
Local aUFs		:= {} 

If(cList == "1")
	cIdenDe  := "     "
	cIdenAte := "ZZZZZ"
EndIf

//Apaga registros antigos da tabela PA2
_cQuery := "DELETE FROM " + RetSqlName("PA2") + " WHERE PA2_USER = '" + __cUserId + "' "
Begin Transaction
TCSQLExec(_cQuery)
End Transaction

DbSelectArea("PA2")

//Grava conteudo do acols na PA2                         
For nX := 1 To Len(aColsB)
	If !aColsB[nX][3]
		RecLock("PA2",.T.)
			PA2->PA2_FILIAL := xFilial("PA2")
			PA2->PA2_USER	:= __cUserId
			PA2->PA2_DATA	:= _dData
			PA2->PA2_NUMID	:= ALLTRIM(STR(_nNumId)) //'54321'
			PA2->PA2_PROD	:= aColsB[nX][1]
		MsUnlock()       
	EndIf
Next nX   

aUFs := separa(alltrim(cUFs),",")

For nX := 1 To Len(aUFs)
	//Roda Stored Procedure para popular a tabela ListaPreco e preencher o relatório
	aResult := TCSPEXEC("GERA_LISTA_PRECO",;
						_cTab,; 								//Codigo da tabela de preco
						IIF(aUFs[nX] == 'BR','  ',aUFs[nX]),; 	//UF
						DTOS(dBase),; 							//Data da Lista
						Val(__cUserId),;						//Id do Usuario
						cList2,;								//Impressao Oficial
						_cLocPad,;								//Deposito-char(4)
						cList,;									//Tipo de impressao
						cIdenDe,;								//Identificacao De
						cIdenAte,;      						//Identificacao Ate
						_nNumId)       							//ID da transacao
	
	If !Empty( aResult[3] )
		MsgStop( "Problema com a SP: " + aResult[3] )//TCSQLError() ) 
	Else
		nIdLista := aResult[1]
		ConfirmSX8()       
		
		cParams := Alltrim(Str(nidLista)) + ';' + DTOS(dBase)   
		CallCrys('ICOMCR08', cParams,cOptions)
	
	EndIf
Next nX

//oDlgTMP:End()

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuMod			 	| 	Julho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Verifica tipo de Impressão para habilitar campos                                |
|-----------------------------------------------------------------------------------------------|
*/


Static Function AtuTpImp(cList)

if cList == "1"

	cIdenDe		:= Space( avSx3("Z8_COD"	,3) )
	cIdenAte	:= Space( avSx3("Z8_COD"	,3) )
		
	oIdenDe:lActive		:= .f.
	oIdenAte:lActive	:= .f.
	
Else

	cIdenDe		:= Space( avSx3("Z8_COD"	,3) )
	cIdenAte	:= Space( avSx3("Z8_COD"	,3) )
		
	oIdenDe:lActive		:= .t.
	oIdenAte:lActive	:= .t.
	
Endif

oIdenDe:Refresh()
oIdenAte:Refresh()
oDlgTMP:Refresh()

Return(.t.)
