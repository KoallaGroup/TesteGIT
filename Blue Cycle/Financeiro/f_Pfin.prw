#Include "Protheus.ch"
#Include "Fileio.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XPEFIN    ºAutor  ³Valmir Belchior     º Data ³06/05/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a geração de arquivo remessa de Pendencias Finanº±±
±±           ³ceiras do padrão PEFIN Serasa Experian "SERASA-CONVEM04"    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xPeFin()
Local cTitulo := 'Processando'
Local cMsg := 'Aguarde, processando a rotina'

Private dDtVIni                := ""
Private dDtVFim                              := ""
Private dDtEIni                 := ""
Private dDtEFim                              := ""
Private _cDtIni                 := ""
Private _cDtFim                               := ""
Private _cPatch                               := ""
Private _nTipo                  := ""
Private nHdl                      := 0

If !Pergunte("XPEFIN",.t.)
                Return()
End

dDtVIni := MV_PAR01
dDtVFim := MV_PAR02
dDtEIni := MV_PAR03
dDtEFim := MV_PAR04
_cCliDe := MV_PAR05
_cCliAte:= MV_PAR06
_cPatch := MV_PAR07
_nTipo  := MV_PAR08

If File(_cPatch)
                Alert("Arquivo "+Alltrim(_cPatch)+" ja existe")
                Return
Endif

FWMsgRun(, {|oSay| ProcPefin( oSay ) }, cTitulo, cMsg ) //ProcPefin()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcPefin ºAutor  ³Valmir Belchior     º Data ³08/05/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a geração de arquivo remessa de Pendencias Finanº±±
±±           ³ceiras do padrão PEFIN Serasa Experian "SERASA-CONVEM04"    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Bronzearte -                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcPefin()

//Local dDtLimF:= Date()-4
//Local dDtLimI:= StoD(alltrim(str(Year(Date())-5)) + substr(dtos(Date()),5,4))
Local cDtVI         := ""
Local cDtVF  := ""
Local cDtEI          := ""
Local cDtEF  := ""

Private  _astru                   := {}
Private  _afields               := {}
Private  _carq
Private oMark
Private cQuery                 := ""
Private cCadastro            := "Geração de Arquivo PEFIN 'SERASA-CONVEM04'"
Private arotina := {}
Private cMark                   := GetMark()
Private nSEQ                     := "000001"

/*IF dDtVFim > dDtLimF
                cDtVF    := DtoS(dDtVFim)
Else
                cDtVF    := DtoS(dDtLimF)
End

If dDtVIni > dDtLimI
                cDtVI     := DtoS(dDtLimI)
Else
                cDtVI     := DtoS(dDtVIni)
End

IF dDtEFim > dDtLimF
                cDtEF    := DtoS(dDtEFim)
Else
                cDtEF    := DtoS(dDtLimF)
End

If dDtEIni > dDtLimI
                cDtEI     := DtoS(dDtLimI)
Else
	                cDtEI     := DtoS(dDtEIni)
End */

cDtVF	:= DtoS(dDtVFim)
cDtVI 	:= DtoS(dDtVIni)

cDtEF	:= DtoS(dDtEFim)
cDtEI	:= DtoS(dDtEIni)

IF _nTipo == 1
                aRotina   := {      { "Marca Todos"              ,"U_MARCAR"  , 0, 1},;
                                                                              { "Desmarca Todos"       ,"U_DESMAR"  , 0, 2},;
                                                                              { "Inverter"                        ,"U_xMARKALL", 0, 3},;
                                                                              { "Gerar"                                            ,'ExecBlock("GERATXT",.F.,.F.,4), CloseBrowse()' , 0, 4}}                                                                                                                                
Else                                                       
                aRotina   := {      { "Desmarca Todos"       ,"U_DESMAR"  , 0, 1},;
                                                                              { "Gerar"                                            ,'ExecBlock("GERATXT",.F.,.F.,4), CloseBrowse()' , 0, 2}}
End

//ª Estrutura da tabela temporaria
AADD(_astru,{"E1_OK"                               ,"C",02,0})
AADD(_astru,{"E1_PREFIXO"    ,"C",03,0})
AADD(_astru,{"E1_NUM"                          ,"C",19,0})
AADD(_astru,{"E1_PARCELA"   ,"C",01,0})
AADD(_astru,{"E1_TIPO"                            ,"C",03,0})
//If _nTipo == 2
                AADD(_astru,{"E1_MOTBX"      ,"C",02,0})
//End
AADD(_astru,{"E1_VENCREA"  ,"D",08,0})
AADD(_astru,{"E1_VALOR"                       ,"C",19,0})
AADD(_astru,{"E1_SALDO"                        ,"C",19,0})
AADD(_astru,{"E1_NSALDO"     ,"N",17,2})
AADD(_astru,{"E1_NUMBCO"  ,"C",15,0})
AADD(_astru,{"E1_VALLIQ"       ,"N",17,2})
AADD(_astru,{"E1_FATURA"     ,"C",09,0})
AADD(_astru,{"E1_PORTADO" ,"C",03,0})
AADD(_astru,{"E1_AGEDEP"     ,"C",05,0})
AADD(_astru,{"E1_CONTA"                       ,"C",10,0})
AADD(_astru,{"E1_NUMBOR"  ,"C",06,0})
AADD(_astru,{"E1_NOMECLI"  ,"C",70,0})
AADD(_astru,{"E1_CLIENTE"     ,"C",06,0})
AADD(_astru,{"E1_LOJA"                           ,"C",02,0})
AADD(_astru,{"E1_DIAATRA"   ,"N",04,0})
AADD(_astru,{"E1_BAIXA"                         ,"D",08,0})
AADD(_astru,{"E1_CHAVE"                       ,"C",16,0})
AADD(_astru,{"E1_HIST"                       ,"C",65,0})
AADD(_astru,{"A1_ENDCOB"    ,"C",45,0})
AADD(_astru,{"A1_BAICOB"     ,"C",20,0})
AADD(_astru,{"A1_MUNCOB" ,"C",08,0})
AADD(_astru,{"A1_ESTCOB"     ,"C",02,0})
AADD(_astru,{"A1_CEPCOB"     ,"C",08,0})
AADD(_astru,{"A1_DDDCOB"   ,"C",03,0})
AADD(_astru,{"A1_TELCOB"      ,"C",15,0})
AADD(_astru,{"A1_CGC"                            ,"C",14,0})
AADD(_astru,{"A1_PESSOA"     ,"C",01,0})

