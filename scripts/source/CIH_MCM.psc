scriptname CIH_MCM extends SKI_ConfigBase
{MCM Menu script}

SexLabFramework property SexLab auto
slaFrameworkScr property SexLabAroused auto

bool property enableMod = True auto
bool property enableWerewolf = True auto
bool property enableVampire = True auto
bool property enableSuccubus = True auto
bool property isSuccubus = False auto
bool property sqrt = True auto

bool property enableCustomWerewolf = False auto
int property customNewMoon = 0 Auto
int property customWaxingCrescent = 1 Auto
int property customFirstQuarter = 2 Auto
int property customWaxingGibbous = 4 Auto
int property customFullMoon = 8 Auto
int property customWaningGibbous = 4 Auto
int property customThirdQuarter = 2 Auto
int property customWaningCrescent = 1 Auto
int property customNewMoonDefault = 0 Auto
int property customWaxingCrescentDefault = 1 Auto
int property customFirstQuarterDefault = 2 Auto
int property customWaxingGibbousDefault = 4 Auto
int property customFullMoonDefault = 8 Auto
int property customWaningGibbousDefault = 4 Auto
int property customThirdQuarterDefault = 2 Auto
int property customWaningCrescentDefault = 1 Auto

int property SuccubusEnergyDrainPerHour = 50 auto
int property SuccubusEnergyGainPerOrgasm = 100 auto

int property SuccubusEnergyDrainPerHourDefault = 50 auto
int property SuccubusEnergyGainPerOrgasmDefault = 100 auto

;=============================================================
;INIT
;=============================================================

event OnConfigInit()
    ModName = "SL Creatures in heat"
	self.RefreshStrings()
endEvent

Function RefreshStrings()
	Pages = new string[4]
	Pages[0] = "$CIH_Config"
	Pages[1] = "$CIH_Werewolf"
	Pages[2] = "$CIH_Vampire"
	Pages[3] = "$CIH_Succubus"
EndFunction

event OnPageReset(string page)
	if page == ""
		;self.LoadCustomContent("MilkMod/MilkLogo.dds")
		self.RefreshStrings()
	else
		;self.UnloadCustomContent()
	endif

	if page == "$CIH_Config"
		self.Page_Config()
	elseif page == "$CIH_Werewolf"
		self.Page_Werewolf()
	elseif page == "$CIH_Vampire"
		self.Page_Vampire()
	elseif page == "$CIH_Succubus"
		self.Page_Succubus()
	endif
endEvent

;=============================================================
;PAGES Layout
;=============================================================

function Page_Config()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddToggleOptionST("enableWerewolf_T", "$CIH_enableWerewolf", enableWerewolf)
		AddToggleOptionST("enableVampire_T", "$CIH_enableVampire", enableVampire)
		AddToggleOptionST("enableSuccubus_T", "$CIH_enableSuccubus", enableSuccubus)
		AddEmptyOption()

		AddToggleOptionST("enableMod_T", "$CIH_enableMod", enableMod)
		AddToggleOptionST("sqrt_T", "$CIH_sqrt", sqrt)
	
	SetCursorPosition(1)
		AddTextOption("$CIH_isWerewolf", (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Werewolf).isWerewolf(), OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_isVampire", (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Vampire).isVampire(), OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_isSuccubus", (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Succubus).isSuccubus(), OPTION_FLAG_DISABLED)
endfunction

