#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | SF1140I  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Baixa a quantidade de Material em transito entre as filiais      |
|          | na entrada da Pré-nota na filial de destino.                     |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function SF1140I

Local aArea		:= GetArea(), _cSQL := ""
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea()), _aSD1 := SD1->(GetArea())
Local cLocal	:= ""
Local cCgcCli	:= Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
Local cFilDest	:= ""
Local cEstoque	:= ""
Local aItens	:= {}
Local aLinha	:= {} 
Local _lTrans	:= .F.
Local lImport	:= .F. 
private cCond	:= ""

//WMSINT()
ITRPNFE() //Transportadora

//Grava o segmento do documento
//Jorge Alves - Setembro/2014
DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
     If Reclock("SF1",.f.)
		SF1->F1__SEGISP := Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1__SEGISP")
     	MsUnlock()
     EndIf
     
     If SF1->F1_EST == "EX" .Or. !Empty(Alltrim(SF1->F1__PROIMP))
   	 	lImport := .T. 	
     EndIf
     
EndIf       

DbSelectArea("SZE")
DbSetOrder(1)
DbGoTop()
While !(eof())
	If(Alltrim(SZE->ZE_CGC) == Alltrim(cCgcCli) )
    	_lTrans := .T.
    	Exit
    EndIf 
	DbSkip()
EndDo


//------------------------- Gravações de bloqueios na Z04 - Luis -------------------------------

