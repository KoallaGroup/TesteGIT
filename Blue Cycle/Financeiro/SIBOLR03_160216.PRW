#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//------------------------------------------------------------------- 
/*/{Protheus.doc} SIBOLR03
Rotina de Seleção dos Titulos para impressão de Boletos.
       
@author	Ederson Colen
@since	03/12/2012
@version P11
@param	
@return	Nil

@obs	      
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       Programador     Motivo 
/*/ 
//------------------------------------------------------------------ 
User Function SIBOLR03()

Private cPerg    := "SIBOLR03"

Private cClientIn := Space(TamSx3("A1_COD")[1])
Private cClientFi := Space(TamSx3("A1_COD")[1])
Private cLojaInic := Space(TamSx3("A1_LOJA")[1])
Private cLojaFina := Space(TamSx3("A1_LOJA")[1])
Private cVendInic := Space(TamSx3("A3_COD")[1])
Private cVendFina := Space(TamSx3("A3_COD")[1])
Private cNotaInic := Space(TamSx3("F2_DOC")[1])
Private cNotaFina := Space(TamSx3("F2_DOC")[1])
Private cSerieIni := Space(TamSx3("F2_SERIE")[1])
Private cSerieFin := Space(TamSx3("F2_SERIE")[1])
Private cParcTiIn := Space(TamSx3("E1_PARCELA")[1])
Private cParcTiFi := Space(TamSx3("E1_PARCELA")[1])
Private dEmisInic := CToD(Space(08))
Private dEmisFina := CToD(Space(08))

//Funcao para criar/ajustar o grupo de perguntas da SX1
FSAjuSX1()

If Pergunte(cPerg,.T.)

   cClientIn := MV_PAR01
   cLojaInic := MV_PAR02
   cClientFi := MV_PAR03
   cLojaFina := MV_PAR04
   cVendInic := MV_PAR05
   cVendFina := MV_PAR06
   cNotaInic := MV_PAR07
   cNotaFina := MV_PAR08
   cSerieIni := MV_PAR09
   cSerieFin := MV_PAR10
   cParcTiIn := MV_PAR11
   cParcTiFi := MV_PAR12
   dEmisInic := MV_PAR13
   dEmisFina := MV_PAR14

   FGerArq()

   FTMakTit()

EndIf

If (Select("QSE1") <> 0)
   dbSelectArea("QSE1")
   dbCloseArea()
EndIf

Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FGerArq
Função para Geração do Arquivo de Consulta ao Banco de Dados.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FGerArq()

Local cQuery := ""
Local cGrpTipBo	:= AllTrim(SuperGetMv("SI_GRTIPBO",,"BOL#BO#DP#NF#"))

If Empty(AllTrim(cGrpTipBo))
   cGrpTipBo := AllTrim("BOL#BO#DP#NF#")
EndIf

cGrpTipBo := "'"+cGrpTipBo
cGrpTipBo := StrTran(cGrpTipBo,"#","','")
cGrpTipBo := StrTran(cGrpTipBo,"_","','")

If Right(AllTrim(cGrpTipBo),3) == "','"
	cGrpTipBo := Left(cGrpTipBo,Len(cGrpTipBo)-3)+"'"
EndIf

If Right(AllTrim(cGrpTipBo),1) <> "'"
	cGrpTipBo := cGrpTipBo+"'"
EndIf

If (Select("QSE1") <> 0)
   dbSelectArea("QSE1")
   dbCloseArea()
EndIf

cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SE1")+" E1 "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON(A1.D_E_L_E_T_ <> '*' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += " A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA) "
cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" A3 ON(A3.D_E_L_E_T_ <> '*' AND A3.A3_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += " A3.A3_COD = E1.E1_VEND1) "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1.E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += " AND E1.E1_PREFIXO BETWEEN '"+cSerieIni+"' AND '"+cSerieFin+"' "
cQuery += " AND E1.E1_NUM BETWEEN '"+cNotaInic+"' AND '"+cNotaFina+"' "
cQuery += " AND E1.E1_CLIENTE BETWEEN '"+cClientIn+"' AND '"+cClientFi+"' "
cQuery += " AND E1.E1_LOJA BETWEEN '"+cLojaInic+"' AND '"+cLojaFina+"' "
cQuery += " AND E1.E1_EMISSAO BETWEEN '"+DToS(dEmisInic)+"' AND '"+DToS(dEmisFina)+"' "
cQuery += " AND E1.E1_VEND1 BETWEEN '"+cVendInic+"' AND '"+cVendFina+"' "
cQuery += " AND E1.E1_TIPO NOT LIKE '%-%' "
cQuery += " AND E1.E1_SALDO > 0.00 "
cQuery += " AND E1.E1_TIPO IN("+cGrpTipBo+") "
TCQUERY cQuery ALIAS "QSE1" NEW

