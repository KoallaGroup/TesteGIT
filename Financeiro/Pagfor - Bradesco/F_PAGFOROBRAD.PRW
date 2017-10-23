#include "protheus.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F_PAGFORBRAD ºAutor  ³ Ulisses Carmo     º Data ³  4/08/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa com todas as funcoes necessarias para os CNABs    º±±
±±º          ³ PAGFOR e COBRANCA do banco Bradesco                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DINIZ JUNTAS                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

//264-265 - Retorno a Modalidade do Pagamento  / 012-013 Santander - Retorna a Modalidade do Pagamento 
***************************************
User Function fModPag()  

	Local _cModPag
	Local _Mod := ""                                               
	Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	
	_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)    
	
	_cModPag := SEA->EA_MODELO   

Return(_cModPag) 


//Retorno o Tipo do Documento (NF, DP, FT...)
*********************************************
User Function fTipDoc()

	LOCAL _cTipo

	IF SUBSTR(SE2->E2_TIPO,1,2) == "NF"
	      _cTipo := "01"
	ELSE
		IF SUBSTR(SE2->E2_TIPO,1,2) == "FT"
	       _cTipo := "02" 
	 	ELSE
	  		IF SUBSTR(SE2->E2_TIPO,1,2) == "DP"
	       		_cTipo := "04"
	    	ELSE
	   			_cTipo := "05"        
			ENDIF
	  	ENDIF
	ENDIF

Return(_cTipo) 


// Retorno os valores do documento, pagamento, desconto e acrescimo do CNAB PAGFOR 
*****************************************************
User Function fValPag(cCOND) //PAGVAL(cCOND)

	Local nVALOR := 0
	 
	If SUBSTR(SE2->E2_CODBAR,1,3)=="   " .and. cCOND=='1'
		nVALOR :=  STRZERO(ROUND(SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC,2)*100,10)
	Else
		nVALOR := STRZERO((SE2->E2_VALOR - SE2->E2_PIS - SE2->E2_COFINS - SE2->E2_CSLL - SE2->E2_ISS)*100,10) //SUBS(SE2->E2_CODBAR,10,10)
	EndIf
	
	//If cCOND =='2'
	 //	nVALOR := STRZERO((SE2->E2_VALOR - SE2->E2_PIS - SE2->E2_COFINS - SE2->E2_CSLL - SE2->E2_ISS) *100,15)
	//EndIf
	
	If cCOND =='2'
		nVALOR := STRZERO((SE2->E2_VALOR - SE2->E2_DECRESC + SE2->E2_ACRESC)*100,15)
	EndIf
	
	If cCOND =='3'
		nVALOR := STRZERO(SE2->E2_DECRESC*100,15)
	EndIf
	If cCOND =='4'
		nVALOR := STRZERO(SE2->E2_ACRESC*100,15)	
	EndIf
    
Return(nVALOR)

// Função incluida para tratar o conteúdo das posições 182 - 189 quando a decrescimo ou acrescimo para gravar a data do vencimento real. 
//Incluida por Thiago Domingues 29\10\14.
*****************************
User Function fDatPag(cCONDT)
*****************************

 Local cDATA := 0
 

    If cCONDT == '1' .and. (SE2->E2_DECRESC <> 0 .or. SE2->E2_ACRESC <> 0) 
        cDATA := DTOS(SE2->E2_VENCREA)
    Else
        cDATA := "00000000"
    EndIf

Return(cDATA)




