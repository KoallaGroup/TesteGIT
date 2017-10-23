#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#Include 'FWMVCDef.ch'

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} MVC002
Rotina de edi��o do Agendamento do Atendimento aos Clientes
@author Sigfrido Eduardo Sol�rzano Rodriguez
@since 29/06/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------
User Function MVC002(cOP)
    /*Declarando as vari�veis que ser�o utilizadas*/
	Local lRet := .T.
	Local aArea := ZZ1->(GetArea()) 
	Local aRotinaAnt   
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cVendInt := Space(TAMSx3("ZZ1_VENINT")[1])
	Local cFilter
	
	Private oBrowZZ1
	Private cChaveAux := ""

	Default cOP := " "
	
	SetKey(VK_F12, { || Pergunte("MVC002",.T.) } ) 
	
	Pergunte("MVC002",.F.)
	              	
	If cOP == "A"
		aRotinaAnt := AClone(aRotina)
		aRotina := MenuDef()
	Endif
	
    //Iniciamos a constru��o b�sica de um Browse.
	oBrowZZ1 := FWMBrowse():New()                                          
	
    //Definimos a tabela que ser� exibida na Browse utilizando o m�todo SetAlias
	oBrowZZ1:SetAlias("ZZ1")

    //Definimos o t�tulo que ser� exibido como m�todo SetDescription
	
	oBrowZZ1:SetDescription( 'Agenda do Atendimento aos Clientes' )
	oBrowZZ1:AddLegend( "Empty(ZZ1_DTEXAT)", "YELLOW", "Agenda pendente" )
	oBrowZZ1:AddLegend( "!Empty(ZZ1_DTEXAT)", "BLUE" , "Agenda executada" )
	//oBrowZZ1:SetMenuDef( 'MVC002' ) // Define de onde virao os      
	//oBrowZZ1:SetMenuDef( '' )
	//oBrowZZ1:ForceQuitButton() // For�a exibi��o do bot�o 	
	
	// botoes deste browse
	//Adiciona um filtro ao browse  
	If Type("dDataIni") <> "U"
		oBrowZZ1:SetFilterDefault( "ZZ1_DTAGAT >= DToS(dDataIni) .And. ZZ1_DTAGAT <= DToS(dDataFim)" )
	ElseIf cOP == "A" .Or. mv_par01 == 1                    
		cVendInt := Posicione("SA3", 7, XFilial("SA3") + cCodUser, "A3_COD") 
		
		If !Empty(cVendInt)
			cFilter := "ZZ1_VENINT == '" + cVendInt + "'"
			
			If mv_par02 == 1
				cFilter += " .AND. DToS(ZZ1_DTAGAT) == '" + DToS(dDataBase) + "'"
			Endif
			  
			oBrowZZ1:SetFilterDefault(cFilter)						
		Else
			If mv_par02 == 1                   	
				cFilter := "DToS(ZZ1_DTAGAT) == '" + DToS(dDataBase) + "'"
				
				oBrowZZ1:SetFilterDefault(cFilter)						
			Endif
		Endif 
	ElseIf  mv_par01 == 2 .And. mv_par02 == 1                   	
		cFilter := "DToS(ZZ1_DTAGAT) == '" + DToS(dDataBase) + "'"
		
		oBrowZZ1:SetFilterDefault(cFilter)						
	Endif
	//Desliga a exibi��o dos detalhes
	//oBrowZZ1:DisableDetails()
	
 	//Ativamos a classe
	oBrowZZ1:Activate()
    RestArea(aArea) 
    
    If cOP == "A"
		aRotina := AClone(aRotinaAnt)  
		ASize(aRotinaAnt,0)
	Endif      
	
	SetKey(VK_F12,Nil)
Return

//-------------------------------------------------------------------
// Montar o menu Funcional
//------------------------------------------------------------------- 
Static Function MenuDef()
	Local aRotina := {}      
	
	ADD OPTION aRotina TITLE "Pesquisar"  				ACTION 'PesqBrw' 		OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.MVC002" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.MVC002" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.MVC002" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.MVC002" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 				ACTION "VIEWDEF.MVC002" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" 					ACTION "VIEWDEF.MVC002" OPERATION 9 ACCESS 0   
	ADD OPTION aRotina TITLE "Atendimento n�o programado aos Clientes" ACTION "U_fAtClWin" 	OPERATION 10 ACCESS 0 
	ADD OPTION aRotina TITLE "Apontar Atendimento ao Cliente" ACTION "U_fAtClWin('A')" OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE "Hist�rico Atendimento Aos Clientes" ACTION "U_MVC001" OPERATION 10 ACCESS 0   
	//ADD OPTION aRotina TITLE "HSPAHABS()" ACTION "HSPAHABS()" OPERATION 10 ACCESS 0
	//ADD OPTION aRotina TITLE "U_fHistAteC()" ACTION "U_fHistAteC()" OPERATION 10 ACCESS 0	   
	
Return aRotina                                           

Static Function ModelDef()
	Local oModel
	
	Local oStr1:= FWFormStruct(1,'ZZ1')       
	
	//oModel := MPFormModel():New('ModelName') 
	oModel := MPFormModel():New( 'ModelName',  /*Pr�-Validacao*/ , {|oX| MVC002OK(oX)} /*Validacao*/, /*Commit do Modelo*/, /*Cancel*/)
	
	oModel:addFields('ZZ1MODEL',,oStr1)     
	oModel:SetPrimaryKey({})
	oModel:getModel('ZZ1MODEL'):SetDescription('Agenda do Atendimento aos Clientes')		
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel := ModelDef() 
	Local oStr1:= Nil
	 
	Local oStr3:= FWFormStruct(2, 'ZZ1')         
	
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('ZZ1VIEW' , oStr3,'ZZ1MODEL' ) 
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('ZZ1VIEW','BOXFORM1')	
Return oView

//-------------------------------------------------------------------
// Valida��es ao salvar registro
// Input: Model
// Retorno: Se erros foram gerados ou n�o
//-------------------------------------------------------------------
Static Function MVC002OK( oModel )
	Local lRet      := .T.
	Local oModelZZ1 := oModel:GetModel( 'ZZ1MODEL' )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()

	//Capturar o conteudo dos campos
 	Local cZZ1_DTEXAT	:= oModelZZ1:GetValue('ZZ1_DTEXAT')
	
	If nOpc == 4
		If !Empty(cZZ1_DTEXAT)
			SFCMsgErro("N�o � permitada a altera��o ap�s o apontamento da agenda.","MVC002")   
			lRet := .F.
		Endif 
	ElseIf nOpc == 5
		If !Empty(cZZ1_DTEXAT)
			SFCMsgErro("N�o � permitada a exclus�o ap�s o apontamento da agenda.","MVC002")   
			lRet := .F.
		Endif  
	ElseIf nOpc == 3
		If !Empty(cZZ1_DTEXAT)
			SFCMsgErro("N�o � permitada a c�pia ap�s o apontamento da agenda.","MVC002")   
			lRet := .F.
		Endif
	Endif
	
	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet
