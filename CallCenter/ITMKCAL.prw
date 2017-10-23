#Include "Protheus.ch"
#Include "TMKDEF.CH"
#Include "TRYEXCEPTION.CH"

#DEFINE _LIDLG  aCoors[1]
#DEFINE _CIDLG  aCoors[2]
#DEFINE _LFDLG  aCoors[3]
#DEFINE _CFDLG  aCoors[4]

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKCAL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Tela de atendimento do Call Center                                                  |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKCAL()
Local aObjeto := {}, aTamAut := MsAdvSize()
Private _aHeadPA3 := {}, _aColPA3 := {}, _oDlgPA3 := Nil, _oEncPA3 := Nil, _oGetPA3 := Nil, inclui := .t., altera := .f.
Private _lOK := .t., _bEndDlg := { || _lOK := .f.,IIF(!Empty(M->PA3_CODCLI),ITMKMOTIVO(),""), _oDlgPA3:End() }

If Val(U_SETSEGTO()) <= 0
    Help(" ",1,"Usuario sem permissao para acessar esta rotina por não estar vinculado a um segmento.")
    Return
EndIf

If !TMKOPERADOR()
    Help("  ",1,"OPERADOR")
    Return
Endif

//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"

AAdd( aObjeto, { 100, 100, .T., .T. } )
aInfo := { aTamAut[ 1 ], aTamAut[ 2 ], aTamAut[ 3 ], aTamAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjeto, .f. ) 
aPosEnch := {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-60,aPosObj[1,4]}

DbSelectArea("PA3")
RegToMemory("PA3",.t.)

ITMKCALGET()

DEFINE MSDIALOG _oDlgPA3 TITLE "Call Center ISAPA - Atendimento" From aTamAut[7],0 To aTamAut[6],aTamAut[5] Of oMainWnd PIXEL
_oEncPA3 := MsMGet():New("PA3",0,3,,,,,aPosEnch,,,,,_oDlgPA3)
_oGetPA3 := MsNewGetDados():New(aPosObj[1,3]-65,aPosObj[1,2], aPosObj[1,3]-12, aPosObj[1,4], /*GD_UPDATE*/,,,,,, 9999,,,, _oDlgPA3, _aHeadPA3, _aColPA3)
@aPosObj[1,3]-5,aPosObj[1,4]-300 BUTTON "F4-Pedido"        SIZE 50,14 ACTION {|| ITMKCPED()}     OF _oDlgPA3 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-250 BUTTON "F5-Cons. Pedido"  SIZE 50,14 ACTION {|| ITMKPEDIDOS()}  OF _oDlgPA3 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-200 BUTTON "F6-Cons. Cotacao" SIZE 50,14 ACTION {|| ITMKCOTACAO()}  OF _oDlgPA3 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-150 BUTTON "F7-Contatos"      SIZE 50,14 ACTION {|| At450Contatos("M->PA3_CODCLI","M->PA3_LOJA"),ITMKCALGET()}  OF _oDlgPA3 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-100 BUTTON "F8-Pos. Cliente"  SIZE 50,14 ACTION {|| U_ITMKPOSCLI(M->PA3_CODCLI,M->PA3_LOJA)}   OF _oDlgPA3 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-050 BUTTON "F12-Sair"         SIZE 50,14 ACTION Eval(_bEndDlg)  OF _oDlgPA3 PIXEL

ITMKSETK()//determina SETKEY  

ACTIVATE MSDIALOG _oDlgPA3 CENTER

If _lOK
    ITMKMOTIVO()
EndIf

Return

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKCALGET | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Monta os arrays da GetDados                                                            |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKCALGET()
Local _aCpo := {"UA_CODCONT","U5_CONTAT","UM_DESC","U5_DDD","U5_FCOM1","U5_CODPAIS","U5_NIVER","U5_EMAIL"}
Local _aTitulo := {"Contato","Nome","Cargo","DDD","Telefone","Ramal","Aniversario","E-mail"}
Local nx := 0, _aFill := {}, _aLinha := {}, _cTab := ""

_aHeadPA3 := {}
_aColPA3  := {}

//Monta o cabeçalho - aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nx := 1 to Len(_aCpo)
    If SX3->(MsSeek(_aCpo[nx]))
        AADD(_aHeadPA3, {_aTitulo[nx],_aCpo[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,""})
    Endif
Next nx

//Monta o aCols
For nx := 1 to Len(_aCpo)
    AADD(_aFill, CriaVar(_aCpo[nx]))
Next nx

AADD(_aFill,.F.) 
AADD(_aColPA3, _aFill)

If Type("_oGetPA3") == "O"
    _oGetPA3:aCols := _aColPA3
    _oGetPA3:Refresh()
EndIf

If !Empty(M->PA3_CODCLI) .And. !Empty(M->PA3_LOJA)

    _cTab := GetNextAlias()
    _cSQL := "Select Distinct AC8_FILIAL,AC8_FILENT,AC8_ENTIDA,AC8_CODENT,AC8_CODCON,"
    _cSQL +=        "U5_CONTAT,UM_DESC,U5_DDD,U5_FCOM1,AGB_COMP,U5_NIVER,U5_EMAIL From " + RetSqlName("AC8") + " C8 "
    _cSQL +=    "Inner Join " + RetSqlName("SU5") + " U5 On U5_FILIAL = '" + xFilial("SU5") + "' And U5_CODCONT = AC8_CODCON And U5.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SUM") + " UM On UM_FILIAL = '" + xFilial("SUM") + "' And UM_CARGO = U5_FUNCAO And UM.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("AGB") + " GB On AGB_FILIAL = '" + xFilial("AGB") + "' And AGB_CODIGO = U5_AGBCOM And AGB_ENTIDA = 'SU5' And "
    _cSQL +=                                               "AGB_CODENT = U5_CODCONT And GB.D_E_L_E_T_ = ' ' "
    _cSQL += "Where AC8_FILIAL = '" + xFilial("AC8") + "' And AC8_ENTIDA = 'SA1' And AC8_CODENT = '" + M->PA3_CODCLI + M->PA3_LOJA + "' And "
    _cSQL +=     "C8.D_E_L_E_T_ = ' ' " 
    _cSQL += "Order By U5_CONTAT,AC8_CODCON "
    
    If Select(_cTab) > 0
        DbSelectArea(_cTab)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
    
    DbSelectArea(_cTab)
    DbGoTop()
    
    While !Eof()
        AADD(_aLinha,{  (_cTab)->AC8_CODCON,;
                        (_cTab)->U5_CONTAT,;
                        (_cTab)->UM_DESC,;
                        (_cTab)->U5_DDD,;
                        (_cTab)->U5_FCOM1,;
                        (_cTab)->AGB_COMP,;
                        STOD((_cTab)->U5_NIVER),;
                        (_cTab)->U5_EMAIL,;
                        .f.})
        
        DbSelectArea(_cTab)
        DbSkip()
    EndDo
    
    If Len(_aLinha) > 0
        _oGetPA3:aCols := _aLinha
        _oGetPA3:Refresh()
    EndIf

EndIf

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKUVIS | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ultima operador a visitar o cliente                                                  |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKUVIS(_cCli,_cLoja,_cRet)
Local _cSQL := _cTab := "", _cConteudo := "", _aArea := GetArea()
Default _cCli := "", _cLoja := ""

DbSelectArea("Z23")

_cTab := GetNextAlias()
_cSQL := "Select MAX(Z.R_E_C_N_O_) Z23RECNO From " + RetSqlName("Z23") + " Z "
_cSQL += "Where Z23_CODCLI = '" + _cCli + "' And Z23_LOJA = '" + _cLoja + "' And Z.D_E_L_E_T_ = ' ' "  

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    DbSelectArea("Z23")
    DbGoTo((_cTab)->Z23RECNO)
    
    If _cRet == "1"
        _cConteudo := Z23->Z23_NUSER
    Else
        _cConteudo := Z23->Z23_DATA
    EndIf
    
EndIf  

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

RestArea(_aArea)
Return _cConteudo


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKCNT1 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Contatos do cliente                                                                  |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKCNT1(_cConteudo)
Local _aArea := GetArea()

ITMKCALGET()

RestArea(_aArea)
Return _cConteudo

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKCPED | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Inclusão de pedido                                                                   |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function ITMKCPED()
Local _aCpoEnch := {}, _oException
Private inclui      := .t., altera := .f.
Private cCadastro   := "Atendimento"
Private aRotina     := {}
Private lTk271Auto  := .f.
Private aAutoCab    := {}                           // Campos de Cabecalho utilizados na rotina automatica
Private aAutoItens  := {}                           // Campos dos Itens utilizados na rotina automatica
Private cAliasAuto  := "SUA"                        // Alias para identificar qual sera a rotina de atendimento para entrada automatica
Private aTELA[0][0],aGETS[0]
Private aTELA1[0][0],aGETS1[0]
Private aTELA2[0][0],aGETS2[0]
Private aTELA3[0][0],aGETS3[0]

If Empty(M->PA3_CODCLI) .Or. Empty(M->PA3_LOJA) .Or. Empty(M->PA3_TPOPER)
    MsgStop("Existem campos obrigatórios nao preenchidos, favor verificar","ATENCAO")
    Return
EndIf

If Empty(M->PA3_FILATE)
    MsgStop("Filial nao informada","ATENCAO")
    Return
EndIf

DbSelectArea("SA1")
DbSetOrder(1)
If !MsSeek(xFilial("SA1") + M->PA3_CODCLI + M->PA3_LOJA)
    MsgStop("Cliente incorreto, favor verificar","ATENCAO")
    Return
ElseIf !U_ITMKVLSA1(M->PA3_CODCLI,M->PA3_LOJA)
    MsgAlert("Cliente possui restrição. Só será permitida geração de cotação.","AVISO")
EndIf

//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"

DbSelectArea("SX3")
DbSetOrder(1)
MsSeek("SUA")

While !Eof() .And. SX3->X3_ARQUIVO == "SUA"
    If X3Uso(SX3->X3_USADO)
        AADD(_aCpoEnch,SX3->X3_CAMPO)
    EndIf
    DbSkip()  
EndDo

ITMKRETK()
SetFunName("TMKA271")
DbSelectArea("SUA")
TryException
    cFilAnt := M->PA3_FILATE
    TK271CallCenter("SUA",0 ,3 ,_aCpoEnch,M->PA3_CODCLI,M->PA3_LOJA ,_oGetPA3:aCols[_oGetPA3:nat][1],"SA1",nil ,""   ,.F.) 
CatchException Using _oException
    //Se der erro.log confirma o controle de numeração por causa da gravação online
    ConfirmSX8()
    
    ErrorDlg(_oException)
    Eval(ErrorBlock(),_oException)
EndException
ITMKSETK()
cFilAnt := SM0->M0_CODFIL
SetFunName("ITMKCAL")

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKSETK | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Definição das teclas de atalho                                                       |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function ITMKSETK()

SetKey( VK_F4  , { || ITMKCPED()     } )
SetKey( VK_F5  , { || ITMKPEDIDOS()  } )
SetKey( VK_F6  , { || ITMKCOTACAO()  } )
SetKey( VK_F7  , { || At450Contatos("M->PA3_CODCLI","M->PA3_LOJA"),ITMKCALGET()} )
SetKey( VK_F8  , { || ITMKPOSCLI()   } )
SetKey( VK_F12 , _bEndDlg )

Return


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKRETK | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Limpa as teclas de atalho                                                            |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function ITMKRETK()
SetKey( VK_F4  ,{|| ""})
SetKey( VK_F5  ,{|| ""})
SetKey( VK_F6  ,{|| ""})
SetKey( VK_F7  ,{|| ""})
SetKey( VK_F8  ,{|| ""})
SetKey( VK_F12 ,{|| ""})
Return


/*
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKPEDIDOS | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Consulta de pedidos                                                                     |
+------------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                   |
+------------+-----------------------------------------------------------------------------------------+
*/

