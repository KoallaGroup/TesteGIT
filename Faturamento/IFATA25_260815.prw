#include "protheus.ch"
#INCLUDE "topconn.ch"   

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATA25				 	| Novembro de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina criada para excluir as cotações									  	  	|
|-----------------------------------------------------------------------------------------------|
*/         

User Function IFATA25()  

Local nLinha 		:= 5   
Local aStru  		:= {{010,060,090},;
 				  		{250,300,330}}
Local aCpoHeader 	:= {"UA_NUM","UA_EMISSAO", "UA_VEND","UA_VALBRUT","UA_CONDPG","UA__MOTCAN","ZD_DESC"} 				  
Local nStyle    	:= 0 /*GD_INSERT+GD_DELETE+GD_UPDATE*/   
Local aEdit			:= {}

Private aSize       := MsAdvSize(.T.)
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oDlgTMP     := Nil    
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
Private _cFilial	:= "  "
Private _cNmFil		:= "  "
Private _cNmSeg		:= "  "
Private _cSeg		:= space(TamSx3("UA__SEGISP")[1])
Private _nDias		:= 0  


aObjects 	:= {}   
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )

CriaHeader(aCpoHeader)
//CriaCols()

//Cria janela

DEFINE MSDIALOG oDlgTMP TITLE "Exclusão de cotação" FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
oDlgTMP:lMaximized := .F.

@ nLinha,aStru[1][1] Say "Filial: " 		SIZE 040,10 OF oDlgTMP PIXEL FONT oFont14 
@ nLinha,aStru[1][2] MsGet _cFilial  		F3 "DLB" Size 10,10 of oDlgTMP PIXEL FONT oFont14 VALID ValFil(_cFilial)
@ nLinha,aStru[1][3] MsGet _cNmFil  		Size 100,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

@ nLinha,aStru[2][1] Say "Segmento: " 		SIZE 040,10 OF oDlgTMP PIXEL FONT oFont14
@ nLinha,aStru[2][2] MsGet _cSeg 			F3 "SZ7" Size 010,10 of oDlgTMP PIXEL FONT oFont14 VALID ExistCPO("SZ7") .And. ValSeg(_cSeg) 
@ nLinha,aStru[2][3] MsGet _cNmSeg  		Size 060,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.
nLinha += 16

@ nlinha,aStru[1][1] Say "Qtde. de Dias: " 	SIZE 080,10 OF oDlgTMP PIXEL FONT oFont14
@ nLinha,aStru[1][2] MsGet _nDias 			PICTURE "@E 999" Size 025,10 of oDlgTMP PIXEL FONT oFont14 

@ nLinha,aStru[2][1] Button oButton PROMPT "Processar"  SIZE 40,10   OF oDlgTMP PIXEL ACTION CriaCols()  
@ nLinha,aStru[2][2] Button oButton PROMPT "Sair"  SIZE 40,10   OF oDlgTMP PIXEL ACTION oDlgTMP:End()

oGetTM1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-10,aPosObj[2,4], nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)
                                                              
@ aPosObj[2,3]-5,aPosObj[2,4]-50 Button oButton PROMPT "Cancela"  SIZE 40,13   OF oDlgTMP PIXEL ACTION (CancCot())


ACTIVATE MSDIALOG oDlgTMP CENTERED  

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
aHeaderB      := {}
For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
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

AADD( aHeaderB, { "Recno WT", "UA_REC_WT", "", 09, 0,,, "N", "SUA", "V"} )

Return Nil 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaCols				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols()
Local   n			:= 0 
Local 	nPos_Num 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_NUM"		})
Local	nPos_Emis 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_EMISSAO"	})
Local	nPos_Vend 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_VEND"		})
Local	nPos_VBru 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_VALBRUT"	})
Local	nPos_Cond 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_CONDPG"	})
Local	nPos_Canc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA__MOTCAN"	})
Local	nPos_NmCa 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZD_DESC"		}) 
Local	nQtdCpo 	:= Len(aHeaderB)
Local 	cDtAte		:= dDataBase
Local   cDtDe		:= dDataBase - _nDias                                                                              



