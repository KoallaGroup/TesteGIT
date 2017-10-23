#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
#INCLUDE "FIVEWIN.CH"
#Include "TbiConn.ch"
/*----------------------*/
User Function MarcFat()
/*----------------------*/                                            

If Pergunte("MARCFAT")

MsgRun("Selecionando pedidos, Aguarde...","",{|| CursorWait(), montaC2() ,CursorArrow()})      
   
Endif

Return

/************************/
Static Function montac2()
/*************************/


Local cAlias := ""      
Local cCodUser := RetCodUsr()
Local aCamposA := { {"OK","OK","OK"} ,;              
                      {"SITUACAO","SITUACAO","Situacao"} ,;
                      {"PEDIDO","PEDIDO","Pedido"} ,;
                      {"FILIAL","FILIAL","Filial"} ,;                      
                      {"FORNECEDOR","FORNECEDOR","Fornecedor"} ,;
                      {"LOJA","LOJA","Loja"} ,;
                      {"NOME","NOME","Razao Social"} ,; 
                     {"NATUREZA","NATUREZA","Natureza"} ,; 
                     {"VALOR","VALOR","Valor"} ,; 
                      {"EMISSAO","EMISSAO","Emissao"},;
                      {"TIPO","TIPO","Tipo"} }    
Local cFiltro := ''                        
Private aCampos := {}

//dbSelectArea("SC5")
//aordem := SC5->(IndexOrd())
//SC5->(DbSetOrder(8))
//_cAlias := Alias()
//_nRecno := Recno()     

//cCodUser := '000091'

cAlias := GetNextAlias()


cQuery := " SELECT C7_FILIAL, C7_NUM, C7_EMISSAO, A2_COD, A2_LOJA, A2_NOME, ED_DESCRIC, SUM(C7_TOTAL) VALOR, CR_STATUS, CR_TIPO, CR_NIVEL FROM "+    RetSqlName("SC7") + " SC7 "
cQuery += " INNER JOIN "+        RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA "
cQuery += " LEFT JOIN "+        RetSqlName("SED") + " SED ON ED_CODIGO = C7_NATUREZ AND SED.D_E_L_E_T_ = ' '  "
cQuery += " INNER JOIN "+        RetSqlName("SCR") + " SCR ON CR_FILIAL = C7_FILIAL AND CR_NUM = C7_NUM AND CR_USER = '"+cCodUser+"' "

cQuery += " WHERE SC7.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' ' AND C7_CONAPRO = 'B' AND SCR.D_E_L_E_T_ = ' ' "
If MV_PAR01 = 2 
	cQuery += " AND SCR.CR_STATUS = '02' "
EndIf 	

cQuery += " GROUP BY C7_FILIAL, C7_NUM, C7_EMISSAO, A2_COD, A2_LOJA, A2_NOME, ED_DESCRIC, CR_STATUS, CR_TIPO, CR_NIVEL "

cQuery += " ORDER BY  C7_FILIAL, C7_NUM, C7_EMISSAO, A2_COD, A2_LOJA "   

Query := ChangeQuery(cQuery)          

TcQuery cQuery NEW ALIAS (cAlias)   
                                                                                                               
DbSelectArea(cAlias)

//Estrutura do arquivo
aAdd(aCampos,{"FILIAL","C",Len((cAlias)->C7_FILIAL),0})
aAdd(aCampos,{"OK","C",2,0})
aAdd(aCampos,{"SITUACAO","C",25,0})
aAdd(aCampos,{"PEDIDO","C",Len((cAlias)->C7_NUM),0})
aAdd(aCampos,{"FORNECEDOR","C",Len((cAlias)->A2_COD),0})
aAdd(aCampos,{"LOJA","C",Len((cAlias)->A2_LOJA),0})
aAdd(aCampos,{"NOME","C",Len((cAlias)->A2_NOME),0})
aAdd(aCampos,{"NATUREZA","C",Len((cAlias)->ED_DESCRIC),0})
aAdd(aCampos,{"VALOR","C",12,0})
aAdd(aCampos,{"EMISSAO","D",Len((cAlias)->C7_EMISSAO),0}) 
aAdd(aCampos,{"LIBERACAO","C",1,0})                       
aAdd(aCampos,{"TIPO","C",Len((cAlias)->CR_TIPO),0}) 
aAdd(aCampos,{"NIVEL","C",2,0})



cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TMP",.T.,.F.)
cArqTrab := CriaTrab(Nil,.F.)
IndRegua("TMP",cArqTrab,"FILIAL",,.F.,"Processando")       


