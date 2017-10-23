#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFATA06			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Amarração de Vendedor x Transportador											 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFATA06()

	Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}
	Local nLinha:= nLin02 	:= nOpca := 0, oDlg, oGet
	Local nOpcx := 4
	Local cSeek	:= xFilial("SZI")+SA3->A3_COD+'T'
	Local cWhile:= "SZI->(ZI_FILIAL+ZI_VEND+ZI_TIPO)"
	Local aYesFields:= {}   
	Local aNoFields	:= {}
	
	Local cCadastro	:= "Vendedor x Transportador"
	
	//Monta a entrada de dados do arquivo
	Private aTela[0][0],aGets[0],aHeader[0]

	aadd(aYesFields, "ZI_TRANSP")
	aadd(aYesFields, "ZI_NMETRAN")
	
	//Cria aHeader e aCols
	FillGetDados(nOpcx,"SZI",3,cSeek,{|| &cWhile },{||.T.},aNoFields,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)
	
	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd(aObjects,{100,015,.t.,.f.})
	AAdd(aObjects,{100,100,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	nLinha  := aPosObj[1,1] + 4
	nLin02  := aPosObj[1,1] + 2
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,020,045,058,150,170,128,143,172,186,205,222,250,270} } )

	@nLinha, aPosGet[1,01] Say "Codigo :"		SIZE 25,10 OF oDlg PIXEL
	@nLinha, aPosGet[1,02] Say SA3->A3_COD 		SIZE 18,10 OF oDlg PIXEL

	@nLinha, aPosGet[1,03] Say "Vendedor :"		SIZE 40,10 OF oDlg PIXEL
	@nLinha, aPosGet[1,04] Say SA3->A3_NOME 	SIZE 180,10 OF oDlg PIXEL
		
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_IFATA06C()","U_IFATA06D()","",.T.)
	Private oGetDad := oGet
	   
	ACTIVATE MSDIALOG oDlg On Init IFATA06B(oDlg,{||nOpca:=1, if(oGet:TudoOk(),oDlg:End(),nOpca := 0)}, {||oDlg:End()})

	if nOpca == 1
		U_IFATA06E()
	endif
		
	RestArea(aArea)						
Return (nOpca)

    

Static Function IFATA06B(oDlg,bOk,bCancel,nOpc)
	Local aButtons   := {}
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


user Function IFATA06C()
	local _lRet := .T.
	local _nZI_TRANSP	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_TRANSP" })
	
    for x:=1 to len(aCols)                         

		if ! aCols[x][len(aHeader)+1] .and. x <> n
			
			if aCols[x][_nZI_TRANSP] == aCols[n][_nZI_TRANSP]
				alert ("Já existe essa Transportadora relacionada com esse vendedor !!")
          		_lRet := .F.
				exit
	  		endif
	        	             
        endif
	next x

return _lRet
            


user Function IFATA06D()
	local _lRet := .T.

return _lRet


user Function IFATA06E()
       
	local _nZI_TRANSP	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_TRANSP" })
	local _nRecno		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_REC_WT" })

   	dbSelectArea("SZI")     

    for x:=1 to len(aCols)                         

		if ! aCols[x][len(aHeader)+1]
			
        	if aCols[x][_nRecno] > 0
        		_cGrava := .F.
        		go aCols[x][_nRecno]
        	else
        		_cGrava := .T.
        	endif

        	do while !reclock("SZI",_cGrava)
        	enddo
        	
        	SZI->ZI_FILIAL := xFilial("SZI")
        	SZI->ZI_VEND   := SA3->A3_COD
        	SZI->ZI_TIPO   := "T"
        	SZI->ZI_TRANSP := aCols[x][_nZI_TRANSP]
                                                   
			if _cGrava 
	        	SZI->ZI_DTINCL 	:= date()
	        	SZI->ZI_HRINCL 	:= time()
	  		else
	        	SZI->ZI_DTALT 	:= date()
	        	SZI->ZI_HRALT 	:= time()
	  		endif
	        	             
        	msUnlock()

        else
		
        	if aCols[x][_nRecno] > 0
	      		go aCols[x][_nRecno]
	
	        	do while !reclock("SZI", .F.)
	        	enddo
	        	delete
	        	msUnlock()       
	        	
				dbSetOrder(3)
				dbSeek(xFilial("SZI")+SA3->A3_COD+'R'+aCols[x][_nZI_TRANSP])
				do while ZI_VEND == SA3->A3_COD .and. ZI_TIPO == 'R' .and. ZI_TRANSP == aCols[x][_nZI_TRANSP]
		        	do while !reclock("SZI", .F.)
		        	enddo
		        	delete
		        	msUnlock()       
					SZI->(dbSkip())
				enddo
			endif
	
		endif
		                                  
	next x

	msgAlert ("Vinculo com Transportadoras atualizado com Sucesso !!")
       
return 