#INCLUDE "Protheus.ch"

/*
+-----------+---------+-------+-------------------------------------+------+----------------+
| Programa  | IFATA10 | Autor | Rubens Cruz	- Anadi Solu��es 		  | Data | Abril/2014	  |
+-----------+---------+-------+-------------------------------------+------+----------------+
| Descricao | Cadastro de Pendencias de Cliente											    			  |
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA													 					    					  |
+-----------+-------------------------------------------------------------------------------+
*/

User Function IFATA10()
Private cCadastro	:="Pendencias de Cliente"
Private cAlias1		:= "SZP"
Private cAlias2		:= "SZO"
Private aRotina		:= {}

aAdd( aRotina, {"Pesquisar"	, "AxPesqui" 	, 0, 1 })
aAdd( aRotina, {"Visualizar", "U_IFATA10A"	, 0, 2 })
aAdd( aRotina, {"Incluir"	, "U_IFATA10A"	, 0, 3 })
aAdd( aRotina, {"Alterar"	, "U_IFATA10A"	, 0, 4 })
aAdd( aRotina, {"Excluir"	, "U_IFATA10A"	, 0, 5 })

dbselectarea(cAlias1)
dbsetorder(1)
dbgotop()

mBrowse(,,,,cAlias1)

return

/*
+-----------+----------+-------+-------------------------------------+------+----------------+
| Programa  | IFATA10A | Autor | Rubens Cruz	- Anadi Solu��es 	 | Data | Abril/2014	 |
+-----------+----------+-------+-------------------------------------+------+----------------+
| Descricao | Inclusao, Gravacao ou Exclusao das pendencias de pedido		 			     |
+-----------+--------------------------------------------------------------------------------+
| Uso       | ISAPA													 					     |
+-----------+--------------------------------------------------------------------------------+
*/

User Function IFATA10A(cAlias,nRecno,nOpc)
Local i			:=0
Local cLinok 	:= "alwaystrue"
Local cTudook 	:= "alwaystrue"
Local cDelOk	:= "U_IFATA10E()"
Local nOpce 	:= nopc
Local nOpcg 	:= nopc
Local cFieldok 	:= "allwaystrue"
Local lVirtual 	:= .T.
Local nLinhas 	:= 99
Local nFreeze 	:= 0
Local lRet 		:= .T.
Local nReg		:=(cAlias1)->(Recno())
Local aSize 	:= MsAdvSize()
Local aObjects 	:= {}
Local aInfo		:= {}
Local aPosGet	:= {}
Local nGetLin	:= 0
Local aButtons  := {}
Local aPosKits	:= {}
Local cAtela	:= ""

