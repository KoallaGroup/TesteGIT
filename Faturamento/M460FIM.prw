#Include "Protheus.ch"       
#Include "TopConn.ch"       


/*
+------------+---------+--------+------------------------------------------+-------+------------+
| Programa:  | M460FIM | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Junho/2014 |
+------------+---------+--------+------------------------------------------+-------+------------+
| Descrição: | Ponto de entrada executado apos geracao do documento de saida					|
+-----------------------------------------------------------------------------------------------+
| Uso        | Isapa																			|
+------------+--+-------------------------------------------------------------------------------+   
| Modificacoes  | Marcus Feixas em 10.12 - inclusao das linhas para gravar as parcelas          |
|               |  arredondando todas e colocado a diferenca na primeira parcela.               |
+---------------+-------------------------------------------------------------------------------+   

*/

User Function M460FIM()
Local _aArea := GetArea(), _aResult := {}, _cTab := _cSQL := _cPed := _cSeg := ""

/*-------------------------------------*
 | Envio da NF ao WMS - Jorge H. Alves |
 *-------------------------------------*/
 
DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
 
//Verifica se o pedido é do Call Center
DbSelectArea("SUA")
//DbOrderNickName("SUANF")
//If DbSeek(xFilial("SUA") + SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
DbSetOrder(8)
If DbSeek(xFilial("SUA") + SD2->D2_PEDIDO)
	_cPed := SUA->UA_NUM
	_cSeg := SUA->UA__SEGISP
	While !Reclock("SUA",.f.)
	EndDo
	SUA->UA__STATUS := "9"
	MsUnlock()
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5") +SD2->D2_PEDIDO)
		While !Reclock("SC5",.f.)
		EndDo
		SC5->C5__STATUS := "9"
		MsUnlock()
	EndIf
EndIf

If Empty(_cPed)

    _cPed := SD2->D2_PEDIDO + "FAT" 
    _cSeg := Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO,"C5__SEGISP")
    While !Reclock("SC5",.f.)
    EndDo
    SC5->C5__STATUS := "9"
    MsUnlock()
	
EndIf

//Faz envio da NF para o ArMHAzena

_aResult := TCSPEXEC("PROC_PMHA_INTER_NOTAFISCAL",cEmpant,cFilAnt,_cSeg,_cPed,SF2->F2_DOC,SF2->F2_SERIE,"INC",IIf(!Empty(SF2->F2__TRAFIL),cFilAnt,""),Alltrim(SF2->F2__TRAFIL))
If !Empty(_aResult)
	If _aResult[1] == "S"
		Help( Nil, Nil, "ENVNOTFIS", Nil, _aResult[2], 1, 0 ) 
		_lRet := .f. 
	EndIf
Else
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar Documento de saida para arMHAzena", 1, 0 )

	_lRet := .f.
EndIf

//------TERMINO ENVIO NF AO WMS----------
                

// ---> Inicio da gravacao do SEI arredondando as parcelas..  MARCUS FEIXAS
	
_cSqlSe1 := "select count(*) QTDSE1 , sum(E1_VALOR) VALORSE1 from " + retsqlname("SE1") + " SE1 where "
_cSqlSe1 += "     E1_FILIAL = '" + SF2->F2_FILIAL + "' and "
_cSqlSe1 += "     E1_PREFIXO = '" + SF2->F2_SERIE + "' and "
_cSqlSe1 += "     E1_NUM = '" + SF2->F2_DOC + "' and "
_cSqlSe1 += "     E1_TIPO= 'NF' and "
_cSqlSe1 += "     E1_CLIENTE = '" + SF2->F2_CLIENTE + "' and "
_cSqlSe1 += "     SE1.D_E_L_E_T_ = ' '  "         
tcquery _cSqlSe1 NEW ALIAS "XSE1" 
_cQtdSe1 := XSE1->QTDSE1  
dbselectarea("XSE1")
DbCloseArea()
//           
if  _cQtdSe1 > 1   // so entrará nesta sistemática se houverem MAIS DE UMA PARCELA senao nao tem porque entrar.

    //  
	_cSqlSe1 := "select R_E_C_N_O_ XRECNO from " + retsqlname("SE1") + " SE1 where "
	_cSqlSe1 += "     E1_FILIAL = '" + SF2->F2_FILIAL + "' and "
	_cSqlSe1 += "     E1_PREFIXO = '" + SF2->F2_SERIE + "' and "
	_cSqlSe1 += "     E1_NUM = '" + SF2->F2_DOC + "' and "
	_cSqlSe1 += "     E1_TIPO= 'NF' and "
	_cSqlSe1 += "     E1_CLIENTE = '" + SF2->F2_CLIENTE + "' and "
	_cSqlSe1 += "     SE1.D_E_L_E_T_ = ' '  "         
	tcquery _cSqlSe1 NEW ALIAS "XSE1" 
	//

