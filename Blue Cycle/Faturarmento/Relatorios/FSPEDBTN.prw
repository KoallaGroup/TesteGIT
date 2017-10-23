#INCLUDE "rwmake.ch" 
#INCLUDE "topconn.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSPED     บ Autor ณ BRENO MENEZES      บ Data ณ  03/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FSPEDBTN


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := ""
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FSPED" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FSPED" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""
Public aSC5          := {}
Public aSC6          := {}
Public aSCJ          := {}
Public aSCK          := {}
Public aSE1          := {}
Public cClient       := SC5->C5_CLIENT
Public cNum          := SC5->C5_NUM
Public cEmissao      := SC5->C5_EMISSAO

FSTELPED()
//FSPEDORC()

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

SetRegua(RecCount())

If (Select("QSC5") <> 0)
   dbSelectArea("QSC5")
   dbCloseArea()
EndIf
/* ORIGINAL
cQuery := "SELECT A1_NOME,A1_END,A1_CGC,C5_CONDPAG,C5_EMISSAO,C5_NUM, A1_MUN,A1_BAIRRO,A1_EST,C5_NOTA,                                     "
cQuery += "SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) EMISSAO FROM "+RetSqlName("SC5")+" SC5    "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA                                                  "
cQuery += "WHERE SA1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = ''                                                                               "
cQuery += "AND A1_COD     BETWEEN '"+cClient+"' AND '"+cClient+"'                                                                          "
cQuery += "AND C5_NUM     BETWEEN '"+cNum+"' AND '"+cNum+"'                                                                                "  
cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(cEmissao)+"' AND '"+DTOS(cEmissao)+"'                                                            "
cQuery += "ORDER BY C5_NUM                                                                                                                 "
*/
//ALTERADO POR EVERTON SILVA EM 29/06/2011 - ACRESCENTADO CONTROLE POR FILIAL
cQuery := "SELECT A1_NOME,A1_END,A1_CGC,C5_CONDPAG,C5_EMISSAO,C5_NUM, A1_MUN,A1_BAIRRO,A1_EST,C5_NOTA,                                     "
cQuery += "SUBSTR(C5_EMISSAO,7,2)+'/'+SUBSTR(C5_EMISSAO,5,2)+'/'+SUBSTR(C5_EMISSAO,1,4) EMISSAO FROM "+RetSqlName("SC5")+" SC5    "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA                                                  "
cQuery += "WHERE SA1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = ''                                                                               "
cQuery += "AND A1_COD     BETWEEN '"+cClient+"' AND '"+cClient+"'                                                                          "
cQuery += "AND C5_NUM     BETWEEN '"+cNum+"' AND '"+cNum+"'                                                                                "  
cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(cEmissao)+"' AND '"+DTOS(cEmissao)+"'                                                            "
cQuery += "AND C5_FILIAL = '"+xFilial("SC5")+"'                                                                                                   "
cQuery += "ORDER BY C5_NUM                                                                                                                 "
TCQUERY cQuery ALIAS "QSC5" NEW 

QSC5->(dbGoTop())
While !QSC5->(EOF())
   
   aAdd(aSC5,{QSC5->A1_NOME,QSC5->C5_NUM,QSC5->EMISSAO,QSC5->A1_CGC,QSC5->A1_END,QSC5->A1_MUN,QSC5->A1_BAIRRO,QSC5->A1_EST,FSCOND(QSC5->C5_CONDPAG),QSC5->C5_NOTA})
	
   QSC5->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	

EndDo
If Substr(cOrd,1,2) == "02"  
	For i:=1 to Len(aSC5)
		
		Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSC5[i,1])+" PEDIDO: "+AllTrim(aSC5[i,2])+ " DATA: "+AllTrim(aSC5[i,3])+ " CNPJ: "+AllTrim(aSC5[i,4]) 
		Cabec1 := " ENDERECO : "+AllTrim(aSC5[i,5])+" CIDADE: "+AllTrim(aSC5[i,6])+" BAIRRO: "+AllTrim(aSC5[i,7])+" ESTADO: "+AllTrim(aSC5[i,8])+ " CONDICAO DE PAGAMENTO: "+AllTrim(aSC5[i,9])
		Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "
		FSITEM(aSC5[i,2]) 
		If AllTrim(aSC5[i,10]) <> "" 
	    	FSFIN(aSC5[i,10])
	    EndIf
	Next

	FSEXP(aSC6,Titulo,Cabec1)  
