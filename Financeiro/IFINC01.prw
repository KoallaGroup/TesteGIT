#INCLUDE "PROTHEUS.CH"
#include "TbiConn.ch"
#include "topconn.ch"
#include "IFINC01.CH"

/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | IFINC01 | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Março/2015    |
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Consulta de psoição cliente customizada									   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/

User Function IFINC01()
Local cFilter := ""     

Private cCadastro := STR0005 //"Consulta Posi‡ao Clientes"
Private aRotina	:=	{{STR0001, "AxPesqui" 	, 0 , 1},; //"Pesquisar"
					 {STR0002, "AxVisual" 	, 0 , 2},; //"Visualizar"
					 {STR0003, "U_IFINC01A" , 0 , 2}}  //"Consultar"
 

dbSelectArea("SA1")
dbSetOrder(1)

SetKey(VK_F12, { || pergunte("IFINC01",.T.) } )

mBrowse( 6, 1,22,75,"SA1",,,,,,,,,,,,,,cFilter)

SetKey(VK_F12,Nil)

Return

/*
+-----------+----------+-------+-------------------------------------+------+---------------+
| Programa  | IFINC01A | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Março/2015    |
+-----------+----------+-------+-------------------------------------+------+---------------+
| Descricao | Consulta de psoição cliente customizada									    |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA													 					    |
+-----------+-------------------------------------------------------------------------------+
*/

User Function IFINC01A(_nRecno)
Local cPerg 	:= "IFINC01"
Local aPergs 	:= {}
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.) 
Local _lConf	:= (FunName() $ "IFINC01#IGENM01")

Private Inclui := .F.
Private Altera := .F.
Private aParam := {}

Default _nRecno := 0

Aadd(aPergs,{"Da Emissao ? "					,"","","mv_ch1","D",08						,0,0,"G","","MV_PAR01",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate a Emissao ? "					,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Vencimento ? "					,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate o Vencimento ? "				,"","","mv_ch4","D",08						,0,0,"G","","MV_PAR04",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera Provisor. ? "			,"","","mv_ch5","N",01						,0,0,"C","","MV_PAR05","Sim"		,"","","","","Nao"	  				,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Prefixo ? "					,"","","mv_ch6","C",TamSx3("E1_PREFIXO")[1]	,0,0,"G","","MV_PAR06",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo ? "					,"","","mv_ch7","C",TamSx3("E1_PREFIXO")[1]	,0,0,"G","","MV_PAR07",""			,"","","","","",""					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera Faturados ? "			,"","","mv_ch8","N",01						,0,0,"C","","MV_PAR08","Sim"		,"","","","","Nao"					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera Liquidados ? "			,"","","mv_ch9","N",01						,0,0,"C","","MV_PAR09","Sim"		,"","","","","Nao"					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Pedidos com Itens Bloqueados ?"	,"","","mv_ch0","N",01						,0,0,"C","","MV_PAR10","Sim"		,"","","","","Nao"					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tit. Gerados por Liquidacao ? "	,"","","mv_cha","N",01						,0,0,"C","","MV_PAR11","Sim"		,"","","","","Nao"					,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera Saldo ?  "				,"","","mv_chb","N",01						,0,0,"C","","MV_PAR12","Normal"		,"","","","","Corrigido"			,"","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera Lojas ?  "				,"","","mv_chc","N",01						,0,0,"C","","MV_PAR13","Sim"		,"","","","","Nao"					,"","","","",""					,"","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"TES gera duplicata ? "			,"","","mv_chd","N",01						,0,0,"C","","MV_PAR14","Todas"		,"","","","","Gera Duplicatas"		,"","","","","Não Gera Duplic"	,"","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Considera RA ? "					,"","","mv_che","N",01						,0,0,"C","","MV_PAR15","Sim"		,"","","","","Nao"					,"","","","",""					,"","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Exibe dias a vencer ? "			,"","","mv_chf","N",01						,0,0,"C","","MV_PAR16","Sim"		,"","","","","Nao"					,"","","","",""					,"","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Seleciona Filiais? "				,"","","mv_chg","N",01						,0,0,"C","","MV_PAR17","Sim"		,"","","","","Nao"					,"","","","",""					,"","","","","","","","","","","","","","","","","",""})

AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

If lPanelFin
	 lPergunte := PergInPanel(cPerg,.T.)
Else
    lPergunte := Pergunte(cPerg,_lConf)		
Endif

If(!lPergunte .AND. _lConf)//Tratativa para quando o usuario cancela a tela de parametros
	Return
EndIf

For nX := 1 To Len(aPergs)
	aadd(aParam,&(aPergs[nX][11]))
Next nX

If Type("_NRECNO") == "N" .AND. _nRecno > 0
	DbSelectArea("SA1")
	DbGoTo(_nRecno)
EndIf  

U_IFINC01B(aParam)

Return                                  

/*
+------------+----------+-------+-------------------------------------+------+---------------+
| Programa   | IFINC01B | Autor | Rubens Cruz	- Anadi Soluções 	  | Data | Março/2015    |
+------------+----------+-------+-------------------------------------+------+---------------+
| Descricao  | Consulta de psoição cliente customizada				   					     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
| Parametros | 	aParams = [1] Data de Emissao Inicial 										 |
| 			 | 			  [2] Data de Emissao Final   										 |
| 			 | 			  [3] Vencimento Inicial    										 |
| 			 | 			  [4] Vencimento Final    											 |
| 			 | 			  [5] Considera Provisorios (1) Sim (2) Nao   						 |
| 			 | 			  [6] Prefixo Inicial												 |
| 			 | 			  [7] Prefixo Final			  										 |
+------------+-------------------------------------------------------------------------------+
*/

