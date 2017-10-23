#Include "Protheus.ch"
#Include "Fileio.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XPEFIN    �Autor  �Valmir Belchior     � Data �06/05/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para a gera��o de arquivo remessa de Pendencias Finan���
��           �ceiras do padr�o PEFIN Serasa Experian "SERASA-CONVEM04"    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcPefin �Autor  �Valmir Belchior     � Data �08/05/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para a gera��o de arquivo remessa de Pendencias Finan���
��           �ceiras do padr�o PEFIN Serasa Experian "SERASA-CONVEM04"    ���
�������������������������������������������������������������������������͹��
���Uso       �Bronzearte -                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Private cCadastro            := "Gera��o de Arquivo PEFIN 'SERASA-CONVEM04'"
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

//� Estrutura da tabela temporaria
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

// cria a tabela tempor�ria
_carq:="T_"+Criatrab(,.F.)
MsCreate(_carq,_astru,"DBFCDX")
Sleep(1000)

IIF(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
// atribui a tabela tempor�ria ao alias TRB
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
AADD(_afields,{"E1_HIST"     ,"","Hist�rico"                                         })
AADD(_afields,{"E1_NUMBCO"               ,"","Nosso Numero"      })
AADD(_afields,{"E1_PORTADO"              ,"","Banco"                                        })
AADD(_afields,{"E1_AGEDEP"  ,"","Agencia"                    })
AADD(_afields,{"E1_CONTA"    ,"","Conta Corrente"})
AADD(_afields,{"E1_NUMBOR"               ,"","Numero Border�"})
AADD(_afields,{"E1_DIAATRA" ,"","Dias Atraso"              })
AADD(_afields,{"E1_BAIXA"      ,"","Dt.Baixa"                    })

DbSelectArea("TRB")
DbGotop()

IF _nTipo == 1
                MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,'U_xMarkAll()'        ,,,,'U_xMarka()' ,{|| U_DESMAR()}        ,,,,,,,.F.) // MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,,,,,'U_xMarkax()',{|| U_xMarkAle()} ,,,,,,,.F.) //18-05-17 MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,'U_xMarkAll()'        ,,,,'U_xMarka()' ,{|| U_DESMAR()}        ,,,,,,,.F.)
Else
                MarkBrow( 'TRB', 'E1_OK',,_afields,, cMark,,,,,'U_xMarkax()',{|| U_xMarkAle()} ,,,,,,,.F.)
End

