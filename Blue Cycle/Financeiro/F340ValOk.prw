User Function F340ValOk  

Local aTit 	:= Paramixb[1]
Local lRet 	:= .t.
Local x    	:= 0
Local ContF := 0

For x := 1 to Len(aTit)
	If aTit[x][8] 
  
		If Empty(SUBSTR(cValtoChar(Posicione("SE2",1,aTit[x][16]+aTit[x][1]+aTit[x][2]+aTit[x][3]+aTit[x][4]+aTit[x][14]+aTit[x][15],'E2_DATALIB')),1,2))
			Alert("A P.A. "+atit[x][2]+" est� bloqueada para compensa��o. Solicite a libera��o para utiliz�-la.")  
			lRet := .F.
		EndIf
		++ContF	
	EndIf
Next

Return lRet