User Function XGFEAPRF()
    Local cGW6Fil := PARAMIXB[1]
    Local cGW6Emi := PARAMIXB[2]
    Local cGW6Ser := PARAMIXB[3]
    Local cGW6NRF := PARAMIXB[4]
    //Local cGW6DT := PARAMIXB[5]
 
    Alert("Fatura: " + cGW6NRF + " bloqueada por alçada! Aguarde liberação para envio ao financeiro.") 
    lExcept := .T.
Return .T.