#INCLUDE "RWMAKE.CH"

/*/
Cria arquivo de trabalho com titulos a receber em atraso
Permite a marcacao dos mesmos e envio de email para os clientes
Nilza
28/03/2016
/*/       
                                      
****************************
User Function COB_MAIL()
****************************

Local aCpos := {{ "OK"     		,"C",  2, 0 },;
      			{ "E1_NOMCLI"	,"C", 20, 0 },;
				{ "E1_CLIENTE"  ,"C", 10, 0 },;
				{ "E1_PREFIXO"	,"C", 03, 0 },;
				{ "E1_NUM"		,"C", 09, 0 },;
				{ "E1_PARCELA"	,"C", 03, 0 },;
				{ "E1_EMISSAO"  ,"D", 08, 0 },;
				{ "E1_VENCREA"	,"D", 08, 0 },;
				{ "E1_SALDO"	,"N", 15, 2 },;                                                                         		
				{ "E1_HIST"		,"C", 65, 0 },;
				{ "A1_EMAIL"	,"C", 50, 0 } }                                                                         		


Local aCampos := {{ "OK"     	,,  "Sel" 				},;
      			{ "E1_NOMCLI"	,,  "Nome Cliente" 		},;
				{ "E1_CLIENTE"  ,,  "Codigo/lj cliente"	},;
				{ "E1_PREFIXO"	,,  "Prefixo"  			},;
				{ "E1_NUM"		,,  "Documento" 		},;
				{ "E1_PARCELA"	,,  "Parcela" 			},;
				{ "E1_EMISSAO"  ,,  "Emissao" 			},;
				{ "E1_VENCREA"	,,  "Vencimento" 		},;
				{ "E1_SALDO"	,,  "Saldo", "@E 999,999,999.99" 		},;                                                                         		
				{ "E1_HIST"		,,  "Historico" 		},;
				{ "A1_EMAIL"	,,  "e-mail" 		} } 

Local oMark
Local obs
Local cNomtrb  := CriaTrab(aCpos)

Private cCadastro := "TITULOS EM ATRASO"
Private aRotina	  := { { "Envia e-mail", 'ExecBlock("_COB_MAIL")', 3, } }
Private cMarca    := GetMark()

dbUseArea( .T.,,cNomTrb,"TRB",.F. )

