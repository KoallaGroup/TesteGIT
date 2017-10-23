#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKC11				 	| Novembro de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz / Jose Augusto F. P. Alves - Anadi								|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina criada para exibir tela de visitas								  	  	|
|-----------------------------------------------------------------------------------------------|
*/                                                                                                                                                            

User Function ITMKC11()
Local nLinha 		:= 5   
Local aStru  		:= {{010,065,110},;
						{240,280,300},;
						{380,425,470,515,560}}
Local aStru2		:= {{010,065},;
						{130,165},;
						{230,270,290}}
Local aTFolder 		:= { "Pedidos","Visitas" }
				  
Local aEdit			:= {}   

Private aSize       := MsAdvSize(.T.)
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oGetTM2		:= Nil
Private oDlgTMP     := Nil    
Private oTFolder	:= Nil 
Private oCombo1   
Private oCombo2
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
Private _cEmpresa	:= "  "
Private _cFilial	:= "  "
Private _cNmEmp		:= "  "
Private _cSeg		:= space(TamSx3("UA__SEGISP")[1])
Private _cNmSeg		:= "  "
Private _cCli		:= space(TamSx3("A1_COD")[1])
Private _cNmCli		:= space(TamSx3("A1_NREDUZ")[1])
Private _cTransp	:= space(TamSx3("A4_COD")[1]) 
Private _cNmTra		:= space(TamSx3("A4_NREDUZ")[1])
Private _cRepres 	:= space(TamSx3("A3_COD")[1])
Private _cNmRep		:= space(TamSx3("A3_NREDUZ")[1])
Private _cOpera		:= space(TamSx3("U7_COD")[1])
Private _cNmOpera	:= space(TamSx3("U7_NOME")[1])
Private _cNmTra2    := ""
Private aComboOP	:= {"1=Receptivo","2=Ativo","3=Fax","4=Representante","5=Direto","       "}
Private cComboOP    := ""  
Private aItens1		:= {	"Vendas ", "Brindes", "       "}
Private cList		:= " "     
Private _cNmOper	:= "  " 
Private _dDataDe	:= CTOD("  /  /    ")
Private _dDataAte	:= CTOD("  /  /    ")
Private _cDDD1		:= "  "
Private _cTel1		:= Space(8)
Private _cDDD2		:= "  "
Private _cTel2		:= Space(8)
Private _cSit		:= "  " 
Private _cNmSit		:= "  " 
Private _cAlerta	:= "  "
Private _nTotCli	:= 0
Private _nNaoComp	:= 0
Private _nVisit		:= 0   
Private _nNaoVisit	:= 0
Private _nCompr		:= 0
Private _nNaoComp	:= 0 
Private _nCliNov	:= 0
Private aAux 		:= {}        
Private ocTel
Private lTel		:= Space(1) 
Private ocPrep
Private lPrep		:= Space(1)  


Private _nTotPeca   := 0
Private _nTotPneu   := 0 
Private _nVlrTotal  := 0

Private _nPerPeca   := 0
Private _nPerPneu   := 0 
Private _nPerTotal  := 0  

Private _nTotais    := 0  

Private oButton  

Private oGetTra, oAlerSZA   
Private oGetTlin 
Private _nTotLin := 0  
Private oGetTPca  
Private _nTotPca := 0  
Private oGetTPne  
Private _nTotPne := 0  	
Private oGetTFre  
Private _nTotFre := 0  	    
Private oGetVIem  
Private _nTotVIem := 0  

Private _cOrigem := "TMK"
Private _cNmOrigem := "Call Center"

aObjects 	:= {}   
AAdd(aObjects,{100,150,.t.,.f.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )    

_dDataDe	:= Date() //dDataBase - (Day(dDataBase)) + 1
_dDataAte	:= Date() //dDataBase

//Cria janela      


DbSelectArea("SZE")

If(SZE->(dbSeek("01")))
	_cNmEmp :=  SZE->ZE_NOMECOM
	_cEmpresa := SZE->ZE_CODIGO 
EndiF  

_cSeg := U_SETSEGTO()  
ValSeg(_cSeg)     

DEFINE MSDIALOG oDlgTMP TITLE "Consulta de Visitas" FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1][1] Say "Empresa: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12 
@ nLinha,aStru[1][2] MsGet _cEmpresa  			Size 10,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[1][2]+20 Button oButton PROMPT "Troca"  			SIZE 20,12   OF oDlgTMP PIXEL ACTION TrocaEmp()  
@ nLinha,aStru[1][3] MsGet _cNmEmp  			Size 120,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[2][1] Say "Origem: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12                                                                        
@ nLinha,aStru[2][2] MsGet _cOrigem  			Size 10,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[2][3]+10 MsGet _cNmOrigem  		Size 100,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[3][2] Say "Filial: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12 
@ nLinha,aStru[3][2]+35 MsGet _cFilial  		Size 10,10 of oDlgTMP PIXEL FONT oFont12 F3 "SM0" VALID ValidFil(_cFilial)

nLinha += 16

@ nLinha,aStru[1][1] Say "Segmento: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[1][2] MsGet _cSeg 				Size 010,10 of oDlgTMP PIXEL FONT oFont12 F3 "SZ72" VALID If(!Empty(Alltrim(_cSeg)),ValSeg(_cSeg),LimpaCpo("SEGMENTO"))
@ nLinha,aStru[1][3] MsGet _cNmSeg  			Size 060,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.  
@ nLinha,aStru[2][1] Say "Status: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12                                                                        
@ nLinha,aStru[2][2] MsGet _cSit  				Size 10,10 of oDlgTMP PIXEL FONT oFont12 F3 "SZM" VALID If(!Empty(Alltrim(_cSit)),ValSit(_cSit), LimpaCpo("SITUACAO"))
@ nLinha,aStru[2][3]+10 MsGet _cNmSit  			Size 100,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[3][2] Say "Operador: " 			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12 
@ nLinha,aStru[3][2]+35 MsGet _cOpera  			Size 10,10 of oDlgTMP PIXEL FONT oFont12 F3 "SU7" VALID ValidOper(_cOpera)
@ nLinha,aStru[3][2]+75 MsGet _cNmOpera			Size 120,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F. 
nLinha += 16

@ nlinha,aStru[1][1] Say "Cliente: " 			SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[1][2] MsGet _cCli 				Size 035,10 of oDlgTMP PIXEL FONT oFont12 F3 "SA1" VALID If(!Empty(Alltrim(_cCli)),ValCli(_cCli),LimpaCpo("CLIENTE")) 
@ nLinha,aStru[1][3] MsGet _cNmCli  			Size 120,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.    
@ nLinha,aStru[2][1] Say "TP.CNO"			SIZE 040,10 OF oDlgTMP PIXEL FONT oFont12 
@ nLinha,aStru[2][2] MSCOMBOBOX oCombo1 VAR cList ITEMS aItens1  SIZE 070,10 OF oDlgTMP PIXEL FONT oFont12 
nLinha += 16

@ nlinha,aStru[1][1] Say "Transportadora: " 	SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[1][2] MsGet _cTransp				Size 025,10 of oDlgTMP PIXEL FONT oFont12 F3 "SA4" VALID If(!Empty(Alltrim(_cTransp)),ValTra(_cTransp),LimpaCpo("TRANSPORTADORA"))
@ nLinha,aStru[1][3] MsGet _cNmTra  			Size 120,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F. 
@ nlinha,aStru[2][1] Say "Telefone: "  			SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12 
@ nLinha,aStru[2][2] MsGet _cDDD1				Size 020,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[2][3] MsGet _cTel1				Size 060,10 of oDlgTMP PIXEL FONT oFont12 PICTURE "9999-9999" WHEN .F.
@ nLinha,aStru[3][1] CheckBox ocTel Var lTel Prompt "Telefone" Size C(060),C(008) COLOR CLR_BLACK PIXEL FONT oFont12 OF oDlgTMP
nLinha += 16

@ nlinha,aStru[1][1] Say "Representante: "  	SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[1][2] MsGet _cRepres		  		Size 025,10 of oDlgTMP PIXEL FONT oFont12 F3 "SA3SEG" VALID If(!Empty(Alltrim(_cRepres)),ValRep(_cRepres),LimpaCpo("REPRESENTANTE"))
@ nLinha,aStru[1][3] MsGet _cNmRep  			Size 120,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nlinha,aStru[2][1] Say "Telefone: "  			SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[2][2] MsGet _cDDD2				Size 020,10 of oDlgTMP PIXEL FONT oFont12 WHEN .F.
@ nLinha,aStru[2][3] MsGet _cTel2				Size 060,10 of oDlgTMP PIXEL FONT oFont12 PICTURE "9999-9999" WHEN .F. 
@ nLinha,aStru[3][1] CheckBox ocPrep Var lPrep Prompt "Preposto" Size C(060),C(008) COLOR CLR_BLACK PIXEL FONT oFont12 OF oDlgTMP
nLinha += 16                                                                                   

