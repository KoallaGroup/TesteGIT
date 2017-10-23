#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"  
#include "fwmvcdef.ch" 
#include "fwbrowse.ch"
#include "parmtype.ch"
                              

#DEFINE _LIDLG	aCoors[1]                                                                                              
#DEFINE _CIDLG	aCoors[2]
#DEFINE _LFDLG	aCoors[3]
#DEFINE _CFDLG	aCoors[4]


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA01			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Validação de Classificação de Documento de Entrada							  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTA01()  
	Local aCores 	:= {{ "! empty(F1__WMSAPR)" ,'BR_VERDE'},;		   	//APROVADO
			   	     	{ "empty(F1__WMSAPR)",'BR_VERMELHO'}} // AGUARDANDO APROVAÇÃO
	
	Private aRotina := {{"Pesquisar"		,"AxPesqui"		,0,1} ,;
						{"Det.Divergencias"	,"U_IESTAD2"	,0,2,0 ,.F.},;
				        {"Aprovar"			,"U_GRVSF1(3)"	,0,4},;
				        {"Visualizar"		,"A103NFiscal"	,0,4} ,; 
						{"Legenda"			,"U_IESTALEG1"	,0,0,0 ,.F.},;
						{"Divergencias"		,"U_IESTAD1"	,0,0,0 ,.F.}}
						//{"Estornar",	"U_GRVSF1(4)",0,6},; 	   
							 
	Private aCoors	:= FWGetDialogSize( oMainWnd )	             
				             
    U_IESTA01A()
	
	SetKey( VK_F12 , { || U_IESTA01A(.T.) } )

	MBrowse( 6,1,22,75,'SF1',,,,,,aCores,,,,,.F.)  
	
	set filter to
	SetKey( VK_F12 , { || } )
	
Return


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MontaTela			 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela de Detalhamento do ítem												  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function MontaTela(cAlias, nReg, nOpc)

	Local cLinOK   := "AllwaysTrue"
	Local lTudoOK  := .T.
	Local cFieldOK := "AllwaysTrue"
	Local lRet     := .F.
	Local nOptx    := nOpc
	Local aCampos  := {"F1_DOC","F1_SERIE"}
	Local aAreaATU := GetArea()
	Local aAreaZZY := SF1->(GetArea())
	Local aButtons := {}
	
	Private _cNumDoc  	 := SF1->F1_DOC
	Private	n			 := 1
	Private aHeader      := {}
	Private aCols        := {}
	Private oGetTM1      := Nil
	Private oDlgTMP		 := Nil
	Private oQtdSel		 := Nil
	Private aSize      	 := MsAdvSize(.T.)
	Private aCpoGet   	 := {"F1_DOC","F1_SERIE"}
	Private aPosicao 	 := 0
	Private aEdit    	 := {}
	Private lColuna   	 := .F.      
	
	aHeader := CriaHeader({"F1_DOC", "F1_SERIE"})
	CriaCols(nOpc)  
	    
	RegToMemory( "SF1",.F.)              
	
	_titulo := ''
	if nOptx == 2
		_titulo := 'Visualização'
	elseif nOptx == 3
		_titulo := 'Aprovação'
	elseif nOptx == 4
		_titulo := 'Estorno'
	endif
		
	aObjects := {}
	aAdd( aObjects, {100,100, .T., .T.})
	aAdd( aObjects, {100,100, .T., .T.})
	aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj	:= MsObjSize( ainfo, aObjects )
	
	DEFINE MSDIALOG oDlgTMP TITLE _titulo FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL  
	oDlgTMP:lMaximized := .F.
	aPosicao := {aPosObj[1,1]+20, aPosObj[1,2]+11, aPosObj[1,3]+13, aPosObj[1,4]-10}
	oEnchoice := MsMGet():New("SF1", ,nOptx, , , , aCpoGet, aPosicao, aEdit, , , , , oDlgTMP, , , lColuna)
	oGetTM1 := MSGETDADOS():NEW(aPosObj[2,1]+25, aPosObj[2,2]+11, aPosObj[2,3]+5, aPosObj[2,4]-10,nOptx,"AllwaysTrue","AllwaysTrue","",.T., aCampos, , .F., 200,,, ,, oDlgTMP)
	ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{|| GRVSF1(nOptx)},{||Rollbacksx8(),oDlgTMP:End()},,aButtons)              
	RestArea(aAreaATU)
	
