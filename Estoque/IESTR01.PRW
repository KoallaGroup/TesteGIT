#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIESTR01   บAutor  ณAlexandre Caetano   บ Data ณ  27/Out/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta relat๓rio em Crystal Report - (Itens Sem Movimento) บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IESTR01()
local _aArea := GetArea()
local _cPerg := "IESTR01"

AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf                    

c:= 1
       
cParms := MV_PAR01 + ";" 
cParms += MV_PAR02 + ";" 
cParms += MV_PAR03  + ";" 
cParms += MV_PAR04  + ";" 
cParms += DtoS(MV_PAR05) + ";" 
cParms += DtoS(MV_PAR06) + ";" 
cParms += MV_PAR07 + ";" 
cParms += MV_PAR08 + ";" 
cParms += Str(MV_PAR09,1)  + ";"
cParms += MV_PAR10  + ";" 
cParms += DtoS(dDataBase) + ";"
cParms +=Str(MV_PAR11,1) + ";"

x:="1;0;1;IESTR01"              

Do Case
	Case MV_PAR11 = 1
		CallCrys("IESTR01",cParms, x)
	Case MV_PAR11 = 2
		CallCrys("IESTR01B",cParms, x)
	Case MV_PAR11 = 3
		CallCrys("IESTR01C",cParms, x)
EndCase

restArea (_aArea)

Return(.t.)
//----------------------------------------


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
  //PutSx1(X1_GRUPO, X1_ORDEM, X1_PERGUNT       , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO           , X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_F3      , X1_GRPSXG, X1_PYME, X1_VAR01  , X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, aHelpPor, aHelpEng, aHelpSpa, X1_HELP)	   
    PutSx1(_cPerg  , "01"    , "Filial de     5 ", " "      , " "      , "mv_ch1"  , "C"    , 02                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par01", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
    PutSx1(_cPerg  , "02"    , "Filial ate     ", " "      , " "      , "mv_ch2"  , "C"    , 02                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par02", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
    
    PutSx1(_cPerg  , "03"    , "Grupo de       ", " "      , " "      , "mv_ch3"  , "C"    , AvSx3("BM_GRUPO",3)  , 0         , 0        , "G"   , ""      , "SBM"      , ""       , ""     , "mv_par03", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
    PutSx1(_cPerg  , "04"    , "Grupo ate      ", " "      , " "      , "mv_ch4"  , "C"    , AvSx3("BM_GRUPO",3)  , 0         , 0        , "G"   , ""      , "SBM"      , ""       , ""     , "mv_par04", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
   	           
	PutSx1(_cPerg  , "05"    , "Perํodo de     ", " "      , " "      , "mv_ch5"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par05", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "06"    , "Perํodo at้    ", " "      , " "      , "mv_ch6"  , "D"    , 08                   , 0         , 0        , "G"   , ""      , ""         , ""       , ""     , "mv_par06", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "07"    , "Produto de     ", " "      , " "      , "mv_ch7"  , "C"    , AvSx3("B1_COD",3)    , 0         , 0        , "G"   , ""      , "SB1"      , ""       , ""     , "mv_par07", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
    PutSx1(_cPerg  , "08"    , "Produto ate    ", " "      , " "      , "mv_ch8"  , "C"    , AvSx3("B1_COD",3)    , 0         , 0        , "G"   , ""      , "SB1"      , ""       , ""     , "mv_par08", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
    
    PutSx1(_cPerg  , "09"    , "Com Saldo      ", " "      , " "      , "mv_ch9"  , "G"    , 3                    , 0         , 0        , "C"   , ""      , ""         , ""       , ""     , "mv_par09", "SIM"   , ""        , ""        , ""      , "NรO"   , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
    
    PutSx1(_cPerg  , "10"    , "Segmento       ", " "      , " "      , "mv_cha"  , "C"    , AvSx3("Z7_COD",3)    , 0         , 0        , "G"   , "MV_PAR10 == Posicione('SZ1',1,'  '+__cUserID,'Z1_SEGISP')"      , "SZ7"      , ""       , ""     , "mv_par10", "SIM"   , ""        , ""        , ""      , "NรO"   , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )

    PutSx1(_cPerg  , "11"    , "Origem    	   ", " "      , " "      , "mv_chb"  , "N"    , 1    				  , 0         , 0        , "C"   , ""      , ""      	, ""       , ""     , "mv_par11","Entrada", ""        , ""        , ""      , "Saํda" , ""        , ""        , "Ambos" , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )

	RestArea (_aArea)                                                                    

Return(_cPerg)