@ nlinha,aStru2[1][1] Say "Data De: "  			SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru2[1][2] MsGet _dDataDe			Size 055,10 of oDlgTMP PIXEL FONT oFont12 
@ nlinha,aStru2[2][1] Say "Data Ate: "  		SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru2[2][2] MsGet _dDataAte			Size 055,10 of oDlgTMP PIXEL FONT oFont12 
@ nlinha,aStru[2][1]  Say "Operação: "  		SIZE 080,10 OF oDlgTMP PIXEL FONT oFont12
@ nLinha,aStru[2][2]  MSCOMBOBOX oCombo2 VAR cComboOP ITEMS aComboOP  SIZE 070,10 OF oDlgTMP PIXEL FONT oFont12
                                           
@ nLinha,aStru[3][1] Button oButton PROMPT "Pedidos"  		SIZE 40,10   OF oDlgTMP PIXEL ACTION MsAguarde({|| PastaSel(1)},"Processando Pedidos...") 
@ nLinha,aStru[3][2] Button oButton PROMPT "Pedido"    		SIZE 40,10   OF oDlgTMP PIXEL ACTION ShowPV(oTFolder:nOption)
@ nLinha,aStru[3][3] Button oButton PROMPT "Visitas"  		SIZE 40,10   OF oDlgTMP PIXEL ACTION PastaSel(2) 
@ nLinha,aStru[3][4] Button oButton PROMPT "Sair"  			SIZE 40,10   OF oDlgTMP PIXEL ACTION oDlgTMP:End()  

nLinha += 16                                     

oTFolder := tfolder():new( nLinha,3,aTFolder,,oDlgTMP,,,,.T.,,(oDlgTMP:nClientWidth/2)-10,(oDlgTMP:nClientHeight/2)-10-nLinha )   
//oTFolder:bChange := {|| IF(oTFolder:nOption == 1 ,CriaColsPed(.F.),CriaColsVis(.F.) )} 
oTFolder:Refresh() 

FilFoldPed()
FilFoldVis() 

ACTIVATE MSDIALOG oDlgTMP CENTERED 

Return                     

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : FilFoldPed				 	| Novembro de 2014		  		         		 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Preenche o folder de pedido os objetos visuais							  	  	|
|-----------------------------------------------------------------------------------------------|
*/                                                                                                                                                            

Static Function FilFoldPed()
Local aHeaderB 		:= {}  
Local aColsB		:= {}
Local aCpoHeader 	:= {"UA_FILIAL","UA_NUM","UA_EMISSAO","A1_NREDUZ","UA_ESTE","UA__TEL","UA__TIPPED","UA_VEND","UA__TPOPE","UA__RESEST"} 
Local nStyle    	:= 0 /*GD_INSERT+GD_DELETE+GD_UPDATE*/ 
Local aEdit			:= {}, oAlert  
Local aStru  		:= {010,065,180,210,400} 

//aHeaderB := CriaHeader(aCpoHeader)            

//Aadd(aHeader, { "Data Emissao",	"DTEMISSAO",	"@D",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )

AADD( aHeaderB, { "Filial"     	, "UA_FILIAL" , "@!",2 ,,,, TamSX3("UA_FILIAL")[3], "SUA", "V"} )
AADD( aHeaderB, { "Pedido"     	, "UA_NUM"    , "@!",6 ,,,, TamSX3("UA_NUM")[3], "SUA", "V"} )
AADD( aHeaderB, { "Data"       	, "UA_EMISSAO", "@D",10,,,, TamSX3("UA_EMISSAO")[3], "SUA", "V"} )
AADD( aHeaderB, { "Nome"       	, "A1_NREDUZ" , "@!",24,,,, TamSX3("A1_NREDUZ")[3], "SA1", "V"} ) 
AADD( aHeaderB, { "UF"         	, "UA_ESTE"   , "@!",2 ,,,, TamSX3("UA_ESTE")[3], "SUA", "V"} )  
AADD( aHeaderB, { "Tel"       	, "UA_TEL"    , "@!",3 ,,,, TamSX3("UA__TEL")[3], "SUA", "V"} )
AADD( aHeaderB, { "Tipo"   		, "UA__TIPPED", "@!",2 ,,,, TamSX3("UA__TIPPED")[3], "SUA", "V"} )
AADD( aHeaderB, { "ST"         	, "UA__STATUS", "@!",2 ,,,, TamSX3("UA__TIPPED")[3], "SUA", "V"} )   
AADD( aHeaderB, { "RP" 		   	, "UA_VEND"   , "@!",6 ,,,, TamSX3("UA_VEND")[3], "SUA", "V"} ) 
AADD( aHeaderB, { "OP"   	   	, "UA__TPOPE" , "@!",12,,,, TamSX3("UA__TPOPE")[3], "SUA", "V"} ) 
AADD( aHeaderB, { "EST"		   	, "UA__RESEST", "@!",1 ,,,, TamSX3("UA__RESEST")[3], "SUA", "V"} )
AADD( aHeaderB, { "Vlr. Peça"  	, "PECA" , PesqPict("SUB","UB_VLRITEM"),12,2,,, TamSX3("UB_VLRITEM")[3], "SUA", "V"} )
AADD( aHeaderB, { "Vlr. Pneu"  	, "PNEU" , PesqPict("SUB","UB_VLRITEM"),12,2,,, TamSX3("UB_VLRITEM")[3], "SUA", "V"} )
AADD( aHeaderB, { "Frete"	   	, "FRETE", PesqPict("SUA","UA_FRETE"),12,2,,, TamSX3("UA_FRETE")[3], "SUA", "V"} )
AADD( aHeaderB, { "Valor Itens"	, "ITENS", PesqPict("SUB","UB_VLRITEM"),12,2,,, TamSX3("UB_VLRITEM")[3], "SUA", "V"} )  

oGetTM1 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-32,aPosObj[1,4]-5, nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oTFolder:aDialogs[1], aHeaderB, aColsB)

CriaColsPed(.T.)   

@ aPosObj[1,3]-20,010 Say "Total Linhas: " 		   								SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12 
@ aPosObj[1,3]-22,050 MsGet oGetTlin Var _nTotLin Picture "@E 99999"			SIZE 020,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.

@ aPosObj[1,3]-20,080 Say "Total Vlr.Peca: " 		   			 				SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12
@ aPosObj[1,3]-22,125 MsGet oGetTPca Var _nTotPca Picture "@E 99,999,999.99" 	SIZE 060,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.
   
@ aPosObj[1,3]-20,190 Say "Total Vlr.Pneu: " 		   							SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12 
@ aPosObj[1,3]-22,237 MsGet oGetTPne Var _nTotPne Picture "@E 99,999,999.99" 	SIZE 060,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.

@ aPosObj[1,3]-20,305 Say "Total Frete: " 		   								SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12 
@ aPosObj[1,3]-22,343 MsGet oGetTFre Var _nTotFre Picture "@E 99,999,999.99"	SIZE 060,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.

@ aPosObj[1,3]-20,410 Say "Total Vlr. Itens: " 		  	 						SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12 
@ aPosObj[1,3]-22,460 MsGet oGetVIem Var _nTotVIem Picture "@E 99,999,999.99"	SIZE 060,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.

@ aPosObj[1,3],aStru[1] Say "Transportadora: " 		   						SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12
@ aPosObj[1,3],aStru[2] MsGet oGetTra Var _cNmTra2  						SIZE 100,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.
@ aPosObj[1,3],aStru[3] Say "Alerta: " 				   						SIZE 080,010 OF oTFolder:aDialogs[1] PIXEL FONT oFont12
@ aPosObj[1,3],aStru[4] MsGet oAlerSZA Var _cAlerta							SIZE 180,010 of oTFolder:aDialogs[1] PIXEL FONT oFont12 WHEN .F.
@ aPosObj[1,3],aStru[5] Button oButton PROMPT "Exibir Erro" 				SIZE 040,012 OF oTFolder:aDialogs[1] PIXEL ACTION BErro2()
@ aPosObj[1,3],aStru[5]+100 Button oButton PROMPT "Imprime Pedido"  		SIZE 40,12   OF oTFolder:aDialogs[1] PIXEL ACTION ChamaRel(1)

_cAlerta := IVerSZA()
oAlerSZA:refresh()

//oGetTM1:bChange := {|| BErro1(),MudaTransp() }  
oGetTM1:bChange := {|| MudaTransp() }  
oGetTM1:oBrowse:Refresh()

Return
                                       
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : FilFoldVis				 	| Novembro de 2014		  		         		 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Preenche o folder de pedido os objetos visuais							  	  	|
|-----------------------------------------------------------------------------------------------|
*/                                                                                                                                                            