//	_lFrtPri := (Posicione("SE4",1,xfilial("SE4")+SF2->F2_COND,"E4__FRETEF") = "P") // P=Frete na Primeira parcela (Customizado), R=rateia (padrao!)
	_lFrtPri := .t.
    if _lFrtPri   // .t. = frete na Primeira parcela
       _nVlFrtP := SF2->F2_FRETE / _cQtdSe1
       _nVlFrtT := SF2->F2_FRETE
    else
       _nVlFrtP := 0     
       _nVlFrtT := 0
    endif
    // Em primeiro lugar, vamos tirar o FRETE das parcelas .. pois senao o arredondamento sai errado.
    //                  
    if _lFrtPri
		dbselectarea("XSE1")
		dbgotop()   
		while !eof()
		    SE1->( dbGoto( XSE1->XRECNO ) ) 
		    
	     	    // Tirando os AVOS de rateio do FRETE ....
		        reclock("SE1",.f.)
		        SE1->E1_VALOR   := SE1->E1_VALOR - _nVlFrtP
		        SE1->E1_BASCOM1 := iif(!EMPTY(SE1->E1_BASCOM1),SE1->E1_BASCOM1 - _nVlFrtP ,0)
		        SE1->E1_BASCOM2 := iif(!EMPTY(SE1->E1_BASCOM2),SE1->E1_BASCOM2 - _nVlFrtP ,0)
		        SE1->E1_BASCOM3 := iif(!EMPTY(SE1->E1_BASCOM3),SE1->E1_BASCOM3 - _nVlFrtP ,0)
		        SE1->E1_BASCOM4 := iif(!EMPTY(SE1->E1_BASCOM4),SE1->E1_BASCOM4 - _nVlFrtP ,0)
		        SE1->E1_VLCRUZ  := iif(!EMPTY(SE1->E1_VLCRUZ) ,SE1->E1_VLCRUZ  - _nVlFrtP ,0)
		        SE1->E1_SALDO   := iif(!EMPTY(SE1->E1_SALDO)  ,SE1->E1_SALDO   - _nVlFrtP ,0)
		        msunlock()

		    dbselectarea("XSE1")
		    dbskip()
		end
		//
		// ==> Agora vamos gravar tudo na Primeira Parcela
		//
		dbselectarea("XSE1")
		dbgotop()
		while !eof()
		    SE1->( dbGoto( XSE1->XRECNO ) ) 
		    if ALLTRIM(SE1->E1_PARCELA) <> '1'
	              dbselectarea("XSE1")
	              dbskip()
		       loop
		    endif
		    // Incluindo na primeira parcela as sobras do arredondamenteo e o VALOR TOTAL DE FRETE  (_nVlFrtT)
		    reclock("SE1",.f.)
		    SE1->E1_VALOR := SE1->E1_VALOR + _nVlFrtT
	        SE1->E1_BASCOM1 := iif(!EMPTY(SE1->E1_BASCOM1) , SE1->E1_BASCOM1 + _nVlFrtT,0)
	        SE1->E1_BASCOM2 := iif(!EMPTY(SE1->E1_BASCOM2) , SE1->E1_BASCOM2 + _nVlFrtT,0)
	        SE1->E1_BASCOM3 := iif(!EMPTY(SE1->E1_BASCOM3) , SE1->E1_BASCOM3 + _nVlFrtT,0)
	        SE1->E1_BASCOM4 := iif(!EMPTY(SE1->E1_BASCOM4) , SE1->E1_BASCOM4 + _nVlFrtT,0)
	        SE1->E1_VLCRUZ  := iif(!EMPTY(SE1->E1_VLCRUZ)  , SE1->E1_VLCRUZ  + _nVlFrtT,0)
	        SE1->E1_SALDO   := iif(!EMPTY(SE1->E1_SALDO)   , SE1->E1_SALDO   + _nVlFrtT,0)
		    msunlock()
		    dbselectarea("XSE1")
		    dbskip()
		end
    Endif  // Acima soh fazia se o FRETE for para a PRIMEIRA PARCELA veja E3__FRETEF = 'P'
  	//
  	// AGORA VAMOS ARREDONDAR AS PARCELAS SUBSEQUENTES... DEIXANDO OS CENTAVOS NA PRIMEIRA PARCELA..... 
  	//                                                                                                 
  	_nDifSe1 := 0  
	dbselectarea("XSE1")
	dbgotop()   
	while !eof()
	    SE1->( dbGoto( XSE1->XRECNO ) ) 
	    if ALLTRIM(SE1->E1_PARCELA) <> '1' 
     	    // Tirando OS CENTAVOS das parcelas diferente de 01
	        reclock("SE1",.f.)
	        _nDifSe1 += (SE1->E1_VALOR - int(SE1->E1_VALOR))
	        SE1->E1_VALOR   := int(SE1->E1_VALOR)
	        SE1->E1_BASCOM1 := int(SE1->E1_BASCOM1)
	        SE1->E1_BASCOM2 := int(SE1->E1_BASCOM2)
	        SE1->E1_BASCOM3 := int(SE1->E1_BASCOM3)
	        SE1->E1_BASCOM4 := int(SE1->E1_BASCOM4)
	        SE1->E1_VLCRUZ  := int(SE1->E1_VLCRUZ)
	        SE1->E1_SALDO   := int(SE1->E1_SALDO)
	        msunlock()
	    endif
	    dbselectarea("XSE1")
	    dbskip()
	end
	// ----------------------------------------------------------------
	// ==> Agora vamos gravar tudo na Primeira Parcela
	// ----------------------------------------------------------------
	dbselectarea("XSE1")
	dbgotop()
	while !eof()
	    SE1->( dbGoto( XSE1->XRECNO ) ) 
	    if ALLTRIM(SE1->E1_PARCELA) <> '1'
              dbselectarea("XSE1")
              dbskip()
	       loop
	    endif
	    // Incluindo na primeira parcela as sobras do arredondamenteo e o VALOR TOTAL DE FRETE  (_nVlFrtT)
	    reclock("SE1",.f.)
	    SE1->E1_VALOR := SE1->E1_VALOR + _nDifSe1
        SE1->E1_BASCOM1 := iif(!EMPTY(SE1->E1_BASCOM1) , SE1->E1_BASCOM1 + _nDifSe1 ,0)
        SE1->E1_BASCOM2 := iif(!EMPTY(SE1->E1_BASCOM2) , SE1->E1_BASCOM2 + _nDifSe1 ,0)
        SE1->E1_BASCOM3 := iif(!EMPTY(SE1->E1_BASCOM3) , SE1->E1_BASCOM3 + _nDifSe1 ,0)
        SE1->E1_BASCOM4 := iif(!EMPTY(SE1->E1_BASCOM4) , SE1->E1_BASCOM4 + _nDifSe1 ,0)
        SE1->E1_VLCRUZ  := iif(!EMPTY(SE1->E1_VLCRUZ)  , SE1->E1_VLCRUZ  + _nDifSe1 ,0)
        SE1->E1_SALDO   := iif(!EMPTY(SE1->E1_SALDO)   , SE1->E1_SALDO   + _nDifSe1 ,0)
  
	    msunlock()
	    dbselectarea("XSE1")
	    dbskip()
	end
	//
	dbselectarea("XSE1")
	DbCloseArea()
	//
endif


// ---> Final da Gravacao do SE1 arredondnado as pacelas...   MARCUS FEIXSA  

// acerto da gravação da data na tabela SF6 com a data de recolhimento - Kliamca

DbSelectArea("SF6")
DbSetOrder(3)
If DbSeek(xFilial("SF6") + "2" + "N" + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	Reclock("SF6",.f.)
	SF6->F6_DTVENC  := SF6->F6_DTARREC
	SF6->F6_PROCESS := "2"
	MsUnlock()
Endif                                                                  

// final da gravação do SF6

RestArea(_aArea)
Return