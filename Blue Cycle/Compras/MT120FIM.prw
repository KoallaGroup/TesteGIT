#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"          
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)
//----------------------------------------------------------------------------
/*/{Protheus.doc} MT120FIM
O ponto se encontra no final da função A120PEDIDO. Após a restauração do filtro 
da FilBrowse depois de fechar a operação realizada no pedido de compras, é a 
ultima instrução da função A120Pedido.  
Parametro Configurador: NM_PMCUSTO = "Percentual da Margem do custo aceitavel 
para comparação entre custo padrão e valor digitado. Conteúdo default = 10".
Parametro Configurador: NM_APROCUS = "Grupo de aprovadores de pedidods responsável
por liberar dos PCs bloqueados por divergências de custos. Conteúdo default = 000008.
Parametro Configurador: NM_MT120FM = "Desativa a funcionalidade. Conteúdo padrão True."
@author LSC - Novo Mundo
@since 20/07/2015      
@version 1.0
@return nenhum
/*/
//----------------------------------------------------------------------------

User Function MT120FIM()
/************************************************************************
* 
*                        
*****/
Local aAreaOld  := GetArea()
Local nOpcaoSel := ParamIxb[1] // 3=Incluir, 4=Alterar e 5=Exclusão
Local cNumPedid := ParamIxb[2] // Numero do pedido de compra
Local nAcaoCanc := ParamIxb[3] // Ação foi Cancelada = 0  ou Confirmada = 1
  
/*
Local cNumDocum := ""
Local cDescrica := ""
Local cMargAcei := ""
Local cTitulFrm := ""    
Local cObservac := ""                       
Local cTpTitulo := "" 

Local nPercentu := GetNewPar("NM_PMCUSTO",10) //Percentual da Margem do custo aceitavel para comparação entre custo padrão e valor digitado...
Local nMrgAcima := 0 
Local nPosVlrBr := 0
Local nMrgAbaix := 0
Local nPosProdu := 0 
Local nPosValor := 0
Local nPosiItem := 0
Local nPosCusto := 0 
Local nMoedaSC7 := 0
Local nVlrBruto := 0 
Local nValorDef := 0
Local nPosIpiDf := 0
Local nPosISTDf := 0
Local nVlrDefla := 0
Local lBloqCust := .F.
Local lDeletaCr := .T.

Local aArrayCab := {}
Local aArrayTam := {}
Local aArrayMsg := {} 
						
Local aClonCols := AClone(aCols)
Local aClonHead := AClone(aHeader)
Local aAreaSlv1 := SB1->(GetArea())
Local aAreaSlv2 := SC7->(GetArea())

If(nAcaoCanc == 0)//Usuário clicou em fechar
	Return
EndIf
*/



U_Updscr(cNumPedid)


RestArea(aAreaOld)


Return



User Function Updscr(cNumPedid)
Local cQuery := ""


   
DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cNumPedid)


If (SC7->C7_NATUREZ = "212049" .OR. SC7->C7_NATUREZ = "216003" .OR. SC7->C7_NATUREZ = "212074" .OR. SC7->C7_NATUREZ = "212075" .OR. SC7->C7_NATUREZ = "212063" .OR. SC7->C7_NATUREZ = "212016" .OR. SC7->C7_NATUREZ = "216007")                                                                            
	cQuery := " UPDATE "+RetSqlName("SCR")+" SET D_E_L_E_T_ = '*' WHERE CR_NUM = '"+SC7->C7_NUM+"' AND CR_FILIAL = '"+SC7->C7_FILIAL+"' AND CR_NIVEL > '00' "
	TcSqlExec(cQuery)

EndIf


//dbSelectArea("SCR")
//SCR->(dbGoTop())
//dbSetOrder(2)
//dbSeek(xFilial("SCR")+"PC"+Left(cNumPedid,6),.T.) //CR_FILIAL+CR_TIPO+CR_NUM
/*If(SCR->(Found()))
	RecLock("SCR",.F.)
	
	cQuery := " UPDATE "+RetSqlName("SCR")+" SET CR_FORNECE = SA2PC.A2_NOME, CR_NREDUZ = SA2PC.A2_NREDUZ "
	cQuery += " FROM "+RetSqlName("SCR")+" SCR "
	cQuery += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON SC7.C7_FILIAL = SCR.CR_FILIAL AND SC7.C7_NUM = SCR.CR_NUM AND SCR.CR_TIPO = 'PC' AND SC7.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN "+RetSqlName("SA2")+" SA2PC ON SA2PC.A2_COD = SC7.C7_FORNECE AND SA2PC.A2_LOJA = SC7.C7_LOJA AND SA2PC.D_E_L_E_T_ = '' "
	cQuery += " WHERE SCR.D_E_L_E_T_ = '' AND SCR.CR_FILIAL = '"+xFilial("SCR")+"' AND SCR.CR_NUM ='"+cNumPedid+"' "
	
	TcSqlExec(cQuery)
	
	MsUnlock()
	SCR->(dbSkip())
EndIf */ 


