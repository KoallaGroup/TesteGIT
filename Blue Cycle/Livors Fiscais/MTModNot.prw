User Function MTModNot(cEspecie)

      

Local cCodigo:="01" // Default Nota Fiscal ou Nota Fiscal Fatura

Local lMtModNot     :=     ExistBlock("MTMODNOT")

      

Do Case

       Case Alltrim(cEspecie)=="CA"           

             cCodigo:="10" // Conh.Aereo

       Case Alltrim(cEspecie)=="CTA"    

             cCodigo:="09" // Conh.Transp.Aquaviario

       Case Alltrim(cEspecie)=="CTF"    

             cCodigo:="11" // Conh.Transp.Ferroviario

       Case Alltrim(cEspecie)=="CTR"    

             cCodigo:="08" // Conh.Transp.Rodoviario

       Case Alltrim(cEspecie)=="NFCEE"

             cCodigo:="06" // Conta de Energia Eletrica

       Case Alltrim(cEspecie)=="NFE"    

             cCodigo:="01" // NF Entrada

       Case Alltrim(cEspecie)=="NFPS"   

             cCodigo:=" " // NF Prestacao de Servico 

       Case Alltrim(cEspecie)=="NFS"    

             cCodigo:=" " // NF Servico

       Case Alltrim(cEspecie)=="NFST"   

             cCodigo:="07" // NF Servico de Transporte

       Case Alltrim(cEspecie)=="NFSC"   

             cCodigo:="21" // NF Servico de Comunicacao

       Case Alltrim(cEspecie)=="NTSC"   

             cCodigo:="21" // NF Servico de Comunicacao

       Case Alltrim(cEspecie)=="NTST"   

             cCodigo:="22" // NF Servico de Telecomunicacoes

       Case Alltrim(cEspecie)=="NFCF"   

             cCodigo:="02" // NF de venda a Consumidor Final

       Case Alltrim(cEspecie)=="NFP"    

             cCodigo:="04" // NF de Produtor

       Case Alltrim(cEspecie)=="RMD"    

             cCodigo:="18" // Resumo Movimento Diario      

       Case Alltrim(cEspecie)=="CTM"    

             cCodigo:="26" // Conh.Transp.Multimodal

       Case Alltrim(cEspecie)=="CF" .OR. Alltrim(cEspecie)=="ECF"

             cCodigo:="02" // Cupon Fiscal gerado pelo SIGALOJA

       Case Alltrim(cEspecie)=="RPS"

             cCodigo:=" " // Recibo Provisorio de Servicos - Nota Fiscal Eletronica de Sao Paulo               

       Case Alltrim(cEspecie)=="SPED"   

             cCodigo:="55" // Nota fiscal eletronica do SEFAZ.

       Case Alltrim(cEspecie)=="NFFA"   

             cCodigo:="29" // Nota fiscal de fornecimento de agua

       Case Alltrim(cEspecie)=="NFCFG"

             cCodigo:="28" // Nota fiscal/conta de fornecimento de gas

       Case Alltrim(cEspecie)=="CTE"

             cCodigo:="57" // Conhecimento de Transporte Eletronico

       Case Alltrim(cEspecie)=="NFA"

             cCodigo:="1B" // Nota Fiscal Avulsa    

       Case lMtModNot

             cCodigo:= Execblock("MTMODNOT",.F.,.F.,cEspecie)

EndCase
                                 
      

Return (cCodigo)
