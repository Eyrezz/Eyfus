#SingleInstance, Force
#Persistent
DetectHiddenWindows On
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
OnExit("Closing")

IniRead, CN, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterNumber, CN
IniRead, DN, %A_ScriptDir%\Config\IniFiles\DataNumber.ini, DataNumber, DN

Loop, %CN%
	{
	IniRead, C%A_Index%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, C%A_Index%
	IniRead, CS%A_Index%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, CS%A_Index%
	}
Loop, %DN%
    {
    IniRead, %A_Index%, %A_ScriptDir%\Config\IniFiles\DataNumber.ini, CharacterData, %A_Index%
    }
Loop, read, %A_ScriptDir%\Config\IniFiles\Configs.ini
    {
    IfInString, A_LoopReadLine, =
        {
        Conf_Main++
        }
    }
Loop, read, %A_ScriptDir%\Config\IniFiles\RomanNumeral.ini
    {
    IfInString, A_LoopReadLine, =
        {
        Rom_Num++
        }
    }
Loop, read, %A_ScriptDir%\Config\IniFiles\ShortCutInitiative.ini
    {
    IfInString, A_LoopReadLine, [
        {
        ShortCut_Ini++
        }
    }
Loop, read, %A_ScriptDir%\Config\IniFiles\ShortCutMacro.ini
    {
    IfInString, A_LoopReadLine, =
        {
        ShortCut_Macro++
        }
    }
Loop, read, %A_ScriptDir%\Config\IniFiles\Keys.ini
    {
    IfInString, A_LoopReadLine, =
        {
        Keys_Macro++
        }
    }
Loop, %Conf_Main%
    {
    IniRead, ShortConf%A_Index%, %A_ScriptDir%\Config\IniFiles\Configs.ini, ShortcutConfig, ShortConf%A_Index%
    }
Loop, %Rom_Num%
    {
    IniRead, RNum%A_Index%, %A_ScriptDir%\Config\IniFiles\RomanNumeral.ini, Roman numeral, RNum%A_Index%
    }
Loop, %ShortCut_Ini%
    {
    IniRead, IniA%A_Index%, %A_ScriptDir%\Config\IniFiles\ShortCutInitiative.ini, ShortcutIni%A_Index%, IniA%A_Index%
    IniRead, IniMi%A_Index%, %A_ScriptDir%\Config\IniFiles\ShortCutInitiative.ini, ShortcutIni%A_Index%, IniMi%A_Index%
    }
Loop, %ShortCut_Macro%
	{
	IniRead, ShortMacro%A_Index%, %A_ScriptDir%\Config\IniFiles\ShortCutMacro.ini, ShortcutMacro, ShortMacro%A_Index%
	}
Loop, %Keys_Macro%
	{
	IniRead, Key%A_Index%, %A_ScriptDir%\Config\IniFiles\Keys.ini, Keys, Key%A_Index%
	}
Loop, %ShortCut_Ini%
    {
   	HotKey, % IniA%A_Index%, MainIniAc%A_Index%
   	HotKey, % IniMi%A_Index%, MainIniMi%A_Index%
    }
Loop, %Conf_Main%
	{
	HotKey, % ShortConf%A_Index%, MainConf%A_Index%
	}
Loop, %ShortCut_Macro%
	{
	HotKey, % ShortMacro%A_Index%, ShortPvm%A_Index%
	}
return

Dif := 0

DeleteIniFile:
{
IniDelete, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Window name
IniDelete, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, IDFenetre
IniDelete, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Name
IniDelete, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Number accounts
return
}

checkAnyWin:
{
anyWinActive := False
Loop, %N_Accounts%
	{
	if WinActive(np%A_Index%)
		{
		anyWinActive := True
		}
	}
return
}

checkAnyWinNotMinimized:
{
Nt := 0
Loop, %N_Accounts%
	{
	this_idtn := P%A_Index%
	WinGet, min_max_state,MinMax, ahk_id %this_idtn%
	if (min_max_state = 1)
		{
		Nt++
		WinGetTitle, Tn%Nt%, ahk_id %this_idtn%
		}
	}
return
}

checkAnyWinMinimized:
{
Nm := 0
Loop, %N_Accounts%
	{
	this_idmn := P%A_Index%
	WinGet, min_max_state,MinMax, ahk_id %this_idmn%
	if (min_max_state = -1)
		{
		Nm++
		WinGetTitle, Mn%Nm%, ahk_id %this_idmn%
		}
	}
return
}

CloseExit: 
{
Loop, %N_Accounts%
	{
	if WinExist("ahk_id" P%A_Index%)
		{
		WinSetTitle, % nd%A_Index%
		this_id_reset := P%A_Index%
		SendMessage, 0x80, 0, 0,, ahk_id %this_id_reset%
		SendMessage, 0x80, 1, 0,, ahk_id %this_id_reset%
		winHide, ahk_id %this_id_reset%
		winShow, ahk_id %this_id_reset%
		}
	}	
if (Dif = 1)
	{
	Gosub DeleteIniFile
	}
return
}

MainConf1:
{
Loop, %D%
	{
	WinSetTitle, % np%A_Index%, , % nd%A_Index%
	P%A_Index% := ""
	}
if (Dif = 1)
	{
	Gosub DeleteIniFile
	N_Accounts := 0
	}
else 
	{
	Dif++	
	}
WinGet, D, list, - Dofus
Loop, %D%
	{
	this_id := D%A_Index%
	WinGet, min_max_state,MinMax, ahk_id %this_id%
	if (min_max_state = 1)
		{
		WinGetTitle, nd%A_Index%, ahk_id %this_id%
		Array%A_Index% := StrSplit(nd%A_Index%, [A_Space, "`n"])
		name%A_Index% := Array%A_Index%[1]
		this_name := name%A_Index%
		WinGet, P%A_Index%, ID, % nd%A_Index%
		this_idf := P%A_Index%
		this_number := RNum%A_Index%
		WinSetTitle, % nd%A_Index%, , - %this_number% - %this_name% - Dofus
		WinGetTitle, np%A_Index%, ahk_id %this_idf%
		Loop, %CN%
			{
			if (C%A_Index% = this_name)
				{
				Break
				}
			else 
				{
				if (A_Index = CN)
					{
					InputBox, UserInput, %this_name%,1 = Cra_F                     2 = Cra_M`n3 = Ecaflip_F                 4 = Ecaflip_M`n5 = Eliotrope_F             6 = Eliotrope_M`n7 = Eniripsa_F               8 = Eniripsa_M`n9 = Enutrof_F               10 = Enutrof_M`n11 = Feca_F                 12 = Feca_M`n13 = Forgelance_F       14 = Forgelance_M`n15 = Huppermage_F    16 = Huppermage_M`n17 = Iop_F                   18 = Iop_M`n19 = Osamodas_F        20 = Osamodas_M`n21 = Ouginak_F            22 = Ouginak_M`n23 = Pandawa_F           24 = Pandawa_M`n25 = Roublard_F          26 = Roublard_M`n27 = Sacrieur_F            28 = Sacrieur_M`n29 = Sadida_F              30 = Sadida_M`n31 = Sram_F                32 = Sram_M`n33 = Steamer_F            34 = Steamer_M`n35 = Xelor_F                36 = Xelor_M`n37 = Zobal_F                38 = Zobal_M`n, 200, 300, 430
					if ErrorLevel
						{
    					MsgBox, CANCEL was pressed.
    					Gosub DeleteIniFile
    					ExitApp
    					}
					else
						{
						NewCharacter := %UserInput%
						CN++
						IniWrite, %CN%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterNumber, CN
   						IniWrite, %this_name%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, C%CN%
   						IniWrite, %NewCharacter%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, CS%CN%
    					}
					}
    			}
    		}	
    	IniRead, CN, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterNumber, CN		
    	Loop, %CN%
			{
			IniRead, C%A_Index%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, C%A_Index%
			IniRead, CS%A_Index%, %A_ScriptDir%\Config\IniFiles\DataCharacters.ini, CharacterClasseSexe, CS%A_Index%
			}	
		Loop, %CN%
			{
			if (this_name = C%A_Index%)
				{
				ICW := CS%A_Index%
				this_classe := ICW
				ArrayClasseSexe%A_Index% := StrSplit(this_classe, ["_"]) 
				Ico = %A_ScriptDir%\Config\IcoCharacters\%ICW%.ico
				hIcon := DllCall( "LoadImage", UInt,0, Str,Ico, UInt,1, UInt,0, UInt,0, UInt,0x10 )
				SendMessage, 0x80, 0, hIcon ,, ahk_id %this_idf%  
				SendMessage, 0x80, 1, hIcon ,, ahk_id %this_idf%
				winHide, ahk_id %this_idf%
				winShow, ahk_id %this_idf%
				}
			}
		N_Accounts++
		}
	else
		{
		SendMessage, 0x80, 0, 0,, ahk_id %this_id%
		SendMessage, 0x80, 1, 0,, ahk_id %this_id%
		winHide, ahk_id %this_id%
		winShow, ahk_id %this_id%
		}
	}
IniWrite, %N_Accounts%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Number accounts, N_Accounts
Loop, %N_Accounts%
	{
	IniWrite, % np%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Window name, np%A_Index%
	IniWrite, % P%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, IDFenetre, P%A_Index%
	IniWrite, % name%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Name, name%A_Index%
	}	
IniRead, N_Accounts, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Number accounts, N_Accounts
Loop, %N_Accounts%
	{
	IniRead, np%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Window name, np%A_Index%
	IniRead, P%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, IDFenetre, P%A_Index%
	IniRead, name%A_Index%, %A_ScriptDir%\Config\IniFiles\ActualsCharacters.ini, Name, name%A_Index%
	}
return
}

MainConf2:
{
ExitApp
Closing() {
Gosub CloseExit
}
}

MainIniAc1:
{
if (WinExist(np1))
	{
	WinActivate
	}
return
}

MainIniAc2:
{
if (WinExist(np2))
	{
	WinActivate
	}
return
}

MainIniAc3:
{
if (WinExist(np3))
	{
	WinActivate
	}
return
}

MainIniAc4:
{
if (WinExist(np4))
	{
	WinActivate
	}
return
}

MainIniAc5:
{
if (WinExist(np5))
	{
	WinActivate
	}
return
}

MainIniAc6:
{
if (WinExist(np6))
	{
	WinActivate
	}
return
}

MainIniAc7:
{
if (WinExist(np7))
	{
	WinActivate
	}
return
}

MainIniAc8:
{
if (WinExist(np8))
	{
	WinActivate
	}
return
}

MainIniMi1:
{
if (WinExist(np1))
	{
	WinMinimize
	}
return
}

MainIniMi2:
{
if (WinExist(np2))
	{
	WinMinimize
	}
return
}

MainIniMi3:
{
if (WinExist(np3))
	{
	WinMinimize
	}
return
}

MainIniMi4:
{
if (WinExist(np4))
	{
	WinMinimize
	}
return
}

MainIniMi5:
{
if (WinExist(np5))
	{
	WinMinimize
	}
return
}

MainIniMi6:
{
if (WinExist(np6))
	{
	WinMinimize
	}
return
}

MainIniMi7:
{
if (WinExist(np7))
	{
	WinMinimize
	}
return
}

MainIniMi8:
{
if (WinExist(np8))
	{
	WinMinimize
	}
return
}

ShortPvm1:
{
gosub checkAnyWin
if(anyWinActive)
	{
	gosub checkAnyWinNotMinimized
	Loop, %Nt%
		{
		if (WinActive(Tn%A_Index%))
			{
			if A_Index = %Nt%
				{
				Nc := 1
				}	
			else
				{
				Nc := A_Index + 1
				}
			if (WinExist(Tn%Nc%))
				{
				WinActivate
				return
				}
			}
		}
	}
return		
}

ShortPvm2:
{
gosub checkAnyWin
if(anyWinActive)
	{
	gosub checkAnyWinNotMinimized
	Loop, %Nt%
		{
		if (WinActive(Tn%A_Index%))
			{
			if (A_Index = 1)
				{
				Nc := Nt
				}	
			else
				{
				Nc := A_Index - 1
				}
			if (WinExist(Tn%Nc%))
				{
				WinActivate
				return
				}
			}
		}
	}
return		
}

ShortPvm3:
{
gosub checkAnyWin
if(anyWinActive)
	{
	gosub checkAnyWinNotMinimized
	Loop, %Nt%
		{
		if (WinActive(Tn%A_Index%))
			{
			if A_Index = %Nt%
				{
				Nc := 1
				}	
			else
				{
				Nc := A_Index + 1
				}
			if (WinExist(Tn%Nc%))
				{
				ControlSend,, {%Key1%}, % Tn%A_Index%
				WinActivate
				return
				}
			}
		}
	}
return		
}

ShortPvm4:
{
gosub checkAnyWin
if(anyWinActive)
	{
	gosub checkAnyWinNotMinimized
	MouseGetPos, xpos, ypos
	Loop, %Nt%
		{
		if (WinActive(Tn%A_Index%))
			{
			ControlClick, X%xpos% Y%ypos%
			if A_Index = %Nt%
				{
				Nc := 1
				}
			else
				{
				Nc := A_Index + 1
				}
			if (WinExist(Tn%Nc%))
				{
				WinActivate
				return
				}
			}
		}
	}
return
}

ShortPvm5:
{
gosub checkAnyWinMinimized
Loop, %Nm%
	{
	if (WinExist(Mn%A_Index%))
		{
		WinActivate
		}
	}
return
}