#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+------------------------------------------+-------+--------------+
| Programa:  | ICOMP05 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+---------+--------+------------------------------------------+-------+--------------+
| Descrição: | Geração de NF de Importação - Integração com CAPRI (Despachante)                   |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function ICOMP05()
Local oButton1, oButton2, oGet1, oGroup1, oSay1, oSay2
Local _oFont 		:= tFont():New("Tahoma",,-14,,.t.), _oFont2 := tFont():New("Tahoma",,-12,,.t.)
Private _cRefExt 	:= Space(TamSX3("Z2_CODPROC")[1])
Private aTMPSF1		:= {}
Private _oICOMP05, _oGetProc, _lICOMP05 := .t.

DEFINE MSDIALOG _oICOMP05 TITLE "Importação de NF Digitada" FROM 000, 000  TO 400, 750 PIXEL

    @ 003, 000 GROUP oGroup1 TO 022, 375 OF _oICOMP05 PIXEL
    @ 009, 120 SAY oSay1 PROMPT "Relação de Processos para o Recebimento" SIZE 150, 010 OF _oICOMP05 PIXEL FONT _oFont
    @ 029, 120 SAY oSay2 PROMPT "Ref. Externa" SIZE 050, 010 OF _oICOMP05 PIXEL FONT _oFont2
    @ 027, 163 MSGET oGet1 VAR _cRefExt SIZE 060, 010 OF _oICOMP05 PIXEL
    @ 027, 250 BUTTON oButton1 PROMPT "Pesquisar"    SIZE 037, 012 OF _oICOMP05 PIXEL ACTION MsAguarde({|| FilCols(_cRefExt)},"Processando...","Buscando informações no despachante",.t.)
    fMSNewGe1()
    @ 182, 280 BUTTON oButton2 PROMPT "Gerar NF" 	SIZE 037, 012 OF _oICOMP05 PIXEL ACTION ICOMP05A(aTMPSF1[_oGetProc:nAt])
    @ 182, 330 BUTTON oButton3 PROMPT "Sair" 		SIZE 037, 012 OF _oICOMP05 PIXEL ACTION _oICOMP05:End()

ACTIVATE MSDIALOG _oICOMP05 CENTERED

Return


Static Function fMSNewGe1()
Local nX := 0, aHeaderEx := {}, aColsEx := {}, aFieldFill := {}, _aAlter := {}
Local aFields := {"Z2_CODPROC","F1__DOCCOD","F1__REFEXT" ,"F1__DTDIG2"  ,"F1_FORNECE","B1_DESC"}
Local aNomeSX := {"Processo"  ,"Documento","Ref. Externa","Data Emissão","Fornecedor","Razão Social"}

//aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(aNomeSX[nx]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
Next nX

//aCols
For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEx, aFieldFill)

_oGetProc := MsNewGetDados():New(046,000,177,375,,"AllwaysTrue","AllwaysTrue","",_aAlter,,999,"AllwaysTrue","","AllwaysTrue",_oICOMP05,aHeaderEx,aColsEx)

Return                          

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ICOMP05A | Autor: | Rubens Cruz - Anadi Consultoria 			| Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Desenvolvimento da tela de parametros							                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
| Parametros | _aNF 		:= Array com os dados da nota para montagem da tela e ExecAuto         |
|			 |     [01]		:= Código do Processo                                                  |
|			 |     [02]		:= Código do Documento                                                 |
|			 |     [03]		:= Série do Documento                                                  |
|			 |     [04]		:= Código do Referencia Externa                                        |
|			 |     [05]		:= Data de Emissão do Documento                                        |
|			 |     [06]		:= Código do Fornecedor                                                |
|			 |     [07]		:= Nome do Fornecedor                                                  |
|			 |     [08]		:= Código da Filial que irá receber a mercadoria                       |
|			 |     [09]		:= Código da DI                                                        |
|			 |     [10]		:= Data da DI			                                               |
|			 |     [11]		:= Local de Desembaraco                                                |
|			 |     [12]		:= UF de Desembaraco                                                   |
|			 |     [13]		:= Data de Desembaraco                                                 |
|			 |     [14]		:= Peso Liquido                                                        |
|			 |     [15]		:= Peso Bruto                                                          |
|			 |     [16]		:= Quantidade                                                          |
|			 |     [17]		:= Valor da NF                                                         |
|			 |     [18]		:= Valor Bruto                                                         |
|			 |     [19]		:= Frete                                                               |
|			 |     [20]		:= Base de Calculo ICMS                                                |
|			 |     [21]		:= Aliquota ICMS                                                       |
|			 |     [22]		:= Valor ICMS                                                          |
|			 |     [23]		:= Base de Calculo IPI                                                 |
|			 |     [24]		:= Valor IPI                                                           |
|			 |     [25]		:= CFOP                                                                |
|			 |     [26]		:= DOC_TIP //Usado na chave para relacionar com os itens			   |
+------------+-------------------------------------------------------------------------------------+
*/                   

Static Function ICOMP05A(_aNF)
Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local _aAreaSZ1	:= SZ1->(GetArea())
Local _aArea	:= GetArea()                                                      
Local aStru 	:= {{010,070,130},;
					{130,180,190},;
					{220,250,270}} 
Local aStru2	:= {010,050,090,130,171,202}
Local _nLinha	:= 005 
Local _nLinAux	:= 0
Local nAlt		:= 0
Local nLarg		:= 0
Local _aItens	:= Separa(Posicione("SX3",2,"C5_TPFRETE","X3_CBOX"),";")
Local _aItens2	:= Separa(Posicione("SX3",2,"CD5_LOCAL" ,"X3_CBOX"),";")
Local _aItens3	:= Separa(Posicione("SX3",2,"CD5_TPIMP" ,"X3_CBOX"),";")

Private oDlgTMP     
Private oFret
Private oLoc
Private oDoc
Private oFont 		:= tFont():New("Tahoma",,,,.t.)
Private _cProc		:= Padr(alltrim(str(_aNF[01])),TamSX3("Z2_CODPROC")[1]) 
Private _cDocCod	:= _aNF[02] 
Private _cSerie		:= _aNF[03] 
Private _cRef		:= _aNF[04]
Private _dEmissao	:= _aNF[05]
Private _cFilial	:= cFilAnt //StrZero(_aNF[08],2)
Private _cNmFil		:= ""
Private _cForn		:= space(TamSX3("A2_COD")[1])     
Private _cLoja		:= space(TamSX3("A2_LOJA")[1])
Private _cEnd		:= space(TamSX3("A2_END")[1])
Private _cSeg		:= " "//space(TamSX3("Z7_CODIGO")[1])
Private _cTransp	:= space(TamSX3("A4_COD")[1])
Private _cTpFret	:= ""
Private _cLocSrv	:= ""
Private _cTpImp		:= ""
Private _cDI		:= PadR(_aNF[09],TamSX3("CD5_NDI")[1])
Private _dDtDI		:= _aNF[10]
Private _dDtDesem	:= _aNF[13]
Private _cDesem		:= _aNF[11] 
Private _cUFDesem	:= PadR(_aNF[12],TamSX3("A2_EST")[1])
Private _cCodObs	:= space(TamSX3("Z21_CODIGO")[1])
Private _nPesLiq	:= _aNF[14], _nPesBrut := _aNF[15], _nQtVol := _aNF[16]
Private _cNmFor		:= ""     
Private _cNmSeg		:= "  "
Private _cNmTran	:= ""
Private _cNmObs		:= "", _nFilCod := _nDocTip := _nDocCod := 0