dbSelectArea("QSE1")
dbGoTop()

Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTMakTit
Função gera a Tela de Seleção dos Titulos para impressão dos Boletos

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FTMakTit()

Local oDlgMark
Local lInvLib  := .F.
Local cMarcAlt := GetMark()

// A MsGetDados e MsMGet necessitam que estes array e variaveis estejam declarados
Private lRefresh  := .T.
Private aTELA[0][0],aGETS[0]
Private aRotina := { { "", "", 0 , 1}, { "", "", 0 , 2}, { "", "", 0 , 3}, { "", "", 0 , 4}, { "", "", 0 , 5} }

Private oMarkAlt
Private lCanAllMark	:= .T.
Private lHasMark		:= .T.

Private cCodiBanc := Space(TamSx3("A6_COD")[1])
Private cCodiAgen := Space(TamSx3("A6_AGENCIA")[1])
Private cCodiCCor := Space(TamSx3("A6_NUMCON")[1])
Private cNossNume := Space(TamSx3("EE_NOSSNUM")[1])
Private cCarteira := Space(TamSx3("EE_NUNCART")[1])

Private lSaiTela := .F.

Private cArqTrbE1 := ""
Private aStruSE1  := {}
Private cIndeSE1  := Space(10)
Private aCampoSE1 := {}

Private oGrpMark, oGrpBanc

Private oBTn1
Private oBTn2

Private aTamTela := {060,060,480,705}
Private aTGrMark := {040,006,180,320}
Private aTGrBanc := {010,006,035,320}

Private aPosGBCO  := {017,010}
Private aPosGAGE  := {017,040}
Private aPosGCON  := {017,073}
Private aPosGCar  := {017,140}
Private aPosGNNu  := {017,170}

Private aTamLAB   := {185,005,205,100}
Private aPosChe   := {190,010,080,010}

Private aTamMBro  := {048,011,175,315}

Private aPosSVlr  := {190,120}

Private lDtVenc   := .F.

Private nTotaMark := 0.00
Private oTotaMark,oFntVlrt

// Monta o browse de Alteracoes
AADD(aCampoSE1,{"E1_OK"     ,,"OK"                           ,PesqPict("SE1","E1_OK"  )})
AADD(aCampoSE1,{"E1_PREFIXO",,AllTrim(RetTitle("E1_PREFIXO")),PesqPict("SE1","E1_PREFIXO")})
AADD(aCampoSE1,{"E1_NUM    ",,AllTrim(RetTitle("E1_NUM    ")),PesqPict("SE1","E1_NUM    ")})
AADD(aCampoSE1,{"E1_CLIENTE",,AllTrim(RetTitle("E1_CLIENTE")),PesqPict("SE1","E1_CLIENTE")})
AADD(aCampoSE1,{"E1_NOMCLI ",,AllTrim(RetTitle("E1_NOMCLI ")),PesqPict("SE1","E1_NOMCLI ")})
AADD(aCampoSE1,{"E1_VALOR  ",,AllTrim(RetTitle("E1_VALOR  ")),PesqPict("SE1","E1_VALOR  ")})
AADD(aCampoSE1,{"E1_VENCTO ",,AllTrim(RetTitle("E1_VENCTO ")),PesqPict("SE1","E1_VENCTO ")})
AADD(aCampoSE1,{"E1_EMISSAO",,AllTrim(RetTitle("E1_EMISSAO")),PesqPict("SE1","E1_EMISSAO")})
AADD(aCampoSE1,{"E1_VENCTO",,AllTrim(RetTitle("E1_VENCTO")),PesqPict("SE1","E1_VENCTO")})
AADD(aCampoSE1,{"E1_PARCELA",,AllTrim(RetTitle("E1_PARCELA")),PesqPict("SE1","E1_PARCELA")})
AADD(aCampoSE1,{"E1_TIPO   ",,AllTrim(RetTitle("E1_TIPO   ")),PesqPict("SE1","E1_TIPO   ")})
AADD(aCampoSE1,{"E1_LOJA   ",,AllTrim(RetTitle("E1_LOJA   ")),PesqPict("SE1","E1_LOJA   ")})
AADD(aCampoSE1,{"E1_PEDIDO ",,AllTrim(RetTitle("E1_PEDIDO ")),PesqPict("SE1","E1_PEDIDO ")})