// apaga a tabela tempor�rio
MsErase(_carq+GetDBExtension(),,"DBFCDX")
TRB->(DbCloseArea())
TMP->(DbCloseArea())
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gerar �Autor  �Valmir Belchior                    � Data �03/11/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     �Insere novas perguntas ao sx1                               ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
// for�a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraPEFIN �Autor  �Valmir Belchior     � Data �13/05/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcoes Gera o arquivo REM para o PEFIN                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//                              Seq.  In�   Tam  AXN     ZPB                                                       Conteudo                                                                                                                                                        Descri��o
Aadd( aH, {"01","001","001","N","Z","(1)(2)"     ,"0"})                                                                                                                                                                 //"C�digo do registro = '0' (zero)"
Aadd( aH, {"02","002","009","N","Z","(1)(2)"     ,Substr(PADL(SM0->M0_CGC,15,"0"),1,9)})                      //"N�mero do CNPJ da institui��o informante ajustado � direita e preenchido com zeros � esquerda"
Aadd( aH, {"03","011","008","N","Z","(1)(2)"     ,GravaData(date(),.F.,8)})                                                                                         //"Data do movimento (AAAAMMDD) � data de gera��o doarquivo"
Aadd( aH, {"04","019","004","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_DDDPEFI")),04,"0")})       //"N�mero de DDD do telefone de contato da institui��o informante",
Aadd( aH, {"05","023","008","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_TELPEFI")),08,"0")})         //"N�mero do telefone de contato da institui��o informante)","(1) (2)"})
Aadd( aH, {"06","031","004","N","Z","(1)(2)"     ,PADL(ALLTRIM(GetMv("MV_RAMAPEF")),04,"0")})    //"N�mero de ramal do telefone de contato da institui��o informante","(1) (2)"})
Aadd( aH, {"07","035","070","A","Z","(1)(2)"     ,PADR((GetMv("MV_CONTPEF")),70," ")})                                        //"Nome do contato da institui��o informante","(1) (2)"})
Aadd( aH, {"08","105","015","X","Z","(1)(2)"      ,PADR("SERASA-CONVEM04",15," ")})                                                 //"Identifica��o do arquivo fixo 'SERASA-CONVEM04'","(1) (2)"})
Aadd( aH, {"09","120","006","N","Z","(1)(2)"     ,PADL(ALLTRIM(cSeqArq),06,"0")})                                                       //"N�mero da remessa do arquivo sequencial do 000001,incrementando de 1 a cada novo movimento","(1) (2)"})
Aadd( aH, {"10","126","001","A","Z","(1)(2)"     ,"E"})                                                                                                                                                                 //"C�digo de envio de arquivo = �E� ( ENTRADA) e �R� (RETORNO)","(1) (2)"})
Aadd( aH, {"11","127","004","X","Z","(1)(2)"      ,Space(004)})                                                                                                                                  //"Diferencial de remessa , caso a institui��o informante tenha necessidade de enviar mais de uma remessa independentes por deptos., no mesmo dia, de 0000 � 9999. Caso contr�rio, em branco","(1) (2)"})
Aadd( aH, {"12","131","403"," "," ",""                                   ,Space(403)})                                                                                                                                 //"Deixar em branco",""})
Aadd( aH, {"13","534","060","X","Z",""                                ,Space(060)})                                                                                                                                 //"C�digo de erros � 3 posi��es ocorrendo 20 vezes . Aus�ncia de c�digos indica que foi aceito no movimento de retorno . Na entrada, preencher com brancos",""})
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
                               //                              Seq.  In�   Tam  AXN     ZPB                                                                       Conteudo                                                                                                                                        Descri��o
                               Aadd( aR, {"01","001","001","N","Z","(1)(2)"                     ,"1"})                                   //C�digo do registro = '1' - Detalhes (1)(2)
                               Aadd( aR, {"02","002","001","A","Z","(1)(2)"                     ,Iif(_nTipo==1,"I","E")})					 //Aadd( aR, {"02","002","001","A","Z","(1)(2)"                     ,Alltrim(str(_nTipo))})                //C�digo da opera��o = I - inclus�o ; E �exclus�o (1)(2)
                               Aadd( aR, {"03","003","006","N","Z","(1)   "                        ,Subst(SM0->M0_CGC,10,6)})            //Filial e d�gito do CNPJ da contratante (1)
                               Aadd( aR, {"04","009","008","N","Z","(1)   "                        ,GravaData(TRB->E1_VENCREA,.F.,8)})   //Data da ocorr�ncia (AAAAMMDD) � data do vencimento da d�vida, n�o superior a 4 anos e 11 meses , e inferior � 4 dias da data do movimento (1)
                               Aadd( aR, {"05","017","008","N","Z","(1)   "                        ,GravaData(TRB->E1_VENCREA,.F.,8)})   //Data do t�rmino do contrato � formato �AAAAMMDD� . Caso n�o possua , repetir a data da ocorr�ncia ( vide observa��o 1 para natureza �DC� ) (1)
                               Aadd( aR, {"06","025","003","X","Z","(1)   "                        ,"DP "})                              //C�digo de natureza da opera��o (1)
                               Aadd( aR, {"07","028","004","A","Z",""                              ,Space(004)})       					 //C�digo da pra�a Embratel ( que originou a d�vida )
                               Aadd( aR, {"08","032","001","A","Z","(3)(4)(5)"                	   ,TRB->A1_PESSOA})                          //Tipo de pessoa do principal ; F�sica (F) ou Jur�dica( J ) (3)(4)(5)
                               Aadd( aR, {"09","033","001","X","Z","(3)(4 (5)"                	   ,Iif(TRB->A1_PESSOA=="F","1","2")})       //Tipo do primeiro docto. do principal :1-CNPJ ou 2-CPF(3)(4)(5)
                               Aadd( aR, {"10","034","015","N","Z","(2)(3)(4)(5)"          		   ,TRB->A1_CGC})                                //Primeiro documento do principal : CPF completo � base + d�gito ou CNPJ completo � base + filial + d�gito .Ajustado � direita e preenchido com zeros � esquerda(2)(3)(4)(5)
                               Aadd( aR, {"11","049","002","X","Z","(2)(5)"                        ,IF(_nTipo == 1,"  ",TRB->E1_MOTBX)})   //Motivo da baixa (2)(5)
                               /*
                               01 � pagamento da d�vida
                               02 � renegocia��o da d�vida
                               03 � por solicita��o do cliente
                               04 � ordem judicial valmir.b
                               05 � corre��o de endere�o
                               06 � atualiza��o do valor � valoriza��o
                               07 � atualiza��o do valor�pagamento parcial
                               08 � atualiza��o de data
                               09 � corre��o do nome
                               10 � corre��o do n�mero do contrato
                               11 � corre��o de varios dados (valor+datas+etc)
                               12 � baixa por perda de controle de base
                               13 � motivo n�o identificado
                               14 � pontualiza��o da d�vida
                               15 � baixa por concess�o de cr�dito
                               16 � incorpora��o / mudan�a de titularidade
                               17 � comunicado devolvido dos correios
                               18 � corre��o de dados do coobrigado / avalista.
                               19 � renegocia��o da d�vida por acordo.
                               20 � pagamento da d�vida por pagamento banc�rio.
                               21 � analise de documentos.
                               22 � corre��o de dados pela loja / filial.
                               23 � pagamento da d�vida por emiss�o de Nota Promiss�ria.
                               24 � an�lise de documento por seguro.
                               25 � devolu��o ou troca de bem financiado.
                               
                               Os motivos abaixo s�o de uso interno do sistema da SERASA, portanto n�o devem ser usados
                               
                               00 � motivo antes da implanta��o ( passado )
                               88 � Carta / Comprovante n�o retornado dos Correios
                               89 � Motivos diversos
                               90 � Falta documenta��o da d�vida
                               91 � contesta��o / declara��o do interessado
                               92 � aditivo contratual
                               93 � exclus�o por extin��o de contrato
                               94 � decurso � S�mula 13
                               95 � comunicado devolvido do correio
                               96 � determina��o judicial
                               97 � decurso do prazo
                               99 � motivo da baixa n�o informado
                               */
                               Aadd( aR, {"12","051","001","X","Z",""                                                 ,Space(001)})                                                                                                  //Tipo do segundo documento do principal : 3 � RG, se houver.Se n�o, espa�os (s� para pessoa f�sica )
                               Aadd( aR, {"13","052","015","X","Z",""                                                 ,Space(015)})                                                                                                  //Segundo documento do principal , se houver, se n�o, espa�os
                               Aadd( aR, {"14","067","002","A","Z",""                                                ,Space(002)})                                                                                                  //UF quando documento for RG , se n�o , espa�os. Para os campos abaixo , de Seq. 15 a 21, referentes ao coobrigado, se o registro for do principal, deixar em branco.
                               Aadd( aR, {"15","069","001","A","Z","(4)(6)"                     ,Space(001)})                                                                                                  //Tipo de pessoa do coobrigado : F�sica ( F) ou Jur�dica ( J ) (4)(6)
                               Aadd( aR, {"16","070","001","X","Z","(4)(6)"                      ,Space(001)})                                                                                                  //Tipo do primeiro documento do coobrigado (4) (6) 1 � CNPJ ou 2 � CPF
                               Aadd( aR, {"17","071","015","X","Z","(4)(6)"                      ,Space(015)})                                                                                                  //Primeiro documento do coobrigado : (4) (6) CPF completo - base + d�gito ou CNPJ completo - base + filial + d�gito , ajustado � direita e preenchido com zeros � esquerda
                               Aadd( aR, {"18","086","002","" ," ",""                                                    ,Space(002)})                                                                                                                  //Espa�os
                               Aadd( aR, {"19","088","001","X","Z",""                                                 ,Space(001)})                                                                                                  //Tipo do segundo documento do coobrigado : 3 � RG, se houver, se n�o, espa�os ( s� para pessoa f�sica )
                               Aadd( aR, {"20","089","015","X","Z",""                                                 ,Space(001)})                                                                                                  //Segundo documento do coobrigado, se houver, se n�o, espa�os
                               Aadd( aR, {"21","104","002","A","Z",""                                                ,Space(001)})                                                                                                  //Unidade da Federa��o, quando documento for RG, se n�o, espa�os
                               Aadd( aR, {"22","106","070","X","Z","(1)(4)(6)"                ,PADR(TRB->E1_NOMECLI,70," ")})                                        //Nome do devedor (1) (4) (6)
                               Aadd( aR, {"23","176","008","N","Z",""                                                ,Space(008)})                                                                                                  //A data do nascimento (AAAAMMDD) deve ser superior a 18 anos ( s� para pessoa f�sica ). Se n�o, colocar 00000000
                               Aadd( aR, {"24","184","070","X","Z",""                                                 ,Space(070)})                                                                                                  //Nome do pai. Caso n�o possua , brancos.
                               Aadd( aR, {"25","254","070","X","Z",""                                                 ,Space(070)})                                                                                                  //Nome da m�e. Caso n�o possua, brancos
                               Aadd( aR, {"26","324","045","X","Z","(1)"                                           ,PADR(SUBSTR(TRB->A1_ENDCOB,1,45),45," ")}) //Endere�o completo (rua, Av., n� etc.) (1)
                               Aadd( aR, {"27","369","020","X","Z","(1)"                                           ,PADR(TRB->A1_BAICOB,20," ")})                                          //Bairro correspondente (1)
                               Aadd( aR, {"28","389","025","X","Z","(1)"                                           ,PADR(TRB->A1_MUNCOB,25," ")})                                      //Munic�pio correspondente (1)
                               Aadd( aR, {"29","414","002","A","Z","(1)"                                           ,PADR(TRB->A1_ESTCOB,02," ")})                                          //Sigla Unidade Federativa (1)
                               Aadd( aR, {"30","416","008","N","Z","(1)"                                          ,PADL(TRB->A1_CEPCOB,08,"0")})                                         //C�digo de endere�amento postal completo (1)
                               Aadd( aR, {"31","424","015","N","Z","(1)"                                          ,STRZERO(ROUND(TRB->E1_NSALDO,2)*100,15) })         //Valor com 2 decimais, alinhar a direita com zeros a esquerda(1)
                               Aadd( aR, {"32","439","016","X","Z","(1)(2)"                      ,PADR(TRB->E1_CHAVE,16," ")})                                             //O n�mero do contrato deve ser �nico para o principal e seus coobrigados (vide observa��o 2 para natureza �DC� e observa��o 4 ) (1) (2)
                               Aadd( aR, {"33","455","009","N","Z",""                                                ,PADR(SUBSTR(TRB->E1_NUMBCO,01,09),09," ")})//Nosso n�mero ( Vide observa��o 3 para natureza "DC")
                               Aadd( aR, {"34","464","025","X","Z",""                                                 ,PADR(SUBSTR(TRB->A1_ENDCOB,45,25),25," ")})//Complemento do endere�o do devedor � usar somente quando o campo de seq. Nr.26 (endere�o completo) n�o for suficiente                  
                               Aadd( aR, {"35","489","004","N","Z",""                                                ,PADL(ALLTRIM(TRB->A1_DDDCOB),04,"0")})              //DDD do telefone do devedor
                               Aadd( aR, {"36","493","009","N","Z",""                                                ,PADL(ALLTRIM(TRB->A1_TELCOB),09,"0")})                //N�mero do telefone do devedor
                               Aadd( aR, {"37","502","008","N","Z",""                                                ,GravaData(TRB->E1_VENCREA,.F.,8)})                                  //Data do compromisso assumido pelo devedor - formato AAAAMMDD
                               Aadd( aR, {"38","510","015","N","Z",""                                                ,"" })                                                                                                                                    //Valor total do compromisso assumido pelo devedor, com 2 decimais, sem ponto e virgula.                 
                               Aadd( aR, {"39","525","009","" ," ",""                                                    ,Space(009)})                                                                                                  //Deixar em branco
                               Aadd( aR, {"40","534","060","X","Z",""                                                 ,Space(060)})                                                                                                  //C�digos de erros � 3 posi��es ocorrendo 20 vezes . Aus�ncia de c�digos indica que o registro foi aceito no movto de retorno . Na entrada , preencher com brancos.                              
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

