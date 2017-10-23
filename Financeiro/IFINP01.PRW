#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "HBUTTON.CH" 
#INCLUDE "TOTVS.CH"
#Include "Colors.ch"

/*
+-----------+---------+-------+---------------------------------------+------+------------+
| Programa  | IFINP01 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Março/2014 |
+-----------+---------+-------+---------------------------------------+------+------------+
| Descricao | Rotina para visualização do cadastro de identificacoes										  | 
+-----------+-----------------------------------------------------------------------------+
| Uso       | ISAPA																		  |
+-----------+------------------------------------------------ -----------------------------+
*/           

User Function IFINP01   
LOCAL cFiltro   	:= "Z8_SEGISP = '" + Posicione("SZ1",1,xFilial("SZ1")+__cUserId,"Z1_SEGISP") + "' "

PRIVATE cAlias   	:= 'SZ8'
PRIVATE cCadastro 	:= "Cadastro Identificacoes"
PRIVATE aRotina     := {{"Identificacao" , "U_IFINP01I()"   	, 0, 3 },;  //3=Inclusão
                        {"Alterar"       , "U_IFINP01A()"   	, 0, 4 },;  //4=Alteração
                        {"Excluir"       , "U_IFINP01D()"   	, 0, 5 },;  //5=Exclusão
                        {"Produtos"      , "U_IFINP01I('1')"  	, 0, 4 },;  //4=Alteração
                        {"Representantes", "U_IFINP01I('2')"	, 0, 4 }}   //4=Alteração

dbSelectArea("SZ8")
dbSetOrder(1)

mBrowse( ,,,,"SZ8",,,,,,,,,,,,,,cFiltro)

Return             

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP01A | Autor | Rubens Cruz - Anadi Soluções 	  	   | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Rotina para alteracao do cadastro					        			   | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/ 

User Function IFINP01A()
Local cCod 		:= SZ8->Z8_COD
Local cCodnew 	:= ""

if(AxAltera("SZ8",SZ8->(Recno()),4) == 1)
	cCodNew := SZ8->Z8_COD
	if(cCod != cCodnew)
		dbSelectArea("SZ9")
		dbSetOrder(1)    
		dbGoTop()
		if dbSeek(xFilial("SZ7")+cCod)
			Do While (!EOF() .AND. SZ9->Z9_COD == cCod)
				if reclock("SZ9", .F.)
					SZ9->Z9_COD := cCodnew
				endif
				DbSkip()
			EndDo
		EndIf
    EndIf          
EndIf

Return

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP01D | Autor | Rubens Cruz - Anadi Soluções 	  	   | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Rotina para deletar registro do cadastro				        			   | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/ 

user Function IFINP01D()
Local cCod 	:= SZ8->Z8_COD
Local _nRet	:= 0

//_nRet := AxDeleta("SZ8", SZ8->(Recno()), 3)

if(axDeleta("SZ8",SZ8->(RECNO()),3) == 2)
	dbSelectArea("SZ9")
	dbSetOrder(1)    
	dbGoTop()
	if dbSeek(xFilial("SZ9")+cCod)
		Do While (!EOF() .AND. SZ9->Z9_COD == cCod)
			if reclock("SZ9", .F.)
				delete		
			endif
			DbSkip()
		EndDo
	EndIf
EndIf

return     

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | IFINP01I | Autor | Rubens Cruz - Anadi Soluções 	  	   | Data | Março/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Rotina para criar identificacoes						        			   			 | 
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   					 |
+-----------+------------------------------------------------------------------------------+
*/ 

