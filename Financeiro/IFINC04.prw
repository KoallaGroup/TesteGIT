#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ IFINC04  ≥ Autor ≥ Rafael Domingues - ANADI ≥ Data ≥ 23/04/15 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Tela consulta titulos                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ IFINC04()                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Especifico Isapa                                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function IFINC04()

Local aAreaSA1 := SA1->(GetArea())

Private oDlgMain    := Nil
Private oListBox     := Nil
Private oCheck       := Nil
Private aCoordenadas := MsAdvSize(.T.)
Private nOpcClick    := 0
Private lEdicao      := .T.
Private aTitulos     := {}
Private lCheck1      := .F.
Private lCheck2      := .F.
Private lCheck3      := .F.
Private lCheck4      := .F.
Private lCheck5      := .F.
Private lCheck6      := .F.
Private cCodCli      := Space(TamSX3("A1_COD")[1])
Private cNomeCli     := Space(TamSX3("A1_NOME")[1])
Private cBanco       := Space(TamSX3("A6_COD")[1])
Private cDescBco     := Space(TamSX3("A6_NOMEAGE")[1])
Private cTpCob       := Space(04) //Space(TamSX3("E1__TPCOBR")[1])
Private cDesTpC      := Space(TamSX3("ZX5_DSCITE")[1])
Private cCodSit      := Space(02)
Private cDesSit      := Space(TamSX3("A6_NOMEAGE")[1])
Private cCodSeg      := Space(TamSX3("Z7_CODIGO")[1])
Private cDesSeg      := Space(TamSX3("Z7_DESCRIC")[1])
Private dEmisDe      := dDatabase
Private dEmisAt      := dDatabase
Private dVencDe      := dDatabase
Private dVencAt      := dDatabase
Private nSalDe       := 0
Private nSalAte      := 999999999999
Private nValDe       := 0
Private nValAte      := 999999999999
Private nVencid      := 0
Private dDataB       := dDatabase
Private nJuros       := 0