Static Function FilFoldVis()
Local aHeaderC 		:= {}  
Local aColsC		:= {}
Local aCpoHeaderB 	:= {"AD7_FILIAL","AD7__DTVIS","AD7__PED","A1_NREDUZ","A1_MUN","AD7__TPOPE","AD7_TOPICO"}
Local nStyle    	:= 0 /*GD_INSERT+GD_DELETE+GD_UPDATE*/ 
Local aEdit			:= {}
Local nLinha		:= aPosObj[1,3]-20
Local aStru  		:= {010,055,120,180}   

aHeaderC := CriaHeader(aCpoHeaderB) 

AADD( aHeaderC, { "Vlr. Peça"  , "PECA" , "@E 999,999,999.99", 15, 2,,, "N", "AD7", "V"} )
AADD( aHeaderC, { "Vlr. Pneu"  , "PNEU" , "@E 999,999,999.99", 15, 2,,, "N", "AD7", "V"} )
AADD( aHeaderC, { "Valor Total", "ITENS", "@E 999,999,999.99", 15, 2,,, "N", "AD7", "V"} )  

oGetTM2 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-48,aPosObj[1,4]-10, nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oTFolder:aDialogs[2], aHeaderC, aColsC)

CriaColsVis(.T.)

@ nLinha, 010 To nLinha - 48, 250

//@ nLinha  ,aStru[1] Say "Compraram: " 			SIZE 080,010 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
//@ nLinha-3,aStru[2] MsGet _nCompr  				Size 050,010 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.
@ nLinha+12 ,aStru[1]+250 Say "Totais: "	   		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha+09 ,aStru[2]+250 MsGet _nTotais			Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F. 
@ nLinha+12 ,aStru[1]+390 Say "Representante: 	"	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha+09 ,aStru[2]+400 MsGet _cNmRep	   			Size 120,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.
//nLinha -= 16

@ nLinha  ,aStru[1] Say "Compraram: " 			SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2] MsGet _nCompr  				Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.
@ nLinha  ,aStru[3] Say "Não Compraram: "		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[4] MsGet _nNaoComp				Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F. 
@ nLinha  ,aStru[1]+250 Say "Total Vlr Total: "	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+250 MsGet _nVlrTotal		Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999,999,999.99" WHEN .F.  
@ nLinha  ,aStru[1]+390 Say "% Cota Total: "	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+400 MsGet _nPerTotal		Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999.99" WHEN .F.
nLinha -= 12

@ nLinha  ,aStru[1] Say "Visitados: " 			SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2] MsGet _nVisit  				Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.
@ nLinha  ,aStru[3] Say "Não Visitados: "		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[4] MsGet _nNaoVisit			Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F. 
@ nLinha  ,aStru[1]+250 Say "Total Vlr Pneu: "	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+250 MsGet _nTotPneu			Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999,999,999.99" WHEN .F.
@ nLinha  ,aStru[1]+390 Say "% Cota Pneu: "		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+400 MsGet _nPerPneu			Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999.99" WHEN .F.
@ nLinha-3,aStru[1]+530 Button oButton PROMPT "Imprime Visitas"  	SIZE 40,12   OF oTFolder:aDialogs[2] PIXEL ACTION ChamaRel(2)
nLinha -= 12

@ nLinha  ,aStru[1] Say "Total Clientes: " 		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2] MsGet _nTotCli  			Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.
@ nLinha  ,aStru[3] Say "Clientes Novos: "		SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[4] MsGet _nCliNov				Size 050,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 WHEN .F.  
@ nLinha  ,aStru[1]+250 Say "Total Vlr Peça: " 	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+250 MsGet _nTotPeca  		Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999,999,999.99" WHEN .F.  
@ nLinha  ,aStru[1]+390 Say "% Cota Peça: " 	SIZE 080,008 OF oTFolder:aDialogs[2] PIXEL FONT oFont12
@ nLinha-3,aStru[2]+400 MsGet _nPerPeca 		Size 080,008 of oTFolder:aDialogs[2] PIXEL FONT oFont12 PICTURE "@E 999.99" WHEN .F.  
nLinha -= 10 

nLinha -= 12 

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Novembro de 2014				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader(aCpoHeader)
Local _aHeader      := {}

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(_aHeader, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		If(Alltrim(SX3->X3_Campo) == "A1_NREDUZ" .Or. Alltrim(SX3->X3_Campo) == "A1_MUN" ,20,SX3->X3_Tamanho),;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3		    ,;
		SX3->X3_Context})
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

Return _aHeader          

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaColsPed			 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/                            

Static Function CriaColsPed(lPrime)
Local _cQuery	:= "" 
Local nX		:= 0           
Local lPrimey   := lPrime      
Local cTotal1 	:= 0
Local cTotal2 	:= 0
Local cTotal3 	:= 0
Local cTotal4 	:= 0           
Local lFrete    := .F.             

oTFolder:aDialogs[1]:lActive := .T.
oTFolder:aDialogs[2]:lActive := .F.

If lPrimey 

	oGetTM1:Acols := {}
	
	nX++
	AAdd(oGetTM1:Acols, Array(Len(oGetTM1:aHeader)+1))
	
	oGetTM1:Acols[nX][01]  	:= "  "
	oGetTM1:Acols[nX][02] 	:= "  "
	oGetTM1:Acols[nX][03] 	:= CTOD("  /  /    ")
	oGetTM1:Acols[nX][04]  	:= ""
	oGetTM1:Acols[nX][05]  	:= ""
	oGetTM1:Acols[nX][06]  	:= ""
	oGetTM1:Acols[nX][07]  	:= ""
	oGetTM1:Acols[nX][08]  	:= ""
	oGetTM1:Acols[nX][09]  	:= ""      
	oGetTM1:Acols[nX][10]  	:= ""   
	oGetTM1:Acols[nX][11]  	:= "" 
	oGetTM1:Acols[nX][12]  	:= 0 
	oGetTM1:Acols[nX][13]  	:= 0   
	oGetTM1:Acols[nX][14]  	:= 0 
	oGetTM1:Acols[nX][15]  	:= 0   
	oGetTM1:Acols[nX][16]	:= .F.	
Else 

	If(select("TRB_SUA") > 0)
		TRB_SUA->(DbCloseArea())
	EndIf
	             
	
	_cQuery := "SELECT  *																		" + Chr(13)
	_cQuery += "FROM " + RetSqlName("SZF") + " SZF, " + RetSqlName("SUA") + " SUA               " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '  '   				" + Chr(13)
	_cQuery += "						 AND SA1.A1_COD = SUA.UA_CLIENTE           				" + Chr(13)
	_cQuery += "						 AND SA1.A1_LOJA = SUA.UA_LOJA             				" + Chr(13)
	_cQuery += "						 AND SA1.D_E_L_E_T_ = ' '                  				" + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SZM") + " SZM ON SZM.ZM_FILIAL = '  '   				" + Chr(13)
	_cQuery += "						 AND SZM.ZM_COD = SUA.UA__STATUS           				" + Chr(13)
	_cQuery += "						 AND SZM.ZM_EXIFAT != '3'		           				" + Chr(13)
	_cQuery += "						 AND SZM.D_E_L_E_T_ = ' '                  				" + Chr(13)
	_cQuery += "WHERE SUA.D_E_L_E_T_ = ' '                                        	   			" + Chr(13) 
	_cQuery += "AND SUA.UA__TIPPED = SZF.ZF_COD                                        	   		" + Chr(13) 
	_cQuery += "AND SZF.D_E_L_E_T_ = ' '                                         	   	   		" + Chr(13)
