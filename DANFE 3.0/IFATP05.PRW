#Include "Rwmake.ch"
#Include "Protheus.ch" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"    
#include "topconn.ch"

//Static cEmpInt	:= GetJobProfString( 'cEmpInt', '' ) //--> Empresa onde ocorrerá a integração
//Static cFilInt	:= GetJobProfString( 'cFilInt', '' ) //--> Filial onde ocorrerá a integração

/*
+-----------+---------+-------+---------------------------------------+------+-------------+
| Programa  | IFATP05 | Autor | Jose Augusto F.Alves - Anadi Soluções | Data | Agosto/2012 |
+-----------+---------+-------+---------------------------------------+------+-------------+
| Descricao | ROTINA para impressão automática do DANFE, após autorização da NF-e		   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/
*-----------------------
User Function IFATP05B()
*-----------------------

Local _aArea := {}, _nx := 0
Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO 'FAT' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 

For _nx := 1 To 4
	U_IFATP05("01","01")
	Sleep(60000)
Next _nx

RestArea(_aArea)

Return

*-----------------------
User Function IFATP05C()
*-----------------------

Local _aArea := {}, _nx := 0
Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO 'FAT' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 

For _nx := 1 To 4
	U_IFATP05("01","03")
	Sleep(60000)
Next _nx

RestArea(_aArea)
Return       

*-----------------------
User Function IFATP05D()
*-----------------------

Local _aArea := {}, _nx := 0
Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 

For _nx := 1 To 4
	U_IFATP05("01","04")
	Sleep(60000)
Next _nx

RestArea(_aArea)
Return  

*-----------------------
User Function IFATP05E()
*-----------------------

Local _aArea := {}, _nx := 0
Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "05" MODULO 'FATURAMENTO' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 

For _nx := 1 To 4
	U_IFATP05("01","05")
	Sleep(60000)
Next _nx

RestArea(_aArea)
Return 

*-----------------------
User Function IFATP05F()
*-----------------------

Local _aArea := {}, _nx := 0
Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "06" MODULO 'FAT' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 

For _nx := 1 To 4
	U_IFATP05("01","06")
	Sleep(60000)
Next _nx

RestArea(_aArea)
Return

/*
+-----------+---------+-------+---------------------------------------+------+-------------+
| Programa  | IFATP05 | Autor | Jose Augusto F.Alves - Anadi Soluções | Data | Agosto/2012 |
+-----------+---------+-------+---------------------------------------+------+-------------+
| Descricao | JOB para impressão automática do DANFE, após autorização da NF-e			   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/

User Function IFATP05(_cEmpAt, _cFilAt)
Local _aArea := {}     

Local aTables := { "SF2", "SF3" }
                
PREPARE ENVIRONMENT EMPRESA _cEmpAt FILIAL _cFilAt MODULO 'FATURAMENTO' TABLES "SF2","SF3"

_aArea := SM0->(GetArea()) 


		//dbSelectArea( "SM0" )
   		//dbGoTop()

   		//While !SM0->( EOF() )   
	        _cFilAux := cFilAnt
	        cFilAnt := _cFilAt
	        U_IFATP05A(_cEmpAt, _cFilAt)
	        cFilAnt := _cFilAux
	    	//SM0->( dbSkip() )
  		//End

RestArea(_aArea)

Return


/*
+-----------+----------+-------+---------------------------------------+------+-------------+
| Programa  | FFATP05A | Autor | Jose Augusto F.Alves - Anadi Soluções | Data | Agosto/2012 |
+-----------+----------+-------+---------------------------------------+------+-------------+
| Descricao | Verifica as notas não impressas e faz o envio para a impressora				|
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/

User Function IFATP05A(_cEmp,_cFil)
Local cQuery := _cSQL := _cTab := _cIdent := _cFile := "",oSetup


//Localiza a Identidade da Empresa nas tabelas do SPED
_cTab := GetNextAlias()
_cSQL := "Select ID_ENT From SPED001 "
_cSQL += "Where CNPJ = '" + SM0->M0_CGC + "' And D_E_L_E_T_ = ' ' "

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    _cIdent := (_cTab)->ID_ENT 
	   
	If Select("TRB_NF") <> 0
		TRB_NF->(dbCloseArea())
	Endif

    //Busca pelas notas não impressas e autorizadas
    cQuery := "Select F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO From " + RetSqlName("SF2") + " F2 "
    cQuery +=    "Inner Join SPED050 SP On ID_ENT = '" + _cIdent + "' And NFE_ID = F2_SERIE || F2_DOC And STATUS = 6 And SP.D_E_L_E_T_ = ' ' "
    //cQuery += "Where F2_FILIAL = '" + xFilial("SF2") + "' And F2_FIMP = ' ' And F2.D_E_L_E_T_ = ' ' And F2.FE__IMPRES <> 'S'"  
    cQuery += "Where F2_FILIAL = '" + xFilial("SF2") + "' And F2_FIMP = ' ' And F2.D_E_L_E_T_ = ' ' "
	
	TcQuery cQuery New Alias "TRB_NF"
	
	dbSelectArea("TRB_NF")
	TRB_NF->(dbGoTop())
	
    While TRB_NF->(!Eof())
        DbSelectArea("SF2")
        DbSetOrder(1)
        If DbSeek(xFilial("SF2") + TRB_NF->F2_DOC + TRB_NF->F2_SERIE + TRB_NF->F2_CLIENTE + TRB_NF->F2_LOJA)
                                                                                     
			If RecLock("SZF", .F.)
				SF2->F2__IMPRES	:= "S"		
				MsUnlock()
			EndIf
	         
	    EndIf
        
        DbSelectArea("TRB_NF")
        TRB_NF->(DbSkip())    
    EndDo

	TRB_NF->(dbGoTop())
    
    //Efetua a impressão do DANFE de cada nota
    While TRB_NF->(!Eof())
        DbSelectArea("SF2")
        DbSetOrder(1)
        If DbSeek(xFilial("SF2") + TRB_NF->F2_DOC + TRB_NF->F2_SERIE + TRB_NF->F2_CLIENTE + TRB_NF->F2_LOJA)
                                                                                     
	        _cFile := "DANFE_"+_cIdEnt+Dtos(MSDate())+StrTran(Time(),":","") 
	        CONOUT("NUMERO DA DANFE:"+_cFile)
	        lDisableSetup  := .T.
	        lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
	        oDanfe := FWMSPrinter():New(_cFile, IMP_SPOOL, lAdjustToLegacy, "\nfe\", lDisableSetup)   
	        U_DANFE_P1(_cIdEnt,,,oDanfe, oSetup)  
	         
	    EndIf
        
        DbSelectArea("TRB_NF")
        TRB_NF->(DbSkip())    
    EndDo
    
EndIf

Return 