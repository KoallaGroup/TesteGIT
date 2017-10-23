#Include "Protheus.ch"

User Function IFISG01()
Local _lRet := .f., _aGrupo := UsrRetGrp (__cUserId), nx := 0

For nx := 1 To Len(_aGrupo)
            If _aGrupo[nx] $ Alltrim(GetMv("MV__GRPFIS"))
                        _lRet := .t.
                        Exit
            EndIf
Next nx

Return _lRet