/////  PROGRAMA GRAVAR AS INFORMACOES COMPLEMENTARES CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (374-413) 
***********************************************
User Function fInfCompl() //Pagdoc() 

	Local _Doc := ""
	Local _Mod := ""                                               
	Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	
	_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)
	
	DO CASE
	   CASE _Mod $ "03/08"
	        _Doc := IIF(SA2->A2_CGC==SM0->M0_CGC,"D","C")+"000000"+"01"+"01"+SPACE(29)
	   CASE _Mod == "31" .AND. SUBSTR(SE2->E2_CODBAR,1,3)=="237"
	        _Doc := SUBSTR(SE2->E2_CODBAR,5,5)+SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)+SUBSTR(SE2->E2_CODBAR,33,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
	   CASE _Mod == "31"
	        _Doc := SUBSTR(SE2->E2_CODBAR,5,5)+SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)+SUBSTR(SE2->E2_CODBAR,33,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
	   OTHERWISE
	        _Doc := SPACE(40)
	ENDCASE 


Return(_Doc) 


***************************
User Function fSequen()
***************************     

	Public c_Ret := getmv("MV__SEQREM")
	c_Ret := c_Ret+1
	PutMv("MV__SEQREM", c_Ret)
	
Return(c_Ret)      
 

***************************
User Function fIncSeq()
*************************** 

	Local c_Ret1 := 0  
	
	c_Ret := 1
	PutMv("MV__SEQREM", c_Ret)
	
Return(c_Ret1)  


****************************
User Function fNossoNum()
****************************

	Local aAreaAtual := GetArea()
	Private nNossoNum

	dbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+MV_PAR13+MV_PAR14+MV_PAR15+MV_PAR16)
	//DbSeek(xFilial("SEE")+"237"+"3390 "+"18760-7   "+"123")    //Bradesco
	nNossoNum := Right(Alltrim(SEE->EE_FAXATU),11)
	
	// Garante que o numero tera 11 digitos
	If Len(Alltrim(nNossoNum)) <> 11
	     nNossoNum := Strzero(Val(nNossoNum),11)
	Endif

	// Verifica se nao estourou o contador, se estourou reinicializa
	// e grava o proximo numero
	dbSelectArea("SEE")
	RecLock("SEE",.F.)
	If nNossoNum == "99999999999"
	     Replace EE_FAXATU With "00000000001"
	Else
	     _nFaxAtu := Val(nNossoNum) + 1
	     _nFaxAtu := Strzero(_nFaxAtu,12)
	     Replace EE_FAXATU With _nFaxAtu
	Endif
	MsUnlock()
	
	nNossoNum := val(nNossoNum)
	cDigito   := CDigitoNosso() 
	nNossoNum := StrZero(nNossoNum,11)+cDigito       
	
	RecLock('SE1',.f.)
	SE1->E1_NUMBCO := nNossoNum
	MsUnlock('SE1') 

	//Else
	////   nNossoNum := NossoNum()
	//   nNossoNum := Alltrim(SE1->E1_NUMBCO)
	//EndIf 
	
	RestArea(aAreaAtual)

Return nNossoNum 

*******************************
Static Function CDigitoNosso()
*******************************

	nCont:=0
	
	//nSoma1 := val(subs(alltrim(mv_par17),02,1))*2 // Como o campo tem 3 posiçoes no parametro considera as duas ultimas 007 = 07
	//nSoma2 := val(subs(alltrim(mv_par17),03,1))*7 // Como o campo tem 3 posiçoes no parametro considera as duas ultimas 007 = 07 
	nSoma1 := val(subs(alltrim("009"),02,1))*2 
	nSoma2 := val(subs(alltrim("009"),03,1))*7
	nSoma3 := val(subs(StrZero(nNossoNum,11),01,1))*6
	nSoma4 := val(subs(StrZero(nNossoNum,11),02,1))*5
	nSoma5 := val(subs(StrZero(nNossoNum,11),03,1))*4
	nSoma6 := val(subs(StrZero(nNossoNum,11),04,1))*3
	nSoma7 := val(subs(StrZero(nNossoNum,11),05,1))*2
	nSoma8 := val(subs(StrZero(nNossoNum,11),06,1))*7
	nSoma9 := val(subs(StrZero(nNossoNum,11),07,1))*6
	nSomaA := val(subs(StrZero(nNossoNum,11),08,1))*5
	nSomaB := val(subs(StrZero(nNossoNum,11),09,1))*4
	nSomaC := val(subs(StrZero(nNossoNum,11),10,1))*3
	nSomaD := val(subs(StrZero(nNossoNum,11),11,1))*2
	
	cDigito := mod((nSoma1+nSoma2+nSoma3+nSoma4+nSoma5+nSoma6+nSoma7+nSoma8+nSoma9+nSomaA+nSomaB+nSomaC+nSomaD),11)
	
	nCont := iif(cDigito == 1, "P", iif(cDigito == 0 , "0", strzero(11-cDigito,1)))  

Return nCont 
  

******************************
User Function fPagAgen()       
*****************************

SetPrvt("_AGENCIA,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_MULT,_RESUL,_RESTO,_DIGITO,_NPOSDV, _DIGITOA")

/////  PROGRAMA PARA SEPARAR A AGENCIA DO CODIGO DE BARRA PARA O PROGRAMA DO 

/////  PAGFOR - POSICOES ( 99 - 104 )