Return


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaHeader			 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader(aCpoHeader)
	Local aHeaderTMP      := {}
//	aCpoHeader   := {"F1_DOC", "F1_SERIE"}
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
				cNivel >= SX3->X3_Nivel                  // Nivel do Usuario é maior que o Nivel do Campo.
			
				AAdd(aHeaderTMP, {Trim(SX3->X3_Titulo),;
				SX3->X3_Campo       ,;
				SX3->X3_Picture     ,;
				SX3->X3_Tamanho     ,;
				SX3->X3_Decimal     ,;
				SX3->X3_Valid       ,;
				SX3->X3_Usado       ,;
				SX3->X3_Tipo        ,;
				SX3->X3_Arquivo     ,;
				SX3->X3_Context})
			EndIf
		Endif
	Next _nElemHead	
	dbSelectArea("SX3")
	dbSetOrder(1)
	
Return aHeaderTMP


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(nOpcao)

	Local nQtdCpo := 0
	Local i       := 0
	Local nCols   := 0                                             
	
	Local nPosDoc:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "F1_DOC" }) 
	Local nPosSerie:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "F1_SERIE" })
	
	nQtdCpo := Len(aHeader)
	aCols   := {}
	n:=0                    
	
   _cNumDoc := SF1->F1_DOC
   
   DbSelectArea("SD1")
   DbSetOrder(1)
   DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
   While ! Eof() .AND. SD1->(D1_FILIAL+D1_DOC+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_FORNECE+F1_LOJA)
      	AAdd(aCols, Array(nQtdCpo+1))
      	n++
      	
		aCols[n][nQtdCpo+1] := .F.
		Acols[n][nPosDoc] 	:= SD1->D1_DOC
	    Acols[n][nPosSerie] := SD1->D1_SERIE
	    
	    aCols[n][Len(aHeader)+1] := .F.
	    
        DbSelectArea("SD1")
        DbSkip()
   Enddo

	