DbSelectArea("SZE")
DbSetOrder(1)
DbSeek(cEmpAnt+_cFilial)
_cNmFil := SZE->ZE_FILIAL

/*
DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek(xFilial("SZ1")+__cUserID)
_cSeg 	:= SZ1->Z1_SEGISP
_cNmSeg	:= SZ1->Z1_DESCR
*/
DEFINE MSDIALOG oDlgTMP TITLE OemToAnsi("Parametros NF") From 000,000 To 540,610 OF oMainWnd PIXEL
nAlt  := (oDlgTMP:nClientHeight / 2) - 30
nLarg := (oDlgTMP:nClientWidth  / 2) - 10

//Cabecalho da janela com os dados do aCols da tela anterior
@ _nLinha,aStru2[1] Say "Processo"					SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru2[2] Say "Documento"					SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru2[3] Say "Ref. Externa"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru2[4] Say "Dt. Emissão"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru2[5] Say "Fornecedor"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
_nLinha += 12

@ _nLinha,aStru2[1] MsGet _cProc 					SIZE 040,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru2[2] MsGet _cDocCod	 				SIZE 040,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru2[3] MsGet _cRef 					SIZE 040,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru2[4] MsGet _dEmissao	 				SIZE 040,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru2[5] MsGet _aNF[06]					SIZE 030,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru2[6] MsGet _aNF[07]					SIZE 105,10 of oDlgTMP PIXEL WHEN .F.
_nLinAux := _nLinha += 26
            
//Itens para preenchimento
@ _nLinha,aStru[1][1] Say "Filial :"   				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cFilial 				SIZE 020,10 of oDlgTMP PIXEL F3 "DLB" VALID ValField()
@ _nLinha,aStru[1][3] MsGet _cNmFil 				SIZE 080,10 of oDlgTMP PIXEL WHEN .F.
_nLinha += 16
	
@ _nLinha,aStru[1][1] Say "Fornecedor: "			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cForn 					SIZE 050,10 of oDlgTMP PIXEL F3 "SA2LIK" VALID ValField()
_nLinha += 16
	
@ _nLinha,aStru[1][1] Say "Loja: "					SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cLoja 					SIZE 020,10 of oDlgTMP PIXEL VALID ValField()
@ _nLinha,aStru[1][3] MsGet _cNmFor 				SIZE 140,10 of oDlgTMP PIXEL WHEN .F.
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Endereço :"	  			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cEnd 					SIZE 140,10 of oDlgTMP PIXEL When .f.
_nLinha += 16
	
@ _nLinha,aStru[1][1] Say "Segmento :"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cSeg	 				SIZE 020,10 of oDlgTMP PIXEL WHEN .F.  
@ _nLinha,aStru[1][3] MsGet _cNmSeg 				SIZE 060,10 of oDlgTMP PIXEL WHEN .F.  
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Transportadora :"		SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cTransp 				SIZE 040,10 of oDlgTMP PIXEL F3 "SA4LIK" VALID ValField()
@ _nLinha,aStru[1][3] MsGet _cNmTran 				SIZE 140,10 of oDlgTMP PIXEL WHEN .F.
_nLinha += 16
		
@ _nLinha,aStru[1][1] Say "Tipo de Frete :"			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL  
@ _nLinha,aStru[1][2] COMBOBOX oFret VAR _cTpFret ITEMS _aItens 	SIZE 55,10 Of oDlgTMP PIXEL 
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Processo :"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cProc 					SIZE 040,10 of oDlgTMP PIXEL WHEN .F.
@ _nLinha,aStru[2][1] Say "Número DI :"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[2][2] MsGet _cDI 					SIZE 040,10 of oDlgTMP PIXEL 
@ _nLinha,aStru[3][1] Say "Data DI :"				SIZE 080,10 OF oDlgTMP FONT oFont PIXEL  
@ _nLinha,aStru[3][2] MsGet _dDtDI 					SIZE 040,10 of oDlgTMP PIXEL 
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Local Desembaraço :"		SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cDesem					SIZE 140,10 of oDlgTMP PIXEL 
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Obs Compl. :"			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cCodObs				SIZE 040,10 of oDlgTMP PIXEL F3 "Z21" VALID ValField()
@ _nLinha,aStru[1][3] MsGet _cNmObs					SIZE 140,10 of oDlgTMP PIXEL WHEN .F.
_nLinha += 16

@ _nLinha,aStru[1][1] Say "UF Desembaraço :"		SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _cUFDesem				SIZE 020,10 of oDlgTMP PIXEL F3 "12" VALID (Vazio() .OR. ExistCpo("SX5","12"+_cUFDesem))
@ _nLinha,aStru[2][1] Say "Data Desemb. :"			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[2][2] MsGet _dDtDesem				SIZE 040,10 of oDlgTMP PIXEL 
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Peso Liquido :"			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[1][2] MsGet _nPesLiq				SIZE 045,10 of oDlgTMP PICTURE "@E 999,999.99" PIXEL 
@ _nLinha,aStru[2][1] Say "Peso Bruto :"			SIZE 080,10 OF oDlgTMP FONT oFont PIXEL 
@ _nLinha,aStru[2][2] MsGet _nPesBrut				SIZE 045,10 of oDlgTMP PICTURE "@E 999,999.99" PIXEL 
_nLinha += 16

@ _nLinha,aStru[1][1] Say "Local Serviço:"		    SIZE 080,10 OF oDlgTMP FONT oFont PIXEL  
@ _nLinha,aStru[1][2] COMBOBOX oLoc  VAR _cLocSrv ITEMS _aItens2 	SIZE 060,10 Of oDlgTMP PIXEL 
@ _nLinha,aStru[2][1] Say "Tipo Doc.:"		        SIZE 100,10 OF oDlgTMP FONT oFont PIXEL  
@ _nLinha,aStru[2][2] COMBOBOX oDoc VAR _cTpImp   ITEMS _aItens3 	SIZE 100,10 Of oDlgTMP PIXEL 
_nLinha += 16

@ _nLinAux-12,005 TO _nLinha,300 PROMPT "Parâmetros para a Importação/Geração NFE"  OF oDlgTMP COLOR 0, 16777215 PIXEL