// cria a tabela temporária
_carq:="T_"+Criatrab(,.F.)
MsCreate(_carq,_astru,"DBFCDX")
Sleep(1000)

IIF(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
// atribui a tabela temporária ao alias TRB
dbUseArea(.T.,"DBFCDX",_cARq,"TRB",.T.,.F.)

cQuery := ""
//cQuery := " SELECT E1_FATURA,E1_VALLIQ, E1_PREFIXO, E1_NUMBCO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_NUMBCO, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, A1_NOME, E1_CLIENTE, E1_LOJA, E1_SALDO, E1_BAIXA, A1_END, A1_BAIRRO, A1_MUNC,  A1_MUN, A1_EST, A1_CEP, A1_DDD, A1_TEL, A1_CGC,A1_PESSOA " //cQuery := " SELECT E1_FATURA,E1_VALLIQ, E1_PREFIXO, E1_NUMBCO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_NUMBCO, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, A1_NOME, E1_CLIENTE, E1_LOJA, E1_SALDO, E1_BAIXA, A1_ENDCOB,A1_END, A1_BAICOB, A1_BAIRRO, A1_MUNC,  A1_MUN, A1_EST, A1_ESTCOB, A1_CEP,A1_CEPCOB, A1_DDD,A1_DDDCOB, A1_TELCOB, A1_TEL, A1_CGC,A1_PESSOA "
cQuery := " SELECT E1_FATURA,E1_VALLIQ, E1_PREFIXO, E1_NUMBCO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_NUMBCO, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, A1_NOME, E1_CLIENTE, E1_LOJA, E1_SALDO, E1_HIST, E1_BAIXA, A1_ENDCOB,A1_END, A1_BAIRROC, A1_BAIRRO, A1_MUNC,  A1_MUN, A1_EST, A1_ESTC, A1_CEP, A1_CEPC, A1_DDD, A1_TEL, A1_CGC,A1_PESSOA "
cQuery += " FROM "+Retsqlname("SE1") +" SE1, "+Retsqlname("SA1") +" SA1 " // +Retsqlname("SEA") +" SEA, "
cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
//cQuery += " AND EA_FILIAL = '"+xFilial("SEA")+"' "
cQuery += " AND A1_FILIAL = '"+xFilial("SA1")+"' "
//cQuery += " AND E1_NUMBOR = EA_NUMBOR "
//cQuery += " AND E1_PREFIXO = EA_PREFIXO "
//cQuery += " AND E1_NUM = EA_NUM "
//cQuery += " AND E1_PARCELA = EA_PARCELA "
//cQuery += " AND E1_TIPO = EA_TIPO "
cQuery += " AND E1_CLIENTE = A1_COD"
cQuery += " AND E1_LOJA = A1_LOJA"
//cQuery += " AND EA_TRANSF = 'S'"
cQuery += " AND A1_COD BETWEEN '"+_cCliDe+"' AND '"+_cCliAte+"'"
cQuery += " AND E1_PREFIXO = '1'"
cQuery += " AND E1_TIPO = 'NF'"
If _nTipo == 1
                cQuery += " AND E1_SALDO > 0 " // 17-05-17 cQuery += " AND E1_SALDO > 0 AND E1_STPEFIN = ' '" 
// 17-05-17 Else
                // 17-05-17 cQuery += "AND E1_STPEFIN = 'I'" 
End
//cQuery += " AND A1_XSERASA <> 'N' "
cQuery += " AND A1_COD NOT IN "+GETMV("MV_CLIESP")+ALLTRIM(GETMV("MV_CLIESP2"))+" "
//cQuery += " AND E1_NUMBCO <> '' "
cQuery += " AND SE1.D_E_L_E_T_ <> '*' "
//cQuery += " AND SEA.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_VENCREA BETWEEN '"+cDtVI+"' AND '"+cDtVF+"'"
cQuery += " AND E1_EMISSAO BETWEEN '"+cDtEI+"' AND '"+cDtEF+"'"
cQuery += " ORDER BY A1_COD, E1_NUM, E1_PARCELA, E1_TIPO"

cQuery := ChangeQuery(cQuery)

If Select("TMP") > 0
                dbSelectArea("TMP")
                dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.F.)

