#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch" 

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} fAtendClienteClass
Classe para executar carga de programação para atendimento do Vendedor Interno
@author Sigfrido Eduardo Solórzano Rodriguez
@since 22/06/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------
User Function fAtuAgenAt()
	Local cTitulo := 'Processando programação'   
	Local cTitulo2 := 'Processando integração ExcelXProtheus programação'
	Local cMsg := 'Aguarde, processando a programação para atendimento do VDI'
	Local cMsgExcel := 'Aguarde, Exportando p/ Excel a programação para atendimento do VDI'  
	Local cMsgEdit  := 'Aguarde, Integrando a programação Excel para atendimento do VDI'  
 	Local cEmp, oMainWnd
	Local nTop,	nLeft, nWidthBmp, nHeightBmp
	Local oDataIni, oDataFim
	Local lHasButton := .T.
	
	/*PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" ;
                                 USER "ADMIN" PASSWORD "brtx.99bcd2015";
                                 MODULO "FAT" ;
                                 TABLES "SF1","SD1","SD3","SB1"    */                                   
	Private oBmp
	Private dDataIni := Ctod("01/" + Strzero(Month(dDatabase),2) + "/" + Strzero(Year(dDatabase),4))
	Private dDataFim := Ctod("01/" + If(Month(dDatabase)<12,Strzero(Month(dDatabase)+1,2),"01")+"/"+If(Month(dDatabase)<12,Strzero(Year(dDatabase),4),Strzero(Year(dDatabase)+1,4)))-1
                                     
	cEmp := Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL)
	
	DEFINE MSDIALOG oDlg FROM 87 ,32  TO 377,609 TITLE "Programação para atendimento do VDI" Of oMainWnd PIXEL 
	@ 047,005   TO 127 ,284 LABEL "Parametros do Filtro p/ execução da programação para atendimento do VDI" OF oDlg PIXEL 
	@ 067,012  SAY "Data Inicial" Of oDlg PIXEL SIZE 60 ,9 COLOR CLR_HBLUE
	
	oDataIni := TGet():New( 067, 048, { | u | If( PCount() == 0, dDataIni, dDataIni := u ) }, oDlg, ;
    50, 09, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataIni",,,,lHasButton  )    
    
    @ 067,145 SAY "Data Final" Of oDlg PIXEL SIZE 59 ,9 COLOR CLR_HBLUE

	oDataFim := TGet():New( 067, 185, { | u | If( PCount() == 0, dDataFim, dDataFim := u ) }, oDlg, ;
    50, 09, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataFim",,,,lHasButton  ) 
    
	nTop := 20  
	nLeft := 18
	nWidthBmp := 110 
	nHeightBmp := 125
	
	oBmp := TBmpRep():New( nTop, nLeft, nWidthBmp, nHeightBmp,;
				 , .T.,oDlg, , , .F., .F., , , .F., , .T., , .F. )
	
	oBmp:cName := "oBmp"
	oBmp:cCaption := "oBmp"
	oBmp:nLeft := 20
	oBmp:nTop := 18
	oBmp:nWidth := 217
	oBmp:nHeight := 117
	oBmp:lShowHint := .F.
	oBmp:lReadOnly := .F.
	oBmp:Align := 0
	oBmp:lVisibleControl := .T. 	
	oBmp:cBmpFile := "\system\LOGO" + SM0->M0_CODIGO + SM0->M0_CODFIL + ".BMP" //oBmp:LoadBmp('LOGO' + SM0->M0_CODIGO + SM0->M0_CODFIL )
	oBmp:Refresh()
	oBmp:lStretch := .F.
	oBmp:lAutoSize := .F.
		
	@130,110 BUTTON "<< Cancelar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
	@130,150 BUTTON "Confirma >>" SIZE 35 ,10  FONT oDlg:oFont ACTION (FWMsgRun(, {|oSay| fAtuAgendaAtend( oSay ) }, cTitulo, cMsg ))  OF oDlg PIXEL    	 	
	@130,190 BUTTON "<< Excel >>" SIZE 35 ,10  FONT oDlg:oFont ACTION (FWMsgRun(, {|oSay| fExpExc( oSay ) }, cTitulo, cMsgExcel ))  OF oDlg PIXEL    	 	
	@130,230 BUTTON "<< Processar >>" SIZE 42 ,10  FONT oDlg:oFont ACTION (FWMsgRun(, {|oSay| fIntAgVDI( oSay, .F. ) }, cTitulo2, cMsgEdit ))  OF oDlg PIXEL    	 	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return
	
Static Function fAtuAgendaAtend()							
	//Local dDataIni := CToD("01/06/17")	
	//Local dDataFim := CToD("30/06/17")	  
	Local nDiasUte := 22
    Local nD
	Local nContAte := 0
    
    BeginSql alias 'ZZ1TMP'   					
		SELECT ZZ1_DTEXAT
		FROM ZZ1010 ZZ1 		
		WHERE ZZ1.ZZ1_FILIAL = %xfilial:ZZ1% AND 
		ZZ1.ZZ1_DTAGAT >= %Exp:DToS(dDataIni)% AND 
		ZZ1.ZZ1_DTAGAT <= %Exp:DToS(dDataFim)% AND
		ZZ1.ZZ1_DTEXAT <> '        ' AND ROWNUM <= 1
	EndSql
    
	ZZ1TMP->(DbGotop())
	
	If ZZ1TMP->(!EOF())
		Help( ,, 'HELP',, 'Não é permitida a execução da programação para atendimento do VDI do período com agenda já apontada.', 1, 0)  
		ZZ1TMP->(DbCloseArea())
		Return
	End if
	
	ZZ1TMP->(DbCloseArea())
	
	BeginSql alias 'ZZ1TMP'   					
		SELECT ZZ1_DTEXAT
		FROM ZZ1010 ZZ1 		
		WHERE ZZ1.ZZ1_FILIAL = %xfilial:ZZ1% AND 
		ZZ1.ZZ1_DTAGAT >= %Exp:DToS(dDataIni)% AND 
		ZZ1.ZZ1_DTAGAT <= %Exp:DToS(dDataFim)% AND
		ZZ1.ZZ1_DTEXAT = '        ' AND ROWNUM <= 1
	EndSql
    
	ZZ1TMP->(DbGotop())
	
	If ZZ1TMP->(!EOF())
		If MsgBox('A programação para atendimento do VDI do período já foi executada anteriormente. Deseja excluir a atual e refazer novamente?',"ATENÇÃO","YESNO")
			cUPD := " UPDATE ZZ1010"
			cUPD := cUPD + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
			cUPD := cUPD + " WHERE ZZ1_FILIAL = '" + xFilial("ZZ1") + "' AND"
			cUPD := cUPD + " ZZ1_DTAGAT >= '" +  DToS(dDataIni) + "' AND"
			cUPD := cUPD + " ZZ1_DTAGAT <= '" +  DToS(dDataFim) + "' AND"
			cUPD := cUPD + " ZZ1_DTEXAT  = '        '"
			
			TcSqlExec(cUPD)    
			
			ZZ1TMP->(DbCloseArea())		
		Else  
			ZZ1TMP->(DbCloseArea())
			Return                       
		Endif		
	End if
	
	BeginSql alias 'AGETMP'   
		%noparser% 
		SELECT ROUND(COUNT(*) / %Exp:nDiasUte%,0) NCLIEDIA, SA1.A1_VEND2 
		FROM %table:SA1% SA1
		WHERE SA1.A1_FILIAL = %xfilial:SA1%  AND 
		SA1.A1_VEND2 NOT IN ('      ','000000') AND 
		SA1.A1_MSBLQL <> '1' AND
		SA1.%notDel%    
		GROUP BY  SA1.A1_VEND2
		ORDER BY  SA1.A1_VEND2
 	EndSql

	Do While !AGETMP->(Eof())
		BeginSql alias 'SA1TMP'   
			%noparser% 
			SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_VEND
			FROM SA1010 SA1
			WHERE SA1.A1_FILIAL = %xfilial:SA1% AND SA1.A1_VEND2 = %Exp:AGETMP->A1_VEND2% AND SA1.A1_MSBLQL <> '1' AND SA1.%notDel%
		EndSql

		Do While !SA1TMP->(Eof())						
			For nD := dDataIni To dDataFim	
				nContAte := 0
				
				If DOW(nD) <> 1 .And. DOW(nD) <> 7								
					Do While nContAte <= AGETMP->NCLIEDIA .AND. !SA1TMP->(Eof())  
						
						BeginSql alias 'TRBRot'
							%noparser%
							SELECT COD_ROTEIRO, COD_USUARIO, SEQUENCIA, COD_CLI, to_char(DATAROT, 'YYYYMMDD') DATAROT, COD_VISITA 
							FROM ROTEIRO@MEX
							WHERE to_char(DATAROT, 'YYYYMMDD') = %Exp:DTOS(nD)% AND COD_USUARIO = %Exp:Alltrim(STR(Val(SA1TMP->A1_VEND)))% AND COD_CLI = %Exp:(Alltrim(STR(Val(SA1TMP->A1_COD)))+SA1TMP->A1_LOJA)%
							ORDER BY DATAROT
						EndSql  
						
						aLastQuery := GetLastQuery()
						
						If TRBROT->(Eof())  						
							RecLock("ZZ1",.T.) 
			
							ZZ1->ZZ1_FILIAL	:= xFilial('ZZ1')   
							ZZ1->ZZ1_DTPROG := Date()
							ZZ1->ZZ1_VENINT := AGETMP->A1_VEND2
							ZZ1->ZZ1_VENEXT := SA1TMP->A1_VEND
							ZZ1->ZZ1_CODCLI := SA1TMP->A1_COD  
							ZZ1->ZZ1_CLILJ  := SA1TMP->A1_LOJA
							ZZ1->ZZ1_DTAGAT := nD          
							ZZ1->ZZ1_ROTINA	:= "fAtuAgenAt"
					
							ZZ1->(MsUnlock())
						Else 
							Help( ,, 'HELP',, DtoS(nD)+"/"+SA1TMP->A1_VEND+"/"+SA1TMP->A1_COD+"/"+SA1TMP->A1_LOJA, 1, 0)  
						Endif
						
						TRBROT->(DbCloseArea())
						
						nContAte++
						SA1TMP->(dbSkip())				
					Enddo 
				Endif				
			Next nD
		Enddo
		
		SA1TMP->(DbCloseArea())

		AGETMP->(dbSkip())
	Enddo
	
	AGETMP->(DbCloseArea())
	
	ApMsgInfo("Execução da programação para atendimento do VDI concluída com sucesso!", "Aviso")
Return

Static Function fExpExc()

	Local aCabExcel :={}
	Local aItensExcel :={}

	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(aCabExcel, {"ZZ1_FILIAL" ,"C", 02, 0})
	AADD(aCabExcel, {"ZZ1_DTAGAT" ,"D", 08, 0})
	AADD(aCabExcel, {"ZZ1_VENINT" ,"D", 06, 0})  
	AADD(aCabExcel, {"ZZ1_NOMVDI" ,"C", 40, 0})
	AADD(aCabExcel, {"ZZ1_VENEXT" ,"D", 06, 0}) 
	AADD(aCabExcel, {"ZZ1_NOMVDE" ,"C", 40, 0})
	AADD(aCabExcel, {"ZZ1_CODCLI" ,"C", 06, 0})
	AADD(aCabExcel, {"ZZ1_CLILJ " ,"C", 02, 0})
	AADD(aCabExcel, {"ZZ1_NOMCLI" ,"C", 60, 0})
	AADD(aCabExcel, {"ZZ1_DTPROG" ,"D", 08, 0})
	AADD(aCabExcel, {"ZZ1_DTEXAT" ,"D", 08, 2})

	fProcItens(aCabExcel, @aItensExcel)
	
	aCabExcel[1][1] := "Filial"
	aCabExcel[2][1] := "Data Agendamento"
	aCabExcel[3][1] := "Vendedor Interno"	
	aCabExcel[4][1] := "Nome VDI"
	aCabExcel[5][1] := "Vendedor Externo"	
	aCabExcel[6][1] := "Nome VDE"
	aCabExcel[7][1] := "Cód.Cliente"
	aCabExcel[8][1] := "Loja Cliente"
	aCabExcel[9][1] := "Nome Cliente"
	aCabExcel[10][1] := "Data Programação"	
	aCabExcel[11][1] := "Data Execução Ate."
	
	DlgToExcel({{"GETDADOS", "Programação para atendimento do VDI no Período", aCabExcel,aItensExcel}})
	
	ApMsgInfo("Geração da Planilha de programação para atendimento do VDI concluída com sucesso! Salve a mesma na pasta de dados da planilha de integração ExcelXProtheus", "Aviso")
Return                                                              


Static Function fProcItens(aHeader, aCols)
	Local aItem, aLastQuery
	Local nX

	DbSelectArea("ZZ1")
	DbSetOrder(1)
	DbGotop()
 
 	BeginSql alias 'ZZ1TMP'   
		COLUMN ZZ1_DTPROG AS DATE
		COLUMN ZZ1_DTAGAT AS DATE
		COLUMN ZZ1_DTEXAT AS DATE
		
	    SELECT ZZ1_FILIAL,ZZ1_DTPROG,ZZ1_VENINT,SA3.A3_NOME ZZ1_NOMVDI,ZZ1_VENEXT,SA3B.A3_NOME ZZ1_NOMVDE,ZZ1_CODCLI,ZZ1_CLILJ,SA1.A1_NOME ZZ1_NOMCLI,ZZ1_DTAGAT,ZZ1_DTEXAT 
		FROM ZZ1010 ZZ1 
		INNER JOIN SA3010 SA3 ON ZZ1.ZZ1_VENINT = SA3.A3_COD 
		INNER JOIN SA3010 SA3B ON ZZ1.ZZ1_VENEXT = SA3B.A3_COD 
		INNER JOIN SA1010 SA1 ON ZZ1.ZZ1_CODCLI = SA1.A1_COD AND ZZ1.ZZ1_CLILJ = SA1.A1_LOJA
		WHERE  ZZ1.ZZ1_FILIAL = %xfilial:ZZ1% AND 
		ZZ1.ZZ1_DTAGAT >= %Exp:DToS(dDataIni)% AND 
		ZZ1.ZZ1_DTAGAT <= %Exp:DToS(dDataFim)% AND 
		ZZ1.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SA3B.D_E_L_E_T_ = ' '
		ORDER BY  ZZ1.ZZ1_DTAGAT, ZZ1.ZZ1_VENINT, ZZ1.ZZ1_CODCLI
	EndSql
		
    aLastQuery := GetLastQuery()
    
	ZZ1TMP->(DbGotop())

	Do While ZZ1TMP->(!EOF())

		aItem := Array(Len(aHeader))

		For nX := 1 to Len(aHeader)
			IF aHeader[nX][2] == "C"
				aItem[nX] := ZZ1TMP->&(aHeader[nX][1]) //CHR(160)+ZZ1TMP->&(aHeader[nX][1])
			ELSE
				aItem[nX] := ZZ1TMP->&(aHeader[nX][1])
			ENDIF
		Next nX

		AADD(aCols,aItem)
		
		aItem := {}  
		
		ZZ1TMP->(dbSkip())
	Enddo
    
	ZZ1TMP->(DbCloseArea())
Return

Static Function fIntAgVDI(oSay,lJob)
	Local aLastQuery
	Local cUPD 
	Local nRec
    
	If lJob
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" ;
	                                 USER "ADMIN" PASSWORD "brtx.99bcd2015";
	                                 MODULO "FAT" ;
	                                 TABLES "SF1","SD1","SD3","SB1"    
    Endif
                                 
	BeginSql alias 'ZZ1TMP'   		
		SELECT ZZ1_FILIAL, ZZ1_DTPROG, ZZ1_VENINT, ZZ1_CODCLI, ZZ1_CLILJ, ZZ1_DTAGAT, ZZ1_DTEXAT
		FROM ZZ1010TMP ZZ1 	
		ORDER BY ZZ1.ZZ1_DTAGAT, ZZ1.ZZ1_VENINT, ZZ1.ZZ1_CODCLI
	EndSql
    
    aLastQuery := GetLastQuery()
    
    If !lJob
	    nRec := nRecTot := 0    
	   
		ZZ1TMP->(DbGotop())     
		
	    Do While ZZ1TMP->(!EOF())
	    	nRecTot++ 
	    	ZZ1TMP->(dbSkip())
		Enddo
    Endif
    
    ZZ1TMP->(DbGotop()) 
    
	Do While ZZ1TMP->(!EOF()) 
		cUPD := " UPDATE ZZ1010"
		cUPD := cUPD + " SET ZZ1_DTAGAT = '" + ZZ1TMP->ZZ1_DTAGAT + "', ZZ1_DTEXAT = '" + ZZ1TMP->ZZ1_DTEXAT + "'"
		cUPD := cUPD + " WHERE ZZ1_FILIAL = '" + ZZ1TMP->ZZ1_FILIAL + "' AND"
		cUPD := cUPD + " ZZ1_DTPROG = '" +  ZZ1TMP->ZZ1_DTPROG + "' AND"
		cUPD := cUPD + " ZZ1_VENINT = '" +  ZZ1TMP->ZZ1_VENINT + "' AND"
		cUPD := cUPD + " ZZ1_CODCLI = '" +  ZZ1TMP->ZZ1_CODCLI + "' AND"
		cUPD := cUPD + " ZZ1_CLILJ = '" +  ZZ1TMP->ZZ1_CLILJ + "' AND"
		cUPD := cUPD + " ZZ1_DTEXAT  = ' '"
        
		TcSqlExec(cUPD)                                   		
        
        If !lJob
	        nRec++
	        
			oSay:cCaption := ('Registro ' + Alltrim(Str(nRec)) + "/" + Alltrim(Str(nRecTot)))
			ProcessMessages()
        Endif
        
		ZZ1TMP->(dbSkip())
	Enddo                
	
	cUPD := " DELETE FROM ZZ1010TMP "
	
	TcSqlExec(cUPD)  
	
	ZZ1TMP->(DbCloseArea())
Return

User Function fJobInAgVDI()
	fIntAgVDI(, .T. )
Return