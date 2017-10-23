/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : TMKVDEL			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para validação dos ítens do Pedido de Call Center				 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function TMKVDEL()
local aArea			:= GetArea()
local lRetorno		:= .T.
local cCodRet 		:= ""
local _nUB__MOTCAN	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__MOTCAN" })  
local _nUB__CODKIT  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__CODKIT" })  
Local _nPUsCan		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DTCAN"  })   
Local _nPHrCan		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__HRCAN"  })
Local _nPItem		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"    })
Local _nPPai		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ITEPAI" })
Local _nPFilh		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ITFILH" })
    
    if nfolder == 2 //teleatendimento    
        if aCols[n][len(aHeader)+1] .and. empty(aCols[n][_nUB__MOTCAN])
            DbSelectArea("SZD")
            DbGoTop()        
            lRet := ConPad1(,,,"SZD_IT",cCodRet,, .F.)
            
			if lRet
                cCodRet := SZD->ZD_COD
                aCols[n][_nUB__MOTCAN] := cCodRet
                aCols[n][_nPUsCan] 	   := Date()
                aCols[n][_nPHrCan] 	   := Time()

                //Retira a resera do item
                U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[n][_nPItem],"","",0,"E")
                
                //Se for um KIT, todos seus itens devem ser deletados                                
                if ! empty(aCols[n][_nUB__CODKIT])  
                    _cKit := aCols[n][_nUB__CODKIT]
                    for xx := 1 to len(aCols)                    
                        if aCols[xx][_nUB__CODKIT] == _cKit .And. xx != n
                            aCols[xx][_nUB__MOTCAN]   := cCodRet
                            aCols[xx][_nPUsCan] 	  := Date()
                            aCols[xx][_nPHrCan] 	  := Time()
                            aCols[xx][len(aHeader)+1] := .T.
                            U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[xx][_nPItem],"","",0,"E")

                            If !MaFisFound("IT",xx)
                                MaFisAdd(   ""  , ""    , 0     , 0     ,;
                                            0   , ""    , ""    , NIL   ,;
                                            0   , 0     , 0     , 0     ,;
                                            0   )
                            Endif
                            MaFisDel(xx,aCols[xx][Len(aCols[xx])])
                            
                            Eval(bRefresh)
                            Eval(bGDRefresh)

                            //Atualiza a gravação online
                            U_ITMKGRON("SUB","",xx,lRet)                            
                        endif
                    
                    next xx 
                
                endif
                
                If !Empty(aCols[n][_nPPai])
                	xx := aScan(aCols, { |x| AllTrim(x[_nPItem]) == aCols[n][_nPPai] })
                	If xx > 0
	                    aCols[xx][_nUB__MOTCAN]   := cCodRet
	                    aCols[xx][_nPUsCan] 	  := Date()
	                    aCols[xx][_nPHrCan] 	  := Time()
	                    aCols[xx][len(aHeader)+1] := .T.
	                    U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[xx][_nPItem],"","",0,"E")
	
	                    If !MaFisFound("IT",xx)
	                        MaFisAdd(   ""  , ""    , 0     , 0     ,;
	                                    0   , ""    , ""    , NIL   ,;
	                                    0   , 0     , 0     , 0     ,;
	                                    0   )
	                    Endif
	                    MaFisDel(xx,aCols[xx][Len(aCols[xx])])
	                    
	                    Eval(bRefresh)
	                    Eval(bGDRefresh)
	
	                    //Atualiza a gravação online
	                    U_ITMKGRON("SUB","",xx,lRet)
	                EndIf
	            ElseIf !Empty(aCols[n][_nPFilh])
                	xx := aScan(aCols, { |x| AllTrim(x[_nPItem]) == aCols[n][_nPFilh] })
                	If xx > 0
	                    aCols[xx][_nUB__MOTCAN]   := cCodRet
	                    aCols[xx][_nPUsCan] 	  := Date()
	                    aCols[xx][_nPHrCan] 	  := Time()
	                    aCols[xx][len(aHeader)+1] := .T.
	                    U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,aCols[xx][_nPItem],"","",0,"E")
	
	                    If !MaFisFound("IT",xx)
	                        MaFisAdd(   ""  , ""    , 0     , 0     ,;
	                                    0   , ""    , ""    , NIL   ,;
	                                    0   , 0     , 0     , 0     ,;
	                                    0   )
	                    Endif
	                    MaFisDel(xx,aCols[xx][Len(aCols[xx])])
	                    
	                    Eval(bRefresh)
	                    Eval(bGDRefresh)
	
	                    //Atualiza a gravação online
	                    U_ITMKGRON("SUB","",xx,lRet)
	                EndIf
                EndIf
                
                //Atualiza a gravação online
                U_ITMKGRON("SUB","",n,lRet)
			else
                aCols[n][len(aHeader)+1] := .F.
				lRetorno:= .F.
			endif
		else
            MsgAlert("Itens deletados não podem ser reativados !!")
            aCols[n][len(aHeader)+1] := .T.
            If !MaFisFound("IT",n)
                MaFisAdd(   ""  , ""    , 0     , 0     ,;
                            0   , ""    , ""    , NIL   ,;
                            0   , 0     , 0     , 0     ,;
                            0   )
            Endif
            MaFisDel(n,aCols[n][Len(aCols[n])])
            
            Eval(bRefresh)
            Eval(bGDRefresh)
		endif 
	endif          
    
	restArea(aArea)
return lRetorno