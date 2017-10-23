/*
+------------+---------+--------+--------------------+-------+------------+
| Programa:  |baca08   | Autor: | Rubens Silva       | Data: |  Nov/2014  |
+------------+---------+--------+--------------------+-------+------------+
| Descrição: | Atualiza grupo Tributario Isapa                            |
|            | 															  |
+------------+------------------------------------------------------------+
| Uso:       | Isapa                                                      |
+------------+------------------------------------------------------------+
*/
	User Function BACA08()
	Processa({|| BACACOO8() },"Atualizando Cadastro...") 
Return

Static Function BACACOO8()
	Local _cDbf     := "\data\SE1COM.dbf"
	Local _cLogErro := ""
	Local _cLogFile := "\data\Error.log"                               
	Local _CCOPROD  := SE1->(GetArea())
	
	If Select("SE1COM") > 0
		SE1COM->(dbCloseArea())
	EndIf

  	Use &(_cDbf) Alias "SE1COM" New 
  	DbSelectarea("SE1COM") 
	ProcRegua(RecCount())
	While !SE1COM->(Eof())
		DbSelectarea("SE1") 
		DbSetOrder(1)    
		If DbSeek(/*("SE1")+*/SE1COM->E1_FILIAL+SE1COM->E1_PREFIXO+SE1COM->E1_NUM+SE1COM->E1_PARCELA+SE1COM->E1_TIPO)
			//IncProc("Processando Produto ..." +GRP01->PRODUTO)      ?
			IncProc("Processando NOTAS ..." +SE1COM->E1_FILIAL+SE1COM->E1_PREFIXO+SE1COM->E1_NUM+SE1COM->E1_PARCELA+SE1COM->E1_TIPO)
			While !RecLock("SE1",.F.)
			EndDo		
			//	SA1->A2_CONTA	:= SA1CONT->A2_CONTA
			
			
			 //	SA1->A1_NOME 		:= SA1CONT->A1_NOME
			 //	SA1->A1_VEND     	:= SA1CONT->A1_VEND
				SE1->E1_BASCOM1		:= SE1COM->E1_BASCOM1
				SE1->E1__BASIPI		:= SE1COM->E1__BASIPI
			 //	SA1->A1_MSALDO		:= SA1CONT->A1__MSALD
			 //	SA1->A1_MCOMPRA		:= SA1CONT->A1__MCOMP
			
			
			MsUnLock()                                   
			
		Else
			_cLogErro += ", " + SE1COM->E1_FILIAL+SE1COM->E1_PREFIXO+SE1COM->E1_NUM+SE1COM->E1_PARCELA+SE1COM->E1_TIPO	
		EndIf
        SE1COM->(DbSkip())
	EndDo                 
//	Salva Log de Produtos Não Encontrados
	MemoWrite(_cLogFile,_cLogErro)
	SE1COM->(dbCloseArea())
    RestArea(_CCOPROD)
Return
                                    