User Function IFINC01B(aParam,cCLiente,cLoja)
Local aArea 	:= GetArea()
Local aAlias	:= {}
Local aAlias1	:= {}
Local aSize 	:= {}, aPosObj := {}, aInfo := {}, aObjects := {}
Local oDlg               
Local _cQuery	:= ""
Local cCgc		:= RetTitle("A1_CGC")
Local aGrpUsr	:= UsrRetGrp(__cUserId)
Local _lUsrFin	:= .F. //(__cUserId $ GetMV("MV__USRFIN"))
Local cMoeda    := ""
Local aSavAhead := If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol  := If(Type("aCols")=="A",aCols,{})
Local nSavN     := If(Type("N")=="N",n,0)
Local nConLin   := 0           
Local _nLinha	:= 1
Local aCols     :={}
Local aHeader   :={}  
Local _aPosic	:= {}
Local _nPosAux	:= 1
Local dMaiComp	:= CTOD("  /  /    ") 
Local nPComp	:= 0
Local nUComp	:= 0
Local cSalFin	:= ""
Local cLcFin	:= ""
Local aGet      := {"","","",""}
Local cTelefone := Alltrim(SA1->A1_DDI+" "+SA1->A1_DDD+" "+SA1->A1_TEL)
Local lSigaGE   := GetMv("MV_ACATIVO") //Integracao Gestao Educacional
Local dPRICOM   := CRIAVAR("A1_PRICOM",.F.) 
Local dULTCOM   := CRIAVAR("A1_ULTCOM",.F.) 
Local dDTULCHQ  := CRIAVAR("A1_DTULCHQ",.F.)
Local dDTULTIT  := CRIAVAR("A1_DTULTIT",.F.)
Local dDtLc   	:= CRIAVAR("A1_VENCLC",.F.) 
Local lhabili   := (aParam[13] == 1)         
Local cRISCO    := ""
Local nLC       := 0
Local nSALDUP   := 0
Local nSALDUPM  := 0
Local nLCFIN    := 0
Local nMATR     := 0
Local nSALFIN   := 0
Local nSALFINM  := 0
Local nMETR     := 0
Local nMCOMPRA  := 0
Local nMSALDO   := 0          
Local nCHQDEVO  := 0
Local nTITPROT  := 0 
Local nAlt		:= 0
Local nLarg		:= 0
                      
Private nValAcu	:= SA1->A1__VALACU
Private cDtAcu	:= SA1->A1__DTACU
Private nCasas  	:= GetMv("MV_CENT")
Private nMcusto   	:= Iif(SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val(GetMv("MV_MCUSTO")))         
Private aTmpFil		:= {}
Private aSelFil 	:= {} //AdmGetFil(.F.,.T.,"SE1")

Default cCliente := ""
Default cLoja	:= ""

If!(Empty(cCliente))
	DbSelectArea("SA1")
	If !Dbseek(xFilial("SA1")+cCliente+cLoja)
		Alert("Cliente não Localizado")
		Return	
	EndIf
EndIf

SX3->(DbSetOrder(2))
cLcFin	:=	If(SX3->(DbSeek("A1_LCFIN")) ,X3Titulo(),STR0076)
cSalFin  := If(SX3->(DbSeek("A1_SALFIN")),X3Titulo(),STR0075)
cMoeda  		:= " "+Pad(Getmv("MV_SIMB"+Alltrim(STR(nMCusto))),4)

For nX := 1 To Len(aGrpUsr)
	If(Alltrim(aGrpUsr[nX]) $ GetMV("MV__USRFIN") )
		_lUsrFin := .T.
		Exit
	EndIf
Next nX

If aParam[13] == 1
	nLC      := SA1->A1_LC
	dPRICOM  := SA1->A1_PRICOM
	nSALDUP  := SA1->A1_SALDUP
	nSALDUPM := SA1->A1_SALDUPM
	dULTCOM  := SA1->A1_ULTCOM       
	nLCFIN   := SA1->A1_LCFIN       
	nMATR    := SA1->A1_MATR                 
	nSALFIN  := SA1->A1_SALFIN  
	nSALFINM := SA1->A1_SALFINM              
	nMETR    := SA1->A1_METR 
	nMCOMPRA := SA1->A1_MCOMPRA        
	cRISCO   := SA1->A1_RISCO
	nMSALDO  := SA1->A1_MSALDO
	nCHQDEVO := SA1->A1_CHQDEVO
	dDTULCHQ := SA1->A1_DTULCHQ
	nTITPROT := SA1->A1_TITPROT
	dDTULTIT := SA1->A1_DTULTIT
	dDtLc	 := SA1->A1_VENCLC
Else
	Fc010Loja(@nLC,@dPRICOM,@nSALDUP,@nSALDUPM,@dULTCOM,@nLCFIN,@nMATR,@nSALFIN,@nSALFINM,@nMETR,@nMCOMPRA,@cRISCO,@nMSALDO,@nCHQDEVO,@dDTULCHQ,@nTITPROT,@dDTULTIT)
Endif

If aParam[17] == 1
	aSelFil := AdmGetFil(.F.,.F.,"SE1")
Else
	aSelFil := {cFilAnt}
EndIf

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

aHeader	:= {STR0077,STR0078,"Em"," ",STR0077,STR0078,"Em"}  
 
If Select("TRB_SA1") > 0
	DbSelectArea("TRB_SA1")
	DbCloseArea()
EndIf

//Data da Maior compra
_cQuery := "SELECT * " + Chr(13)
_cQuery += "FROM " + RetSqlName("SF2") + " SF2 " + Chr(13)
_cQuery += "WHERE SF2.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "      AND F2_CLIENTE = '" + SA1->A1_COD + "'" + Chr(13)
_cQuery += "      AND F2_VALBRUT = " + Alltrim(Str(SA1->A1_MCOMPRA)) + " " + Chr(13)
_cQuery += "      AND F2_TIPO = 'N' " + Chr(13)
TcQuery _cQuery New Alias "TRB_SA1"
TcSetField("TRB_SA1", "F2_EMISSAO"  , "D", 08, 0)

If !(eof())
	dMaiComp := TRB_SA1->F2_EMISSAO  