function Page_Werewolf()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddTextOption("$CIH_Curr_Phase_of_the_Moon" , "$CIH_Curr_Day", OPTION_FLAG_DISABLED)
		int CurrentDay = (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Werewolf).GetCurrentDay()
		If CurrentDay >= 22 || CurrentDay == 0
			AddTextOption("$CIH_Waxing_gibbous" , CurrentDay)
		ElseIf CurrentDay < 4
			AddTextOption("$CIH_Full_moon" , CurrentDay)
		ElseIf CurrentDay < 7
			AddTextOption("$CIH_Waning_gibbous" , CurrentDay)
		ElseIf CurrentDay < 10
			AddTextOption("$CIH_Third_quarter" , CurrentDay)
		ElseIF CurrentDay < 13
			AddTextOption("$CIH_Waning_crescent" , CurrentDay)
		ElseIf CurrentDay < 16
			AddTextOption("$CIH_New_moon" , CurrentDay)
		ElseIf CurrentDay < 19
			AddTextOption("$CIH_Waxing_crescent" , CurrentDay)
		ElseIf CurrentDay < 22
			AddTextOption("$CIH_First_quarter" , CurrentDay)
		EndIf

		AddEmptyOption()
		AddTextOption("$CIH_New_moon" ,"13-15", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Waxing_crescent" ,"16-18", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_First_quarter" ,"19-21", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Waxing_gibbous" ,"22-24", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Full_moon" , "1-3", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Waning_gibbous" ,"4-6", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Third_quarter" ,"7-9", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Waning_crescent" ,"10-12", OPTION_FLAG_DISABLED)
		AddEmptyOption()

	SetCursorPosition(1)
		AddToggleOptionST("enableCustomWerewolf_T", "$CIH_enableCustomWerewolf", enableCustomWerewolf)
		AddTextOption("$CIH_heat_per_hour" , (self.GetAlias(0) as CIH_PlayerAliasScript).TimerWerewolf())
		AddEmptyOption()

		AddSliderOptionST("CustomWerewolfNewMoon_S", "$CIH_New_Moon", customNewMoon, "{0}")
		AddSliderOptionST("CustomWerewolfWaxingCrescent_S", "$CIH_Waxing_Crescent", customWaxingCrescent, "{0}")
		AddSliderOptionST("CustomWerewolfFirstQuarter_S", "$CIH_First_Quarter", customFirstQuarter, "{0}")
		AddSliderOptionST("CustomWerewolfWaxingGibbous_S", "$CIH_Waxing_Gibbous", customWaxingGibbous, "{0}")
		AddSliderOptionST("CustomWerewolfFullMoon_S", "$CIH_Full_Moon", customFullMoon, "{0}")
		AddSliderOptionST("CustomWerewolfWaningGibbous_S", "$CIH_Waning_Gibbous", customWaningGibbous, "{0}")
		AddSliderOptionST("CustomWerewolfWaningQuarter_S", "$CIH_Third_Quarter", customThirdQuarter, "{0}")
		AddSliderOptionST("CustomWerewolfWaningCrescent_S", "$CIH_Waning_Crescent", customWaningCrescent, "{0}")

		AddEmptyOption()
endfunction	

function Page_Vampire()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddTextOption("$CIH_Vampire_Heat_start" , "20:00", OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_Vampire_Heat_end" , "04:00", OPTION_FLAG_DISABLED)
		
	SetCursorPosition(1)
		AddTextOption("$CIH_Current_hour" , Math.Floor((self.GetAlias(0) as CIH_PlayerAliasScript).GetCurrentHourOfDay()) as int)
		AddTextOption("$CIH_Vampire_Feed" , (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Vampire).GetFeedTimer() as int)
		AddTextOption("$CIH_Vampire_Stage" , (Quest.GetQuest("CIH_CreaturesInHeatQuest") as CIH_Vampire).GetVampireStatus() as int)
		AddTextOption("$CIH_heat_per_hour" ,(self.GetAlias(0) as CIH_PlayerAliasScript).TimerVampire() as int)
		AddEmptyOption()
endfunction	

function Page_Succubus()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddTextOption("$CIH_Energy" , (self.GetAlias(0) as CIH_PlayerAliasScript).GetEnergy() as int, OPTION_FLAG_DISABLED)
		AddTextOption("$CIH_MaxEnergy" , (self.GetAlias(0) as CIH_PlayerAliasScript).GetMaxEnergy() as int, OPTION_FLAG_DISABLED)
		
	SetCursorPosition(1)
		AddToggleOptionST("isSuccubus_T", "$CIH_overrideSuccubus", isSuccubus)	
		AddSliderOptionST("SuccubusEnergyDrainPerHour_S", "$CIH_SuccubusEnergyDrainPerHour", SuccubusEnergyDrainPerHour, "{0}")
		AddSliderOptionST("SuccubusEnergyGainPerOrgasm_S", "$CIH_SuccubusEnergyGainPerOrgasm", SuccubusEnergyGainPerOrgasm, "{0}")
		AddTextOption("$CIH_heat_per_hour" , (self.GetAlias(0) as CIH_PlayerAliasScript).TimerSuccubus() as int)
endfunction	

;=============================================================
;STATES, mess below
;=============================================================

;=============================================================
;TOGGLES
;=============================================================

state enableWerewolf_T
	event OnSelectST()
		if enableWerewolf
			enableWerewolf = false
		else
			enableWerewolf = true
		endif
		SetToggleOptionValueST(enableWerewolf)
	endEvent
endState

state enableVampire_T
	event OnSelectST()
		if enableVampire
			enableVampire = false
		else
			enableVampire = true
		endif
		SetToggleOptionValueST(enableVampire)
	endEvent
endState

state enableSuccubus_T
	event OnSelectST()
		if enableSuccubus
			enableSuccubus = false
		else
			enableSuccubus = true
		endif
		SetToggleOptionValueST(enableSuccubus)
	endEvent
endState

state enableMod_T
	event OnSelectST()
		if enableMod
			enableMod = false
			(self.GetAlias(0) as CIH_PlayerAliasScript).UnregisterForUpdate()
		else
			enableMod = true
			(self.GetAlias(0) as CIH_PlayerAliasScript).RegisterForUpdateGameTime(1)
		endif
		SetToggleOptionValueST(enableMod)
	endEvent
endState

state sqrt_T
	event OnSelectST()
		if sqrt
			sqrt = false
		else
			sqrt = true
		endif
		SetToggleOptionValueST(sqrt)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$CIH_sqrt_Higlight")
	endEvent
endState

state isSuccubus_T
	event OnSelectST()
		if isSuccubus
			isSuccubus = false
		else
			isSuccubus = true
		endif
		SetToggleOptionValueST(isSuccubus)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$CIH_isSuccubus_Higlight")
	endEvent
endState

state enableCustomWerewolf_T
	event OnSelectST()
		if enableCustomWerewolf
			enableCustomWerewolf = false
		else
			enableCustomWerewolf = true
		EndIf
		SetToggleOptionValueST(enableCustomWerewolf)
		ForcePageReset()
	endEvent
	event OnHighlightST()
		SetInfoText("$CIH_enableCustomWerewolf_Higlight")
	endEvent
endState

;=============================================================
;Sliders
;=============================================================
		
state SuccubusEnergyDrainPerHour_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(SuccubusEnergyDrainPerHour)
		SetSliderDialogDefaultValue(SuccubusEnergyDrainPerHourDefault)
		SetSliderDialogRange(0, 1000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		SuccubusEnergyDrainPerHour = value as int
		SetSliderOptionValueST(SuccubusEnergyDrainPerHour, "{0}")
	endEvent

	event OnHighlightST()
		SetInfoText("$CIH_SuccubusEnergyDrainPerHour_Higlight")
	endEvent
endState

state SuccubusEnergyGainPerOrgasm_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(SuccubusEnergyGainPerOrgasm)
		SetSliderDialogDefaultValue(SuccubusEnergyGainPerOrgasmDefault)
		SetSliderDialogRange(0, 1000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		SuccubusEnergyGainPerOrgasm = value as int
		SetSliderOptionValueST(SuccubusEnergyGainPerOrgasm, "{0}")
	endEvent

	event OnHighlightST()
		SetInfoText("$CIH_SuccubusEnergyGainPerOrgasm_Higlight")
	endEvent
endState

state CustomWerewolfNewMoon_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customNewMoon)
		SetSliderDialogDefaultValue(customNewMoonDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customNewMoon = value as Int
		SetSliderOptionValueST(customNewMoon, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfWaxingCrescent_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customWaxingCrescent)
		SetSliderDialogDefaultValue(customWaxingCrescentDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customWaxingCrescent = value as Int
		SetSliderOptionValueST(customWaxingCrescent, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfFirstQuarter_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customFirstQuarter)
		SetSliderDialogDefaultValue(customFirstQuarterDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customFirstQuarter = value as Int
		SetSliderOptionValueST(customFirstQuarter, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfWaxingGibbous_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customWaxingGibbous)
		SetSliderDialogDefaultValue(customWaxingGibbousDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customWaxingGibbous = value as Int
		SetSliderOptionValueST(customWaxingGibbous, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfFullMoon_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customFullMoon)
		SetSliderDialogDefaultValue(customFullMoonDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customFullMoon = value as Int
		SetSliderOptionValueST(customFullMoon, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfWaningGibbous_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customWaningGibbous)
		SetSliderDialogDefaultValue(customWaningGibbousDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customWaningGibbous = value as Int
		SetSliderOptionValueST(customWaningGibbous, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfWaningQuarter_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customThirdQuarter)
		SetSliderDialogDefaultValue(customThirdQuarterDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customThirdQuarter = value as Int
		SetSliderOptionValueST(customThirdQuarter, "{0}")
		ForcePageReset()
	EndEvent
EndState

state CustomWerewolfWaningCrescent_S
	event OnSliderOpenST()
		SetSliderDialogStartValue(customWaningCrescent)
		SetSliderDialogDefaultValue(customWaningCrescentDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent

	event OnSliderAcceptST(float value)
		customWaningCrescent = value as Int
		SetSliderOptionValueST(customWaningCrescent, "{0}")
		ForcePageReset()
	EndEvent
EndState