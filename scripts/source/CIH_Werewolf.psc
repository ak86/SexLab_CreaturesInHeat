Scriptname CIH_Werewolf extends Quest Hidden

CompanionsHousekeepingScript WereWolfQuest

Event OnInit()
	WereWolfQuest = Quest.GetQuest("C00") as CompanionsHousekeepingScript
EndEvent

bool Function isWerewolf()
	if WereWolfQuest.PlayerHasBeastBlood
		return true
	endif
	
	return false
EndFunction

Int Function GetCurrentMoonphase()
	Int PhaseTest = GetCurrentDay()

	If PhaseTest >= 22 || PhaseTest == 0
		Return 7
	ElseIf PhaseTest < 4
		Return 0
	ElseIf PhaseTest < 7
		Return 1
	ElseIf PhaseTest < 10
		Return 2
	ElseIF PhaseTest < 13
		Return 3
	ElseIf PhaseTest < 16
		Return 4
	ElseIf PhaseTest < 19
		Return 5
	ElseIf PhaseTest < 22
		Return 6
	EndIf
EndFunction

Int Function GetCurrentDay()
	Int GameDayPassed
	Int GameHoursPassed
	Int CurrentDay
	
	GameDayPassed = GetPassedGameDays()
	GameHoursPassed = GetPassedGameHours()
 
	If (GameHoursPassed >= 12.0)
		GameDayPassed += 1
	EndIf
 
	CurrentDay = GameDayPassed % 24 ;A full cycle through the moon phases lasts 24 days

	Return CurrentDay
EndFunction

Int Function GetPassedGameHours()
	Float GameTime
	Float GameHoursPassed
 
	GameTime = Utility.GetCurrentGameTime()
	GameHoursPassed = Math.Floor((GameTime - Math.Floor(GameTime)) * 24)
	Return GameHoursPassed as Int
EndFunction

Int Function GetPassedGameDays()
	Float GameTime
	Float GameDayPassed
 
	GameTime = Utility.GetCurrentGameTime()
	GameDayPassed = Math.Floor(GameTime)
	Return GameDayPassed as Int
EndFunction
