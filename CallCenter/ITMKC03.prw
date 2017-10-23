#include "rwmake.ch"
#include "Protheus.ch"

/*
+------------+----------+--------+------------------------------+-------+-----------+
| Programa:  | ITMKC03  | Autor: | Rogério Alves - Anadi        | Data: | Set/2014  |
+------------+----------+--------+------------------------------+-------+-----------+
| Descrição: | Cadastro de recados para Vendedores                                  |
+------------+----------------------------------------------------------------------+
| Uso:       | Isapa                                                                |
+------------+----------------------------------------------------------------------+
*/


User Function ITMKC03()

Local _aArea := getArea()

SetPrvt("CARQUIVO,CCHAVE,CFOR,NINDEX,CORDEM")
SetPrvt("ACAMPOS,CTITULO,CCADASTRO,cFiltro,AROTINA,")

aCampos := {{"Segmento"			,"AD8__SEGIS"	,00,00	,"@!"	},;
				{"Area"				,"AD8__AREA"	,00,00	,"@!"	},;
				{"Grp Repr"			,"AD8__GRPREP"	,00,00	,"@!"	},;
				{"Supervisor"		,"AD8__SUPER"	,00,00	,"@!"	},;
				{"Gerente"			,"AD8__GEREN"	,00,00	,"@!"	},;								
				{"Data"				,"AD8_DTINI"	,00,00	,"@!"	},;
				{"Usuario"			,"AD8_CODUSR"	,00,00	,"@!"	}}
                                        
DbSelectArea("AD8")

cArquivo 	:= CriaTrab(aCampos,.F.)
cChave 		:= "AD8_TAREFA"
cFor 			:= ""//"AD8_ANIVER == '1'"
cOrdem		:= "D"

IndRegua("AD8",cArquivo,cChave,cOrdem,cFor,"Criando Indice...")

nIndex := RetIndex("AD8")

#IFNDEF TOP
	DbSetIndex(cArquivo+OrdBagExt())
#ENDIF

DbSetOrder(nIndex+1)
dbGotop()

cTitulo 		:= "Recados para Vendedores"
cCADASTRO 	:= OEMTOANSI(cTitulo)

aRotina	:= {	{"Pesquisar "	,"AxPesqui"		,0,1},;
					{"Visualizar"	,"axVisual"		,0,2},;
					{"Incluir"		,"U_ITMKC03A()",0,3},;
					{"Alterar"		,"U_ITMKC03B()",0,4},;
					{"Excluir"		,"U_ITMKC03C()",0,5}}

mBrowse(6,1,22,75,"AD8",aCampos)

DbSelectArea("AD8")
RetIndex("AD8")
FErase(cArquivo+OrdBagExt())

restArea(_aArea)

return


/////////////////////////////////////
//INCLUIR
/////////////////////////////////////

user Function ITMKC03A()

lRet := .F.

axInclui("AD8",,,,,,'lRet := .T.')

if lRet
	if reclock("AD8", .F.)
//		AD8->AD8__DTINC	:= date()
//		AD8->AD8__HRINC	:= time()
	endif
endif

return


/////////////////////////////////////
//ALTERAR
/////////////////////////////////////

user Function ITMKC03B()

lRet := .F.

axAltera("AD8",AD8->(RECNO()),3,,,,,'lRet := .T.')

if lRet
	if reclock("AD8", .F.)
//		AD8->AD8__DTALT	:= date()
//		AD8->AD8__HRALT	:= time()
	endif
endif

return


/////////////////////////////////////
//EXCLUIR
/////////////////////////////////////

user Function ITMKC03C()

axDeleta("AD8",AD8->(RECNO()),4)

if reclock("AD8", .F.)
//	AD8->AD8__DTALT	:= date()
//	AD8->AD8__HRALT	:= time()
endif

return
