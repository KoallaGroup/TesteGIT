#include "protheus.ch"     
#INCLUDE "TOPCONN.CH" 
          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o ³ ICOMR01³ Autor ³ Juscelino Alves dos Santos ³ Data ³ 07/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Embarques atrasados                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Gerar Relatrio com a relação de todos os itens dos pedidos ´±±
±±³ de Compra cuja a Data de embarque ja esteja vencida e com saldo       ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function ICOMR01()
Local oReport  
Local cPerg :="ICOMR01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1(cPerg,"01","Empresa "  ,'','',"mv_ch1","C",02,0,,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data de Referencia " ,'','',"mv_ch2","D",08,0,,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Segmento " ,'','',"mv_ch3","C",02,0,,"G","","SZ7","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Fornecedor " ,'','',"mv_ch4","C",06,0,,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","SubGrupo " ,'','',"mv_ch5","C",02,0,,"G","","SZ4","","","mv_par05","","","","","","","","","","","","","","","","")

Pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
oReport:PrintDialog()	

Return
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função que Instancia o Relatorio as Seções e Quebras do Relatorio
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ReportDef()
Local oReport
Local oSection1,oSection2
Local oBreak
local cPerg :="ICOMR01"
oReport := TReport():New("ICOMR01","Relatorio de Embarques Pendentes",cPerg,{|oReport| PrintReport(oReport)},"Relatorio de Impressão dos Embarques Pendentes.")
oReport:HideParamPage()   
oReport:nFontBody  := 08

oSection1 := TRSection():New(oReport,"Embarques",{"_QRY"})       
TRCell():New(oSection1,"FORNECEDOR" , ,       /*Titulo*/,/*Picture*/,13,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"FORNECED"	,"_QRY","Fornecedor",,06,)   
TRCell():New(oSection1,"FORNOME"	,"_QRY","Fornecedor",,40,)  
oSection1:Cell("FORNECEDOR"):SetBlock ( { || "Fornecedor:" })
oSection1:SetHeaderBreak(.F.)
oSection1:SetHeaderSection(.F.)

oSection2 := TRSection():New( oSection1 , "Pedidos", {"_QRY"} )
TRCell():New(oSection2,"PEDIDO"  ,"_QRY","PEDIDO",,10)             
TRCell():New(oSection2,"EMISSAO" ,"_QRY","DATA "+CRLF+"PEDIDO",,12)
TRCell():New(oSection2,"DATAENT" ,"_QRY","DATA PREVISTA "+CRLF+"ENTREGA",,12)
TRCell():New(oSection2,"ITEM "   ,"_QRY","ITEM",,04)
TRCell():New(oSection2,"DESCRI " ,"_QRY","DESCRIÇÃO",,32,)
TRCell():New(oSection2,"QUANT "  ,"_QRY","QUANTIDADE","@E 999,999,999.99")
TRCell():New(oSection2,"DIASAT " ,"_QRY","DIAS DE"+CRLF+"ATRASO","@E 999,999")             

oBreak := TRBreak():New(oSection1,oSection1:Cell("FORNECED"),"Total Quantidade Fornecedor")

TRFunction():New(oSection2:Cell("QUANT "),"Total Geral da Quantidade","SUM",oBreak ,,,,.F.,.T.)

Return oReport


//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função do que Gera a QUERY para o Relatorio e Dispara a Impressão
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)    
Local oSection2 := oReport:Section(1):Section(1)
Local cPart
Local cFiltro   := ""     
Local _cQuery   := ""

MakeSqlExpr("ICOMR01")

oSection1:BeginQuery() 
_cQuery := " SELECT "+ CRLF 
_cQuery += " SC7.C7_FORNECE FORNECED , SZ2.Z2_FILIAL FILIAL , "+ CRLF 

_cQuery += " (SELECT SA2.A2_NOME "+ CRLF 
_cQuery += "  FROM "+RetSqlName("SA2")+" SA2 "+ CRLF 
_cQuery += "  WHERE  SA2.D_E_L_E_T_ <> '*'  "+ CRLF 
_cQuery += "  AND SA2.A2_FILIAL ='"+xFilial("SA2")+"' "+ CRLF 
_cQuery += "  AND SA2.A2_COD=SC7.C7_FORNECE "+ CRLF 
_cQuery += "  AND SA2.A2_LOJA=SC7.C7_LOJA) FORNOME , "+ CRLF 

