#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDRGP210   บ Autor ณ Mauricio Cardoso   บ Data ณ  10/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissao dos Recibos de Pagamento no Formato Grafico        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RECGRAC


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Recibos de Pagamento"
Local cPict          := ""
Local titulo         := "Recibos de Pagamento"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {"Matricula","C Custo+Nome"}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "DRGP210"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RECPAG"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "DRGP210"
Private oPrint       := TMSPrinter():New()

Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

fAsrPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  16/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem :=  aReturn[8] 
Local cStartPath:= GetSrvProfString("Startpath","")
Local nSalBase, nSalContr, nBaseFgts, nFgts, nBaseIrrf, nFxIr
Local aMeses, cMesRef, cFilAnt

Local dDataRef, nTpImp, cFilDe, cFilAte, cMatDe, cMatAte, cMens1, cMens2, cMens3, dDtPagto, cRPagto, cDataRef
Local cRodape
Local cMensagem1, cMensagem2, cMensagem3, cMensagem4, i
Local nLinFim, nPrimeiro

Local nContador, nRecibos, nRecLin, lAsrPrint, lCont1, lCont2

Local aOrdBag  := {}
Local cArqMov  := ""
Local _cAnoMes := ""

Private oFont01, oFont02, oFont03, oFont04
Private cFont1 := ""
Private cFont2 := ""
Private cFont3 := ""
Private cFont4 := ""
Private aInfo

Private cAliasMov := ""


Pergunte(cPerg,.F.)
 dDataRef  := mv_par01 
 nTpImp    := mv_par02 
 cFilDe    := mv_par03 
 cFilAte   := mv_par04 
 cMatDe    := mv_par05 
 cMatAte   := mv_par06 
 cMens1    := mv_par07 
 cMens2    := mv_par08 
 cMens3    := mv_par09
 dDtPagto  := mv_par10
 cRPagto   := If(mv_par11==1,"R1","R2")

cDataRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
cDataRef := If(nTpImp==4,"13"+Right(cDataRef,4),cDataRef)
_cAnoMes := StrZero(Year(dDataRef),4) + StrZero(Month(dDataRef),2)