Static Function ITMKPEDIDOS()
Local _nLin := _nLi2 := 0 
Local aSM0      := FWLoadSM0()
Private _aObjeto  := {}, _aSize := MsAdvSize(), _aInfo := {}, _aPosObj := {}, _aPosEnch := {}
Private _cFilial := M->PA3_FILATE, _cCodCli := M->PA3_CODCLI, _cLojaCli := M->PA3_LOJA, oFont := tFont():New("Tahoma",,-12,,.F.)
Private _cTpPed  := PADR("1",TamSX3("UA__TIPPED")[1]), _cDescri := Posicione("SZF",1,xFilial("SZF") + _cTpPed,"ZF_DESC"), _oTpPed := _oDescri := Nil
Private _cNomCli := _cEndCli := _cNomFil := "", _oDlgCot := Nil  

DbSelectArea("SA1")
DbSetOrder(1)
If !MsSeek(xFilial("SA1") + M->PA3_CODCLI + M->PA3_LOJA)
    MsgStop("Cliente incorreto, favor verificar","ATENCAO")
    Return
EndIf

If Empty(M->PA3_FILATE)
    MsgStop("Filial nao informada","ATENCAO")
    Return
EndIf
         
Private _aColCot := {}, _aHeadCot := {}

For x:=1 to Len(aSM0)
    If _cFilial == aSM0[x][2]
        _cNomFil := aSM0[x][7]
        Exit
    EndIf
Next

cFilAnt := _cFilial
//_cNomFil := Posicione("SZE",1,cEmpAnt + _cFilial,"ZE_FILIAL")
_cNomCli := SA1->A1_NOME
_cEndCli := SA1->A1_END
_aSize := MsAdvSize()

AAdd(_aObjeto, { 100, 100, .t., .t. } )
_aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}
_aPosObj := MsObjSize(_aInfo,_aObjeto)  
_nLin    := _aPosObj[1,1]+10
_nLi2    := _aPosObj[1,1]+8

DEFINE MSDIALOG _oDlgCot TITLE "Consulta Pedidos" From _aSize[7],0 To _aSize[6],_aSize[5] OF oMainWnd PIXEL

ICabCot(.t.,@_nLin,@_nLi2,@_oDlgCot,"PED")                                       
_nLin += 15
@ _nLin,_aPosObj[1,4]-260 BUTTON "Imprimir"  SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| ITMKCALIMP(_oGetCot:aCols[_oGetCot:nAt][1],_cFilial) }
@ _nLin,_aPosObj[1,4]-190 BUTTON "Reabrir"   SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| IRecallPed(_cFilial,_oGetCot:aCols[_oGetCot:nAt][1],_oGetCot:aCols[_oGetCot:nAt][Len(_oGetCot:aHeader)]),IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"1") }
@ _nLin,_aPosObj[1,4]-120 BUTTON "Detalhes"  SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| IDetSUA(_oGetCot:aCols[_oGetCot:nAt][1],"PED") }
@ _nLin,_aPosObj[1,4]-050 BUTTON "Fechar"    SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION _oDlgCot:End()
_nLin += 25

IHeadPed()
_oGetCot := MsNewGetDados():New(_nLin,_aPosObj[1,2], _aPosObj[1,3]-12, _aPosObj[1,4], /*GD_UPDATE*/,,,,,, 9999,,,, _oDlgCot, _aHeadCot, _aColCot)
IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"1")

//_oTpPed:bChange := {|| _cDescri := Posicione("SZF",1,xFilial("SZF") + _cTpPed,"ZF_DESC"),_oDescri:Refresh(),IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2") }
ACTIVATE MSDIALOG _oDlgCot CENTERED

cFilAnt := SM0->M0_CODFIL
SetFunName("ITMKCAL")

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IHeadPed | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Cabeçalho da Consulta de pedidos                                                     |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IHeadPed()
Local _aCpo    := {"UB_NUM","UA__DTAPFI","UA__DTAPCO","ZM_DESC","UB_VLRITEM","UA_VEND","A1_DDD","A1_TEL","A1_MUN","A4_NREDUZ","ZJ_NMTRANS","ZUA_TEL"}
Local _aTam    := {TamSX3("UB_NUM")[1],TamSX3("UA__DTAPFI")[1],TamSX3("UA__DTAPCO")[1],25,14,TamSX3("UA_VEND")[1],3,12,30,TamSX3("A3_NREDUZ")[1],TamSX3("A3_NREDUZ")[1],TamSX3("ZUA_TEL")[1]} 
Local _aTitulo := {"Pedido","Emissao","Prev. Fat","Status","Vl. c/ IPI","Vendedor","DDD","Telefone","Municipio","Transp.","Redesp."," "}
Local nx := 0, _aFill := {}, _cCot := _cTab := ""

_aHeadCot := {}
_aColCot  := {}

//Monta o cabeçalho - aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nx := 1 to Len(_aCpo)
    If SX3->(MsSeek(_aCpo[nx])) 
        AADD(_aHeadCot, {_aTitulo[nx],_aCpo[nx],SX3->X3_PICTURE,_aTam[nx],SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,""})
    Endif
Next nx

//Monta o aCols
For nx := 1 to Len(_aCpo)
    AADD(_aFill, CriaVar(_aCpo[nx]))
Next nx

AADD(_aFill,.F.) 
AADD(_aColCot, _aFill)

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGetDPed | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | GetDados da Consulta de pedidos                                                      |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,_cOri) 
Local nx := 0, _aFill := {}, _cCot := _cTab := "", _aArea := GetArea()

If !Empty(_cCodCli) .And. !Empty(_cLojaCli)

    _cCot := GetNextAlias()
    _cSQL := "Select Distinct UA_NUM,UA_EMISSAO,UA__PRVFAT,ZM_DESC,UA_VEND,A1_DDD,A1_TEL,A1_MUN,"
    _cSQL +=                 "A4T.A4_NOME A4_TRANSP,A4T.A4_DDD A4_DDD, A4T.A4_TEL A4_TEL, A4R.A4_NOME A4_REDESP From " + RetSqlName("SUA") + " UA "
    _cSQL +=    "Inner Join " + RetSqlName("SA1") + " A1  On A1_FILIAL = '" + xFilial("SA1") + "' And A1_COD = UA_CLIENTE And A1_LOJA = UA_LOJA And A1.D_E_L_E_T_ = ' ' "    
    _cSQL +=    "Inner Join " + RetSqlName("SZM") + " ZM  On ZM_FILIAL = '" + xFilial("SZM") + "' And ZM_COD = UA__STATUS And ZM.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SA4") + " A4T On A4T.A4_FILIAL = '" + xFilial("SA4") + "' And A4T.A4_COD = UA_TRANSP And A4T.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SA4") + " A4R On A4R.A4_FILIAL = '" + xFilial("SA4") + "' And A4R.A4_COD = UA__REDESP And A4R.D_E_L_E_T_ = ' ' "
    _cSQL += "Where UA_FILIAL = '" + _cFilial + "' And UA_CLIENTE = '" + _cCodCli + "' And UA_LOJA = '" + _cLojaCli + "' And "
    //_cSQL +=        "UA__TIPPED = '" + _cTpPed + "' And UA__SEGISP = '" + U_SETSEGTO() + "' And (UA__RESEST = 'S' Or UA__MOTCAN <> ' ') And "
    _cSQL +=        "UA__TIPPED = '" + _cTpPed + "' And UA__SEGISP = '" + U_SETSEGTO() + "' And UA__TIPPED Not In('4') And "
    _cSQL +=        "UA.D_E_L_E_T_ = ' ' "
    //_cSQL += "Order By UA_EMISSAO DESC, UA_NUM "
    _cSQL += "Order By UA_NUM DESC, UA_EMISSAO DESC "
    
    If Select(_cCot) > 0
        DbSelectArea(_cCot)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cCot,.T.,.T.)
    TcSetField( _cCot,"UA_EMISSAO", "D")
    TcSetField( _cCot,"UA__PRVFAT", "D")
      
    DbSelectArea(_cCot)
    DbGoTop()
    _aFill := {}
    While !Eof()
        AADD(_aFill,{ (_cCot)->UA_NUM,;
                       (_cCot)->UA_EMISSAO,;
                       (_cCot)->UA__PRVFAT,;
                       (_cCot)->ZM_DESC,;
                       ICalVTot(_cFilial,(_cCot)->UA_NUM,"",.f.),;
                       (_cCot)->UA_VEND,;
                       (_cCot)->A4_DDD,;
                       (_cCot)->A4_TEL,;
                       (_cCot)->A1_MUN,;
                       (_cCot)->A4_TRANSP,;
                       (_cCot)->A4_REDESP,;
                       " ",;
                        .f.})
        
        DbSelectArea(_cCot)
        DbSkip()
    EndDo
    
    
    //Busca os pedidos que estão na ZUA (Grav. Online) e que não estão no Call Center (SUA)
    _cSQL := "Select Distinct ZUA_NUM,ZUA_DTEMIS,ZUA_PRVFAT,ZUA_VEND,ZM_DESC,A1_DDD,A1_TEL,A1_MUN,"
    _cSQL +=                 "A4T.A4_NOME A4_TRANSP,A4T.A4_DDD A4_DDD, A4T.A4_TEL A4_TEL, A4R.A4_NOME A4_REDESP,UA_NUM From " + RetSqlName("ZUA") + " ZA "
    _cSQL +=    "Inner Join " + RetSqlName("SA1") + " A1  On A1_FILIAL = '" + xFilial("SA1") + "' And A1_COD = ZUA_CODCLI And A1_LOJA = ZUA_LOJA And A1.D_E_L_E_T_ = ' ' "    
    _cSQL +=    "Inner Join " + RetSqlName("SZM") + " ZM  On ZM_FILIAL = '" + xFilial("SZM") + "' And ZM_COD = ZUA_STATUS And ZM.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SUA") + " UA  On UA_FILIAL = '" + xFilial("SUA") + "' And UA_NUM = ZUA_NUM And UA.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SA4") + " A4T On A4T.A4_FILIAL = '" + xFilial("SA4") + "' And A4T.A4_COD = ZUA_TRANSP And A4T.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SA4") + " A4R On A4R.A4_FILIAL = '" + xFilial("SA4") + "' And A4R.A4_COD = ZUA_REDESP And A4R.D_E_L_E_T_ = ' ' "
    _cSQL += "Where ZUA_FILIAL = '" + _cFilial + "' And ZUA_CODCLI = '" + _cCodCli + "' And ZUA_LOJA = '" + _cLojaCli + "' And "
    _cSQL +=        "ZUA_TIPPED = '" + _cTpPed + "' And ZUA_SEGISP = '" + U_SETSEGTO() + "' And ZUA_TIPPED Not In('4') And "
    _cSQL +=        "ZA.D_E_L_E_T_ = ' ' And UA_NUM is Null "
    _cSQL += "Order By ZUA_NUM DESC, ZUA_DTEMIS DESC "
    
    If Select(_cCot) > 0
        DbSelectArea(_cCot)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cCot,.T.,.T.)
    TcSetField( _cCot,"ZUA_DTEMIS", "D")
    TcSetField( _cCot,"ZUA_PRVFAT", "D")
      
    DbSelectArea(_cCot)
    DbGoTop()

    While !Eof()
        AADD(_aFill,{ (_cCot)->ZUA_NUM,;
                       (_cCot)->ZUA_DTEMIS,;
                       (_cCot)->ZUA_PRVFAT,;
                       (_cCot)->ZM_DESC,;
                       ICalVTot(_cFilial,(_cCot)->ZUA_NUM,"",.t.),;
                       (_cCot)->ZUA_VEND,;
                       (_cCot)->A4_DDD,;
                       (_cCot)->A4_TEL,;
                       (_cCot)->A1_MUN,;
                       (_cCot)->A4_TRANSP,;
                       (_cCot)->A4_REDESP,;
                       "*",;
                        .f.})
        
        DbSelectArea(_cCot)
        DbSkip()
    EndDo    
    
    If Len(_aFill) > 0
        _oGetCot:aCols := aSort(_aFill, , , { | x,y | x[1]+DTOS(x[2]) > y[1]+DTOS(y[2]) } )  
        _oGetCot:Refresh()
    ElseIf Type("_oGetCot") == "O" .And. _cOri == "2"
        For nx := 1 To Len(_oGetCot:aHeader)
            AADD(_aFill, CriaVar(_oGetCot:aHeader[nx][2]))
        Next nx
    
        AADD(_aFill, .f.) 
        _oGetCot:aCols := {}
        AADD(_oGetCot:aCols,_aFill)
        _oGetCot:Refresh()