Else
	
	For i:=1 to Len(aSC5)
		
		Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSC5[i,1])+" PEDIDO: "+AllTrim(aSC5[i,2])+ " DATA: "+AllTrim(aSC5[i,3])+ " CNPJ: "+AllTrim(aSC5[i,4]) 
		Cabec1 := " ENDERECO : "+AllTrim(aSC5[i,5])+" CIDADE: "+AllTrim(aSC5[i,6])+" BAIRRO: "+AllTrim(aSC5[i,7])+" ESTADO: "+AllTrim(aSC5[i,8])+ " CONDICAO DE PAGAMENTO: "+AllTrim(aSC5[i,9])
	   	Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "
	   	
	    If lAbortPrint
	       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	       Exit
	    Endif
	
	    FSITEM(aSC5[i,2])
	
	    If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	    
	    Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSC5[i,1])+" PEDIDO: "+AllTrim(aSC5[i,2])+ " DATA: "+AllTrim(aSC5[i,3])+ " CNPJ: "+AllTrim(aSC5[i,4]) 
		Cabec1 := " ENDERECO : "+AllTrim(aSC5[i,5])+" CIDADE: "+AllTrim(aSC5[i,6])+" BAIRRO: "+AllTrim(aSC5[i,7])+" ESTADO: "+AllTrim(aSC5[i,8])+ " CONDICAO DE PAGAMENTO: "+AllTrim(aSC5[i,9])
	   	Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "
	   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 10
	    Endif
	   
		For j:=1 to Len(aSC6) 
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	    
			    Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSC5[i,1])+" PEDIDO: "+AllTrim(aSC5[i,2])+ " DATA: "+AllTrim(aSC5[i,3])+ " CNPJ: "+AllTrim(aSC5[i,4]) 
				Cabec1 := " ENDERECO : "+AllTrim(aSC5[i,5])+" CIDADE: "+AllTrim(aSC5[i,6])+" BAIRRO: "+AllTrim(aSC5[i,7])+" ESTADO: "+AllTrim(aSC5[i,8])+ " CONDICAO DE PAGAMENTO: "+AllTrim(aSC5[i,9])
			   	Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "
			   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			       nLin := 10
			Endif
					
			@nLin,002 PSAY aSC6[j,1]      							// Codigo do Produto
			@nLin,017 PSAY aSC6[j,2]      							// Referencia
			@nLin,040 PSAY aSC6[j,3]        						// Descricao do Produto
			@nLin,098 PSAY aSC6[j,4]    					    	// Numero do Pedido
			@nLin,111 PSAY aSC6[j,5]   							    // Descricao do Grupo
			@nLin,147 PSAY aSC6[j,6]  PICTURE "@E 99,999,999.99"    // Quantidade do Pedido
			@nLin,166 PSAY aSC6[j,7]  PICTURE "@E 99,999,999.99"    // Preco Unitario de Venda
			@nLin,184 PSAY aSC6[j,8]  PICTURE "@E 99,999,999.99"    // Total por Produto
			
	   		nLin := nLin + 1 // Avanca a linha de impressao
	    
	    Next   
	    nLin := nLin + 5
	    @nLin,002 PSAY " TOTAL GERAL: " 
	    @nLin,015 PSAY FSTOTAL(aSC5[i,2]) PICTURE "@E 99,999,999.99"
	    nLin := nLin + 3
	    
	    If AllTrim(aSC5[i,10]) <> "" 
	    	FSFIN(aSC5[i,10])
	        
	    	@nLin,002 PSAY " TITULO      PARCELA  TIPO    PREFIXO           VALOR       VENCIMENTO  "
	        
	    	nLin := nLin + 2 // Avanca a linha de impressao
	    	
	    	For j:=1 to Len(aSE1)
			
				@nLin,002 PSAY aSE1[j,1]      							// Titulo
				@nLin,017 PSAY aSE1[j,2]      							// Parcela
				@nLin,025 PSAY aSE1[j,3]        						// Tipo
				@nLin,035 PSAY aSE1[j,4]    					    	// Prefixo
				@nLin,045 PSAY aSE1[j,5]  PICTURE "@E 99,999,999.99"    // Valor
				@nLin,063 PSAY aSE1[j,6]      							// Vencimento
			
			
	   			nLin := nLin + 1 // Avanca a linha de impressao
	    
	    	Next
	    EndIf
	    
	    nLin := 56
	Next
	
	If (Select("QSCJ") <> 0)
	   dbSelectArea("QSCJ")
	   dbCloseArea()
	EndIf
                                                                                                                      			     
	cQuery5 := "SELECT A1_NOME,A1_END,A1_CGC,CJ_CONDPAG,CJ_EMISSAO,CJ_NUM, A1_MUN,A1_BAIRRO,A1_EST,                                          "
	cQuery5 += "SUBSTR(CJ_EMISSAO,7,2)+'/'+SUBSTR(CJ_EMISSAO,5,2)+'/'+SUBSTR(CJ_EMISSAO,1,4) EMISSAO FROM "+RetSqlName("SCJ")+" SCJ "
	cQuery5 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON CJ_CLIENTE+CJ_LOJA = A1_COD+A1_LOJA                                                  "
	cQuery5 += "WHERE SA1.D_E_L_E_T_ = '' AND SCJ.D_E_L_E_T_ = ''                                                                            "
	cQuery5 += "AND A1_COD     BETWEEN '"+cClient+"' AND '"+cClient+"'                                                                       "
	cQuery5 += "AND CJ_NUM     BETWEEN '"+cNum+"' AND '"+cNum+"'                                                                             "
	cQuery5 += "AND CJ_EMISSAO BETWEEN '"+DTOS(cEmissao)+"' AND '"+DTOS(cEmissao)+"'                                                         "
	cQuery5 += "ORDER BY CJ_NUM                                                                                                              "
               	                                                                                                                             "
	TCQUERY cQuery5 ALIAS "QSCJ" NEW  
	
	QSCJ->(dbGoTop())
	While !QSCJ->(EOF())
	   
	   aAdd(aSCJ,{QSCJ->A1_NOME,QSCJ->CJ_NUM,QSCJ->EMISSAO,QSCJ->A1_CGC,QSCJ->A1_END,QSCJ->A1_MUN,QSCJ->A1_BAIRRO,QSCJ->A1_EST,FSCOND(QSCJ->CJ_CONDPAG)})
		
	   QSCJ->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	
	
	EndDo
	
	For i:=1 to Len(aSCJ)
		
		Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSCJ[i,1])+" ORCAMENTO: "+AllTrim(aSCJ[i,2])+ " DATA: "+AllTrim(aSCJ[i,3])+ " CNPJ: "+AllTrim(aSCJ[i,4]) 
		Cabec1 := " ENDERECO : "+AllTrim(aSCJ[i,5])+" CIDADE: "+AllTrim(aSCJ[i,6])+" BAIRRO: "+AllTrim(aSCJ[i,7])+" ESTADO: "+AllTrim(aSCJ[i,8])+ " CONDICAO PAGAMENTO: "+AllTrim(aSCJ[i,9])
	   	Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "
	   	
	    If lAbortPrint
	       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	       Exit
	    Endif
	
	    FSITEMJ(aSCJ[i,2])
	
	    If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	       Titulo := "INFORMACOES SOBRE O CLIENTE: "+AllTrim(aSC5[i,1])+" PEDIDO: "+AllTrim(aSC5[i,2])+ " DATA: "+AllTrim(aSC5[i,3])+ " CNPJ: "+AllTrim(aSC5[i,4]) 
		   Cabec1 := " ENDERECO : "+AllTrim(aSC5[i,5])+" CIDADE: "+AllTrim(aSC5[i,6])+" BAIRRO: "+AllTrim(aSC5[i,7])+" ESTADO: "+AllTrim(aSC5[i,8])+ " CONDICAO DE PAGAMENTO: "+AllTrim(aSC5[i,9])
	   	   Cabec2 := " COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                                   QUANTIDADE        PRECO UNITARIO        TOTAL "	
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 10
	    Endif
	   
		For j:=1 to Len(aSCK)
			
			@nLin,002 PSAY aSCK[j,1]      							// Codigo do Produto
			@nLin,017 PSAY aSCK[j,2]      							// Referencia
			@nLin,040 PSAY aSCK[j,3]        						// Descricao do Produto
			@nLin,098 PSAY aSCK[j,4]    					    	// Numero do Pedido
			@nLin,111 PSAY aSCK[j,5]   							    // Descricao do Grupo
			@nLin,147 PSAY aSCK[j,6]  PICTURE "@E 99,999,999.99"    // Quantidade do Pedido
			@nLin,166 PSAY aSCK[j,7]  PICTURE "@E 99,999,999.99"    // Preco Unitario de Venda
			@nLin,184 PSAY aSCK[j,8]  PICTURE "@E 99,999,999.99"    // Total por Produto
			
	   		nLin := nLin + 1 // Avanca a linha de impressao
	    
	    Next
	    nLin := 56
	Next

	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	FSEXP(aSC6,Titulo,Cabec1) 
