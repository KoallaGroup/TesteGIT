#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH" 

/*
+------------+---------+--------+------------------------------------------+-------+--------------+
| Programa:  | ICOMA13 | Autor: | Jorge Henrique Alves - Anadi Soluções    | Data: | Outubro/2014 |
+------------+---------+--------+------------------------------------------+-------+--------------+
| Descrição: | Cadastro de Cotação para importação												  |
+------------+------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa												                      |
+------------+------------------------------------------------------------------------------------+
*/

User Function ICOMA13()
Private _cFil := "" 
Private cCadastro := "Cadastro de cotacao", cString := "SZL"
Private aRotina   := {	{"Pesquisar" 	,"AxPesqui"	   ,0,1},;    
						{"Visualizar" 	,"U_ICOMA13A(2)",0,2},;
					 	{"Incluir"		,"U_ICOMA13A(3)",0,3},;
					  	{"Alterar"		,"U_ICOMA13A(4)",0,4},;
					  	{"Imprimir"     ,"U_ICOMA13I()" ,0,2},;
					  	{"Excluir"		,"U_ICOMA13A(5)",0,5}}

DbSelectArea(cString)
DbSetOrder(1)
DbGoTop()

dbSelectArea("SZ1")
dbSetOrder(1)
if dbSeek(xFilial("SZ1")+__cUserId)
    _cSegto := SZ1->Z1_SEGISP
else
    _cSegto := '0'
endif   

if Alltrim(_cSegto) <> '0'
    _cFil := 'Alltrim(SZL->ZL_SEGISP) == "' + Alltrim(_cSegto) + '" '
    DbSelectArea("SZL")
    Set Filter To &_cFil
endif

mBrowse(6,1,22,75,cString,,,,,,)
Return                   