//IndRegua( cTemp, cArqTrab, "TRB_VALOR")

//Criacao de um Segundo Indice
// cNomInd2:=E_Create(cArqTrab,.F.)
// IndRegua( "TMP", cNomInd2, "PEDIDO")

//Criacao dos Indices na Tabela Temporaria
// SET INDEX TO (cArqTrab),(cNomInd2)

                
//Alert('Cheguei aqui!') 
              
DbGotop(cAlias)
While ! (cAlias)->(Eof())
        
                               cImprime := "S"

        //If cImprime = "S"
        //If (cAlias)->C5_LIBEROK == "S"     
                                               RecLock("TMP",.T.)
                                               
                                               TMP->FILIAL      := (cAlias)->C7_FILIAL
                                               TMP->PEDIDO      := (cAlias)->C7_NUM
                                               TMP->FORNECEDOR := (cAlias)->A2_COD
                                               TMP->LOJA        := (cAlias)->A2_LOJA
                                               TMP->NOME        := (cAlias)->A2_NOME
                                               TMP->NATUREZA  := (cAlias)->ED_DESCRIC
                                               TMP->EMISSAO     := Stod((cAlias)->C7_EMISSAO)
                                               TMP->VALOR     := TRANSFORM((cAlias)->VALOR,"@E 9,999,999.99")
                                               TMP->TIPO	:= (cAlias)->CR_TIPO  
                                               TMP->NIVEL 	:= (cAlias)->CR_NIVEL
                                               If (cAlias)->CR_STATUS = '02'
                                               	TMP->SITUACAO := 'Pendente' 
                                               	TMP->LIBERACAO := 'S'
                                               Else
                                               	If (cAlias)->CR_STATUS = '01'
                                               		TMP->SITUACAO := 'Aguard. Outros Niveis' 
                                               	ElseIf (cAlias)->CR_STATUS = '03'
                                               		TMP->SITUACAO := 'Pedido Liberado'  
                                               	ElseIf (cAlias)->CR_STATUS = '04'
                                               		TMP->SITUACAO := 'Bloqueado Pelo Usuario'
                                               	ElseIf (cAlias)->CR_STATUS = '05'
                                               		TMP->SITUACAO := 'Liberado Outro Usuário'	
                                               	EndIf
                                               	TMP->LIBERACAO := ' '
                                               EndIf
                                               
                                               
                                               MsUnlock("TMP")
                               
                               //EndIf
                                                
                               (cAlias)->(dbSkip())

EndDo


TMP->(DbGotop())

aRotina:= {{"Pesquisar"     ,'ExecBlock("PesqPed",.F.,.F.,4)',0,1},;
             {"Liberar Marc." ,'ExecBlock("cValida",.F.,.F.,4)' , 0 , 4 }}
             
//,CloseBrowse()             

                          
cMarca := GetMark() 
cCadastro := "Aprovação de Pedidos em Lote"

MarkBrow("TMP","OK","TMP->LIBERACAO == ' '" ,aCamposA ,.F.,cMarca, , , , , , , )     

dbSelectArea("TMP")
dbclosearea("TMP")



Return 

/*********************/
User Function cValida()
/*********************/
Local cUserAp := RetCodUsr()   
Local cLibPed := "S"    
Local cAlias := ""      




