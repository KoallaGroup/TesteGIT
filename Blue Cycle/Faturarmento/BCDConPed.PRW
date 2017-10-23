#INCLUDE "RWMAKE.CH" 
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'
//--------------------------------------------------------------
/*/{Protheus.doc} BCDConPed
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -                                               
@since 30/06/2016                                                   
/*/                                                             
//--------------------------------------------------------------
User Function BCDConPed(cTpCh,CliAtend,LojaAtend)  
Local nAber
Local cAber := 0
Local nAtr
Local cAtr := 0
Local nCred
Local cCred := 0
Local o6Mes
Local c6Mes := 0
Local oCEP
Local cCEP := "Define variable value"
Local oCod
Local cCod := "Define variable value"                    
Local oEnd
Local cEnd := "Define variable value"
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oLim
Local nLim := 0
Local oLimDis
Local cLimDis := 0
Local oLoja
Local cLoja := "Define variable value"
Local oMCom
Local cMCom := 0
Local oMedia
Local cMedia := 0
Local oMesAtu
Local cMesAtu := 0
Local oMun
Local cMun := "Define variable value"
Local oNome
Local cNome := "Define variable value"
Local oQtdPed
Local cQtdPed := 0
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oTkt
Local cTkt := 0
Local oUF
Local cUF := "Define variable value"      
Local cParFin
Local cParCom
Local dDataIni := FirstDate(MonthSub(Date(),1))
Local dDataFim := LastDate(MonthSub(Date(),1))
Private aWBSAC 
Private cVarArq 
Static oDlg  

                                               



    

    cAlias := GetNextAlias()
	cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_END, A1_MUN, A1_EST, A1_CEP, A1_LC, A1_SALDUP, A1_MCOMPRA,TTLSEM, QTDPED, MESATU,
	cQuery += " NVL(CREDITO,0) CREDITO, NVL(ATRASO,0) ATRASO  FROM SA1010 " 
	cQuery += " LEFT JOIN(SELECT C5_CLIENTE, C5_LOJACLI,SUM(C6_QTDVEN*C6_PRCVEN) TTLSEM, COUNT(DISTINCT(C5_NUM)) QTDPED,  "
	cQuery += "                 SUM(CASE WHEN SUBSTR(C5_EMISSAO,1,6) = SUBSTR(to_char(SYSDATE, 'yyyymmdd'),1,6) THEN (C6_QTDVEN*C6_PRCVEN) ELSE 0 END) MESATU " 
	cQuery += "                 FROM SC5010"
	cQuery += "                 INNER JOIN SC6010 ON "
	cQuery += "                 C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI "
	cQuery += "                 WHERE SC5010.D_E_L_E_T_ = ' ' AND SC6010.D_E_L_E_T_ = ' ' "
	cQuery += "                 GROUP BY C5_CLIENTE, C5_LOJACLI) SC5 "
	cQuery += "                 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
	cQuery += " LEFT JOIN (SELECT E1_CLIENTE, E1_LOJA, SUM(CASE WHEN E1_TIPO = 'NCC' THEN E1_VALOR ELSE 0 END) CREDITO, 
	cQuery += "                 SUM(CASE WHEN E1_VENCREA < to_char(SYSDATE, 'yyyymmdd')AND E1_TIPO = 'NF' THEN E1_VALOR ELSE 0 END) ATRASO 
	cQuery += "                 FROM SE1010 WHERE SE1010.D_E_L_E_T_ = ' ' AND E1_SALDO >0 
	cQuery += "                 GROUP BY E1_CLIENTE, E1_LOJA) SE1
	cQuery += "                 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
	If cTpch = '1'
		cQuery += " WHERE A1_COD = '"+SC5->C5_CLIENTE+"' AND A1_LOJA = '"+SC5->C5_LOJACLI+"' AND SA1010.D_E_L_E_T_ = ' '" 
	Elseif cTpch = '3'
		cQuery += " WHERE A1_COD = '"+CliAtend+"' AND A1_LOJA = '"+LojaAtend+"' AND SA1010.D_E_L_E_T_ = ' '"
	Else
   		cQuery += " WHERE A1_COD = '"+M->C5_CLIENTE+"' AND A1_LOJA = '"+M->C5_LOJACLI+"' AND SA1010.D_E_L_E_T_ = ' '" 
	EndIf

	
	               
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.) 
                                                              
	If cTpch = '1'
		cParCom := SC5->C5__OBSCOM
		cParfin := SC5->C5_PARECER
	Else
		cParCom := M->C5__OBSCOM
		cParfin := M->C5_PARECER
	EndIf
	



	c6Mes 	:= (cAlias)->TTLSEM
	cCEP 	:= (cAlias)->A1_CEP
	cCod 	:= (cAlias)->A1_COD
	cEnd 	:= (cAlias)->A1_END
	nLim 	:= (cAlias)->A1_LC
	cLimDis	:= (cAlias)->A1_LC-(cAlias)->A1_SALDUP
	cLoja 	:= (cAlias)->A1_LOJA
	cMCom 	:= (cAlias)->A1_MCOMPRA
	cMedia 	:= (cAlias)->TTLSEM/6
	cMesAtu	:= (cAlias)->MESATU
	cMun 	:= (cAlias)->A1_MUN
	cNome 	:= (cAlias)->A1_NOME
	cQtdPed	:= (cAlias)->QTDPED         
	cTkt 	:= (cAlias)->TTLSEM/(cAlias)->QTDPED
	cUF 	:= (cAlias)->A1_EST

	cAber	:= (cAlias)->A1_SALDUP
	cAtr	:= (cAlias)->ATRASO
	cCred	:= (cAlias)->CREDITO 

     
	//@ 37,14 SAY "Qtd.Total.Est Qualid: "

	     
  DEFINE MSDIALOG oDlg TITLE "Posição Cliente" FROM 000, 000  TO 554, 1200 COLORS 0, 16777215 PIXEL           
     

    @ 001, 000 GROUP oGroup1 TO 057, 421 PROMPT "Informações do Cliente" OF oDlg COLOR 0, 16777215 PIXEL      
	@ 001, 425 GROUP oGroup1 TO 135, 600 PROMPT "Parecer Comercial" OF oDlg COLOR 0, 16777215 PIXEL   
	//oScr:= TScrollBox():New(oDlg,008,430,125,165,.T.,.T.,.T.)   
	oMemo   := tMultiget():New(008,430,{|u|if(Pcount()>0,cParCom:=u,cParCom)},oDlg  ,165,125,,,,,,.T.,,,{|| .T.})                                    
	@ 137, 425 GROUP oGroup1 TO 272, 600 PROMPT "Parecer Financeiro" OF oDlg COLOR 0, 16777215 PIXEL 
	//oScr:= TScrollBox():New(oDlg,144,430,125,165,.T.,.T.,.T.)   
	oMemo   := tMultiget():New(144,430,{|u|if(Pcount()>0,cParFin:=u,cParFin)},oDlg  ,165,125,,,,,,.T.,,,{|| .T.})                                    
	
    @ 020, 005 MSGET oCod VAR cCod SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 020, 041 MSGET oLoja VAR cLoja SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 020, 068 MSGET oNome VAR cNome SIZE 179, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 020, 251 MSGET oEnd VAR cEnd SIZE 166, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 043, 005 MSGET oMun VAR cMun SIZE 108, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 043, 117 MSGET oUF VAR cUF SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 043, 144 MSGET oCEP VAR cCEP SIZE 064, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