/*        
        If !Empty(_cDescri)
            MsgStop("Nao foi encontrado nenhum registro","0 REGISTROS")
            _cDescri := ""
        EndIf*/
    EndIf

    If Select(_cCot) > 0
        DbSelectArea(_cCot)
        DbCloseArea()
    EndIf

EndIf

RestArea(_aArea)
Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ICalVTot | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Calcula o total do pedido                                                            |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function ICalVTot(_cFilial,_cNum,_cTipo,_lZUB)
Local _cVal := _cTab := "", _nTotal := 0
Default _lZUB := .f.

_cTab := GetNextAlias()

If _lZUB
    If _cTipo == "S" //Com ST
        _cVal := "Select Sum(ZUB_VLRITE + ZUB_VALIPI + ZUB_VALIST) UB_TOTAL From " + RetSqlName("ZUB") + " UB "
    ElseIf _cTipo == "M" //Valor Mercadoria
        _cVal := "Select Sum(ZUB_VLRITE) UB_TOTAL From " + RetSqlName("ZUB") + " UB "
    Else //Mercadoria + IPI
        _cVal := "Select Sum(ZUB_VLRITE + ZUB_VALIPI) UB_TOTAL From " + RetSqlName("ZUB") + " UB "
    EndIf
    _cVal += "Where ZUB_FILIAL = '" + _cFilial + "' And ZUB_NUM = '" + _cNum + "' And UB.D_E_L_E_T_ = ' ' "
Else
    If _cTipo == "S" //Com ST
        _cVal := "Select Sum(UB_VLRITEM + UB__VALIPI + UB__VALIST) UB_TOTAL From " + RetSqlName("SUB") + " UB "
    ElseIf _cTipo == "M" //Valor Mercadoria
        _cVal := "Select Sum(UB_VLRITEM) UB_TOTAL From " + RetSqlName("SUB") + " UB "
    Else //Mercadoria + IPI
        _cVal := "Select Sum(UB_VLRITEM + UB__VALIPI) UB_TOTAL From " + RetSqlName("SUB") + " UB "
    EndIf
    _cVal += "Where UB_FILIAL = '" + _cFilial + "' And UB_NUM = '" + _cNum + "' And UB.D_E_L_E_T_ = ' ' "
EndIf

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cVal),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    _nTotal := (_cTab)->UB_TOTAL
EndIf

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

Return _nTotal

/*
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKCOTACAO | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Consulta de cotacao                                                                     |
+------------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                   |
+------------+-----------------------------------------------------------------------------------------+
*/

Static Function ITMKCOTACAO()
Local _nLin := _nLi2 := 0, _cRelato := "1;0;1;ITMKCR10"
Private _aObjeto  := {}, _aSize := MsAdvSize(), _aInfo := {}, _aPosObj := {}, _aPosEnch := {}
Private _cFilial := M->PA3_FILATE, _cCodCli := M->PA3_CODCLI, _cLojaCli := M->PA3_LOJA, oFont := tFont():New("Tahoma",,-12,,.F.)
Private _cTpPed  := PADR("4",TamSX3("UA__TIPPED")[1]), _cDescri := Posicione("SZF",1,xFilial("SZF") + _cTpPed,"ZF_DESC"), _oTpPed := _oDescri := Nil
Private _cNomCli := _cEndCli := _cNomFil := "", _oDlgCot := Nil, _lSair := .t.

DbSelectArea("SA1")
DbSetOrder(1)
If !MsSeek(xFilial("SA1") + M->PA3_CODCLI + M->PA3_LOJA)
    MsgStop("Cliente incorreto, favor verificar","ATENCAO")
    Return
EndIf

If Empty(M->PA3_FILATE)
    MsgStop("Filial nao informada","ATENCAO")
    Return
EndIf
         
Private _aColCot := {}, _aHeadCot := {}

cFilAnt  := _cFilial
_cNomFil := Posicione("SZE",1,cEmpAnt + _cFilial,"ZE_FILIAL")
_cNomCli := SA1->A1_NOME
_cEndCli := SA1->A1_END
_aSize   := MsAdvSize()

AAdd(_aObjeto, { 100, 100, .t., .t. } )
_aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}
_aPosObj := MsObjSize(_aInfo,_aObjeto)  
_nLin    := _aPosObj[1,1]+10
_nLi2    := _aPosObj[1,1]+8

DEFINE MSDIALOG _oDlgCot TITLE "Consulta Cotações" From _aSize[7],0 To _aSize[6],_aSize[5] OF oMainWnd PIXEL

ICabCot(.t.,@_nLin,@_nLi2,@_oDlgCot,"COT")                                       
_nLin += 15
@ _nLin,_aPosObj[1,4]-260 BUTTON "Imprimir"  SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| CallCrys('ITMKCR10',_oGetCot:aCols[_oGetCot:nAt][1]+";"+_cFilial,_cRelato) }
@ _nLin,_aPosObj[1,4]-190 BUTTON "Reabrir"   SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| IRecallPed(_cFilial,_oGetCot:aCols[_oGetCot:nAt][1],_oGetCot:aCols[_oGetCot:nAt][Len(_oGetCot:aHeader)]) }
@ _nLin,_aPosObj[1,4]-120 BUTTON "Detalhes"  SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| IDetSUA(_oGetCot:aCols[_oGetCot:nAt][1],"COT") }
@ _nLin,_aPosObj[1,4]-050 BUTTON "Fechar"    SIZE 50,14 Of _oDlgCot PIXEL FONT oFont ACTION {|| _lSair := .t.,_oDlgCot:End() }
_nLin += 25

IHeadCot()
_oGetCot := MsNewGetDados():New(_nLin,_aPosObj[1,2], _aPosObj[1,3]-12, _aPosObj[1,4], /*GD_UPDATE*/,,,,,, 9999,,,, _oDlgCot, _aHeadCot, _aColCot)
IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"1")

//_oTpPed:bChange := {|| _cDescri := Posicione("SZF",1,xFilial("SZF") + _cTpPed,"ZF_DESC"),_oDescri:Refresh(),IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2") }
ACTIVATE MSDIALOG _oDlgCot CENTERED

cFilAnt := SM0->M0_CODFIL
SetFunName("ITMKCAL")

If !_lSair
    ITMKCOTACAO()
EndIf

Return

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | ICabCot | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Cabeçalho Consulta de cotacao                                                       |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function ICabCot(_lEdit,_nLin,_nLi2,_oObj,_cRotina)
@ _nLin,010 Say "Filial"                FONT oFont SIZE 020,10 OF _oObj PIXEL
@ _nLi2,040 MsGet _cFilial              FONT oFont SIZE 007,10 of _oObj PIXEL When .f.
@ _nLi2,060 MsGet _cNomFil              FONT oFont SIZE 070,10 of _oObj PIXEL When .f.
@ _nLin,150 Say "Tipo Pedido"           FONT oFont SIZE 035,10 OF _oObj PIXEL
@ _nLi2,190 MsGet _oTpPed  Var _cTpPed  FONT oFont SIZE 020,10 of _oObj PIXEL When _lEdit F3 "SZF" Valid FilColsTMK(_cRotina)//ExistCpo("SZF",_cTpPed)
@ _nLi2,240 MsGet _oDescri Var _cDescri FONT oFont SIZE 060,10 of _oObj PIXEL When .f.
_nLin += 15
_nLi2 += 15
@ _nLin,010 Say "Cliente"           FONT oFont SIZE 020,10 OF _oObj PIXEL
@ _nLi2,040 MsGet _cCodCli          FONT oFont SIZE 050,10 of _oObj PIXEL When .f.
@ _nLi2,100 MsGet _cNomCli          FONT oFont SIZE 200,10 of _oObj PIXEL When .f.
_nLin += 15
_nLi2 += 15
@ _nLin,010 Say "Loja"              FONT oFont SIZE 020,10 OF _oObj PIXEL
@ _nLi2,040 MsGet _cLojaCli         FONT oFont SIZE 050,10 of _oObj PIXEL When .f.
@ _nLi2,100 MsGet _cEndCli          FONT oFont SIZE 200,10 of _oObj PIXEL When .f.

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IHeadCot | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Cabeçalho consulta cotação                                                           |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IHeadCot()
Local _aCpo    := {"UB_NUM","UA__DTAPFI","UA__DTAPCO","U7_NOME","UA_VALMERC","UA__DESCCP","UA_CONDPG","ZUA_TEL"}
Local _aTam    := {TamSX3("UB_NUM")[1],TamSX3("UA__DTAPFI")[1],TamSX3("UA__DTAPCO")[1],TamSX3("U7_NOME")[1],TamSX3("UA_VALMERC")[1],TamSX3("UA__DESCCP")[1],TamSX3("UA_CONDPG")[1],TamSX3("ZUA_TEL")[1]}
Local _aTitulo := {"Pedido","Emissao","Prev. Fat","Operador","Total Produtos","Cond. Pagto","Codigo"," "}
Local nx := 0, _aFill := {}, _cCot := _cTab := ""

_aHeadCot := {}
_aColCot  := {}

//Monta o cabeçalho - aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nx := 1 to Len(_aCpo)
    If SX3->(MsSeek(_aCpo[nx])) 
        AADD(_aHeadCot, {_aTitulo[nx],_aCpo[nx],SX3->X3_PICTURE,_aTam[nx],SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,""})
    Endif
Next nx

//Monta o aCols
For nx := 1 to Len(_aCpo)
    AADD(_aFill, CriaVar(_aCpo[nx]))
Next nx

AADD(_aFill,.F.) 
AADD(_aColCot, _aFill)

Return


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGetDCot | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | GetDados consulta cotação                                                            |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,_cOri) 
Local nx := 0, _aFill := {}, _cCot := _cTab := ""

