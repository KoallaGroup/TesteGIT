#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 09/10/2014
/*/
//--------------------------------------------------------------
User Function ICOMP01()

Local oButton1
Local oButton2
Local oButton3

Private oGet1
Private cGet1		:= Space( Len( ZX5->ZX5_CODIGO  ) )

Private oSay1
Private oSay2
Private oSay3

Private oForOri
Private cForOri 	:= Space( Len( SA2->A2_COD     ) )
Private oGet5
Private cGet5 		:= Space( Len( SA2->A2_LOJA    ) )

Private oGet3
Private cGet3 		:= Space( Len( SA2->A2_COD     ) )
Private oGet4
Private cGet4 		:= Space( Len( SA2->A2_LOJA    ) )

Private oNmForOri
Private cNmForOri	:= Space( Len( SA2->A2_NOME    ) )
Private oGet6
Private cGet6 		:= Space( Len( SA2->A2_NOME    ) )
Private oDesGr
Private cDesGr		:= Space( Len( ZX5->ZX5_DSCGRP ) )

Static oDlg

DEFINE MSDIALOG oDlg TITLE "DE PARA - PROD X FORNEC" FROM 000, 000  TO 480, 700 COLORS 0, 16777215 PIXEL

@ 007, 003 SAY 		oSay1 		PROMPT	"Grupo Cotacao" 								SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 006, 053 MSGET	oGet1		VAR 	cGet1 		Valid U_GetGrp(cGet1)	  			SIZE 064, 010 OF oDlg COLORS 0, 16777215 F3 "ISPFOR" PIXEL
@ 006, 119 MSGET 	oDesGr		VAR 	cDesGr 		When .f. 				   			SIZE 230, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 025, 004 SAY 		oSay2 		PROMPT	"Do Fornecedor" 						   		SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 053 MSGET 	oForOri 	VAR 	cForOri 										SIZE 064, 010 OF oDlg COLORS 0, 16777215 F3 "ICOM14" PIXEL
@ 024, 119 MSGET 	oGet5 		VAR 	cGet5 		Valid U_GetForn(cForOri,cGet5,1)	SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 152 MSGET 	oNmForOri	VAR 	cNmForOri 	When .f.					   		SIZE 197, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 042, 004 SAY 		oSay3		PROMPT 	"Para Fornecedor" 						   		SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 041, 053 MSGET 	oGet3 		VAR 	cGet3 											SIZE 064, 010 OF oDlg COLORS 0, 16777215 F3 "ICOM14" PIXEL
@ 041, 119 MSGET 	oGet4	 	VAR 	cGet4 		Valid U_GetForn(cGet3,cGet4,2)		SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 041, 152 MSGET 	oGet6 		VAR 	cGet6		When .f. 					   		SIZE 197, 010 OF oDlg COLORS 0, 16777215 PIXEL

fMSNewGe1()

@ 056, 006 BUTTON oButton1 		PROMPT 	"Listar Itens"	Action U_LstItem(cForOri)		SIZE 037, 012 OF oDlg PIXEL

@ 217, 144 BUTTON oButton2 		PROMPT 	"Gravar" 		Action U_ValidGrv() 			SIZE 037, 012 OF oDlg PIXEL
@ 217, 269 BUTTON oButton3 		PROMPT 	"Cancelar" 		Action {||oDlg:End()}			SIZE 037, 012 OF oDlg PIXEL


ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"B1_COD","A5_CODPRF","B1_DESC"}
Local aAlterFields := {}
Static oMSNewGe1

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEx, aFieldFill)

oMSNewGe1 := MsNewGetDados():New( 072, 004, 209, 348, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LstItem   ºAutor  ³Alexandre Caetano   º Data ³  09/Out/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Lista item da SA5 cadastrado para o fornecedor              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LstItem(PForOri)

Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"A5_PRODUTO"    , "A5_CODPRF"    , "B1_DESC" }
Local aAlterFields 	:= {}
Local cQry
Local oRetorna

Static oMSNewGe1D

aHeaderA5			:= {}
AColsA5 			:= {}

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderA5, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsA5, aFieldFill)

// Preenche dados do aCols

If Select("TMPA5") > 0
	dbSelectArea("TMPA5")
	DbCloseArea()
EndIf

cQry := " SELECT A5_PRODUTO, A5_CODPRF, A5_NOMPROD "
cQry += " FROM " + RetSqlName("SA5") + " A5 "
cQry += " WHERE A5.D_E_L_E_T_ = '' "
cQry += "   AND A5_FORNECE = '" + PForOri + "' "
cQry += "   AND A5_LOJA    = '" + cGet5   + "' "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPA5",.T.,.F. )

AColsA5 := {}

TMPA5->( dbGoTop() )
Do While TMPA5->( !EoF() )
	aAdd( aColsA5, {TMPA5->A5_PRODUTO, TMPA5->A5_CODPRF, TMPA5->A5_NOMPROD, .f. } )
	TMPA5->( dbSkip() )
Enddo

// --------------------------------------------

DEFINE MSDIALOG oDlgLstIte TITLE "Lista de Produtos"  FROM 000, 000  TO 450, 600 COLORS 0, 16777215 PIXEL

oMSNewGe1D := MsNewGetDados():New( 003, 003, 190, 300, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgLstIte, aHeaderA5, aColsA5)
@ 200, 260 BUTTON oRetorna 		PROMPT "Retornar" Action {|| oDlgLstIte:end()}			SIZE 040, 020 OF oDlgLstIte PIXEL

ACTIVATE MSDIALOG oDlgLstIte CENTERED

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetForn   ºAutor  ³Alexandre Caetano   º Data ³  09/Out/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza descrição do fornecedor                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetForn(PForn,PLoja,POrd)
Local cNomeForn

cNomeForn := Posicione("SA2",1, xFilial("SA2") + PForn + PLoja,"A2_NREDUZ")
if POrd = 1      // Origem
	
	cNmForOri := cNomeForn
	oNmForOri:Refresh()
	
Elseif PORd = 2  // Destino
	
	cGet6	:= cNomeForn
	oGet6:Refresh()
	
Endif
Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetGrp    ºAutor  ³Alexandre Caetano   º Data ³ 09/Out/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza descrição do Grupo                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetGrp(PGrp)


cDesGr := Posicione("ZX5",1, XFilial("ZX5") + Space(2) + "000001" + PGrp, "ZX5_DSCITE")
oDesGr:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidGrv  ºAutor  ³Alexandre Caetano   º Data ³ 10/Out/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida dados antes de gravar dados na SA5                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValidGrv()
Local lOK := .t.

SA2->( dbSetOrder(1) )
if !SA2->( dbSeek( xFilial("SA2") + cForOri + cGet5, .f. ) )
	lOK	:= .f.
	msgAlert("Fornecedor Origem não existe." + Chr(13) +;
	"Digite um  fornecedor válido.","Atenção")
Endif

if !SA2->( dbSeek( xFilial("SA2") + cGet3 + cGet4, .f. ) )
	lOK	:= .f.
	msgAlert("Fornecedor Destino não existe." + Chr(13) +;
	"Digite um  fornecedor válido.","Atenção")
Else
	SA5->( dbSetOrder(1)	)
	if SA5->( dbSeek( xFilial("SA2") + cGet3 + cGet4, .f. ) )
		lOK	:= .f.
		msgAlert("Fornecedor Destino ja possui dados de amarrações Produto X Fornecedor." + Chr(13) +;
		"               Exclua os registros existentes antes desta operação.               ", "Atenção" )
	Endif
Endif

if lOk
	Processa({|| GrvDados() },"Aguarde! Realizando cópia dos registros...",,.T.)
Endif


Return(.t.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvDados  ºAutor  ³Alexandre Caetano   º Data ³  09/Out/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava dados do fornecedor origem para o fornecedor destino  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvDados()

Local cQry
Local aColsA5 := {}
Local nPosSeg	:= 0

If Select("TMPA5") > 0
	dbSelectArea("TMPA5")
	DbCloseArea()
EndIf

cQry := " SELECT * "
cQry += " FROM " + RetSQLName("SA5") + " A5 "
cQry += " WHERE A5.D_E_L_E_T_ = ' ' "
cQry += "   AND A5_FORNECE = '" + cForOri + "' "
cQry += "   AND A5_LOJA    = '" + cGet5   + "' "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPA5",.T.,.F. )

aCamposA5 := SA5->( DbStruct() )


//dbSelectArea("SX3")
//dbSetOrder(2)
//If DbSeek("A5__SEGISP")
//	nPosSeg	:= SX3->X3_ORDEM
//EndIf

/*
While !Eof() .And. SX3->X3_ALIAS == "SA5"
	If X3Uso(SX3->X3_Usado)
		AAdd(aCamposA5, {Trim(	SX3->X3_Titulo)		,;
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
	DbSkip()
EndDo
*/