//    @ 043, 212 MSGET oLim VAR nLim 	Picture "@E999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 043, 212 MSGET oLim VAR nLim 		Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 043, 285 MSGET oLimDis VAR cLimDis Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 043, 357 MSGET oMCom VAR cMCom Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 012, 006 SAY oSay1 PROMPT "Código" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 042 SAY oSay2 PROMPT "Loja" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 068 SAY oSay3 PROMPT "Razão Social" SIZE 073, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 251 SAY oSay4 PROMPT "Endereço" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 035, 005 SAY oSay5 PROMPT "Município" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 035, 117 SAY oSay6 PROMPT "UF" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 035, 144 SAY oSay7 PROMPT "CEP" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 212 SAY oSay8 PROMPT "Limite Crédito" SIZE 052, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 285 SAY oSay9 PROMPT "Limite Disponível" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 357 SAY oSay10 PROMPT "Maior Compra" SIZE 053, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 058, 000 GROUP oGroup2 TO 092, 420 PROMPT "Histórico de Compras" OF oDlg COLOR 0, 16777215 PIXEL
    @ 076, 005 MSGET o6Mes VAR c6Mes Picture "@E 999,999,999.99" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 076, 092 MSGET oMedia VAR cMedia Picture "@E 999,999,999.99" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 076, 178 MSGET oMesAtu VAR cMesAtu Picture "@E 999,999,999.99" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 076, 264 MSGET oQtdPed VAR cQtdPed Picture "@E 999,999,999.99" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 076, 351 MSGET oTkt VAR cTkt Picture "@E 999,999,999.99" SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 068, 005 SAY oSay11 PROMPT "Venda 6 Meses" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 092 SAY oSay12 PROMPT "Média Mês" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 178 SAY oSay13 PROMPT "Mês Atual" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 264 SAY oSay14 PROMPT "Qtd. Pedidos" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 351 SAY oSay15 PROMPT "Ticket Médio" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 093, 000 GROUP oGroup3 TO 164, 284 PROMPT "Titulos em Aberto" OF oDlg COLOR 0, 16777215 PIXEL
    fWBrowse1(cTpCh, CliAtend, LojaAtend)       

    @ 102, 357 MSGET nAber VAR cAber Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 123, 357 MSGET nAtr VAR cAtr Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 144, 357 MSGET nCred VAR cCred Picture "@E 999,999,999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    @ 104, 302 SAY oSay16 PROMPT "Titulos em Aberto:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 125, 302 SAY oSay17 PROMPT "Titulos em Atraso:" SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 146, 302 SAY oSay18 PROMPT "Créditos Aberto:" SIZE 048, 007 OF oDlg COLORS 0, 16777215 PIXEL    
   	@ 166, 000 GROUP oGroup4 TO 217, 421 PROMPT "Dados da Entrega" OF oDlg COLOR 0, 16777215 PIXEL
    fWBrowse2(cTpCh)    
                                                                                      
    @ 219, 000 GROUP oGroup1 TO 272, 421 PROMPT "Informações do SAC" OF oDlg COLOR 0, 16777215 PIXEL    
    fWBSAC(cTpCh,CliAtend, LojaAtend) 
    @ 228, 383 BUTTON oButton1 PROMPT "Detalhes SAC" SIZE 037, 040 OF oDlg ACTION {||_lOK := TesteMsg()} PIXEL     
  ACTIVATE MSDIALOG oDlg CENTERED
  //DbCloseArea("TRB")