EndIf

Return

Static Function FSPEDORC()
//**************************************************************************************************************************************************
//Cria็ใo dos Parametros
//
//********** 
Private cPerg    :="FSPDOR"

ValidPerg(cPerg)
Pergunte(cPerg,.t.)

Return

Static Function ValidPerg(cPerg)
//**************************************************************************************************************************************************
//Grava pergunta no SX1
//
//***********************

Local _sAlias := Alias()                 	
Local aRegs := {}
Local i,j,nCampo

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aCampos := {"GRUPO","ORDEM","PERGUNT","VARIAVL","TIPO","TAMANHO","DECIMAL","PRESEL","GSC","VALID","VAR01","DEF01","CNT01","VAR01","DEF01","CNT01","VAR02","DEF02","CNT02","VAR03","DEF03","CNT03","VAR04","DEF04","CNT04","VAR05","DEF05","CNT05","F3"}
aAdd(aRegs,{cPerg,"01","De Emissao       ?","","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Emissao      ?","","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","De Cliente       ?","","","mv_ch3" ,"C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"04","Ate Cliente      ?","","","mv_ch4" ,"C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"05","Do Pedido        ?","","","mv_ch5" ,"C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SC5"})
aAdd(aRegs,{cPerg,"06","Ate Pedido       ?","","","mv_ch6" ,"C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SC5"})
aAdd(aRegs,{cPerg,"07","Do Orcamento     ?","","","mv_ch7" ,"C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SCJ"})
aAdd(aRegs,{cPerg,"08","Ate Orcamento    ?","","","mv_ch8" ,"C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SCJ"})
aAdd(aRegs,{cPerg,"09","Imprimir em      ?","","","mv_ch9" ,"C",02,0,0,"C","","MV_PAR09","Protheus","","","Excel","","","","","","","","","","",""})

