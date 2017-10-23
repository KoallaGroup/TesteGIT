#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IFINR12   ºAutor  ³Alexandre Caetano   º Data ³  05/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa relatório em Crystal Report - (Royalties)           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IFINR12()
local _aArea := GetArea()
local _cPerg := "IFINR12"
local _cFilbkp := cfilant
local dDtIni              
Local dDtB9_01 	:= GETMV("MV_ULMES")
Local dDtB9_03	:= GETMV("MV_ULMES")
Local dDtB9_04	:= GETMV("MV_ULMES")
Local dDtB9_05	:= GETMV("MV_ULMES")
Local dDtB9_06	:= GETMV("MV_ULMES")

AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf 

//================================
dDtIni := MV_PAR06 

If (!Empty(MV_PAR01))
	cfilAnt := MV_PAR01 
EndIf
/*Else
	dbSelectArea( "SM0" )
	dbGoTop() 
	cfilAnt := SM0->M0_CODFIL 
	dDtFAnt := GETMV("MV_ULMES")
	While !SM0->( EOF() )
		If dDtFAnt <> GETMV("MV_ULMES")
		 	Alert("Data fechamento estoque (MV_ULMES) diferente entre filiais. Pode ser que ocorram divergencias nos saldos iniciais.")
		EndIf     
		SM0->( dbSkip() )
		cFilAnt := SM0->M0_CODFIL 
	EndDo   
EndIf*/ 

	dbSelectArea( "SM0" )
	dbGoTop() 
	cfilAnt := SM0->M0_CODFIL 
	While !SM0->( EOF() ) 
		If cfilAnt == "01"
			dDtB9_01 := GETMV("MV_ULMES")
		ElseIf cfilAnt == "03"   
			dDtB9_03 := GETMV("MV_ULMES")  
		ElseIf cfilAnt == "04"   
			dDtB9_04 := GETMV("MV_ULMES")  			
		ElseIf cfilAnt == "05"   
			dDtB9_05 := GETMV("MV_ULMES") 
		ElseIf cfilAnt == "06"   
			dDtB9_06 := GETMV("MV_ULMES")  
		EndIf 			
		SM0->( dbSkip() )
		cFilAnt := SM0->M0_CODFIL 
	EndDo   
	
cfilant := _cFilbkp
                   
//dDtB9 := CtoD("31" + "/" + Strzero( ( Month(MV_PAR07) - 1 ),2,0 ) + "/" + Str( Year(MV_PAR07) ))
//if Empty(dDtB9)                                                     
  //	dDtB9 := CtoD("30" + "/" + Strzero( ( Month(MV_PAR07) - 1 ),2,0 ) + "/" + Str( Year(MV_PAR07) ))
//Endif  

//=====================================================  

If dDtini < dDtB9_01
	dDtB9_01 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
EndIf

If dDtini < dDtB9_03
	dDtB9_03 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
EndIf

If dDtini < dDtB9_04
	dDtB9_04 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
EndIf
   
If dDtini < dDtB9_05
	dDtB9_05 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
EndIf

If dDtini < dDtB9_06
	dDtB9_06 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
EndIf

                                             
if Empty(MV_PAR04)                                                       
	cMarcaIni 	:= Space( avSx3("Z5_CODIGO",3) )
	cMarcaFim 	:= Replicate( "Z",avSx3("Z5_CODIGO",3) )
	cDescMarca  := "Todas"
Else                      
	cMarcaIni 	:= MV_PAR04
	cMarcaFim   := MV_PAR04
	cDescMarca 	:= MV_PAR04 + " - " + Posicione("SZ5",1,xFilial("SZ5") + MV_PAR04, "Z5_DESC")
Endif
                                                                        
cParms := MV_PAR01 + ";" + MV_PAR02 + ";" + MV_PAR03  + ";" + cMarcaIni  + ";" + cMarcaFim  + ";" + Transform(MV_PAR05,"@E 99,99") + ";" 
cParms += DtoS(MV_PAR06) + ";" + DtoS(MV_PAR07) + ";" + DtoS(dDatabase) + ";"  
cParms += DtoS(dDtB9_01) + ";" + DtoS(dDtB9_03) + ";" + DtoS(dDtB9_04) + ";" + DtoS(dDtB9_05) + ";" + DtoS(dDtB9_06)
                    
if MV_PAR09 = 1
                                                                                                       		
	x:="1;0;1;IFINR12"              
   	CallCrys("IFINR12",cParms, x)   
   
Elseif MV_PAR09 = 2

	x:="1;0;1;IFINR12b"              
   	CallCrys("IFINR12b",cParms, x) 

Elseif MV_PAR09 = 3

	If !Empty(MV_PAR01)
		Alert("Esta opcao de relatorio deve ser executada sem o filtro de filial.")
	Else
		x:="1;0;1;IFINR12c"              
   		CallCrys("IFINR12c",cParms, x)      	   
	EndIf   

Endif

restArea (_aArea)

cfilant := _cFilbkp
Return(.t.)
//----------------------------------------


Static Function AjustSX1(_cPerg)
	Local _aArea := GetArea()
	Local aHelpPor	:= {}
  //PutSx1(X1_GRUPO, X1_ORDEM, X1_PERGUNT       , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO           , X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_F3      , X1_GRPSXG, X1_PYME, X1_VAR01  , X1_DEF01   , X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, aHelpPor, aHelpEng, aHelpSpa, X1_HELP)	   
    PutSx1(_cPerg  , "01"    , "Filial         ", " "      , " "      , "mv_ch1"  , "C"    , 02                   , 0         , 0        , "G"   , ""      , "DLB"      , ""       , ""     , "mv_par01", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
    PutSx1(_cPerg  , "02"    , "Produto de     ", " "      , " "      , "mv_ch2"  , "C"    , AvSx3("B1_COD",3)    , 0         , 0        , "G"   , ""      , "SB1"      , ""       , ""     , "mv_par02", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
    PutSx1(_cPerg  , "03"    , "Produto ate    ", " "      , " "      , "mv_ch3"  , "C"    , AvSx3("B1_COD",3)    , 0         , 0        , "G"   , ""      , "SB1"      , ""       , ""     , "mv_par03", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
    PutSx1(_cPerg  , "04"    , "Marca          ", " "      , " "      , "mv_ch4"  , "C"    , AvSx3("B1__MARCA",3) , 0         , 0        , "G"   , ""      , "SZ5"      , ""       , ""     , "mv_par04", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
	PutSx1(_cPerg  , "05"    , "Royalties      ", " "      , " "      , "mv_ch5"  , "N"    , 05                   , 2         , 0        , "G"   , ""      , "   "      , ""       , ""     , "mv_par05", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
  	PutSx1(_cPerg  , "06"    , "Período de     ", " "      , " "      , "mv_ch6"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par06", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
	PutSx1(_cPerg  , "07"    , "Período até    ", " "      , " "      , "mv_ch7"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par07", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
	PutSx1(_cPerg  , "08"    , "Soma Poder 3º  ", " "      , " "      , "mv_ch8"  , "G"    , 01                   , 0         , 0        , "C"   , ""      , ""         , ""       , ""     , "mv_par08", "Sim"      , ""        , ""        , ""      , "Não"   , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "09"    , "Tipo           ", " "      , " "      , "mv_ch9"  , "G"    , 01                   , 0         , 0        , "C"   , ""      , ""         , ""       , ""     , "mv_par09", "Relatório", ""        , ""        , ""      , "Resumo", ""        , ""        , "Rel. Royalties", ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
				     
	RestArea (_aArea)

Return(_cPerg)                              

