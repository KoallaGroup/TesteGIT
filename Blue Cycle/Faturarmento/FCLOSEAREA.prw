#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FCLOSEAREA
Função que verifica se arquivo ou tabela ja existe para nesse caso apaga-lo(a)

@author	Rodrigo Prates (DSM)
@since	28/12/2010
@param	pParTabe		Variavel com o nome da tabela que será verificada
@return
/*/
//-------------------------------------------------------------------
User Function FCLOSEAREA(pParTabe)
	If (Select(pParTabe) != 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe + GetDbExtension())
			fErase(pParTabe + GetDbExtension())
		EndIf
	EndIf
Return(Nil)