EndIf

DbCloseArea()

//Valor da Primeira Compra
_cQuery := "SELECT * " + Chr(13)
_cQuery += "FROM " + RetSqlName("SF2") + " SF2 " + Chr(13)
_cQuery += "WHERE SF2.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "      AND F2_CLIENTE = '" + SA1->A1_COD + "'" + Chr(13)
_cQuery += "      AND F2_EMISSAO = '" + DTOS(SA1->A1_PRICOM) + "' " + Chr(13)
_cQuery += "      AND F2_TIPO = 'N' " + Chr(13)
TcQuery _cQuery New Alias "TRB_SA1"

If !(eof())
	nPComp	:= TRB_SA1->F2_VALBRUT
EndIf

DbCloseArea()

//Valor da Ultima Compra
_cQuery := "SELECT * " + Chr(13)
_cQuery += "FROM " + RetSqlName("SF2") + " SF2 " + Chr(13)
_cQuery += "WHERE SF2.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "      AND F2_CLIENTE = '" + SA1->A1_COD + "'" + Chr(13)
_cQuery += "      AND F2_EMISSAO = '" + DTOS(SA1->A1_ULTCOM) + "' " + Chr(13)
_cQuery += "      AND F2_TIPO = 'N' " + Chr(13)
TcQuery _cQuery New Alias "TRB_SA1"

If !(eof())
	nUComp	:= TRB_SA1->F2_VALBRUT
EndIf

DbCloseArea()

//LIMITE DE CREDITO # PRIMEIRA COMPRA
Aadd(aCols,{STR0014,;
			IIF(_lUsrFin,TRansform(Round(Noround(xMoeda(nLC, nMcusto, 1,dDataBase,MsDecimais(1)+1),2),MsDecimais(1)),PesqPict("SA1","A1_LC",14,1)),""),;
			IIF(_lUsrFin,SPACE(07)+DtoC(dDtLc),""),;
			" ",;
			If(lSigaGE,STR0111,STR0015),;
			Transform(nPComp,"@E 999,999,999.99"),;
			SPACE(07)+DtoC(dPRICOM)}) // LIMITE DE CREDITO # Primeira Parcela / Primeira Compra 
//SALDO # ULTIMA COMPRA
Aadd(aCols,{if(lSigaGE,STR0109,STR0010),;
			TRansform(nSALDUP,PesqPict("SA1","A1_SALDUP",14,1) ),;
            " ",;
			" ",;
			if(lSigaGE,STR0112,STR0016),;
			Transform(nUComp,"@E 999,999,999.99"),;
			SPACE(07)+DtoC(dULTCOM)}) // Valor Parcelas / Saldo  / Ultima Parcela / Ultima Compra
//Limite de credito secundario # MAIOR ATRASO
Aadd(aCols,{cLcFin,;
			TRansform(Round(Noround(xMoeda(nLCFIN,nMcusto,1,dDatabase,MsDecimais(1)+1),2),MsDecimais(1)),PesqPict("SA1","A1_LCFIN",14,1)),;     
            " ",;
            " ",;
            STR0017,;
            Transform(nMATR,PesqPict("SA1","A1_MATR",14)),;
            " "}) // Limite sec / Maior Atraso    
//SAldo do limite de credito secundario $ media de Atraso
Aadd(aCols,{cSalFin,;
   		   TRansform(nSALFIN,PesqPict("SA1","A1_SALFIN",14,1)),;
           " ",;
           " ",;
           STR0018,;
           PADC(STR(nMETR,7,2),22),;
           " "}) // Saldo em Cheque / Media de Atraso
//Maior Compra # Grau de risco
Aadd(aCols,{if(lSigaGE,STR0110,STR0011),;
			TRansform(Round(Noround(xMoeda(nMCOMPRA, nMcusto ,1, dDataBase,MsDecimais(1)+1),2),MsDecimais(1)),PesqPict("SA1","A1_MCOMPRA",14,1) ) ,;
			SPACE(07)+DtoC(dMaiComp),;
            " ",;
            STR0019,;
            SPACE(25)+cRISCO,;
            " "}) // Maior Compra / Grau de Risco
//MAior Saldo
Aadd(aCols,{STR0012,;
			TRansform(Round(Noround(xMoeda(nMSALDO, nMcusto ,1, dDataBase,MsDecimais(1)+1 ),2),MsDecimais(1)),PesqPict("SA1","A1_MSALDO",14,1)),;
            " ",;
            " ",;
            " ",;
            " ",;
            " "}) //Maior saldo
 
            
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 To aSize[6],740 OF oMainWnd PIXEL 

nAlt  := (oDlg:nClientHeight / 2) - 28
nLarg := (oDlg:nClientWidth  / 2)

_aPosic := {{nAlt-14,002},;
			{nAlt	,002},;
			{nAlt-14,064},;
			{nAlt	,064},;
			{nAlt-14,126},;
			{nAlt	,126},;
			{nAlt-14,188},;
			{nAlt	,188},;
			{nAlt-14,250},;
			{nAlt	,250},;
			{nAlt-14,312},;
			{nAlt	,312}}

//@ _nLinha,002 TO _nLinha+043, 267 OF oDlg	PIXEL ORIGINAL
@ _nLinha,002 TO _nLinha+083, 267 OF oDlg	PIXEL //TESTE RAFAEL
@ _nLinha,273 TO _nLinha+043, 364 OF oDlg	PIXEL
_nLinha+= 3