@ nAlt,(nLarg-090) Button oButton PROMPT "Confirmar"  	SIZE 40,13   OF oDlgTMP PIXEL ACTION {|| MsAguarde({|| ICOMP05B(_aNF)}, "Processando","Gerando documento de entrada"),oDlgTMP:End()}
@ nAlt,(nLarg-040) Button oButton PROMPT "Sair"  		SIZE 40,13   OF oDlgTMP PIXEL ACTION {|| oDlgTMP:End()}
		
ACTIVATE MSDIALOG oDlgTMP CENTERED                                                                                  

RestArea(_aArea)
RestArea(_aAreaSZE)
RestArea(_aAreaSZ1)

Return

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | FilCols  | Autor: | Rubens Cruz - Anadi Consultoria 			| Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Preenche GetDados com os dados da referência externa informada	                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function FilCols(cRefExt)
Local _cQuery 	:= _cTab := "", _lRet := .t.
Local _aResult	:= 0

/*_cQuery := "SELECT PRI_COD PROCESSO,                                                         " + Chr(13)
_cQuery += "       DOC_COD,                                                                  " + Chr(13)
_cQuery += "       ESP_SERIE DOC_SERIE,                                                      " + Chr(13)
_cQuery += "       pri_esp_refcliente REFEXT,                                                " + Chr(13)
_cQuery += "       doc_dta_emissao DTEMISSAO,                                                " + Chr(13)
_cQuery += "       COD_PESSOA FORCOD,                                                        " + Chr(13)
_cQuery += "       nome_pessoa FORNOME,                                                      " + Chr(13)
_cQuery += "       FIL_COD,                                                                  " + Chr(13)
_cQuery += "       CDI_COD,						                                             " + Chr(13)
_cQuery += "       DATA_REGDI DT_DI,			                                             " + Chr(13)
_cQuery += "       LOCAL_DESEMBARACO,			                                             " + Chr(13)
_cQuery += "       UF_LOCAL_DESEMBARACO UF_DESEMB,                                           " + Chr(13)
_cQuery += "       DATA_DESEMBARACO DT_DESEMB,                                           	 " + Chr(13)
_cQuery += "       FIS_FLT_PESO_LIQUIDO PESO_LIQ,                                            " + Chr(13)
_cQuery += "       FIS_FLT_PESO_BRUTO PESO_BRUT,                                             " + Chr(13)
_cQuery += "       FIS_QTD_VOLUMES QUANTIDADE,                                               " + Chr(13)
_cQuery += "       MNY_VLR_CONTABIL VAL_NF,                                                  " + Chr(13)
_cQuery += "       MNY_VLR_MERC VAL_BRUT,                                                    " + Chr(13)
_cQuery += "       MNY_FRETE FRETE,                                                          " + Chr(13)
_cQuery += "       MNY_BC_ICMS BC_ICMS,		                                                 " + Chr(13)
_cQuery += "       PCT_ICMS ALIQ_ICMS,		                                                 " + Chr(13)
_cQuery += "       MNY_ICMS ICMS,			                                                 " + Chr(13)
_cQuery += "       MNY_BC_IPI BC_IPI,		                                                 " + Chr(13)
_cQuery += "       MNY_IPI IPI,			                                                     " + Chr(13)
_cQuery += "       CFOP,			                                                     	 " + Chr(13)
_cQuery += "       DOC_TIP			                                                     	 " + Chr(13)
_cQuery += "FROM conexos.view_int_nfe@msvsim_conexos CB                                      " + Chr(13)
_cQuery += "WHERE TRIM(pri_esp_refcliente) = '" + alltrim(cRefExt) + "'                      " + Chr(13)
//_cQuery += "      AND NOT EXISTS(SELECT 1                                                    " + Chr(13)
//_cQuery += "                     FROM " + retSqlname("SF1") + " F1                           " + Chr(13)
//_cQuery += "                     WHERE LTRIM(RTRIM(F1admin.F1__DOCCOD))=LTRIM(RTRIM(CB.DOC_COD))  " + Chr(13)
//_cQuery += "                     AND F1.D_E_L_E_T_=' ')                                      "
TCQUERY _cQuery NEW ALIAS _cTab
TcSetField(_cTab, "DTEMISSAO"  , "D", 08, 0)
TcSetField(_cTab, "DT_DI"  	  , "D", 08, 0)
TcSetField(_cTab, "DT_DESEMB"  , "D", 08, 0) */
/*
If (select(_cTab) > 0)
    TRB_SLD->(DbCloseArea())
EndIf
*/

/*
If TCSPExist("SPIMPPA8")
	_aResult := TCSPEXEC("SPIMPPA8",Alltrim(cRefExt))
				
    If !Empty(_aResult)
        If _aResult[1] == "S"
            Help( Nil, Nil, "CONEXOS", Nil, "Falha na comunicação com o despachante", 1, 0 ) 
            _lRet := .f.
        EndIf
    Else
        Help( Nil, Nil, "CONEXOS", Nil, "Problema com execução de stored procedure. Tente novamente", 1, 0 )
        _lRet := .f. 
    EndIf
Else
    MsgStop("Procedure SPIMPPA8 não localizada no banco de dados. Favor contatar o TI")
    _lRet := .f.
EndIf
*/

If TCSPExist("SPIMPPA8")

	_aResult := TCSPEXEC("SPIMPPA8",Alltrim(cRefExt))
				
    If !Empty(_aResult)
		If _aResult[1] == "S"
           Help( Nil, Nil, "CONEXOS", Nil, _aResult[2] , 1, 0 ) 
            _lRet := .f.
		EndIf        
    Else
        Help( Nil, Nil, "CONEXOS", Nil, "Problema com execução de stored procedure SPIMPPA8. Tente novamente", 1, 0 )
        _lRet := .f. 
    EndIf
Else
    MsgStop("Procedure SPIMPPA8 não localizada no banco de dados. Favor contatar o TI")
    _lRet := .f.
EndIf

