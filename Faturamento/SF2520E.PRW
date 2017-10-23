#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : SF2520E	 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar tabelas do REOA e FUNDAP na exclusão de NF de saída|
|-----------------------------------------------------------------------------------------------|	
*/

user Function SF2520E()
local _aArea	:= GetArea()
local _cDocto, _cPed := _cSeg := ""
local _cSerie
local _cFornecedor
local _cLoja
local _cItem
local _nQtdeUtilizado

DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)    

/*Alterada forma de buscar pedido do Call Center
Jorge H. - Anadi
DbSelectArea("SUA")
//DbOrderNickName("SUANF")
//If DbSeek(xFilial("SUA") + cFilAnt + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
DbSetOrder(8)
If DbSeek(xFilial("SUA") + SD2->D2_PEDIDO)
	_cPed := SUA->UA_NUM
	_cSeg := SUA->UA__SEGISP
EndIf
*/

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5") + SD2->D2_PEDIDO) .And. !Empty(SC5->C5__NUMSUA)
	DbSelectArea("SUA")
	DbSetOrder(1)
	If DbSeek(xFilial("SUA") + SD2->D2_PEDIDO)
		_cPed := SUA->UA_NUM
		_cSeg := SUA->UA__SEGISP
	EndIf
EndIf

If Empty(_cPed)
	_cPed := SD2->D2_PEDIDO + "FAT" 
	_cSeg := Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO,"C5__SEGISP")
EndIf

//Faz envio da NF para o ArMHAzena
_aResult := TCSPEXEC("PROC_PMHA_INTER_NOTAFISCAL",cEmpAnt,SF2->F2_FILIAL,_cSeg,_cPed,SF2->F2_DOC,SF2->F2_SERIE,"EXC",IIf(!Empty(SF2->F2__TRAFIL),SF2->F2_FILIAL,""),Alltrim(SF2->F2__TRAFIL))
If !Empty(_aResult)
	If _aResult[1] == "S"
		Help( Nil, Nil, "ENVNOTFIS", Nil, "Problema no envio de cancelamento ao WMS - " + _aResult[2], 1, 0 ) 
		_lRet := .f.
	EndIf
Else
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar Exclusao de Documento de saida para arMHAzena", 1, 0 )

	_lRet := .f.
EndIf
//------TERMINO ENVIO NF AO WMS----------

// REOA
	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
	_cQuery += "WHERE D2_FILIAL = '" + SF2->F2_FILIAL  + "' "
	_cQuery += "  AND D2_DOC = '" + SF2->F2_DOC +  "' "
	_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE +  "' "
	_cQuery += "  AND D_E_L_E_T_ <> '*' "

	if(select("TMPSD2") > 0)
		TMPSD2->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPSD2"

	do while ! TMPSD2->(eof())

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + TMPSD2->D2_TES)
		
		if SF4->F4_ESTOQUE == "S"
	
			dbSelectArea("Z11")		
			dbSetOrder(2)
			if dbSeek(xFilial("Z11")+SF2->F2_DOC+SF2->F2_SERIE+TMPSD2->D2_ITEM)
				do while Z11->Z11_DOCSAI==SF2->F2_DOC .and. Z11->Z11_SERSAI==SF2->F2_SERIE .and. Z11->Z11_ITEMSA==TMPSD2->D2_ITEM
					_cDocto			:= Z11->Z11_DOCENT
					_cSerie			:= Z11->Z11_SERENT
					_cFornecedor	:= Z11->Z11_FORNEC
					_cLoja			:= Z11->Z11_LOJA  
					_cItem			:= Z11->Z11_ITEMEN  
					_cProd			:= Z11->Z11_CODPRO
					_nQtdeUtilizado	:= Z11->Z11_QTDEUT
	
					if reclock("Z11", .F.)
						Z11->(dbDelete())
						msUnlock()
					endif
					
					dbSelectArea("Z12")
					dbSetOrder(1)         
					if dbSeek(xFilial("Z12")+_cDocto+_cSerie+_cFornecedor+_cLoja+_cProd)
						if reclock("Z12", .F.)
					    	Z12->Z12_SALDO	+= _nQtdeUtilizado
						endif
					endif		
	
					Z11->(dbSkip())
				enddo			
	
	       	endif
		endif
      	TMPSD2->( dbSkip() )
	enddo
	
// FIM REOA	  

// FUNDAP

	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
	_cQuery += "WHERE D2_FILIAL = '" + SF2->F2_FILIAL  + "' "
	_cQuery += "  AND D2_DOC = '" + SF2->F2_DOC +  "' "
	_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE +  "' "
	_cQuery += "  AND D_E_L_E_T_ <> '*' "

	if(select("TMPSD2") > 0)
		TMPSD2->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPSD2"

	do while ! TMPSD2->(eof())

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + TMPSD2->D2_TES)
		
		if SF4->F4_ESTOQUE == "S"
	
			dbSelectArea("Z26")		
			dbSetOrder(2)
			if dbSeek(xFilial("Z26")+SF2->F2_DOC+SF2->F2_SERIE+TMPSD2->D2_ITEM)
				do while Z26->Z26_DOCSAI==SF2->F2_DOC .and. Z26->Z26_SERSAI==SF2->F2_SERIE .and. Z26->Z26_ITEMSA==TMPSD2->D2_ITEM
					_cDocto			:= Z26->Z26_DOCENT
					_cSerie			:= Z26->Z26_SERENT
					_cFornecedor	:= Z26->Z26_FORNEC
					_cLoja			:= Z26->Z26_LOJA  
					_cItem			:= Z26->Z26_ITEMEN  
					_cProd			:= Z26->Z26_CODPRO
					_nQtdeUtilizado	:= Z26->Z26_QTDEUT
	
					if reclock("Z26", .F.)
						Z26->(dbDelete())
						msUnlock()
					endif
					
					dbSelectArea("Z25")
					dbSetOrder(1)         
					if dbSeek(xFilial("Z25")+_cDocto+_cSerie+_cFornecedor+_cLoja+_cProd)
						if reclock("Z25", .F.)
					    	Z25->Z25_SALDO	+= _nQtdeUtilizado
						endif
					endif		
	
					Z26->(dbSkip())
				enddo			
	
	       	endif
		endif
      	TMPSD2->( dbSkip() )
	enddo
	
// FIM FUNDAP  
	
	
	restarea(_aArea)

return