//	_cQuery += "AND SZF.ZF_BRINDE != '1'                                         	   	   		" + Chr(13)
	If !Empty(Alltrim(_cFilial))
		_cQuery += "AND SUA.UA_FILIAL = '"+_cFilial+"'                               		 	" + Chr(13)
	EndIf
	If Val(_cSeg) <> 0  
		_cQuery += "AND SUA.UA__SEGISP = '"+_cSeg+"'                                   			" + Chr(13)
	EndIf     
	If !Empty(Alltrim(_cCli))
		_cQuery += "AND SUA.UA_CLIENTE = '"+_cCli+"'                                   			" + Chr(13)
	EndIf   
	If !Empty(Alltrim(_cTransp))
		_cQuery += "AND SUA.UA_TRANSP = '"+_cTransp+"'                                 			" + Chr(13)
	EndIf
	If !Empty(Alltrim(_cRepres))
		_cQuery += "AND SUA.UA_VEND = '"+_cRepres+"'                                 			" + Chr(13)
	EndIf 
	If !Empty(Alltrim(_cSit))
		_cQuery+="	AND SUA.UA__STATUS='"+_cSit+"' 												" + Chr(13)
	EndIf   
	If !Empty(Alltrim(cComboOP))
		_cQuery+="	AND SUA.UA__TPOPE = '"+cComboOP+"' 											" + Chr(13)
	EndIf    
	If !Empty(Alltrim(_cOpera))
		_cQuery+="	AND SUA.UA_OPERADO = '"+_cOpera+"'	 										" + Chr(13)
	EndIf    
	If lTel
		_cQuery+="	AND TRIM(SUA.UA__TEL) = 'S' 												" + Chr(13)
	EndIf 
	If !Empty(Alltrim(cList))
		If Alltrim(cList) == "Brindes"
			_cQuery+="	AND SZF.ZF_BRINDE = '1'  												" + Chr(13)
		Elseif Alltrim(cList) == "Vendas"
			_cQuery+="	AND SZF.ZF_BRINDE <> '1' 											    " + Chr(13)
		EndIf
	EndIf   
	_cQuery+="	AND TRIM(SZF.ZF_COD) NOT IN ('4','3')										    " + Chr(13)
	If !Empty(Alltrim(DtoS(_dDataDe))) .And. !Empty(Alltrim(DtoS(_dDataAte)))
		_cQuery += "AND SUA.UA_EMISSAO BETWEEN '"+DtoS(_dDataDe)+"' AND  '"+DtoS(_dDataAte)+"' 	" + Chr(13)
	EndIf
	//_cQuery += "AND SUA.UA_NUM = '000415'														" + Chr(13)
	_cQuery += "Order by UA_FILIAL,UA_VEND,UA_EMISSAO,UA_NUM "
	TcQuery _cQuery New Alias "TRB_SUA"
	TCSetField("TRB_SUA","UA_EMISSAO","D")
	  
	oGetTM1:Acols := {}
	                      
	//Zera os totais
	_nTotLin  := 0
	_nTotPca  := 0  
	_nTotPne  := 0  	
	_nTotFre  := 0  	    
	_nTotVIem := 0  	

	If(Empty(TRB_SUA->UA_NUM))
		nX++
			AAdd(oGetTM1:Acols, Array(Len(oGetTM1:aHeader)+1))
			
			oGetTM1:Acols[nX][01]  	:= "  "
			oGetTM1:Acols[nX][02] 	:= "  "
			oGetTM1:Acols[nX][03] 	:= CTOD("  /  /    ")
			oGetTM1:Acols[nX][04]  	:= ""
			oGetTM1:Acols[nX][05]  	:= ""
			oGetTM1:Acols[nX][06]  	:= "" 
			oGetTM1:Acols[nX][07]  	:= ""  
			oGetTM1:Acols[nX][08]  	:= ""  
			oGetTM1:Acols[nX][09]  	:= ""   
			oGetTM1:Acols[nX][10]  	:= ""   
			oGetTM1:Acols[nX][11]  	:= "" 
			oGetTM1:Acols[nX][12]  	:= 0 
			oGetTM1:Acols[nX][13]  	:= 0   
			oGetTM1:Acols[nX][14]  	:= 0 
			oGetTM1:Acols[nX][15]  	:= 0   
			oGetTM1:Acols[nX][16]	:= .F.
	
	Else
		DbSelectArea("TRB_SUA")
		While TRB_SUA->(!Eof())
			nX++
			AAdd(oGetTM1:Acols, Array(Len(oGetTM1:aHeader)+1))  
			
			oGetTM1:Acols[nX][1]   	:= TRB_SUA->UA_FILIAL
			oGetTM1:Acols[nX][2] 	:= TRB_SUA->UA_NUM
			oGetTM1:Acols[nX][3] 	:= TRB_SUA->UA_EMISSAO
			oGetTM1:Acols[nX][4]  	:= TRB_SUA->A1_NREDUZ 
			oGetTM1:Acols[nX][5]  	:= TRB_SUA->A1_EST 
			oGetTM1:Acols[nX][6]  	:= TRB_SUA->UA__TEL
			oGetTM1:Acols[nX][7]  	:= TRB_SUA->UA__TIPPED
			oGetTM1:Acols[nX][8]  	:= TRB_SUA->UA__STATUS
			oGetTM1:Acols[nX][9]  	:= TRB_SUA->UA_VEND   
			
			DO CASE
				CASE TRB_SUA->UA__TPOPE  == "1"
			  		oGetTM1:Acols[nX][10] := "Receptivo"
				CASE TRB_SUA->UA__TPOPE  == "2"
			  		oGetTM1:Acols[nX][10] := "Ativo"
				CASE TRB_SUA->UA__TPOPE  == "3"
			  		oGetTM1:Acols[nX][10] := "Fax"
				CASE TRB_SUA->UA__TPOPE  == "4"
			   		oGetTM1:Acols[nX][10] := "Representante"
				CASE TRB_SUA->UA__TPOPE  == "5"
			   		oGetTM1:Acols[nX][10] := "Direto"
				OTHERWISE
					oGetTM1:Acols[nX][10] := " "
			ENDCASE 
	
			oGetTM1:Acols[nX][11]  	:= TRB_SUA->UA__RESEST 
			
			MontaQuery(TRB_SUA->UA_FILIAL, TRB_SUA->UA_NUM)
			cTotal1 := 0
			cTotal2 := 0
			cTotal3 := 0 
			cTotal4 := 0
			lFrete := .T.
			DbSelectArea("TRB")
			TRB->( DbGoTop() )
			While TRB->(!Eof())
				cTotal1 += TRB->PECA
				cTotal2 += TRB->PNEU 
				If lFrete
					cTotal3 := TRB->FRETE  
					lFrete := .F.
				EndIF
				cTotal4 += TRB->PNEU + TRB->PECA //+ TRB->FRETE
				TRB->(DbSkip())
			End	
			oGetTM1:Acols[nX][12]  	:= cTotal1
			oGetTM1:Acols[nX][13]  	:= cTotal2
			oGetTM1:Acols[nX][14]  	:= cTotal3
			oGetTM1:Acols[nX][15]  	:= cTotal4 + cTotal3
			oGetTM1:Acols[nX][16]	:= .F.
	  		TRB_SUA->(DbSkip())
			TRB->(dbCloseArea()) 
		
			//Preenche os totais
			_nTotLin  += 1
			_nTotPca  += cTotal1 
			_nTotPne  += cTotal2  	
			_nTotFre  += cTotal3  	    
			_nTotVIem += cTotal4 + cTotal3
			
		EndDo
		
		oGetTM1:nAt := nX
		
	EndIf
	
	TRB_SUA->(dbCloseArea())
	
	//Verifica se exitem erros de integração com a Webline
	_cAlerta := IVerSZA()
    oAlerSZA:refresh()  
	
Endif

oGetTM1:refresh() 

Return                                         

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaColsVis			 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/                            

Static Function CriaColsVis(lPrime)
Local _cQuery	:= "" 
Local nX		:= 0  
Local cTotal1 	:= 0                            
Local cTotal2 	:= 0
Local cTotal3 	:= 0 
Local lPrimey   := lPrime 

If lPrimey   

	oGetTM2:Acols := {}
	
	nX++
	AAdd(oGetTM2:Acols, Array(Len(oGetTM2:aHeader)+1))
	
	oGetTM2:Acols[nX][1] 	:= ""
	oGetTM2:Acols[nX][2]   	:= CTOD("  /  /    ")
	oGetTM2:Acols[nX][3] 	:= ""
	oGetTM2:Acols[nX][4] 	:= ""
	oGetTM2:Acols[nX][5]  	:= ""  
	oGetTM2:Acols[nX][6]  	:= "" 
	oGetTM2:Acols[nX][7]  	:= "" 
	oGetTM2:Acols[nX][8]  	:= 0
	oGetTM2:Acols[nX][9]  	:= 0
	oGetTM2:Acols[nX][10]  	:= 0
	oGetTM2:Acols[nX][11]	:= .F.

Else   
    
    oTFolder:aDialogs[1]:lActive := .F.
	oTFolder:aDialogs[2]:lActive := .T.
    
	If Empty(Alltrim(_cRepres))
		MsgInfo("Por favor selecione um representante!", "Atencao")	
	Else
		_nTotPeca := 0
		_nTotPneu := 0 
		_nVlrTotal:= 0
	
		If(select("TRB_AD7") > 0)
			TRB_AD7->(DbCloseArea())
		EndIf
		             
		_cQuery := "SELECT 	* FROM " + RetSqlName("AD7") + " AD7 " 
//		_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '  '   				" + Chr(13)
		_cQuery += "LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '  '   				" + Chr(13)		
		_cQuery += "						 AND SA1.A1_COD = AD7.AD7_CODCLI           				" + Chr(13)
		_cQuery += "						 AND SA1.A1_LOJA = AD7.AD7_LOJA             			" + Chr(13)
		_cQuery += "						 AND SA1.D_E_L_E_T_ = ' '                  				" + Chr(13) 