If _lRet
    _cTab   := GetNextAlias()
    _cQuery := "SELECT *                                                                 "
    _cQuery += "FROM " + RetSqlName("PA8") + " PA8                                       "
    _cQuery += "WHERE PA8.D_E_L_E_T_ = ' '                                               "
    _cQuery += "      AND TRIM(PA8_ESPREF) = TRIM('" + alltrim(cRefExt) + "')            "
    _cQuery += "      AND NOT EXISTS(SELECT 1                                            "
    _cQuery += "                     FROM " + RetSqlName("SF1") + " SF1                  "
    _cQuery += "                     WHERE TRIM(SF1.F1__DOCCOD) = TRIM(PA8.PA8_DOCCOD)   "
    _cQuery += "                     AND SF1.D_E_L_E_T_=' ')                             "
    
    If Select(_cTab) > 0
        DbSelectArea(_cTab)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cTab,.T.,.T.)  
    TcSetField(_cTab, "PA8_DTEMIS"  , "D", 08, 0)
    TcSetField(_cTab, "PA8_DTMOV"   , "D", 08, 0)
    TcSetField(_cTab, "PA8_DATDES"  , "D", 08, 0)
    TcSetField(_cTab, "PA8_DREGDI"  , "D", 08, 0)
    
    _oGetProc:aCols := {}
    aTMPSF1	:= {}
    
    DbSelectArea(_cTab)
    DbGoTop()
    
    If(Eof())  
    	AADD(aTMPSF1,{})
    	AADD(_oGetProc:aCols,{"",;
    						  "",;
    						  "",;
    						  CTOD("  /  /    "),;
    						  "",;
    						  "",;
    						  .F.}) 
    	_oGetProc:nAt := 1                         
    Else
    	While !Eof()
    		AADD(aTMPSF1,{(_cTab)->PA8_PRICOD			,;
    		   			  (_cTab)->PA8_DOCCOD			,;
    		   			  (_cTab)->PA8_SERIE 	 		,;
    		  			  (_cTab)->PA8_ESPREF  			,;
    		  			  (_cTab)->PA8_DTEMIS	  		,;
    		  			  (_cTab)->PA8_CODPES  			,;
    		  			  (_cTab)->PA8_NOMPES  			,;
    		  			  (_cTab)->PA8_FILCOD  			,;
    		  			  (_cTab)->PA8_CDICOD 			,;
    		  			  (_cTab)->PA8_DREGDI  			,;
    		  			  (_cTab)->PA8_LOCDES			,;
    		  			  (_cTab)->PA8_UFLDES	  		,;		
    					  (_cTab)->PA8_DATDES	  		,;		
    					  (_cTab)->PA8_PESLIQ	  		,;		
    					  (_cTab)->PA8_PESBRU 	 		,;		
    					  (_cTab)->PA8_QTDVOL	 		,;		
    					  (_cTab)->PA8_VLRCON 			,;		
    					  (_cTab)->PA8_VLRMER	  		,;		
    					  (_cTab)->PA8_FRETE  			,;		
    					  (_cTab)->PA8_BCIMS  			,;		
    					  (_cTab)->PA8_PCTICM	  		,;
    					  (_cTab)->PA8_ICM	  			,;
    					  (_cTab)->PA8_BCIPI  			,;
    					  (_cTab)->PA8_IPI  			,;
    					  (_cTab)->PA8_CFOP				,;
    					  (_cTab)->PA8_DOCTIP			,;
    					  (_cTab)->PA8_FILCOD           })
    					  
    		AADD(_oGetProc:aCols,{(_cTab)->PA8_PRICOD	,;
    							  (_cTab)->PA8_DOCCOD	,;
    							  (_cTab)->PA8_ESPREF	,;
    							  (_cTab)->PA8_DTEMIS	,;
    							  (_cTab)->PA8_CODPES	,;
    							  (_cTab)->PA8_NOMPES	,;
    							  .F.				})                          
    		DbSelectArea(_cTab)
    		DbSkip()
    	EndDo  
    	_oGetProc:goTop()
    	_oGetProc:Refresh()
    EndIf
EndIf

Return

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ICOMP05B | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Rotina para gravacao da NF de entrada através do ExecAuto		                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
| Parametros | _aNF 		:= Array com os dados da nota para montagem da tela e ExecAuto         |
|			 |     [01]		:= Código do Processo                                                  |
|			 |     [02]		:= Código do Documento                                                 |
|			 |     [03]		:= Série do Documento                                                  |
|			 |     [04]		:= Código do Referencia Externa                                        |
|			 |     [05]		:= Data de Emissão do Documento                                        |
|			 |     [06]		:= Código do Fornecedor                                                |
|			 |     [07]		:= Nome do Fornecedor                                                  |
|			 |     [08]		:= Código da Filial que irá receber a mercadoria                       |
|			 |     [09]		:= Código da DI                                                        |
|			 |     [10]		:= Data da DI			                                               |
|			 |     [11]		:= Local de Desembaraco                                                |
|			 |     [12]		:= UF de Desembaraco                                                   |
|			 |     [13]		:= Data de Desembaraco                                                 |
|			 |     [14]		:= Peso Liquido                                                        |
|			 |     [15]		:= Peso Bruto                                                          |
|			 |     [16]		:= Quantidade                                                          |
|			 |     [17]		:= Valor Bruto                                                         |
|			 |     [18]		:= Valor Mercadoria                                                    |
|			 |     [19]		:= Frete                                                               |
|			 |     [20]		:= Base de Calculo ICMS                                                |
|			 |     [21]		:= Aliquota ICMS                                                       |
|			 |     [22]		:= Valor ICMS                                                          |
|			 |     [23]		:= Base de Calculo IPI                                                 |
|			 |     [24]		:= Valor IPI                                                           |
|			 |     [25]		:= CFOP                                                                |
|			 |     [26]		:= DOC_TIP //Usado na chave para relacionar com os itens			   |
|            |     [27]     := FIL_COD //Usado na chave para relacionar com os itens               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function ICOMP05B(_aNF)
Local lSucess	:= .T. , _cTb2 := _cQuery := ""
Local _cErro 	:= _cAviso := _cDest := "", _lErro := .f.
Local _aCab 	:= {}, _lEmb := .f.
Local _aItens   := {}, _cSQL := _cTb9 := ""
Local _aLinha	:= {}, _lSZ3 := .f.
Local _cQuery	:= "", _nPrUni := 0
Local _cZ2Cod	:= Posicione("SZ2",3,_cFilial+_cProc,"Z2_CODIGO")
Local _cNumDI	:= ""  
Local _lCont	:= .T.
Local _cTpTes	:= PADR(GetMV("MV__TESEXT"),TamSX3("FM_TIPO")[1])
Local _cCIpiAux	:= ""
Local _cSIpiAux	:= ""
Local _cTes		:= "", _nFatDes := _nFatFrt := 0
Local _cFilAux	:= cFilAnt
Local cResul	:= _cProd := "" 
Local _lPA9OK	:= .T.
   
Private lMsErroAuto := .F., _aSZ3 := {{0,0}}

cFilAnt := _cFilial

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+_cForn+_cLoja)

DbSelectArea("SFM")
DbSetOrder(2)
If DbSeek(_cFilial+_cTpTes+Space(TamSX3("FM_CLIENTE")[1])+Space(TamSX3("FM_LOJACLI")[1])+Space(TamSX3("FM_FORNECE")[1])+Space(TamSX3("FM_LOJAFOR")[1]))
    _cCIpiAux := SFM->FM_TE
    _cSIpiAux := SFM->FM__TESIPI
EndIf           			

