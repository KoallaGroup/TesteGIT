#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE "RWMAKE.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o ³ ICOMA09³ Autor ³ Juscelino Alves dos Santos ³ Data ³ 01/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para Sugestão de Compra                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Gerar sugestões de Compra para todos os produtos que esteja´±±
±±³ vinculado ao fonecedor do pedido de compra Sua utilização na Tela do  ³±± 
±±³ do Pedido de Compra na Inclusão.                                      ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ICOMA09() 
// Delcaração de Variaveis Locais
Local aSaveArea:= GetArea()
Local _lretped      := .F.                                                                     

// Delcaração de Variaveis Privadas                                                                     
Private  _oLocal,_odescloc,_oGrupo,_ocodfor,_odescfor,_oforloj,_odat01I,_odat01F,_odat02I,_odat02F
Private _ccodfor    := M->CA120FORN
Private _cdescfor   := Posicione("SA2",1,XFILIAL("SA2")+M->CA120FORN+M->CA120LOJ,"A2_NOME")
Private _cforloj    := M->CA120LOJ
Private _ddat01I     := Ctod("  /  /  ")
Private _ddat01F     := Ctod("  /  /  ")
Private _ddat02I     := Ctod("  /  /  ")
Private _ddat02F     := Ctod("  /  /  ")
Private _cnumped     := M->CA120NUM
private aHeadsc := {}
private aColssc := {}
        
// Definição de Fonte
Define font oFont Name "ARIAL" SIZE 50,15 
Define font oFontB Name "ARIAL" SIZE 07,12 BOLD
                            
// Criticas Antes de acessar a Rotina
If !Inclui
   MsgStop(OemToAnsi("Opção Disponivel apenas na Inclusão do Pedido de Compa, verifique."),OemToAnsi("Atencao"))
   RestArea(aSaveArea)
   Return
EndIf 

If Empty(M->CA120FORN)
   MsgStop(OemToAnsi("Favor , Informa o Codigo do Fornecedor para acessar essa Opção."),OemToAnsi("Atencao"))
   RestArea(aSaveArea)
   Return
EndIf


