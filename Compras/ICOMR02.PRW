#INCLUDE "PROTHEUS.CH"
#include "Rwmake.ch"
/*���������������������������������������������������������������������������
���Programa  �ICOMR02   � Autor � Marcelo H. Sanches    � Data �17/09/2014���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
���������������������������������������������������������������������������*/
User Function ICOMR02()
/**********************/
Local cTime:=Dtos(dDataBase)
Local aTabas:=;
{;
{"Bike",;
{"Produto",;
{"B1_COD","B1_DESC","B1__DESCP","B1__MARCA"},;
"SELECT B1_COD, B1_DESC, B1__DESCP, B1__MARCA FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1__SEGISP='1' ",;
"PRODUTO_"+cTime+".TXT";
},;
{"Marca",;
{"Z5_CODIGO","Z5_DESC"},;
"SELECT Z5_CODIGO, Z5_DESC FROM "+RetSqlName("SZ5")+" Z5 WHERE Z5.D_E_L_E_T_=' ' AND Z5.Z5_SEGISP='1' ",;
"MARCA_"+cTime+".TXT";
},;
{"Grupo_Categoria",;
{"Z8_COD","Z8_DESCRI"},;
"SELECT Z8_COD,Z8_DESCRI FROM "+RetSqlName("SZ8")+" Z8 WHERE Z8.D_E_L_E_T_=' ' AND Z8.Z8_SEGISP='1' ",;
"GRUPO_CATEGORIA"+cTime+".TXT";
},;
{"Itens_Categoria",;
{"Z9_COD","Z9_PRODUTO","B1_DESC"},;
"SELECT Z9_COD, Z9_PRODUTO, B1_DESC FROM "+RetSqlName("SB1")+" B1 LEFT OUTER JOIN "+RetSqlName("SZ9")+" Z9 ON B1.B1_FILIAL=Z9.Z9_FILIAL AND B1.B1_COD=Z9.Z9_PRODUTO AND Z9.D_E_L_E_T_=' ' WHERE B1.D_E_L_E_T_=' ' AND B1.B1__SEGISP='1' ",;
"ITENS_CATEGORIA"+cTime+".TXT";
};
},;
{"Auto",;
{"Produto",;
{"B1_COD","B1_DESC","B1__DESCP","B1__MARCA"},;
"SELECT B1_COD, B1_DESC, B1__DESCP, B1__MARCA FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1__SEGISP='2' ",;
"PRODUTO_"+cTime+".TXT";
},;
{"Montadora",;
{"Z5_CODIGO","Z5_DESC"},;
"SELECT Z5_CODIGO, Z5_DESC FROM "+RetSqlName("SZ5")+" Z5 WHERE Z5.D_E_L_E_T_=' ' AND Z5.Z5_SEGISP='2' ",;
"MONTADORA_"+cTime+".TXT";
},;
{"Marca",;
{"Z4_CODIGO","Z4_DESC"},;
"SELECT Z4_CODIGO, Z4_DESC FROM "+RetSqlName("SZ4")+" Z4 WHERE Z4.D_E_L_E_T_=' ' AND Z4.Z4_SEGISP='2' ",;
"MARCA_"+cTime+".TXT";
},;
{"Itens_Montadora",;
{"B1_COD","B1__MARCA"},;
"SELECT B1_COD, B1__MARCA FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1__SEGISP='2' ",;
"ITENS_MONTADORA_"+cTime+".TXT";
},;
{"Grupo_Categoria",;
{"Z8_COD","Z8_DESCRI"},;
"SELECT Z8_COD,Z8_DESCRI FROM "+RetSqlName("SZ8")+" Z8 WHERE Z8.D_E_L_E_T_=' ' AND Z8.Z8_SEGISP='2' ",;
"GRUPO_CATEGORIA"+cTime+".TXT";
},;
{"Itens_Categoria",;
{"Z9_COD","Z9_PRODUTO","B1_DESC"},;
"SELECT Z9_COD, Z9_PRODUTO, B1_DESC FROM "+RetSqlName("SB1")+" B1 LEFT OUTER JOIN "+RetSqlName("SZ9")+" Z9 ON B1.B1_FILIAL=Z9.Z9_FILIAL AND B1.B1_COD=Z9.Z9_PRODUTO AND Z9.D_E_L_E_T_=' ' WHERE B1.D_E_L_E_T_=' ' AND B1.B1__SEGISP='2' ",;
"ITENS_CATEGORIA"+cTime+".TXT";
};
};
}

Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local cPasta //:= cGetFile( , 'Salvar Boleto', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. )

Local _aArea   		:= {}
Local _aAlias  		:= {}
Local _cSeg			:= ""