FCrTrbE1(cMarcAlt)

While ! lSaiTela

   Define MSDialog oDlgMark Title OemToAnsi("Titulos para Impressao Boleto Bancario.") From aTamTela[01],aTamTela[02] TO aTamTela[03],aTamTela[04] Pixel
   Define FONT oFntVlrt NAME "Arial" Size 000,015 BOLD

   oGrpBanc := TGroup():New(aTGrBanc[01],aTGrBanc[02],aTGrBanc[03],aTGrBanc[04],OemToAnsi("Informe os Dados Banco\Agencia\Conta Corrente\Carteira."),,CLR_HBLUE,,.T.)
   @ aPosGBCO[01],aPosGBCO[02] MsGet cCodiBanc Valid ExistCpo("SA6",cCodiBanc) .And. FVldBanc() F3 "SA6"  Pixel
   @ aPosGAGE[01],aPosGAGE[02] MsGet cCodiAgen Valid ExistCpo("SA6",cCodiBanc+cCodiAgen) Pixel
   @ aPosGCON[01],aPosGCON[02] MsGet cCodiCCor Valid ExistCpo("SA6",cCodiBanc+cCodiAgen+cCodiCCor) .And. FVldCCor() Pixel
   @ aPosGCar[01],aPosGCar[02] MsGet cCarteira Picture "@!" Valid FVldCart() Pixel

   @ aPosGNNu[01],aPosGNNu[02] MsGet cNossNume Valid .T. When RefrDial() SIZE 110,10 Pixel

   oGrpMark := TGroup():New(aTGrMark[01],aTGrMark[02],aTGrMark[03],aTGrMark[04],OemToAnsi("Marque os Titulos que sera Impresso o Boleto Bancario."),,CLR_HBLUE,,.T.)
   oMarkAlt := MsSelect():New("TRE1","E1_OK",,aCampoSE1,lInvLib,cMarcAlt,aTamMBro)
   oMarkAlt:oBrowse:lCanAllMark := .T.
   oMarkAlt:oBrowse:lHasMark    := .T.
   oMarkAlt:bMark               := {|| FAltEsco(cMarcAlt,lInvLib,oDlgMark)}
   oMarkAlt:oBrowse:bAllMark    := {|| FAltMarkAll(cMarcAlt,oDlgMark)}

   @ aPosSVlr[01],aPosSVlr[02] SAY oTotaMark Var "Valor Total Marcado"+TransForm(nTotaMark,"@E 999,999,999.99") Of oDlgMark FONT oFntVlrt PIXEL COLOR CLR_HRED

   Define SButton oBTn1 From 195,240 Type 1 Action (Iif(FFTelaOk(),FImpBol() .And. oDlgMark:End(),NIL)) Enable Of oDlgMark
   Define SButton oBTn2 From 195,280 Type 2 Action (Iif(FCancel(),oDlgMark:End(),NIL)) Enable Of oDlgMark

   Activate MSDialog oDlgMark Centered

EndDo

If (Select("TRE1") <> 0)
   dbSelectArea("TRE1")
   dbCloseArea()
EndIf

// Remove arquivos temporarios
Ferase(cArqTrbE1+GetDBExtension())
Ferase(cArqTrbE1+OrdBagExt())

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldBanc
Função de Validação do Codigo Banco

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldBanc()

Local lRetVld := .T.

If Left(cCodiBanc,1) == "C"
   MsgBox("Favor informar o Codigo de um Banco. (FOI INFORMADO UM CAIXA)")
   lRetVld := .T.
