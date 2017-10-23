#INCLUDE "RWMAKE.CH" 
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"                                      
#INCLUDE 'TOPCONN.CH'



User Function tstfina()

LOCAL aArray := {}           
Local cHist := ""
Local lAlt := .F.    
Local cFilAnt := "01"
 
PRIVATE lMsErroAuto := .F.

cNumTit := '029928'
nValRec := 100
cFilDep := cFilAnt
/*DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+AllTrim(cNumTit))*/

//	RecLock("SC5",.F.)
   //	SC5->C5_VLPGANT := SC5->C5_VLPGANT + nValRec
	//SC5->C5_VLCNAB 	:= SC5->C5_VLCNAB - nValRec   

//	MsUnlock()


	cHist := "Titulo gerado`a partir do pedido antecipado: "//+SC5->C5_NUM
   // cFilAnt := "01"
	 PREPARE ENVIRONMENT Empresa "01" Filial "01" Modulo "FAT" Tables "SC5","SC6","SA1","SE4","SX6"
	aArray := { { "E1_PREFIXO"  , "RA"             , NIL },;
	            { "E1_FILIAL"      , "01"            , NIL },;
	            { "E1_NUM"      , cNumTit            , NIL },;
	            { "E1_TIPO"     , "RA"              , NIL },;
	            { "E1_NATUREZ"  , "112001"             , NIL },;
	            { "E1_CLIENTE"  , '006257'       , NIL },;
	            { "E1_LOJA"  , '01'       , NIL },;
	            { "E1_EMISSAO"  , Date(), NIL },;
	            { "E1_VENCTO"   , Date(), NIL },;
	            { "E1_VENCREA"  , Date(), NIL },;
	            { "E1_VALOR"    , nValRec              , NIL },;
	            { "E1_VLCRUZ"    , nValRec              , NIL },;
	            { "E1_HIST"    , cHist              , NIL }   }
	 
	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
	If lMsErroAuto
	    MostraErro()
	Else
	    Alert("Título incluído com sucesso!")
	EndIf	

	
//EndIf

 
Return        