Return

//------------------------------------------------
Static Function fWBrowse1(cTpCh, CliAtend, LojaAtend)
//------------------------------------------------
Local oWBrowse1
Local aWBrowse1 := {}
Local nAtras := 0
    

	cAlias := GetNextAlias()
    cQuery := " SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO FROM SE1010 WHERE E1_TIPO = 'NF' AND E1_SALDO > 0  AND D_E_L_E_T_ = ' ' AND 
    If cTpCh = '1'
    	cQuery += " E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"' "                
    ElseIf cTpCh = '3'
    	cQuery += " E1_CLIENTE = '"+CliAtend+"' AND E1_LOJA = '"+LojaAtend+"' "    	
    Else
    	cQuery += " E1_CLIENTE = '"+M->C5_CLIENTE+"' AND E1_LOJA = '"+M->C5_LOJACLI+"' "
    EndIf
    cQuery += " ORDER BY E1_NUM, E1_PARCELA"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  

    If Eof(cAlias)
    	Aadd(aWBrowse1,{"","","","","","","",""})
    EndIf   

	DbSelectArea(cAlias)
	DbGoTop()  		
	Do While !Eof(cAlias)  
		
		If (cAlias)->E1_VENCREA > dToc(Date())
			nAtras := nAtras + 1
		EndIf
			
		
		Aadd(aWBrowse1,{(cAlias)->E1_PREFIXO,(cAlias)->E1_NUM,(cAlias)->E1_PARCELA,(cAlias)->E1_TIPO,sTod((cAlias)->E1_EMISSAO),sTod((cAlias)->E1_VENCREA),Transform((cAlias)->E1_VALOR,"@e 999,999,999.99"),Transform((cAlias)->E1_SALDO,"@e 999,999,999.99")})
		
		DbSelectArea(cAlias)
		DbSkip() 
  
				
	End Do


    @ 100, 005 LISTBOX oWBrowse1 Fields HEADER "Prefixo","Titulo","Parcela","Tipo","Emissao","Vencimento","Valor","Saldo" SIZE 275, 060 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7],;
      aWBrowse1[oWBrowse1:nAt,8];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}
  //DbCloseArea("TRB1")
