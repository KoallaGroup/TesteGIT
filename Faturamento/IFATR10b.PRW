#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IFATR10b  ºAutor  ³Alexandre Caetano   º Data ³  15/Dez/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime relatório crystal com os itens da lista de preço   º±±
±±º          ³ bike pesquisada pelo usuário                               º±±
±±º          ³ Relatório para Alteração de Preços - Bicicletas            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºInstruções³ A rotina gravará os dados do aCols na tabela PA7           º±±
±±º          ³ para a gravação ocorrer corretamente os campos do acols e  º±±
±±º          ³ da tabele PA7 devem ter a mesma ordem                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

x:="1;0;1;Relatório para Alteração de Preços - Bicicletas" 

CallCrys("IFATCR10B",cParms, x)

Return