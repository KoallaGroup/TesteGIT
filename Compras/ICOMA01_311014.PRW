#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA01			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cadastro de Processo de Importação											  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA01()
               
	Local aCores := {{ "SZ2->Z2_STATUS=='1'" ,'BR_VERDE'},;		   	//ABERTO
			   	     { "SZ2->Z2_STATUS=='2'" ,'BR_AMARELO'},; 		//CANCELADO
			   	     { "SZ2->Z2_STATUS=='4'" ,'BR_AZUL'},; 			//PARCIALMENTE DESEMBARCADO
			   	     { "SZ2->Z2_STATUS=='3'" ,'BR_VERMELHO'}} 		//FECHADO
	
	Private aRotina  := {{"Pesquisar",		"AxPesqui",0,1} ,;
			             {"Visualizacao",	"U_TELASZ2",0,2},;
						 {"Inclusao",		"U_TELASZ2",0,3} ,;
			             {"Alteracao",		"U_TELASZ2",0,4} ,; 
			             {"Exclusao",		"U_TELASZ2",0,5},; 			             
			             {"Cancelamento",	"U_TELASZ2",0,6},; 			             
			             {"Desembarque",	"U_TELASZ2",0,7},; 			             
			             {"Legenda",		"U_ICOMA01LEG",0,0,0 ,.F.}} 

	dbSelectArea("SZ2")
	
	MBrowse( 6,1,22,75,'SZ2',,,,,,aCores)  
	
Return


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : TELASZ2			 		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela de Detalhamento do ítem												  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function TELASZ2(cAlias, nReg, nOpc)

	local cTitulo	:= "Cadastro de Processo de Importação"      
	local cValLinha	:= "u_validaLinha()"
	local cValTudo	:= "u_validaTudo(" + alltrim(str(nOpc)) + ")"

	Private aCols	:= {}
	Private aHeader	:= {}
	Private lEmbarque := .F.
	
	dbSelectArea("SZ2")
	
	For ni:= 1 to FCount()
		&("M->"+FieldName(ni)):=If((nOpc == 3) ,CriaVar(FieldName(ni)),FieldGet(ni))
	Next	

	CriaHeader()	
	CriaCols(nOpc)

	aCpoEnChoice := {"Z2_CODIGO"}

	if nOpc == 4
		_aAlter	:= {"Z2_DTENTPR", "Z2_INVOICE", "Z2_DTEMBAR", "Z2_PROFORM", "Z2_CODPROC", "Z2_NAVIO1", "Z2_NAVIO2"}     
		aButton := {}                                                                                                       
		
		Aadd( aButton, {"RECALC", { || AddItens() },"Adiciona Itens" } )
		
		lRet:=Modelo3(cTitulo,"SZ2","SZ3",aCpoEnChoice,cValLinha,cValTudo,nOpc,nOpc,,,,_aAlter,,aButton,,220)
	elseif nOpc == 7
	    
		_aAlter	:= {"Z2_DESEMBA"}
		lRet:=Modelo3(cTitulo,"SZ2","SZ3",aCpoEnChoice,cValLinha,cValTudo,4,4,,,,_aAlter,,,,220)
	
	else
		lEmbarque := .T.
		lRet:=Modelo3(cTitulo,"SZ2","SZ3",aCpoEnChoice,cValLinha,cValTudo,nOpc,nOpc,,,,,,,,220)
	endif

	
	if lRet
		U_GRVSZ2(nOpc)
	endif
		
Return
                                  

User Function validaLinha()
	Local nZ3_QTDEMBA:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDEMBA" })
	Local nZ3_VLEMBAR:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLEMBAR" })
	Local nZ3_QTDPED :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDPED" })

    if ! aCols[n][Len(aHeader)+1]
		if Acols[n][nZ3_QTDEMBA] == 0
			msgAlert("A quantidade embarcada deve ser preenchida !!")
			return .F.
		endif
	
		if Acols[n][nZ3_VLEMBAR] == 0
			msgAlert("O valor da mercadoria embarcada deve ser preenchido !!")
			return .F.
		endif
		
		if Acols[n][nZ3_QTDEMBA] > Acols[n][nZ3_QTDPED]
			msgAlert("A quantidade embarcada não pode ser superior a quantidade do pedido !!")
			return .F.
		endif
	endif
	