SA5->( dbGoTop() )

Do While TMPA5->( !EoF() )
	
	Reclock("SA5",.t.)
	For i := 1 to Len(aCamposA5)
		
		if     SA5->( FieldName(i) ) == "A5_FORNECE"
			SA5->A5_FORNECE	:= cGet3
		Elseif SA5->( FieldName(i) ) == "A5_LOJA"
			SA5->A5_LOJA 	:= cGet4
		Elseif SA5->( FieldName(i) ) == "A5_NOMEFOR"
			SA5->A5_NOMEFOR := cGet6
		//Elseif SA5->( FieldName(i) ) == "A5__SEGISP"  // campo customizado aparece depois do d_e_l_e_t_ e r_e_c_n_o_ da qury
			//SA5->( FieldPut(FieldPos(aCamposA5[i][1]), ("TMPA5->" + aCamposA5[i][1])))
			//SA5->( Fieldput( i, Str(TMPA5->(FieldPos(aCamposA5[i][1]) ) ) ) )
		Else
//			SA5->( Fieldput( i, TMPA5->( FieldGet(i) ) ) )
			FieldPut(FieldPos(aCamposA5[i][1]), &("TMPA5->" + aCamposA5[i][1]))
			
		Endif
		
	Next i
	SA5->( msUnlock() )
	
	aAdd( aColsA5, {SA5->A5_PRODUTO, SA5->A5_CODPRF, SA5->A5_NOMPROD, .f. } )
	
	TMPA5->( dbSkip() )
Enddo

oMSNewGe1:aCols := aColsA5

dbSelectArea("SA5")
Set Filter to

Return(.t.)

