#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICOMP03ºAutor  ³Alexandre Caetano   º Data ³  10/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida existencia de amarração Produto X Fornecedor        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exlcusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ICOMP03()
Local lRet	:= .t. 
Local aArea := GetArea()
Local nPosProd  :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "C7_PRODUTO" 	})

SA5->(dbSetOrder(1))
cProd := aCols[n,nPosProd]

if !SA5->( dbSeek(xFilial("SA5")+M->Ca120Forn + M->Ca120Loj + cProd )  )
	msgAlert("       Amarração Produto X Fornecedor não existe.        " + chr(13) +;
	         "Cadastre a amarração antes de inserir o pedido de compra.","Atenção !!")
	lRet := .f.	         
Endif
                        
restarea(aArea)
Return(lRet)

/*
+------------+----------+--------+------------------------------------------+-------+----------------+
| Programa:  | ICOMA13A | Autor: | Jorge Henrique Alves - Anadi Soluções    | Data: | Fevereiro/2015 |
+------------+----------+--------+------------------------------------------+-------+----------------+
| Descrição: | Zera os impostos no pedido de compras, de acordo com informações do fornecedor        |
+------------+---------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ICOMP03A()
Local _nPVIPI := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_VALIPI"  })
Local _nPBIPI := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_BASEIPI" })
Local _nPAIPI := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_IPI"     })
Local _nPVICM := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_VALICM"  })
Local _nPBICM := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_BASEICM" })
Local _nPAICM := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_PICM"    })
Local _aArea := GetArea()

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + CA120FORN + CA120LOJ)

If SA2->A2__IPI != "1" .Or. SA2->A2_EST == "EX"
    
    If _nPAIPI > 0
        aCols[n][_nPAIPI] := 0
        M->C7_IPI         := 0
        MaFisAlt("IT_ALIQIPI",aCols[N][_nPAIPI],N)
    EndIf

    If _nPBIPI > 0
        aCols[n][_nPBIPI] := 0
        M->C7_BASEIPI     := 0
        MaFisAlt("IT_BASEIPI",aCols[N][_nPBIPI],N)
    EndIf    
        
    If _nPVIPI > 0
        aCols[n][_nPVIPI] := 0
        M->C7_VALIPI      := 0
    EndIf

    If _nPAICM > 0
        aCols[n][_nPAICM] := 0
        M->C7_PICM        := 0
        MaFisAlt("IT_ALIQICM",aCols[N][_nPAICM],N)
    EndIf

    If _nPBICM > 0
        aCols[n][_nPBICM] := 0
        M->C7_BASEICM     := 0
        MaFisAlt("IT_BASEICM",aCols[N][_nPBICM],N)
    EndIf
    
    If _nPVICM > 0
        aCols[n][_nPVICM] := 0
        M->C7_VALICM      := 0
    EndIf
EndIf

Eval(bFolderRefresh)
Eval(bGDRefresh)
Eval(bZeraDesc)
Eval(bRefresh)
Eval(bListRefresh)
Eval(bPIDRefresh)

RestArea(_aArea)
Return .t.