If(select("TRB_SUA") > 0)
	TRB_SUA->(DbCloseArea())
EndIf
             

_cQuery := "SELECT SUA.*, SZD.*, SUA.R_E_C_N_O_ RECSUA					   						"
_cQuery += "FROM " + RetSqlName("SUA") + " SUA 										   	   		"
_cQuery += "LEFT JOIN " + RetSqlName("SZD") + " SZD ON ZD_COD = UA__MOTCAN 		   	   			"
_cQuery += "			 AND ZD_TIPO = 'PE'														"
_cQuery += "			 AND SZD.D_E_L_E_T_ = ' ' 									   	   		"
_cQuery += "WHERE SUA.D_E_L_E_T_ = ' ' 												   	   		"
_cQuery += "	  AND UA__TIPPED = '4' 												   			"
_cQuery += "	  AND SUA.UA__FILIAL = '" + _cFilial + "' 		   						   		"
If _cSeg <> "0" 
	_cQuery += "	  AND SUA.UA__SEGISP = '" + _cSeg + "'		   								"
EndIF
_cQuery += "	  AND SUA.UA_EMISSAO <= '" + DtoS(cDtDe) + "' 								 	"
_cQuery += "      AND SUA.UA__RESEST = 'N' "
_cQuery += "	  AND SUA.D_E_L_E_T_ = ' '  													"
	
TcQuery _cQuery New Alias "TRB_SUA"
TCSetField("TRB_SUA","UA_EMISSAO","D")

oGetTM1:Acols := {}

If(Empty(TRB_SUA->UA_NUM))
	n++
	AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
	
	oGetTM1:Acols[n][nQtdCpo+1]  	 	:= .F.
	oGetTM1:Acols[n][nPos_Num]		   	:= space(TamSx3("UA_NUM")[1])
	oGetTM1:Acols[n][nPos_Emis]	 	:= "  /  /    "
	oGetTM1:Acols[n][nPos_Vend] 		:= space(TamSx3("UA_VEND")[1])
	oGetTM1:Acols[n][nPos_VBru] 	 	:= 0
	oGetTM1:Acols[n][nPos_Cond] 	 	:= space(TamSx3("UA_CONDPG")[1])
	oGetTM1:Acols[n][nPos_Canc] 	 	:= space(TamSx3("UA__MOTCAN")[1])
	oGetTM1:Acols[n][nPos_NmCa] 	 	:= space(TamSx3("ZD_DESC")[1])
	oGetTM1:Acols[n][Len(aHeaderB)] 	:= 0
	oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
Else
	DbSelectArea("TRB_SUA")
	TRB_SUA->(DbGoTop())
	While ! TRB_SUA->(eof())
		n++
		AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
		
		oGetTM1:Acols[n][nPos_Num]		   	:= TRB_SUA->UA_NUM
		oGetTM1:Acols[n][nPos_Emis]	   		:= TRB_SUA->UA_EMISSAO
		oGetTM1:Acols[n][nPos_Vend] 		:= TRB_SUA->UA_VEND
		oGetTM1:Acols[n][nPos_VBru] 	 	:= TRB_SUA->UA_VALBRUT
		oGetTM1:Acols[n][nPos_Cond] 	 	:= TRB_SUA->UA_CONDPG
		oGetTM1:Acols[n][nPos_Canc] 	 	:= TRB_SUA->UA__MOTCAN
		oGetTM1:Acols[n][nPos_NmCa] 	 	:= TRB_SUA->ZD_DESC
		oGetTM1:Acols[n][Len(aHeaderB)] 	:= TRB_SUA->RECSUA
		oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
		TRB_SUA->(DbSkip())
	EndDo