EndIf

SysRefresh()

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldCCor
Função de Validação da Conta Banco

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldCCor()

Local lRetVld := .T.

dbSelectArea("SA6")
dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
If ! Eof()
	dbSelectArea("SEE")
	dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor)   //+SA6->A6_SEQBANC)
	If ! Eof()
		cCarteira := SEE->EE_NUNCART
	EndIf
EndIf

SysRefresh()

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldCart
Função de Validação da Carteira.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldCart()
                 
Local lRetVal	 := .T.
Local cSeqNNBan := ""

If Empty(cCarteira) 
   MsgBox("Carteira deve ser informada.")
   lRetVal := .F.
Else
   dbSelectArea("SA6")
   dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
   If ! Eof()
      cSeqNNBan := ""  //SA6->A6_SEQBANC
   EndIf

   dbSelectArea("SEE")
   dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
   If Eof() .Or. cCarteira <> SEE->EE_NUNCART
      Aviso("A T E N C A O","Carteira informada nao esta cadastrada.",{"OK"})
      lRetVal := .F.
   EndIf
EndIf

Return(lRetVal)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldCart
Função de Refresh da Tela de Re-Impressão.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function RefrDial()

Local cSeqNNBan := ""

dbSelectArea("SA6")
dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
If ! Eof()
   cSeqNNBan := ""  //SA6->A6_SEQBANC
EndIf

dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
   cNossNume := AllTrim(SEE->EE_NOSSNUM)
EndIf

SysRefresh()

Return(.F.)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FFTelaOk
Função de Validação de Tela OK.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FFTelaOk()

Local lRetVld := .T.

lSaiTela := .T.

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FCancel
Função de Cancelamento da Tela.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FCancel()

Local lRetVld := .T.

lSaiTela := .T.

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FAltEsco
Função de Alteração dos Titulos selecionado.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FAltEsco(cMarcAlt,lInvLib,oDlgMark)

Local lRetFunc := .T.

If IsMark("E1_OK",cMarcAlt,lInvLib)
  RecLock("TRE1",.F.)
  If ! lInvLib
     Replace TRE1->E1_OK With cMarcAlt
     nTotaMark += TRE1->E1_VALOR
  Else
     Replace TRE1->E1_OK With "  "
     nTotaMark -= TRE1->E1_VALOR
  Endif
  MsUnlock()
Else
  RecLock("TRE1",.F.)
  If ! lInvLib
     Replace TRE1->E1_OK With "  "
     nTotaMark -= TRE1->E1_VALOR
  Else
     Replace TRE1->E1_OK With cMarcAlt
     nTotaMark += TRE1->E1_VALOR
  Endif
  MsUnlock()
Endif
oDlgMark:Refresh()
oTotaMark:Refresh()

Return(lRetFunc)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FAltMarkAll
Função de Alteração de todos os Titulos selecionados.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FAltMarkAll(cMarcAlt,oDlgMark)

Local lRetFunc := .T.
Local nRecno   := 0

dbSelectArea("TRE1")
nRecno := Recno()
dbGotop()

Do While !Eof()
  RecLock("TRE1",.F.)
  If ! Marked("E1_OK")
     Replace TRE1->E1_OK With cMarcAlt
     nTotaMark += TRE1->E1_VALOR
  Else
     Replace TRE1->E1_OK With "  "
     nTotaMark -= TRE1->E1_VALOR
  Endif
  MsUnlock()
  dbSkip()
EndDo

dbSelectArea("TRE1")
dbGoto(nRecno)

oDlgMark:Refresh()
oTotaMark:Refresh()

Return(lRetFunc)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FCrTrbE1
Função de criação do Arquivo de Trabalho utilizado na Tela de Seleção.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FCrTrbE1(cMarcAlt)

dbSelectArea("SE1")
dbSetOrder(1)

aStruSE1  := SE1->(dbStruct())
cIndeSE1  := SE1->(IndexKey())
cArqTrbE1 := CriaTrab(aStruSE1,.T.)

dbUseArea(.T.,,cArqTrbE1,"TRE1",.F.,.F.)
IndRegua("TRE1",cArqTrbE1,cIndeSE1,,,"Selecionando registros...")