If	!(DbSeek( cPerg  )   )

		For nX:=1 to Len(aRegs)
			If	DbSeek( cPerg + aRegs[nx][02] )   

			Else
				If	RecLock('SX1',.T.)
					Replace SX1->X1_GRUPO  		With aRegs[nx][01]
					Replace SX1->X1_ORDEM   	With aRegs[nx][02]
					Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
					Replace SX1->X1_PERSPA		With aRegs[nx][04]
					Replace SX1->X1_PERENG		With aRegs[nx][05]
					Replace SX1->X1_VARIAVL		With aRegs[nx][06]
					Replace SX1->X1_TIPO		With aRegs[nx][07]
					Replace SX1->X1_TAMANHO		With aRegs[nx][08]
					Replace SX1->X1_DECIMAL		With aRegs[nx][09]
					Replace SX1->X1_PRESEL		With aRegs[nx][10]
					Replace SX1->X1_GSC			With aRegs[nx][11]
					Replace SX1->X1_VALID		With aRegs[nx][12]
					Replace SX1->X1_VAR01		With aRegs[nx][13]
					Replace SX1->X1_DEF01		With aRegs[nx][14]
					Replace SX1->X1_DEF02		With aRegs[nx][17]
					Replace SX1->X1_DEF03		With aRegs[nx][20]
					Replace SX1->X1_DEF04		With aRegs[nx][23]
					Replace SX1->X1_DEF05		With aRegs[nx][26]
					Replace SX1->X1_F3   		With aRegs[nx][28]
					SX1->(MsUnlock())
				Else
					Help('',1,'REGNOIS')
				EndIf	
			Endif
		Next nX