aMeses  := {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
cMesRef := aMeses[Month(dDataRef)]+"/"+Str(Year(dDataRef),4)


oFont01	:= TFont():New("Tahoma",07,07,,.T.,,,,.T.,.F.)
oFont02	:= TFont():New("Tahoma",14,10,,.T.,,,,.T.,.F.)
oFont03	:= TFont():New("Tahoma",12,10,,.T.,,,,.T.,.F.)
oFont04	:= TFont():New("Tahoma",08,08,,.T.,,,,.T.,.F.)

cFont1 := oFont01
cFont2 := oFont02
cFont3 := oFont03
cFont4 := oFont04

cFilAnt := "@@"

dbSelectArea("SA6")
dbSetOrder(1)
//dbSelectArea("SI3")
dbSelectArea("CTT")
dbSetOrder(1)
dbSelectArea("SRJ")
dbSetOrder(1)
dbSelectArea("SRX")
dbSetOrder(1)

cMensagem1 := "" ; cMensagem2 := "" ; cMensagem3 := "" ; cMensagem4 := ""
If SRX->(dbSeek( xFilial("SRX")+"06  "+cMens1 ))
   cMensagem1 := Left(SRX->RX_TXT,30)
EndIf
If SRX->(dbSeek( xFilial("SRX")+"06  "+cMens2 ))
   cMensagem2 := Left(SRX->RX_TXT,30)
EndIf
If SRX->(dbSeek( xFilial("SRX")+"06  "+cMens3 ))
   cMensagem3 := Left(SRX->RX_TXT,30)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Opensrc( cDataRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL , NIL )
	Return(  NIL )
Endif

dbSelectArea("SRA")
If nOrdem == 2
dbSetOrder(8)
Else
dbSetOrder(1)
Endif

SetRegua(RecCount())
dbGoTop()


nLinFim   := 1600
nPrimeiro := 1
Do While !Eof()
   IncRegua()
   If lAbortPrint
      oPrint:Say(nLin,050 ,"*** CANCELADO PELO OPERADOR ***",oFont01)
      Exit
   Endif
   
   If (SRA->RA_FILIAL  < cFilDe  .Or. SRA->RA_FILIAL  > cFilAte) .Or. ;
      (SRA->RA_MAT     < cMatDe  .Or. SRA->RA_MAT     > cMatAte)
      dbSkip()
      Loop
   EndIf
   
//   If SRA->RA_SITFOLH == "D" .And. MesAno(dDataRef) >= MesAno(SRA->RA_DEMISSA)
//      dbSkip()
//      Loop
//   EndIf

   If SRA->RA_FILIAL # cFilAnt
      If !fInfo(@aInfo,SRA->RA_FILIAL)
         Exit
      EndIf
      cFilAnt := SRA->RA_FILIAL
   EndIf
   
   nSalBase := 0 ; nSalContr := 0 ; nBaseFgts := 0 ; nFgts := 0 ; nBaseIrrf := 0 ; nFxIr := 0

   dbSelectArea("SRV")
   dbSetOrder(1)
   aProv := {}
   aDesc := {}
   nTotProv := 0
   nTotDesc := 0
   
   If nTpImp # 4   // Adiantamento - Folha - 1a Parcela
      dbSelectArea("SRD")
      dbSetOrder(1)
      dbSeek( SRA->(RA_FILIAL+RA_MAT+_cAnoMes) )
      Do While !Eof() .And. SRD->(RD_FILIAL+RD_MAT) == SRA->(RA_FILIAL+RA_MAT) .And. SRD->RD_DATARQ == _cAnoMes
         SRV->(dbSeek( xFilial("SRV")+SRD->RD_PD ))
      
         If nTpImp == 1   // Adiantamento
            If SRV->RV_CODFOL == "0007"
               SRV->(dbSetOrder(2))
               SRV->(dbSeek( xFilial("SRV")+"0006" ))
               Aadd(aProv,{SRV->RV_COD,SRV->RV_DESC,SRD->RD_HORAS,SRD->RD_VALOR,0})
               nTotProv += SRD->RD_VALOR
               SRV->(dbSetOrder(1))
            ElseIf SRV->RV_CODFOL == "0008"
               Aadd(aProv,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,SRD->RD_VALOR,0})
               nTotProv += SRD->RD_VALOR
            ElseIf SRV->RV_CODFOL == "0012"
               SRV->(dbSetOrder(2))       
               SRV->(dbSeek( xFilial("SRV")+"0009" ))
               Aadd(aDesc,{SRV->RV_COD,SRV->RV_DESC,SRD->RD_HORAS,0,SRD->RD_VALOR})
               nTotDesc += SRD->RD_VALOR
               SRV->(dbSetOrder(1))
            EndIf
         ElseIf nTpImp == 2   // Folha                           
         	/*If SRD->RD_PD != '120' .And. SRD->RD_PD != '121' .And. SRD->RD_PD != '122' .And. SRD->RD_PD != '126' .And. SRD->RD_PD != '146' .And. SRD->RD_PD != '147';
              	 .And. SRD->RD_PD != '158' .And. SRD->RD_PD != '159' .And. SRD->RD_PD != '188' .And. SRD->RD_PD != '491' .And. SRD->RD_PD != '495' .And. SRD->RD_PD != '461';
            	  .And. SRD->RD_PD != '207' .And. SRD->RD_PD != '244'.And. SRD->RD_PD != '404' .AND. SRD->RD_PD != '447' .And. SRD->RD_PD != '125'        */
	            If SRV->RV_TIPOCOD == "1"
	               Aadd(aProv,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,SRD->RD_VALOR,0})
	               nTotProv += SRD->RD_VALOR
	            ElseIf SRV->RV_TIPOCOD == "2"
	               Aadd(aDesc,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,0,SRD->RD_VALOR})
	               nTotDesc += SRD->RD_VALOR
	            EndIf
        
	            If SRV->RV_CODFOL == "0013"
	               nSalContr  := SRD->RD_VALOR
	            EndIf
	            If SRV->RV_CODFOL == "0017"
	               nBaseFgts  := SRD->RD_VALOR
	            EndIf
	            If SRV->RV_CODFOL == "0018"
	               nFgts      := SRD->RD_VALOR
	            EndIf
	            If SRV->RV_CODFOL == "0015"
	               nBaseIrrf  := SRD->RD_VALOR
	            EndIf
	            If SRV->RV_CODFOL == "0066"
	               nFxIr      := SRD->RD_HORAS
	            EndIf 
	       	//EndIf
         ElseIf nTpImp == 3   // 1a Parcela
            If SRV->RV_CODFOL == "0022" .Or. SRV->RV_COD == "137"
               Aadd(aProv,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,SRD->RD_VALOR,0})
               nTotProv += SRD->RD_VALOR
            EndIf
            If SRV->RV_CODFOL == "0108"
               nBaseFgts  := SRD->RD_VALOR
            EndIf
            If SRV->RV_CODFOL == "0109"
               nFgts      := SRD->RD_VALOR
            EndIf
         
         ElseIf nTpImp == 5   // F้rias
            
            If SRD->RD_PD = '120' .OR. SRD->RD_PD = '121' .OR. SRD->RD_PD = '122' .OR. SRD->RD_PD = '126' .OR. SRD->RD_PD = '146' .OR. SRD->RD_PD = '147';
            	 .OR. SRD->RD_PD = '158' .OR. SRD->RD_PD = '159' .OR. SRD->RD_PD = '188' .OR. SRD->RD_PD = '491' .OR. SRD->RD_PD = '495' .OR. SRD->RD_PD = '461';
            	  .OR. SRD->RD_PD = '207' .OR. SRD->RD_PD = '244' .OR. SRD->RD_PD = '447'
	            If SRV->RV_TIPOCOD == "1"
	               Aadd(aProv,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,SRD->RD_VALOR,0})
	               nTotProv += SRD->RD_VALOR
	            ElseIf SRV->RV_TIPOCOD == "2"
	               Aadd(aDesc,{SRD->RD_PD,SRV->RV_DESC,SRD->RD_HORAS,0,SRD->RD_VALOR})
	               nTotDesc += SRD->RD_VALOR
	            EndIf
	        EndIf
         
         
         
         
         EndIf
      
         dbSkip()
      EndDo
   Else  // 2a Parcela
      dbSelectArea("SRI")
      dbSetOrder(1)
      dbSeek( SRA->(RA_FILIAL+RA_MAT) )
      Do While !Eof() .And. SRI->(RI_FILIAL+RI_MAT) == SRA->(RA_FILIAL+RA_MAT)
         SRV->(dbSeek( xFilial("SRV")+SRI->RI_PD ))

         If SRV->RV_TIPOCOD == "1"
            Aadd(aProv,{SRI->RI_PD,SRV->RV_DESC,SRI->RI_HORAS,SRI->RI_VALOR,0})
            nTotProv += SRI->RI_VALOR
         ElseIf SRV->RV_TIPOCOD == "2"
            Aadd(aDesc,{SRI->RI_PD,SRV->RV_DESC,SRI->RI_HORAS,0,SRI->RI_VALOR})
            nTotDesc += SRI->RI_VALOR
         EndIf
           
         If SRV->RV_CODFOL == "0019"
            nSalContr  := SRI->RI_VALOR
         EndIf
         If SRV->RV_CODFOL == "0108"
            nBaseFgts  := SRI->RI_VALOR
         EndIf
         If SRV->RV_CODFOL == "0109"
            nFgts      := SRI->RI_VALOR
         EndIf
         If SRV->RV_CODFOL == "0027"
            nBaseIrrf  := SRI->RI_VALOR
         EndIf
         If SRV->RV_CODFOL == "0071"
            nFxIr      := SRI->RI_HORAS
         EndIf

         dbSkip()
      EndDo
   EndIf
   nSalBase   := If(SRA->RA_CATFUNC=="H",Round(SRA->RA_SALARIO * SRA->RA_HRSMES,2),SRA->RA_SALARIO)
   If nTpImp == 1   // Adiantamento
      aProv := Asort( aProv,,,{|x,y| x[1] < y[1]} )
      aDesc := Asort( aDesc,,,{|x,y| x[1] < y[1]} )
   EndIf
   dbSelectArea("SRA")
   If Len(aProv) == 0 .And. Len(aDesc) == 0
      dbSkip()
      Loop
   EndIf
   
   cMensagem4 := ""
   If Month(dDataRef) == Month(SRA->RA_NASC)
      cMensagem4 := "***  FELIZ ANIVERSARIO!!  ***"
   EndIf

   If nPrimeiro == 1
      oPrint:StartPage()  // Inicializa a Pagina
      nLinFim  := 1600
   Else
      nLinFim  := 3200
   EndIf

   SA6->(dbSeek( xFilial("SA9")+SRA->RA_BCDEPSA ))
   //SI3->(dbSeek( xFilial("SI3")+SRA->RA_CC ))
   CTT->(dbSeek( xFilial("CTT")+SRA->RA_CC ))
   SRJ->(dbSeek( xFilial("SRJ")+SRA->RA_CODFUNC ))
   SM0->(DbSeek( "01"+SRA->RA_FILIAL))


   Aeval(aDesc,{|x| Aadd(aProv,x)})
   nContador := 1
   nRecLin   := 0
   lCont1    := .F.
   lCont2    := .F.
   lAsrPrint := .T.
   For nRecibos := 1 To 3

       If nPrimeiro == 1
          nLin := 40                                                      // nLin := 40
       Else
          nLin := 1640                                                     // nLin := 1640
       EndIf                 
       
        // IMPRESSAO DO LOGOTIPO
   		aBmp2 :=  "\SYSTEM\LGRL0101_rec.BMP"  

       // SAYBITMAP( LINHA, COLUNHA, FIGURA, LARGURA, ALTURA )
     
       oPrint:SayBitmap( 0030,0140,aBmp2,0600,0140 )
       
   	   oPrint:SayBitmap( 1620,0140,aBmp2,0600,0140 )   //MAURICIO LOGO DA 2ชPAGINA

       // FIM DA IMPRESSAO DO LOGOTIPO 
       
       // Box
       oPrint:Say(nLin,0950 ,"Demonstrativo de Pagamento de Salario",cFont3)     //0900
       nLin+=150
       oPrint:Box(nLin ,080 ,nLinFim ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
      
       // Nome da Empresa
     /*   If SRA->RA_FILIAL=="01"
		       oPrint:Say(nLin,100 ,SM0->M0_CODFIL+" - "+Upper(SM0->M0_NOMECOM),cFont2)
	    	   oPrint:Say(nLin,1350 ,"CNPJ: "+"61.115.630/0001-04",cFont2)
    	   	   oPrint:Say(nLin,1850 ,"Filial: "+ "01")  
         Elseif   SRA->RA_FILIAL=="02"
		       oPrint:Say(nLin,100 ,SM0->M0_CODFIL+" - "+Upper(SM0->M0_NOMECOM),cFont2)
	    	   oPrint:Say(nLin,1350 ,"CNPJ: "+"99.999.999/9999-99",cFont2)
    	   	   oPrint:Say(nLin,1850 ,"Filial: "+ "02" )
		Elseif   SRA->RA_FILIAL=="03"
		       oPrint:Say(nLin,100 ,SM0->M0_CODFIL+" - "+Upper(SM0->M0_NOMECOM),cFont2)
	    	   oPrint:Say(nLin,1350 ,"CNPJ: "+"99.999.999/9999-99",cFont2)
    	   	   oPrint:Say(nLin,1850 ,"Filial: "+ "03" )   	   	          
		Elseif   SRA->RA_FILIAL=="04"
		       oPrint:Say(nLin,100 ,SM0->M0_CODFIL+" - "+Upper(SM0->M0_NOMECOM),cFont2)
	    	   oPrint:Say(nLin,1350 ,"CNPJ: "+"99.999.999/9999-99",cFont2)
    	   	   oPrint:Say(nLin,1850 ,"Filial: "+ "04" )                
		Endif   */
		              

	/*	dbSelectArea("SM0")
		dbSetOrder(1)
		dbSeek("01"+TRB->RA_FILIAL)*/
       
       
       oPrint:Say(nLin,100 ,SM0->M0_CODFIL+" - "+Upper(SM0->M0_NOMECOM),cFont2)
       oPrint:Say(nLin,1350 ,"CNPJ: "+Transform(SM0->M0_CGC,"@R ##.###.###/####-##"),cFont2)       //1350   MAURICIO
//       oPrint:Say(nLin,1950 ,"Filial: "+Upper(SM0->M0_FILIAL))                                     // 1450  filial Mauricio
       oPrint:Say(nLin,1950 ,Upper(SM0->M0_FILIAL))                                     // 1450  filial Mauricio       
       
  
       nLin+=40
       // Linha e Coluna
       oPrint:line(nLin-050,1300 ,nLin,1300 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1920,nLin,1920 )													//Linha Vertical Meio   1800 MAURICIO	
       oPrint:line(nLin ,080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
       // Cidade - Estado - Cnpj e Competencia
       oPrint:Say(nLin,100 ,"Cidade: "+Upper(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT,cFont2)
       oPrint:Say(nLin,1350 ,"Competencia : "+cMesRef,cFont3)
       nLin+=40
       // Linha e Coluna
       oPrint:line(nLin-050,1300 ,nLin,1300 )													//Linha Vertical Meio	
       oPrint:line(nLin ,080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
       // Dados Cadastrais
       oPrint:Say(nLin,100 ,"Mat: "+SRA->RA_MAT ,cFont3)
       oPrint:Say(nLin,450 ,"Nome: "+SRA->RA_NOME ,cFont3)
       oPrint:Say(nLin,1350 ,"Funcao: "+SRJ->RJ_DESC ,cFont3)
       nLin+=40
       // Linha e Coluna
       oPrint:line(nLin-050,400 ,nLin,400 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1300 ,nLin,1300 )													//Linha Vertical Meio	
       oPrint:line(nLin ,080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
       // Dados Cadastrais II
       oPrint:Say(nLin,100 ,"CBO: "+SRJ->RJ_CODCBO ,cFont3)
       //oPrint:Say(nLin,450 ,"Depto: "+SRA->RA_CC+" - "+SI3->I3_DESC ,cFont3)
      oPrint:Say(nLin,450 ,"Depto: "+SRA->RA_CC+" - "+CTT->CTT_DESC01 ,cFont3)
      oPrint:Say(nLin,1350 ,"Data Admissao: "+Dtoc(SRA->RA_ADMISSA) ,cFont3)
       nLin+=40
       // Linha e Coluna
       oPrint:line(nLin-050,400 ,nLin,400 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1300 ,nLin,1300 )													//Linha Vertical Meio	
       oPrint:line(nLin ,080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
       // Barra Separacao
       oPrint:Say(nLin,100 ,"COD" ,cFont3)
       oPrint:Say(nLin,250 ,"DESCRICAO" ,cFont3)
       oPrint:Say(nLin,1060 ,"REFERENCIA" ,cFont3)       //1070
       oPrint:Say(nLin,1440 ,"PROVENTOS" ,cFont3)        //1350
       oPrint:Say(nLin,1900 ,"DESCONTOS" ,cFont3)        //1800
       nLin+=40
       // Linha e Coluna
       oPrint:line(nLin-050,200 ,nLin,200 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1050 ,nLin,1050 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1300 ,nLin,1300 )													//Linha Vertical Meio	
       oPrint:line(nLin-050,1750 ,nLin,1750 )													//Linha Vertical Meio	
       oPrint:line(nLin ,080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
       oPrint:Box(nLin ,0080 ,If(nPrimeiro==1,1300,2900) ,0200) 					 	  							 //Linha Horizontal
       oPrint:Box(nLin ,0200 ,If(nPrimeiro==1,1300,2900) ,1050) 					 	  							 //Linha Horizontal
       oPrint:Box(nLin ,1050 ,If(nPrimeiro==1,1300,2900) ,1300) 					 	  							 //Linha Horizontal
       oPrint:Box(nLin ,1300 ,If(nPrimeiro==1,1300,2900) ,1750) 					 	  							 //Linha Horizontal
       oPrint:Box(nLin ,1750 ,If(nPrimeiro==1,1300,2900) ,2250) 					 	  							 //Linha Horizontal
       nLin+=10
 
       // Impressao dos Itens do Recibo
       If Len(aProv) > 0
          For i := nContador To Len(aProv)
              oPrint:Say(nLin,100 ,aProv[i,1] ,cFont3)
              oPrint:Say(nLin,250 ,aProv[i,2] ,cFont3)
              oPrint:Say(nLin,1250 ,Transform(aProv[i,3],'@E 999.99') ,cFont3,,,,1)             //1130
              If aProv[i,4] > 0
                 oPrint:Say(nLin,1700 ,Transform(aProv[i,4],'@E 9,999,999.99') ,cFont3,,,,1)    //1450
              Else
                 oPrint:Say(nLin,2200 ,Transform(aProv[i,5],'@E 9,999,999.99') ,cFont3,,,,1)    //1950
              EndIf
              nLin+=40
              nRecLin++
              If i == Len(aProv)
                 lAsrPrint := .T.
                 Exit
              ElseIf nRecLin == 20
                 lAsrPrint := .F.
                 lCont1    := .T.
                 lCont2    := .F.
                 nRecLin   := 0
                 Exit
              EndIf
          Next
          nContador := If(!lAsrPrint,i+1,1)
       EndIf
   
       If nPrimeiro == 1
          nLin := 1300
       Else
          nLin := 2900
       EndIf
    




       oPrint:Box(nLin ,0080 ,nLinFim ,2250) 					 	  							 //Linha Horizontal       2250 MAURICIO
       oPrint:Box(nLin ,1300 ,nLin+180 ,2250) 					 	  							 //Linha Horizontal       2250 MAURICIO
       If(lAsrPrint,oPrint:Say(nLin,0100 ,cMensagem1 ,cFont3),"")
       nLin += 40
       // Totais de Proventos e Descontos
       If(lAsrPrint,oPrint:Say(nLin,0100 ,cMensagem2 ,cFont3),"")
       If(lAsrPrint,oPrint:Say(nLin,1700 ,Transform(nTotProv,'@E 9,999,999.99') ,cFont3,,,,1),oPrint:Say(nLin,1700 ,"*,***,***.**" ,cFont3,,,,1))     //1450  MAURICIO
       If(lAsrPrint,oPrint:Say(nLin,2200 ,Transform(nTotDesc,'@E 9,999,999.99') ,cFont3,,,,1),oPrint:Say(nLin,2200 ,"*,***,***.**" ,cFont3,,,,1))     //1950  MAURICIO 
       nLin += 40
       If(lAsrPrint,oPrint:Say(nLin,0100 ,cMensagem3 ,cFont3),"")
       If lCont1
          oPrint:Say(nLin,0800 ,"C O N T I N U A" ,cFont3)
          lCont1 := .F.  ; lCont2 := .T.
       ElseIf lCont2
          oPrint:Say(nLin,0800 ,"C O N T I N U A C A O" ,cFont3)
          lCont1 := .F.  ; lCont2 := .F.
       EndIf       
       nLin += 20
       oPrint:line(nLin ,1300 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin += 20
       If(lAsrPrint,oPrint:Say(nLin,0100 ,cMensagem4 ,cFont3),"")
       If(lAsrPrint,oPrint:Say(nLin,1450 ,"Total Liquido" ,cFont3),"")
       If(lAsrPrint,oPrint:Say(nLin,2200 ,Transform(nTotProv-nTotDesc,'@E 9,999,999.99') ,cFont3,,,,1),oPrint:Say(nLin,2200 ,"*,***,***.**" ,cFont3,,,,1))    // 1950 MAURICIO
       nLin += 60
       oPrint:line(nLin ,0080 ,nLin ,2250) 					 	  							 //Linha Horizontal
  
       //nLin := 1480
   
       oPrint:line(nLin ,0441 ,nLin+70 ,0441) 					 	  							 //Linha Horizontal
       oPrint:line(nLin ,0802 ,nLin+70 ,0802) 					 	  							 //Linha Horizontal
       oPrint:line(nLin ,1163 ,nLin+70 ,1163) 					 	  							 //Linha Horizontal
       oPrint:line(nLin ,1524 ,nLin+70 ,1524) 					 	  							 //Linha Horizontal
       oPrint:line(nLin ,1885 ,nLin+70 ,1885) 					 	  							 //Linha Horizontal
       nLin += 05
       /*oPrint:Say(nLin,0110 ,"Salario Base" ,cFont1)
       oPrint:Say(nLin,0471 ,"Sal Contr INSS" ,cFont1)
       oPrint:Say(nLin,0832 ,"Base Calc FGTS" ,cFont1)
       oPrint:Say(nLin,1193 ,"FGTS no Mes" ,cFont1)
       oPrint:Say(nLin,1554 ,"Base Calc IRRF" ,cFont1)
       oPrint:Say(nLin,1915 ,"Faixa IRRF" ,cFont1)*/
       nLin += 30
      /* If(lAsrPrint,oPrint:Say(nLin,0210 ,Transform(nSalBase,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,0210 ,"*,***,***.**" ,cFont4))
       If(lAsrPrint,oPrint:Say(nLin,0571 ,Transform(nSalContr,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,0571 ,"*,***,***.**" ,cFont4))
       If(lAsrPrint,oPrint:Say(nLin,0932 ,Transform(nBaseFgts,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,0932 ,"*,***,***.**" ,cFont4))
       If(lAsrPrint,oPrint:Say(nLin,1293 ,Transform(nFgts,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,1293 ,"*,***,***.**" ,cFont4))
       If(lAsrPrint,oPrint:Say(nLin,1654 ,Transform(nBaseIrrf,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,1654 ,"*,***,***.**" ,cFont4))
       If(lAsrPrint,oPrint:Say(nLin,2015 ,Transform(nFxIr,'@E 9,999,999.99') ,cFont4),oPrint:Say(nLin,2015 ,"      ***.**" ,cFont4))*/

       If nPrimeiro == 1
          nLin := 1550
       Else
          nLin := 3150
       EndIf
       oPrint:line(nLin ,0080 ,nLin ,2250) 					 	  							 //Linha Horizontal
       nLin += 20

       cRodape := "DEPOSITO REALIZADO DIA "+Dtoc(dDtPagto)+" "
       cRodape += "NO BANCO "+Left(SRA->RA_BCDEPSA,3)+" - "
       cRodape += Alltrim(Upper(SA6->A6_NOME))+" - "
       cRodape += "AGENCIA "+Right(SRA->RA_BCDEPSA,5)+" - "
       cRodape += "C/C "+SRA->RA_CTDEPSA

       If(lAsrPrint,oPrint:Say(nLin-10,0110 ,cRodape ,cFont3),"")
  
       If Upper(cRPagto) == "R2"
          If nPrimeiro == 2
             oPrint:EndPage()
             nPrimeiro := 1
          Else
             nPrimeiro ++
          EndIf
       Else
          oPrint:EndPage()
       EndIf
       // Verifica se Todos os Itens Foram Impressos e Vai para o Proximo Funcionario
       If lAsrPrint
          Exit
       EndIf
   Next

   dbSkip()
EndDo
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

SET DEVICE TO SCREEN
If aReturn[5]==1
   oPrint:Preview()
   dbCommitAll()
   SET PRINTER TO
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Data de Referencia           ?','','','mv_ch1','D',08,0,0,'G','NaoVazio'   ,'mv_par01',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'02','Tipo Impressao               ?','','','mv_ch2','N',01,0,0,'C',''           ,'mv_par02','Adiantamento' ,'','','','','Folha'         ,'','','','','1a Parcela'     ,'','','','','2a Parcela' ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'03','Filial De                    ?','','','mv_ch3','C',02,0,0,'G',''           ,'mv_par03',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'04','Filial Ate                   ?','','','mv_ch4','C',02,0,0,'G','NaoVazio'   ,'mv_par04',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'05','Matricula De                 ?','','','mv_ch5','C',06,0,0,'G',''           ,'mv_par05',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'06','Matricula Ate                ?','','','mv_ch6','C',06,0,0,'G','NaoVazio'   ,'mv_par06',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'07','Mensagem 01                  ?','','','mv_ch7','C',01,0,0,'G',''           ,'mv_par07',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'08','Mensagem 02                  ?','','','mv_ch8','C',01,0,0,'G',''           ,'mv_par08',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'09','Mensagem 03                  ?','','','mv_ch9','C',01,0,0,'G',''           ,'mv_par09',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'10','Data do Pagamento            ?','','','mv_cha','D',08,0,0,'G','NaoVazio'   ,'mv_par10',''             ,'','','','',''              ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'11','Quantidade Por Pagina        ?','','','mv_chb','N',01,0,0,'C',''           ,'mv_par11','1 Por Pagina' ,'','','','','2 Por Pagina'  ,'','','','',''               ,'','','','',''           ,'','','','',''      ,'','','' ,'   ','' })

ValidPerg(aRegs,cPerg)

Return

   // Box para os Detalhes
   //oPrint:SayBitMap(nLin+3,084,"Teste.bmp",105,1495)