#include "protheus.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITMKR05   �Autor  �Alexandre Caetano   � Data �  15/Out/2014���
�������������������������������������������������������������������������͹��
���Desc.     �Executa relat�rio em Crystal Report                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ITMKR05()
local _aArea := GetArea()
local _cPerg := "ITMKR05"

AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf

if Empty(MV_PAR07) // Vendedor
   cVendini := "      "
   cVendFim := "ZZZZZZ"        
Else
	cVendini := MV_PAR07
   	cVendFim := MV_PAR07
Endif

if Empty(MV_PAR08) // Tipo de Opera��o
	cTpOperIni	:= " "
	cTpOperFim  := "Z"
Else                  
	cTpOperIni	:= MV_PAR08
	cTpOperFim  := MV_PAR08
Endif


cParms := MV_PAR01+";"+MV_PAR02+";"+MV_PAR03+";"+MV_PAR04+";"+DtoS(MV_PAR05)+";"+DtoS(MV_PAR06)+";"+cVendIni+";"+cVendFim+";"+cTpOperIni+";"+cTpOperFim 
x:="1;0;1;ITMKR05" 

         
CallCrys("ITMKR05",cParms, x)

restArea (_aArea)

Return(.t.)

Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
  //PutSx1(X1_GRUPO, X1_ORDEM, X1_PERGUNT      , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_F3, X1_GRPSXG, X1_PYME, X1_VAR01  , X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, aHelpPor, aHelpEng, aHelpSpa, X1_HELP)	
	PutSx1(_cPerg  , "01"    , "Filial de     ", " "      , " "      , "mv_ch1"  , "C"    , 02        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par01", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "02"    , "Filial at�    ", " "      , " "      , "mv_ch2"  , "C"    , 02        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par02", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "03"    , "Equipe de     ", " "      , " "      , "mv_ch3"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par03", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "04"    , "Equipe at�    ", " "      , " "      , "mv_ch4"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par04", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	 
	
	PutSx1(_cPerg  , "05"    , "Per�odo de    ", " "      , " "      , "mv_ch5"  , "D"    , 08        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par05", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	PutSx1(_cPerg  , "06"    , "Per�odo at�   ", " "      , " "      , "mv_ch6"  , "D"    , 08        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par06", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "07"    , "Representante ", " "      , " "      , "mv_ch7"  , "C"    , 06        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par07", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )	
	
	PutSx1(_cPerg  , "08"    , "Opera��o      ", " "      , " "      , "mv_ch8"  , "C"    , 01        , 0         , 0        , "G"   , ""      , ""   , ""       , ""     , "mv_par08", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )		

	RestArea (_aArea)

Return(_cPerg)