EndIF


dbSelectArea(_sAlias)

Return NIL

Static Function FSCOND(cCond) 
//**************************************************************************************************************************************************
//Retorna a Condicao de Pagamento
//
//***********************       

If (Select("QSE4") <> 0)
   dbSelectArea("QSE4")
   dbCloseArea()
EndIf

cQuery1 := "SELECT E4_DESCRI FROM "+RetSqlName("SE4")+" WHERE D_E_L_E_T_ = '' AND E4_CODIGO = '"+cCond+"' AND E4_FILIAL = '"+xFilial("SE4")+"'"

TCQUERY cQuery1 ALIAS "QSE4" NEW 

Return(QSE4->E4_DESCRI)   

Static Function FSITEM(cNum)  
//**************************************************************************************************************************************************
//Retorna os Itens dos Produtos
//
//***********************  
Public aSC6 := {}

If (Select("QSC6") <> 0)
   dbSelectArea("QSC6")
   dbCloseArea()
EndIf

cQuery2 := "SELECT C6_PRODUTO,C6_DESCRI,C6_UM,C6_QTDVEN,                                        "
cQuery2 += "C6_PRCVEN,C6_VALOR FROM "+RetSqlName("SC6")+" WHERE D_E_L_E_T_ = ''                 "
cQuery2 += "AND C6_NUM =  '"+cNum+"'                                                            "
cQuery2 += "AND C6_FILIAL = '"+xFilial("SC6")+"'                                                "

TCQUERY cQuery2 ALIAS "QSC6" NEW   

QSC6->(dbGoTop())
While !QSC6->(EOF())
   
   aAdd(aSC6,{QSC6->C6_PRODUTO,FSYREF(QSC6->C6_PRODUTO),QSC6->C6_DESCRI,QSC6->C6_UM,FSDESCGRU(QSC6->C6_PRODUTO),QSC6->C6_QTDVEN,QSC6->C6_PRCVEN,QSC6->C6_VALOR,""})           
   
   QSC6->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	

EndDo

Return()

Static Function FSYREF(cCond) 
//**************************************************************************************************************************************************
//Retorna as Referencias
//
//***********************  

If (Select("QSB1R") <> 0)
   dbSelectArea("QSB1R")
   dbCloseArea()
EndIf

cQuery3 := "SELECT B1_YREF FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ = '' AND B1_COD = '"+cCond+"' AND B1_FILIAL = '"+xFilial("SB1")+"'    "

TCQUERY cQuery3 ALIAS "QSB1R" NEW 

Return(QSB1R->B1_YREF)

Static Function FSDESCGRU(cCod) 
//**************************************************************************************************************************************************
//Retorna as Referencias
//
//***********************  

If (Select("QSB1D") <> 0)
   dbSelectArea("QSB1D")
   dbCloseArea()
EndIf

cQuery4 := "SELECT B1_DESCGRU FROM "+RetSqlName("SB1")+" WHERE D_E_L_E_T_ = '' AND B1_COD = '"+cCod+"' AND B1_FILIAL = '"+xFilial("SB1")+"'    "

TCQUERY cQuery4 ALIAS "QSB1D" NEW 

Return(QSB1D->B1_DESCGRU)

Static Function FSITEMJ(cNum)  
//**************************************************************************************************************************************************
//Retorna os Itens dos Produtos
//
//***********************  
aSCK := {}

If (Select("QSCK") <> 0)
   dbSelectArea("QSCK")
   dbCloseArea()
EndIf

