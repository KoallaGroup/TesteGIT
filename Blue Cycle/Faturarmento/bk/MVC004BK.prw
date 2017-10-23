#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#Include 'FWMVCDef.ch'

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} MVC004
Rotina de edição do Agendamento do Atendimento aos Clientes
@author Sigfrido Eduardo Solórzano Rodriguez
@since 29/06/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------

User Function MVC004()
    /*Declarando as variáveis que serão utilizadas*/
	Local lRet := .T.
	Local aArea := ZZ1->(GetArea()) 
	Private oBrowse
	Private cChaveAux := ""

    //Iniciamos a construção básica de um Browse.
	oBrowse := FWMBrowse():New()

    //Definimos a tabela que será exibida na Browse utilizando o método SetAlias
	oBrowse:SetAlias("ZZ1")

    //Definimos o título que será exibido como método SetDescription
	//oBrowse:SetDescription("Grupo Tributário")
	oBrowse:SetDescription( 'Cadastro de Agendamento do Atendimento aos Clientes' )
	oBrowse:AddLegend( "Empty(ZZ1_DTEXAT)", "YELLOW", "Agenda pendente" )
	oBrowse:AddLegend( "!Empty(ZZ1_DTEXAT)", "BLUE" , "Agenda executada" )

	//Adiciona um filtro ao browse  
	If Type("dDataIni") <> "U"
		oBrowse:SetFilterDefault( "ZZ1_DTAGAT >= DToS(dDataIni) .And. ZZ1_DTAGAT <= DToS(dDataFim)" )
	Endif
	//Desliga a exibição dos detalhes
	//oBrowse:DisableDetails()
	
        //Ativamos a classe
	oBrowse:Activate()
    RestArea(aArea)
Return

//------------	-------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 		OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MVC004" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.MVC004" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.MVC004" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.MVC004" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.MVC004" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.MVC004" OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'ZZ1')
oModel := MPFormModel():New('ModelName')
oModel:addFields('ZZ1MODEL',,oStr1)     
oModel:SetPrimaryKey({})
oModel:getModel('ZZ1MODEL'):SetDescription('Cadastro de Agendamento do Atendimento aos Clientes')
	
Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Blue Cycle

@since 03/07/2017
@version 1.0
/*/
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