Private oDlg
Private nFolder	:= 2
Private aCols := {}
Private aHeader := {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
Private aAlt := {}
Private aPosicoes := {}
Private aTELA[0][0] // Vari�veis que ser�o atualizadas pela Enchoice()
Private aGETS[0] // e utilizadas pela fun��o OBRIGATORIO()

AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
nGetLin := aPosObj[3,1]

Aadd(aPosicoes,{1,2})
Aadd(aPosicoes,{2,2})

//Criar as variaveis M->ZN_??? da tabela pai
Regtomemory(cAlias1,(nOpc==3))

//Criar as variaveis M->ZO_??? da tabela filho
Regtomemory(cAlias2,(nOpc==3))

//Criar o vetor aHeader, que eh o vetor que tem as caracteristicas para os campos da Getdados

aHeader:= {}
aCpoEnchoice := {}
aAltEnchoice :={}

dbselectarea("SX3")
dbsetorder(1)
dbseek(cAlias2)
while ! eof() .and. x3_arquivo == cAlias2
	if x3uso(x3_usado) .and. cnivel >= x3_nivel .and. x3_browse == 'S'
		aAdd(aHeader,{trim(x3_titulo),;
		x3_campo,;
		x3_picture,;
		x3_tamanho,;
		x3_decimal,;
		x3_valid,;
		x3_usado,;
		x3_tipo,;
		x3_arquivo,;
		x3_context,;
		X3_Cbox,;
		X3_relacao,;
		X3_when})
	endif
	dbskip()
enddo

dbseek(cAlias1)
while ! eof() .and. x3_arquivo == cAlias1
	if x3uso(x3_usado) .and. cnivel >= x3_nivel
		aAdd(aCpoEnchoice,x3_campo)                      
		aAdd(aAltEnchoice,x3_campo)
	endif
	dbskip()
enddo

//Criar o vetor aCols, que eh o vetor que tem os dados preenchidos pelo usuario, relacionado com o vetor aHeader

CriaCols(nOpc)

//Adicione posi��es dos campos da SX3 para a fun��o de Kits (ITMKA06)
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_ITEM" 	})) //Posicao do Item
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_CODPROD" 	})) //Posicao do Codigo do Item
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_DESITEM"  })) //Posicao da Descri��o do Item
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_QUANT" 	})) //Posicao da Quantidade do Item
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_QTDKIT" 	})) //Posicao da Quantidade do Kit
Aadd( aPosKits, ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_CODKIT" 	})) //Posicao do Codigo do Kit

//Adiciona bot�es nas acoes relacionadas da MSDIALOG
Aadd( aButtons, {"EDIT", { || U_ITMKA06(aPosKits[1],aPosKits[2],aPosKits[3],aPosKits[4],aPosKits[5],aPosKits[6]) },"Kit" } )
//ITMKA06(nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)



DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

oGetPV := MSMGet():New( cAlias1, nReg, nOpc, , , , , aPosObj[1],/*If(lGCT,aPedCpo[1],NIL)*/,3,,,"",,,,,cAtela)

oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudoOk,"+ZO_ITEM",.T.,,2/*nFreeze*/,,nLinhas,cFieldOk,,,cDelOk)
//oGetDados := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],GD_INSERT+GD_DELETE+GD_UPDATE,cLinOk,cTudoOk,"+ZO_ITEM",,2/*nFreeze*/,,,,cDelOk,,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||if(IFATA10V(),iif(nOPC == 3,u_IFATA10B(),iif(nOPC == 4,u_IFATA10C(),u_IFATA10D())),)/*,oDlg:End()*/},{||oDlg:End(),RollbackSx8()},,aButtons) CENTERED

return


Static function CriaCols(nOpc)
Local nQtdcpo := 0
Local i:= 0                                               
Local nCols := 0
nQtdcpo := len(aHeader)
aCols:= {}
aAlt := {}     

if('1' == '1','','')

if nOpc == 3
	aAdd(aCols,array(nQtdcpo+1))
	for i := 1 to nQtdcpo
		aCols[1,i] := Criavar(aHeader[i,2])
	next i
	aCols[1,nQtdcpo+1] := .F.
	aCols[1,1] := strzero(1,TAMSX3("ZO_ITEM")[1])
else
	dbselectarea(cAlias2)
	dbsetorder(1)
	dbseek(xfilial(cAlias2)+(cAlias1)->ZP_CODIGO)//CLI+(cAlias1)->ZP_LOJA+(cAlias1)->ZP_SEQ)
	while .not. eof() .and. (cAlias2)->ZO_filial+(cAlias2)->ZO_CODIGO == xfilial(cAlias2)+(cAlias1)->ZP_CODIGO
		
		aAdd(aCols,array(nQtdcpo+1))
		nCols++
		for i:= 1 to nQtdcpo
			if aHeader[i,10] <> "V"
				aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
			else
				aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
			endif
		next i
		aCols[nCols,nQtdcpo+1] := .F.
		aAdd(aAlt,Recno())
		dbselectarea(cAlias2)
		dbskip()
	enddo
endif

return


//Criando a fun��o GrvDados
//Rotina de Cadastro para a tabela SZ1
//Cadastro de Software.
//Fun��o GrvDados
//Descri��o Fun��o para incluir os dados na tabela Filho conforme o vetor aHeader e aCols e
//tamb�m incluir os dados na tabela Pai conforme as variaveis M->???

User Function IFATA10B()
Local bcampo := {|nfield| field(nfield) }
Local i:= 0
Local y:= 0
Local nItem :=0

procregua(len(aCols)+fCount())
dbselectarea(cAlias1)
Reclock(cAlias1,.T.)
for i:= 1 to fcount()
	incproc()
	if "FILIAL" $ fieldname(i)
		cAlias1->(Fieldput(i,xfilial(cAlias1)))
	else
		cAlias1->(Fieldput(i,M->&(EVAL(BCAMPO,i))))
	endif
next

Msunlock()
dbselectarea(cAlias2)
dbsetorder(1)
for i:=1 to len(aCols)
	incproc()
	if .not. aCols[i,len(aHeader)+1]
		Reclock(cAlias2,.T.)
		for y:= 1 to len(aHeader)
			cAlias2->(Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y]))
		next
		
		nItem++
		(cAlias2)->ZO_FILIAL  := xfilial(cAlias2)
		(cAlias2)->ZO_CODIGO  := (cAlias1)->ZP_CODIGO
		//		(cAlias2)->z3_item := strzero(nItem,2,0)
		Msunlock()
	endif