// Inicialização do Vetores da Getdados
aAdd(aHeadsc,{"Produto"             , "PROD"     , ""   ,15   ,0   ,"" , "" , "C" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Descrição"           , "DESC"     , ""   ,30   ,0   ,"" , "" , "C" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"U.V."                , "DTULV"     , ""  ,02   ,0   ,"" , "" , "C" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"U.C."                , "DTULC"     , ""  ,02   ,0   ,"" , "" , "C" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Venda Periodo 1"     , "VLVENP1"  ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Venda Periodo 2"     , "VLVENP2"  ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Estoque        "     , "VLEST"    ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Compra"              , "VLCOM"    ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Faturado"            , "VLFAT"    ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Margem"              , "MARGEM"   ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 
aAdd(aHeadsc,{"Sugestão de Compra"  , "SUGCOM"   ,"@E 99,999,999.99",14,2,"" ,"","N",""   ,"","","","","",".T."}) 


// Definição da Fonte e Dimensão da Tela 
oFont := tFont():New("Tahoma",,-14,,.t.)
aSize := MsAdvSize()
aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

// Tela de Sugestão de Compra 
DEFINE MSDIALOG oDlg TITLE "Sugestão de Compras" From -15,-05 To 500,1270 OF oMainWnd PIXEL //STYLE DS_MODALFRAME STATUS
@  10,10 Say "Numero do Pedido :" 		FONT oFont SIZE 100,10 OF oDlg PIXEL
@  10,125 Say "Fornecedor :" 			FONT oFont SIZE 100,10 OF oDlg PIXEL
@  10,389 Say "	Loja :" 	    		FONT oFont SIZE 100,10 OF oDlg PIXEL

// Quadros da Tela
@ 027,001 TO 029,640   
@ 027,185 TO 066,305   
@ 027,313 TO 066,435   
@ 037,185 TO 039,305   
@ 037,313 TO 039,435   

@  29,192 Say "	Periodo 1" 	    		FONT oFont SIZE 100,10 OF oDlg PIXEL  COLOR CLR_HBLUE
@  29,320 Say "	Periodo 2" 	    		FONT oFont SIZE 100,10 OF oDlg PIXEL  COLOR CLR_HBLUE
@  41,190 Say "A Partir da Data" 	    FONT oFont SIZE 100,10 OF oDlg PIXEL
@  41,319 Say "A Partir da Data" 	    FONT oFont SIZE 100,10 OF oDlg PIXEL
@  53,206 Say "Ate a Data" 	            FONT oFont SIZE 100,10 OF oDlg PIXEL
@  53,334 Say "Ate a Data" 	            FONT oFont SIZE 100,10 OF oDlg PIXEL   

// Gets da Tela 
@ 10,080 MsGet _onumped  var _cnumped  When .F.  Size 30,10 of oDlg PIXEL FONT oFont  
@ 10,175 MsGet _ocodfor	 var _ccodfor  When .F.	Size 30,10 of oDlg PIXEL FONT oFont 
@ 10,225 MsGet _odescfor var _cdescfor When .F. Size 160,10 of oDlg PIXEL FONT oFont  
@ 10,415 MsGet _oforloj  var _cforloj  When .F. Size 05,10 of oDlg PIXEL FONT oFont  
@ 40,249 MsGet _odat01I  var _ddat01I  When .T. Size 56,10 of oDlg PIXEL FONT oFont MESSAGE "Informe a Data Inicial do Primeiro Periodo - (Obrigatorio)"
@ 50,249 MsGet _odat01F  var _ddat01F  When .T. Size 56,10 of oDlg PIXEL FONT oFont MESSAGE "Informe a Data Final do Primeiro Periodo - (Obrigatorio)" 
@ 40,380 MsGet _odat02I  var _ddat02I  When .T. Size 56,10 of oDlg PIXEL FONT oFont MESSAGE "Informe a Data Inicial do Segundo Periodo - (Obrigatorio)"                
@ 50,380 MsGet _odat02F  var _ddat02F  When .T. Size 56,10 of oDlg PIXEL FONT oFont MESSAGE "Informe a Data Final do Segundo Periodo - (Obrigatorio)"  
       
oGetDados0 :=MsNewGetDados():New(067,002,258,640,0,,,,,,,,,,odlg,aHeadsc,aColssc) 

// Botões da Tela                                                                     

@ 010,509 BUTTON "&Geração de Pedido"	 SIZE 080,10 Of oDlg PIXEL FONT oFont ACTION (U_ICOMA12(_ccodfor,_cforloj,_ddat01I,_ddat01F,_ddat02I,_ddat02F)) MESSAGE "Tela de Geração de Pedido"  
@ 045,440 BUTTON "&Sugestão"	SIZE 060,10 Of oDlg PIXEL FONT oFont ACTION (Processa({|| fmonqury() },)) MESSAGE "Executa a Sugestão de Compra Baseado nos Periodos Inoformados"  
@ 045,509 BUTTON "&Pedido"	    SIZE 060,10 Of oDlg PIXEL FONT oFont ACTION (Processa({||_lretped:=Funped()},),Iif(_lretped,oDlg:End(),)) MESSAGE "Transfere todos os produtos da Sugestão de Compra para a Tela do Pedido de Compra"  
@ 045,579 BUTTON "&Cancelar"	SIZE 060,10 Of oDlg PIXEL FONT oFont ACTION (oDlg:End()) MESSAGE "Cancela toda a Operação Retornando a Tela de Pedido de Compra"  

ACTIVATE MSDIALOG oDlg CENTERED       

// Refresh da Tela do Pedido de Compra
GetdRefresh()

          
RestArea(aSaveArea)
Return   

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função do Botão < PEDIDO > ==> Transferi os dados da Tela de Sugestão para a Tela de Pedido de Compra 
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Funped()
Local _cItem := "0001"     
Local _ger   :=.F.

If Len(aColssc)<=0   
   MsgStop(OemToAnsi("Não Existem Itens de Sugestão de Compra Para Transferir para o Pedido de Compra, verifique."),OemToAnsi("Atencao"))
   Return .F.
EndIf   

aRefImpos := MaFisRelImp('MT100',{"SC7"})     

For _nLin=1 to Len(aColssc)

   If Len(aCols) == 1 .And. Empty(aCols[1,2])
      _nLin := 1
      _cItem := "0001"
   Else
      AADD(aCols,Array(Len(aHeader)+1))
      _nLin := Len(aCols)
      aCols[_nLin,Len(aHeader)+1] := .F.
      For _nX := 1 To Len(aCols)
         If !Empty(aCols[_nX,1])
           _cItem := aCols[_nX,1]
         Endif
      Next
      _cItem := Soma1(_cItem)
   Endif

   // atualiza linha do aCols
   n := Len(aCols)
          
   For _nP := 1 To Len(aHeader)

     // cria campo em branco                        
     If AllTrim(aHeader[_nP,2]) == "C7_ALI_WT" .Or. AllTrim(aHeader[_nP,2]) == "C7_REC_WT"     
       aCols[_nLin,_nP] :=0      
     Else   
       aCols[_nLin,_nP] := CriaVar(aHeader[_nP,2])    
     EndIf

     // atualiza o valor do ACOLS do Pedido de Compra
     Do Case
        Case AllTrim(aHeader[_nP,2]) == "C7_ITEM"   
           aCols[_nLin,_nP] := _cItem    
        Case AllTrim(aHeader[_nP,2]) == "C7_PRODUTO" 
           aCols[_nLin,_nP] := aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "PROD"})] 
        Case AllTrim(aHeader[_nP,2]) == "C7_QUANT" 
           aCols[_nLin,_nP] := aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "SUGCOM"})]           
     EndCase                  
     _ger   :=.T.
   Next _np
   
   // Executa as triggers
   For _ny := 1 To Len(aHeader)
       If AllTrim(aHeader[_ny,2]) == "C7_PRODUTO"  
          If ExistTrigger("C7_PRODUTO") // verifica se existe trigger para este campo
             SB1->(DbSeek(Xfilial("SB1")+aCols[_nLin,_nY])) // Posiciona o Produto para pegar os valores corretos nas triggers
             RunTrigger(2,_nLin,nil,,"C7_PRODUTO") // Executo a trigger
          Endif
       EndIf   
   Next _ny

   // Disparo rotina padrão do Protheus no VALID
   A120Produto(aCols[_nLin,aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"}) ])
   
   // Inicia a Carga do item nas funcoes MATXFIS       
   MaFisToCols(aHeader,aCols,,"MT100")
   MaFisAlt("IT_TES",aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES"}) ],n)
   If !MaFisFound("NF")
      MaFisIni(ca120Forn,ca120Loj,"F","N",Nil,aRefImpos,,.T.)
   Endif
   MaFisIniLoad(n)
   For _nX := 1 To Len(aRefImpos)
       _nPosRef := aScan(aHeader,{|x| AllTrim(x[2]) == aRefImpos[_nX][2]})
       If _nPosRef > 0
          MaFisLoad(aRefImpos[_nX][3],aCols[n,_nPosRef],n)
       Endif
       MaFisEndLoad(n,2)  
   Next _nP
   
Next _yy

          
// Executa o Refresh nos valores de impostos se existir.
A120Refresh(@aValores)    
// Executa o Refresh na GetDados do Pedido de Compra.   
GetdRefresh()

If !_ger     
   MsgStop(OemToAnsi("Não Foi Possivel Transferir a Sugestão de compra Para o Pedido de Compra , verifique."),OemToAnsi("Atencao"))
   Return .F.
Else                  
   MsgInfo(OemToAnsi("Sugestão de Compra Transferida para o Pedido de Compra com Sucesso  , verifique."),OemToAnsi("Atencao"))
   Return .T.
EndIf
Return 


//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função do Botão < SUGESTÃO > ==> Gera a Sugestão de Compras na Tela de Sugestão de Compra
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fmonqury() 
Local aSaveArea:= GetArea()
Local _nSaldo  	:= 0
Local _PrcVen	:= 0
Local _PrcCom	:= 0
Local _SugCom	:= 0
Local _nQtdMes	:= 0

If Empty(_ddat01I) .Or. Empty(_ddat01F) .Or. Empty(_ddat02I) .Or. Empty(_ddat02F)
   MsgStop(OemToAnsi("Periodo de Sugestão Invalido , verifique."),OemToAnsi("Atencao"))
   Return 
EndIf

If _ddat01F<_ddat01I   
   MsgStop(OemToAnsi("Periodo de Venda ( 1 ) Invalido , verifique."),OemToAnsi("Atencao"))
   Return 
ElseIf _ddat02F<_ddat02I
   MsgStop(OemToAnsi("Periodo de Venda ( 2 ) Invalido , verifique."),OemToAnsi("Atencao"))
   Return 
EndIf          

_nQtdMes	:= Month(_ddat02F) - Month(_ddat02I) + 1

aColssc := {} // Inicializa o ACOLS da Sugestão de Compra

/// *** Criação da QUERY *** ///
_cQuery := "SELECT A5_PRODUTO  , SDX.D2_COD AS PROD, SA5.A5__UNFOR AS UNIDA5 , " 

// Gera a Descriçao do Produto
_cQuery += " (SELECT SB1.B1_DESC 
_cQuery += " FROM "+RetSqlName("SB1")+" SB1  "
_cQuery += " WHERE  SB1.D_E_L_E_T_ <> '*'  AND  "
_cQuery += " SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
_cQuery += " SB1.B1_COD = SA5.A5_PRODUTO) AS DESCPR ,  "

// Gera a Descriçao a Unidade de compra do Produto pela tabela de produtos
_cQuery += " (SELECT SB1.B1_SEGUM 
_cQuery += " FROM "+RetSqlName("SB1")+" SB1  "
_cQuery += " WHERE  SB1.D_E_L_E_T_ <> '*'  AND  "
_cQuery += " SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
_cQuery += " SB1.B1_COD = SA5.A5_PRODUTO) AS UNIDB1 ,  "

// Gera a Descriçao a Unidade de Venda do Produto pela tabela de Vendas
_cQuery += " (SELECT D2_UM "
_cQuery += " FROM "+ RetSqlName("SD2") + " D2 "
_cQuery += " WHERE  D2.D_E_L_E_T_ = ' ' "
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "
_cQuery += " AND D2_COD = SA5.A5_PRODUTO "
_cQuery += " AND D2_TIPO = 'N' "                   
_cQuery += " AND D2_EMISSAO = (SELECT MAX(D2_EMISSAO)  FROM "+RetSqlName("SD2") +" D22  "
_cQuery += " WHERE   D22.D_E_L_E_T_ = ' '   AND  D2.D2_FILIAL = D22.D2_FILIAL  AND   D2.D2_COD =  D22.D2_COD AND  ROWNUM<= 1)) AS UNIDVEN, "


// Gera a Quantidade Vendida do Periodo (1)
_cQuery += " (SELECT  SUM(SD2.D2_QUANT) 
_cQuery += " FROM "+RetSqlName("SD2")+" SD2  "
_cQuery += " WHERE  SD2.D_E_L_E_T_ <> '*'  AND  "
_cQuery += " SD2.D2_FILIAL ='"+xFilial("SD2")+"' AND "
_cQuery += " SD2.D2_EMISSAO >= '"+Dtos(_ddat01I)+"' AND "
_cQuery += " SD2.D2_EMISSAO <= '"+Dtos(_ddat01F)+"' AND "
_cQuery += " SD2.D2_COD >= SA5.A5_PRODUTO AND  "
_cQuery += " SD2.D2_COD <= SA5.A5_PRODUTO AND  "
_cQuery += " SD2.D2_TIPO = 'N' AND "
_cQuery += " EXISTS (SELECT SF4.F4_CODIGO FROM "+RetSqlName("SF4")+" SF4 WHERE  SF4.F4_CODIGO = SD2.D2_TES  AND  "
_cQuery += " SF4.F4_ESTOQUE = 'S'  AND  SF4.D_E_L_E_T_ <> '*'  )) AS QTDVENP1 , "       


// Gera a Quantidade Vendida do Periodo (2)
_cQuery += " (SELECT  SUM(SD2.D2_QUANT) "
_cQuery += " FROM "+RetSqlName("SD2")+" SD2  "
_cQuery += " WHERE  SD2.D_E_L_E_T_ <> '*'  AND  "
_cQuery += " SD2.D2_FILIAL ='"+xFilial("SD2")+"' AND "
_cQuery += " SD2.D2_EMISSAO >= '"+Dtos(_ddat02I)+"'  AND "
_cQuery += " SD2.D2_EMISSAO <= '"+Dtos(_ddat02F)+"'  AND "
_cQuery += " SD2.D2_COD >= SA5.A5_PRODUTO AND "
_cQuery += " SD2.D2_COD <= SA5.A5_PRODUTO AND "
_cQuery += " SD2.D2_TIPO = 'N' AND "
_cQuery += " EXISTS (SELECT SF4.F4_CODIGO FROM "+RetSqlName("SF4")+" SF4 WHERE SF4.F4_CODIGO = SD2.D2_TES  AND  "
_cQuery += " SF4.F4_ESTOQUE = 'S'  AND  SF4.D_E_L_E_T_ <> '*'  )) AS QTDVENP2, "
                                          
// Gera a Quantidade de Compra 
_cQuery += " (SELECT SUM(SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA)  FROM "+RetSqlName("SC7")+" SC7 "
_cQuery += " WHERE "
_cQuery += " SC7.C7_FILIAL = '"+xFilial("SC7")+"'  AND "
_cQuery += " SC7.C7_RESIDUO <> 'S' AND  "
_cQuery += " SC7.C7_PRODUTO >= SA5.A5_PRODUTO AND "
_cQuery += " SC7.C7_PRODUTO <= SA5.A5_PRODUTO AND "
_cQuery += " (SC7.C7_QUANT-SC7.C7_QUJE-SC7.C7_QTDACLA)>0 AND "
_cQuery += " SC7.D_E_L_E_T_ <> '*' "
_cQuery += " GROUP BY C7_PRODUTO) AS COMPRAS,"

// Gera a Quantidade Valor Bruto e de Custo para achar a Margem
_cQuery += " (SELECT  SUM(C6_QTDVEN-C6_QTDEMP-C6_QTDENT) SALDO "
_cQuery += " FROM  "+RetSqlName("SC6")+" SC6 , "+RetSqlName("SC5")+" SC5  "
_cQuery += " WHERE  "
_cQuery += " SC6.C6_PRODUTO = SA5.A5_PRODUTO AND "
_cQuery += " SC6.C6_BLQ NOT IN('R ') AND "
_cQuery += " SC6.C6_BLQ NOT IN('S ') AND "  
_cQuery += " (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
_cQuery += " SC6.D_E_L_E_T_<>'*' AND  "
_cQuery += " SC5.C5_NUM = SC6.C6_NUM AND "
_cQuery += " SC5.C5_TIPO NOT IN('D','B') AND  "
_cQuery += " SC5.C5_LIBEROK <> 'E'  AND "
_cQuery += " SC6.D_E_L_E_T_<>'*' AND  "
_cQuery += " SC5.D_E_L_E_T_<>'*') AS PREFATUR, "

_cQuery += " SUM(SDX.D2_TOTAL-SDX.D2_VALIMP5-SDX.D2_VALIMP6-SDX.D2_VALICM)  TOTBRU , SUM( SDX.D2_CUSTO1) TOTCUS "
_cQuery += " FROM "+RetSqlName("SA5")+" SA5 "


// Left Join para os campos ==> D2_TOTAL / D2_VALIMP5  / D2_VALIMP6 / D2_VALICM / D2_CUSTO1
_cQuery += " LEFT OUTER JOIN "+RetSqlName("SD2")+" SDX ON "
_cQuery += " SDX.D_E_L_E_T_ <> '*'  AND  "
_cQuery += " SDX.D2_FILIAL ='"+xFilial("SD2")+"'  AND "
_cQuery += " SDX.D2_EMISSAO >= '"+Dtos(_ddat01I)+"' AND "
_cQuery += " SDX.D2_EMISSAO <= '"+Dtos(_ddat01F)+"' AND "
_cQuery += " SDX.D2_COD >= SA5.A5_PRODUTO AND "
_cQuery += " SDX.D2_COD <= SA5.A5_PRODUTO AND "
_cQuery += " SDX.D2_TIPO = 'N' AND "
_cQuery += " EXISTS (SELECT SF4.F4_CODIGO FROM "+RetSqlName("SF4")+" SF4 WHERE  SF4.F4_CODIGO = SDX.D2_TES  AND  
_cQuery += " SF4.F4_ESTOQUE = 'S'  AND  SF4.D_E_L_E_T_ <> '*'  ) "

// Condição da Tabela Principal 
_cQuery += " WHERE  SA5.A5_FILIAL= '"+xFilial("SA5")+"'  AND  "
_cQuery += " SA5.A5_FORNECE='"+CA120FORN+"' AND  "
_cQuery += " SA5.A5_LOJA='"+CA120LOJ+"'  AND  "
_cQuery += " SA5.D_E_L_E_T_<>'*' "

// Agrupando e Ordenando por Produto
_cQuery += " GROUP  BY  SA5.A5_PRODUTO , SDX.D2_COD , SA5.A5__UNFOR  "
_cQuery += " ORDER BY  SA5.A5_PRODUTO ASC "

MemoWrite("lixoj.xxx",_cQuery)	         

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"_TRB",.T.,.T.)    

TcSetField("_TRB", "QTDVENP1"   , "N", 12, 2)
TcSetField("_TRB", "QTDVENP2"   , "N", 12, 2)
TcSetField("_TRB", "COMPRAS"   , "N", 12, 2)
TcSetField("_TRB", "TOTBRU"   , "N", 12, 2)
TcSetField("_TRB", "TOTCUS"   , "N", 12, 2)


// Trasnfere o resultado da query para o ACOLS da GETDADOS
_TRB->(DbGotop())
If _TRB->(!Eof())
   SB1->(DbSetOrder(1))  // Setando indice do Produto para calculo de Estoque
   SB2->(DbSetOrder(1))  // Setando indice dos Saldos para calculo de Estoque
   _TRB->(DbGotop())
   While !_TRB->(Eof())                      
      // Posiciona a SB1 e SB2 para Calculo do Saldo do Produto
      _nSaldo := 0
      If SB1->(DbSeek(xFilial("SB1")+_TRB->A5_PRODUTO))
         SB2->(DbSeek(xFilial("SB2")+_TRB->A5_PRODUTO+SB1->B1_LOCPAD))
         _nSaldo := u_xSldProd(xFilial("SB2"),_TRB->A5_PRODUTO,SB1->B1_LOCPAD) 
      EndIf
          
   	  _PrcVen	:= U_PrcVen(_TRB->A5_PRODUTO)
   	  _PrcCom	:= U_PrcCom(_TRB->A5_PRODUTO,ca120Forn,ca120Loj)   	  
   	  _SugCom	:= _TRB->COMPRAS - (_TRB->QTDVENP2/_nQtdMes)
   	  
   	  If _SugCom < 1
   	  	_SugCom := 0
   	  Else
   	  	If !((Int(_SugCom)/2) ==  (_SugCom/2))
			_SugCom := Int(_SugCom) + 1
		EndIf
   	  EndIf
   	  	
      AADD(aColssc,Array(Len(aHeadsc)+1))
      _nLin := Len(aColssc)
      aColssc[_nLin,Len(aHeadsc)+1] := .F.
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "PROD"})]    := _TRB->A5_PRODUTO
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "DESC"})]    := _TRB->DESCPR
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "DTULV"})]   := _TRB->UNIDVEN
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "DTULC"})]   := Iif(!Empty(_TRB->UNIDA5),_TRB->UNIDA5,_TRB->UNIDB1)
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "VLVENP1"})] := _TRB->QTDVENP1
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "VLVENP2"})] := _TRB->QTDVENP2
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "VLEST"})]   := _nSaldo
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "VLCOM"  })] := _TRB->COMPRAS
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "VLFAT"  })] := _TRB->PREFATUR
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "MARGEM"  })]:= Iif(!Empty(_PrcCom),_PrcVen/_PrcCom,0)
      aColssc[_nLin,aScan(aHeadsc,{|x| AllTrim(x[2]) == "SUGCOM"  })]:= _SugCom
      aColssc[_nLin,Len(aHeadsc)+1] := .F.
      _TRB->(DbSkip())
   End-While      
