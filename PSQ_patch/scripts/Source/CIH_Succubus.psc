Scriptname CIH_Succubus extends Quest Hidden

CIH_MCM MCM

Event OnInit()
	MCM = Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_MCM
EndEvent

bool Function isSuccubus ()
	playersuccubusquestscript PSQ = Quest.GetQuest("PlayerSuccubusQuest") as playersuccubusquestscript
	if PSQ.PlayerIsSuccubus.GetValue() == 1
		return true
	endif
	
	return false
EndFunction

float Function GetEnergy ()
	playersuccubusquestscript PSQ = Quest.GetQuest("PlayerSuccubusQuest") as playersuccubusquestscript
	return PSQ.SuccubusEnergy.GetValue()
EndFunction

float Function GetMaxEnergy ()
	playersuccubusquestscript PSQ = Quest.GetQuest("PlayerSuccubusQuest") as playersuccubusquestscript
	return PSQ.MaxEnergy
EndFunction