Aadd( aT, {"01","001","001","N","Z","(1)(2)"                     ,"9"})                                                                                                                                  //"C�digo de registro - 9 � trailler (1) (2)
Aadd( aT, {"02","002","532","  ",""," "                                                   ,Space(532)})                                                                                                   //"Deixar em branco
Aadd( aT, {"03","534","060","X","Z",""                                                 ,Space(060)})                                                                                                   //"C�digos de erros � 3 posi��es ocorrendo 20 vezes. Aus�ncia de c�digos indica que o arquivo foi aceito no movimento de Retorno. Na entrada, preencher com brancos
Aadd( aT, {"04","594","007","N","Z","(1)(2)"                     ,PADL(ALLTRIM(STR(nSeqReg)),07,"0")})            //"Sequ�ncia do registro no arquivo (1) (2)

For i := 1 To Len(aT)
                If aT[i][4] =="N"
                               cT += PADL(aT[i][7],val(aT[i][3]),"0")
                Else
                               cT += PADR(aT[i][7],val(aT[i][3])," ")
                End
Next i

GravaTxt(cT)     // Grava linha do header no arquivo // Parei Aqui


/*
(1) Campos obrigat�rios para inclus�o
(2) Campos obrigat�rios para exclus�o
(3) Campos obrigat�rios para inclus�o do principal
(4) Campos obrigat�rios para inclus�o coobrigados
(5) Campos obrigat�rios para exclus�o do principal com seus coobrigados
(6) Campos obrigat�rios para exclus�o de coobrigados
(N) Campos Num�ricos
(A) Campos alfab�ticos
(X) Campos alfanum�ricos
(Z) Campos zonados

Obs.1: Quando a natureza for DC , A data do t�rmino do contrato dever� ser a mesma da data da ocorr�ncia.
Obs.2: No caso de natureza �DC� � Campos 439 a 442: N� do Banco; Campos 443 a 446: N� da Ag�ncia; Campos 447 a 452: N� do Cheque e Campos 453 a 454: N� da al�nea � somente al�nea 12,13 e 14 ( TODOS OS CAMPOS DEVER�O SER ALINHADOS A DIREITA E PREENCHIDOS COM ZEROS A ESQUERDA ).
Obs.3: No caso de natureza �DC�, ser� anotado o N� da conta corrente do inadimplente.
Obs.4 :CAMPO ALFANUM�RICO , ZONADO, DEVENDO ACEITAR OS SEGUINTES CARACTERES
0 1 2 3 4 5 6 7 8 9
A B C D E F G H I J K L
M N O P Q R S T U V X Y ( letras de A a Z mai�sculas )
Z W / (barra) - (hifen) . (ponto) Espa�o
*/
Alert("Fim do processamento.")

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �Valmir Belchior     � Data �07/11/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcoes marca, desmarca, inverte e checa marcados           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
                               // for�a o posicionamento do browse no primeiro registro
                               oMark:oBrowse:Gotop()
                               Return(lRet)
                End
                //  EndIf
                dbSkip()
