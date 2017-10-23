#include "protheus.ch"  
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'   

User Function DesLogis()
Local aCabExcel :={}
Local aItensExcel :={}         
pergunte("DESLOGIS",.T.)
// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
AADD(aCabExcel, {"Num_Pedido" ,"C", 06, 0})
AADD(aCabExcel, {"Status_Ped" ,"C", 15, 0})
AADD(aCabExcel, {"Dt_Emissao" ,"D", 08, 0})
AADD(aCabExcel, {"Cliente" ,"C", 40, 0})      
AADD(aCabExcel, {"UF" ,"C", 02, 0})
AADD(aCabExcel, {"Dt_Entrada_CD" ,"D", 08, 0}) 
AADD(aCabExcel, {"Hr_Entrada_CD" ,"C", 05, 0})
AADD(aCabExcel, {"Cod_Cliente" ,"C", 06, 0})
AADD(aCabExcel, {"Loja" ,"C", 02, 0})
AADD(aCabExcel, {"Dt_Ini_Sep" ,"D", 08, 0})
AADD(aCabExcel, {"Hr_Ini_Sep" ,"C", 05, 0})
AADD(aCabExcel, {"Dt_Fim_Sep" ,"D", 08, 0})
AADD(aCabExcel, {"Hr_Fim_Separacao" ,"C", 05, 0})
AADD(aCabExcel, {"Qtd_Unidades" ,"N", 12, 0})
AADD(aCabExcel, {"Qtd_Linhas" ,"N", 12, 0})
AADD(aCabExcel, {"Dt_Inicio_Conf" ,"D", 08, 0})
AADD(aCabExcel, {"Hr_Inicio_Conf" ,"C", 05, 0})
AADD(aCabExcel, {"Dt_Fim_Conf" ,"D", 08, 0})
AADD(aCabExcel, {"Hr_Fim_Conf" ,"C", 05, 0})
AADD(aCabExcel, {"Valor_Pedido" ,"N", 12, 2})
AADD(aCabExcel, {"Dt_Faturamento" ,"D", 08, 0})
AADD(aCabExcel, {"Hr_Fat" ,"C", 05, 0})
AADD(aCabExcel, {"Data_Exp" ,"D", 08, 0})
AADD(aCabExcel, {"Hora_Exp" ,"C", 05, 0})
AADD(aCabExcel, {"Cond_Pagto" ,"C", 40, 0})
AADD(aCabExcel, {"Transportadora" ,"C", 40, 0})
AADD(aCabExcel, {"Nr_Nota" ,"C", 09, 0}) 
AADD(aCabExcel, {"Separador" ,"C", 15, 0})
AADD(aCabExcel, {"Conferente" ,"C", 15, 0})
AADD(aCabExcel, {"Embalador" ,"C", 15, 0})





MsgRun("Favor Aguardar.....", "Selecionando os Registros",;
{|| GProcItens(aCabExcel, @aItensExcel)})

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
{||DlgToExcel({{"GETDADOS","RELATÓRIO DE DESEMPENHO DE LOGÍSTICA",;
aCabExcel,aItensExcel}})})

Return



