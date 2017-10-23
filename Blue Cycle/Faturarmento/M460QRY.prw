#include "rwmake.ch" 
                      
                                   
User Function M460QRY()
             

local _volta := " AND C9_PEDIDO IN (SELECT C5_NUM FROM SC5010 WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND D_E_L_E_T_ = ' ' AND C5__STATUS = '8') "              
Local cQuery :=paramixb[1]
cQuery+=_volta                   


                                   


Return(cQuery)        