_cQuery += "  Z2_PEDIDO  PEDIDO, "+ CRLF 
_cQuery += " SC7.C7_EMISSAO EMISSAO , "+ CRLF 
_cQuery += " SZ2.Z2_DTENTPR DATAENT, "+ CRLF 
_cQuery += " SC7.C7_ITEM  ITEM, "+ CRLF 
_cQuery += " SC7.C7_DESCRI DESCRI , "+ CRLF 
_cQuery += " SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA QUANT, "+ CRLF 
_cQuery += " Z2_DTENTPR-'"+Dtos(Ddatabase)+"' DIASAT "+ CRLF 
_cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 "+ CRLF 
                                                                 
                                                                 
_cQuery += " RIGHT  OUTER JOIN "+RetSqlName("SZ3") + " SZ3  ON  "+ CRLF 
_cQuery += " SZ3.Z3_CODIGO = SZ2.Z2_CODIGO "+ CRLF 
_cQuery += " AND SZ3.D_E_L_E_T_ = ''  "+ CRLF 
_cQuery += " AND SZ3.Z3_FILIAL = SZ2.Z2_FILIAL "+ CRLF 
_cQuery += " AND  (SELECT SUM(SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA)  FROM  "+RetSqlName("SC7")+" SC7  "+ CRLF 
_cQuery += "  WHERE  "+ CRLF 
_cQuery += "  SC7.C7_FILIAL = SZ2.Z2_FILIAL "+ CRLF 
_cQuery += "  AND C7_NUM = SZ3.Z3_PEDIDO "+ CRLF 
_cQuery += "  AND SC7.C7_RESIDUO <> 'S' "+ CRLF 
_cQuery += "  AND SC7.C7_PRODUTO = SZ3.Z3_PRODUTO "+ CRLF 
_cQuery += "  AND SC7.C7_ITEM = SZ3.Z3_ITPEDCO "+ CRLF 
_cQuery += "  AND  SC7.D_E_L_E_T_ <> '*' "+ CRLF 
_cQuery += "  GROUP BY C7_PRODUTO) >0 "+ CRLF 

_cQuery += "  RIGHT OUTER JOIN "+RetSqlName("SC7")+" SC7  ON "+ CRLF 
_cQuery += "  SC7.C7_FILIAL = SZ2.Z2_FILIAL "+ CRLF 
_cQuery += "  AND C7_NUM = SZ3.Z3_PEDIDO "+ CRLF 
_cQuery += "  AND SC7.C7_RESIDUO <> 'S' "+ CRLF 
_cQuery += "  AND SC7.C7_PRODUTO = SZ3.Z3_PRODUTO "+ CRLF 
_cQuery += "  AND SC7.C7_ITEM = SZ3.Z3_ITPEDCO "+ CRLF 
_cQuery += "  AND  SC7.D_E_L_E_T_ <> '*' "+ CRLF 

_cQuery += "  RIGHT OUTER JOIN "+RetSqlName("SB1")+" SB1  ON "+ CRLF 
_cQuery += "  SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+ CRLF 
_cQuery += "  AND SB1.B1_COD = SZ3.Z3_PRODUTO "+ CRLF 
_cQuery += Iif(!Empty(mv_par05)," AND SB1.B1__SUBGRP  = '" + mv_par05 + "'  " + CRLF, "")
_cQuery += "  AND  SB1.D_E_L_E_T_ <> '*' " + CRLF 
  
_cQuery += "  WHERE  "
_cQuery += Iif(!Empty(mv_par01),"  SZ2.Z2_FILIAL  = '" + mv_par01 + "'  AND " + CRLF, "") // OU SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "+ CRLF
_cQuery += "  SZ2.Z2_DTENTPR <= '" + Iif(!Empty(mv_par02),Dtos(mv_par02),Dtos(Ddatabase)) + "' " + CRLF 
_cQuery += Iif(!Empty(mv_par01),"   AND SZ2.Z2_FILIAL  = '" + mv_par01 + "' " + CRLF, "")
_cQuery += Iif(!Empty(mv_par03),"   AND SZ2.Z2_SEGISP  = '" + mv_par03 + "' " + CRLF, "")
_cQuery += Iif(!Empty(mv_par04),"   AND SZ2.Z2_CODFOR  = '" + mv_par04 + "' "+ CRLF , "")
_cQuery += "   AND SZ2.D_E_L_E_T_ = ' ' " + CRLF 
_cQuery += "   ORDER BY SC7.C7_FORNECE,SC7.C7_EMISSAO "+ CRLF 

_cQuery := ChangeQuery(_cQuery)

 
If Select("_QRY") > 0
    Dbselectarea("_QRY")
    _QRY->(DbClosearea())
EndIf
 
TcQuery _cQuery New Alias "_QRY"   
TcSetField("_QRY","EMISSAO","D",8,0)
TcSetField("_QRY","DATAENT","D",8,0)
TcSetField("_QRY","QUANT","N",12,0)   

oSection1:EndQuery({{"_QRY"},_cQuery})
oSection2:SetParentQuery()       

oSection2:SetParentFilter({|cParam| _QRY->FORNECED >= cParam .and. _QRY->FORNECED <= cParam},{|| _QRY->FORNECED})
	
oSection1:Print()

_QRY->(DbClosearea())
Return
