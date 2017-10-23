#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFISA01				 	| 	Junho de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta para alterar aliquota de IPI dos produtos de um determinado NCM  	  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFISA01()      
Local _aArea	:= GetArea()
Local aCampos  	:= {}               
Local aButtons 	:= {{"EDIT", { || ITMKA21C()  },"Definir comissoes" } }
Local cNCM		:= space(TamSx3("B1_POSIPI")[1])
Local nQtdCpo   := 0
Local nCols     := 0
Local n			:= 0
Local nStyle    := /*GD_INSERT+GD_DELETE+*/GD_UPDATE

Private nPos_NCM 	:= ""
Private nPos_IPI 	:= ""
Private nQtde 		:= 0
Private nDesc 		:= 0
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oDlgTMP     := Nil
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {"B1_IPI","IPI"}
Private aRotina     := .F.
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)

aObjects 	:= {}
aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )

CriaHeader()
CriaCols()

//Cria janela

DEFINE MSDIALOG oDlgTMP TITLE "Consulta de alteracao de IPI" FROM aSize[7]-50, 400 TO aSize[6]-200,aSize[5]-200 PIXEL
oDlgTMP:lMaximized := .F.

@ 5,005 Say "NCM: " SIZE 50,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,035 MsGet cNCM Picture "@R 9999.99.99" F3 "SYD" Size 60,10 of oDlgTMP PIXEL FONT oFont14
@ 5,120 Button oButton PROMPT "Consultar"  SIZE 40,10   OF oDlgTMP PIXEL ACTION CriaCols(cNCM)

oGetTM1 := MsNewGetDados():New(20, 0, 190, 350, nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

oSBtn2  := SButton():New( 192,262,1,{|| U_IFISA01G(cNCM,oGetTM1:aCols[oGetTM1:nAt][nPos_IPI]),oDlgTMP:end()},oDlgTMP,,"", )
oSBtn3  := SButton():New( 192,300,2,{|| oDlgTMP:end()},oDlgTMP,,"", )
                                                                          
ACTIVATE MSDIALOG oDlgTMP CENTERED //ON INIT EnchoiceBar(oDlgTMP,{||ITMKA21G(),oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)   

RestArea(_aArea)

Return .T.                      


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Junho de 2014					  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()
aHeaderB      := {}
aCpoHeader   := {"B1_POSIPI","B1_IPI"}
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
		".T."       		,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3		    ,;
		SX3->X3_Context})
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

Return Nil 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaCols				 	| 	Junho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols(cNCM)
Local   n			:= 0 
Local	nQtdCpo 	:= Len(aHeaderB)

nPos_NCM 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_POSIPI"	})
nPos_IPI 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_IPI"		})

If(select("TRB_SB1") > 0)
	TRB_SB1->(DbCloseArea())
EndIf
             
AcolsB := {}

	if(Empty(cNCM))
		aColsB := {}
		n++
      	AAdd(aColsB, Array(nQtdCpo+1))

		aColsB[n][nQtdCpo+1]  	 	:= .F.
		AcolsB[n][nPos_NCM]		   	:= space(TamSx3("B1_POSIPI")[1])
		AcolsB[n][nPos_IPI]	 	 	:= space(TamSx3("B1_IPI")[1])
		AcolsB[n][Len(aHeaderB)+1]	:= .F.
	Else                           
		_cQuery := "SELECT DISTINCT SB1.B1_POSIPI           "
		_cQuery += "FROM " + RetSqlName("SB1") + " SB1      "
		_cQuery += "WHERE SB1.D_E_L_E_T_ = ' ' AND          "
		_cQuery += "		SB1.B1_POSIPI = '" + cNCM + "' 		"
		_cQuery := ChangeQuery(_cQuery)
		TcQuery _cQuery New Alias "TRB_SB1"
		
		oGetTM1:Acols := {}                              
		
		If(Empty(TRB_SB1->B1_POSIPI))                        
			n++
	      	AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
	
			oGetTM1:Acols[n][nQtdCpo+1] := .F.
			oGetTM1:Acols[n][nPos_NCM]		   	:= space(TamSx3("B1_POSIPI")[1])
			oGetTM1:Acols[n][nPos_IPI]	 	 	:= 0
			oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
		EndIf
		
		DbSelectArea("TRB_SB1")
		While !(eof())
			n++    
	      	AAdd(oGetTM1:Acols, Array(nQtdCpo+1))
	
			oGetTM1:Acols[n][nQtdCpo+1]  	 	:= .F.
			oGetTM1:Acols[n][nPos_NCM]			:= TRB_SB1->B1_POSIPI
			oGetTM1:Acols[n][nPos_IPI]		 	:= 0
			oGetTM1:Acols[n][Len(aHeaderB)+1]	:= .F.
				   	  	     
			DbSkip()
		EndDo
	
	 	TRB_SB1->(dbCloseArea())
	EndIf
	
 	if(!Empty(cNCM))
		oGetTM1:Refresh()
 	EndIf	

Return       
                                                                     
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFISA01G				 	| 	Junho de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Gravar   	  																	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFISA01G(cNCM,nIPI)           
Local _cQuery := ""

If (!Empty(cNCM))
	_cQuery := "UPDATE " + retSqlname("SB1") 
	_cQuery += " SET B1_IPI = " + nIPI
	_cQuery += " WHERE B1_POSIPI = '" + cNCM + "'"  
	//_cQuery := ChangeQuery(_cQuery) 
	                                                                
	If (TCSQLExec(_cQuery) < 0)
	    Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf
Else
	alert("Não existem produtos com esse NCM")
EndIf

Return