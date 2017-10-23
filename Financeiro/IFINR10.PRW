#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR10 | Autor: | Rogério Alves      | Data: | Junho/2014 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Títulos Abertos por representante            |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------------------------------------------+
*/

User Function IFINR10()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cStaTit	:= ""
Local cLucPer	:= GetMv("MV__LUCPER")

Private cPerg 	:= PADR("IFINR10",Len(SX1->X1_GRUPO))

//		   "X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02","X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3","X1_PYME","X1_GRPSXG","X1_HELP","X1_PICTURE","X1_IDFIL"}
//                               1           ,2          ,3          ,4           ,5        ,6           ,7           ,8          ,9       ,10        ,11        ,12        ,13          ,14          ,15        ,16        ,17        ,18          ,19          ,20        ,21        ,22        ,23          ,24          ,25        ,26        ,27        ,28          ,29          ,30        ,31        ,32        ,33          ,34          ,35        ,36     ,37       ,38         ,39       ,40          ,41                                      

//            1                       2  3  4        5   6                       7 8  9  10  11        12            		13 14 15        16 17                   18 19 20 21 22              23 24 25 26 27 28 29 30 31 32 33 34 35 36       37 38 39 40
Aadd(aPergs,{"Data Referencia"		,"","","mv_ch1","D",08						,0,0,"G","","MV_PAR01",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Representante"		,"","","mv_ch2","C",TamSx3("A3_COD")[1]	    ,0,0,"G","","MV_PAR02",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Ate Representante"	,"","","mv_ch3","C",TamSx3("A3_COD")[1]	    ,0,0,"G","","MV_PAR03",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Do Supervisor"		,"","","mv_ch4","C",TamSx3("A3_COD")[1]	    ,0,0,"G","","MV_PAR04",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Ate Supervisor"		,"","","mv_ch5","C",TamSx3("A3_COD")[1]	    ,0,0,"G","","MV_PAR05",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Da Emissao"			,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Emissao"			,"","","mv_ch7","D",08						,0,0,"G","","MV_PAR07",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Vencimento"		,"","","mv_ch8","D",08						,0,0,"G","","MV_PAR08",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Vencimento"		,"","","mv_ch9","D",08						,0,0,"G","","MV_PAR09",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Da Filial Cobranca"	,"","","mv_chA","C",02						,0,0,"G","","MV_PAR10",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Ate Filial Cobranca"	,"","","mv_chB","C",02						,0,0,"G","","MV_PAR11",""					,"","","ZZ"		,"",""					,"","","","",""				,"","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Da Filial Emissao"	,"","","mv_chC","C",02						,0,0,"G","","MV_PAR12",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Ate Filial Emissao"	,"","","mv_chD","C",02						,0,0,"G","","MV_PAR13",""					,"","","ZZ"		,"",""					,"","","","",""				,"","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Segmento"				,"","","mv_chE","C",TamSx3("Z7_CODIGO")[1]  ,0,0,"C","","MV_PAR14",""					,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Status Título"		,"","","mv_chF","C",01	                    ,0,1,"C","","MV_PAR15","Todos"	  			,"","",""		,"","Lucros e Perdas"	,"","","","","Inegociáveis"	,"","","","","","","","","","","","","",""		,"","","",""})
//Aadd(aPergs,{"Status"				,"","","mv_chF","C",TamSx3("ZU_CODIGO")[1]  ,0,1,"C","","MV_PAR15",""			,"","",""		,"",""					,"","","","",""				,"","","","","","","","","","","","","","SZU_01","","","",""})
//Aadd(aPergs,{"Imprimir Excel"		,"","","mv_chG","C",01	                    ,0,1,"C","","MV_PAR16","Sim"		,"","",""		,"","Não"				,"","","","",""				,"","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

If MV_PAR15 == 1
	cStaTit := "TO"
ElseIf MV_PAR15 == 2
	cStaTit := "LP"	
ElseIf MV_PAR15 == 3
	cStaTit := "IN"		
Else
	cStaTit := "TO"	
EndIf

/*Definição dos paramentos para o relatório com base nas perguntas da SX1.*/  

cParams += DTOC(MV_PAR01)	+";"
cParams += MV_PAR02			+";"
cParams += MV_PAR03			+";"
cParams += MV_PAR04			+";"
cParams += MV_PAR05			+";"
cParams += DTOC(MV_PAR06)	+";"
cParams += DTOC(MV_PAR07)	+";"
cParams += DTOC(MV_PAR08)	+";"
cParams += DTOC(MV_PAR09)	+";"
cParams += MV_PAR10			+";"
cParams += MV_PAR11			+";"
cParams += MV_PAR12			+";"
cParams += MV_PAR13			+";"
cParams += MV_PAR14			+";"
cParams += cStaTit			+";"
cParams += cLucPer

/*Definição das opções para geração do relatório.*/
                                       
cOptions := "1;0;1;Titulos Abertos por Representante"

/*Chamada da função .*/

CallCrys('IFINCR10', cParams,cOptions)

Return .T.  

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE DA³CALLCRYS(<creport>,<cparam>,<copcoes>) onde                 ³±±
±±³FUN€ÇO    ³<creport>= Nome do relatório Crystal,localizado no diretório³±±
±±³CALLCRYS  ³          apontado por MV_CRYSTAL, sem a extensão e path.   ³±±
±±³          ³<cparam> = Parƒmetros passados para o Crystal, em vez de usar³±±
±±³          ³          o SX1, separados por vírgula ou ponto e vírgula.  ³±±
±±³          ³<copcoes>= Conjunto de opções para nao mostrar a tela da    ³±±
±±³          ³           SetPrint, composta por x;y;z;w, onde             ³±±
±±³          ³                         x = vídeo(1) ou impressora(3)      ³±±
±±³          ³                         y = Atualiza(0) ou não(1) os dados ³±±
±±³          ³                         z = Número de cópias               ³±±
±±³          ³                         w = Título do repo                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/ 