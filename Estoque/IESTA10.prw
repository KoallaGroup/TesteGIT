#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

Static cEmpInt	:= GetJobProfString( 'cEmpInt', '' ) //--> Empresa onde ocorrerá a integração
Static cFilInt	:= GetJobProfString( 'cFilInt', '' ) //--> Filial onde ocorrerá a integração

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | IESTA10 | Autor: |    Rogério Alves     | Data: |    Julho/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Schedule para realização de transferência, saída ou entrada        |
|            | automática do material no armazem da mesma filial                  |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function IESTA10(aEmp)

Local cEmp 		:= aEmp[1]
Local cFilDes	:= cFilOri := aEmp[2]
Local cProd	    := _cDocSD3 := ""
Local cUM     	:= "", _lSD3 := .t.
Local cLocOri	:= ""
Local cLocDes	:= ""
Local cTmSai	:= ""
Local cTmEnt	:= ""
Local cDoc	    := ""     	
Local dData		:= ""
Local nQuant	:= 0
Local lOk		:= .T.
Local lMenu 	:= .f.
Local cQUERY 	:= ""
Local xTEMP		:= ""
Local aFilial	:= {}
Local aItem		:= aCab := {}
Local nOpcAuto	:= 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
Local nCount	:= 0

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.
/*
RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmp, cFilOri,,,"EST",GetEnvServer())
*/
//PREPARE ENVIRONMENT Empresa cEmp Filial cFilOri Modulo "EST" Tables "SD3","Z01","SB2"

ConOut("_________________Inicio do Processo: "+Time())

cQUERY := "SELECT Z01.*,Z01.R_E_C_N_O_ Z01RECNO "
cQUERY += "FROM " + RetSqlName("Z01") + " Z01 "
cQUERY += "WHERE Z01_IMPOK = '0' "
cQUERY += "AND Z01.D_E_L_E_T_ = ' ' "
cQUERY += "AND Z01_FILIAL = '" + cFilOri + "' And Z01_DATA >= '20150601' "
cQUERY += "ORDER BY Z01_DATA,Z01_DOC, Z01_PROD "

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

cTmSai	:= GetMv("MV__TMSAI")
cTmEnt	:= GetMv("MV__TMENT")

dbSelectArea("xTEMP")
dbGoTop()

