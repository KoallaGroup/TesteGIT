#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "XmlXFun.Ch"
#define ENTER chr(13) + chr(10)
                     
/*
+-------------+----------+--------+--------------------------------+-------+---------------+
| Programa:   | IESTA15  | Autor: | Rubens Cruz - Anadi			   | Data: | Janeiro/2015  |
+-------------+----------+--------+--------------------------------+-------+---------------+
| Descrição:  | Criação de janela para informaco caminho do XML e processo para gerar a NF |
+-------------+----------------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         	   |
+-------------+----------------------------------------------------------------------------+
*/

User Function IESTA15()
Local _aArea	:= GetArea()
Local _aAreaSF1	:= SF1->(GetArea())
Local _aAreaSA2	:= SA2->(GetArea())
Local _aAreaSZ2	:= SZ2->(GetArea())
Local _aAreaSF4	:= SF4->(GetArea())
Local aStru 	:= {010, 070} 
Local _nLinha	:= 010 
Local nAlt		:= 0
Local nLarg		:= 0

Private oDlgTMP
Private oFont 	:= tFont():New("Tahoma",,-12,,.t.)
Private oFont24	:= tFont():New("Tahoma",,-24,,.t.)
Private _cPath	:= Space(100)
Private _cProc	:= space(TamSX3("Z2_CODIGO")[1]) 
Private _cNota	:= ""
Private _cSerie	:= ""


DEFINE MSDIALOG oDlgTMP TITLE OemToAnsi("Geração de NF por XML") From 000,000 To 200,480 OF oMainWnd PIXEL
nAlt  := (oDlgTMP:nClientHeight / 2) - 35
nLarg := (oDlgTMP:nClientWidth  / 2) - 10

@ _nLinha,aStru[1] Say "XML"   				SIZE 080,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2] MsGet _cPath 			SIZE 140,10 of oDlgTMP PIXEL FONT oFont VALID(FilProc())
_nLinha += 16
	
@ _nLinha,aStru[1] Say "Processo"  			SIZE 080,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2] MsGet _cProc 			SIZE 050,10 of oDlgTMP PIXEL FONT oFont VALID (Vazio() .OR. ExistCPO("SZ2",_cProc,3) )
_nLinha += 16
	
@ _nLinha,aStru[1] Say "Nota Fiscal"  		SIZE 080,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2] MsGet _cNota 			SIZE 040,10 of oDlgTMP PIXEL FONT oFont WHEN .F.  
_nLinha += 16
	
@ _nLinha,aStru[1] Say "Série" 				SIZE 080,10 OF oDlgTMP PIXEL FONT oFont 
@ _nLinha,aStru[2] MsGet _cSerie 			SIZE 020,10 of oDlgTMP PIXEL FONT oFont WHEN .F.  
		
@ nAlt,(nLarg-140) Button oButton PROMPT "Loc. Pasta"  	SIZE 40,15   OF oDlgTMP PIXEL ACTION (PathXML(),FilProc())
@ nAlt,(nLarg-090) Button oButton PROMPT "Gerar NF"  	SIZE 40,15   OF oDlgTMP PIXEL ACTION (U_IESTA15A())
@ nAlt,(nLarg-040) Button oButton PROMPT "Sair"  		SIZE 40,15   OF oDlgTMP PIXEL ACTION oDlgTMP:End()
		
ACTIVATE MSDIALOG oDlgTMP CENTERED                                                                                

RestArea(_aAreaSF1)
RestArea(_aAreaSA2)
RestArea(_aAreaSZ2)
RestArea(_aAreaSF4)

Return

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : IESTA15A					| 	Novembro de 2014													|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi																		|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Geração de Dados da NF de Entrada a partir de XML												|
|---------------------------------------------------------------------------------------------------------------|	
*/


User Function IESTA15A()
Local _cCam	:= "\temp\"
Local lSucess	:= .T.
Local _cErro := _cAviso := _cDest := "", _lErro := .f.

Private aSitTrib 	:= {}
Private _cCodProc	:= "212121212"

