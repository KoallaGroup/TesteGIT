#include "rwmake.ch" 

User Function TIRAFLAG()

/*

NILZA MEN - QSDOBRASIL
22/02/16
ESTE PROGRAMA PERMITE QUE O FLAG CONTABIL DA NF DE ENTRADA SEJA LIMPO PARA QUE A NF SEJA CONTABILIZADA NOVAMENTE

*/  

cString   := "SF1"
cCadastro := "Tira flag de contabilizacao NF entrada"
aRotina   := { { "Pesquisa" , "AxPesqui", 0 , 1 } ,;
               { "Visualiza", "AxVisual", 0 , 2 } ,;
               { "Tira Flag", 'ExecBlock("M2atuc1a")', 0 , 3 } }

dbSelectArea("SF1")
dbSetOrder(1)
aCampos := { {"Data Contabil.","F1_DTLANC"} } 

mBrowse( 6,1,22,75,cString,aCampos)

Return

       
User Function M2atuc1a()

/*
*/  

_dDataAnt := SF1->F1_DTLANC

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Tira flag Contabil"
@ 8,10 TO 84,222
@ 23,14  SAY "NF"
@ 23,64  SAY "Emissao"
@ 23,114 SAY "Fornecedor"
@ 23,164 SAY "Data Cont."

@ 33,14  GET SF1->F1_DOC     when .f. Size 50,20
@ 33,64  GET SF1->F1_EMISSAO when .f. Size 50,20
@ 33,114 GET SF1->F1_FORNECE when .f. Size 50,20
@ 33,164 GET _dDataAnt       when .t. Size 50,20

@ 50,75  BMPBUTTON TYPE 1 ACTION OkProc()
@ 50,130 BMPBUTTON TYPE 2 ACTION Close(oDlg5)

ACTIVATE DIALOG oDlg5

Static Function OkProc()
              
Reclock("SF1",.f.)
Replace F1_DTLANC with _dDataAnt
MsUnlock()

Close(oDlg5)

Return