//		_cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = AD7.AD7_FILIAL   	" + Chr(13)
		_cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = AD7.AD7_FILIAL   	" + Chr(13)		
		_cQuery += "						 AND SUA.UA_NUM = AD7.AD7__PED          				" + Chr(13)
		_cQuery += "						 AND SUA.UA_CLIENTE = AD7.AD7_CODCLI             		" + Chr(13)
		_cQuery += "						 AND SA1.A1_LOJA = AD7.AD7_LOJA             			" + Chr(13)
		_cQuery += "						 AND SUA.D_E_L_E_T_ = ' '                  				" + Chr(13) 
		If lTel
			_cQuery+="	AND TRIM(SUA.UA__TEL) = 'S' 												" + Chr(13)
		EndIf 
		_cQuery += "WHERE AD7.D_E_L_E_T_ = ' '														" + Chr(13)
//		If !Empty(Alltrim(_cEmpresa))
//			_cQuery += "AND AD7.AD7_FILIAL = '"+_cEmpresa+"'                               		 	" + Chr(13)
//		EndIf
		If !Empty(Alltrim(_cFilial))
			_cQuery += "AND AD7.AD7_FILIAL = '"+_cFilial+"'                               		 	" + Chr(13)
		EndIf
		If !Empty(Alltrim(DtoS(_dDataDe))) .And. !Empty(Alltrim(DtoS(_dDataAte)))
			_cQuery += "AND AD7.AD7__DTVIS BETWEEN '"+DtoS(_dDataDe)+"' AND  '"+DtoS(_dDataAte)+"' 	" + Chr(13)			
		EndIf  
		If !Empty(Alltrim(_cRepres))
			_cQuery += "AND AD7.AD7_VEND = '"+_cRepres+"'                                 			" + Chr(13)
		EndIf
		If !Empty(Alltrim(_cCli))
			_cQuery += "AND AD7.AD7_CODCLI = '"+_cCli+"'                                 			" + Chr(13)
		EndIf
		If !Empty(Alltrim(_cCli))
			_cQuery += "AND AD7.AD7__STAT = '"+_cSit+"'                                 			" + Chr(13)
		EndIf 
		If !Empty(Alltrim(cComboOP))
			_cQuery+="	AND AD7.AD7__TPOPE = '"+cComboOP+"' 										" + Chr(13)
		EndIf   
		If lPrep
			_cQuery+="	AND TRIM(AD7.AD7__PREP) = 'S' 												" + Chr(13)
		EndIf 
		If !Empty(Alltrim(_cOpera))
			_cQuery+="	AND AD7.AD7__OPERA = '"+_cOpera+"'	 										" + Chr(13)
		EndIf
		_cQuery += "Order by AD7_FILIAL,AD7_VEND,AD7_DATA,AD7__NUM "
		    
		TcQuery _cQuery New Alias "TRB_AD7"
		TCSetField("TRB_AD7","AD7__DTVIS","D")
		  
		oGetTM2:Acols := {}
		
		If(Empty(TRB_AD7->AD7__DTVIS))
			nX++
				AAdd(oGetTM2:Acols, Array(Len(oGetTM2:aHeader)+1))
				
				oGetTM2:Acols[nX][1] 	:= ""
				oGetTM2:Acols[nX][2]   	:= CTOD("  /  /    ")
				oGetTM2:Acols[nX][3] 	:= ""
				oGetTM2:Acols[nX][4] 	:= ""
				oGetTM2:Acols[nX][5]  	:= ""  
				oGetTM2:Acols[nX][6]  	:= "" 
				oGetTM2:Acols[nX][7]  	:= "" 
				oGetTM2:Acols[nX][8]  	:= 0
				oGetTM2:Acols[nX][9]  	:= 0
				oGetTM2:Acols[nX][10]  	:= 0
				oGetTM2:Acols[nX][11]	:= .F.
		
		Else
			_nTotais := 0
			DbSelectArea("TRB_AD7")
			While TRB_AD7->(!Eof())                        	
				nX++          
				_nTotais++
				AAdd(oGetTM2:Acols, Array(Len(oGetTM2:aHeader)+1))
				
				oGetTM2:Acols[nX][1]   	:= TRB_AD7->AD7_FILIAL
				oGetTM2:Acols[nX][2]   	:= TRB_AD7->AD7__DTVIS
				oGetTM2:Acols[nX][3] 	:= TRB_AD7->AD7__PED
				oGetTM2:Acols[nX][4] 	:= TRB_AD7->A1_NREDUZ
				oGetTM2:Acols[nX][5]  	:= TRB_AD7->A1_MUN
				DO CASE
					CASE TRB_AD7->AD7__TPOPE  == "1"
				  		oGetTM2:Acols[nX][6] := "Receptivo"
					CASE TRB_AD7->AD7__TPOPE  == "2"
				  		oGetTM2:Acols[nX][6] := "Ativo"
					CASE TRB_AD7->AD7__TPOPE  == "3"
				  		oGetTM2:Acols[nX][6] := "Fax"
					CASE TRB_AD7->AD7__TPOPE  == "4"
				   		oGetTM2:Acols[nX][6] := "Representante"
					CASE TRB_AD7->AD7__TPOPE  == "5"
				   		oGetTM2:Acols[nX][6] := "Direto"
					OTHERWISE
						oGetTM2:Acols[nX][6] := " "
				ENDCASE 
			
				oGetTM2:Acols[nX][7]  	:= TRB_AD7->AD7_TOPICO
				MontaQuery(TRB_AD7->AD7_FILIAL, TRB_AD7->AD7__PED)
					cTotal1 := 0
					cTotal2 := 0
					cTotal3 := 0
			   		DbSelectArea("TRB")
					TRB->( DbGoTop() )
					While TRB->(!Eof())
						cTotal1 += TRB->PECA
						cTotal2 += TRB->PNEU
						cTotal3 += TRB->PNEU + TRB->PECA 
						TRB->(DbSkip())
					End	
					oGetTM2:Acols[nX][8]  	:= cTotal1
					oGetTM2:Acols[nX][9]  	:= cTotal2
					oGetTM2:Acols[nX][10]  	:= cTotal3		
					oGetTM2:Acols[nX][11]	:= .F.
					TRB_AD7->(DbSkip())
					TRB->(dbCloseArea())
					_nTotPeca += cTotal1
					_nTotPneu += cTotal2
					_nVlrTotal+= cTotal3
			EndDo
			
			oGetTM2:nAt := nX
			
		EndIf
		
		TRB_AD7->(dbCloseArea())  
		
		CarTotais()
		
		  
	EndIf

EndIf   
    
Return   

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValFil				 	| 	Dezembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial e Preenchimento do Acols								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValFil(_cEmpresa)
Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SZE")

If(dbSeek(cEmpAnt+_cEmpresa))
	_cNmEmp :=  SZE->ZE_NOMECOM
Else
	_cNmEmp := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZE)
RestArea(_aArea)

Return lRet                          

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValSeg				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial e Preenchimento do Acols								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValSeg(_cSeg)
Local _aArea	:= GetArea()
Local _aAreaSZ7	:= SZ7->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SZ7")

If(dbSeek(xFilial("SZ7")+Alltrim(_cSeg)))
	_cNmSeg :=  SZ7->Z7_DESCRIC	
Else
	_cNmSeg := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZ7)
RestArea(_aArea)

Return lRet 
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValCli				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao do Cliente 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValCli(_cCli)
Local _aArea	:= GetArea()
Local _aAreaSA1	:= SA1->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SA1")

If(dbSeek(xFilial("SA1")+Alltrim(_cCli)))
	_cNmCli :=  SA1->A1_NREDUZ
Else
	_cNmCli := ""
	lRet := .F.
EndIf

RestArea(_aAreaSA1)
RestArea(_aArea)

Return lRet 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValTra				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Transportadora 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValTra(_cTransp)
Local _aArea	:= GetArea()
Local _aAreaSA4	:= SA4->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SA4")

If(dbSeek(xFilial("SA4")+Alltrim(_cTransp)))
	_cNmTra :=  SA4->A4_NOME
	_cDDD1 	:= SA4->A4_DDD
	_cTel1  := SA4->A4_TEL	
Else
	_cNmTra := ""
	lRet := .F.
EndIf

RestArea(_aAreaSA4)
RestArea(_aArea)

Return lRet  

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValRep				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Representante	 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValRep(_cRepres)
Local _aArea	:= GetArea()
Local _aAreaSA3	:= SA3->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SA3")

If(dbSeek(xFilial("SA3")+Alltrim(_cRepres)))
	_cNmRep := SA3->A3_NOME
	_cDDD2 	:= SA3->A3_DDDTEL
	_cTel2  := SA3->A3_TEL		
Else
	_cNmRep := ""
	lRet := .F.
EndIf

RestArea(_aAreaSA3)
RestArea(_aArea)

Return lRet 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValSit				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Situacao		 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValSit(_cSit)
Local _aArea	:= GetArea()
Local _aAreaSZM	:= SZM->(GetArea())
Local lRet 		:= .T.
                         