If lSigaGE
	
	DbSelectArea("JA2")
	DbSetOrder( 5 )
	dbSeek(xFilial("JA2")+SA1->A1_COD+SA1->A1_LOJA)
	
	@ _nLinha,005 SAY STR0108 SIZE 050,07          OF oDlg PIXEL	// Registro Academico
	@ _nLinha,105 SAY STR0008 			 SIZE 025,07 OF oDlg PIXEL //"Nome"
	@ _nLinha,280 SAY "Mes/Ano"			 SIZE 035,07 OF oDlg PIXEL 
	@ _nLinha,315 SAY "Maior Acúmulo"	 SIZE 035,07 OF oDlg PIXEL 
	_nLinha+= 6

	@ _nLinha,004 GET JA2->JA2_NUMRA 		SIZE 075,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,105 MSGET SA1->A1_NOME     SIZE 150,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,280 MSGET cDtAcu     		 SIZE 030,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,315 MSGET nValAcu     	 SIZE 045,09 WHEN .F. OF oDlg PIXEL PICTURE "@E 999,999,999.99"
Else
	
   If aParam[13] == 1  //Considera loja		
		@ _nLinha,077 SAY STR0007 SIZE 020,07          OF oDlg PIXEL //"Loja"
	Endif
	@ _nLinha,105 SAY STR0008 			 SIZE 025,07 OF oDlg PIXEL //"Nome"
	@ _nLinha,005 SAY STR0006 SIZE 025,07          OF oDlg PIXEL //"Codigo"
	_nLinha+= 2
	@ _nLinha,280 SAY "Mes/Ano"			 SIZE 035,07 OF oDlg PIXEL 
	@ _nLinha,315 SAY "Maior Acúmulo"	 SIZE 035,07 OF oDlg PIXEL 
	_nLinha+= 6

   If aParam[13] == 1  //Considera loja		
		@ _nLinha,077 MSGET SA1->A1_LOJA     SIZE 021,09 WHEN .F. OF oDlg PIXEL
	Endif
	@ _nLinha,004 MSGET SA1->A1_COD      SIZE 070,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,105 MSGET SA1->A1_NOME     SIZE 150,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,280 MSGET cDtAcu     		 SIZE 030,09 WHEN .F. OF oDlg PIXEL
	@ _nLinha,315 MSGET nValAcu     	 SIZE 045,09 WHEN .F. OF oDlg PIXEL PICTURE "@E 999,999,999.99"
	
EndIf

_nLinha+= 11
@ _nLinha,005 SAY cCGC    SIZE 025,07 OF oDlg PIXEL
@ _nLinha,077 SAY STR0009 SIZE 025,07 OF oDlg PIXEL //"Telefone"
@ _nLinha,141 SAY RetTitle("A1_VENCLC")  SIZE 035,07 OF oDlg PIXEL
If ! lSigaGE
	@ _nLinha,206 SAY STR0057 SIZE 035,07 OF oDlg PIXEL //"Vendedor"
EndIf
_nLinha+= 5
@ _nLinha,285 BUTTON "Processar" 	 SIZE 060,12 FONT oDlg:oFont ACTION (ProcAcum(),oDlg:Refresh()) OF oDlg PIXEL
_nLinha+= 2

If cPaisLoc=="BRA"
	@ _nLinha,004 MSGET SA1->A1_CGC      SIZE 070,09 PICTURE StrTran(PicPes(SA1->A1_PESSOA),"%C","") WHEN .F. OF oDlg PIXEL
Else
	@ _nLinha,004 MSGET SA1->A1_CGC      SIZE 070,09 PICTURE PesqPict("SA1","A1_CGC") WHEN .F. OF oDlg PIXEL

EndIf
@ _nLinha,077 MSGET cTelefone	       SIZE 060,09 WHEN .F. OF oDlg PIXEL
@ _nLinha,141 MSGET SA1->A1_VENCLC       SIZE 060,09 WHEN .F. OF oDlg PIXEL
If ! lSigaGE
	@ _nLinha,206 MSGET SA1->A1_VEND  	 SIZE 053,09 WHEN .F. OF oDlg PIXEL
EndIf

//ADICIONADO POR RAFAEL DOMINGUES - 07/04/2015
//INICIO
_nLinha+= 11

@ _nLinha,004 SAY "Nome Fantasia"		SIZE 060,07 OF oDlg PIXEL
@ _nLinha+7,004 MSGET SA1->A1_NREDUZ	SIZE 130,09 WHEN .F. OF oDlg PIXEL

@ _nLinha,141 SAY "Inscr. Estadual"		SIZE 045,07 OF oDlg PIXEL
@ _nLinha+7,141 MSGET SA1->A1_INSCR		SIZE 060,09 WHEN .F. OF oDlg PIXEL

@ _nLinha,206 SAY "Cliente Desde"	SIZE 060,07 OF oDlg PIXEL
@ _nLinha+7,206 MSGET DtoC(SA1->A1_PRICOM)	SIZE 053,09 WHEN .F. OF oDlg PIXEL

_nLinha+= 18

@ _nLinha,004 SAY "Município"		SIZE 060,07 OF oDlg PIXEL
@ _nLinha+7,004 MSGET SA1->A1_MUN	SIZE 130,09 WHEN .F. OF oDlg PIXEL

@ _nLinha,141 SAY "UF"				SIZE 025,07 OF oDlg PIXEL
@ _nLinha+7,141 MSGET SA1->A1_EST	SIZE 019,09 WHEN .F. OF oDlg PIXEL

//FIM - RAFAEL DOMINGUES
//_nLinha+= 94 ORIGINAL
_nLinha+= 104

//oLbx := RDListBox(3.5, .42, 363, 70, aCols, aHeader,{38,51,51,11,50,63})   ORIGINAL
oLbx := RDListBox(6.5, .42, 363, 70, aCols, aHeader,{38,51,51,11,50,63})

@ _nLinha,002 SAY STR0020 SIZE 061,07 OF oDlg PIXEL //"Cheques Devolvidos"
@ _nLinha,121 SAY STR0021 SIZE 061,07 OF oDlg PIXEL //"Titulos Protestados"
_nLinha+= 6

//DESENHA AS BORDAS DO CHEQUE DEVOLVIDO E TITULO PROTESTADO
@ _nLinha,002 TO _nLinha+024, 114 OF oDlg	PIXEL
@ _nLinha,121 TO _nLinha+024, 257 OF oDlg	PIXEL
_nLinha+= 3

