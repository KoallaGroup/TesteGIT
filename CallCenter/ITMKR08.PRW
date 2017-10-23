#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITMKR08   บAutor  ณAlexandre Caetano   บ Data ณ  15/Out/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta relat๓rio em Crystal Report                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ITMKR08()
local _aArea := GetArea()
local _cPerg := "ITMKR08"

AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf

if Empty(MV_PAR08) // Vendedor
   cVendini := "      "
   cVendFim := "ZZZZZZ"        
Else
	cVendini := MV_PAR08
   	cVendFim := MV_PAR08
Endif

if Empty(MV_PAR09) // Tipo de Opera็ใo
	cTpOperIni	:= " "
	cTpOperFim  := "Z"
Else                  
	cTpOperIni	:= MV_PAR09
	cTpOperFim  := MV_PAR09
Endif

//        dDtaPartir         Filial de    Filial ate   Grp de       Grp ate           Periodo de         Periodo ate    
cParms := DtoS(MV_PAR01)+";"+MV_PAR02+";"+MV_PAR03+";"+MV_PAR04+";"+MV_PAR05+";"+DtoS(MV_PAR06)+";"+DtoS(MV_PAR07)+";"+cVendIni+";"+cVendFim+";"+cTpOperIni+";"+cTpOperFim
x:="1;0;1;ITMKR08"

         
CallCrys("ITMKR08",cParms, x)

restArea (_aArea)

Return(.t.)

Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
  //PutSx1(X1_GRUPO, X1_ORDEM, X1_PERGUNT      , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_F3, X1_GRPSXG, X1_PYME, X1_VAR01  , X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, aHelpPor, aHelpEng, aHelpSpa, X1_HELP)	
    PutSx1(_cPerg  , "01"    , "A Partir Data ", ""       , " "      , "mv_ch1"  , "D"    , 08        , 0         , 0        ,"G"    , ""      , ""   , ""       , ""     , "mv_par01", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
    
	PutSx1(_cPerg  , "02"    , "Filial de     ", " "      , " "      , "mv_ch2"  , "C"    , 02        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par02", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "03"    , "Filial at้    ", " "      , " "      , "mv_ch3"  , "C"    , 02        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par03", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "04"    , "Equipe de     ", " "      , " "      , "mv_ch4"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par04", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "05"    , "Equipe at้    ", " "      , " "      , "mv_ch5"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par05", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	 
	
	PutSx1(_cPerg  , "06"    , "Perํodo de    ", " "      , " "      , "mv_ch6"  , "D"    , 08        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par06", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "07"    , "Perํodo at้   ", " "      , " "      , "mv_ch7"  , "D"    , 08        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par07", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	                                                                          
	PutSx1(_cPerg  , "08"    , "Representante ", " "      , " "      , "mv_ch8"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par08", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "09"    , "Opera็ใo      ", " "      , " "      , "mv_ch9"  , "C"    , 01        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par09", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )		

	RestArea (_aArea)

Return(_cPerg)