aadd(aSitTrib,"00")
aadd(aSitTrib,"10")
aadd(aSitTrib,"20")
aadd(aSitTrib,"30")
aadd(aSitTrib,"40")
aadd(aSitTrib,"41")
aadd(aSitTrib,"50")
aadd(aSitTrib,"51")
aadd(aSitTrib,"60")
aadd(aSitTrib,"70")
aadd(aSitTrib,"90")
aadd(aSitTrib,"PART")

If(Empty(_cPath) .OR. Empty(_cProc))
	Alert("XML ou Código do Processo não informado")
	Return 
EndIf  

//Copia o arquivo para a protheus_Data pois o XmlParserFile só le arquivos la dentro
lSucess := CpyT2S(_cPath,_cCam,.T.)

if !lSucess
  Alert("Não foi possivel copiar arquivo para o servidor")
  Return 
endif

_cArq := _cCam + RETFILENAME(_cPath) + ".xml"

Processa({|| IESTA15B(_cArq) },"Importando Arquivo XML...") 

If (FErase(_cCam + RETFILENAME(_cPath) + ".xml",,.F.) != 0)
	Alert("Não foi possível apagar arquivo: " + FError())
EndIf

DbSelectArea("SF1")

Return



Static Function IESTA15B(_cArq)
Local oXml	:= Nil, _cErro := _cAviso := _cSerie := _cNF := _cCodNF := _log := _cLog := _cProd := _cPed := _cItem := _cFornec := ""
Local _cEOL := CHR(13) + CHR(10), _lOK := .f., _aCab := {}, _aItem := {}, _lExec := .t., _nTot := 0, _lSaida := .F.
Local _cCodSZ2 	:= _cArmz := _cSitTrib := ""
Local _cForn	:= "", _lZ08 := .f.
Local _cLoja	:= ""

Private lMsErroAuto := .f., _lImport := .F.

oXml := XmlParserFile(_cArq,"_",@_cErro,@_cAviso)

