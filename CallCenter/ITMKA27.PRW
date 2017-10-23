#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*{Protheus.doc} MyFunction
Description
                                                                
@param xParam Parameter Description                             
@return xRet Return Description
@author Silverio Bastos - Anadi Solucoes -                                               
@since 13/10/2014
*/                                                             
//--------------------------------------------------------------
User Function ITMKA27()
	Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}

	Local oSay1
	Local oSay10
	Local oSay11
	Local oSay12
	Local oSay13
	Local oSay14
	Local oSay15
	Local oSay16
	Local oSay17
	Local oSay18
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local nItens := Len(aCols)
	Local _nPosPro	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	Private oComboBo1
	Private nComboBo1 := 1
	Private oComboBo2
	Private nComboBo2 := 1
	Private oComboBo3
	Private nFrete  := Space(TamSx3("UA_TPFRETE")[1])

	Private cSeg
	Private cDscTPPd := Space(TamSx3("UA__DSCTIP")[1])
	Private cLJCOB   := Space(TamSx3("UA__LJACOB")[1])
	Private cUFTABPrc:= Space(2)
	Private cTabPrc  := space(TamSx3("UA__TABPRC")[1])
	Private cDscPgt  := Space(50)
	Private cCond    := Space(TamSx3("UA_CONDPG")[1])
	Private cTPPed   := Space(TamSx3("UA__TIPPED")[1])
	Private cReserv  := Space(3)
	Private dDTFat   := Date()
	Private dData    := Date()
	Private cEmp     := space(40)
	Private cAtend   := Space(TamSx3("UA_NUM")[1])
	Private cFL	     := Space(TamSx3("UA_FILIAL")[1])
	Private cLJ      := Space(TamSx3("UA_LOJA")[1])
	Private cCli     := Space(TamSx3("UA_CLIENTE")[1])
	Private cTransp  := Space(TamSx3("UA_TRANSP")[1])
	Private cDTransp := Space(80)
	
	Private oTransp  
	Private oDTransp 
	
	Private oDscTPPd 
	Private oLJCOB   
	Private oUFTABPrc
	Private oTabPrc  
	Private oDscPgt  
	Private oCond    
	Private oTPPed 
	Private oReserv  
	Private oDTFat   
	Private oData   
	Private oEmp   
	Private oAtend   
	Private oFL	   
	Private oLJ      
	Private oCli    
	Private oSButton1
	Private oSButton2
	Static oDlg

	oFont := tFont():New("Tahoma",,-14,,.t.)
    aSize := MsAdvSize()

	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)
	

	cAtend 		:= M->UA_NUM
	nComboBo2   := M->UA_TMK
	cFL	 		:= SM0->M0_CODFIL
	cReserv := "Sim"
	/*
	if M->UA_CLIENTE  <> "" 
	cCli 	:= M->UA_CLIENTE  
	cLJ  	:= M->UA_LOJA
	cFL  	:= M->UA__FILIAL	
	cTPPed 	:= M->UA__TIPPED
	IF M->UA__RESEST == "N"
		cReserv := "Nao"
	Else
		cReserv := "Sim"
	Endif
    
    cCond := M->UA_CONDPG
	
	IF M->UA__PRIORI := "0"
		nComboBo2 ="0" 
	Elseif 	M->UA__PRIORI := "1"
		nComboBo2 ="1"
	Else
		nComboBo2 ="2"
	Endif

   
    nFrete  := M->UA_TPFRETE 
    cTransp := M->UA_TRANSP  

	Endif
     */

  	DEFINE MSDIALOG oDlg TITLE "Atendimento" FROM aSize[7],0 To aSize[6],aSize[5] COLORS 0, 16777215 PIXEL
	nLinha  := aPosObj[1,1] + 4
	nLin02  := aPosObj[1,1] + 20
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,020,045,058,150,170,128,143,172,186,205,222,250,270}})

    @ 026, 019 SAY oSay2 PROMPT "Markenting" SIZE 050, 009 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 038, 018 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS {"1=Receptivo","2=Ativo","3=Fax","4=Representantes","5=Direto"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
   
    @ 027, 100 SAY oSay3 PROMPT "Cliente" SIZE 025, 009 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 027, 195 SAY oSay4 PROMPT "Loja" SIZE 025, 009 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont	
    if Empty(aCols[nItens][_nPosPro])
    	@ 037, 100 MSGET oCli VAR cCli SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "SA1LIK" PIXEL FONT oFont Valid fPsqCli() 
    	@ 037, 195 MSGET oLJ  VAR cLJ  SIZE 017, 010 OF oDlg COLORS 0, 16777215 F3 "SUALJ1" PIXEL FONT oFont VALID fValLJ()
    Else
    	@ 037, 100 MSGET oCli VAR cCli SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "SA1LIK" READONLY PIXEL FONT oFont Valid fPsqCli() 
    	@ 037, 195 MSGET oLJ  VAR cLJ  SIZE 017, 010 OF oDlg COLORS 0, 16777215 F3 "SUALJ1" READONLY PIXEL FONT oFont VALID fValLJ()
    Endif
    
    @ 027, 312 SAY oSay5 PROMPT "Filial" SIZE 025, 009 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 037, 311 MSGET oFL VAR cFL SIZE 031, 010 OF oDlg COLORS 0, 16777215 F3 "SM0" PIXEL FONT oFont
    
    @ 055, 018 SAY oSay6 PROMPT "Atendimento" SIZE 050, 009 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 067, 018 MSGET oAtend VAR cAtend SIZE 073, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont
    
    @ 055, 100 SAY oSay7 PROMPT "Empresa" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 067, 100 MSGET oEmp VAR cEmp        SIZE 120, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont
    
    @ 055, 246 SAY oSay8 PROMPT "Data" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 067, 245 MSGET oData  VAR dData  SIZE 054, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont
   
    @ 055, 313 SAY oSay9 PROMPT "Data Faturamento" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont 
    @ 067, 312 MSGET odDTFat VAR dDTFat            SIZE 054, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont Valid fValFat()

    @ 080, 018 SAY oSay10 PROMPT "Reserva Est." SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 092, 019 MSGET oReserv VAR cReserv        SIZE 073, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont
  
    @ 080, 100 SAY oSay11 PROMPT "Tipo Pedido" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 092, 100 MSGET oTPPed VAR cTPPed         SIZE 073, 010 OF oDlg COLORS 0, 16777215 F3 "SZF" PIXEL FONT oFont VALID fValTPPED() 

    @ 080, 244 SAY oSay17 PROMPT "Desc Tp Pedido" SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 092, 245 MSGET oDscTPPd VAR cDscTPPd        SIZE 063, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont

    @ 108, 018 SAY oSay12 PROMPT "Condição" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont  
    @ 118, 019 MSGET oCond VAR cCond        SIZE 030, 010 OF oDlg COLORS 0, 16777215 F3 "SE4" PIXEL FONT oFont Valid fValCond()   

    @ 108, 100 SAY oSay13 PROMPT "Desc Cond PG" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 118, 100 MSGET oDscPgt VAR cDscPgt        SIZE 153, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL FONT oFont

    @ 135, 019 SAY oSay14 PROMPT "Tab.Preco" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 145, 019 MSGET oTabPrc VAR cTabPrc     SIZE 039, 010 OF oDlg COLORS 0, 16777215 READONLY F3 "DA0" PIXEL FONT oFont


    @ 135, 100 SAY oSay15 PROMPT "UF Tab Prc" SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 145, 100 MSGET oUFTABPrc VAR cUFTABPrc  SIZE 039, 010 OF oDlg COLORS 0, 16777215 READONLY F3 "DA0" PIXEL FONT oFont


    @ 108, 313 SAY oSay16 PROMPT "Loja Cobrança" SIZE 055, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 118, 312 MSGET oLJCOB VAR cLJCOB           SIZE 039, 010 OF oDlg COLORS 0, 16777215 READONLY F3 "SUALJ2" PIXEL FONT oFont


    @ 135, 313 SAY oSay18 PROMPT "Separação" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 145, 312 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"0=Normal","1=Urgente","2=Avarias"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont

    @ 158, 019 SAY oSay16 PROMPT "Transportadora" SIZE 055, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 168, 019 MSGET oTransp VAR cTransp          SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "SZITRP" PIXEL FONT oFont Valid fTransp()


	@ 158, 100 SAY oSay16 PROMPT "Razao Transp." SIZE 055, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 168, 100 MSGET oDTransp VAR cDTransp       SIZE 160, 010 OF oDlg COLORS 0, 16777215 READONLY  PIXEL FONT oFont

    @ 158, 313 SAY oSay18 PROMPT "Tipo Frete" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
    @ 168, 312 MSCOMBOBOX oComboBo3 VAR nFrete ITEMS {"C=CIF","F=FOB"} SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont


	IF M->UA_TMK = "1"
		nComboBo2	:= "1=Receptivo"
	Elseif M->UA_TMK = "2"
		nComboBo2	:= "2=Ativo"
	ElseIf M->UA_TMK = "3"
		nComboBo2	:="3=Fax"
	ElseIf M->UA_TMK = "4"	
		nComboBo2	:="4=Representantes"
	ElseIf M->UA_TMK = "5"
		nComboBo2	:="5=Direto"
    Endif
	oComboBo2:Refresh()

    DEFINE SBUTTON oSButton1 FROM 185, 309 TYPE 01 OF oDlg ENABLE ACTION (fCarreg() )
    DEFINE SBUTTON oSButton2 FROM 185, 346 TYPE 02 OF oDlg ENABLE ACTION (oDlg:End() )

  ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fPsqCli()
    
    local _aArea := getArea()
	
    If Empty(cCli)
    	Alert("Favor Informar Codigo do Cliente")
    	Return .F.
    Endif                              
	
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		cSeg := SZ1->Z1_SEGISP
	else
		cSeg := '0'
	endif	


   	DbSelectArea("SA1")
	DbSetOrder(1)
	IF DbSeek(xFilial()+cCli,.T.)
		M->UA_CLIENTE	:= cCli
		cLJ	 			:= SA1->A1_LOJA
		M->UA_LOJA	  	:= SA1->A1_LOJA
		cEmp 			:= TkDCliente(cCli,cLJ)
		M->UA__FILIAL 	:= U_ITMKA19(cCli,cLJ,cSeg)
		//cFL	 		  	:= U_ITMKA19(cCli,cLJ,cSeg)
		M->UA__SEGISP 	:= cSeg
		M->UA__LJAENT 	:= U_ITMKA04("1") //IIF(VAZIO(SA1->A1__LJAENT),SA1->A1_LOJA,SA1->A1__LJAENT)
		//cLJ := M->UA__LJAENT
		M->UA__LJACOB := U_ITMKA04("2") //IIF(VAZIO(SA1->A1__LJACOB),SA1->A1_LOJA,SA1->A1__LJACOB)
		cLJCOB := M->UA__LJAENT
		cTPPed :="1"
		M->UA__UFTAB := SA1->A1_EST
		cUFTABPrc    := M->UA__UFTAB
	    cTABPRC		 := getMV("MV__TABBRA")
	    Return .T.
	Else
		Alert("Cliente não encontrado.")
		Return .F.
	Endif		
	restarea(_aArea)

	
Return

Static Function fValLJ()
    Local lRet := .T.
    
    local _aArea := getArea()
	
    If Empty(cLJ)
    	Alert("Favor Informar Loja do Cliente")
    	Return .F.
    Endif      

	
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		cSeg := SZ1->Z1_SEGISP
	else
		cSeg := '0'
	endif	


   	DbSelectArea("SA1")
	DbSetOrder(1)
	IF DbSeek(xFilial()+cCli+cLJ,.T.)

		cEmp := TkDCliente(cCli,cLJ)
		cLJ	 := SA1->A1_LOJA
		
		M->UA_LOJA	  := SA1->A1_LOJA
		M->UA__FILIAL := U_ITMKA19(cCli,cLJ,cSeg)
		//cFL	 		  := U_ITMKA19(cCli,cLJ,cSeg) 
		M->UA_VEND    := SA1->A1_VEND
		M->UA__SEGISP := cSeg
		M->UA__LJAENT := IIF(VAZIO(SA1->A1__LJAENT),SA1->A1_LOJA,SA1->A1__LJAENT)
		M->UA__LJACOB := IIF(VAZIO(SA1->A1__LJACOB),SA1->A1_LOJA,SA1->A1__LJACOB)
		cTPPed :="1"
		M->UA__UFTAB := SA1->A1_EST
		cUFTABPrc    := M->UA__UFTAB
	    cTABPRC		 := getMV("MV__TABBRA")
	Else
		Alert("Loja não encontrada.")
		lRet := .F.
	Endif
		
	restarea(_aArea)


    oTPPed:SetFocus()
    
    
Return lRet   

Static Function fValTPPed() 
	Local lRet := .T.
	
	dbSelectArea("SZF")
	dbSetOrder(1)
	if dbSeek(xFilial("SZF")+cTPPed)
		cDscTPPd 	 := SZF->ZF_DESC
		M->UA__TIPPED := cTPPed
		M->UA__PEDORI := M->UA__TIPPED
		IF Alltrim(M->UA__TIPPED) == "4"           
			M->UA_OPER := "2"
		Elseif M->UA__TIPPED != "4"                              	    
			M->UA_OPER := "1"
		Endif			
		        
		if Alltrim(M->UA__TIPPED) == "4"           
			M->UA__RESEST := "N"
			cReserv := "Nao"
		Else
			cReserv := "Sim"
			M->UA__RESEST := "S"		
		Endif
		M->UA__PRVFAT := dDTFat	
		oCond:SetFocus()
		Else
			Alert("Tipo de Pedido não encontrado")
		    lRet := .F.
		Endif

Return

Static Function fValCond()
	Local lRet	:= .T.
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	If dbSeek(xFilial("SE4")+cCond)
		cDscPgt := SE4->E4_DESCRI
		oTransp:SetFocus()
	Else
		Alert("Condição de Pagamento não encontrada.")
		lRet	:= .F.
	Endif
	   

	
Return lRet

Static Function fValFat() 
    Local lRet := .T.
	If dDTFat < dDatabase
		Alert("Data do Faturamento não pode ser inferior a Data Atual do sistema.")
		lRet := .F.
	Endif
	
Return lRet

Static Function fCarreg()
	M->UA_CLIENTE   := cCli
	M->UA_LOJA		:= cLJ 
	M->UA__FILIAL	:= cFL
	M->UA__TIPPED   := cTPPed
	M->UA__PEDORI   := M->UA__TIPPED
	IF Alltrim(M->UA__TIPPED) == "4"           
		M->UA_OPER := "2"
	Elseif M->UA__TIPPED != "4"                              	    
		M->UA_OPER := "1"
	Endif			
	if Alltrim(M->UA__TIPPED) == "4"           
		M->UA__RESEST := "N"
		cReserv := "Nao"
	Else
		cReserv := "Sim
		M->UA__RESEST := "S"		
	Endif
    M->UA_CONDPG	:= cCond
//	M->UA__UFTAB := cUFTABPrc
	
	IF nComboBo2 ="0" 
		M->UA__PRIORI := "0"
	Elseif nComboBo2 ="1"
		M->UA__PRIORI := "1"
	Else
		M->UA__PRIORI := "2"	
	Endif

	M->UA__TABPRC := getMV("MV__TABBRA")
    
    M->UA_TPFRETE := nFrete
    M->UA_TRANSP  := cTransp

	oDlg:End()
Return

Static Function fTransp()
    Local lRet	:= .T.

    If cTransp == "" 
         Alert("Favor informar a transportadora.")
         lRet := .F.
    Else  
       	cDTransp := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")     
		nFrete   := posicione("SA4",1,xFilial("SA4")+cTransp,"A4__TPFRET")         
	Endif	
Return lRet

	                                                       