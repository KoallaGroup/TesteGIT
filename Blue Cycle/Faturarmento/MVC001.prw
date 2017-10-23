#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} MVC001
Consulta de Atendimento aos Clientes
@author Sigfrido Eduardo Sol�rzano Rodriguez
@since 22/06/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------

User Function MVC001()
    /*Declarando as vari�veis que ser�o utilizadas*/
	Local lRet := .T.
	Local aArea := ZZ0->(GetArea()) 
	Local aRotinaAnt 
		
	Private oBrowse
	Private cChaveAux := ""
    
	If FunName() == "MVC002"
		aRotinaAnt := IIF(Type("aRotina") <> "U", AClone(aRotina), {})
		aRotina := MenuDef()
	Endif
	
    //Iniciamos a constru��o b�sica de um Browse.
	oBrowse := FWMBrowse():New()

    //Definimos a tabela que ser� exibida na Browse utilizando o m�todo SetAlias
	oBrowse:SetAlias("ZZ0")

    //Definimos o t�tulo que ser� exibido como m�todo SetDescription
	//oBrowse:SetDescription("Grupo Tribut�rio")
	oBrowse:SetDescription( 'Hist�rico de Atendimento aos Clientes' )
	oBrowse:AddLegend( "ZZ0_TIPO=='A'", "YELLOW", "Ativo" )
	oBrowse:AddLegend( "ZZ0_TIPO=='R'", "BLUE" , "Reativo" )

	//Adiciona um filtro ao browse
	//oBrowse:SetFilterDefault( "X5_TABELA == '21'" )
	
	//Desliga a exibi��o dos detalhes
	//oBrowse:DisableDetails()
	
        //Ativamos a classe
	oBrowse:Activate()
    RestArea(aArea)
    
    If FunName() == "MVC002"
		aRotina := AClone(aRotinaAnt)  
		ASize(aRotinaAnt,0)
	Endif   
Return

//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}       
	
	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 		OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MVC001" OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.MVC001" OPERATION 3 ACCESS 0
	//ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.MVC001" OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.MVC001" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.MVC001" OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.MVC001" OPERATION 9 ACCESS 0
Return aRotina

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZZ0') //Local oStr1:= FWFormStruct(2, 'SX5')
	
	// Cria o objeto de View
	oView := FWFormView():New()
	
	// Define qual o Modelo de dados ser� utilizado
	oView:SetModel(oModel)
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField('Formulario' , oStr1,'CamposZZ0' ) //oView:AddField('Formulario' , oStr1,'CamposZZ0' )

        //Remove os campos que n�o ir�o aparecer	
	//oStr1:RemoveField( 'X5_DESCENG' )
	//oStr1:RemoveField( 'X5_DESCSPA' )
	
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'PAI', 100)
	
	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView('Formulario','PAI')
	oView:EnableTitleView('Formulario' , 'Hist�rico Atendimento aos Clientes' )	
	oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
Return oView

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct( 1, 'ZZ0', /*bAvalCampo*/,/*lViewUsado*/ ) //Local oStr1:= FWFormStruct( 1, 'SX5', /*bAvalCampo*/,/*lViewUsado*/ ) // Constru��o de uma estrutura de dados
	
	//Cria o objeto do Modelo de Dados
        //Irie usar uma fun��o MVC001V que ser� acionada quando eu clicar no bot�o "Confirmar"
	oModel := MPFormModel():New('AtendimentoaosClientes', /*bPreValidacao*/, { | oModel | '<strong><em><span style="color: #ff0000;">MVC001V</span></em></strong>( oModel )' } , /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )
	oModel:SetDescription('Atendimento aos Clientes')
	
	//Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
    //oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )

    //Abaixo irei bloquear/liberar os campos para edi��o
	//oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })

        //Podemos usar as fun��es INCLUI ou ALTERA
	//oStr1:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })

    //Ou usar a propriedade GetOperation que captura a opera��o que est� sendo executada
	/*oStr1:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	
	oStr1:RemoveField( 'X5_DESCENG' )
	oStr1:RemoveField( 'X5_DESCSPA' )
	oStr1:RemoveField( 'X5_FILIAL' )*/
	
	// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	oModel:addFields('CamposZZ0',,oStr1,,,)//oModel:addFields('CamposZZ0',,oStr1,{|oModel|'<strong><span style="color: #ff0000;"><em>MVC001T</em></span></strong>(oModel)'},,)
	
	//Define a chave primaria utilizada pelo modelo
	oModel:SetPrimaryKey({}) //oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE' })
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:getModel('CamposZZ0'):SetDescription('Atendimento aos Clientes')
	
Return oModel

//-------------------------------------------------------------------
// Valida��es ao salvar registro
// Input: Model
// Retorno: Se erros foram gerados ou n�o
//-------------------------------------------------------------------
Static Function MVC001V( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposZZ0' )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()
/*
	//Capturar o conteudo dos campos
        Local cChave	:= oModelSX5:GetValue('X5_CHAVE')
	Local cTabela	:= oModelSX5:GetValue('X5_TABELA')
	Local cDescri	:= oModelSX5:GetValue('X5_DESCRI')
	
	Begin Transaction
		
		if nOpc == 3 .or. nOpc == 4
			if Empty(cTabela)
				oModelSX5:SetValue('X5_TABELA','21')
			Endif
			
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbGoTop())
			If(SX5->(dbSeek(xFilial("SX5")+cTabela+cChave)))
				if cChaveAux != cChave
					SFCMsgErro("A chave "+Alltrim(cChave)+" ja foi informada!","MVC001")
					lRet := .F.
				Endif
			Endif

			if Empty(cChave)
				SFCMsgErro("O campo chave � obrigat�rio!","MVC001")
				lRet := .F.
			Endif
			
			if Empty(cDescri)
				SFCMsgErro("O campo descri��o � obrigat�rio!","MVC001")
				lRet := .F.
			Endif
			
		Endif
		
		if !lRet
			DisarmTransaction()
		Endif
		
	End Transaction
	*/
	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet
