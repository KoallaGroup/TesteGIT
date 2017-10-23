#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IESTR05				| 	Abril de 2014										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de itens com Saldo e sem Preço										|
|-----------------------------------------------------------------------------------------------|
*/

User Function IESTR05()

local _aArea 	:= GetArea()
local _cPerg 	:= "IESTR05"
Local _cCodTab	:= Alltrim(getMV("MV__TABBRA"))
AjustSX1(_cPerg)

If !Pergunte(_cPerg,.t.)
	Return
EndIf

//c:= 1

cParms := MV_PAR01  + ";" + _cCodTab + ";" + DtoS(MV_PAR02)

x:="1;0;1;IESTR05"


CallCrys("IESTCR05",cParms, x)

restArea (_aArea)

Return(.t.)
//----------------------------------------


Static Function AjustSX1(_cPerg)

Local _aArea := GetArea()
Local aHelpPor	:= {}
//PutSx1(X1_GRUPO, X1_ORDEM, X1_PERGUNT       , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO           	, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID									, X1_F3      , X1_GRPSXG, X1_PYME, X1_VAR01  , X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, aHelpPor, aHelpEng, aHelpSpa, X1_HELP)

PutSx1(_cPerg  , "01"    , "Segmento          ", " "      , " "      , "mv_ch1"  , "C"    , AvSx3("B1__SEGISP",3)	, 0         , 0        , "G"   , "!Vazio() .and. ExistCpo('SZ7',MV_PAR01) "	, "SZ72"     , ""       , ""     , "mv_par01", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )
PutSx1(_cPerg  , "02"    , "Data de Referência", " "      , " "      , "mv_ch2"  , "D"    , 08                     	, 0         , 0        , "G"   , ""      									, ""         , ""       , ""     , "mv_par02", ""      , ""        , ""        , ""      , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""        , ""        , ""      , ""      , ""      , ""     )

RestArea (_aArea)

Return(_cPerg)