//Cria arquivo de trabalho
dbSelectArea("SE1")
dbSetOrder(1)
if rddname()=="TOPCONN"
	cChave := "E1_NUM"
	dbSelectArea("SE1")
	aStru := dbStruct()
	nIndex := RetIndex("SE1")
	dbSetOrder(nIndex + 1)
		
	cOrder := SqlOrder(cChave)
	cQuery := " SELECT * "
    cQuery := cQuery +" FROM " + RetSqlName("SE1") + " SE1 "
    cQuery := cQuery +" WHERE "  //SE1.E1_FILIAL = '" + xFilial("SE1") + "'" + " AND "
    cQuery := cQuery +" D_E_L_E_T_ <> '*' AND E1_SALDO <> '0' AND E1_TIPO = 'NF' "
    cQuery := cQuery +" AND E1_VENCREA < '"+DTOS(DDATABASE)+"' AND E1_CLIENTE NOT LIKE '9%' "
    cQuery := cQuery +" ORDER BY E1_CLIENTE,E1_LOJA, E1_NUM, E1_PARCELA, E1_VENCREA " //+ cOrder
	cQuery := ChangeQuery(cQuery)
	If Select("TSE1") > 0
		dbSelectArea("TSE1")
		dbCloseArea()
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSE1', .T., .T.)
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('TSE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	dbSelectArea("TSE1")
	ProcRegua(RecCount())
	dbGotop()
	
	While !Eof()
	    IncProc("Gerando arquivo de trabalho!")
	
		dbSelectArea("TRB")
		RecLock("TRB",.t.)
		Replace E1_NOMCLI	With TSE1->E1_NOMCLI
		Replace E1_CLIENTE	With TSE1->E1_CLIENTE +  TSE1->E1_LOJA 
		Replace E1_PREFIXO	With TSE1->E1_PREFIXO
		Replace E1_NUM		With TSE1->E1_NUM
		Replace E1_PARCELA	With TSE1->E1_PARCELA
		Replace E1_EMISSAO	With TSE1->E1_EMISSAO
		Replace E1_VENCREA	With TSE1->E1_VENCREA
		Replace E1_SALDO	With TSE1->E1_SALDO                                                           		
		Replace E1_HIST		With TSE1->E1_HIST 		
		Replace A1_EMAIL	With POSICIONE("SA1",1,xFilial("SA1")+TSE1->E1_CLIENTE+TSE1->E1_LOJA,"A1_EMAIL")                                                           		
		MsUnlock()
		dbSelectArea("TSE1")
		dbSkip()
	End
Endif

DbSelectArea("TRB")
DbGoTop()


MarkBrow("TRB","OK",,aCampos,,cMarca,'U__MAlTRB2(cMarca)',,,, 'U__MTRB2(cMarca)') 

DbSelectArea("TRB")
DbCloseArea()
Ferase(cNomtrb+".dbf")

Return()


// Grava marca no campo
****************************
User Function _MTRB2(cMarca)
****************************
RecLock('TRB', .F. )
OK := iif(IsMark('OK',cMarca),Space(2),cMarca)
MsUnLock()
Return(Nil)


// Grava marca em todos os registros validos
*****************************
User Function _MAlTRB2(cMarca)
*****************************
Local nRecno := Recno()
dbSelectArea('TRB')
dbGotop()
while !Eof()
	U__MTRB2(cMarca)
	dbSkip()
EndDo
DbGoto( nRecno )
Return(Nil)


// Funcao de envio de email
****************************
User Function _COB_MAIL()
****************************
 
contm := 0
 
DbSelectArea("TRB")
DbGoTop()
Do While !Eof()
	
	If IsMark('OK',cMarca)
		contm++
	Endif
	DbSkip()
	
Enddo

IF(contm = 0)
	APMsgStop("Nenhum documento Foi Selecionado","AVISO")
	Return
//elseif(contm > 1)
//	APMsgStop("Permitido Apenas A Seleção de um Cliente Por Vez","AVISO")
//	Return
endif

DbSelectArea("TRB")
DbGoTop()

Do While !Eof()
	
	If IsMark('OK',cMarca)
		//Alert("Enviar email")
        u_EnvEmail()
	Endif	
	DbSelectArea("TRB")
	DbSkip()
	
EndDo

DbSelectArea("TRB")
DbGoTop()
Do While !Eof()
	RecLock("TRB",.F.)
	OK := "  "
	msUnLock()
	DbSkip()
EndDo
DbGoTop()

Return(.T.)



/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array da Função PutSX1                  ³
//³01 - X1_GRUPO         19 - X1_DEFENG1   ³
//³02 - X1_ORDEM         20 - X1_CNT01     ³
//³03 - X1_PERGUNT       21 - X1_DEF02     ³
//³04 - X1_PERSPA        22 - X1_DEFSPA2   ³
//³05 - X1_PERENG        23 - X1_DEFENG2   ³
//³06 - X1_VARIAVL       24 - X1_DEF03     ³
//³07 - X1_TIPO          25 - X1_DEFSPA3   ³
//³08 - X1_TAMANHO       26 - X1_DEFENG3   ³
//³09 - X1_DECIMAL       27 - X1_DEF04     ³
//³10 - X1_PRESEL        28 - X1_DEFSPA4   ³
//³11 - X1_GSC           29 - X1_DEFENG4   ³
//³12 - X1_VALID         30 - X1_DEF05     ³
//³13 - X1_F3            31 - X1_DEFSPA5   ³
//³14 - X1_GRPSXG        32 - X1_DEFENG5   ³
//³15 - X1_PYME          33 - HelpPort {}  ³
//³16 - X1_VAR01         34 - HelpEsp  {}  ³
//³17 - X1_DEF01         35 - HelpEng  {}  ³
//³18 - X1_DEFSPA1       36 - X1_HELP      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
****************************
Static Function fRetav1(cPerg)
****************************
//     01     02   03                 04                 05                 06         07  08 09 10 11  12                                      13   14 15 16         17               18 19  20     21           22 23 24              25 26  27      28 29 30 31 32 33      34 35 36

PutSx1(cPerg,"01","Emissao de ?"    ,"Emissao de ?"    ,"Emissao de ?"    ,"mv_ch1"  ,"D",08,00,00,"G",""                                   ,"SB1","","","mv_par01",""              ,"","",""    ,""          ,"","",""             ,"","",""     ,"","","","","",       ,  ,  ,"")
PutSx1(cPerg,"02","Emissao ate ?"   ,"Emissao ate ?"   ,"Emissao ate ?"   ,"mv_ch2"  ,"D",08,00,00,"G","NaoVazio"                           ,"SB1","","","mv_par02",""              ,"","",""    ,""          ,"","",""             ,"","",""     ,"","","","","",       ,  ,  ,"")

Return(Nil)