Enddo

MsgStop("Nenhum titulo foi selecionado. Favor marcar os t�tulos que dever�o compor o arquivo de instru��es.")
lRet        := .T.
TRB->(DbGotop())
MarkBRefresh( )
// for�a o posicionamento do browse no primeiro registro
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
// for�a o posicionamento do browse no primeiro registro
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
// for�a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � GravaTxt � Autor � Valmir Belchior       � Data � 11.09.07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera Texto com Base nas Informacoes                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GravaTxt(cTexto)

FSeek(nHdl,0,FS_END)
cTexto += Chr(13)+Chr(10)
FWrite(nHdl, cTexto, Len(cTexto))

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � GravaTxt � Autor � Valmir Belchior       � Data � 11.09.07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera Texto com Base nas Informacoes                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

aAdd( aVetor, { lMark, "01","Pagamento da d�vida"})
aAdd( aVetor, { lMark, "02","Renegocia��o da d�vida"})
aAdd( aVetor, { lMark, "03","Por solicita��o do cliente"})
aAdd( aVetor, { lMark, "04","Ordem judicial "})
aAdd( aVetor, { lMark, "05","Corre��o de endere�o"})
aAdd( aVetor, { lMark, "06","Atualiza��o do valor � valoriza��o"})
aAdd( aVetor, { lMark, "07","Atualiza��o do valor�pagamento parcial"})
aAdd( aVetor, { lMark, "08","Atualiza��o de data"})
aAdd( aVetor, { lMark, "09","Corre��o do nome"})
aAdd( aVetor, { lMark, "10","Corre��o do n�mero do contrato"})
aAdd( aVetor, { lMark, "11","Corre��o de varios dados (valor+datas+etc)"})
aAdd( aVetor, { lMark, "12","Baixa por perda de controle de base"})
aAdd( aVetor, { lMark, "13","Motivo n�o identificado"})
aAdd( aVetor, { lMark, "14","Pontualiza��o da d�vida"})
aAdd( aVetor, { lMark, "15","Baixa por concess�o de cr�dito"})
aAdd( aVetor, { lMark, "16","Incorpora��o / mudan�a de titularidade"})
aAdd( aVetor, { lMark, "17","Comunicado devolvido dos correios"})
aAdd( aVetor, { lMark, "18","Corre��o de dados do coobrigado / avalista."})
aAdd( aVetor, { lMark, "19","Renegocia��o da d�vida por acordo."})
aAdd( aVetor, { lMark, "20","Pagamento da d�vida por pagamento banc�rio."})
aAdd( aVetor, { lMark, "21","Analise de documentos."})
aAdd( aVetor, { lMark, "22","Corre��o de dados pela loja / filial."})
aAdd( aVetor, { lMark, "23","Pagamento da d�vida por emiss�o de Nota Promiss�ria."})
aAdd( aVetor, { lMark, "24","An�lise de documento por seguro."})
aAdd( aVetor, { lMark, "25","Devolu��o ou troca de bem financiado."})

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx FIELDS HEADER " ","C�digo Motivo","Motivo da Baixa"  SIZE 230,095 OF oDlg PIXEL ON dblClick( Marca() )
oLbx:SetArray( aVetor )
oLbx:bLine := {||{Iif(aVetor[oLbx:nat,01],oOk,oNo),;
                       aVetor[oLbx:nat,02],;
                       aVetor[oLbx:nat,03]}}           
@ 110,10 SAY "Somente ser� poss�vel marcar um registro." SIZE 160,7 PIXEL OF oDlg

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XMotBx    �Autor  �Valmir Belchior     � Data �06/05/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para a gera��o de arquivo remessa de Pendencias Finan���
��           �ceiras do padr�o PEFIN Serasa Experian "SERASA-CONVEM04"    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �checamBx   �Autor  �Valmir Belchior     � Data �06/05/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para a gera��o de arquivo remessa de Pendencias Finan���
��           �ceiras do padr�o PEFIN Serasa Experian "SERASA-CONVEM04"    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	// for�a o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
Return