/*_cQuery	:= "SELECT PA9_CODEXT,                                       " + Chr(13)
_cQuery	+= "       PA9_QTD,                                        " + Chr(13)
_cQuery	+= "       CDI_COD,                                                   " + Chr(13)
_cQuery	+= "       CDI_COD_SEQ,                                               " + Chr(13)
_cQuery	+= "       ADI_COD,                                                   " + Chr(13)
_cQuery	+= "       DPR_PRE_VALORUN,                                           " + Chr(13)
_cQuery	+= "       CASE WHEN PA9_QTD = 0                           " + Chr(13)
_cQuery	+= "            THEN 0                                                " + Chr(13)
_cQuery	+= "       ELSE (DPR_PRE_VALORUN/PA9_QTD) END AS VUNIT,    " + Chr(13)
_cQuery	+= "       PA9_CSTICM,                                                  " + Chr(13)
_cQuery	+= "       MNY_VLR_IPI,                                               " + Chr(13)
_cQuery	+= "       MNY_FRETE,                                                 " + Chr(13)
_cQuery	+= "       MNY_SEGURO,                                                " + Chr(13)
_cQuery	+= "       MNY_BC_II,                                                 " + Chr(13)
_cQuery	+= "       MNY_II,                                                    " + Chr(13)
_cQuery	+= "       MNY_DESPESAS,                                              " + Chr(13)
_cQuery	+= "       PA9_IPI,                                                   " + Chr(13)
_cQuery	+= "       MNY_BC_ICMS,                                               " + Chr(13)
_cQuery	+= "       MNY_BC_PIS,                                                " + Chr(13)
_cQuery	+= "       MNY_VLR_PIS,                                               " + Chr(13)
_cQuery	+= "       PCT_PIS,                                                   " + Chr(13)
_cQuery	+= "       MNY_BC_COFINS,                                             " + Chr(13)
_cQuery	+= "       MNY_VLR_COFINS,                                            " + Chr(13)
_cQuery	+= "       PCT_COFINS,                                                " + Chr(13)
_cQuery	+= "       MNY_VLR_ICMS,                                              " + Chr(13)
_cQuery	+= "       PCT_ICMS,                                                  " + Chr(13)
_cQuery	+= "       MNY_BC_IPI                                                 " + Chr(13)
_cQuery	+= "FROM CONEXOS.VIEW_INT_NFE_ITENS@MSVSIM_CONEXOS DET                " + Chr(13)
_cQuery	+= "WHERE DET.FIL_COD = '" + Alltrim(Str(_aNF[08])) + "'              " + Chr(13)
_cQuery	+= "      AND DET.DOC_TIP = '" + Alltrim(Str(_aNF[26])) + "'          " + Chr(13)
_cQuery	+= "      AND DET.DOC_COD = '" + Alltrim(Str(_aNF[02])) + "'          "
TCQUERY _cQuery NEW ALIAS _cTb2*/

/*
If TCSPExist("SPIMPPA9")
	cResul := TCSPEXEC("SPIMPPA9",;
						alltrim(_cRef),;
						_aNF[02])
Else
    MsgStop("Procedure SPIMPPA9 não localizada no banco de dados, favor contatar o TI.")
    Return
EndIf
*/

If TCSPExist("SPIMPPA9")    
    _aResult := TCSPEXEC("SPIMPPA9",alltrim(_cRef),_aNF[02])
                
    If !Empty(_aResult)
        If _aResult[1] == "S"
           Help( Nil, Nil, "CONEXOS_PA9", Nil, _aResult[2] , 1, 0 ) 
            _lPA9OK := .f.
        EndIf        
    Else
        Help( Nil, Nil, "CONEXOS_PA9", Nil, "Problema com execução de stored procedure SPIMPPA9. Tente novamente", 1, 0 )
        _lPA9OK := .f. 
    EndIf
Else
    MsgStop("Procedure SPIMPPA9 não localizada no banco de dados. Favor contatar o TI")
    _lPA9OK := .f.
EndIf

If !_lPA9OK
    Return
EndIf

If Empty(_cZ2Cod)
	If !MsgYesno("O pedido de importação não foi localizado. Deseja prosseguir?","NF DE IMPORTAÇÃO")
		Return
	EndIf
EndIf

_cTb2   := GetNextAlias()
_cQuery	:= "SELECT *                                               "
_cQuery	+= "FROM " + RetSqlName("PA9") + " PA9                     "
_cQuery	+= "WHERE PA9.D_E_L_E_T_ = ' '                             "
_cQuery	+= "      AND PA9_FILCOD = " + Alltrim(Str(_aNF[27])) +    "  AND PA9_DOCTIP = " + Alltrim(Str(_aNF[26])) + " "  
_cQuery += "      AND PA9_DOCCOD = " + Alltrim(Str(_aNF[02])) "

If Select(_cTb2) > 0
    DbSelectArea(_cTb2)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cTb2,.T.,.T.)

DbSelectArea(_cTb2)
DbGoTop()

If Eof()
    _lCont := .f.
EndIf

If !_lCont
	MsgStop("Nao foi possivel fazer a geração do documento. Itens não localizados")
	If Select(_cTb2) > 0
	    DbSelectArea(_cTb2)
	    DbCloseArea()
	EndIf	
	Return
EndIf

//Verifica se existem quantidades quebradas em algum item
DbSelectArea(_cTb2)
While !Eof()

	If Int((_cTb2)->PA9_QTD) != (_cTb2)->PA9_QTD
	    _lCont := .f.
		If !_lCont
			MsgStop("O Produto " + Alltrim((_cTb2)->PA9_CODEXT) +" está com a quantidade inválida. " + Alltrim(Str((_cTb2)->PA9_QTD)))
			If Select(_cTb2) > 0
			    DbSelectArea(_cTb2)
			    DbCloseArea()
			EndIf	
			Return
		EndIf
	
	EndIf
	
	DbSelectArea(_cTb2)
	DbSkip()

EndDo

DbSelectArea(_cTb2)
DbGoTop()

_cTb9 := GetNextAlias()
_cSQL := "Select Sum(A9.PA9_MNYDES) PA9_MNYDES, Sum(A9.PA9_FRETE) PA9_FRETE From " + RetSqlName("PA9") + " A9 "
_cSQL += "Where PA9_FILCOD = " + Alltrim(Str(_aNF[27])) + " And PA9_DOCTIP = " + Alltrim(Str(_aNF[26])) + " And "
_cSQL +=    "PA9_DOCCOD = " + Alltrim(Str(_aNF[02])) + " And A9.D_E_L_E_T_ = ' ' "

If Select(_cTb9) > 0
    DbSelectArea(_cTb9)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTb9,.T.,.T.)

DbSelectArea(_cTb9)
DbGoTop()

If !Eof()
    _nFatDes := (_cTb9)->PA9_MNYDES/_aNF[18]
    _nFatFrt := (_cTb9)->PA9_FRETE/_aNF[18]
EndIf

If Select(_cTb9) > 0
    DbSelectArea(_cTb9)
    DbCloseArea()
EndIf