If !Empty(_cCodCli) .And. !Empty(_cLojaCli)

    _cCot := GetNextAlias()
    _cSQL := "Select Distinct UA_NUM,UA_EMISSAO,UA__PRVFAT,U7_NOME,E4_DESCRI,UA_CONDPG From " + RetSqlName("SUA") + " UA "
    _cSQL +=    "Inner Join " + RetSqlName("SA1") + " A1 On A1_FILIAL = '" + xFilial("SA1") + "' And A1_COD = UA_CLIENTE And A1_LOJA = UA_LOJA And A1.D_E_L_E_T_ = ' ' "
    //_cSQL +=    "Inner Join " + RetSqlName("SUB") + " UB On UB_FILIAL = UA_FILIAL And UB_NUM = UA_NUM And UB.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Inner Join " + RetSqlName("SU7") + " U7 On U7_FILIAL = '" + xFilial("SU7") + "' And U7_COD = UA_OPERADO And U7.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Inner Join " + RetSqlName("SE4") + " E4 On E4_FILIAL = '" + xFilial("SE4") + "' And E4_CODIGO = UA_CONDPG And E4.D_E_L_E_T_ = ' ' "
    _cSQL += "Where UA_FILIAL = '" + _cFilial + "' And UA_CLIENTE = '" + _cCodCli + "' And UA_LOJA = '" + _cLojaCli + "' And UA__TIPPED = '" + _cTpPed + "' And "
    _cSQL +=        "UA__MOTCAN = ' ' And UA__SEGISP = '" + U_SETSEGTO() + "' And UA__RESEST In('N',' ') And UA.D_E_L_E_T_ = ' ' "
    //_cSQL += "Order By UA_EMISSAO DESC, UA_NUM "
    _cSQL += "Order By UA_NUM DESC, UA_EMISSAO DESC "
    
    If Select(_cCot) > 0
        DbSelectArea(_cCot)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cCot,.T.,.T.)
    TcSetField( _cCot,"UA_EMISSAO", "D")
    TcSetField( _cCot,"UA__PRVFAT", "D")
      
    DbSelectArea(_cCot)
    DbGoTop()
    _aFill := {}
    While !Eof()
        AADD(_aFill,{ (_cCot)->UA_NUM,;
                       (_cCot)->UA_EMISSAO,;
                       (_cCot)->UA__PRVFAT,;
                       (_cCot)->U7_NOME,;
                       ICalVTot(_cFilial,(_cCot)->UA_NUM,"M",.f.),;
                       (_cCot)->E4_DESCRI,;
                       (_cCot)->UA_CONDPG,;
                       " ",;
                        .f.})
        
        DbSelectArea(_cCot)
        DbSkip()
    EndDo
    
    //Busca os pedidos que estão na ZUA (Grav. Online) e que não estão no Call Center (SUA)
    _cSQL := "Select Distinct ZUA_NUM,ZUA_DTEMIS,ZUA_PRVFAT,U7_NOME,E4_DESCRI,ZUA_CONDPG,UA_NUM From " + RetSqlName("ZUA") + " ZA "
    _cSQL +=    "Inner Join " + RetSqlName("SA1") + " A1 On A1_FILIAL = '" + xFilial("SA1") + "' And A1_COD = ZUA_CODCLI And A1_LOJA = ZUA_LOJA And A1.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Inner Join " + RetSqlName("SU7") + " U7 On U7_FILIAL = '" + xFilial("SU7") + "' And U7_COD = ZUA_OPERAD And U7.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SE4") + " E4 On E4_FILIAL = '" + xFilial("SE4") + "' And E4_CODIGO = ZUA_CONDPG And E4.D_E_L_E_T_ = ' ' "
    _cSQL +=    "Left  Join " + RetSqlName("SUA") + " UA  On UA_FILIAL = '" + xFilial("SUA") + "' And UA_NUM = ZUA_NUM And UA.D_E_L_E_T_ = ' ' "
    _cSQL += "Where ZUA_FILIAL = '" + _cFilial + "' And ZUA_CODCLI = '" + _cCodCli + "' And ZUA_LOJA = '" + _cLojaCli + "' And ZUA_TIPPED = '" + _cTpPed + "' And "
    _cSQL +=        "ZUA_MOTCAN = ' ' And ZUA_SEGISP = '" + U_SETSEGTO() + "' And ZUA_RESEST In('N',' ') And ZA.D_E_L_E_T_ = ' ' And UA_NUM is Null "
    _cSQL += "Order By ZUA_NUM DESC, ZUA_DTEMIS DESC "
    
    If Select(_cCot) > 0
        DbSelectArea(_cCot)
        DbCloseArea()
    EndIf
    
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cCot,.T.,.T.)
    TcSetField( _cCot,"ZUA_DTEMIS", "D")
    TcSetField( _cCot,"ZUA_PRVFAT", "D")
      
    DbSelectArea(_cCot)
    DbGoTop()

    While !Eof()
        AADD(_aFill,{ (_cCot)->ZUA_NUM,;
                       (_cCot)->ZUA_DTEMIS,;
                       (_cCot)->ZUA_PRVFAT,;
                       (_cCot)->U7_NOME,;
                       ICalVTot(_cFilial,(_cCot)->ZUA_NUM,"M",.t.),;
                       (_cCot)->E4_DESCRI,;
                       (_cCot)->ZUA_CONDPG,;
                       "*",;
                        .f.})
        
        DbSelectArea(_cCot)
        DbSkip()
    EndDo    

    If Len(_aFill) > 0 
        _oGetCot:aCols := aSort(_aFill, , , { | x,y | x[1]+DTOS(x[2]) > y[1]+DTOS(y[2]) } )
        _oGetCot:Refresh()
    ElseIf Type("_oGetCot") == "O" .And. _cOri == "2"
        For nx := 1 To Len(_oGetCot:aHeader)
            AADD(_aFill, CriaVar(_oGetCot:aHeader[nx][2]))
        Next nx
    
        AADD(_aFill, .f.) 
        _oGetCot:aCols := {}
        AADD(_oGetCot:aCols,_aFill)
        _oGetCot:Refresh()
/*        
        If !Empty(_cDescri)
            MsgStop("Nao foi encontrado nenhum registro","0 REGISTROS")
            _cDescri := ""
        EndIf*/
    EndIf

EndIf

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IDetSUA  | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | MsMGet da SUA                                                                        |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IDetSUA(_cNumSUA,_cPedCot)
Local _oDlgDet, _nLin := _aPosObj[1,1]+10, _nLi2 := _aPosObj[1,1]+8
Local _aPosEnch := {}

DEFINE MSDIALOG _oDlgDet TITLE "Consulta Cotações" From _aSize[7],0 To _aSize[6],_aSize[5] OF oMainWnd PIXEL

ICabCot(.f.,@_nLin,@_nLi2,_oDlgDet,_cPedCot)
_nLin += 25

cFilAnt := _cFilial

DbSelectArea("SUA")
DbOrderNickName("FILNUM")
MsSeek(xFilial("SUA") + _cFilial + _cNumSUA)
_aPosEnch := {_nLin,_aPosObj[1,2],_aPosObj[1,3]-12,_aPosObj[1,4]}
RegToMemory("SUA",.f.)
_oGetGet := MsMGet():New("SUA",SUA->(Recno()),2,,,,,_aPosEnch,,,,,_oDlgDet)  

@ _aPosObj[1,3]-5,_aPosObj[1,4]-150 BUTTON "F6-Visualizar"       SIZE 50,14 ACTION  {|| ITMKVERPED() } OF _oDlgDet PIXEL
If SUA->UA__RESEST == "N"
    @ _aPosObj[1,3]-5,_aPosObj[1,4]-100 BUTTON "F7-Gerar Pedido" SIZE 50,14 ACTION  {|| ITMKGERAPV(_cPedCot) } OF _oDlgDet PIXEL
EndIf
@ _aPosObj[1,3]-5,_aPosObj[1,4]-050 BUTTON "F12-Retornar"        SIZE 50,14 ACTION  {|| _oDlgDet:End() } OF _oDlgDet PIXEL
ACTIVATE MSDIALOG _oDlgDet CENTERED

cFilAnt := SM0->M0_CODIGO

Return

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVERPED | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Visualizar o pedido                                                                    |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKVERPED()

//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"


DbSelectArea("SUA")
cFilAnt := _cFilial
SetFunName("TMKA271")
TK271CallCenter("SUA",SUA->(RecNo()),2) 
cFilAnt := SM0->M0_CODFIL
SetFunName("ITMKCAL")

Return

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKALTPED | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Reabertura do pedido                                                                   |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKALTPED()
//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"


DbSelectArea("SUA")
cFilAnt := _cFilial
SetFunName("TMKA271")
TK271CallCenter("SUA",SUA->(RecNo()) ,4) 
cFilAnt := SM0->M0_CODFIL
SetFunName("ITMKCAL")

Return

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKGERAPV | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Transforma cotação em pedido                                                           |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKGERAPV(_cPedCot)
Local _nSelect := 1, _lOK := .f., _oDlgPV 

If !U_ITMKVLSA1(M->PA3_CODCLI,M->PA3_LOJA)
    MsgAlert("Cliente possui restrição. Não pode ser gerado pedido","ATENCAO")
    Return
EndIf

DEFINE MSDIALOG _oDlgPV TITLE "Gerar Pedido" From 000,000 To 120,400 PIXEL

oRMenu1 := TRadMenu():New( 010,001,{"Indicacao Total","Indicacao Parcial"},bSetGet(_nSelect),_oDlgPV,,,CLR_BLACK,CLR_WHITE,"",,,197,025,,.F.,.F.,.T. )
@ 035, 070 BUTTON oButton1 PROMPT "Continuar" SIZE 037, 012 OF _oDlgPV PIXEL ACTION{|| _lOK := .t.,_oDlgPV:End()}
@ 035, 125 BUTTON oButton2 PROMPT "Retornar" SIZE 037, 012 OF _oDlgPV PIXEL ACTION _oDlgPV:End()
ACTIVATE MSDIALOG _oDlgPV CENTERED

