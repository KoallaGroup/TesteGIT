#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IFATR10b  �Autor  �Alexandre Caetano   � Data �  15/Dez/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime relat�rio crystal com os itens da lista de pre�o   ���
���          � bike pesquisada pelo usu�rio                               ���
���          � Relat�rio para Altera��o de Pre�os - Bicicletas            ���
�������������������������������������������������������������������������͹��
���Instru��es� A rotina gravar� os dados do aCols na tabela PA7           ���
���          � para a grava��o ocorrer corretamente os campos do acols e  ���
���          � da tabele PA7 devem ter a mesma ordem                      ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IFATR10b()

Local _aArea 	:= GetArea()
Local aCampos   := {}
Local cUseId	:= __cUserId
Local cQUERY	:= ""

chkFile("PA6")
chkFile("SX3")

IF TcCanOpen(RetSqlName("PA6"))
	cQuery := " DELETE "+RetSqlName("PA6")
	cQuery += " WHERE PA6_FILIAL = '"+xFilial("PA6")+"' "
	cQuery += " AND PA6_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
ENDIF

nDel	:= Len( aHeadsc ) + 1

SX3->( dbSetOrder(1) )
SX3->( dbSeek("PA6") )     

Do While SX3->( !EoF() ) .and.;
         SX3->X3_CAMPO = "PA6"
         
	aAdd(aCampos, SX3->X3_CAMPO)
	SX3->(dbSkip())
	
Enddo                                                                     

For  nI := 1 to Len( oBrw1:Acols ) 
	if !oBrw1:Acols[nI,nDel]
 		RecLock("PA6",.t.)        
 		nXx := 1
		For  nX := 2 to nDel                            			
			
			if aCampos[nX] = "PA6_MARCA"
				SZ5->(dbSeek( xFilial("SZ5") + oBrw1:Acols[nI,nXx] ) )
				cMarca := oBrw1:Acols[nI,nXx] + "-" + SZ5->Z5_DESC              
				PA6->(&(aCampos[nX])) := cMarca				
			Else
				PA6->(&(aCampos[nX])) := oBrw1:Acols[nI,nXx]					
			Endif
			
			nXx++
		Next nX
		
		PA6->PA6_USER	:= __cUserID
		PA6->PA6_DTREL	:= Date()

		PA6->( msUnLock() )
	Endif
Next nI

cParms := __cUserID + ";"
cParms += DTOS(date()) + ";"

x:="1;0;1;Relat�rio para Altera��o de Pre�os - Bicicletas" 

CallCrys("IFATCR10B",cParms, x)

Return