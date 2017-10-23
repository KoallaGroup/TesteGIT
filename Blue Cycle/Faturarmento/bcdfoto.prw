#include "protheus.ch"	
#include 'tbiconn.ch'
#include 'topconn.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  05/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BCDFOTO
	Local oDlg
	Local oMemo
	Local cMemo	  := ""
	Local oGet
	Local cGet1	  := ""
	Local cGet2
	Local oCombo
	Local cCombo  := ""
	Local aResumo := {"Cobranca/Mesmo","Cadastro","Cobranca","Falta Analise","Limite","Sem Item no Estoque","Serasa","Sintegra","Somente Antecipado","Outros"}

	Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_BITMAP")

	Define MsDialog oDlg From 125,3 To 463,324 Title OemToAnsi("Visuzalização de Imagem do Produto.") Pixel
	@003,004 To 151,160 Label "Foto" Of oDlg Pixel
	

   If Empty(SB1->B1_BITMAP)
      @ 120,85 SAY "Não cadastrada." SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlg
   Else
      @ 004,005 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 150,150 PIXEL
      Showbitmap(oBitPro,SB1->B1_BITMAP,"")
      oBitPro:lStretch:=.T.
      oBitPro:Refresh()
   EndIf
	


	Define sButton From 156,135 Type 2 Action oDlg:End() Enable Of oDlg
	Activate MsDialog oDlg center



Return