FGrvTrbE1(cMarcAlt)

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FGrvTrbE1
Função de gravação do Arquivo de Trabalho utilizado na Tela de Seleção.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FGrvTrbE1(cMarcAlt)

Local aArqSE1   := {"SE1",SE1->(IndexOrd()),SE1->(Recno())}

dbSelectArea("QSE1")
dbGoTop()

While ! Eof()

   dbSelectArea("TRE1")
   RecLock("TRE1",.T.)
   For nXi := 1 To Len(aStruSE1)
       If aStruSE1[nxI,2] == "D"
          TRE1->(FieldPut(nXi,SToD(QSE1->(FieldGet(FieldPos(aStruSE1[nXi][1]))))))
       Else
          TRE1->(FieldPut(nXi,QSE1->(FieldGet(FieldPos(aStruSE1[nXi][1])))))
       EndIf
   Next nXi
   MsUnLock()

   dbSelectArea("QSE1")
   dbSkip()

EndDo

dbSelectArea("TRE1")
dbGoTop()

//Retorna Ambiente
dbSelectArea(aArqSE1[1])
dbSetOrder(aArqSE1[2])
dbGoTo(aArqSE1[3])

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FImpBol
Função de impressão do Boleto.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FImpBol()

Local aArqSE1  := {"SE1",SE1->(IndexOrd()),SE1->(Recno())}

dbSelectArea("TRE1")
dbGotop()

While ! Eof()

   If ! Marked("E1_OK")
      dbSelectArea("TRE1")
      dbSkip()
      Loop
   EndIf
   
//   If Empty(TRE1->E1_NOSSNUM)
      FAtuaRece(TRE1->E1_CLIENTE,TRE1->E1_LOJA,TRE1->E1_PREFIXO,TRE1->E1_NUM,TRE1->E1_PARCELA,TRE1->E1_TIPO)
//   EndIf
   
   dbSelectArea("TRE1")
   dbSkip()

EndDo

U_SIBOLR01()

//Retorna Ambiente
dbSelectArea(aArqSE1[1])
dbSetOrder(aArqSE1[2])
dbGoTo(aArqSE1[3])

Return(.T.)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FImpBol
Função de atualização dos Titulos selecionados para impressão do boleto.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FAtuaRece(cCliente,cLojaCli,cPrefFat,cNumDupl,cNParcTi,cTipoTitu)

Local cSeqNNBan := ""

Local cBancAnt := cCodiBanc
Local cAgenAnt := cCodiAgen
Local cCCorAnt := cCodiCCor

Private lGravaPar := .F.
Private aArraRegi := {}
Private nLenNos   := 0
Private cNossAuxi := ""
Private cCarNossn := ""

dbSelectArea("SE1")
dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
dbSeek(xFilial("SE1")+cCliente+cLojaCli+cPrefFat+cNumDupl+cNParcTi+cTipoTitu)

If ! Eof() //.And. Empty(SE1->NOSSNUM)

   dbSelectArea("SA1")
   dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
   If ! Eof() .And. ! Empty(SA1->A1_BCOBOL)
//		cCodiBanc := SA1->A1_BCOBOL
//		cCodiAgen := SA1->A1_AGENBOL
//		cCodiCCor := SA1->A1_CONTBOL
   EndIf

   cDigito   := ""

   dbSelectArea("SA6")
   dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
   If ! Eof()
      cSeqNNBan := ""  //SA6->A6_SEQBANC
   EndIf

	dbSelectArea("SEE")
	If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
	   Do Case 
	   	Case cCodiBanc == "001"