return .T.


User Function validaTudo(nOpc)

	if nOpc == 7 
		if empty(M->Z2_DESEMBA)
			msgAlert ("A data de Desembarque precisa ser preenchida !!")
			return .F.
		endif
	endif

return .T.


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : TrazPedido				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Busca o pedido, preenche os dados e chama a função que monta o acols		  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function TrazPedido()

	dbSelectArea("SC7")
	dbSetOrder(1)
	
	if dbSeek(xFilial("SC7")+M->Z2_PEDIDO)
	                                                     
		M->Z2_CODFOR 	:= SC7->C7_FORNECE
		M->Z2_LOJAFOR 	:= SC7->C7_LOJA
		M->Z2_NOMEFAN	:= posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ")
		M->Z2_STATUS 	:= "1"
		M->Z2_CONDPAG	:= SC7->C7_COND
		M->Z2_DESCCOND	:= posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")
		M->Z2_DTEMPED	:= SC7->C7_EMISSAO
		
		CriaCols(3)
		n := 1
		GETDREFRESH()		
		if len(aCols) == 0		
			msgAlert ("Pedido sem itens a serem processados !!")
			return .F.
		endif		     
	else
		msgAlert ("Pedido de Compra não Encontrado !!")
		return .F.	
	endif
	

return .T.


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : CriaHeader			   		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaHeader()
	aHeader      := {}

	aCpoHeader   := {"Z3_ITEM", "Z3_PEDIDO", "Z3_ITPEDCO", "Z3_PRODUTO", "Z3_DESCPRO", "Z3_CDPRDFO", "Z3_UNIDMED", "Z3_QTDPED", "Z3_VLRPEDI", "Z3_QTDEMBA", "Z3_VLEMBAR", "Z3_QTDESEM", "Z3_VLDESEM", "Z3_DSCINGL"}    
	
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
				cNivel >= SX3->X3_Nivel                  // Nivel do Usuario é maior que o Nivel do Campo.
			
				AAdd(aHeader, {Trim(SX3->X3_Titulo),;
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
	
Return Nil


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : CriaCols				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(nOpc)

	Local nQtdCpo := 0
	Local i       := 0
	Local nCols   := 0                                             

	Local nZ3_ITEM	 :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITEM" }) 
	Local nZ3_PEDIDO :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PEDIDO" })
	Local nZ3_ITPEDCO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITPEDCO" })
	Local nZ3_PRODUTO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PRODUTO" })
	Local nZ3_DESCPRO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DESCPRO" })
	Local nZ3_CDPRDFO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_CDPRDFO" })
	Local nZ3_UNIDMED:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_UNIDMED" })
	Local nZ3_QTDPED :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDPED" })
	Local nZ3_VLRPEDI:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLRPEDI" })
	Local nZ3_QTDEMBA:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDEMBA" })
	Local nZ3_VLEMBAR:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLEMBAR" })
	Local nZ3_DSCINGL:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DSCINGL" })
	Local nZ3_QTDESEM:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDESEM" })
	Local nZ3_VLDESEM:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLDESEM" })
	
	nQtdCpo := Len(aHeader)
	aCols   := {}
	n:=0                    

	if nOpc == 3   

	  	While ! Eof() .AND. SC7->C7_NUM == M->Z2_PEDIDO
			
			if SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA - C7__QTEMBA) > 0 .and. C7_RESIDUO != "S"  	
		      	AAdd(aCols, Array(nQtdCpo+1))
		      	n++
		      	
//				aCols[n][nQtdCpo+1]  := .F.
				Acols[n][nZ3_ITEM] 	 := strZero(n,4)
				Acols[n][nZ3_PEDIDO] := SC7->C7_NUM
				Acols[n][nZ3_ITPEDCO]:= SC7->C7_ITEM
				Acols[n][nZ3_PRODUTO]:= SC7->C7_PRODUTO
				Acols[n][nZ3_DESCPRO]:= posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
				Acols[n][nZ3_CDPRDFO]:= posicione("SA5",1,xFilial("SA5")+SC7->(C7_FORNECE+C7_LOJA)+SB1->B1_COD,"A5_CODPRF")
				Acols[n][nZ3_UNIDMED]:= SC7->C7_UM
				Acols[n][nZ3_QTDPED] := SC7->C7_QUANT
				Acols[n][nZ3_VLRPEDI]:= SC7->C7_TOTAL
				Acols[n][nZ3_QTDEMBA]:= SC7->C7_QUANT - SC7->C7__QTEMBA
				Acols[n][nZ3_VLEMBAR]:= SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7__QTEMBA)
				Acols[n][nZ3_QTDESEM]:= 0
				Acols[n][nZ3_VLDESEM]:= 0
				Acols[n][nZ3_DSCINGL]:= SB1->B1__DESCI
			    
			    aCols[n][Len(aHeader)+1] := .F.
			endif		    
	        DbSelectArea("SC7")
	        DbSkip()
	   	Enddo

	else
	
		dbSelectArea("SZ3")
		dbSetOrder(1)  
		if dbSeek(xFilial("SZ3") + M->Z2_CODIGO)
			do while SZ3->Z3_CODIGO == M->Z2_CODIGO
			
		      	AAdd(aCols, Array(nQtdCpo+1))
		      	n++
		      	
				aCols[n][nQtdCpo+1]  := .F.
				Acols[n][nZ3_ITEM] 	 := SZ3->Z3_ITEM
				Acols[n][nZ3_PEDIDO] := SZ3->Z3_PEDIDO
				Acols[n][nZ3_ITPEDCO]:= SZ3->Z3_ITPEDCO
				Acols[n][nZ3_PRODUTO]:= SZ3->Z3_PRODUTO
				Acols[n][nZ3_DESCPRO]:= posicione("SB1",1,xFilial("SB1")+SZ3->Z3_PRODUTO,"B1_DESC")
				Acols[n][nZ3_CDPRDFO]:= posicione("SA5",1,xFilial("SA5")+SZ2->(Z2_CODFOR+Z2_LOJAFOR)+SB1->B1_COD,"A5_CODPRF")
				Acols[n][nZ3_UNIDMED]:= SZ3->Z3_UNIDMED
				Acols[n][nZ3_QTDPED] := SZ3->Z3_QTDPED
				Acols[n][nZ3_VLRPEDI]:= SZ3->Z3_VLRPEDI
				Acols[n][nZ3_QTDEMBA]:= SZ3->Z3_QTDEMBA
				Acols[n][nZ3_VLEMBAR]:= SZ3->Z3_VLEMBAR
				Acols[n][nZ3_DSCINGL]:= SB1->B1__DESCI
				Acols[n][nZ3_QTDESEM]:= SZ3->Z3_QTDESEM
				Acols[n][nZ3_VLDESEM]:= SZ3->Z3_VLDESEM
			    
			    aCols[n][Len(aHeader)+1] := .F.
			
				SZ3->(dbSkip())
			enddo
		
		endif  
	  	   	
	endif
	
