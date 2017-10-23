#include "topconn.ch"
#include "rwmake.ch"
#include "Protheus.Ch"

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKA32 | Autor: | Rogério Alves      | Data: | Novembro/2014|
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Varre acols e preenche o campo UB__DESCP de desconto de Capa |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKA32()


MsAguarde({|| ITMKA32A()},"Processando...","Atualizando Preços")

Return .t.

Static Function ITMKA32A()
Local aArea 	:= getArea(), _n := n
Local nPosDescP	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "UB__DESCCP"})

For x:=1 To Len(aCols)
	If !(aCols[x][Len(aCols[x])])
		aCols[x][nPosDescP] := M->UA__DESCAP
		n := x
        Eval(bGDRefresh)
        Eval(bRefresh)
        n := x
		U_ITMKC05P("")
		n := x
		U_ITMKC07I("")
		n := x
        Eval(bGDRefresh)
        Eval(bRefresh)		
        
        //Atualiza a gravação online
        U_ITMKGRON("SUB","",x)
	EndIf
Next x
             
n := _n
Eval(bGDRefresh)
Eval(bRefresh)

RestArea(aArea)
Return 