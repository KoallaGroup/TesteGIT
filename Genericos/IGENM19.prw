#INCLUDE "rwmake.ch" 
#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IGENM19				 	| Dezembro de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por  Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Altera Parametros Customizados								  	  				|
|-----------------------------------------------------------------------------------------------|
*/    

User Function IGENM19

Local lOk		:= .F.
Local lDel		:= .F.
Local aX6Head	:= {}
Local cTitDtq	:= "Altera Parametros Customizados"
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

Private aSize       := MsAdvSize(.T.)

aObjects 	:= {}   
AAdd(aObjects,{100,150,.t.,.f.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects ) 

/*aadd(aParamet, "MV__CLIINA")
aadd(aParamet, "MV__DEFSEG")
aadd(aParamet, "MV__ESTSUF")
aadd(aParamet, "MV__FILREO")
aadd(aParamet, "MV__IPIORI")
aadd(aParamet, "MV__LOCPAD")
aadd(aParamet, "MV__MAXPED")
aadd(aParamet, "MV__MAXPRA")
aadd(aParamet, "MV__MINPED")
aadd(aParamet, "MV__MOTVIS")
aadd(aParamet, "MV__TABPUF")
aadd(aParamet, "MV__TRPTMK")
aadd(aParamet, "MV__USRSZI")
aadd(aParamet, "MV__DEFEST")*/  

DbSelectArea("SX6")
DbSetOrder(1) 
SX6->(DbGotop())
While SX6->(!Eof()) 
	If Substr(Alltrim(SX6->X6_VAR),1,4) == "MV__"
    	aadd(aParamet, SX6->X6_VAR)
 	EndIf
	SX6->(DbSkip())
End
SX6->(DbCloseArea())

aAdd(aX6Head, {"Filial"	   		, "X6_FIL"		, "@!", 002, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aX6Head, {"Parametro"		, "X6_VAR"		, "@!", 015, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aX6Head, {"Descricao" 		, "X6_DESCRIC"	, "@!", 050, 00, "", "", "C", "", "" ,"" ,"", ".F.", "V", "", "", ""}) 
aAdd(aX6Head, {"Conteudo"		, "X6_CONTEUD"  , "@!", 050, 00, "", "", "C", "", "" ,"" ,"", ".T.", "R", "", "", ""})  
aAdd(aX6Head, {"Desc Completa"	, "DESC_TOTAL"  , "@!", 080, 00, "", "", "M", "", "" ,"" ,"", ".F.", "R", "", "", ""}) 
//aAdd(aX6Head, {X3Titulo(), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT ,SX3->X3_CBOX ,SX3->X3_RELACAO, SX3->X3_WHEN, SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR, SX3->X3_OBRIGAT})

aHeader	:= aX6Head                                      
aCols 	:= fCols()
nMax 	:= nTamAcols := Len(aX6Head)   
Aadd(aAltera,"X6_CONTEUD") 
Aadd(aAltera,"DESC_TOTAL")
	
Define MsDialog oTelaDtq TITLE "Alteracao de Parametros Customizados"  FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
oTelaDtq:lMaximized := .F.
	
oGetTit:=MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]+100,aPosObj[1,4],nStyle,,,,aAltera,,nMax,,,.t.,oTelaDtq,aHeader,aCols)

Activate MsDialog oTelaDtq Centered On Init Enchoicebar(oTelaDtq, {|| lOk:=.T.,oTelaDtq:End()},{|| lOk:=.F.,oTelaDtq:End()},,aButtons)

If lOk
	
	for x:=1 to len(oGetTit:Acols)    
		SX6->(DbGoTop())
		If SX6->(DbSeek(oGetTit:Acols[x][1]+oGetTit:Acols[x][2]))
			RecLock("SX6", .F. )
			SX6->X6_CONTEUD:= oGetTit:Acols[x][4]
			SX6->(MsUnLock())
		Endif
	Next 
	
	MsgInfo("Parametros Atualizados com Sucesso!")
	
EndIf

Return


Static Function fCols()   

Local aArray := {}    

For I:=1 To Len(aParamet) 
	dbSelectArea("SX6")
	SX6->(DbGoTop())
	While ! SX6->(Eof())
		If SX6->X6_VAR = aParamet[I] 
			Aadd(aArray,{SX6->X6_FIL,SX6->X6_VAR,SX6->X6_DESCRIC,SX6->X6_CONTEUD,Alltrim(SX6->X6_DESCRIC)+Alltrim(SX6->X6_DESC1)+Alltrim(SX6->X6_DESC2),.F.})
		EndIf  
		SX6->(DbSkip())
	End 
Next

Return AClone(aArray)