//Dbselectarea("SA1")
DBGOTOP()
WHILE TMP->(!EOF())
                //IF !Alltrim(TMP->E1_CLIENTE) $ FORMULA("106")
                               DBSELECTAREA("TRB")
                               RECLOCK("TRB",.T.)
                               TRB->E1_NUM                 := Alltrim(TMP->E1_PREFIXO) + " / "+ Alltrim(TMP->E1_NUM) + " / " + Alltrim(TMP->E1_PARCELA) +" / " + Alltrim(TMP->E1_TIPO)
                               TRB->E1_VENCREA := STOD(TMP->E1_VENCREA)
                               TRB->E1_VALOR   := Alltrim(Transform(TMP->E1_VALOR,"@E 999999999.99"))
                               TRB->E1_SALDO   := Alltrim(Transform(TMP->E1_SALDO,"@E 999999999.99"))
                               TRB->E1_NSALDO  := TMP->E1_SALDO
                               If _nTipo == 2
                                               TRB->E1_MOTBX            := xMotBx()
                               End
                               TRB->E1_FATURA  := TMP->E1_FATURA
                               TRB->E1_VALLIQ  := TMP->E1_VALLIQ
                               TRB->E1_NUMBCO  := TMP->E1_NUMBCO
                               TRB->E1_PORTADO := TMP->E1_PORTADO
                               TRB->E1_AGEDEP  := TMP->E1_AGEDEP
                               TRB->E1_CONTA   := TMP->E1_CONTA
                               TRB->E1_NUMBOR  := TMP->E1_NUMBOR
                               TRB->E1_NOMECLI := Alltrim(Posicione("SA1", 1, xFilial("SA1") + TMP->E1_CLIENTE+TMP->E1_LOJA , "A1_NOME"))
                               TRB->E1_CLIENTE := Alltrim(TMP->E1_CLIENTE)
                               TRB->E1_LOJA    := TMP->E1_LOJA
                               TRB->E1_DIAATRA := DATE()-StoD(TMP->E1_VENCREA)
                               TRB->E1_BAIXA   := STOD(TMP->E1_BAIXA)
                               TRB->E1_NUMBCO  := TMP->E1_NUMBCO
                               TRB->E1_CHAVE   := TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO
                               TRB->E1_HIST    := TMP->E1_HIST
                               TRB->A1_ENDCOB  := Iif(Empty(TMP->A1_ENDCOB), TMP->A1_END , TMP->A1_ENDCOB)
                               TRB->A1_BAICOB  := Iif(Empty(TMP->A1_BAIRROC), TMP->A1_BAIRRO, TMP->A1_BAIRROC)
                               TRB->A1_MUNCOB  := Iif(Empty(TMP->A1_MUNC)  , TMP->A1_MUN, TMP->A1_MUNC)
                               TRB->A1_ESTCOB  := Iif(Empty(TMP->A1_ESTC), TMP->A1_EST, TMP->A1_ESTC)
                               TRB->A1_CEPCOB  := Iif(Empty(TMP->A1_CEPC), TMP->A1_CEP, TMP->A1_CEPC)
                               TRB->A1_DDDCOB  := TMP->A1_DDD //TRB->A1_DDDCOB  := Iif(Empty(TMP->A1_DDDCOB), TMP->A1_DDD, TMP->A1_DDDCOB)
                               TRB->A1_TELCOB  := TMP->A1_TEL //TRB->A1_TELCOB  := Iif(Empty(TMP->A1_TELCOB), TMP->A1_TEL, TMP->A1_TELCOB)                     
                               TRB->A1_CGC     := TMP->A1_CGC
                               TRB->A1_PESSOA  := TMP->A1_PESSOA
                               
                               MSUNLOCK()
                               DBSELECTAREA("TMP")
                //End
                DBSKIP()
ENDDO

AADD(_afields,{"E1_OK"                            ,"",""                                                    })
AADD(_afields,{"E1_CLIENTE"  ,"","Cod.Cliente"             })
AADD(_afields,{"E1_LOJA"         ,"","Loja"                                            })
AADD(_afields,{"E1_NOMECLI"               ,"","Cliente"                      })
AADD(_afields,{"E1_NUM"                       ,"","Pref/Num/Parc/Tipo"                          })
//If _nTipo == 2
                AADD(_afields,{"E1_MOTBX","","Motivo Bx."  })
//End
AADD(_afields,{"E1_VENCREA"               ,"","Venc. Real"               })
AADD(_afields,{"E1_VALOR"     ,"","Valor"                                         })
AADD(_afields,{"E1_SALDO"     ,"","Saldo"                                         })
AADD(_afields,{"E1_HIST"     ,"","Histórico"                                         })
AADD(_afields,{"E1_NUMBCO"               ,"","Nosso Numero"      })
AADD(_afields,{"E1_PORTADO"              ,"","Banco"                                        })
AADD(_afields,{"E1_AGEDEP"  ,"","Agencia"                    })
AADD(_afields,{"E1_CONTA"    ,"","Conta Corrente"})
AADD(_afields,{"E1_NUMBOR"               ,"","Numero Borderô"})
AADD(_afields,{"E1_DIAATRA" ,"","Dias Atraso"              })
AADD(_afields,{"E1_BAIXA"      ,"","Dt.Baixa"                    })

DbSelectArea("TRB")
DbGotop()

IF _nTipo == 1
                MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,'U_xMarkAll()'        ,,,,'U_xMarka()' ,{|| U_DESMAR()}        ,,,,,,,.F.) // MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,,,,,'U_xMarkax()',{|| U_xMarkAle()} ,,,,,,,.F.) //18-05-17 MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,'U_xMarkAll()'        ,,,,'U_xMarka()' ,{|| U_DESMAR()}        ,,,,,,,.F.)
Else
                MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,,,,,'U_xMarkax()',{|| U_xMarkAle()} ,,,,,,,.F.)
End

// apaga a tabela temporário
MsErase(_carq+GetDBExtension(),,"DBFCDX")
TRB->(DbCloseArea())
TMP->(DbCloseArea())
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gerar ºAutor  ³Valmir Belchior                    º Data ³03/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GeraTXT()
Local      oMark := GetMarkBrow()
Local cTitulo := 'Processando'
Local cMsg := 'Aguarde, processando a rotina'