DbSelectArea(_cTb2)
DbGoTop()

_aCab   := {}

Do While !(eof()) 
    
    _cProd  := PADR(Alltrim((_cTb2)->PA9_CODEXT),TamSX3("B1_COD")[1])
    //_lCont  := .f.
    //_lCont  := ICOMP05E(Alltrim(_cRef),_cProd,_cTb2)
    _lSZ3  := ICOMP05E(Alltrim(_cRef),_cProd,_cTb2)
    //If !_lCont
    //    Exit
    //EndIf
         
    /*_lSZ3 := .t.
    DbSelectArea("SZ3")
	DbSetOrder(4)
	If !DbSeek(_cFilial + _cZ2Cod + _cProd + SA2->A2_COD + SA2->A2_LOJA)
		//Alert("Produto " + (_cTb2)->PA9_CODEXT + " Não encontrado no pedido de compra")
		_lSZ3 := .f.
		//Exit
    ElseIf( (_cTb2)->PA9_QTD > (SZ3->Z3_QTDPED - SZ3->Z3_QTDESEM) )
        //Alert("Quantidade maior que saldo do pedido de compra")
        //_lCont  := .F.
        //Exit
        _lSZ3 := .f.
	EndIf	*/

	DbSelectArea("SFM")
	DbSetOrder(2)
	If ((_cTb2)->PA9_IPI > 0)
		If (DbSeek(_cFilial + _cTpTes + Space(TamSX3("FM_CLIENTE")[1]) + Space(TamSX3("FM_LOJACLI")[1]) + SA2->A2_COD + SA2->A2_LOJA))
        	_cTes 	:= SFM->FM_TE
		Else
        	_cTes 	:= _cCIpiAux
		EndIf
	Else
		If (DbSeek(_cFilial + _cTpTes + Space(TamSX3("FM_CLIENTE")[1]) + Space(TamSX3("FM_LOJACLI")[1]) + SA2->A2_COD + SA2->A2_LOJA))
        	_cTes 	:= SFM->FM__TESIPI
		Else
        	_cTes 	:= _cSIpiAux
		EndIf
	EndIf
		
    If Len(_aCab) == 0
        _aCab := {  {"F1_DOC"       ,Space(TamSX3("F1_DOC")[1])                     ,NIL},;
                    {"F1_SERIE"     ,Space(TamSX3("F1_SERIE")[1])                   ,NIL},;
                    {"F1_FORNECE"   ,SA2->A2_COD                                    ,NIL},;
                    {"F1_LOJA"      ,SA2->A2_LOJA                                   ,NIL},;
                    {"F1_EST"       ,SA2->A2_EST                                    ,NIL},;
                    {"F1_TIPO"      ,'N'                                            ,NIL},;
                    {"F1_FORMUL"    ,'S'                                            ,NIL},;
                    {"F1_EMISSAO"   ,Date()                                         ,NIL},;
                    {"F1_ESPECIE"   ,'SPED'                                         ,NIL},;
                    {"F1__PROIMP"   ,_cProc                                         ,NIL},;
                    {"F1_COND"      ,SZ2->Z2_CONDPAG                                ,NIL},;
                    {"F1_TRANSP"    ,_cTransp                                       ,NIL},;
                    {"F1_TPFRETE"   ,_cTpFret                                       ,NIL},;
                    {"F1_PLIQUI"    ,_nPesLiq                                       ,NIL},;
                    {"F1_PBRUTO"    ,_nPesBrut                                      ,NIL},;
                    {"F1_VOLUME1"   ,_nQtVol	                                    ,NIL},;
	                {"F1_ESPECI1"   ,"VOLUME(S)"                                    ,NIL},;
                    {"F1__REFEXT"   ,_cRef                                          ,Nil},;
                    {"F1__DOCCOD"   ,_cDocCod                                       ,Nil}}
                    
    EndIf
		
	//Monta o numeto da DI, deixando apenas os dígitos
	_cNumDI := Alltrim(Str(_aNF[09]))
	
    Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_LOCPAD")
    Posicione("SC7",1,xFilial("SC7") + SZ3->Z3_PEDIDO + SZ3->Z3_ITPEDCO,"C7_LOCAL")
    Posicione("SF4",1,xFilial("SF4") + _cTes,"F4_CODIGO")
    
    _nPrUni := NoRound(Val((_cTb2)->PA9_PREVAL)/(_cTb2)->PA9_QTD,TamSX3("D1_VUNIT")[2])
    
	AADD(_aLinha,{"D1_COD"	    		,_cProd               	                             ,NIL})
	If _lSZ3
	   AADD(_aLinha,{"D1_LOCAL"	    	,SC7->C7_LOCAL					                     ,NIL})
	Else
	   AADD(_aLinha,{"D1_LOCAL"         ,SB1->B1_LOCPAD                                      ,NIL})
	EndIf
	If _lSZ3
	   AADD(_aLinha,{"D1_UM"			,SZ3->Z3_UNIDMED                                  ,NIL})
	Else
	   AADD(_aLinha,{"D1_UM"            ,SB1->B1_UM                                       ,NIL})
	EndIf
	AADD(_aLinha,{"D1_QUANT"  			,(_cTb2)->PA9_QTD                                    ,NIL})
	/*
	AADD(_aLinha,{"D1_VUNIT"	    	,NoRound(Val((_cTb2)->PA9_PREVAL)/(_cTb2)->PA9_QTD,TamSX3("D1_VUNIT")[2]),NIL})
	AADD(_aLinha,{"D1_TOTAL"	    	,Val((_cTb2)->PA9_PREVAL)                            ,NIL})
	*/
	AADD(_aLinha,{"D1_VUNIT"	    	,_nPrUni                                             ,NIL})                           
	AADD(_aLinha,{"D1_TOTAL"	    	,_nPrUni * (_cTb2)->PA9_QTD                          ,NIL})
	
	AADD(_aLinha,{"D1_TES"    			,_cTes							                     ,NIL})
	AADD(_aLinha,{"D1_CF"	    		,_aNF[25]						                     ,NIL})
	AADD(_aLinha,{"D1_CLASFIS"    		,(_cTb2)->PA9_CSTICM 				                 ,NIL})
	AADD(_aLinha,{"D1_IPI" 		   		,NoRound((_cTb2)->PA9_IPI,TamSX3("D1_IPI")[2])       ,NIL})
	AADD(_aLinha,{"D1_VALIPI"    		,Round((_cTb2)->PA9_VLRIPI,TamSX3("D1_VALIPI")[2])   ,NIL})
	AADD(_aLinha,{"D1_BASEIPI"    		,NoRound((_cTb2)->PA9_BCIPI,TamSX3("D1_BASEIPI")[2]) ,NIL})
    //AADD(_aLinha,{"D1_VALFRE"    		,NoRound((_cTb2)->PA9_FRETE,TamSX3("D1_VALFRE")[2])  ,NIL})
	AADD(_aLinha,{"D1_SEGURO"    		,Round((_cTb2)->PA9_SEGURO,TamSX3("D1_SEGURO")[2]) ,NIL})
	AADD(_aLinha,{"D1_DESPESA"          ,Round(Val((_cTb2)->PA9_PREVAL) * _nFatDes,TamSX3("D1_DESPESA")[2])  ,NIL})
	//AADD(_aLinha,{"D1_DESPESA"    	,Round((_cTb2)->PA9_MNYDES,TamSX3("D1_DESPESA")[2])  ,NIL})
	AADD(_aLinha,{"D1_PICM" 	   		,NoRound((_cTb2)->PA9_ALQICM,TamSX3("D1_PICM")[2])   ,NIL})
    AADD(_aLinha,{"D1_VALICM"    		,Round((_cTb2)->PA9_VLRICM,TamSX3("D1_VALICM")[2])   ,NIL})
	AADD(_aLinha,{"D1_BASEICM"    		,NoRound((_cTb2)->PA9_BCICMS,TamSX3("D1_BASEICM")[2]),NIL})

	AADD(_aLinha,{"D1_BASIMP5"    		,NoRound((_cTb2)->PA9_BCCOF,TamSX3("D1_BASIMP5")[2]) ,NIL})
	AADD(_aLinha,{"D1_BASIMP6"    		,NoRound((_cTb2)->PA9_BCPIS,TamSX3("D1_BASIMP6")[2]) ,NIL})
	AADD(_aLinha,{"D1_VALIMP5"    		,Round((_cTb2)->PA9_VLRCOF,TamSX3("D1_VALIMP5")[2])  ,NIL})
	AADD(_aLinha,{"D1_VALIMP6"    		,Round((_cTb2)->PA9_VLRPIS,TamSX3("D1_VALIMP6")[2])  ,NIL})
	AADD(_aLinha,{"D1_ALQIMP5"    		,NoRound((_cTb2)->PA9_ALQCOF,TamSX3("D1_ALQIMP5")[2]),NIL})
	AADD(_aLinha,{"D1_ALQIMP6"    		,NoRound((_cTb2)->PA9_ALQPIS,TamSX3("D1_ALQIMP6")[2]),NIL})
    If _lSZ3
	   AADD(_aLinha,{"D1__PEDIMP" 	   		,SZ3->Z3_PEDIDO				                      ,NIL})
	   AADD(_aLinha,{"D1__ITPIMP" 	   		,SZ3->Z3_ITPEDCO			                      ,NIL})
	Else
	   AADD(_aLinha,{"D1__PEDIMP" 	   		,""							                      ,NIL})
	   AADD(_aLinha,{"D1__ITPIMP" 	   		,""							                      ,NIL})
    EndIf
	AADD(_aLinha,{"D1__CODPRO"    		,SZ2->Z2_CODIGO					                     ,NIL})
	AADD(_aLinha,{"D1__VTRANS"          ,SZ2->Z2_VTRANS                                      ,NIL})
	AADD(_aLinha,{"D1__INTERM"          ,SZ2->Z2_INTERM                                      ,NIL})
	AADD(_aLinha,{"D1__NDI"    			,_cNumDI						                     ,NIL})
	AADD(_aLinha,{"D1__DTDI"            ,_dDtDI                                              ,NIL})
	AADD(_aLinha,{"D1__SQADIC" 			,Alltrim(Str((_cTb2)->PA9_IDICOD))                   ,NIL})
	AADD(_aLinha,{"D1__NADIC" 			,Alltrim(Str((_cTb2)->PA9_ADICOD))                   ,NIL})
	AADD(_aLinha,{"D1__BCIMP" 			,NoRound((_cTb2)->PA9_BCII,TamSX3("D1__BCIMP")[2])	 ,NIL})
	AADD(_aLinha,{"D1__VLRII" 			,NoRound((_cTb2)->PA9_MNYII,TamSX3("D1__VLRII")[2])  ,NIL})
	AADD(_aLinha,{"D1__DSPAD"           ,NoRound(Val((_cTb2)->PA9_PREVAL) * _nFatDes,TamSX3("D1_DESPESA")[2])  ,NIL})

    AADD(_aLinha,{"D1__BASCOF"          ,NoRound((_cTb2)->PA9_BCCOF,TamSX3("D1__BASCOF")[2]) ,NIL})
    AADD(_aLinha,{"D1__BASPIS"          ,NoRound((_cTb2)->PA9_BCPIS,TamSX3("D1__BASPIS")[2]) ,NIL})
    AADD(_aLinha,{"D1__VALCOF"          ,Round((_cTb2)->PA9_VLRCOF,TamSX3("D1__VALCOF")[2])  ,NIL})
    AADD(_aLinha,{"D1__VALPIS"          ,Round((_cTb2)->PA9_VLRPIS,TamSX3("D1__VALPIS")[2])  ,NIL})
    AADD(_aLinha,{"D1__ALQCOF"          ,NoRound((_cTb2)->PA9_ALQCOF,TamSX3("D1__ALQCOF")[2]),NIL})
    AADD(_aLinha,{"D1__ALQPIS"          ,NoRound((_cTb2)->PA9_ALQPIS,TamSX3("D1__ALQPIS")[2]),NIL})
    
	AADD(_aLinha,{"D1__ALQIPI" 		   	,NoRound((_cTb2)->PA9_IPI,TamSX3("D1__ALQIPI")[2])   ,NIL})
	AADD(_aLinha,{"D1__VLRIPI"    		,Round((_cTb2)->PA9_VLRIPI,TamSX3("D1__VLRIPI")[2])  ,NIL})
	AADD(_aLinha,{"D1__BASIPI"    		,NoRound((_cTb2)->PA9_BCIPI,TamSX3("D1__BASIPI")[2]) ,NIL})
	
	AADD(_aLinha,{"D1__ALQICM" 	   		,NoRound((_cTb2)->PA9_ALQICM,TamSX3("D1__ALQICM")[2]),NIL})
    AADD(_aLinha,{"D1__VLRICM"    		,Round((_cTb2)->PA9_VLRICM,TamSX3("D1__VLRICM")[2])  ,NIL})
	AADD(_aLinha,{"D1__BASICM"    		,NoRound((_cTb2)->PA9_BCICMS,TamSX3("D1__BASICM")[2]),NIL})

    /*
    If SF4->F4_MALQCOF > 0 .And. (_cTb2)->PA9_BCCOF > 0
        AADD(_aLinha,{"D1_VALCMAJ"      ,(SF4->F4_MALQCOF/100) * (_cTb2)->PA9_BCCOF          ,NIL})
    EndIf
    
    If SF4->F4_MALQPIS > 0 .And. (_cTb2)->PA9_BCPIS > 0
        AADD(_aLinha,{"D1_VALPMAJ"      ,(SF4->F4_MALQPIS/100) * (_cTb2)->PA9_BCPIS          ,NIL})
    EndIf    
    */
  	AADD(_aItens,_aLinha)
	_aLinha := {} 

	DbSelectArea(_cTb2)
	DbSkip()