DbSelectArea("SZM")

If(dbSeek(xFilial("SZM")+Alltrim(_cSit)))
	_cNmSit := SZM->ZM_DESC		
Else
	_cNmSit := ""
	lRet := .F.
EndIf

RestArea(_aAreaSZM)
RestArea(_aArea)

Return lRet   

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ShowPV				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Mostra pedido Call Center		 											  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ShowPV(nOppca)

Local lRet:=.t. 
Local nOpcu := nOppca  
Local _cFilAtu := cFilAnt       
Private aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"    
                
Private INCLUI := .F.
Private ALTERA := .F. 


If nOpcu = 1  
cFilAnt := oGetTM1:Acols[oGetTM1:nat][1]
	If Empty(oGetTM1:Acols) .or. Empty(oGetTM1:Acols[oGetTM1:nat][2])
		MsgInfo("Nao ha pedido para exibir !", "escolha outro atendimento")
	Else
		//PRIVATE aRotina     := {{"","",0,1},{"Visualizar"   , "TK271CallCenter" , 0, 2 }}
		ChkFile("SUA")
		ChkFile("SUB")
		ChkFile("SB1")
		SUA->(DbSetOrder(1))
		SUA->(DbSeek( oGetTM1:Acols[oGetTM1:nat][1]+oGetTM1:Acols[oGetTM1:nat][2] ))
		SUB->(DbSetOrder(1))
		SUB->(dbseek(oGetTM1:Acols[oGetTM1:nat][1]+oGetTM1:Acols[oGetTM1:nat][2]))
		TK271CallCenter("SUA",SUA->(RecNo()),2)
	Endif
Else
cFilAnt := oGetTM2:Acols[oGetTM2:nat][1]
	If Empty(oGetTM2:Acols) .or. Empty(oGetTM2:Acols[oGetTM2:nat][3])
		MsgInfo("Nao ha pedido para exibir !", "escolha outro atendimento")           		
	Else
		//PRIVATE aRotina     := {{"","",0,1},{"Visualizar"   , "TK271CallCenter" , 0, 2 }}
		ChkFile("SUA")
		ChkFile("SUB")
		ChkFile("SB1")
		SUA->(DbSetOrder(1))
		SUA->(DbSeek( oGetTM2:Acols[oGetTM2:nat][1]+oGetTM2:Acols[oGetTM2:nat][3] ))
		SUB->(DbSetOrder(1))
		SUB->(dbseek(xFilial("SUB")+oGetTM2:Acols[oGetTM2:nat][3]))
		TK271CallCenter("SUA",SUA->(RecNo()),2)
	Endif
EndiF

cFilAnt := _cFilAtu

Return lRet           

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : MontaQry				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Monta Query para somar valores dos produtos		 								|
|-----------------------------------------------------------------------------------------------|
*/   

Static Function MontaQuery(_cFilA, _cNumPedA)

Local cQry := "" 
Local cFillu 	:= _cFilA
Local cNumPedA 	:= _cNumPedA     

If(select("TRB") > 0)
	TRB->(DbCloseArea())
EndIf      

//cQry += " case when SB1.B1_TIPO = 'PC' then SUB.UB_VLRITEM + UB__VALIPI + UB__VALIST end as PECA,"   -- Calculo anterior

cQry := " SELECT"
cQry += " case when SB1.B1_TIPO = 'PC' then SUB.UB_VLRITEM end as PECA,"
cQry += " case when SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA' then SUB.UB_VLRITEM end as PNEU,"
cQry += " SUA.UA_FRETE as FRETE"
cQry += " FROM " + RetSqlName("SB1") + " SB1,"
cQry += " " + RetSqlName("SUA") + " SUA,"
cQry += " " + RetSqlName("SUB") + " SUB"
cQry += " WHERE SUA.UA_NUM = SUB.UB_NUM"  
cQry += " AND SUA.UA_FILIAL = SUB.UB_FILIAL"
cQry += " AND SUB.UB_PRODUTO = SB1.B1_COD"
cQry += " AND SUA.D_E_L_E_T_ = ' '"
cQry += " AND SUB.D_E_L_E_T_ = ' '"
cQry += " AND SB1.D_E_L_E_T_ = ' '"   
cQry += " AND SUA.UA_FILIAL = '" +cFillu+ "'"
cQry += " AND SUA.UA_NUM = '" +cNumPedA+ "'"    

TcQuery cQry New Alias "TRB" 

Return
 
      
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CarTotais				 	| 	Novembro de 2014			  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Monta Query para somar valores dos produtos		 								|
|-----------------------------------------------------------------------------------------------|
*/ 
Static Function CarTotais()        

