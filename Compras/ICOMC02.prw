#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICOMC02   ºAutor  ³Microsiga           º Data ³  09/Out/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ICOMC02()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SB1->B1_COD
Local oGet2
Local cGet2 := SB1->B1_DESC
Local oSay1
Local oSay2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Produto x Codigo de Barras" FROM 000, 000  TO 500, 550 COLORS 0, 16777215 PIXEL
    
	@ 009, 033 MSGET 	oGet1 			VAR cGet1 	when .f.	SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 010, 003 SAY 		oSay1 PROMPT 	"Produto" 				SIZE 024, 007 OF oDlg COLORS 0, 16777215 PIXEL   
    @ 029, 032 MSGET 	oGet2 			VAR cGet2 	when .f. 	SIZE 235, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 031, 003 SAY		oSay2 PROMPT	"Descricao" 			SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
    fMSNewGe1()
    
    @ 231, 126 BUTTON oButton1 PROMPT "Gravar"    Action {|| U_GrvCodBar(), oDlg:End() }		SIZE 037, 012 OF oDlg PIXEL
    @ 231, 214 BUTTON oButton2 PROMPT "Cancelar"  Action {|| oDlg:End() }						SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

  //Se usuario mandou gravar, atualizar tabela customizada

Return

//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"B1_CODBAR","B1_UM","B1_QE"}
Local _aTitulo := {"Cod. Barras","UM","RECNO_WT"}
Local _aCampos := {"CODBAR","UNMED","RECNOZ"}
Local aAlterFields := {"CODBAR","UNMED"}
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

oMSNewGe1 := MsNewGetDados():New( 049, 003, 223, 269, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

//Verificar se ja existe cadastro na tabela customizada
//Se existir, preencher acols                          
Posicione("Z14",1,xFilial("Z14")+SB1->B1_COD,"Z14_CODPRO")
if Z14->( !EoF() )
	aColsEx := {}
	Do While Z14->( !EoF() ) .and.;
		     Z14->Z14_CODPRO = SB1->B1_COD
	                                                                 //Deleted
		aAdd(aColsEx, {Z14->Z14_CODBAR, Z14->Z14_UM, Z14->(Recno()),  .f.} ) 	
		Z14->( dbSkip() ) 
	Enddo        
Endif
//-----------------------------------------------------

oMsNewGe1:aCols := aColsEx

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvCodBar ºAutor  ³Alexandre Caetano   º Data ³  09/Out/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ºDesc.     ³ Faz a manutenção do Arquivo Z14                              º±±
±±º        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GrvCodBar()

For i := 1 to Len(oMsNewGe1:aCols)

	if !Empty(oMsNewGe1:aCols[i,1]) .and.;
	   !Empty(oMsNewGe1:aCols[i,2])
	   
	    Posicione("Z14",1,xFilial("Z14") + SB1->B1_COD + oMsNewGe1:aCols[i,1]  , "Z14_CODBAR")   		 
	   		
	
		if oMsNewGe1:aCols[i,3] == 0
			if !oMsNewGe1:aCols[i,4]  // not Deleted   
				Posicione("Z14",1,xFilial("Z14")+SB1->B1_COD+oMsNewGe1:aCols[i,1],"Z14_CODPRO")			
				if Z14->(EoF())
					Reclock("Z14",.t.)   
					Z14->Z14_CODPRO	:= SB1->B1_COD
					Z14->Z14_CODBAR	:= oMsNewGe1:aCols[i,1]
					Z14->Z14_UM    	:= oMsNewGe1:aCols[i,2]		
				Endif				
			Endif
		Elseif oMsNewGe1:aCols[i,3] > 0           
			if !oMsNewGe1:aCols[i,4] // not Deleted
				Z14->( dbGoTo(oMsNewGe1:aCols[i,3]) )
				Reclock("Z14",.f.) 	
				Z14->Z14_CODPRO	:= SB1->B1_COD
				Z14->Z14_CODBAR	:= oMsNewGe1:aCols[i,1]
				Z14->Z14_UM    	:= oMsNewGe1:aCols[i,2]
			Else
				Z14->( dbGoTo(oMsNewGe1:aCols[i,3]) )
				Reclock("Z14",.f.)
				Z14->( dbDelete() )
			Endif
		Endif
		
		            	
		Z14->( msUnlock() )		

	Endif                  
	
Next i


Return(.f.)