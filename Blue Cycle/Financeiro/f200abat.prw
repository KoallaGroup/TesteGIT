


User function F200ABAT

// Nilza - 14/03/2016
// Ponto de entrada para tratar abatimentos e descontos
// Estou usando para alterar o banco de deposito

Pergunte("F200PORT",.f.)

cBanco   := MV_PAR01
cAgencia := MV_PAR02
cConta   := MV_PAR03
cHist070 := SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_NOMCLI

Pergunte("AFI200",.f.)

Return