Local cQry1 := ""  
Local nTotClie 	:= 0 
Local cQry2 := ""
Local nVisitad 	:= 0  
Local cQry3 := ""
Local nComprou  := 0 
Local cQry4 := ""
Local nNcomprou := 0
Local cQry5 := ""  
Local nClNew 	:= 0 
Local nCotaPca  := 0
Local nCotaPne  := 0
Local nCotaTot  := 0

   
	//TOTAL DE CLIENTES
	If(select("TRB1") > 0)
		TRB1->(DbCloseArea())
	EndIf                           
	
	cQry1 := "SELECT COUNT(DISTINCT(A1_COD)) AS TOTAL_CLI 				" + Chr(13)
	cQry1 += "FROM " + RetSqlName("SA1") + " SA1						" + Chr(13)
	cQry1 += "WHERE SA1.D_E_L_E_T_ = ' ' And A1_MSBLQL <> '1' 			" + Chr(13)
	If !Empty(Alltrim(_cRepres))
		cQry1 += "AND SA1.A1_VEND = '" + _cRepres + "'                 	" + Chr(13)
	EndIf
	If !Empty(Alltrim(_cSeg))
		cQry1 += "AND (TRIM('" + _cSeg + "') = '0' OR SA1.A1__SEGISP = '" + _cSeg + "') " + Chr(13)
	EndIf
	cQry1 += "GROUP BY A1_COD											"
	
	TcQuery cQry1 New Alias "TRB1"   
	
	DbSelectArea("TRB1")
	While TRB1->(!Eof()) 
		nTotClie += TRB1->TOTAL_CLI   
		TRB1->(DbSkip()) 
	End
	TRB1->(dbCloseArea()) 
	
	
	//VISITADOS
	If(select("TRB2") > 0)
		TRB2->(DbCloseArea())
	EndIf                           
	
	cQry2 := "SELECT COUNT(DISTINCT(AD7_CODCLI)) AS TOTAL_AD7													" + Chr(13)
	cQry2 += "FROM " + RetSqlName("AD7") + " AD7, " + RetSqlName("SA1") + " SA1								 	" + Chr(13)
	cQry2 += "WHERE AD7.AD7_CODCLI = SA1.A1_COD																	" + Chr(13)
	cQry2 += "AND AD7.AD7_LOJA = SA1.A1_LOJA                                                                    " + Chr(13)
	cQry2 += "AND AD7.AD7_VEND = SA1.A1_VEND	  																" + Chr(13)
	cQry2 += "AND SA1.D_E_L_E_T_ = ' '																			" + Chr(13) 	
	cQry2 += "AND SA1.A1_MSBLQL != '1'																			" + Chr(13) 	
	cQry2 += "AND AD7.AD7__DTVIS BETWEEN '"+DtoS(_dDataDe)+"' AND  '"+DtoS(_dDataAte)+"' 						" + Chr(13)
	cQry2 += "AND AD7.D_E_L_E_T_ = ' '																			" + Chr(13)
	If !Empty(Alltrim(_cFilial))
		cQry2 += "AND AD7.AD7_FILIAL = '"+_cFilial+"' 					                              		 	" + Chr(13)
	EndIf		
	If !Empty(Alltrim(_cRepres))
		cQry2 += "AND SA1.A1_VEND = '"+_cRepres+"'                               		   						" + Chr(13)
	EndIf
	cQry2 += "GROUP BY AD7_CODCLI																				" + Chr(13) 
	
	TcQuery cQry2 New Alias "TRB2"   
	
	DbSelectArea("TRB2")
	While TRB2->(!Eof()) 
		nVisitad += TRB2->TOTAL_AD7   
		TRB2->(DbSkip()) 
	End
	TRB2->(dbCloseArea())
	
	//COMPRARAM  
	If(select("TRB3") > 0)
		TRB3->(DbCloseArea())
	EndIf   
	
	cQry3 := "SELECT COUNT(DISTINCT(AD7_CODCLI)) AS TOTAL_COM													" + Chr(13)
	cQry3 += "FROM " + RetSqlName("AD7") + " AD7															 	" + Chr(13)
	cQry3 += "INNER JOIN " + RetSqlName("SA3") + " SA3 ON AD7.AD7_VEND = SA3.A3_COD AND							" + Chr(13)
	cQry3 += "                         SA3.D_E_L_E_T_ = ' '                                                     " + Chr(13)
	cQry3 += "WHERE AD7.D_E_L_E_T_ = ' '																		" + Chr(13)
	cQry3 += "AND AD7.AD7__PED <> ' ' 																			" + Chr(13)
	cQry3 += "AND AD7.AD7__DTVIS BETWEEN '"+DtoS(_dDataDe)+"' AND  '"+DtoS(_dDataAte)+"' 						" + Chr(13)
	cQry3 += "AND AD7.AD7_TOPICO LIKE '%COMPROU%'																" + Chr(13)
	If !Empty(Alltrim(_cFilial))
		cQry3 += "AND AD7.AD7_FILIAL = '"+_cFilial+"' 					                              		 	" + Chr(13)
	EndIf				
	If !Empty(Alltrim(_cRepres))
		cQry3 += "AND AD7.AD7_VEND = '"+_cRepres+"'                               		   						" + Chr(13)
	EndIf
	cQry3 += "GROUP BY AD7_CODCLI																				" + Chr(13)
	
	TcQuery cQry3 New Alias "TRB3"   
	
	DbSelectArea("TRB3")
	While TRB3->(!Eof()) 
		nComprou += TRB3->TOTAL_COM   
		TRB3->(DbSkip()) 
	End
	TRB3->(dbCloseArea())   
	
	//NAO COMPRARAM  
	/*If(select("TRB4") > 0)
		TRB4->(DbCloseArea())
	EndIf   
	
	cQry4 := "SELECT DISTINCT(COUNT(AD7_CODCLI)) AS TOTAL_NCOM													" + Chr(13)
	cQry4 += "FROM " + RetSqlName("AD7") + " AD7															 	" + Chr(13)
	cQry4 += "WHERE AD7.D_E_L_E_T_ <> '*'																		" + Chr(13)
	cQry4 += "AND AD7.AD7_TOPICO NOT LIKE '%COMPROU%'															" + Chr(13)
	cQry4 += "GROUP BY AD7_CODCLI																				" + Chr(13)
	
	TcQuery cQry4 New Alias "TRB4"   
	
	DbSelectArea("TRB4")
	While TRB4->(!Eof()) 
		nNcomprou += TRB4->TOTAL_NCOM   
		TRB4->(DbSkip()) 
	End
	TRB4->(dbCloseArea())*/  
	
	//CLIENTES NOVOS  
	If(select("TRB5") > 0)
		TRB5->(DbCloseArea())
	EndIf   
	
	cQry5 := "SELECT SUM(COUNT(*)) AS CLI_NOVOS										   							" + Chr(13)
	cQry5 += "FROM " + RetSqlName("SA1") + " SA1															 	" + Chr(13)
	cQry5 += "WHERE SA1.D_E_L_E_T_ <> '*' And A1_MSBLQL <> '1' And A1__ATIVO <> '2'								" + Chr(13)
	If !Empty(Alltrim(DtoS(_dDataDe))) .And. !Empty(Alltrim(DtoS(_dDataAte)))
		cQry5 += "AND SA1.A1__DTINCL >= '"+DtoS(_dDataDe)+"'                                                    " + Chr(13)
	EndIf 
	If !Empty(Alltrim(_cRepres))
		cQry5 += "AND SA1.A1_VEND = '"+_cRepres+"'                               		   						" + Chr(13)
	EndIf 
	cQry5 += "GROUP BY A1_COD																			   		" + Chr(13)
	
	TcQuery cQry5 New Alias "TRB5"   
	
	DbSelectArea("TRB5")
	While TRB5->(!Eof()) 
		nClNew += TRB5->CLI_NOVOS   
		TRB5->(DbSkip()) 
	End
	TRB5->(dbCloseArea())  
	
	_nTotCli   := nTotClie  
	_nVisit    := nVisitad 
	_nCompr    := nComprou
	_nNaoComp  := nVisitad - nComprou   
	_nNaoVisit := nTotClie - nVisitad   
	_nCliNov   := nClNew    
	
	
	//COTAS DE VENDA  
	If(select("TRB6") > 0)
		TRB6->(DbCloseArea())
	EndIf   
	
	cQry6 := "SELECT *  				   																		" + Chr(13)
	cQry6 += "FROM " + RetSqlName("SCT") + " SCT															 	" + Chr(13)
	cQry6 += "WHERE SCT.D_E_L_E_T_ = ' '																		" + Chr(13)
	If !Empty(Alltrim(_cRepres))
		cQry6 += "AND SCT.CT_VEND = '"+_cRepres+"'                               		   						" + Chr(13)
	EndIf
	If !Empty(Alltrim(DtoS(_dDataDe))) .And. !Empty(Alltrim(DtoS(_dDataAte)))
		cQry6 += "AND SUBSTR(CT_DATA,1,6) =  '"+Substr(DtoS(_dDataAte),1,6)+"'				   					" + Chr(13)
	EndIf  																			   		
	
	TcQuery cQry6 New Alias "TRB6"   
	
	DbSelectArea("TRB6")
	While TRB6->(!Eof()) 
		nCotaPca  += TRB6->CT__COTAPC
		nCotaPne  += TRB6->CT__COTAPN
		nCotaTot  += TRB6->CT_VALOR   
		TRB6->(DbSkip()) 
	End
	TRB6->(dbCloseArea())       
	
	_nPerPeca   := (_nTotPeca/nCotaPca)  * 100
	_nPerPneu   := (_nTotPneu/nCotaPne) * 100 
	_nPerTotal  := (_nVlrTotal/nCotaTot) * 100    
	
	oDlgTMP:refresh()
	
Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ChamaRel				 	| 	Novembro de 2014			  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Chama Relatorios de Pedidos e Visitas			 								|
|-----------------------------------------------------------------------------------------------|
*/ 	          
	
Static Function ChamaRel(nOpcce) 

Local _cFilAtu := cFilAnt

Local nOpcau := nOpcce

If nOpcau == 1 

	cFilAnt := oGetTM1:Acols[oGetTM1:nat][1]
	If Empty(oGetTM1:Acols) .or. Empty(oGetTM1:Acols[oGetTM1:nat][2])
		MsgInfo("Nao ha pedido para exibir !", "escolha outro atendimento")
	Else
		U_IFATR09(oGetTM1:Acols[oGetTM1:nat][2],oGetTM1:Acols[oGetTM1:nat][1])
	EndIf

Else 

	If Empty(Alltrim(_cRepres)) 
		MsgInfo("Por favor selecione um representante !", "Atencao")
	Else
	   U_IFATR08(_cRepres,_dDataDe,_dDataAte,cComboOP)
	   //U_IFATR08(_cRepres,_dDataDe,_dDataAte)
	EndIf
	

	
EndIf 

cFilAnt := _cFilAtu 

Return
		                   
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : BErro1					 	| 	Novembro de 2014			  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Busca Erros na tabela SZA           			 								|
|-----------------------------------------------------------------------------------------------|
*/ 		 
		     
Static Function BErro1()
Local _cFilAtu := cFilAnt
 

    cFilAnt := oGetTM1:Acols[oGetTM1:nat][1]         
	SUA->(DbSetOrder(1))
	SUA->(DbSeek( oGetTM1:Acols[oGetTM1:nat][1]+oGetTM1:Acols[oGetTM1:nat][2] ))
	SZA->(DbSetOrder(1))
	If SZA->(dbseek(oGetTM1:Acols[oGetTM1:nat][1]+oGetTM1:Acols[oGetTM1:nat][2]))
    
	    If SZA->ZA_FLAGIMP == "3" 
			_cAlerta := "OK"
		ElseIf SZA->ZA_FLAGIMP == "4" 
			_cAlerta := "ERRO"
		EndIf	 
	
	EndIf
	
	cFilAnt := _cFilAtu

Return .T.    

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : BErro2					 	| 	Março de 2015			  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido Luis Carlos - Anadi		 													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Busca Erros na tabela SZA e apresenta na tela           			 			|
|-----------------------------------------------------------------------------------------------|
*/ 	