Private _cSubC := ""

DbSelectArea("TRB")
DbGotop()

If ChecaMark()
                Return
End

IF _nTipo == 2
                IF Checambx()== 1
       Return()
                End                        
End

If !File(_cPatch)
                nHdl := FCreate(_cPatch)
Else
                Alert("Arquivo ja existe")
                Return
Endif


FWMsgRun(, {|oSay| GeraPEFIN( oSay ) }, cTitulo, cMsg ) //Processa({||GeraPEFIN()})

MsgInfo("Arquivo "+_cPatch+" gerado com sucesso."," Aviso ")
FClose(nHdl)

MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraPEFIN ºAutor  ³Valmir Belchior     º Data ³13/05/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcoes Gera o arquivo REM para o PEFIN                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraPEFIN()
Local aH                               :={}
Local aR                               :={}
Local aT                               :={}
Local cH                               :=""
Local cR                               :=""
Local cT                                :=""
Local nSeqReg  :=2
Local cSeqArq   := STR(GetMv("MV_SEQPEFI"))
Local i := 0

//Registro Header
//                              Seq.  Iní   Tam  AXN     ZPB                                                       Conteudo                                                                                                                                                        Descrição
Aadd( aH, {"01","001","001","N","Z","(1)(2)"     ,"0"})                                                                                                                                                                 //"Código do registro = '0' (zero)"
Aadd( aH, {"02","002","009","N","Z","(1)(2)"     ,Substr(PADL(SM0->M0_CGC,15,"0"),1,9)})                      //"Número do CNPJ da instituição informante ajustado à direita e preenchido com zeros à esquerda"
Aadd( aH, {"03","011","008","N","Z","(1)(2)"     ,GravaData(date(),.F.,8)})                                                                                         //"Data do movimento (AAAAMMDD) – data de geração doarquivo"
Aadd( aH, {"04","019","004","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_DDDPEFI")),04,"0")})       //"Número de DDD do telefone de contato da instituição informante",
Aadd( aH, {"05","023","008","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_TELPEFI")),08,"0")})         //"Número do telefone de contato da instituição informante)","(1) (2)"})
Aadd( aH, {"06","031","004","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_RAMAPEF")),04,"0")})    //"Número de ramal do telefone de contato da instituição informante","(1) (2)"})
Aadd( aH, {"07","035","070","A","Z","(1)(2)"     ,PADR((GetMv("MV_CONTPEF")),70," ")})                                        //"Nome do contato da instituição informante","(1) (2)"})
Aadd( aH, {"08","105","015","X","Z","(1)(2)"      ,PADR("SERASA-CONVEM04",15," ")})                                                 //"Identificação do arquivo fixo 'SERASA-CONVEM04'","(1) (2)"})
Aadd( aH, {"09","120","006","N","Z","(1)(2)"     ,PADL(ALLTRIM(cSeqArq),06,"0")})                                                       //"Número da remessa do arquivo sequencial do 000001,incrementando de 1 a cada novo movimento","(1) (2)"})
Aadd( aH, {"10","126","001","A","Z","(1)(2)"     ,"E"})                                                                                                                                                                 //"Código de envio de arquivo = “E” ( ENTRADA) e “R” (RETORNO)","(1) (2)"})
Aadd( aH, {"11","127","004","X","Z","(1)(2)"      ,Space(004)})                                                                                                                                  //"Diferencial de remessa , caso a instituição informante tenha necessidade de enviar mais de uma remessa independentes por deptos., no mesmo dia, de 0000 à 9999. Caso contrário, em branco","(1) (2)"})
Aadd( aH, {"12","131","403"," "," ",""                                   ,Space(403)})                                                                                                                                 //"Deixar em branco",""})
Aadd( aH, {"13","534","060","X","Z",""                                ,Space(060)})                                                                                                                                 //"Código de erros – 3 posições ocorrendo 20 vezes . Ausência de códigos indica que foi aceito no movimento de retorno . Na entrada, preencher com brancos",""})
Aadd( aH, {"14","594","007","N","Z","(1)(2)"     ,"0000001" })                                                                                                                                   //"Sequencia do registro no arquivo igual a 0000001 para o header","(1) (2)"})

PUTMV("MV_SEQPEFI",Val(cSeqArq)+1)

For i := 1 To Len(aH)
                If aH[i][4] =="N"
                               cH += PADL(aH[i][7],val(aH[i][3]),"0")
                Else
                               cH += PADR(aH[i][7],val(aH[i][3])," ")
                End
Next i

GravaTxt(cH)     // Grava linha do header no arquivo

dbSelectArea("TRB")
dbgotop()
ProcRegua(RecCount())

