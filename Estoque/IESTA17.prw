#include "protheus.ch"
#include "topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IESTA17			  		| 	Junho de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para consulta de movimento de estoque									 		|
|-------------------------------------------------------------------------------------------------------|
*/                  

User Function IESTA17()
Local _nLinha	:= 10
Local aStru		:= {{010,040,070},;
					{105,140,200}} 

Private _cFil		:= Space(TamSX3("ZO_FILIAL")[1])
Private _cNmFil	:= ""
Private _dDataDe	:= CTOD("  /  /    ")
Private _dDataAte	:= CTOD("  /  /    ")
Private _aPeds		:= {{.F.,"","","","","","","","","",0}} 

Private _oDlg
Private aSize       := MsAdvSize(.T.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
Private oOk      	:= LoadBitmap( GetResources(), "LBOK" )
Private oNo   	  	:= LoadBitmap( GetResources(), "LBNO" )
             

aObjects 	:= {}   
AAdd(aObjects,{100,150,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )    

DEFINE MSDIALOG _oDlg TITLE "Consulta de Visitas" FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
_oDlg:lMaximized := .F.

@ _nLinha,aStru[1][1] Say "Local: " 			SIZE 040,10 OF _oDlg PIXEL FONT oFont12 
@ _nLinha,aStru[1][2] MsGet _cFil  				Size 10,10 of _oDlg PIXEL FONT oFont12 F3 "DLB" VALID ValFil(_cFil)
@ _nLinha,aStru[1][3] MsGet _cNmFil  			Size 130,10 of _oDlg PIXEL FONT oFont12 WHEN .F.
_nLinha	+= 16
                                           
@ _nLinha,aStru[1][1] Say "Data De: " 			SIZE 040,10 OF _oDlg PIXEL FONT oFont12 
@ _nLinha,aStru[1][2] MsGet _dDataDe			Size 055,10 of _oDlg PIXEL FONT oFont12 
@ _nLinha,aStru[2][1] Say "Data Ate: " 			SIZE 040,10 OF _oDlg PIXEL FONT oFont12 
@ _nLinha,aStru[2][2] MsGet _dDataAte			Size 055,10 of _oDlg PIXEL FONT oFont12 
@ _nLinha,aStru[2][3] Button oButton PROMPT "Processar"		SIZE 40,11   OF _oDlg PIXEL ACTION FilDados() 
_nLinha	+= 16

@ 005,005 TO _nLinha,aPosObj[2][4] Of _oDlg PIXEL
_nLinha	+= 7

@ _nLinha,004 LISTBOX oLbx1 FIELDS HEADER "","Série","Documento","Dt. Mov.","Pedido", "Status", "Descrição Status","Cliente","Loja","Desc. Cliente","Recno WT";
								SIZE aPosObj[2][4]-5,aPosObj[2][3]-_nlinha-10,0,0 OF _oDlg PIXEL ON DBLCLICK (Marcar2(.F.,_aPeds))
oLbx1:SetArray(_aPeds)
oLbx1:bLine := { || {If(_aPeds[oLbx1:nAt,01],oOk,oNo),; 	  	//""
						Alltrim(_aPeds[oLbx1:nAt,02]),;         //Série
						Alltrim(_aPeds[oLbx1:nAt,03]),;         //Documento
						STOD(_aPeds[oLbx1:nAt,04])	 ,;         //Dt. Mov
						Alltrim(_aPeds[oLbx1:nAt,05]),;         //Pedido
						Alltrim(_aPeds[oLbx1:nAt,06]),;         //Status
						Alltrim(_aPeds[oLbx1:nAt,07]),;	 		//Descricao do Status
						Alltrim(_aPeds[oLbx1:nAt,08]),;         //Cliente
						Alltrim(_aPeds[oLbx1:nAt,09]),;         //Loja
						Alltrim(_aPeds[oLbx1:nAt,10]),;         //Descricao do Cliente
						_aPeds[oLbx1:nAt,11]}}         			//Recno SZP
						
@ aPosObj[2][3]-6,aPosObj[2][4]-150 Button oButton PROMPT "Visualizar"	SIZE 40,13   OF _oDlg PIXEL ACTION ( ConsPed() ) 
@ aPosObj[2][3]-6,aPosObj[2][4]-100 Button oButton PROMPT "Gerar"		SIZE 40,13   OF _oDlg PIXEL ACTION ( GerMov(),FilDados() ) 
@ aPosObj[2][3]-6,aPosObj[2][4]-050 Button oButton PROMPT "Sair"		SIZE 40,13   OF _oDlg PIXEL ACTION _oDlg:End() 

ACTIVATE MSDIALOG _oDlg CENTERED 


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
    
If Empty(_cFilial)
	_cNmFil := ""
ElseIf(dbSeek(cEmpAnt+_cFilial))
	_cNmFil :=  SZE->ZE_FILIAL
Else
	_cNmFil := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZE)
RestArea(_aArea)

Return lRet  


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : FilDados				 	| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Preenche os dados do ListBox da tela principal								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function FilDados()       
Local _lRet		:= .T.
Local _cQuery	:= "" 

If( Empty(_cFil) )
	Alert("Filial Em Branco")
	_lRet := .F.
ElseIf( Empty(_dDataDe) .OR. Empty(_dDataAte) )
	Alert("Período Em Branco")
	_lRet := .F.
EndIf

If _lRet
	If Select("TRB_SZO") > 0
		DbSelectArea("TRB_SZO")
		DbCloseArea()
	EndIf	

	_cQuery := "SELECT MAX(SF2.F2_SERIE) AS F2_SERIE,										" + Chr(13)
	_cQuery += "       MAX(SF2.F2_DOC) AS F2_DOC,                                           " + Chr(13)
	_cQuery += "       SF2.F2_EMISSAO,                                                		" + Chr(13)
	_cQuery += "       SUA.UA_NUM,                                                          " + Chr(13)
	_cQuery += "       SUA.UA__STATUS,                                                      " + Chr(13)
	_cQuery += "       SZM.ZM_DESC,                                                         " + Chr(13)
	_cQuery += "       SUA.UA_CLIENTE,                                                      " + Chr(13)
	_cQuery += "       SUA.UA_LOJA,                                                         " + Chr(13)
	_cQuery += "       SA1.A1_NREDUZ,                                                       " + Chr(13)
	_cQuery += "       SZP.R_E_C_N_O_ AS RECSZP                                             " + Chr(13)
	_cQuery += "FROM " + RetSqlName("SZO") + " SZO                                          " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SZP") + " SZP ON SZP.ZP_FILIAL = SZO.ZO_FILIAL   " + Chr(13)
	_cQuery += "                         AND SZP.ZP_CODIGO = SZO.ZO_CODIGO                  " + Chr(13)
	_cQuery += "                         AND SZP.ZP_CODCLI = SZO.ZO_CODCLI                  " + Chr(13)
	_cQuery += "                         AND SZP.ZP_LOJA = SZO.ZO_LOJA	                    " + Chr(13)
	_cQuery += "                         AND SZP.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = SZO.ZO_FILPED   " + Chr(13)
	_cQuery += "                         AND SUA.UA_NUM = SZO.ZO_PEDIDO                     " + Chr(13)
	_cQuery += "                         AND SUA.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL = SUA.UA_FILIAL   " + Chr(13)
	_cQuery += "                         AND SC5.C5__NUMSUA = SUA.UA_NUM                    " + Chr(13)
	_cQuery += "                         AND SC5.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SC5.C5_FILIAL   " + Chr(13)
	_cQuery += "                         AND SF2.F2_DOC = SC5.C5_NOTA                       " + Chr(13)
	_cQuery += "                         AND SF2.F2_SERIE = SC5.C5_SERIE                    " + Chr(13)
	_cQuery += "                         AND SF2.F2_CLIENTE = SC5.C5_CLIENTE                " + Chr(13)
	_cQuery += "                         AND SF2.F2_LOJA = SC5.C5_LOJACLI                   " + Chr(13)
	_cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SZM") + " SZM ON SZM.ZM_FILIAL = '  '            " + Chr(13)
	_cQuery += "                         AND SZM.ZM_COD = SUA.UA__STATUS                    " + Chr(13)
	_cQuery += "                         AND SZM.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '  '   			" + Chr(13)
	_cQuery += "                         AND SA1.A1_COD = SUA.UA_CLIENTE                    " + Chr(13)
	_cQuery += "                         AND SA1.A1_LOJA = SUA.UA_LOJA                      " + Chr(13)
	_cQuery += "                         AND SA1.D_E_L_E_T_ = ' '                           " + Chr(13)
	_cQuery += "WHERE SZO.D_E_L_E_T_ = ' '                                                  " + Chr(13)
	_cQuery += "      AND SZO.ZO_PEDIDO != ' '                                              " + Chr(13)
	_cQuery += "      AND SUA.UA_FILIAL = '" + _cFil + "'                                   " + Chr(13)
	_cQuery += "      AND SZO.ZO_BAIXA = ' '                                                " + Chr(13)
	_cQuery += "      AND SZO.ZO_CODPROD != ' '                                             " + Chr(13)
	_cQuery += "      AND SUA.UA_EMISSAO BETWEEN '" + DTOS(_dDataDe) + "' AND '" + DTOS(_dDataAte) + "' " + Chr(13)
	_cQuery += "GROUP BY SF2.F2_EMISSAO,                                                    " + Chr(13)
	_cQuery += "       SUA.UA_NUM,                                                          " + Chr(13)
	_cQuery += "       SUA.UA__STATUS,                                                      " + Chr(13)
	_cQuery += "       SZM.ZM_DESC,                                                         " + Chr(13)
	_cQuery += "       SUA.UA_CLIENTE,                                                      " + Chr(13)
	_cQuery += "       SUA.UA_LOJA,                                                         " + Chr(13)
	_cQuery += "       SA1.A1_NREDUZ,                                                       " + Chr(13)
	_cQuery += "       SZP.R_E_C_N_O_                                                       "
	TcQuery _cQuery New Alias "TRB_SZO"
	
	_aPeds := {}
	
	If !(Eof())
		Do While !(Eof())
			AADD(_aPeds,{.F.,;
						 TRB_SZO->F2_SERIE,;
						 TRB_SZO->F2_DOC,;
						 TRB_SZO->F2_EMISSAO,;
						 TRB_SZO->UA_NUM,;
						 TRB_SZO->UA__STATUS,;
						 TRB_SZO->ZM_DESC,;
						 TRB_SZO->UA_CLIENTE,;
						 TRB_SZO->UA_LOJA,;
						 TRB_SZO->A1_NREDUZ,;
						 TRB_SZO->RECSZP})
			TRB_SZO->(DbSkip())	
		EndDo
	Else
		MsgInfo("Nenhum resultado encontrado para esses parâmetros")
	EndIf
	
	TRB_SZO->(DbCloseArea())
	
	oLbx1:aArray := _aPeds
	oLbx1:Refresh()
	
	oLbx1:nAt := (Len(oLbx1:aArray))
	//_Instruc()
	oLbx1:nAt := 1
EndIf	

Return _lret            

*----------------------------------------
Static Function Marcar2(lTodos,aDados)
*----------------------------------------

If lTodos
	lMarcados := ! lMarcados
	For nI := 1 to Len(aDados)
		aDados[nI,1] := lMarcados
	Next
Else
	aDados[oLbx1:nAt,1] := ! aDados[oLbx1:nAt,1]
Endif
oLbx1:Refresh(.T.)
_oDlg:Refresh(.T.)

Return Nil                  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GerMov				 	| 	Junho de 2015				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Gera movimentação dos itens slecionados									  		|
|-----------------------------------------------------------------------------------------------|
*/

Static Function GerMov()
Local nX		:= nY := 0
Local cDoc		:= ""
Local aCab		:= {}
Local aItem 	:= {}                      
Local aItAux	:= {}
Local cTmSai	:= GetMv("MV__TMSAI") 
Local nOpcAuto	:= 3
Local _cFilAux	:= cFilAnt    
Local nSaldo	:= 0
Local nQtDisp	:= 0
Local aLocVen	:= Separa(GetMV("MV__CROSLO"),",")
Local cProdVaz	:= ""
Local _cQuery	:= ""
Local _nOk		:= 0
Local _cPeds	:= ""

Private lMsErroAuto := .F.

cFilAnt := _cFil

For nX:=1 To Len(_aPeds)
	If _aPeds[nX][1]
		aCab 	:= {}
		aItem 	:= {}

		Begin Transaction

			dbSelectArea("SD3")
			cDoc	:= NextNumero("SD3",2,"D3_DOC",.T.) //Pega o último número disponível do Documento da SD3
			cDoc	:= A261RetINV(cDoc) //Função que verifica se o código faz parte de inventario
	
			aCab := {	{"D3_DOC"    	, cDoc					,  	Nil},;
						{"D3_TM"     	, cTmSai  				,  	Nil},;
						{"D3_CC"     	, " "       			,  	Nil},;
						{"D3_EMISSAO"	, Date()	 		 	,  	Nil}}
	
			DbSelectArea("SZO")
			DbSetOrder(3)
			DbSeek(xFilial("SZO")+_cFil+_aPeds[nX][5])
						
			Do While(xFilial("SZO")+_cFil+_aPeds[nX][5] == SZO->(ZO_FILIAL+ZO_FILPED+ZO_PEDIDO) )
 				nSaldo 		:= SZO->ZO_QUANT
				aItAux 		:= {}
				cProdVaz 	:= ""
				
				If( !Empty(SZO->ZO_CODPROD) .AND. Empty(SZO->ZO_BAIXA) )
					//Verifica se tem saldo suficiente no armazem
					DbSelectArea("SB2")
					DbSetOrder(1)
					For nY := 1 To Len(aLocVen)        
						If DbSeek(SZO->ZO_FILPED + Padr(Alltrim(SZO->ZO_CODPROD),TamSX3("B2_COD")[1]) + aLocVen[nY])
							nQtDisp := SaldoSb2()
							If nQtDisp > nSaldo
								aadd(aItAux,{{"D3_TM"      	, cTmSai										,  	Nil},;
											{"D3_COD"   	, SZO->ZO_CODPROD  								,  	Nil},;
											{"D3_QUANT"     , nSaldo										,  	Nil},;
											{"D3_LOCAL"     , aLocVen[nY]									,  	Nil},;
											{"D3__OBS"      , "REF. PENDENCIA DE PEDIDO " + _aPeds[nX][5]	,  	Nil},;
											{"D3_EMISSAO"	, Date()	 									,  	NIL}})						
								nSaldo := 0
								Exit
							Else
								nSaldo := nSaldo - nQtDisp
								aadd(aItAux,{{"D3_TM"      	, cTmSai										,  	Nil},;
											{"D3_COD"      	, SZO->ZO_CODPROD  								,  	Nil},;
											{"D3_QUANT"     , nQtDisp										,  	Nil},;
											{"D3_LOCAL"     , aLocVen[nY]									,  	Nil},;
											{"D3__OBS"      , "REF. PENDENCIA DE PEDIDO " + _aPeds[nX][5]	,  	Nil},;
											{"D3_EMISSAO"	, Date()	 									,  	NIL}})						
							End
						EndIf
					Next nY
	
					If nSaldo <= 0
	                     For nY := 1 To Len(aItAux)
							Aadd(aItem,aItAux[nY])
					/*aadd(aItem,{{"D3_TM"      	, cTmSai										,  	Nil},;
								{"D3_COD"      	, SZO->ZO_CODPROD  								,  	Nil},;
								{"D3_QUANT"     , SZO->ZO_QUANT									,  	Nil},;
								{"D3_LOCAL"     , "01" 											,  	Nil},;
								{"D3__OBS"      , "REF. PENDENCIA DE PEDIDO " + _aPeds[nX][5]	,  	Nil},;
								{"D3_EMISSAO"	, Date()	 									,  	NIL}}) */
						Next nY
					Else           
						cProdVaz := SZO->ZO_CODPROD
						Exit
					EndIf
				EndIf
				SZO->(DbSkip())
			EndDo
			
			If(!Empty(cProdVaz))
				MsgAlert("Ocorreu o seguinte erro ao efetuar movimentação dos itens do pedido " + _aPeds[nX][5] + "." + Chr(10) + Chr(13) + ;
           				 " - Produto " + cProdVaz + " sem saldo")
				RollBackSX8()
			Else
				MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)

				If lMsErroAuto
					DisarmTransaction()
					//RollBackSX8()
		            If MsgYesNo("Ocorreu um erro ao efetuar movimentação dos itens do pedido " + _aPeds[nX][5] + "." + Chr(10) + Chr(13) + ;
		            			"Deseja visualizar os detalhes do erro?","Aviso")
						MostraErro()
					EndIf
				else
					//ConfirmSX8()

					_cPeds += cDoc + ';'
					//Se o Execauto gravou corretamente, preenche campo baixa na SZO
					_cQuery := "Update " + RetSqlName("SZO") 
					_cQuery += " Set ZO_BAIXA = '1' "
					_cQuery += "Where ZO_FILPED = '" + _cFil + "' And ZO_PEDIDO = '" + _aPeds[nX][5] + "' And D_E_L_E_T_ = ' ' And ZO_BAIXA = ' ' "
					
					_nOK := TCSQLExec(_cQuery)
					     
					If _nOK < 0
					    DbSelectArea("SZO")
					    DbSetOrder(3)
					    If MsSeek(xFilial("SZO") + _cFil + _aPeds[nX][5])
					        While !Eof() .And. (xFilial("SZO") + _cFil + _aPeds[nX][5] == SZO->(ZO_FILIAL+ZO_FILPED+ZO_PEDIDO) )
					            If Empty(SZO->ZO_BAIXA)
					                Reclock("SZO",.F.)
					                	SZO->ZO_BAIXA := "1"
					                MsUnlock()
					            EndIf
					            DbSkip()
					        EndDo
					    EndIf
					Else
						TCRefresh("SZO")
					Endif				
	
				EndIf
		
			EndIf		
		End Transaction

	EndIf
