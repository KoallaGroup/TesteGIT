
User Function TITICMST

Local	cOrigem		:=	PARAMIXB[1]
Local	cTipoImp	:=  PARAMIXB[2]

If AllTrim(cOrigem)='MATA954'	//Apuracao de ISS	
	SE2->E2_NUM			:=	SE2->(Soma1(E2_NUM,Len(E2_NUM)))	
	SE2->E2_VENCTO  	:= DataValida(dDataBase+30,.T.)	
	SE2->E2_VENCREA 	:= DataValida(dDataBase+30,.T.)
EndIf
    
//ICMS ST (cTipoImp)
If AllTrim(cOrigem)="MATA460A"  .or. AllTrim(cTipoImp)='3' // ICMS ST	  
	SE2->E2_NUM    := SD2->D2_DOC    //SE1->E1_NUM    //SE2->(Soma1(E2_NUM,Len(E2_NUM)))	  
	SE2->E2_VENCTO := DataValida(dDataBase+2,.T.)	  
	SE2->E2_VENCREA:= DataValida(dDataBase+2,.T.)
EndIf

Return {SE2->E2_NUM,SE2->E2_VENCTO}