Else
   MsgInfo(OemToAnsi("Nenhum Produto Encontrado para Sugestão de Compra dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
EndIf
_TRB->(DbCloseArea())
oGetDados0:aCols := aClone(aColssc)
oGetDados0:Refresh()  

RestArea(aSaveArea)
Return 
                            
//////////////////////////////////////////////////
//Pega o preco de venda do produto
//////////////////////////////////////////////////

User Function PrcVen(cProd)	

Local cQuery	:= ""
Local xTEMP		:= {}

cQuery += "SELECT DISTINCT DA1_PRCVEN AS PRCVEN "
cQuery += "FROM "+ RetSqlName("DA1") + " DA1 "
cQuery += "WHERE  DA1.D_E_L_E_T_ = ' ' "
cQuery += "AND DA1_FILIAL = '" + xFilial("DA1") + "' "
cQuery += "AND DA1_CODPRO = '" + cProd + "' "
cQuery += "AND DA1_ESTADO = '  ' "                   
cQuery += "AND DA1_DATVIG = (SELECT MAX(DA1A.DA1_DATVIG)  FROM "+RetSqlName("DA1") +" DA1A "
cQuery += "WHERE   DA1A.D_E_L_E_T_ = ' ' AND DA1A.DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1A.DA1_CODPRO = '" + cProd + "' ) "
 
If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()

Return(xTEMP->PRCVEN)


//////////////////////////////////////////////////
//Pega o preco de compra do produto
//////////////////////////////////////////////////

User Function PrcCom(cProd, cFor, cLoja)

Local cQuery	:= ""
Local xTEMP		:= {}

cQuery += "SELECT DISTINCT AIB_PRCCOM AS PRCCOM "
cQuery += "FROM "+ RetSqlName("AIB") + " AIB "
cQuery += "WHERE  AIB.D_E_L_E_T_ = ' ' "
cQuery += "AND AIB_FILIAL = '" + xFilial("AIB") + "' "
cQuery += "AND AIB_CODPRO = '" + cProd + "' "
cQuery += "AND AIB_CODFOR = '" + cFor + "' "
cQuery += "AND AIB_LOJFOR = '" + cLoja + "' "
cQuery += "AND AIB_DATVIG = (SELECT MAX(AIBA.AIB_DATVIG)  FROM "+RetSqlName("AIB") +" AIBA "
cQuery += "WHERE  AIBA.D_E_L_E_T_ = ' ' AND AIBA.AIB_FILIAL = '" + xFilial("AIB") + "' AND AIBA.AIB_CODPRO = '" + cProd + "'  AND  ROWNUM <= 1) "
 
If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()

Return(xTEMP->PRCCOM)