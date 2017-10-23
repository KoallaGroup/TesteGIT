#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "AP5MAIL.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSSP8   บ Autor ณMarco - PrimaInfo   บ Data ณ  07/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณaJUSTA MARCACOES IMPARES                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEstre                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AJUSSP8

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oLeTxt
Private cPerg := Padr("AJUSSP8",Len(SX1->X1_GRUPO))

ValidPerg()
Pergunte(cPerg,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 400,480 DIALOG oLeTxt TITLE OemToAnsi("Ajusta Marcacoes Impares SP8")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Activate Dialog oLeTxt Centered

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  08/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OkLeTxt

Processa({|| RunCont() },"Processando...")

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  08/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont


Local cQuery := ""

cQuery += " SELECT W.*"
cQuery += " ,(SELECT MAX(P8_HORA) FROM "+RetSQlName("SP8") + " WHERE D_E_L_E_T_ = ' ' AND P8_FILIAL = FILIAL AND P8_MAT = MAT AND P8_PAPONTA = PAPONTA AND P8_ORDEM = ORDEM AND P8_DATA = DATAMAX) HORAMAX"
cQuery += " FROM("
cQuery += " SELECT T.* "
cQuery += " ,(SELECT MAX(P8_DATA) FROM "+RetSQlName("SP8") + " WHERE D_E_L_E_T_ = ' ' AND P8_FILIAL = FILIAL AND P8_MAT = MAT AND P8_PAPONTA = PAPONTA AND P8_ORDEM = ORDEM) DATAMAX"
cQuery += " ,(SELECT MAX(P8_TPMARCA) FROM "+RetSQlName("SP8") + " WHERE D_E_L_E_T_ = ' ' AND P8_FILIAL = FILIAL AND P8_MAT = MAT AND P8_PAPONTA = PAPONTA AND P8_ORDEM = ORDEM) TPMARCAMAX"
cQuery += " ,(SELECT MAX(P8_DATAAPO) FROM "+RetSQlName("SP8") + " WHERE D_E_L_E_T_ = ' ' AND P8_FILIAL = FILIAL AND P8_MAT = MAT AND P8_PAPONTA = PAPONTA AND P8_ORDEM = ORDEM) DATAAPO"
cQuery += " FROM("
cQuery += " SELECT P8_FILIAL FILIAL,P8_MAT MAT,P8_PAPONTA PAPONTA,P8_ORDEM ORDEM,P8_CC CC,P8_TURNO TURNO,COUNT(*) NUMMARC"
cQuery += " FROM "+RetSQlName("SP8")
cQuery += " WHERE"
cQuery += " D_E_L_E_T_ = ' '"
cQuery += " AND P8_PAPONTA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'"
cQuery += " AND P8_FILIAL  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND P8_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND P8_TPMCREP <> 'D'"
cQuery += " GROUP BY P8_FILIAL,P8_MAT,P8_PAPONTA, P8_ORDEM, P8_CC,P8_TURNO"
cQuery += " HAVING COUNT(*) = 1 OR COUNT(*) = 3 OR COUNT(*) = 5 OR COUNT(*) = 7  OR COUNT(*) = 9  OR COUNT(*) = 11  OR COUNT(*) = 13  OR COUNT(*) = 15)T)W"
cQuery += " ORDER BY 1,2"

If Select("WSP8") > 0
	WSP8->(dbCloseArea())
Endif
TCQUERY cQuery ALIAS "WSP8" NEW

ProcRegua( WSP8->(RecCount()) )
While !WSP8->(EOF())
	IncProc("Processando: " + WSP8->FILIAL+"/"+WSP8->MAT)
	nHoraMax:= 0
	If WSP8->HORAMAX = 23.59
	   nHoraMax:= 0.00
	ElseIf WSP8->HORAMAX - INT(WSP8->HORAMAX) =0.59
	   nHoraMax:= INT(WSP8->HORAMAX) + 1
	Else   
	   nHoraMax:= WSP8->HORAMAX + 0.01
	ENDIF
	   	 
	dbSelectArea("SP8")
	RecLock("SP8",.T.)
	SP8->P8_FILIAL	:= WSP8->FILIAL
	SP8->P8_MAT		:= WSP8->MAT
	SP8->P8_DATA	:= IIF(WSP8->HORAMAX=23.59,Stod(WSP8->DATAMAX)+1,Stod(WSP8->DATAMAX))
	SP8->P8_HORA	:= nHoraMax
	SP8->P8_CC		:= WSP8->CC
	SP8->P8_ORDEM	:= WSP8->ORDEM
	SP8->P8_FLAG	:= "I"
	SP8->P8_APONTA	:= "N"	
	SP8->P8_TURNO	:= WSP8->TURNO
	SP8->P8_PAPONTA	:= WSP8->PAPONTA
	SP8->P8_DATAAPO := Stod(WSP8->DATAAPO)
	SP8->P8_TIPOREG := "I"
	SP8->P8_MOTIVRG := "AJUSTE MARCACAO IMPAR"
	SP8->P8_DATAALT := SP8->P8_DATA	
	SP8->P8_HORAALT := strTran(time(),":","")
	SP8->P8_USUARIO := __cUserID	
	SP8->(MsUnlock())
	WSP8->(dbSkip())
Enddo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP6 IDE            บ Data ณ  17/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function ValidPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
aAdd(aRegs,{ cPerg,'01','Date de   ?                  ','','','mv_ch1','D',08,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'','' })
aAdd(aRegs,{ cPerg,'02','Date Ate   ?                 ','','','mv_ch2','D',08,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'','' })
aAdd(aRegs,{ cPerg,'03','Filial De ?                  ','','','mv_ch3','C',08,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'04','Filial Ate ?                 ','','','mv_ch4','C',08,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'05','Matricula De ?               ','','','mv_ch5','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'06','Matricula Ate ?              ','','','mv_ch6','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return