_Agencia := ""

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	_Agencia  := SUBSTR(SE2->E2_CODBAR,5,4)
	
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_CODBAR,5,1)
	_DIG2   := SUBSTR(SE2->E2_CODBAR,6,1)
	_DIG3   := SUBSTR(SE2->E2_CODBAR,7,1)
	_DIG4   := SUBSTR(SE2->E2_CODBAR,8,1)
	
	_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := 11 - _RESTO
	
	_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))
	
	_Agencia:= STRZERO(VAL(_Agencia + _RETDIG),6)
Else
	If SUBSTR(SE2->E2_CODBAR,1,3) == "   "
		
		_Agencia := STRZERO(VAL(SA2->A2_AGENCIA),6)
		
	Else
		_Agencia := "000000"
	Endif
	Endif

Return(_Agencia)         


**********************************
User Function fPagacta()        // incluido pelo assistente de conversao do AP5 IDE em 10/11/00 
********************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CTACED,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO,_DIGITOC,_DIGITOA")

/////  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA PARA O PROGRAMA DO
/////  PAGFOR - POSICOES ( 105 - 119 )

_CTACED := " "

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
    _Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,24,7)),13,0)
    
    _RETDIG := " "
    _DIG1   := SUBSTR(SE2->E2_CODBAR,24,1)
    _DIG2   := SUBSTR(SE2->E2_CODBAR,25,1)
    _DIG3   := SUBSTR(SE2->E2_CODBAR,26,1)
    _DIG4   := SUBSTR(SE2->E2_CODBAR,27,1)
    _DIG5   := SUBSTR(SE2->E2_CODBAR,28,1)
    _DIG6   := SUBSTR(SE2->E2_CODBAR,29,1)
    _DIG7   := SUBSTR(SE2->E2_CODBAR,30,1)
    
    _MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
    _RESUL  := INT(_MULT /11 )
    _RESTO  := INT(_MULT % 11)
    _DIGITO := STRZERO((11 - _RESTO),1,0)

    _RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))

    _Ctaced := _Ctaced + _RETDIG
Else
   IF SUBSTR(SE2->E2_CODBAR,1,3) == "   "
     _DIGITOC := STR(VAL(RIGHT(ALLTRIM(SA2->A2_NUMCON),1)),1)
     
    _Ctaced  := STRZERO(VAL(Left(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON),".",""),"-",""),(LEN(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON),".",""),"-",""))-1))),13)
    _Ctaced  += _DIGITOC

   Else
       _Ctaced  := "0000000000000"
     Endif
   Endif
 


// Substituido pelo assistente de conversao do AP5 IDE em 10/11/00 ==> __return(_Ctaced)
Return(_Ctaced)        // incluido pelo assistente de conversao do AP5 IDE em 10/11/00  


************************
USER FUNCTION fCOMPLE_C  
************************

LOCAL C_VAR:= ""

C_VAR := STRZERO( VAL(SUBSTR(ALLTRIM(MV_PAR07),1,5) ),7) 
 
RETURN ( C_VAR ) 

************************
USER FUNCTION fCarteira  
************************

LOCAL C_VAR:= ""
Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	
_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)

C_VAR := IIF(_Mod$"30/31" .AND. SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)=="237",;
			 STRZERO(VAL(SUBSTR(ALLTRIM(SE2->E2_CODBAR),9,1)+SUBSTR(ALLTRIM(SE2->E2_CODBAR),11,1)),3), "000")
 
RETURN ( C_VAR )

************************
USER FUNCTION fNNum2  
************************

LOCAL C_VAR:= ""
Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	
_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)

C_VAR := IIF(_Mod$"30/31" .AND. SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)=="237",;
			 STRZERO(VAL(;
			 SUBSTR(ALLTRIM(SE2->E2_CODBAR),12,9);
			 +SUBSTR(ALLTRIM(SE2->E2_CODBAR),22,2)),12), STRZERO(0,12))
 
RETURN ( C_VAR )

************************
USER FUNCTION fbcoforn  
************************

LOCAL C_VAR:= ""
Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	
_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)

C_VAR := IIF(ALLTRIM(SEA->EA_MODELO)$"01/02/30","237",IIF(ALLTRIM(SEA->EA_MODELO)$"03/08",STRZERO(VAL(SE2->E2_FORBCO),3),SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)))                                                                                                           
 
RETURN ( C_VAR )