#INCLUDE "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH"



	User Function ITMKA34()
	
		LOCAL cFiltro     := ""
		PRIVATE cAlias    := 'SU4'
		PRIVATE cCadastro := "Agenda"
		PRIVATE aRotina     := {{"Pesquisar"   , "AxPesqui"         	, 0, 1 },;
		                        {"Visualizar"  , "U_ITMKA34A(2)"   		, 0, 2 },;
		                        {"Incluir"     , "U_ITMKA34A(3)"   		, 0, 3 },;
		                        {"Alterar"     , "U_ITMKA34A(4)"   		, 0, 4 },;
		                        {"Excluir"     , "U_ITMKA34D"   		, 0, 5 }}
		
			
		dbSelectArea("SU4")
		dbSetOrder(1)
		
	
		mBrowse( ,,,,"SU4",,,,,,,,,,,,,,cFiltro)
		
	
	Return    
	

	User Function ITMKA34V()
	
		AxVisual("SU4",SUA->(RECNO()),1)
	
	Return                                                                    

	User Function ITMKA34A(nOpc)
		Local aArea     := GetArea()
		Local oDlg
		Local nCntFor   := 0
		Local cCadastro := "Agenda do Operador"
		Local aObjects  := {}
		Local aPosObj   := {}
		Local aSizeAut  := MsAdvSize()  
		Local nReg	:= 0
	//	PRIVATE cCampos := "U4_FILIAL,U4_LISTA,U4_DESC,U4_DATA,U4_FORMA,U4_TELE,U4_OPERAD,U4_TIPOTEL,U4_STATUS,U4_TIPO,U4_HORA1,U4_CLIENTE,U4_LOJA,U4_CONTATO,U4_NREDUZ,U4_ASSUNTO"
		PRIVATE cCampos := "U4_FILIAL,U4_LISTA,U4_DATA,U4_FORMA,U4_OPERAD,U4_TIPOTEL,U4_HORA1,U4_CLIENTE,U4_LOJA,U4_CONTATO,U4_NREDUZ,U4_ASSUNTO"
		Private aCampos := {'NOUSER'}
		Private nCampos	:= 0
        Private cLista  := ""
		dbSelectArea("SU4")