While TRB->(!Eof())
                IncProc(TRB->E1_PREFIXO+TRB->E1_NUM+TRB->E1_PARCELA+TRB->E1_TIPO)
                aR                          :={}
                IF IsMark( 'E1_OK', cMark )
                               //Registro Detalhes
                               //                              Seq.  Iní   Tam  AXN     ZPB                                                                       Conteudo                                                                                                                                        Descrição
                               Aadd( aR, {"01","001","001","N","Z","(1)(2)"                     ,"1"})                                   //Código do registro = '1' - Detalhes (1)(2)
                               Aadd( aR, {"02","002","001","A","Z","(1)(2)"                     ,Iif(_nTipo==1,"I","E")})					 //Aadd( aR, {"02","002","001","A","Z","(1)(2)"                     ,Alltrim(str(_nTipo))})                //Código da operação = I - inclusão ; E –exclusão (1)(2)
                               Aadd( aR, {"03","003","006","N","Z","(1)   "                        ,Subst(SM0->M0_CGC,10,6)})            //Filial e dígito do CNPJ da contratante (1)
                               Aadd( aR, {"04","009","008","N","Z","(1)   "                        ,GravaData(TRB->E1_VENCREA,.F.,8)})   //Data da ocorrência (AAAAMMDD) – data do vencimento da dívida, não superior a 4 anos e 11 meses , e inferior à 4 dias da data do movimento (1)
                               Aadd( aR, {"05","017","008","N","Z","(1)   "                        ,GravaData(TRB->E1_VENCREA,.F.,8)})   //Data do término do contrato – formato “AAAAMMDD” . Caso não possua , repetir a data da ocorrência ( vide observação 1 para natureza “DC” ) (1)
                               Aadd( aR, {"06","025","003","X","Z","(1)   "                        ,"DP "})                              //Código de natureza da operação (1)
                               Aadd( aR, {"07","028","004","A","Z",""                              ,Space(004)})       					 //Código da praça Embratel ( que originou a dívida )
                               Aadd( aR, {"08","032","001","A","Z","(3)(4)(5)"                	   ,TRB->A1_PESSOA})                          //Tipo de pessoa do principal ; Física (F) ou Jurídica( J ) (3)(4)(5)
                               Aadd( aR, {"09","033","001","X","Z","(3)(4 (5)"                	   ,Iif(TRB->A1_PESSOA=="F","1","2")})       //Tipo do primeiro docto. do principal :1-CNPJ ou 2-CPF(3)(4)(5)
                               Aadd( aR, {"10","034","015","N","Z","(2)(3)(4)(5)"          		   ,TRB->A1_CGC})                                //Primeiro documento do principal : CPF completo – base + dígito ou CNPJ completo – base + filial + dígito .Ajustado à direita e preenchido com zeros à esquerda(2)(3)(4)(5)
                               Aadd( aR, {"11","049","002","X","Z","(2)(5)"                        ,IF(_nTipo == 1,"  ",TRB->E1_MOTBX)})   //Motivo da baixa (2)(5)
                               /*
                               01 – pagamento da dívida
                               02 – renegociação da dívida
                               03 – por solicitação do cliente
                               04 – ordem judicial valmir.b
                               05 – correção de endereço
                               06 – atualização do valor – valorização
                               07 – atualização do valor–pagamento parcial
                               08 – atualização de data
                               09 – correção do nome
                               10 – correção do número do contrato
                               11 – correção de varios dados (valor+datas+etc)
                               12 – baixa por perda de controle de base
                               13 – motivo não identificado
                               14 – pontualização da dívida
                               15 – baixa por concessão de crédito
                               16 – incorporação / mudança de titularidade
                               17 – comunicado devolvido dos correios
                               18 – correção de dados do coobrigado / avalista.
                               19 – renegociação da dívida por acordo.
                               20 – pagamento da dívida por pagamento bancário.
                               21 – analise de documentos.
                               22 – correção de dados pela loja / filial.
                               23 – pagamento da dívida por emissão de Nota Promissória.
                               24 – análise de documento por seguro.
                               25 – devolução ou troca de bem financiado.
                               
                               Os motivos abaixo são de uso interno do sistema da SERASA, portanto não devem ser usados
                               
                               00 – motivo antes da implantação ( passado )
                               88 – Carta / Comprovante não retornado dos Correios
                               89 – Motivos diversos
                               90 – Falta documentação da dívida
                               91 – contestação / declaração do interessado
                               92 – aditivo contratual
                               93 – exclusão por extinção de contrato
                               94 – decurso – Súmula 13
                               95 – comunicado devolvido do correio
                               96 – determinação judicial
                               97 – decurso do prazo
                               99 – motivo da baixa não informado
                               */
                               Aadd( aR, {"12","051","001","X","Z",""                                                 ,Space(001)})                                                                                                  //Tipo do segundo documento do principal : 3 – RG, se houver.Se não, espaços (só para pessoa física )
                               Aadd( aR, {"13","052","015","X","Z",""                                                 ,Space(015)})                                                                                                  //Segundo documento do principal , se houver, se não, espaços
                               Aadd( aR, {"14","067","002","A","Z",""                                                ,Space(002)})                                                                                                  //UF quando documento for RG , se não , espaços. Para os campos abaixo , de Seq. 15 a 21, referentes ao coobrigado, se o registro for do principal, deixar em branco.
                               Aadd( aR, {"15","069","001","A","Z","(4)(6)"                     ,Space(001)})                                                                                                  //Tipo de pessoa do coobrigado : Física ( F) ou Jurídica ( J ) (4)(6)
                               Aadd( aR, {"16","070","001","X","Z","(4)(6)"                      ,Space(001)})                                                                                                  //Tipo do primeiro documento do coobrigado (4) (6) 1 – CNPJ ou 2 – CPF
                               Aadd( aR, {"17","071","015","X","Z","(4)(6)"                      ,Space(015)})                                                                                                  //Primeiro documento do coobrigado : (4) (6) CPF completo - base + dígito ou CNPJ completo - base + filial + dígito , ajustado à direita e preenchido com zeros à esquerda
                               Aadd( aR, {"18","086","002","" ," ",""                                                    ,Space(002)})                                                                                                                  //Espaços
                               Aadd( aR, {"19","088","001","X","Z",""                                                 ,Space(001)})                                                                                                  //Tipo do segundo documento do coobrigado : 3 – RG, se houver, se não, espaços ( só para pessoa física )
                               Aadd( aR, {"20","089","015","X","Z",""                                                 ,Space(001)})                                                                                                  //Segundo documento do coobrigado, se houver, se não, espaços
                               Aadd( aR, {"21","104","002","A","Z",""                                                ,Space(001)})                                                                                                  //Unidade da Federação, quando documento for RG, se não, espaços
                               Aadd( aR, {"22","106","070","X","Z","(1)(4)(6)"                ,PADR(TRB->E1_NOMECLI,70," ")})                                        //Nome do devedor (1) (4) (6)
                               Aadd( aR, {"23","176","008","N","Z",""                                                ,Space(008)})                                                                                                  //A data do nascimento (AAAAMMDD) deve ser superior a 18 anos ( só para pessoa física ). Se não, colocar 00000000
                               Aadd( aR, {"24","184","070","X","Z",""                                                 ,Space(070)})                                                                                                  //Nome do pai. Caso não possua , brancos.
                               Aadd( aR, {"25","254","070","X","Z",""                                                 ,Space(070)})                                                                                                  //Nome da mãe. Caso não possua, brancos
                               Aadd( aR, {"26","324","045","X","Z","(1)"                                           ,PADR(SUBSTR(TRB->A1_ENDCOB,1,45),45," ")}) //Endereço completo (rua, Av., nº etc.) (1)
                               Aadd( aR, {"27","369","020","X","Z","(1)"                                           ,PADR(TRB->A1_BAICOB,20," ")})                                          //Bairro correspondente (1)
                               Aadd( aR, {"28","389","025","X","Z","(1)"                                           ,PADR(TRB->A1_MUNCOB,25," ")})                                      //Município correspondente (1)
                               Aadd( aR, {"29","414","002","A","Z","(1)"                                           ,PADR(TRB->A1_ESTCOB,02," ")})                                          //Sigla Unidade Federativa (1)
                               Aadd( aR, {"30","416","008","N","Z","(1)"                                          ,PADL(TRB->A1_CEPCOB,08,"0")})                                         //Código de endereçamento postal completo (1)
                               Aadd( aR, {"31","424","015","N","Z","(1)"                                          ,STRZERO(ROUND(TRB->E1_NSALDO,2)*100,15) })         //Valor com 2 decimais, alinhar a direita com zeros a esquerda(1)
                               Aadd( aR, {"32","439","016","X","Z","(1)(2)"                      ,PADR(TRB->E1_CHAVE,16," ")})                                             //O número do contrato deve ser único para o principal e seus coobrigados (vide observação 2 para natureza “DC” e observação 4 ) (1) (2)
                               Aadd( aR, {"33","455","009","N","Z",""                                                ,PADR(SUBSTR(TRB->E1_NUMBCO,01,09),09," ")})//Nosso número ( Vide observação 3 para natureza "DC")
                               Aadd( aR, {"34","464","025","X","Z",""                                                 ,PADR(SUBSTR(TRB->A1_ENDCOB,45,25),25," ")})//Complemento do endereço do devedor – usar somente quando o campo de seq. Nr.26 (endereço completo) não for suficiente                  
                               Aadd( aR, {"35","489","004","N","Z",""                                                ,PADL(ALLTRIM(TRB->A1_DDDCOB),04,"0")})              //DDD do telefone do devedor
                               Aadd( aR, {"36","493","009","N","Z",""                                                ,PADL(ALLTRIM(TRB->A1_TELCOB),09,"0")})                //Número do telefone do devedor
                               Aadd( aR, {"37","502","008","N","Z",""                                                ,GravaData(TRB->E1_VENCREA,.F.,8)})                                  //Data do compromisso assumido pelo devedor - formato AAAAMMDD
                               Aadd( aR, {"38","510","015","N","Z",""                                                ,"" })                                                                                                                                    //Valor total do compromisso assumido pelo devedor, com 2 decimais, sem ponto e virgula.                 
                               Aadd( aR, {"39","525","009","" ," ",""                                                    ,Space(009)})                                                                                                  //Deixar em branco
                               Aadd( aR, {"40","534","060","X","Z",""                                                 ,Space(060)})                                                                                                  //Códigos de erros – 3 posições ocorrendo 20 vezes . Ausência de códigos indica que o registro foi aceito no movto de retorno . Na entrada , preencher com brancos.                              
                               Aadd( aR, {"41","594","007","N","Z","(1)(2)"                     ,PADL(ALLTRIM(STR(nSeqReg)),07,"0")})                   //Sequencia do registro no arquivo (1) (2)
                               
                               For i := 1 To Len(aR)
                                               If aR[i][4] =="N"
                                                               cR += PADL(aR[i][7],val(aR[i][3]),"0")
                                               Else
                                                               cR += PADR(aR[i][7],val(aR[i][3])," ")
                                               End
                               Next i
                               
                               GravaTxt(cR)     // Grava linha do header no arquivo 
                               cR           := ""
                               dbSelectArea("SE1")                     
                               dbSetOrder(1)
                               IF dbSeek(xFilial("SE1")+TRB->E1_CHAVE)
                               		RecLock( "SE1", .F. )
                                    If  _nTipo == 1
                                    	SE1->E1_STPEFIN := "I"
                                        SE1->E1_INPEFIN            := DATE()
                                        SE1->E1_INPFUSE := Upper(AllTrim(UsrRetName(__cUserID)))
                                    Else        
                                     	SE1->E1_STPEFIN := "E"
                                        SE1->E1_EXPEFIN           := DATE()
                                        SE1->E1_EXPFUSE := Upper(AllTrim(UsrRetName(__cUserID)))
                                    End                                                                                                      
                                    MsUnLock()                      
                               End                                                       
                               nSeqReg++
                End
                dbSelectArea("TRB")
                TRB->(dbSkip())