If !_lTrans .AND. SF1->F1_TIPO == 'N' .And. !lImport  
	nPosPedido	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_PEDIDO"})
	nPosQuant	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"})
	nPosItemPC	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEMPC"}) //<-mesma variavel D1_ITEM e D1_ITEMPC
	nPosValorU	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
	nPosCodPro	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
	nPosIPI		:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_IPI"})
	nPosItem	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEM"}) //<-mesma variavel D1_ITEM e D1_ITEMPC
	_aBloqs 	:= {}
	
	//Exclui ocorrencia de fornecimento da NF caso já exista
	_cSQL := "Update " + RetSqlName("Z05") + " "
	_cSQL += "Set D_E_L_E_T_ = '*' "
	_cSQL += "Where Z05_FILIAL = '" + SF1->F1_FILIAL + "' And Z05_DOC = '" + SF1->F1_DOC + "' And Z05_SERIE = '" + SF1->F1_SERIE + "' And "
	_cSQL +=       "Z05_CLI = '" + SF1->F1_FORNECE + "' And Z05_LOJA = '" + SF1->F1_LOJA + "' And D_E_L_E_T_ = ' ' "
	TCSQLExec(_cSQL)
	
	//Limpa flag de aprovação
	If Reclock("SF1",.f.)
	    SF1->F1__WMSBLQ := ""
	    SF1->F1__WMSAPR := ""
	    SF1->F1__WMSDAP := CTOD("  /  /  ")
	    SF1->F1__WMSHAP := ""
	    SF1->(MsUnlock())
	EndIf
	
	For x:=1 To Len(aCols)   
		If !(aCols[x][Len(aCols[x])])     
			dbSelectArea("SC7")
			dbSetOrder(1)
			If dbSeek (xFilial("SC7")+aCols[x][nPosPedido]+aCols[x][nPosItemPC])
				if aCols[x][nPosValorU] != SC7->C7_PRECO    // valida preço - código 066				
					aadd(_aBloqs, {"066", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
	
				if aCols[x][nPosQuant] > SC7->C7_QUANT    // valida quantidade - código 065				
					aadd(_aBloqs, {"065", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
	
				if dDataBase > SC7->C7_DATPRF    // valida data de entrega - código 069				
					aadd(_aBloqs, {"069", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
	
				if cCond != SC7->C7_COND    // valida condição de pagamento - código 068
					aadd(_aBloqs, {"068", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
	               
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek (xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek (xFilial("SB1")+aCols[x][nPosCodPro])
				
				if SB1->B1_PESO == 0   // valida peso - código 067				
					aadd(_aBloqs, {"067", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
				
				if aCols[x][nPosIPI] != SB1->B1_IPI    // valida ipi - código 090				
					aadd(_aBloqs, {"090", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif		
	
				if (SA2->A2__IPI == '1' .and. aCols[x][nPosIPI] == 0 .and. SB1->B1_IPI > 0) .or. (SA2->A2__IPI != '1' .and. aCols[x][nPosIPI] > 0)   // valida ipi divergente - código 088				
					aadd(_aBloqs, {"088", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
				endif
			Else
				aadd(_aBloqs, {"097", aCols[x][nPosItem], aCols[x][nPosCodPro], aCols[x][nPosPedido]})
			EndIf
		EndIf
	Next x  
	
	for x:=1 to len(_aBloqs)
	
		_cCodBloq	:= _aBloqs[x][1]
		_cItem		:= _aBloqs[x][2]
		_cProduto	:= _aBloqs[x][3]  
		_cPedido	:= _aBloqs[x][4]  
		
		dbSelectArea("Z05")
	 	if reclock("Z05",.T.)
	 		Z05->Z05_FILIAL	:= xFilial("Z05")
	 		Z05->Z05_NUM	:= _cPedido
	 		Z05->Z05_ITEM	:= _cItem
	 		Z05->Z05_CODIGO	:= _cCodBloq
	 		Z05->Z05_DESC	:= posicione("Z04",1,xFilial("Z04")+_cCodBloq,"Z04_DESC")
	 		Z05->Z05_TIPO	:= '4'
	 		Z05->Z05_CLI	:= SF1->F1_FORNECE 
	 		Z05->Z05_LOJA	:= SF1->F1_LOJA
	 		Z05->Z05_PRODUT	:= _cProduto
	 		Z05->Z05_DOC	:= SF1->F1_DOC 
	 		Z05->Z05_SERIE	:= SF1->F1_SERIE
		 	msUnlock()
	 	endif
	 	
	 	DbSelectArea("SF1")
	 	If SF1->F1__WMSBLQ != "1"
	        If Reclock("SF1",.f.)
	            SF1->F1__WMSBLQ := "1"
	            MsUnlock()                                                                         
	        EndIf
	 	EndIf
	
	next x
ElseIf !_lTrans .AND. SF1->F1_TIPO == 'D'
	If Reclock("SF1",.F.)
	    SF1->F1__WMSBLQ := "1"
	    SF1->F1__WMSAPR := ""
	    SF1->F1__WMSDAP := CTOD("  /  /  ")
	    SF1->F1__WMSHAP := ""
	    SF1->(MsUnlock())
	EndIf
EndIf

//------------------------- fim de gravações de bloqueios na Z04


If SF1->F1_TIPO == "N" .and. Empty(SF1->F1_STATUS)
	
	DbSelectArea("SM0")
	DbGoTop()
	
	While !EOf()
		
		IF cCgcCli == SM0->M0_CGC
			cFilDest := SM0->M0_CODFIL
			Exit
		ENDIF
		
		DbSkip()
		
	EndDo
	
	RestArea(aAreaSM0)
	
	If Empty(cFilDest)
		RestArea(aAreaSB2)
		RestArea(aArea)
		Return
	EndIf
	
	/*
	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	If DbSeek(cFilDest+ SF1->F1_DOC + SF1->F1_SERIE)
		
		While !Eof() .AND. SD2->D2_FILIAL == cFilDest .AND. SD2->D2_DOC == SF1->F1_DOC .AND. SD2->D2_SERIE == SF1->F1_SERIE
			
			aLinha := {}
			AAdd(aLinha,{SD2->D2_DOC		})
			AAdd(aLinha,{SD2->D2_SERIE		})
			AAdd(aLinha,{SD2->D2_COD		})
			AAdd(aLinha,{Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ESTOQUE")})
			AAdd(aItens,aLinha)
			
			DbSelectArea("SD2")
			DbSkip()
			
		EndDo
		
		For i:=1 to Len(aItens)
			
			If  aItens[i][4][1] == "S"
				
				DbSelectArea("SD1")
				DbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				If DbSeek(xFilial("SD1")+ aItens[i][1][1] + aItens[i][2][1] + SF1->F1_FORNECE + SF1->F1_LOJA + aItens[i][3][1])
					
					cLocal	:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_LOCPAD")
					
					DbSelectArea("SB2")
					DbSetOrder(1)
					If DbSeek(xFilial("SD1")+SD1->D1_COD+cLocal)
						If SB2->B2__QTDTRA >= SD1->D1_QUANT
							//Retira o produto da quantidade em transito e passa para quantidade disponivel, quando se tratar de transferencia
							Do While !reclock("SB2", .F.)
							EndDo
							SB2->B2__QTDTRA := SB2->B2__QTDTRA - SD1->D1_QUANT 
							SB2->B2__QTDISP := SB2->B2__QTDISP + SD1->D1_QUANT 
						    msUnlock()
                        EndIf
					EndIf
					
				EndIf
				
			Endif
			
		Next
	EndIf
	*/
EndIf

RestArea(_aSD1)
RestArea(aAreaSB2)
RestArea(aArea)

Return


/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | WMSINT   | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Realiza gravação do campo f1_wmsint caso haja alguma linha no    |
|          | documento de entrada, na inclusão da pré nota                    |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

Static Function WMSINT()

_aArea := getArea()

nPosWMSINT	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1__WMSINT"})

For x:=1 To Len(aCols)
	If !(aCols[x][Len(aCols[x])])
		_nD1__WMSINT := aCols[x][nPosWMSINT]
		exit
	EndIf
Next x

dbSelectArea("SF1")
if reclock("SF1", .F.)
	F1__WMSINT := _nD1__WMSINT
	msUnlock()
endif

restarea(_aArea)

return

//Informa a transportadora na pre-nota de entrada
//Jorge Henrique Alves - Outubro/2014
Static Function ITRPNFE()
Local oButton1, oButton2
Local oSay1, oSay2,oSay5
private cTransp := SF1->F1_TRANSP
private cDesc := Posicione("SA4",1,xFilial("SA4") + SF1->F1_TRANSP,"A4_NOME")
private cDescCond := Posicione("SE4",1,xFilial("SE4") + SC7->C7_COND,"E4_DESCRI")
private _nFrete := _nFator := 0
private _cConheci := space(9)
private oDesc, oTransp, oCond, oDescCond
Private oCombo
Private aItens	:= {"F=FOB",;
					"C=CIF"}
Private cList		:= " "   
Private oCond1, oCond2  
Private oDlg


cCond := SC7->C7_COND

DEFINE MSDIALOG oDlg TITLE "TRANSPORTADORA" FROM 000, 000  TO 360, 500 PIXEL

    @ 010, 052 SAY oSay1 PROMPT "Informe a Transportadora e do documentoo de entrada" SIZE 127, 007 OF oDlg PIXEL
    @ 025, 005 SAY oSay2 PROMPT "Transportadora" SIZE 038, 007 OF oDlg PIXEL
    @ 023, 050 MSGET oTransp VAR cTransp SIZE 060, 010 OF oDlg PICTURE "@!" F3 "SA4" VALID valTrans() PIXEL
    @ 040, 006 MSGET oDesc VAR cDesc SIZE 241, 010 OF oDlg READONLY PIXEL
    
    @ 060,005 SAY oSay5 PROMPT "Tipo do Frete" SIZE 038, 007 OF oDlg PIXEL
    @ 058,050 MSCOMBOBOX oCombo VAR cList ITEMS aItens SIZE 040, 010 OF oDlg PIXEL VALID valTpFre() 
    
    //somente se o frete for FOB habilito estes campos abaixo
    @ 080, 005 SAY oSay1 PROMPT "Valor do Frete" SIZE 038, 007 OF oDlg PIXEL 
    @ 078, 050 MSGET oCond1 VAR _nFrete SIZE 060, 010 OF oDlg PICTURE "@E 99,999,999.99"  VALID valCond() PIXEL 
    @ 080, 120 SAY oSay1 PROMPT "Nro. Conhecimento" SIZE 050, 007 OF oDlg PIXEL
    @ 078, 170 MSGET oCond2 VAR _cConheci SIZE 060, 010 OF oDlg PICTURE "@!" VALID valCond() PIXEL 

    @ 100, 052 SAY oSay1 PROMPT "Informe a Condição de Pagamento do documento de entrada" SIZE 150, 007 OF oDlg PIXEL
    @ 115, 005 SAY oSay2 PROMPT "Condição de Pagamento" SIZE 070, 007 OF oDlg PIXEL
    @ 114, 070 MSGET oCond VAR cCond SIZE 060, 010 OF oDlg PICTURE "@!" F3 "SE4" VALID valCond() PIXEL

    @ 130, 006 MSGET oDescCond VAR cDescCond SIZE 241, 010 OF oDlg READONLY PIXEL
    
    @ 150, 043 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {||_lOK := valGrava()} PIXEL
    @ 150, 151 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION {||_lOK := .f.,oDlg:End()} PIXEL
    
ACTIVATE MSDIALOG oDlg CENTERED
  
If _lOk
  	If Reclock("SF1",.f.)
  		SF1->F1_TRANSP 	:= cTransp
  		SF1->F1_COND 	:= cCond 
        SF1->F1_TPFRETE := cList 
  		MsUnlock()
	EndIf

	_nTotalNota := 0
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
		do while SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			_nTotalNota += SD1->D1_TOTAL
	  		SD1->(dbSkip())
	  	enddo
	EndIf
		
	_nFator := (_nFrete/_nTotalNota) //(_nFrete/SF1->F1_VALMERC)
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
		do while SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			if Reclock("SD1",.f.)  
			
					SD1->D1__VLRFRE := SD1->D1_TOTAL * _nFator //_nFrete * (SD1->D1_TOTAL / _nTotalNota)
				SD1->D1__NRCONH := _cConheci
				
		     	MsUnlock()
		    endif
	  		SD1->(dbSkip())
	  	enddo
	EndIf
	
EndIf

Return


static function valTrans()
	_lret := .T.
	
	if ! ExistCpo("SA4",cTransp)
		_lret := .F.	
	else
		cDesc := Posicione("SA4",1,xFilial("SA4") + cTransp,"A4_NOME")
	endif                                                             

return _lret


static function valGrava()
	_lret := .T.
	
	if cList == 'F' .and. _nFrete <= 0
    	msgAlert ("Em caso de frete tipo FOB o valor do mesmo tem que ser informado" + chr(13) + "Favor verificar !!")
		_lret := .F.
	endif           
	
	if _lret
		oDlg:End()
	endif                                                  

return _lret
	
	
static function valCond()
	_lret := .T.
	
	if ! ExistCpo("SE4",cCond)
		_lret := .F.	
	else
		cDescCond := Posicione("SE4",1,xFilial("SE4") + cCond,"E4_DESCRI")
	endif                                                             
return _lret
	                
Static Function valTpFre()
   
	If cList == "C" 
		oCond1:BWHEN := { || .F.}  
		oCond2:BWHEN := { || .F.} 
	ElseIf cList == "F"
		oCond1:BWHEN := { || .T.}   
		oCond2:BWHEN := { || .T.} 
	EndIf		

Return
	