Return(nAtras)
              




//------------------------------------------------
Static Function fWBrowse2(cTpCh)
//------------------------------------------------
Local oWBrowse1
Local aWBrowse1 := {}
Local cTrecho := 0                      
Local cTpFrete    

    cAlias := GetNextAlias()
    cQuery := " SELECT GWU_SERDC, GWU_NRDC, F2_EMISSAO, A4_NOME, GWU_DTPENT, GWU_DTENT, GWU_HRENT, GWU_NRCIDD, GW1_TPFRET, GWU_SEQ "
    cQuery += " FROM GWU010          "
    cQuery += " INNER JOIN GW1010   "
    cQuery += " ON GWU_FILIAL = GW1_FILIAL AND GWU_SERDC = GW1_SERDC AND GWU_NRDC = GW1_NRDC AND GW1_CDTPDC = GWU_CDTPDC AND GW1_EMISDC = GWU_EMISDC "
    cQuery += " INNER JOIN SF2010  "     
    cQuery += " ON F2_FILIAL = GW1_FILIAL AND GWU_SERDC = F2_SERIE AND GWU_NRDC = F2_DOC "
    cQuery += " INNER JOIN SA4010  "    
    cQuery += " ON A4_CGC = GWU_CDTRP "
    cQuery += " WHERE SA4010.D_E_L_E_T_ = ' ' AND GWU010.D_E_L_E_T_ = ' ' AND GW1010.D_E_L_E_T_ = ' ' AND SF2010.D_E_L_E_T_ = ' ' AND GWU_CDTPDC = 'NFS'"
    If cTpCh = '1'
    	cQuery += " AND GWU_NRDC = '"+SC5->C5_NOTA+"' "     
    ElseIf cTpCh = '3'
    	cQuery += " AND GWU_NRDC = ' ' "    	
	Else
		cQuery += " AND GWU_NRDC = '"+M->C5_NOTA+"' "
	EndIf
    cQuery += " ORDER BY GWU_SEQ "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  
   // Aadd(aWBrowse1,{"Prefixo","Titulo","Parcela","Tipo","Emissao","Vencimento","Valor","Saldo"})
   // Aadd(aWBrowse1,{"Prefixo","Titulo","Parcela","Tipo","Emissao","Vencimento","Valor","Saldo"})
    If Eof(cAlias)
    	Aadd(aWBrowse1,{"","","","","","","","",""})
    EndIf

	DbSelectArea(cAlias)
	DbGoTop()  		
	Do While !Eof(cAlias)  
		
		If (cAlias)->GWU_SEQ = '01'
			cTrecho  := "1º Trecho"
		Else
			cTrecho := "2º Trecho"
		EndIf 
		
		If (cAlias)->GW1_TPFRET = '1'
			cTpFrete := 'CIF'
		ElseIf (cAlias)->GW1_TPFRET = '2'
			cTpFrete := 'CIF Redespacho'
		ElseIf (cAlias)->GW1_TPFRET = '3'
			cTpFrete := 'FOB'
		Else
			cTpFrete := 'FOB Redespacho'
		EndIf
			
		
		Aadd(aWBrowse1,{(cAlias)->GWU_SERDC,(cAlias)->GWU_NRDC,sTod((cAlias)->F2_EMISSAO),(cAlias)->A4_NOME,sTod((cAlias)->GWU_DTPENT),sTod((cAlias)->GWU_DTENT),(cAlias)->GWU_HRENT,cTpFrete,cTrecho})
		
//		Transform(TRB1->E1_VALOR,"@e 999,999,999.99"),Transform(TRB1->E1_SALDO,"@e 999,999,999.99")})
		DbSelectArea(cAlias)
		DbSkip() 
  
				
	End Do


    @ 173, 005 LISTBOX oWBrowse1 Fields HEADER "Prefixo","Nota Fiscal","Emissão NF","Transportadora","Dt. Prevista Ent.","Dt. Entrega","Hr. Entrega","Tipo Frete","Trecho" SIZE 412, 040 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7],;
      aWBrowse1[oWBrowse1:nAt,8],;
      aWBrowse1[oWBrowse1:nAt,9];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}
  //DbCloseArea("TRB2")
