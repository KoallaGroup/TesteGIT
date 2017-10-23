#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIFINR12   บAutor  ณAlexandre Caetano   บ Data ณ  05/Nov/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta relat๓rio em Crystal Report - (Royalties)           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IFINR12()
local _aArea := GetArea()
local _cPerg := "IFINR12"
local _cFilbkp := cfilant
local dDtIni


AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf 

//================================
dDtIni := MV_PAR06 

If (!Empty(MV_PAR01))
	cfilant := MV_PAR01
EndIf

//dDtB9 := CtoD("31" + "/" + Strzero( ( Month(MV_PAR07) - 1 ),2,0 ) + "/" + Str( Year(MV_PAR07) ))
//if Empty(dDtB9)                                                     
  //	dDtB9 := CtoD("30" + "/" + Strzero( ( Month(MV_PAR07) - 1 ),2,0 ) + "/" + Str( Year(MV_PAR07) ))
//Endif  

//=====================================================
if dDtini < GETMV("MV_ULMES")
	dDtB9 := CtoD("01" + "/" + Alltrim(str(month(MV_PAR06))) + "/" + Alltrim(str(year(MV_PAR06)))) - 1
else  
	dDtB9 := GETMV("MV_ULMES") 
endif

                                             
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
cParms += DtoS(MV_PAR06) + ";" + DtoS(MV_PAR07) + ";" + cDescMarca + ";" + DtoS(dDatabase) + ";" + Str(MV_PAR08) + ";" + DtoS(dDtB9)
                    
if MV_PAR09 = 1
   
	x:="1;0;1;IFINR12"              
   	CallCrys("IFINR12",cParms, x)   
   
Elseif MV_PAR09 = 2

	x:="1;0;1;IFINR12b"              
   	CallCrys("IFINR12b",cParms, x)

Elseif MV_PAR09 = 3

	x:="1;0;1;IFINR12c"              
   	CallCrys("IFINR12c",cParms, x)      	   

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
  	PutSx1(_cPerg  , "06"    , "Perํodo de     ", " "      , " "      , "mv_ch6"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par06", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
	PutSx1(_cPerg  , "07"    , "Perํodo at้    ", " "      , " "      , "mv_ch7"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par07", ""         , ""        , ""        , ""      , ""      , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
	PutSx1(_cPerg  , "08"    , "Soma Poder 3บ  ", " "      , " "      , "mv_ch8"  , "G"    , 01                   , 0         , 0        , "C"   , ""      , ""         , ""       , ""     , "mv_par08", "Sim"      , ""        , ""        , ""      , "Nใo"   , ""        , ""        , ""              , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "09"    , "Tipo           ", " "      , " "      , "mv_ch9"  , "G"    , 01                   , 0         , 0        , "C"   , ""      , ""         , ""       , ""     , "mv_par09", "Relat๓rio", ""        , ""        , ""      , "Resumo", ""        , ""        , "Rel. Royalties", ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
				     
	RestArea (_aArea)

Return(_cPerg)                              

