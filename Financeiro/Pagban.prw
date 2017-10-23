#include "rwmake.ch"        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGBAN    �Autor  �Osmil Squarcine     � Data �  12/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �PROGRAMA PARA SEPARAR O BANCO DO CODIGO DE BARRAS           ���
���          �CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (96-98)           ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - HOSPITAL SANTA CRUZ                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pagban()        

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_BANCO,")

//  PROGRAMA PARA SEPARAR O BANCO DO CODIGO DE BARRAS
//  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (96-98)

//IF SUBSTR(SE2->E2_CODBAR,1,3) == "   "
//   _BANCO := SUBSTR(SA2->A2_BANCO,1,3)
//ELSE
//   _BANCO := SUBSTR(SE2->E2_CODBAR,1,3)
//ENDIF
 
DO CASE
	CASE SEA->EA_MODELO == "01" .OR. SEA->EA_MODELO=="02"
		_BANCO:= "237" 
	CASE SEA->EA_MODELO =="03" .OR. SEA->EA_MODELO=="41"
 		_BANCO:=STRZERO(VAL(SE2->E2_FORBCO))
 	CASE SEA->EA_MODELO == "30" .OR. SEA->EA_MODELO=="31"
 		_BANCO:= SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)
 ENDCASE
 			
 return _BANCO			
			//linha do cnab	,"237",IIF(ALLTRIM(SEA->EA_MODELO)$"03/41",STRZERO(VAL(SE2->E2_FORBCO),3),SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)))                                                                                                                                                                                                                                                                                                                                           