/*
				Do Case
					Case SE1->E1_TIPO == "NF "
						cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					Case SE1->E1_TIPO == "DP "
						cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					OtherWise
						cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
				EndCase
*/
				Do Case
					Case SE1->E1_TIPO == "NF "
						cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,3,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					Case SE1->E1_TIPO == "DP "
						cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,3,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					OtherWise
						cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,3,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
				EndCase

				cDigito := ""

         Case cCodiBanc == '341'

				cParcela := AllTrim(SE1->E1_PARCELA)
				If Val(cParcela) > 0
					cParcela := StrZero(Val(cParcela),2)
				Else
					If Empty(cParcela)
						cParcela := "01"
					Else
						If Len(AllTrim(cParcela)) >= 2

						Else
							cParcela := ASC(Upper(SE1->E1_PARCELA)) - 64
							cParcela := IIF(cParcela >= 0,cParcela,0)
						EndIf
					EndIf
				EndIf
				cNossNume := Right(AllTrim(SE1->E1_NUM),6)+cParcela
				cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarNossn)

         Case cCodiBanc == '033'

  				cNossNume := "0"+StrZero(Val(SE1->E1_NUM),9)+StrZero(Val(SE1->E1_PARCELA),3)
				cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarNossn)

         OtherWise

			   cNossNume := AllTrim(SEE->EE_NOSSNUM)
				cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarNossn)

      EndCase

      cCarNossn := AllTrim(SEE->EE_NUNCART)

   Else
      Aviso("A T E N C A O","Não foi possível atualizar os Dados do Título. Favor Informar ao Administrador do Sistema.",{"OK"})
      Return Nil
	EndIf

	RecLock("SE1",.F.)
	SE1->E1_PORTADO	:=	cCodiBanc
	SE1->E1_BCOCLI 	:=	cCodiBanc
	SE1->E1_AGEDEP	:=	cCodiAgen
	SE1->E1_CONTA	:=	cCodiCCor
	SE1->E1_NUMBCO	:=	cNossNume+cDigito
	SE1->E1_NOSSNUM :=	cNossNume+cDigito
//	SE1->E1_NUNCART	:=	cCarteira
//	SE1->E1_NUMBCO 	:=	cNossNume+cDigito   //E1_NOSSNUM
   MsUnlock()

   If ! cCodiBanc $ "001_341_033_"
      nLenNos   := Len(Alltrim(cNossNume))
      cNossAuxi := Soma1(cNossNume,nLenNos)
		dbSelectArea("SEE")
		dbSetOrder(1)
		If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
  	   	 RecLock("SEE",.F.)
  		    SEE->EE_NOSSNUM := cNossAuxi
	  	    MsUnlock()
		EndIf
	EndIf

EndIf

cCodiBanc := cBancAnt
cCodiAgen := cAgenAnt
cCodiCCor := cCCorAnt

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FSAjuSX1
Ajusta as Perguntas utilizadas no programa princial.

@author	  Ederson Colen
@since	  16/05/2012
@version   P11.5
@obs	     Referente ao Projeto FS006443
@param     cPerg      - Nome do Grupo de Perguntas

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------                          
Static Function FSAjuSX1()

Local aPergs   := {}
Local aPergAux := {}
Local aHelpPor := {}
Local nXX      := 0

