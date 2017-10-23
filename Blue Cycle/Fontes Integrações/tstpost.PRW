#INCLUDE "TOTVS.CH"
//#INCLUDE "XMLCSVCS.CH"   

user function tstpost2()
Local cUrl := "http://dev.api.vexpenses.com/v2/costs-centers"
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local sPostRet := "" 
Local cParam := ""         
Local cJson 
Local cValor2 := "TI"
Local cValor3 := "true"

cJSon := '{' 
cJSon += '"name": "TESTE1",' 
cJSon += '"ativo": true' 
cJSon += '}' 

//cParam   :=     "name="+cValor2+;
   //       "&ativo="+cValor3
//aadd(aHeadOut,'name: DIRETORIA')
//aadd(aHeadOut,'ativo: true')  
aadd(aHeadOut,'Content-Type: application/json')  
aadd(aHeadOut,'Accept: application/json') 
aadd(aHeadOut,'Authorization: Bearer nHqR56qG2lLOQFi82jZF9nVyFzBYHivddorv0Sd9rwdDakwLQ2hfxNaaqXMh')
sPostRet := HttpPost(cUrl,"",cJSon,nTimeOut,aHeadOut,@cHeadRet) 
//"name:DIRETORIA,ativo:true"


if !empty(sPostRet)
  conout("HttpPost Ok")
  varinfo("WebPage", sPostRet)
else
  conout("HttpPost Failed.")
  varinfo("Header", cHeadRet)
Endif
Return


                        
User Function JsonTest 

Local cJson 
Local oObj 

cJSon := '{"menu": {' 
cJSon += '"id": "file",' 
cJSon += '"value": "File",' 
cJSon += '"popup": {' 
cJSon += ' "menuitem": [' 
cJSon += ' {"value": "New", "onclick": "CreateNewDoc()"},' 
cJSon += ' {"value": "Open", "onclick": "OpenDoc()"},' 
cJSon += ' {"value": "Close", "onclick": "CloseDoc()"}' 
cJSon += ' ]' 
cJSon += ' }' 
cJSon += '}}' 

If FWJsonDeserialize(cJson,@oObj)
MsgStop(oObj:menu:popup:menuitem[3]:onclick) //Será exibida a mensagem 'CloseDoc()'
Endif

Return
                 