Return .T.


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : GRVSF1				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Gravação após validação														  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function GRVSF1(_nOpcao)
    Local _cBlqWMS   := Alltrim(GetMv("MV__WMSBLQ"))
	Local _lGravaDoc := .F.

	if _nOpcao == 3
		if SF1->F1__WMSBLQ == '1'
		   	If MsgYesNo(OemToAnsi("Confirma a Aprovação desse Documento ? "))
		   	   _lGravaDoc := .T.
		   	Endif     
		else
		    msgAlert ("Este Documento já está Aprovado !!")
		endif		   	
	elseif _nOpcao == 4
		if SF1->F1__WMSBLQ == '2'
		   	If MsgYesNo(OemToAnsi("Confirma o Estorno da Aprovação desse Documento ? "))
		   	   _lGravaDoc := .T.
		   	Endif   
		else
		    msgAlert ("Este Documento ainda não foi Aprovado !!")
		endif
	endif	
	
	If _lGravaDoc        
		dbSelectArea("SF1")
		if reclock("SF1", .F.)	
			if _nOpcao == 3   
				SF1->F1__WMSBLQ := '2'
				SF1->F1__WMSAPR	:= __cUserId
				SF1->F1__WMSDAP	:= date()
				SF1->F1__WMSHAP	:= time()
				
				//Comunica liberacao ao WMS
				DbSelectArea("Z05")
				DbSetOrder(6)
				If DbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + _cBlqWMS)
				    DbSelectArea("SF1")
				    U_IRECWMS("SF1LIB") 
				EndIf
				
			elseif _nOpcao == 4
				SF1->F1__WMSBLQ := '1'
				SF1->F1__WMSAPR	:= ''
				SF1->F1__WMSDAP	:= ctod('')
				SF1->F1__WMSHAP	:= ''
			endif
		    msUnlock()
		endif
					
		
		//Atualiza a quantidade disponivel
		If _nOpcao == 3
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
			
			While !Eof() .And. (SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA) ==;
								(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
				
				DbSelectArea("SB2")
				DbSetOrder(1)
				If DbSeek(SD1->D1_FILIAL + SD1->D1_COD + SD1->D1_LOCAL) .And. (SD1->D1_QUANT != SD1->D1__WMSQTD) .And. (SD1->D1__WMSQTD > 0)
					While !Reclock("SB2",.f.)
					EndDo
					If SD1->D1__TRANSF == "S"
						SB2->B2__QTDTRA := SB2->B2__QTDTRA - SD1->D1_QUANT
					EndIf					
					SB2->B2__ENTPRC := SB2->B2__ENTPRC + SD1->D1__WMSQTD
					MsUnlock()
				EndIf
				
				DbSelectArea("SD1")
				DbSkip()			
			EndDo
		EndIf
	Endif
	     
//	oDlgTMP:End()
		
Return()


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTALEG1			 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Legenda do Browse															  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTALEG1()
	Local aCores := {}
	aCores := {	{"BR_VERDE",OemToAnsi("Aprovado")},;
			    {"BR_VERMELHO",OemToAnsi("Aguardando Aprovação")}}
	
	BrwLegenda(OemToAnsi("Legenda"),OemToAnsi("Status Aprovação"),aCores)
Return   


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTAD1			  		| 	Dezembro de 2014					  				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi				  							|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela para exibir divergencias												  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTAD1() 

Local lOk		:= .F.
Local lDel		:= .F.
Local aX6Head	:= {}
Local cTitDtq	:= "Divergencias"
Local nQtdGrv	:= 0
Local aButtons	:= {}
Local nSuperior := 017
Local nEsquerda := 005
Local nInferior := 146
Local nDireita  := 247
Local nStyle	:= GD_UPDATE   
     
Private aAltera := {}
Private oTelaDtq
Private oMultline                                                           	
Private aParamet := {}  
Private aCols := {}     

DbSelectArea("SX6")
DbSetOrder(1)
aAdd(aX6Head, {"Codigo"	   		, "Z05_CODIGO"	, "@!", 003, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""})
aAdd(aX6Head, {"Descricao"	   	, "Z05_DESC"	, "@!", 060, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 

aHeader	:= aX6Head                                      
aCols 	:= fCols()
nMax 	:= nTamAcols := Len(aX6Head)   
	
Define MsDialog oTelaDtq TITLE "Divergencias"  FROM _LIDLG/2, _CIDLG/2 TO _LFDLG/2, _CFDLG/2 of oMainWnd PIXEL
oTelaDtq:lMaximized := .F.
	
oGetTit:=MsNewGetDados():New(0, 0, oTelaDtq:nBottom/2, oTelaDtq:nRight/2,nStyle,,,,,,nMax,,,.t.,oTelaDtq,aHeader,aCols)  

AlignObject( oTelaDtq, { oGetTit:oBrowse }, 1, 1, { 100 } )

Activate MsDialog oTelaDtq Centered On Init Enchoicebar(oTelaDtq, {|| lOk:=.T.,oTelaDtq:End()},{|| lOk:=.F.,oTelaDtq:End()},,aButtons)

Return

*-----------------------
Static Function fCols()
*-----------------------   

Local aArray := {}  
Local cQry := ""    

If(select("TRB") > 0)
	TRB->(DbCloseArea())
EndIf      

cQry := " SELECT distinct Z05_CODIGO, Z05_DESC"
cQry += " FROM " + RetSqlName("Z05") + " Z05"
cQry += " WHERE Z05.Z05_FILIAL = '" +SF1->F1_FILIAL+ "'"  
cQry += " AND Z05.Z05_DOC = '" +SF1->F1_DOC+ "'"
cQry += " AND Z05.Z05_SERIE = '" +SF1->F1_SERIE+ "'"
cQry += " AND Z05.D_E_L_E_T_ = ' '"   
cQry += " ORDER BY Z05_CODIGO"   

TcQuery cQry New Alias "TRB"

	DbSelectArea("TRB")
	While TRB->(!Eof()) 
   		Aadd(aArray,{TRB->Z05_CODIGO,TRB->Z05_DESC,.F.})
		TRB->(DbSkip()) 
	End
	TRB->(dbCloseArea())       

Return AClone(aArray)
                              

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTAD2			  		| 	Dezembro de 2014					  				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi				  							|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela para exibir divergencias												  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTAD2() 
Local aHeader	:= {}
Local lOk		:= .T.
Local lDel		:= .F.
Local aX6Head	:= {} 
Local aX6Head3	:= {}
Local cTitDtq	:= "Detalhe das Divergencias"
Local aButtons	:= {}
Local nStyle	:= GD_UPDATE  
Local nLinha 	:= 5   
Local aStru  	:= {{010,060,090},;
					{250,300,330}} 
Local aCpoHead	:= {"D1_ITEM",;
					"D1_COD",;
					"C7_QUANT",;
					"D1_QUANT",;
					"D1__WMSQTD",;
					"C7_PRECO",;
					"D1_VUNIT",;
					"C7_TOTAL",;
					"D1_TOTAL",;
					"C7_VALIPI",;
					"D1_VALIPI",;
					"C7_IPI",;
					"D1_IPI"}
     
Private aAltera := {}
Private oTelaDtq
Private oMultline                                                           	
Private aParamet := {}  
Private aCols := {}    
Private aSize       := MsAdvSize(.T.)  
Private nNumNota := ""    
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)   
Private aColsC := {}  
Private oGetDE := Nil 	 

SetKey( VK_F4 , { || IESTA01T() } )

aAdd(aHeader, {"Item"	   		, "D1_ITEM"		, "@!"				            , TamSX3("D1_ITEM")[1]  , 00                    , "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aHeader, {"Produto"	   	, "D1_COD"		, "@!"				            , TamSX3("D1_COD")[1]   , 00                    , "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aHeader, {"Quant.Ped"	   	, "C7_QUANT"	, "@E 999,999.99"	            , TamSX3("C7_QUANT")[1] , TamSX3("C7_QUANT")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aHeader, {"Quant.NF"	   	, "D1_QUANT"	, "@E 999,999.99"	            , TamSX3("D1_QUANT")[1] , TamSX3("D1_QUANT")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aHeader, {"WMS"	   		, "D1__WMSQTD"	, "@E 999,999.99"	            , TamSX3("D1_QUANT")[1] , TamSX3("D1_QUANT")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})  
aAdd(aHeader, {"Vlr Unit Ped"	, "C7_PRECO"	, PesqPict("SC7","C7_PRECO")	, TamSX3("C7_PRECO")[1] , TamSX3("C7_PRECO")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})  
aAdd(aHeader, {"Vlr Unit NF"	, "D1_VUNIT"	, PesqPict("SD1","D1_VUNIT")	, TamSX3("D1_VUNIT")[1] , TamSX3("D1_VUNIT")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})  
aAdd(aHeader, {"Vlr Tot Ped"	, "C7_TOTAL"	, PesqPict("SC7","C7_TOTAL")	, TamSX3("C7_TOTAL")[1] , TamSX3("C7_TOTAL")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})  
aAdd(aHeader, {"Vlr Tot NF"		, "D1_TOTAL"	, PesqPict("SD1","D1_TOTAL")	, TamSX3("D1_TOTAL")[1] , TamSX3("D1_TOTAL")[2] , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})    
aAdd(aHeader, {"Vlr IPI Ped"	, "C7_VALIPI"	, PesqPict("SC7","C7_VALIPI")	, TamSX3("C7_VALIPI")[1], TamSX3("D1_VALIPI")[2], "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aHeader, {"Vlr IPI NF"		, "D1_VALIPI"	, PesqPict("SD1","D1_VALIPI")	, TamSX3("D1_VALIPI")[1], TamSX3("D1_VALIPI")[2], "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})  
aAdd(aHeader, {"% IPI Ped"		, "C7_IPI"		, PesqPict("SC7","C7_IPI")	    , TamSX3("C7_IPI")[1]   , TamSX3("C7_IPI")[2]   , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})   
aAdd(aHeader, {"% IPI NF"		, "D1_IPI" 		, PesqPict("SD1","D1_IPI")	    , TamSX3("D1_IPI")[1]   , TamSX3("D1_IPI")[2]   , "", "", "N", "", "" ,"" ,"", ".F.", "V", "", "", ""})
aAdd(aHeader, {"Cond.Pgto.Ped"	, "C7_COND"		, "@!"				            , 040					, 00                    , "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""})   
aAdd(aHeader, {"Cond.Pgto.NF"	, "F1_COND" 	, "@!"				            , 040					, 00                    , "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""})

//aHeader	:= CriaHeader(aCpoHead)                                      
aCols 	:= fCols2()
nMax 	:= nTamAcols := Len(aX6Head)  

aAdd(aX6Head3, {"Codigo"	   	, "Z05_CODIGO"	, "@!", 003, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""})
aAdd(aX6Head3, {"Descricao"	   	, "Z05_DESC"	, "@!", 060, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 

aHeaderC 	:= aX6Head3                                      
aColsC  	:= fCols3(.T.,"")
nMaxC   	:= nTamAcols := Len(aX6Head3)  

aObjects 	:= {}   
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects ) 
	
Define MsDialog oTelaDtq TITLE "Detalhamento das Divergencias" FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
oTelaDtq:lMaximized := .F.

@ nLinha,aStru[1][1] Say "Nota Fiscal: " 	SIZE 040,10 OF oTelaDtq PIXEL FONT oFont14 
@ nLinha,aStru[1][2] MsGet nNumNota  		Size 100,10 of oTelaDtq PIXEL FONT oFont14 WHEN .F.

oGetTit:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-100,aPosObj[2,4],nStyle,,,,,,nMax,,,.t.,oTelaDtq,aHeader,aCols) 

oGetDE:=MsNewGetDados():New(aPosObj[2,3]-98,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,,,,,,nMax,,,.t.,oTelaDtq,aHeaderC,aColsC) 

oGetTit:bChange := {|| fCols3(.F.,oGetTit:aCols[oGetTit:nat,1]) }
oGetDE:Refresh()

Activate MsDialog oTelaDtq Centered On Init Enchoicebar(oTelaDtq, {|| U_GRVSF1(3),oTelaDtq:End()},{|| lOk:=.F.,oTelaDtq:End()},,aButtons)

SetKey( VK_F4 , { || } )

Return

*-----------------------
Static Function fCols2()
*-----------------------   

Local aArray := {}  
Local cQry := ""    

If(select("TRB") > 0)
	TRB->(DbCloseArea())
EndIf  

cQry := "SELECT DISTINCT D1_ITEM,                                              " + Chr(13)
cQry += "            D1_COD,                                                   " + Chr(13)
cQry += "            NVL(C7_QUANT,0) C7_QUANT,                                 " + Chr(13)
cQry += "            D1_QUANT,                                                 " + Chr(13)
cQry += "            D1_DOC,                                                   " + Chr(13)
cQry += "            D1_SERIE,                                                 " + Chr(13)
cQry += "            D1__WMSQTD,                                               " + Chr(13)
cQry += "            NVL(C7_PRECO,0) C7_PRECO,                                 " + Chr(13)
cQry += "            D1_VUNIT,                                                 " + Chr(13)
cQry += "            NVL(C7_TOTAL,0) C7_TOTAL,                                 " + Chr(13)
cQry += "            D1_TOTAL,                                                 " + Chr(13)
cQry += "            NVL(C7_VALIPI,0) C7_VALIPI,                               " + Chr(13)
cQry += "            D1_VALIPI,                                                " + Chr(13)
cQry += "            NVL(C7_IPI,0) C7_IPI,                                     " + Chr(13)
cQry += "            D1_IPI,                                                   " + Chr(13)
cQry += "            SUBSTR(SE4A.E4_DESCRI,1,40) AS F1_COND,                   " + Chr(13)
cQry += "            SUBSTR(SE4B.E4_DESCRI,1,40) AS C7_COND                    " + Chr(13)
cQry += "FROM " + RetSqlName("SD1") + " SD1                                    " + Chr(13)
cQry += "INNER JOIN " + RetSqlName("SF1") + " SF1 ON SF1.F1_FILIAL = SD1.D1_FILIAL " + Chr(13)
cQry += "                         AND F1_DOC = SD1.D1_DOC              		   " + Chr(13)
cQry += "                         AND F1_SERIE = SD1.D1_SERIE          		   " + Chr(13)
cQry += "                         AND F1_FORNECE = SD1.D1_FORNECE              " + Chr(13)
cQry += "                         AND F1_LOJA = SD1.D1_LOJA                    " + Chr(13)
cQry += "                         AND SF1.D_E_L_E_T_ <> '*'                    " + Chr(13)
cQry += "INNER JOIN " + RetSqlName("Z05") + " Z05 ON " + Chr(13) 
cQry += "                         Z05_FILIAL = SD1.D1_FILIAL               	   " + Chr(13)
cQry += "                         AND Z05_DOC = SD1.D1_DOC		               " + Chr(13)
cQry += "                         AND Z05_SERIE = SD1.D1_SERIE	               " + Chr(13)
cQry += "                         AND Z05_CLI = SD1.D1_FORNECE                 " + Chr(13)
cQry += "                         AND Z05_LOJA = SD1.D1_LOJA                   " + Chr(13)
cQry += "                         AND Z05.D_E_L_E_T_ <> '*'                    " + Chr(13)
cQry += "LEFT JOIN " + RetSqlName("SC7") + " SC7 ON C7_NUM = SD1.D1_PEDIDO     " + Chr(13)
cQry += "                        AND C7_ITEM = SD1.D1_ITEMPC                   " + Chr(13)
cQry += "                        AND C7_FILIAL = SD1.D1_FILIAL                 " + Chr(13)
cQry += "                        AND C7_FORNECE = SD1.D1_FORNECE               " + Chr(13)
cQry += "                        AND C7_LOJA = SD1.D1_LOJA                     " + Chr(13)
cQry += "                        AND SC7.D_E_L_E_T_ <> '*'                     " + Chr(13)
cQry += "LEFT JOIN " + RetSqlName("SE4") + " SE4A ON SE4A.E4_FILIAL = '  '     " + Chr(13)
cQry += "                          AND SE4A.E4_CODIGO = SF1.F1_COND            " + Chr(13)
cQry += "                          AND SE4A.D_E_L_E_T_ = ' '                   " + Chr(13)
cQry += "LEFT JOIN " + RetSqlName("SE4") + " SE4B ON SE4B.E4_FILIAL = '  '     " + Chr(13)
cQry += "                          AND SE4B.E4_CODIGO = SC7.C7_COND            " + Chr(13)
cQry += "                          AND SE4B.D_E_L_E_T_ = ' '                   " + Chr(13)
cQry += "WHERE SD1.D_E_L_E_T_ <> '*'                                           " + Chr(13)
cQry += "		AND D1_DOC = '" +SF1->F1_DOC+ "'							   " + Chr(13)
cQry += "		AND D1_FILIAL = '" +SF1->F1_FILIAL+ "'						   " + Chr(13)
cQry += "		AND D1_SERIE = '" +SF1->F1_SERIE+ "'						   " + Chr(13)
cQry += "ORDER BY D1_ITEM													   "   

TcQuery cQry New Alias "TRB"

	DbSelectArea("TRB")
	While TRB->(!Eof()) 
   		Aadd(aArray,{TRB->D1_ITEM,TRB->D1_COD,TRB->C7_QUANT,TRB->D1_QUANT,TRB->D1__WMSQTD,TRB->C7_PRECO,TRB->D1_VUNIT,TRB->C7_TOTAL,TRB->D1_TOTAL,TRB->C7_VALIPI,TRB->D1_VALIPI,TRB->C7_IPI,TRB->D1_IPI,TRB->C7_COND,TRB->F1_COND,.F.})
		nNumNota := TRB->D1_DOC
		TRB->(DbSkip()) 
	End
	TRB->(dbCloseArea())       

Return AClone(aArray)
    

*-----------------------------------
Static Function fCols3(lPrime,nItem)
*-----------------------------------   

Local aArray := {}  
Local cQry := "" 
Local lPryme := lPrime   
Local nItemc := nItem

If lPryme
	Aadd(aArray,{"","",.F.})
Else
	If(select("TRB") > 0)
		TRB->(DbCloseArea())
	EndIf      
	
	cQry := " SELECT Z05_CODIGO, Z05_DESC"
	cQry += " FROM " + RetSqlName("Z05") + " Z05"
	cQry += " WHERE Z05.Z05_FILIAL = '" +SF1->F1_FILIAL+ "'"  
	cQry += " AND Z05.Z05_DOC = '" +SF1->F1_DOC+ "'"
	cQry += " AND Z05.Z05_SERIE = '" +SF1->F1_SERIE+ "'"
	cQry += " AND Z05.Z05_ITEM = '" +nItemc+ "'"
	cQry += " AND Z05.D_E_L_E_T_ = ' '"   
	cQry += " ORDER BY Z05_CODIGO"   
	
	TcQuery cQry New Alias "TRB"
	
		DbSelectArea("TRB")
		While TRB->(!Eof()) 
	   		Aadd(aArray,{TRB->Z05_CODIGO,TRB->Z05_DESC,.F.})
			TRB->(DbSkip()) 
		End
		TRB->(dbCloseArea())  
EndIf        
If Type("oGetDE") == "O"
    oGetDE:aCols := aArray
    oGetDE:Refresh()
EndIf
Return AClone(aArray)


static function IESTA01T() 
	local oTelaDtq
	local nLinha 	:= 5   
	local _nF1_COND	:= ASCAN(oGetTit:aHeader, { |x| AllTrim(x[2]) == "F1_COND" })
	local _nC7_COND	:= ASCAN(oGetTit:aHeader, { |x| AllTrim(x[2]) == "C7_COND" })

	Private oFont10	    := tFont():New("Tahoma",,-10,,.F.)   
	
	cItem	:= oGetTit:aCols[oGetTit:NAT][1]  
	cCondPe	:= posicione("SE4",1,xFilial("SE4")+oGetTit:aCols[oGetTit:NAT][_nC7_COND], "E4_DESCRI")
	cCondNF	:= posicione("SE4",1,xFilial("SE4")+oGetTit:aCols[oGetTit:NAT][_nF1_COND], "E4_DESCRI")

	Define MsDialog oTelaDtq TITLE "Formas de Pagamento" FROM 0, 0 TO 200,400 PIXEL
	oTelaDtq:lMaximized := .F.

	@ nLinha+11,10 	Say "Condições de Pagamento do Ítem : " 	SIZE 100,10 OF oTelaDtq PIXEL FONT oFont10 
	@ nLinha+08,95 	MsGet cItem  		Size 10,10 of oTelaDtq PIXEL FONT oFont10 WHEN .F.
	
	@ nLinha+31,10 	Say "Cond. de Pagto. do Pedido : " 	SIZE 080,10 OF oTelaDtq PIXEL FONT oFont10
	@ nLinha+28,80 	MsGet cCondPe  		Size 120,10 of oTelaDtq PIXEL FONT oFont10 WHEN .F.

	@ nLinha+51,10 	Say "Cond. de Pagto. do Pedido : " 	SIZE 080,10 OF oTelaDtq PIXEL FONT oFont10 
	@ nLinha+48,80 	MsGet cCondNF  		Size 120,10 of oTelaDtq PIXEL FONT oFont10 WHEN .F.

    @ nlinha+70,80 	Button oButton PROMPT "Fechar"  	 SIZE 40,15   OF oTelaDtq PIXEL ACTION oTelaDtq:End()

	Activate MsDialog oTelaDtq Centered 
return                       


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA01A			  		| 	Abril de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Funcao generica para exibir o filtro no Doc de Entrada						  	|
|-----------------------------------------------------------------------------------------------|	
|	Parametros: _lFil := .T. = Janela já criada / .F. = Janela não criada						|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTA01A(_lFil) 
Local _cGrpLog	:= superGetMV("MV__GRPLOG", ,"000017,000025")
Local _cGrpComB	:= superGetMV("MV__GRPCMB", ,"000013")
Local _cGrpComA	:= superGetMV("MV__GRPCMA", ,"000014")
Local _lVisBloq := .F.    
Local _oButton1, _oComboBo1, _oSay1, _oTK530, _cComboBo1 := '2 '
Local _oBrowse  := GetObjBrow()
Local _cFilter	:= ""

Default _lFil := .F.

If MsgYesNo(OemToAnsi("Deseja visualizar somente os Documentos Bloqueados ?"))
	_lVisBloq := .T.
Endif   	

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	cSegto 	:= SZ1->Z1_SEGISP
Else
	cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])
EndIf

If Val(cSegto) = 0
    DbSelectArea("SX3")
    DbSetOrder(2)
    DbSeek("C5__SEGISP")
    DEFINE MSDIALOG _oTK530 TITLE "Filtro Segmento" FROM 000, 000  TO 120, 195 COLORS 0, 16777215 PIXEL
        @ 005, 006 SAY _oSay1 PROMPT "Selecione o segmento a ser exibido" SIZE 088, 007 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 021, 007 MSCOMBOBOX _oComboBo1 VAR _cComboBo1 ITEMS Separa(Alltrim(SX3->X3_CBOX),";") SIZE 083, 010 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 039, 029 BUTTON _oButton1 PROMPT "Avançar" SIZE 037, 012 OF _oTK530 PIXEL ACTION {|| _oTK530:End()}
    ACTIVATE MSDIALOG _oTK530 CENTERED    
    
    cSegto := PADR(Alltrim(_cComboBo1),TamSX3("Z1_SEGISP")[1])

Endif        

cTpSeg	:= SZ1->Z1_SEGTIP  // 1 - Nacional, 2 - Importado
	
if _lVisBloq
	_cFilter := "F1__WMSBLQ == '1' .And. F1__WMSRET == '1' "
else
	_cFilter := "((F1__WMSBLQ == '2' .or. F1__WMSBLQ == ' ') .Or. F1__WMSBLQ == '1') "
	_cFilter += " .and. F1__WMSRET == '1' "
endif  
_cFilter += " .and. F1__SEGISP == '" + cSegto + "' "

    _lGrupo	:= .F.

dbSelectArea("SU7")
dbSetOrder(4)
if dbSeek(xFilial("SU7")+__cUserId)

	_aGrupos := usrRetGRP(__cUserId)
        
	for x := 1 to len(_aGrupos)
		if (_aGrupos[x] $ _cGrpComB .or. _aGrupos[x] $ _cGrpComA .or. _aGrupos[x] $ _cGrpLog)		// Filtra notas de Devolução de acordo com segmento do usuário 
			_cFilter += "  .and. (F1_TIPO == 'D' "		
	        _lGrupo	:= .T.
			exit
		endif
	next x 

	for x := 1 to len(_aGrupos)
		if _aGrupos[x] $ _cGrpLog 	// Filtra notas de Transferência de acordo com segmento do usuário 
			If _lGrupo
				_cFilter += "  .or. F1__TRANSF == 'S' "
	        Else
				_cFilter += "  .and. (F1__TRANSF == 'S' "
	        EndIf
	        _lGrupo	:= .T.
			exit
		endif 				
	next x 

	If _lGrupo
		_cFilter += ")"
	EndIf
endif
 
if ! _lGrupo			
	if cTpSeg == '2'
		_cFilter += "  .and. (F1_EST == 'EX' .or. F1__PROIMP <> ' ') .and. F1_TIPO == 'N' " //Importado 
	Else
		_cFilter += "  .and. F1_EST <> 'EX' .and. F1_TIPO == 'N' .And. Empty(F1__PROIMP) "
	endif
	
endif  

dbSelectArea("SF1")
dbSetOrder(1)
set filter to &_cFilter
DbGoTop()

If _lFil
	_oBrowse:Refresh()
EndIf

Return 