/*
+------------+----------+--------+------------------------------------------+-------+----------------+
| Programa:  | ICOMA13A | Autor: | Jorge Henrique Alves - Anadi Soluções    | Data: | Outubro/2014   |
+------------+----------+--------+------------------------------------------+-------+----------------+
| Descrição: | Getdados do cadastro de cotação                                                       |
+------------+---------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa 			    														 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ICOMA13A(nOpcx)
Local aArea		:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}
Local _cNum 	:= IIF(nOpcx == 3,Criavar("ZL_NUM"),SZL->ZL_NUM), _dDtEmis := IIF(nOpcx == 3,dDataBase,SZL->ZL_DATA)
Local nLinha 	:= nLin02 := nOpca := 0, oDlg
Local cSeek		:= IIF(nOpcx == 3,"",SZL->ZL_FILIAL + SZL->ZL_NUM), cWhile := IIF(nOpcx == 3,"","SZL->ZL_FILIAL + SZL->ZL_NUM")

Private oGet

//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0]

//Cria aHeader e aCols
FillGetDados(nOpcx,"SZL",1,cSeek,{|| &cWhile },{||.T.},/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,nOpcx == 3)

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,015,.t.,.f.})
AAdd(aObjects,{100,100,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 2
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,030,042,057,115,145,183,201,215,228} } )

@nLinha, aPosGet[1,01] Say "Num. Cotacao" 		SIZE 45, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,02] MSGET _cNum				PICTURE PesqPict("SZL","ZL_NUM",TamSX3("ZL_NUM")[1])  When .F. SIZE 30,10 OF oDlg PIXEL
@nLinha, aPosGet[1,05] SAY "Data Emissao"  		SIZE 35, 10 OF oDlg PIXEL
@nLin02, aPosGet[1,06] MSGET _dDtEmis 			PICTURE PesqPict("SZL","ZL_DATA",TamSX3("ZL_DATA")[1])  When (nOpcx == 3) SIZE 45,10 OF oDlg PIXEL

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,,,"+ZL_ITEM",nOpcx ==3 .Or. nOpcx == 4)
If nOpcx == 3
	aCols[1][aScan(aHeader,{|x| Trim(x[2]) == "ZL_ITEM"})] := StrZero(1,TamSX3("ZL_ITEM")[1])
EndIf
ACTIVATE MSDIALOG oDlg On Init ICOMA13B(oDlg,{||nOpca:=1, if(oGet:TudoOk(),oDlg:End(),nOpca := 0)}, {||oDlg:End()},nOpcx)

If nOpca == 1 .And. nOpcx > 2
    DbSelectArea("SZL")
    Set Filter To
    
	If !ICOMA13G(nOpcx,_cNum,_dDtEmis)
		MsgStop("Falha na gravação dos dados","ATENCAO")
	EndIf
	
    DbSelectArea("SZL")
    Set Filter To &_cFil
EndIf

//Restaura a integridade da janela               
RestArea(aArea)

Return

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ICOMA13G | Autor: | Jorge Henrique Alves - Anadi Soluções    | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Rotina auxiliar para gravar a inclusão, alteração ou exclusão                       |
+------------+-------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa       			                                                   |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function ICOMA13G(nOpcx,_cNum,_dDtEmis)
Local _lRet := .f., _aArea := GetArea(), nx := ny := 0, _cMay := "", _lChange := .f., _cNumOld := _cNum
Local _nPRec := aScan(aHeader, { |x| AllTrim(x[2]) == "ZL_REC_WT" })

If nOpcx == 3 //Incluir

	DbSelectArea("SZL")
	DbSetOrder(1)
	DbGoTop()
	
	_cMay := "SZL" + Alltrim( xFilial( "SZL" ) ) + _cNum
	While dbSeek( xFilial("SZL") + _cNum) .or. !MayIUseCode(_cMay)
		_cNum := Soma1( cNumPed, Len( cNumPed ) )
		_cMay := "SZL" + Alltrim( xFilial("SZL") ) + _cNum 
		_lChange := .t.
	End
	If __lSX8
		ConfirmSX8()
	Endif
	
	If _lChange
		Help( Nil, Nil, "NUMCOT", Nil, "Numero da cotacao alterado para " + _cNum + ". Ja existia cotacao com o numero " + _cNumOld, 1, 0 ) 
	EndIf

EndIf

//Faz a Gravação dos dados
For nx := 1 To Len(aCols)

	If (aCols[nx][Len(aHeader) + 1] .Or. nOpcx == 5) .And. nOpcx >= 3
		DbSelectArea("SZL")		
		DbGoTo(aCols[nx][_nPRec])		
		If (aCols[nx][_nPRec]) > 0	// Incluido situacao caso a exclusao do registro for no momento da inclusao. Rogerio 30/12/14
			While !Reclock("SZL",.f.)		
			EndDo
			DbDelete()
			MsUnlock()
		EndIf
		_lRet := .t.
	Else
		If aCols[nx][_nPRec] > 0
            DbSelectArea("SZL")     
            DbGoTo(aCols[nx][_nPRec])
			While !Reclock("SZL",.f.)
			EndDo
		Else			
			While !Reclock("SZL",.t.)
			EndDo				
			SZL->ZL_FILIAL	:= xFilial("SZL")
			SZL->ZL_NUM		:= _cNum
			SZL->ZL_DATA	:= _dDtEmis
		EndIf
		For ny := 1 To Len(aHeader)
			FieldPut(FieldPos(aHeader[ny][2]), aCols[nx][ny])
		Next ny			
		MsUnlock()
		_lRet := .t.

	EndIf
Next

RestArea(_aArea)
Return _lRet

/*
+------------+----------+--------+------------------------------------------+-------+----------------+
| Programa:  | ICOMA13B | Autor: | Jorge Henrique Alves - Anadi Soluções    | Data: | Outubro/2014   |
+------------+----------+--------+------------------------------------------+-------+----------------+
| Descrição: | Montagem da EnchoiceBar																 |
+----------------------------------------------------------------------------------------------------+
| Uso:       | Exclusivo Isapa          			                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

Static Function ICOMA13B(oDlg,bOk,bCancel,nOpc)
Local aButtons   := {}
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BscDdsFor ºAutor  ³Alexandre Caetano   º Data ³  13/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca Dados do Fornecedor                                  º±±
±±º          ³ 1 - Codigo do produto no fornecedor                        º±±
±±º          ³ 2 - Descrição em ingles                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BSCDDSFOR()
Local aArea 	:= GetArea()       
Local nPosCodi	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_PRODUTO" })
Local nPosDesc	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_DESCRI"  }) 
Local nPosForn  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_FORNECE" })
Local nPosLoja  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_LOJA"    })

cProd :=  M->ZL_PRODUTO
      
SB1->( dbSetOrder(1) )
SB1->( dbSeek( xFilial("SB1") + avKey(cProd,"B1_COD") ) )

If Empty( aCols[n,nPosForn] )
	SA5->( dbSetOrder(2))
	SA5->( dbSeek(xFilial("SA5") + avKey(cProd,"A5_PRODUTO") ) )
Else          
	cForn := aCols[n,nPosForn]
	cLoja := aCols[n,nPosLoja]
	
	SA5->(dbSetOrder(2))                 	
	SA5->( dbSeek( xFilial("SA5") + avKey(cProd,"A5_PRODUTO") + avKey(cForn,"A5_FORNECE") + avKey(cLoja,"A5_LOJA") ) )
Endif                                                                   

cCdPrdForn := SA5->A5_CODPRF
cDescIngle := iif( Empty(SA5->A5__DESCIN), SB1->B1_DESC, SA5->A5__DESCIN )

aCols[n,nPosCodi] := cCdPrdForn 
aCols[n,nPosDesc] := cDescIngle

Return(.t.)


User Function ICOMA13I()
Local _cRelato := "1;0;1;ICOMCR13"

CallCrys('ICOMCR13',SZL->ZL_NUM,_cRelato)

Return