cQuery6 := "SELECT CK_PRODUTO,CK_DESCRI,CK_UM,CK_QTDVEN,   				             "
cQuery6 += "CK_PRCVEN,CK_VALOR FROM "+RetSqlName("SCK")+" WHERE D_E_L_E_T_ = ''      "
cQuery6 += "AND CK_NUM =  '"+cNum+"'      "                           				 "
cQuery6 += "ORDER BY CK_NUM                                       				     "

TCQUERY cQuery6 ALIAS "QSCK" NEW   

QSCK->(dbGoTop())
While !QSCK->(EOF())
   
   aAdd(aSCK,{QSCK->CK_PRODUTO,FSYREF(QSCK->CK_PRODUTO),QSCK->CK_DESCRI,QSCK->CK_UM,FSDESCGRU(QSCK->CK_PRODUTO),QSCK->CK_QTDVEN,QSCK->CK_PRCVEN,QSCK->CK_VALOR})           
   
   QSCK->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	

EndDo

Return()   

Static Function FSFIN(cNum)  
//**************************************************************************************************************************************************
//Retorna os Itens dos Produtos
//
//***********************  
Public aSE1 := {}

If (Select("QSE1") <> 0)
   dbSelectArea("QSE1")
   dbCloseArea()
EndIf

cQuery7 := "SELECT E1_NUM,E1_PARCELA,E1_TIPO,E1_PREFIXO,E1_VALOR,                                                                  "
cQuery7 += "SUBSTR(E1_VENCTO,7,2)+'/'+SUBSTR(E1_VENCTO,5,2)+'/'+SUBSTR(E1_VENCTO,1,4) EMISSAO FROM "+RetSqlName("SE1")+"  " 
cQuery7 += "WHERE D_E_L_E_T_ = '' AND E1_NUM = '"+cNum+"'                                                                          "
cQuery7 += "AND E1_FILIAL = '"+xFilial("SE1")+"'                                                                                   "

TCQUERY cQuery7 ALIAS "QSE1" NEW   

QSE1->(dbGoTop())
While !QSE1->(EOF())
   
   aAdd(aSE1,{QSE1->E1_NUM,QSE1->E1_PARCELA,QSE1->E1_TIPO,QSE1->E1_PREFIXO,QSE1->E1_VALOR,QSE1->EMISSAO,"",""})           
   
   QSE1->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	

EndDo

Return()

Static Function FSTOTAL(cCod) 
//**************************************************************************************************************************************************
//Retorna o Total dos Produtos
//
//***********************  

If (Select("QSC61") <> 0)
   dbSelectArea("QSC61")
   dbCloseArea()
EndIf

cQuery8 := "SELECT SUM(C6_VALOR) TOTAL FROM "+RetSqlName("SC6")+" WHERE D_E_L_E_T_ = '' AND C6_NUM = '"+cCod+"' AND C6_FILIAL = '"+xFilial("SC6")+"'"

TCQUERY cQuery8 ALIAS "QSC61" NEW 

Return(QSC61->TOTAL)  

Static Function FSEXP(aSC6,Titulo,Cabec1)
//*****************************************************************************************************************
// Fun็ใo para exportar arquivos em excel.
//
//************

Local aCabExcel    := {}
Local aItensExcel  := {}    
Local aCabExcel1   := {}
Local aItensExcel1 := {}
Public aItens6     := {"Titulo","Parcela","Tipo","Prefixo","Valor","Vencimento",".","." }

// Aadd (aCabExcel,{"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAL})
Aadd (aCabExcel, { "Codigo Produto" , "C", 006, 0 }) 
Aadd (aCabExcel, { "Referencia"     , "C", 020, 0 })  
Aadd (aCabExcel, { "Descricao"      , "C", 050, 0 }) 
Aadd (aCabExcel, { "Unidade"        , "C", 002, 0 })
Aadd (aCabExcel, { "Marca"          , "C", 020, 0 })
Aadd (aCabExcel, { "Quantidade"     , "N", 020, 2 })
Aadd (aCabExcel, { "Preco Unitario" , "N", 020, 2 })
Aadd (aCabExcel, { "Total"          , "N", 020, 2 })
Aadd (aCabExcel, { "."              , "C", 006, 0 })  