EndDo

If Select(_cTb2) > 0
    DbSelectArea(_cTb2)
    DbCloseArea()
EndIf

If !_lCont
	Return
EndIf 

MsExecAuto({|x,y,z,p| Mata103(x,y,z,p)},_aCab,_aItens,3,.T.)

If lMsErroAuto
	MostraErro()
Else
    _oGetProc:aCols[_oGetProc:nAt][Len(_oGetProc:aHeader)+1] := .t.
    _oGetProc:Refresh()
EndIf 		    

cFilAnt := _cFilAux

Return

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ValField | Autor: | Rubens Cruz - Anadi Consultoria 			| Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Valida os dados digitados na tela de parametros para geracao do doc. de entrada	   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function ValField()
Local lRet 		:= .F.
Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local _aAreaSA2	:= SA2->(GetArea())
Local _aAreaSA4	:= SA4->(GetArea())
Local _aAreaZ21	:= Z21->(GetArea())

Do Case
	Case (ReadVar() == '_CFILIAL')
		If(Empty(_cFilial))
			lRet := .T.
			_cNmFil	:= ""
		Else
			DbSelectArea("SZE")
			If(DbSeek(cEmpAnt+_cFilial))
				_cNmFil	:= SZE->ZE_FILIAL
				lRet := .T.
			EndIf  
		EndIf
	Case (ReadVar() == '_CFORN')
		If(Empty(_cForn))
			lRet := .T.
			_cNmFor	:= ""
		Else
			DbSelectArea("SA2")
			If(DbSeek(xFilial("SA2")+_cForn))
				_cLoja	:= SA2->A2_LOJA
				_cNmFor	:= SA2->A2_NREDUZ
				_cEnd   := Alltrim(SA2->A2_END)
				_cSeg 	:= SA2->A2__SEGISP
				_cNmSeg	:= Posicione("SZ7",1,xFilial("SZ7") + _cSeg,"Z7_DESCRIC")
				lRet := .T.
			EndIf  
		EndIf
	Case (ReadVar() == '_CLOJA')
		If(Empty(_cLoja))
			lRet := .T.
			_cNmFor	:= ""
		Else
			DbSelectArea("SA2")
			If(DbSeek(xFilial("SA2")+_cForn+_cLoja))
				_cNmFor	:= SA2->A2_NREDUZ
				_cEnd   := Alltrim(SA2->A2_END)
				_cSeg 	:= SA2->A2__SEGISP
				_cNmSeg	:= Posicione("SZ7",1,xFilial("SZ7") + _cSeg,"Z7_DESCRIC")
				lRet := .T.
			EndIf  
		EndIf
	Case (ReadVar() == '_CTRANSP')
		If(Empty(_cTransp))
			lRet := .T.
			_cNmTran	:= ""
		Else
			DbSelectArea("SA4")
			If(DbSeek(xFilial("SA4")+_cTransp))
				_cNmTran	:= SA4->A4_NOME
				lRet := .T.
			EndIf  
		EndIf
	Case (ReadVar() == '_CCODOBS')
		If(Empty(_cCodObs))
			lRet := .T.
			_cNmObs	:= ""
		Else
			DbSelectArea("Z21")
			If(DbSeek(xFilial("Z21")+_cCodObs))
				_cNmObs	:= Z21->Z21_DESCRI
				lRet := .T.
			EndIf  
		EndIf