Static Function GProcItens(aHeader, aCols)
Local aItem
Local nX
Local cAliasLog := GetNextAlias()

                              
cQuery := " select C5_NUM||'FAT' Num_Pedido,ZM_DESC Status_Ped, to_char(to_date(C5_EMISSAO,'YYYYMMDD') , 'DD/MM/YYYY') Dt_Emissao, A1_NOME Cliente, A1_EST UF,DATAINC Dt_Entrada_CD, HORAINC Hr_Entrada_CD, 
cQuery += " 			C5_CLIENTE Cod_Cliente, C5_LOJACLI Loja, SEP.dataini Dt_Ini_Sep,HORAINI Hr_Ini_Sep ,  datafim Dt_Fim_Sep, horafim Hr_Fim_Separacao, QTDE Qtd_Unidades, LINHA Qtd_Linhas, "
cQuery += "             datainiCONF Dt_Inicio_Conf,horainiCONF Hr_Inicio_Conf, datafimCONF Dt_Fim_Conf, horafimCONF Hr_Fim_Conf,"
cQuery += "             VLR_VEND Valor_Pedido, to_char(to_date(F2_EMISSAO,'YYYYMMDD'), 'DD/MM/YYYY') Dt_Faturamento, F2_HORA Hr_Fat, DATAEXP Data_Exp, HORAEXP Hora_Exp, E4_DESCRI Cond_Pagto, A4_NOME Transportadora, F2_DOC Nr_Nota,"
cQuery += "             SEPARADOR Separador, CONFERENTE Conferente, EMBALADOR Embalador "
cQuery += "             FROM dadosadv.SC5010 C5 "
cQuery += "				LEFT JOIN dadosadv.SZM010 ON SZM010.D_E_L_E_T_ = ' ' AND ZM_COD = C5.C5__STATUS"  
cQuery += "	LEFT JOIN( SELECT A4_COD, A4_NOME  "
cQuery += "				FROM dadosadv.SA4010    "
cQuery += "				WHERE D_E_L_E_T_ = ' ' ) SA4 "
cQuery += "				ON A4_COD = C5.C5_TRANSP"
cQuery += "	LEFT JOIN( SELECT E4_CODIGO, E4_DESCRI 
cQuery += "  			FROM dadosadv.SE4010 "
cQuery += "				WHERE D_E_L_E_T_ = ' ') SE4 "
cQuery += "				ON E4_CODIGO = C5.C5_CONDPAG"
cQuery += " LEFT JOIN( SELECT  TITCODIGO,TRADOCUMENTO,MIN(TRADATAINCLUSAO) DATAINI, to_char(MIN(TRADATAINCLUSAO) , 'hh24:mi') HORAINI, "
cQuery += "             MAX(TRADATAINCLUSAO) DATAFIM,to_char(MAX(TRADATAINCLUSAO), 'hh24:mi') HORAFIM,"
cQuery += "             MIN(USRCODIGO) SEPARADOR"
cQuery += "             FROM BLUECYCLE.TRANSACAO TRANSEP "
cQuery += "             WHERE TITCODIGO = 'SDOC' "
cQuery += "             GROUP BY TITCODIGO,TRADOCUMENTO"
cQuery += "             ) SEP"
cQuery += "             ON SEP.TRADOCUMENTO = C5.C5_NUM||'FAT' AND SEP.TITCODIGO = 'SDOC'"
cQuery += " LEFT JOIN( SELECT ORCCODIGO,ORCDATAINCLUSAO DATAINC,To_char(ORCDATAINCLUSAO , 'hh24:mi') HORAINC, ORCEMBALADORPC Embalador  "
cQuery += "            FROM BLUECYCLE.OC )"
cQuery += "            ON ORCCODIGO = C5.C5_NUM||'FAT'"
cQuery += " LEFT JOIN( SELECT C6_FILIAL, C6_NUM,SUM(C6_QTDVEN*C6_PRCVEN) VLR_VEND ,SUM(C6_QTDVEN) QTDE,COUNT(DISTINCT(CASE WHEN C6_QTDVEN >0 THEN C6_PRODUTO END) ) LINHA"
cQuery += "            FROM DADOSADV.SC6010   "
cQuery += "            WHERE "
cQuery += "            D_E_L_E_T_ = ' '"
cQuery += "            GROUP BY C6_FILIAL, C6_NUM) SC6"
cQuery += "            ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM"
cQuery += " LEFT JOIN( SELECT A1_COD, A1_LOJA, A1_NOME, A1_EST FROM "
cQuery += "             DADOSADV.SA1010"
cQuery += "             WHERE D_E_L_E_T_ = ' ')"
cQuery += "             ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI"
cQuery += " LEFT JOIN( SELECT  TITCODIGO,TRADOCUMENTO,MIN(TRADATAINCLUSAO) DATAINICONF, to_char(MIN(TRADATAINCLUSAO) , 'hh24:mi') HORAINICONF, "
cQuery += "             MAX(TRADATAINCLUSAO) DATAFIMCONF,to_char(MAX(TRADATAINCLUSAO), 'hh24:mi') HORAFIMCONF, SUM(TRAQUANTIDADE) QTDECONF, MIN(USRCODIGO) CONFERENTE"
cQuery += "             FROM BLUECYCLE.TRANSACAO TRANCONF "
//cQuery += "             WHERE TITCODIGO = 'CONFSEP' "
cQuery += "             GROUP BY TITCODIGO,TRADOCUMENTO"
cQuery += "             ) CONF"
cQuery += "             ON CONF.TRADOCUMENTO = C5.C5_NUM||'FAT' AND CONF.TITCODIGO = 'CONFSEP'"
cQuery += " LEFT JOIN( SELECT F2_DOC, F2_SERIE, F2_EMISSAO, F2_HORA"
cQuery += "             FROM DADOSADV.SF2010"
cQuery += "             WHERE D_E_L_E_T_ = ' ') FAT"
cQuery += "             ON F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE"
cQuery += "  LEFT JOIN( SELECT DCSCODIGO,OVLDATAEXPEDICAO DATAEXP,to_char(OVLDATAEXPEDICAO, 'hh24:mi') HORAEXP"
cQuery += "             FROM BLUECYCLE.OCVOLUME) EXP  "
cQuery += "             ON EXP.DCSCODIGO = C5.C5_NUM||'FAT'                       "
cQuery += "             WHERE C5.C5_FILIAL = '"+xFilial("SC5")+"' AND C5.C5_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' AND C5__STATUS <> '1' AND C5.D_E_L_E_T_ = ' ' "
cQuery += "             ORDER BY C5.C5_FILIAL, C5.C5_EMISSAO, C5.C5_NUM "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasLog,.T.,.T.)
//TCQUERY cQuery ALIAS "TRB" NEW   

//DbSelectArea("TRB")

//DbGotop()

//Do While !Eof("TRB")                       
While !Eof()
//Alert(trb->Hr_Inicio_Separacao)


	aItem := Array(Len(aHeader)+1)
	For nX := 1 to Len(aHeader)
		IF aHeader[nX][2] == "C"
			aItem[nX] := CHR(160)+(cAliasLog)->&(aHeader[nX][1])
		ELSE
			aItem[nX] := (cAliasLog)->&(aHeader[nX][1])
		ENDIF
	Next nX
	AADD(aCols,aItem)
	aItem := {}
	DbSelectArea(cAliasLog)
	DbSkip()
EndDO    

DbCloseArea(cAliasLog)

Return