EndDo

Aadd( aT, {"01","001","001","N","Z","(1)(2)"                     ,"9"})                                                                                                                                  //"Código de registro - 9 – trailler (1) (2)
Aadd( aT, {"02","002","532","  ",""," "                                                   ,Space(532)})                                                                                                   //"Deixar em branco
Aadd( aT, {"03","534","060","X","Z",""                                                 ,Space(060)})                                                                                                   //"Códigos de erros – 3 posições ocorrendo 20 vezes. Ausência de códigos indica que o arquivo foi aceito no movimento de Retorno. Na entrada, preencher com brancos
Aadd( aT, {"04","594","007","N","Z","(1)(2)"                     ,PADL(ALLTRIM(STR(nSeqReg)),07,"0")})            //"Sequência do registro no arquivo (1) (2)

For i := 1 To Len(aT)
                If aT[i][4] =="N"
                               cT += PADL(aT[i][7],val(aT[i][3]),"0")
                Else
                               cT += PADR(aT[i][7],val(aT[i][3])," ")
                End
Next i

GravaTxt(cT)     // Grava linha do header no arquivo // Parei Aqui


/*
(1) Campos obrigatórios para inclusão
(2) Campos obrigatórios para exclusão
(3) Campos obrigatórios para inclusão do principal
(4) Campos obrigatórios para inclusão coobrigados
(5) Campos obrigatórios para exclusão do principal com seus coobrigados
(6) Campos obrigatórios para exclusão de coobrigados
(N) Campos Numéricos
(A) Campos alfabéticos
(X) Campos alfanuméricos
(Z) Campos zonados

Obs.1: Quando a natureza for DC , A data do término do contrato deverá ser a mesma da data da ocorrência.
Obs.2: No caso de natureza “DC” – Campos 439 a 442: Nº do Banco; Campos 443 a 446: Nº da Agência; Campos 447 a 452: Nº do Cheque e Campos 453 a 454: Nº da alínea – somente alínea 12,13 e 14 ( TODOS OS CAMPOS DEVERÃO SER ALINHADOS A DIREITA E PREENCHIDOS COM ZEROS A ESQUERDA ).
Obs.3: No caso de natureza “DC”, será anotado o Nº da conta corrente do inadimplente.
Obs.4 :CAMPO ALFANUMÉRICO , ZONADO, DEVENDO ACEITAR OS SEGUINTES CARACTERES
0 1 2 3 4 5 6 7 8 9
A B C D E F G H I J K L
M N O P Q R S T U V X Y ( letras de A a Z maiúsculas )
Z W / (barra) - (hifen) . (ponto) Espaço
*/
Alert("Fim do processamento.")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Valmir Belchior     º Data ³07/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcoes marca, desmarca, inverte e checa marcados           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChecaMark()
Local oMark := GetMarkBrow()
Local lRet            := .F.
DbSelectArea("TRB")
DbGotop()

