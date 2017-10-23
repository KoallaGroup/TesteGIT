User function MA030TOK()      


Local ret := .T. 

If M->A1_PESSOA == "J" .And. Empty(M->A1_SEGTO) 
     MsgAlert("Preencha a Segmentação do Cliente!", "Preencher Campo") 
     ret := .F. 
endif 
              
Return ret                   

