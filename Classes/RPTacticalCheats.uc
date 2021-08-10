class RPTacticalCheats extends Mod_TacticalCheatManager;

function RoulettePlusMod RP()
{
	return RoulettePlusMod(ModBridge(XComGameInfo(WorldInfo.Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod"));
}

function ResetSoldierScreen()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	kSoldierUI.ClearTimer('ResetSoldierScreen', self);
	
	kSoldierUI.SetActiveSoldier(kSoldierUI.m_kSoldier);
	kSoldierUI.UpdateDoll();
	kSoldierUI.UpdateView();

	kSoldierUI.m_kSoldier.onLoadoutChange();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierSummary.SetSoldier(kSoldierUI.m_kSoldier);
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.GetMgr().UpdateView();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.UpdateAbilityData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierHeader.UpdateData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierStats.UpdateData();
}

exec function RoulettePlusTest()
{
	`Log("Success");
}

exec function RerollRandomTree()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		kSoldierUI.m_kSoldier.AssignRandomPerks();

		kSoldierUI.SetTimer(0.5, false, 'ResetSoldierScreen', self);
	}
}

exec function RerollStats()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		kSoldierUI.m_kSoldier.m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
		kSoldierUI.m_kSoldier.m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
		kSoldierUI.m_kSoldier.m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
		kSoldierUI.m_kSoldier.m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
		kSoldierUI.m_kSoldier.m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBarracks.RandomizeStats(kSoldierUI.m_kSoldier);

		kSoldierUI.SetTimer(0.5, false, 'ResetSoldierScreen', self);
	}
}

exec function RemoveRandPerks()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(Outer.GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		RP().RemoveRandPerks(kSoldierUI.m_kSoldier);

		kSoldierUI.SetTimer(0.5, false, 'ResetSoldierScreen', self);
	}
}

exec function ResetAndReroll()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		RemoveRandPerks();
		RerollRandomTree();
		RerollStats();
	}
}

exec function RemovePerk(string strName)
{
    local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;
    local int iIndex;
    local bool bFound;
    local TPerk kPerk;
    local XComPerkManager kPerkMan;
    local string strPerkName;

    kPerkMan = XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().GetBarracks().m_kPerkManager;
	PC = XComPlayerController(Outer.GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		if((strName != "") && strName != "NONE")
		{
			if(int(strName) > 0)
			{
				iIndex = int(strName);
				kPerk = kPerkMan.GetPerk(iIndex);
				if(kPerk.iPerk != 0)
				{
					bFound = true;
					strPerkName = kPerkMan.GetPerkName(iIndex);
				}
			}
			else
			{
				for(iIndex = 0; iIndex < 172; iIndex++)
				{
					strPerkName = kPerkMan.GetPerkName(iIndex);
					if((strPerkName != "NONE") && strPerkName ~= strName)
					{
						bFound = true;
						break;
					}
				}
			}
			if(bFound)
			{
				if(kSoldierUI.m_kSoldier.m_kChar.aUpgrades[iIndex] % 2 == 1)
				{
					kSoldierUI.m_kSoldier.m_kChar.aUpgrades[iIndex] -= 1;
				}
			}
		}
	}
}

exec function ShowSoldierOnScreen()
{
	local XGSoldierUI kSoldierUI;

	kSoldierUI = XGSoldierUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true));

	`Log(`ShowVar(kSoldierUI));
	`Log(`ShowVar(kSoldierUI.m_kSoldier));

}

exec function blankextradata()
{
	local int I;

	for(I = 0; I < RP().m_kRPCheckpoint.arrSoldierStorage.Length; I++)
	{
		if(I >= 2 && I <= 50)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 54 && I <= 65)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 67 && I <= 130)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 132 && I <= 141)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 144 && I <= 188)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 190 && I <= 214)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 216 && I <= 260)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 264 && I <= 283)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
		if(I >= 287 && I <= 338)
		{
			RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID = -1;
		}
	}

}

exec function removeblankdata()
{
	local int I;
	local array<TSoldierStorage> TStor;

	for(I = 0; I < RP().m_kRPCheckpoint.arrSoldierStorage.Length; I++)
	{
		if(RP().m_kRPCheckpoint.arrSoldierStorage[I].SoldierID != -1)
		{
			TStor.AddItem(RP().m_kRPCheckpoint.arrSoldierStorage[I]);
		}
	}
	RP().m_kRPCheckpoint.arrSoldierStorage = TStor;
}


`ifdebug

exec function AddActorToDestroy()
{
	local int I;

	for(I=0;I<74;I++)
		`log(I);
		class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToDestroy.AddItem(class'RPCheckpoint');
	//RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint
}

exec function DestoryRecActor()
{
	class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToDestroy.AddItem(class'RPCheckpointRec');
}

exec function RemoveActorFromRecord()
{
	//class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToRecord.RemoveItem(class'RPCheckpoint');
	class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToRecord.RemoveItem(class'RPCheckpointRec');
}

exec function AddActorToRecord()
{
	class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToRecord.AddItem(class'RPCheckpoint');
}

exec function CopyDataRecords()
{
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpointRec.arrSoldierStorage =
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint.arrSoldierStorage;

	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpointRec.arrAlienStorage =
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint.arrAlienStorage;
}

exec function CopyDataRecordsBack()
{
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint.arrSoldierStorage =
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpointRec.arrSoldierStorage;

	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint.arrAlienStorage =
	RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpointRec.arrAlienStorage;
}

`endif

DefaultProperties
{
}
