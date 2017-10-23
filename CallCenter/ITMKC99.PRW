#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -                                               
@since 08/09/2014                                                   
/*/                                                             
//--------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  09/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ITMKC02()
Local oArmGer
Local cArmGer := ""
Local oArmVit
Local cArmVit := ""
Local oConsDtEnt
Local oCrossDock
Local cCrossDock := ""
Local oDescCompl
Local oDescGrp
Local cDescGrp := ""
Local oDescMarca
Local cDescMarca := ""
Local oDescSGrp
Local cDescSGrp := ""
Local oDolar
Local cDolar := ""
Local oDtPer1Fin
Local cDtPer1Fin := ""
Local oDtPer1ini
Local cDtPer1ini := ""
Local oDtPer2Fin
Local cDtPer2Fin := ""
Local oDtPer2ini
Local cDtPer2ini := ""
Local oEmpr
Local cEmpr := ""
Local oEmprDesc
Local cEmprDesc := ""
Local oEntTransf
Local cEntTransf := ""
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
Local oGroup6
Local oGroup7
Local oGroup8
Local oGrupo
Local cGrupo := ""
Local oMarca
Local cMarca := ""
Local oMBaseCons
Local cMBaseCons := ""
Local oPrecoVist
Local cPrecoVist := ""
Local oPrecVSP
Local cPrecVSP := ""
Local oPrevEntr
Local cPrevEntr := ""
Local oProced
Local cProced := ""
Local oProd
Local cProd := ""
Local oProdDesc
Local cProdDesc := ""
Local oQtdPreVnd
Local cQtdPreVnd := ""
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay2
Local oSay23
Local oSay24
Local oSay25
Local oSay26
Local oSay27
Local oSay28
Local oSay29
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSldPreVnd
Local cSldPreVnd := ""
Local oSubGrupo
Local cSubGrupo := ""
Local oTotDisp
Local cTotDisp := ""
Local oTotEntPro
Local cTotEntPro := ""
Local oTotEstRea
Local cTotEstRea := ""
Local oTotReserv
Local cTotReserv := ""
Local oTotSaiPro
Local cTotSaiPro := ""
Local oTotValEst
Local cTotValEst := ""
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

    @ 000, 003 GROUP oGroup1 TO 081, 493 PROMPT "Sele็ใo" OF oDlg COLOR 0, 16777215 PIXEL
    @ 008, 225 GROUP oGroup2 TO 033, 355 PROMPT "Sele็ใo 1" OF oDlg COLOR 0, 16777215 PIXEL
    @ 008, 357 GROUP oGroup3 TO 033, 487 PROMPT "Sele็ใo 2" OF oDlg COLOR 0, 16777215 PIXEL
    @ 008, 080 MSGET oDtPer2Fin VAR cDtPer2Fin When .f. SIZE 045, 010 OF oGroup3 COLORS 0, 16777215 PIXEL
    @ 009, 020 MSGET oDtPer2ini VAR cDtPer2ini When .f. SIZE 045, 010 OF oGroup3 COLORS 0, 16777215 PIXEL
    @ 010, 067 SAY oSay5 PROMPT "At้" SIZE 012, 007 OF oGroup3 COLORS 0, 16777215 PIXEL
    @ 010, 022 MSGET oEmpr VAR cEmpr When .f. SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 010, 041 MSGET oEmprDesc VAR cEmprDesc When .f. SIZE 182, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 012, 008 SAY oSay1 PROMPT "Empr." SIZE 014, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 244 MSGET oDtPer1ini VAR cDtPer1ini When .f. SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 307 MSGET oDtPer1Fin VAR cDtPer1Fin When .f. SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 018, 227 SAY oSay2 PROMPT "Data" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 018, 362 SAY oSay4 PROMPT "Data" SIZE 013, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 019, 293 SAY oSay3 PROMPT "At้" SIZE 012, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 021, 055 MSGET oProdDesc VAR cProdDesc When .f. SIZE 168, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 022, 022 MSGET oProd VAR cProd  Valid {||U_ConsProd()}SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 023, 009 SAY oSay6 PROMPT "Item" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 032, 005 SAY oSay7 PROMPT "Descr." SIZE 017, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 252 MSGET oGrupo VAR cGrupo When .f. SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 274 MSGET oDescGrp VAR cDescGrp When .f. SIZE 213, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 035, 234 SAY oSay8 PROMPT "Grupo" SIZE 017, 007 OF oDlg COLORS 0, 16777215 PIXEL
  
	@ 044, 252 MSGET oSubGrupo VAR cSubGrupo When .f. SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 044, 274 MSGET oDescSGrp VAR cDescSGrp When .f. SIZE 213, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 225 SAY oSay9 PROMPT "Sub Grupo" SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 248 MSGET oMarca VAR cMarca When .f. SIZE 022, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 053, 270 MSGET oDescMarca VAR cDescMarca When .f. SIZE 213, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 056, 233 SAY oSay10 PROMPT "Marca" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 067, 060 MSGET oMBaseCons VAR cMBaseCons  When .f. SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 067, 200 MSGET oProced VAR cProced When .f. SIZE 021, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 006 SAY oSay11 PROMPT "Meses Base Consumo" SIZE 055, 006 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 165 SAY oSay12 PROMPT "Proced๊ncia" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 081, 004 GROUP oGroup4 TO 194, 493 PROMPT "Estoque" OF oDlg COLOR 0, 16777215 PIXEL
    @ 150, 027 MSGET oTotEstRea VAR cTotEstRea When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 122 MSGET oTotValEst VAR cTotValEst When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 173 MSGET oTotReserv VAR cTotReserv When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 221 MSGET oTotEntPro VAR cTotEntPro When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 270 MSGET oTotSaiPro VAR cTotSaiPro When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 320 MSGET oTotDisp VAR cTotDisp When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 152, 006 SAY oSay23 PROMPT "Totais" SIZE 017, 007 OF oDlg COLORS 0, 16777215 PIXEL
 	@ 161, 051 MSGET oPrecoVist VAR cPrecoVist When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 161, 141 MSGET oArmVit VAR cArmVit When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 161, 242 GROUP oGroup5 TO 181, 367 PROMPT "Previsใo de Entrega" OF oDlg COLOR 0, 16777215 PIXEL
    @ 161, 368 GROUP oGroup6 TO 181, 493 PROMPT "Pr้ Venda" OF oDlg COLOR 0, 16777215 PIXEL    
    @ 162, 006 SAY oSay24 PROMPT "Pre็o a Vista" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 163, 099 SAY oSay27 PROMPT "Armaz้m Vit๓ria" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 172, 050 MSGET oPrecVSP VAR cPrecVSP When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 172, 141 MSGET oArmGer VAR cArmGer When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 173, 006 SAY oSay25 PROMPT "Pre็o a Vista SP" SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 174, 099 SAY oSay28 PROMPT "Armaz้m Geral" SIZE 039, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 182, 141 MSGET oEntTransf VAR cEntTransf When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 183, 050 MSGET oDolar VAR cDolar When .f. SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 184, 006 SAY oSay26 PROMPT "Pre็o D๓lar" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 184, 097 SAY oSay29 PROMPT "Qtde. Ent. Transf." SIZE 044, 008 OF oDlg COLORS 0, 16777215 PIXEL
    fMSNewGe1()    
    @ 169, 245 SAY oSay13 PROMPT "Qtde." SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 167, 260 MSGET oPrevEntr VAR cPrevEntr When .f. SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 167, 323 BUTTON oConsDtEnt PROMPT "Consultar" SIZE 040, 010 OF oDlg PIXEL
    @ 170, 372 SAY oSay14 PROMPT "Qtde." SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 168, 389 MSGET oQtdPreVnd VAR cQtdPreVnd SIZE 041, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 169, 431 SAY oSay15 PROMPT "Saldo" SIZE 016, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 167, 448 MSGET oSldPreVnd VAR cSldPreVnd SIZE 041, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 184, 247 SAY oSay16 PROMPT "Cross Dock" SIZE 031, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 182, 280 MSGET oCrossDock VAR cCrossDock When .f. SIZE 084, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 194, 004 GROUP oGroup7 TO 248, 248 PROMPT "Perํodo 1" OF oDlg COLOR 0, 16777215 PIXEL
    @ 194, 250 GROUP oGroup8 TO 248, 494 PROMPT "Perํodo 2" OF oDlg COLOR 0, 16777215 PIXEL
    fMSNewGe2()
    fMSNewGe3()
    @ 033, 022 SCROLLBOX oDescCompl HORIZONTAL VERTICAL SIZE 034, 201 OF oDlg BORDER

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {}
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

  oMSNewGe1 := MsNewGetDados():New( 087, 006, 150, 491, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return

//------------------------------------------------ 
Static Function fMSNewGe2()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {}
Local aAlterFields := {}
Static oMSNewGe2

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

  oMSNewGe2 := MsNewGetDados():New( 201, 006, 246, 246, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return

//------------------------------------------------ 
Static Function fMSNewGe3()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {}
Local aAlterFields := {}
Static oMSNewGe3

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

  oMSNewGe3 := MsNewGetDados():New( 201, 252, 246, 492, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsProd  บAutor  ณAlexandre Caetano   บ Data ณ  08/Set/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche dados da consulta conforme produto solicitado      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณExclusivo ISAPA                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConsProd()


Return(.t.)