_LTESTE := ""
If Valtype(oXml) == "O"    

	If ValType(XmlChildEx(oXML,"_NFEPROC")) == "O" 
		
		//Verifica o status de autorização da NF-e
		If oXML:_NfeProc:_ProtNfe:_InfProt:_cStat:TEXT != "100"
			_log += "Status de autorização inválido. Favor entrar em contato com o fornecedor" + ENTER
		EndIf
		
		
		If ValType(XmlChildEx(oXML:_NfeProc:_NFe:_InfNFe:_Dest,"_CPF")) == "O"
			_cnpjDest := oXML:_NfeProc:_NFe:_InfNFe:_Emit:_CNPJ:TEXT
		else
			//Valida o CNPJ do destinatário
			_cnpjDest := oXML:_nfeProc:_NFe:_InfNFe:_dest:_CNPJ:TEXT
		endif
		
		dbSelectArea("SM0")
		_nRecSM0 := SM0->(recno())
		               
		cCodFil := ""
		SM0->(dbGotop())
		Do While ! Eof()                                                     
			if _cnpjDest == SM0->M0_CGC
				cCodFil := SM0->M0_CODFIL
				exit
			endif
			dbSkip()
		EndDo
	    go _nRecSM0 
	    
		if empty(cCodFil)						
    		_log += "CNPJ NÃO ENCONTRADO NAS FILIAIS CADASTRADAS : " + _cnpjDest + _cEOL 
			_lExec := .F.
		endif
       
    	_cCodFilOld := cFilAnt
    	cFilAnt := cCodFil
    
		//Verifica se o fornecedor já está cadastado, se não estiver, faz a inclusão
		_cnpjEmi := oXML:_NfeProc:_NFe:_InfNFe:_Emit:_CNPJ:TEXT                     
		_estadoDest := oXML:_NfeProc:_NFe:_InfNFe:_Emit:_enderEmit:_UF:TEXT
	
		If Empty(Posicione("SA2",3,xFilial("SA2") + oXML:_NfeProc:_NFe:_InfNFe:_Emit:_CNPJ:TEXT,"A2_COD"))
    		_log += "FORNECEDOR NÃO CADASTRADADO " + _cEOL 
			_lExec := .F.
		Else
			_cForn	:= SA2->A2_COD
			_cLoja	:=SA2->A2_LOJA
		EndIf
		
        DbSelectArea("SZ2")
		DbSetOrder(3)
		If !(DbSeek(xFilial("SZ2")+_cProc))
    		_log += "CÓDIGO DE IMPORTAÇÃO NÃO ENCONTRADO " + _cEOL 
			_lExec := .F.
		EndIf
		
		_cNF 	:= PadR(oXml:_NfeProc:_NFe:_InfNFe:_ide:_nNF:TEXT,TamSX3("F1_DOC")[1])
		_cSerie	:= PadR(oXml:_NfeProc:_NFe:_InfNFe:_ide:_serie:TEXT,TamSX3("F1_SERIE")[1])
		if oXml:_nfeProc:_NFe:_InfNFe:_VERSAO:TEXT >= "3.10"
			_dDtEmi	:= STOD(StrTran(substr(oXML:_nfeProc:_NFe:_InfNFe:_Ide:_dHEmi:TEXT,1,10),"-",""))
		else
			_dDtEmi	:= STOD(StrTran(oXML:_nfeProc:_NFe:_InfNFe:_Ide:_DEMI:TEXT,"-",""))
		endif

        DbSelectArea("SF1")
		DbSetOrder(1)
		If (DbSeek(xFilial("SF1")+_cNF+_cSerie+_cForn+_cLoja))
    		_log += "NOTA FISCAL JÁ EXISTE " + _cEOL 
			_lExec := .F.
		EndIf

		If ValType(oXml:_NfeProc:_NFe:_InfNFe:_det) == "O"
			XmlNode2Arr(oXml:_NfeProc:_NFe:_InfNFe:_det,"_det")
		EndIf

        //Cabeçalho da pré-nota
		_aCab := {	{"F1_DOC"		,_cNF		    								,NIL},;
		    	   	{"F1_SERIE"		,_cSerie	 									,NIL},;
		            {"F1_FORNECE"	,SA2->A2_COD   									,NIL},;
		            {"F1_LOJA"	   	,SA2->A2_LOJA  									,NIL},;
		          	{"F1_TIPO"		,'N'		    								,NIL},;
		            {"F1_FORMUL"	,'N'	    									,NIL},;
		        	{"F1_EMISSAO"	,_dDtEmi										,NIL},;
		            {"F1_ESPECIE"	,'NF'            		   						,NIL},;
		        	{"F1__PROIMP"	,_cProc											,NIL},;
		        	{"F1__REFEXT"   ,SZ2->Z2_PROCISA                                ,NIL},;
		            {"F1_COND" 		,SZ2->Z2_CONDPAG							 	,NIL}}

		_aItens := {}
	    _aLinha := {}
	    
	    //Itens 
	    For nx := 1 To Len(oXml:_NfeProc:_NFe:_InfNFe:_det)
	    
	    	_cProd 	:= oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_xPed:TEXT   
	    	_cFop 	:= oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_CFOP:TEXT   
			_cTes	:= ""

            _nBaseICM   := "0"
            _nPerICM    := "0"
            _nValICM    := "0"
            _nBaseIPI   := "0"
            _nBaseCST   := "0"
            _nValCST    := "0"
            _nPerIPI    := "0"
            _nValIPI    := "0"
            _nBasePIS   := "0"
            _nPerPIS    := "0"
            _nValPIS    := "0"
            _nBaseCOF   := "0"
            _nPerCOF    := "0"
            _nValCOF    := "0"

            oImposto := oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_imposto
            if Type("oImposto:_ICMS")<>"U"
                nLenSit := Len(aSitTrib)
                For nY := 1 To nLenSit
                    If Type("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT")<>"U"
                        _nBaseICM   := &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBC:TEXT")
                        _nPerICM    := &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_pICMS:TEXT")
                        _nValICM    := &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT")
                        
                        If Type("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBCST:TEXT")<>"U"
                            _nBaseCST   := &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBCST:TEXT")
                            _nValCST    := &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMSST:TEXT")
                        endif                               
                    endif   
                next nY
            endif
            
            if Type("oImposto:_IPI:_IPITrib")<>"U"      
                if Type("oImposto:_IPI:_IPITrib:_vBC")<>"U"
                    _nBaseIPI   := oImposto:_IPI:_IPITrib:_vBC:TEXT
                    _nPerIPI    := oImposto:_IPI:_IPITrib:_pIPI:TEXT
                    _nValIPI    := oImposto:_IPI:_IPITrib:_vIPI:TEXT
                endif
            endif
                                
            if Type("oImposto:_PIS:_PISAliq")<>"U"
                _nBasePIS   := oImposto:_PIS:_PISAliq:_vBC:TEXT
                _nPerPIS    := oImposto:_PIS:_PISAliq:_pPIS:TEXT
                _nValPIS    := oImposto:_PIS:_PISAliq:_vPIS:TEXT
            endif
                
            if Type("oImposto:_COFINS:_COFINSAliq")<>"U"
                _nBaseCOF   := oImposto:_COFINS:_COFINSAliq:_vBC:TEXT
                _nPerCOF    := oImposto:_COFINS:_COFINSAliq:_pCOFINS:TEXT
                _nValCOF    := oImposto:_COFINS:_COFINSAliq:_vCOFINS:TEXT
            endif
                
            If Empty(Posicione("SB1",1,xFilial("SB1") + alltrim(_cProd),"B1_COD"))
                _log += "Produto não localizado na SB1: ;" + _cProd + ";" + oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_xProd:TEXT + ";" + oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT + ";" + oXML:_NfeProc:_NFe:_InfNFe:_Emit:_CNPJ:TEXT + _cEOL 
                _lExec := .F.
            endif               
            
            If _lExec 
                _nTot := Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_qCom:TEXT) * Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT)
  
                if _nTot > 0
                
                    _cArmz := SB1->B1_LOCPAD
                    _cSitTrib := PADR(SB1->B1_ORIGEM,TamSX3("D1_CLASFIS")[1])
					
					_lZ08 := .f.
			        DbselectArea("Z08")
			        DbSetOrder(1)
			        If DbSeek(xFilial("Z08") + SB1->B1_COD)
			            _lZ08 := .t.
			        Else
			            DbSetOrder(2)
			            If DbSeek(xFilial("SB1") + SB1->B1_GRUPO)
			                _lZ08 := .t.
			            EndIf
			        EndIf
                    
                    If Alltrim(SA2->A2_COD) $ GetMv("MV__ARMFOR") .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG") .And. _lZ08
                        _cArmz := Alltrim(GetMv("MV__ARMCOD"))
                        _cSitTrib := PADR("2",TamSX3("D1_CLASFIS")[1])
                    EndIf 
                
                    AADD(_aLinha,{"D1_COD"              ,SB1->B1_COD                                                    ,NIL})
                	AADD(_aLinha,{"D1_LOCAL"            ,_cArmz                                                         ,NIL})
                    AADD(_aLinha,{"D1_UM"               ,SB1->B1_UM                                                     ,NIL})
                    AADD(_aLinha,{"D1_QUANT"            ,Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_qCom:TEXT)      ,NIL})
                    AADD(_aLinha,{"D1_VUNIT"            ,Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT)    ,NIL})
                    AADD(_aLinha,{"D1_TOTAL"            ,_nTot                                                          ,NIL})

					AADD(_aLinha,{"D1_IPI"              ,val(_nPerIPI)                                                  ,NIL})
                    AADD(_aLinha,{"D1_VALIPI"           ,val(_nValIPI)                                                  ,NIL})
                    AADD(_aLinha,{"D1_BASEIPI"          ,val(_nBaseIPI)                                                 ,NIL})

                    AADD(_aLinha,{"D1_PICM"             ,val(_nPerICM)                                                  ,NIL})
                    AADD(_aLinha,{"D1_VALICM"           ,val(_nValICM)                                                  ,NIL})
                    AADD(_aLinha,{"D1_BASEICM"          ,val(_nBaseICM)                                                 ,NIL})
                    AADD(_aLinha,{"D1_ICMSRET"          ,val(_nValCST)                                                  ,NIL})
                    AADD(_aLinha,{"D1_BRICMS"           ,val(_nBaseCST)                                                 ,NIL})

                    AADD(_aLinha,{"D1_BASIMP5"          ,val(_nBaseCOF)                                                 ,NIL})
                    AADD(_aLinha,{"D1_BASIMP6"          ,val(_nBasePIS)                                                 ,NIL})
                    AADD(_aLinha,{"D1_VALIMP5"          ,val(_nValCOF)                                                  ,NIL})
                    AADD(_aLinha,{"D1_VALIMP6"          ,val(_nValPIS)                                                  ,NIL})
                    AADD(_aLinha,{"D1_ALQIMP5"          ,val(_nPerCOF)                                                  ,NIL})
                    AADD(_aLinha,{"D1_ALQIMP6"          ,val(_nPerPIS)                                                  ,NIL})
                    
                    AADD(_aLinha,{"D1_CLASFIS"          ,_cSitTrib                                                      ,NIL})

					AADD(_aLinha,{"D1__CODPRO"          ,SZ2->Z2_CODIGO                                                 ,NIL})

                    AADD(_aItens,_aLinha)
                    _aLinha := {} 
				endif
            EndIf

			
			/*
			dbSelectArea("SF4")    
			dbSetOrder(1)   			
			if dbSeek(xFilial("SF4")+SA2->A2__TESIMP)
                                  
				_cCfop 	:= SF4->F4_CF
				_cTes 	:= SF4->F4_CODIGO 				

 		    	_nBaseICM 	:= "0"
		    	_nPerICM 	:= "0"
		    	_nValICM 	:= "0"
		    	_nBaseIPI 	:= "0"
		    	_nBaseCST 	:= "0"
		    	_nValCST 	:= "0"
		    	_nPerIPI 	:= "0"
		    	_nValIPI 	:= "0"
		    	_nBasePIS 	:= "0"
		    	_nPerPIS 	:= "0"
		    	_nValPIS 	:= "0"
		    	_nBaseCOF 	:= "0"
		    	_nPerCOF 	:= "0"
		    	_nValCOF 	:= "0"

				oImposto := oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_imposto
				if Type("oImposto:_ICMS")<>"U"
					nLenSit := Len(aSitTrib)
					For nY := 1 To nLenSit
						If Type("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT")<>"U"
			 		    	_nBaseICM 	:= &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBC:TEXT")
					    	_nPerICM 	:= &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_pICMS:TEXT")
					    	_nValICM 	:= &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT")
					    	
							If Type("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBCST:TEXT")<>"U"
						    	_nBaseCST 	:= &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vBCST:TEXT")
						    	_nValCST 	:= &("oImposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMSST:TEXT")
							endif						    	
					    endif	
					next nY
				endif
		    	
				if Type("oImposto:_IPI:_IPITrib")<>"U"      
					if Type("oImposto:_IPI:_IPITrib:_vBC")<>"U"
				    	_nBaseIPI 	:= oImposto:_IPI:_IPITrib:_vBC:TEXT
				    	_nPerIPI 	:= oImposto:_IPI:_IPITrib:_pIPI:TEXT
			       		_nValIPI 	:= oImposto:_IPI:_IPITrib:_vIPI:TEXT
			        endif
				endif
							    	
				if Type("oImposto:_PIS:_PISAliq")<>"U"
			    	_nBasePIS 	:= oImposto:_PIS:_PISAliq:_vBC:TEXT
			    	_nPerPIS 	:= oImposto:_PIS:_PISAliq:_pPIS:TEXT
			    	_nValPIS 	:= oImposto:_PIS:_PISAliq:_vPIS:TEXT
				endif
					
				if Type("oImposto:_COFINS:_COFINSAliq")<>"U"
			    	_nBaseCOF 	:= oImposto:_COFINS:_COFINSAliq:_vBC:TEXT
			    	_nPerCOF 	:= oImposto:_COFINS:_COFINSAliq:_pCOFINS:TEXT
			    	_nValCOF 	:= oImposto:_COFINS:_COFINSAliq:_vCOFINS:TEXT
				endif
					
				If Empty(Posicione("SB1",1,xFilial("SB1") + alltrim(_cProd),"B1_COD"))
		    		_log += "Produto não localizado na SB1: ;" + _cProd + ";" + oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_xProd:TEXT + ";" + oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT + ";" + oXML:_NfeProc:_NFe:_InfNFe:_Emit:_CNPJ:TEXT + _cEOL 
					_lExec := .F.
				endif			    
		    	
				DbSelectArea("SZ3")
				DbSetOrder(4)
				If(DbSeek(xFilial("SZ3")+SZ2->Z2_CODIGO+SB1->B1_COD))

			    	If _lExec 
			    		_nTot := Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_qCom:TEXT) * Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT)
	  
			    	    if _nTot > 0
			  				AADD(_aLinha,{"D1_COD"	    		,SB1->B1_COD													,NIL})
							AADD(_aLinha,{"D1_LOCAL"	    	,SB1->B1_LOCPAD    												,NIL})
							AADD(_aLinha,{"D1_UM"				,SB1->B1_UM    	   												,NIL})
							AADD(_aLinha,{"D1_QUANT"  			,Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_qCom:TEXT)		,NIL})
							AADD(_aLinha,{"D1_VUNIT"	    	,Val(oXml:_NfeProc:_NFe:_InfNFe:_Det[nx]:_Prod:_vUnCom:TEXT) 	,NIL})
							AADD(_aLinha,{"D1_TOTAL"	    	,_nTot															,NIL})
//							AADD(_aLinha,{"D1_TESACLA"    		,_cTes															,NIL})
//							AADD(_aLinha,{"D1_CF"	    		,_cCfop															,NIL})
	
							AADD(_aLinha,{"D1_IPI" 		   		,val(_nPerIPI)													,NIL})
							AADD(_aLinha,{"D1_VALIPI"    		,val(_nValIPI)													,NIL})
							AADD(_aLinha,{"D1_BASEIPI"    		,val(_nBaseIPI)													,NIL})
	
							AADD(_aLinha,{"D1_PICM" 	   		,val(_nPerICM)													,NIL})
							AADD(_aLinha,{"D1_VALICM"    		,val(_nValICM)													,NIL})
							AADD(_aLinha,{"D1_BASEICM"    		,val(_nBaseICM)													,NIL})
							AADD(_aLinha,{"D1_ICMSRET"    		,val(_nValCST)													,NIL})
							AADD(_aLinha,{"D1_BRICMS"    		,val(_nBaseCST)													,NIL})
	
							AADD(_aLinha,{"D1_BASIMP5"    		,val(_nBaseCOF)													,NIL})
							AADD(_aLinha,{"D1_BASIMP6"    		,val(_nBasePIS)													,NIL})
							AADD(_aLinha,{"D1_VALIMP5"    		,val(_nValCOF)													,NIL})
							AADD(_aLinha,{"D1_VALIMP6"    		,val(_nValPIS)													,NIL})
							AADD(_aLinha,{"D1_ALQIMP5"    		,val(_nPerCOF)													,NIL})
							AADD(_aLinha,{"D1_ALQIMP6"    		,val(_nPerPIS)													,NIL})
	
//							AADD(_aLinha,{"D1_PEDIDO" 	   		,SZ3->Z3_PEDIDO				 									,NIL})
//							AADD(_aLinha,{"D1_ITEMPC" 	   		,SZ3->Z3_ITPEDCO												,NIL})
	
							AADD(_aLinha,{"D1__CODPRO"    		,SZ2->Z2_CODIGO													,NIL})
	
						  	AADD(_aItens,_aLinha)
							_aLinha := {} 
						endif
					EndIf
				
				Else
		    		_log += "Não encontrado produto do pedido de importação: " + SB1->B1_COD + _cEOL
					_lExec := .F.
				EndIf
			  else
	    		_log += "CFOP sem correspondência de TES: " + _cFop + _cEOL
				_lExec := .F.
			  endif
			  */ 
	    Next nx
	    
        If _lExec

   			MsExecAuto({|x,y,z,m,p| Mata140(x,y,z,m,p)},_aCab,_aItens,3,.F.,0)
	    
		    If lMsErroAuto
		       MostraErro()
		    Else
		    	DbSelectArea("SF1")
		    	DbSetOrder(1)
		    	If(DbSeek(xFilial("SF1")+_cNF+_cSerie+_cForn+_cLoja))
			    	_lImport := .T.
	
			    	_log += "Importação realizada com sucesso" + ENTER
				Else
					_log += "Processo abortado" + ENTER
				EndIf		    	
		    EndIf
		Else
			_log += "Não foi possivel gerar o documento de entrada" + ENTER
		EndIf
		
	Else
		_log += "Estrutura do arquivo inválida (TAG com protocolo de autorizacao nao foi localizada). Caso este erro persista, entre em contato com o fornecedor" + ENTER
	EndIf