next

return

//Criando a fun��o AltDados


//Rotina de Cadastro para a tabela SZ1
//Cadastro de Software.
//Fun��o AltDados
//Descri��o Fun��o para incluir/alterar os dados na tabela Filho conforme o vetor aHeader e aCols e
//tamb�m incluir os dados na tabela Pai conforme as variaveis M->???

User Function IFATA10C()

//axAltera("SZF",SZF->(RECNO()),3,,,,,'lRet := .T.')

Local bcampo := { |nfield| field(nfield) }
Local i:= 0
Local y:= 0
Local nitem := 0
                                                                             
//Valida campos obrigatorios
//If ('1' == '1')
//	alert("Preencha todos os campos obrigatorios")
//	return
//EndIf

procregua(len(aCols)+fCount())
dbselectarea(cAlias1)
Reclock(cAlias1,.F.)
for i:= 1 to fcount()
	incproc()
	if "FILIAL" $ fieldname(i)
		Fieldput(i,xfilial(cAlias1))
	else
		Fieldput(i,M->&(EVAL(BCAMPO,i)))
	endif
next i

Msunlock()
dbselectarea(cAlias2)
dbsetorder(1)
nItem := len(aAlt)+1
for i:=1 to len(aCols)
	if i<=len(aAlt)
		dbgoto(aAlt[i])
		Reclock(cAlias2,.F.)
		if aCols[i,len(aHeader)+1]
			DbDelete()
		else
			for y:= 1 to len(aHeader)
				Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])
			next y
		endif
		Msunlock()
	else
		if ! aCols[i,len(aHeader)+1]
			Reclock(cAlias2,.T.)
			for y:= 1 to len(aHeader)
				Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])
			next y
			(cAlias2)->zo_filial  := xfilial(calias2)
			(cAlias2)->ZO_CODIGO  := (cAlias1)->ZP_CODIGO
//			(cAlias2)->ZO_LOJA    := (cAlias1)->ZP_LOJA
//			(cAlias2)->ZO_SEQ	  := (cAlias1)->ZP_SEQ
			Msunlock()
			nItem++
		endif
	endif
next i

return

//Criando a fun��o ExcluiDados

Static Function u_IFATA10D()

procregua(len(aCols)+1)

dbselectarea(cAlias2)
dbsetorder(1)
dbseek(xfilial(cAlias2)+(cAlias1)->ZP_CODIGO)//CLI+(cAlias1)->ZP_LOJA+(cAlias1)->ZP_SEQ)
while .not. eof() .and. (cAlias2)->ZO_filial+(cAlias2)->ZO_CODIGO == xfilial(cAlias2)+(cAlias1)->ZP_CODIGO
	incproc()
	Reclock(cAlias2,.F.)
	DbDelete()
	Msunlock()
	dbskip()
enddo

dbselectarea(cAlias1)
dbsetorder(1)
incproc()
Reclock(cAlias1,.F.)
DbDelete()
Msunlock()
return

/*
+-----------+----------+-------+-------------------------------------+------+----------------+
| Programa  | IFATA10E | Autor | Rubens Cruz	- Anadi Solu��es 	 | Data | Abril/2014	 |
+-----------+----------+-------+-------------------------------------+------+----------------+
| Descricao | Cadastro de Pendencias de Pedido											     |
+-----------+--------------------------------------------------------------------------------+
| Uso       | ISAPA													 					     |
+-----------+--------------------------------------------------------------------------------+
*/

User Function IFATA10E()
Local lRet 		:= .T.
Local nCodKit 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZO_CODKIT" 	}) //Posicao do Codigo do Kit

//Verifica se existe produto com kit
if(!Vazio(aCols[n][nCodKit]))
	for nX := 1 to len(aCols)
		if(!Vazio(aCols[nX][nCodKit]))
				aCols[nX][len(aCols[nx])] := .T.
		EndIf
	next nX
EndIf

Return lRet                                    


Static Function IFATA10V()           
Local lRet := .T.
             
IF Obrigatorio(aGets,aTela) /*Valida o cabecalho*/
	lRet := .F.
	oDlg:End()
EndIf

Return lRet
