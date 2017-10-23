#INCLUDE "PROTHEUS.CH"

/*
+------------+----------+--------+------------------------------+-------+-----------+
| Programa:  | IFATA01  | Autor: | Elias Santos - Anadi			| Data: | Jan/2014  |
+------------+----------+--------+------------------------------+-------+-----------+
| Descrição: | Cadastro Usuário X Segmento											|
+------------+----------------------------------------------------------------------+
| Uso:       | Isapa				    	                    			        |
+------------+----------------------------------------------------------------------+
*/

User Function IFATA01()

LOCAL cFiltro   := ""
PRIVATE cAlias   := 'SZ1'
PRIVATE cCadastro := "Usuários X Segmentos"
PRIVATE aRotina     := {{"Pesquisar" , "AxPesqui"         , 0, 1 },;
                        {"Visualizar" , "U_IFATA01V"   , 0, 2 },;
                        {"Incluir"       , "U_IFATA01I"   , 0, 3 },;
                        {"Alterar"      , "U_IFATA01A"   , 0, 4 },;
                        {"Excluir"      , "U_IFATA01D"   , 0, 5 }}

If !(Alltrim(Upper(cUserName)) $ Alltrim(Upper(GETMV("MV__USRSZI"))))
	MsgAlert("Usuário sem acesso para este cadastro.")
	Return
EndIf
 
dbSelectArea("SZ1")
dbSetOrder(1)

mBrowse( ,,,,"SZ1",,,,,,,,,,,,,,cFiltro)

Return    

User Function IFATA01V()

AxVisual("SZ1",SZ1->(RECNO()),1)

Return                                                                    

User Function IFATA01I()
Local cUsuarios  
Local cSeg, _cEnv := ""
Local aRet
Local aUsr
Local cDesc

If !Pergunte("IFATA01I")
	Return .f.
Endif 

MsAguarde({|| cUsuarios := u_IFATC01C("1")}, "Filtrando Usuarios...")                 
aRet := StrTokArr(cUsuarios,";")
aUsr := {}     

cSeg := MV_PAR01
DbSelectArea("SZ7")
DbSetOrder(1)
DbSeek(xFilial("SZ7") + cSeg)

cDesc := SZ7->Z7_DESCRIC

/*
IF (MV_PAR01=='1')
	//cSeg := "1"
	cDesc := xFilial("SZ7") + cSeg
ElseIf (MV_PAR01=='2')
	//cSeg := "2"
	cDesc := "Auto"
Else
	//cSeg := "0"
	cDesc := "Ambos"
EndIf
*/

For nx := 1 to Len(aRet)

    While !RecLock("SZ1",.T.)
    EndDo
    
    PswOrder(1)
    PswSeek(aRet[nx],.t.)
    aUsr := PswRet(1)
    
    SZ1->Z1_CODUSR  := aRet[nx]
    SZ1->Z1_USUARIO := aUsr[1,2]
    SZ1->Z1_NOMUSR  := aUsr[1,4]
    SZ1->Z1_SEGISP 	:= cSeg
    SZ1->Z1_DESCR 	:= cDesc
    SZ1->Z1_SEGTIP  := Alltrim(Str(mv_par02))
    SZ1->Z1_ENVWMS  := Alltrim(Str(mv_par03))
    MsUnlock()

Next 


Return .f.                                                              

User Function IFATA01A()

AxAltera("SZ1",SZ1->(Recno()),4)

Return .t.                        

User Function IFATA01D()


AxDeleta("SZ1", SZ1->(Recno()), 5)

Return  .t.


/*
+------------+----------+--------+------------------------------+-------+-----------+
| Programa:  | IFATC01C | Autor: | Elias Santos - Anadi			| Data: | Jan/2014  |
+------------+----------+--------+------------------------------+-------+-----------+
| Descrição: | Consulta padrão para Código e E-mail de Usuário						|
+------------+----------------------------------------------------------------------+
| Uso:       | Isapa				    	                    			        |
+------------+----------------------------------------------------------------------+
*/

User Function IFATC01C(_cTipo)
Local cTitulo := MvParDef := _cRet := _cOpc := "", nx := _nPCpo := _nPPar := _nPFor := _nLen := _nTam := 0, _aSep := {}, _aUsr := AllUsers(.f.,.t.)
Private _aRet := {}, _aCampos := {}
Default _cTipo := "1"                 

cTitulo := IIF(_cTipo == "1","Codigo Dos Usuarios","E-mail dos Usuarios")
_aSep := Separa(Alltrim(&(ReadVar())),";")

For nx := 1 To Len(_aUsr)

	//Usuário que já estão na SZ1 serão desconsiderados
	DbSelectArea("SZ1")
	DbSetOrder(1)
	If dbSeek(xFilial("SZ1") + _aUsr[nx][1][1]) //_aUsr[nx][1][17]
		Loop
	EndIf
	
	If _cTipo == "1" //Consulta que retorna o código do usuário
		If aScan(_aCampos,_aUsr[nx][1][1]) = 0 .And. aScan(_aSep,_aUsr[nx][1][1]) == 0
			AADD(_aCampos,_aUsr[nx][1][1] + " - " + Alltrim(_aUsr[nx][1][4]))
			_nTam := Len(_aUsr[nx][1][1]) + 1
		EndIf
	Else //Retorna o e-mail do usuário
		If aScan(_aCampos,Alltrim(_aUsr[nx][1][14])) = 0 .And. aScan(_aSep,Alltrim(_aUsr[nx][1][14])) == 0
			AADD(_aCampos,PADR(_aUsr[nx][1][14],30) + " - " + Alltrim(_aUsr[nx][1][4]))
			_nTam := 31
		EndIf	
	EndIf
	
Next nx


For nx := 1 To Len(_aCampos)
	MvParDef += SubStr(_aCampos[nx],1,_nTam)
Next

//Calcula quantos itens podem ser selecionados
//If (Round((Len(&(ReadVar())) / _nTam),0) - 1) > Len(_aCampos)
	_nLen := Len(_aCampos)
//Else
//	_nLen := (Round((Len(&(ReadVar())) / _nTam),0) - 1)
//EndIf
                                             
If f_Opcoes(@_aRet,cTitulo,_aCampos,MvParDef,Len(_aCampos),50,.f.,_nTam,_nLen,.t.,.f.,"",.f.,.f.,.t.) // Chama funcao f_Opcoes
	
	//Grava todos os registros marcados na variável
	For nx := 1 To Len(_aRet)
		_cRet += IIF(!Empty(_cRet),";" + Alltrim(_aRet[nx]),Alltrim(_aRet[nx]))
	Next

EndIf	

Return _cRet