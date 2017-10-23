#include "protheus.ch"
#INCLUDE "topconn.ch"   

/*
+----------+----------+-------+------------------------------------------+------+---------------+
|Programa  | IFATA32  | Autor | Jose Augusto F. P. Alves - Anadi  		 | Data | 	 Marco/2015 |
+----------+----------+-------+------------------------------------------+------+---------------+
|Descricao | Mostra informacoes de transportadora do pedido								 	    |
+----------+------------------------------------------------------------------------------------+
|Uso       | Isapa                                                                              |
+----------+------------------------------------------------------------------------------------+
*/

User Function IFATA32()  
Local oButton1
Local oGet1
Local cGet1 := Space(6)
Local oGet2
Local cGet2 := Space(80)
Local oSay1
Local oSay2
Local aEdit			:= {}
Static oDlg  
                

//Local aCpoHeader 	:= {"F2_VOLUME1","F2_VOLUME2","F2_VOLUME3","F2_VOLUME4","F2_ESPECI1","F2_ESPECI2","F2_ESPECI3","F2_ESPECI4"} 
//Local aCpoHeader 	:= {"Campo","Conteudo"} 
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil 

cGet1 := SF2->F2_TRANSP
cGet2 := Posicione("SA4",1, xFilial("SA4")+SF2->F2_TRANSP, "A4_NOME")   
                           
AADD( aHeaderB, { "Campo", "Campo", "", 20, 0,,, "C", "", "V"} ) 
AADD( aHeaderB, { "Conteudo", "Conteudo", "", 20, 0,,, "C", "", "V"} )
//CriaHeader(aCpoHeader)
CriaCols()

  DEFINE MSDIALOG oDlg TITLE "Consulta Transportadora" FROM 000, 000  TO 320, 650 COLORS 0, 16777215 PIXEL

    @ 010, 007 SAY oSay1 PROMPT "Cod. Transportadora:" SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 008, 060 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 025, 007 SAY oSay2 PROMPT "Nome Trasportadora:" SIZE 051, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 060 MSGET oGet2 VAR cGet2 SIZE 159, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 147, 283 BUTTON oButton1 PROMPT "Sair" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()  
    
	oGetTM1 := MsNewGetDados():New( 040, 002, 142, 323, 0, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aEdit,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderB, aColsB)

  ACTIVATE MSDIALOG oDlg CENTERED

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

AADD( aHeaderB, { "Recno WT", "F2_REC_WT", "", 09, 0,,, "N", "SF2", "V"} )

Return Nil            

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaCols				 	| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto Ferraraz Pereria Alves - Anadi		 						|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/                             

Static Function CriaCols()
/*Local   n			:= 0 
Local 	nVol1 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VOLUME1"	})
Local	nVol2 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VOLUME2"	})
Local	nVol3 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VOLUME3"		})
Local	nVol4 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_VOLUME4"	})
Local	nEsp1 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_ESPECI1"	})
Local	nEsp2 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_ESPECI2"	})
Local	nEsp3 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_ESPECI3"		}) 
Local	nEsp4 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "F2_ESPECI4"		}) 
Local	nQtdCpo 	:= Len(aHeaderB)*/                                                                           


If(select("TRB_SF2") > 0)
	TRB_SF2->(DbCloseArea())
EndIf             

_cQuery := " SELECT SF2.*,  															"
_cQuery += " SF2.R_E_C_N_O_ RECSF2														"
_cQuery += " FROM " + RetSqlName("SF2") + " SF2 										"
_cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' 												"
_cQuery += " AND SF2.F2_DOC = 		'" + SF2->F2_DOC + "' 		   						"     
_cQuery += " AND SF2.F2_SERIE = 	'" + SF2->F2_SERIE + "' 		   					"
_cQuery += " AND SF2.F2_CLIENTE = 	'" + SF2->F2_CLIENTE  + "' 		   					"
_cQuery += " AND SF2.F2_LOJA = 		'" + SF2->F2_LOJA + "' 		   						" 
_cQuery += " AND SF2.F2_FILIAL = 	'" + SF2->F2_FILIAL + "' 		   					"
_cQuery += " AND SF2.D_E_L_E_T_ = ' '  													"
	
TcQuery _cQuery New Alias "TRB_SF2"

AcolsD := {}

	DbSelectArea("TRB_SF2")
	For i := 1 To TRB_SF2->(FCOUNT())
   		 If "F2_ESPECI" $ TRB_SF2->(FIELD(i))  .OR. "F2_VOLUME" $ TRB_SF2->(FIELD(i))
   		 	If "F2_ESPECIE" <> TRB_SF2->(FIELD(i))     
   		 		Aadd(AcolsD,{TRB_SF2->(FIELD(i)),TRB_SF2->&((FIELD(i)))})
   		  	EndIf
   		 EndIf
 	Next i 
    
    AcolsB := {}  
    
	For j := 1 To Len(AcolsD) 
		_cCpoHead := AcolsD[j][1]   
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(AcolsB, {Trim(SX3->X3_Titulo),IIf(valtype(AcolsD[j][2]) == "N",Alltrim(Str(AcolsD[j][2])),AcolsD[j][2]),.F.})
		Endif
 	Next i 
 

/*	AcolsB := {}   

	DbSelectArea("TRB_SF2")
	TRB_SF2->(DbGoTop())
	While ! TRB_SF2->(eof())
		n++
		AAdd(AcolsB, Array(nQtdCpo+1))
		
		AcolsB[n][nVol1]			:= TRB_SF2->F2_VOLUME1
		AcolsB[n][nVol2]	   		:= TRB_SF2->F2_VOLUME2
		AcolsB[n][nVol3] 			:= TRB_SF2->F2_VOLUME3
		AcolsB[n][nVol4] 	 		:= TRB_SF2->F2_VOLUME4
		AcolsB[n][nEsp1] 	 		:= TRB_SF2->F2_ESPECI1
		AcolsB[n][nEsp2] 	 		:= TRB_SF2->F2_ESPECI2
		AcolsB[n][nEsp3] 	 		:= TRB_SF2->F2_ESPECI3 
		AcolsB[n][nEsp4] 	 		:= TRB_SF2->F2_ESPECI4
		AcolsB[n][Len(aHeaderB)] 	:= TRB_SF2->RECSF2
		AcolsB[n][Len(aHeaderB)+1]	:= .F.
		TRB_SF2->(DbSkip())
	EndDo

*/

Return                                         
