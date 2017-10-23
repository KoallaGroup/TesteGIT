#INCLUDE "rwmake.ch"

/*
+----------+---------+-------+-------------------------------------------+------+------------+
|Programa  | IFATA37 | Autor | Jorge Henrique Alves - Anadi Consultoria  | Data | Julho/2015 |
+----------+---------+-------+-------------------------------------------+------+------------+
|Descricao | Cadastro de produtos/grupos que entram no controle de armazéns                  | 
+----------+---------------------------------------------------------------------------------+
|Uso       | Isapa                                                                           |
+----------+---------------------------------------------------------------------------------+
*/

User Function IFATA37()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z08"

dbSelectArea("Z08")
dbSetOrder(1)

AxCadastro(cString,"Controle Armazens",cVldExc,cVldAlt)

Return