@ _nLinha,005 SAY STR0022 SIZE 034,07 OF oDlg PIXEL //"Quantidade"
@ _nLinha,045 SAY STR0023 SIZE 066,07 OF oDlg PIXEL //"Ultimo Devolvido"
@ _nLinha,126 SAY STR0022 SIZE 034,07 OF oDlg PIXEL //"Quantidade"
@ _nLinha,163 SAY STR0024 SIZE 076,07 OF oDlg PIXEL //"Ultimo Protesto"
_nLinha+= 8

@ _nLinha,006 MSGET nCHQDEVO SIZE 024,08 WHEN .F. OF oDlg PIXEL
@ _nLinha,045 MSGET dDTULCHQ SIZE 050,08 WHEN .F. OF oDlg PIXEL
@ _nLinha,126 MSGET nTITPROT SIZE 024,08 WHEN .F. OF oDlg PIXEL
@ _nLinha,163 MSGET dDTULTIT SIZE 050,08 WHEN .F. OF oDlg PIXEL

//RAFAEL DOMINGUES - 07/04/15

//QUERY PARA BUSCAR O TOTAL DE TITULOS EM ATRASO
_cQuery := " SELECT COUNT(*) QTDE, SUM(E1_VALOR) VALOR FROM "+RetSqlName("SE1") +Chr(13)
_cQuery += " WHERE D_E_L_E_T_ = '' "
_cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' " +Chr(13)
_cQuery += " AND E1_LOJA = '"+SA1->A1_LOJA+"' " +Chr(13)
_cQuery += " AND E1_TIPO = 'NF' AND E1_BAIXA = '' "
TcQuery _cQuery New Alias "TRB"

DbSelectArea("TRB")
DbGoTop()

nQtAtr	:= TRB->QTDE
nTotAtr := TRB->VALOR

DbCloseArea()

//EM DESENVOLVIMENTO
/*
//QUERY PARA BUSCAR O TOTAL DE TITULOS NEGOCIADOS
SELECT COUNT(*) QTDE, SUM(E1_VALOR) FROM SE1010
WHERE D_E_L_E_T_ = ''
AND E1_CLIENTE = '86692381'
AND E1_LOJA = '132'
AND E1_TIPO = 'NF'
AND E1_BAIXA = ''
*/

nQtNe	:= 0
nTotNe  := 0

//QUERY PARA BUSCAR O TOTAL DE TITULOS EM ABERTO
_cQuery := " SELECT COUNT(*) QTDE, SUM(E1_VALOR) VALOR FROM "+RetSqlName("SE1") +Chr(13)
_cQuery += " WHERE D_E_L_E_T_ = '' "+Chr(13)
_cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' " +Chr(13)
_cQuery += " AND E1_LOJA = '"+SA1->A1_LOJA+"' " +Chr(13)
_cQuery += " AND E1_TIPO = 'NF' AND E1_BAIXA <> '' "
TcQuery _cQuery New Alias "TRB"

DbSelectArea("TRB")
DbGoTop()

nQtAb	:= TRB->QTDE
nTotAb  := TRB->VALOR

DbCloseArea()

_nLinha-= 11
@ _nLinha,265 SAY "Atraso" SIZE 034,09 OF oDlg PIXEL
@ _nLinha,295 MSGET nQtAtr SIZE 010,09 WHEN .F. OF oDlg PIXEL
@ _nLinha,325 MSGET nTotAtr SIZE 045,09 WHEN .F. OF oDlg PIXEL
@ _nLinha+14,265 SAY "Negociado" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+14,295 MSGET nQtNe SIZE 010,09 WHEN .F. OF oDlg PIXEL
@ _nLinha+14,325 MSGET nTotNe SIZE 045,09 WHEN .F. OF oDlg PIXEL
@ _nLinha+28,265 SAY "A Vencer" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+28,295 MSGET nQtAb SIZE 010,09 WHEN .F. OF oDlg PIXEL
@ _nLinha+28,325 MSGET nTotAb SIZE 045,09 WHEN .F. OF oDlg PIXEL

//ADICIONADO POR RAFAEL DOMINGUES EM 07/04/2015
//DESENHA AS BORDAS DO CHEQUE DEVOLVIDO E TITULO PROTESTADO
//_nLinha+= 20
//@ _nLinha,002 TO _nLinha+024, 267 OF oDlg	PIXEL
//_nLinha+= 3

_nLinha+= 31

//QUERY PARA BUSCAR O TOTAL DOS PEDIDOS
_cQuery := " SELECT SUM(C6_VALOR) TOTPED FROM "+RetSqlName("SC6") +Chr(13)
_cQuery += " WHERE D_E_L_E_T_ = '' "+Chr(13)
_cQuery += " AND C6_CLI = '"+SA1->A1_COD+"' " +Chr(13)
_cQuery += " AND C6_LOJA = '"+SA1->A1_LOJA+"' " +Chr(13)
TcQuery _cQuery New Alias "TRB"

DbSelectArea("TRB")
DbGoTop()

nTotPed	:= TRB->TOTPED

DbCloseArea()

nTotal := nTotAtr+nTotNe+nTotAb
nSaldo := nLC-nTotPed-nTotal

@ _nLinha,005 SAY "Total" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+7,005 MSGET nTotal SIZE 055,09 WHEN .F. OF oDlg PIXEL
@ _nLinha,070 SAY "Tot.Pedido" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+7,070 MSGET nTotPed SIZE 055,09 WHEN .F. OF oDlg PIXEL
@ _nLinha,135 SAY "Lim.Crédito" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+7,135 MSGET nLC SIZE 055,09 WHEN .F. OF oDlg PIXEL
@ _nLinha,200 SAY "Saldo" SIZE 034,09 OF oDlg PIXEL
@ _nLinha+7,200 MSGET nSaldo SIZE 055,09 WHEN .F. OF oDlg PIXEL


