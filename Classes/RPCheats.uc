class RPCheats extends Mod_StrategyCheatManager;

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

	kSoldierUI.m_kSoldier.AssignRandomPerks();
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

exec function RerollStats()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	kSoldierUI.m_kSoldier.m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
	kSoldierUI.m_kSoldier.m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
	kSoldierUI.m_kSoldier.m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
	kSoldierUI.m_kSoldier.m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
	kSoldierUI.m_kSoldier.m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBarracks.RandomizeStats(kSoldierUI.m_kSoldier);

	kSoldierUI.m_kSoldier.onLoadoutChange();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierSummary.SetSoldier(kSoldierUI.m_kSoldier);
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.GetMgr().UpdateView();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.UpdateAbilityData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierHeader.UpdateData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierStats.UpdateData();
}

exec function ResetAndReroll()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;
	local RoulettePlusMod RP;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	kSoldierUI.m_kSoldier.ClearPerks();
	RerollRandomTree();
	RerollStats();
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
				kSoldierUI.m_kSoldier.m_kChar.aUpgrades[iIndex] = 0;
			}
		}
	}
}

`ifdebug

exec function AddActorToDestroy()
{
	local int I;

	//for(I=0;I<742;I++)
		class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToDestroy.AddItem(class'RPCheckpoint');
	//RoulettePlusMod(ModBridge(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).Mods[0]).Mods("RoulettePlus.RoulettePlusMod")).m_kRPCheckpoint
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
