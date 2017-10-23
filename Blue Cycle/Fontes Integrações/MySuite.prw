#INCLUDE "TOTVS.CH"
//#INCLUDE "XMLCSVCS.CH"
user function tstpost()
Local cUrl := "http://bluecycle.mysuite2.com.br/webservices/ws_getusuarios.php"
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local sPostRet := ""
Local cValor1  := "bike@bike.com.br"
Local cValor2 := "afa29f11b476e62e28e2624e3cf47bef"

cParam   :=     "email="+cValor1+;
          "servicekey="+cValor2
          

aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/x-www-form-urlencoded')

sPostRet := HttpPost(cUrl,cParam,"",nTimeOut,aHeadOut,@cHeadRet)

if !empty(sPostRet)
  conout("HttpPost Ok")
  varinfo("WebPage", sPostRet)
else
  conout("HttpPost Failed.")
  varinfo("Header", cHeadRet)          
Endif  



Return

/*

cUrl      := "a tua URL que deseja acessar"
nTimeOut := 120   
aHeadOut := {}
cHeadRet := ""
sPostRet := ""
cParam   := ""

//Na proxima variavel voce vai montar a string contendo os parametros enviados para a conexao.

cParam   :=     "var1="+cValor1+;
          "&var2="+cValor2+;
          "&var3="+cValor3

//Aqui tu vai executar a funçao que faz a conexao propriamente dita
sPostRet := HttpPost(cUrl,cParam,"",nTimeOut,aHeadOut,@cHeadRet)

//Aqui tu vai testar se retornou alguma coisa. Se for = NILL tu sabe que deu erro de conexao, ou de envio de parametros ou algum problema.
If sPostRet == Nil
     MsgAlert(aspassimplesNao retornou nadaaspassimples)
     return .F.
Endif 

//Em caso de sucesso(aqui vinha outra duvida, nao existe documentaçao de como pegar os valores, entao tentei usar do mesmo modo que uso em outra conexao do tipo GET e deu certo hehe)

//Cria objeto com XML de retorno
CREATE oScript XMLSTRING sPostRet

//Testa se nao deu erro no parse do XML
nXmlStatus := XMLError()
If ( nXmlStatus == XERROR_SUCCESS )
        //Aqui tu vai referenciar cada valor do teu XML 
        cTeste := oScript:_PEDIDO:_TESTE:TEXT
Endif
//--- 
*/