While !Eof()
	
	lOk := .T.
	
	/*
	DbSelectArea("SB1")
	DbSetOrder(1)
	If !SB1->(MsSeek(xFilial("SB1")+xTEMP->Z01_PROD))
		lOk := .F.
	Else
		cProd 	:= xTEMP->Z01_PROD
		cUM 	:= SB1->B1_UM
		dData	:= STOD(xTEMP->Z01_DATA)
		nQuant	:= xTEMP->Z01_QUANT
		cFilOri	:= xTEMP->Z01_FILIAL
		cFilDes	:= xTEMP->Z01_FILDES
		
	EndIf
	*/
	cLocOri	:= StrZero(Val(xTEMP->Z01_LOCORI),TamSX3("B1_LOCPAD")[1])
	cLocDes	:= StrZero(Val(xTEMP->Z01_LOCDES),TamSX3("B1_LOCPAD")[1])
	
	If lOk
		
		If Empty(cLocDes)
			
			//cDoc	:= GetSxENum("SD3","D3_DOC",1)
			aCab 	:= {}
			aItem 	:= {}

			cDoc	:= xTEMP->Z01_DOC
			_cDocSD3 := cDoc
			DbSelectArea("SD3")
			DbSetOrder(2)
			While DbSeek(xFilial("SD3") + _cDocSD3)
				_cDocSD3 := Soma1(_cDocSD3)
				DbSelectArea("SD3")
			EndDo
			
			lMsErroAuto := .F.
	
			aCab := {	{"D3_DOC"    	, _cDocSD3				,  	Nil},;
						{"D3_TM"     	, cTmSai  				,  	Nil},;
						{"D3_EMISSAO"	, STOD(xTEMP->Z01_DATA)	,  	Nil}}
	        
	        DbSelectArea("xTEMP")
			While !Eof() .And. (cDoc == xTEMP->Z01_DOC)

				cLocOri	:= StrZero(Val(xTEMP->Z01_LOCORI),TamSX3("B1_LOCPAD")[1])
				cLocDes	:= StrZero(Val(xTEMP->Z01_LOCDES),TamSX3("B1_LOCPAD")[1])

				DbSelectArea("NNR")
				DbSetOrder(1)
				If !DbSeek(xFilial("NNR")+cLocOri)
					If reclock("NNR", .T.)
						NNR->NNR_CODIGO := cLocOri
						NNR->NNR_DESCRI := "ARMAZEM " + cLocOri
						MsUnlock()
					EndIf
				EndIf
				
				DbSelectArea("SB2")
				DbSetOrder(1)
				If !DbSeek(cFilOri+xTEMP->Z01_PROD+cLocOri,.F.)
					MsUnlockAll()
					CriaSB2(xTEMP->Z01_PROD,cLocOri,cFilOri)
					MsUnlock()
				EndIf

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFIlial("SB1")+xTEMP->Z01_PROD)							
					aadd(aItem,{{"D3_TM"      	, cTmSai			,  	Nil},;
								{"D3_COD"      	, xTEMP->Z01_PROD 	,  	Nil},;
								{"D3_UM"        , SB1->B1_UM		,  	Nil},;
								{"D3_QUANT"     , xTEMP->Z01_QUANT 	,  	Nil},;
								{"D3_LOCAL"     , cLocOri		 	,  	Nil},;
								{"D3__OBS "     , "Documento WMS "	+ cDoc 	,  	Nil},;
								{"D3_EMISSAO"	, Date()	 		,  	NIL}})
				Else
					DbSelectArea("Z01")
					DbGoTo(xTEMP->Z01RECNO)
					While !Reclock("Z01",.f.)
					EndDo
					Z01->Z01_IMPOK := "E"
					MsUnlock()
				EndIf
				
				DbSelectArea("xTEMP")
				DbSkip()
			EndDo
			
			Begin Transaction
				MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)
			End Transaction
			
			If lMsErroAuto
				If !lMenu
					ConOut("_________________Erro na Saida do material!")
				Else
					MostraErro()
					DisarmTransaction()
				EndIf

			    DbSelectArea("Z01")
			    DbSetOrder(2)
			    DbGoTop()
			    If MsSeek(cFilOri + cDoc)
			        While !Eof() .And. (Alltrim(Z01->Z01_FILIAL) + Alltrim(Z01->Z01_DOC)) == (Alltrim(cFilOri) + Alltrim(cDoc))
			            If Z01->Z01_IMPOK == "0"
			                While !Reclock("Z01",.F.)
			                EndDo
			                DbSelectArea("SD3")
			                DbSetOrder(2)
			                If DbSeek(xFilial("SD3") + _cDocSD3 + Z01->Z01_PROD)
				                Z01->Z01_IMPOK := "S"
				           	Else
				           		Z01->Z01_IMPOK := "E"
				           	EndIf
			                DbSelectArea("Z01")
			                MsUnlock()
			            EndIf
			            
			            DbSelectArea("Z01")
			            DbSkip()
			        EndDo
				Endif
			Else
				_cUpd := "Update " + RetSqlName("Z01") 
				_cUpd += " Set Z01_IMPOK = 'S' "
				_cUpd += "Where Z01_FILIAL = '" + cFilOri + "' And Z01_DOC = '" + cDoc + "' And D_E_L_E_T_ = ' ' And Z01_IMPOK = '0' "
				
				_nOK := TCSQLExec(_cUpd)
				     
				If _nOK < 0
				    DbSelectArea("Z01")
				    DbSetOrder(2)
				    DbGoTop()
				    If MsSeek(cFilOri + cDoc)
				        While !Eof() .And. (Alltrim(Z01->Z01_FILIAL) + Alltrim(Z01->Z01_DOC)) == (Alltrim(cFilOri) + Alltrim(cDoc))
				            If Z01->Z01_IMPOK == "0"
				                While !Reclock("Z01",.F.)
				                EndDo
				                Z01->Z01_IMPOK := "S"
				                MsUnlock()
				            EndIf
				            DbSkip()
				        EndDo
				    EndIf
				Else
					TCRefresh("Z01")
				Endif				
			EndIf
		Else		
			cDoc	:= xTEMP->Z01_DOC
			_cDocSD3 := cDoc
			DbSelectArea("SD3")
			DbSetOrder(2)
			While DbSeek(xFilial("SD3") + _cDocSD3)
				_cDocSD3 := Soma1(_cDocSD3)
				DbSelectArea("SD3")
			EndDo
			
			//cDoc	:= GetSxENum("SD3","D3_DOC",1)
			aCab 	:= {}
			aItem 	:= {}
			
			lMsErroAuto := .F.						
			
			_aLinha 	:= {{ _cDocSD3, STOD(xTEMP->Z01_DATA) }}
	
	        DbSelectArea("xTEMP")
			While !Eof() .And. (cDoc == xTEMP->Z01_DOC)

				cLocOri	:= StrZero(Val(xTEMP->Z01_LOCORI),TamSX3("B1_LOCPAD")[1])
				cLocDes	:= StrZero(Val(xTEMP->Z01_LOCDES),TamSX3("B1_LOCPAD")[1])

				DbSelectArea("NNR")
				DbSetOrder(1)
				If !DbSeek(xFilial("NNR")+cLocOri)
					If reclock("NNR", .T.)
						NNR->NNR_CODIGO := cLocOri
						NNR->NNR_DESCRI := "ARMAZEM " + cLocOri
						MsUnlock()
					EndIf
				EndIf

				DbSelectArea("SB2")
				DbSetOrder(1)
				If !DbSeek(cFilOri+xTEMP->Z01_PROD+cLocOri,.F.)
					MsUnlockAll()
					CriaSB2(xTEMP->Z01_PROD,cLocOri,cFilOri)
					MsUnlock()
				EndIf

				
				DbSelectArea("NNR")
				DbSetOrder(1)
				If !DbSeek(xFilial("NNR")+cLocDes)
					If reclock("NNR", .T.)
						NNR->NNR_CODIGO := cLocDes
						NNR->NNR_DESCRI := "ARMAZEM " + cLocDes
						MsUnlock()
					EndIf
				EndIf
				
				DbSelectArea("SB2")
				DbSetOrder(1)
				If !DbSeek(cFilOri+xTEMP->Z01_PROD+cLocDes,.F.)
					MsUnlockAll()
					CriaSB2(xTEMP->Z01_PROD,cLocDes,cFilOri)
					MsUnlock()
				EndIf
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFIlial("SB1")+xTEMP->Z01_PROD)
					aadd(_aLinha, {SB1->B1_COD 											,;
									SB1->B1_DESC										,;
									SB1->B1_UM										  	,;
									cLocOri						                      	,;
									CriaVar("D3_LOCALIZ",.F.) 							,;
									SB1->B1_COD						              		,;
									SB1->B1_DESC										,;
									SB1->B1_UM										  	,;
									cLocDes												,;
									CriaVar("D3_LOCALIZ",.F.) 							,;
									CriaVar("D3_NUMSERI",.F.) 							,;
									""                         							,;
									CriaVar("D3_NUMLOTE",.F.) 							,;
									CriaVar("D3_DTVALID",.F.) 							,;
									CriaVar("D3_POTENCI",.F.) 							,;
									xTEMP->Z01_QUANT									,;
									CriaVar("D3_QTSEGUM",.F.) 							,;
									CriaVar("D3_ESTORNO",.F.) 							,;
									CriaVar("D3_NUMSEQ",.F.)  							,;
									""                        							,;
									CriaVar("D3_DTVALID",.F.) 							,;
									CriaVar("D3_ITEMGRD",.F.) })
				Else
					DbSelectArea("Z01")
					DbGoTo(xTEMP->Z01RECNO)
					While !Reclock("Z01",.f.)
					EndDo
					Z01->Z01_IMPOK := "E"
					MsUnlock()				
				EndIf
			 
			 	DbSelectArea("xTEMP")
				DbSkip()
			EndDo
			
			Begin Transaction
				msExecAuto({|x,Y| Mata261(x,Y)},_aLinha,3)
			End Transaction
			
			If lMsErroAuto
				If !lMenu
					ConOut("_________________Erro na entrada do material!")
				Else
					MostraErro()
					DisarmTransaction()
				EndIf

			    DbSelectArea("Z01")
			    DbSetOrder(2)
			    DbGoTop()
			    If MsSeek(cFilOri + cDoc)
			        While !Eof() .And. (Alltrim(Z01->Z01_FILIAL) + Alltrim(Z01->Z01_DOC)) == (Alltrim(cFilOri) + Alltrim(cDoc))
			            If Z01->Z01_IMPOK == "0"
				            _lSD3 := .t.
			                While !Reclock("Z01",.F.)
			                EndDo
			                DbSelectArea("SD3")
			                DbSetOrder(2)
			                If DbSeek(xFilial("SD3") + _cDocSD3 + Z01->Z01_PROD)
				                Z01->Z01_IMPOK := "S"
				           	Else
				           		Z01->Z01_IMPOK := "E"
				           		_lSD3 := .f.
				           	EndIf
			                DbSelectArea("Z01")
			                MsUnlock()
			                
			                If _lSD3
								_cUpd := "Update " + RetSqlName("SD3") 
								_cUpd += " Set D3__OBS = 'Documento WMS' " + cDoc + "' "
								_cUpd += "Where D3_FILIAL = '" + cFilOri + "' And D3_DOC = '" + _cDocSD3 + "' And "
								_cUpd +=	"D3_COD = '" + Z01->Z01_PROD + "' And D_E_L_E_T_ = ' ' "
								
								_nOK := TCSQLExec(_cUpd)
								     
								If _nOK < 0
								    DbSelectArea("SD3")
								    DbSetOrder(2)
								    DbGoTop()
								    If MsSeek(xFilial("SD3") + _cDocSD3 + Z01->Z01_PROD)
								        While !Eof() .And. (Alltrim(SD3->D3_FILIAL) + Alltrim(SD3->D3_DOC) + Alltrim(SD3->D3_COD)) == (Alltrim(cFilOri) + Alltrim(_cDocSD3) + Alltrim(Z01->Z01_PROD))
							                While !Reclock("SD3",.F.)
							                EndDo
							                SD3->D3__OBS := "Documento WMS " + cDoc
							                MsUnlock()
								            DbSkip()
								        EndDo
								    EndIf
								Else
									TCRefresh("SD3")
								Endif				
			                EndIf
			            EndIf
			            
			            DbSelectArea("Z01")
			            DbSkip()
			        EndDo
			    EndIf
				
			Else
				_cUpd := "Update " + RetSqlName("Z01") 
				_cUpd += " Set Z01_IMPOK = 'S' "
				_cUpd += "Where Z01_FILIAL = '" + cFilOri + "' And Z01_DOC = '" + cDoc + "' And D_E_L_E_T_ = ' ' And Z01_IMPOK = '0' "
				
				_nOK := TCSQLExec(_cUpd)
				     
				If _nOK < 0
				    DbSelectArea("Z01")
				    DbSetOrder(2)
				    DbGoTop()
				    If MsSeek(cFilOri + cDoc)
				        While !Eof() .And. (Alltrim(Z01->Z01_FILIAL) + Alltrim(Z01->Z01_DOC)) == (Alltrim(cFilOri) + Alltrim(cDoc))
				            If Z01->Z01_IMPOK == "0"
				                While !Reclock("Z01",.F.)
				                EndDo
				                Z01->Z01_IMPOK := "S"
				                MsUnlock()
				            EndIf
				            DbSkip()
				        EndDo
				    EndIf
				Else
					TCRefresh("Z01")
				Endif
				
				_cUpd := "Update " + RetSqlName("SD3") 
				_cUpd += " Set D3__OBS = 'Documento WMS' " + cDoc + "' "
				_cUpd += "Where D3_FILIAL = '" + cFilOri + "' And D3_DOC = '" + _cDocSD3 + "' And D_E_L_E_T_ = ' ' "
				
				_nOK := TCSQLExec(_cUpd)
				     
				If _nOK < 0
				    DbSelectArea("SD3")
				    DbSetOrder(2)
				    DbGoTop()
				    If MsSeek(cFilOri + _cDocSD3)
				        While !Eof() .And. (Alltrim(SD3->D3_FILIAL) + Alltrim(SD3->D3_DOC)) == (Alltim(cFilOri) + Alltrim(_cDocSD3))
			                While !Reclock("SD3",.F.)
			                EndDo
			                SD3->D3__OBS := "Documento WMS " + cDoc
			                MsUnlock()
				            DbSkip()
				        EndDo
				    EndIf
				Else
					TCRefresh("SD3")
				Endif				
				
			EndIf
			
		EndIf
		/*
		DbSelectArea("Z01")
		//DbSetOrder(2) //Z01_FILIAL+Z01_DOC+Z01_PROD
		//If DbSeek(cFilOri+xTEMP->Z01_DOC+cProd)
		DbGoTo(xTEMP->Z01RECNO)
			If reclock("Z01", .F.)
				Z01->Z01_IMPOK := "S"
				MsUnlock()
			EndIf
			
		//EndIf
		*/		
	EndIf	
	
	DbSelectArea("xTEMP")
EndDo

If !lMenu
	Reset Environment
	ConOut("_________________Fim do Processo  "+Time())
EndIf

Return




User Function IESTA10J()

Local aTables := { "SD3", "SB1", "SB2", "Z10", "Z01", "NNR" }

If Empty( cEmpInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao MHA - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

If Empty( cFilInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao MHA - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

RPCSetType(3)
RpcSetEnv (cEmpInt, cFilInt, Nil, Nil, "EST", Nil, aTables)

//While !KillApp()
	U_IESTA10({cEmpInt,cFilInt})
//	Exit
//EndDo

Return