While !Eof()
                //            IF RecLock( 'TRB', .F. )
                IF IsMark( 'E1_OK', cMark )
                               TRB->(DbGotop())
                               MarkBRefresh( )
                               // força o posicionamento do browse no primeiro registro
                               oMark:oBrowse:Gotop()
                               Return(lRet)
                End
                //  EndIf
                dbSkip()
Enddo

MsgStop("Nenhum titulo foi selecionado. Favor marcar os títulos que deverão compor o arquivo de instruções.")
lRet        := .T.
TRB->(DbGotop())
MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return(lRet)

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
// Grava marca no campo
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

User Function xMarka()
If IsMark( 'E1_OK', cMark )
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK With Space(2)
                MsUnLock()
Else
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK With cMark
                MsUnLock()
EndIf
Return

/*
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
// Grava marca no campo
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
*/      

User Function xMarkae()
If IsMark( 'E1_OK', cMark )
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK                    With Space(2)
                IF _nTipo == 2
                               Replace TRB->E1_MOTBX           With Space(2)
                End
                MsUnLock()
Else
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK                    With cMark
//            If _nTipo == 2    
//                           Replace TRB->E1_MOTBX           With LstBxMr2()
//            End        
                MsUnLock()
EndIf
Return
      
User Function xMarkax()
If IsMark( 'E1_OK', cMark )
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK                    With Space(2)
                Replace TRB->E1_MOTBX           With Space(2)
                MsUnLock()
                MarkBRefresh( )

Else
                RecLock( 'TRB', .F. )
                Replace TRB->E1_OK                    With cMark 
                Replace TRB->E1_MOTBX           With LstBxMr2()
                MsUnLock()
                MarkBRefresh( )
EndIf
Return

//////////////////////////////////////////////////////////////////
// Grava marca em todos os registros validos
//////////////////////////////////////////////////////////////////

User Function xMarkAll()
Local oMark := GetMarkBrow()

dbSelectArea('TRB')
dbGotop()
While !Eof()
                U_xMarka()
                dbSkip()
End
MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return


User Function xMarkAle()
Local oMark := GetMarkBrow()

dbSelectArea('TRB')
dbGotop()
While !Eof()
                IF TRB->E1_MOTBX $ "01#02" 
                               U_xMarkae()
                End
                dbSkip()
End
MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GravaTxt ³ Autor ³ Valmir Belchior       ³ Data ³ 11.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Texto com Base nas Informacoes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaTxt(cTexto)

