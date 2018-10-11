Scriptname CIH_Vampire extends Quest Hidden

PlayerVampireQuestScript VampireQuest

Event OnInit()
	VampireQuest = Quest.GetQuest("PlayerVampireQuest") as PlayerVampireQuestScript
EndEvent

bool Function isVampire()
	if VampireQuest.VampireStatus > 0
		return true
	endif
	
	return false
EndFunction

float Function GetVampireStatus()
	return VampireQuest.VampireStatus
EndFunction

float Function GetFeedTimer()
	return VampireQuest.FeedTimer
EndFunction