EndCase         

RestArea(_aAreaSZE)
RestArea(_aAreaSA2)
RestArea(_aAreaSA4)
RestArea(_aAreaZ21)
RestArea(_aArea)

Return lRet


Static Function ICOMP05E(_cIsaPrc,_cCodProc,_cTb2)
Local _cSQL := _cSZ3 := "", _nPos := 0, _lSZ3 := .f., _aArea := GetArea()

_cSZ3 := GetNextAlias()
_cSQL += "Select Z3.R_E_C_N_O_ Z3RECNO From " + RetSqlName("SZ3") + " Z3 "
_cSQL +=    "Inner Join " + RetSqlName("SZ2") + " Z2 On Z2_FILIAL = Z3_FILIAL And Z2_CODIGO = Z3_CODIGO And Z2.D_E_L_E_T_ = ' ' "
_cSQL += "Where Z3_FILIAL ='" + xFilial("SZ3") + "' And Z3_CODFORN = '" + SA2->A2_COD + "' And Z3_LOJAFOR = '" + SA2->A2_LOJA + "' And "
_cSQL +=    "Z3_PRODUTO = '" + _cCodProc + "' And Z3_QTDPED > Z3_QTDESEM And Z3_QTDPED >= " + Alltrim(Str((_cTb2)->PA9_QTD)) + " And "
_cSQL +=    "Z3.D_E_L_E_T_ = ' ' And Z2_PROCISA = '" + _cIsaPrc + "' And Z2_STATUS = '1' "
_cSQL += "Order By Z3.R_E_C_N_O_ "

If Select(_cSZ3) > 0
    DbSelectArea(_cSZ3)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cSZ3,.T.,.T.)

DbSelectArea(_cSZ3)
DbGoTop()

If Eof()
    //Help( Nil, Nil, "PEDCOM", Nil, "Pedido de compra não localizado para o produto " + Alltrim((_cTb2)->PA9_CODEXT), 1, 0 )  
Else
    While !Eof()
        
        DbSelectArea("SZ3")
        DbGoTo((_cSZ3)->Z3RECNO)
        
        _nPos := aScan(_aSZ3, { |x| x[1] == (_cSZ3)->Z3RECNO  })
        If _nPos > 0
            If (SZ3->Z3_QTDPED - SZ3->Z3_QTDESEM - _aSZ3[_nPos][2]) > 0
                _lSZ3 := .t.
            EndIf
        Else 
            _lSZ3 := .t.
        EndIf
        
        If _lSZ3
            If _nPos == 0   
                AADD(_aSZ3,{(_cSZ3)->Z3RECNO,(_cTb2)->PA9_QTD})
            Else
                _aSZ3[_nPos][2] += (_cTb2)->PA9_QTD
            EndIf
            DbSelectArea("SZ3")
            DbGoTo((_cSZ3)->Z3RECNO)
            Exit
        EndIf
        
        DbSelectArea(_cSZ3)
        DbSkip()
    EndDo
    /*
    If !_lSZ3
        Help(Nil, Nil, "QTDEMB", Nil, "Não localizado pedido de importação com saldo a embarcar." + Alltrim((_cTb2)->PA9_CODEXT), 1, 0)
    EndIf
    */
EndIf

If Select(_cSZ3) > 0
    DbSelectArea(_cSZ3)
    DbCloseArea()
EndIf

RestArea(_aArea)
Return _lSZ3