Aadd (aCabExcel1, { "Titulo"      , "C", 010, 0 }) 
Aadd (aCabExcel1, { "Parcela"     , "C", 020, 0 })  
Aadd (aCabExcel1, { "Tipo"        , "C", 010, 0 }) 
Aadd (aCabExcel1, { "Prefixo"     , "C", 010, 0 })
Aadd (aCabExcel1, { "Valor"       , "N", 020, 2 })
Aadd (aCabExcel1, { "Vencimento"  , "C", 010, 0 })
Aadd (aCabExcel1, { "."           , "C", 006, 0 }) 
Aadd (aCabExcel1, { "."           , "C", 006, 0 })  


MsgRun("Favor Aguardar...", "Selecionando os Registros", {||FSPROITN(aCabExcel, @aItensExcel,aSC6)}) 
MsgRun("Favor Aguardar...", "Selecionando os Registros", {||FSPROIT(aCabExcel1, aItensExcel1,aSE1)})

MsgRun("Favor Aguardar...", "Exportando os Registros para o Excel", ;
{||DlgToExcel ({{ "GETDADOS", Titulo, aCabExcel, aItensExcel }})})

Return

Static Function FSPROITN(aHeader, aCols,aSC6)
//*************************************************************************************************************************************************
//Gera Itens Para Exportar Para Excel
//
//******************************

Local aItem
Local nX  
Local lVerifi := .t.
Local nTes    := .f.
Local nVerifi := .f. 
Local nVerif  := .f.

For j := 1  to Len(aSC6)

	aItem := Array(Len(aHeader))
		
	For nX := 1 to Len(aHeader)
	
		If aHeader[nx][2] == "C"
			aItem[nx] := Chr(160)+aSC6[j,nx]
		Else
			aItem[nx] := aSC6[j,nx] 
		EndIf
	Next
		
	Aadd(aCols, aItem)

Next

Static Function FSPROIT(aHeader, aCols1,aSE1)
//*************************************************************************************************************************************************
//Gera Itens Para Exportar Para Excel
//
//******************************

Local aItem1
Local nX  
Local lVerifi := .t.
Local nTes    := .f.
Local nVerifi := .f. 
Local nVerif  := .f.

Aadd(aCols1, aItens6)

For j := 1  to Len(aSE1)

	aItem1 := Array(Len(aHeader))
		
	For nX := 1 to Len(aHeader)
	
		If aHeader[nx][2] == "C"
			aItem1[nx] := Chr(160)+aSE1[j,nx]
		Else
			aItem1[nx] := aSE1[j,nx] 
		EndIf
	Next
		
	Aadd(aCols1, aItem1)

Next

Return 

Static Function FSTELPED()

Local lRet      := .t. 
Public cOrd    
Public cEsc     := {"01 - Protheus","02 - Excel"}        


@ 000,00 TO 100,300 DIALOG oDlg TITLE "Relatorio de Pedidos"
@ 010,10 SAY "Gerar Relatorio: "
@ 010,55 COMBOBOX cOrd ITEMS cEsc SIZE 80,60       
@ 025,10 BUTTON "_Confirma" size 35,15 action FSCANCEL()
@ 025,50 BUTTON "_Sair" size 35,15 action FSCANCEL()

activate dialog oDlg Centered  

Static Procedure FSCANCEL()     
//*****************************************************************************************************************
// Fun็ใo para cancelar a rotina.
//
//**********

	close(odlg)
return	    

//0123456789012345678901345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          10        20       30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
// COD PRODUTO    REFERENCIA            DESCRICAO                                                 UNIDADE      MARCA                               QUANTIDADE         PRECO UNITARIO    TOTAL
//  999999         999999999999999       9999999999999999999999999999999999999999999999999999      99           9999999999999999999999999999999     999999999999999    999999999999999   9999999999999999

//012356789012345678901234567890123456789012345678901234567890123456789
//         10        20        30        40        50
// TITULO    PARCELA TIPO   PREFIXO       VALOR                EMISSAO 
// 999999      999    999    99999   9999999999999999                