Static Function BErro2()
	Local oButton1
	
	Local nX
	Local aHeaderSZA 	:= {}
	Local aColsSZA 		:= {}
	Local aFieldFill	:= {}
	
	Static oMSNewGe1
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	dbSeek("SZA")                  
	
	do while SX3->X3_ARQUIVO == "SZA"
		If X3Uso(SX3->X3_USADO)   //SX3->X3_USADO == '€€€€€€€€€€€€€€ '
			Aadd(aHeaderSZA, {	SX3->X3_TITULO,;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT,;
								SX3->X3_CBOX,;
								SX3->X3_RELACAO})
		Endif
		SX3->(dbSkip())
	enddo
	

	dbSelectArea("SZA")
	dbSetOrder(1)
	
	_cFilter := " SZA->ZA_FLAGIMP == '4' "		
	
	if ! empty(M->_cSeg)
		_cFilter += " .and. SZA->ZA_SEGISP == '" + M->_cSeg + "' "		
	endif
	
	if ! empty(M->_cFilial)
		_cFilter += " .and. SZA->ZA_FILIAL == '" + M->_cFilial + "' "		
	endif

	if ! empty(M->_dDataDe)
		_cFilter += " .and. dtoc(SZA->ZA_EMISSAO) >= '" + dtoc(M->_dDataDe) + "' "		
	endif
                       
	if ! empty(M->_dDataAte)
		_cFilter += " .and. dtoc(SZA->ZA_EMISSAO) <= '" + dtoc(M->_dDataAte) + "' "		
	endif
	
	set filter to &_cFilter
	
	SZA->(dbGotop())
	
	do while ! SZA->(eof())
	    
		lenAcols := len(aColsSZA)
		aCol := {}
		
		for y:= 1 to len(aHeaderSZA)
			aadd(aCol, SZA->&(aHeaderSZA[y,2]))
		next y
		aadd(aCol, .F.)
	
		aadd(aColsSZA,aCol)

		SZA->(dbSkip())
	enddo	

	if len(aColsSZA) == 0
		dbSelectArea("SX3")
		dbSetOrder(2)
		// Define field values
		For nX := 1 to Len(aHeaderSZA)
			If DbSeek(aHeaderSZA[nX][2])
				Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX
		
		Aadd(aFieldFill, .F.)
		Aadd(aColsSZA, aFieldFill)
	endif			

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3,3}
	aPosObj := MsObjSize(aInfo, aObjects)	

	DEFINE MSDIALOG oDlg TITLE "Erros" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

	MsNewGetDados():New( aPosObj[1,1], aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],0,"AllwaysTrue","AllwaysTrue",,,,,,,, oDlg, aHeaderSZA, aColsSZA)

 	@ aPosObj[1,3]+3,aPosObj[1,4]-160 BUTTON "Sair"	SIZE 60,10 Of oDlg PIXEL  ACTION oDlg:End() 

  	ACTIVATE MSDIALOG oDlg CENTERED

Return   

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : LimpaCpo					 	| 	Novembro de 2014			  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		 									|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Limpa Campos do Filtro                                    					 	|
|-----------------------------------------------------------------------------------------------|
*/ 	

Static Function LimpaCpo(cCpo)          
Local cCpoor := cCpo

			DO CASE
				CASE cCpoor == "EMPRESA"
			  		_cNmEmp	 := ""
				CASE cCpoor == "SITUACAO"
			  		_cNmSit	 := ""
				CASE cCpoor == "SEGMENTO"
			  		_cNmSeg	 := ""
				CASE cCpoor == "CLIENTE"
			  		_cNmCli	 := ""
				CASE cCpoor == "TRANSPORTADORA"
			  		_cNmTra	 := ""
			  		_cDDD1   := ""
			  		_cTel1   := ""
			 	CASE cCpoor == "REPRESENTANTE"
			  		_cNmRep	 := ""
			  		_cDDD2   := ""
			  		_cTel2   := ""
			ENDCASE  
Return .T.                          


#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGENM13 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Consulta padrão filiais do usuário                                                  |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function TrocaEmp()
Local _aArea  := GetArea(), _oGet := Nil, _oDlg1 := {}, _aFilUsr := FwEmpLoad()
Local _aHead := {}, _aFill := {}, _aCol := {}, _ny := _nz := 1
Local _aStru  := {"ZE_COD", "ZE_NOMECON"}, _lok := .f.   
Local cEmmp := ""  
Local aAreaSM0	:= SM0->( GetArea() )

If Len(_aFilUsr) > 0  

	
	AADD( _aHead, { "Cod Empres"     , "M0_CODIGO" , "@!",2 ,,,, "C", "SM0", "V"} )
	AADD( _aHead, { "Nome"    		 , "M0_NOMECOM"   , "@!",30 ,,,, "C", "SM0", "V"} )
 
    For _ny := 1 To Len(_aFilUsr) 
            If 	ascan( _aCol, {|aVal|aVal[1] = _aFilUsr[_ny][1]}) = 0 
            	SM0->( dbSeek( _aFilUsr[_ny][1] ) )
            	//AADD(_aCol,{_aFilUsr[_ny][1],_aFilUsr[_ny][2],.f.}) 
            	AADD(_aCol,{_aFilUsr[_ny][1],SM0->M0_NOMECOM,.f.})      
        	EndIf     
    Next _ny
    
    DEFINE MSDIALOG _oDlg1 TITLE "Escolha a Empresa" FROM 000,000 TO 350,450 PIXEL   
    _oGet := MsNewGetDados():New(300,300,300,300,/*GD_INSERT+GD_DELETE+GD_UPDATE*/,,,,,,999,,,,_oDlg1,_aHead,_aCol)
    AlignObject( _oDlg1 ,{ _oGet:oBrowse }, 1, 1, { 500 } )    
    _oGet:oBrowse:BldBlClick := {|| If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil)}
    ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT ( EnchoiceBar( _oDlg1, { || If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil ) }, { || _oDlg1:End() } ) )

    If _lOK
        If MsgYesNo("Confirma a troca de Empresa?","ATENCAO")
            cEmpAnt := _oGet:aCols[_oGet:nAt][1]
        EndIf
    EndIf
        
EndIf

RestArea(_aArea) 
RestArea( aAreaSM0 )

_cEmpresa := _oGet:aCols[_oGet:nAt][1]
_cNmEmp   := _oGet:aCols[_oGet:nAt][2]
                            
Return                    

Static Function PastaSel(nNpast)
  
Local nNpas := nNpast

If nNpas = 1 
	oTFolder:SetOption(1)    
	CriaColsPed(.F.)
Else
	oTFolder:SetOption(2)  
	CriaColsVis(.F.)
EndIf

Return

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | MudaTransp | Autor: | Jose Augusto F. P. Alves - Anadi      | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Verifica a transportadora do call center                                            |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function MudaTransp()     
   

	SUA->(DbSetOrder(1))
	If SUA->(DbSeek( oGetTM1:Acols[oGetTM1:nat][1]+oGetTM1:Acols[oGetTM1:nat][2] ))  
		DbSelectArea("SA4")

		If dbSeek(xFilial("SA4")+Alltrim(SUA->UA_TRANSP))
   			_cNmTra2 :=  SA4->A4_NOME  	
 		Else
 			_cNmTra2 := ""
 		EndIF
	EndIf   
	
	oGetTra:Refresh()

Return
	
	
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValFil				 	| 	Dezembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi		 									            |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial                         								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValidFil(_cFil)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(_cFIL)
	dbSelectArea("SZE")
	dbSetOrder(1)
	if !dbSeek(_cEmpresa+_cFil)
		msgAlert("Filial não cadastrado !!")
		_lRet := .F.
	EndIf
EndIf

restarea(_aArea)

Return _lRet         



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValidOper				 	| 	Março de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi		 									            |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao do Operador                         								  	|
|-----------------------------------------------------------------------------------------------|
*/
static function ValidOper(_cOpera)
	local _lRet  := .T.

	if !empty(_cOpera)
		dbSelectArea("SU7")
		dbSetOrder(1)
		if !dbSeek(xFilial("SU7")+_cOpera)
			msgAlert("Operador não cadastrado. Favor verificar !!")
			_lRet := .F.
		else
			_cNmOpera := SU7->U7_NOME
		EndIf 
	else
		_cNmOpera	:= space(TamSx3("U7_NOME")[1])
	endif	
return _lRet


User Function ITMKC11A 

	Private cSegc := _cSeg

Return cSegc 	



Static Function IVerSZA()
Local _cMsgSZA := _cSQL := _cTab := ""

_cTab := GetNExtAlias()
_cSQL := "Select Count(ZA_PEDMEX) ZA_PEDMEX From " + RetSqlName("SZA") + " ZA "
_cSQL += "Where ZA_FLAGIMP = '4' " 

If !Empty(M->_cFilial)
    _cSQL += " And ZA_FILIAL = '" + M->_cFilial + "' "       
EndIf

If !Empty(M->_dDataDe)
    _cSQL += " And ZA_EMISSAO >= '" + DTOS(M->_dDataDe) + "' "      
EndIf

If !Empty(M->_dDataAte)
    _cSQL += " And ZA_EMISSAO <= '" + DTOS(M->_dDataAte) + "' "     
EndIf

If !Empty(M->_cSeg)
    _cSQL += " And ZA_SEGISP = '" + M->_cSeg + "' "      
EndIf
_cSQL += " And ZA.D_E_L_E_T_ = ' ' "

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL ), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    If (_cTab)->ZA_PEDMEX > 0
        _cMSgSZA := "Existe(m) " + AllTrim(Str((_cTab)->ZA_PEDMEX)) + " Pedido(s) com problema de Integração"
    EndIf
EndIf 

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

Return _cMSgSZA