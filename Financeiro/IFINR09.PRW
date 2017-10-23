#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR09 | Autor: | Rogério Alves      | Data: | Junho/2014 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Resumo de Pagamento indicados				 |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------------------------------------------+
*/

User Function IFINR09()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cExcel	:= ""
Private cPerg 	:= PADR("IFINR09",Len(SX1->X1_GRUPO))
              
dbSelectArea("SEA")

Aadd(aPergs,{"Da Filial"		,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Filial"		,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","","ZZ"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Banco"			,"","","mv_ch3","C",TamSx3("EA_PORTADO")[1]	,0,0,"G","","MV_PAR03","","","",""		,"","","","","","","","","","","","","","","","","","","","","SA6"	,"","","",""})
Aadd(aPergs,{"Ate Banco"		,"","","mv_ch4","C",TamSx3("EA_PORTADO")[1]	,0,0,"G","","MV_PAR04","","","","ZZZ"	,"","","","","","","","","","","","","","","","","","","","","SA6"	,"","","",""})
Aadd(aPergs,{"Do Vencimento"	,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Vencimento"	,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Tipo"			,"","","mv_ch7","C",TamSx3("EA_MODELO")[1]	,0,0,"G","","MV_PAR07","","","",""		,"","","","","","","","","","","","","","","","","","","","","58"	,"","","",""})
Aadd(aPergs,{"Ate Tipo"			,"","","mv_ch8","C",TamSx3("EA_MODELO")[1]	,0,0,"G","","MV_PAR08","","","","ZZ"	,"","","","","","","","","","","","","","","","","","","","","58"	,"","","",""})
Aadd(aPergs,{"Do Bordero"		,"","","mv_ch9","C",TamSx3("EA_NUMBOR")[1]	,0,0,"G","","MV_PAR09","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Bordero"		,"","","mv_chA","C",TamSx3("EA_NUMBOR")[1]	,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

/*Definição dos paramentos para o relatório com base nas perguntas da SX1.*/  

cParams += MV_PAR01 		+ ";"
cParams += MV_PAR02 		+ ";"
cParams += MV_PAR03 		+ ";"
cParams += MV_PAR04 		+ ";"
cParams += DTOC(MV_PAR05) 	+ ";"
cParams += DTOC(MV_PAR06) 	+ ";"
cParams += MV_PAR07 		+ ";"
cParams += MV_PAR08 		+ ";"
cParams += MV_PAR09 		+ ";"
cParams += MV_PAR10

/*Definição das opções para geração do relatório.*/
                                       
cOptions := "1;0;1;Pagamentos Indicados"

/*Chamada da função .*/

CallCrys('IFINCR09', cParams,cOptions)

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
