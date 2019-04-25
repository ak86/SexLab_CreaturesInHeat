scriptname CIH_PlayerAliasScript extends ReferenceAlias

bool SexLabArousedlocked = false

Float CumCount = 500.0

CIH_MCM MCM
CIH_Werewolf W
CIH_Vampire V
CIH_Succubus S

;=============================================================
;INIT
;=============================================================

Event OnInit()
	Maintenance()
	Debug.Notification("Creatures in heat OnInit => " + self.GetActorRef().GetLeveledActorBase().GetName())
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

function Maintenance()
	MCM = self.GetOwningQuest() as CIH_MCM
	W = self.GetOwningQuest() as CIH_Werewolf
	V = self.GetOwningQuest() as CIH_Vampire
	S = self.GetOwningQuest() as CIH_Succubus
	
	self.RegisterForModEvent("SexLabOrgasmSeparate", "OnSexLabOrgasmSeparate")
	self.RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	self.RegisterForSingleUpdateGameTime(1)
endFunction

int function TimerWerewolf()
	int heat = 0
	if W.isWerewolf() && MCM.enableWerewolf
		int day = W.GetCurrentDay()

		;A full cycle through the moon phases lasts 24 days
		;fool moon, max arousal gen
		if day < 4
			;SexLabArousedunlock
			heat = 10
			;after fool moon, reduce arousal gen
		elseif day < 7
			heat = 7 - day
			;befor fool moon, increase arousal gen
		elseif day >= 22
			heat = day - 21
		elseif SexLabArousedlocked
		;maybe add later or not
		;SexLabArousedlocked unlock
		endif
	endif
	
	if MCM.sqrt
		heat = heat * heat
	endif
	return heat
endFunction

int function TimerVampire()
	int heat = 0
	if V.isVampire() && MCM.enableVampire
		float Feed = V.GetFeedTimer()
		float Stage = V.GetVampireStatus()
		if Feed/Stage > 1.25
			heat = Feed as int
		elseif Feed >= 1
			heat = (Feed/Stage) as int
		endif
	endif
	
	if MCM.sqrt
		heat = heat * heat
	endif
	return heat
endFunction

int function TimerSuccubus()
	int heat = 0
	if S.isSuccubus() && MCM.enableSuccubus
		float MaxEnergy = GetMaxEnergy()
		float CurrentEnergy = GetEnergy()
		CurrentEnergy = PapyrusUtil.ClampFloat(CurrentEnergy, 1.0, MaxEnergy)
		if MaxEnergy/CurrentEnergy > 1.25
			heat = (MaxEnergy/CurrentEnergy) as int
		endif
	endif
	
	if MCM.sqrt
		heat = heat * heat
	endif
	return heat
endFunction

Event OnUpdateGameTime()
	if MCM.enableMod
		float Time = GetCurrentHourOfDay()
		;check succ everyhour
		CumCount = PapyrusUtil.ClampFloat(CumCount - MCM.SuccubusEnergyDrainPerHour, 0.0, 1000)
		MCM.SexLabAroused.UpdateActorExposure(self.GetActorRef(), TimerSuccubus())
		;check werewolf at everyhour, trigger at moon phase
		MCM.SexLabAroused.UpdateActorExposure(self.GetActorRef(), TimerWerewolf())
		if Time < 4 || Time > 20
			;check vampires at night
			MCM.SexLabAroused.UpdateActorExposure(self.GetActorRef(), TimerVampire())
		endif
		RegisterForSingleUpdateGameTime(1)
	endif
endEvent

float Function GetCurrentHourOfDay()
{Returns the current time of day in hours since midnight}
 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return Time
EndFunction

Function RegisterForSingleUpdateGameTimeAt(float GameTime)
{Registers for a single UpdateGameTime event at the next occurrence
of the specified GameTime (in hours since midnight)}
 
	float CurrentTime = GetCurrentHourOfDay()
	If (GameTime <= CurrentTime)
		GameTime += 24
	EndIf
 
	RegisterForSingleUpdateGameTime(GameTime - CurrentTime)
EndFunction

float Function GetEnergy()
	float CurrentEnergy = S.GetEnergy()
	
	;use own calc if no psq
	if CurrentEnergy < 0
		CurrentEnergy = CumCount
	endif
	Return CumCount
EndFunction

float Function GetMaxEnergy()
	Return S.GetMaxEnergy()
EndFunction

;----------------------------------------------------------------------------
;SexLab hooks
;----------------------------------------------------------------------------

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	sslThreadController controller = MCM.SexLab.GetController(_argc as int)

	if controller.HasPlayer && !(MCM.SexLab.config.SeparateOrgasms && Game.GetModbyName("SLSO.esp") != 255)
		CumCount = CumCount + (controller.ActorAlias.Length - 1) * MCM.SuccubusEnergyGainPerOrgasm
	endif
EndEvent

Event OnSexLabOrgasmSeparate(Form ActorRef, Int Thread)
	sslThreadController controller = MCM.SexLab.GetController(Thread)
	
	if controller.HasPlayer && ActorRef != self.GetActorRef()
		CumCount = CumCount + MCM.SuccubusEnergyGainPerOrgasm
	endif
EndEvent