Return .T.


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : GRVSZ2			   		 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Gravação após validação														  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function GRVSZ2(nOpc)

	Local nZ3_ITEM	 :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITEM" }) 
	Local nZ3_PEDIDO :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PEDIDO" })
	Local nZ3_ITPEDCO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITPEDCO" })
	Local nZ3_PRODUTO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PRODUTO" })
	Local nZ3_DESCPRO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DESCPRO" })
	Local nZ3_CDPRDFO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_CDPRDFO" })
	Local nZ3_UNIDMED:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_UNIDMED" })
	Local nZ3_QTDPED :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDPED" })
	Local nZ3_VLRPEDI:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLRPEDI" })
	Local nZ3_QTDEMBA:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDEMBA" })
	Local nZ3_VLEMBAR:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLEMBAR" })
	Local nZ3_DSCINGL:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DSCINGL" })
	Local nZ3_QTDESEM:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDESEM" })
	Local nZ3_VLDESEM:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLDESEM" })

	if nOpc == 3   
		dbSelectArea("SZ2")
		if reclock("SZ2", .T.)	
			Z2_FILIAL 	:= xFilial('SZ2')
			Z2_CODIGO 	:= M->Z2_CODIGO
			Z2_SEGISP	:= M->Z2_SEGISP
			Z2_PEDIDO 	:= M->Z2_PEDIDO
			Z2_CODFOR 	:= M->Z2_CODFOR
			Z2_LOJAFOR	:= M->Z2_LOJAFOR
			Z2_STATUS 	:= M->Z2_STATUS
			Z2_CONDPAG	:= M->Z2_CONDPAG	
			Z2_DTEMPED	:= M->Z2_DTEMPED
			Z2_DTENTPR	:= M->Z2_DTENTPR
			Z2_INVOICE	:= M->Z2_INVOICE
			Z2_DTEMBAR	:= M->Z2_DTEMBAR
			Z2_PROFORM	:= M->Z2_PROFORM
			Z2_CODPROC	:= M->Z2_CODPROC
			Z2_NAVIO1	:= M->Z2_NAVIO1
			Z2_NAVIO2	:= M->Z2_NAVIO2
		
			msUnlock()
			confirmSX8()
		                       
		    nItem := 0
			for n := 1 to len(aCols)
				if reclock("SZ3", .T.)	 
					If !(aCols[n][Len(aCols[n])])
						nItem ++	        	
						SZ3->Z3_FILIAL	:= xFilial('SZ3')
						SZ3->Z3_CODIGO	:= M->Z2_CODIGO
						SZ3->Z3_SEGISP	:= M->Z2_SEGISP
						SZ3->Z3_CODFORN	:= M->Z2_CODFOR
						SZ3->Z3_LOJAFOR	:= M->Z2_LOJAFOR
						SZ3->Z3_ITEM	:= strZero(nItem,4) 	 
						SZ3->Z3_PEDIDO	:= Acols[n][nZ3_PEDIDO] 
						SZ3->Z3_ITPEDCO	:= Acols[n][nZ3_ITPEDCO]
						SZ3->Z3_PRODUTO	:= Acols[n][nZ3_PRODUTO]
						SZ3->Z3_UNIDMED	:= Acols[n][nZ3_UNIDMED]
						SZ3->Z3_QTDPED	:= Acols[n][nZ3_QTDPED] 
						SZ3->Z3_VLRPEDI	:= Acols[n][nZ3_VLRPEDI]
						SZ3->Z3_QTDEMBA	:= Acols[n][nZ3_QTDEMBA]
						SZ3->Z3_VLEMBAR	:= Acols[n][nZ3_VLEMBAR]
					endif
				endif
				
				dbSelectArea("SC7")
				dbSetOrder(1)
				if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
					if reclock("SC7", .F.)
						C7_DATPRF	:= M->Z2_DTENTPR
						C7__QTEMBA	+= Acols[n][nZ3_QTDEMBA]						
					endif					
				endif				        
				
			    _aCab := {}
			    _aItem := {}                              
	/*Jorge ALves - Outubro/2014
				dbSelectArea("SC7")
				dbSetOrder(1)
				if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
					Aadd(_aCab,{"C7_FILIAL", 	xFilial("SC7")	, Nil})
				   	Aadd(_aCab,{"C7_EMISSAO", 	SC7->C7_EMISSAO, Nil})
					Aadd(_aCab,{"C7_FORNECE", 	SC7->C7_FORNECE	, Nil})
					Aadd(_aCab,{"C7_LOJA", 		SC7->C7_LOJA	, Nil})
				    Aadd(_aCab,{"C7_NUM",		SC7->C7_NUM    	,NIL})
				    Aadd(_aCab,{"C7_COND",		SC7->C7_COND   	,NIL})
	 			    Aadd(_aCab,{"C7_CONTATO" ,	SC7->C7_CONTATO	,NIL})
				    Aadd(_aCab,{"C7_FILENT",	SC7->C7_FILENT 	,NIL})			    
		
					_aItens := {} 
				    aadd(_aItem,{"C7_ITEM",		SC7->C7_ITEM   	,NIL})
				    aAdd(_aItem,{"C7_PRODUTO",	SC7->C7_PRODUTO	,Nil})
				    aadd(_aItem,{"C7_QUANT",	SC7->C7_QUANT 	,NIL})
				    aAdd(_aItem,{"C7_PRECO",	SC7->C7_PRECO   ,Nil}) 
				    aAdd(_aItem,{"C7_TES",		SC7->C7_TES    	,Nil})
				    aadd(_aItem,{"C7_DATPRF",	M->Z2_DTENTPR 	,NIL})
				    aadd(_aItem,{"C7_CC",		SC7->C7_CC     	,NIL})			    
		    		aadd(_aItem,{"C7_REC_WT", 	SC7->(RECNO())  ,Nil})
				    
					aadd(_aItens,_aItem)
		
				    nOpc        := 4
				    lMsErroAuto := .F.
				    MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCab,_aItens,nOpc) 					
				    
				    if lMsErroAuto
				    	mostraErro()
				    endif
				endif	
*/				
			 next n		
		endif
		
	elseif nOpc == 4 
		
		dbSelectArea("SZ2")
		if reclock("SZ2", .F.)	
			Z2_DTEMPED	:= M->Z2_DTEMPED
			Z2_DTENTPR	:= M->Z2_DTENTPR
			Z2_INVOICE	:= M->Z2_INVOICE
			Z2_DTEMBAR	:= M->Z2_DTEMBAR
			Z2_PROFORM	:= M->Z2_PROFORM
			Z2_CODPROC	:= M->Z2_CODPROC
			Z2_NAVIO1	:= M->Z2_NAVIO1
			Z2_NAVIO2	:= M->Z2_NAVIO2
		
			msUnlock()
		endif

		for n := 1 to len(aCols)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			if dbSeek(xFilial("SZ3") + M->Z2_CODIGO + Acols[n][nZ3_ITEM])
								
				if reclock("SZ3", .F.)	 
					If !(aCols[n][Len(aCols[n])])
						_ndif := Acols[n][nZ3_QTDEMBA] - SZ3->Z3_QTDEMBA
						        	
						SZ3->Z3_QTDEMBA	:= Acols[n][nZ3_QTDEMBA]
						SZ3->Z3_VLEMBAR	:= Acols[n][nZ3_VLEMBAR]
						
						dbSelectArea("SC7")
						dbSetOrder(1)
						if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
							if reclock("SC7", .F.)
								SC7->C7__QTEMBA	+= _ndif						
								if SC7->C7__QTEMBA == 0
									SC7->C7_DATPRF	:= ctod("")
								else
									SC7->C7_DATPRF	:= M->Z2_DTENTPR
								endif
							endif					
						endif				    
					else
						dbSelectArea("SC7")
						dbSetOrder(1)
						if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
							if reclock("SC7", .F.)
								SC7->C7__QTEMBA	-= Acols[n][nZ3_QTDEMBA]
								if SC7->C7__QTEMBA == 0
									SC7->C7_DATPRF	:= ctod("")
								endif
							endif					
						endif				    
						
						dbSelectArea("SZ3")
						delete
					endif
				endif
				msUnlock()
			else
			
				if reclock("SZ3", .T.)	 
					If !(aCols[n][Len(aCols[n])])	        	
						SZ3->Z3_FILIAL	:= xFilial('SZ3')
						SZ3->Z3_CODIGO	:= M->Z2_CODIGO
						SZ3->Z3_SEGISP	:= M->Z2_SEGISP
						SZ3->Z3_CODFORN	:= M->Z2_CODFOR
						SZ3->Z3_LOJAFOR	:= M->Z2_LOJAFOR
						SZ3->Z3_ITEM	:= Acols[n][nZ3_ITEM] 	 
						SZ3->Z3_PEDIDO	:= Acols[n][nZ3_PEDIDO] 
						SZ3->Z3_ITPEDCO	:= Acols[n][nZ3_ITPEDCO]
						SZ3->Z3_PRODUTO	:= Acols[n][nZ3_PRODUTO]
						SZ3->Z3_UNIDMED	:= Acols[n][nZ3_UNIDMED]
						SZ3->Z3_QTDPED	:= Acols[n][nZ3_QTDPED] 
						SZ3->Z3_VLRPEDI	:= Acols[n][nZ3_VLRPEDI]
						SZ3->Z3_QTDEMBA	:= Acols[n][nZ3_QTDEMBA]
						SZ3->Z3_VLEMBAR	:= Acols[n][nZ3_VLEMBAR]