//Desenha a Tela
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Consulta de TÌtulos"),,,,,,,,oMainWnd,.T.)
	TGroup():New(004,003,120,oDlgMain:nClientWidth/2-5,"Par‚metros:",oDlgMain,,,.T.)
		TSay():New(014,008,{||"Cliente: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 014,045 MsGet cCodCli Of oDlgMain F3 "SA1" Valid(Empty(cCodCli) .or. Iif(ExistCpo("SA1",cCodCli),(cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli,"SA1->A1_NOME"),.T.),.F.)) PIXEL SIZE 70,009 When lEdicao
		@ 014,115 MsGet cNomeCli Of oDlgMain PIXEL SIZE 150,009 When .F.
		
		TSay():New(029,008,{||"Banco: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 029,045 MsGet cBanco Of oDlgMain F3 "SA6" Valid(Empty(cBanco) .or. Iif(ExistCpo("SA6",cBanco),(cDescBco := Posicione("SA6",1,xFilial("SA6")+cBanco,"SA6->A6_NOME"),.T.),.F.)) PIXEL SIZE 020,009 When lEdicao
		@ 029,080 MsGet cDescBco Of oDlgMain PIXEL SIZE 100,009 When .F.
				
		TSay():New(044,008,{||"Tp CobranÁa: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 044,045 MsGet cTpCob Of oDlgMain F3 "ZX5TPC" Valid(Empty(cTpCob) .or. Iif(!Empty(cTpCob),(cDesTpC := Posicione("ZX5",1,"  "+"  "+"000010"+cTpCob,"ZX5->ZX5_DSCITE"),.T.),.F.)) PIXEL SIZE 020,009 When lEdicao //Valid(Iif(ExistCpo("ZX5",cTpCob),(cDesTpC := Posicione("ZX5",1,xFilial("ZX5")+xFilial("ZX5")+"000010"+cTpCob,"ZX5->ZX5_DSCITE"),.T.),.F.)) PIXEL SIZE 020,009 When lEdicao
		@ 044,080 MsGet cDesTpC Of oDlgMain PIXEL SIZE 100,009 When .F.
		
		TSay():New(059,008,{||"SituaÁ„o: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 059,045 MsGet cCodSit Of oDlgMain F3 "07" Valid(Empty(cCodSit) .or. Iif(!Empty(cCodSit),(cDesSit := Posicione("SX5",1,xFilial("SX5")+"07"+cCodSit,"SX5->X5_DESCRI"),.T.),.F.)) PIXEL SIZE 020,009 When lEdicao
		@ 059,080 MsGet cDesSit Of oDlgMain PIXEL SIZE 100,009 When .F.
		
		TSay():New(074,008,{||"Segmento: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 074,045 MsGet cCodSeg Of oDlgMain F3 "SZ7" Valid(Empty(cCodSeg) .or. Iif(ExistCpo("SZ7",cCodSeg),(cDesSeg := Posicione("SZ7",1,xFilial("SZ7")+cCodSeg,"SZ7->Z7_DESCRIC"),.T.),.F.)) PIXEL SIZE 020,009 When lEdicao
		@ 074,085 MsGet cDesSeg Of oDlgMain PIXEL SIZE 100,009 When .F.
		
		TSay():New(089,008,{||"Emiss„o De: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 089,045 MsGet dEmisDe Of oDlgMain PIXEL SIZE 050,009 When lEdicao
		
		TSay():New(089,128,{||"Emiss„o AtÈ: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 089,170 MsGet dEmisAt Of oDlgMain PIXEL SIZE 050,009 When lEdicao
		
		TSay():New(089,248,{||"Vencimento De: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 089,290 MsGet dVencDe Of oDlgMain PIXEL SIZE 050,009 When lEdicao
		
		TSay():New(089,368,{||"Vencimento AtÈ: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 089,410 MsGet dVencAt Of oDlgMain PIXEL SIZE 050,009 When lEdicao
		
		TSay():New(104,008,{||"Valor De: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 104,045 MsGet nValDe Picture PesqPict("SE1","E1_VALOR") Of oDlgMain PIXEL SIZE 060,009 When lEdicao
		
		TSay():New(104,128,{||"Valor AtÈ: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 104,170 MsGet nValAte Picture PesqPict("SE1","E1_VALOR") Of oDlgMain PIXEL SIZE 060,009 When lEdicao
		
		TSay():New(104,248,{||"Saldo De: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 104,290 MsGet nSalDe Picture PesqPict("SE1","E1_VALOR") Of oDlgMain PIXEL SIZE 060,009 When lEdicao
		
		TSay():New(104,368,{||"Saldo AtÈ: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 104,410 MsGet nSalAte Picture PesqPict("SE1","E1_VALOR") Of oDlgMain PIXEL SIZE 060,009 When lEdicao
		
		TSay():New(014,530,{||"Vencidos Acima de: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 014,590 MsGet nVencid Picture "999" Of oDlgMain PIXEL SIZE 030,009 When lEdicao
		
		TSay():New(029,530,{||"DataBase: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 029,560 MsGet dDataB Of oDlgMain PIXEL SIZE 050,009 When lEdicao
		
		TSay():New(044,530,{||"Perc. Juros MÍs: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 044,580 MsGet nJuros Picture "999.99" Of oDlgMain PIXEL SIZE 030,009 When lEdicao
		
		oCheck1 := TCheckBox():New(014,330,'TÌtulos em Aberto',,oDlgMain, 100,210,,,,,,,,.T.,,,)
		oCheck2 := TCheckBox():New(024,330,'TÌtulos Quitados',,oDlgMain, 100,210,,,,,,,,.T.,,,)
		oCheck3 := TCheckBox():New(034,330,'TÌtulos Cancelados',,oDlgMain, 100,210,,,,,,,,.T.,,,)
		oCheck4 := TCheckBox():New(044,330,'TÌtulos em Aberto - Vencidos',,oDlgMain, 100,210,,,,,,,,.T.,,,)
		oCheck5 := TCheckBox():New(054,330,'TÌtulos em Aberto - A Vencer',,oDlgMain,100,210,,,,,,,,.T.,,,)
		oCheck6 := TCheckBox():New(064,330,'TÌtulos Quitados - Pagos com Atraso',,oDlgMain,100,210,,,,,,,,.T.,,,)
		
		// Seta Eventos do Check
		oCheck1:bSetGet := {|| lCheck1 };oCheck1:bLClicked := {|| lCheck1:=!lCheck1 }	
		oCheck2:bSetGet := {|| lCheck2 };oCheck2:bLClicked := {|| lCheck2:=!lCheck2 }		
		oCheck3:bSetGet := {|| lCheck3 };oCheck3:bLClicked := {|| lCheck3:=!lCheck3 }		
		oCheck4:bSetGet := {|| lCheck4 };oCheck4:bLClicked := {|| lCheck4:=!lCheck4 }		
		oCheck5:bSetGet := {|| lCheck5 };oCheck5:bLClicked := {|| lCheck5:=!lCheck5 }		
		oCheck6:bSetGet := {|| lCheck6 };oCheck6:bLClicked := {|| lCheck6:=!lCheck6 }

	TButton():New(104,500,"Buscar",oDlgMain,{|| Processa(U_BuscaTit()) },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(104,550,"Refazer Busca",oDlgMain,{|| aTitulos := {{"","","","","","","","","","","","","","","","","","","","","","",""}},;
		oListBox:SetArray(aTitulos),;
		oListBox:bLine := {||{ 	aTitulos[oListBox:nAt][1],aTitulos[oListBox:nAt][2],aTitulos[oListBox:nAt][3],aTitulos[oListBox:nAt][4],;
								aTitulos[oListBox:nAt][5],aTitulos[oListBox:nAt][6],aTitulos[oListBox:nAt][7],aTitulos[oListBox:nAt][8],;
								aTitulos[oListBox:nAt][9],aTitulos[oListBox:nAt][10],aTitulos[oListBox:nAt][11],aTitulos[oListBox:nAt][12],;
								aTitulos[oListBox:nAt][13],aTitulos[oListBox:nAt][14],aTitulos[oListBox:nAt][15],aTitulos[oListBox:nAt][16],;
								aTitulos[oListBox:nAt][17],aTitulos[oListBox:nAt][18],aTitulos[oListBox:nAt][19],aTitulos[oListBox:nAt][20],;
								aTitulos[oListBox:nAt][21],aTitulos[oListBox:nAt][22],aTitulos[oListBox:nAt][23] }},;
								cCodCli   := Space(TamSX3("A1_COD")[1]),;
								cNomeCli  := Space(TamSX3("A1_NOME")[1]),;
								cBanco    := Space(TamSX3("A6_COD")[1]),;
								cDescBco  := Space(TamSX3("A6_NOMEAGE")[1]),;
								cTpCob    := Space(04),;
								cDesTpC   := Space(TamSX3("ZX5_DSCITE")[1]),;
								cCodSit   := Space(02),;
								cDesSit   := Space(TamSX3("A6_NOMEAGE")[1]),;
								cCodSeg   := Space(TamSX3("Z7_CODIGO")[1]),;
								cDesSeg   := Space(TamSX3("Z7_DESCRIC")[1]),;
								dEmisDe   := dDatabase,;
								dEmisAt   := dDatabase,;
								dVencDe   := dDatabase,;
								dVencAt   := dDatabase,;
								nSalDe    := 0,;
								nSalAte   := 999999999999,;
								nValDe    := 0,;
								nValAte   := 999999999999,;
								nVencid   := 0,;
								dDataB    := dDatabase,;
								nJuros    := 0,;
								lCheck1   := .F.,;
								lCheck2   := .F.,;
								lCheck3   := .F.,;
								lCheck4   := .F.,;
								lCheck5   := .F.,;
								lCheck6   := .F.,;
								lEdicao   := .T. },045,011,,,,.T.,,"",,,,.F. )

	TGroup():New(120,003,250,oDlgMain:nClientWidth/2-5,"TÌtulos",oDlgMain,,,.T.)
		aTitulos := {{"","","","","","","","","","","","","","","","","","","","","","",""}}
		oListBox := TWBrowse():New(130,008,639,115,,{"Cliente","End.","UF","Local","TÌtulo","Tipo","Moeda","Status","Emiss„o","Vencimento","Status Data","Dias","QuitaÁ„o","Dt. Cancel","Banco","Agencia","Conta Corrente","N˙mero Banc·rio","T. Cob","Vlr. Emiss„o","Valor Saldo","AcrÈscimos","Total"},,oDlgMain,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aTitulos)
		oListBox:bLine := {||{ 	aTitulos[oListBox:nAt][1],aTitulos[oListBox:nAt][2],aTitulos[oListBox:nAt][3],aTitulos[oListBox:nAt][4],;
								aTitulos[oListBox:nAt][5],aTitulos[oListBox:nAt][6],aTitulos[oListBox:nAt][7],aTitulos[oListBox:nAt][8],;
								aTitulos[oListBox:nAt][9],aTitulos[oListBox:nAt][10],aTitulos[oListBox:nAt][11],aTitulos[oListBox:nAt][12],;
								aTitulos[oListBox:nAt][13],aTitulos[oListBox:nAt][14],aTitulos[oListBox:nAt][15],aTitulos[oListBox:nAt][16],;
								aTitulos[oListBox:nAt][17],aTitulos[oListBox:nAt][18],aTitulos[oListBox:nAt][19],aTitulos[oListBox:nAt][20],;
								aTitulos[oListBox:nAt][21],aTitulos[oListBox:nAt][22],aTitulos[oListBox:nAt][23] }}

	TButton():New(255,014,"Imprimir",oDlgMain,{|| U_IFINC04A(aTitulos) },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(255,064,"Emitir Danfe",oDlgMain,{|| oDlgMain:End() },045,011,,,,.T.,,"",,,,.F. )

EnchoiceBar(oDlgMain,{|| nOpcClick := 1, oDlgMain:End() },{|| nOpcClick := 0, oDlgMain:End()})
oDlgMain:Activate(,,,.T.)

RESTAREA(aAreaSA1)
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥BuscaTitulos∫Autor  ≥ ∫ Data ≥  13/05/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Busca os produtos conforme filtro informado                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function BuscaTit()

Local nTotReg := 0
Local cQuery  := ""
Local nCount  := 0
Local nTot    := 0
Local nTotS   := 0
Local nJur    := 0
Local nAcre   := 0
Local nJurT   := 0
Local nAcreT  := 0
Local nDias   := 0
Local cDesc   := 0

cQuery := " SELECT A1_NOME, A1_END, A1_EST, E1_FILIAL, E1_NUM, E1_TIPO, E1_STATUS, E1_EMISSAO, E1_VENCTO, E1_BAIXA, "
cQuery += " E1_NUMBOR, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NUMBCO, E1__TPCOBR, E1_VALOR, E1_SALDO FROM "
cQuery +=  RetSqlName("SE1") +" SE1, "+RetSqlName("SA1")+" SA1 "
cQuery += " WHERE SE1.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND E1_CLIENTE = A1_COD "

If !Empty(cCodCli)
	cQuery += " AND E1_CLIENTE = '"+cCodCli+"' "
EndIf

If !Empty(cBanco)
	cQuery += " AND E1_PORTADO = '"+cBanco+"' "
EndIf

If !Empty(cCodSit)
	cQuery += " AND E1_SITUACA= '"+cCodSit+"' "
EndIf

If !Empty(cCodSeg)
	cQuery += " AND A1__SEGISP = '"+cCodSeg+"' "
EndIf

If !Empty(cTpCob)
	cQuery += " AND E1__TPCOBR = '"+cTpCob+"' "
EndIf

cQuery += " AND E1_EMISSAO BETWEEN '"+DtoS(dEmisDe)+"' AND '"+DtoS(dEmisAt)+"' "
cQuery += " AND E1_VENCTO BETWEEN '"+DtoS(dVencDe)+"' AND '"+DtoS(dVencAt)+"' "
cQuery += " AND E1_VALOR BETWEEN '"+AllTrim(Str(nValDe))+"' AND '"+AllTrim(Str(nValAte))+"' "
cQuery += " AND E1_SALDO BETWEEN '"+AllTrim(Str(nSalDe))+"' AND '"+AllTrim(Str(nSalAte))+"' "

If lCheck1
	cQuery += " AND E1_BAIXA = '' "
EndIf

If lCheck2
	cQuery += " AND E1_BAIXA <> '' AND E1_SALDO = 0 "
EndIf

If lCheck4
	cQuery += " AND E1_BAIXA = '' AND E1_VENCTO < '"+DtoS(dDataB)+"' "
EndIf

If lCheck5
	cQuery += " AND E1_BAIXA = '' AND E1_VENCTO >= '"+DtoS(dDataB)+"' "
EndIf

If lCheck6
	cQuery += " AND E1_BAIXA <> '' AND E1_SALDO = 0 AND E1_BAIXA > E1_VENCTO"
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","E1_EMISSAO","D")
TcSetField("TMP","E1_VENCTO","D")
TcSetField("TMP","E1_BAIXA" ,"D")
TcSetField("TMP","E1_VALOR"  ,"N",12,2)
TcSetField("TMP","E1_SALDO"  ,"N",12,2)
LJMsgRun("Consultando TÌtulos...","Aguarde...")

DbSelectArea("TMP")
DbGoTop()

aTitulos := {}
ProcRegua(nTotReg)
While TMP->(!Eof())
	IncProc()
	
	nDias  := TMP->E1_VENCTO - dDataB
	
	If nVencid > 0
		If nDias < nVencid
			DbSelectArea("TMP")
			DbSkip()
			Loop
		EndIf
	EndIf
	
	If !Empty(TMP->E1_BAIXA)
		cDesc := "Quitado"
		nDias := 0
	Else
		cDesc := IIf(nDias < 0, "Vencido", "A Vencer")
		
		If nDias < 0
			nDias := nDias * (-1)
			nJur  := Round(((((nJuros/100) / 30) * nDias) * TMP->E1_VALOR) + TMP->E1_VALOR,2)
			nAcre := Round(((((nJuros/100) / 30) * nDias) * TMP->E1_VALOR),2)
		EndIf
		
	EndIf
			
	AAdd(aTitulos,{AllTrim(TMP->A1_NOME),AllTrim(TMP->A1_END),TMP->A1_EST,TMP->E1_FILIAL,TMP->E1_NUM+"/"+TMP->E1_PARCELA,TMP->E1_TIPO,"R$",TMP->E1_STATUS,DtoC(TMP->E1_EMISSAO),;
	DtoC(TMP->E1_VENCTO),cDesc,AllTrim(Str(nDias)),DtoC(TMP->E1_BAIXA),"",;
	Iif(!Empty(TMP->E1_NUMBOR),Posicione("SEA",1,xFilial("SEA")+TMP->E1_NUMBOR+TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO,"EA_PORTADO"),""),;
	Iif(!Empty(TMP->E1_NUMBOR),Posicione("SEA",1,xFilial("SEA")+TMP->E1_NUMBOR+TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO,"EA_AGEDEP"),""),;
	Iif(!Empty(TMP->E1_NUMBOR),Posicione("SEA",1,xFilial("SEA")+TMP->E1_NUMBOR+TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO,"EA_NUMCON"),""),;
	TMP->E1_NUMBCO,TMP->E1__TPCOBR,	AllTrim(Str(TMP->E1_VALOR)),AllTrim(Str(TMP->E1_SALDO)),AllTrim(Str(nAcre)),AllTrim(Str(nJur)) })

	nCount++
	nTot   += TMP->E1_VALOR
	nTotS  += TMP->E1_SALDO
	nJurT  += nJur
	nAcreT += nAcre
	nJur   := 0
	nAcre  := 0
	cDesc  := ""
	nDias  := 0
	TMP->(dbSkip())
End

DbSelectArea("TMP")
DbCloseArea()

AAdd(aTitulos,{"","","","","","","","","","","","","","","","","",;
"TOTAL",AllTrim(Str(nCount)),AllTrim(Str(Round(nTot,2))),AllTrim(Str(Round(nTotS,2))),AllTrim(Str(Round(nAcreT,2))),AllTrim(Str(Round(nJurT,2))) })

//Atualiza o list de produtos
oListBox:SetArray(aTitulos)
oListBox:bLine := {||{ 	aTitulos[oListBox:nAt][1],aTitulos[oListBox:nAt][2],aTitulos[oListBox:nAt][3],aTitulos[oListBox:nAt][4],;
						aTitulos[oListBox:nAt][5],aTitulos[oListBox:nAt][6],aTitulos[oListBox:nAt][7],aTitulos[oListBox:nAt][8],;
						aTitulos[oListBox:nAt][9],aTitulos[oListBox:nAt][10],aTitulos[oListBox:nAt][11],aTitulos[oListBox:nAt][12],;
						aTitulos[oListBox:nAt][13],aTitulos[oListBox:nAt][14],aTitulos[oListBox:nAt][15],aTitulos[oListBox:nAt][16],;
						aTitulos[oListBox:nAt][17],aTitulos[oListBox:nAt][18],aTitulos[oListBox:nAt][19],aTitulos[oListBox:nAt][20],;
						aTitulos[oListBox:nAt][21],aTitulos[oListBox:nAt][22],aTitulos[oListBox:nAt][23] }}

oListBox:Refresh()
lEdicao := .F.

Return

User Function IFINC04A(aTitulos)

If TcCanOpen(RetSqlName("PAB"))
	cQuery := " DELETE "+RetSqlName("PAB")
	cQuery += " WHERE PAB_USER = '"+__cUserId+"' "
	TCSqlExec(cQuery)
EndIf

For i := 1 To (Len(aTitulos)-1)

	DbSelectArea("PAB")
	While !RecLock("PAB",.T.)
	Enddo
		
	PAB_FILIAL := aTitulos[i][4]
	PAB_USER   := __cUserId
	PAB_CODCLI := cCodCli
	PAB_NMCLI  := aTitulos[i][1]
	PAB_UF     := aTitulos[i][3]
	PAB_TITULO := aTitulos[i][5]
	PAB_TIPO   := aTitulos[i][6]
	PAB_EMISSA := CtoD(aTitulos[i][9])
	PAB_VENCTO := CtoD(aTitulos[i][10])
	PAB_DESVCT := aTitulos[i][11]
	PAB_DIAS   := Val(aTitulos[i][12])
	PAB_QUIT   := CtoD(aTitulos[i][13])
	PAB_PORTAD := aTitulos[i][15]
	PAB_TPCOB  := aTitulos[i][17]
	PAB_NUMBCO := aTitulos[i][18] //aTitulos[i][17]
	PAB_MOEDA  := "01"
	PAB_VLREMI := Val(aTitulos[i][20])
	PAB_VLRSAL := Val(aTitulos[i][21])
	PAB_ACRESC := Val(aTitulos[i][22])
	PAB_TOTAL  := Val(aTitulos[i][23])
	MsUnLock()
	
Next

cOptions 	:= "1;0;1;Relatorio de Titulos" // 1(visualiza tela) 2 (direto impressora) 6(pdf) ; 0 (atualiza dados) ; 1 (n˙mero de cÛpias)

CallCrys("IFINCR18",__cUserId+";"+AllTrim(Str(nJuros)),cOptions)

Return