If ApMsgYesNo("Confirma a liberação dos pedidos selecionados ?")
   

   DbSelectArea("TMP")
   DbGotop("TMP")
   While ! Eof()
                   
       If !Empty(TMP->OK) //== cMarca
       
       
       
       
			cAlias := GetNextAlias()
			cQuery := " SELECT *  FROM "+    RetSqlName("SCR") + " SCR "
			cQuery += " WHERE SCR.D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+TMP->FILIAL+"' AND CR_NUM = '"+TMP->PEDIDO+"'  AND CR_NIVEL >= '"+TMP->NIVEL+"' AND CR_TIPO = '"+TMP->TIPO+"' "
			cQuery += " ORDER BY  CR_NIVEL "   
			Query := ChangeQuery(cQuery)          
			TcQuery cQuery NEW ALIAS (cAlias)          



		   	cLibPed := "S"       
  			
			DbGotop(cAlias)
			While ! (cAlias)->(Eof())  			
  		/*	
  			DbSelectArea("SCR")
     		DbSetOrder(1)                                               
     		If DbSeek(TMP->FILIAL+TMP->TIPO+TMP->PEDIDO+TMP->NIVEL)     
	         	While !EOF() .and. alltrim(SCR->CR_NUM) == alltrim(TMP->PEDIDO)
		  */       	          
   		         	
		                                                              
		  
	  			DbSelectArea("SCR")
	     		DbSetOrder(2)                                               
	     		If DbSeek((cAlias)->CR_FILIAL+(cAlias)->CR_TIPO+(cAlias)->CR_NUM+(cAlias)->CR_USER)     		  
		  
		            If (cAlias)->CR_NIVEL = TMP->NIVEL
			            RecLock("SCR",.F.)
			            If (cAlias)->CR_USER = cUserAp  
			            	SCR->CR_STATUS 	:= '03'
			            	RecLock("TMP",.F.)
			            	TMP->SITUACAO := 'Pedido Liberado'
			            	TMP->LIBERACAO := ' '
			            	MsUnlock("TMP")
			            Else
			            	SCR->CR_STATUS 	:= '05'
			            EndIf	
			            SCR->CR_DATALIB := Date()
			            SCR->CR_USERLIB := cUserAp
			            SCR->CR_LIBAPRO := SCR->CR_APROV
			            MsUnLock("SCR")
			        Else
			            RecLock("SCR",.F.)
			            SCR->CR_STATUS 	:= '02'
			            cLibPed := "N"    
			            MsUnLock("SCR")
					EndIf                          
	                           
	            EndIf      
			(cAlias)->(DbSkip())
	    	Enddo
	        
	        
	            If cLibPed == "S"
	            
					DbSelectArea("SC7")
		     		DbSetOrder(1)
		       		DbSeek(TMP->FILIAL+TMP->PEDIDO)     
		         
					While !Eof() .And. SC7->C7_NUM == TMP->PEDIDO
					
				        RecLock("SC7",.F.)
		                SC7->C7_CONAPROV = 'L'
		                MsUnlock("SC7")


						SC7->(dbSkip())
					
					EndDo			         	

	          	EndIf
              
            //EndIf
                      
       EndIf

       DbSelectArea("TMP")
       DbSkip()
       
   Enddo

MarkbRefresh()
   
Endif      
Return 

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author Ricardo Mansano - vjcarmo@hotmail.com
@since 8/3/2011
/*/
//--------------------------------------------------------------
User Function PesqPed()
Local oComboBo1
Local nComboBo1 := 1
Local oGet1
Local cGet1 := "                 "
Local cCombo
Local oSButton1
Local oSButton2
Local nOpc := 0
Local nOpcA := 0
Local cTpPesq := {"Pedido","Fornecedor"} 
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Pesquisa" FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL   
  
  

    //@ 007, 009 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS cTpPesq SIZE 124, 010 OF oDlg COLORS 0, 16777215 PIXEL //Valid (!Empty(cTpPesq))
                oCombo:= tComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
                cTpPesq,123,20,oDlg,,,;
                ,,,.T.,,,,,,,,,"cCombo")
    
    @ 024, 009 MSGET oGet1 VAR cGet1 SIZE 123, 010 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 006, 152 TYPE 01 ACTION ( nOpc:=1,oDlg:End() ) OF oDlg ENABLE
    DEFINE SBUTTON oSButton2 FROM 022, 153 TYPE 02 ACTION ( nOpc:=2,oDlg:End() ) OF oDlg ENABLE

                ACTIVATE MSDIALOG oDlg CENTERED   


  

    IF nOpc = 1 
                if cCombo == "Pedido"
                                               DbSelectArea("TMP")
                                               IndRegua("TMP",cArqTrab,"PEDIDO",,.F.,"Processando")
                                IF ! DbSeek(cGet1)
                                                Alert('Pedido não encontrado!')
                                EndIf
                                
                Endif     
                if cCombo == "Fornecedor"
                                               DbSelectArea("TMP")
                                               IndRegua("TMP",cArqTrab,"FORNECEDOR",,.F.,"Processando")
                                If ! DbSeek(cGet1)     
                                                Alert('Pedido não encontrado!')
                                EndIf                     
                endif                     
    EndIf


Return  






dbSelectArea("TMP")
dbclosearea("TMP")

Set Device To Screen

If aReturn[5] == 1
                Set Printer TO
                dbcommitAll()
                ourspool(wnrel)
Endif

If File(cArqTrb+".DBF")
                Ferase(cArqTrb+".DBF")
                Ferase(cArqTrb+".NTX")
EndIf

MS_FLUSH()

Static Function ZPTRefre(oBrowse)

Local oObjBrow := GetObjBrow() //Obtém o ultimo Objeto Browse
      oObjBrow:Refresh()
  // oObjBrow:setfocus()

Return .T.                          