User Function IFINP01I(_cOpc)

	Local nX           	:= 0
	Local nUsado       	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local cAliasE      	:= cAlias
	Local aAlterEnch   	:= {}
	Local aPos         	:= {000,000,080,1000}   
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local nModelo      	:= 3
	Local lF3          	:= .F.
	Local lMemoria     	:= .T.
	Local lColumn      	:= .F.
	Local caTela       	:= ""
	Local lNoFolder    	:= .F.
	Local lProperty    	:= .F.
	Local aCpoGDa      	:= {}
	Local cAliasGD     	:= "SD1"
	Local nSuperior    	:= 030
	Local nEsquerda    	:= 000
	Local nInferior    	:= 230
	Local nDireita     	:= 603
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "D1_ITEM"
	Local nFreeze      	:= 000
	Local nMax         	:= 999
	Local cFieldOk     	:= "AllwaysTrue"
	Local cSuperDel    	:= ""
	Local cDelOk       	:= "AllwaysTrue"
	Local aHeader      	:= {}
	Local aCols        	:= {}
	Local aAlterGDa    	:= {}
	Local cAliasOrg		:= GetArea()
	Local aColsEx 		:= {}, aFill := {}
	Local aFieldTit 	:= {}
	Local aAlterFields  := {}
	Local _aFields 		:= {}
	
	
	Private oDlgPgt1, aFill := {}, oMSNewGe1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0] 
	
	default _cOpc := ""
    
    if(_cOpc == '1')
    	aFieldTit 		:= 				{"Tipo"		,"Suframa ?"	,"Código Produto" ,"Descrição","Inativo?"  ,"Pagina"   ,"Seq"    }
    	aAlterFields  	:= _aFields := {"Z9_TIPO"	,"Z9_SUFRAMA"	,"Z9_PRODUTO"	  ,"Z9_DESCRI","Z9_MSBLQL" ,"Z9_PAGCAT","Z9_SEQ"	}
    ElseIf(_cOpc == '2') 
    	aFieldTit 		:= 				{"Vendedor" ,"Nome"		}
    	aAlterFields  	:= _aFields := {"Z9_VEND" 	,"Z9_NOME"	}
    Else
    	aFieldTit 		:= 				{"Codigo" ,"Descricao","Abreviatura" 	,"Ordem Impressao", "Inativo?"  ,"Imprime na Lista"	,"Promoção"		}
    	aAlterFields  	:= _aFields := {"Z8_COD" ,"Z8_DESCRI","Z8_ABREV"		,"Z8_ORDEM"       , "Z8_MSBLQL" ,"Z8_IMPLP"			,"Z8_PROMOC"	}
    EndIf
   
	//Array com os campos que é permitida alteração.
	aAlterGDa := aAlterFields


	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100,  15, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	
	aPosObj := MsObjSize(aInfo, aObjects)
		
	
	nUsado:=0
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aFields)
		If SX3->(DbSeek(_aFields[nX]))
			Aadd(aHeader, {aFieldTit[nx],;
							aAlterFields[nx],;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
	                       	SX3->X3_USADO,;
	                       	SX3->X3_TIPO,;
	                       	SX3->X3_F3,;
	                       	"R"})   
	  		nUsado:=nUsado+1
	    Endif
	Next nX 
	
	AADD( aHeader, { "Recno WT", "Z9_REC_WT", "", 09, 0,,, "N", "SZ9", "V"} )

	//Insere produtos caso exista
   	if(_cOpc == '1')
   		
		dbSelectArea("SZ9")
		dbSetOrder(3)    
		dbGoTop()
		if dbSeek(xFilial("SZ9")+SZ8->Z8_COD)
			While (!EOF() .AND. SZ8->Z8_COD == SZ9->Z9_COD)
//		    	if(!Vazio(SZ9->Z9_PRODUTO))
		    		AADD(aCols,{SZ9->Z9_TIPO	,;
		    					SZ9->Z9_SUFRAMA	,;
	    						IIF(SZ9->Z9_TIPO == '1',SZ9->Z9_PRODUTO,Space(TamSX3('Z9_PRODUTO')[1])),;
	    						IIF(SZ9->Z9_TIPO == '1',PADR(Posicione("SB1",1,xFilial("SB1")+SZ9->Z9_PRODUTO,"B1__DESCP"),TamSX3("Z9_DESCRI")[1]),SZ9->Z9_DESCRI),;
		    					SZ9->Z9_MSBLQL	,;
								SZ9->Z9_PAGCAT	,;
								SZ9->Z9_SEQ	  	,;	
	    			            SZ9->(Recno())	,;
	    						.F.})
