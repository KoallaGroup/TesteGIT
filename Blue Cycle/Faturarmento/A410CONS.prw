User Function A410CONS()

_nomeuser := Alltrim(substr(cusuario,7,15))

aBotao := {}
AAdd( aBotao, { "FRETE", { || U_CALCFRET() }, "Consultar Frete" } ) 
AAdd( aBotao, { "DADOS", { || U_FALTCADCL() }, "Alt. Cliente" } )
AAdd( aBotao, { "VENDEDOR", { || u_zChamada() }, "Teste Pesquisa" } )

/*If _nomeuser $ GETMV("MV_HAPEA41") 
     AAdd( aBotao, { "CADEADO", { || U_WIZ001() }, "Wizard" } )
Endif*/
                         
Return( abotao)

                                                       


User Function CalcFret()


Local _nposprod:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local _nPosCf:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
Local _nPosVlr:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local _nPosNota:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_NOTA"}) 
Local _nPosQuant:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local _nTes:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local cOper := ''
Local cOperB := ''
Local cOperL := ''
Local cTemFat := ''
Local cProdu := 'N'                       
Local cBonif := 'N'
Local cAntecip := 'N'
Local cValorPed := 0 
Local cValFret := 0
Local cFrete := ' '       
Local cExp := ' ' 
Local cBloq := ''   


//cQuery := " SELECT C5_FILIAL,C5_OK, C5_NUM, C5_CLIENTE, C5_LOJACLI,A1_NOME,  SUM((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+"

//cQuery += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(((C6_QTDVEN*C6_PRCVEN)/100)*F7_MARGEM))/100)*(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*F7_ALIQEXT ELSE 0 END)" 
//cQuery += " ELSE 0 END))AS TOTPED, C5_VLPGANT, C5_VLCNAB,CASE WHEN C5_CNAB = 'S' THEN 'Sim' ELSE 'Nao' END C5_CNAB "




	IF LEN(ACOLS) > 0 .and. !empty(acols[1,_nposprod])
	                         
		FOR I:=1 TO LEN(ACOLS) 

			If !aCols[I][Len(aCols[I])]//identifica se o item não foi deletado			

				If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_DUPLIC") = "S" .And. Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_ESTOQUE") = "S"
					
					
					If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_IPI") = "S"
						cValorIPI := (ACOLS[I,_nposVlr] / 100) * Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_IPI")
					Else
						cValorIPI := 0
					EndIf
					cGrpCli := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_GRPTRIB")
					cGrpProd := Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_GRTRIB")    
					cEst := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_EST")
					
					cAlias := GetNextAlias()
					cQuery := " SELECT F7_MARGEM, F7_ALIQINT, F7_ALIQEXT FROM SF7010 WHERE F7_GRTRIB = '"+cGrpProd+"' AND F7_GRPCLI = '"+cGrpCli+"' AND D_E_L_E_T_ = ' ' "
					cQuery += " AND F7_FILIAL = '"+xFilial("SF7")+"' AND F7_EST = '"+cESt+"' "					
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  					
					
			
					cValorPed += cValorIPI + ACOLS[I,_nposVlr] 
					cValProd := ACOLS[I,_nposVlr]
					
					If (cAlias)->F7_MARGEM > 0 
						cBaseSt = cValProd + (cValProd/100)* F7_MARGEM
												
						If Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST") = "RJ"
							nAliqInt := 20
						Else
							nAliqInt := (cAlias)->F7_ALIQINT
						EndIf
						
						nValSt := (cBaseSt/100)*nAliqInt - (ACOLS[I,_nposVlr]/100)*(cAlias)->F7_ALIQEXT	  
					Else
						nValSt := 0
										
					EndIf                                                                         
					

					
					
					cValorPed += nValSt
					
				EndIf
				                                 
			Endif
		next i   
		
	Endif     
	
	If M->C5_TRANSP $ AllTrim(GetMv("MV_TRFTAE"))
	    //Validar valor fixo do frete aereo para pedidos inferiores a R$ 1.500,00 (Amanda)
	    If cValorPed > 1500
	    	cValFret := (cValorPed/100)*6
	    Else 
	    	If cValorPed > 0  .And.  cValorPed <= 1500
	    		cValFret := 200
	    	EndIf
	    EndIf 
    	   
 	Else
 		If cValorPed < 1500 .And. cValorPed > 0
			If Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST") $ "RS|SC|PR"
				cValFret := 40
			ElseIf Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST") $ "SP"
				cValFret := 50       
			Else
				cValFret := 60
			EndIf  
		EndIf
	EndIf 		
    
    M->C5_FRETE := cValFret 
    
Return()