EndIf

oGetTM1:refresh() 

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

If(dbSeek(cEmpAnt+_cFilial))
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
|	Programa : CancCot				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validacao da Filial e Preenchimento do Acols								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CancCot()  
                          
Local nTotRegs	:= 0      
Local cQrySUA 	:= ""
Local cQrySUB 	:= ""                 
                          
	If msgYesNo("Tem certeza que deseja excluir as cotacoes?","ATENCAO")

		DbSelectArea("TRB_SUA")
		TRB_SUA->(DbGoTop())
		While ! TRB_SUA->(eof())
	        
	   		DbSelectArea("SUA")
			SUA->( dbGoTo( TRB_SUA->RECSUA ) )
			TkY150ExcOr()	
			TRB_SUA->( dbSkip() )
	   	
	   	End 		
		
		TRB_SUA->( dbCloseArea() )   
		MsgInfo("Cotacoes exluidas com sucesso.")
	Endif
      


oDlgTMP:End()

Return    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³TK150ExcOr³ Autor ³ Vendas Clientes    	³ Data ³ 28/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de exclusao de Orcamentos						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tk150ExcOrc()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ CALL CENTER 												  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TkY150ExcOr()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exclusao do cadastro de parcelas da condicao de pagamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SL4" )
If DbSeek( xFilial("SL4")+ SUA->UA_NUM + "SIGATMK ")
	While !Eof() 					  .AND. ;
		  xFilial("SL4") == L4_FILIAL .AND. ;
		  L4_NUM == SUA->UA_NUM 	  .AND. ;
		  L4_ORIGEM == "SIGATMK "	
		Reclock("SL4",.F.,.T.)
		DbDelete()
		MsUnlock()
		SL4->(DbSkip())
	End
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exclusao dos itens do atendimento - Televendas       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SUB")
DbSetorder(1)
If DbSeek(xFilial("SUB")+SUA->UA_NUM )
	While !Eof() .AND. xFilial("SUB") == UB_FILIAL .AND. UB_NUM == SUA->UA_NUM
		Reclock("SUB" ,.F.,.T.)
		DbDelete()
		MsUnlock()
		SUB->(DbSkip())
	End
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a exclusao do contrato de credito. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TkY150ExCre()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exclusao do cabecalho do atendimento Televendas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reclock( "SUA" ,.F.,.T.)
DbDelete()
MsUnlock()  



Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tk150ExCred ºAutor  ³Vendas Clientes   º Data ³  06/24/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realizar a exclusao do contrato de credito quando foi feito º±±
±±º          ³no orcamento ou pedido.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CALL CENTER - TELEVENDAS                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TkY150ExCre()

Local aARea		:= GetArea()   	// Salva a area atual
Local lRet		:= .T.			// Retorno da funcao
Local lSigaCRD	:= .F.			// Indica se o operador esta configurado para realizar a analise de credito pelo SIGACRD
Local cEstacao	:= ""			// Codigo da estacao
Local aRetCRD	:= {}			// Retorno da funcao de cancelamento do contrato

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o operador realiza analise de credito atraves do SIGACRD³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEstacao:= TkPosto(SUA->UA_OPERADO,"U0_ESTACAO")
Dbselectarea("SLG")
DbSetOrder(1)
If DbSeek(xFilial("SLG")+cEstacao)
	If LG_CRDXINT == "1"	//Sim
		lSigaCrd:= .T.
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exclui a transacao de credito quando existiu ³
//³analise de credito feita pelo SIGACRD        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSigaCrd
	If SUA->(FieldPos("UA_CONTRA")) > 0
		If !Empty(SUA->UA_CONTRA)
    		aRetCrd    := aClone(CrdxVenda( "3", {"",""}, SUA->UA_CONTRA, .F., Nil))     		   
		Endif
	Endif
Endif			
                                                     
RestArea(aArea)
Return(lRet)  