//						SZ3->Z3_DSCINGL	:= Acols[n][nZ3_DSCINGL]
					endif
				endif

				dbSelectArea("SC7")
				dbSetOrder(1)
				if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
					if reclock("SC7", .F.)
						C7_DATPRF	:= M->Z2_DTENTPR
						C7__QTEMBA	+= Acols[n][nZ3_QTDEMBA]						
					endif	 
				endif				    
				
			endif
		next n	
		
		dbSelectArea("SZ3")
		dbSetOrder(1)
		if dbSeek(xFilial("SZ3") + M->Z2_CODIGO)   
			nItem := 0
			do while SZ3->Z3_CODIGO == M->Z2_CODIGO  
				nItem ++
				if reclock("SZ3", .F.)	 
					SZ3->Z3_ITEM	:= strZero(nItem, 4)
					msUnlock()
				endif
				SZ3->(dbSkip())
			enddo
		endif
		
	elseif nOpc == 5 
                    
		dbSelectArea("SZ2")
		if reclock("SZ2", .F.)	
			delete		
			msUnlock()
		endif

		for n := 1 to len(aCols)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			if dbSeek(xFilial("SZ3") + M->Z2_CODIGO + Acols[n][nZ3_ITEM])
								
				if reclock("SZ3", .F.)	 
					dbSelectArea("SC7")
					dbSetOrder(1)
					if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
						if reclock("SC7", .F.)
							SC7->C7__QTEMBA	-= Acols[n][nZ3_QTDEMBA]
							if SC7->C7__QTEMBA == 0
								SC7->C7_DATPRF	:= ctod("")
							endif
						endif					
					endif				    
					
					dbSelectArea("SZ3")
					delete
				endif
				msUnlock()
			endif
		next n	


	elseif nOpc == 6 
                    
		dbSelectArea("SZ2")
		if reclock("SZ2", .F.)	
			SZ2->Z2_STATUS	:= '2'
			msUnlock()
		endif

		for n := 1 to len(aCols)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			if dbSeek(xFilial("SZ3") + M->Z2_CODIGO + Acols[n][nZ3_ITEM])
								
				if reclock("SZ3", .F.)	 
					dbSelectArea("SC7")
					dbSetOrder(1)
					if dbSeek (xFilial("SC7")+Acols[n][nZ3_PEDIDO]+Acols[n][nZ3_ITPEDCO])
						if reclock("SC7", .F.)
							SC7->C7__QTEMBA	-= Acols[n][nZ3_QTDEMBA]
							if SC7->C7__QTEMBA == 0
								SC7->C7_DATPRF	:= ctod("")
							endif
						endif					
					endif				    
					
				endif
				msUnlock()
			endif
		next n	

	elseif nOpc == 7 
                    
		_cStat := ""

		for n := 1 to len(aCols)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			if dbSeek(xFilial("SZ3") + M->Z2_CODIGO + Acols[n][nZ3_ITEM])
				if reclock("SZ3", .F.)	 
					SZ3->Z3_QTDESEM	:= Acols[n][nZ3_QTDESEM]
					SZ3->Z3_VLDESEM	:= Acols[n][nZ3_VLDESEM]
				
					msUnlock()                              
					if SZ3->Z3_QTDESEM <> SZ3->Z3_QTDEMBA .and. SZ3->Z3_QTDESEM > 0
						_cStat := "4"
					endif
					if SZ3->Z3_QTDESEM == SZ3->Z3_QTDEMBA .and. _cStat <> '4'
						_cStat := "3"
					endif
				endif
			endif
		next n	
        
		dbSelectArea("SZ2")
		if reclock("SZ2", .F.)	
			if _cStat <> ""
				SZ2->Z2_STATUS := _cStat
			endif
			SZ2->Z2_DESEMBA	:= M->Z2_DESEMBA
			msUnlock()
		endif
		
	endif
     
