#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | IFINA02 | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Fevereiro/2014|
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Geração automática de boletos por retorno do CNAB							   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/

User Function IFINA02   

LOCAL	aPergs		:= {}
Local 	_SE1		:= {}
Local	_aStru1		:= {}   
Local	cArqTrab 	:= ""
Local 	aCampos 	:= {}, _aStr := {}

PRIVATE lExec		:= .F., cIndexName := '', cIndexKey  := '', cFilter := '', cMarca := GetMark(), lInverte := .f.
Private titulo		:= "Impressao de Boleto com Codigo de Barras", cPerg := PADR("IFINA02",Len(SX1->X1_GRUPO))

If Select("_SE1") > 0
	DbSelectArea("_SE1")
	DbCloseArea()
EndIf

dbSelectArea("SE1")
	
Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch7","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_ch8","C",6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_ch9","C",2,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_cha","C",2,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chb","D",8,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_chc","D",8,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"% Multa","","","mv_chf","N",5,2,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"% Juros ao Dia","","","mv_chg","N",6,3,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)
	
If !Pergunte (cPerg,.t.)
	Return
EndIf
	
aTam := TamSX3("E1_OK")
AADD(_aStru1,{"E1_OK" 			,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_PREFIXO")
AADD(_aStru1,{"E1_PREFIXO" 		,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_NUM")
AADD(_aStru1,{"E1_NUM" 			,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_PARCELA")
AADD(_aStru1,{"E1_PARCELA"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_SALDO")
AADD(_aStru1,{"E1_SALDO" 		,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_TIPO")
AADD(_aStru1,{"E1_TIPO" 		,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_PORTADO")
AADD(_aStru1,{"E1_PORTADO"      ,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_AGEDEP")
AADD(_aStru1,{"E1_AGEDEP"      ,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_CONTA")
AADD(_aStru1,{"E1_CONTA"      ,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_EMISSAO")
AADD(_aStru1,{"E1_EMISSAO"  	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_VENCREA")
AADD(_aStru1,{"E1_VENCREA"   	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_CLIENTE")
AADD(_aStru1,{"E1_CLIENTE"      ,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E1_LOJA")
AADD(_aStru1,{"E1_LOJA"      	,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_NUMBCO")
AADD(_aStru1,{"E1_NUMBCO"      	,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_VALOR")
AADD(_aStru1,{"E1_VALOR"      	,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_NATUREZ")
AADD(_aStru1,{"E1_NATUREZ"      ,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("A1_NREDUZ")
AADD(_aStru1,{"A1_NREDUZ"      	,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_VENCTO")
AADD(_aStru1,{"E1_VENCTO"      	,aTam[3],aTam[1],aTam[2]}) 
aTam := TamSX3("E1_IDCNAB")
AADD(_aStru1,{"E1_IDCNAB"      	,aTam[3],aTam[1],aTam[2]}) 
	
cArqTrab := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,cArqTrab,"_SE1",.t.)
	
DbSelectArea("_SE1")
	
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

cFilter		:= "SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_SALDO, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_CLIENTE, E1_LOJA, E1_NUMBCO, CAST(E1_VALOR AS NUMERIC (16,2)) AS E1_VALOR, E1_NATUREZ, E1_VENCTO,E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_IDCNAB "
cFilter		+= 		"FROM " + RETSQLNAME("SE1") + " E1 "
cFilter		+= "WHERE E1_FILIAL = '"+xFilial("SE1")+"' And E1_SALDO > 0 And "
cFilter		+= 		"E1_PREFIXO BETWEEN '" + MV_PAR01 + "' And '" + MV_PAR02 + "' And "
cFilter		+= 		"E1_NUM BETWEEN '" + MV_PAR03 + "' And '" + MV_PAR04 + "' And "
cFilter		+= 		"E1_PARCELA BETWEEN '" + MV_PAR05 + "' And '" + MV_PAR06 + "' And "
cFilter		+= 		"E1_CLIENTE BETWEEN '" + MV_PAR07 + "' And '" + MV_PAR08 + "' And "
cFilter		+= 		"E1_LOJA BETWEEN '" + MV_PAR09 + "' And '"+MV_PAR10+"' And "
cFilter		+= 		"E1_EMISSAO BETWEEN '"+DTOS(mv_par11)+"' and '"+DTOS(mv_par12)+"' And "
cFilter		+= 		"E1_VENCREA BETWEEN '"+DTOS(mv_par13)+"' and '"+DTOS(mv_par14)+"' And "
cFilter		+= 		"E1_PORTADO <> '   ' And "
cFilter		+= 		"E1.D_E_L_E_T_ = ' ' "
cFilter		+= 		"ORDER BY E1_NUM DESC " 

TcQuery cFilter New Alias "TRB"
	
dbSelectArea("TRB")
dbGoTop()
	
While !Eof()
	
	While !RecLock("_SE1",.t.)
	Enddo
	_SE1->E1_NUM   		:= TRB->E1_NUM
	_SE1->E1_PREFIXO   	:= TRB->E1_PREFIXO
	_SE1->E1_PARCELA   	:= TRB->E1_PARCELA
	_SE1->E1_SALDO   	:= TRB->E1_SALDO
	_SE1->E1_TIPO   	:= TRB->E1_TIPO
	_SE1->E1_EMISSAO   	:= STOD(TRB->E1_EMISSAO)
	_SE1->E1_VENCTO   	:= STOD(TRB->E1_VENCTO)	
	_SE1->E1_VENCREA   	:= STOD(TRB->E1_VENCREA)
	_SE1->E1_CLIENTE   	:= TRB->E1_CLIENTE
	_SE1->E1_LOJA   	:= TRB->E1_LOJA
	_SE1->A1_NREDUZ   	:= Posicione('SA1',1,xFilial('SA1')+TRB->E1_CLIENTE+TRB->E1_LOJA,'A1_NREDUZ')
	_SE1->E1_NUMBCO   	:= TRB->E1_NUMBCO	
	_SE1->E1_VALOR   	:= TRB->E1_VALOR
	_SE1->E1_NATUREZ	:= TRB->E1_NATUREZ
	_SE1->E1_PORTADO	:= TRB->E1_PORTADO
	_SE1->E1_AGEDEP		:= TRB->E1_AGEDEP
	_SE1->E1_CONTA		:= TRB->E1_CONTA
	_SE1->E1_IDCNAB		:= TRB->E1_IDCNAB
	MsUnLock()
		
	DbSelectArea("TRB")
	DbSkip()
		
EndDo
	
AADD(aCampos,{"E1_OK"     	, "" ,"  "				, ""	})
AADD(aCampos,{"E1_NUM"    	, "" ,"No. Título" 		, "@!" 	})
AADD(aCampos,{"E1_PREFIXO"  , "" ,"Prefixo"	  		, "@!" 	})
AADD(aCampos,{"E1_PARCELA" 	, "" ,"Parcela"   		, "@!" 	})
AADD(aCampos,{"E1_VALOR" 	, "" ,"Vlr.Titulo" 		, "@E 9,999,999,999,999.99" })
AADD(aCampos,{"E1_TIPO"     , "" ,"Tipo"  			, "@!" 	})
AADD(aCampos,{"E1_EMISSAO" 	, "" ,"Dt Emissão"		, "@D" 	})
AADD(aCampos,{"E1_VENCTO" 	, "" ,"Vencimento"		, "@D" 	})
AADD(aCampos,{"E1_VENCREA"  , "" ,"Vencto real"		, "@D" 	})
AADD(aCampos,{"E1_CLIENTE"	, "" ,"Cliente"		  	, "@!" 	})
AADD(aCampos,{"E1_LOJA"	 	, "" ,"Loja"		  	, "@!" 	})
AADD(aCampos,{"A1_NREDUZ"	, "" ,"Nome Cliente"  	, "@!" 	})
AADD(aCampos,{"E1_NATUREZ"	, "" ,"Natureza"	  	, "@!" 	})

dbSelectArea("_SE1")
dbGoTop()

DEFINE MSDIALOG oDlg TITLE "Seleção dos títulos a serem impressos" From 0,0 To 350,800 PIXEL
		
//Cria a MsSelect
oMark := MsSelect():New("_SE1","E1_OK","",@aCampos,@lInverte,@cMarca,{0,1,150,400},,,,,)
oMark:oBrowse:lCanAllMark := .f.
		
DEFINE SBUTTON OBJECT oBtn2 FROM 157,300 TYPE 1  ENABLE OF oDlg ACTION (IFINA02M(),Close(oDlg))
DEFINE SBUTTON OBJECT oBtn3 FROM 157,340 TYPE 2  ENABLE OF oDlg ACTION (Close(oDlg))
		
//Exibe a Dialog
ACTIVATE MSDIALOG oDlg CENTERED 
	
dbGoTop()
	
_SE1->(DbCloseArea())

Return

/*
+-----------+----------+-------+-------------------------------------+------+----------------+
| Programa  | IFINA02M | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Fevereiro/2014 |
+-----------+----------+-------+-------------------------------------+------+----------------+
| Descricao | Gera os boletos de acordo com o banco vinculado ao titulo					     |
+-----------+--------------------------------------------------------------------------------+
| Uso       | ISAPA													 					     |
+-----------+--------------------------------------------------------------------------------+
*/

static Function  IFINA02M()

Local cPasta := cGetFile( , 'Salvar Boleto', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. )

If(Empty(cPasta))
	MsgInfo("Nenhuma pasta selecionada")
	Return
EndIf

DbSelectArea("_SE1")
dbGoTop()
ProcRegua(RecCount())
	
Do While !EOF()
	If (Marked("E1_OK") .AND. !Empty(E1_IDCNAB) )
		Do Case
			Case E1_PORTADO == '341' //Boletos do Itaú
				u_ifinr01(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '237' //Boletos do Bradesco
				u_ifinr02(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '001' //Boletos do Banco do Brasil
				u_ifinr03(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '655' //Boletos do Votorantim
				u_ifinr04(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '422' //Boletos do Safra
				u_ifinr05(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
			Case E1_PORTADO == '399' //Boletos do HSBC
				u_ifinr06(E1_PREFIXO,E1_PARCELA,E1_NUM,E1_CLIENTE,E1_LOJA,cPasta,E1_AGEDEP,E1_CONTA) 
		EndCase
			
	EndIf 
	
	DbSelectArea("_SE1")
	dbSkip()

EndDo


Return