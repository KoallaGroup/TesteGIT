#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

//aTitulo
#DEFINE _VLRTIT_        01
#DEFINE _VLRIRRF_       02
#DEFINE _VLRINSS_       03
#DEFINE _VLRISS_        04
#DEFINE _VLRPIS_        05
#DEFINE _VLRCSLL_       06          
#DEFINE _VLRCOFI_       07
#DEFINE _VLRIPI_        08                           
#DEFINE _VLRSOL_        09
#DEFINE _VLRMOE_        10                        
#DEFINE _VLRREA_        11
#DEFINE _VLRACR_        12
#DEFINE _VLRDSPMOE_     13 //Valor despesas acessorias na moeda
#DEFINE _VLRDSPREA_    14 //Valor despesas acessorias em real
#DEFINE _VLRTITDIF_    15 //Diferenca no valor do titulo na moeda do titulo
#DEFINE _TAXANDF_      16 //Taxa da NDF
#DEFINE _MOEDANDF_     17 //Moeda da NDF
#DEFINE _VLRFET_       18 //Valor do FETHAB
#DEFINE _VLRDESPAC2_   19 //Diferença no rateio das despesas acessorias em dolar
#DEFINE _VLRFAB_       20 //Valor do FABOV
#DEFINE _VLRFAC_       21 //Valor do FACS
#DEFINE _VLRTPDP_      22 //Valor do FACS  

//aImposto
#DEFINE _IMPFET_        08 //Valor do FETHAB
#DEFINE _IMPFAB_        09 //Valor do FABOV
#DEFINE _IMPFAC_        10 //Valor do FACS

//GetMv
#DEFINE  __ULMES        01
#DEFINE  __LIBGRUPO     02  
#DEFINE  __FRETMOE      03
#DEFINE  __CONTSOC      04
#DEFINE  __MCUSTO       05
#DEFINE  __MOEDTIT      06
#DEFINE  __TXPER        07
#DEFINE  __TPCOMIS      08
#DEFINE  __1DUP         09
#DEFINE  __1DUPREF      10
#DEFINE  __1DUPNAT      11
#DEFINE  __RATDESP      12
#DEFINE  __SERCUP       13
#DEFINE  __TPNRNFS      14
#DEFINE  __EECFAT       15
#DEFINE  __RTIPFIN      16

//Entry Point - Pontos de Entrada
#DEFINE EP_M460MKB      01
#DEFINE EP_M461IMPF     02
#DEFINE EP_SF2460I      03
#DEFINE EP_M460IPI      04
#DEFINE EP_M460ICM      05
#DEFINE EP_M460SOLI     06
#DEFINE EP_MSD2UM2      07
#DEFINE EP_MSD2460      08
#DEFINE EP_MTASF2       09
#DEFINE EP_F440COM      10
#DEFINE EP_M460IREN     11
#DEFINE EP_M460ISS      12
#DEFINE EP_M460VISS     13
#DEFINE EP_M460ATEC     14
#DEFINE EP_M460NITE     15
#DEFINE EP_M460PROC     16
#DEFINE EP_M460QRY      17
#DEFINE EP_M460FIL      18
#DEFINE EP_M460RTPD     19
#DEFINE EP_M460FIM      20
#DEFINE EP_M460COND     21
#DEFINE EP_M460INSS     22
#DEFINE EP_M460ITPD     23
#DEFINE EP_M460ORD      24
#DEFINE EP_M460MOED     25
#DEFINE EP_M460FIT      26
#DEFINE EP_M460IPT      27
#DEFINE EP_M460QRT      28
#DEFINE EP_M460SOT      29
#DEFINE EP_MSD246T      30
#DEFINE EP_MSD2UMT      31
#DEFINE EP_SF2460T      32
#DEFINE EP_M460RAT      33
#DEFINE EP_M461ACRE     34
#DEFINE EP_M460NOTA     35
#DEFINE EP_M460ICMT     36
#DEFINE EP_M460QUEB     37

//aSavRat
#DEFINE SV_PEDIDO       01
#DEFINE SV_FRETE        02
#DEFINE SV_FRETAUT      03
#DEFINE SV_SEGURO       04
#DEFINE SV_DESPESA      05
#DEFINE SV_DESCONT      06
#DEFINE SV_DESPAC2      07
#DEFINE SV_VLR_FRT      08

//aRateio
#DEFINE RT_PEDIDO       01
#DEFINE RT_ITEM         02
#DEFINE RT_SEQUEN       03
#DEFINE RT_FRETE        04
#DEFINE RT_SEGURO       05
#DEFINE RT_DESPESA      06
#DEFINE RT_FRETAUT      07
#DEFINE RT_DESCONT      08
#DEFINE RT_PRECOIT      09
#DEFINE RT_PDESCON      10
#DEFINE RT_DESPAC2      11
#DEFINE RT_DESPMOE      12
#DEFINE RT_VLR_FRT      13

#DEFINE __UFORI         01
#DEFINE __ALQORI        02
#DEFINE __PROPOR        03

Static lRelease := GetRpoRelease() >= "R7"  //Identifica se o release é igual ou superior ao 11.7

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis Staticas do Programa                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static aEntry     := {}
Static aFisGet    := Nil
Static aFisGetSC5 := Nil
Static aRelImp    := Nil
Static aSavRat    := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis Staticas para utilizacao do arquivo SD9 na numeracao de DOC   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static cMin460D 
Static dDatabOri := Ctod("")
Static aSerieSD9 := {}                    // Series utilizadas no controle pelo SD9 
Static cFilOri   := ""                    //filial  para controle de numeracao SD9

/*
+------------+---------+-------+-------------------------+------+---------------+
| Programa:  | IFATA26 | Autor | Silverio Bastos - Anadi | Data | Novembro/2014 |
+------------+---------+-------+-------------------------+------+---------------+
| Descrição: | Rotina de Geracao das Notas Fiscais de Saida.                    |
+------------+------------------------------------------------------------------+
| Uso:       | Isapa                                                            |
+------------+------------------------------------------------------------------+
*/

User Function IFATA26()

Local lContinua := .T.
Local lIntACD       := SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local cFilSC9       := ""
Local cQrySC9       := ""
Local aIndexSC9 := {}
Local aCores        := {}
Local aRotAdic  := {}               // Array utilizado no ponto de entrada
Local lFatPrev  := SuperGetMV( 'MV_FATFTPR', .F., .T. ) //Indica se permite faturar itens previstos (C9_TPOP = P)
Local _cPedido := Space(TamSX3("C9_PEDIDO")[1]), _cSQL := _cTab := "", _aStru := {}, _lOK := .f.
Private _cTemp := ""

PRIVATE bFiltraBrw         // Expressao de Filtro
PRIVATE nOrdNFS   := 1     // Ordem de Geracao da Nota Fiscal
PRIVATE aRotina   := {}
//  { "Pesquisar","Ma460Pesq", 0 , 1},;  //"Pesquisar"
//                              { "Ordem" ,"Ma460Ordem" , 0 , 0},; //"Ordem"
//                              { "Prep. Doc's" ,"U_xMa460Nota"  , 0 , 4},; //"Prep. Doc's"
//                              { "Estor.Doc's" ,"Ma461Estor" , 0 , 0},; //"Estor.Doc's"    
//                              { "Visualiza Doc." ,"Ma461View"  , 0 , 2},; //"Visualiza Doc."
//                              { "Legenda" ,"A461Legend" , 0 , 6},; //"Legenda"    
//                              { "Conhecimento" ,"Ma461Conh"  , 0 , 4} } //"Conhecimento"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada - Adiciona rotinas ao aRotina       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MA461ROT")
    aRotAdic := ExecBlock("MA461ROT", .F., .F.)
    If ValType(aRotAdic) == "A"
        AEval(aRotAdic,{|x| AAdd(aRotina,x)})
    EndIf
EndIf  
    
PRIVATE cCadastro := OemToAnsi("Prepara‡„o dos Documentos de Sa¡da")                  //"Prepara‡„o dos Documentos de Sa¡da"
Private c460Cond  := ""
Public cMarca    := ThisMark()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carga das Variaveis Staticas do Programa                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('SC9') //Liberação de Pedidos
SC9->(DbSetOrder(1))    //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
dbSelectArea("SFC")
dbSelectArea("AF8")
dbSelectArea("AFS")
dbSelectArea("SES")
MaNfsInit()       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta o SX1                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia Ponto de Entrada                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nModulo == 72
    c460Cond := KEXF730()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o direito de acesso por parte do usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Substr(cAcesso,51,1) <> "S" )
    dbSelectArea("SF2")
    dbSetOrder(3)
    MsSeek(xFilial("SF2")+Space(Len(SF2->F2_ECF))+"z",.T.)
    dbSkip(-1)
    If ( dDataBase < SF2->F2_EMISSAO )
        Help(" ",1,"DATNF")
        lContinua := .F.
    EndIf
    If lContinua
        MsSeek(xFilial("SF2")+"S"+"z",.T.)
        dbSkip(-1)
        If ( dDataBase < SF2->F2_EMISSAO )
            Help(" ",1,"DATNF")
            lContinua := .F.
        EndIf
    EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o Ambiente de Processamento.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( AMIIn(5,12,39,45,69,72) .And. lContinua )          // SigaFat - SigaLoja - SigaCda
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica o Fechamento do Estoque                                        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ( If(FindFunction("MVUlmes"),MVUlmes(),SuperGetMV("MV_ULMES")) >= dDataBase )
        Help ( " ", 1, "FECHTO" )
        lContinua := .F.
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica o Fechamento do Fiscal                                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ( !FisChkDt(dDataBase) )
        lContinua := .F.
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica as perguntas MT461A                                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Variaveis utilizadas para parametros                         ³
    //³ mv_par01     // Filtra j  emitidas     - Sim/Nao             ³
    //³ mv_par02     // Estorno da Liberacao   - Posic./Marcados     ³
    //³ mv_par03     // Cons. Param. Abaixo    - Sim/Nao             ³
    //³ mv_par04     // Trazer Ped. Marc       - Sim/Nao             ³
    //³ mv_par05     // De  Pedido                                   ³
    //³ mv_par06     // Ate Pedido                                   ³
    //³ mv_par07     // De  Cliente                                  ³
    //³ mv_par08     // Ate Cliente                                  ³
    //³ mv_par09     // De  Loja                                     ³
    //³ mv_par10     // Ate Loja                                     ³
    //³ mv_par11     // De  Liberacao                                ³
    //³ mv_par12     // Ate Liberacao                                ³
    //³ mv_par13     // De  Entrega                                  ³
    //³ mv_par14     // Ate Entrega                                  ³
    //³ mv_par15     // Mostra Itens Previstos - Sim/Não             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    AjustSX1_A()
    If ( Pergunte("MT461A",.T.) .And. lContinua )
        cFilSC9 := "C9_FILIAL='"+xFilial("SC9")+"'"
        cQrySC9 := "SC9.C9_FILIAL='"+xFilial("SC9")+"'"
        If ( MV_PAR01 == 1 )
            cFilSC9 += ".And.C9_BLEST = ' '"
            cFilSC9 += ".And.C9_BLCRED = ' '"
        EndIf
        
        If ( !lFatPrev )    //Indica se permite faturar itens Previstos (Campo C6_TPOP)
            If ( SC9->(FieldPos('C9_TPOP')) > 0 )
                //Filtra apenas itens com Tipo de Ordem de Produção Firmes (C6_TPOP = 'F' | C9_TPOP = '1')
                cFilSC9 += ".And. C9_TPOP != '2'"
                cQrySC9 += "AND  SC9.C9_TPOP <> '2'"
            EndIf
        EndIf
        
        If ( MV_PAR03 == 1 )

            cFilSC9 += ".And.C9_PEDIDO>='"+MV_PAR05+"'"
            cFilSC9 += ".And.C9_PEDIDO<='"+MV_PAR06+"'"
            cFilSC9 += ".And.C9_CLIENTE>='"+MV_PAR07+"'"
            cFilSC9 += ".And.C9_CLIENTE<='"+MV_PAR08+"'"
            cFilSC9 += ".And.C9_LOJA>='"+MV_PAR09+"'"
            cFilSC9 += ".And.C9_LOJA<='"+MV_PAR10+"'"
            cFilSC9 += ".And.Dtos(C9_DATALIB)>='"+Dtos(MV_PAR11)+"'"
            cFilSC9 += ".And.Dtos(C9_DATALIB)<='"+Dtos(MV_PAR12)+"'"
            
            //Se a versão for 11.7 ou superior
            If ( lRelease )
                //Filtra por data de entrega
                If ( !Empty( MV_PAR13 ) ) .And. ( ValType(MV_PAR13) == 'D' )
//                  cFilSC9 += ".And. DToS(C9_DATENT) >= '" + DToS(MV_PAR13) + "'"
                EndIf               
                If ( !Empty( MV_PAR14 ) ) .And. ( ValType(MV_PAR14) == 'D' )
//                  cFilSC9 += ".And. DToS(C9_DATENT) <= '" + DToS(MV_PAR14) + "'"
                EndIf
            EndIf
            
            If ( SC9->(FieldPos('C9_TPOP')) > 0 )
                //Mostra itens previstos?
                If ( !Empty( MV_PAR15 ) ) .And. ( ValType(MV_PAR15) == 'N' )
                    If ( MV_PAR15 == 2 ) .And. ( lFatPrev )
                        cFilSC9 += ".And. C9_TPOP != '2'"
                    EndIf
                EndIf
            EndIf
                
            cQrySC9 += " AND SC9.C9_PEDIDO>='"+MV_PAR05+"'"
            cQrySC9 += " AND SC9.C9_PEDIDO<='"+MV_PAR06+"'"
            cQrySC9 += " AND SC9.C9_CLIENTE>='"+MV_PAR07+"'"
            cQrySC9 += " AND SC9.C9_CLIENTE<='"+MV_PAR08+"'"
            cQrySC9 += " AND SC9.C9_LOJA>='"+MV_PAR09+"'"
            cQrySC9 += " AND SC9.C9_LOJA<='"+MV_PAR10+"'"
            cQrySC9 += " AND SC9.C9_DATALIB>='"+Dtos(MV_PAR11)+"'"
            cQrySC9 += " AND SC9.C9_DATALIB<='"+Dtos(MV_PAR12)+"'"  
            
            //Se a versão for 11.7 ou superior
            If ( lRelease )
                If ( !Empty( MV_PAR13 ) ) .And. ( ValType(MV_PAR13) == 'D' )
  //                    cQrySC9 += " AND SC9.C9_DATENT >= '" + DToS(MV_PAR13) + "'"
                EndIf
                
                If ( !Empty( MV_PAR14 ) ) .And. ( ValType(MV_PAR14) == 'D' )
//                  cQrySC9 += " AND SC9.C9_DATENT <= '" + DToS(MV_PAR14) + "'"     
                EndIf
            EndIf
            
            If ( SC9->(FieldPos('C9_TPOP')) > 0 )
                //Mostra itens previstos?
                If ( !Empty( MV_PAR15 ) ) .And. ( ValType(MV_PAR15) == 'N' )
                    If ( MV_PAR15 == 2 ) .And. ( lFatPrev )
                        cQrySC9 += "AND SC9.C9_TPOP <> '2'"
                    EndIf
                EndIf
            EndIf

        EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pontos de Entrada                                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        
        If nModulo == 72
            cQrySC9 := KEXF750(cQrySC9 , 1 )
        EndIf
        

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Chamada para integracao com o modulo ACD - Faz filtro do PV na geracao da nota. ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lIntACD .And. FindFunction("CBM460FIL")
            cFilSC9 += ".And."+CBM460FIL()
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pontos de Entrada                                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Array com as cores que definem cada status no markbrowser³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aCores := { {'Empty(SC9->C9_BLEST)   .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  "','ENABLE' },;    //Pedido de Venda liberado 
                    {'SC9->C9_BLEST=="10"    .And. SC9->C9_BLCRED=="10"  .And. SC9->C9_BLWMS$"05,06,07,  "','DISABLE'},;    //Pedido de Venda Faturado
                    {'!(Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  ")','BR_AZUL'}}    //Pedido de Venda com bloqueio
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Ponto de Entrada para alterar cores do Browse do Cadastro    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Existblock("M461COR")
            aCores := ExecBlock("M461COR",.F.,.F.,aCores)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Realiza a Filtragem                                                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        bFiltraBrw := {|x| If(x==Nil,FilBrowse("SC9",@aIndexSC9,@cFilSC9),{cFilSC9,cQrySC9,"","",aIndexSC9}) }
        Eval(bFiltraBrw)
        SC9->(MsSeek(xFilial()))
        dbGotop()    
        
        _cTab := GetNextAlias()
        _cSQL := "Select Distinct C9_FILIAL, C9_PEDIDO, C9_CLIENTE, C9_LOJA, C5__NUMSUA PEDCALL, A1_NOME, A1_NREDUZ, A2_NOME, A2_NREDUZ, C5_TIPO, 
        _cSQL += "(SELECT COUNT(*) From " + RetSqlName("SC6") + " C6 "
        _cSQL += "Where C6_FILIAL = '" + xFilial("SC6") + "' And C6_NUM = C9_PEDIDO AND C6.D_E_L_E_T_ = ' ') QTITEM, " 
        _cSQL += "C5_EMISSAO From " + RetSqlName("SC9") + " C9 " 
        _cSQL += "INNER JOIN " + RetSqlName("SC5") + " C5 ON  C5_FILIAL = C9_FILIAL And C5_NUM = C9_PEDIDO AND C5.D_E_L_E_T_ = ' ' "
        _cSQL += "LEFT  JOIN " + RetSqlName("SA1") + " A1 ON  A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND A1.D_E_L_E_T_ = ' ' "
        _cSQL += "LEFT  JOIN " + RetSqlName("SA2") + " A2 ON  A2_COD = C9_CLIENTE AND A2_LOJA = C9_LOJA AND A2.D_E_L_E_T_ = ' ' "
        _cSQL += "Where C9_FILIAL = '" + xFilial("SC9") + "' And C9_PEDIDO BETWEEN '" + MV_PAR05 + "' And '" + MV_PAR06 + "' AND "
        _cSQL += "C9_CLIENTE BETWEEN '" + MV_PAR07 + "' And '" + MV_PAR08 + "' And "
        _cSQL += "C9_LOJA BETWEEN '" + MV_PAR09 + "' And '" + MV_PAR10 + "' And "
        _cSQL += "C9_DATALIB BETWEEN '" + Dtos(MV_PAR11) + "' And '" + Dtos(MV_PAR12) + "' And "
    //  _cSQL += "C9_DATENT BETWEEN '" + Dtos(MV_PAR13) + "' And '" + Dtos(MV_PAR14) + "' And "
        _cSQL += "C9_BLEST = ' ' And C9_BLCRED = ' ' And "
        _cSQL += "C9.D_E_L_E_T_ = ' ' And C5__STATUS = '8' "            
        _cSQL += "ORDER BY C9_FILIAL, C9_PEDIDO "

        _cSQL := ChangeQuery(_cSQL)

        If Select(_cTab) > 0
            DbSelectArea(_cTab)
            DbCloseArea()
        EndIf

        DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

        DbSelectArea(_cTab)
        DbGoTop()

        If !Eof()
    
            //Cria a tabela temporária do MarkBrowse
            _cTemp := GetNextAlias()
            AADD(_aStru,{"MARKOK"           ,"C"                    ,   02                      ,   0                       })
            AADD(_aStru,{"Filial"           ,TamSX3("C9_FILIAL")[3] ,   TamSX3("C9_FILIAL")[1]  ,   TamSX3("C9_FILIAL")[2]  })
            AADD(_aStru,{"Pedido"           ,TamSX3("C9_PEDIDO")[3] ,   TamSX3("C9_PEDIDO")[1]  ,   TamSX3("C9_PEDIDO")[2]  })
            AADD(_aStru,{"PedCall"          ,TamSX3("C5__NUMSUA")[3],   TamSX3("C5__NUMSUA")[1] ,   TamSX3("C5__NUMSUA")[2] })
            AADD(_aStru,{"Cliente"          ,TamSX3("A1_COD")[3]    ,   TamSX3("A1_COD")[1]     ,   TamSX3("A1_COD")[2]     })
            AADD(_aStru,{"Loja"             ,TamSX3("A1_LOJA")[3]   ,   TamSX3("A1_LOJA")[1]    ,   TamSX3("A1_LOJA")[2]    })
            AADD(_aStru,{"Nome"             ,TamSX3("A1_NOME")[3]   ,   TamSX3("A1_NOME")[1]    ,   TamSX3("A1_NOME")[2]    })
            //AADD(_aStru,{"Fantasia"       ,TamSX3("A1_NREDUZ")[3] ,   TamSX3("A1_NREDUZ")[1]  ,   TamSX3("A1_NREDUZ")[2]  })
            AADD(_aStru,{"QtdeItens"        ,"N"                    ,   03                      ,   0                       })
            AADD(_aStru,{"DtEmissao"        ,TamSX3("C5_EMISSAO")[3],   TamSX3("C5_EMISSAO")[1] ,   TamSX3("C5_EMISSAO")[2] })
    
            _cArq1 := CriaTrab(_aStru,.t.)
            DbUseArea(.t.,,_cArq1,_cTemp,.t.)
            _cInd1 := CriaTrab(Nil,.f.)
            IndRegua(_cTemp,_cInd1,"FILIAL + PEDIDO ",,,"Gerando a Tela...") 
    
            DbSelectArea(_cTab)
            dbGotop()
            While !Eof()          

                DbSelectArea(_cTemp)
                If !DbSeek((_cTab)->C9_FILIAL + (_cTab)->C9_PEDIDO )
                    _lOK := .t.
                    Reclock(_cTemp,.t.)
                    (_cTemp)->FILIAL    := (_cTab)->C9_FILIAL
                    (_cTemp)->PEDIDO    := (_cTab)->C9_PEDIDO
                    (_cTemp)->PEDCALL   := (_cTab)->PEDCALL
                    (_cTemp)->CLIENTE   := (_cTab)->C9_CLIENTE
                    (_cTemp)->LOJA      := (_cTab)->C9_LOJA
                    If (_cTab)->C5_TIPO $ "D/B"
                       (_cTemp)->NOME       := (_cTab)->A2_NOME
                        //(_cTemp)->FANTASIA    := (_cTab)->A1_NREDUZ
                    Else
                       (_cTemp)->NOME       := (_cTab)->A1_NOME
                        //(_cTemp)->FANTASIA    := (_cTab)->A1_NREDUZ
                    EndIf
                    (_cTemp)->QTDEITENS := (_cTab)->QTITEM
                    (_cTemp)->DTEMISSAO := CTOD(SUBST((_cTab)->C5_EMISSAO,7,2)+"/"+SUBST((_cTab)->C5_EMISSAO,5,2)+"/"+SUBST((_cTab)->C5_EMISSAO,1,4))  
                    MsUnlock()
                EndIf
        
                DbSelectArea(_cTab)
                DbSkip()
        
            EndDo
    
            IFATA26A() //Monta a estrutura do Markbrowse

            //MarkBrow("SC9","C9_OK","A460Avalia()",,MV_PAR04==1.And.MV_PAR03==1,GetMark(,"SC9","C9_OK"),,,,,,,,,aCores)
            
            If Select(_cTemp) > 0
                DbSelectArea(_cTemp)
                DbCloseArea()
            EndIf
         
            If File(_cInd1 + OrdBagExt())
                fErase(_cInd1 + OrdBagExt())
            EndIf
    
            If File(_cArq1 + GetDbExtension())
                fErase(_cArq1 + GetDbExtension())
            EndIf   
        Else
            MsgAlert('Não existe nenhum Pedido Liberado para Faturamento !!!')
        EndIf

        If Select(_cTab) > 0
            DbSelectArea(_cTab)
            DbCloseArea()
        EndIf   
        
        dbSelectArea("SC9")
        RetIndex("SC9")
        dbClearFilter()
        aEval(aIndexSC9,{|x| Ferase(x[1]+OrdBagExt())})
    Else
        lContinua := .F.
    EndIf

    SetKey(VK_F12,Nil)
Else
    lContinua := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Anula as variaveis staticas criadas pela funcao manfsinit               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaNfsEnd()

Return( lContinua )


/*
+------------+---------+-------+-------------------------+------+---------------+
| Programa:  | IFATA26C| Autor | Silverio Bastos - Anadi | Data | Novembro/2014 |
+------------+---------+-------+-------------------------+------+---------------+
| Descrição: | Rotina de Geracao das Notas Fiscais de Saida.                    |
+------------+------------------------------------------------------------------+
| Uso:       | Isapa                                                            |
+------------+------------------------------------------------------------------+
*/

User Function IFATA26C(cAlias)

Local aArea    := GetArea()
Local lContinua := .T.
Local nOpcA    := 0
Local cSerie   := ""
Local nX        := 0
Local aMsgHlp   := {}
Local cHlp      := ""
Local lP21      := .F. // Existe pergunta 21 do grupo MT460A   
Local dDataMoe  := dDataBase

// Verifica se usuario alterou numero da nota fiscal quando MV_TPNRNFS == "3" (apenas para MV_ESTADO = "SC").
Private lMudouNum := .F.
Private cNumero   := ""
Private aPedDecret:= {}     //Decreto Nº 54.869, de 2 de outubro de 2009 do Estado de São Paulo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis de parametrizacao de lancamentos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Mostra Lan‡.Contab     ?  Sim/Nao                         ³
//³ mv_par02 Aglut. Lan‡amentos     ?  Sim/Nao                         ³
//³ mv_par03 Lan‡.Contab.On-Line    ?  Sim/Nao                         ³
//³ mv_par04 Contb.Custo On-Line    ?  Sim/Nao                         ³
//³ mv_par05 Reaj. na mesma N.F.    ?  Sim/Nao                         ³
//³ mv_par06 Taxa deflacao ICMS     ?  Numerico                        ³
//³ mv_par07 Metodo calc.acr.fin    ?  Taxa defl/Dif.lista/% Acrs.ped  ³
//³ mv_par08 Arred.prc unit vist    ?  Sempre/Nunca/Consumid.final     ³
//³ mv_par09 Agreg. liberac. de     ?  Caracter                        ³
//³ mv_par10 Agreg. liberac. ate    ?  Caracter                        ³
//³ mv_par11 Aglut.Ped. Iguais      ?  Sim/Nao                         ³
//³ mv_par12 Valor Minimo p/fatu    ?                                  ³
//³ mv_par13 Transportadora de      ?                                  ³
//³ mv_par14 Transportadora ate     ?                                  ³
//³ mv_par15 Atualiza Cli.X Prod    ?                                  ³
//³ mv_par16 Emitir                 ?  Nota / Cupom Fiscal             ³
//³ mv_par17 Gera Titulo            ?  Sim/Nao                         ³
//³ mv_par18 Gera guia recolhimento ?  Sim/Nao                         ³
//³ mv_par19 Gera Titulo ICMS Próprio ?  Sim/Nao                       ³
//³ mv_par20 Gera Guia ICMS Próprio ?  Sim/Nao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1(@lP21)    
If ( Pergunte("MT460A",.T.) )
    If mv_par16 == 2
        Aviso("Atendendo legislação do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08 desenvolvido pelo CONFAZ, os módulos Front-loja/SigaLoja (rotina Venda Assistida) são únicas interfaces Protheus a permitirem emissão de cupom fiscal.","Atendendo legislação do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08 desenvolvido pelo CONFAZ, os módulos Front-loja/SigaLoja (rotina Venda Assistida) são únicas interfaces Protheus a permitirem emissão de cupom fiscal.",{"Atendendo legislação do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08 desenvolvido pelo CONFAZ, os módulos Front-loja/SigaLoja (rotina Venda Assistida) são únicas interfaces Protheus a permitirem emissão de cupom fiscal."})    //"Atendendo legislação do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08 desenvolvido pelo CONFAZ, os módulos Front-loja/SigaLoja (rotina Venda Assistida) são únicas interfaces Protheus a permitirem emissão de cupom fiscal."
    Else 
        lContinua := U_xSx5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS"))
        If ( lContinua )
                If nModulo == 72 
                    KEXF740(SC9->(IndexOrd()))
                EndIf
                If lP21
                    dDataMoe := MV_PAR21
                Endif                
                Processa({|lEnd| Ma460Proc( cAlias,;
                    cSerie,;
                    MV_PAR01==1,;
                    MV_PAR02==1,;
                    MV_PAR03==1,;
                    MV_PAR04==1,;
                    MV_PAR05==1,;
                    MV_PAR07,;
                    MV_PAR08,;
                    MV_PAR09,;
                    MV_PAR10,;
                    MV_PAR11==1,;
                    MV_PAR12,;
                    MV_PAR13,;
                    MV_PAR14,;
                    MV_PAR15==1,;
                    .F.,;
                    c460Cond,@lEnd,dDataMoe)},,OemToAnsi("Prepara‡„o dos Doc's de Sa¡da/Expedi‡„o "),.T.)     //"Prepara‡„o dos Doc's de Sa¡da/Expedi‡„o "
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Exibe a uma mensagem para o usuário, informando os pedidos que não  ³
                    //³ foram faturados.                                                    ³
                    //³ Decreto Nº 54.869, de 2 de outubro de 2009 do Estado de São Paulo   ³
                    //³ Atingido o valor máximo do cupom fiscal: 10.000,00.                 ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If MV_PAR16==2 .And. Len(aPedDecret) > 0
                        aMsgHlp := LjAnalisaLeg(51)
                        cHlp := aMsgHlp[5] + CHR(10)
                        cHlp += "Pedido(s): "       //"Pedido(s): "
                        For nX := 1 To Len(aPedDecret)                      
                            If nX == 1
                                cHlp += aPedDecret[nX]
                            Else
                                cHlp += ", " + aPedDecret[nX]
                            EndIf
                        Next nX
                        aMsgHlp[5] := cHlp
                        LjMsgLeg(aMsgHlp)
                    EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Destrava o controle de numeracao                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            SX5->(MsRUnLock())
        EndIf           
    EndIf           
Else
    lContinua := .F.
EndIf
RestArea(aArea)

Return( lContinua )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma460Proc ³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gauge de Processamento da Geracao da Nota Fiscal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da MarkBrowse                                  ³±±
±±³          ³ExpC2: Serie da Nota Fiscal a ser considerada               ³±±
±±³          ³ExpL3: Mostra Lanc.Ctb.                                     ³±±
±±³          ³ExpL4: Aglut.Lancamentos                                    ³±±
±±³          ³ExpL5: Lct.Ctb.On-Line                                      ³±±
±±³          ³ExpL6: Lct.Ctb.Custo On-Line                                ³±±
±±³          ³ExpL7: Reajusta na mesma nota                               ³±±
±±³          ³ExpN8: Calc.Acr.Fin                                         ³±±
±±³          ³ExpN9: Arred.Prc.Unit                                       ³±±
±±³          ³ExpCA: Agregador de Liberacao Inicial                       ³±±
±±³          ³ExpCB: Agregador de Liberacao Final                         ³±±
±±³          ³ExpLC: Aglutina Pedido Iguais                               ³±±
±±³          ³ExpND: Valor Minimo para faturamento                        ³±±
±±³          ³ExpNE: Transportadora Inicial                               ³±±
±±³          ³ExpNF: Transportadora Final                                 ³±±
±±³          ³ExpNG: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExpNH: Cupom Fiscal                                         ³±±
±±³          ³ExpNI: Condicao a Ser Avaliada                              ³±±
±±³          ³ExpLJ: Flag de cancelamento do usuario                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma460Proc(cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,cAgregI,cAgregF,lJunta,nFatMin,cTranspI,cTranspF,lAtuSA7,lECF,cCondicao,lEnd,dDataMoe)

Local aArea     := GetArea()
Local aAreaSC9  := SC9->(GetArea())
Local aFiltro   := Eval(bFiltraBrw,1)
Local nItemNf   := a460NumIt(cSerie)
Local nIndSC9   := 0
Local nIndBrw   := 0
Local nPosKey   := 0
Local nCntFor   := 0
Local nTotal    := 0
Local nNrVend   := Fa440CntVen()
Local nPrcVen   := 0
Local nRecDAK   := 0
Local cArqSC9   := ""
Local cArqBrw   := ""
Local cFilSC9   := aFiltro[1]
Local cQrySC9   := aFiltro[2]
Local cFilBrw   := aFiltro[3]
Local cQryBrw   := aFiltro[4]
Local cKeySC9   := "C9_FILIAL+"
Local cAuxKey   := ""
Local cCursor1  := cTabela
Local cCursor2  := "SC9"
Local cCursor3  := "SC9"
Local cVendedor := ""
Local cFldQry   := ""
Local cNota     := ""
Local cTipo9    := ""
Local cPedido   := ""
Local cString   := ""
Local cSavFil   := cFilAnt
Local lInverte  := ThisInv()
Local lLibGrupo := SuperGetMv("MV_LIBGRUPO")=="S"
Local lAtuEst   := .F.
Local lQuery    := .F.
Local lQuebra   := .F.
Local lConfirma := .T.
Local lExecuta  := .T.
Local lTxMoeda  := .F.
Local lAcima    := .F.
Local lTotZero  := .F.
Local lSemSaldo := .F.
Local lFilDAK   := OsVlEntCom()<>1 .And. cTabela == "DAK"
Local lM461VTot := ExistBlock("M461VTOT")
Local lGeraVTot := .T.
Local aSemSaldo := {}
Local aTravas   := {}
Local aPvlNfs   := {}
Local aQuebra   := {}
Local aQuebra2  := {}
Local aQuebra3  := {}
Local aNfCodISS := {}
Local bWhile1   := {|| !Eof() }
Local bWhile2   := {|| !Eof() }
Local bWhile3   := {|| !Eof() }
Local lCond9    := GetNewPar("MV_DATAINF",.F.)
Local cCarga    := ""
Local lPedSemAd := .F.
Local aPedSemAd := {}
Local aPedAdt := {}
Local lValidouAdt := .T.
Local nCnt := 0
Local nAcresTot := 0
Local nPosAcres := 0
Local aAcresTot := {}
Local aAreaSC9Adt
Local aAreaSC5Adt
Local aAreaSC6Adt
Local nPosAdt := 0
Local lLeiSP  := .F.

#IFDEF TOP
    Local cDbMs    := ""
#ENDIF  

Default dDataMoe := dDataBase

Private cFilOpl := cFilAnt //-- Uso SIGAOMS - Tratamento para Filial Operador Logistico

If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif

lCond9   := IIf(ValType(lCond9)<>"L",.F.,lCond9)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atendendo legislacao do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08,desenvolvido pelo CONFAZ|               |
//³o modulo Front-loja/SigaLoja (rotina Venda Assistida) sao unicas interfaces Protheus a permitirem emissao de cupom fiscal.        | 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lECF := .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pontos de Entrada                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( ExistTemplate("M460MARK") )
    lExecuta := ExecTemplate("M460MARK",.F.,.F.,{ThisMark(),ThisInv()})
EndIf 

IF nModulo == 72
    lExecuta := KEXF720(ThisMark(),ThisInv())
Endif

If ( ExistBlock("M460MARK") )
    lExecuta := ExecBlock("M460MARK",.F.,.F.,{ThisMark(),ThisInv(),cSerie})
EndIf

If ( lExecuta )
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica a data de execucao                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If GetNewPar("MV_NFCHGDT",.F.)
        If MsDate()==dDataBase+1
            If Aviso( "O sistema identificou a troca da data do sistema operacional, deseja atualizar a data base do sistema?", "Sim", {"Sim","Nao"}, 2 )==1 //"O sistema identificou a troca da data do sistema operacional, deseja atualizar a data base do sistema?"###"Sim","Nao"
                dDataBase := MsDate()
            EndIf
        EndIf
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Inicializa a filtragem da MarkBrowse                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Do Case
    Case cTabela == "SC9"
        If ( lInverte )
            cFilSC9 += ".And.C9_OK<>'"+cMarca+"'"
            cQrySC9    += " AND SC9.C9_OK<>'"+cMarca+"'"
        Else
            cFilSC9 += ".And.C9_OK=='"+cMarca+"'"
            cQrySC9    += " AND SC9.C9_OK='"+cMarca+"'"
        EndIf
        bWhile1 := {|| !Eof() .And. xFilial("SC9") == (cCursor1)->C9_FILIAL }
        bWhile2 := {|| !Eof() .And. xFilial("SC9") == (cCursor2)->C9_FILIAL }
        bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL }
    Case cTabela == "DAK"
        If ( lInverte )
            cFilBrw += ".And.DAK_OK<>'"+cMarca+"'"
            cQryBrw += " AND DAK_OK<>'"+cMarca+"'"
        Else
            cFilBrw += ".And.DAK_OK=='"+cMarca+"'"
            cQryBrw    += " AND DAK_OK='"+cMarca+"'"
        EndIf
        cFilBrw += ".AND.DAK_FEZNF<>'1' "
        cQryBrw += " AND DAK_FEZNF<>'1' "
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Verifica a necessidade do DAI                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If ( lFilDAK )
            cCursor2:= "DAI"
            cQryBrw += "AND DAI.DAI_FILIAL='"+xFilial("DAI")+"' "
            cQryBrw += "AND DAI.DAI_COD=DAK.DAK_COD "
            cQryBrw += "AND DAI.DAI_SEQCAR=DAK.DAK_SEQCAR "
            cQryBrw += "AND DAI.D_E_L_E_T_ = ' ' "
            cQryBrw += "AND DAI.DAI_PEDIDO = SC9.C9_PEDIDO "
            bWhile1 := {|| !Eof()}
            bWhile2 := {|| !Eof() .And. (cCursor2)->DAI_FILIAL == xFilial("DAI") .AND. (cCursor2)->DAI_COD==(cCursor1)->DAK_COD .And. (cCursor2)->DAI_SEQCAR==(cCursor1)->DAK_SEQCAR}
            bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .And. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR}
            If lFilDAK
                cFldQry := ",DAI.DAI_FILIAL,DAI.DAI_COD,DAI.DAI_SEQCAR,DAI.DAI_FILPV,DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.DAK_PTOENT,DAK.R_E_C_N_O_ DAKRECNO "
            Else
                cFldQry := ",DAI.DAI_FILIAL,DAI.DAI_COD,DAI.DAI_SEQCAR,DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.DAK_PTOENT,DAK.R_E_C_N_O_ DAKRECNO "
            EndIf
        Else
            bWhile1 := {|| !Eof() }
            bWhile2 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .AND. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR }
            bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .AND. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR}
            cFldQry := ",DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.DAK_PTOENT,DAK.R_E_C_N_O_ DAKRECNO "
        EndIf
    EndCase
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica qual a Ordem em que a NFS deve ser gerada                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !lFilDAK
        cKeySC9 += "C9_CARGA+C9_SEQCAR+"
        cKeySC9 += "C9_FILIAL+C9_SEQENT+C9_AGREG+"
    Else
        cKeySC9 += "C9_CARGA+C9_SEQCAR+C9_SEQENT+"
        cKeySC9 += "C9_AGREG+"
    EndIf
    If lJunta
        cKeySC9 += "C9_CLIENTE+C9_LOJA+"
    EndIf
    cKeySC9 += "C9_PEDIDO+"
    If ( lLibGrupo )
        cKeySC9 += "C9_GRUPO+"
    EndIf  
    If SC9->(FieldPos("C9_RETOPER")) > 0 .And. SB1->(FieldPos("B1_RETOPER")) > 0
        cKeySC9 += "C9_RETOPER+"
    Endif
    If SC9->(FieldPos("C9_CODISS")) > 0 .And. GetNewPar("MV_NFEQUEB",.F.)
        cKeySC9 += "C9_CODISS+"
    Endif
    dbSelectArea("SC9")
    dbSetOrder(nOrdNFS)
    cKeySC9 += IndexKey()
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Retira os itens duplicados da ordem de Geracao da NFS                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cAuxKey := cKeySC9
    cKeySC9 := ""
    While ( (nPosKey:=At("+",cAuxKey))<>0 )
        If ( !SubStr(cAuxKey,1,nPosKey-1)$cKeySC9 )
            cKeySC9 += "+"+SubStr(cAuxKey,1,nPosKey-1)
        EndIf
        cAuxKey := SubStr(cAuxKey,nPosKey+1)
    EndDo
    If ( !cAuxKey$cKeySC9 )
        cKeySC9 += "+"+cAuxKey
    EndIf
    cKeySC9 := SubStr(cKeySC9,2)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Realiza a Selecao do SC9 e da Tabela da Markbrowse se esta existir      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    #IFDEF TOP

        cDbMs := UPPER(TcGetDb())

        If ( TcSrvType()<>"AS/400" .And. cDbMs<>"POSTGRES" )
            cAuxKey := cQrySC9
            cQrySC9 := ""
            cCursor1:= "MA460PROC"
            cCursor2:= cCursor1
            cCursor3:= cCursor2
            lQuery  := .T.
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Montagem dos campos do SC9                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SC9")
            For nCntFor := 1 To FCount()
                cQrySC9 += ","+FieldName(nCntFor)
            Next nCntFor
            Do Case
            Case "ORACLE"==Upper(TcGetDb())
                cQrySC9 := "SELECT DISTINCT /*+FIRST_ROWS*/ "+SubStr(cQrySC9,2)
            Case "CACHE"==Upper(TcGetDb())
                cQrySC9 := "SELECT "+SubStr(cQrySC9,2)
            OtherWise
                cQrySC9 := "SELECT DISTINCT "+SubStr(cQrySC9,2)
            EndCase
            cQrySC9 += ",SC9.R_E_C_N_O_ C9RECNO "
            cQrySC9 += ",SC5.R_E_C_N_O_ C5RECNO "
            cQrySC9 += ",SC6.R_E_C_N_O_ C6RECNO, SC6.C6_QTDENT, SC6.C6_QTDVEN "
            cQrySC9 += ",SE4.R_E_C_N_O_ E4RECNO "
            cQrySC9 += ",SB1.R_E_C_N_O_ B1RECNO "
            cQrySC9 += ",SB2.R_E_C_N_O_ B2RECNO "
            cQrySC9 += ",SF4.R_E_C_N_O_ F4RECNO "
            cQrySC9 += ",SF4.F4_ISS F4ISS, SF4.F4_QTDZERO, SF4.F4_ESTOQUE "
            cQrySC9 += ",SC5.C5_MOEDA "
            cQrySC9 += ",SC5.C5_DATA1 "
            cQrySC9 += cFldQry
            If ( lJunta )
                cVendedor := "1"
                For nCntfor := 1 To nNrVend
                    cQrySC9 += ",SC5.C5_VEND"+cVendedor
                    If SC5->(FieldPos("C5_CODRL"+cVendedor)) > 0
                        cQrySC9 += ",SC5.C5_CODRL"+cVendedor
                    EndIf
                    cVendedor := Soma1(cVendedor,1)
                Next nCntFor
                cQrySC9 += ",SC5.C5_TIPO,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPOCLI,SC5.C5_LOJAENT,SC5.C5_REAJUST,SC5.C5_CONDPAG,SC5.C5_INCISS,SC5.C5_TRANSP,SC5.C5_TPFRETE,"
                If SC5->(FieldPos("C5_CLIENT"))>0
                    cQrySC9 += "SC5.C5_CLIENT,"
                EndIf
                If SC5->(FieldPos("C5_FORNISS"))>0
                    cQrySC9 += "SC5.C5_FORNISS,"
                EndIf
                If SC5->(FieldPos("C5_RECISS"))>0
                    cQrySC9 += "SC5.C5_RECISS,"
                EndIf
                cQrySC9 += "SE4.E4_TIPO,SB2.B2_LOCAL "
            Else
                cQrySC9 += ",SC5.C5_TIPO,SB2.B2_LOCAL "
            EndIf
            cQrySC9 += "FROM "+RetSqlName("SC9")+" SC9 ,"
            If ( cTabela <> "SC9" )
                cQrySC9 += RetSqlName(cTabela)+" "+cTabela+","
                If ( lFilDAK )
                    cQrySC9 += RetSqlName("DAI")+" DAI,"
                Endif
            EndIf
            cQrySC9 += RetSqlName("SC5")+" SC5 ,"
            cQrySC9 += RetSqlName("SC6")+" SC6 ,"
            cQrySC9 += RetSqlName("SE4")+" SE4 ,"
            cQrySC9 += RetSqlName("SB1")+" SB1 ,"
            cQrySC9 += RetSqlName("SB2")+" SB2 ,"
            cQrySC9 += RetSqlName("SF4")+" SF4  "
            cQrySC9 += "WHERE "
            If cTabela <> "SC9"
                cQrySC9 += cQryBrw+" AND "+cAuxKey
            Else
                cQrySC9 += cAuxKey
            EndIf
            cQrySC9 += " AND SC9.C9_BLCRED='"+Space(Len(SC9->C9_BLCRED))+"'"
            cQrySC9 += " AND SC9.C9_BLEST='"+Space(Len(SC9->C9_BLEST))+"'"
            cQrySC9 += " AND SC9.C9_BLWMS IN('  ','05','06','07') "

            cQrySC9 += " AND SC9.C9_AGREG>='"+cAgregI+"'"
            cQrySC9 += " AND SC9.C9_AGREG<='"+cAgregF+"'"
            cQrySC9 += " AND SC9.D_E_L_E_T_=' ' "
            cQrySC9 += " AND SC5.C5_FILIAL="+IIF(lFilDAK,OsFilQry("SC5","DAI.DAI_FILPV"),"'"+xFilial("SC5")+"'")
            cQrySC9 += " AND SC5.C5_NUM=SC9.C9_PEDIDO"
            cQrySC9 += " AND SC5.C5_TRANSP>='"+cTranspI+"'"
            cQrySC9 += " AND SC5.C5_TRANSP<='"+cTranspF+"'"
            cQrySC9 += " AND SC5.D_E_L_E_T_=' '"
            cQrySC9 += " AND SC6.C6_FILIAL="+IIf(lFilDAK,OsFilQry("SC6","DAI.DAI_FILPV"),"'"+xFilial("SC6")+"'")
            cQrySC9 += " AND SC6.C6_NUM=SC9.C9_PEDIDO"
            cQrySC9 += " AND SC6.C6_ITEM=SC9.C9_ITEM"
            cQrySC9 += " AND SC6.C6_PRODUTO=SC9.C9_PRODUTO"
            cQrySC9 += " AND SC6.D_E_L_E_T_=' '"
            cQrySC9 += " AND SE4.E4_FILIAL="+IIf(lFilDAK,OsFilQry("SE4","DAI.DAI_FILPV"),"'"+xFilial("SE4")+"'")
            cQrySC9 += " AND SE4.E4_CODIGO=SC5.C5_CONDPAG "
            cQrySC9 += " AND SE4.D_E_L_E_T_=' '"
            cQrySC9 += " AND SB1.B1_FILIAL="+IIf(lFilDAK,OsFilQry("SB1","DAI.DAI_FILPV"),"'"+xFilial("SB1")+"'")
            cQrySC9 += " AND SB1.B1_COD=SC9.C9_PRODUTO"
            cQrySC9 += " AND SB1.D_E_L_E_T_=' '"
            cQrySC9 += " AND SB2.B2_FILIAL="+IIf(lFilDAK,OsFilQry("SB2","DAI.DAI_FILPV"),"'"+xFilial("SB2")+"'")
            cQrySC9 += " AND SB2.B2_COD=SC9.C9_PRODUTO"
            cQrySC9 += " AND SB2.B2_LOCAL=SC9.C9_LOCAL"
            cQrySC9 += " AND SB2.D_E_L_E_T_=' '"
            cQrySC9 += " AND SF4.F4_FILIAL="+IIf(lFilDAK,OsFilQry("SF4","DAI.DAI_FILPV"),"'"+xFilial("SF4")+"'")
            cQrySC9 += " AND SF4.F4_CODIGO=SC6.C6_TES"
            cQrySC9 += " AND SF4.D_E_L_E_T_=' '"
            If lFilDAK
                cKeySC9 := StrTran(cKeySC9,"C9_PEDIDO","DAI_FILPV,C9_PEDIDO")
            EndIf
            cQrySC9 += " ORDER BY "+SqlOrder(cKeySC9)

            cQrySC9 := ChangeQuery(cQrySC9)
            //MEMOWRIT("\MATA461A.SQL",cQrySC9)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC9),cCursor3,.F.,.T.)
            aEval(SC9->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cCursor3,x[1],x[2],x[3],x[4]),Nil)})
        Else
    #ENDIF
        If ( cTabela <> "SC9" )
            cArqBrw := CriaTrab(,.F.)
            IndRegua(cTabela,cArqBrw,(cTabela)->(IndexKey()),,cFilBrw)
            nIndBrw := RetIndex(cTabela)
            #IFNDEF TOP
                dbSetOrder(1)
                Eval(bFiltraBrw)
                nIndBrw += Len(aFiltro[5])
                dbSetIndex(cArqBrw+OrdBagExt())
            #ENDIF
            dbSetOrder(nIndBrw+1)
            dbGotop()
        EndIf
        cArqSC9 := CriaTrab(,.F.)
        IndRegua("SC9",cArqSC9,cKeySC9,,cFilSC9)
        nIndSC9 := RetIndex("SC9")
        #IFNDEF TOP
            If cTabela == "SC9"
                dbSetOrder(1)
                Eval(bFiltraBrw)
                nIndSC9 += Len(aFiltro[5])
            Endif
            dbSetIndex(cArqSC9+OrdBagExt())
        #ENDIF
        dbSetOrder(nIndSC9+1)
        dbGotop()
        #IFDEF TOP
        EndIf
        #ENDIF
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Seta a regua de processamento das notas fiscais                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ProcRegua((cTabela)->(LastRec()))
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica as condicoes de quebra de nota fiscal                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lFilDAK
        aadd(aQuebra2,{"DAI->DAI_FILPV",})
    EndIf
    If ( lJunta )
        aadd(aQuebra,{"SC9->C9_AGREG",})
        aadd(aQuebra,{"SC9->C9_CARGA",})
        aadd(aQuebra,{"SC9->C9_SEQCAR",})
        aadd(aQuebra,{"SC5->C5_TIPO",})
        aadd(aQuebra,{"SC5->C5_CLIENTE",})
        aadd(aQuebra,{"SC5->C5_LOJACLI",})
        aadd(aQuebra,{"SC5->C5_TIPOCLI",})
        If SC5->(FieldPos("C5_CLIENT"))>0
            aadd(aQuebra,{"SC5->C5_CLIENT",})
        EndIf
        aadd(aQuebra,{"SC5->C5_LOJAENT",})
        aadd(aQuebra,{"SC5->C5_REAJUST",})
        aadd(aQuebra,{"SC5->C5_CONDPAG",})
        aadd(aQuebra,{"SC5->C5_INCISS",})
        aadd(aQuebra,{"SC5->C5_TRANSP",})
        aadd(aQuebra,{"SC5->C5_TPFRETE",})
        If SC5->(FieldPos("C5_FORNISS"))<>0
            aadd(aQuebra,{"SC5->C5_FORNISS",})
        EndIf
        cVendedor := "1"
        For nCntfor := 1 To nNrVend
            aadd(aQuebra,{"SC5->C5_VEND"+cVendedor,})
            If SC5->(FieldPos("C5_CODRL"+cVendedor))>0
                aadd(aQuebra,{"SC5->C5_CODRL"+cVendedor,})
            EndIf
            cVendedor := Soma1(cVendedor,1)
        Next nCntFor
        If SC5->(FieldPos("C5_RECISS"))>0
            aadd(aQuebra,{"SC5->C5_RECISS",})
        EndIf
    Else
        aadd(aQuebra,{"SC9->C9_CARGA",})
        aadd(aQuebra,{"SC9->C9_SEQCAR",})
        aadd(aQuebra,{"SC9->C9_AGREG",})
        aadd(aQuebra,{"SC9->C9_PEDIDO",})
    EndIf
    If SC9->(FieldPos("C9_CODISS")) > 0 .And. GetNewPar("MV_NFEQUEB",.F.)
        aadd(aQuebra3,{"SC9->C9_CODISS",})
    Endif
    dbSelectArea("SA1")
    dbSetOrder(1)
    MsSeek(xFilial("SA1")+(cCursor3)->(C9_CLIENTE+C9_LOJA))
    If SC9->(FieldPos("C9_RETOPER")) > 0 .And. SB1->(FieldPos("B1_RETOPER")) > 0 .And. (SA1->A1_RECCOFI=="S" .Or. SA1->A1_RECPIS=="S")
        If lQuery
            aadd(aQuebra,{"     Iif("+cCursor3+"->C9_RETOPER=='1' .And. (SB1->B1_PIS=='1' .Or. SB1->B1_COFINS=='1'),'1','2')",})
        Else
            aadd(aQuebra,{"Iif(SC9->C9_RETOPER=='1' .And. (SB1->B1_PIS=='1' .Or. SB1->B1_COFINS=='1' ),'1','2')",})
        EndIf
    Endif
    If ( lQuery )
        aEval(aQuebra ,{|x| x[1]:= SubStr(x[1],6)})
        aEval(aQuebra2,{|x| x[1]:= SubStr(x[1],6)})
        aEval(aQuebra3,{|x| x[1]:= SubStr(x[1],6)})
    EndIf   
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Processa o Arquivo do Browse                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea(cCursor1)
    While Eval(bWhile1)
        Do Case
        Case cCursor2 == "DAI" .And. cTabela == "DAK"
            DAK->(dbSkip())
            nRecDAK := DAK->(Recno())
            DAK->(dbSkip(-1))
        
            dbSelectArea(cCursor2)
            dbSetOrder(1)
            MsSeek(xFilial("DAI")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)

        Case cCursor2 == "SC9" .And. cTabela == "DAK"
            DAK->(dbSkip())
            nRecDAK := DAK->(Recno())
            DAK->(dbSkip(-1))

            If !lQuery
                dbSelectArea(cCursor3)
                dbSetOrder(nIndSC9+1)
                MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
            EndIf
        EndCase
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Processa a tabela vinculada ao browse                                   ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        dbSelectArea(cCursor2)
        While Eval(bWhile2)
            If cTabela == "DAK"
                //-- Uso SIGAOMS - Tratamento para Filial Operador Logistico
                If lFilDAK
                    //-- Verifica a Filial na qual deve ser gerada a Nota Fiscal de Saida
                    If  cFilAnt <> (cCursor2)->DAI_FILPV
                        cFilAnt := (cCursor2)->DAI_FILPV
                        MaNFSEnd()
                        MaNFSInit()
                    EndIf
                EndIf
                If !lQuery
                    dbSelectArea(cCursor3)
                    dbSetOrder(nIndSC9+1)
                    MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
                    If cCursor2 <> cCursor3
                        (cCursor2)->(dbSkip())
                    EndIf
                EndIf
            EndIf
            dbSelectArea(cCursor3)
            While Eval(bWhile3)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Posiciona Registros                                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( !lQuery )
                    dbSelectArea("SB1")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

                    dbSelectArea("SC5")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

                    dbSelectArea("SC6")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

                    dbSelectArea("SB2")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

                    dbSelectArea("SF4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SF4")+SC6->C6_TES)

                    dbSelectArea("SE4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)                                                                                
                EndIf
                dbSelectArea(cCursor3)
                lConfirma := .T.
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Atualiza os itens de Quebra                                             ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                aEval(aQuebra, {|x| x[2] := &(x[1])})
                aEval(aQuebra2,{|x| x[2] := &(x[1])})
                aEval(aQuebra3,{|x| x[2] := &(x[1])})
                If !Empty(aQuebra3)
                    If lQuery
                        If !Empty((cCursor3)->C9_CODISS)
                            aAdd(aNfCodISS,(cCursor3)->C9_CODISS)
                        EndIf
                    Else
                        If !Empty(SC9->C9_CODISS)
                            aAdd(aNfCodISS,SC9->C9_CODISS)
                        EndIf
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Inicializa as variaveis de quebra do SC9                                ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If lQuery
                    cPedido := (cCursor3)->C9_PEDIDO
                    If lJunta
                        cTipo9  := (cCursor3)->E4_TIPO
                    EndIf
                Else
                    cPedido := SC9->C9_PEDIDO
                    If lJunta
                        cTipo9  := SE4->E4_TIPO
                    EndIf
                EndIf

                // Verifica se bloqueia faturamento quando o 1o vencto < emissao da NF
                // na cond.pgto tipo 9. MV_DATAINF(T = Bloqueia , F = Fatura)
                // Bloqueia faturamento se a moeda nao estiver cadastrada
                If lQuery
                    If ( lCond9 .And. (cCursor3)->C5_DATA1 < (dtos(dDataBase)) .And. !Empty((cCursor3)->C5_DATA1) );
                        .Or. (xMoeda( 1, (cCursor3)->C5_MOEDA, 1, dDataMoe, TamSX3("M2_MOEDA2")[2] ) = 0)
                        lConfirma:= .F.
                        If ( xMoeda( 1, (cCursor3)->C5_MOEDA, 1, dDataMoe, TamSX3("M2_MOEDA2")[2] ) = 0 )
                            lTxMoeda := .T.
                        EndIf                           
                    EndIf
                Else
                    If ( lCond9 .And. SC5->C5_DATA1 < dDataBase .And. !Empty(SC5->C5_DATA1) );
                        .Or. ( xMoeda( 1, SC5->C5_MOEDA, 1, dDataMoe, TamSX3("M2_MOEDA2")[2] ) = 0)
                        lConfirma:= .F.
                        If ( xMoeda( 1, (cCursor3)->C5_MOEDA, 1, dDataMoe, TamSX3("M2_MOEDA2")[2] ) = 0 )
                            lTxMoeda := .T.
                        EndIf                           
                    EndIf
                EndIf 
                
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³P.E . para exibir mensagem com motivo de não faturar de acordo com parametro MV_DATAINF³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !(lConfirma) .And. lCond9 .And. ExistBlock( "M461DINF" ) 
                    ExecBlock( "M461DINF", .f., .f. ) 
                EndIf
                
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Efetua a selecao dos registros                                          ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( !lQuery )
                    If !( SC9->C9_AGREG >= cAgregI .And. SC9->C9_AGREG <= cAgregF .And.;
                            SC5->C5_TRANSP >= cTranspI .And. SC5->C5_TRANSP <= cTranspF .And.;
                            IIf(cTabela=="SC9",IsMark("C9_OK",cMarca,lInverte),.T.) .And.;
                            SC9->C9_BLCRED==Space(Len(SC9->C9_BLCRED)) .And.;
                            SC9->C9_BLWMS$"05/06/07/  " .And.;
                            SC9->C9_BLEST==Space(Len(SC9->C9_BLEST)) )
                        lConfirma:= .F.
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Avalia a Expressao cCondicao                                            ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( !Empty(cCondicao) )
                    If ( !(&cCondicao) )
                        lConfirma := .F.
                    EndIf
                EndIf
                If ( lConfirma )
                    nPrcVen   := C9_PRCVEN
                    aTravas   := {}
                    lSemSaldo := .F.
                    lAtuEst   := IIf(lQuery,(cCursor3)->F4_ESTOQUE=="S",SF4->F4_ESTOQUE=="S")
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Verifica se o produto est  sendo inventariado  ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If lAtuEst .And. BlqInvent(C9_PRODUTO,C9_LOCAL,,,SC9->(Recno()))
                        Help(" ",1,"BLQINVENT",,C9_PRODUTO+" Almox: "+C9_LOCAL,1,11)
                        lConfirma := .F.
                    EndIf
                    If ( lConfirma )
                        If ( !lQuery )
                            dbSelectArea("SC5")
                        EndIf
                        If ( C5_MOEDA <> 1 )
                            nPrcVen := a410Arred(xMoeda(nPrcVen,C5_MOEDA,1,dDataMoe,8),"D2_PRCVEN")
                        EndIf
                        If ( !lQuery )
                            dbSelectArea("SC9")
                        EndIf
                        If nPrcVen <> 0
                            If Ma461QIsOk(aPvlNfs,IIf(!lQuery,"SC6",cCursor3),IIf(!lQuery,"SC9",cCursor3)) .And. A461Saldo(C9_PEDIDO,C9_ITEM,C9_PRODUTO,C9_LOCAL,C9_QTDLIB,C9_QTDLIB2,C9_LOTECTL,C9_NUMLOTE,@aTravas,@lSemSaldo,lAtuEst)
    
                                // Nao permite D2_TOTAL zerado (quando utilziado D2_PRCVEN muito baixo, sistema estava
                                // gravando D2_TOTAL zerado.
                                lTotZero := .F.
                                If lQuery
                                    If !((cCursor3)->C5_TIPO $ "CIP") .And. (cCursor3)->F4_QTDZERO <> "1" .And. a410Arred((cCursor3)->C9_QTDLIB*nPrcVen, "D2_TOTAL") == 0
                                        lTotZero := .T.
                                    EndIf
                                Else
                                    If !(SC5->C5_TIPO $ "CIP") .And. SF4->F4_QTDZERO <> "1" .And. a410Arred(SC9->C9_QTDLIB*nPrcVen, "D2_TOTAL") == 0
                                        lTotZero := .T.
                                    EndIf
                                EndIf
                                If  !lTotZero
                                    aadd(aPvlNfs,{ C9_PEDIDO,;
                                        C9_ITEM,;
                                        C9_SEQUEN,;
                                        C9_QTDLIB,;
                                        nPrcVen,;
                                        C9_PRODUTO,;
                                        If(lQuery,F4ISS=="S",SF4->F4_ISS=="S"),;
                                        If(lQuery,C9RECNO,SC9->(RecNo())),;
                                        If(lQuery,C5RECNO,SC5->(RecNo())),;
                                        If(lQuery,C6RECNO,SC6->(RecNo())),;
                                        If(lQuery,E4RECNO,SE4->(RecNo())),;
                                        If(lQuery,B1RECNO,SB1->(RecNo())),;
                                        If(lQuery,B2RECNO,SB2->(RecNo())),;
                                        If(lQuery,F4RECNO,SF4->(RecNo())),;
                                        If(lQuery,B2_LOCAL,SB2->B2_LOCAL),;
                                        If(cTabela<>"DAK",0,If(lQuery,DAKRECNO,DAK->(RecNo()))),;
                                        C9_QTDLIB2})
                                Endif
                            Else
                                If lSemSaldo
                                    aAdd(aSemSaldo,{C9_PEDIDO,C9_ITEM,C9_SEQUEN})
                                Else
                                    lAcima := .T.
                                EndIf   
                            EndIf
                        Else
                            lTxMoeda := .T.
                        EndIf
                    EndIf
                EndIf
                If  cTabela == "DAK" .And. (cCursor1)->DAK_COD <> cCarga
                    cCarga := (cCursor1)->DAK_COD
                    ProcRegua((cCursor1)->DAK_PTOENT)
                EndIf
                dbSelectArea(cCursor3)
                dbSkip()
                If  cTabela == "SC9"
                    IncProc(OemToAnsi("Preparados os Doc's: ")+": "+cSerie+"/"+cNota) //"Preparados os Doc's: "
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Posiciona Registros                                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( !lQuery )
                    dbSelectArea("SB1")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

                    dbSelectArea("SC5")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

                    dbSelectArea("SC6")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

                    dbSelectArea("SB2")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

                    dbSelectArea("SF4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SF4")+SC6->C6_TES)

                    dbSelectArea("SE4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
                EndIf

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Verifica a quebra                                                       ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                lQuebra := .F.
                If ( aScan(aQuebra,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )             
                    lQuebra := .T.
                ElseIf ( aScan(aQuebra2,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )
                    lQuebra := .T.
                ElseIf ( aScan(aQuebra3,{|x| If(x[2] <> Nil,&(x[1])<>x[2].And.!Empty(&(x[1])).And.!Empty(x[2]),.F.) }) <> 0 ) .Or.;
                       ( If(!Empty(aNfCodISS).And.!Empty(If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)),aScan(aNfCodISS,If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)) == 0,.F.) )
                    //Quando nao for NF Conjugada faz a quebra pelo codigo do ISS
                    aNfCodIss:= {}
                    lQuebra  := .T.
                EndIf

                If ( lJunta )
                    If ( !lQuery )
                        dbSelectArea("SE4")
                    EndIf
                    If ( E4_TIPO=="9" .Or. cTipo9=="9" )
                        If cPedido <> (cCursor3)->C9_PEDIDO
                            lQuebra := .T.
                        EndIf
                    EndIf
                EndIf
                If ( Len(aPvlNfs) >= nItemNf )
                    lQuebra := .T.
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Efetua a Geracao da Nfs                                                 ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                dbSelectArea(cCursor3)
                If ( lQuebra .Or. ( !Eval(bWhile3) .And. !Eval(bWhile2) ) )
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Verifica a quebra por numero de itens de nota fiscal                    ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    aEval(aPvlNfs,{|x| nTotal += a410Arred(If(x[4]<>0,x[4],1)*x[5],"D2_TOTAL")})

                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Ponto de entrada para verificar o valor total da nota                   ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If lM461VTot
                        lGeraVTot := ExecBlock("M461VTOT",.F.,.F.,{nTotal,aPvlNfs[Len(aPvlNfs),11]})
                        If ValType(lGeraVTot) <> "L"
                            lGeraVTot := .T.
                        Endif
                    Endif

                    #IFDEF TOP
                        If cPaisLoc $ "BRA|MEX" .and. FunName() = "MATA460A" .and. AliasInDic("FIE") .and. AliasInDic("FR3")
                            aAreaSC5Adt := SC5->(GetArea())
                            If A410UsaAdi(SC5->C5_CONDPAG)
                                RestArea(aAreaSC5Adt)
                                aAreaSC9Adt := SC9->(GetArea())
                                aAreaSC5Adt := SC5->(GetArea())
                                aAreaSC6Adt := SC6->(GetArea())
                                aPedAdt := {}
                                /*
                                estrutura array aPedAdt
                                1 - C9_PEDIDO
                                2 - C5_CONDPAG
                                3 - C9_CLIENTE
                                4 - C9_LOJA
                                5 - TES do pedido gera duplicata
                                */
                                nAcresTot := 0
                                aAcresTot := {}
                                For nCnt:=1 To Len(aPvlNfs)
                                    SC9->(MsGoto(aPvlNfs[nCnt][8])) 
                                    SC5->(MsGoto(aPvlNfs[nCnt][9])) 
                                    SC6->(MsGoto(aPvlNfs[nCnt][10]))    
                                    nPosAdt := aScan(aPedAdt,{|x| x[1]+x[2]+x[3]+x[4] = SC9->C9_PEDIDO+SC5->C5_CONDPAG+SC9->C9_CLIENTE+SC9->C9_LOJA})
                                    If nPosAdt = 0
                                        aAdd(aPedAdt,{SC9->C9_PEDIDO,SC5->C5_CONDPAG,SC9->C9_CLIENTE,SC9->C9_LOJA,AvalTes(SC6->C6_TES,,"S")})
                                    Else
                                        If !aPedAdt[nPosAdt][5]     
                                            aPedAdt[nPosAdt][5] := AvalTes(SC6->C6_TES,,"S")
                                        Endif   
                                    Endif   
                                    // calcula o acrescimo financeiro para os itens liberados deste pedido
                                    nAcresTot := MaAcreFinAdt(aPvlNfs,nCnt,MV_PAR05==1,dDataMoe)
                                    // gera array com valores de acrescimo para cada pedido
                                    nPosAcres := aScan(aAcresTot,{|x| x[1] = aPvlNfs[nCnt][1]})
                                    If nPosAcres = 0
                                        aAdd(aAcresTot,{aPvlNfs[nCnt][1],nAcresTot})
                                    Else
                                        aAcresTot[nPosAcres][2] += nAcresTot
                                    Endif       
                                Next nCnt   
                                RestArea(aAreaSC5Adt)
                                RestArea(aAreaSC6Adt)
                                RestArea(aAreaSC9Adt)
                                // avalia cada pedido em separado, para checar se hah algum adiantamento relacionado ao pedido
                                For nCnt:=1 To Len(aPedAdt)
                                    If aScan(aPedSemAd,aPedAdt[nCnt][1]) <= 0
                                        If aPedAdt[nCnt][5] // somente valida valor do adiantamento se algum item liberado neste pedido tem TES que gera duplicata
                                            nAcresTot := aAcresTot[aScan(aAcresTot,{|x| x[1] = aPedAdt[nCnt][1]})][2]
                                            lPedSemAd := A461NAdian(aPedAdt[nCnt][1],aPedAdt[nCnt][2],aPvlNfs,.F.,.F.,aPedAdt[nCnt][3],aPedAdt[nCnt][4],{},nAcresTot)
                                            If !lPedSemAd
                                                aAdd(aPedSemAd,aPedAdt[nCnt][1])
                                                lValidouAdt := .F.
                                                //Exit
                                            Else
                                                lValidouAdt := .T.
                                                Exit // se validou um pedido nao precisa validar o restante.
                                            Endif       
                                        Endif   
                                    Endif
                                Next nCnt
                            EndIf
                        Endif   
                    #ENDIF
                                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Decreto Nº 54.869, de 2 de outubro de 2009 do Estado de São Paulo      ³
                    //³ Atingido o valor máximo do cupom fiscal: 10.000,00.                    ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    lLeiSP := .F.
                    If lECF .And. nTotal > 10000 .And. LjAnalisaLeg(51)[1]
                        aAdd(aPedDecret,cPedido)
                        lLeiSP := .T.
                    EndIf
                                    
                    If ( nTotal > nFatMin .And. !Empty(aPvlNfs) .And. lGeraVTot .and. lValidouAdt .And. !lLeiSP)
                        dbSelectArea("SC9")
                        cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,,,,,,dDataMoe)
                    EndIf
                    nTotal  := 0
                    aPvlNfs := {}
                    aNfCodISS := {}
                    lValidouAdt := .T.

                    If cTabela == "DAK"
                        IncProc(OemToAnsi("Preparados os Doc's: ")+": "+cCarga+" - "+cSerie+"/"+cNota) //"Preparados os Doc's: "
                    EndIf
                EndIf
                dbSelectArea(cCursor3)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Remove travas dos registros utilizados                  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                MaDesTrava(aTravas)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Controle de cancelamento do usuario                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If lEnd
                    Exit
                EndIf
            EndDo
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Controle de cancelamento do usuario                                     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

            //-- Uso SIGAOMS - Tratamento para Filial Operador Logistico
            If lFilDAK .And. cFilAnt <> cSavFil
                cFilAnt := cSavFil
            EndIf

            If lEnd
                Exit
            EndIf
        EndDo
        If ( cCursor1 <> cCursor2 )
            If (cCursor2 == "DAI" .Or. cCursor2 == "SC9") .And. cTabela == "DAK"
                dbSelectArea("DAK")
                DAK->(MSGoTo(nRecDAK))
            Else
                dbSelectArea(cCursor1)
                dbSkip()
            Endif   
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Controle de cancelamento do usuario                                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lEnd
            Exit
        EndIf
    EndDo
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Restaura a entrada da rotina                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ( lQuery )
        dbSelectArea(cCursor3)
        dbCloseArea()
        dbSelectArea("SC9")
    Else
        RetIndex("SC9")
        dbClearFilter()
        FErase(cArqSC9+OrdBagExt())
        If cTabela <> "SC9"
            RetIndex(cCursor1)
            dbClearFilter()
            FErase(cArqBrw+OrdBagExt())
        EndIf
        Eval(bFiltraBrw)
    EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento de mensagens                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTxMoeda
    Aviso("Mensagens","Alguns pedidos nao foram gerados pois nao existe taxa para a moeda",{"Alguns pedidos nao foram gerados pois nao existe taxa para a moeda"}) //"Mensagens"###"Alguns pedidos nao foram gerados pois nao existe taxa para a moeda"
EndIf
If lAcima
    Aviso("Mensagens","Alguns itens dos pedidos nao foram gerados pois a Qtd.Vendida e menor que a liberada!",{"Alguns itens dos pedidos nao foram gerados pois a Qtd.Vendida e menor que a liberada!"}) //"Mensagens" //"Alguns itens dos pedidos nao foram gerados pois a Qtd.Vendida e menor que a liberada!"
EndIf
If lTotZero
    Aviso("Mensagens","Alguns itens dos pedidos nao foram gerados pois o valor total do item esta igual a zero",{"Alguns itens dos pedidos nao foram gerados pois o valor total do item esta igual a zero"}) //"Mensagens" //"Alguns itens dos pedidos nao foram gerados pois o valor total do item esta igual a zero"
EndIf 
If lSemSaldo
    cString += "Os itens abaixo não foram gerados devido a falta de quantidade disponivel do produto em estoque. Verificar o saldo disponivel em estoque para os itens abaixo: "+Chr(13)+Chr(10)+Chr(13)+Chr(10) //"Os itens abaixo não foram gerados devido a falta de quantidade disponivel do produto em estoque. Verificar o saldo disponivel em estoque para os itens abaixo: "
    For nCntFor := 1 To Len(aSemSaldo)
        cString += "Nro.Pedido: " + aSemSaldo[nCntFor,1] + " / " + "Item : " + aSemSaldo[nCntFor,2] + " / " + "Sequencia: " + aSemSaldo[nCntFor,3] + Chr(13)+Chr(10) //"Nro.Pedido: " ###### "Item : " ### "Sequencia: " ###
    Next nCntFor 
    Aviso("Mensagens",cString,{"Mensagens"}) //"Mensagens" 
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea(aAreaSC9)
RestArea(aArea)

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaPvl2SD2 ³ Autor ³Eduardo Riera          ³ Data ³29.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao do Item da Nota Fiscal de Saida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Item da Nota Fiscal                                  ³±±
±±³          ³ExpA2: Array com o item do SC9 a ser Gerado                 ³±±
±±³          ³ExpA3: Array com o rateio das despesas acessorias           ³±±
±±³          ³ExpA4: Array aTitulo p/  controle do Financeiro             ³±±
±±³          ³ExpL5: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExpL6: Reajuste de Preco.                                   ³±±
±±³          ³ExpN7: Valor do Desconto ( Produto Negativo )               ³±±
±±³          ³ExpC8: Numero do Embarque de Exportacao                     ³±±
±±³          ³ExpC9: Array com as cargas a serem atualizadas              ³±±
±±³          ³ExpB1: Code Block de atualizacao do pedido de venda antes   ³±±
±±³          ³       da geracao da nota fiscal                            ³±±
±±³          ³ExpAA: Array contendo o contrato (GCT) relacionado ao       ³±±
±±³          ³       pedido                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaPvl2Sd2(cItemNf,aPvlNfs,aRateio,aTitulo,lAtuSa7,lReajuste,nValNeg,nItem,cEmbExp,aCarga,bAtuPvl,aContrato,aMedicao,aNfOriLot,cAliq,dDataMoe, nTotAcre)

Local aPvlSD2   := aPvlNfs[nItem]
Local aSolid    := {}
Local aSolidTmp        //Inicial este array com nil para validar somente apos utilização do ponto de entrada.
Local aPesoEmb  := {}
Local nMaxVend  := Fa440CntVen()
Local nCntFor   := 0
Local nComis    := 0
Local nPrcVen   := 0
Local nPrUnit   := 0
Local nAcresFin := 0
Local nTotal    := 0
Local ny        := 0
Local nDesconto := 0
Local nRecOri   := 0
Local nPosAIss  := 0
Local nAliqIss  := 0
Local cCliEnt   := ""
Local cVendedor := ""
Local cSeriOri  := ""
Local cNfOri    := ""
Local cNumSeq   := SF4->(ProxNum())
Local cItemOri  := ""
Local cIdentB6  := ""
Local cGrpCliTrb := NIL
Local cFilPv    := ""
Local cFilSav   := cFilAnt
Local lGrvVeic  := .F.      //Grava Veiculo
Local aAreaDAI  := {}
Local cMoedaTit := SuperGetMv("MV_MOEDTIT")
Local nMoeda    := 0
Local nMoedaNDF := 1
Local nTaxaNDF  := 0
Local aTransp   := {"",""}
Local lCfo      := .F.
Local nX        := 0 
Local lCAT83      := .F.

Local cEstado     := SuperGetMv("MV_ESTADO") 
Local cTesVend    := SuperGetMv("MV_TESVEND",,"")
Local nTotPed     := 0 

//Verifica se a funcionalidade Lista de Presente esta ativa e aplicada
Local lUsaLstPre := SuperGetMV("MV_LJLSPRE",,.F.) // .And. IIf(FindFunction("LjUpd78Ok"),LjUpd78Ok(),.F.)

Local lCtbIsCube    := FindFunction("CtbEntArr") .And. AliasInDic("CV0")
Local aEntidades    := {}
Local nEnt          := 0
Local nDeb          := 0

Default bAtuPvl  := {||.T.}
Default dDataMoe := dDataBase

//Gestao de Contratos
Default aContrato := {}
Default aMedicao  := {}
Default aNfOriLot := {}
Default cAliq   :=""    
Default nTotAcre    := 0

//Tratamento para saber o total antes de chamar a MATXFIS
aEval(aPvlNfs,{|x| nTotPed += a410Arred( x[5],"D2_TOTAL")})
nTotPed +=nTotAcre

If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
dbSetOrder(1)
MsGoto(aPvlSd2[8])

dbSelectArea("SC5")
dbSetOrder(1)
MsGoto(aPvlSD2[9])

dbSelectArea("SC6")
dbSetOrder(1)
MsGoto(aPvlSD2[10])

dbSelectArea("SE4")
dbSetOrder(1)
MsGoto(aPvlSd2[11])

dbSelectArea("SB1")
dbSetOrder(1)
MsGoto(aPvlSd2[12])

dbSelectArea("SB2")
dbSetOrder(1)
MsGoto(aPvlSd2[13])

dbSelectArea("SF4")
dbSetOrder(1)
MsGoto(aPvlSd2[14])

dbSelectArea("DAK")
dbSetOrder(1)
MsGoto(aPvlSd2[16])

dbSelectArea("SA4")
dbSetOrder(1)

nMoeda := SC5->C5_MOEDA
nMoeda := If(cMoedaTit=="S",nMoeda,1)

lCAT83   := SD2->(FieldPos("D2_CODLAN")) > 0 .And. SC6->(FieldPos("C6_CODLAN")) > 0 .And. SuperGetMV("MV_CAT8309",,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a relacao de impostos contidos no SF2 e SD2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nItem == 1
    If SC5->(FieldPos("C5_CLIENT"))>0
        cCliEnt := SC5->C5_CLIENT
    EndIf
    If Empty(cCliEnt)
        cCliEnt := SC5->C5_CLIENTE
    EndIf

    If ExistBlock( "M461GRP" )
        cGrpCliTrb := ExecBlock( "M461GRP", .f., .f. )
    EndIf

    If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
        aTransp[01] := SA4->A4_EST
        aTransp[02] := Iif(SA4->(FieldPos("A4_TPTRANS")) > 0,SA4->A4_TPTRANS,"")
    Endif
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³A Consultoria Tributária, por meio da Resposta à Consulta nº 268/2004, determinou a aplicação das seguintes alíquotas nas Notas Fiscais de venda emitidas pelo vendedor remetente:                                                                         ³
    //³1) no caso previsto na letra "a" (venda para SP e entrega no PR) - aplicação da alíquota interna do Estado de São Paulo, visto que a operação entre o vendedor remetente e o adquirente originário é interna;                                              ³
    //³2) no caso previsto na letra "b" (venda para o DF e entrega no PR) - aplicação da alíquota interestadual prevista para as operações com o Paraná, ou seja, 12%, visto que a circulação da mercadoria se dá entre os Estado de São Paulo e do Paraná.       ³
    //³3) no caso previsto na letra "c" (venda para o RS e entrega no SP) - aplicação da alíquota interna do Estado de São Paulo, uma vez que se considera interna a operação, quando não se comprovar a saída da mercadoria do território do Estado de São Paulo,³
    //³ conforme previsto no art. 36, § 4º do RICMS/SP                                                                                                                                                                                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If cEstado == 'SP' .And. SC5->(FieldPos("C5_CLIENT"))>0
        If !Empty(SC5->C5_CLIENT) .And. SC5->C5_CLIENT <> SC5->C5_CLIENTE
            For nX := 1 To Len(aPvlNfs)
                dbSelectArea("SC6")
                dbSetOrder(1)
                MsGoto(aPvlNfs[nX][10])
                If Alltrim(SC6->C6_TES)$ Alltrim(cTesVend)
                    lCfo:=  .T.
                EndIf
            Next 

            //Restauro a area anterior
            dbSelectArea("SC6")
            dbSetOrder(1)
            MsGoto(aPvlSD2[10])

            If lCfo
                dbSelectArea(IIF(SC5->C5_TIPO$"DB","SA2","SA1"))
                dbSetOrder(1)
                MsSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJAENT)
                If Iif(SC5->C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST) <> 'SP'
                     cCliEnt := SC5->C5_CLIENT
                Else
                    cCliEnt := SC5->C5_CLIENTE
                EndIf
            EndIf 
        EndIf
    EndIF
    dbSelectArea("SC5")
    MaFisIni(cCliEnt,SC5->C5_LOJAENT,If(SC5->C5_TIPO$'DB',"F","C"),SC5->C5_TIPO,SC5->C5_TIPOCLI,aRelImp,,,,'MATA461',,,,cGrpCliTrb,,,,;
                aTransp,,,SC6->C6_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,nTotPed)
    MaFisLoad("NF_ESPECIE",SF2->F2_ESPECIE)
    If !(SC5->C5_TIPO$'DB')
        If "CTR"$AllTrim(SF2->F2_ESPECIE) .OR. "NFST"$AllTrim(SF2->F2_ESPECIE)
            MaFisLoad("NF_PNF_COD",SC5->C5_CLIENTE)
            MaFisLoad("NF_PNF_LOJ",SC5->C5_LOJACLI)
            MaFisLoad("NF_PNF_UF" ,SA1->A1_EST)
            MaFisLoad("NF_PNF_TPCLIFOR",SA1->A1_TIPO)
        EndIf
        If SC5->(FieldPos("C5_NATUREZ"))>0 .And. !Empty(SC5->C5_NATUREZ)
            MaFisLoad("NF_NATUREZA",SC5->C5_NATUREZ)
        Else
            MaFisLoad("NF_NATUREZA",Iif( Empty(SA1->A1_NATUREZ), &(SuperGetMv("MV_1DUPNAT")) , SA1->A1_NATUREZ ))
        EndIf
    EndIf
    If !Empty(SF2->F2_CLIENT) .And. !Empty(SF2->F2_LOJENT)
        MaFisLoad("NF_CLIENT",SF2->F2_CLIENT)
        MaFisLoad("NF_LOJENT",SF2->F2_LOJENT)
    EndIf
    For nY := 1 to Len(aFisGetSC5)
        If !Empty( SC5->(FieldGet(FieldPos(aFisGetSC5[nY][2]))) )
            If aFisGetSC5[ny][1] == "NF_SUFRAMA"
                MaFisLoad(aFisGetSC5[ny][1],Iif( SC5->(FieldGet(FieldPos(aFisGetSC5[nY][2]))) == "1",.T.,.F.))
            Else
                MaFisLoad(aFisGetSC5[ny][1], SC5->(FieldGet(FieldPos(aFisGetSC5[nY][2]))) )
            Endif
        EndIf
    Next nY
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para devolucao de Material                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SC5->C5_TIPO=="D" )
    dbSelectArea("SD1")
    dbSetOrder(1)
    If ( MsSeek(xFilial()+SC6->C6_NFORI+SC6->C6_SERIORI+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC6->C6_PRODUTO+SC6->C6_ITEMORI,.F.) )
        nRecOri := SD1->(RecNo())
        dbSelectArea("SF1")
        dbSetOrder(1)
        If MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+"N")
            nTaxaNDF := SF1->F1_TXMOEDA
            dbSelectArea("SE2")
            dbSetOrder(6)
            If MsSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL)
                nMoedaNDF := SE2->E2_MOEDA
            EndIf
        EndIf
    EndIf
Else
    If ( SF4->F4_PODER3=="D" .And. SC5->C5_TIPO$"BN" )
        dbSelectArea("SD1")
        dbSetOrder(4)
        If ( MsSeek(xFilial("SD1")+SC9->C9_IDENTB6) )
            nRecOri := SD1->(RecNo())
        EndIf
        dbSetOrder(1)
    Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa Code Block de atualizacao do pedido de venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Eval(bAtuPvl)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa as funcoes                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisIniLoad(nItem,{    SC6->C6_PRODUTO,;   //IT_PRODUTO
    SC6->C6_TES,;       //IT_TES
    If(SF4->F4_ISS=="S", SC6->C6_CODISS , " " ) ,;  //IT_CODISS
    aPvlNfs[nItem][4],; //IT_QUANT
    SC6->C6_NFORI,;     //IT_NFORI
    SC6->C6_SERIORI,;   //IT_SERIORI
    SB1->(RecNo()),;    //IT_RECNOSB1
    SF4->(RecNo()),;    //IT_RECNOSF4
    nRecOri ,;          //IT_RECORI  
    SC6->C6_LOTECTL,;   //IT_LOTECTL
    SC6->C6_NUMLOTE })  //IT_NUMLOTE
//Apesar da referencia já ser atualizada no momento da gravação no SD2, pelo MAFisRef, na MATXFIS precisaremos
// da classificação fiscal no cálculo dos impostos do item.
If Len(Alltrim(SC6->C6_CLASFIS))==3
    Mafisload("IT_CLASFIS",SC6->C6_CLASFIS,nItem)
EndIf

MaFisLoad("IT_ABVLISS",SC6->C6_ABATISS,nItem)   

MaFisTes(SC6->C6_TES,SF4->(RecNo()),nItem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Para que a aliquota do ISS Progressivo seja enquadrada na tabela        ³
//³CALCPROG.ISS a MATXFIS necessita do valor de referencia do valor total  ³
//³do item do pedido de vendas para que aliquota seja gravada ao gerar NFs.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SuperGetMV("MV_ISSPRG",,"N") == "S")
    MaFisLoad("IT_VALMERC",SC6->C6_VALOR,nItem) 
EndIf                          

nPosAIss := Ascan(aFisGet, {|x| x[1] == "IT_ALIQISS" })
If nPosAIss > 0    
    dbSelectArea("SC6")
    nAliqIss := SC6->(FieldGet(FieldPos(aFisGet[nPosAIss][2])))
    If nAliqIss == 0
        nAliqIss := MaAliqISS(nItem)
    EndIf
Else
    nAliqIss := MaAliqISS(nItem)
Endif   
aRateio[RT_PRECOIT] := MaPvPrcIt(aPvlNfs,nItem,lReajuste,aRateio,nValNeg,nAliqIss,dDataMoe)

nValNeg     := If(nValNeg>0,0,nValNeg)
MaFisLoad("IT_VALMERC",aRateio[RT_PRECOIT][3]+aRateio[RT_PRECOIT][4],nItem) 
MaFisLoad("IT_PRCUNI",aRateio[RT_PRECOIT][1],nItem)
MaFisLoad("IT_VLR_FRT",aRateio[RT_VLR_FRT],nItem)
If nAliqIss==0
    MaFisLoad("IT_FRETE",aRateio[RT_FRETE],nItem)
    MaFisLoad("IT_SEGURO",aRateio[RT_SEGURO],nItem)
    MaFisLoad("IT_DESPESA",aRateio[RT_DESPESA],nItem)
EndIf
MaFisLoad("IT_AUTONOMO",aRateio[RT_FRETAUT],nItem)
MaFisLoad("IT_DESCONTO",aRateio[RT_PRECOIT][4],nItem)
MaFisLoad("IT_PESO",SB1->B1_PESO,nItem)

If !Empty(aNfOriLot) .And. Len(aNfOriLot[01])>0 //Tratamento para IVA Ajustado - Esta chamada tem custo zero de performance para matxfis
    MaFisAddIT("IT_ANFORI2",{aNfOriLot[01][__UFORI],aNfOriLot[01][__ALQORI],aNfOriLot[01][__PROPOR],0},nItem,.T.)
EndIf
MaFisRecal("",nItem)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Forca os valores de impostos que foram informados no SC6.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
For nY := 1 to Len(aFisGet)
    If !Empty( SC6->(FieldGet(FieldPos(aFisGet[ny][2]))) )
        MaFisAlt(aFisGet[ny][1] , SC6->(FieldGet(FieldPos(aFisGet[ny][2]))) ,nItem,.T.)
    EndIf
Next nY      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa o calculo de todos os impostos.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisAlt("IT_ALIQISS",aRateio[RT_PRECOIT][5],nItem,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Compatibilizacao com os pontos de entrada anteriores                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SF4->F4_IPI<>"N" )
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pontos de Entrada                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndIf
If ( SF4->F4_ICM=="S" )

EndIf
If ( SC5->C5_TIPOCLI == "S" .Or. SC5->C5_TIPOCLI == "F" .Or. SC5->C5_TIPOCLI $ SuperGetMV("MV_TPSOLCF")  )
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pontos de Entrada                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nModulo == 72 
        ICMSITEM    := MaFisRet(nItem,"IT_VALICM")      // variavel para ponto de entrada
        QUANTITEM   := MaFisRet(nItem,"IT_QUANT")       // variavel para ponto de entrada
        BASEICMRET  := MaFisRet(nItem,"IT_BASESOL") // criado apenas para o ponto de entrada
        MARGEMLUCR  := MaFisRet(nItem,"IT_MARGEM")      // criado apenas para o ponto de entrada
        If nModulo == 72 
            aSolidTmp := KEXF760(nItem)
        Else
            If ExistBlock("M460SOLI")
                aSolidTmp := ExecBlock("M460SOLI",.F.,.F.,{nItem,SC6->C6_ITEM})
            EndIf
        EndIf
        If ValType(aSolidTmp) == "A" 
            aSolid := aClone(aSolidTmp)
        EndIf
        If Len(aSolid) == 2
            MaFisLoad("IT_BASESOL",NoRound(aSolid[1],2),nItem)
            MaFisLoad("IT_VALSOL" ,NoRound(aSolid[2],2),nItem)
        EndIf
    EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a carga do item.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisEndLoad(nItem,2)

nPrcVen  := aRateio[RT_PRECOIT][1]
nPrUnit  := aRateio[RT_PRECOIT][2]
nTotal   := aRateio[RT_PRECOIT][3]
nDesconto:= aRateio[RT_PRECOIT][4]
nAcresFin:= aRateio[RT_PRECOIT][6]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo dos Impostos Financeiros                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SF4->F4_DUPLIC=="S" )
    aTitulo[_VLRTIT_]  += MaFisRet(nItem,'IT_BASEDUP')
    aTitulo[_VLRIRRF_] += MaFisRet(nItem,'IT_VALIRR')
    aTitulo[_VLRINSS_] += MaFisRet(nItem,'IT_VALINS')
    aTitulo[_VLRINSS_] += MaFisRet(nItem,'IT_VALINA')
    aTitulo[_VLRISS_]  += MaFisRet(nItem,'IT_VALISS')
    aTitulo[_VLRPIS_]  += MaFisRet(nItem,'IT_VALPIS')
    aTitulo[_VLRCSLL_] += MaFisRet(nItem,'IT_VALCSL')
    aTitulo[_VLRCOFI_] += MaFisRet(nItem,'IT_VALCOF')
    aTitulo[_VLRIPI_ ] += MaFisRet(nItem,'IT_VALIPI')
    aTitulo[_VLRSOL_ ] += MaFisRet(nItem,'IT_VALSOL')
    aTitulo[_VLRFET_ ] += MaFisRet(nItem,'IT_VALFET')
    aTitulo[_VLRFAB_ ] += MaFisRet(nItem,'IT_VALFAB')   
    aTitulo[_VLRFAC_ ] += MaFisRet(nItem,'IT_VALFAC')
    aTitulo[_VLRTPDP_] += MaFisRet(nItem,'IT_VALTPDP')   

    If MaFisRet(nItem,'IT_BASEDUP') > 0
        aTitulo[_VLRMOE_]      += aRateio[RT_PRECOIT][7]
        aTitulo[_VLRREA_]      += aRateio[RT_PRECOIT][3]
        aTitulo[_VLRACR_]      += aRateio[RT_PRECOIT][6]
        aTitulo[_VLRDESPAC2_]  += aRateio[RT_DESPAC2]
        If nMoeda <> 1

            aTitulo[_VLRDSPREA_] += aRateio[RT_FRETE]+aRateio[RT_SEGURO]+aRateio[RT_DESPESA]+aRateio[RT_FRETAUT]-aRateio[RT_DESCONT]

            If GetNewPar("MV_TPRTDSP","1")=="2"
                aTitulo[_VLRDSPMOE_] += xMoeda(aRateio[RT_FRETE]+aRateio[RT_SEGURO]+aRateio[RT_DESPESA]+aRateio[RT_FRETAUT]-aRateio[RT_DESCONT],1,nMoeda,dDataMoe,2)
            Else
                aTitulo[_VLRDSPMOE_] += aRateio[RT_DESPMOE]
            EndIf

            If aTitulo[_VLRDESPAC2_] < 0
                aTitulo[_VLRTITDIF_] := (aTitulo[_VLRMOE_]+aTitulo[_VLRDESPAC2_])-xMoeda(aTitulo[_VLRREA_],1,nMoeda,dDataMoe,2)
            Else
                aTitulo[_VLRTITDIF_] := aTitulo[_VLRMOE_]+aTitulo[_VLRDSPMOE_]-xMoeda(aTitulo[_VLRREA_]+aTitulo[_VLRDSPREA_],1,nMoeda,dDataMoe,2)
            EndIf
        EndIf
        If nMoedaNDF <> 1 .And. aTitulo[_MOEDANDF_] <> -1
            If aTitulo[_MOEDANDF_] == 0
                aTitulo[_MOEDANDF_] :=  nMoedaNDF
            Else
                If nMoedaNDF <> aTitulo[_MOEDANDF_]
                    aTitulo[_MOEDANDF_] := -1
                EndIf
            EndIf
            If aTitulo[_MOEDANDF_] > 0
                If aTitulo[_TAXANDF_ ] == 0
                    aTitulo[_TAXANDF_] := nTaxaNDF
                Else
                    aTitulo[_TAXANDF_ ]  := (aTitulo[_VLRTIT_]/(xMoeda(aTitulo[_VLRTIT_] - MaFisRet(nItem,'IT_BASEDUP'),1,aTitulo[_MOEDANDF_],dDataMoe,,,aTitulo[_TAXANDF_ ])+xMoeda(aTitulo[_VLRTIT_] - MaFisRet(nItem,'IT_BASEDUP'),1,nMoedaNDF,dDataMoe,,,nTaxaNDF)))
                EndIf
            EndIf
        EndIf
    EndIf
ElseIF SF4->(FieldGet(FieldPos("F4_DUPLIST")) == "1" )
    aTitulo[_VLRTIT_]  += MaFisRet(nItem,'IT_VALSOL')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Poder de Terceiro                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
Case ( SF4->F4_PODER3=="D" .And. Empty(SC6->C6_NFORI) )
    dbSelectArea("SB6")
    dbSetOrder(1)
    MsSeek(xFilial("SB6")+SC6->C6_PRODUTO+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC9->C9_IDENTB6)

    While ( !Eof() .And. xFilial("SB6") == SB6->B6_FILIAL .And.;
            SC6->C6_PRODUTO== SB6->B6_PRODUTO.And.;
            SC5->C5_CLIENTE== SB6->B6_CLIFOR .And.;
            SC5->C5_LOJACLI== SB6->B6_LOJA   .And.;
            SB6->B6_IDENT  == SC9->C9_IDENTB6 )
        dbSelectArea("SF4")
        dbSetOrder(1)
        MsSeek(xFilial("SF4")+SB6->B6_TES)
        If ( SF4->F4_PODER3=="R" )
            cNfOri   := SB6->B6_DOC
            cSeriOri := SB6->B6_SERIE
            cItemOri := ""
            cIdentB6 := SC9->C9_IDENTB6
            dbSelectArea("SF4")
            dbSetOrder(1)
            MsGoto(aPvlSd2[13])
            Exit
        EndIf
        dbSelectArea("SB6")
        dbSkip()
    EndDo
Case ( SF4->F4_PODER3=="N" .And. !Empty(SC9->C9_IDENTB6) )
    dbSelectArea("SD1")
    dbSetOrder(4)
    MsSeek(xFilial("SD1")+SC9->C9_IDENTB6)
    cNfOri   := SD1->D1_DOC
    cSeriOri := SD1->D1_SERIE
    cItemOri := SD1->D1_ITEM
    cIdentB6 := SC9->C9_IDENTB6
OtherWise
    cNfOri   := SC6->C6_NFORI
    cSeriOri := SC6->C6_SERIORI
    cItemOri := SC6->C6_ITEMORI
    cIdentB6 := SC9->C9_IDENTB6
EndCase

//Tratamento para ICMS-ST de transporte, quando a nota nao deve possuir valor
//contabil, apenas os valores do ICMS Solidario
If SF4->(FieldPos("F4_OBSSOL"))>0 .And. SF4->(FieldPos("QTDZERO"))>0
    If SF4->F4_OBSSOL=="5" .And. SF4->F4_QTDZERO=="1"
        nPrUnit :=  0
        nPrcVen :=  0
        nTotal  :=  0
    Endif
Endif

RecLock("SD2",.T.)
SD2->D2_FILIAL   := xFilial("SD2")
SD2->D2_SERIE    := SF2->F2_SERIE
SD2->D2_DOC      := SF2->F2_DOC
SD2->D2_ITEM     := cItemNf
SD2->D2_EMISSAO  := dDataBase
SD2->D2_TIPO     := SF2->F2_TIPO
SD2->D2_CLIENTE  := SF2->F2_CLIENTE
SD2->D2_LOJA     := SF2->F2_LOJA
SD2->D2_COD      := SC6->C6_PRODUTO
SD2->D2_QUANT    := aPvlSD2[4]
SD2->D2_UM       := SC6->C6_UM
If SD2->(FieldPos('D2_ESTOQUE')) > 0 
    SD2->D2_ESTOQUE  := SF4->F4_ESTOQUE 
Endif
If SD2->(FieldPos('D2_SITTRIB')) > 0 .And. !Empty(cAliq)
    SD2->D2_SITTRIB  := cAliq
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Vendas Cliente - 22/02/11                                ³
//³Grava os campos de Codigo da Lista de Presentes e Item da³
//³Lista de Presentes                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  lUsaLstPre
    SD2->D2_CODLPRE := SC6->C6_CODLPRE
    SD2->D2_ITLPRE  := SC6->C6_ITLPRE
EndIf
If Empty( aPvlSD2[17] )
    If aPvlSD2[4] == SC6->C6_QTDVEN
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Se baixou totalmente a primeira unidade de medida, baixa a segunda     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        SD2->D2_QTSEGUM  := SC6->C6_UNSVEN
    Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Faz a conversao de unidade                                             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        SD2->D2_QTSEGUM  := SF4->(ConvUm(SC6->C6_PRODUTO,aPvlSD2[4],0,2))
    EndIf
Else
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fatura a quantidade efetivamente liberada                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SD2->D2_QTSEGUM := aPvlSD2[17]
EndIf

SD2->D2_SEGUM    := SC6->C6_SEGUM
SD2->D2_DESC     := SC6->C6_DESCONT
SD2->D2_DESCON   := nDesconto
SD2->D2_PEDIDO   := SC6->C6_NUM
SD2->D2_ITEMPV   := SC6->C6_ITEM
SD2->D2_LOCAL    := SC9->C9_LOCAL
SD2->D2_NUMSERI  := SC6->C6_NUMSERI
SD2->D2_CODFAB   := SC6->C6_CODFAB
SD2->D2_LOJAFA   := SC6->C6_LOJAFA
SD2->D2_ITEMORI  := cItemOri
SD2->D2_PESO     := SB1->B1_PESO
SD2->D2_GRUPO    := SB1->B1_GRUPO
SD2->D2_TP       := SB1->B1_TIPO
SD2->D2_CONTA    := SB1->B1_CONTA
SD2->D2_CCUSTO   := SB1->B1_CC
SD2->D2_ITEMCC   := SB1->B1_ITEMCC
SD2->D2_CLVL     := SB1->B1_CLVL
SD2->D2_EST      := SF2->F2_EST
SD2->D2_PRUNIT   := nPrUnit
SD2->D2_BASEORI  := 0
SD2->D2_NUMSEQ   := cNumSeq
SD2->D2_VALACRS  := nAcresFin
SD2->D2_IDENTB6  := cIdentB6
SD2->D2_GRADE    := SC6->C6_GRADE
SD2->D2_CODISS   := SF4->(If(SF4->F4_ISS=="S", SC6->C6_CODISS , " " )) 
SD2->D2_NUMLOTE  := SC9->C9_NUMLOTE
SD2->D2_LOTECTL  := SC9->C9_LOTECTL
SD2->D2_DTVALID  := SC9->C9_DTVALID
SD2->D2_POTENCI  := SC9->C9_POTENCI
SD2->D2_CLASFIS  := SC6->C6_CLASFIS
SD2->D2_PROJPMS  := SC9->C9_PROJPMS
SD2->D2_TASKPMS  := SC9->C9_TASKPMS
If SD2->(FieldPos('D2_TRT')) > 0 .And.SC9->(FieldPos('C9_TRT'))  > 0
    SD2->D2_TRT  := SC9->C9_TRT
Endif   
SD2->D2_LICITA    := SC9->C9_LICITA
SD2->D2_SERVIC   := SC9->C9_SERVIC
SD2->D2_PDV      := SF2->F2_PDV
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a gravacao dos Impostos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF4->(MaFisWrite(2,"SD2",nItem))
SD2->D2_VALICM   := SF4->(If(SF4->F4_ISS<>"S",MaFisRet(nItem,'IT_VALICM') ,MaFisRet(nItem,'IT_VALISS')))
SD2->D2_BASEICM  := SF4->(If(SF4->F4_ISS<>"S",MaFisRet(nItem,'IT_BASEICM'),MaFisRet(nItem,'IT_BASEISS')))
SD2->D2_PICM     := SF4->(If(SF4->F4_ISS=="S",MaFisRet(nItem,'IT_ALIQISS'),MaFisRet(nItem,'IT_ALIQICM')))
SD2->D2_DESCZFR  := SF4->(MaFisRet(nItem,'IT_DESCZF'))    
If nModulo <> 43
    SD2->D2_CF := SC6->C6_CF
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a gravacao dos valores unitarios qdo. nao utiliza desc. ZF       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SD2->D2_DESCZFR == 0 
    SD2->D2_PRCVEN  := nPrcVen
    SD2->D2_TOTAL   := nTotal
Else
    SD2->D2_TOTAL := SD2->D2_TOTAL - nDesconto
EndIf
If SD2->(FieldPos("D2_EDTPMS"))>0
    SD2->D2_EDTPMS   := SC9->C9_EDTPMS
EndIf                              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desconta o Valor do ICMS DESONERADO do valor do Item D2_PRCVEN         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SF4->F4_AGREG$"R"
    SD2->D2_TOTAL  -= MaFisRet(nItem,"IT_DEDICM")
    SD2->D2_PRCVEN := A410Arred(SD2->D2_TOTAL/IIf(SD2->D2_QUANT==0,1,SD2->D2_QUANT),"D2_PRCVEN")
EndIf                              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza CAT/83                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCAT83
    SD2->D2_CODLAN := SC6->C6_CODLAN
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pontos de Entrada                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ( SD2->(FIELDPOS("D2_PREEMB")) <> 0 ) .and. cEmbExp <> Nil
    SD2->D2_PREEMB := cEmbExp
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Percentuais de Comissao                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cVendedor := "1"
For nCntFor := 1 To nMaxVend
    nComis := SC6->(FieldGet(FieldPos("C6_COMIS"+cVendedor)))
    If ( nComis == 0 )
        nComis := SC5->(FieldGet(FieldPos("C5_COMIS"+cVendedor)))
    EndIf
    SD2->(FieldPut(FieldPos("D2_COMIS"+cVendedor),nComis))
    cVendedor := Soma1(cVendedor,1)
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o Cabecalho da Nota                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !InTransact()
    RecLock("SF2")
EndIf

If !Empty(SC5->C5_PEDEXP) .And. SuperGetMV("MV_EECFAT") .And. FindFunction("EECAtuPesNF") .And. EECAtuPesNF(SC5->C5_PEDEXP)
    aPesoEmb := CalcPeso(SC5->C5_PEDEXP,SD2->D2_ITEMPV,SD2->D2_QUANT,SC5->C5_NUM)
    SF2->F2_PLIQUI     += aPesoEmb[1]
    SF2->F2_PBRUTO     += aPesoEmb[2]
Else
    If ( SC5->C5_PESOL == 0 )
        SF2->F2_PLIQUI     += SD2->D2_PESO * SD2->D2_QUANT
    EndIf
    If ( SC5->C5_PBRUTO == 0 )
        SF2->F2_PBRUTO     += SB1->B1_PESBRU * SD2->D2_QUANT
    EndIf
EndIf

SF2->F2_CARGA  := SC9->C9_CARGA
SF2->F2_SEQCAR := SC9->C9_SEQCAR
SF2->F2_SEQENT := SC9->C9_SEQENT

If SF2->(FieldPos("F2_DESCCAB")) > 0
    SF2->F2_DESCCAB += aRateio[RT_DESCONT]+aRateio[RT_PDESCON]
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza itens do Pedido de Venda                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SC6",.F.)
SF4->(MaAvalSC6("SC6",5))
MsUnlock()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Itens de Pedido Liberado                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SC9")
SF4->(MaAvalSC9("SC9",11))
MsUnLock()
If (!Empty(SC9->C9_CARGA))
    //-- Uso SIGAOMS - Tratamento para Filial Operador Logistico
    If  Type("cFilOpl") <> "U" .And. cFilOpl <> cFilAnt
        cFilAnt := cFilOpl
    EndIf
    If  aPvlSD2[16] <> 0
        lGrvVeic := .T.
        If Ascan(aCarga,aPvlSD2[16])==0
            aadd(aCarga,aPvlSD2[16])
        EndIf
    Else
        dbSelectArea("DAK")
        dbSetOrder(1) //DAK_FILIAL+DAK_COD+DAK_SEQCAR
        If  MsSeek(xFilial("DAK")+SC9->C9_CARGA+SC9->C9_SEQCAR)
            lGrvVeic := .T.
            If Ascan(aCarga,DAK->(RecNo()))==0
                aadd(aCarga,DAK->(RecNo()))
            EndIf
        EndIf
    EndIf
    If  lGrvVeic .And. SF2->(FieldPos("F2_VEICUL1")) > 0 //Grava Veiculo
        SF2->F2_VEICUL1 := DAK->DAK_CAMINH
    EndIf
    cFilPv := IIf(OsVlEntCom()==1,"",SC9->C9_FILIAL)
    If  DAI->(FieldPos("DAI_NFISCA")) > 0 .And. DAI->(FieldPos("DAI_SERIE")) > 0
        aAreaDAI := DAI->(GetArea())
        dbSelectArea("DAI")
        dbSetOrder(1) //DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
        If  DAI->(dbSeek(xFilial("DAI")+SC9->C9_CARGA+SC9->C9_SEQCAR+SC9->C9_SEQENT+SC9->C9_PEDIDO))
            Reclock("DAI",.F.)
            DAI->DAI_NFISCA := SF2->F2_DOC
            DAI->DAI_SERIE  := SF2->F2_SERIE
            MsUnlock()
        EndIf
        RestArea(aAreaDAI)
    EndIf
    //-- Uso SIGAOMS - Tratamento para Filial Operador Logistico
    If  cFilAnt <> cFilSav
        cFilAnt := cFilSav
    EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza saldo no armazem de poder de terceiros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("TrfSldPoder3")
    TrfSldPoder3(SD2->D2_TES,"SD2",SD2->D2_COD,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza saldo do contrato SIGAGCT                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC6->( FieldPos("C6_ITEMED") ) > 0 .And. !Empty(SC6->C6_ITEMED)
    CtaAvalGCT(1,aContrato,SC5->C5_MDCONTR,SC5->C5_MDPLANI,SC6->C6_ITEMED,SD2->D2_QUANT,aMedicao,SC5->C5_MDNUMED,SD2->D2_TOTAL) 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os acumulados do SD2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(FkCommit(.T.))
MaAvalSD2(,,lAtuSA7,nItem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina para tratar a gravacao do rateio por item nota fiscal de saida.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("AGH") .And. AliasInDic("AGG")
    aAreaRat := GetArea()
    nItemRat := 0
    dbSelectArea("AGG")
    dbSetOrder(1) // AGG_FILIAL+AGG_PEDIDO+AGG_FORNEC+AGG_LOJA+AGG_ITEMPD+AGG_ITEM  
    If dbSeek(xFilial("AGG") + SD2->D2_PEDIDO + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEMPV)
        While AGG->(!EOF()) .AND. AGG->(AGG_FILIAL+AGG_PEDIDO+AGG_FORNEC+AGG_LOJA+AGG_ITEMPD) == xFilial("AGG") + SD2->D2_PEDIDO + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEMPV
            nItemRat++
            RecLock("AGH",.T.)
            AGH->AGH_FILIAL     :=  xFilial("AGH")
            AGH->AGH_NUM        :=  SF2->F2_DOC
            AGH->AGH_SERIE      :=  SF2->F2_SERIE
            AGH->AGH_FORNECE    :=  SD2->D2_CLIENTE
            AGH->AGH_LOJA       :=  SD2->D2_LOJA
            AGH->AGH_ITEMPD     :=  SD2->D2_ITEM
            AGH->AGH_ITEM       :=  STRZERO( nItemRat , TamSX3("AGH_ITEM")[1])
            AGH->AGH_PERC       :=  AGG->AGG_PERC
            AGH->AGH_CC         :=  AGG->AGG_CC
            AGH->AGH_CONTA      :=  AGG->AGG_CONTA
            AGH->AGH_ITEMCTA    :=  AGG->AGG_ITEMCTA
            AGH->AGH_CLVL       :=  AGG->AGG_CLVL
            AGH->AGH_CUSTO1     :=  SD2->D2_CUSTO1 * (AGG->AGG_PERC/100)
            AGH->AGH_CUSTO2     :=  SD2->D2_CUSTO2 * (AGG->AGG_PERC/100)
            AGH->AGH_CUSTO3     :=  SD2->D2_CUSTO3 * (AGG->AGG_PERC/100)
            AGH->AGH_CUSTO4     :=  SD2->D2_CUSTO4 * (AGG->AGG_PERC/100)
            AGH->AGH_CUSTO5     :=  SD2->D2_CUSTO5 * (AGG->AGG_PERC/100)
            
            If lCtbIsCube
                aEntidades := CtbEntArr()
                For nEnt := 1 to Len(aEntidades)
                    For nDeb := 1 to 2
                        cCpo := "AGH_EC"+aEntidades[nEnt]
                        cAGG := "AGG_EC"+aEntidades[nEnt]
                        
                        If nDeb == 1
                            cCpo += "DB"
                            cAGG += "DB"
                        Else
                            cCpo += "CR"
                            cAGG += "CR"
                        EndIf
                                        
                        If AGH->(FieldPos(cCpo)) > 0 .And. AGG->(FieldPos(cAGG)) > 0
                            AGH->(&(cCpo)) := AGG->(&(cAGG))
                        EndIf
                        
                    Next nDeb
                Next nEnt
            EndIf
            
            MsUnLock()
            AGG->(dbSkip())
        EndDo
        RecLock("SD2",.F.)
            SD2->D2_RATEIO := "1"
        MsUnLock()
    EndIf
    RestArea(aAreaRat)
Endif

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaPvl2SF2 ³ Autor ³Eduardo Riera          ³ Data ³29.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao da Nota Fiscal de Saida                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaPvl2SF2(cSerie,cNumero,aPedido,lReajuste,lMoedaFre,lCtbOnLine,nValNeg,cPdv,cCgc)

Local aEspVol  := {}
Local nCntFor  := 1
Local nMaxVend := Fa440CntVen()
Local cScan    := ""
Local nScan    := ""
Local cEstado  := ""
Local cCliEnt  := IIf(SC5->(FieldPos("C5_CLIENT"))>0,IIf(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE),SC5->C5_CLIENTE)
Local cVendedor:= "1"
Local nTotPBrut:= 0
Local nTotPesoL:= 0
Local cEspecie := ""
Local lTMSUFPAG:= SuperGetMv("MV_TMSUFPG",.F.,.F.) //-- Define se grava o estado do pagador do frete.
Local cMv_Estado  := SuperGetMv("MV_ESTADO") 
Local cTesVend    := SuperGetMv("MV_TESVEND",,"")
Local lCfo        := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ( SC5->C5_TIPO $ "DB" )
    If ( SC5->C5_CLIENTE+SC5->C5_LOJACLI <> cCliEnt+SC5->C5_LOJAENT )
        dbSelectArea("SA2")
        dbSetOrder(1)
        MsSeek(xFilial("SA2")+cCliEnt+SC5->C5_LOJAENT)
        cEstado := SA2->A2_EST

        dbSelectArea("SA2")
        dbSetOrder(1)
        MsSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

        cEstado := IIf(Empty(cEstado),SA2->A2_EST,cEstado)
    Else
        dbSelectArea("SA2")
        dbSetOrder(1)
        MsSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

        cEstado := SA2->A2_EST
    EndIf
Else
    If ( SC5->C5_CLIENTE+SC5->C5_LOJACLI <> cCliEnt+SC5->C5_LOJAENT )
        dbSelectArea("SA1")
        dbSetOrder(1)
        MsSeek(xFilial("SA1")+cCliEnt+SC5->C5_LOJAENT)
        cEstado := SA1->A1_EST

        dbSelectArea("SA1")
        dbSetOrder(1)
        MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
        
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³A Consultoria Tributária, por meio da Resposta à Consulta nº 268/2004, determinou a aplicação das seguintes alíquotas nas Notas Fiscais de venda emitidas pelo vendedor remetente:                                                                         ³
    //³1) no caso previsto na letra "a" (venda para SP e entrega no PR) - aplicação da alíquota interna do Estado de São Paulo, visto que a operação entre o vendedor remetente e o adquirente originário é interna;                                              ³
    //³2) no caso previsto na letra "b" (venda para o DF e entrega no PR) - aplicação da alíquota interestadual prevista para as operações com o Paraná, ou seja, 12%, visto que a circulação da mercadoria se dá entre os Estado de São Paulo e do Paraná.       ³
    //³3) no caso previsto na letra "c" (venda para o RS e entrega no SP) - aplicação da alíquota interna do Estado de São Paulo, uma vez que se considera interna a operação, quando não se comprovar a saída da mercadoria do território do Estado de São Paulo,³
    //³ conforme previsto no art. 36, § 4º do RICMS/SP                                                                                                                                                                                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If cMv_Estado == 'SP'.And. SA1->A1_EST == 'SP'
        dbSelectArea("SC6")
        dbSetOrder(1)
        MsSeek(xFilial("SC6")+aPedido[nCntFor][1])
            
        While !SC6->(Eof()) .And. xFilial("SC6") == SC6->C6_FILIAL .And. SC6->C6_NUM    == aPedido[nCntFor][1] 
            If Alltrim(SC6->C6_TES)$ Alltrim(cTesVend)
                lCfo:=  .T.
            EndIf
            dbSkip() 
        End
            
        If lCfo
            cEstado := SA1->A1_EST          
        EndIf 
    EndIF
    
        //--Se a chamada e pelo modulo SIGATMS, para gravar o estado precisamos respeitar o parametro MV_TMSUFPG,
        //--responsavel por todas as gravacoes de estado, na parte fiscal, se o parametro estiver ativado, gravo
        //--o estado que pegamos atraves do C5_CLIENTE+C5_LOJACLI, que e o cliente devedor do frete,
        //--caso contrario utilizo o estado do destinatario que ja estava gravado em cEstado        
        If "TMSA200" $ FunName() //--SIGATMS, Calculo do Frete
            If lTMSUFPAG
                cEstado := SA1->A1_EST
            EndIf
        EndIf

        cEstado := IIf(Empty(cEstado),SA1->A1_EST,cEstado)      
    Else
        dbSelectArea("SA1")
        dbSetOrder(1)
        MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

        cEstado := SA1->A1_EST
    EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Volumes                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCntFor := 1 To Len(aPedido)
    dbSelectArea("SC5")
    dbSetOrder(1)
    MsSeek(xFilial("SC5")+aPedido[nCntFor][1])

    cScan := "1"
    While ( !Empty(cScan) )
        cEspecie := Upper(FieldGet(FieldPos("C5_ESPECI"+cScan)))
        If !Empty(cEspecie)
            nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
            If ( nScan==0 )
                aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("C5_VOLUME"+cScan)) })
            Else
                aEspVol[nScan][2] += FieldGet(FieldPos("C5_VOLUME"+cScan))
            EndIf
        EndIf
        cScan := Soma1(cScan,1)
        If ( FieldPos("C5_ESPECI"+cScan) == 0 )
            cScan := ""
        EndIf
    EndDo
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Calculo dos Peso Bruto                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Empty(SC5->C5_PEDEXP) .Or. !SuperGetMV("MV_EECFAT") .Or. ( !Empty(SC5->C5_PEDEXP) .AND. FindFunction("EECAtuPesNF") .AND. !EECAtuPesNF(SC5->C5_PEDEXP))
        nTotPBrut   += FieldGet(FieldPos("C5_PBRUTO"))
        nTotPesoL   += FieldGet(FieldPos("C5_PESOL"))
    EndIf
Next nCntFor

RecLock("SF2",.T.)

SF2->F2_FILIAL     := xFilial("SF2")
SF2->F2_DOC        := cNumero
SF2->F2_PDV        := cPdv
SF2->F2_ECF        := IIf(!Empty(cPdv),"S","")
SF2->F2_SERIE      := cSerie
SF2->F2_ESPECIE    := A460Especie(cSerie)
SF2->F2_EMISSAO    := dDataBase
SF2->F2_CLIENTE    := SC5->C5_CLIENTE
SF2->F2_LOJA       := SC5->C5_LOJACLI
SF2->F2_TIPO       := SC5->C5_TIPO
SF2->F2_COND       := SC5->C5_CONDPAG
SF2->F2_TIPOCLI    := SC5->C5_TIPOCLI
SF2->F2_TRANSP     := SC5->C5_TRANSP
SF2->F2_REDESP     := SC5->C5_REDESP
SF2->F2_REAJUST    := If(!lReajuste,SC5->C5_REAJUST,"")
SF2->F2_HORA       := SubStr(Time(),1,5)
SF2->F2_REGIAO     := SA1->A1_REGIAO
SF2->F2_EST        := cEstado
SF2->F2_PBRUTO     := nTotPBrut
SF2->F2_PLIQUI     := nTotPesoL  
SF2->F2_CLIENT  :=  SC5->C5_CLIENT
SF2->F2_LOJENT  :=  SC5->C5_LOJAENT    
If  SF2->(FieldPos("F2_TPFRETE")) > 0   
     SF2->F2_TPFRETE := SC5->C5_TPFRETE
EndIf
If  SF2->(FieldPos("F2_CGCCLI")) > 0    
    SF2->F2_CGCCLI  := ALLTRIM( cCgc )
Endif
If SF2->(FieldPos("F2_VEICUL1"))>0 .And. SC5->(FieldPos("C5_VEICULO")) > 0
   SF2->F2_VEICUL1 := SC5->C5_VEICULO
Endif 
If  SC5->(FieldPos("C5_RECFAUT")) > 0   .And. SF2->(FieldPos("F2_RECFAUT")) > 0     
    SF2->F2_RECFAUT    := SC5->C5_RECFAUT
ENdif
If  SC5->(FieldPos("C5_NFSUBST")) > 0   .And. SF2->(FieldPos("F2_NFSUBST")) > 0     
    SF2->F2_NFSUBST    := SC5->C5_NFSUBST
ENdif
If  SC5->(FieldPos("C5_SERSUBS")) > 0   .And. SF2->(FieldPos("F2_SERSUBS")) > 0     
    SF2->F2_SERSUBS    := SC5->C5_SERSUBS
ENdif
If  SF2->(FieldPos("F2_MENNOTA")) > 0
    SF2->F2_MENNOTA  := SC5->C5_MENNOTA
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de Entrada Padrao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( ExistBlock("M461LSF2") )
    ExecBlock("M461LSF2",.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao dos vendedores                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cVendedor := "1"
For nCntFor := 1 To nMaxVend
    FieldPut(FieldPos("F2_VEND"+cVendedor),SC5->(FieldGet(FieldPos("C5_VEND"+cVendedor))))
    If SC5->(FieldPos("C5_CODRL"+cVendedor))>0
        FieldPut(FieldPos("F2_CODRL"+cVendedor),SC5->(FieldGet(FieldPos("C5_CODRL"+cVendedor))))
    EndIf
    cVendedor := Soma1(cVendedor,1)
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao dos Volumes/Especie                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCntFor := 1 To Len(aEspVol)
    FieldPut(FieldPos("F2_ESPECI"+StrZero(nCntFor,1)),aEspVol[nCntFor,1])
    FieldPut(FieldPos("F2_VOLUME"+StrZero(nCntFor,1)),aEspVol[nCntFor,2])
Next nCntFor

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaNfs2Fin ³ Autor ³Eduardo Riera          ³ Data ³29.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao dos Dados Financeiros                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array aTitulo                                        ³±±
±±³          ³       [1] Valor do Titulo                                  ³±±
±±³          ³       [2] Valor do IRF                                     ³±±
±±³          ³       [3] Valor do INSS                                    ³±±
±±³          ³       [4] Valor do ISS                                     ³±±
±±³          ³       [5] Valor do PIS                                     ³±±
±±³          ³       [6] Valor do CSLL                                    ³±±
±±³          ³       [7] Valor do COFINS                                  ³±±
±±³          ³       [8] Valor do IPI                                     ³±±
±±³          ³       [9] Valor do Solidario                               ³±±
±±³          ³ExpN2: Moeda do Titulo                                      ³±±
±±³          ³ExpC3: Codigo do Banco                                      ³±±
±±³          ³ExpC4: Numero do Pedido                                     ³±±
±±³          ³ExpB5: Code block para complemento de atualizacao dos titu- ³±±
±±³          ³       los financeiros.                                     ³±±
±±³          ³ExpA6: Array contendo o contrato (GCT) relacionado pelo     ³±±
±±³          ³       pedido de contrato                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaNfs2Fin(aTitulo,nMoeda,cBanco,cPedido,bAtuFin,lCtbOnLine,cFornISS,cRecISS, cB1M996,cB1FRETISS,aContrato,aMedicao,aRecSE1Adt,dDataMoe)

Local aVencto   := {}
Local aImposto  := {}
Local aImpOut   := {}    
Local aProp     := {}
Local aRecSe1   := {}
Local aRecSe2   := {}
Local aRecNDF   := {}
Local aCtbRet   := {0,0,0}

Local dDataCnd  := SF2->F2_EMISSAO

Local cMoedaTit := SuperGetMv("MV_MOEDTIT")
Local cVendedor := 0
Local cConteudo := ""
Local cParcela  := ""
Local cAliasSE2 := "SE2"   
Local cPrefOri  := ""
Local cNumOri   := ""
Local cParcOri  := ""
Local cTipoOri  := ""
Local cCfOri    := ""
Local cLojaOri  := ""
Local cTipoData := GetNewPar( "MV_TD10925", "1" ) 
Local cAplVlMn  := "1"
Local cAlIssB1  := GetNewPar("MV_ALISSB1","")

Local lf440Com  := ''//aEntry[EP_F440COM]
Local lM460IREN := ''//aEntry[EP_M460IREN]
Local lAbate    := .F. 
Local lComissao := SuperGetMv("MV_TPCOMIS")=="O"
Local lTemVend  := .F.
Local lCompensa := SuperGetMv("MV_CMPDEVC",.F.,.F.) //Compensar automatica dev. Compras
Local lQuery    := .F.

Local nPerJur   := SuperGetMv("MV_TXPER")
Local nDecE1Vlr := TamSX3( "E1_VALOR"  )[2]
Local nDecE1Vlc := TamSX3( "E1_VLCRUZ" )[2]
Local nVendedor := 0
Local nVlrParc  := 0
Local nVlrMoed1 := 0
Local nTotMoeda := 0
Local nTotMoed1 := 0
Local nVlrAcum1 := 0
Local nVlrAcum2 := 0
Local nTotalDev := 0
Local nCntFor   := 0
Local cImposto  := "0000000"
Local nImpISS   := 0
Local nImpIRRF  := 0
Local nImpINSS  := 0
Local nImpCSLL  := 0
Local nImpCOF   := 0
Local nImpPIS   := 0
Local nImpFet   := 0
Local nImpFab   := 0
Local nImpFac   := 0
Local nMaxVend  := Fa440CntVen()
Local nAbtISS   := 0              
Local nFatorParc:= 0 
Local nValTot   := 0
Local nBasePis  := MaFisRet(,"NF_BASEPIS")
Local nBaseCof  := MaFisRet(,"NF_BASECOF")
Local nBaseCsl  := MaFisRet(,"NF_BASECSL")
Local nBaseIns  := MaFisRet(,"NF_BASEINS")
Local nBaseIrf  := MaFisRet(,"NF_BASEIRR") 
Local nSaldoPis := nBasePis
Local nSaldoCof := nBaseCof
Local nSaldoCsl := nBaseCsl
Local nSaldoIns := nBaseIns
Local nSaldoIrf := nBaseIrf
Local nSaldoProp:= 0
Local nProp     := 0
Local nRetParISS:= 0

Local dIniMes   := FirstDay( dDataBase ) 
Local dFimMes   := LastDay( dDataBase ) 
Local nValMinRet:= GetNewPar( "MV_VL10925", 0 ) 
Local cModRet   := GetNewPar( "MV_AB10925", "0" )
Local aAcumulMes:= {} 
Local aRecnos   := {} 
Local aDadosRet := {}

Local cAnoMes := ""
                
Local nVlRetPIS := 0
Local nVlRetCOF := 0
Local nVlRetCSLL:= 0
Local nTotARet  := 0
Local nSobra    := 0
Local nFatorRed := 0
Local nLoop     := 0
Local nScanMes  := 0
Local nX        := 0
Local lContrAbt := !Empty( SE1->( FieldPos( "E1_SABTPIS" ) ) ) .And. !Empty( SE1->( FieldPos( "E1_SABTCOF" ) ) ) .And. ; 
                 !Empty( SE1->( FieldPos( "E1_SABTCSL" ) ) ) 
Local lGerAbtISS:= ( GetNewPar("MV_TPABISS","1")=="2" )                  
Local lFethab   := (SE1->(FieldPos("E1_FETHAB")) > 0) 
Local lFabov    := (SE1->(FieldPos("E1_FABOV")) > 0) 
Local lFacs     := (SE1->(FieldPos("E1_FACS")) > 0) 
                 
Local cRetCli   := "1"               
Local lCondVenda := .F.

Local cA1M996       :=  ""
Local cMV_A1M996    :=  GetNewPar ("MV_A1M996", "")
Local cTipoParc     := ""
Local cA1FRETISS    :=  ""

#IFDEF TOP
    Local aStruSE2  := {}
    Local cQuery    := ""
#ENDIF

Local lBaseImp  := ( SuperGetMv("MV_BS10925",.F.,"1") == "1")
Local nBasePCC  :=  Iif(nBasePis==0,Iif(nBaseCof==0,Iif(nBaseCsl==0,0,nBaseCsl),nBaseCof),nBasePis)
Local aTitCndVnd    := {}
Local lAtuSldNat:= FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local cNatureza := IIF(SC5->(FieldPos("C5_NATUREZ"))>0 .And. !Empty(SC5->C5_NATUREZ), SC5->C5_NATUREZ, Nil)

Private nValFun := SF2->F2_CONTSOC

//Gestao de Contratos
Default aContrato := {}
Default aMedicao  := {}

DEFAULT cPedido := ""
DEFAULT bAtuFin := {|| .T.}         
DEFAULT cFornISS:= ""
DEFAULT cRecISS := SA1->A1_RECISS

Default cB1M996 :=  ""
Default cB1FRETISS :=  ""
//

Default aRecSE1Adt := Array(0)
Default dDataMoe := dDataBase


If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif

If (SA1->(FieldPos (cMV_A1M996))>0)     //Campo da tabela SE1 identifica fornecimento de (1) bens e Servicos contratados por pessoa juridica de direito publico ou (2 ou '') identifica que Nao.
    cA1M996 :=  SA1->(FieldGet (FieldPos (cMV_A1M996)))
EndIf   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
//³Mais especificamente o paragrafo unico do Art 2.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SA1->(FieldPos ("A1_FRETISS"))>0)
    cA1FRETISS  :=  SA1->(FieldGet (FieldPos ("A1_FRETISS")))
EndIf

If lContrAbt
    If SA1->(FieldPos("A1_ABATIMP")) > 0 
        cRetCli := Iif(Empty(SA1->A1_ABATIMP),"1",SA1->A1_ABATIMP)      
    Endif
Endif       
    
//tratamento para empresa publica. deve ser feito a retencao sem verificar o valor minimo      
If SA1->(FieldPos("A1_RECCSLL")) > 0 .And. SA1->(FieldPos("A1_RECCOFI")) > 0 .And. SA1->(FieldPos("A1_RECPIS")) > 0
    If ("1"$cA1M996) .And. (SA1->A1_RECCSLL == "P" .Or. SA1->A1_RECCOFI == "P" .Or. SA1->A1_RECPIS == "P") 
        nValMinRet := 0
    EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica se o tratamento de valor minimo para retencao (R$ 5.000,00) deve ser aplicado:³
//³Controle pela variavel cAplVlMn, onde :                                              ³
//³1 = Aplica o valor minimo                                                            ³
//³2 = Nao aplica o valor minimo                                                        ³
//³Quando o tratamento da retencao for pela emissao, sera forcada a retencao em cada    ³
//³movimento. Quando o tratamento da retencao for pela baixa, o financeiro ira usar o   ³
//³campo E1_APLVLMN para identificar se utilizara ou nao o valor minimo para retencao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_PIS252") > 0 .Or. MaFisRet(,"NF_COF252") > 0 
    cModRet     := "1"
    cAplVlMn    := "2"
    cRetCli     := "2"
Endif

nMoeda := If(cMoedaTit=="S",nMoeda,1)

If lGerAbtISS .And. cRecISS == "2"
    lGerAbtISS := .F.
EndIf   
If ( SF2->F2_TIPO == "D" )
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gera Titulo Credito ao Fornecedor                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //ADupCred(aTitulo[_VLRTIT_],"501")
    If aTitulo[_MOEDANDF_]<=0
        Aadd(aRecNDF,ADupCred(aTitulo[_VLRTIT_],"501",nMoeda/*nMoeda*/,cNatureza,/*nTaxaNCC*/))
    Else
        Aadd(aRecNDF,ADupCred(xMoeda(aTitulo[_VLRTIT_],1,aTitulo[_MOEDANDF_],dDataMoe,,,aTitulo[_TAXANDF_])+aTitulo[_VLRTITDIF_],"501",aTitulo[_MOEDANDF_]/*nMoeda*/,cNatureza,aTitulo[_TAXANDF_]/*nTaxaNCC*/))
    EndIf
    If lCompensa  //Compensacao automatica do titulo

        dbSelectArea("SE2")
        dbSetOrder(6)
        #IFDEF TOP
            lQuery    := .T.
            aStruSE2  := SE2->(dbStruct())
            cAliasSE2 := "A461DEV"
            cQuery    := "SELECT SE2.E2_FILIAL, SE2.E2_SALDO ,SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NUMBOR ,"
            cQuery    += " SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_TIPO,SE2.E2_MOEDA, SE2.R_E_C_N_O_ SE2RECNO ,"
            cQuery    += " SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_ITEM,SD2.D2_COD,"
            cQuery    += " SD2.D2_PEDIDO,SD2.D2_ITEMPV,SD2.D2_CLIENTE,SD2.D2_LOJA " 
            cQuery    += " FROM "+RetSqlName("SE2")+" SE2 " 
            cQuery    += " JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D2_PEDIDO ='"+cPedido+"' AND SE2.E2_NUM = SD2.D2_NFORI AND SE2.E2_PREFIXO = SD2.D2_SERIORI AND SD2.D_E_L_E_T_ = ' ' "      
            cQuery    += " WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "   
            cQuery    += " SE2.E2_TIPO='NF ' AND "
            cQuery    += " SE2.D_E_L_E_T_=' ' "
            cQuery    += " ORDER BY "+SqlOrder(SE2->(IndexKey()))
            
            cQuery := ChangeQuery(cQuery)

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)
            For nX := 1 To Len(aStruSE2)
                If aStruSE2[nX][2]<>"C"
                    TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
                EndIf
            Next nX
            
            While !Eof()
                If Empty((cAliasSE2)->E2_NUMBOR)
                    If !SuperGetMv("MV_CHECKNF",.F.,.F.)
                        aadd(aRecSE2,If(lQuery,(cAliasSE2)->SE2RECNO,(cAliasSE2)->(RecNo())))
                        nTotalDev += xMoeda((cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_MOEDA,1)
                    EndIf
                EndIf
                dbSelectArea(cAliasSE2)
                dbSkip()
            EndDo           
        #ELSE
            MsSeek(xFilial("SE2")+SF2->F2_CLIENTE+SF2->F2_LOJA+SD2->D2_SERIORI+SD2->D2_NFORI)
    
            While !Eof() .And. xFilial("SE2") == (cAliasSE2)->E2_FILIAL .And.;
                SF2->F2_CLIENTE == (cAliasSE2)->E2_FORNECE .And.;
                SF2->F2_LOJA == (cAliasSE2)->E2_LOJA .And.;
                SD2->D2_SERIORI == (cAliasSE2)->E2_PREFIXO .And.;
                SD2->D2_NFORI == (cAliasSE2)->E2_NUM
                If (cAliasSE2)->E2_TIPO == "NF " .And. Empty((cAliasSE2)->E2_NUMBOR)
                    If !SuperGetMv("MV_CHECKNF",.F.,.F.)
                        aadd(aRecSE2,If(lQuery,(cAliasSE2)->SE2RECNO,(cAliasSE2)->(RecNo())))
                        nTotalDev += xMoeda((cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_MOEDA,1)
                    EndIf
                EndIf
                dbSelectArea(cAliasSE2)
                dbSkip()
            EndDo   
        #ENDIF

        //Compensacao automatica do titulo
        MaIntBxCP(2,aRecSe2,,aRecNDF,,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.}) 
        
        If lQuery
            dbSelectArea(cAliasSE2)
            dbCloseArea()
            dbSelectArea("SE2")
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Atualiza o SF2                                                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !InTransact()
        RecLock("SF2")
    EndIf
    SF2->F2_PREFIXO:= SE2->E2_PREFIXO
    SF2->F2_DUPL   := SF2->F2_DOC
Else
    If !(SF2->F2_TIPO$"B")
    
        //
        // Template GEM - Gestao de Empreendimentos Imobiliarios
        //
        // Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
        //
        If ExistTemplate("GMCondPagto") .And. HasTemplate("LOT")
            lCondVenda := ExecTemplate("GMCondPagto",.F.,.F.,{SF2->F2_COND,} )
            If ValType(lCondVenda) # "L"
                lCondVenda := .F.
            EndIf
        EndIf                   
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica o numero de parcelas dos impostos                             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        // Se Cond.Pagto tipo 9, moeda 2 e MV_MOEDTIT = "S", passa valor em Moeda 2 para nao
        // dar problema de arredondamento.
        If SE4->E4_TIPO == "9" .And. nMoeda <> 1 .And. cMoedaTit == "S"
            aVencto := Condicao(xMoeda(aTitulo[_VLRTIT_],1,nMoeda,dDataMoe),SF2->F2_COND,aTitulo[_VLRIPI_],dDataCnd,aTitulo[_VLRSOL_],,,aTitulo[_VLRACR_])
        Else
            aVencto := Condicao(aTitulo[_VLRTIT_],SF2->F2_COND,aTitulo[_VLRIPI_],dDataCnd,aTitulo[_VLRSOL_],,,aTitulo[_VLRACR_])            
        EndIf
        //
        // Template GEM - Gestao de Empreendimentos Imobiliarios
        //
        If ExistBlock("GMMA410Dupl")
            aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_],aVencto}, .F., .F.)
        Else
            If ExistTemplate("GMMA410Dupl")
                aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_],aVencto}) 
            EndIf
        Endif   
        
        cImposto := GetNewPar("MV_RTIPESP",cImposto)
        
        If GetNewPar("MV_RTIPFIN",.F.)
            If(SubStr(cImposto,1,1)$"01",nImpISS:=Len(aVencto),nImpISS:=1)
            If(SubStr(cImposto,2,1)$"01",nImpIRRF:=Len(aVencto),nImpIRRF:=1)
            If(SubStr(cImposto,3,1)$"01",nImpINSS:=Len(aVencto),nImpINSS:=1)
            If(SubStr(cImposto,4,1)$"01",nImpCSLL:=Len(aVencto),nImpCSLL:=1)
            If(SubStr(cImposto,5,1)$"01",nImpCOF:=Len(aVencto),nImpCOF:=1)
            If(SubStr(cImposto,6,1)$"01",nImpPIS:=Len(aVencto),nImpPIS:=1)
            If(SubStr(cImposto,7,1)$"01",nImpFet:=Len(aVencto),nImpFet:=1)          
            If(SubStr(cImposto,8,1)$"01",nImpFab:=Len(aVencto),nImpFab:=1)
            If(SubStr(cImposto,9,1)$"01",nImpFac:=Len(aVencto),nImpFac:=1)          
        Else
            If(SubStr(cImposto,1,1)$"02",nImpISS:=1,nImpISS:=Len(aVencto))
            If(SubStr(cImposto,2,1)$"02",nImpIRRF:=1,nImpIRRF:=Len(aVencto))
            If(SubStr(cImposto,3,1)$"02",nImpINSS:=1,nImpINSS:=Len(aVencto))
            If(SubStr(cImposto,4,1)$"02",nImpCSLL:=1,nImpCSLL:=Len(aVencto))
            If(SubStr(cImposto,5,1)$"02",nImpCOF:=1,nImpCOF:=Len(aVencto))
            If(SubStr(cImposto,6,1)$"02",nImpPIS:=1,nImpPIS:=Len(aVencto))
            If(SubStr(cImposto,7,1)$"02",nImpFet:=1,nImpFet:=Len(aVencto))          
            If(SubStr(cImposto,8,1)$"02",nImpFab:=1,nImpFab:=Len(aVencto))          
            If(SubStr(cImposto,9,1)$"02",nImpFac:=1,nImpFac:=Len(aVencto))                                  
        EndIf

        If nImpISS == 1 .And. !(SF2->F2_TIPO$"DB") .And. cRecISS =="1" .And. SuperGetMV("MV_DESCISS") .And. Len(aVencto) > 1 .And. !lGerAbtISS
            nAbtISS := aTitulo[_VLRISS_]
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Aplica a condicao de pagamento                                         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If nAbtISS != 0
            aVencto := Condicao(aTitulo[_VLRTIT_]+nAbtISS,SF2->F2_COND,aTitulo[_VLRIPI_],dDataCnd,aTitulo[_VLRSOL_],,,aTitulo[_VLRACR_])
            //
            // Template GEM - Gestao de Empreendimentos Imobiliarios
            //
            If ExistBlock("GMMA410Dupl")
                aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_]+nAbtISS,aVencto}, .F., .F.) 
            Else
                If ExistTemplate("GMMA410Dupl")
                    aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_]+nAbtISS,aVencto}) 
                EndIf
            Endif   
        EndIf
        nTotMoed1  := aTitulo[_VLRTIT_]
      //-- CRT - Conhecimento Transporte Internacional - Valor está em dolar.
        If nModulo == 43 .And. nMoeda <> 1 
            nTotMoed1:= Round(NoRound(xMoeda(aTitulo[_VLRTIT_],nMoeda,1,dDataMoe,3),3),2)
        EndIf
        
        If nMoeda <> 1
            If nModulo == 43
                nTotMoeda  := aTitulo[_VLRTIT_]
            Else
                nTotMoeda  := xMoeda(aTitulo[_VLRTIT_],1,nMoeda,dDataMoe)+aTitulo[_VLRTITDIF_]
            EndIf   
        Else        
            nTotMoeda  := xMoeda(aTitulo[_VLRTIT_],1,nMoeda,dDataMoe)
        EndIf

        If ExistBlock("ME4_COND")
            aVencto := Condicao(aTitulo[_VLRTIT_]+nAbtISS,SF2->F2_COND,SF2->F2_VALIPI,dDataCnd,SF2->F2_ICMSRET,,ExecBlock("ME4_COND",.F.,.F.),aTitulo[_VLRACR_])
            //
            // Template GEM - Gestao de Empreendimentos Imobiliarios
            //
            If ExistBlock("GMMA410Dupl")
                aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_]+nAbtISS,aVencto}, .F., .F.) 
            Else
                If ExistTemplate("GMMA410Dupl")
                    aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{cPedido ,SF2->F2_COND,dDataCnd,,aTitulo[_VLRTIT_]+nAbtISS,aVencto}) 
                EndIf
            Endif   
        EndIf
        If ExistBlock("MT461VCT")
            aVencto := ExecBlock("MT461VCT",.F.,.F.,{aVencto,aTitulo})
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica a primeira parcela                                            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If ( Len(aVencto) > 1 )
            cParcela := SuperGetMv("MV_1DUP")
        EndIf
        If ExistBlock("M4601DUP")
            cParcela := ExecBlock("M4601DUP",.F.,.F.,{cParcela})
        EndIf   
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica os impostos a serem gravados                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aImposto := {{0,0},;
            {aTitulo[_VLRIRRF_],0},;
            {aTitulo[_VLRINSS_],0},;
            {aTitulo[_VLRISS_],0},;
            {aTitulo[_VLRPIS_],0},;             
            {aTitulo[_VLRCSLL_],0},;
            {aTitulo[_VLRCOFI_],0},;
            {aTitulo[_VLRFET_],0},;
            {aTitulo[_VLRFAB_],0},;
            {aTitulo[_VLRFAC_],0},;
            {0,0},{0,0},{0,0},{0,0},;
            {0,0},{0,0},{0,0},{0,0},;
            {0,0},{0,0},{0,0},;
            {aTitulo[_VLRTPDP_],0}}
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualizacao das parcelas do contas a receber                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        dbSelectArea("SE1")                                
        
        If cModRet == "1" .And. lContrAbt
            
            nAbtISSAnt := nAbtISS
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //|FOR SOMENTE PARA DETERMINAR O VALOR A SER COMPARADO COM O MV_VL10925    |
            //|                                                                        |
            //³ Obtem os totais por mes antes de processar                             ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            For nCntFor := 1 To Len(aVencto)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Calculo valor acumulado do MES de acordo com a definicao do parametro ³
                //³  MV_RTIPFIN que determina em qual parcela deverah haver a retencao.  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !(nImpCSLL==nCntFor .And. nImpCOF==nCntFor .And. nImpPIS==nCntFor)
                    Loop
                EndIf
                
                If lBaseImp .And. nBasePCC>0
                    nVlrParc  := nVlrMoed1 := NoRound( xMoeda((nBasePCC/Len(aVencto)),1,nMoeda,dDataMoe), nDecE1Vlr )
                Else
                    nVlrParc  := NoRound( xMoeda(aVencto[nCntFor][2]-nAbtISSAnt,1,nMoeda,dDataMoe), nDecE1Vlr )
                    nVlrMoed1 := NoRound( aVencto[nCntFor][2]-nAbtISSAnt, nDecE1Vlc )
                EndIf
                
                If nCntFor == 1
                    nAbtISSAnt := 0
                EndIf
                
                nVlrAcum1 += nVlrParc
                nVlrAcum2 += nVlrMoed1
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Na Ultima Parcela acerta as diferenca de centavo                        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( Len(aVencto)==nCntFor ) .AND. ! lCondVenda
                    If lBaseImp .And. nBasePCC>0
                        nVlrParc += nBasePCC - nVlrAcum1
                        nVlrMoed1+= nBasePCC  - nVlrAcum2
                    Else
                        nVlrParc += nTotMoeda - nVlrAcum1
                        nVlrMoed1+= nTotMoed1  - nVlrAcum2
                    EndIf
                EndIf
                
                cAnoMes := Left( DToS( DataValida( aVencto[nCntFor,1],.T.) ), 6 )
                
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Alimenta os acumulados por Ano / Mes                                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If Empty( nScanMes := AScan( aAcumulMes, { |x| x[1] == cAnoMes } ) )
                    AAdd( aAcumulMes, { cAnoMes, 0 } )
                    nScanMes := Len( aAcumulMes )
                EndIf
                
                aAcumulMes[ nScanMes, 2 ] += nVlrParc
                
            Next nCntFor
            
        EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calcula a proporcao da parcelaa do PIS,COFINS e CSLL                   ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nValPis := 0
        nValCof := 0
        nValCsl := 0
        
        For nX := 1 to Len(aVencto)
            nValTot += aVencto[nX][2]
        Next
                            
        aProp := {} 
            
        nSaldoProp := 1 
    
        For nX := 1 to Len(aVencto) 
            If nX == Len(aVencto)  
                nProp := nSaldoProp
            Else            
                nProp := Round(aVencto[nX][2] / nValTot,6)
                nSaldoProp -= nProp
            EndIf   
           AAdd( aProp, nProp )
        Next nX
        
        //
        // Template GEM - Gestao de Empreendimentos Imobiliarios
        //
        // Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
        //
        If ExistTemplate("GEMMA461") .And. HasTemplate("LOT")
            aTitCndVnd := ExecTemplate("GEMMA461",.F.,.F.,{cPedido ,SF2->F2_COND ,dDataCnd ,aTitulo[_VLRTIT_]+nAbtISS }) 
        EndIf
        
        nVlrAcum1 := 0
        nVlrAcum2 := 0
        
        nVlrParc  := 0
        nVlrMoed1 := 0
                
        For nCntFor := 1 To Len(aVencto)
        
            //
            // Tipo de parcela = E1_TIPO
            //
            cTipoParc := MVNOTAFIS
            
            //
            // Template GEM - Gestao de empreendimentos imobiliarios
            // Condicao de pagto com condicao de venda
            //
            If ExistTemplate("GEMTipTit")
                cTipoParc := ExecTemplate("GEMTipTit",.F.,.F.,{cTipoParc,aVencto[nCntFor][1],SF2->F2_COND})
            EndIf                                  
            
            //-- SIGATMS = Retorna Tipo do Titulo (E1_TIPO) com base no parametro MV_TMSTIPT
            If IntTms() .And. nModulo==43 .And. FindFunction("TmsTpTit")
                TmsTpTit(@cTipoParc)                
            EndIf
    
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Calcula a proporcao da parcela em relacao ao total de duplicatas       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            nFatorParc := ( aVencto[nCntFor][2]-nAbtISS ) / ( aTitulo[_VLRTIT_]+nAbtISS )

            // Se Cond.Pagto tipo 9, moeda 2 e MV_MOEDTIT = "S", array a Vencto ja esta em Moeda 2,
            // e nao precisa converter.
            If (SE4->E4_TIPO == "9" .Or. nModulo == 43) .And. nMoeda <> 1 .And. cMoedaTit == "S"
                nVlrParc := NoRound( aVencto[nCntFor][2]-nAbtISS, nDecE1Vlr )
                // Valor em moeda 1 que devera ser gravado no campo E1_VLCRUZ
                nVlrMoed1:= NoRound( xMoeda(aVencto[nCntFor][2]-nAbtISS,nMoeda,1,dDataMoe), nDecE1Vlc )             
            Else
                nVlrParc := NoRound( xMoeda(aVencto[nCntFor][2]-nAbtISS,1,nMoeda,dDataMoe), nDecE1Vlr ) 
                nVlrMoed1:= NoRound( aVencto[nCntFor][2]-nAbtISS, nDecE1Vlc )               
            EndIf
            
            If nCntFor == 1
                nAbtISS := 0
            EndIf

            nVlrAcum1 += nVlrParc
            nVlrAcum2 += nVlrMoed1
            
            If ! lCondVenda 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Na Ultima Parcela acerta as diferenca de centavo                        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If ( Len(aVencto)==nCntFor )
                    nVlrParc += nTotMoeda - nVlrAcum1
                    nVlrMoed1+= nTotMoed1  - nVlrAcum2
                EndIf
            EndIf

            RecLock("SE1",.T.)
            If SE1->(FieldPos ("E1_SCORGP"))>0      //Campo da tabela SE1 identifica fornecimento de (1) bens e Servicos contratados por pessoa juridica de direito publico ou (2 ou '') identifica que Nao.
                If ("1"$cA1M996) .And. ("1"$cB1M996)
                    SE1->E1_SCORGP  :=  "1"
                EndIf
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
            //³Mais especificamente o paragrafo unico do Art 2.                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SE1->(FieldPos ("E1_FRETISS"))>0
                If ("2"$cA1FRETISS) .And. ("2"$cB1FRETISS)
                    SE1->E1_FRETISS :=  "2"
                Else
                    SE1->E1_FRETISS :=  "1"
                EndIf
            EndIf
            // Tratamento para a cidade de Cascavel-PR Decreto n.º 8.230
            If (SF4->(FieldPos ("F4_FRETISS"))>0) .And. (SE1->(FieldPos ("E1_VLMINIS"))>0) 
                SE1->E1_VLMINIS :=  SF4->(FieldGet (FieldPos ("F4_FRETISS")))
            EndIf
            //
            SE1->E1_FILIAL := xFilial("SE1")
            SE1->E1_PREFIXO:= &(SuperGetMv("MV_1DUPREF"))
            SE1->E1_NUM    := SF2->F2_DOC
            SE1->E1_PARCELA:= cParcela

            SE1->E1_TIPO   := cTipoParc 

            SE1->E1_CLIENTE:= SF2->F2_CLIENTE
            SE1->E1_LOJA   := SF2->F2_LOJA
            SE1->E1_SERIE  := SF2->F2_SERIE
            SE1->E1_PEDIDO := cPedido
            SE1->E1_NOMCLI := If(Empty(SA1->A1_NREDUZ),SA1->A1_NOME,SA1->A1_NREDUZ)
            SE1->E1_EMISSAO:= SF2->F2_EMISSAO
            SE1->E1_VALOR  := nVlrParc
            SE1->E1_SALDO  := SE1->E1_VALOR
            SE1->E1_VLCRUZ := nVlrMoed1
            SE1->E1_LA     := "S"
            SE1->E1_SITUACA:= "0"
            SE1->E1_MOEDA  := nMoeda
            SE1->E1_EMIS1  := dDataBase
            SE1->E1_VENCTO := aVencto[nCntFor][1]
            SE1->E1_VENCORI:= SE1->E1_VENCTO
            SE1->E1_VENCREA:= DataValida(SE1->E1_VENCTO,.T.)
            SE1->E1_STATUS := "A"
            SE1->E1_PORCJUR:= nPerJur
            SE1->E1_VALJUR := Round(SE1->E1_VALOR * (SE1->E1_PORCJUR / 100),2)
            SE1->E1_OCORREN:= CriaVar("E1_OCORREN")
            SE1->E1_DESCFIN:= SE4->E4_DESCFIN
            SE1->E1_DIADESC:= SE4->E4_DIADESC
            If SE1->(FieldPos("E1_FORNISS"))<>0
                SE1->E1_FORNISS:= cFornISS
            EndIf
            SE1->E1_NATUREZ:= &(SuperGetMv("MV_1DUPNAT"))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Recalcula os impostos com base na natureza do parametro                 ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SE1->E1_NATUREZ <> MaFisRet(,"NF_NATUREZA")
                MaFisAlt("NF_NATUREZA",SE1->E1_NATUREZ)
                aTitulo[_VLRIRRF_] := MaFisRet(,"NF_VALIRR")
                aTitulo[_VLRINSS_] := MaFisRet(,"NF_VALINS")
                aTitulo[_VLRINSS_] := MaFisRet(,"NF_VALINA")
                aTitulo[_VLRISS_]  := IIf(cRecISS=="1", MaFisRet(,"NF_VALISS"), 0)
                aTitulo[_VLRPIS_]  := MaFisRet(,"NF_VALPIS")
                aTitulo[_VLRCSLL_] := MaFisRet(,"NF_VALCSL")
                aTitulo[_VLRCOFI_] := MaFisRet(,"NF_VALCOF")
                aTitulo[_VLRFET_]  := MaFisRet(,"NF_VALFET")                
                aTitulo[_VLRFAB_]  := MaFisRet(,"NF_VALFAB")                
                aTitulo[_VLRFAC_]  := MaFisRet(,"NF_VALFAC")
                //aTitulo[_VLRTPDP_] := MaFisRet(,"NF_VALTPDP")                             
                aImposto := {{0,0},;
                    {aTitulo[_VLRIRRF_],0},;
                    {aTitulo[_VLRINSS_],0},;
                    {aTitulo[_VLRISS_],0},;
                    {aTitulo[_VLRPIS_],0},;
                    {aTitulo[_VLRCSLL_],0},;
                    {aTitulo[_VLRCOFI_],0},;
                    {aTitulo[_VLRFET_],0},;
                    {aTitulo[_VLRFAB_],0},;
                    {aTitulo[_VLRFAC_],0},;
                    {0,0},{0,0},{0,0},{0,0},;
                    {0,0},{0,0},{0,0},{0,0},;
                    {0,0},{0,0},{0,0},;
                    {aTitulo[_VLRTPDP_],0}}
            EndIf
            dbSelectArea("SED")
            dbSetOrder(1)
            MsSeek(xFilial("SED")+SE1->E1_NATUREZ)            
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Os Impostos sao calculados apena na primeira parcela                    ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SED->ED_CALCISS=="S"
            
                If nImpISS == 1 
                    SE1->E1_ISS := NoRound(aImposto[_VLRISS_][1],2)
                Else                    
                    SE1->E1_ISS := NoRound(aImposto[_VLRISS_][1]*nFatorParc,2)
                EndIf                   
                    
                aImposto[_VLRISS_][2] += SE1->E1_ISS
                If nCntFor == nImpISS
                    SE1->E1_ISS += aImposto[_VLRISS_][1]-aImposto[_VLRISS_][2]
                    //Tratamento para alíquotas parciais de retenção ISS -> Campo da tabela SB1 no parâmetro MV_ALISSB1
                    If SB1->(FieldPos(cAlIssB1)) > 0
                        If SB1->&(cAlIssB1) > 0
                            nRetParISS  := SFT->FT_VALCONT * SB1->&(cAlIssB1) / 100
                            SE1->E1_ISS := SE1->E1_ISS - nRetParISS
                        Endif
                    Endif
                    //
                    aImposto[_VLRISS_][1] := 0
                    aImposto[_VLRISS_][2] := 0
                EndIf
            EndIf                 
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do IRRF                                                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nImpIRRF == 1 
                SE1->E1_IRRF := NoRound(aImposto[_VLRIRRF_][1],2)
            Else    
                SE1->E1_IRRF := NoRound(aImposto[_VLRIRRF_][1]*nFatorParc,2)
            EndIf                   
            
            If SE1->(FieldPos("E1_BASEIRF")) > 0                    
                If nCntFor == Len(aVencto)
                    SE1->E1_BASEIRF := nSaldoIrf
                Else
                    SE1->E1_BASEIRF := nBaseIrf * aProp[nCntFor]
                    nSaldoIrf -= SE1->E1_BASEIRF
                Endif   
            Endif
 
            aImposto[_VLRIRRF_][2] += SE1->E1_IRRF
            If nCntFor == nImpIRRF
                SE1->E1_IRRF += aImposto[_VLRIRRF_][1]-aImposto[_VLRIRRF_][2]
                aImposto[_VLRIRRF_][1] := 0
                aImposto[_VLRIRRF_][2] := 0
            EndIf             
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do INSS                                                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nImpINSS == 1 
                SE1->E1_INSS := NoRound(aImposto[_VLRINSS_][1],2)
            Else            
                SE1->E1_INSS := NoRound(aImposto[_VLRINSS_][1]*nFatorParc,2)
            EndIf 

            If SE1->(FieldPos("E1_BASEINS")) > 0                    
                If nCntFor == Len(aVencto)
                    SE1->E1_BASEINS := nSaldoIns
                Else
                    SE1->E1_BASEINS := nBaseIns * aProp[nCntFor]
                    nSaldoIns -= SE1->E1_BASEINS
                Endif   
            Endif 

            aImposto[_VLRINSS_][2] += SE1->E1_INSS
            If nCntFor == nImpINSS
                SE1->E1_INSS += aImposto[_VLRINSS_][1]-aImposto[_VLRINSS_][2]
                aImposto[_VLRINSS_][1] := 0
                aImposto[_VLRINSS_][2] := 0
            EndIf                                               
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do CSLL                                                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nImpCSLL == 1 
                SE1->E1_CSLL := NoRound(aImposto[_VLRCSLL_][1],2)
            Else 
                SE1->E1_CSLL := NoRound(aImposto[_VLRCSLL_][1]*nFatorParc,2)
            EndIf   

            If SE1->(FieldPos("E1_BASECSL")) > 0                    
                If nCntFor == Len(aVencto)
                    SE1->E1_BASECSL := nSaldoCsl
                Else
                    SE1->E1_BASECSL := nBaseCsl * aProp[nCntFor]
                    nSaldoCsl -= SE1->E1_BASECSL
                Endif   
            Endif
                
            aImposto[_VLRCSLL_][2] += SE1->E1_CSLL
            
            If nCntFor == nImpCSLL
                SE1->E1_CSLL += aImposto[_VLRCSLL_][1]-aImposto[_VLRCSLL_][2]
                aImposto[_VLRCSLL_][1] := 0
                aImposto[_VLRCSLL_][2] := 0
            EndIf    

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do CoFins                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nImpCof == 1
                SE1->E1_COFINS := NoRound(aImposto[_VLRCOFI_][1],2)
            Else    
                SE1->E1_COFINS := NoRound(aImposto[_VLRCOFI_][1]*nFatorParc,2)
            EndIf   

            If SE1->(FieldPos("E1_BASECOF")) > 0                    
                If nCntFor == Len(aVencto)
                    SE1->E1_BASECOF := nSaldoCof
                Else
                    SE1->E1_BASECOF := nBaseCof * aProp[nCntFor]
                    nSaldoCof -= SE1->E1_BASECOF
                Endif   
            Endif
                
            aImposto[_VLRCOFI_][2] += SE1->E1_COFINS
            
            If nCntFor == nImpCOF
                SE1->E1_COFINS += aImposto[_VLRCOFI_][1]-aImposto[_VLRCOFI_][2]
                aImposto[_VLRCOFI_][1] := 0
                aImposto[_VLRCOFI_][2] := 0
            EndIf 

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do PIS                                                 ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nImpPIS == 1 
                SE1->E1_PIS := NoRound(aImposto[_VLRPIS_][1]/nImpPIS,2)
            Else
                SE1->E1_PIS := NoRound(aImposto[_VLRPIS_][1]*nFatorParc,2)              
            EndIf               

            If SE1->(FieldPos("E1_BASEPIS")) > 0                    
                If nCntFor == Len(aVencto)
                    SE1->E1_BASEPIS := nSaldoPis
                Else
                    SE1->E1_BASEPIS := nBasePis * aProp[nCntFor]
                    nSaldoPis -= SE1->E1_BASEPIS
                Endif   
            Endif
                
            aImposto[_VLRPIS_ ][2] += SE1->E1_PIS
            
            If nCntFor == nImpPIS
                SE1->E1_PIS += aImposto[_VLRPIS_][1]-aImposto[_VLRPIS_][2]
                aImposto[_VLRPIS_][1] := 0
                aImposto[_VLRPIS_][2] := 0
            EndIf               
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do imposto Fethab                                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lFethab
                If nImpFet == 1
                    SE1->E1_FETHAB := NoRound(aImposto[_IMPFET_][1],2)
                Else    
                    SE1->E1_FETHAB := NoRound(aImposto[_IMPFET_][1]*nFatorParc,2)
                EndIf   
                
                aImposto[_IMPFET_][2] += SE1->E1_FETHAB
                If nCntFor == nImpFet
                    SE1->E1_FETHAB += aImposto[_IMPFET_][1]-aImposto[_IMPFET_][2]
                    aImposto[_IMPFET_][1] := 0
                    aImposto[_IMPFET_][2] := 0
                EndIf 
            Endif

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do imposto Fabov                                       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lFabov
                If nImpFab == 1
                    SE1->E1_FABOV := NoRound(aImposto[_IMPFAB_][1],2)
                Else
                    SE1->E1_FABOV := NoRound(aImposto[_IMPFAB_][1]*nFatorParc,2)
                EndIf
                
                aImposto[_IMPFAB_][2] += SE1->E1_FABOV
                If nCntFor == nImpFab
                    SE1->E1_FABOV += aImposto[_IMPFAB_][1]-aImposto[_IMPFAB_][2]
                    aImposto[_IMPFAB_][1] := 0
                    aImposto[_IMPFAB_][2] := 0
                EndIf
            Endif
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua o calculo do imposto Facs                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lFacs
                If nImpFac == 1
                    SE1->E1_FACS := NoRound(aImposto[_IMPFAC_][1],2)
                Else
                    SE1->E1_FACS := NoRound(aImposto[_IMPFAC_][1]*nFatorParc,2)
                EndIf
                
                aImposto[_IMPFAC_][2] += SE1->E1_FACS
                If nCntFor == nImpFac
                    SE1->E1_FACS += aImposto[_IMPFAC_][1]-aImposto[_IMPFAC_][2]
                    aImposto[_IMPFAC_][1] := 0
                    aImposto[_IMPFAC_][2] := 0
                EndIf
            Endif
                        
            If lM460IREN
                SE1->E1_IRRF := ExecBlock("M460IREN",.F.,.F.,SE1->E1_IRRF)
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Efetua a Gravacao dos Vendedores                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SE1")
            cVendedor := "1"
            lTemVend := .F.
            For nVendedor := 1 To nMaxVend
                cConteudo := SF2->(FieldGet(FieldPos("F2_VEND"+cVendedor)))
                If (!Empty(cConteudo))
                    lTemVend := .T.
                EndIf
                FieldPut(FieldPos("E1_VEND"+cVendedor),cConteudo)
                If SE1->(FieldPos("E1_ALEMIS"+cVendedor))<>0
                    SA3->(dbSetOrder(1))
                    SA3->(MsSeek(xFilial("SA3")+cConteudo))
                    FieldPut(FieldPos("E1_ALEMIS"+cVendedor),SA3->A3_ALEMISS)
                EndIf
                If SE1->(FieldPos("E1_ALBAIX"+cVendedor))<>0
                    SA3->(dbSetOrder(1))
                    SA3->(MsSeek(xFilial("SA3")+cConteudo))
                    FieldPut(FieldPos("E1_ALBAIX"+cVendedor),SA3->A3_ALBAIXA)
                EndIf
                
                If SF2->(FieldPos("F2_CODRL"+cVendedor))>0 .And. SE1->(FieldPos("E1_CODRL"+cVendedor))>0
                    cConteudo := SF2->(FieldGet(FieldPos("F2_CODRL"+cVendedor)))
                    FieldPut(FieldPos("E1_CODRL"+cVendedor),cConteudo)
                EndIf               
                cVendedor := Soma1(cVendedor,1)
            Next nVendedor
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Integracao como Financeiro                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            aImpOut := {SE1->E1_INSS,SE1->E1_ISS,SE1->E1_PIS,SE1->E1_CSLL,SE1->E1_COFINS}           

            cAnoMes := Left( DToS( SE1->E1_VENCREA ), 6 ) 
         
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Indica se o tratamento de valor minimo para retencao (R$ 5.000,00) deve ser aplicado:³
            //³1 = Aplica o valor minimo                                                            ³
            //³2 = Nao aplica o valor minimo                                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SE1->(FieldPos("E1_APLVLMN")) > 0
                SE1->E1_APLVLMN := cAplVlMn
            Endif
                        
            If lContrAbt

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Grava o saldo para abatimento                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                SE1->E1_SABTPIS := SE1->E1_PIS 
                SE1->E1_SABTCOF := SE1->E1_COFINS           
                SE1->E1_SABTCSL := SE1->E1_CSLL             

                If cRetCli == "1" 
                
                    If cModRet == "1" 
                
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Pesquisa nos valores pagos para verificar se deve reter a parcela                        ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If !Empty( nScanMes := AScan( aAcumulMes, { |x| x[1] == cAnoMes } ) )               
                            lAbate := ( aAcumulMes[ nScanMes, 2 ] > nValMinRet )
                        Else 
                           lAbate := .T. 
                        EndIf                   
                    
                    ElseIf cModRet == "2"
                    
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Verifica os titulos para o mes de referencia, para verificar se atingiu a retencao       ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        
                        // Estrutura de aDadosRet 
                        // 1-Valor dos titulos 
                        // 2-Valor do PIS
                        // 3-Valor do COFINS
                        // 4-Valor da CSLL 
                        // 5-Array contendo os recnos dos titulos 
                        
                        nVlRetPIS := 0
                        nVlRetCOF := 0
                        nVlRetCSLL:= 0 
                        
                        aDadosRet := MaNfsCalRt( If( cTipoData == "2", SE1->E1_VENCTO, SE1->E1_VENCREA ) )
                        
                        lAbate := .F.
                        
                        If aDadosRet[ 6 ] > nValMinRet  // PIS 
                            lAbate := .T. 
                            nVlRetPIS  := aDadosRet[ 2 ] 
                        EndIf 

                        If aDadosRet[ 7 ] > nValMinRet  // COFINS 
                            lAbate := .T. 
                            nVlRetCOF  := aDadosRet[ 3 ] 
                        EndIf 
      
                        If aDadosRet[ 8 ] > nValMinRet  // CSLL
                            lAbate := .T. 
                            nVlRetCSLL := aDadosRet[ 4 ]
                        EndIf 
                        
                        If lAbate
                        
                            nVlRetPIS  := aDadosRet[ 2 ] 
                            nVlRetCOF  := aDadosRet[ 3 ] 
                            nVlRetCSLL := aDadosRet[ 4 ]                                                                                    
                            
                            nTotARet := nVlRetPIS + nVlRetCOF + nVlRetCSLL
                            
                            nSobra := SE1->E1_VALOR - nTotARet
                        
                            If nSobra < 0                                                           

                                nSavRec := SE1->( Recno() ) 
                            
                                nFatorRed := 1 - ( Abs( nSobra ) / nTotARet ) 
                                
                                nVlRetPIS  := NoRound( nVlRetPIS * nFatorRed, 2 ) 
                                nVlRetCOF  := NoRound( nVlRetCOF * nFatorRed, 2 )                       
                                
                                nVlRetCSLL := SE1->E1_VALOR - ( nVlRetPIS + nVlRetCOF ) 


                                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                //³ Grava o valor de NCC caso a retencao seja maior   ³
                                //³ que o valor do titulo                             ³                         
                                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                If FindFunction("ADUPCREDRT")
                                    ADupCredRt(Abs(nSobra),"101",nMoeda)
                                Endif   
                                
                                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                //³ Restaura o registro do titulo original            ³
                                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                SE1->( MsGoto( nSavRec ) )                              
                                
                                Reclock( "SE1", .F. )                               
                            
                            EndIf 
                            
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³ Grava os novos valores de retencao                ³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            If !Empty( nVlRetPIS )                                                      
                                SE1->E1_PIS    := nVlRetPIS                     
                            Endif   
                            If !Empty( nVlRetCOF )                                                              
                                SE1->E1_COFINS := nVlRetCOF                                         
                            Endif   
                            If !Empty( nVlRetCSLL )
                                SE1->E1_CSLL   := nVlRetCSLL                                        
                            Endif   
                            
                    
                            nSavRec := SE1->( Recno() ) 
                            
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³ Zera os saldos a abater dos demais movimentos     ³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            aRecnos := aClone( aDadosRet[ 5 ] ) 
                            
                            cPrefOri  := SE1->E1_PREFIXO
                            cNumOri   := SE1->E1_NUM
                            cParcOri  := SE1->E1_PARCELA
                            cTipoOri  := SE1->E1_TIPO
                            cCfOri    := SE1->E1_CLIENTE
                            cLojaOri  := SE1->E1_LOJA
                                            
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³Ponto de entrada - permite a alteracao do array aRecnos para atualizacao do SE1   ³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            If ExistBlock("M461GRVTAB")                     
                                aRecnos := ExecBlock("M461GRVTAB", .F., .F., {aRecnos})
                            EndIf
                            For nLoop := 1 to Len( aRecnos )
                            
                                SE1->( dbGoto( aRecnos[ nLoop ] ) )
                                
                                RecLock( "SE1", .F. ) 
                                
                                SE1->E1_SABTPIS := 0 
                                SE1->E1_SABTCOF := 0                        
                                SE1->E1_SABTCSL := 0
                                
                                SE1->( MsUnlock() )                                                                                                 

                                If AliasIndic("SFQ")                                                                    
                                    If nSavRec <> aRecnos[ nLoop ] 
                                        dbSelectArea("SFQ")
                                        RecLock("SFQ",.T.)
                                            SFQ->FQ_FILIAL  := xFilial("SFQ")
                                            SFQ->FQ_ENTORI  := "SE1"
                                            SFQ->FQ_PREFORI := cPrefOri
                                            SFQ->FQ_NUMORI  := cNumOri
                                            SFQ->FQ_PARCORI := cParcOri
                                            SFQ->FQ_TIPOORI := cTipoOri                                     
                                            SFQ->FQ_CFORI   := cCfOri
                                            SFQ->FQ_LOJAORI := cLojaOri
                                            
                                            SFQ->FQ_ENTDES  := "SE1"
                                            SFQ->FQ_PREFDES := SE1->E1_PREFIXO
                                            SFQ->FQ_NUMDES  := SE1->E1_NUM
                                            SFQ->FQ_PARCDES := SE1->E1_PARCELA                             
                                            SFQ->FQ_TIPODES := SE1->E1_TIPO
                                            SFQ->FQ_CFDES   := SE1->E1_CLIENTE
                                            SFQ->FQ_LOJADES := SE1->E1_LOJA
                                        MsUnlock()
                                    Endif                               
                                Endif                   
                            Next nLoop 
                            
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³ Retorna do ponteiro do SE1 para a parcela         ³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            SE1->( MsGoto( nSavRec ) ) 
                            Reclock( "SE1", .F. ) 
                        
                        Else    
                            lAbate := .F.                   
                        EndIf               
                    
                    EndIf
                ElseIf cRetCli == "2"
                    lAbate := .T. 
                ElseIf cRetCli == "3"
                    lAbate := .F. 
                EndIf               
                
            EndIf               
    
            If !lAbate .And. cModRet == "1"
                aImpOut[3]  :=   aImpOut[4] :=  aImpOut[5]  :=  0
                aImposto[_VLRPIS_ ][1]  :=  aImposto[_VLRPIS_ ][2]  :=  0
                If lContrAbt
                    SE1->E1_SABTPIS :=  0
                EndIf
                SE1->E1_BASEPIS :=  0
                SE1->E1_PIS     :=  0
                aImposto[_VLRCOFI_ ][1] :=  aImposto[_VLRCOFI_ ][2] :=  0
                If lContrAbt
                    SE1->E1_SABTCOF :=  0
                EndIf
                SE1->E1_BASECOF :=  0
                SE1->E1_COFINS  :=  0
                aImposto[_VLRCSLL_ ][1] :=  aImposto[_VLRCSLL_ ][2] :=  0
                If lContrAbt
                    SE1->E1_SABTCSL :=  0
                EndIf
                SE1->E1_BASECSL :=  0
                SE1->E1_CSLL    :=  0
            EndIf

            If SE1->(FieldPos("E1_TPDP"))> 0 
                If ValType(aImposto[_VLRTPDP_][1]) == "A" .And. aImposto[_VLRTPDP_][1][1] > 0
                    SE1->E1_TPDP := aImposto[_VLRTPDP_][1][1] * nFatorParc
                ElseIf ValType(aImposto[_VLRTPDP_][1]) == "N" .And. aImposto[_VLRTPDP_][1] > 0
                    SE1->E1_TPDP := aImposto[_VLRTPDP_][1] * nFatorParc
                EndIf 
            EndIf
                    
            A040DupRec( "MATA460",(nCntFor == 1),aTitulo[_VLRTIT_], lAbate, lGerAbtISS,, aTitulo[_VLRISS_], MaFisRet(,"NF_RECISS"), , aMedicao , aProp[nCntFor] , (nCntFor == Len(aVencto)),,cRetCli)

            If lAtuSldNat
                AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG,"3","2"), "R", SE1->E1_VALOR, SE1->E1_VLCRUZ, If(SE1->E1_TIPO$MVABATIM,"-","+"),,FunName(),"SE1", SE1->(Recno()),0)
            Endif
            
            //
            // Template GEM - Gestao de Empreendimentos Imobiliarios
            //
            // Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
            //
            If ExistTemplate("GEMLIXPARC")
                ExecTemplate("GEMLIXPARC",.F.,.F.,{SE1->E1_PREFIXO ,SE1->E1_NUM  ,SE1->E1_PARCELA ;
                                                  ,SE1->E1_TIPO    ,SF2->F2_COND ,SE1->E1_VALOR   ;
                                                  ,iIf(Len(aTitCndVnd)>=nCntFor,aTitCndVnd[nCntFor],{}) ; // Detalhes do Titulo a receber(amortizacao,juros,etc)
                                                  } ) 
            
            EndIf
            
            SE1->(MsUnLock())
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Rotina de Importacao automatica de Titulos entre        ³
            //³ Filial e Matriz (Fa620Auto).                            ³
            //³ Parametros:                                             ³
            //³ 1- Recno do Titulo principal.                           ³
            //³ 2- Filial destino.                                      ³
            //³ 3- Historico.                                           ³
            //³ 4- Executa aprovacao automatica. (Logico)               ³
            //³ 5- Apresenta mensagens de Erro. (Logico)                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SuperGetMv("MV_RETAUTO",,.F.) .And. SF4->(FieldPos('F4_TRAFILI')) > 0
                If SF4->F4_TRAFILI == "1"
                    Fa620Auto(SE1->(RECNO()),SuperGetMv("MV_REMATRI", ,""),"Transferência",SuperGetMv("MV_APRAUTO",.F.,.T.),.T.)
                EndIf
            EndIf 
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Atualiza o SF2                                                          ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If !Intransact()
                RecLock("SF2")
            EndIf
            SF2->F2_VALFAT  += SE1->E1_VALOR
            SF2->F2_PREFIXO := SE1->E1_PREFIXO
            SF2->F2_DUPL    := SE1->E1_NUM
            SF2->F2_VALIRRF += SE1->E1_IRRF
            SF2->F2_VALINSS += SE1->E1_INSS - aImpOut[1]
//          SF2->F2_VALISS  += SE1->E1_ISS  - aImpOut[2]
            
            If !lContrAbt .Or. Len( aRecnos ) <= 1 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Corrige apenas se nao aglutinadora  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                SF2->F2_VALPIS  += SE1->E1_PIS  - aImpOut[3]
                SF2->F2_VALCSLL += SE1->E1_CSLL - aImpOut[4]
                SF2->F2_VALCOFI += SE1->E1_COFINS - aImpOut[5]
            EndIf
            
            aCtbRet[1] += SE1->E1_PIS
            aCtbRet[2] += SE1->E1_COFINS
            aCtbRet[3] += SE1->E1_CSLL

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Calcula a Proxima Parcela                                               ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            cParcela := MaParcela(cParcela)
            nValfun     := 0
            Aadd(aRecSe1,SE1->(Recno()))
            Aadd(aRecSE1Adt,SE1->(Recno()))
        Next nCntFor
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Calcula a Comissao                                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        For nCntFor:= 1 To Len(aRecSe1)
            If ( lComissao .And. lTemVend )
                dbSelectArea("SE1")
                MsGoto(aRecSe1[nCntFor])
                Fa440CalcE("MATA460")
                If lF440Com
                    ExecBlock("F440COM",.F.,.F., aRecSE1)
                EndIf
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³CodeBlock de integracao com outros modulos                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            Eval(bAtuFin,aRecSe1[nCntFor])
        Next nCntFor
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o valor de retencao do PIS/COFINS/CSLL para contabilizacao  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If GetNewPar("MV_CTRETNF","1")=="2"
            RecLock("SF2")
            If SF2->(FieldPos("F2_VALPIS"))>0
                SF2->F2_VALPIS := aCtbRet[1]
            EndIf
            If SF2->(FieldPos("F2_VALCOFI"))>0
                SF2->F2_VALCOFI := aCtbRet[2]
            EndIf
            If SF2->(FieldPos("F2_VALCSLL"))>0
                SF2->F2_VALCSLL := aCtbRet[3]
            EndIf
        EndIf       
    EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza caucao de contrato           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aContrato) > 0
    CtaAbatCauc( 1, aContrato[1], aRecSe1, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_DOC, SF2->F2_SERIE, NIL, SF2->F2_VALBRUT ) 
EndIf

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaPvPrcIt³ Autor ³Edson Maricate          ³ Data ³07.10.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o preco unitario do item.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaPvPrcIt(aPvlNfs,nx,lReajuste,aRateio,nValNeg,nPerISS,dDataMoe)

Local aVar      := {}
Local nPrTab    := 0
Local nPrcVen   := 0
Local nPrUnit   := 0
Local nAcresFin := 0
Local nTotal    := 0
Local nDesconto := 0      
Local nTotMdPv  := 0       
Local lAcresDup := ( SuperGetMv("MV_ACRSDUP",.F.,.F.) == .T.)
Local lM461PRCV := FindFunction("P_M461PRCV")   //Project Function para alterar preço de venda
Local lM461UNIT := FindFunction("P_M461UNIT")   //Project Function para alterar preço unita´rio  

Default dDataMoe := dDataBase

If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][8])

dbSelectArea("SB1")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][12])

dbSelectArea("SC5")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][9])

dbSelectArea("SC6")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][10])

dbSelectArea("SF4")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][14])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa Variaveis                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SF4->F4_ISS == "S"  // a funcao AliqICMs trata Excecao Fiscal de ISS tambem
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Preco de Venda                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPrcVen := SC9->C9_PRCVEN
nPrUnit := If(SC6->C6_PRUNIT<>0,SC6->C6_PRUNIT,SC9->C9_PRCVEN)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A implementação dos pontos de entrada (P_M461PRCV e P_M461UNIT) e de total responsabilidade do cliente, principalmente sobre³
//³base de dados que sera gerada. Para o desenvolvimento dos pontos de entrada deverao ser incluidas, validacoes das           ³ 
//³configuracoes das TES, pois ao alterar os precos de venda, o sistema perde a referencia de calculo, podendo resultar em     ³
//³valores incorretos,inclusive de impostos. Outra informacao importante pertinente a utilizacao dos pontos de entrada e que   ³
//³devem ser validadas, apos implantacao deste novo processo na nota fiscal, as rotinas que geram obrigacoes fiscais.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Calculo do Preco de Venda - Veririfque quadro explicativo acima
If lM461PRCV
    nPrcVen := P_M461PRCV(nX,nPrcVen)
EndIf

//Calculo do Preco Unitario - Veririfque quadro explicativo acima                                               ³
If lM461UNIT
    nPrUnit := P_M461UNIT(nX,nPrUnit)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula o reajuste de preco.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !Empty(SC5->C5_REAJUST) .And. lReajuste )
    nPrcVen  := Formula(SC5->C5_REAJUST)
    nPrUnit := nPrcVen
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Converte os valores para a Moeda Corrente(1)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_MOEDA > 1 
    nTotMdPv := nPrcVen 
    If  ExistBlock("M460PRC")
        aVar     := ExecBlock("M460PRC",.F.,.F.,{nPrcVen,nPrUnit})
        nPrcVen  := aVar[1]
        nPrUnit  := aVar[2]
    Else                   
        nPrcVen  := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataMoe,8)
        nPrUnit := xMoeda(nPrUnit,SC5->C5_MOEDA,1,dDataMoe,8)
    Endif   
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Acrescimo Financeiro                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SC5->C5_ACRSFIN <> 0 ) 
    If lAcresDup
        nAcresFin := a410Arred(nPrcVen*SC5->C5_ACRSFIN/100,"D2_PRCVEN")
        nTotMdPv += a410Arred(nTotMdPv*SC5->C5_ACRSFIN/100,"D2_PRCVEN")     
    Else
        If SF4->F4_DUPLIC=="S"                                          
            nAcresFin := a410Arred(nPrcVen*SC5->C5_ACRSFIN/100,"D2_PRCVEN")     
            nTotMdPv  += a410Arred(nTotMdPv*SC5->C5_ACRSFIN/100,"D2_PRCVEN")            
        Endif
    Endif       
EndIf

If SC5->C5_TIPO $ "CIP"
    If ( SC5->C5_MOEDA == 1 )
        nPrcVen := SC6->C6_PRCVEN
    EndIf
Else    
    nPrcVen  := a410Arred(nPrcVen,"D2_PRCVEN")+nAcresFin
    nPrUnit  := a410Arred(nPrUnit,"D2_PRCVEN")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Preco com ISS                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SC5->C5_INCISS == "N" .And. SF4->F4_ISS=="S" .And. SC5->C5_TIPO == "N" )
    nPrcVen := a410Arred(nPrcVen/(1-(nPerISS/100)),"D2_PRCVEN")
    nTotMdPv:= a410Arred(nTotMdPv/(1-(nPerISS/100)),"D2_PRCVEN")    
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula o Valor Total do Item                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SC5->C5_TIPO$"CIP" .Or. MaTesSel(SC6->C6_TES) .Or.;
        ( aPvlNfs[nx][4]==SC6->C6_QTDVEN .And. (SC5->C5_TIPO=="D" .Or. SF4->F4_PODER3=="D") ) )
    If ( SC5->C5_TIPO$"CIP" .Or. MaTesSel(SC6->C6_TES) ) .And. ExistBlock("M460PRC")
        nTotal := nPrcVen
    Else
        If ( SC5->C5_MOEDA <> 1 )
            nTotMdPv := SC6->C6_VALOR
            nTotal   := xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,1,dDataMoe,TamSX3("C6_PRCVEN")[2])       
        Else
            nTotal   := SC6->C6_VALOR       
        EndIf
    EndIf
Else
    nTotal   := nPrcVen * aPvlNfs[nx][4]
    nTotMdPv *= aPvlNfs[nx][4]
EndIf

nTotal   := a410Arred(nTotal  ,"D2_TOTAL")
nTotMdPv := a410Arred(nTotMdPv,"D2_TOTAL")


If nPrcVen > 0
    aRateio[RT_PDESCON] := IIf(aRateio[RT_PDESCON]>nTotal,nTotal,aRateio[RT_PDESCON])
    If aRateio[RT_PDESCON]+aRateio[RT_DESCONT]>nTotal
        aRateio[RT_PDESCON] := 0
    EndIf
    //Por segurancao nao eh pertido desconto maior que o total do item
Else
    nValNeg := 0
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Desconto                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPrTab := nPrUnit
If GetNewPar("MV_NDESCTP",.F.) .And. SC6->C6_VALDESC == 0 .And. SC6->C6_DESCONT==0
    nPrUnit := nPrcVen
EndIf
If ( nPrUnit > nPrcVen .Or. nValNeg > 0 .Or. SC6->C6_VALDESC > 0 )

    nDesconto := (a410Arred(nPrUnit*aPvlNFs[nx][4],"D2_DESCON")-nTotal)+nValNeg
    If nDesconto <= 0
        If SC6->C6_QTDVEN == aPvlNFs[nx][4]
            nDesconto := SC6->C6_VALDESC
        Else
            nDesconto := A410Arred(SC6->C6_VALDESC/SC6->C6_QTDVEN*aPvlNFs[nx][4],"C6_VALDESC")
        EndIf
        nDesconto := xMoeda(nDesconto,SC5->C5_MOEDA,1,dDataMoe,TamSX3("D2_DESCON")[2])
    EndIf
    nDesconto := nDesconto + aRateio[RT_DESCONT] + aRateio[RT_PDESCON]
    nDesconto := Max(0,nDesconto)
Else
    nDesconto := aRateio[RT_DESCONT] + aRateio[RT_PDESCON]
EndIf                               
nPrUnit := nPrTab
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desconto de Cabecalho so calculado na geracao da NF                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPrcVen := nPrcVen - A410Arred(((aRateio[RT_DESCONT]+aRateio[RT_PDESCON]) / aPvlNFs[nx][4]),"D2_PRCVEN")
nTotal  := nTotal  -  aRateio[RT_DESCONT] - aRateio[RT_PDESCON]
nTotMdPv-= xMoeda(aRateio[RT_DESCONT]+aRateio[RT_PDESCON],1,SC5->C5_MOEDA,dDataMoe,2)

nAcresFin := nAcresFin * aPvlNfs[nx][4]

Return {nPrcVen,nPrUnit,nTotal,nDesconto,nPerISS,nAcresFin,nTotMdPv}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma461Est2 ³ Autor ³Eduardo Riera          ³ Data ³29.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorno da liberacao dos pedidos de venda - Processamento   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se o estorno foi efetuado com sucesso         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma461Est2(lEnd)

Local aArea      := GetArea()

Local lRetorno   := .T.
Local lQuery     := .F.
Local lValido    := .F.
Local lInverte   := ThisInv()
Local cMarca     := ThisMark()

Local cAliasSC9  := "SC9"
Local cMensagem  := RetTitle("C6_NUM")

#IFDEF TOP
    Local aFiltro    := Eval(bFiltraBrw,1)
    Local cDbMs      := ""  
    Local cQuery     := ""  
#ENDIF  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(SC9->(LastRec()))
#IFDEF TOP           
    cDbMs := UPPER(TcGetDb())
    If ( TcSrvType()<>"AS/400" .And. cDbMs <> "POSTGRES" )  
        lQuery    := .T.
        cAliasSC9 := "MA461ESTOR"

        cQuery := "SELECT R_E_C_N_O_ SC9RECNO,C9_PEDIDO,C9_ITEM "
        cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
        cQuery += "WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
        If ( lInverte )
            cQuery += "SC9.C9_OK<>'"+cMarca+"' AND "
        Else
            cQuery += "SC9.C9_OK='"+cMarca+"' AND "
        EndIf
        cQuery += "SC9.C9_BLEST = ' ' AND "
        cQuery += "SC9.C9_BLCRED = ' ' AND "
//      cQuery += "SC9.C9_BLCRED<>'10' AND "
//      cQuery += "SC9.C9_BLCRED<>'ZZ' AND "        
        cQuery += "SC9.D_E_L_E_T_=' ' "
        cQuery += "AND "+aFiltro[2]

        cQuery := ChangeQuery(cQuery)

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
    Else            
#ENDIF
    dbSelectArea("SC9")
    MsSeek(xFilial("SC9"))          
    #IFDEF TOP
    EndIf
    #ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o processamento                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasSC9)
While !Eof()
    lValido := .T.
    If !lQuery
        If  Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
            If ((SC9->C9_FILIAL <> xFilial("SC9")) .And.;
                    ((SC9->C9_BLEST == "10" .And. SC9->C9_BLCRED == "10").Or.(SC9->C9_BLEST == "ZZ" .And. SC9->C9_BLCRED == "ZZ"))) .Or.;
                    !((SC9->C9_OK <> cMarca .And. lInverte) .Or.;
                    (SC9->C9_OK == cMarca .And. !lInverte))
                lValido := .F.
            EndIf
        Else
            lValido := .F.
        EndIf
    EndIf
    If lValido
        If lQuery
            dbSelectArea("SC9")
            MsGoto((cAliasSC9)->SC9RECNO)
        EndIf
        dbSelectArea("SC9")
        If Empty(c460Cond) .Or. &(c460Cond)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifica ponto de entrada                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If ExistBlock("MA461EST")
                lValido := ExecBlock("MA461EST",.F.,.F.)
            EndIf
            If lValido
                Begin Transaction
                    a460Estorna()
                End Transaction
            EndIf
        EndIf
    EndIf
    dbSelectArea(cAliasSC9)
    dbSkip()
    IncProc(cMensagem+"..:"+(cAliasSC9)->C9_PEDIDO+"/"+(cAliasSC9)->C9_ITEM)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Controle de cancelamento do usuario                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lEnd
        Exit
    EndIf   
EndDo
If lQuery
    dbSelectArea(cAliasSC9)
    dbCloseArea()
    dbSelectArea("SC9")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)

Return( lRetorno )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaNfs2Nfs2³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de preparacao do documento de saida atraves de outro ³±±
±±³          ³documento de saida.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie do Documento de Origem                         ³±±
±±³          ³ExpC2: Numero do Documento de Origem                        ³±±
±±³          ³ExpC3: Cliente/Fornecedor do documento do origem            ³±±
±±³          ³ExpC4: Loja do Documento de origem                          ³±±
±±³          ³ExpC5: Serie do Documento a ser gerado                      ³±±
±±³          ³ExpC6: Numero do documento a ser gerado                     ³±±
±±³          ³ExpL7: Lancamento padrao 610                           (OPC)³±±
±±³          ³ExpL8: Lancamento padrao 620                           (OPC)³±±
±±³          ³ExpN9: Controle do Total Contabilizado                 (OPC)³±±
±±³          ³ExpNA: Handle do arquivo de contabilizacao             (OPC)³±±
±±³          ³ExpLB: Reajuste de preco na nota fiscal                (OPC)³±±
±±³          ³ExpNC: Tipo de Acrescimo Financeiro                    (OPC)³±±
±±³          ³ExpND: Tipo de Arredondamento                          (OPC)³±±
±±³          ³ExpLE: Atualiza Amarracao Cliente x Produto            (OPC)³±±
±±³          ³ExplF: Cupom Fiscal                                    (OPC)³±±
±±³          ³ExpBG: CodeBlock a ser executado para o SD2            (OPC)³±±
±±³          ³ExpBH: Filtragem do SD2                                (OPC)³±±
±±³          ³ExpBI: CodeBlock a ser executado para o SF2            (OPC)³±±
±±³          ³ExpAJ: Array com os Recnos do SF2                      (OPC)³±±
±±³          ³       Deve possuir o mesmo tamanho da ExpAl           (OPC)³±±
±±³          ³ExpAL: Array com os itens do SD2                       (OPC)³±±
±±³          ³       [1] Item do SD2                                 (OPC)³±±
±±³          ³       [2] Conteudo dos campos na ordem da estrutura   (OPC)³±±
±±³          ³ExpAN: Calculo Fiscal                                  (OPC)³±±
±±³          ³       Desabilita o calculo fiscal pois as informacoes ja   ³±±
±±³          ³       foram passadas nos campos do SD2 e SF2.              ³±±
±±³          ³ExpAO: Codigo do cliente de Entrega para calculo dos impos- ³±±
±±³          ³       tos.                                                 ³±±
±±³          ³ExpAP: Codigo da loja de Entrega para calculo dos impostos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaNfs2Nfs2(cSerie,cNumero,cClieFor,cLoja,cSerieNFS,cNumNFS,lLct610,lLct620,nLctTotal,nHdlPrv,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,bFilSD2,bSD2,bSF2,aDocOri,aItemOri,aSF2,lNoFiscal,bFiscalSF2,bFiscalSD2,bFatSE1,aLancCtb)

Local aArea      := GetArea()
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSD2   := SD2->(GetArea())
Local aStruSD2   := SD2->(dbStruct())
Local aStruSF2   := SF2->(dbStruct())
Local aSD2       := {}
Local aRegSD2    := {}
Local aTitulo    := { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0, 0, 0, 0}
Local aLockSF2   := {}
Local aLockSB2   := {}
Local aLockSA1   := {}
Local aLockSA2   := {}
Local aVldSF2    := {}
Local cBanco     := ""
Local nMoeda     := 1
Local cAliasSB1  := "SB1"
Local cAliasSD2  := "SD2"
Local cAliasSF4  := "SF4"
Local cAliasSE1  := "SE1"
Local cAliasSB6  := "SB6"
Local cItemSD2   := ""
Local cEstado    := ""
Local lQuery     := .F.
Local lFirst     := .F.
Local lRetorno   := .F.
Local lValido    := .F.
Local nItemNf    := IIf(FUNNAME() != "TMSA200", a460NumIt(cSerieNFS) , 99 )  //Caso venha da rotina de calculo de frete(TMS), pega valor DEFAULT do parametro (99)
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nItensSD2  := 0
Local nSldSB6    := 0
Local nQtdSB6    := 0
Local nDedICM    := 0
Local nPItem     := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_ITEM"  })
Local nPDescon   := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_DESCON"})
Local nPQuant    := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_QUANT"})
Local nPPrcVen   := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_PRCVEN"})
Local nPTotal    := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TOTAL"})
Local nPQtSegum  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_QTSEGUM"})
Local nPIdentB6  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_IDENTB6"})
Local nPLoteCtl  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_LOTECTL"})
Local nPNumLote  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_NUMLOTE"})
Local nPDtValid  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_DTVALID"})
Local nPPotenc   := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_POTENCI"})
Local nPCliente  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_CLIENTE"})
Local nPLoja     := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_LOJA"})
Local nPTipo     := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TIPO"})
Local nPDoc      := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_DOC"})
Local nPSerie    := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_SERIE"})
Local nPProduto  := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_COD"})
Local nPNumSeq   := Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_NUMSEQ"})
Local nPLocal    := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_LOCAL"})
Local nPTES      := aScan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TES"})
Local nPEstDest  := Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_EST"})
Local nPEstado   := Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_EST"})
Local nItemNF2   := 1
Local cMV_B1M996 := GetNewPar ("MV_B1M996", "")
Local cB1M996    := ""
Local cB1FRETISS := ""
Local cTpNrNfs   := SuperGetMV("MV_TPNRNFS")
Local aTransp    := {"",""}
Local lCliDes    := ( SF2->(FieldPos('F2_CLIENT'))>0 .And. SF2->(FieldPos('F2_LOJENT'))>0 )
Local lMvAtuComp := SuperGetMV("MV_ATUCOMP",,.F.)
Local lIntTms    := SuperGetMV("MV_INTTMS",,.F.)    
#IFDEF TOP
    Local aStruSB6   := {}
    Local aStruSE1   := {}
    Local cDbMs      := ""  
    Local cQuery     := ""  
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os parametros DEFAULT                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFAULT lLct610      := .F.
DEFAULT lLct620      := .F.
DEFAULT nLctTotal    := 0
DEFAULT lReajusta    := .F.
DEFAULT nCalAcrs     := 1
DEFAULT nArredPrcLis := 1
DEFAULT lAtuSA7      := .F.
DEFAULT lECF         := .F.
DEFAULT bSD2         := {|| .T.}
DEFAULT bFilSD2      := {|| .T.}
DEFAULT bSF2         := {|| .T.}
DEFAULT aDocOri      := {}
DEFAULT aItemOri     := {}
DEFAULT aSF2         := {}
DEFAULT lNoFiscal    := .F.
DEFAULT bFatSE1      := {|| .T. }
DEFAULT aLancCtb     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atendendo legislacao do Programa Aplicativo Fiscal - Emissor de Cupom Fiscal (PAF - ECF) Ato COTEPE 06/08,desenvolvido pelo CONFAZ|               |
//³o modulo Front-loja/SigaLoja (rotina Venda Assistida) sao unicas interfaces Protheus a permitirem emissao de cupom fiscal.        | 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lECF := .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa os itens do documento - Origem                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
If Empty(aItemOri)  
    nY := 0
    dbSelectArea("SD2")
    dbSetOrder(3)
    #IFDEF TOP
        lQuery    := .T.
        cAliasSD2 := "MANFS2NFS"

        cQuery := ""
        For nX := 1 To Len(aStruSD2)
                cQuery += ","+aStruSD2[nX][1]
        Next nX
        cQuery := "SELECT SF2.R_E_C_N_O_ SF2RECNO,F2_REAJUST "+cQuery+" "
        cQuery += "FROM "+RetSqlName("SD2")+" SD2,"
        cQuery += RetSqlName("SF2")+" SF2 "
        cQuery += "WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
        cQuery += "SF2.F2_SERIE='"+cSerie+"' AND "
        cQuery += "SF2.F2_DOC='"+cNumero+"' AND "
        cQuery += "SF2.F2_CLIENTE='"+cClieFor+"' AND "
        cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
        cQuery += "SF2.D_E_L_E_T_=' ' AND "
        cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
        cQuery += "SD2.D2_SERIE=SF2.F2_SERIE AND "
        cQuery += "SD2.D2_DOC=SF2.F2_DOC AND "
        cQuery += "SD2.D2_CLIENTE=SF2.F2_CLIENTE AND "
        cQuery += "SD2.D2_LOJA=SF2.F2_LOJA AND "
        cQuery += "SD2.D_E_L_E_T_=' ' "         
        cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))

        cQuery := ChangeQuery(cQuery)

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

        For nX := 1 To Len(aStruSD2)
            If aStruSD2[nX][2]<>"C"
                TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
            EndIf
        Next nX
    #ELSE
        MsSeek(xFilial("SD2")+cNumero+cSerie+cClieFor+cLoja)
    #ENDIF
    While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
            cNumero == (cAliasSD2)->D2_DOC .And.;
            cSerie == (cAliasSD2)->D2_SERIE .And.;
            cClieFor == (cAliasSD2)->D2_CLIENTE .And.;
            (cAliasSD2)->D2_LOJA == cLoja
        
        dbSelectArea("SF4")
        dbSetOrder(1)
        MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)

        dbSelectArea("SB1")
        dbSetOrder(1)
        MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
        
        If !lQuery
            dbSelectArea("SF2")
            dbSetOrder(1)
            MsSeek(xFilial("SF2")+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)               
        EndIf
        If Eval(bFilSD2,cAliasSD2,"SF4","SB1",Iif(lQuery,(cAliasSD2)->F2_REAJUST,SF2->F2_REAJUST) )
            nY++
            aadd(aDocOri,IIf(lQuery,(cAliasSD2)->SF2RECNO,SF2->(RecNo())))
            aadd(aItemOri,{})
            For nX := 1 To Len(aStruSD2)
                aadd(aItemOri[nY],(cAliasSD2)->(FieldGet(FieldPos(aStruSD2[nX][1]))))
            Next nX
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Chamada do CodeBlock para alteracao do SD2                             ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            Eval(bSD2,1,@aItemOri[nY],cAliasSD2,cAliasSF4,cAliasSB1)
        EndIf
        dbSelectArea(cAliasSD2)
        dbSkip()
    EndDo
    If lQuery
        dbSelectArea(cAliasSD2)
        dbCloseArea()
        dbSelectArea("SD2")
    EndIf
EndIf   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena os Itens do documento por: Tipo+Cliente+Loja+Serie+Documento    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aItemOri := aSort(aItemOri,,,{|x,y| x[nPTipo]+x[nPCliente]+x[nPLoja]+x[nPSerie]+x[nPDoc]+x[nPItem] < ;
    y[nPTipo]+y[nPCliente]+y[nPLoja]+y[nPSerie]+y[nPDoc]+y[nPItem]})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para Dead-Lock                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aItemOri)
    If aScan(aLockSB2,aItemOri[nX][nPProduto]+aItemOri[nX][nPLocal])==0
        If lIntTms .And. nModulo == 43 .And. nPTES > 0
            SF4->(DbSetOrder(1))
            If SF4->(DbSeek(xFilial("SF4")+aItemOri[nx][nPTES])) .And. SF4->F4_ESTOQUE == "S"
                aadd(aLockSB2,aItemOri[nX][nPProduto]+aItemOri[nX][nPLocal])
            EndIf
        Else
            aadd(aLockSB2,aItemOri[nX][nPProduto]+aItemOri[nX][nPLocal])        
        EndIf
    EndIf
    If aScan(aLockSF2,aItemOri[nX][nPDoc]+aItemOri[nX][nPSerie]+aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])==0
        aadd(aLockSF2,aItemOri[nX][nPDoc]+aItemOri[nX][nPSerie]+aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])
    EndIf

    If aItemOri[nX][nPTipo]$"DB"
        If aScan(aLockSA2,aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])==0
            aadd(aLockSA2,aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])
        EndIf
    Else
        If aScan(aLockSA1,aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])==0
            aadd(aLockSA1,aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja])
        EndIf
    EndIf
Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para Dead-Lock                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Iif(!GetNewPar("MV_NFS_JOB",.F.),MultLock("SB2",aLockSB2,1), .T.) .And. If(Len(aLockSA1) > 1,MultLock("SA1",aLockSA1,1),.T.) .And. If(Len(aLockSA2) > 1,MultLock("SA2",aLockSA2,1),.T.) .And. If(Len(aLockSF2) > 1,MultLock("SF2",aLockSF2,3),.T.)

    For nItensSD2 := 1 To Len(aItemOri)
        aadd(aSD2,aClone(aItemOri[nItensSD2]))
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica-se a Quebra do documento Fiscal                               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nX := nItensSD2+1
        nY := nItensSD2
        If nX > Len(aItemOri) .Or. aItemOri[nX][nPTipo]+;
                aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja]+;
                aItemOri[nX][nPDoc]+aItemOri[nX][nPSerie]<>;
                aItemOri[nY][nPTipo]+;
                aItemOri[nY][nPCliente]+aItemOri[nY][nPLoja]+;
                aItemOri[nY][nPDoc]+aItemOri[nY][nPSerie]
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Posiciona no Documento de Origem                                       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (aDocOri[nItensSD2]) <> 0
                SF2->(MsGoto(aDocOri[nItensSD2]))
                If !Empty(SF2->F2_NEXTDOC)
                    If aScan(aVldSF2,aDocOri[nItensSD2]) <> 0
                        lValido := .T.
                    Else
                        lValido := .F.
                    EndIf
                Else
                    lValido := .T.
                    aadd(aVldSF2,aDocOri[nItensSD2])
                EndIf
            Else
                lValido := .T.
            EndIf
            If lValido
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Atualiza o Documento com o Numero do Proximo Documento de Saida        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                    
                If Empty(cNumNFS)
                    // Obtem numero do documento dentro da transacao
                    SX3->(dbSetOrder(1))
                    If (SX3->(dbSeek("SD9"))) .And. cTpNrNfs == "3"
                        cNumNFS:=MA461NumNf(.T.,cSerieNFS,NIL,lECF)
                    Else
                        cNumNFS  := NxtSX5Nota( cSerieNFS,.T.,cTpNrNfs)
                    EndIf
                EndIf
                If aDocOri[nItensSD2] <> 0
                    RecLock("SF2")
                    If Empty(SF2->F2_NEXTDOC)
                        SF2->F2_NEXTDOC := cNumNFS
                        SF2->F2_NEXTSER := cSerieNFS
                    Else
                        SF2->F2_NEXTDOC := Repl("X",Len(cNumNFS))
                        SF2->F2_NEXTSER := Repl("X",Len(cSerieNFS))
                    EndIf
                    MsUnLock()
                EndIf
            EndIf
        EndIf
        If lValido .And. (nX > Len(aItemOri) .Or. aItemOri[nX][nPTipo]+;
                aItemOri[nX][nPCliente]+aItemOri[nX][nPLoja]<>;
                aItemOri[nY][nPTipo]+;
                aItemOri[nY][nPCliente]+aItemOri[nY][nPLoja])
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Inicia a gravacao dos documentos de saida                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            cItemSD2 := StrZero(1,Len(SD2->D2_ITEM))
            nX       := 1
            nItemNF2 := 1                       
            While nX <= Len(aSD2)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Analise do Documento de Origem                                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If Empty(cItemSD2) .Or. nItemNF2 == 1               
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Inicializa a numeracao dos itens do documento de saida                 ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    cItemSD2 := StrZero(1,Len(SD2->D2_ITEM))
                    If Empty(cNumNFS)
                        // Obtem numero do documento dentro da transacao
                        SX3->(dbSetOrder(1))
                        If (SX3->(dbSeek("SD9"))) .And. cTpNrNfs == "3"
                            cNumNFS:=MA461NumNf(.T.,cSerieNFS,NIL,lECF)
                        Else    
                            cNumNFS  := NxtSX5Nota( cSerieNFS,.T.,cTpNrNfs)
                        EndIf   
                    EndIf
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Posiciona no Documento de Origem                                       ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If aDocOri[nItensSD2] <> 0
                        SF2->(MsGoto(aDocOri[nItensSD2]))                   
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Verificando os titulos a receber                                       ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If !Empty(SF2->F2_DUPL)
                            dbSelectArea("SE1")
                            dbSetOrder(2)
                            #IFDEF TOP
                                cDbMs := UPPER(TcGetDb())                           
                                If ( TcSrvType()<>"AS/400" .And. cDbMs<>"POSTGRES" )                            
                                    aStruSE1 := SE1->(dbStruct())
                                    cAliasSE1:= "MANFS2NFS_SE1"
    
                                    lQuery := .T.
                                    cQuery := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
                                    cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
                                    cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
                                    cQuery += "SE1.E1_PREFIXO='"+SF2->F2_PREFIXO+"' AND "
                                    cQuery += "SE1.E1_NUM='"+SF2->F2_DUPL+"' AND "
                                    cQuery += "SE1.E1_CLIENTE='"+cClieFor+"' AND "
                                    cQuery += "SE1.E1_LOJA='"+cLoja+"' AND "
                                    cQuery += "SE1.D_E_L_E_T_=' ' "
    
                                    cQuery := ChangeQuery(cQuery)
    
                                    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
    
                                    For nY := 1 To Len(aStruSE1)
                                        If aStruSE1[nY][2] <> "C"
                                            TcSetField(cAliasSE1,aStruSE1[nY][1],aStruSE1[nY][2],aStruSE1[nY][3],aStruSE1[nY][4])
                                        EndIf
                                    Next nY
                                Else
                            #ENDIF
                                MsSeek(xFilial("SE1")+cClieFor+cLoja+SF2->F2_PREFIXO+SF2->F2_DUPL)
                                #IFDEF TOP
                                EndIf
                                #ENDIF
                            dbSelectArea(cAliasSE1)
                            While ( !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
                                    cClieFor == (cAliasSE1)->E1_CLIENTE .And.;
                                    cLoja == (cAliasSE1)->E1_LOJA .And.;                
                                    SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
                                    SF2->F2_DUPL == (cAliasSE1)->E1_NUM )
                                If (cAliasSE1)->E1_TIPO $ MVNOTAFIS
                                    cBanco := (cAliasSE1)->E1_PORTADO
                                    nMoeda := (cAliasSE1)->E1_MOEDA
                                    Exit
                                EndIf
                                dbSelectArea(cAliasSE1)
                                dbSkip()
                            EndDo
                            If lQuery
                                dbSelectArea(cAliasSE1)
                                dbCloseArea()
                                dbSelectArea("SE1")
                            EndIf
                        EndIf                   
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Inicia a Gravacao do Cabecalho - SF2                                   ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        aSF2 := {}
                        For nY := 1 To Len(aStruSF2)
                            aadd(aSF2,SF2->(FieldGet(FieldPos(aStruSF2[nY][1]))))
                        Next nY
                        RecLock("SF2",.T.)
                        For nY := 1 To Len(aStruSF2)
                            FieldPut(nY,aSF2[nY])
                        Next nY
                    Else
                        RecLock("SF2",.T.)
                        For nY := 1 To Len(aStruSF2)
                            FieldPut(nY,aSF2[nY])
                        Next nY
                        cEstado := aSF2[nPEstado]
                    EndIf
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Posiciona Registros                                                     ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If  ( SF2->F2_TIPO $ "DB" )
                        dbSelectArea("SA2")
                        dbSetOrder(1)
                        MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
                        If Empty(cEstado)
                            If SF2->F2_CLIENTE+SF2->F2_LOJA == aSD2[nX][nPCliente]+aSD2[nX][nPLoja]
                                cEstado := SA2->A2_EST
                            Else
                                cEstado := aSD2[nX][nPEstDest]
                            EndIf
                        EndIf
                    Else
                        dbSelectArea("SA1")
                        dbSetOrder(1)
                        MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
                        If Empty(cEstado)
                            If SF2->F2_CLIENTE+SF2->F2_LOJA == aSD2[nX][nPCliente]+aSD2[nX][nPLoja]
                                cEstado := SA1->A1_EST
                            Else
                                cEstado := aSD2[nX][nPEstDest]
                            EndIf
                        EndIf
                    EndIf
                    dbSelectArea("SA4")
                    dbSetOrder(1)
                    If SA4->(dbSeek(xFilial("SA4")+SF2->F2_TRANSP))
                        aTransp[01] := SA4->A4_EST
                        aTransp[02] := Iif(SA4->(FieldPos("A4_TPTRANS")) > 0,SA4->A4_TPTRANS,"")
                    Endif
                    SF2->F2_NFORI   := SF2->F2_DOC
                    SF2->F2_SERIORI := SF2->F2_SERIE
                    SF2->F2_DOC     := cNumNFS
                    SF2->F2_SERIE   := cSerieNFS
                    SF2->F2_CLIENTE := aSD2[nX][nPCliente]
                    SF2->F2_LOJA    := aSD2[nX][nPLoja]
                    SF2->F2_TIPO    := aSD2[nX][nPTipo]
                    SF2->F2_CARGA   := ""
                    SF2->F2_SEQCAR  := ""
                    SF2->F2_EST     := cEstado
                    SF2->F2_EMISSAO := dDataBase
                    SF2->F2_ESPECIE := A460Especie(cSerieNFS)
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Complemento da gravacao do SF2                                         ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    Eval(bSF2,1)                
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Inicializa cabecalho da funcao fiscal                                   ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    MaFisSave()
                    MaFisEnd()
                    MaFisIni(SF2->F2_CLIENTE,SF2->F2_LOJA,IIF(SF2->F2_TIPO$'DB',"F","C"),SF2->F2_TIPO,SF2->F2_TIPOCLI,aRelImp,,,,'MATA461',,,,,,IIf(lCliDes,SF2->F2_CLIENT,""),IIf(lCliDes,SF2->F2_LOJENT,""),aTransp)
                    If !Empty(SF2->F2_EST)
                        If SF2->F2_TIPO$"DB"
                            MaFisAlt("NF_UFORIGEM",SF2->F2_EST)
                        Else
                            MaFisAlt("NF_UFDEST",SF2->F2_EST)
                        EndIf
                    EndIf
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Carrega os valores da funcao fiscal (Total)                            ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    dbSelectArea("SF2")
                    For nY := 1 To Len(aRelImp)
                        If aRelImp[nY][1] == "SF2"
                            MaFisLoad(aRelImp[nY][3],SF2->(FieldGet(FieldPos(aRelImp[nY][2]))))
                        EndIf
                    Next nY                 

                Else
                    cItemSD2 := Soma1(cItemSD2)
                EndIf

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Executa code block para tratamento do fiscal.                          ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
                If bFiscalSF2 <> NIL
                    Eval(bFiscalSF2)
                EndIf

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Inicia a Gravacao do Cabecalho - SD2                                   ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                aSD2[nX,nPNumSeq] := SF4->(ProxNum())
                aSD2[nX,nPDoc]    := cNumNFS
                aSD2[nX,nPSerie]  := cSerieNFS
                aSD2[nX,nPItem]   := cItemSD2
                RecLock("SD2",.T.)
                For nY := 1 To Len(aSD2[nX])
                    FieldPut(nY,aSD2[nX][nY])
                Next nY
                SD2->D2_IDENTB6 := IIf(SD2->D2_TIPO$"CIP",SD2->D2_IDENTB6,"")
                SD2->D2_EMISSAO := dDataBase                
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Verifica o Poder de terceiros                                          ³
                //³                                                                        ³
                //³ Neste ponto sera realizado o FIFO do poder de terceiro caso nao seja   ³
                //³ informado a rotina qual identificador deve ser utilizado para o retorno³
                //³ do material                                                            ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If Empty(SD2->D2_IDENTB6)
                    dbSelectArea("SF4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SF4")+SD2->D2_TES)
                    If SF4->F4_PODER3=="D"
                        nSldSB6    := 0
                        nQtdSB6    := SD2->D2_QUANT
                        lFirst     := .T.

                        dbSelectArea("SB6")
                        dbSetOrder(2)
                        #IFDEF TOP
                            lQuery    := .T.
                            cAliasSB6 := "MANFS2NFS_SB6"
                            aStruSB6  := SB6->(dbStruct())

                            cQuery := "SELECT * "
                            cQuery += "FROM "+RetSqlName("SB6")+" SB6 "
                            cQuery += "WHERE SB6.B6_FILIAL='"+xFilial("SB6")+"' AND "
                            cQuery += "SB6.B6_PRODUTO='"+SD2->D2_COD+"' AND "
                            cQuery += "SB6.B6_CLIFOR='"+SD2->D2_CLIENTE+"' AND "
                            cQuery += "SB6.B6_LOJA='"+SD2->D2_LOJA+"' AND "
                            cQuery += "SB6.B6_PODER3='R' AND "
                            cQuery += "SB6.B6_TPCF='"+IIf(SD2->D2_TIPO$"DB","F","C")+"' AND "
                            cQuery += "SB6.D_E_L_E_T_=' ' "
                            cQuery += "ORDER BY "+SqlOrder(SB6->(IndexKey()))

                            cQuery := ChangeQuery(cQuery)

                            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB6,.T.,.T.)

                            For nZ := 1 To Len(aStruSB6)
                                If aStruSB6[nZ][2]<>"C"
                                    TcSetField(cAliasSB6,aStruSB6[nZ][1],aStruSB6[nZ][2],aStruSB6[nZ][3],aStruSB6[nZ][4])
                                EndIf
                            Next nZ
                        #ELSE
                            MsSeek(xFilial("SB6")+SD2->D2_COD+SD2->D2_CLIENTE+SD2->D2_LOJA+"R")
                        #ENDIF
                        While !Eof() .And. (cAliasSB6)->B6_FILIAL == xFilial("SB6") .And.;
                                (cAliasSB6)->B6_PRODUTO == SD2->D2_COD .And.;
                                (cAliasSB6)->B6_CLIFOR == SD2->D2_CLIENTE .And.;
                                (cAliasSB6)->B6_LOJA == SD2->D2_LOJA .And.;
                                (cAliasSB6)->B6_PODER3 == 'R' .And. nQtdSB6 > 0

                            If (cAliasSB6)->B6_TPCF == IIf(SD2->D2_TIPO$"DB","F","C")

                                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                //³ Verifica o saldo o poder de terceiro                                   ³
                                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                        
                                nSldSB6 := Min((cAliasSB6)->B6_SALDO - (cAliasSB6)->B6_QULIB,nQtdSB6)

                                If nSldSB6 > 0
                                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                    //³ Posiciona Registros                                                    ³
                                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                    dbSelectArea("SD1")
                                    dbSetOrder(4)
                                    MsSeek(xFilial("SD1")+(cAliasSB6)->B6_IDENT)
                                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                    //³ Ajusta o Documento de Saida para a quantidade em poder de terceiro     ³
                                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                            
                                    If lFirst
                                        SD2->D2_DESCON  := A410Arred(SD1->D1_VALDESC/SD1->D1_QUANT*nSldSB6,"D2_DESCON")
                                        SD2->D2_QUANT   := nSldSB6
                                        SD2->D2_PRCVEN  := A410Arred((SD1->D1_TOTAL-SD1->D1_VALDESC)/SD1->D1_QUANT,"D2_PRCVEN")
                                        SD2->D2_TOTAL   := A410Arred(SD2->D2_QUANT*SD2->D2_PRCVEN,"D2_TOTAL")
                                        SD2->D2_QTSEGUM := SF4->(ConvUm(SD2->D2_COD,SD2->D2_QUANT,0,2))
                                        SD2->D2_IDENTB6 := (cAliasSB6)->B6_IDENT
                                        SD2->D2_NFORI   := SD1->D1_DOC
                                        SD2->D2_SERIORI := SD1->D1_SERIE
                                        SD2->D2_ITEMORI := SD1->D1_ITEM
                                        SD2->D2_LOCAL   := (cAliasSB6)->B6_LOCAL
                                        SD2->D2_LOTECTL := SD1->D1_LOTECTL
                                        SD2->D2_NUMLOTE := SD1->D1_NUMLOTE
                                        SD2->D2_DTVALID := SD1->D1_DTVALID
                                        SD2->D2_POTENCI := SD1->D1_POTENCI

                                        nQtdSB6 -= SD2->D2_QUANT
                                        lFirst := .F.
                                    Else
                                        aadd(aSD2,aClone(aSD2[nX]))
                                        aSD2[Len(aSD2)][nPDescon ] := A410Arred(SD1->D1_VALDESC/SD1->D1_QUANT*nSldSB6,"D2_DESCON")
                                        aSD2[Len(aSD2)][nPQuant  ] := nSldSB6
                                        aSD2[Len(aSD2)][nPTotal  ] := A410Arred(aSD2[Len(aSD2)][nPQuant]*aSD2[Len(aSD2)][nPPrcVen],"D2_TOTAL")
                                        aSD2[Len(aSD2)][nPQtSegum] := SF4->(ConvUm(SD2->D2_COD,aSD2[Len(aSD2)][nPQuant],0,2))
                                        aSD2[Len(aSD2)][nPIdentB6] := (cAliasSB6)->B6_IDENT
                                        aSD2[Len(aSD2)][nPLoteCtl] := SD1->D1_LOTECTL
                                        aSD2[Len(aSD2)][nPNumLote] := SD1->D1_NUMLOTE
                                        aSD2[Len(aSD2)][nPDtValid] := SD1->D1_DTVALID
                                        aSD2[Len(aSD2)][nPPotenc]  := SD1->D1_POTENCI                                           

                                        nQtdSB6 -= aSD2[Len(aSD2)][nPQuant]
                                    EndIf
                                EndIf
                            EndIf
                            dbSelectArea(cAliasSB6)
                            dbSkip()
                        EndDo
                        If lQuery
                            dbSelectArea(cAliasSB6)
                            dbCloseArea()
                            dbSelectArea("SB6")
                        EndIf               
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Atualiza CAT/83                                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If SD2->(FieldPos("D2_CODLAN")) > 0 .And. SF4->(FieldPos("F4_CODLAN")) > 0 .And. SuperGetMV("MV_CAT8309",,.T.)
                    SD2->D2_CODLAN := IIF(SD2->D2_TES == SF4->F4_CODIGO,SF4->F4_CODLAN,Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_CODLAN"))
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Complemento da gravacao do SD2                                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                Eval(bSD2,2,aSD2)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Carga do Funcao fiscal para o Item                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                MaFisIniLoad(nItemNf2,Nil,.T.)              
                For nZ := 1 To Len(aRelImp)
                    If aRelImp[nZ][1] == "SD2"
                        MaFisLoad(aRelImp[nZ][3],SD2->(FieldGet(FieldPos(aRelImp[nZ][2]))),nItemNF2)                        
                    EndIf
                Next nZ
                MaFisEndLoad(nItemNf2,2)                
                aadd(aRegSD2,SD2->(RecNo()))
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Verifica a quebra de nota fiscal                                       ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If nX == Len(aSD2) .Or. nItemNF2 >= nItemNF             
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Complemento da gravacao do SF2                                         ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    Eval(bSF2,2)
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Posiciona registros                                                    ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If SF2->F2_TIPO$"DB"
                        dbSelectArea("SA2")
                        dbSetOrder(1)
                        MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
                    Else
                        dbSelectArea("SA1")
                        dbSetOrder(1)
                        MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
                    EndIf
                    dbSelectArea("SE4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SE4")+SF2->F2_COND)

                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Regrava os itens da nota fiscal de saida apos alteracao                ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    For nY := 1 To Len(aRegSD2) 
                        SD2->(MsGoto(aRegSD2[nY]))
                        RecLock("SD2",.F.)                      
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Posiciona registros                                                    ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
                        dbSelectArea("SB1")
                        dbSetOrder(1)
                        MsSeek(xFilial("SB1")+SD2->D2_COD)

                        dbSelectArea("SB2")
                        dbSetOrder(1)
                        MsSeek(xFilial("SB2")+SD2->D2_COD+SD2->D2_LOCAL)

                        dbSelectArea("SF4")
                        dbSetOrder(1)
                        MsSeek(xFilial("SF4")+SD2->D2_TES)

                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Atualiza os dados fiscais                                              ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If MaFisRet(nY,"IT_TES")==SD2->D2_TES
                            MaFisAlt("IT_TES","",nY)
                        EndIf
                        MaFisAlt("IT_TES",SD2->D2_TES,nY)

                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Executa code block para tratamento do fiscal.                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
                        If bFiscalSD2 <> NIL
                            Eval(bFiscalSD2)
                        EndIf

                        SF4->(MaFisWrite(2,"SD2",nY))
                        SD2->D2_VALICM  := SF4->(MaFisRet(nY,'IT_VALICM')+MaFisRet(nY,'IT_VALISS'))
                        SD2->D2_BASEICM := SF4->(MaFisRet(ny,'IT_BASEICM')+MaFisRet(nY,'IT_BASEISS'))
                        SD2->D2_PICM    := SF4->(If(SF4->F4_ISS=="S",MaFisRet(nY,'IT_ALIQISS'),MaFisRet(nY,'IT_ALIQICM')))
                        SD2->D2_DESCZFR := SF4->(MaFisRet(nY,'IT_DESCZF'))
                        SD2->D2_TOTAL    := SD2->D2_TOTAL - SD2->D2_DESCON - IIf(SF4->F4_AGREG$"R", MaFisRet(nY,"IT_DEDICM") , 0)
                        SD2->D2_PRCVEN  := A410Arred(SD2->D2_TOTAL/IIf(SD2->D2_QUANT==0,1,SD2->D2_QUANT),"D2_PRCVEN")

                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Desconta o Valor do ICMS DESONERADO do valor do Item D2_PRCVEN         ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If SF4->F4_AGREG$"R"
                            nDedICM += MaFisRet(nY,'IT_DEDICM')
                        EndIf

                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Pontos de Entrada                                                      ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³Calculo dos Impostos Financeiros                                        ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If ( SF4->F4_DUPLIC=="S" )
                            aTitulo[_VLRTIT_]  += MaFisRet(nY,'IT_BASEDUP')
                            aTitulo[_VLRIRRF_] += MaFisRet(nY,'IT_VALIRR')
                            aTitulo[_VLRINSS_] += MaFisRet(nY,'IT_VALINS')
                            aTitulo[_VLRINSS_] += MaFisRet(nY,'IT_VALINA')
                            aTitulo[_VLRISS_]  += MaFisRet(nY,'IT_VALISS')
                            aTitulo[_VLRPIS_]  += MaFisRet(nY,'IT_VALPIS')
                            aTitulo[_VLRCSLL_] += MaFisRet(nY,'IT_VALCSL')
                            aTitulo[_VLRCOFI_] += MaFisRet(nY,'IT_VALCOF')
                            aTitulo[_VLRFET_]  += MaFisRet(nY,'IT_VALFET')
                            aTitulo[_VLRFAB_]  += MaFisRet(nY,'IT_VALFAB')                          
                            aTitulo[_VLRFAC_]  += MaFisRet(nY,'IT_VALFAC')
                            aTitulo[_VLRTPDP_] += MaFisRet(nY,'IT_VALTPDP')                                 
                        EndIf           
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Atualiza os acumulados do SD2                                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        MaAvalSD2(,,lAtuSA7,nY)
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Contabilizacao dos itens                                               ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If ( lLct610 )
                            nLctTotal += DetProva(nHdlPrv,"610","MATA460",cLote)
                        EndIf
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        PcoDetLan("000101","01","MATA461")
                        If (SB1->(FieldPos(cMV_B1M996))>0) .And. cB1M996 <> "1"
                            cB1M996 :=  SB1->(FieldGet(FieldPos(cMV_B1M996)))
                        EndIf                       
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
                        //³Mais especificamente o paragrafo unico do Art 2.                        ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If (SB1->(FieldPos("B1_FRETISS"))>0) .And. cB1FRETISS <> "2"
                            cB1FRETISS  :=  SB1->B1_FRETISS
                        EndIf
                    Next nY
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Regrava o Cabecalho da Nota Fiscal de Saida                            ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    MaFisWrite(,"SF2")
                    MaAvalSF2(lNoFiscal)

                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Desconta o Valor do ICMS DESONERADO do valor do Item D2_PRCVEN         ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If nDedICM > 0
                        SF2->F2_VALMERC -= nDedICM 
                    EndIf
            
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Gravacao do Financeiro                                                 ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If aTitulo[_VLRTIT_] > 0
                        lFatSE1 := Eval(bFatSE1)
                        If nModulo == 43 .And. SuperGetMv("MV_TMSMFAT") == "2" .And. !lFatSE1
                            SF2->F2_VALFAT := aTitulo[_VLRTIT_]
                        Else
                            If nModulo == 43 .And. SF2->(FieldPos("F2_MOEDA")) > 0 //-- CRT - Conhecimento Transporte Internacional
                                nMoeda:= SF2->F2_MOEDA
                            EndIf
                            MaNfs2Fin(aTitulo,nMoeda,cBanco,,,,, MaFisRet(,"NF_RECISS"), cB1M996, cB1FRETISS )
                        EndIf
                    EndIf
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Gravacao do Fiscal                                                     ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    if !empty(SF2->F2_PDV)
                        //Chama a "MaFisAtuSF3" de forma diferenciada para gravar tambem os campos F3_PDV e FT_PDV
                        MaFisAtuSF3(1,"S",SF2->(Recno()),"SF2",NIL,NIL,"LOJA701")
                    else
                        MaFisAtuSF3(1,"S",SF2->(RecNo()))
                    endif
                    
                    MAFISCDA(,2)    //Gravacao dos lancamentos fiscais
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //Atualiza dados dos complementos SPED automaticamente
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    If lMvAtuComp
                        AtuComp(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"S",SF2->F2_TIPO)
                    EndIf
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Termino da Gravacao                                                    ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Para a localizacao Mexico, sera processada a funcao do ponto de entrada SF2460I no padrao.³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If cPaisLoc == "MEX"
                        RcFatMex()
                    Endif
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Pontos de Entrada                                                      ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                
                    If nModulo == 72
                        KEXF990()
                    EndIf  
                    
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Contabilizacao do Cabecalho                                            ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                    
                    If ( llCt620 )
                        nLctTotal += DetProva(nHdlPrv,"620","MATA460",cLote)
                        aLancCtb := {{"F2_DTLANC",dDataBase,"SF2",SF2->(Recno()),0,0,0}}
                    EndIf
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    PcoDetLan("000101","02","MATA461")
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Restaura a pilha da funcao fiscal                                      ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    lRetorno := .T.
                    cItemSD2 := ""
                    cNumNFS  := ""
                    MaFisEnd()
                    MaFisRestore()
                    nItemNF2 := 0
                    aRegSD2  := {}
                    aTitulo  := { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 }
                EndIf
                nX++
                nItemNF2++              
            EndDo
            aSD2    := {}
            aRegSD2 := {}
        EndIf
    Next nItensSD2
Else
    ConOut("WARNING: DEADLOCK CONTROL IS ON")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aArea)

Return( lRetorno )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaAvalSF2 ³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de atualizacao dos acumulados do SF2                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaAvalSF2(lNoFiscal)

Local cEstado     := SF2->F2_EST
Local lTMSUFPAG   := SuperGetMv("MV_TMSUFPG",.F.,.F.) //-- Define se grava o estado do pagador do frete.
Default lNoFiscal := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a gravacao dos Impostos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lNoFiscal
    MaFisWrite(2,"SF2")
    SF2->F2_VALMERC    := MaFisRet(,"NF_VALMERC")-MaFisRet(,"NF_DESCONTO")
    SF2->F2_VALIRRF    := 0
    If lTMSUFPAG .And. !Empty(MaFisRet(,"NF_PNF_UF")) .And. ("CTR"$SF2->F2_ESPECIE .Or. "NFST"$SF2->F2_ESPECIE .Or. "CTE"$SF2->F2_ESPECIE .Or. "RPS"$SF2->F2_ESPECIE)
        SF2->F2_EST := MaFisRet(,"NF_PNF_UF")
    Else
        SF2->F2_EST := Iif(Empty(cEstado),SF2->F2_EST,cEstado)
    EndIf
EndIf

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraRemFacºAutor  ³Bruno Sobieski      ºFecha ³  10/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera remitos e notas fiscais para as cargas selecionadas    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraRemFac(aRems,lGerRem,cMarcaSC9,aNFs)
Local aParams   :=  {}
AjustaSx1()
If Len(aREMS) > 0 .And. Pergunte('MT462R',.T.)
    aParams :=  {mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06}
   // Verifica moeda
   
    If  aParams[05] ==2 .and. Recmoeda(dDatabase,aParams[06])<=0
        MsgAlert(OemToAnsi("teste"))
        Return .F.
    EndIf
    lGerRem :=  .T.
    SetInvert(.F.)  
    MsProcTxt('Generando '+RetTitle('D2_REMITO')) //'Generando '
    a462ANGera(Nil,cMarcaSC9,.T.,aRems,.T.,aParams)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a geracao das Facturas, se houver.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(aNfs) > 0
    cMarcaSC9 := ThisMark()
    //  MsProcTxt(STR0026) //'Generando facturas'
    AlteraSX1()  // criar perguntas pela moeda
    If Pergunte('MT468C',.T.)
        aParams :=  {   SPACE(Len(SC9->C9_PEDIDO))  ,Replicate('z',Len(SC9->C9_PEDIDO)),; //Pedido de - ate
            SPACE(Len(SA1->A1_COD))     ,Replicate('z',Len(SA1->A1_COD)),; //Cliente de - ate
            SPACE(Len(SA1->A1_LOJA))    ,Replicate('z',Len(SA1->A1_LOJA)),; //Loja de - ate
            SPACE(Len(SB1->B1_GRUPO))   ,Replicate('z',Len(SB1->B1_GRUPO)),; //Grupo de - ate
            SPACE(Len(SA1->A1_AGREG))   ,Replicate('z',Len(SA1->A1_AGREG)),; //Agregador de - ate
            mv_par01    ,mv_par02, mv_par03,; //lDigita # lAglutina # lGeraLanc
            2           ,mv_par04,  mv_par05    ,; //lInverte# lAtuaSC7  # nSepara
            0           ,      2,; //nValorMin # factura proforma
            SPACE(Len(SC5->C5_TRANSP))      ,Replicate('z',Len(SC5->C5_TRANSP)),; //Trasnportadora de - ate
            2,  mv_par06,   mv_par07,mv_par08} //Reajusta na mesma nota #   Fatura Pedido pela   # Moeda para faturamento # Contabiliza por?
        If  aParams[22] ==2 .and. Recmoeda(dDatabase,aParams[23])<=0
            MsgAlert(OemToAnsi('Generando '))
            Return .F.
        EndIf
            
        MsAguarde({|| a468nFatura("SC9",aParams,@aNFs,,.T.)},'Preparando documentos de la carga','Generando facturas',.F.) //'Preparando documentos de la carga'###'Generando facturas'

    Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustSX1_A³ Autor ³Patricia A. Salomao    ³ Data ³ 25/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Deleta Pergunta criada para o Modulo TMS (Transporte)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MT461A                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION AjustSX1_A()

Local aArea :=  GetArea()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("MT461A13") .And. X1_F3 == "M6"
    RecLock("SX1",.F.)
    dbDelete()
    MsUnlock()
EndIf

RestArea(aArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  AjustSX1_B  ³ Autor ³Patricia A. Salomao    ³ Data ³ 25/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Deleta Pergunta criada para o Modulo TMS (Transporte)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MT461B                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustSX1_B()

Local aArea :=  GetArea()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("MT461B09") .And. X1_F3 == "M6"
    RecLock("SX1",.F.)
    dbDelete()
    MsUnlock()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AlteraSX1º Autor ³ Paulo Augusto      ºFecha ³  15/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criar pergunta para compatibilizar com o MATA468N          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA461                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AlteraSX1()
Local aArea := GetArea()
Local aKey  := {{"MT468C","06"},;
                {"MT468C","07"},;   
                {"MT468C","08"}}
Local nI := 0 
Local aHelpPor:= {}
Local aHelpEng:= {}
Local aHelpSpa:= {}             
                
DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To Len(aKey)
    If !DbSeek(aKey[nI][1]+aKey[nI][2]) 
        
        If aKey[nI][1]+aKey[nI][2]  == "MT468C06"  
            PutSx1( aKey[nI][1], aKey[nI][2],"Fatura Pedido pela ?","Factura Pedido por ?","Invoice order by   ?","mv_ch6","N",1,0,1,"C","","","","",;
            "mv_par06","Moeda Ped.","Moneda Pedido ","Order Currency","","Moneda Seleccionada","Moeda Sel.","Selected Currency","","","","","","","","","")
            aHelpPor:= {}
            aHelpEng:= {}
            aHelpSpa:= {}               
            aAdd(aHelpEng,"Select the currency to be used  ")
            aAdd(aHelpEng,"by the outflow document. ")
            aAdd(aHelpPor,"Selecione em qual moeda sera ")
            aAdd(aHelpPor,"gerado o documento de saida.")
            aAdd(aHelpSpa,"Seleccione en que moneda se ")
            aAdd(aHelpSpa,"generara el documento de salida.")
            PutSX1Help("P.MT468C06.",aHelpPor,aHelpEng,aHelpSpa)     

        ElseIf aKey[nI][1]+aKey[nI][2] == "MT468C07"    
            PutSx1( aKey[nI][1], aKey[nI][2],"Fatura pela Moeda  ?","Fatura pela Moeda  ?","Fatura pela Moeda  ?","mv_ch7","N",1,0,1,"C","","","","",;
            "mv_par07","Moeda 1   ","Moneda 1   ","Currency 1 ","","Moeda 2   ","Moneda 2   ","Currency 2","Moeda 3","Moneda 3","Currency 3","Moeda 4","Moneda 4","Currency 4","Moeda 5","Moneda 5","Currency 5","","","","")   
            aHelpPor:= {}
            aHelpEng:= {}
            aHelpSpa:= {}               
            aAdd(aHelpEng,"Select the currency. ")
            aAdd(aHelpPor,"Selecione a moeda  ")
            aAdd(aHelpSpa,"Seleccione la moneda ")
        
            PutSX1Help("P.MT468C07.",aHelpPor,aHelpEng,aHelpSpa)     
    ElseIf aKey[nI][1]+aKey[nI][2] == "MT468C08"  // Contabiliza por (Pedidos)
                
        PutSx1( aKey[nI][1], aKey[nI][2],"Record by ?","Contabiliza por ?","Contabiliza por   ?","mv_ch8","N",1,0,1,"C","","","","",;
        "mv_par08","Nota ","Factura","Invoice","","Total Notas","Total Facturas","Total Invoices","","","","","","","","","")
            aHelpPor:= {}
            aHelpEng:= {}
            aHelpSpa:= {}               
            aAdd(aHelpEng,"Select how record of invoice ")
            aAdd(aHelpEng,"by the outflow document. ")
            aAdd(aHelpPor,"Selecione como sera feita a ")
            aAdd(aHelpPor,"contabilizacao das notas.")
            aAdd(aHelpSpa,"Seleccione como se ")
            aAdd(aHelpSpa,"contabilizaran las facturas.")
            PutSX1Help("P.MT468C08.",aHelpPor,aHelpEng,aHelpSpa)       
        EndIf
    EndIf
Next nI
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1º Autor ³ Paulo Augusto      ºFecha ³  10/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criar pergunta para compatibilizar com o MATA468N          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA461                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(lP21)
Local aArea := GetArea()
Local aKey  := {{"MT462R","05"},;
                {"MT462R","06"} }
Local nI := 0   
Local cPerg   := "MT460A"           
Local aHelpPor:= {}
Local aHelpEng:= {}
Local aHelpSpa:= {}             
  
Default lP21 := .F.                 

DbSelectArea("SX1")
DbSetOrder(1)     
If cPaisLoc=="BRA"

    //Deixa o parâmetro com data base, para não gerar nota fiscal com cotação errada. 
    If SX1->(DbSeek("MT460A    21")) .And. !Empty(SX1->X1_CNT01)
        lP21 := .T.
        RecLock("SX1",.F.)
        Replace SX1->X1_CNT01   With ""
        SX1->(MsUnLock())
    Endif
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Gera Guia de Recolhimento ou Titulo ICMS no Contas a pagar quando nao for do mesmo Estado ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //Inclusao de novas perguntas para que o usuario tenha a opcao de recolhe a guia e gerar o titulo na Documentacao de Entrada
    aHelpPor:= {}
    aHelpEng:= {}
    aHelpSpa:= {}               
    Aadd( aHelpPor, "Informe se deverá ser gerado o título ")
    Aadd( aHelpPor, "a pagar do ICMS Substituição Tributária ") 
    Aadd( aHelpPor, "quando este for calculado no documento e")
    Aadd( aHelpPor, " a UF de destino for diferente da UF que")
    Aadd( aHelpPor, " está emitindo o documento.")
    Aadd( aHelpEng, "Informe se deverá ser gerado o título ")
    Aadd( aHelpEng, "a pagar do ICMS Substituição Tributária ") 
    Aadd( aHelpEng, "quando este for calculado no documento e")
    Aadd( aHelpEng, " a UF de destino for diferente da UF que")
    Aadd( aHelpEng, " está emitindo o documento.")
    Aadd( aHelpSpa, "Informe se deverá ser gerado o título ")
    Aadd( aHelpSpa, "a pagar do ICMS Substituição Tributária ") 
    Aadd( aHelpSpa, "quando este for calculado no documento e")
    Aadd( aHelpSpa, " a UF de destino for diferente da UF que")
    Aadd( aHelpSpa, " está emitindo o documento.")

    PutSx1(cPerg,"17","Gera Titulo ?"           ,"¿Genera Titulo ? "           ,"Generate Bill ? "           ,"mv_chh","N",01,0,2,"C","","","","","mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
    
    aHelpPor:= {}
    aHelpEng:= {}
    aHelpSpa:= {}               
    Aadd( aHelpPor, "Informe se deverá ser gerada uma Guia ")
    Aadd( aHelpPor, "de Recolhimento do ICMS Substituição ")
    Aadd( aHelpPor, "Tributária quando este for calculado ")
    Aadd( aHelpPor, "no documento e a UF de destino for ")
    Aadd( aHelpPor, "diferente da UF que está emitindo o ") 
    Aadd( aHelpPor, "documento. O sistema irá apresentar ")
    Aadd( aHelpPor, "uma tela para que as informações ")
    Aadd( aHelpPor, "necessárias a geração da Guia sejam ")
    Aadd( aHelpPor, "preenchidas.")
    Aadd( aHelpEng, "Informe se deverá ser gerada uma Guia ")
    Aadd( aHelpEng, "de Recolhimento do ICMS Substituição ")
    Aadd( aHelpEng, "Tributária quando este for calculado ")
    Aadd( aHelpEng, "no documento e a UF de destino for ")
    Aadd( aHelpEng, "diferente da UF que está emitindo o ") 
    Aadd( aHelpEng, "documento. O sistema irá apresentar ")
    Aadd( aHelpEng, "uma tela para que as informações ")
    Aadd( aHelpEng, "necessárias a geração da Guia sejam ")
    Aadd( aHelpEng, "preenchidas.")
    Aadd( aHelpSpa, "Informe se deverá ser gerada uma Guia ")
    Aadd( aHelpSpa, "de Recolhimento do ICMS Substituição ")
    Aadd( aHelpSpa, "Tributária quando este for calculado ")
    Aadd( aHelpSpa, "no documento e a UF de destino for ")
    Aadd( aHelpSpa, "diferente da UF que está emitindo o ") 
    Aadd( aHelpSpa, "documento. O sistema irá apresentar ")
    Aadd( aHelpSpa, "uma tela para que as informações ")
    Aadd( aHelpSpa, "necessárias a geração da Guia sejam ")
    Aadd( aHelpSpa, "preenchidas.")
    PutSx1(cperg,"18","Gera guia recolhimento ?","¿Genera form. de pago ? "    ,"Generate tax payment form ?","mv_chi","N",01,0,2,"C","","","","","mv_par18","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
    aHelpPor:= {}
    aHelpEng:= {}
    aHelpSpa:= {}               
    Aadd( aHelpPor, "Informe se deverá ser gerado o título ")
    Aadd( aHelpPor, "a pagar do ICMS Próprip quando") 
    Aadd( aHelpPor, "este for calculado no documento e")
    Aadd( aHelpPor, "a UF de destino for diferente da UF que")
    Aadd( aHelpPor, "está emitindo o documento.")
    Aadd( aHelpEng, "Informe se deverá ser gerado o título ")
    Aadd( aHelpEng, "a pagar do ICMS Próprip quando") 
    Aadd( aHelpEng, "este for calculado no documento e")
    Aadd( aHelpEng, "a UF de destino for diferente da UF que")
    Aadd( aHelpEng, "está emitindo o documento.")
    Aadd( aHelpSpa, "Informe se deverá ser gerado o título ")
    Aadd( aHelpSpa, "a pagar do ICMS Próprip quando") 
    Aadd( aHelpSpa, "este for calculado no documento e")
    Aadd( aHelpSpa, "a UF de destino for diferente da UF que")
    Aadd( aHelpSpa, "está emitindo o documento.")
    PutSx1(cPerg,"19","Gera Titulo ICMS Próprio ?" ,"Gera Titulo ICMS Próprio ?","Gera Titulo ICMS Próprio ?" ,"mv_chj","N",01,0,2,"C","","","","","mv_par19","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
    
     
    aHelpPor:= {}
    aHelpEng:= {}
    aHelpSpa:= {}               
    Aadd( aHelpPor, "Informe se deverá ser gerada uma  ")
    Aadd( aHelpPor, "Guia de Recolhimento do ICMS Próprio ")
    Aadd( aHelpPor, "quando este for calculado no ")
    Aadd( aHelpPor, "documento e a UF de destino for ")
    Aadd( aHelpPor, "diferente da UF que está emitindo o ") 
    Aadd( aHelpPor, "documento. O sistema irá apresentar ")
    Aadd( aHelpPor, "uma tela para que as informações ")
    Aadd( aHelpPor, "necessárias a geração da Guia sejam ")
    Aadd( aHelpPor, "preenchidas.")
    Aadd( aHelpEng, "Informe se deverá ser gerada uma  ")
    Aadd( aHelpEng, "Guia de Recolhimento do ICMS Próprio ")
    Aadd( aHelpEng, "quando este for calculado no ")
    Aadd( aHelpEng, "documento e a UF de destino for ")
    Aadd( aHelpEng, "diferente da UF que está emitindo o ") 
    Aadd( aHelpEng, "documento. O sistema irá apresentar ")
    Aadd( aHelpEng, "uma tela para que as informações ")
    Aadd( aHelpEng, "necessárias a geração da Guia sejam ")
    Aadd( aHelpEng, "preenchidas.")
    Aadd( aHelpSpa, "Informe se deverá ser gerada uma  ")
    Aadd( aHelpSpa, "Guia de Recolhimento do ICMS Próprio ")
    Aadd( aHelpSpa, "quando este for calculado no ")
    Aadd( aHelpSpa, "documento e a UF de destino for ")
    Aadd( aHelpSpa, "diferente da UF que está emitindo o ") 
    Aadd( aHelpSpa, "documento. O sistema irá apresentar ")
    Aadd( aHelpSpa, "uma tela para que as informações ")
    Aadd( aHelpSpa, "necessárias a geração da Guia sejam ")
    Aadd( aHelpSpa, "preenchidas.")
    PutSx1(cperg,"20","Gera Guia ICMS Próprio?","Gera Guia ICMS Próprio?","Gera Guia ICMS Próprio?","mv_chl","N",01,0,2,"C","","","","","mv_par20","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
Else
    For nI := 1 To Len(aKey)
        If !DbSeek(aKey[nI][1]+aKey[nI][2]) 
            
            If aKey[nI][1]+aKey[nI][2]  == "MT462R05"  
                PutSx1( aKey[nI][1], aKey[nI][2],"Gera " + GetDescRem()+ " pela ?","Genera " + GetDescRem()+ " por ?","Gera " + GetDescRem()+ " By ?","mv_ch5","N",1,0,1,"C","","","","",;
                "mv_par05","Moeda " + GetDescRem() + " .","Moneda " + GetDescRem()+ " ." ,  GetDescRem() + "Currency .","","Moeda Selecionada.","Moneda Seleccionada.","Selected Currency.","","","","","","","","","")
                aHelpPor:= {}
                aHelpEng:= {}
                aHelpSpa:= {}               
                aAdd(aHelpEng,"Select the currency to be used  ")
                aAdd(aHelpPor,"Selecione em qual moeda sera ")
                aAdd(aHelpPor,"gerado .")
                aAdd(aHelpSpa,"Seleccione en que moneda se  ")
                aAdd(aHelpSpa,"generara .")
                PutSX1Help("P.MT462R05.",aHelpPor,aHelpEng,aHelpSpa)     
            ElseIf aKey[nI][1]+aKey[nI][2] == "MT462R06"    
                PutSx1( aKey[nI][1], aKey[nI][2],"Fatura pela Moeda  ?","Factura pela Moneda  ?","Fatura pela Moeda  ?","mv_ch6","N",1,0,1,"C","","","","",;
                "mv_par06","Moeda 1   ","Moneda 1   ","Currency 1 ","","Moeda 2   ","Moneda 2   ","Currency 2","Moeda 3","Moneda 3","Currency 3","Moeda 4","Moneda 4","Currency 4","Moeda 5","Moneda 5","Currency 5","","","","")   
                aHelpPor:= {}
                aHelpEng:= {}
                aHelpSpa:= {}               
                aAdd(aHelpEng,"Select the currency. ")
                aAdd(aHelpPor,"Selecione a moeda  ")
                aAdd(aHelpSpa,"Seleccione la moneda ")
                PutSX1Help("P.MT462R06.",aHelpPor,aHelpEng,aHelpSpa)     
            EndIf
        EndIf
    Next nI
EndIf
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461Saldo ³ Autor ³Rodrigo de A Sartorio  ³ Data ³06/07/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia o saldo do item do pedido para nao permitir que seja ³±±
±±³          ³faturado um item indisponivel em estoque.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico    - .T. item do pedido sera faturado, .F. nao sera  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPedido   - Numero do pedido analisado                      ³±±
±±³          ³cItem     - Item do pedido analisado                        ³±±
±±³          ³cProduto  - Produto do pedido analisado                     ³±±
±±³          ³cLocal    - Armazem do pedido analisado                     ³±±
±±³          ³nQuant    - Quantidade do pedido analisado                  ³±±
±±³          ³nQuant2UM - Quantidade do pedido analisado na segunda UM    ³±±
±±³          ³cLoteCtl  - Lote do pedido analisado                        ³±±
±±³          ³cNumLote  - Sub-Lote do pedido analisado                    ³±±
±±³          ³aTravas   - Array com os Recno travados                     ³±±
±±³          ³lSemSaldo - Indica que nao existe saldo para o produto      ³±±
±±³          ³lEstoque  - Indica se atualiza estoque                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A461Saldo(cPedido,cItem,cProduto,cLocal,nQuant,nQuant2UM,cLoteCtl,cNumLote,aTravas,lSemSaldo,lAtuEst)
Local lRet     := .T.
Local aArray   := {}
Local aArea    := {}
Local nCnt     := 0
Local nCnt2    := 0
Local nSaldo   := 0
Local lEstNeg  := SuperGetMV("MV_ESTNEG",.F.,'N')=='S'
Local lRastro  := Rastro(cProduto) 
Local lLocaliza:= Localiza(cProduto)
Local lM461ADT := ExistBlock("M461ADT")
Local lM461SLD := ExistBlock("M461SLD") .And. ExecBlock("M461SLD",.F.,.F.)

Default aTravas   := {}
Default lSemSaldo := .F.
Default lAtuEst   := .F.

// Checa o saldo do lote/Endereco
If !lEstNeg .And. !lM461SLD .And. lAtuEst .And. ( lRastro .Or. lLocaliza )
    aArea :=GetArea()
    aArray:=SldPorLote(cProduto,cLocal,nQuant,nQuant2UM,cLoteCtl,cNumLote,NIL,NIL,@aTravas,NIL,NIL,NIL,NIL,NIL,dDatabase,,,.T.)
    If lRet .And. lRastro
        nSaldo := 0
        For nCnt:=1 to Len(aArray)
            For nCnt2:=1 to Len(aArray[nCnt,10])
                nSaldo+=aArray[nCnt,10,nCnt2,2]
            Next nCnt2
        Next nCnt
        lRet:=QtdComp(nSaldo) >= QtdComp(nQuant)
    EndIf
    If lRet .And. lLocaliza 
        nSaldo := 0
        For nCnt:=1 to Len(aArray)
            nSaldo+=aArray[nCnt,5]
        Next nCnt
        lRet:=QtdComp(nSaldo) >= QtdComp(nQuant)
    EndIf   
    RestArea(aArea)
    If !lRet
        lSemSaldo := .T.
    EndIf   
EndIf          

If lRet
    If lM461ADT
        lRet := ExecBlock("M461ADT",.F.,.F.,{cPedido, cItem})
    EndIf   
Endif   

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma460ChkF3³ Autor ³ Marco Bianchi         ³ Data ³27/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Na geracao da tabela SD9 (MV_TPNRNFS=3), verifica se a nota ³±±
±±³          ³encontrada em MA461MkNum existe em SF3 (cancelada ou nao).  ³±±
±±³          ³Se existir nao permite utilizacao do numero.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ma460ChkF3(cNumNF,cSerNF)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Retorna .T. / .F.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³M461JBNUM                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


/*/
Static Function Ma460ChkF3(cIniNUM,cIniSER)

Local aArea   := GetArea()
Local aAreaSF3 := SF3->(GetArea())
Local lBack   := .F.
#IFDEF TOP
Local cQuery  := ""
#ENDIF

If cPaisLoc == "BRA"
    #IFDEF TOP
        If TcSrvType()<>"AS/400"
            SF3->(dbCommit())
            cQuery := "SELECT COUNT(*) SF3NOTA "
            cQuery += "FROM "+RetSqlName("SF3")+" SF3 "
            cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
            cQuery += "SF3.F3_SERIE='"+cIniSer+"' AND "
            cQuery += "SF3.F3_NFISCAL='"+cIniNum+"' AND "
            cQuery += "(SF3.F3_CFO LIKE '5%' OR SF3.F3_CFO LIKE '6%' OR SF3.F3_CFO LIKE '7%' OR SF3.F3_FORMUL='S' ) AND "
            cQuery += "SF3.D_E_L_E_T_=' ' "
            
            cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKF3NOTA",.T.,.T.)
            
            If CHKF3NOTA->SF3NOTA > 0
                lBack := .T.
            EndIf
            dbCloseArea()
            dbSelectArea("SF3")
        Else
    #ENDIF
        DbSelectArea( "SF3" )
        DbSetOrder( 5 )
        If MsSeek( xFilial("SF3")+cIniSER+cIniNUM,.F.)
            If Substr(SF3->F3_CFO,1,1) < "5"
                While !Eof() .And. (xFilial("SF3")+cIniSER+cIniNUM) == (SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL) .And. !lBack
                    If (SF3->F3_FORMUL == "S" .Or.Substr(SF3->F3_CFO,1,1) > "5")
                        lBack := .T.
                    EndIf
                    DbSelectArea("SF3")                 
                    DbSkip()
                EndDo
            Else
                lBack := .T.
            EndIf
        EndIf
        #IFDEF TOP
        EndIf
        #ENDIF
EndIf

RestArea(aAreaSF3)
RestArea(aArea)

Return( lBack )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma461LibD9³ Autor ³ Marco Bianchi         ³ Data ³24/10/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Libera numeracao da nota no SD9 dentro das seguintes situa- ³±±
±±³          ³coes:                                                       ³±±
±±³          ³                                                            ³±±
±±³          ³1. Caso 2 usuarios marquem o mesmo pedido e confirme a      ³±±
±±³          ³   gravacao da nota, o segundo usuario tera gravado o SD9,  ³±±
±±³          ³   porem, nao ira gerar a nota, pois foi gerada pelo pri-   ³±±
±±³          ³   meiro usuario. Desta forma, tornou-se necessario liberar ³±±
±±³          ³   o numero da nota no SD9 reservada pelo primeiro usuario. ³±±
±±³          ³                                                            ³±±
±±³          ³2. Caso um usuario marque e tente faturar um pedido que esta³±±
±±³          ³   sendo alterado por outro usuario.                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ma461LibD9(cSerie)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Retorna .T. / .F.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MaPvlNfs2                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma461LibD9(cSerie,cNumero)
      
Local nTentativas   := 0
Local aRegSD9       := SD9->(GetArea("SD9"))
Local lTravou       := .F.

dbSelectArea("SD9")
dbSetOrder(2) // D9_FILIAL+D9_SERIE+D9_DOC+DTOS(D9_DTUSO)
dbSeek(xFilial("SD9")+cSerie+cNumero)

While !Eof() .And. (D9_FILIAL+D9_SERIE+Alltrim(D9_DOC) == xFilial("SD9")+cSerie+Alltrim(cNumero)) .And. !lTravou
    lTravou := RecLock("SD9",.F.)
    If lTravou
        dbSelectArea("SD9")
        Replace D9_DTUSO   With CTOD("  /  /  ")
        Replace D9_USUARIO With ""
        Replace D9_HORA    With ""
        Msunlock()
    Else
        nTentativas+=1
        If nTentativas >= 50
            Exit
        EndIf
    EndIf
EndDo
RestArea(aRegSD9)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma460InfOr³ Autor ³ Marcelo Alexandre     ³ Data ³17/02/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao criada para retornar para matxfis a informacao da UF ³±±
±±³          ³e aliquota da nota original de entrada quando o produto pos-³±±
±±³          ³suir rastro por sublote.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ma460InfOr                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Retorna                                                     ³±±
±±³          |UF Original da nota de entrada                              ³±±
±±³          |Aliquota Original da nota de entrada                        ³±±
±±³          |Quantidade proporcional da venda referente ao lote          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma460InfOr(cPedido,cItem,cProduto,cLocal,nQuant,nQuant2UM,dDataLib,cLoteCtl,cNumLote)

Local nX      := 0
Local nPropLot:= 0
Local lRastro    := ExistBlock("MAFISRASTRO")
Local lRastroLot := .F.
Local aSaldos    := {}
Local aInfLote   := {}
Local aNfOri     := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento do IVA Ajustado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ           
SB1->(dbSetOrder(1))
If SB1->(MsSeek(xFilial("SB1")+cProduto))
   lIVAAju := IIF(SB1->(FieldPos("B1_IVAAJU")) > 0 .And. SB1->B1_IVAAJU == '1' .And. (IIF(lRastro,lRastroLot := ExecBlock("MAFISRASTRO",.F.,.F.),Rastro(cProduto,"S"))),.T.,.F.)
EndIf
If lIVAAju
    dbSelectArea("SC6")
    dbSetOrder(1)
    MsSeek(xFilial("SC6")+cPedido)
    aSaldos := SldPorLote(cProduto,cLocal,nQuant,nQuant2UM,cLoteCtl,cNumLote,NIL,NIL,NIL,.T.,NIL,NIL,NIL,NIL,dDataBase)

    For nX := 1 to Len(aSaldos)
        nPropLot := Round((aSaldos[nX][5]/SC6->C6_QTDVEN)*100,2)
        If lRastroLot
            dbSelectArea("SB8")
            dbSetOrder(5)
            If MsSeek(xFilial("SB8")+cProduto+aSaldos[nX][01])
                aadd(aInfLote,{SB8->B8_DOC,SB8->B8_SERIE,SB8->B8_CLIFOR,SB8->B8_LOJA,nPropLot})
            EndIf       
        Else                
            dbSelectArea("SB8")
            dbSetOrder(2)
            If MsSeek(xFilial("SB8")+aSaldos[nX][02]+aSaldos[nX][01])
                aadd(aInfLote,{SB8->B8_DOC,SB8->B8_SERIE,SB8->B8_CLIFOR,SB8->B8_LOJA,nPropLot})
            EndIf
        EndIf
        dbSelectArea("SF3")
        dbSetOrder(4)
        If MsSeek(xFilial("SF3")+aInfLote[nX][03]+aInfLote[nX][04]+aInfLote[nX][01]+aInfLote[nX][02])
            aadd(aNfOri,{SF3->F3_ESTADO,SF3->F3_ALIQICM,aInfLote[nX][05]})
        EndIf
    Next nX
EndIf           

Return( aNfOri )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidCGC  ºAutor  ³ Luis Gustavo       º Data ³  07/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o CGC digitado se existe.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ ExpC1 - CGC do cliente                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ ExpL1 - Retorno da funcao T ou F                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidCGC(cCgc)
Local lRet      := .F.                                  // Retorno da funcao
Local cVerCgc   := cCgc                                 // CGC do cliente
Local cNumCNPJ  := Space(TamSX3("A1_CGC")[1])           //varivel para armazenar o retorno da funcao CGC

DEFAULT cCgc := ""

If !Empty(cCgc)         
    If Len( AllTrim( cCgc ) ) >= 11 .AND. Len( AllTrim( cCgc ) ) <= 14
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Retira caracteres que nao sao usados³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cVerCgc := StrTran(cVerCgc,".","")
        cVerCgc := StrTran(cVerCgc,"-","")
        cVerCgc := StrTran(cVerCgc,"/","")
        cVerCgc := Alltrim(cVerCgc)
    
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Valida se o CGC digitado eh valido³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If CGC(cVerCgc, @cNumCNPJ)
            lRet := .T.
            cCgc := cVerCgc
        EndIf
    Else
        MsgStop( "CPF/CNPJ inválido!" )         // "CPF/CNPJ inválido!"
        cCgc := Space(18)
    EndIf   
Else
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Se estiver em branco, valida a insercao³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    lRet := .T.
EndIf

Return lRet 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaAcreFinAdt³ Autor ³Totvs                ³ Data ³22.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o valor do acrescimo financeiro do item, usado para ³±±
±±³          ³o processo de adiantamento.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Valor do acrescimo financeiro do item                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
±±³          ³ExpN2: Item do documento                                    ³±±
±±³          ³ExpL3: Reajuste                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaAcreFinAdt(aPvlNfs,nx,lReajuste,dDataMoe)

Local aVar := {}
Local nPrcVen   := 0
Local nPrUnit   := 0
Local nAcresFin := 0
Local lAcresDup := ( SuperGetMv("MV_ACRSDUP",.F.,.F.) == .T.)
Local aArea := GetArea()
Local aAreaSC9 := SC9->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSF4 := SF4->(GetArea())

Default dDataMoe := dDataBase

If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][8])

dbSelectArea("SB1")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][12])

dbSelectArea("SC5")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][9])

dbSelectArea("SC6")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][10])

dbSelectArea("SF4")
dbSetOrder(1)
MsGoto(aPvlNfs[nx][14])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Preco de Venda                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPrcVen := SC9->C9_PRCVEN
nPrUnit := If(SC6->C6_PRUNIT<>0,SC6->C6_PRUNIT,SC9->C9_PRCVEN)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula o reajuste de preco.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !Empty(SC5->C5_REAJUST) .And. lReajuste )
    nPrcVen  := Formula(SC5->C5_REAJUST)
    nPrUnit := nPrcVen
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Converte os valores para a Moeda Corrente(1)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_MOEDA > 1 
    If  ExistBlock("M460PRC")
        aVar     := ExecBlock("M460PRC",.F.,.F.,{nPrcVen,nPrUnit})
        nPrcVen  := aVar[1]
        nPrUnit  := aVar[2]
    Else                   
        nPrcVen  := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataMoe,8)
        nPrUnit := xMoeda(nPrUnit,SC5->C5_MOEDA,1,dDataMoe,8)
    Endif   
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Acrescimo Financeiro                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SC5->C5_ACRSFIN <> 0 ) 
    If lAcresDup
        nAcresFin := a410Arred(nPrcVen*SC5->C5_ACRSFIN/100,"D2_PRCVEN")
    Else
        If SF4->F4_DUPLIC=="S"                                          
            nAcresFin := a410Arred(nPrcVen*SC5->C5_ACRSFIN/100,"D2_PRCVEN")     
        Endif
    Endif       
EndIf

nAcresFin := nAcresFin * aPvlNfs[nx][4]

SC9->(RestArea(aAreaSC9))
SB1->(RestArea(aAreaSB1))
SC5->(RestArea(aAreaSC5))
SC6->(RestArea(aAreaSC6))
SF4->(RestArea(aAreaSF4))
RestArea(aArea)

Return(nAcresFin)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461NAdian  ³ Autor ³Totvs                ³ Data ³09.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a regra em relacao ao Pedido de Vendas quando utili- ³±±
±±³          ³za condicao de pagamento com Adiantamento.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se adiantamento foi associado ao documento    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do Pedido de venda                            ³±±
±±³          ³ExpC2: Condicao de Pagamento deste documento de saida       ³±±
±±³          ³ExpA3: Array com os itens a serem gerados                   ³±±
±±³          ³ExpL4: Indica se pergunta para selecionar adiantamento jah  ³±±
±±³          ³foi respondida                                              ³±±
±±³          ³ExpL5: Indica se adiantamento jah foi associado ao documento³±±
±±³          ³ExpC6: Codigo do cliente                                    ³±±
±±³          ³ExpC7: Loja do cliente                                      ³±±
±±³          ³ExpA8: Array usado na condicao de pagamento                 ³±±
±±³          ³ExpN9: Valor do acrescimo financeiro                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A461NAdian(cNumPedido, cCondPagto, aPvlNfs, lRespVlrInf, lActVlrInf, cCliente, cLoja, aImpVarDup, nAcresTot)

Local lRet := .T. 
Local aArea := GetArea()
Local aAreaSC9 := SC9->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local nValTot  := 0 // Total do pedido (Liberado)
Local nValAdt  := 0 // Valor total do Adiantamento 
Local aVenc    := {} // Array de parcelas
Local aPedidos := {} 
Local nI       := 0
Local aAreaSE1 := SE1->(GetArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O processo de Recebimento Antecipado estará disponivel ³
//³apenas para TOP no Financeiro.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP 
    If A410UsaAdi( cCondPagto )                                      
        lRet := .F.
        DbSelectArea("SC9")
        DbSetOrder(1) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
        If DbSeek( xFilial("SC9")+cNumPedido )
            While   SC9->C9_FILIAL == xFilial("SC9") .AND.;
                    SC9->C9_PEDIDO == cNumPedido
                
                If aScan(aPvlNfs, {|x| x[8]==SC9->(RECNO())}) > 0
                    nValTot += SC9->C9_QTDLIB * SC9->C9_PRCVEN
                EndIf
                SC9->(DbSkip())     
            End      
            SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
            If SC5->(DbSeek( xFilial("SC5")+cNumPedido ))
                nValTot += SC5->C5_FRETE+SC5->C5_SEGURO+SC5->C5_DESPESA
            EndIf
            aVenc := Condicao(nValTot,cCondPagto,0.00,dDataBase,0.00,aImpVarDup,,nAcresTot) 
            If Len(aVenc) > 0
                // aVenc[1,2] - Valor da primeira parcela
                // Carrega array de Adiantamentos relacionados ao pedido
                aPedidos := FPedAdtPed( "R", {cNumPedido}, .F. )
                For nI := 1 To Len(aPedidos)
                    // checa se o saldo atual do adiantamento eh igual ou maior que o valor relacionado no pedido
                    SE1->(dbGoto(aPedidos[nI][2]))
                    If SE1->(Recno()) = aPedidos[nI][2]
                        If SE1->E1_SALDO >= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDataBase,,SE1->E1_LOJA,,0,1)
                            nValAdt += aPedidos[nI][3]
                        Endif
                    Endif       
                Next nI
                
                If Empty(nValAdt) // eh necessario existir ao menos um adiantamento para o documento de saida a ser gerado                                  
                    // Indica se o usuário ja respondeu ao questionamento nesta liberacao
                    If !lRespVlrInf 
                        lRespVlrInf := .T. 
                        lActVlrInf  := ApMsgYesNo("Foram encontrado(s) pedido(s) usando condição de pagamento associado com 'Adiantamento', porém sem nenhum Adiantamento associado." + CRLF+ "Deseja selecionar agora o(s) Adiantamento(s)?") // "Foram encontrado(s) pedido(s) usando condição de pagamento associado com 'Adiantamento', porém sem nenhum Adiantamento associado." + CRLF+ "Deseja selecionar agora o(s) Adiantamento(s)?"
                    EndIf         
                    If lActVlrInf 
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³Abre a tela do financeiro para inclusao³
                        //³de Adiantamento                        ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If A461NPedido(cNumPedido, cCliente, cLoja, nValAdt, aVenc[1,2], cCondPagto)
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³Chamada recursiva para saber se     ³
                            //³foi atendida a regra do Adiantamento³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            lRet := A461NAdian(cNumPedido, cCondPagto, aPvlNfs, lRespVlrInf, lActVlrInf, cCliente, cLoja, aImpVarDup, nAcresTot)
                        EndIf                       
                    EndIf
                Else
                    lRet := .T.
                EndIf           
            EndIf
        EndIf
    EndIf
#ENDIF

RestArea(aAreaSC9) 
RestArea(aAreaSC5)
RestArea(aAreaSE1)
RestArea(aArea)

Return lRet       


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461NCompAd ³ Autor ³Totvs                ³ Data ³09.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Realiza a compensacao do Titulo a Receber quando trata-se   ³±±
±±³          ³da parcela a Vista e o pedido utilizou Adiantamento.        º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os Pedidos de Venda                        ³±±
±±³          ³ExpA2: Array com o Recno dos titulos gerados                ³±±
±±³          ³ExpA3: Array com os adiantamentos relacionados ao pedido    ³±±
±±³          ³ExpA4: Array com os itens a serem gerados                   ³±±
±±³          ³ExpL5: Indica se eh compensacao do contas a receber         ³±±
±±³          ³ExpC6: Numero do Documento de Saida                         ³±±
±±³          ³ExpC7: Serie do Documento de Saida                          ³±±
±±³          ³ExpA8: Array usado na condicao de pagamento                 ³±±
±±³          ³ExpN9: Valor do acrescimo financeiro                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A461NCompAd(aAtuSC5, aRegSE1, aRecnoAdt, aPvlNfs, lCmp, cDoc, cSerie, aImpVarDup, aAcresTot, aTitulo )

Local aArea := GetArea()
Local aAreaSE1      := SE1->(GetArea())
Local aAreaSC5      := SC5->(GetArea())
Local aAreaSC9      := SC9->(GetArea())
Local lContabiliza := .F.
Local lDigita       := .F.       
Local lAglutina     := .F.  
Local aCodPedidos   := {}   // Recebe o codigo dos Pedidos
Local aRecRet       := {}   // Retorno da funcao que carrega os titulos de Adiantamento
Local nI                := 0    // Variavel utilizado em loop
Local nAux          := 0    // Variavel utilizado em loop
Local aRecNo        := {}   // Recebe o Recno do Titulo de Adiantamento
Local aRecVlr       := {}   // Recebe o valor limite para compensação do Titulo de Adiantamento
Local nVlrParc1 := 0    // Valor da primeira parcela da Nota Fiscal        
Local aPedidos      := {}   // Array para ajuste do saldo no relacionamento do Financeiro
Local nAcresTot     := 0
Local lRet          := .F.
Local nVlrTot       := 0

Default aRecnoAdt := NIL
Default lCmp := .F.
Default cDoc := ""
Default cSerie := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se há ao menos 1 parcela nesta venda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aRegSE1) >= 1

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Carrega os titulos de Adiantamentos relacionados aos³
    //³Pedidos da Nota.                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ValType(aRecnoAdt) == "U"
        For nI := 1 To Len(aAtuSC5)
            nAcresTot := aAcresTot[aScan(aAcresTot,{|x| x[1] = aAtuSC5[nI]})][2]                
            aPedidos := {}          
            nVlrParc1 := A461NP1Vlr(aAtuSC5[nI], aPvlNfs, aImpVarDup, nAcresTot )
            
            // RA's
            aRecRet := FPedAdtPed( "R", { aAtuSC5[nI] }, .F. )
            For nAux := 1 To Len(aRecRet)
                If !Empty(aRecRet[nAux, 3]) // soh trata registros com saldo diferente de 0
                    // checa se o saldo atual do adiantamento eh igual ou maior que o valor relacionado no pedido
                    SE1->(dbGoto(aRecRet[nAux][2]))
                    If SE1->(Recno()) = aRecRet[nAux][2]
                        If SE1->E1_SALDO >= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDataBase,,SE1->E1_LOJA,,0,1)
                            If nVlrParc1 >= aRecRet[nAux, 3] 
                                nVlrTot += aRecRet[nAux, 3]
                                // checa se total de compensacoes nao ultrapassou o valor total do titulo
                                If Valtype("aTitulo") != "U"
                                    If nVlrTot > aTitulo[_VLRTIT_]
                                        aRecRet[nAux, 3] := aRecRet[nAux, 3]-(nVlrTot-aTitulo[_VLRTIT_])
                                    Endif   
                                Endif   
                                aAdd(aRecVlr,  aRecRet[nAux, 3])
                                aAdd(aRecNo,    aRecRet[nAux, 2])
                                nVlrParc1 -= aRecRet[nAux, 3]
                                // Array para ajuste do saldo do relacionamento no Financeiro
                                aAdd( aPedidos, {aRecRet[nAux, 1], aRecRet[nAux, 2], aRecVlr[Len(aRecVlr)]} )           
                            ElseIf nVlrParc1 > 0
                                nVlrTot += nVlrParc1
                                // checa se total de compensacoes nao ultrapassou o valor total do titulo
                                If Valtype("aTitulo") != "U"
                                    If nVlrTot > aTitulo[_VLRTIT_]
                                        nVlrParc1 := nVlrParc1-(nVlrTot-aTitulo[_VLRTIT_])
                                    Endif   
                                Endif   
                            aAdd(aRecVlr,   nVlrParc1)
                                aAdd(aRecNo,    aRecRet[nAux, 2])
                            nVlrParc1 := 0                      
                                // Array para ajuste do saldo do relacionamento no Financeiro
                                aAdd( aPedidos, {aRecRet[nAux, 1], aRecRet[nAux, 2], aRecVlr[Len(aRecVlr)]} )           
                            Endif
                        Endif   
                    Endif   
                Endif   
            Next nAux           
            aAdd(aCodPedidos, {aAtuSC5[nI], aClone(aPedidos)} )
        Next nI     
    Else
        aRecRet := aClone(aRecnoAdt)
        
        For nI := 1 To Len(aRecRet)
            aAdd(aRecNo,    aRecRet[nI, 2])
            aAdd(aRecVlr,   aRecRet[nI, 3])
        Next nI     
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Carrega o pergunte da rotina de compensação financeira³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Pergunte("FIN330",.F.)

    lContabiliza    := MV_PAR09 == 1
    lDigita         := MV_PAR07 == 1 

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Compensa os valores no Financeiro³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SE1->(MsGoTo(aRegSE1[1]))
    If SE1->(Recno()) = aRegSE1[1] .and. Len(aRecNo) > 0 .and. Len(aRecVlr) > 0
        lRet := MaIntBxCR(3,{aRegSE1[1]},,aRecNo,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.T.},,,,,SE1->E1_VALOR,,aRecVlr)    
    Endif   

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Retorna o pergunte da MATA461                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Pergunte("MT460A",.F.)
    
    If lRet .and. Len(aCodPedidos) > 0
        SE1->(MsGoTo(aRegSE1[1]))
        If SE1->(Recno()) = aRegSE1[1]
            If SE1->E1_VALOR != SE1->E1_SALDO .and. !Empty(SE1->E1_BAIXA) // verifica se o titulo foi baixado
                For nI := 1 To Len(aCodPedidos) 
                     
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³Ajuste do saldo do relacionamento no Financeiro³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         
                    FPedAdtGrv( "R", 4, aCodPedidos[nI, 1], aCodPedidos[nI, 2], lCmp, cDoc, cSerie )
                Next nI      
        
                // grava registro do titulo principal na tabela FR3
                SE1->(MsGoTo(aRegSE1[1]))           
                If SE1->(Recno()) = aRegSE1[1]
                    FaGrvFR3("R",SE1->E1_PEDIDO,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_VALOR,cDoc,cSerie)
                Endif   
            Endif   
        Endif
    Endif       
EndIf         

RestArea(aAreaSE1)
RestArea(aAreaSC5)
RestArea(aAreaSC9)
RestArea(aArea)

Return .T.        


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461NPedido ³ Autor ³Totvs                ³ Data ³09.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe tela para indicar ao usuario que Documento de Saida   ³±±
±±³          ³nao tem adiantamento relacionado.                           º±±
±±³          ³Permite relacionar adiantamentos ao Documento.              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se relacionou adiantamento ao Pedido          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do Pedido de Venda                            ³±±
±±³          ³ExpC2: Codigo de cliente                                    ³±±
±±³          ³ExpC3: Loja do cliente                                      ³±±
±±³          ³ExpN4: Valor do adiantamento relacionado ao Pedido          ³±±
±±³          ³ExpN5: Valor da primeira parcela do titulo a receber        ³±±
±±³          ³ExpC6: Condicao de Pagamento                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A461NPedido(cNumPed, cCliente, cLoja, nValAdt, nValParc1, cCondPagto)

Local aArea := GetArea() 
Local cGetNumero    := cNumPed
Local cGetCliente   := cCliente
Local cGetLoja      := cLoja 
Local cGetNome      := Posicione("SA1", 1, xFilial("SA1")+cCliente+cLoja, "A1_NOME")
Local cGetVlrP1 := Round(nValParc1, 2)
Local cGetVlrAd := Round(nValAdt, 2)
Local cGetVlrSld    := Round(nValParc1 - nValAdt, 2)
Local oGetNumero
Local oGetCliente
Local oGetLoja
Local oGetNome
Local oGetVlrP1
Local oGetVlrAd
Local oGetVlrSld
Local lRet := .T.
Local aRecnoSE1     := FPedAdtPed( "R", {cNumPed}, .F. )
Local oDlg              // Dialog Principal

DEFINE MSDIALOG oDlg TITLE "Deseja selecionar agora o(s) Adiantamento(s)?" FROM A461PosTla(178),A461PosTla(181) TO A461PosTla(321),A461PosTla(597) PIXEL // "Valor do Adiantamento não informado"

    // Cria as Groups do Sistema
    @ A461PosTla(003),A461PosTla(002) TO A461PosTla(060),A461PosTla(155) LABEL "Informações do Pedido" PIXEL OF oDlg // "Informações do Pedido"

    // Cria Componentes Padroes do Sistema
    @ A461PosTla(015),A461PosTla(009) Say "Número" Size A461PosTla(018),A461PosTla(008) COLOR CLR_BLACK PIXEL OF oDlg // "Número"
    @ A461PosTla(015),A461PosTla(050) MsGet oGetNumero Var cGetNumero Size A461PosTla(060),A461PosTla(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
    
    @ A461PosTla(030),A461PosTla(009) Say "Cliente" Size A461PosTla(018),A461PosTla(008) COLOR CLR_BLACK PIXEL OF oDlg // "Cliente"
    @ A461PosTla(030),A461PosTla(050) MsGet oGetCliente Var cGetCliente Size A461PosTla(060),A461PosTla(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
    @ A461PosTla(030),A461PosTla(120) MsGet oGetLoja Var cGetLoja Size A461PosTla(027),A461PosTla(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
    
    @ A461PosTla(045),A461PosTla(009) Say "Nome" Size A461PosTla(018),A461PosTla(008) COLOR CLR_BLACK PIXEL OF oDlg // "Nome"
    @ A461PosTla(045),A461PosTla(050) MsGet oGetNome Var cGetNome Size A461PosTla(097),A461PosTla(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
    
    // Botoes disponiveis na tela
    @ A461PosTla(007),A461PosTla(167) Button "Ignora Pedido" Size A461PosTla(037),A461PosTla(012) PIXEL OF oDlg ACTION (lRet:= .F.,oDlg:End()) // "Ignora Pedido"
    @ A461PosTla(025),A461PosTla(167) Button "Adiantamentos" Size A461PosTla(037),A461PosTla(012) PIXEL OF oDlg ACTION (A410Adiant(cNumPed, cCondPagto, nValParc1, aRecnoSE1, .F., cCliente, cLoja, .T.),oDlg:End())     // "Adiantamentos"

    @ A461PosTla(062),A461PosTla(005) Say "Para alterar o valor do Adiantamento, clique em Adiantamentos." Size A461PosTla(158),A461PosTla(008) COLOR CLR_BLACK PIXEL OF oDlg    // "Para alterar o valor do Adiantamento, clique em Adiantamentos."
ACTIVATE MSDIALOG oDlg CENTERED 

RestArea(aArea)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461PosTla  ³ Autor ³Totvs                ³ Data ³09.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por manter o Layout independente da      ³±±
±±³          ³resolucao horizontal do Monitor do Usuario.                 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Numero da Coordenada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Numero da Coordenada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A461PosTla(nTam)

Local nHRes :=  oMainWnd:nClientWidth   // Resolucao horizontal do monitor     
    If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
        nTam *= 0.8                                                                
    ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600                
        nTam *= 1                                                                  
    Else    // Resolucao 1024x768 e acima                                           
        nTam *= 1.28                                                               
    EndIf                                                                         
                                                                                
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
    //³Tratamento para tema "Flat"³                                               
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
    If "MP8" $ oApp:cVersion                                                      
        If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
            nTam *= 0.90                                                            
        EndIf                                                                      
    EndIf                                                                         

Return Int(nTam)         


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A461NP1Vlr  ³ Autor ³Totvs                ³ Data ³09.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o valor da primeira parcela do pedido.              ³±±
±±³          ³Utiliza Qtde liberada * Preco de venda do item para o cal-  ³±±
±±³          ³culo.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Valor da parcela                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do Pedido de Venda                            ³±±
±±³          ³ExpA2: Array com os itens a serem gerados                   ³±±
±±³          ³ExpA3: Array usado na condicao de pagamento                 ³±±
±±³          ³ExpN4: Valor do acrescimo financeiro                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A461NP1Vlr(cNumPedido, aPvlNfs, aImpVarDup, nAcresTot )

Local aArea := GetArea() 
Local aAreaSC5  := SC5->(GetArea()) 
Local nValor    := 0  
Local nValTot   := 0 
Local cCondPagto:= ""
Local cQ := ""

cQ  := "SELECT R_E_C_N_O_ AS SC9RECNO,C9_QTDLIB,C9_PRCVEN "
cQ += "FROM "+RetSqlName("SC9")+" "
cQ += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
cQ += "AND C9_PEDIDO = '"+cNumPedido+"' "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSC9",.T.,.T.)  

TcSetField("TRBSC9","C9_QTDLIB","N",TamSX3("C9_QTDLIB")[1],TamSX3("C9_QTDLIB")[2])
TcSetField("TRBSC9","C9_PRCVEN","N",TamSX3("C9_PRCVEN")[1],TamSX3("C9_PRCVEN")[2])

While !Eof()
    If aScan(aPvlNfs, {|x| x[8]==TRBSC9->SC9RECNO}) > 0
        nValTot += TRBSC9->C9_QTDLIB * TRBSC9->C9_PRCVEN
    EndIf
    dbSkip()    
Enddo      
TRBSC9->(dbCloseArea())

SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
If SC5->(DbSeek( xFilial("SC5")+cNumPedido ))
    nValTot += SC5->C5_FRETE+SC5->C5_SEGURO+SC5->C5_DESPESA
    cCondPagto  := SC5->C5_CONDPAG
    aVenc := Condicao(nValTot,cCondPagto,0.00,dDataBase,0.00,aImpVarDup,,nAcresTot) 
    If Len(aVenc) > 0
        nValor := aVenc[1,2]
    EndIf       
EndIf

RestArea(aAreaSC5)
RestArea(aArea)

Return(nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a461LstPreºAutor  ³Vendas Cliente      º Data ³  02/17/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria a Nota Fiscal de Remessa e um novo registro na tabela  º±±
±±º          ³de conta corrente da lista de presentes                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA846                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function a461LstPre(aPvlnfs)

/*======================================\
|   Elementos do Array aPvlnfs          |
|---------------------------------------|
|aPvlnfs[01] - Numero do Pedido de Venda|
|aPvlnfs[02] - Item do Pedido de Venda  |
|aPvlnfs[03] - Sequencia de Liberacao   |
|aPvlnfs[04] - Quantidade Liberada      |
|aPvlnfs[05] - Preco de Venda           |
|aPvlnfs[06] - Codigo do Produto        |
|aPvlnfs[07] - TES com ISS              |
|aPvlnfs[08] - Recno do SC9             |
|aPvlnfs[09] - Recno do SC5             |
|aPvlnfs[10] - Recno do SC6             |
|aPvlnfs[11] - Recno do SE4             |
|aPvlnfs[12] - Recno do SB1             |
|aPvlnfs[13] - Recno do SB2             |
|aPvlnfs[14] - Recno do SF4             |
|aPvlnfs[15] - Deposito                 |
|aPvlnfs[16] - Recno do DAK             |
|aPvlnfs[17] - Quantidade Liberada 2 UN |
\======================================*/

Local aArea     := GetArea()                                                                        //Grava a area Atual
Local aAreaSF2  := SF2->( GetArea() )                                                               //Grava a area da tabela SF2
Local aAreaSD2  := SD2->( GetArea() )                                                               //Grava a area da tabela SD2
Local aAreaSA1  := SA1->( GetArea() )                                                               //Grava a area da tabela SA1
Local cChaveSF2 := xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA    //Chave de pesquisa para a tabela SD2
Local aCab      := {}                                                                               //Array de cabecalho do EXECAUTO
Local aItens    := {}                                                                               //Array dos itens do EXECAUTO
Local aItAux    := {}                                                                               //Array auxiliar para os itens do EXECAUTO
Local cLista    := GetAdvFVal("SC6","C6_CODLPRE",xFilial("SC6") + aPvlnfs[1][1] + aPvlnfs[1][2] + aPvlnfs[1][6],1,"")   //Numero da Lista de Presente
Local lRet      := .T.                                                                              //Variavel de retorno da funcao
Local cTES      := ""                                                                               //TES usada no item da NF de Remessa
Local cTpOper   := SuperGetMV("MV_LJLPTIR",,"")                                                     //Tipo da Operacao para a NF de Remessa (TES Inteligente)
Local cTESPad   := SuperGetMV("MV_LJLPTSR",,"")                                                     //TES padrao para a NF de Remessa
Local cSerieNFR := SuperGetMV("MV_LJSENFR",,"")                                                     //TES padrao para a NF de Remessa
Local cTpNrNfs  := SuperGetMV("MV_TPNRNFS")                                                         //Tipo do Numero da Nota Fiscal
Local cNumNFR   := ""                                                                               //Numero da Nota Fiscal de Saida
Local aRegCtaC  := {}                                                                               //Array para criar o registro de Debito na tabela de conta corrente

Private lMsErroAuto := .F.                                                                          //Variavel usada para o retorno da EXECAUTO
Private l920Inclui  := .T.                                                                          //Variavel usada para tratamento do execauto

//Caso o parametro de Tipo de Operacao e TES estejam em branco, retorna como falso na funcao
If Empty(cTpOper) .And. Empty(cTESPad)
    lRet        := .F.
ElseIf !Empty(cLista)   //Caso o codigo da lista de presentes esteja em branco, retorna para a funcionalidade normal
    //Verifico se a variavel esta em branco e nesse caso busco a serie padrao ja selecionada
    cSerieNFR   := IIF(Empty(cSerieNFR),SF2->F2_SERIE,cSerieNFR)

    //Verifico como esta parametrizado o sistema para busca do numero da Nota Fiscal
//  If cTpNrNfs == "3"
        cNumNFR := MA461NumNf(NIL,cSerieNFR,NIL,NIL)
//  ElseIf !Sx5NumNota(@cSerieNFR,cTpNrNfs)
//  EndIf
    DbSelectArea("ME4")
    DbSetOrder(4)   //ME4_FILIAL+ME4_CODIGO+ME4_PEDIDO+ME4_ITPED+ME4_ITLST
    
    DbSelectArea("ME1")
    DbSetOrder(2)   //ME1_FILIAL+ME1_CODIGO+ME1_TIPO+ME1_CODCLI+ME1_LOJCLI
    If ME1->( DbSeek( xFilial("ME1") + cLista) )
        DbSelectArea("SA1")
        DbSetOrder(1)   //A1_FILIAL+A1_COD+A1_LOJA
        DbSeek( xFilial("SA1") + ME1->ME1_CODCLI + ME1->ME1_LOJCLI)
    
        aAdd(aCab,{"F2_TIPO"    ,"N"                            })
        aAdd(aCab,{"F2_FORMUL"  ,"S"                            })
        aAdd(aCab,{"F2_DOC"     ,cNumNFR                        })
        aAdd(aCab,{"F2_SERIE"   ,cSerieNFR                      })
        aAdd(aCab,{"F2_EMISSAO" ,dDataBase                      })
        aAdd(aCab,{"F2_CLIENTE" ,ME1->ME1_CODCLI                })
        aAdd(aCab,{"F2_LOJA"    ,ME1->ME1_LOJCLI                })
        aAdd(aCab,{"F2_TIPOCLI" ,SA1->A1_TIPO                   })
        aAdd(aCab,{"F2_ESPECIE" ,SF2->F2_ESPECIE                })
        aAdd(aCab,{"F2_DESCONT" ,SF2->F2_DESCONT                })
        aAdd(aCab,{"F2_VALBRUT" ,SF2->F2_VALBRUT                })
        aAdd(aCab,{"F2_VALFAT"  ,SF2->F2_VALFAT                 })
        aAdd(aCab,{"F2_FRETE"   ,SF2->F2_FRETE                  })
        aAdd(aCab,{"F2_SEGURO"  ,SF2->F2_SEGURO                 })
        aAdd(aCab,{"F2_DESPESA" ,SF2->F2_DESPESA                })
        aAdd(aCab,{"F2_PREFIXO" ,Space(TamSX3("F2_PREFIXO")[1]) })
        aAdd(aCab,{"F2_HORA"    ,SubStr(Time(),1,5)             })
        aAdd(aCab,{"F2_CLIENT"  ,SF2->F2_CLIENT                 })
        aAdd(aCab,{"F2_LOJENT"  ,SF2->F2_LOJENT                 })
        
        DbSelectArea("SD2")
        DbSetOrder(3)   //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
        While !SD2->( Eof() ) .And. cChaveSF2 == SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA
            aItAux := {} 
            If !Empty(cTpOper)
                cTES := MaTESInt(2,cTpOper,ME1->ME1_CODCLI,ME1->ME1_LOJCLI,"C",SD2->D2_COD)
            Else
                cTES := cTESPad
            EndIf
            
            aAdd(aItAux,{"D2_ITEM"      ,SD2->D2_ITEM   ,Nil})
            aAdd(aItAux,{"D2_COD"       ,SD2->D2_COD    ,Nil})
            aAdd(aItAux,{"D2_QUANT"     ,SD2->D2_QUANT  ,Nil})
            aAdd(aItAux,{"D2_PRCVEN"    ,SD2->D2_PRCVEN ,Nil})
            aAdd(aItAux,{"D2_TOTAL"     ,SD2->D2_TOTAL  ,Nil})
            aAdd(aItAux,{"D2_TES"       ,cTES           ,Nil})
            aAdd(aItAux,{"D2_CODLPRE"   ,SD2->D2_CODLPRE,Nil})
            aAdd(aItAux,{"D2_ITLPRE"    ,SD2->D2_ITLPRE ,Nil})
            aAdd(aItAux,{"D2_PEDIDO"    ,SD2->D2_PEDIDO ,Nil})
            aAdd(aItAux,{"D2_ITEMPV"    ,SD2->D2_ITEMPV ,Nil})
            aAdd(aItens,aItAux)
            
            //Posiciona na tabela de conta corrente para atualizar o status do credito
            If ME4->( DbSeek( xFilial("ME4") + SD2->D2_CODLPRE + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_ITLPRE ) )
                RecLock("ME4",.F.)
                ME4->ME4_TIPREG := "4"
                ME4->( MsUnLock() )
            
                //Alimenta o array com os itens que serao gravados na tabela de Conta Corrente da Lista de Presentes
                aRegCtaC    := {}
                aAdd(aRegCtaC,SD2->D2_CODLPRE)      //01 - Codigo da Lista
                aAdd(aRegCtaC,SD2->D2_ITLPRE)       //02 - Item da Lista
                aAdd(aRegCtaC,SD2->D2_COD)          //03 - Codigo do Produto
                aAdd(aRegCtaC,SD2->D2_QUANT)        //04 - Quantidade
                aAdd(aRegCtaC,SD2->D2_TOTAL)        //05 - Valor
                aAdd(aRegCtaC,cEmpAnt)              //06 - Empresa Original
                aAdd(aRegCtaC,cFilAnt)              //07 - Filial Original
                aAdd(aRegCtaC,Nil)                  //08 - Numero do Orcamento
                aAdd(aRegCtaC,Nil)                  //09 - Item do Orcamento
                aAdd(aRegCtaC,SD2->D2_PEDIDO)       //10 - Numero do Pedido de Venda
                aAdd(aRegCtaC,SD2->D2_ITEMPV)       //11 - Item do Pedido de Venda
                aAdd(aRegCtaC,cNumNFR)              //12 - Numero do Documento
                aAdd(aRegCtaC,cSerieNFR)            //13 - Serie do Documento
                aAdd(aRegCtaC,dDataBase)            //14 - Emissao do documento/titulo
                aAdd(aRegCtaC,NIL)                  //15 - Prefixo do Titulo
                aAdd(aRegCtaC,NIL)                  //16 - Numero do Titulo
                aAdd(aRegCtaC,NIL)                  //17 - Parcela do Titulo
                aAdd(aRegCtaC,NIL)                  //18 - Tipo do Titulo
                aAdd(aRegCtaC,SD2->D2_CLIENTE)      //19 - Codigo do Cliente
                aAdd(aRegCtaC,SD2->D2_LOJA)         //20 - Loja do Cliente
                
                //Chama a rotina para gerar o Debito da conta corrente
                If !Lj8GeraCC(aRegCtaC,3)
                    lRet := .F.
                    RollBackSX8()
                    Exit
                EndIf
            EndIf
            SD2->( dbSkip() )
        End

        If lRet
            MSExecAuto({|x,y,z| Mata920(x,y,z)},aCab,aItens,3) //Inclusao  
    
            If lMsErroAuto
                MostraErro()
                lRet := .F.
            EndIf
        EndIf
    Else
        lRet := .F.
    EndIf
EndIf

RestArea(aArea)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSA1)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaRatDesp ³ Autor ³Alexandre Inacio Lemes ³ Data ³13/09/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao destinada a atender o parametro MV_VALDESP que se    ³±±
±±³          ³igual a .T. deve utilizar o rateio de despesas acessorias   ³±±
±±³          ³FRETE/SEGURO/DESPESA realizado pela MATXFIS sobrepondo o ra ³±±
±±³          ³teio realizado pelo MATA461 atraves da alteracao do array   ³±±
±±³          ³aRateio.Esta funcao altera o array aRateio nestas despesas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPvlNfs : Array com os pedidos de vendas liberados para NFS³±±
±±³          ³ aRateio : Array contendo o Rateio de Despesas do MATA461   ³±±
±±³          ³ lReajuste: Variavel logica indicando Reajuste              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

Static Function MaRatDesp(aPvlNfs,aRateio,lReajuste,dDataMoe)

Local aArea     := GetArea()                                                                        
Local aPvlSD2   := {}
Local nItem     := 0

Default dDataMoe := dDataBase

If Empty(dDataMoe)
    dDataMoe := dDatabase
Endif

For nItem := 1 to Len(aPvlNfs)

    aPvlSD2 := aPvlNfs[nItem]
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Posiciona Registros                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SC9")
    dbSetOrder(1)
    MsGoto(aPvlSd2[8])
    
    dbSelectArea("SC5")
    dbSetOrder(1)
    MsGoto(aPvlSD2[9])
    
    dbSelectArea("SC6")
    dbSetOrder(1)
    MsGoto(aPvlSD2[10])
    
    dbSelectArea("SE4")
    dbSetOrder(1)
    MsGoto(aPvlSd2[11])
    
    dbSelectArea("SB1")
    dbSetOrder(1)
    MsGoto(aPvlSd2[12])
    
    dbSelectArea("SB2")
    dbSetOrder(1)
    MsGoto(aPvlSd2[13])
    
    dbSelectArea("SF4")
    dbSetOrder(1)
    MsGoto(aPvlSd2[14])
    
    dbSelectArea("DAK")
    dbSetOrder(1)
    MsGoto(aPvlSd2[16])

    If nItem == 1
        MaFisIni(SC5->C5_CLIENTE,SC5->C5_LOJACLI,If(SC5->C5_TIPO$'DB',"F","C"),SC5->C5_TIPO,SC5->C5_TIPOCLI,aRelImp,,,,'MATA461',,,,,,,,,,,SC6->C6_NUM)
    EndIf
    
    MaFisIniLoad(nItem,{SC6->C6_PRODUTO,;   //IT_PRODUTO
    SC6->C6_TES,;       //IT_TES
    If(SF4->F4_ISS=="S", SC6->C6_CODISS , " " ) ,;  //IT_CODISS
    aPvlNfs[nItem][4],;  //IT_QUANT
    SC6->C6_NFORI,;      //IT_NFORI
    SC6->C6_SERIORI,;    //IT_SERIORI
    SB1->(RecNo()),;     //IT_RECNOSB1
    SF4->(RecNo()), 0 }) //IT_RECNOSF4
    
    nPosAIss := Ascan(aFisGet, {|x| x[1] == "IT_ALIQISS" })
    If nPosAIss > 0    
        dbSelectArea("SC6")
        nAliqIss := &(aFisGet[nPosAIss][2])
        If nAliqIss == 0
            nAliqIss := MaAliqISS(nItem)
        EndIf
    Else
        nAliqIss := MaAliqISS(nItem)
    Endif   
        
    aRateio[nItem][RT_PRECOIT]  := MaPvPrcIt(aPvlNfs,nItem,lReajuste,aRateio[nItem],0,nAliqIss,dDataMoe)
    
    MaFisLoad("IT_VALMERC",aRateio[nItem][RT_PRECOIT][3]+aRateio[nItem][RT_PRECOIT][4],nItem)
    MaFisLoad("IT_PRCUNI",aRateio[nItem][RT_PRECOIT][1],nItem)
    MaFisLoad("IT_VLR_FRT",aRateio[nItem][RT_VLR_FRT],nItem)
    MaFisLoad("IT_AUTONOMO",aRateio[nItem][RT_FRETAUT],nItem)
    MaFisLoad("IT_DESCONTO",aRateio[nItem][RT_PRECOIT][4],nItem)
    MaFisLoad("IT_PESO",SB1->B1_PESO,nItem)
    
    MaFisRecal("",nItem)
    
    MaFisEndLoad(nItem,2)
    
Next nItem

MaFisAlt("NF_FRETE"  , SC5->C5_FRETE  )  
MaFisAlt("NF_SEGURO" , SC5->C5_SEGURO )  
MaFisAlt("NF_DESPESA", SC5->C5_DESPESA)  

For nItem := 1 to Len(aPvlNfs)
    aRateio[nItem][RT_FRETE]  := MaFisRet(nItem,"IT_FRETE")  
    aRateio[nItem][RT_SEGURO] := MaFisRet(nItem,"IT_SEGURO") 
    aRateio[nItem][RT_DESPESA]:= MaFisRet(nItem,"IT_DESPESA") 
Next nItem

MaFisEnd()

RestArea(aArea)

Return

//-------------------------------------
/*  Modelo de Dados
@author     Jefferson Tomaz
@version    P10 R1.4
@build      7.00.101202A
@since      06/04/2011
@return         oModel Objeto do Modelo*/
//-------------------------------------
Static Function ModelDef()                              
Local oModel
Local oStruSF2  := FWFormStruct(1,"SF2")
Local oStruSD2  := FWFormStruct(1,"SD2")
Local oStruRSA1 := NIL
Local oStruCSA1 := NIL
Local oStruDSA1 := NIL
Local oStruRSA4 := NIL
Local aSM0      := FWArrFilAtu()
Local lIntGFE   := SuperGetMv('MV_INTGFE',,.F.)
Local aAux      := {}
Local aRet      := {}
Local nI        := 0
Local cFieldRel := ''
Local aRelatUsr := {}

SM0->(DbGoto(aSM0[SM0_RECNO]))          

If lIntGFE
    oStruSD2:aTriggers := {}
    
    oStruRSA1 := FWFormStruct(1,"SA1",{|cCampo| AllTrim(cCampo)+"|" $ "A1_COD|A1_LOJA|A1_NREDUZ|A1_CGC|A1_END|A1_BAIRRO|A1_MUN|A1_EST|A1_COD_MUN|A1_CEP|"})
    oStruCSA1 := FWFormStruct(1,"SA1",{|cCampo| AllTrim(cCampo)+"|" $ "A1_COD|A1_LOJA|A1_NREDUZ|A1_CGC|"})
    oStruRSA4 := FWFormStruct(1,"SA4",{|cCampo| AllTrim(cCampo)+"|" $ "A4_COD|A4_CGC|A4_EST|A4_COD_MUN|"})
    oStruDSA1 := FWFormStruct(1,"SA1",{|cCampo| AllTrim(cCampo)+"|" $ "A1_COD|A1_LOJA|A1_NREDUZ|A1_CGC|A1_END|A1_BAIRRO|A1_MUN|A1_EST|A1_COD_MUN|A1_CEP|A1_ENDENT|A1_BAIRROE|A1_CEPE|A1_MUNE|A1_ESTE|A1_CODMUNE"})
    oStruCSA2 := FWFormStruct(1,"SA2",{|cCampo| AllTrim(cCampo)+"|" $ "A2_COD|A2_LOJA|A2_NREDUZ|A2_CGC|"})
    oStruDSA2 := FWFormStruct(1,"SA2",{|cCampo| AllTrim(cCampo)+"|" $ "A2_COD|A2_LOJA|A2_NREDUZ|A2_CGC|A2_END|A2_BAIRRO|A2_MUN|A2_EST|A2_COD_MUN|A2_CEP|"})

// ------------- Campos Virtuais para Tabela SF2 ------------------

    oStruSF2:AddField( ;                      // Ord. Tipo Desc.
    "F2_CDTPDC"                      , ;      // [01]  C   Titulo do campo
    "Cod.Tp.Doc"                     , ;      // [02]  C   ToolTip do campo
    "F2_CDTPDC"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    55                               , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("SX5",1,xFilial("SX5")+"MQ"+AllTrim(SF2->F2_TIPO)+"S","X5_DESCRI")'), ; //[11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "F2_TIPO", ;                                                      // [01] Id do campo de origem
    "F2_CDTPDC" , ;                                                   // [02] Id do campo de destino
    'Posicione("SX5",1,xFilial("SX5")+"MQ"+AllTrim(M->F2_TIPO)+"S","X5_DESCRI")')
    
    
    oStruSF2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho
    
    
    oStruSF2:AddField( ;                      // Ord. Tipo Desc.
    "F2_CDCLF"                       , ;      // [01]  C   Titulo do campo
    "Class.frete"                    , ;      // [02]  C   ToolTip do campo
    "F2_CDCLFR"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    5                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    NIL                              , ;      // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    NIL                              )        // [14]  L   Indica se o campo é virtual
    
    oStruSF2:AddField( ;                      // Ord. Tipo Desc.
    "CGC Transp"                     , ;      // [01]  C   Titulo do campo
    "CGC Transp"                     , ;      // [02]  C   ToolTip do campo
    "F2_CGCTRP"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    14                               , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_CGC")' ), ;      // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "F2_TRANSP", ;                                                      // [01] Id do campo de origem
    "F2_CCGCTRP" , ;                                                   // [02] Id do campo de destino
    'Posicione("SA4",1,xFilial("SA4")+M->F2_TRANSP,"A4_CGC")')
    
    oStruSF2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

    oStruSF2:AddField( ;                      // Ord. Tipo Desc.
    "CGC Redesp"                     , ;      // [01]  C   Titulo do campo
    "CGC Redesp"                     , ;      // [02]  C   ToolTip do campo
    "F2_CGCRDP"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    14                               , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CGC")' ), ;      // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "F2_REDESP", ;                                                      // [01] Id do campo de origem
    "F2_CCGCRDP" , ;                                                   // [02] Id do campo de destino
    'Posicione("SA4",1,xFilial("SA4")+M->F2_REDESP,"A4_CGC")')
    
    oStruSF2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

// ------------- Campos Virtuais para Tabela SD2 ------------------
    oStruSD2:AddField( ;                      // Ord. Tipo Desc.
    "Desc.Prod."                     , ;      // [01]  C   Titulo do campo
    "Desc.Prod."                     , ;      // [02]  C   ToolTip do campo
    "D2_DESCRI"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    TamSx3("B1_DESC")[1]             , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'SubStr(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC"),1,50)'), ;    // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual
    
    
    aAux := FwStruTrigger(;
    "D2_COD", ;                                                      // [01] Id do campo de origem
    "D2_DESCRI" , ;                                                   // [02] Id do campo de destino
    'SubStr(Posicione("SB1",1,xFilial("SB1")+FwFldGet("D2_COD"),"B1_DESC"),1,50)' )

    oStruSD2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

    oStruSD2:AddField( ;                      // Ord. Tipo Desc.
    "Peso Bruto"                     , ;      // [01]  C   Titulo do campo
    "Peso Bruto"                     , ;      // [02]  C   ToolTip do campo
    "D2_PBRUTO"                      , ;      // [03]  C   Id do Field
    'N'                              , ;      // [04]  C   Tipo do campo
    11                               , ;      // [05]  N   Tamanho do campo
    4                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'If(FindFunction("OmRtPesoIt"),OmRtPesoIt(SD2->D2_COD,SD2->D2_QUANT),(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_PESBRU")) * SD2->D2_QUANT )'), ;      // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "D2_QUANT", ;                                                      // [01] Id do campo de origem
    "D2_PBRUTO" , ;                                                   // [02] Id do campo de destino
    'If(FindFunction("OmRtPesoIt"),OmRtPesoIt(FwFldGet("D2_COD"),SD2->D2_QUANT),Posicione("SB1",1,xFilial("SB1")+FwFldGet("D2_COD"),"B1_PESBRU") * M->D2_QUANT)' )

    oStruSD2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

    oStruSD2:AddField( ;                      // Ord. Tipo Desc.
    "M3"                             , ;      // [01]  C   Titulo do campo
    "M3"                             , ;      // [02]  C   ToolTip do campo
    "D2_METRO3"                      , ;      // [03]  C   Id do Field
    'N'                              , ;      // [04]  C   Tipo do campo
    11                               , ;      // [05]  N   Tamanho do campo
    4                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório                                                                                                 
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'(Posicione("SB5",1,xFilial("SB5")+ (SD2->D2_COD),"B5_ALTURA")* SB5->B5_LARG * SB5->B5_COMPR)* (SD2->D2_QUANT) '), ;    // [11]  B   Code-block de inicializacao do campo, ;*/
    NIL                              , ;          // [12]  L   Indica se trata-se de um campo chave                                       
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual
    
    aAux := FwStruTrigger(;
    "D2_QUANT"  , ;                                                   // [01] Id do campo de origem
    "D2_METRO3" , ;                                                   // [02] Id do campo de destino
    "(SB5->(B5_ALTURA * B5_LARG * B5_COMPR)) * M->D2_QUANT",;
    .T.,;
    "SB5",;
    1,;
    "xFilial('SB5')+FwFldGet('D2_COD')",;
    "SB5->(FOUND())" )
  
    oStruSD2:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4])                                                        // [04] Bloco de codigo de execução do gatilho  
        
// ------------- Campos Virtuais para Tabela SA1 ------------------
    oStruRSA1:AddField( ;                    // Ord. Tipo Desc.
    "IBGE Compl"                     , ;      // [01]  C   Titulo do campo
    "Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
    "A1_CDIBGE"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_EST, "1") + SA1->A1_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual


    aAux := FwStruTrigger(;
    "A1_COD_MUN", ;                                                      // [01] Id do campo de origem
    "A1_CDIBGE" , ;                                                      // [02] Id do campo de destino
    'TMS120CdUf(M->A1_EST, "1") + M->A1_COD_MUN' )                                                      

    oStruRSA1:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho
                         
    oStruRSA1:AddField( ;                    // Ord. Tipo Desc.
    "IBGEE Compl"                    , ;      // [01]  C   Titulo do campo
    "Cod.IBGEE Compl "               , ;      // [02]  C   ToolTip do campo
    "A1_CDIBGEE"                     , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_ESTE, "1") + SA1->A1_CODMUNE' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual


    aAux := FwStruTrigger(;
    "A1_CODMUNE", ;                                                      // [01] Id do campo de origem
    "A1_CDIBGEE", ;                                                      // [02] Id do campo de destino
    'TMS120CdUf(M->A1_ESTE, "1") + M->A1_CODMUNE' )                                                      

    oStruRSA1:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho



    oStruDSA1:AddField( ;                    // Ord. Tipo Desc.
    "IBGE Compl"                     , ;      // [01]  C   Titulo do campo
    "Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
    "A1_CDIBGE"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_EST, "1") + SA1->A1_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "A1_COD_MUN", ;                                                      // [01] Id do campo de origem
    "A1_CDIBGE" , ;                                                      // [02] Id do campo de destino
    'TMS120CdUf(M->A1_EST, "1") + M->A1_COD_MUN' )                                                      

    oStruDSA1:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

    oStruDSA1:AddField( ;                    // Ord. Tipo Desc.
    "IBGEE Compl"                    , ;      // [01]  C   Titulo do campo
    "Cod.IBGEE Compl "               , ;      // [02]  C   ToolTip do campo
    "A1_CDIBGEE"                     , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_ESTE, "1") + SA1->A1_CODMUNE' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "A1_CODMUNE", ;                                                     // [01] Id do campo de origem
    "A1_CDIBGEE" , ;                                                     // [02] Id do campo de destino
    'TMS120CdUf(M->A1_ESTE, "1") + M->A1_CODMUNE' )                                                      

    oStruDSA1:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

// ------------- Campos Virtuais para Tabela SA2 ------------------
                        
    oStruDSA2:AddField( ;                    // Ord. Tipo Desc.
    "IBGE Compl"                     , ;      // [01]  C   Titulo do campo
    "Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
    "A2_CDIBGE"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA2->A2_EST, "1") + SA2->A2_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "A2_COD_MUN", ;                                                      // [01] Id do campo de origem
    "A2_CDIBGE" , ;                                                      // [02] Id do campo de destino
    'TMS120CdUf(M->A2_EST, "1") + M->A2_COD_MUN' )                                                      

    oStruDSA1:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                                                
    
// ------------- Campos Virtuais para Tabela SA4 ------------------

    oStruRSA4:AddField( ;                    // Ord. Tipo Desc.
    "IBGE Compl"                     , ;      // [01]  C   Titulo do campo
    "Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
    "A4_CDIBGE"                      , ;      // [03]  C   Id do Field
    'C'                              , ;      // [04]  C   Tipo do campo
    7                                , ;      // [05]  N   Tamanho do campo
    0                                , ;      // [06]  N   Decimal do campo
    NIL                              , ;      // [07]  B   Code-block de validação do campo
    NIL                              , ;      // [08]  B   Code-block de validação When do campo
    NIL                              , ;      // [09]  A   Lista de valores permitido do campo
    NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA4->A4_EST, "1") + SA4->A4_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
    NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
    NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual

    aAux := FwStruTrigger(;
    "A4_COD_MUN", ;                                                      // [01] Id do campo de origem
    "A4_CDIBGE" , ;                                                      // [02] Id do campo de destino
    'TMS120CdUf(M->A4_EST, "1") + M->A4_COD_MUN' )                                                      

    oStruRSA4:AddTrigger( ;
    aAux[1], ;                                                      // [01] Id do campo de origem
    aAux[2], ;                                                      // [02] Id do campo de destino
    aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho
    
// ------------- Retira as validaçoes dos campos ------------------
    oStruSF2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruSF2:SetProperty( '*', MODEL_FIELD_WHEN,  NIL ) 
    
    oStruSD2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruSD2:SetProperty( '*', MODEL_FIELD_WHEN,  NIL ) 
    
    oStruRSA1:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruRSA1:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )   

    oStruCSA1:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruCSA1:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )   
        
    oStruDSA1:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruDSA1:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )   
    
    oStruCSA2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruCSA2:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )   
        
    oStruDSA2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruDSA2:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )  
    
    oStruRSA4:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
    oStruRSA4:SetProperty( '*', MODEL_FIELD_WHEN,  NIL )   
EndIf   

oModel:= MPFormModel():New("MATA461",  /*bPre*/, /*bPost*/, Nil /*bCommit*/, /*bCancel*/)

oModel:AddFields("MATA461_SF2", ,oStruSF2,/*bPre*/,/*bPost*/,/*bLoad*/) 
oModel:SetPrimaryKey({"F2_FILIAL", "F2_DOC", "F2_SERIE", "F2_CLIENTE", "F2_LOJA" })

oModel:AddGrid("MATA461_SD2","MATA461_SF2",oStruSD2,/*bLinePre*/, ,/*bPre*/,/*bPost*/,/*bLoad*/)
oModel:SetRelation("MATA461_SD2",{{"D2_FILIAL",'xFilial("SF2")'},{"D2_DOC","F2_DOC"},{"D2_SERIE","F2_SERIE"},;
                                  {"D2_CLIENTE","F2_CLIENTE"},{"D2_LOJA","F2_LOJA"}},"D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA")
oModel:GetModel("MATA461_SD2"):SetDelAllLine(.T.)

If lIntGFE
    oModel:AddFields("REMETENTE_SA1","MATA461_SF2",oStruRSA1,/*bPre*/,/*bPost*/,/*bLoad*/)
    oModel:SetRelation("REMETENTE_SA1",{{"A1_FILIAL",'xFilial("SA1")'},{"A1_CGC","SM0->M0_CGC"}},"A1_FILIAL+A1_CGC")

    oModel:AddFields("CLIENTE_SA1","MATA461_SF2",oStruCSA1,/*bPre*/,/*bPost*/,/*bLoad*/)                               
    oModel:SetRelation("CLIENTE_SA1",{{"A1_FILIAL",'xFilial("SA1")'},{"A1_COD","F2_CLIENTE"},{"A1_LOJA","F2_LOJA"}};
                                  ,"A1_FILIAL+A1_COD+A1_LOJA")                                  

    oModel:AddFields("DESTINATARIO_SA1","MATA461_SF2",oStruDSA1,/*bPre*/,/*bPost*/,/*bLoad*/)                               
    oModel:SetRelation("DESTINATARIO_SA1",{{"A1_FILIAL",'xFilial("SA1")'},{"A1_COD","F2_CLIENT"},{"A1_LOJA","F2_LOJENT"}};
                                  ,"A1_FILIAL+A1_COD+A1_LOJA") 
                                  
    oModel:AddFields("CLIENTE_SA2","MATA461_SF2",oStruCSA2,/*bPre*/,/*bPost*/,/*bLoad*/)                               
    oModel:SetRelation("CLIENTE_SA2",{{"A2_FILIAL",'xFilial("SA2")'},{"A2_COD","F2_CLIENTE"},{"A2_LOJA","F2_LOJA"}};
                                  ,"A2_FILIAL+A2_COD+A2_LOJA")                                  
    oModel:AddFields("DESTINATARIO_SA2","MATA461_SF2",oStruDSA2,/*bPre*/,/*bPost*/,/*bLoad*/)                               
    oModel:SetRelation("DESTINATARIO_SA2",{{"A2_FILIAL",'xFilial("SA2")'},{"A2_COD","F2_CLIENT"},{"A2_LOJA","F2_LOJENT"}};
                                  ,"A2_FILIAL+A2_COD+A2_LOJA") 
                                                                                                     
    oModel:AddFields("REDESPACHO_SA4","MATA461_SF2",oStruRSA4,/*bPre*/,/*bPost*/,/*bLoad*/)                               
    oModel:SetRelation("REDESPACHO_SA4",{{"A4_FILIAL",'xFilial("SA4")'},{"A4_COD","F2_REDESP"}},"A4_FILIAL+A4_COD")
EndIf                                  
                                 
If ExistBlock('MA461Mdl')
    aRet := ExecBlock('MA461Mdl',.F.,.F.)
    If ValType(aRet) == 'A'
        aRelatUsr := AClone(aRet)
    EndIf
    If !Empty(aRelatUsr)
        For nI := 1 To Len(aRelatUsr)
            cFieldRel := 'FIELDREL_'+Alltrim(Str(nI+1))
            oModel:AddFields(cFieldRel,"MATA461_SF2",aRelatUsr[nI,1],/*bPre*/,/*bPost*/,/*bLoad*/)                               
            oModel:SetRelation(cFieldRel,AClone(aRelatUsr[nI,3]),aRelatUsr[nI,2])
        Next nI
    EndIf           
EndIf   
//oModel:SetDescription( OemToAnsi(STR0005))
oModel:SetDescription( 'NF SAIDA')

Return oModel

/*
+------------+-------------+-------+-------------------------+------+---------------+
| Programa:  | xSX5NumNota | Autor | Silverio Bastos - Anadi | Data | Novembro/2014 |
+------------+-------------+-------+-------------------------+------+---------------+
| Descrição: | Verifica qual a serie de Nota a ser considerada automaticamente pelo |
|            | parametro MV__SERINF                                                 |
+------------+----------------------------------------------------------------------+
|Parametro   |ExpC1: cSerie                                                         |
|            |ExpC2: Tipo de Numeracao utilizada                                    |
|            |       [1] Numeracao controla pelo SX5                                |
|            |       [2] Numeracao controla pelo SXE/SXF                            |
|            |       [3] Numeracao controla pelo SD9                                |
|            |ExpC3: Filial a ser apresentada na tela                               |
+------------+----------------------------------------------------------------------+
| Uso:       | Isapa                                                                |
+------------+----------------------------------------------------------------------+
*/

User Function xSx5NumNota(cSerNF,cTpNrNfs,cFilTela,cTab,cAliTp)

Local nVezes    := 0
Local nTamNota  := Len(SF2->F2_DOC)
Local lContinua := .T.
Local lLockSX5  := .T.
Local lSx5Nota  := ExistBlock("SX5NOTA")
Local nTimeOut  := GetNewPar("MV_NOTAOUT",20)*1000
Local nOpcA     := 0
Local aSerNF    := {}
Local aSerNFAnt := {}
Local cNumNF    := ""
Local oDlg
Local oQual
Local oTimer
Local oBmp
Local oBold 
Local cCadastro := OemToAnsi("Notas") //"Notas"
Local cFilSx5       := xFilial("SX5")
Local lValRPS   := ExistBlock("MTVALRPS")
Local nSizeFil  := 2
LOCAL cFilEF    := ""

// Verifica permissao para alterar numero da nota (utilizado apenas para MV_ESTADO = SC)
Local lCanChange  := SuperGetMv("MV_MUDANUM",,.F.)

DEFAULT cTpNrNfs := "1"
DEFAULT cFilTela := cFilAnt                      
DEFAULT cTab     := "01"                                
DEFAULT cAliTp   := 'NFF'

// Verifica se arquivo criado no meio da versao 710 existe
If cTpNrNfs == "3" 
    SX3->(dbSetOrder(1))
    If !(SX3->(dbSeek("SD9")))
        cTpNrNfs := "1"
    EndIf
EndIf
lLockSX5 := IIf(cTpNrNFS == "1",lLockSX5,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trava o parametro do SX6 por seguranca                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( GetMv("MV_NUMITEN",.T.) )
    
    While ( lContinua .And. !SX6->(MsRLock()) )
        Inkey(1)
        nVezes++
        If ( nVezes > 200 )
            lContinua := .F.
        EndIf
    EndDo
Else
    lContinua := .F.
EndIf

//-- Atualiza o conteúdo da filial
If FindFunction("FWSizeFilial")
    nSizeFil := FWSizeFilial()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Defini filial do xe xf                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If PadR(cSerNF,3) == "PLS"
    cFilEF := PadR(xFilial("SE1")+X2PATH("SE1"),45+nSizeFil)
Else
    cFilEF := PadR(xFilial("SF2")+X2PATH("SF2"),45+nSizeFil)
EndIf   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as series de notas fiscais validas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
    DbSelectArea("SX5")
    dbSetOrder(1)
    MsSeek(cFilSX5+cTab,.F.)
    
    While ( SX5->X5_FILIAL == cFilSX5 .And. ;
            SX5->X5_TABELA == cTab .And. lContinua )
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Se a S‚rie for CPF, n„o mostra no aChoice, pois ‚ utilizada ³
        //³ internamente para emissao de Cupom Fiscal.             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If (  AllTrim(SX5->X5_CHAVE)!="CPF".And.AllTrim(SX5->X5_CHAVE)!="CP")
            nVezes := 0
            While ( IIf(lLockSX5,!SX5->(MsRLock()),.F.) .And. lContinua )
                nVezes ++
                If ( nVezes > 20 )
                    aSerNF   := {}
                    lContinua := .F.
                EndIf
            EndDo
            If lContinua
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Quando a Numeracao eh controlado pelo SXE/SXF                           ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If cTpNrNFS == "2"
                    cNumNF := GetSX8Num(cAliTp,,PadR(SX5->X5_CHAVE,3)+cFilEF)
                    // Mantem nota com tamanho 6, se alterado pelo usuario. Para retornar ao tamanho 9 e necessario
                    // alterar a tabelas SXE/SXF.
                    If cPaisloc == "BRA" .And. Len(AllTrim(cNumNF)) < Len(SF2->F2_DOC)
                        nTamNota := 6
                    Else
                        nTamNota  := Len(SF2->F2_DOC)
                    EndIf
                    RollBackSx8()
                    AADD( aSerNF,{PadR(SX5->X5_CHAVE,3),StrZero(Val(cNumNF),nTamNota)})
                Else
                    // Mantem nota com tamanho 6, se alterado pelo usuario. Para retornar ao tamanho 9 e necessario
                    // alterar a tabela "01" pelo configurador.
                    If cPaisloc == "BRA" .And. Len(AllTrim(SX5->X5_DESCRI)) < Len(SF2->F2_DOC)
                        nTamNota := 6
                    Else
                        nTamNota  := Len(SF2->F2_DOC)
                    EndIf
                    AADD( aSerNF,{PadR(SX5->X5_CHAVE,3), MaConvNNota(X5Descri(),nTamNota)})
                EndIf
                If ( lSx5Nota )
                    If ( !ExecBlock("SX5NOTA",.F.,.F.) )
                        aSize(aSerNF,Len(aSerNF)-1)
                    EndIf
                EndIf
            EndIf
        EndIf
        dbSelectArea("SX5")
        dbSkip()
    EndDo
EndIf

//Traz a serie referente ao Parametro da Filial XYZ - Ex: MV__SERINF = '1'
cSerNF := GETMV("MV__SERINF")
dbSelectArea("SX5")
dbSetOrder(1)
If ( MsSeek(cFilSX5+cTab+cSerNF) )
    cNumNF := SX5->X5_DESCRI
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para validar a serie escolhida com a emissao de RPS³
//³referente a Nota Fiscal Eletronica de ISS de Sao Paulo              ³
//³SC9 posicionado e serie escolhida passada por parametro             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua .And. lValRPS 
    lContinua := Execblock("MTVALRPS",.F.,.F.,{cSerNF}) 
Endif            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trava o registro escolhido                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
    If cTpNrNFS == "1"
        dbSelectArea("SX5")
        dbSetOrder(1)
        If ( MsSeek(cFilSX5+cTab+cSerNF) )
            nVezes := 0
            While ( !SX5->(MsRLock()) )
                nVezes ++
                If ( nVezes > 10 )
                    Help(" ",1,"A460FLOCK")
                    lContinua := .F.
                    Exit
                EndIf
                Sleep(100)
            EndDo
            If ( lContinua )
                SX5->X5_DESCRI  := cNumNF
                SX5->X5_DESCSPA := cNumNF
                SX5->X5_DESCENG := cNumNF
            EndIf
        EndIf
    ElseIf cTpNrNFS == "2"
        __cSX5NUM := cNumNF
        
        cNumNF := GetSX8Num(cAliTp,,PadR(cSerNF,3)+cFilEF)
        
        RollBackSX8()
        If __cSX5NUM == cNumNF
            __cSX5NUM := Nil 
        Else
             cNumNF := __cSX5NUM    
        EndIf
    EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Destrava os registro do SX5                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX5->(MsRUnLock())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Destrava o parametro                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( GetMv("MV_NUMITEN",.T.) )
    SX6->(MsRUnLock())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Compatibilizacao com versoes antigas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSerie  := cSerNF
cNumero := cNumNF
// Verifica se o usuario alterou o numero da nota em MV_TPNRNFS == "3" ou "2" (sistema deve respeitar o novo numero)
If nOpcA <> 0 .And. cNumero <> aSerNFAnt[nOpcA][2] .And. (cTpNrNfs == "3" .Or. cTpNrNfs == "2")
    lMudouNum := .T.
EndIf
Return(lContinua)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MaConvNNota³ Autor ³ Sergio Silveira     ³ Data ³ 10/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Preenche o numero da nota fiscal com zeros a esquerda      ³±±
±±³          ³ mesmo quando o conteudo for alfanumerico                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := MaConvNNota(ExpC1)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Simbolo da Moeda                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 := N£mero da Moeda                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MaConvNNota(cX5Descri,nTamNota) 
      
Local cNumNota   := ""
Local cParcNum   := "" 
DEFAULT nTamNota := Len( SF2->F2_DOC )

If MaAllNum( AllTrim( cX5Descri ) )
    cNumNota := StrZero( Val( cX5Descri ),nTamNota,0 )                  
Else
    cParcNum := AllTrim( cX5Descri ) 
    cNumNota := Replicate( "0",nTamNota - Len( cParcNum ) ) + cParcNum 
EndIf 

Return( cNumNota ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MaAllNum   ³ Autor ³ Sergio Silveira     ³ Data ³ 10/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Indica se uma string e formada apenas por numeros          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := MaAllNum(ExpC1)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := String                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 := Retorno                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MaAllNum(cString) 

Local lRet  := .T. 
Local nLoop := 0 

For nLoop := 1 To Len( cString ) 
    If !IsDigit( SubStr( cString, nLoop, 1 ) ) 
        lRet := .F. 
        Exit    
    EndIf       
Next nLoop  

Return(lRet)                                 

/*
+------------+---------+-------+----------------------------------+------+---------------+
| Programa:  | IFATA26A| Autor | Silverio Bastos - Anadi          | Data | Novembro/2014 |
+------------+---------+-------+----------------------------------+------+---------------+
| Descrição: | Rotina auxiliar para montar a estrutura do Markbrowse                     |
+------------+---------------------------------------------------------------------------+
| Uso:       | Isapa                                                                     |
+------------+---------------------------------------------------------------------------+
*/

Static Function IFATA26A()

Local __aArea := GetArea()
Local lInverte := .f.
Local aObjeto       := {}
Local aTamAut       := MsAdvSize()
Local aPosObj       := {}      
Private _aCpo := {}, _oDlgx := Nil
                                                           
AAdd( aObjeto, { 100, 100, .T., .T. } )
aInfo := { aTamAut[ 1 ], aTamAut[ 2 ], aTamAut[ 3 ], aTamAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjeto, .f. ) 
aPosEnch := {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]-60}

cMarca := GetMark()

AADD(_aCpo,{"MARKOK"    ,   ""  ,   ""               ,  "  "    ,   ""  })
AADD(_aCpo,{"FILIAL"    ,   ""  ,   "Filial"         ,  "@!"            })
AADD(_aCpo,{"PEDCALL"   ,   ""  ,   "Ped. C.Center"  ,  "@!"            })
AADD(_aCpo,{"PEDIDO"    ,   ""  ,   "Pedido"         ,  "@!"            })
AADD(_aCpo,{"CLIENTE"   ,   ""  ,   "Cliente"        ,  "@!"            })
AADD(_aCpo,{"NOME"      ,   ""  ,   "R.Social"       ,  "@!"            })
AADD(_aCpo,{"LOJA"      ,   ""  ,   "Loja"           ,  "@!"            })
AADD(_aCpo,{"QTDEITENS" ,   ""  ,   "Qtde.Itens"     ,  "999"           })
AADD(_aCpo,{"DTEMISSAO" ,   ""  ,   "Dt.Emissão"     ,  ""              })

Define MsDialog _oDlgx Title "Preparação Documentos Fiscais" From aTamAut[7],0 to aTamAut[6],aTamAut[5] of oMainWnd PIXEL
//Define MsDialog _oDlgx Title "Preparação Documentos Fiscais" From 10,100 To 420,860 Pixel
oMark := MsSelect():New(_cTemp,"MARKOK",,@_aCpo,@lInverte,cMarca,aPosEnch,,,_oDlgx)
oMark:oBrowse:lCanAllMark   := .T.
oMark:oBrowse:bAllMark      := {|| MrkAll() }

//Define SButton Object oBtn1 From 04,aPosObj[1,4]-30 Type 1 Enable Of _oDlgx Action (IFATA26B(_cTemp),Close(_oDlgx))
//Define SButton Object oBtn2 From 36,aPosObj[1,4]-30 Type 2 Enable Of _oDlgx Action (Close(_oDlgx))

@04,aPosObj[1,4]-40 BUTTON "Peso/Volume" SIZE 35,12 ACTION {|| U_IFATA28((_cTemp)->FILIAL,(_cTemp)->PEDIDO)}  OF _oDlgx PIXEL
@20,aPosObj[1,4]-40 BUTTON "Confirmar"   SIZE 35,12 ACTION {|| IFATA26B(_cTemp),Close(_oDlgx)}                OF _oDlgx PIXEL
@36,aPosObj[1,4]-40 BUTTON "Fechar"      SIZE 35,12 ACTION {|| Close(_oDlgx)}                                 OF _oDlgx PIXEL

DbSelectArea(_cTemp)
DbGoTop()

Activate MsDialog _oDlgx Centered

RestArea(__aArea)

Return 

/*
+------------+---------+-------+-------------------------+------+----------------+
| Programa:  | MrkAll  | Autor | Rubens Cruz - Anadi     | Data | Fevereiro/2015 |
+------------+---------+-------+-------------------------+------+----------------+
| Descrição: | Marca/Desmarca todas as opções do MarkBrowse                      |
+------------+-------------------------------------------------------------------+
| Uso:       | Isapa                                                             |
+------------+-------------------------------------------------------------------+
*/

Static Function MrkAll()
Local _cMarca   := ""

DbSelectArea(_ctemp)   
DbGoTop()

If( Empty((_ctemp)->MARKOK) )
    _cMarca := cMarca
Else
    _cMarca := ""
EndIf

While !(eof())
    RecLock(_ctemp,.F.)
        (_ctemp)->MARKOK := _cMarca
    MsUnlock()
    DbSkip()
EndDo       

DbGoTop()

Return       


/*
+------------+---------+-------+-------------------------+------+---------------+
| Programa:  | IFATA26B| Autor | Silverio Bastos - Anadi | Data | Novembro/2014 |
+------------+---------+-------+-------------------------+------+---------------+
| Descrição: | Filtra a tabela SC9                                              |
+------------+------------------------------------------------------------------+
| Uso:       | Isapa                                                            |
+------------+------------------------------------------------------------------+
*/

Static Function IFATA26B()          
Local __lExec := .F., _cSC9 := _cTexto := "", _cTb9 := GetNextAlias(), _lQIt := .t.

DbSelectArea(_cTemp)
DbGoTop()

While !Eof()
	//_lQIt := .t.
	
    //Se for pedido do call center, mata a reserva da Z10 caso ainda exista
    DbSelectArea("SC5")
    DbSetOrder(1)
    If DbSeek(xFilial("SC5") + (_cTemp)->PEDIDO) .And. !Empty(SC5->C5__NUMSUA)
        DbSelectArea("SUA")
        DbSetOrder(1)
        If DbSeek(xFilial("SUA") + SC5->C5__NUMSUA)
            U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,"","","",0,"E")
        EndIf
    EndIf
    
    _cTexto := ""
    DbSelectArea(_cTemp)
    If (_cTemp)->MARKOK != cMarca
        dbSkip()
        Loop
    Else
    	//Validações de integridade entre SUB x SC6 x SC9
    	//Jorge H - Anadi - Junho/2015		
		If GetMv("MV__VLDSC9")
			MsAguarde({|| _lQIt := IFATA26CMP("ITEM",(_cTemp)->PEDIDO,(_cTemp)->PEDCALL)},"Processando...","Validando numero de itens...",.t.)
			If !_lQIt
	            DbSelectArea(_cTemp)
	            Reclock(_cTemp,.f.)
	            (_cTemp)->MARKOK := " "
	            MsUnlock()
	            
	            DbSkip()
	            Loop
			EndIf
			
			MsAguarde({|| _lQIt := IFATA26CMP("QTD",(_cTemp)->PEDIDO,(_cTemp)->PEDCALL)},"Processando...","Validando as quantidades dos produtos...",.t.)
			If !_lQIt
	            DbSelectArea(_cTemp)
	            Reclock(_cTemp,.f.)
	            (_cTemp)->MARKOK := " "
	            MsUnlock()
	            
	            DbSkip()
	            Loop
			EndIf		
			
			MsAguarde({|| _lQIt := IFATA26CMP("WMS",(_cTemp)->PEDIDO,(_cTemp)->PEDCALL)},"Processando...","Validando as quantidades separadas no WMS...",.t.)
			If !_lQIt
	            DbSelectArea(_cTemp)
	            Reclock(_cTemp,.f.)
	            (_cTemp)->MARKOK := " "
	            MsUnlock()
	            
	            DbSkip()
	            Loop
			EndIf
		EndIf
        
        //Avalia Estoque Real das notas
        _cSC9 := "Select C9_FILIAL,C9_PEDIDO,C9_PRODUTO,Sum(C9_QTDLIB) C9_QTDLIB,B2_QATU From " + RetSqlName("SC9") + " C9 "
        _cSC9 += "Inner Join " + RetSqlName("SB2") + " B2 On B2_FILIAL = C9_FILIAL And B2_COD = C9_PRODUTO And B2_LOCAL = C9_LOCAL And B2.D_E_L_E_T_ = ' ' "
        _cSC9 += "Inner Join " + RetSqlName("SC6") + " C6 On C6_FILIAL = C9_FILIAL And C6_NUM = C9_PEDIDO And C6_ITEM = C9_ITEM And C6.D_E_L_E_T_ = ' ' "
        _cSC9 += "Inner Join " + RetSqlName("SF4") + " F4 On F4_FILIAL = C6_FILIAL And F4_CODIGO = C6_TES And F4_ESTOQUE = 'S' And F4.D_E_L_E_T_ = ' ' "
        _cSC9 += "Where C9_FILIAL = '" + xFilial("SC9") + "' And C9_PEDIDO = '" + (_cTemp)->PEDIDO + "' And C9_NFISCAL = ' ' And C9.D_E_L_E_T_ = ' ' "
        _cSC9 += "Group by C9_FILIAL,C9_PEDIDO,C9_PRODUTO,B2_QATU "
        _cSC9 += "Having Sum(C9_QTDLIB) > B2_QATU "

        If Select(_cTb9) > 0
            DbSelectArea(_cTb9)
            DbCloseArea()
        EndIf

        DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSC9),_cTb9,.T.,.T.)

        DbSelectArea(_cTb9)
        DbGoTop()
        
        While !Eof()
            _cTexto += "Produto - " + Alltrim((_cTb9)->C9_PRODUTO) + Chr(9) + " - Quantidade a Faturar " + Alltrim(Str((_cTb9)->C9_QTDLIB)) + CHR(13) + CHR(10)
            DbSKip()  
        EndDo
        
        If Select(_cTb9) > 0
            DbSelectArea(_cTb9)
            DbCloseArea()
        EndIf        
        
        If !Empty(_cTexto)
            IFATA26QTD((_cTemp)->PEDIDO,(_cTemp)->PEDCALL,_cTexto)
            
            DbSelectArea(_cTemp)
            Reclock(_cTemp,.f.)
            (_cTemp)->MARKOK := " "
            MsUnlock()
            
            DbSkip()
            Loop
        EndIf       
        
        dbSelectArea("SC9")
        _cTab2 := GetNextAlias()
        _cSQL2 := "Select C9_FILIAL, C9_PEDIDO, R_E_C_N_O_ RECNOSC9 " 
        _cSQL2 += "From " + RetSqlName("SC9") + " C9 " 
        _cSQL2 += "Where C9_FILIAL = '" + xFilial("SC9") + "' And C9_PEDIDO = '" + (_cTemp)->PEDIDO + "' AND "
        _cSQL2 += "C9_NFISCAL = ' ' And C9.D_E_L_E_T_ = ' ' "            
        _cSQL2 += "ORDER BY C9_FILIAL, C9_PEDIDO "

        _cSQL2 := ChangeQuery(_cSQL2)

        If Select(_cTab2) > 0
            DbSelectArea(_cTab2)
            DbCloseArea()
        EndIf

        DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL2),_cTab2,.T.,.T.)

        DbSelectArea(_cTab2)
        DbGoTop()
        While !Eof() 
    
            DbSelectArea('SC9')
            DbGoto((_cTab2)->RECNOSC9)
            
            RecLock("SC9",.F.)
            SC9->C9_OK := cMarca
            MsUnlock()
            
            __lExec := .T.
                
            DbSelectArea(_cTab2)
            dbSkip()
        Enddo
                    
    EndIf                    
    dbSelectArea(_cTemp)
    dbSkip()    
Enddo
                                 
If __lExec
    // Processamento da NF //
    U_IFATA26C("SC9")    
    /////////////////////////
Endif

Return

//Exibe log de produtos com saldo insuficiente
//Jorge H - Anadi - Maio/2015
Static Function IFATA26QTD(_cPedC5,_cPedUA,_cTexto)
Local oButton1, oMultiGe1
Local cMultiGe1 := _cTexto
Local oSay1, oSay2, _oDlg1, _oFont1

DEFINE FONT _oFont1 Name "Tahoma" Size 0 , -11 BOLD
If !Empty(_cPedUA)
	DEFINE MSDIALOG _oDlg1 TITLE "Pedido Call Center " + _cPedUA FROM 000, 000  TO 400, 600 PIXEL
    @ 008, 002 SAY oSay1 PROMPT "O pedido Call Center " + _cPedUA + " não pode ser faturado." SIZE 150, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL
Else
	DEFINE MSDIALOG _oDlg1 TITLE "Pedido " + _cPedC5 FROM 000, 000  TO 400, 600 PIXEL
    @ 008, 002 SAY oSay1 PROMPT "O pedido " + _cPedC5 + " não pode ser faturado." SIZE 120, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL	
EndIf
    @ 020, 002 SAY oSay2 PROMPT "Os produtos abaixo não possuem saldo físico suficiente" SIZE 277, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL
    @ 037, 002 GET oMultiGe1 VAR cMultiGe1 OF _oDlg1 MULTILINE SIZE 294, 141 READONLY HSCROLL PIXEL
    @ 179, 256 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF _oDlg1 PIXEL ACTION _oDlg1:End()

ACTIVATE MSDIALOG _oDlg1 CENTERED

Return


Static Function IFATA26CMP(_cTpComp,_cPedSC5,_cPedSUA)
Local _lRet := .t., _cQry := _cTbx := _cMsgWms := "" 
Default _cTpComp := "", _cPedSC5 := "", _cPedSUA := ""

If _cTpComp == "ITEM"
	
	_cTbx := GetNextAlias()
	If !Empty(_cPedSUA)
		_cQry := "Select Count(UB.R_E_C_N_O_) UB_RECNO,Count(C6.R_E_C_N_O_) C6_RECNO, Count(C9.R_E_C_N_O_) C9_RECNO From " + RetSqlName("SUB") + " UB "
		_cQry += "Left Join " + RetSqlName("SC6") + " C6 On C6_FILIAL = UB_FILIAL And C6_NUM = UB_NUMPV And C6_ITEM = UB_ITEMPV And "
		_cQry += 	"C6__TMKNUM = UB_NUM And C6__TMKITE = UB_ITEM And C6.D_E_L_E_T_ = ' ' "
		_cQry += "Left Join " + RetSqlName("SC9") + " C9 On C9_FILIAL = C6_FILIAL And C9_PEDIDO = C6_NUM And C9_ITEM = C6_ITEM And C9_NFISCAL = ' ' And " 
		_cQry +=	"C9.D_E_L_E_T_ = ' ' And C9_BLEST = ' ' And C9_BLCRED = ' ' "
		_cQry += "Where UB_FILIAL = '" + xFilial("SUB") +  "' And UB_NUM = '" + _cPedSUA + "' And UB.D_E_L_E_T_ = ' ' "
		
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTbx,.T.,.T.)
		
		DbSelectArea(_cTbx)
		DbGoTop()
		If !Eof()
			If (_cTbx)->UB_RECNO != (_cTbx)->C9_RECNO .Or. (_cTbx)->UB_RECNO != (_cTbx)->C6_RECNO
		     	_lRet := .f.
		     	
		     	MsgStop("O pedido Call Center " + _cPedSUA + " não pode ser faturado. "  + CHR(13) + CHR(10) +;
		     			"O número de itens a faturar (" + Alltrim(Str((_cTbx)->C9_RECNO)) +; 
		     			") está divergente do pedido (" + Alltrim(Str((_cTbx)->UB_RECNO))  + "). " + CHR(13) + CHR(10) +;
		     			"O pedido deve ser reaberto","ATENCAO")
		     	
			EndIf
		EndIf
		
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf

	/*Else
		_cQry := "Select Count(C6.R_E_C_N_O_) C6_RECNO, Count(C9.R_E_C_N_O_) C9_RECNO From " + RetSqlName("SC6") + " C6 "
		_cQry += "Left Join " + RetSqlName("SC9") + " C9 On C9_FILIAL = C6_FILIAL And C9_PEDIDO = C6_NUM And C9_ITEM = C6_ITEM And C9_NFISCAL = ' ' And " 
		_cQry +=	"C9.D_E_L_E_T_ = ' ' And C9_BLEST = ' ' And C9_BLCRED = ' ' "
		_cQry += "Where C6_FILIAL = '" + xFilial("SC6") +  "' And C6_NUM = '" + _cPedSC5 + "' And C6.D_E_L_E_T_ = ' ' "
		
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTbx,.T.,.T.)
		
		DbSelectArea(_cTbx)
		DbGoTop()
		If !Eof()
			If (_cTbx)->C6_RECNO != (_cTbx)->C9_RECNO
		     	_lRet := .f.
		     	
		     	MsgStop("O pedido " + _cPedSC5 + " não pode ser faturado. " + CHR(13) + CHR(10) +;
		     			"O número de itens a faturar (" + Alltrim(Str((_cTbx)->C9_RECNO)) +; 
		     			") está divergente do pedido (" + Alltrim(Str((_cTbx)->C6_RECNO))  + "). " + CHR(13) + CHR(10) +;
		     			"O pedido deve ser reaberto","ATENCAO")
		     	
			EndIf
		EndIf
		*/
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf

	EndIf

ElseIf _cTpComp == "QTD"
	
	_cTbx := GetNextAlias()
	If !Empty(_cPedSUA)
		_cQry := "Select Sum(UB_QUANT) UB_QUANT, Sum(C6_QTDVEN) C6_QTDVEN, Sum(C9_QTDLIB) C9_QTDLIB From " + RetSqlName("SUB") + " UB "
		_cQry += "Left Join " + RetSqlName("SC6") + " C6 On C6_FILIAL = UB_FILIAL And C6_NUM = UB_NUMPV And C6_ITEM = UB_ITEMPV And "
		_cQry += 	"C6__TMKNUM = UB_NUM And C6__TMKITE = UB_ITEM And C6.D_E_L_E_T_ = ' ' "
		_cQry += "Left Join " + RetSqlName("SC9") + " C9 On C9_FILIAL = C6_FILIAL And C9_PEDIDO = C6_NUM And C9_ITEM = C6_ITEM And C9_NFISCAL = ' ' And " 
		_cQry +=	"C9.D_E_L_E_T_ = ' ' And C9_BLEST = ' ' And C9_BLCRED = ' ' "
		_cQry += "Where UB_FILIAL = '" + xFilial("SUB") +  "' And UB_NUM = '" + _cPedSUA + "' And UB.D_E_L_E_T_ = ' ' "
		
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTbx,.T.,.T.)
		
		DbSelectArea(_cTbx)
		DbGoTop()
		If !Eof()
			If (_cTbx)->UB_QUANT != (_cTbx)->C9_QTDLIB .Or. (_cTbx)->UB_QUANT != (_cTbx)->C6_QTDVEN
		     	_lRet := .f.
		     	
		     	MsgStop("O pedido Call Center " + _cPedSUA + " não pode ser faturado. " + CHR(13) + CHR(10) +;
		     			"A quantidade dos produtos a faturar (" + Alltrim(Str((_cTbx)->C9_QTDLIB)) +; 
		     			") está divergente do pedido (" + Alltrim(Str((_cTbx)->UB_QUANT))  + "). " + CHR(13) + CHR(10) +;		     			
		     			"O pedido deve ser reaberto","ATENCAO")
		     	
			EndIf
		EndIf
		
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf

	/*
	Else
		_cQry := "Select Sum(C6_QTDVEN) C6_QTDVEN, Sum(C9_QTDLIB) C9_QTDLIB From " + RetSqlName("SC6") + " C6 "
		_cQry += "Left Join " + RetSqlName("SC9") + " C9 On C9_FILIAL = C6_FILIAL And C9_PEDIDO = C6_NUM And C9_ITEM = C6_ITEM And C9_NFISCAL = ' ' And " 
		_cQry +=	"C9.D_E_L_E_T_ = ' ' And C9_BLEST = ' ' And C9_BLCRED = ' ' "
		_cQry += "Where C6_FILIAL = '" + xFilial("SC6") +  "' And C6_NUM = '" + _cPedSC5 + "' And C6.D_E_L_E_T_ = ' ' "

	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTbx,.T.,.T.)
		
		DbSelectArea(_cTbx)
		DbGoTop()
		If !Eof()
			If (_cTbx)->C6_QTDVEN != (_cTbx)->C9_QTDLIB
		     	_lRet := .f.
		     	
		     	MsgStop("O pedido " + _cPedSC5 + " não pode ser faturado. " + CHR(13) + CHR(10) +;
		     			"A quantidade dos produtos a faturar (" + Alltrim(Str((_cTbx)->C9_QTDLIB)) +; 
		     			") está divergente do pedido (" + Alltrim(Str((_cTbx)->C6_QTDVEN))  + "). " + CHR(13) + CHR(10) +;		     			
		     			"O pedido deve ser reaberto","ATENCAO")
		     	
			EndIf
		EndIf
	*/	
	 	If Select(_cTbx) > 0
	  		DbSelectArea(_cTbx)
			DbCloseArea()
		EndIf

	EndIf

Else
	_cTbx := GetNextAlias()
	_cQry := "Select C9_ITEM,C9_PRODUTO,C9_QTDLIB, C9__QTDMHA From " + RetSqlName("SC9") + " C9 "
	_cQry += "Where C9_FILIAL = '" + xFilial("SC9") +  "' And C9_PEDIDO = '" + _cPedSC5 + "' And C9_NFISCAL = ' ' And "
	_cQry += 		"C9.D_E_L_E_T_ = ' ' And C9_QTDLIB <> C9__QTDMHA "
	_cQry += "Order By C9_ITEM,C9_PRODUTO "

 	If Select(_cTbx) > 0
  		DbSelectArea(_cTbx)
		DbCloseArea()
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTbx,.T.,.T.)
	
	DbSelectArea(_cTbx)
	DbGoTop()
	While !Eof()
	     	
     	_cMsgWms += "Item " + (_cTbx)->C9_ITEM + " - Produto " + Alltrim((_cTbx)->C9_PRODUTO)
     	_cMsgWms += " - Qtd Pedido " + Alltrim(Str((_cTbx)->C9_QTDLIB)) + " - Qtd WMS " + Alltrim(Str((_cTbx)->C9__QTDMHA))
     	_cMsgWms += CHR(13) + CHR(10)
	     	
		DbSkip()
	EndDo
	
	If !Empty(_cMsgWms)
		_lRet := .f.
		IFATA26WMS(_cPedSC5,_cPedSUA,_cMsgWms)
	EndIf
	
 	If Select(_cTbx) > 0
  		DbSelectArea(_cTbx)
		DbCloseArea()
	EndIf
EndIf

Return _lRet


//Exibe log de produtos com quantidade retornada do WMS diferente da quantidade liberada
//Jorge H - Anadi - Junho/2015
Static Function IFATA26WMS(_cPedC5,_cPedUA,_cTexto)
Local oButton1, oMultiGe1
Local cMultiGe1 := _cTexto
Local oSay1, oSay2, _oDlg1, _oFont1

DEFINE FONT _oFont1 Name "Tahoma" Size 0 , -11 BOLD
If !Empty(_cPedUA)
	DEFINE MSDIALOG _oDlg1 TITLE "Pedido Call Center " + _cPedUA FROM 000, 000  TO 400, 600 PIXEL
    @ 008, 002 SAY oSay1 PROMPT "O pedido Call Center " + _cPedUA + " não pode ser faturado." SIZE 150, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL
Else
	DEFINE MSDIALOG _oDlg1 TITLE "Pedido " + _cPedC5 FROM 000, 000  TO 400, 600 PIXEL
    @ 008, 002 SAY oSay1 PROMPT "O pedido " + _cPedC5 + " não pode ser faturado." SIZE 120, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL	
EndIf

    @ 020, 002 SAY oSay2 PROMPT "A quantidade separada pelo WMS está diferente do esperado" SIZE 277, 007 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL
    @ 037, 002 GET oMultiGe1 VAR cMultiGe1 OF _oDlg1 MULTILINE SIZE 294, 141 READONLY HSCROLL PIXEL
    @ 179, 256 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF _oDlg1 PIXEL ACTION _oDlg1:End()

ACTIVATE MSDIALOG _oDlg1 CENTERED

Return