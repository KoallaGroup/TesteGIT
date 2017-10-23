/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103IPC			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada acionado após a inclusão do pedido de compra no documento		|
|				de entrada																		|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT103IPC()
Local _nPQtd := ASCAN(aHeader,{|x|Alltrim(x[2]) == "D1_QUANT"})
Local _nPQt2 := ASCAN(aHeader,{|x|Alltrim(x[2]) == "D1__QTDSEG"})
Local _nPUM2 := ASCAN(aHeader,{|x|Alltrim(x[2]) == "D1__UNMED2"})
Local _nPUM1 := ASCAN(aHeader,{|x|Alltrim(x[2]) == "D1_UM"})
   
n := Len(aCols)
M->D1_COD := aCols[Len(aCols)][ASCAN(aHeader,{|x|x[2] = "D1_COD"})]
if ExistTrigger("D1_COD")
	RunTrigger(2,Len(aCols),,"D1_COD")
endif

M->D1_QUANT := aCols[Len(aCols)][ASCAN(aHeader,{|x|x[2] = "D1_QUANT"})]
if ExistTrigger("D1_QUANT")
	RunTrigger(2,Len(aCols),,"D1_QUANT")
endif

If _nPQt2 > 0 .And. _nPUM2 > 0
    If !Empty(aCols[n][_nPUM2])
        SZQ->( dbSetOrder(2) )
        if SZQ->( dbSeek(xFilial("SZQ") + aCols[n][_nPUM2] + aCols[n][_nPUM1]) )
            if SZQ->ZQ_TIPOCON = "M"            
                aCols[n][_nPQt2] := (aCols[n][_nPQtd] * SZQ->ZQ_CONV)
            Elseif SZQ->ZQ_TIPOCON = "D"    
                aCols[n][_nPQt2] := (aCols[n][_nPQtd] / SZQ->ZQ_CONV)
            Endif
        EndIf
    EndIf
EndIf 

Return .T.