Private nSegIsp	 := 0
Private oSegIsp
Private oGetTxt				// Dialog Principal
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private nMeter1	 := 0
Private nMeter2	 := 0
Private oMeter1
Private oMeter2
Private oArqAtu
Private cArqAtu:=Space(30)

_cSeg := U_AtuSeg()

DEFINE MSDIALOG oGetTxt TITLE "Gera��o de Arquivos TXT" FROM C(178),C(181) TO C(548),C(600) PIXEL 
If _cSeg == "A"
	@ C(050),C(085) TO C(080),C(135) LABEL "Segmento do usu�rio:" PIXEL OF oGetTxt COLOR CLR_RED PIXEL
	@ C(060),C(088) Radio oSegIsp Var nSegIsp:=1 	When .F. Items "Bikes","Autos" 3D Size C(040),C(010) PIXEL OF oGetTxt
ElseIf _cSeg == "B"
	@ C(050),C(085) TO C(080),C(135) LABEL "Segmento do usu�rio:" PIXEL OF oGetTxt COLOR CLR_RED PIXEL
	@ C(060),C(088) Radio oSegIsp Var nSegIsp:=2 	When .F. Items "Bikes","Autos" 3D Size C(040),C(010) PIXEL OF oGetTxt
ElseIf _cSeg == "C"
	@ C(050),C(085) TO C(080),C(135) LABEL "Usu�rio sem Cadastro" PIXEL OF oGetTxt COLOR CLR_RED PIXEL
	@ C(060),C(088) Radio oSegIsp Var nSegIsp:=0 	When .F. Items "Bikes","Autos" 3D Size C(040),C(010) PIXEL OF oGetTxt	
Else
	@ C(050),C(085) TO C(080),C(135) LABEL "Escolha o Segmento:" PIXEL OF oGetTxt COLOR CLR_RED PIXEL
	@ C(060),C(088) Radio oSegIsp Var nSegIsp 	When .T. Items "Bikes","Autos" 3D Size C(040),C(010) PIXEL OF oGetTxt
EndIf
DEFINE SBUTTON  FROM c(100),c(85) TYPE 13 ACTION (If(nSegIsp==0, MsgStop("Escolha uma op��o Autos ou Bikes para executar a gera��o de TXT"), Eval({||cPasta:=cGetFile(cMask,"Gerar TXT", 1, "", .f., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ), .f., .t.), If(Empty(cPasta), MsgInfo("Arquivo inv�lido"), Gera(cPasta,nSegIsp,aTabas))})) ) ENABLE OF oGetTxt PIXEL
DEFINE SBUTTON  FROM c(100),c(115) TYPE 2 ACTION oGetTxt:End() ENABLE OF oGetTxt PIXEL

@ C(135),C(020) Say "Gravando Arquivo:" Size C(055),C(010) COLOR CLR_RED PIXEL OF oGetTxt
@ C(132),C(060) MsGet oArqAtu Var cArqAtu When .f. Size C(100),C(010) COLOR CLR_BLACK PIXEL OF oGetTxt
oArqAtu:bWhen:={||cArqAtu:=Space(30)}

@ C(147),C(060) METER oMeter1 VAR nMeter1 Size C(100),C(020) PIXEL OF oGetTxt
@ C(160),C(060) METER oMeter2 VAR nMeter2 Size C(100),C(020) PIXEL OF oGetTxt


ACTIVATE MSDIALOG oGetTxt CENTERED

Return(.T.)

/*******************************/
Static Function Gera(_P1,_P2,_P3)
/*******************************/
Local nCtMt1:=0
Local nCtMt2:=0
Local nTotMt2:=0
Local aTotMt2:={}
Local lGer:=.f.
If MsgYesNo("Confirma gera��o dos arquivos TXT em "+_P1+" ?", "Confirma��o de processamento", .t.)
	For nX:=1 To Len(_P3)
		If nX=_P2
			nCtMt1:=0
			For nXX:=2 To Len( _P3[nX])
				DbUseArea(.t.,'TOPCONN', TcGenQry(,, SubStr(_P3[nX][nXX][3], 1, 7)+"COUNT(*) CNT "+SubStr(_P3[nX][nXX][3], At("FROM",_P3[nX][nXX][3]))), "Cnt")
				Aadd(aTotMt2, Cnt->Cnt)
				nTotMt2+=Cnt->Cnt
				Cnt->(DbCloseArea())
				
			Next
			
			oMeter1:Refresh()
			oMeter1:SetTotal(nTotMt2)
			For nXX:=2 To Len( _P3[nX])
				cArqAtu:=_P1+_P3[nX][nXX][4]
				oArqAtu:Refresh()
				If !File(cArqAtu) .Or. MsgYesNo("Arquivo "+cArqAtu+" J� existe !! Substituir ?", "Confirma substitui��o Arquivo", .t.)
					fErase(cArqAtu)
					lGer:=.t.
					nHdl:=FCreate(cArqAtu)
					DbUseArea(.t.,'TOPCONN', TcGenQry(,, _P3[nX][nXX][3]), "Exp")
					oMeter2:Refresh()
					oMeter2:SetTotal(aTotMt2[nXX-1])
					While !Exp->(Eof())
						oMeter1:Set(++nCtMt1)
						oMeter2:Set(++nCtMt2)
						oMeter1:Refresh()
						oMeter2:Refresh()
						cLin:=""
						For nXXX:=1 To Len(_P3[nX][nXX][2])
							FWrite(nHdl,AllTrim(Exp->&(_P3[nX][nXX][2][nXXX]))+";"	)
							
						Next
						
						FWrite(nHdl,chr(13)+Chr(10))
						Exp->(DbSkip())
						
					EndDo
					
					FClose(nHdl)
					Exp->(DbCloseArea())
					
				EndIf
				
			Next nXX
			
		EndIf
		
	Next nX
	
