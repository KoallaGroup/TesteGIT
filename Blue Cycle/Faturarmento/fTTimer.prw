#include "TOTVS.CH"
User Function fTTimer()
  DEFINE DIALOG oDlg TITLE "Exemplo TTimer" FROM 180,180 TO 550,700 PIXEL
   
   nSegundos := 2 // Disparo será de 2 em 2 segundos
   oTimer := TTimer():New(2, {|| alert(time()) }, oDlg )
   oTimer:Activate()
	
  ACTIVATE DIALOG oDlg CENTERED 
Return