Return()      





//------------------------------------------------
Static Function fWBSAC(cTpCh,CliAtend,LojaAtend,lRet)
//------------------------------------------------

Local nAtras := 0
Local ADados := U_WSBCDlis(cTpCh,CliAtend,LojaAtend)  
Local cDtPD := CToD("01/01/1970")
Local oWBrowseS
Local nDataAber
Private ctes1 := "teste"

aWBSAC := {}

              
//Alert(ctes1)

	If !Empty(aDados)
		For nx := 1 to Len(aDados) 
			If aDados[nx]:cCodStatus = "1"
				cStatusTk := "Pendente Empresa"
			ElseIf aDados[nx]:cCodStatus = "2"
				cStatusTk := "Pendente Cliente"
			ElseIf aDados[nx]:cCodStatus = "3"
				cStatusTk := "Concluido"
			ElseIf aDados[nx]:cCodStatus = "4"
				cStatusTk := "Suspenso"
			Else
				cStatusTk := "Verificar"
			EndIf	       
			
			
			If aDados[nx]:cCodDepartamento = "1"
				cDeptoTk := "Atendimento"
			ElseIf aDados[nx]:cCodDepartamento = "2"
				cDeptoTk := "Comercial"
			ElseIf aDados[nx]:cCodDepartamento = "3"
				cDeptoTk := "Dev. Mercadoria"
			ElseIf aDados[nx]:cCodDepartamento = "4"
				cDeptoTk := "Faturamento"
			ElseIf aDados[nx]:cCodDepartamento = "5"
				cDeptoTk := "Financeiro"
			ElseIf aDados[nx]:cCodDepartamento = "6"
				cDeptoTk := "Fiscal"
			ElseIf aDados[nx]:cCodDepartamento = "7"
				cDeptoTk := "Garantia"  
			ElseIf aDados[nx]:cCodDepartamento = "8"
				cDeptoTk := "Logistica"				               
			ElseIf aDados[nx]:cCodDepartamento = "9"
				cDeptoTk := "Marketing"			                       
			ElseIf aDados[nx]:cCodDepartamento = "10"
				cDeptoTk := "Transporte"
			Else			
				cDeptoTk := "Verificar"
			EndIf	    			
			Aadd(aWBSAC,{aDados[nx]:cCodTicket,cStatusTk,aDados[nx]:cTitulo,cDeptoTk,cDtPD+(Val(aDados[nx]:cDtAbertura)/86400+(-3/24)),cDtPD+(Val(aDados[nx]:cDtAlteracao)/86400+(-3/24)),cDtPD+(Val(aDados[nx]:cDtPrevisao)/86400+(-3/24))})	
		
		Next
	Else
		Aadd(aWBSAC,{"","","","","","",""})
	EndIf	
                                                        


    @ 228, 005 LISTBOX oWBrowseS VAR cVarArq Fields HEADER "Ticket","Status","Assunto","Departamento","Dt Abertura","Dt Interação","Dt Previsao" SIZE 375, 040 OF oDlg PIXEL ColSizes 25,50,130,50,50,50,50,50
    oWBrowseS:SetArray(aWBSAC)
    oWBrowseS:bLine := {|| {;
      aWBSAC[oWBrowseS:nAt,1],;
      aWBSAC[oWBrowseS:nAt,2],;
      aWBSAC[oWBrowseS:nAt,3],;
      aWBSAC[oWBrowseS:nAt,4],;
      aWBSAC[oWBrowseS:nAt,5],;
      aWBSAC[oWBrowseS:nAt,6],;
      aWBSAC[oWBrowseS:nAt,7];
    }}
    // DoubleClick event
    oWBrowseS:bLDblClick := {||TesteMsg() } //TesteMsg()
   oWBrowseS:Refresh()
   
Return(nAtras)    



Static Function TesteMsg
 If !Empty(AWBSac[1][1])
	 For Nx:=1 To Len(aWBSAC)
	 If Nx == cVarArQ:NAT
	 //msgAlert("Código: "+aWBSAC[Nx][3]+" Descrição: "+aWBSAC[Nx][2])
	 u_BCDInt(aWBSAC[Nx][1])
	 Exit
	 EndIf
	 Next Nx
 EndIf
Return

