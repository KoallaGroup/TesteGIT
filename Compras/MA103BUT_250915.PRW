#include "protheus.ch"
#include "Rwmake.ch"
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MA103BUT			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Inclusão de Ação Relacionada no menu de Nota de Entrada						  	|
|-----------------------------------------------------------------------------------------------|	
*/
user Function MA103BUT()
Local aButton := {}, nx
Local _nPPed := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_PEDIDO"}), _nPItm := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_ITEMPC"})
Local _nPPZ3 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__PEDIMP"}), _nPIZ3 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ITPIMP"})
Local _nPBI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASIMP5"}), _nPBCF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASCOF"})
Local _nPAI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_ALQIMP5"}), _nPACF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQCOF"})
Local _nPVI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALIMP5"}), _nPVCF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VALCOF"})
Local _nPBI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASIMP6"}), _nPBPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASPIS"})
Local _nPAI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_ALQIMP6"}), _nPAPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQPIS"})
Local _nPVI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALIMP6"}), _nPVPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VALPIS"}) 
Local _nPAIP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQIPI"}), _nPALP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_IPI"})
Local _nPVIP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VLRIPI"}), _nPVLP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALIPI"})
Local _nPBIP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASIPI"}), _nPBSP := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASEIPI"})
Local _nPAIC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQICM"}), _nPALC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_PICM"})
Local _nPVIC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VLRICM"}), _nPVLC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALICM"})
Local _nPBIC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASICM"}), _nPBSC := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASEICM"})

Public lRedEnt 	 := .F., _cChavNfe := ""

SetKey( 17 ,{||U_ICOMA15()} ) //CTRL + Q

if ! Inclui .and. ! Altera
    Aadd( aButton, {"EDIT", { || U_ICOMA02() },"Alt. Dt. Entrada" } )
    Aadd( aButton, {"EDIT", { || U_ICOMA03("SF1",SF1->(RECNO()),4) },"Virada de TES" } )
endif 

Aadd( aButton, {"EDIT", { || U_ICOMA16() },"Redespacho" } )

//Atualiza campos do SD1, na NF de Importação
If Type("_lICOMP05") == "L" .And. _lICOMP05

    For nx := 1 To Len(aCols)
        If _nPPed > 0 .And. _nPItm > 0 .And. _nPPZ3 > 0 .And. _nPIZ3 > 0
            aCols[nx][_nPPed] := aCols[nx][_nPPZ3]
            aCols[nx][_nPItm] := aCols[nx][_nPIZ3]
        EndIf
        
        If _nPAIP > 0 .And. _nPALP > 0
            aCols[nx][_nPALP] := aCols[nx][_nPAIP]
            MaFisAlt("IT_ALIQIPI",aCols[nx][_nPAIP],nx)
        EndIf
        
        If _nPBIP > 0 .And. _nPBSP > 0
            aCols[nx][_nPBSP] := aCols[nx][_nPBIP]
            MaFisAlt("IT_BASEIPI",aCols[nx][_nPBIP],nx)
        EndIf

        If _nPVIP > 0 .And. _nPVLP > 0
            aCols[nx][_nPVLP] := aCols[nx][_nPVIP]
            MaFisAlt("IT_VALIPI",aCols[nx][_nPVIP],nx)
        EndIf

        If _nPAIC > 0 .And. _nPALC > 0
            aCols[nx][_nPALC] := aCols[nx][_nPAIC]
            MaFisAlt("IT_ALIQICM",aCols[nx][_nPAIC],nx)
        EndIf
        
        If _nPBIC > 0 .And. _nPBSC > 0
            aCols[nx][_nPBSC] := aCols[nx][_nPBIC]
            MaFisAlt("IT_BASEICM",aCols[nx][_nPBIC],nx)
        EndIf

        If _nPVLC > 0 .And. _nPVIC > 0
            aCols[nx][_nPVLC] := aCols[nx][_nPVIC]
            MaFisAlt("IT_VALICM",aCols[nx][_nPVIC],nx)
        EndIf

        If _nPBI5 > 0 .And. _nPBCF > 0
            aCols[nx][_nPBI5] := aCols[nx][_nPBCF]
            MaFisAlt("IT_BASECF2",aCols[nx][_nPBCF],nx)
        EndIf
        
        If _nPAI5 > 0 .And. _nPACF > 0
            aCols[nx][_nPAI5] := aCols[nx][_nPACF]
            MaFisAlt("IT_ALIQCF2",aCols[nx][_nPACF],nx)
        EndIf
        
        If _nPVI5 > 0 .And. _nPVCF > 0
            aCols[nx][_nPVI5] := aCols[nx][_nPVCF]
            MaFisAlt("IT_VALCF2",aCols[nx][_nPVCF],nx)
        EndIf

        If _nPBI6 > 0 .And. _nPBPS > 0
            aCols[nx][_nPBI6] := aCols[nx][_nPBPS]
            MaFisAlt("IT_BASEPS2",aCols[nx][_nPBPS],nx)
        EndIf
        
        If _nPAI6 > 0 .And. _nPAPS > 0
            aCols[nx][_nPAI6] := aCols[nx][_nPAPS]
            MaFisAlt("IT_ALIQPS2",aCols[nx][_nPAPS],nx)
        EndIf
        
        If _nPVI6 > 0 .And. _nPVPS > 0
            aCols[nx][_nPVI6] := aCols[nx][_nPVPS]
            MaFisAlt("IT_VALPS2",aCols[nx][_nPVPS],nx)
        EndIf

    Next nx
    Eval(bRefresh)
    Eval(bGDRefresh)
EndIf 

return aButton