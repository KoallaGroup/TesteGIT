#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT103NTZ
Ponto de entrada para tratar a natureza de acordo com o Pedido de Compras,
na geração do documento de entrada. 

@author	Sigfrido E Solorzano Rodriguez
@since
@param
@return
/*/                                                                            
//-------------------------------------------------------------------
User Function MT103NTZ()
	Local aArea := GetArea()
	Local aAreaSC7 := SC7->(GetArea())     
	Local cNatureza	:= ParamIxb[1]
	Local nPosPedido, nPosItemPC, cMT103NTZ	
	
	nPosPedido	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_PEDIDO" })
	nPosItemPC	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_ITEMPC" })
	If nPosPedido > 0
		If !Empty(aCols[1,nPosPedido])  // Verifica Pedido de Compras
		    SC7->(dbSetOrder(14))
		    SC7->(DbSeek(XFilial("SD1")+aCols[1,nPosPedido]+aCols[1,nPosItemPC]))
		                     	
		    If SC7->(DbSeek(XFilial("SD1")+aCols[1,nPosPedido]+aCols[1,nPosItemPC]))
		    	If !Empty(SC7->C7_NATUREZ)
		    		cMT103NTZ	:= SC7->C7_NATUREZ
		    	Else    
		    		Help('' , 1 , 'Atenção' , ,"A Natureza do Pedido No./Item: " + aCols[1,nPosPedido] + "/" + aCols[1,nPosItemPC] + " está vazia. Será considerada a Natureza do Fornecedor e não do Pedido de Compras.", 2 , 2 )
		    		cMT103NTZ	:= cNatureza
		    	Endif
		    Else 
				cMT103NTZ	:= cNatureza
		    Endif      	
		    
		    RestArea(aAreaSC7)    
		    RestArea(aArea)
		Endif
	Else
		cMT103NTZ	:= cNatureza		   		
    EndIf
return(cMT103NTZ)