//		    	EndIf
                DbSelectArea("SZ9")
                DbSkip()
			EndDo
			// Ordernar o Acols
			ASort(aCols,,,{|aX,aY| aX[6]+aX[7] < aY[6]+aY[7]})
		endif
	Elseif(_cOpc == '2')   
		dbSelectArea("SZ9")
		dbSetOrder(1)    
		dbGoTop()
		if dbSeek(xFilial("SZ9")+SZ8->Z8_COD)
			While (!EOF() .AND. SZ8->Z8_COD == SZ9->Z9_COD)
				if(!Vazio(SZ9->Z9_VEND))
		    		AADD(aCols,{SZ9->Z9_VEND 		,;
		    			Posicione("SA3",1,xFilial("SA3")+SZ9->Z9_VEND,"A3_NOME") ,;
		    					SZ9->(Recno())		,;
		    					.F.})
		  		EndIf
		    dbSkip()
			EndDo
		endif  
	EndIf   
	
	if(Empty(aCols))
		AADD(aCols,Array(nUsado+2))
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		For nx := 1 To nUsado
			aCols[len(aCols)][nx] := Criavar(aHeader[nx][2])
		Next
		
		aCols[len(aCols)][nUsado+1] := 0                          
		aCols[len(aCols)][nUsado+2] := .f.  
	EndIf	

	RegToMemory("SZ9", .F.)
	
	
	DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL 
	
	if(!INCLUI)
		@aSize[7]+5,20  Say "Identificação: " + SZ8->Z8_COD + " - " + SZ8->Z8_DESCRI	SIZE 145,40 OF oDlg PIXEL
    EndIf
    

	aAdd( aButtons,{"EDIT",{|| MsgRun( "" , "" , { || Ins_Linha(oGetD:aCols)} )},"Adic.Linha"})

	oGetD:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,cLinOk,cTudoOK, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, aHeader, aCols)
	
	oDlg:bInit := {|| EnchoiceBar(oDlg, {||aColsD:= oGetD:aCols, iif(_cOpc == '1',U_IFINP02P(aColsD),iif(_cOpc == '2',U_IFINP02R(aColsD),U_IFINP02I(aColsD))),oDlg:End()},{||oDlg:End()},,aButtons)}
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return

//	aAdd( aButtons,{"EDIT",{|| MsgRun( "Marcando..." , "Marcando..." , { || ALERT("TESTE")} )},"Produtos"})

Static Function Ins_Linha(AcolsD)
  	
Local aColsx := aClone(AcolsD)
Local aItensx:= {} 

Local nPos 	 := oGetD:NAT
Local nTam 	 := Len(aColsx)

aColsx		:= aSize(aColsx,Len(aColsx)+1)                                         	
aColsx		:= aIns(aColsx,nPos)
aColsx[nPos]:= AADD(aItensx,{Criavar("Z9_TIPO")  ,;
							 Space(TamSX3('Z9_SUFRAMA')[1]),;
							 Space(TamSX3('Z9_PRODUTO')[1]),;
							 Space(TamSX3('Z9_DESCRI')[1]),;
 							 Criavar("Z9_MSBLQL"),;
 							 Space(TamSX3('Z9_PAGCAT')[1]),;
 							 Space(TamSX3('Z9_SEQ')[1]),;
 							 0,;
 							 .F.})
aColsD		:= {}
aColsD		:= aColsx

oGetD:oBrowse:nLen := Len(AColsD)
oGetD:Refresh(.T.)         
oGetD:Goto(nPos)
//oGetD:SetEditLine(.T.)    

Return(AcolsD)
      

/*
+-----------+----------+-------+----------------------------------+------+---------------+
| Programa  | IFINP01K | Autor | Silverio Bastos - Anadi Soluções | Data | Setembro/2014 |
+-----------+----------+-------+----------------------------------+------+---------------+
| Descricao | Funcao Tudo OK no MSGEtdados 															  | 
+-----------+----------------------------------------------------------------------------+
| Uso       | ISAPA																		   				  |
+-----------+----------------------------------------------------------------------------+
*/ 

User Function IFINP01K(aColsX)     

Local aColsXI 	:= aColsX
Local _nPos_Seq:= ASCAN(oGetD:aHeader, { |x| AllTrim(x[2]) == "Z9_SEQ" 	})

// Gravacao dos Itens na Tabela SZ9 - na ordem Z9_SEQ
For ix:= 1 to len(aColsXI)
	
	aColsXI[ix][_nPos_Seq] := strzero(ix,4)   

Next ix

aColsX	:= aColsXI

oGetD:Refresh(.T.)         

Return(AcolsXI)     

/*
+-----------+----------+-------+----------------------------------+------+---------------+
| Programa  | ValProd  | Autor | Rubens Cruz - Anadi Soluções 	  | Data | Maio/2015	 |
+-----------+----------+-------+----------------------------------+------+---------------+
| Descricao | Verifica se o produto inserido já existe no ACOLS							 | 
+-----------+----------------------------------------------------------------------------+
| Uso       | ISAPA																		 |
+-----------+----------------------------------------------------------------------------+
*/ 

Static Function ValProd(_aColsX,_cProd,_nAt)
Local _lRet	:= .T.     

//Alert("teste")                  

Return _lRet