//		RegToMemory("SU4",.F.,,,,FunName())
		                                                                                                                    
		
		aCampos := strtokarr(cCampos ,",")
		
		nCampos := Len( aCampos )
		
		/*	+----------------------------------------------------------------+
			|   Montagem de Variaveis de Memoria                             |
			+----------------------------------------------------------------+
		*/
		
		
		
		IF nOpc <> 3
			RegToMemory("SU4",.F.,,,,FunName())
			
			dbSelectArea("SU4")
			dbSetOrder(1)
			For nCntFor := 1 To FCount()
			   	For nCntF := 1 To nCampos
				   IF FieldName(nCntFor) == aCampos[nCntF]
				  	 M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
				   Endif	 
				Next nCntF    
			Next nCntFor 
	

			M->U4_FILIAL  := SU4->U4_FILIAL
			M->U4_CLIENTE := SU4->U4_CLIENTE
			M->U4_LOJA 	  := SU4->U4_LOJA			
			M->U4_LISTA   := SU4->U4_LISTA
			M->U4_DESC	  := SU4->U4_DESC  		//"Atendimento: "
			M->U4_DATA	  := SU4->U4_DATA
			M->U4_FORMA	  := SU4->U4_FORMA
			M->U4_TELE	  := SU4->U4_TELE
			M->U4_OPERAD  := SU4->U4_OPERAD
			M->U4_TIPOTEL := SU4->U4_TIPOTEL	// 1=Residencial 2=Fax 3=Celular 4=Comercial 1 5=Comercial 2
			M->U4_CODLIG  := SU4->U4_CODLIG     // Codigo do atendimento
			M->U4_STATUS  := SU4->U4_STATUS 	//With Iif(cTipo=="2" .And. ALTERA,"3","1")      	// Status da Lista 1=Pendente 2=Encerrada      
			M->U4_TIPO	  := SU4->U4_TIPO		//	With cTipo		// Tipo da Lista 1=Marketing 2=Vendas 3=Cobranca
			M->U4_HORA1   := SU4->U4_HORA1 		//  With cTimeR
		    M->U4_CONTATO := SU4->U4_CONTATO

		Else
			RegToMemory("SU4",.T.,,,,FunName())
			DbSelectArea("SU4")
			dbSetOrder(1)
			FOR nCntFor := 1 TO FCount()
				For nCntF := 1 To nCampos
					IF FieldName(nCntFor) == aCampos[nCntF]
						If ValType(M->&(FieldName(nCntFor)) ) = "C"
							M->&(FieldName(nCntFor))  := SPACE(LEN(M->&(FieldName(nCntFor)) ))
						ElseIf ValType(M->&(FieldName(nCntFor)) ) = "N"
							M->&(FieldName(nCntFor))  := 0
						ElseIf ValType(M->&(FieldName(nCntFor)) ) = "D"
							M->&(FieldName(nCntFor))  := CtoD("  /  /  ")
						ElseIf ValType(M->&(FieldName(nCntFor)) ) = "L"
							M->&(FieldName(nCntFor))  := .F.
						EndIf
					Endif	
					Next nCntF	
			Next nCntFor
		
			M->U4_FILIAL  := xFilial("SU4")
			cLista		  := GetSXENum("SU4","U4_LISTA")
			M->U4_LISTA   := cLista
			M->U4_DATA	  := dDatabase
			M->U4_OPERAD  := TKOPERADOR()
			M->U4_STATUS  := SU4->U4_STATUS 	
			M->U4_HORA1   := TIME()
			
			
		Endif
		

		
		aObjects := {} 
		AAdd( aObjects, { 415, 100, .T., .T. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
		aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
		aPosObj := MsObjSize( aInfo, aObjects, .T. ) 
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL 
		EnChoice( "SU4" ,nReg ,nOpc , , ,  , aCampos , aPosObj[1],aCampos, 3)
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||IIF( IIF(nOpc == 3 .Or. nOpc == 4, ITMKA34A(nOpc) , .T.) ,(oDlg:End()), )},{|| oDlg:End()})


		RestArea(aArea)
		
	Return(.T.)

	
	Static Function ITMKA34A(nOpc)
		Local lRet	:= .T.
	    //Local cLISTA   := M->U4_LISTA
		Local cCODENT  := M->U4_CLIENTE + M->U4_LOJA
		Local cCONTATO := M->U4_CONTATO
		Local cDATA    := M->U4_DATA
		Local cHRINI   := M->U4_HORA1



		
		If Empty(M->U4_DATA) 
			Alert("Favor verificar Data.")
			Return .F.
		Endif
		If M->U4_DATA < dDatabase
			Alert("Favor verificar Data nao pode ser inferior a Data do Sistema.")
			Return .F.
		Endif

		If Empty(M->U4_DATA)
			Alert("Favor verificar Hora .")
			Return .F.
		Endif
         
			IF nOpc == 3
				RecLock("SU4",.T.)
				SU4->U4_FILIAL   	:= xFilial("SU4")
				SU4->U4_LISTA    	:= cLista
				SU4->U4_DESC		:= "Atendimento: " + cLista  //"Atendimento: "
			Else
				RecLock("SU4",.F.)
			Endif				
			SU4->U4_DATA		:= M->U4_DATA
			SU4->U4_FORMA		:= M->U4_FORMA  		// 1=Voz 2=Fax 3=Cross Posting 4=mala Direta 5=Pendencia 6=WebSite
			SU4->U4_TELE		:= "2" //M->U4_TELE
			SU4->U4_OPERAD		:= M->U4_OPERAD
			SU4->U4_TIPOTEL		:= M->U4_TIPOTEL 	// 1=Residencial 2=Fax 3=Celular 4=Comercial 1 5=Comercial 2
			SU4->U4_CLIENTE		:= M->U4_CLIENTE
			SU4->U4_LOJA		:= M->U4_LOJA
			SU4->U4_NREDUZ 		:= M->U4_NREDUZ
			SU4->U4_ASSUNTO		:= M->U4_ASSUNTO
			SU4->U4_CONTATO     := M->U4_CONTATO
			//SU4->U4_CODLIG   With cCodLig  	// Codigo do atendimento
			SU4->U4_STATUS   	:= "1"      	// Status da Lista 1=Pendente 2=Encerrada      
			SU4->U4_TIPO		:= "3"		    // Tipo da Lista 1=Marketing 2=Vendas 3=Cobranca
			SU4->U4_HORA1       := M->U4_HORA1
			MsUnlock()
			ConfirmSX8()
		    
			IF nOpc == 3
				RecLock("SU6",.T.)
				SU6->U6_FILIAL  := xFilial("SU6")	
				SU6->U6_FILENT  := xFilial("SU6")
				SU6->U6_CODIGO  := GetSXENum("SU6","U6_CODIGO")
				SU6->U6_LISTA   := cLISTA
				SU6->U6_DTBASE  := dDataBase
			Else
				DbSelectArea("SU6")
				DbSetOrder(1)
				// Se nao for possivel alterar - incluir um novo item para a Lista
				If DbSeek(xFilial("SU6")+cLista)
					RecLock("SU6",.F.)
				Else
					SU6->U6_FILIAL  := xFilial("SU6")	
					SU6->U6_FILENT  := xFilial("SU6")
					SU6->U6_CODIGO  := GetSXENum("SU6","U6_CODIGO")
					SU6->U6_LISTA   := cLista
					SU6->U6_DTBASE  := dDataBase
					nOpc := 3
				Endif				
            Endif
			
			SU6->U6_ENTIDA  := "SA1"
			SU6->U6_CODENT  := cCODENT
			SU6->U6_ORIGEM  := "3"				//1=Lista 2=Manual 3=Atendimento
			SU6->U6_CONTATO := cCONTATO
			SU6->U6_DATA    := cDATA
			SU6->U6_HRINI   := cHRINI
			SU6->U6_HRFIM 	:= "23:59"
			SU6->U6_STATUS  := "1"    			//1=Nao Enviado 2=Enviado
			//SU6->U6_CODLIG  := cCodLig
			MsUnlock()
	        
		    
		    IF nOpc == 3
				ConfirmSX8()
				lRet := .T.
		    Endif
		
		    lRet := .T.
	                                                                                                                                                                   8
	Return(lRet)
	 
	
	User Function ITMKA34D()

	axDeleta("SU6",SU6->(RECNO()),4)
	
	Return
	
	User Function fuSU4()
		axCadastro("SU4")
	Return