
/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | IESTR07 | Autor: | Luis Carlos	     | Data: | Maio de 2015 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: |             													|
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function IESTR07()

Private cPerg 	:= "IESTCR02"

If !Pergunte (cPerg,.t.)
	Return
EndIf

cParams := MV_PAR01 		+ ";"		//Fornecedor De
cParams += MV_PAR02 		+ ";" 		//Fornecedor Ate
cParams += MV_PAR03 		+ ";"	
cParams += MV_PAR04			+ ";" 		
cParams += DTOS(MV_PAR05)	+ ";" 		//Emissao De
cParams += DTOS(MV_PAR06)	+ ";" 		//Emissao Ate
cParams += DTOS(MV_PAR07)	+ ";"		//Mes De
cParams += DTOS(MV_PAR08)	+ ";"		//Mes Ate
cParams += DTOS(MV_PAR09)	+ ";"		//Ano De
cParams += DTOS(MV_PAR10)	+ ";"		//Ano Ate
cParams += MV_PAR11 		//Segmento 

cOptions := "1;0;1;Relatório de Compras por Exportador"

CallCrys('IESTCR02',cParams,cOptions)	

Return .T. 