SetFunName("TMKA271")
If _lOK
    If _nSelect == 1 //Total
        Processa({|| CursorWait(),ITMKTOTAL(),CursorArrow()},"Gerando pedido, aguarde...") 
        If _cPedCot == "COT"
            _oDlgCot:End()
            _lSair := .f.
            //MsAguarde({|| IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")}, "Atualizando consulta...")
        Else
            MsAguarde({|| IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")}, "Atualizando consulta...")        
        EndIf
    ElseIf _nSelect == 2 //Parcial
        Processa({|| CursorWait(),ITMKPARCIAL(),CursorArrow()},"Filtrando itens da cotação, aguarde...")
        If _cPedCot == "COT"
            _oDlgCot:End()
            _lSair := .f.
            //MsAguarde({|| IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")}, "Atualizando consulta...")
        Else
            MsAguarde({|| IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")}, "Atualizando consulta...")        
        EndIf±
    EndIf
EndIf
SetFunName("ITMKCAL")

Return

/*
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKPARCIAL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Transformação parcial                                                                   |
+------------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                   |
+------------+-----------------------------------------------------------------------------------------+
*/

Static Function ITMKPARCIAL()
Local _aItens := {}, _lRet := .f., _nPosItem := 0, _aArea := SUA->(GetArea()), _aItDel := {}, _nQtItem := _nQSel := 0, _aCpoEnch := {}
Local _aSUB   := {}, _cChaveSUA := SUA->UA_FILIAL + SUA->UA_NUM, _nQDisp := _nQtdPed := 0, _aBkp := {}, _oException
Private _lITMKCAL := .t., _lNoSaldo := .f., _aSZN := {}

//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"
/*
DbSelectArea("SUB")
DbOrderNickName("SUBNUM")
DbGoTop()
MsSeek(xFilial("SUB")+SUA->UA__FILIAL+SUA->UA_NUM) 

While !Eof() .And. (SUB->UB_FILIAL + SUB->UB__FILIAL + SUB->UB_NUM) == (xFilial("SUB")+SUA->UA__FILIAL+SUA->UA_NUM)
*/
DbSelectArea("SUB")
DbSetOrder(1)
DbGoTop()
MsSeek(SUA->UA_FILIAL + SUA->UA_NUM) 

While !Eof() .And. (SUB->UB_FILIAL + SUB->UB_NUM) == (SUA->UA_FILIAL + SUA->UA_NUM)

    aAdd( _aItens, { .T.,;
                    SUB->UB_ITEM,;
                    SUB->UB_PRODUTO,;
                    Posicione( "SB1", 1, xFilial( "SB1" ) + SUB->UB_PRODUTO, "B1_DESC" ),;
                    SUB->UB_QUANT,;
                    SUB->UB_UM,;
                    SUB->UB_PRCTAB,;    
                    SUB->UB__PRCDIG,;
                    SUB->UB__DESC2,;
                    SUB->UB__DESC3,;
                    SUB->UB__DESCCP,;
                    SUB->UB__DESCP,;
                    SUB->UB_VRUNIT,;
                    SUB->UB_VLRITEM,;
                    SUB->(Recno()) } )
                    
    _nQtItem += 1                
    
    DbSelectArea("SUB")
    DbSkip()

EndDo

If Empty(_aItens)
    MsgStop("Nao foram encontrados itens para este pedido","PROBLEMA")
    Return
EndIf

_lRet := ISelItens( @_aItens )

If _lRet

    For ny := 1 To Len(_aItens)
        If _aItens[ny][1]
            _nQSel += 1
        EndIf
    Next ny
    
    If _nQSel == _nQtItem
        
        Inclui := .f.
        Altera := .t.
        TryException
            DbSelectArea("SUA")
            If Reclock("SUA",.f.)
                _aBkp := {SUA->UA_OPER,SUA->UA__TIPPED,SUA->UA__RESEST,SUA->UA__DSCTIP,SUA->UA__SITFIN,SUA->UA__SITCOM,SUA->UA__DTAPFI,SUA->UA__DTAPCO,SUA->UA__USAPCO,SUA->UA__USAPFI}
                SUA->UA_OPER        := "1"
                SUA->UA__TIPPED     := "1"
                SUA->UA__RESEST     := "S"
                SUA->UA__DSCTIP     := Posicione("SZF",1,xFilial("SZF") + SUA->UA__TIPPED,"ZF_DESC")
                SUA->UA__SITFIN     := " "
                SUA->UA__SITCOM     := " "
                SUA->UA__DTAPFI     := CTOD("  /  /  ")
                SUA->UA__DTAPCO     := CTOD("  /  /  ")
                SUA->UA__USAPCO     := " "
                SUA->UA__USAPFI     := " "
                MsUnlock()
            EndIf
            
            //Limpa informações de Aprovação, caso existam
            DbSelectArea("Z05")
            DbSetOrder(1)
            If MsSeek(SUA->UA_FILIAL + SUA->UA_NUM)
                U_ITMKDZ05(SUA->UA_FILIAL,SUA->UA_NUM)
            EndIf                  
            
            SetFunName("TMKA271")                        
            TK271CallCenter("SUA",SUA->(RecNo()) ,4)
            SetFunName("ITMKCAL")
        	CatchException Using _oException
        
            If Len(_aBkp) > 0
                If Reclock("SUA",.f.)                    
                    SUA->UA_OPER        := _aBkp[1]
                    SUA->UA__TIPPED     := _aBkp[2]
                    SUA->UA__RESEST     := _aBkp[3]
                    SUA->UA__DSCTIP     := _aBkp[4]
                    SUA->UA__SITFIN     := _aBkp[5]
                    SUA->UA__SITCOM     := _aBkp[6]
                    SUA->UA__DTAPFI     := _aBkp[7]
                    SUA->UA__DTAPCO     := _aBkp[8]
                    SUA->UA__USAPCO     := _aBkp[9]
                    SUA->UA__USAPFI     := _aBkp[10]
                    MsUnlock()
                EndIf
            EndIf
            ErrorDlg(_oException)
            Eval(ErrorBlock(),_oException)        
        EndException
    Else     
        // Zera Variaveis
        aCabec   := {}
        aItens   := {}
        aLinha   := {}
        nOperPed := 0
        _aSUB    := {}
        _cItSUB := StrZero( Val("0"), TamSX3("UB_ITEM")[1] )

        For ny := 1 To Len(_aItens)
            If _aItens[ny][1] //Efetiva os itens marcados

                If Empty(aCabec)
                   nOperPed := 3
                   cCodAte  := U_ITMKNSUA()//TkNumero("SUA","UA_NUM")
                   RestArea(_aArea)                    
                   
                   DbSelectArea("SA4")
                   DbSetOrder(1)
                   MsSeek(xFilial("SA4") + SUA->UA_TRANSP)
                   
                    // Alimenta cabeçalho
                    aAdd( aCabec, { "UA_NUM"        , cCodAte                                , Nil } )
                    aAdd( aCabec, { "UA_CLIENTE"    , SUA->UA_CLIENTE                        , Nil } )
                    aAdd( aCabec, { "UA_LOJA"       , SUA->UA_LOJA                           , Nil } ) 
                    aAdd( aCabec, { "UA__TIPPED"    , "1"                                    , Nil } )
                    aAdd( aCabec, { "UA__FILIAL"    , SUA->UA__FILIAL                        , Nil } )
                    aAdd( aCabec, { "UA__SEGISP"    , SUA->UA__SEGISP                        , Nil } ) 
                    aAdd( aCabec, { "UA_OPERADO"    , M->PA3_OPER                            , Nil } )
                    aAdd( aCabec, { "UA_CONDPG"     , SUA->UA_CONDPG                         , Nil } )
                    aAdd( aCabec, { "UA_TABELA"     , SUA->UA_TABELA                         , Nil } )
                    aAdd( aCabec, { "UA__TABPRC"    , SUA->UA__TABPRC                        , Nil } )
                    aAdd( aCabec, { "UA__UFTAB"     , SUA->UA__UFTAB                         , Nil } )
                    aAdd( aCabec, { "UA__PRVFAT"    , Date()                                 , Nil } )                                         
                    aAdd( aCabec, { "UA_OPER"		, "1"   								 , Nil } )
                    aAdd( aCabec, { "UA_VEND"       , SUA->UA_VEND                           , Nil } )
                    aAdd( aCabec, { "UA_TMK"        , M->PA3_TPOPER                          , Nil } )
                    aAdd( aCabec, { "UA_EMISSAO"    , Date()                                 , Nil } )
                    aAdd( aCabec, { "UA_FRETE"      , SUA->UA_FRETE                          , Nil } )
                    aAdd( aCabec, { "UA__STATUS"    , "1"                                    , Nil } )
                    aAdd( aCabec, { "UA_TRANSP"     , SUA->UA_TRANSP                         , Nil } )
                    aAdd( aCabec, { "UA_TPFRETE"    , SUA->UA_TPFRETE                        , Nil } )
                    aAdd( aCabec, { "UA__DESCAP"    , SUA->UA__DESCAP                        , Nil } )
                    aAdd( aCabec, { "UA__LJAENT"    , SUA->UA__LJAENT                        , Nil } )
                    aAdd( aCabec, { "UA__LJACOB"    , SUA->UA__LJACOB                        , Nil } )
                    aAdd( aCabec, { "UA__TPORI"     , SUA->UA__TIPPED                        , Nil } )  
                    aAdd( aCabec, { "UA__TPOPE"     , M->PA3_TPOPER                          , Nil } )                    
                    aAdd( aCabec, { "UA__REDESP"    , SUA->UA__REDESP                        , Nil } )
                    aAdd( aCabec, { "UA__RESEST"    , "S"                                    , Nil } )
                    aAdd( aCabec, { "UA__OBSCOM"	, SUA->UA__OBSCOM			 			 , Nil } )
                    aAdd( aCabec, { "UA__OBSFIN"	, SUA->UA__OBSFIN			 			 , Nil } )
//                    aAdd( aCabec, { "UA__OBSPED"	, SUA->UA__OBSPED			 			 , Nil } )

                EndIf
                
                _cItSUB := Soma1(_cItSUB,TamSX3("UB_ITEM")[1])
                
                DbSelectArea("SUB")
                DbGoTo(_aItens[ny][Len(_aItens[ny])])
                AADD(_aItDel,SUB->(Recno()))
                
                _nQDisp  := U_xSldProd(cFilAnt,SUB->UB_PRODUTO,SUB->UB_LOCAL)
                _nQtdPed := 0
    
                If _nQDisp > 0
                    _nQtdPed := IIF(_nQDisp > SUB->UB_QUANT,SUB->UB_QUANT,_nQDisp)
                EndIf

                If _nQDisp > 0
                    aLinha := {}
                    aadd( aLinha, { "UB_ITEM"       , _cItSUB                               , Nil } )
                    aAdd( aLinha, { "UB__PEDMEX"    , SUB->UB__PEDMEX                       , Nil } )
                    aAdd( aLinha, { "UB__ITEMEX"    , SUB->UB__ITEMEX                       , Nil } )
                    aAdd( aLinha, { "UB__CODKIT"    , SUB->UB__CODKIT                       , Nil } )
                    aAdd( aLinha, { "UB__CODACE"    , SUB->UB__CODACE                       , Nil } )
                    aAdd( aLinha, { "UB__DESCP"     , SUB->UB__DESCP                        , Nil } )
                    aAdd( aLinha, { "UB__DESCCP"    , SUB->UB__DESCCP                       , Nil } )
                    aAdd( aLinha, { "UB_PRCTAB"     , SUB->UB_PRCTAB                        , Nil } ) 
                    aAdd( aLinha, { "UB_PRODUTO"    , SUB->UB_PRODUTO                       , Nil } )
                    aAdd( aLinha, { "UB_QUANT"      , _nQtdPed                              , Nil } )                    
                    aAdd( aLinha, { "UB__QTDSOL"    , SUB->UB_QUANT                         , Nil } )
                    aAdd( aLinha, { "UB_VRUNIT"     , SUB->UB_VRUNIT                        , Nil } )
                    aAdd( aLinha, { "UB_VLRITEM"    , SUB->UB_VRUNIT * _nQtdPed             , Nil } )                    
                    aAdd( aLinha, { "UB__PRCDIG"    , SUB->UB__PRCDIG                       , Nil } ) 
                    aAdd( aLinha, { "UB__DESC2"     , SUB->UB__DESC2                        , Nil } )  
                    aAdd( aLinha, { "UB__DESC3"     , SUB->UB__DESC3                        , Nil } )
                    aAdd( aLinha, { "UB_TES"        , SUB->UB_TES                           , Nil } )
                    aAdd( aLinha, { "UB_LOCAL"      , SUB->UB_LOCAL                         , Nil } )
                    aAdd( aLinha, { "UB__CODUSR"    , __cUserId                             , Nil } )
                    aAdd( aLinha, { "UB__ITORI"     , SUB->UB_ITEM                          , Nil } )
                    aAdd( aLinha, { "UB__TPOPE"     , M->PA3_OPER                           , Nil } )
                    aAdd( aLinha, { "UB__FILIAL"    , SUA->UA__FILIAL                       , Nil } )
                    
                    aAdd( _aSUB, aLinha )
                Else
                    AADD(_aSZN,SUB->(Recno()))
                EndIf
            EndIf
        Next
        
        If Len(_aSUB) > 0
            lMsErroAuto := .F.
            aAdd( aCabec, { "UA_OPER", "1"                , Nil } )
            Processa({|| CursorWait(),TMKA271(aCabec, _aSUB, nOperPed, "2"),CursorArrow()},"Gerando pedido, aguarde...")
        
            // No caso de erro, flag registro e envia o erro por e-mail ou mostra na tela se não for JOB, caso contrario flag integracao OK
            If lMsErroAuto            
                MostraErro()
            Else
                For nx := 1 To Len(_aSZN)
                    _cItSUB := Soma1(_cItSUB,TamSX3("UB_ITEM")[1])
    
                    DbSelectArea("SUB")
                    DbGoTo(_aSZN[nx])
                    
                    DbSelectArea("SZN")
                    While !RecLock("SZN",.T.)
                    EndDo       
                    SZN->ZN_FILIAL  := xFilial("SZN")
                    SZN->ZN_NUM     := cCodAte
                    SZN->ZN_ITEM    := _cItSUB
                    SZN->ZN_DTCAN   := date()
                    SZN->ZN_MOTIVO  := "00001"
                    SZN->ZN_QUANT   := SUB->UB_QUANT
                    SZN->ZN_PRODUTO := SUB->UB_PRODUTO
                    SZN->ZN_HRCAN   := substr(time(),1,5)
                    SZN->ZN_UM      := SUB->UB_UM
                    SZN->ZN_VLRUNIT := SUB->UB_VLRITEM
                    SZN->ZN_PRCLIST := SUB->UB_PRCTAB
                    SZN->ZN_DESC1   := SUB->UB__DESC2
                    SZN->ZN_DESC2   := SUB->UB__DESC3
                    SZN->ZN_TPOPE   := SUB->UB__TPOPE
                    SZN->(MsUnlock())            
                Next nx
                            
                //Deleta os itens efetivados
                _cMSGDel := ""
                For _nx := 1 To Len(_aItDel)
                    DbSelectArea("SUB")
                    DbGoTo(_aItDel[_nx])
                    If Reclock("SUB",.f.)
                        DbDelete()
                        MsUnlock()
                    Else
                        _cMSGDel += IIF(Empty(_cMSGDel),SUB->UB_ITEM,", " + SUB->UB_ITEM)                   
                    EndIf
                Next _nx
                
                //Se excluir todos os itens, deleta o cabeçalho
                If Empty(_cMSGDel)
                    DbSelectArea("SUB")
                    DbSetOrder(1)
                    If !MsSeek(_cChaveSUA)
                        DbSelectArea("SUA")
                        DbSetOrder(1)
                        If MsSeek(_cChaveSUA)
                            If Reclock("SUA",.f.)
                                DbDelete()
                                MsUnlock()
                            Else
                                MsgAlert("Falha ao cancelar a cotação selecionada, esta operação deverá ser realizada manualmente.")
                            EndIf
                        EndIf
                    EndIf
                Else
                    MsgAlert("Problema ao excluir os itens " + _cMSGDel + " do pedido/cotacao selecionado. Esta operação deverá ser realizada manualmente","ATENCAO")
                EndIf
                
                Inclui := .f.
                Altera := .t.            
                DbSelectArea("SUA")
                DbSetOrder(1)
                MsSeek(xFilial("SUA") + cCodAte)
                
                SetFunName("TMKA271")
                TK271CallCenter("SUA",SUA->(RecNo()) ,4)             
                SetFunName("ITMKCAL")
            Endif        
        
        Else
                        
            DbSelectArea("SX3")
            DbSetOrder(1)
            MsSeek("SUA")
            
            While !Eof() .And. SX3->X3_ARQUIVO == "SUA"
                If X3Uso(SX3->X3_USADO)
                    AADD(_aCpoEnch,SX3->X3_CAMPO)
                EndIf
                DbSkip()  
            EndDo
            
            ITMKRETK()
            SetFunName("TMKA271")
            cFilAnt := M->PA3_FILATE
            MsgInfo("Todos os itens selecionados estão com saldo Zerado. Serão lançados em venda perdida")
            _lNoSaldo := .t.
            //_lGerSUA := TK271CallCenter("SUA",0 ,3 ,_aCpoEnch,M->PA3_CODCLI,M->PA3_LOJA ,_oGetPA3:aCols[_oGetPA3:nat][1],"SA1",nil ,""   ,.F.)
            
            ConfirmSX8()
            DbSelectArea("SUA")
            While !Reclock("SUA",.t.)
            EndDo
            SUA->UA_FILIAL  := SUA->UA__FILIAL
            SUA->UA__RESEST := "N"
            SUA->UA__DSCTIP := Posicione("SZF",1,xFilial("SZF") + SUA->UA__TIPPED,"ZF_DESC")
            SUA->UA__DESCCP := Posicione("SE4",1,xFilial("SE4") + SUA->UA_CONDPG,"E4_DESCRI")
            SUA->UA__PRIORI := "0"
            SUA->UA_OPER    := "3"
            SUA->UA_TIPOCLI := M->PA3_TPCLI
            For nx := 1 To Len(aCabec)
                &("SUA->" + aCabec[nx][1]) := aCabec[nx][2]
            Next nx 
            _lGerSUA := .t. 
            SUA->(MsUnlock())
            
            For nx := 1 To Len(_aSZN)
                cItem := StrZero(nx,TamSX3("UB_ITEM")[1],0)

                DbSelectArea("SUB")
                DbGoTo(_aSZN[nx])
                
                DbSelectArea("SZN")
                While !RecLock("SZN",.T.)
                EndDo       
                SZN->ZN_FILIAL := SUB->UB_FILIAL
                SZN->ZN_NUM    := cCodAte
                SZN->ZN_ITEM   := cItem
                SZN->ZN_DTCAN  := date()
                SZN->ZN_MOTIVO := "00001"
                SZN->ZN_QUANT  := SUB->UB_QUANT
                SZN->ZN_PRODUTO:= SUB->UB_PRODUTO
                SZN->ZN_HRCAN  := substr(time(),1,5)
                SZN->ZN_UM      := SUB->UB_UM
                SZN->ZN_VLRUNIT := SUB->UB_VLRITEM
                SZN->ZN_PRCLIST := SUB->UB_PRCTAB
                SZN->ZN_DESC1   := SUB->UB__DESC2
                SZN->ZN_DESC2   := SUB->UB__DESC3
                SZN->ZN_TPOPE   := SUB->UB__TPOPE
                SZN->(MsUnlock())            
            Next nx

            If _lGerSUA
            
                Inclui := .f.
                Altera := .t.            
                DbSelectArea("SUA")
                DbSetOrder(1)
                MsSeek(xFilial("SUA") + cCodAte)
                
                SetFunName("TMKA271")
                TK271CallCenter("SUA",SUA->(RecNo()) ,4)   

                //Deleta os itens efetivados
                _cMSGDel := ""
                For _nx := 1 To Len(_aItDel)
                    DbSelectArea("SUB")
                    DbGoTo(_aItDel[_nx])
                    If Reclock("SUB",.f.)
                        DbDelete()
                        MsUnlock()
                    Else
                        _cMSGDel += IIF(Empty(_cMSGDel),SUB->UB_ITEM,", " + SUB->UB_ITEM)                   
                    EndIf
                Next _nx
                
                //Se excluir todos os itens, deleta o cabeçalho
                If Empty(_cMSGDel)
                    DbSelectArea("SUB")
                    DbSetOrder(1)
                    If !MsSeek(_cChaveSUA)
                        DbSelectArea("SUA")
                        DbSetOrder(1)
                        If MsSeek(_cChaveSUA)
                            If Reclock("SUA",.f.)
                                DbDelete()
                                MsUnlock()
                            Else
                                MsgAlert("Falha ao cancelar a cotação selecionada, esta operação deverá ser realizada manualmente.")
                            EndIf
                        EndIf
                    EndIf
                Else
                    MsgAlert("Problema ao excluir os itens " + _cMSGDel + " do pedido/cotacao selecionado. Esta operação deverá ser realizada manualmente","ATENCAO")
                EndIf                
                SetFunName("ITMKCAL")
            EndIf

            ITMKSETK()
            cFilAnt := SM0->M0_CODFIL
            SetFunName("ITMKCAL")
        
        EndIf
    EndIf
EndIf

Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKTOTAL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Transformação Total                                                                   |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

Static Function ITMKTOTAL()
Local _aItens := {}, _lRet := .f., _nPosItem := 0, _aArea := SUA->(GetArea())
Local _oException, _aBkp := {}

Private _lITMKCAL := .t.

// Zera Variaveis
aCabec   := {}
aItens   := {}
aLinha   := {}
nOperPed := 4
_aSUB    := {}

//A declaracao do arotina é obrigatorio para o funcionamento da TK271CallCenter
aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"

Inclui := .f.
Altera := .t.
    
TryException 
    If Reclock("SUA",.f.)
        _aBkp := {SUA->UA_OPER,SUA->UA__TIPPED,SUA->UA__RESEST,SUA->UA__DSCTIP}
        SUA->UA_OPER        := "1"
        SUA->UA__TIPPED     := "1"
        SUA->UA__RESEST     := "S"
        SUA->UA__DSCTIP     := Posicione("SZF",1,xFilial("SZF") + SUA->UA__TIPPED,"ZF_DESC")
        SUA->UA__SITFIN     := " "
        SUA->UA__SITCOM     := " "
        SUA->UA__DTAPFI     := CTOD("  /  /  ")
        SUA->UA__DTAPCO     := CTOD("  /  /  ")
        SUA->UA__USAPCO     := " "
        SUA->UA__USAPFI     := " "
        MsUnlock()
    EndIf
    
    SetFunName("TMKA271")
    TK271CallCenter("SUA",SUA->(RecNo()) ,4)
    SetFunName("ITMKCAL")
CatchException Using _oException
    If Reclock("SUA",.f.)
        SUA->UA_OPER        := _aBkp[1]
        SUA->UA__TIPPED     := _aBkp[2]
        SUA->UA__RESEST     := _aBkp[3]
        SUA->UA__DSCTIP     := _aBkp[4]
        MsUnlock()
    EndIf

    ErrorDlg(_oException)
    Eval(ErrorBlock(),_oException)
EndException

Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ISelItens | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Tela para seleção dos itens, na transformação parcial                                 |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

Static Function ISelItens(_aItens)

Local cTitulo   := "Geracao de pedido"
Local aCoors    := FWGetDialogSize( oMainWnd )

Local _oDlg
Local oPanelLst
Local oListRegs
Local oOk       := LoadBitmap(GetResources(), "LBOK")
Local oNo       := LoadBitmap(GetResources(), "LBNO")

Local lRetFun := .F.

Local aButtons := {}

// Montagem da Tela
DEFINE MSDIALOG _oDlg TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL

// Criação da Layer
oLayer := FWLayer():New()
oLayer:Init( _oDlg, .F. )

// Linha com os registros
oLayer:AddLine( 'LineLst', 100, .F. )

// Coluna e Janela dos registros
oLayer:AddColumn( 'ColLst' , 100, .T., 'LineLst' )
oLayer:AddWindow( 'ColLst', 'WinLst', 'Marque os itens desejados', 100, .F., .F., , 'LineLst' )

// Montagem do listbox dos Registros
oPanelLst := oLayer:GetWinPanel('ColLst','WinLst','LineLst')

@ 01,01 LISTBOX oListRegs FIELDS HEADER "",;
                                    "Item",;
                                    "Produto",;
                                    "Descricao",;
                                    "Qtd Solicit.",;
                                    "Un.Med.",;
                                    "Preco Lista",;
                                    "Prc Digit.",;
                                    "Desconto 1",;
                                    "Desconto 2",;
                                    "Desconto Capa",;
                                    "Desconto Promo",;
                                    "Valor Unit",;
                                    "Valor Total",;
                                    "RECNO",;
                                    SIZE oPanelLst:nRight / 2.02, oPanelLst:nBottom / 2.25;
                                    OF oPanelLst PIXEL

oListRegs:SetArray( _aItens )

oListRegs:bLine := { || { If( _aItens[oListRegs:nAt,01], oOk, oNo ),;
                              _aItens[oListRegs:nAt,02],;
                              _aItens[oListRegs:nAt,03],;
                              _aItens[oListRegs:nAt,04],;
                              Transform(_aItens[oListRegs:nAt,05],PesqPict( "SUB", "UB_QUANT" )),;
                              _aItens[oListRegs:nAt,06],;
                              Transform(_aItens[oListRegs:nAt,07],PesqPict( "SUB", "UB_PRCTAB" )),;
                              Transform(_aItens[oListRegs:nAt,08],PesqPict( "SUB", "UB__PRCDIG" )),;
                              Transform(_aItens[oListRegs:nAt,09],PesqPict( "SUB", "UB__DESC2" )),;
                              Transform(_aItens[oListRegs:nAt,10],PesqPict( "SUB", "UB__DESC3" )),;
                              Transform(_aItens[oListRegs:nAt,11],PesqPict( "SUB", "UB__DESCCP" )),;
                              Transform(_aItens[oListRegs:nAt,12],PesqPict( "SUB", "UB__DESCP" )),;
                              Transform(_aItens[oListRegs:nAt,13],PesqPict( "SUB", "UB_VRUNIT" )),;
                              Transform(_aItens[oListRegs:nAt,14],PesqPict( "SUB", "UB_VLRITEM" )),;
                              Transform(_aItens[oListRegs:nAt,15],"@E 999999999999")} }

oListRegs:bLdbLClick := { || (;  //aEval( _aItens, { |x| x[1] := .F. } ),;
                                _aItens[oListRegs:nAt,1] := If( !Empty( _aItens[oListRegs:nAt,2]), !_aItens[oListRegs:nAt,1], _aItens[oListRegs:nAt,1]),;
                                oListRegs:Refresh() ) }

                          
ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg, { || lRetFun := .T., _oDlg:End() }, { || _oDlg:End() }, , aButtons )

Return lRetFun

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | IRecallPed | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Reabertura de pedido                                                                   |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function IRecallPed(_cFil,_cPedido,_cSynZUA)
Local _cFilAtu := cFilAnt
Private Altera := .t., Inclui := .f., _lGrOn := .f.

cFilAnt := _cFil

//Verifica se o pedido deve ou não ser reaberto (recuperado) a partir da gravação online
If Empty(_cSynZUA)
    DbSelectArea("SUA")
    DbSetOrder(1)
    MsSeek(_cFil + _cPedido)
    If Alltrim(SUA->UA__STATUS) == '1'
    
        SetFunName("TMKA271")
        TK271CallCenter("SUA",SUA->(RecNo()) ,4)
        SetFunName("ITMKCAL")
    Else
        U_ITMKA08(SUA->UA_NUM)
    EndIf
Else
    //Alimenta o cabeçalho e executa a rotina de alteração.
    //Os itens serão gerados no ponto de entrada TMKACTIVE, quando a variável _lGrOn for igual a .T.
    If U_ITMKRECON("SUA",_cFil,_cPedido,.t.)
        _lGrOn := .t.
        DbSelectArea("SUA")
        DbSetOrder(1)
        MsSeek(_cFil + _cPedido)
        If Alltrim(SUA->UA__STATUS) == '1'
            
            SetFunName("TMKA271")
            TK271CallCenter("SUA",SUA->(RecNo()) ,4)
            SetFunName("ITMKCAL")
        Else
            U_ITMKA08(SUA->UA_NUM)
        EndIf
    EndIf
    
EndIf

cFilAnt := _cFilAtu

Return

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKPOSCLI | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Posição de cliente                                                                     |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

User Function ITMKPOSCLI(_cCli,_cLoja)
Local _aArea := GetArea(), _aParam := {}, _aRotina := {}
Private cCadastro := "Posicao Cliente" 

If Type("aRotina") == "A"
    _aRotina := aClone(aRotina)
Else
    Private aRotina :=  { {"Pesquisar"  , "AxPesqui" , 0 , 1},; 
                             {"Visualizar", "AxVisual" , 0 , 2},; 
                             {"Consultar" , "FC010CON" , 0 , 2},; 
                             {"Impressao" , "FC010IMP" , 0 , 4}}                             
EndIf

If !Empty(_cCli) .And. !Empty(_cLoja) 

    DbSelectArea("SA1")
    DbSetOrder(1)
    If MsSeek(xFilial("SA1") + _cCli + _cLoja)
//        Fc010Con("SA1",SA1->(Recno()),2)
            U_IFINC01A(SA1->(Recno()))
        Return
    EndIf

EndIf

If Len(_aRotina) > 0
    aRotina := aClone(_aRotina)
EndIf

RestArea(_aArea)
Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVLSEG | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida o segmento                                                                     |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ITMKVLSEG(_cCli,_cLoja)
Default _cCli := "", _cLoja := ""

DbSelectArea("SA1")
DbSetOrder(1)
If MsSeek(xFilial("SA1") + _cCli + IIF(!Empty(_cLoja),_cLoja,""))
    If Val(SA1->A1__SEGISP) > 0 .And. Val(SA1->A1__SEGISP) <> Val(U_SETSEGTO()) .And. Val(U_SETSEGTO()) > 0
        MsgAlert("Este cliente nao pertence ao seu segmento","CLIENTE INVALIDO")
        Return .f.
    EndIf
ElseIf Empty(_cLoja) .And. !Found()
    MsgStop("Cliente não localizado","Atencao")
    Return .f.
EndIf

Return .t.

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVLDATF | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida data de faturamento x Date                                                      |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

User Function ITMKVLDATF()

If M->UA__PRVFAT < Date()
    Help( Nil, Nil, "DATFAT", Nil, "A data de faturamento deve ser maior ou igual a " + DTOC(Date()), 1, 0 )
    Return .f.
EndIf

Return .t.  

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVLFIL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida a Filial                                                                       |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ITMKVLFIL(_cFilCod)
Local _lRet := .t., _aFil := {}

_aFil := FWArrFilAtu(,_cFilCod)

If Empty(_aFil)
    MsgStop("Filial incorreta, favor verificar.","ATENCAO")
    _lRet := .f.
EndIf

//Valida a filial 
If _lRet .And. "_FILATE" $ ReadVar()
    If M->PA3_FILATE != M->PA3_FILANT
        If !MsgYesNo("Confirma a troca de filial?","ATENCAO")
            _lRet := .f.
        Else
            cFilAnt := M->PA3_FILATE
        EndIf
    EndIf
EndIf

Return _lRet

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVLRES | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida a Reserva                                                                      |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ITMKVLRES()
Local _lRet := (M->UA__PRVFAT-M->UA_EMISSAO) > Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3__MAXRES")       

Return _lRet

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVDFAT | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida data de faturamento x Data de emissao                                          |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ITMKVDFAT()
Local _lRet := .t.

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    Return _lRet
EndIf  

If M->UA__PRVFAT < M->UA_EMISSAO
    Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista de faturamento nao pode ser menor que a data de emissao", 1, 0 )
    _lRet := .f.  
ElseIf M->UA__PRVFAT >= M->UA_EMISSAO .And. Val(M->UA__TIPPED) == 2
    If  M->UA__PRVFAT == M->UA_EMISSAO
        Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista não pode ser igual a data de emissão, para pedidos programados.", 1, 0 )
        _lRet := .f.
    ElseIf M->UA__RESEST == "S"
        If M->UA__PRVFAT > (M->UA_EMISSAO + Posicione("SA3",1,xFilial("SA3") + M->UA_VEND,"A3__MAXRES"))     
            Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista não pode ser maior que o limite informado no cadastro do vendedor, para pedidos com reserva de estoque", 1, 0 )
            _lRet := .f.
        ElseIf M->UA__PRVFAT <= M->UA_EMISSAO
            Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista deve ser superior a data de emissão.", 1, 0 )
            _lRet := .f.
        EndIf
    Else
        If M->UA__PRVFAT > (M->UA_EMISSAO + Posicione("SA3",1,xFilial("SA3") + M->UA_VEND,"A3__MAXRES") + SA3->A3__SEMRES)     
            Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista não pode ser maior que o limite informado no cadastro do vendedor, para pedidos sem reserva de estoque", 1, 0 )
            _lRet := .f.
        //ElseIf M->UA__PRVFAT < (M->UA_EMISSAO + Posicione("SA3",1,xFilial("SA3") + M->UA_VEND,"A3__MAXRES") + 1)
        //    Help( Nil, Nil, "DATPRVFAT", Nil, "Data prevista não pode ser menor que o limite informado no cadastro do vendedor, para pedidos sem reserva de estoque", 1, 0 )
        //    _lRet := .f.
        EndIf
    EndIf
EndIf

Return _lRet

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKMOTIVO | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Motivo de visita ao atendimento                                                        |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKMOTIVO()
    If !Empty(M->PA3_CODCLI)
        DbSelectArea("SA1")
        DbSetOrder(1)
        MsSeek(xFilial("SA1") + M->PA3_CODCLI + IIF(!Empty(M->PA3_LOJA),M->PA3_LOJA,""))
        U_IGENM17()
    EndIf
Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKVLTRP | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Seleção da transportadora no pedido                                                   |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function ITMKVLTRP(_cRed)
Local _oConfirma, _oFrtConv, _nFrtConv := 2, _oNmRedesp, _oNmTransp
Local _oRedesp, _cRedesp := M->UA__REDESP, _lRet := .f.
Local _cNmTransp := Posicione("SA4",1,xFilial("SA4") + M->UA_TRANSP,"A4_NOME")
Local _cNmRedesp := Posicione("SA4",1,xFilial("SA4") + M->UA__REDESP,"A4_NOME")
Local _oSay1, _oSay2, _oSay3, _oSay4, _oSay5, _oSay6, _oTipo, _oCodTrp, _cTransp := M->UA_TRANSP
Local _oValFrete, _nValFrete := aValores[FRETE], _oValPedido, _oVolta, _oTransp, _nValPedido := aValores[MERCADORIA] //aValores[TOTAL]
Local _aTp := {"C=CIF","F=FOB","3=CONVENIO"}, _cRetTrp := _cRetRed := ""
Local _nTipo := IIF(M->UA__FTCONV == "1","3",M->UA_TPFRETE), _nValImp := _nt := 0

If Type("aObj[8]") == "O"
     If Type("aObj[8]:aArray") == "A" 
        For _nt := 1 To Len(aObj[8]:aArray)
            If Alltrim(aObj[8]:aArray[_nt][1]) == "IPI"
                _nValImp += aObj[8]:aArray[_nt][5]
            ElseIf Alltrim(aObj[8]:aArray[_nt][1]) == "ICR"
                _nValImp += aObj[8]:aArray[_nt][5]
            EndIf           
        Next
     EndIf
EndIf

_nValPedido += _nValImp + _nValFrete

DEFINE MSDIALOG _oTransp TITLE "Dados Transportadora" FROM 000, 000  TO 250, 600 PIXEL

    @ 012, 005 SAY _oSay1 PROMPT "Tipo Frete"                 SIZE 029, 007 OF _oTransp PIXEL
    @ 011, 049 MSCOMBOBOX _oTipo VAR _nTipo ITEMS _aTp        SIZE 072, 010 OF _oTransp PIXEL //VALID IVLDFRTCONV(@_nFrtConv,_nTipo,@_nValFrete,@_nValPedido,@_oTipo)
    @ 031, 005 SAY _oSay2 PROMPT "Transportadora"             SIZE 040, 007 OF _oTransp PIXEL
    @ 030, 049 MSGET _oCodTrp VAR _cTransp                    SIZE 039, 010 OF _oTransp PIXEL READONLY
    @ 030, 090 BUTTON oButton3 PROMPT "Buscar"                SIZE 022, 012 OF _oTransp PIXEL ACTION Eval(bCodTrp)
    @ 030, 120 MSGET _oNmTransp VAR _cNmTransp                SIZE 160, 010 OF _oTransp PIXEL READONLY
    @ 050, 005 SAY _oSay3 PROMPT "Redespacho"                 SIZE 036, 007 OF _oTransp PIXEL
    @ 049, 049 MSGET _oRedesp VAR _cRedesp                    SIZE 039, 010 OF _oTransp PIXEL READONLY
    @ 049, 090 BUTTON oButton4 PROMPT "Buscar"                SIZE 022, 012 OF _oTransp PIXEL ACTION Eval(bCodRed)  
    @ 049, 120 MSGET _oNmRedesp VAR _cNmRedesp                SIZE 160, 010 OF _oTransp PIXEL READONLY

    @ 077, 030 SAY _oSay5 PROMPT "Valor Frete"                SIZE 030, 007 OF _oTransp PIXEL 
    @ 076, 070 MSGET _oValFrete VAR _nValFrete                SIZE 060, 010 OF _oTransp PIXEL READONLY PICTURE PesqPict("SUA","UA_FRETE")
//  @ 077, 160 SAY _oSay6 PROMPT "Valor Pedido"               SIZE 030, 007 OF _oTransp PIXEL
//  @ 076, 200 MSGET _oValPedido VAR _nValPedido              SIZE 060, 010 OF _oTransp PIXEL READONLY PICTURE PesqPict("SUA","UA_VALBRUT")
    @ 077, 150 SAY _oSay6 PROMPT "Valor Pedido"               SIZE 050, 007 OF _oTransp PIXEL
    @ 076, 200 MSGET _oValPedido VAR _nValPedido              SIZE 060, 010 OF _oTransp PIXEL READONLY PICTURE PesqPict("SUA","UA_VALBRUT")
    
    @ 106, 080 BUTTON _oConfirma PROMPT "Confirmar"           SIZE 037, 012 OF _oTransp PIXEL Action {|| IVLDGRV(@_oTransp,@_lRet,_cTransp)}
    @ 106, 200 BUTTON _oVolta    PROMPT "Voltar"              SIZE 037, 012 OF _oTransp PIXEL Action {|| _lRet := .f.,_oTransp:End()}
    bCodTrp := {|| _cRetTrp := U_IGENM10(_nTipo,.t.,.f.,_cTransp),IIF(!Empty(_cRetTrp),_cTransp := _cRetTrp,""),;
               IIF(!Empty(_cRetTrp),_cNmTransp := Posicione("SA4",1,xFilial("SA4") + _cTransp,"A4_NOME"),""),;
               IIF(!Empty(_cRetTrp) .And. _nTipo != "3",_nValFrete := 0,""),;
               IIF(!Empty(_cRetTrp) .And. _nTipo != "3",_nValPedido := aValores[MERCADORIA] + _nValImp,""),;
               IIF(!Empty(_cRetTrp) .And. _nTipo == "3",IVALCFRT(_cTransp,@_nValFrete,@_nValPedido,_nValImp),""),;
               _cRedesp := Posicione("SZI",3,xFilial("SZI") + M->UA_VEND + "R" + _cTransp,"ZI_REDESP"),;
               _cNmRedesp := Posicione("SA4",1,xFilial("SA4") + _cRedesp,"A4_NOME")}
    bCodRed := {|| IIF(_nTipo == "C",_cRetRed := U_IGENM10(_nTipo,.t.,.t.,_cTransp),""),IIF(!Empty(_cRetRed),_cRedesp := _cRetRed,""),;
               IIF(!Empty(_cRetRed),_cNmRedesp := Posicione("SA4",1,xFilial("SA4") + _cRedesp,"A4_NOME"),"")}        
ACTIVATE MSDIALOG _oTransp CENTERED
 
If _lRet
    M->UA_TRANSP    := _cTransp
    M->UA_REDESP    := _cRedesp
    M->UA_TPFRETE   := IIF(_nTipo == "3","C",_nTipo)
    M->UA__FTCONV   := IIF(_nTipo == "3","1","2")
    _cRed           := _cRedesp
    aValores[FRETE] := _nValFrete
    Tk273RodImposto("NF_FRETE",aValores[FRETE])
EndIf

Return _lRet 

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | IVLDGRV | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Validação da transportadora no pedido                                               |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function IVLDGRV(_oTransp,_lRet,_cTransp)
    If M->UA__RESEST == "S" .And. (_cTransp $ GetMV("MV__TRPTMK"))
        MsgStop("Transportadora invalida, favor verificar","CORRIGIR INFORMACAO")
        Return
    EndIf
    _lRet := .t.
    _oTransp:End()
Return 

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IVALCFRT | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Validação da transportadora no pedido                                                |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function IVALCFRT(_cTransp,_nValFrete,_nValPedido,_nValImp)
//Local _nBase := aValores[TOTAL] - aValores[FRETE], _nFrete := 0
Local _nBase := aValores[MERCADORIA], _nFrete := 0, _nValIPI := _nt := 0
Default _nValImp := 0

If Type("aObj[8]") == "O"
     If Type("aObj[8]:aArray") == "A" 
        For _nt := 1 To Len(aObj[8]:aArray)
            If Alltrim(aObj[8]:aArray[_nt][1]) == "IPI"
                _nValIPI += aObj[8]:aArray[_nt][5]
            EndIf
        Next
     EndIf
EndIf

_nBase += _nValIPI

Posicione("SA1",1,xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA,"A1__REGTRP")
DbSelectArea("SZJ")
DbSetOrder(1)
If MsSeek(xFilial("SZJ") + _cTransp + SA1->A1__REGTRP)

    If _nBase >= SZJ->ZJ_BASEMIN
        _nFrete := _nBase * (SZJ->ZJ_PERCFRT/100)
    Else
        _nFrete := SZJ->ZJ_VALMIN
    EndIf
    
    If _nFrete > 0
        _nValFrete  := _nFrete
        //_nValPedido := _nBase + _nFrete
        _nValPedido := aValores[MERCADORIA] + _nFrete + _nValImp
    EndIf
    
EndIf

Return 

/*
+------------+------------+--------+------------------------------------------+-------+---------------+
| Programa:  | FilColsTMK | Autor: | Rubens Cruz - Anadi Consultoria          | Data: | Janeiro/2015  |
+------------+------------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina para validar o campo de tipo de pedido                                          |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function FilColsTMK(_cRotina)
Local lRet := (ExistCpo("SZF",_cTpPed))

If lRet
    _cDescri := Posicione("SZF",1,xFilial("SZF") + _cTpPed,"ZF_DESC")
    _oDescri:Refresh()
    If _cRotina == "PED"
       IGetDPed(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")
    Else
       IGetDCot(_cFilial,_cTpPed,_cCodCli,_cLojaCli,"2")
    EndIf
EndIf

Return lRet

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKDPR1 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Retorna o preço de tabela do produto                                                |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKDPR1()
Local _lRet := .f.
Local _nPTab := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB" }) 
Local _nPDpr := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP" })

If aCols[n][_nPTab] > 0 .And. aCols[n][_nPDpr] == 0
    _lRet := .t.
ElseIf aCols[n][_nPTab] > 0 .And. aCols[n][_nPDpr] > 0
    U_ITMKC06Q("")
EndIf 

Return _lRet


/*
+------------+-----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKVLSA1 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+-----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Validação de ediação de campos, de acordo com situação do cliente                    |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKVLSA1(_cCodSA1,_cLojSA1)
Local _lRet := .t.

DbSelectArea("SA1")
DbSetOrder(1)
MsSeek(xFilial("SA1") + _cCodSA1 + _cLojSA1)

If SA1->A1__RESTRI $ "1/2" .Or. SA1->A1__ATIVO == "2" .Or. SA1->A1__DUVIDO == "1" .Or. SA1->A1__INADIM == "1"
    _lRet := .f.
EndIf

Return _lRet


/*
+------------+------------+--------+-----------------------------------------+-------+----------------+
| Programa:  | ITMKCALIMP | Autor: |    Rogério Alves - Anadi Consultoria    | Data: | Fevereiro/2015 |
+------------+------------+--------+-----------------------------------------+-------+----------------+
| Descrição: | Rotina para impressão dos relatórios de histórico do pedido ou cotação                 |
+-----------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                  |
+------------+----------------------------------------------------------------------------------------+
*/

Static Function ITMKCALIMP(_cNum,_cFil)

Local _lRet     := .t.
Local _cRelato  := "1;0;1;ITMKCR10"
Local _oDlgImp  := Nil
Local _nLin     := 0
Local oFont     := tFont():New("Tahoma",,-11,,.T.)
/*
Private _aObjeto  := {}, _aSize := MsAdvSize(), _aInfo := {}, _aPosObj := {}, _aPosEnch := {}
         
_aSize   := MsAdvSize()

AAdd(_aObjeto, { 100, 100, .t., .t. } )

_aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}
_aPosObj := MsObjSize(_aInfo,_aObjeto)  
_nLin    := _aPosObj[1,1]+10
*/
DEFINE MSDIALOG _oDlgImp TITLE "Modelo do Relatório" From 0,0 To 120,330/*_aSize[7],0 To _aSize[6]-585,_aSize[5]-1118*/ OF oMainWnd PIXEL

_nLin += 8

@ _nLin,010/*_aPosObj[1,4]-740*/ BUTTON "  Cotação "  SIZE 40,14 Of _oDlgImp PIXEL FONT oFont ACTION {|| CallCrys('ITMKCR10',_cNum+";"+_cFilial,_cRelato) , _oDlgImp:End()}
@ _nLin,060/*_aPosObj[1,4]-680*/ BUTTON "Hist. Ped."  SIZE 40,14 Of _oDlgImp PIXEL FONT oFont ACTION {|| U_IFATR09(_cNum,_cFilial) , _oDlgImp:End()}
@ _nLin,110/*_aPosObj[1,4]-620*/ BUTTON " Cancelar "  SIZE 40,14 Of _oDlgImp PIXEL FONT oFont ACTION _oDlgImp:End()

ACTIVATE MSDIALOG _oDlgImp CENTERED

Return _lRet

/*
+------------+----------+--------+-------------------------------------+-------+------------+
| Programa:  | ITMKNSUA | Autor: | Jorge H. Alves - Anadi Consultoria  | Data: | Abril/2015 |
+------------+----------+--------+-------------------------------------+-------+------------+
| Descrição: | Busca a proxima numeração de pedido                                          |
+-------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                        |
+------------+------------------------------------------------------------------------------+
*/

User Function ITMKNSUA()
Local _aArea := GetArea(), _cNumSUA := TkNumero("SUA","UA_NUM"), _nSaveSx8 := GetSX8Len()

//Verifica se o pedido já não existe na SUA e ZUA
DbSelectArea("ZUA")
DbSetOrder(1)
While MsSeek(xFilial("ZUA") + _cNumSUA)
    DbSelectArea("SUA")
    While (GetSx8Len() > _nSaveSx8)
        ConfirmSX8()
    EndDo 
    
    _cNumSUA := GetSX8Num("SUA","UA_NUM")
    
    DbSelectArea("ZUA")
EndDo

DbselectArea("SUA")
DbSetOrder(1)
While MsSeek(xFilial("SUA") + _cNumSUA)
    DbSelectArea("SUA")
    While (GetSx8Len() > _nSaveSx8)
        ConfirmSX8()
    EndDo 
    
    _cNumSUA := GetSX8Num("SUA","UA_NUM")
    
    DbSelectArea("SUA")
EndDo

RestArea(_aArea)
Return _cNumSUA

/*
+------------+----------+--------+-------------------------------------+-------+------------+
| Programa:  | ITMKDZ05 | Autor: | Jorge H. Alves - Anadi Consultoria  | Data: | Abril/2015 |
+------------+----------+--------+-------------------------------------+-------+------------+
| Descrição: | Exclui registros da Z05                                                      |
+-------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                        |
+------------+------------------------------------------------------------------------------+
*/

User Function ITMKDZ05(_cFilTmk,_cNumTmk)
Local _cSQL := "", _nOK := 0

_cSQL := "Update " + RetSqlName("Z05") 
_cSQL += " Set D_E_L_E_T_ = '*' "
_cSQL += "Where Z05_FILIAL = '" + _cFilTmk + "' And Z05_NUM = '" + _cNumTmk + "' And Z05_DOC = ' ' And D_E_L_E_T_ = ' ' "

_nOK := TCSQLExec(_cSQL)
     
If _nOK < 0
    DbSelectArea("Z05")
    DbSetOrder(1)
    DbGoTop()
    If MsSeek(_cFilTmk + _cNumTmk)
        While !Eof() .And. (Z05->Z05_FILIAL + Z05->Z05_NUM) == (_cFilTmk + _cNumTmk) 
            If Empty(Z05->Z05_DOC) .Or. Z05->Z05_TIPO != "4"
                Reclock("Z05",.F.)
                DbDelete()
                MsUnlock()
            EndIf
            DbSkip()
        EndDo
    EndIf
Else
    TCRefresh("Z05")
Endif

Return


User Function ITMKREPL(_cConteudo)
Local _nItm := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"}), _nPai := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITEPAI"})
Local _nPCd := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO"}), _nTes := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_TES"}) 
Local _nFil := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ITFILH"})
Local _nLinha := aScan(aCols, { |x| AllTrim(x[_nItm]) == aCols[n][_nFil] }), _nn := n

If _nLinha > 0
	//Atualizo a nova linha com os mesmos dados da linha original
	n := _nLinha
	For _ny := 1 To Len(aHeader)
		If !(Alltrim(aHeader[_ny][2]) $ Alltrim(GetMv("MV__ARMCPO")))
			aCols[_nLinha][_ny] := aCols[_nn][_ny]
		EndIf
	Next _ny	
	If !(Type("lTk271Auto") <> "U" .AND. lTk271Auto)
		Tk273Calcula()
	EndIf
	
	n := _nLinha	        
    U_ITMKC05P("")
    n := _nLinha
    U_ITMKC07I("")	 

    Eval(bGDRefresh)
    Eval(bRefresh)

    n := _nLinha        
    MaColsToFis(aHeader, aCols, n, "TK273", .F.)   

    n := _nLinha
    U_IFISA04B("",aCols[n][_nTes],"SUB") 
            
    n := _nn
    If Type("oGetTlv") == "O"
	    oGetTlv:oBrowse:NAT := n
    EndIf
	Eval(bGDRefresh)
    Eval(bRefresh)
    
EndIf

If Type("_cConteudo") == "U"
	_cConteudo := &(ReadVar())
EndIf

Return _cConteudo