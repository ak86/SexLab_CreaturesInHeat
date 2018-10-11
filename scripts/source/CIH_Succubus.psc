Scriptname CIH_Succubus extends Quest Hidden

PlayerVampireQuestScript VampireQuest
CIH_MCM MCM

Event OnInit()
	VampireQuest = Quest.GetQuest("PlayerVampireQuest") as PlayerVampireQuestScript
	MCM = Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_MCM
EndEvent

bool Function isSuccubus ()
	Actor PlayerRef = Game.Getplayer()
	If Game.GetModbyName("SuccubusRaceLite.esp") != 255
		if PlayerRef.GetRace() == Game.GetFormFromFile(0x00D62, "SuccubusRaceLite.esp") as race
			return true
		endif
		if PlayerRef.GetRace() == Game.GetFormFromFile(0x1F4D0, "SuccubusRaceLite.esp") as race
			return true
		endif
	endif
	
	if MCM.isSuccubus\
	|| (StorageUtil.GetIntValue(PlayerRef, "Angrim_iSuccubusCurse") > 0)
		return true
	endif
	
	return false
EndFunction

float Function GetEnergy ()
	return -1000
EndFunction

float Function GetMaxEnergy ()
	return 1000
EndFunction