/*
If nTipoPed == 1

   cQuery := "UPDATE SCR SET D_E_L_E_T_='*' "
   cQuery += " FROM "+Retsqlname("SCR")+" SCR "
   cQuery += " INNER JOIN "+Retsqlname("SC7")+" SC7 ON SC7.D_E_L_E_T_=' ' AND C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM  AND C7_CONAPRO<>'L' AND C7_APROV<>'FOL002'"
   cQuery += " LEFT JOIN "+Retsqlname("SY1")+" SY1 ON SY1.D_E_L_E_T_=' ' AND Y1_USER=C7_USER "
   cQuery += " LEFT JOIN "+Retsqlname("ZTU")+" ZTU ON ZTU.D_E_L_E_T_=' ' AND ZTU_CCUSTO=C7_GRUPCOM AND CR_USER=ZTU_USERID " //OR CR_USER IS NULL) "
   cQuery += " LEFT JOIN "+Retsqlname("ZTT")+" ZTT ON ZTT.D_E_L_E_T_=' ' AND ZTT_EMP='"+cEmpAnt+"' AND ZTT_CODFIL=C7_FILIAL AND ZTT_CCUSTO=C7_CC  AND (CR_USER=ZTT_USERID OR CR_USER IS NULL) AND ZTT_NIVEL=CASE WHEN C7_APROV='C00001' AND CR_NIVEL='03' THEN '02' WHEN C7_APROV='C00001' AND CR_NIVEL='02' THEN '01' ELSE CR_NIVEL END " //AND ISNULL(ZTU_USERID,'')=CASE WHEN CR_NIVEL<>'01' AND C7_APROV<>'C00001' THEN '' ELSE ISNULL(ZTU_USERID,'') END  "
   cQuery += " LEFT JOIN "+Retsqlname("SAK")+" SAK ON SAK.D_E_L_E_T_=' ' AND C7_FILIAL = AK_FILIAL AND AK_USER=ZTT_USERID "//CASE WHEN C7_APROV='C00001' AND CR_NIVEL='01'  AND ZTU_USERID IS NOT NULL THEN ZTU_USERID WHEN C7_APROV='C00001' AND CR_NIVEL='01'  AND ZTU_USERID IS NULL"
//   cQuery += " 	AND CR_NIVEL<>ZTT_NIVEL THEN NULL "
//   cQuery += " AND "
//   cQuery += " 	(	SELECT COUNT(DISTINCT ZTU_USERID) FROM "+Retsqlname("SCR")+" SCR"
//   cQuery += " 		INNER JOIN "+Retsqlname("SC7")+" SC7 ON SC7.D_E_L_E_T_='' AND C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM  AND C7_CONAPRO<>'L'"
//   cQuery += " 		INNER JOIN "+Retsqlname("ZTU")+" ZTU ON ZTU.D_E_L_E_T_='' AND ZTU_CCUSTO=C7_GRUPCOM AND (CR_USER=ZTU_USERID OR CR_USER IS NULL)"
//   cQuery += " 		WHERE SCR.D_E_L_E_T_='' AND CR_NUM='"+cNumPedid+"')>0 THEN NULL"
//	cQuery += " 	ELSE ZTT_USERID END "
   cQuery += " WHERE SCR.D_E_L_E_T_=' ' AND C7_APROV<>'FOL002' AND C7_APROV<>'T00001' AND C7_APROV<>'CX0001' AND SCR.CR_NUM = '"+cNumPedid+"' AND AK_NOME IS NULL AND ZTU_USERID IS NULL"
   TcSqlExec(cQuery)
   TcRefresh(Retsqlname("SCR"))        
   
   
   
   
   
EndIf  */

Return


/*User Function EICPO01S()
Private nTipoPed := 1 


U_Updscr(SC7->C7_NUM)

Return*/