EndIf

If lGer
	MsgInfo("Arquivos gerados em "+_P1+" com sucesso!", "Arquivos gravados")
	
Else
	MsgInfo("Arquivos N�O gerados em "+_P1+" com sucesso!", "Verifique os Parametros")
	
EndIf

oMeter1:Set(0)
oMeter2:Set(0)
oMeter1:Refresh()
oMeter2:Refresh()

Return .t.

/*********************/
Static Function C(nTam)
/*********************/
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

/*
Monte uma tela onde o usu�rio vai informar o segmento (ou auto ou bike) e o local onde os arquivos devem ser salvos.
No que ele der OK para processar, ser�o gerados os seguintes arquivos:

Se for segmento AUTO
PRODUTO (todos os produtos do segmento auto que n�o estejam bloqueados). Ser� necess�rio criar um campo chamado B1__FOTO, caracter, tamanho 20
Campos Codigo do produto, Descri��o, Composi��o (Vir� do B5_CEME),c�digo da marca e c�digo da foto (B1__FOTO)

MONTADORA (Refere-se ao cadastro de marcas do Protheus)
Campos c�digo e descri��o

MARCA (refere-se ao cadastro de subgrupo do Protheus)
Campo c�digo e descri��o

ITENS MONTADORA (Refere-se a qual montadora (B1__MARCA) o produto est� vinculado)
Campos c�digo do produto e c�digo da montadora

GRUPO_CATEGORIA (cadastro de identifica��es � tabela SZ8)
Campos c�digo e descri��o

ITENS_CATEGORIA (produtos do cadastro de identifica��es � tabela SZ9)
Campo c�digo identifica��o, c�digo produto, descri��o produto


Se for segmento BIKE
Segue a mesma coisa a �nica diferen�a � que s�o menos arquivos (conforme anexo). E para Bike, onde o arquivo se refere a MARCA � o cadastro de Marcas do Protheus mesmo. Cada segmento trabalha com um conceito. As colunas dos arquivos s�o as mesmas.

*Existem campos que no Protheus estar�o em branco, porque ainda faremos nova carga de dados.
*Para todos os campos, utilizar ALLTRIM
*Listar apenas o que se refere ao segmento escolhido
*O nome do arquivo deve seguir a mesma logica dos exemplos anexo (NOME_DATAGERACAOARQUIVO.TXT)
*Enquanto estiver gerando o arquivo, mostrar a tela de processamento (PROCREGUA ou PROCESSA) informando que est� gerando o arquivo de produto, depois gerando arquivo de marcas...s� pro usu�rio saber o que est� sendo gerado.
*Caso a grava��o no diret�rio n�o seja feita com sucesso, informar ao usu�rio e abortar a opera��o.


Abaixo o print da tela que eles possuem hoje. No ERP atual da Isapa, conforme os arquivos s�o gerados aparece um CHECKED ao lado no nome do arquivo...por isso que pedi para voc� utilizar o processa.
*/


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Junho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Bloqueio dos campos de Segmento de acordo com o do usu�rio                      |
|-----------------------------------------------------------------------------------------------|
*/

User Function AtuSeg()

Local _aArea 	:= getArea()
Local _lRet		:= ""

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	If Alltrim(SZ1->Z1_SEGISP) == "1"
		_lRet := "A"
	ElseIf Alltrim(SZ1->Z1_SEGISP) == "2"
		_lRet := "B"
	Endif
Else
	MsgAlert("USU�RIO N�O CADASTRADO NA TABELA DE USUARIO X SEGMENTO","Atencao!")
	_lRet := "C"	
EndIf

restarea(_aArea)

Return _lRet
