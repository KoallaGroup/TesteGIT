#Include "PROTHEUS.CH"

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMC04 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Cadastro das marcas do produto                               |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMC04()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SB1->B1_COD
Local oGet2
Local cGet2 := SB1->B1_DESC
Local oSay1
Local oSay2
Static oDlg

DEFINE MSDIALOG oDlg TITLE "Marcas po Produto" FROM 000, 000  TO 500, 620 COLORS 0, 16777215 PIXEL

@ 009, 033 MSGET 	oGet1 			VAR cGet1 	when .f.	SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 010, 003 SAY 		oSay1 PROMPT 	"Produto" 				SIZE 024, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 029, 032 MSGET 	oGet2 			VAR cGet2 	when .f. 	SIZE 235, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 031, 003 SAY		oSay2 PROMPT	"Descrição" 			SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL

fMSNewGe1()

@ 231, 196 BUTTON oButton1 PROMPT "Gravar"    Action {|| GrvMarca(), oDlg:End() }		SIZE 037, 012 OF oDlg PIXEL
@ 231, 264 BUTTON oButton2 PROMPT "Cancelar"  Action {|| oDlg:End() }					SIZE 037, 012 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

//Se usuario mandou gravar, atualizar tabela customizada

Return

//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------

Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"Z16_MARCA","Z5_DESC","B1_CARGAE","B1_QE"}
Local _aTitulo 		:= {"Marca","Descrição","Padrão","RECNO_WT"}
Local _aCampos 		:= {"MARCA","DESC","MPAD","RECNOZ"}
Local aAlterFields 	:= {"MARCA","DESC","MPAD"}
Local cDesc			:= ""
Local cPad			:= ""

Static oMSNewGe1

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))

For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEx, {_aTitulo[nx],_aCampos[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
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

oMSNewGe1 := MsNewGetDados():New( 049,003,223,300,GD_INSERT+GD_DELETE+GD_UPDATE,"AllwaysTrue","AllwaysTrue","",aAlterFields,,999,"U_VldCmp()","","AllwaysTrue",oDlg,aHeaderEx,aColsEx)

//Verificar se ja existe cadastro na tabela customizada
//Se existir, preencher acols

Posicione("Z16",1,xFilial("Z16") + SB1->B1_COD,"Z16_PROD")

if Z16->( !EoF() )
	aColsEx := {}
	Do While Z16->( !EoF() ) .and. Z16->Z16_PROD = SB1->B1_COD
		cDesc 	:= Posicione("SZ5",1,xFilial("SZ5") + Z16->Z16_MARCA,"Z5_DESC")
		cPad	:= Posicione("SB1",1,xFilial("SB1") + Z16->Z16_PROD,"B1__MARCA")
		If Alltrim(Z16->Z16_MARCA) == Alltrim(cPad)
			cPad := "1"	//SIM
		Else
			cPad := "2"	//NAO
		EndIf
		aAdd(aColsEx, {Z16->Z16_MARCA,cDesc, cPad, Z16->(Recno()),  .f.} )
		Z16->( dbSkip() )
	Enddo
Endif

oMsNewGe1:aCols := aColsEx

Return


/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | GrvMarca| Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Grava tabela Z16                                             |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

Static Function GrvMarca()

Local cPadrao := .T.

For i := 1 to Len(oMsNewGe1:aCols)
	
	if !Empty(oMsNewGe1:aCols[i,1]) .and. !Empty(oMsNewGe1:aCols[i,2])
		
		Posicione("Z16",1,xFilial("Z16") + SB1->B1_COD + oMsNewGe1:aCols[i,1]  , "Z16_PROD")
		
		if oMsNewGe1:aCols[i,4] == 0
			if !oMsNewGe1:aCols[i,5]
				Posicione("Z16",1,xFilial("Z16")+SB1->B1_COD,"Z16_PROD")
				Reclock("Z16",.t.)
				Z16->Z16_PROD	:= SB1->B1_COD
				Z16->Z16_MARCA	:= oMsNewGe1:aCols[i,1]
			Endif
		Elseif oMsNewGe1:aCols[i,4] > 0
			if !oMsNewGe1:aCols[i,5]
				Z16->( dbGoTo(oMsNewGe1:aCols[i,4]) )
				Reclock("Z16",.f.)
				Z16->Z16_PROD	:= SB1->B1_COD
				Z16->Z16_MARCA	:= oMsNewGe1:aCols[i,1]
			Else
				Z16->( dbGoTo(oMsNewGe1:aCols[i,4]) )
				Reclock("Z16",.f.)
				Z16->( dbDelete() )
			Endif
		Endif
		
		If cPadrao
			If !oMsNewGe1:aCols[i,5]
				If oMsNewGe1:aCols[i,3] == "1"
					Reclock("SB1",.f.)
					SB1->B1__MARCA	:= oMsNewGe1:aCols[i,1]
					SB1->( msUnlock() )
					cPadrao := .F.
				EndIf
			EndIf
		EndIf
		
		Z16->( msUnlock() )
		
	Endif
	
Next i

Return(.f.)

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | VldCmp  | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Valida marca e preenche descrição                            |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function VldCmp()

Local lRet := .T.

If Empty(oMsNewGe1:aCols[n,1])
	dbSelectArea("SZ5")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ5")+M->MARCA)
		oMsNewGe1:aCols[n,2] := SZ5->Z5_DESC
	Else
		Alert("Marca não existe !!!")
		lRet := .F.
	EndIf
EndIf

Return lRet
