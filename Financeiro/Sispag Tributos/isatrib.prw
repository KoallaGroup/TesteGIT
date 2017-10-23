
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240AlMod º Autor ³ Henrique Martins   º Data ³  16/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tributos - SISPAG ITAÚ                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Isapa                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Itautrib()

Local cRet
Local _Tiptrib := SE2->E2__GPS01

     _vValor  := STRZERO(SE2->E2_VALOR*100,14)
     _vJuros  := STRZERO(SE2->E2_ACRESC*100, 14)  
     _vOutras := STRZERO(SE2->E2__VOUTRA, 14)
     _vMulta  := STRZERO(0, 14)
     _vDescont:= STRZERO(SE2->E2_DECRESC*100, 14)
     _ValorIpva:= STRZERO((SE2->E2_VALOR - SE2->E2_DECRESC)*100, 14)
     _vTotal  := STRZERO((SE2->E2_VALOR + SE2->E2_ACRESC )*100,14)
     _AnoVeic := SE2->E2__ANOVEI                        
     _Renavam := SPACE(09)
     _Renav2  := SPACE(12)
     
     If _AnoVeic <= "20130401"
     	_Renavam := STRZERO(VAL(SE2->E2__IPVA02),9)
     Else
     	_Renav2 := STRZERO(VAL(SE2->E2__IPVA07),12) 
     EndIf	 

DO CASE 
  CASE _Tiptrib == "01"

     cRet := ALLTRIM(SE2->E2__GPS01) + PadR(SE2->E2__GPS02,4) + SUBSTR(ALLTRIM(SE2->E2__GPS03),1,6) + SUBSTR(SE2->E2__CNPJ01,1,14) + _vValor +  _vJuros + _vOutras + _vTotal
     cRet += GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(08) + SPACE(50) + SUBSTR(SA2->A2_NOME,1,30)
                                                                    
  CASE _Tiptrib == "02"
  
  //   IF !EMPTY(SE2->E2_CODBAR)
     
 //    cRet := ALLTRIM(SE2->E2__GPS01) + SUBSTR(SE2->E2_CODBAR,40,4) + "2" + SUBSTR(SM0->M0_CGC,1,14) + ALLTRIM(SE2->E2__DARF03) + "00000000000000000" + _vValor
 //    cRet += _vOutras + _vJuros + _vTotal + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)
     
 //    ELSE     

     cRet := ALLTRIM(SE2->E2__GPS01) + ALLTRIM(SE2->E2__FGTS02) + "2" + SUBSTR(SE2->E2__CNPJ01,1,14) + ALLTRIM(SE2->E2__DARF03) + SPACE(17) + _vValor
     cRet += _vMulta + _vJuros + _vTotal + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)
     
//     ENDIF
  CASE _Tiptrib == "03"	
       
     cRet := ALLTRIM(SE2->E2__GPS01) + ALLTRIM(SE2->E2__FGTS02) + "2" + SUBSTR(SE2->E2__CNPJ01,1,14) + SE2->E2__DARF03 + SPACE(8) + "000000000" + "0000000000"
     cRet += SPACE(4) + _vValor + _vMulta + _vJuros + _vTotal + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)
  
  CASE _Tiptrib == "04"
  	
  	cRet := ALLTRIM(SE2->E2__GPS01) + ALLTRIM(SE2->E2__FGTS02) + "2" + SUBSTR(SE2->E2__CNPJ01,1,14) + SUBSTR(SE2->E2__INSCES,1,8) + SUBSTR(SE2->E2__ORIGEM,1,16) + SPACE(1) + _vValor + _vMulta + _vMulta + _vJuros
  	cRet += _vTotal + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + STRZERO(VAL(SE2->E2__DARF03),6) + SPACE(10) + SUBSTR(SA2->A2_NOME,1,30)     
  		                                                                                                                                                                                                 
  CASE _Tiptrib == "05"
                                                                                                                                                                  
     cRet := ALLTRIM(SE2->E2__GPS01) + ALLTRIM(SE2->E2__FGTS02) + "2" + SUBSTR(SE2->E2__CNPJ01,1,14) + SUBSTR(SM0->M0_INSC,1,12) + "0000000000000" + STRZE(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4)    
     cRet += "0000000000000" + _vValor + _vJuros + _vMulta + _vTotal + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(11) + SUBSTR(SM0->M0_NOME,1,30)
     
  CASE _Tiptrib $ "07/08"
     //R
     cRet := ALLTRIM(SE2->E2__GPS01) + SPACE(4) + "2" + SUBSTR(SM0->M0_CGC,1,14) + SUBSTR(DTOS(SE2->E2_EMIS1),1,4) + _Renavam + SUBSTR(SE2->E2__IPVA03,1,2) + SUBSTR(SE2->E2__IPVA04,1,5)    
     cRet += SUBSTR(SE2->E2__IPVA05,1,7) + SE2->E2__IPVA06 + _vValor + _vDescont + _ValorIpva + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(29) + _Renav2 + SUBSTR(SM0->M0_NOME,1,30)
  
  CASE _Tiptrib == "11"
     
  	 //cRet := ALLTRIM(SE2->E2__GPS01) + SUBSTR(SE2->E2__FGTS02,1,4) + "1" + SUBSTR(SM0->M0_CGC,1,14) + STRZERO(SE2->E2__FGTS03,48) + SUBSTR(SE2->E2__FGTS04,1,16) + SUBSTR(SE2->E2__FGTS05,1,9) + SUBSTR(SE2->E2__FGTS06,1,2) + SUBSTR(SM0->M0_NOME,1,30)
  	 cRet := ALLTRIM(SE2->E2__GPS01) + SUBSTR(SE2->E2__FGTS02,1,4) + "1" + SUBSTR(SE2->E2__CNPJ01,1,14) + SubStr(SE2->E2__FGTS03,1,48) + SUBSTR(SE2->E2__FGTS04,1,16) + SUBSTR(SE2->E2__FGTS05,1,9) + SUBSTR(SE2->E2__FGTS06,1,2) + SUBSTR(SM0->M0_NOME,1,30)  
  	 cRet += GRAVADATA(SE2->E2_VENCREA,.F.,5) + _vValor + SPACE(30)
  
  OTHERWISE
  
  	MsgAlert("Tipo de Tributo não preenchido! Favor validar o campo.")
  	Return
     
ENDCASE 

Return(cRet)                        




