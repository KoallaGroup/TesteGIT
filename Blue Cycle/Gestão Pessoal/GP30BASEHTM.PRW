User Function GP30BASEHTM()

Local aArea 	:= GetArea()
Local cHtm  	:= ""
Local cNwVerba  := '18%'
Local dAdmissa  := ""
 
/*cHtm :=	"teste" + CRLF
cHtm +=		""*/
//         cHtm +=		"<br><br><br><br align=left>Base Verba (%): " //+ CRLF 
//Posicione("SRA",1,xFilial("SRA")+SRA->RA_MAT, 'RA_ADMISSA') 
//dAdmissa := Posicione("SRA",1,xFilial("SRA")+SRA->RA_MAT, 'RA_ADMISSA') 
           
//cHtm +=		"<tr>Data de Admissão: <td> </td><td> </td><td> </td><td><align=rigth>"+SRA->RA_MAT +"</td>" //+ CRLF
/*cHtm += 	"" + CRLF
cHtm += 	"" + CRLF
cHtm += 	' ' + CRLF
cHtm +=		"" + CRLF
cHtm += 	"" + CRLF
cHtm +=			" " + cNwVerba + " " + CRLF
cHtm += 	"" + CRLF
cHtm += 	""  + CRLF
cHtm += 		"" + CRLF
cHtm += 	"" + CRLF
cHtm += 	"" + CRLF
cHtm +=		"" + CRLF
cHtm += ""*/
   
RestArea(aArea)

Return( cHtm )