Return


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : ICOMALEG				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Legenda do Browse															  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA01LEG()
	Local aCores := {}
	aCores := {	{"BR_VERDE",OemToAnsi("Aberto")},;
			    {"BR_VERMELHO",OemToAnsi("Fechado")},;
			    {"BR_AZUL",OemToAnsi("Parcialmente Desembarcado")},;
			    {"BR_AMARELO",OemToAnsi("Cancelado")}}

	BrwLegenda(OemToAnsi("Legenda"),OemToAnsi("Status Aprovação"),aCores)
Return


/*
|-----------------------------------------------------------------------------------------------|	
|	Função : AddItens				 	| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Adição de novos itens do pedido	ao Processo de Importação					  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function AddItens()
	Local cTitulo := MvParDef := "", _nLen := _nTam := 0
	Local nZ3_ITEM	 :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITEM" }) 
	Local nZ3_PEDIDO :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PEDIDO" })
	Local nZ3_ITPEDCO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_ITPEDCO" })
	Local nZ3_PRODUTO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_PRODUTO" })
	Local nZ3_DESCPRO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DESCPRO" })
	Local nZ3_CDPRDFO:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_CDPRDFO" })
	Local nZ3_UNIDMED:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_UNIDMED" })
	Local nZ3_QTDPED :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDPED" })
	Local nZ3_VLRPEDI:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLRPEDI" })
	Local nZ3_QTDEMBA:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDEMBA" })
	Local nZ3_VLEMBAR:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_VLEMBAR" })
	Local nZ3_DSCINGL:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_DSCINGL" })
	Private _aRet := {}, _aCampos := {}
	
	nQtdCpo := Len(aHeader)
	cTitulo := "Itens do Pedido"   
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	if dbSeek (xFilial("SC7")+M->Z2_PEDIDO)
		do while SC7->C7_NUM == +M->Z2_PEDIDO
			_lInc := .T.

			for nx := 1 to len(aCols)            
				if Acols[nx][nZ3_ITPEDCO] == SC7->C7_ITEM
					_lInc := .F.
					exit
				endif		
			next nx
			
		    if _lInc
				if SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA - C7__QTEMBA) > 0 .and. C7_RESIDUO != "S"  		
					AADD(_aCampos,C7_NUM + "/" + C7_ITEM + " - " + C7_PRODUTO + " - " + posicione("SB1",1,xFilial("SB1")+C7_PRODUTO,"B1_DESC"))
				endif
			endif
		
			SC7->(dbSkip())
		enddo
	endif
                             
	For nx := 1 To Len(_aCampos)
		MvParDef += SubStr(_aCampos[nx],1,_nTam)
	Next
	
	_nLen := Len(_aCampos)
	
	f_Opcoes(@_aRet,cTitulo,_aCampos,MvParDef,Len(_aCampos),50,.f.,_nTam,_nLen,.t.,.f.,"",.f.,.f.,.t.)
	
	for x:=1 to len(_aRet)	
		dbSelectArea("SC7")
		dbSetOrder(1)
		if dbSeek (xFilial("SC7")+M->Z2_PEDIDO+substr(_aRet[x],8,4))

	      	AAdd(aCols, Array(nQtdCpo+1))
	      	n := len(Acols)

			Acols[n][nZ3_ITEM] 	 := strZero(n,4)
			Acols[n][nZ3_PEDIDO] := SC7->C7_NUM
			Acols[n][nZ3_ITPEDCO]:= SC7->C7_ITEM
			Acols[n][nZ3_PRODUTO]:= SC7->C7_PRODUTO
			Acols[n][nZ3_DESCPRO]:= posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
			Acols[n][nZ3_CDPRDFO]:= posicione("SA5",1,xFilial("SA5")+SC7->(C7_FORNECE+C7_LOJA)+SB1->B1_COD,"A5_CODPRF")
			Acols[n][nZ3_UNIDMED]:= SC7->C7_UM
			Acols[n][nZ3_QTDPED] := SC7->C7_QUANT
			Acols[n][nZ3_VLRPEDI]:= SC7->C7_TOTAL
			Acols[n][nZ3_QTDEMBA]:= 0
			Acols[n][nZ3_VLEMBAR]:= 0
			Acols[n][nZ3_DSCINGL]:= SB1->B1__DESCI

		    aCols[n][Len(aHeader)+1] := .F.

		endif
		n := 1
		GETDREFRESH()
	next x
	
return


user Function VALDTDES()
	if M->Z2_DTEMBAR > M->Z2_DESEMBA
		msgAlert ("A data de Desembarque não pode ser menor que a data de Embarque !!")	
		return .f.
	endif
return .t.


user Function VALQTDES()
	Local nZ3_QTDEMBA:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z3_QTDEMBA" })

	if M->Z3_QTDESEM > Acols[n][nZ3_QTDEMBA]
		msgAlert ("A quantidade desembarcada não pode ser maior que a quantidade embarcada !!")	
		return .f.
	endif
return .t.