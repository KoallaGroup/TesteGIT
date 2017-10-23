#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA02			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Alterar Data Nota Nota Entrada								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA02()
    _aArea	:= getArea()
	               
	Public cF1Dt := ""

	if SF1->F1_FORMUL == "S"   
		if !(SF1->F1_TIPO) $ "N-D"
			msgAlert ("Somente Notas tipo Normal ou Devolução podem usar essa opção !!")	
			return
		else
			If SF1->F1_TIPO = "N" .AND. SF1->F1_EST <> "EX"	
				msgAlert ("Somente Notas de Importação e do tipo Normal podem usar essa opção !!")	
				return
			Endif			
		endif
		
		if SF1->F1__WMSRET == "1"
			msgAlert("Processo já retornou do WMS e não pode ser alterado")	
			return			
		endif
	Else
		msgAlert ("Rotina apenas para Formulário Próprio e NF Tipo Normal ou Devolução !!")	
		return		
	Endif	

	dbSelectArea("SD1")
	dbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
	While !eof().and. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA
		if empty(SD1->D1_TES)
			alert ("Nota sem classificação não pode ter a Data Alterada. Favor verificar !!")
			RestArea(_aArea)
			Return
		endif
		dbSkip()
	End

	cF1Dt := CriaVar("F1_DTDIGIT")
	
	SetPrvt("oDlg1","oGrp1","oSay1","oGet1")    

	oDlg1	:= MSDialog():New( 089,232,190,450,"Data de Digitação",,,.F.,,,,,,.T.,,,.T. )
	oGrp1   := TGroup():New( 000,000,080,164,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1   := TSay():New( 014,004,{||"Data da Digitação"}    ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGet1   := TGet():New( 012,052,{|u| If(PCount()>0,cF1Dt  :=u,cF1Dt)} ,oGrp1,,,'99/99/99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cF1Dt",,)

	oSBtn1  := SButton():New( 030,012,1,{|| U_GRVDATA()},oGrp1,,"", )
	oSBtn2  := SButton():New( 030,070,2,{|| oDlg1:end()},oGrp1,,"", )

	oDlg1:Activate(,,,.T.)
	
	restArea(_aArea)
		
Return .t.

       
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : GRVDATA			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Gravação do campo Data de Digitação											  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function GRVDATA()
    
	if cF1Dt < SF1->F1_DTDIGIT
		msgAlert ("A Data de Digitação da Nota deve ser superior ou igual " + dtoc(SF1->F1_DTDIGIT))
	else
		if msgYesNo("Deseja realmente alterar a data de digitação da nota ?", "Confirme")        
		
			dbSelectArea("SF1") 
			if reclock("SF1", .F.)	
				SF1->F1__DTDIG2	:= DATE()			
				SF1->F1_DTDIGIT	:= cF1Dt
            	SF1->(msUnlock())
			endif
			
			dbSelectArea("SD1")
			dbSetOrder(1)
			if dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
				do while SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA
					if reclock("SD1", .F.)	
						SD1->D1_DTDIGIT	:= cF1Dt
		            	SD1->(msUnlock())
					endif
					SD1->(dbSkip())
				enddo
			endif

			dbSelectArea("SFT")
			dbSetOrder(1)
			if dbSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
				do while SFT->FT_FILIAL == xFilial("SFT") .and. SFT->FT_NFISCAL == SF1->F1_DOC .and. SFT->FT_SERIE == SF1->F1_SERIE .and.; 
						 SFT->FT_CLIEFOR == SF1->F1_FORNECE .and. SFT->FT_LOJA == SF1->F1_LOJA

					While !reclock("SFT", .F.)	
					EndDo
					SFT->FT_ENTRADA	:= cF1Dt
	            	SFT->(msUnlock())

					SFT->(dbSkip())

				enddo
			endif

			dbSelectArea("SF3")
			dbSetOrder(5)
			if dbSeek(xFilial("SF3")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
				While( SF3->(F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA) == SF1->(F1_FILIAL+F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA) )
					While !reclock("SF3", .F.)	
					EndDo
				    SF3->F3_ENTRADA	:= cF1Dt
	            	SF3->(msUnlock())     
	            	SF3->(DbSkip())
	       		EndDo
			endif

		endif		    
		msgAlert ("Data de Digitação alterada com sucesso !!")
		oDlg1:end()		
	endif

return 