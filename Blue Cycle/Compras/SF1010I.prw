#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} SF1010I
Ponto de Entrada para alteração de status do Pedido de venda à partir da 
Nota fiscal de devolução.

@author	Breno Menezes
@since	
@param	
@return

Alteracoes Realizadas desde a Estruturacao Inicial
Data			Programador		Motivo
01/04/13		Ederson Colen	Reestruturaçã do Fonte e inclusão da tratativa
									do Fator 2 (Dentro e Fora)
/*/
//------------------------------------------------------------------- 
User Function SF1100i()
Private cQuery := ""   

/*

	cQuery := "SELECT D1_SERIORI, D1_NFORI, SUM (D1_TOTAL) D1_TOTAL "
	cQuery += "FROM " + RetSqlName("SD1") + " D1 "
	cQuery += "WHERE D1.D_E_L_E_T_ <> '*' "
	cQuery += " AND D1.D1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND D1.D1_SERIE =  '"+SD1->D1_SERIE+"'"
	cQuery += " AND D1.D1_DOC = '"+SD1->D1_DOC+"' AND D1.D1_FORNECE = '"+SD1->D1_FORNECE+"' AND D1.D1_LOJA =  '"+SD1->D1_LOJA+"'"
	cQuery += " GROUP BY D1_SERIORI, D1_NFORI "

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"QDA1",.F.,.T.)   
	
	QDA1->(dbGoTop())

	//cContIt := 	StrZero(1,(TamSX3("DA1_ITEM")[01]))



	While QDA1->(! EoF()) */
If SF1->F1_TIPO = 'D'
        If SF1->F1_VALBRUT = Posicione("SF2",1,xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI,"F2_VALBRUT")
        	DbSelectArea("SC6")
        	DbSetOrder(4)
        	IF DbSeek(xFilial("SC6")+SD1->D1_NFORI+SD1->D1_SERIORI)
        		DbSelectArea("SC5")
        		DbSetOrder(1) 
        		If DbSeek(xFilial("SC5")+SC6->C6_NUM)
        			RecLock("SC5",.F.)
        			SC5->C5__STATUS := "13"
        			MsUnlock("SC5")
        		EndIf
        	EndIf
        EndIf
        
        u_ClasDev()	
        	         
EndIf        	                   
	 //	QDA1->(dbSkip())

	//EndDo


	
Return(Nil)    












User Function CLASDEV()
Local oButton1, oButton2
Local oSay1, oSay2,oSay5
Local _cQuery 	:= ""
Local _cTab		:= ""
private cMotDev := Space(6)
private cDesc := Posicione("SA4",1,xFilial("SA4") + SF1->F1_TRANSP,"A4_NOME")
private cDepto := ""
private cTicket := SPACE(12)
private cDescCond := Posicione("SE4",1,xFilial("SE4") + SC7->C7_COND,"E4_DESCRI")
private _nFrete := _nFator := _nFTot := 0
private _cConheci := space(9)  
private _nFrete2 := 0                        
private _cConheci2 := space(9)
private oDesc, oTransp, oCond, oDescCond, oDepto, oTicket
Private oCombo
Private aItens	:= {"F=FOB",;
					"C=CIF"}  
Private cList		:= " "   
Private oCond1, oCond2  
Private oDlg     
 
Private oComboBo1
Private aItens1	:= {"F=FOB",;
					"C=CIF"} 
Private oGet1
Private oGet2
Private cGet2 := Space(30)
Private oSay3
Private oSay4
Public cGetReds  := Space(6)
Public cRedspach := "F" 


cCond := SC7->C7_COND

DEFINE MSDIALOG oDlg TITLE "DETALHAMENTO DA DEVOLUÇÃO" FROM 000, 000  TO 270, 500 PIXEL

    @ 010, 005 SAY oSay1 PROMPT "Informe o motivo da devolução de venda: " SIZE 127, 007 OF oDlg PIXEL
    @ 025, 005 SAY oSay2 PROMPT "Motivo:  " SIZE 038, 007 OF oDlg PIXEL
    @ 023, 050 MSGET oTransp VAR cMotDev SIZE 030, 010 OF oDlg PICTURE "@!" F3 "SZT" VALID VALMOT() PIXEL
    @ 040, 005 SAY oSay2 PROMPT "Descrição:  " SIZE 038, 007 OF oDlg PIXEL
    @ 050, 005 MSGET oDesc VAR cDesc SIZE 241, 010 OF oDlg READONLY PIXEL
    @ 067, 005 SAY oSay2 PROMPT "Departamento Responsável:  " SIZE 127, 007 OF oDlg PIXEL
    @ 077, 005 MSGET oDepto VAR cDepto SIZE 241, 010 OF oDlg READONLY PICTURE "@!"  PIXEL
    @ 094, 005 SAY oSay2 PROMPT "Número do Ticket SAC   " SIZE 127, 007 OF oDlg PIXEL
    @ 104, 005 MSGET oTicket VAR cTicket SIZE 150, 010 OF oDlg PICTURE "@!"  PIXEL    
    
    /*@ 060,005 SAY oSay5 PROMPT "Tipo do Frete" SIZE 038, 007 OF oDlg PIXEL
    @ 058,050 MSCOMBOBOX oCombo VAR cList ITEMS aItens SIZE 040, 010 OF oDlg PIXEL VALID valTpF() 
    
    //somente se o frete for FOB habilito estes campos abaixo
    @ 080, 005 SAY oSay1 PROMPT "Valor do Frete" SIZE 038, 007 OF oDlg PIXEL 
    @ 078, 050 MSGET oCond1 VAR _nFrete SIZE 060, 010 OF oDlg PICTURE "@E 99,999,999.99"  PIXEL 
    @ 080, 120 SAY oSay1 PROMPT "Nro. Conhecimento" SIZE 050, 007 OF oDlg PIXEL
    @ 078, 170 MSGET oCond2 VAR _cConheci SIZE 060, 010 OF oDlg PICTURE "@!"  PIXEL 

    @ 100, 005 SAY oSay1 PROMPT "Informe a Condição de Pagamento do documento de entrada" SIZE 150, 007 OF oDlg PIXEL
    @ 115, 005 SAY oSay2 PROMPT "Condição de Pagamento" SIZE 070, 007 OF oDlg PIXEL
    @ 114, 070 MSGET oCond VAR cCond SIZE 060, 010 OF oDlg PICTURE "@!" F3 "SE4"  PIXEL

    @ 130, 006 MSGET oDescCond VAR cDescCond SIZE 241, 010 OF oDlg READONLY PIXEL   
    
    @ 150, 008 SAY oSay3 PROMPT "Transportadora Redespacho:" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 180, 008 SAY oSay4 PROMPT "Tipo Frete Redespacho:" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL
   	@ 160, 008 MSGET oGet1 VAR cGetReds F3 "SA4" SIZE 036, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID ValTra(cGetReds) 
	@ 160, 049 MSGET oGet2 VAR cGet2 SIZE 147, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
 	//@ 190, 008 MSCOMBOBOX oComboBo1 VAR cRedspach ITEMS {"F=FOB","C=CIF"} SIZE 040, 010 OF oDlg COLORS 0, 16777215 VALID valTpF1() PIXEL  
 	@ 190, 008 MSCOMBOBOX oComboBo1 VAR cRedspach ITEMS aItens1 SIZE 040, 010 OF oDlg PIXEL VALID valTpF1() 
 	
    //somente se o frete for FOB habilito estes campos abaixo
    @ 210, 008 SAY oSay1 PROMPT "Valor do Frete" SIZE 038, 007 OF oDlg PIXEL 
    @ 208, 050 MSGET oCond3 VAR _nFrete2 SIZE 060, 010 OF oDlg PICTURE "@E 99,999,999.99"  PIXEL 
    //@ 210, 120 SAY oSay1 PROMPT "Nro. Conhecimento" SIZE 050, 007 OF oDlg PIXEL
    //@ 208, 170 MSGET oCond4 VAR _cConheci2 SIZE 060, 010 OF oDlg PICTURE "@!" PIXEL  */
    
    @ 104, 165 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {||_lOK := valGrMot()} PIXEL
    @ 104, 205 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION {||_lOK := .f.,oDlg:End()} PIXEL
    
ACTIVATE MSDIALOG oDlg CENTERED
  
If _lOk
  	If Reclock("SF1",.f.)
  		SF1->F1_MOTDEV 	:= cMotDev
  		SF1->F1_CODTKT 	:= cTicket
       

  		MsUnlock()
	EndIf
EndIf

/*
	DbSetOrder(1)
	If SD1->(DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		do while SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			if Reclock("SD1",.f.)  
			
				//SD1->D1__VLRFRE := SD1->D1_TOTAL * _nFator //_nFrete * (SD1->D1_TOTAL / _nTotalNota)
				//SD1->D1__NRCONH := _cConheci
				
		     	MsUnlock()     
		    endif
	  		SD1->(dbSkip())
	  	enddo
	EndIf   


/*	_nTotalNota := 0
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
		do while SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			_nTotalNota += SD1->D1_TOTAL
	  		SD1->(dbSkip())
	  	enddo
	EndIf*/
	
	//Calcula o total de todas as notas de entrada do mesmo conhecimento de frete para fazer o rateio
  /*	_cTab := GetNextAlias()

  	If Select(_cTab) > 0
		DbSelectArea(_cTab)
		DbCloseArea()
	EndIf
	


EndIf */

Return
      

static function VALMOT()
	_lret := .T.
	
	if ! ExistCpo("SZT",cMotDev)
		_lret := .F.	
	else
		cDesc := Posicione("SZT",1,xFilial("SZT")+cMotDev,"ZT_DESC")
		cDepto := SZT->ZT_DEPTO
	endif                                                             

return _lret



static function valGrMot()
	_lret := .T.
	
	If Empty(cMotDev)
    	msgAlert ("Por favor, informe o código da devolução" )
		_lret := .F.		
	ElseIf Empty(cTicket) .AND. cMotdev <> "000013" .and. cMotDev <> "000014"
    	msgAlert ("Nos casos de devoluções de venda é obrigatório a digitação do número do ticket (SAC)." + chr(13) + "Por favor, informe o número do ticket.")
		_lret := .F.	 
	endif 
	
	if _lret
		oDlg:End()
	endif                                                  

return _lret