FSeek(nHdl,0,FS_END)
cTexto += Chr(13)+Chr(10)
FWrite(nHdl, cTexto, Len(cTexto))

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GravaTxt ³ Autor ³ Valmir Belchior       ³ Data ³ 11.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Texto com Base nas Informacoes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LstBxMr2()

Local cVar     := ""
Local cTitulo  := "Motivos de baixa"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk1
Local oChk2
Local cSaldo 

Private oDlg
Private lChk1 := .F.
Private oLbx
Private aVetor:= {}
Private cRet  := ""

//+-------------------------------------+
//| Carrega o vetor conforme a motivos  |
//+-------------------------------------+

aAdd( aVetor, { lMark, "01","Pagamento da dívida"})
aAdd( aVetor, { lMark, "02","Renegociação da dívida"})
aAdd( aVetor, { lMark, "03","Por solicitação do cliente"})
aAdd( aVetor, { lMark, "04","Ordem judicial "})
aAdd( aVetor, { lMark, "05","Correção de endereço"})
aAdd( aVetor, { lMark, "06","Atualização do valor – valorização"})
aAdd( aVetor, { lMark, "07","Atualização do valor–pagamento parcial"})
aAdd( aVetor, { lMark, "08","Atualização de data"})
aAdd( aVetor, { lMark, "09","Correção do nome"})
aAdd( aVetor, { lMark, "10","Correção do número do contrato"})
aAdd( aVetor, { lMark, "11","Correção de varios dados (valor+datas+etc)"})
aAdd( aVetor, { lMark, "12","Baixa por perda de controle de base"})
aAdd( aVetor, { lMark, "13","Motivo não identificado"})
aAdd( aVetor, { lMark, "14","Pontualização da dívida"})
aAdd( aVetor, { lMark, "15","Baixa por concessão de crédito"})
aAdd( aVetor, { lMark, "16","Incorporação / mudança de titularidade"})
aAdd( aVetor, { lMark, "17","Comunicado devolvido dos correios"})
aAdd( aVetor, { lMark, "18","Correção de dados do coobrigado / avalista."})
aAdd( aVetor, { lMark, "19","Renegociação da dívida por acordo."})
aAdd( aVetor, { lMark, "20","Pagamento da dívida por pagamento bancário."})
aAdd( aVetor, { lMark, "21","Analise de documentos."})
aAdd( aVetor, { lMark, "22","Correção de dados pela loja / filial."})
aAdd( aVetor, { lMark, "23","Pagamento da dívida por emissão de Nota Promissória."})
aAdd( aVetor, { lMark, "24","Análise de documento por seguro."})
aAdd( aVetor, { lMark, "25","Devolução ou troca de bem financiado."})

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx FIELDS HEADER " ","Código Motivo","Motivo da Baixa"  SIZE 230,095 OF oDlg PIXEL ON dblClick( Marca() )
oLbx:SetArray( aVetor )
oLbx:bLine := {||{Iif(aVetor[oLbx:nat,01],oOk,oNo),;
                       aVetor[oLbx:nat,02],;
                       aVetor[oLbx:nat,03]}}           
@ 110,10 SAY "Somente será possível marcar um registro." SIZE 160,7 PIXEL OF oDlg

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION gravabx() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

Return(cRet)

Static Function gravabx()
Local i := 0

For i := 1 To Len(aVetor)
                IF aVetor[i][1] == .T.
                               cRet := aVetor[i][2]        
                End
Next i
oDlg:End()
Return(cRet)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxMark.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxMar()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que marca ou desmarca todos os objetos                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Marca()
Local i := 0
Local nPos := 0

nPos := AScan( aVetor, {|x| x[1] == .T. } )

If nPos == 0
                aVetor[ oLbx:nAt, 1 ] := .T.
Else
                If nPos == oLbx:nAt
                               aVetor[ nPos, 1 ] := ! aVetor[ nPos, 1 ]
                Else
                               aVetor[ nPos, 1 ] := .F.
                               aVetor[ oLbx:nAt, 1 ] := .T.
                Endif
Endif

oLbx:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XMotBx    ºAutor  ³Valmir Belchior     º Data ³06/05/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a geração de arquivo remessa de Pendencias Finanº±±
±±           ³ceiras do padrão PEFIN Serasa Experian "SERASA-CONVEM04"    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xMotBx()
Local cRet           := ""

IF TRB->E1_NSALDO == 0 .AND. (!Empty(TRB->E1_FATURA) .or. TRB->E1_VALLIQ > 0)
                cRet       := "02"
ElseIf TRB->E1_NSALDO == 0
                cRet       := "01"
End

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³checamBx   ºAutor  ³Valmir Belchior     º Data ³06/05/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a geração de arquivo remessa de Pendencias Finanº±±
±±           ³ceiras do padrão PEFIN Serasa Experian "SERASA-CONVEM04"    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChecamBx()
Local cRet           := ""
Local aArea := GetArea()

dbSelectArea("TRB")
dbgotop()

While TRB->(!Eof())
IF IsMark( 'E1_OK', cMark )
                IF Empty(TRB->E1_MOTBX)
                               Alert("Existe registros marcados sem o Motivo da baixa. Favor marcar novamente os itens sem Motivo da baixa e inclui-los.")
                               Return(1)
                End
End        
TRB->(dbSkip())
EndDo
                
RestArea(aArea)

Return()

User Function DesMar()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
	 IF RecLock( 'TRB', .F. )
	  TRB->E1_OK := SPACE(2)
	  MsUnLock()
	 EndIf
	 dbSkip()
	Enddo
	MarkBRefresh( )
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
Return