//@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON Iif(lSigaGE,STR0105,STR0025) SIZE 60,12 FONT oDlg:oFont ACTION ( Fc010Brow(1,@aAlias,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Aberto" / "Tit Aberto"
@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON Iif(lSigaGE,STR0105,STR0025) SIZE 60,12 FONT oDlg:oFont ACTION ( U_FC010BOL(1,@aAlias,@aAlias1,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Aberto" / "Tit Aberto"
_nPosAux += 1
//@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON Iif(lSigaGE,STR0123,STR0122) SIZE 60,12 FONT oDlg:oFont ACTION ( FC010Brow(2,@aAlias,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Pago" / "Tit Recebidos"
@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON Iif(lSigaGE,STR0123,STR0122) SIZE 60,12 FONT oDlg:oFont ACTION ( U_FC010BOL(2,@aAlias,@aAlias1,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Pago" / "Tit Recebidos"
_nPosAux += 1

If ! lSigaGE
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0027 SIZE 60,12 FONT oDlg:oFont ACTION Fc010Brow(3,@aAlias,aParam,.T.,aGet)	OF oDlg PIXEL //"Pedidos"
	_nPosAux += 1
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0028 SIZE 60,12 FONT oDlg:oFont ACTION Fc010Brow(4,@aAlias,aParam,.T.,aGet)	OF oDlg PIXEL //"Faturamento"
	_nPosAux += 1
Else
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0107 SIZE 60,12 ACTION ACAR590(JA2->JA2_NUMRA) OF oDlg PIXEL  // "Extrato"
EndIf

//@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0059 SIZE 60,12 FONT oDlg:oFont ACTION Mata030Ref("SA1",SA1->(Recno()),2) WHEN lhabili OF oDlg PIXEL //"Referencias"
//_nPosAux += 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O modulo de call center não esta disponivel em Pyme, portanto nao exibe o botao do historico de cobranca³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If !__lPyme 
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0095 SIZE 60,12 FONT oDlg:oFont ACTION TmkC020() WHEN lhabili OF oDlg PIXEL //Historico de Cobranca
	_nPosAux += 1
Endif*/	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O Ecossistema nao esta disponivel em Pyme, portanto nao exibe o botao de consulta a credito             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If !__lPyme 
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0114 SIZE 60,12 FONT oDlg:oFont ACTION Fc010Eco() MESSAGE STR0115 WHEN lhabili OF oDlg PIXEL // "Credito", "Ecossistema - Consulta a credito" 
	_nPosAux += 1
Endif*/

If Trim(GetMV("MV_VEICULO")) == "S"
   @ 043+nConLin,272 BUTTON STR0058 SIZE 60,12 FONT oDlg:oFont ACTION FG_SALOSV(SA1->A1_COD,SA1->A1_LOJA,," ","T") OF oDlg PIXEL  //"OSs em Aberto"
	_nPosAux += 1
EndIf   

If _lUsrFin
	@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON "Alt Dados" SIZE 60,12 FONT oDlg:oFont ACTION (AltDad()) OF oDlg PIXEL
	_nPosAux += 1
EndIf

//ADICIONADO POR RAFAEL DOMINGUES - 07/04/2015
@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON "Observação Cliente" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC02(SA1->A1_COD,SA1->A1_LOJA)  OF oDlg PIXEL //"Observacao Cliente"
_nPosAux += 1

//ADICIONADO POR RAFAEL DOMINGUES - 10/04/2015
@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON "Compras Mensais" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC03(SA1->A1_COD,SA1->A1_LOJA)  OF oDlg PIXEL //"Compras mensais"
_nPosAux += 1

//ADICIONADO POR RAFAEL DOMINGUES - 28/04/2015
@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON "Cons. Tít. Por Cliente" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC04()  OF oDlg PIXEL //"Consulta Titulo"
_nPosAux += 1

//ADICIONADO POR RAFAEL DOMINGUES - 28/04/2015
//@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON "Negociação" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC05()  OF oDlg PIXEL //"Negociação"
//_nPosAux += 1

@ _aPosic[_nPosAux][1],_aPosic[_nPosAux][2] BUTTON STR0031 SIZE 60,12 FONT oDlg:oFont ACTION oDlg:End() 	OF oDlg PIXEL //"Sair"
ACTIVATE MSDIALOG oDlg CENTERED


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade dos Dados                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aSavAHead
aCols   := aSavaCol
N       := nSavN
aEval(aAlias,{|x| (x[1])->(dbCloseArea()),Ferase(x[2]+GetDBExtension()),Ferase(x[2]+OrdBagExt())})
aEval(aAlias1,{|x| (x[1])->(dbCloseArea()),Ferase(x[2]+GetDBExtension()),Ferase(x[2]+OrdBagExt())})
dbSelectArea("SA1")
RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fc010Loja ºAutor  ³Microsiga           º Data ³  12/30/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega as variaveis com todos os valores da empresa        º±±
±±º          ³selecionada                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc010                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fc010Loja(nLC,dPRICOM,nSALDUP,nSALDUPM,dULTCOM,nLCFIN,nMATR,nSALFIN,nSALFINM,nMETR,nMCOMPRA,cRISCO,nMSALDO,nCHQDEVO,dDTULCHQ,nTITPROT,dDTULTIT)

Local nRecSA1 := SA1->(Recno())
Local cCod := SA1->A1_COD
Local cChave := xFilial("SA1") + cCod         
Local aAreaSA1 := SA1->(GetArea())

SA1->(DbSetOrder(1))
SA1->(DbSeek(cChave))
While cChave == (xFilial("SA1") + SA1->A1_COD)
	nLC      += SA1->A1_LC
	nSALDUP  += SA1->A1_SALDUP
	nSALDUPM += SA1->A1_SALDUPM
	nLCFIN   += SA1->A1_LCFIN       
	nSALFIN  += SA1->A1_SALFIN  
	nSALFINM += SA1->A1_SALFINM              
	If nMCOMPRA < SA1->A1_MCOMPRA
		nMCOMPRA := SA1->A1_MCOMPRA        
	Endif
	If nMSALDO < SA1->A1_MSALDO
		nMSALDO := SA1->A1_MSALDO
	Endif       
	If cRISCO < SA1->A1_RISCO
		cRISCO := SA1->A1_RISCO
	Endif
	If nMETR < SA1->A1_METR 
		nMETR := SA1->A1_METR 
	Endif
	If nMATR < SA1->A1_MATR
		nMATR := SA1->A1_MATR
	Endif                 
   If dULTCOM < SA1->A1_ULTCOM       
		dULTCOM := SA1->A1_ULTCOM       
	Endif
   If Empty(dPRICOM) .Or. dPRICOM > SA1->A1_PRICOM
		dPRICOM :=SA1->A1_PRICOM
	Endif
  	nCHQDEVO += SA1->A1_CHQDEVO
  	nTITPROT += SA1->A1_TITPROT
   If dDTULCHQ < SA1->A1_DTULCHQ
   	dDTULCHQ := SA1->A1_DTULCHQ
   Endif
   If dDTULTIT < SA1->A1_DTULTIT
   	dDTULTIT := SA1->A1_DTULTIT
   Endif
	SA1->(DbSkip())
EndDo

RestArea(aAreaSA1)
SA1->(dbGoTo(nRecSA1))

Return             


/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | AltDad  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Março/2015    |
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Altera dados do cliente													   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/

Static Function AltDad()       
Local oDlgTMP, oCombo1, oCombo2
Local _nLinha 	:= 5
Local _aStru	:= {010,060,120,170}
Local nAlt		:= 0
Local nLarg		:= 0    
Local _lRet		:= .F.
Local aItens	:= Separa(Posicione("SX3",2,"A1__RESTRI","X3_CBOX"),";")
Local aItens2	:= Separa(Posicione("SX3",2,"A1_RISCO","X3_CBOX"),";")
Local cInad		:= SA1->A1__RESTRI
Local cRisc		:= SA1->A1_RISCO
Local nLC		:= SA1->A1_LC
Local dDtLC		:= SA1->A1_VENCLC //CTOD("  /  /    ")

DEFINE MSDIALOG oDlgTMP TITLE "Alteração de dados financeiros" FROM 0,0 To 110,460 OF oMainWnd PIXEL 
nAlt  := (oDlgTMP:nClientHeight / 2) - 28
nLarg := (oDlgTMP:nClientWidth  / 2)

@ _nLinha,_aStru[1] SAY "Blq. Financ?"		 SIZE 076,07 OF oDlgTMP PIXEL 
@ _nLinha,_aStru[2] MSCOMBOBOX oCombo1 VAR cInad ITEMS aItens SIZE 050,08 OF oDlgTMP PIXEL
@ _nLinha,_aStru[3] SAY "Risco" 			 SIZE 076,07 OF oDlgTMP PIXEL 
@ _nLinha,_aStru[4] MSCOMBOBOX oCombo2 VAR cRisc ITEMS aItens2	SIZE 050,08 OF oDlgTMP PIXEL
_nLinha += 16

@ _nLinha,_aStru[1] SAY "Limite de Crédito"  SIZE 076,07 OF oDlgTMP PIXEL 
@ _nLinha,_aStru[2] MSGET nLC 				 SIZE 050,08 OF oDlgTMP PIXEL PICTURE PesqPict("SA1","A1_LC") 
@ _nLinha,_aStru[3] SAY "Venc. Lim. Crédito" SIZE 076,07 OF oDlgTMP PIXEL 
@ _nLinha,_aStru[4] MSGET dDtLC 			 SIZE 050,08 OF oDlgTMP PIXEL
_nLinha += 16

@ nAlt,nLarg-100 BUTTON "Confirmar" SIZE 40,12 ACTION (_lRet := .T.,oDlgTMP:End())  OF oDlgTMP PIXEL 
@ nAlt,nLarg-050 BUTTON "Sair" 		SIZE 40,12 ACTION oDlgTMP:End() 				OF oDlgTMP PIXEL 

ACTIVATE MSDIALOG oDlgTMP CENTERED

If _lRet
	Reclock("SA1",.F.)
		SA1->A1__INADIM	:= cInad
		SA1->A1_RISCO	:= cRisc
		SA1->A1_LC		:= nLC
		SA1->A1_VENCLC 	:= dDtLC
	SA1->(MsUnlock())
	
	oLbx:aArray[5][6] := SPACE(25)+cRisc
	oLbx:aArray[1][2] := TRansform(Round(Noround(xMoeda(nLC, nMcusto, 1,dDataBase,MsDecimais(1)+1),2),MsDecimais(1)),PesqPict("SA1","A1_LC",14,1))
	oLbx:aArray[1][3] := SPACE(07)+DtoC(dDtLC)
	
EndIf

Return _lRet

/*
+-----------+----------+-------+-------------------------------------+------+---------------+
| Programa  | ProcAcum | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Março/2015    |
+-----------+----------+-------+-------------------------------------+------+---------------+
| Descricao | Calcula período de maior acumulo do periodo selecionado					    |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA													 					    |
+-----------+-------------------------------------------------------------------------------+
*/

Static Function ProcAcum()
Local _cQuery	:= ""

If Select("TRB_SA1") > 0
	DbSelectArea("TRB_SA1")
	DbCloseArea()
EndIf

/*
_cQuery := "SELECT E1_CLIENTE, " + Chr(13)
_cQuery += "       SUBSTR(E1_VENCREA,1,6) AS PERIOD, " + Chr(13)
_cQuery += "       SUM(E1_VALOR) AS DEVENDO, " + Chr(13)
_cQuery += "       NVL(MAX(SE5R.PAGO),0) AS PAGO, " + Chr(13)
_cQuery += "       NVL(MAX(SE5P.ESTORNO),0) AS ESTORNO " + Chr(13)
_cQuery += "FROM " + RetSqlName("SE1") + " SE1  " + Chr(13)
_cQuery += "LEFT JOIN(SELECT SE5.E5_CLIENTE, " + Chr(13)
_cQuery += "                     SUBSTR(SE5.E5_DATA,1,6) AS PERIOD, " + Chr(13)
_cQuery += "                     SUM(E5_VALOR) AS PAGO " + Chr(13)
_cQuery += "            FROM " + RetSqlName("SE5") + " SE5 " + Chr(13)
_cQuery += "            INNER JOIN " + RetSqlName("SE1") + " SE1 ON SE1.E1_CLIENTE = SE5.E5_CLIENTE " + Chr(13)
_cQuery += "                                     AND SE1.E1_LOJA = SE5.E5_LOJA " + Chr(13)
_cQuery += "                                     AND SE1.E1_PREFIXO = SE5.E5_PREFIXO " + Chr(13)
_cQuery += "                                     AND SE1.E1_NUM = SE5.E5_NUMERO " + Chr(13)
_cQuery += "                                     AND SE1.E1_PARCELA = SE5.E5_PARCELA " + Chr(13)
_cQuery += "                                     AND SE1.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "            WHERE SE5.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "                  AND E5_RECPAG = 'R' " + Chr(13)
_cQuery += "            GROUP BY SUBSTR(SE5.E5_DATA,1,6), " + Chr(13)
_cQuery += "                     SE5.E5_CLIENTE) SE5R ON SE5R.E5_CLIENTE = E1_CLIENTE " + Chr(13)
_cQuery += "                                             AND SE5R.PERIOD = SUBSTR(SE1.E1_VENCREA,1,6) " + Chr(13)
_cQuery += "LEFT JOIN (SELECT SE5.E5_CLIENTE, " + Chr(13)
_cQuery += "                  SUBSTR(SE5.E5_DATA,1,6) AS PERIOD, " + Chr(13)
_cQuery += "                  SUM(E5_VALOR) AS ESTORNO " + Chr(13)
_cQuery += "          FROM " + RetSqlName("SE5") + " SE5 " + Chr(13)
_cQuery += "          INNER JOIN " + RetSqlName("SE1") + " SE1 ON SE1.E1_CLIENTE = SE5.E5_CLIENTE " + Chr(13)
_cQuery += "                                   AND SE1.E1_LOJA = SE5.E5_LOJA " + Chr(13)
_cQuery += "                                   AND SE1.E1_PREFIXO = SE5.E5_PREFIXO " + Chr(13)
_cQuery += "                                   AND SE1.E1_NUM = SE5.E5_NUMERO " + Chr(13)
_cQuery += "                                   AND SE1.E1_PARCELA = SE5.E5_PARCELA " + Chr(13)
_cQuery += "                                   AND SE1.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "          WHERE SE5.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "                AND E5_RECPAG != 'R' " + Chr(13)
_cQuery += "                AND SE5.E5_TIPODOC = 'ES' " + Chr(13)
_cQuery += "          GROUP BY SUBSTR(SE5.E5_DATA,1,6), " + Chr(13)
_cQuery += "                    SE5.E5_CLIENTE) SE5P ON SE5P.E5_CLIENTE = SE1.E1_CLIENTE " + Chr(13)
_cQuery += "                                               AND SE5P.ESTORNO = SUBSTR(SE1.E1_VENCREA,1,6) " + Chr(13)
_cQuery += "WHERE SE1.D_E_L_E_T_ = ' ' " + Chr(13)
_cQuery += "      AND E1_CLIENTE = '" + SA1->A1_COD + "' " + Chr(13)
_cQuery += "      AND E1_VENCREA >= '" + DTOS(SA1->A1_PRICOM) + "' " + Chr(13)
_cQuery += "      AND E1_TIPO = 'NF' " + Chr(13)
_cQuery += "GROUP BY SUBSTR(E1_VENCREA,1,6), " + Chr(13)
_cQuery += "         E1_CLIENTE " + Chr(13)
_cQuery += "ORDER BY (DEVENDO - (PAGO + ESTORNO)) DESC "
TcQuery _cQuery New Alias "TRB_SA1"
                            
Do While !TRB_SA1->(eof())
	If nValAcu < (TRB_SA1->DEVENDO - TRB_SA1->PAGO + TRB_SA1->ESTORNO)
		cDtAcu	:= Substr(TRB_SA1->PERIOD,5,2) + "/" + Substr(TRB_SA1->PERIOD,1,4)
		nValAcu	:= TRB_SA1->DEVENDO - TRB_SA1->PAGO + TRB_SA1->ESTORNO
	EndIf
	TRB_SA1->(DbSkip())
EndDo

Reclock("SA1",.F.)
	SA1->A1__DTACU  := cDtAcu
	SA1->A1__VALACU := nValAcu
MsUnlock()

TRB_SA1->(DbCloseArea())
*/

_cQuery := " SELECT SUM(CASE WHEN E1_TIPO = 'NCC' THEN (E1_SALDO * -1) ELSE E1_SALDO END) ABERTO FROM "+ RetSqlName("SE1")
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND E1_BAIXA = ' ' "
_cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' "
TcQuery _cQuery New Alias "TRB_SA1"
                            
Do While !TRB_SA1->(eof())
	If TRB_SA1->ABERTO > SA1->A1__VALACU
		Reclock("SA1",.F.)
			SA1->A1__DTACU  := Substr(DtoS(dDataBase),5,2) + "/" + Substr(DtoS(dDataBase),1,4)
			SA1->A1__VALACU := TRB_SA1->ABERTO
			
			cDtAcu  := SA1->A1__DTACU
			nValAcu := SA1->A1__VALACU
		MsUnlock()
	EndIf
	
	TRB_SA1->(DbSkip())
EndDo

TRB_SA1->(DbCloseArea())

Return