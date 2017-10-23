WSMETHOD GET WSRECEIVE CODPRODUTO WSSERVICE PRODUTOS
Local cCodProd := Self:CODPRODUTO
Local aArea    := GetArea()
Local oObjProd := Nil
Local cStatus  := ""
Local cJson    := ""

::SetContentType("application/json")

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
If SB1->( DbSeek( xFilial("SB1") + cCodProd ) )
    cStatus  := Iif( SB1->B1_MSBLQL == "1", "Sim", "Nao" )
    oObjProd := Produtos():New(SB1->B1_DESC, SB1->B1_UM, cStatus)
EndIf

cJson := FWJsonSerialize(oObjProd)

::SetResponse(cJson)

RestArea(aArea)
Return(.T.)