// 1 - Texto Pergunta
// 2 - Tipo Campo (C,N,D,etc)
// 3 - Tamanho Campo
// 4 - Tamanho Decimal
// 5 - Tipo Get (G) ou (C) Choice
// 6 - F3
// 7 - Validação Campo
// 8 a 12 Opções.
// 13 - Texto do Help Tamanho Linha                                       '1234567890123456789012345678901234567890' )
//             1                     2   3 4 5   6     7  8  9  10 11 12  13
Aadd(aPergAux,{"Cliente Inicial    ?",TamSx3("A1_COD")[3],TamSx3("A1_COD")[1],TamSx3("A1_COD")[2]      ,"G","SA1","","","","","","","Informe o Cod.Cliente Inicial"})
Aadd(aPergAux,{"Loja Inicial       ?",TamSx3("A1_LOJA")[3],TamSx3("A1_LOJA")[1],TamSx3("A1_LOJA")[2]   ,"G","","","","","","","","Informe o Cod.Loja Inicial"})
Aadd(aPergAux,{"Cliente Final      ?",TamSx3("A1_COD")[3],TamSx3("A1_COD")[1],TamSx3("A1_COD")[2]      ,"G","SA1","","","","","","","Informe o Cod.Cliente Final"})
Aadd(aPergAux,{"Loja Final         ?",TamSx3("A1_LOJA")[3],TamSx3("A1_LOJA")[1],TamSx3("A1_LOJA")[2]   ,"G","","","","","","","","Informe o Cod.Loja Final"})
Aadd(aPergAux,{"Vendedor Inicial   ?",TamSx3("A3_COD")[3],TamSx3("A3_COD")[1],TamSx3("A3_COD")[2]      ,"G","SA3","","","","","","","Informe o Cod.Vendedor Inicial"})
Aadd(aPergAux,{"Vendedor Final     ?",TamSx3("A3_COD")[3],TamSx3("A3_COD")[1],TamSx3("A3_COD")[2]      ,"G","SA3","","","","","","","Informe o Cod.Vendedor Final"})
Aadd(aPergAux,{"Nota Fiscal Inicial?",TamSx3("F2_DOC")[3],TamSx3("F2_DOC")[1],TamSx3("F2_DOC")[2]      ,"G",""   ,"","","","","","","Informe a Nota Fiscal Incial"})
Aadd(aPergAux,{"Nota Fiscal Final  ?",TamSx3("F2_DOC")[3],TamSx3("F2_DOC")[1],TamSx3("F2_DOC")[2]      ,"G",""   ,"","","","","","","Informe a Nota Fiscal Final"})
Aadd(aPergAux,{"Serie NF Inicial   ?",TamSx3("F2_DOC")[3],TamSx3("F2_DOC")[1],TamSx3("F2_DOC")[2]      ,"G",""   ,"","","","","","","Informe a Nota Fiscal Incial"})
Aadd(aPergAux,{"Serie NF Final     ?",TamSx3("F2_SERIE")[3],TamSx3("F2_SERIE")[1],TamSx3("F2_SERIE")[2],"G",""   ,"","","","","","","Informe a Nota Fiscal Final"})
Aadd(aPergAux,{"Parcela Tit.Inicial?",TamSx3("E1_PARCELA")[3],TamSx3("E1_PARCELA")[1],TamSx3("E1_PARCELA")[2],"G",""   ,"","","","","","","Informe a Parcela Inicial"})
Aadd(aPergAux,{"Parcela Tit.Final  ?",TamSx3("E1_PARCELA")[3],TamSx3("E1_PARCELA")[1],TamSx3("E1_PARCELA")[2],"G",""   ,"","","","","","","Informe a Parcela Final"})
Aadd(aPergAux,{"Dt Emissao Inicial ?",TamSx3("F2_EMISSAO")[3],TamSx3("F2_EMISSAO")[1],TamSx3("F2_EMISSAO")[2],"G",""   ,"","","","","","","Informe a Dt Emissao Inicial"})
Aadd(aPergAux,{"Dt Emissao Final   ?",TamSx3("F2_EMISSAO")[3],TamSx3("F2_EMISSAO")[1],TamSx3("F2_EMISSAO")[2],"G",""   ,"","","","","","","Informe a Dt Emissao Final"})

//Alimenta os arreys de Pergunta e Help.
For nXT := 1 To Len(aPergAux)
	 Aadd(aPergs,{aPergAux[nXT,01],aPergAux[nXT,01],aPergAux[nXT,01],"mv_ch"+AllTrim(Str(nXT)),;
					aPergAux[nXT,02],aPergAux[nXT,03],aPergAux[nXT,04],0,aPergAux[nXT,05],;
					aPergAux[nXT,07],"MV_PAR"+StrZero(nXT,2),;
					aPergAux[nXT,08],aPergAux[nXT,08],aPergAux[nXT,08],"","",;
					aPergAux[nXT,09],aPergAux[nXT,09],aPergAux[nXT,09],"","",;
					aPergAux[nXT,10],aPergAux[nXT,10],aPergAux[nXT,10],"","",;
					aPergAux[nXT,11],aPergAux[nXT,11],aPergAux[nXT,11],"","",;
					aPergAux[nXT,12],aPergAux[nXT,12],aPergAux[nXT,12],"",aPergAux[nXT,06],"","",""})
	 Aadd(aHelpPor,{aPergAux[nXT,13]})
Next nXT

//Cria perguntas (padrao)
AjustaSx1(cPerg,aPergs)

//Help das perguntas
For nXX := 1 To Len(aHelpPor)
    PutSX1Help("P."+cPerg+StrZero(nXX,2),aHelpPor[nXX],aHelpPor[nXX],aHelpPor[nXX])
Next nXX

Return Nil