Static Function DetNFImp()

SB1->(DbSeek(xFilial()+NFI->PRD_ESP_COD_EXTERNO))
aItem:={}

AADD(aItem,{"D1_COD",		NFI->PRD_ESP_COD_EXTERNO,	".T."})// codigo do produto
AADD(aItem,{"D1_UM"	,		Sb1->B1_UM,					".T."}) // unidade do produto
AADD(aItem,{"D1_QUANT",		NFI->DPR_QTD_QUANTIDADE,	".T."}) // quantidade do produto
AADD(aItem,{"D1_VUNIT",		NFI->DPR_PRE_VALORUN,		".T."}) // valor unitario do item
AADD(aItem,{"D1_VALIPI",	NFI->MNY_VLR_IPI,			".T."})  // Vlr do IPI 
AADD(aItem,{"D1_VALICM",	NFI->MNY_VLR_ICMS,			".T."})  // Vlr do ICMS
AADD(aItem,{"D1_CF",		NFD->CFOP,					".T."})  // Classificacao Fiscal                                                
AADD(aItem,{"D1_IPI",		NFI->PCT_IPI,				".T."})
AADD(aItem,{"D1_PICM",		NFI->PCT_ICMS,				".T."})
AADD(aItem,{"D1_PESO",		Sb1->B1_Peso,				".T."})  // Peso Total do Item
AADD(aItem,{"D1_FORNECE",	Sa2->A2_Cod,				".T."})
AADD(aItem,{"D1_LOJA",		Sa2->A2_Loja,				".T."})
AADD(aItem,{"D1_LOCAL",		Sb1->B1_LocPad,				".T."})
AADD(aItem,{"D1_DOC",		cNumero,					NIL})
AADD(aItem,{"D1_SERIE",		cSerie,						NIL})
AADD(aItem,{"D1_EMISSAO",	NFD->DOC_DTA_EMISSAO,		NIL})
AADD(aItem,{"D1_DTDIGIT",	dDataBase,					".T."})               
AADD(aItem,{"D1_TIPO",		"N",						NIL})   //nTipoNF=NFE_COMPLEMEN   Bete 24/11 - Trevo
AADD(aItem,{"D1_TIPODOC",	"10",						NIL})   //nTipoNF=NFE_COMPLEMEN   Bete 24/11 - Trevo
AADD(aItem,{"D1_TP",		SB1->B1_TIPO,				".T."})
AADD(aItem,{"D1_TOTAL",		NFI->DPR_PRE_VALORUN,		".T."})  // valor total do item (quantidade * preco)
AADD(aItem,{"D1_BASEICM",	NFI->MNY_BC_ICMS,			".T."})
AADD(aItem,{"D1_BASEIPI",	NFI->MNY_BC_IPI,			".T."})
AADD(aItem,{"D1_FORMUL",	"S",						".T."})
AADD(aItem,{"D1_TEC",		Sb1->B1_PosIpi,				".T."})
AADD(aItem,{"D1_CONHEC",	NFD->PRI_ESP_REFCLIENTE,	".T."})
AADD(aItem,{"D1_DESPESA",	NFI->MNY_DESPESAS,			".T."})
AADD(aItem,{"D1_BASIMP6",	NFI->MNY_BC_PIS,			".T."})
AADD(aItem,{"D1_VALIMP6",	MNY_VLR_PIS,				".T."})
AADD(aItem,{"D1_ALIQIMP6",	NFI->PCT_PIS,				".T."})
AADD(aItem,{"D1_BASIMP5",	NFI->MNY_BC_COFINS,			".T."})
AADD(aItem,{"D1_VALIMP5",	NFI->MNY_VLR_COFINS,		".T."})
AADD(aItem,{"D1_ALIQIMP5",	NFI->PCT_COFINS,			".T."})
//AADD(aItem,{"D1_TIPO_NF"     ,xTipoNF          ,NIL}) 

AADD(aItens,ACLONE(aItem))

RETURN .T.
