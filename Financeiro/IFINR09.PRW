#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR09 | Autor: | Rog�rio Alves      | Data: | Junho/2014 |
+------------+--------+--------+--------------------+-------+------------+
| Descri��o: | Relat�rio de Resumo de Pagamento indicados				 |
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

/*Defini��o dos paramentos para o relat�rio com base nas perguntas da SX1.*/  

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

/*Defini��o das op��es para gera��o do relat�rio.*/
                                       
cOptions := "1;0;1;Pagamentos Indicados"

/*Chamada da fun��o .*/

CallCrys('IFINCR09', cParams,cOptions)

Return .T. 



/*
�������������������������������������������������������������������������Ĵ��
���SINTAXE DA�CALLCRYS(<creport>,<cparam>,<copcoes>) onde                 ���
���FUN��O    �<creport>= Nome do relat�rio Crystal,localizado no diret�rio���
���CALLCRYS  �          apontado por MV_CRYSTAL, sem a extens�o e path.   ���
���          �<cparam> = Par�metros passados para o Crystal, em vez de usar���
���          �          o SX1, separados por v�rgula ou ponto e v�rgula.  ���
���          �<copcoes>= Conjunto de op��es para nao mostrar a tela da    ���
���          �           SetPrint, composta por x;y;z;w, onde             ���
���          �                         x = v�deo(1) ou impressora(3)      ���
���          �                         y = Atualiza(0) ou n�o(1) os dados ���
���          �                         z = N�mero de c�pias               ���
���          �                         w = T�tulo do repo                 ���
��������������������������������������������������������������������������ٱ�
*/