Next nX
               
If !Empty(_cPeds)
	MsgInfo("Pedidos Gerados: " + _cPeds)
EndIf

cFilAnt := _cFilAux

Return                     

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ConsPed				 	| 	Julho de 2015				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta Pedido posicionado no aCols									  		|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ConsPed()
Local _aArea := GetArea()

Private cCadastro	:="Pendencias de Pedido"
Private cAlias1		:= "SZP"
Private cAlias2		:= "SZO"                 
Private aRotina		:= {}
Private INCLUI		:= .T.
Private ALTERA		:= .T.
                 
aAdd( aRotina, {"Pesquisar"	, "AxPesqui" 	, 0, 1 })
aAdd( aRotina, {"Visualizar", "u_IFATA10A"	, 0, 2 })
aAdd( aRotina, {"Incluir"	, "u_IFATA10A"	, 0, 3 })
aAdd( aRotina, {"Alterar"	, "u_IFATA10A"	, 0, 4 })
aAdd( aRotina, {"Excluir"	, "u_IFATA10A"	, 0, 5 })


DbSelectArea(cAlias1) 
DbGoTo(_aPeds[oLbx1:nAt,11])
//RegToMemory( cAlias1,.T.)              

U_IFATA10A(cAlias1,_aPeds[oLbx1:nAt,11],4)

RestArea(_aArea)

Return