Else	
	_log += "Erro na abertura do arquivo" + _cEOL + _cErro + _cEOL + _cAviso + ENTER
EndIf 

If (Empty(_log))
	msgAlert ("Problemas na importação da nota")
Else
	msgAlert (_log)
EndIf

cFilAnt := _cCodFilOld
      
Return                                                                                                                       

/*
+-------------+----------+--------+--------------------------------+-------+---------------+
| Programa:   | PathXML  | Autor: | Rubens Cruz - Anadi			   | Data: | Janeiro/2015  |
+-------------+----------+--------+--------------------------------+-------+---------------+
| Descrição:  | cGetFile para preencher caminho do XML									   |
+-------------+----------------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         	   |
+-------------+----------------------------------------------------------------------------+
*/
                                                      
Static Function PathXML()
Local cCamAux
Local nOpcoes := GETF_LOCALHARD+GETF_LOCALFLOPPY//+GETF_NETWORKDRIVE
     
cCamAux := cGetFile("*.xml|*.xml","Selecione o XML para importação de dados",0,,.t.,nOpcoes) 

If (cCamAux != "")
	_cPath  := Padr(cCamAux,100)
	_cProc	:= space(TamSX3("Z2_CODIGO")[1]) 
	_cNota	:= ""
	_cSerie	:= ""
