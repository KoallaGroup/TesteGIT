#include "protheus.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ICOMP03�Autor  �Alexandre Caetano   � Data �  10/Nov/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Valida existencia de amarra��o Produto X Fornecedor        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exlcusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ICOMP03()
Local lRet	:= .t. 
Local aArea := GetArea()
Local nPosProd  :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "C7_PRODUTO" 	})

SA5->(dbSetOrder(1))
cProd := aCols[n,nPosProd]

if !SA5->( dbSeek(xFilial("SA5")+M->Ca120Forn + M->Ca120Loj + cProd )  )
	msgAlert("       Amarra��o Produto X Fornecedor n�o existe.        " + chr(13) +;
	         "Cadastre a amarra��o antes de inserir o pedido de compra.","Aten��o !!")
	lRet := .f.	         
Endif
                        
restarea(aArea)
Return(lRet)

/*
+------------+----------+--------+------------------------------------------+-------+----------------+
| Programa:  | ICOMA13A | Autor: | Jorge Henrique Alves - Anadi Solu��es    | Data: | Fevereiro/2015 |
+------------+----------+--------+------------------------------------------+-------+----------------+
| Descri��o: | Zera os impostos no pedido de compras, de acordo com informa��es do fornecedor        |
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