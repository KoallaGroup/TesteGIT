#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICOMC05   ºAutor  ³Alexandre Caetano   º Data ³ 01/Nov/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Padrão Especifíca                                 º±±
±±º          ³ Fornecedores por Grupo de cotação                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ICOMC05()
Local oSayCodGrp 
Local oOK
Local oRet, _cLoja := cA120Loj
Local aArea := GetArea()     

Private oDlg1                                   	
Private cCodGrp 	:= Space( LEN( ZX5->ZX5_CODIGO ) ) 
Private cDesGrp 	 
Private oGetCodGrp     
Private aHeader1 	:= {}
Private aCols1		:= {}
Private lOk			:= .f.
Private cRetGrp		:= cA120Forn

DEFINE MSDIALOG oDlg1 TITLE "Consulta Fornecedores por Grupo de Cotação - Seleção do Grupo" FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL
                                                                                                       
   	@ 003, 008 SAY 		oSayCodGrp 	    PROMPT "Grupo de Cotação :"									              	     				SIZE 050, 007 	OF oDlg1 COLORS 0, 16777215 PIXEL
   	@ 003, 060 MSGET 	oGetCodGrp 		VAR cCodGrp 	When .t.	Picture	avSX3("ZX5_CODIGO",6)	Valid U_GetDesGrp() F3 "ISPFOR"		SIZE 040, 008 	OF oDlg1 COLORS 0, 16777215 PIXEL
 	@ 003, 102 	MSGET 	oGetDesGrp 		VAR cDesGrp		When .f. 										                    			SIZE 100, 008 	OF oDlg1 COLORS 0, 16777215 PIXEL
    
    @ 030, 118 BUTTON oOK 		PROMPT "Confirmar" Action {|| U_SHOWFORN(),oDlg1:end()}			SIZE 040, 020 OF oDlg1 PIXEL
    @ 030, 160 BUTTON oRet 		PROMPT "Retornar"  Action {|| oDlg1:end()} 					  	SIZE 040, 020 OF oDlg1 PIXEL
    
ACTIVATE MSDIALOG oDlg1 CENTERED

if !lOK 
    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2") + cA120Forn + cA120Loj)
	cRetGrp  := cA120Forn
	cA120Loj := SA2->A2_LOJA
	
Else
    cA120Loj := Space(TamSX3("A2_LOJA")[1])
Endif          

RestArea(aArea)

Return(cRetGrp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDesGrp ºAutor  ³Alexandre Caetano   º Data ³  01/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca descrição do Grupo na tabela ZX5->X5_GRUPO = '000001' º±±
±±º          ³                                 	                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EXCLUSIVO ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetDesGrp()                                     

Local cQry := ""


If Select("TMPZX5") > 0
	dbSelectArea("TMPZX5")
	DbCloseArea()
EndIf                

cQry := " SELECT ZX5_DSCGRP                                "    
cQry += " FROM " + RetSQLName("ZX5") + " ZX5               "
cQry += " WHERE ZX5.D_E_L_E_T_  = ' ' AND                  "
cQry += "       ZX5.ZX5_GRUPO   = '000001 '                "
cQry += " AND   ZX5.ZX5_FILIAL  = '" + xFilial("ZX5") + "' "
cQry += " AND   ZX5.ZX5_CODIGO  = '" + cCodGrp + "'        " 

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPZX5",.T.,.F. )

if TMPZX5->(!EoF())
	cDesGrp := 	TMPZX5->ZX5_DSCGRP
	oGetCodGrp:Refresh()
	oDlg1:Refresh()
Else 
	msgAlert("Grupo de cotação não localizado. " + Chr(13) +;
	         "     Digite um valor válido.     ", "Atenção !!!") 
Endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SHOWFORN ºAutor  ³Alexandre Caetano   º Data ³  01/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Getdados para visualização dos fornecedores            º±±
±±º          ³pertencentes ao grupo selecionado                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SHOWFORN()      
Local cQry       
Local oOK
Local oRet       
Private oMSNewGe1
Private oDlg2

If Select("TMPZ02") > 0
	dbSelectArea("TMPZ02")
	DbCloseArea()
EndIf                 


cQry := " SELECT DISTINCT Z02_CODFOR,  A2_NOME, A2_NREDUZ "
cQry += " FROM " + RetSQLName("Z02") + " Z02                      "
cQry += " JOIN SA2010 SA2 ON A2_COD = Z02_CODFOR  And SA2.D_E_L_E_T_ = ' '  "
cQry += " WHERE Z02_GRUPO  = '" + cCodGrp        + "'             "
cQry += " AND   Z02_FILIAL = '" + xFilial("Z02") + "' And Z02.D_E_L_E_T_ = ' '            "        

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPZ02",.T.,.F. )

DEFINE MSDIALOG oDlg2 TITLE "Consulta Fornecedores por Grupo de Cotação - Seleção do Fornecedor" FROM 000, 000  TO 400, 1300 COLORS 0, 16777215 PIXEL
    
	//Instancia msNewGetDados
	fMSNewGe1()
	
    @ 180, 568 BUTTON oOK 		PROMPT "Confirmar" Action {|| lOk := .t., oDlg2:end()}			SIZE 040, 020 OF oDlg2 PIXEL
    @ 180, 610 BUTTON oRet 		PROMPT "Retornar"  Action {|| oDlg2:end()} 						SIZE 040, 020 OF oDlg2 PIXEL
    
ACTIVATE MSDIALOG oDlg2 CENTERED 

//cRetGrp := {omsnewge1:acols[omsnewge1:nat,1],omsnewge1:acols[omsnewge1:nat,2]}
//cRetGrp := omsnewge1:acols[omsnewge1:nat,1]

ca120Forn	:= oMSNewGe1:aCols[oMSNewGe1:nat,1]

Return(cRetGrp)

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"A2_COD", "A2_NOME", "A2_NREDUZ"}
Local aAlterFields 	:= {}

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeader1, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif             
  Next nX

  // Define field values
  For nX := 1 to Len(aHeader1)
    If DbSeek(aHeader1[nX,2])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aCols1, aFieldFill)

  oMSNewGe1 := MsNewGetDados():New( 005, 005, 176, 650, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg2, aHeader1, aCols1)
  
  // Gera Dados para msNewGetDados
  aCols1 := {}
  TMPZ02->( dbGoTop() )
  Do While TMPZ02->( !EoF() ) 
  	aAdd( aCols1, {TMPZ02->Z02_CODFOR, TMPZ02->A2_NOME, TMPZ02->A2_NREDUZ, .f.} )
	TMPZ02->( dbSkip() ) 
  Enddo                                          	
  oMSNewGe1:aCols := aCols1
  oMSNewGe1:Refresh()
//------------------------------ 

Return(.t.)