EndIf


Return


/*
+-------------+----------+--------+--------------------------------+-------+---------------+
| Programa:   | FilProc  | Autor: | Rubens Cruz - Anadi			   | Data: | Janeiro/2015  |
+-------------+----------+--------+--------------------------------+-------+---------------+
| Descrição:  | Valida Processo digitado e preenche Nota e Serie com base no XML		   |
+-------------+----------------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         	   |
+-------------+----------------------------------------------------------------------------+
*/
                                                      
Static Function FilProc()
Local lRet	:= .T. 
Local oXml	:= Nil
Local _cErro := _cAviso := "" 
Local _cCam	:= "\temp\"
Local lSucess	:= .T.

If(Empty(_cPath))
	_cNota 	:= ""
	_cSerie	:= ""
	Return lRet
EndIf  

//Copia o arquivo para a protheus_Data pois o XmlParserFile só le arquivos la dentro
lSucess := CpyT2S(_cPath,_cCam,.T.)

if !lSucess
  Alert("Não foi possivel copiar arquivo para o servidor")
  Return lRet
endif

oXml := XmlParserFile(_cCam + RETFILENAME(_cPath) + ".xml","_",@_cErro,@_cAviso)

If Valtype(oXml) == "O"    
		_cNota 	:= oXml:_NfeProc:_NFe:_InfNFe:_ide:_nNF:TEXT
		_cSerie	:= oXml:_NfeProc:_NFe:_InfNFe:_ide:_serie:TEXT

		//Apaga o arquivo copiado para o servidor após a consulta
		If (FErase(_cCam + RETFILENAME(_cPath) + ".xml",,.F.) != 0)
			Alert("Não foi possível apagar arquivo: " + FError())
		EndIf
Else           
	Alert(" XML não encontrado")
	lRet := .F.
EndIf

Return lRet