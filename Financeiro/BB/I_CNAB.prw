#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+--------+--------+-----------------+-----+--------------+
| Programa:  | I_CNAB | Autor: | 				 |Data:|        /     |
+------------+--------+--+-----+-----------------+-----+--------------+
| Descrição: |                                                        |
+------------+--------------------------------------------------------+
| Uso:       | Isapa 		                                          |
+------------+--------------------------------------------------------+
*/

User Function I_CNAB

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea 	:= GetArea()
Local _vPreDOC  := ''
Local DOC_TED 	:= ''
Local _Val      := 0

If SE2->E2_FORBCO == '001'
   _vPreDoc := '000'

If SEA->EA_MODELO == '03' 
	If _Val <= 4999.99
		_vPreDoc := '700'
	Else
		_vPreDoc := '018'
	Endif
ElseIf SEA->EA_MODELO $ '41/43'
	   _vPreDoc := '018'
Endif					    
	 
RestArea(_aArea)

Return(_vPreDoc)
                                                                
