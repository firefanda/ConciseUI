-- ===========================================================================
-- Cui Remind Panel
-- eudaimonia, 11/11/2019
-- ===========================================================================
include("InstanceManager")
include("cui_settings")
include("cui_tech_civic_support")

-- ---------------------------------------------------------------------------

local isAttached = false
local isAnyRemind = false

-- ---------------------------------------------------------------------------
function RefreshTech(localPlayer, eTech)
  if not CuiSettings:GetBoolean(CuiSettings.REMIND_TECH) then
    Controls.TechReady:SetHide(true)
    return
  end

  local isReady = CuiIsTechReady(localPlayer)
  Controls.TechReady:SetHide(not isReady)
  if isReady then isAnyRemind = true end
end

-- ---------------------------------------------------------------------------
function RefreshCivic(localPlayer, eCivic)
  if not CuiSettings:GetBoolean(CuiSettings.REMIND_CIVIC) then
    Controls.CivicReady:SetHide(true)
    return
  end

  local isReady = CuiIsCivicReady(localPlayer)
  Controls.CivicReady:SetHide(not isReady)
  if isReady then isAnyRemind = true end
end

-- ---------------------------------------------------------------------------
function RefreshGovernment(localPlayer)
  if not CuiSettings:GetBoolean(CuiSettings.REMIND_GOVERNMENT) then
    Controls.GovernmentReady:SetHide(true)
    return
  end

  local isReady = CuiIsGovernmentReady(localPlayer)
  Controls.GovernmentReady:SetHide(not isReady)
  if isReady then isAnyRemind = true end
end

-- ---------------------------------------------------------------------------
function RefreshGovernor(localPlayer)
  if not CuiSettings:GetBoolean(CuiSettings.REMIND_GOVERNOR) then
    Controls.GovernorReady:SetHide(true)
    return
  end

  local isReady = CuiIsGovernorReady(localPlayer)
  Controls.GovernorReady:SetHide(not isReady)
  if isReady then isAnyRemind = true end
end

-- ---------------------------------------------------------------------------
function RefreshAll()
  local localPlayer = Game.GetLocalPlayer()
  if localPlayer ~= -1 then
    isAnyRemind = false
    RefreshTech(localPlayer)
    RefreshCivic(localPlayer)
    RefreshGovernment(localPlayer)
    RefreshGovernor(localPlayer)
  end

  Controls.RemindStack:CalculateSize()
  Controls.Bubble:SetHide(not isAnyRemind)
  if isAnyRemind then
    local stackX = Controls.RemindStack:GetSizeX()
    local stackY = Controls.RemindStack:GetSizeY()
    Controls.Bubble:SetSizeX(stackX + 60)
    Controls.Bubble:SetSizeY(stackY + 98)
  end
end

-- ---------------------------------------------------------------------------
function OnMinimapResize()
  if isAttached then
    local minimap = ContextPtr:LookUpControl("/InGame/MinimapPanel/MiniMap/MinimapContainer")
    Controls.RemindContainer:SetOffsetX(minimap:GetSizeX() + 30)
  end
end

-- ---------------------------------------------------------------------------
function AttachToMinimap()
  if not isAttached then
    local minimap = ContextPtr:LookUpControl("/InGame/MinimapPanel/MiniMap/MinimapContainer")
    Controls.RemindContainer:ChangeParent(minimap)
    Controls.RemindContainer:SetOffsetX(minimap:GetSizeX() + 30)
    isAttached = true
  end

  RefreshAll()
end

-- ---------------------------------------------------------------------------
function Initialize()
  ContextPtr:SetHide(true)
  --
  Events.LoadGameViewStateDone.Add(AttachToMinimap)
  --
  Events.ResearchChanged.Add(RefreshAll)
  Events.ResearchCompleted.Add(RefreshAll)
  --
  Events.CivicChanged.Add(RefreshAll)
  Events.CivicCompleted.Add(RefreshAll)
  --
  Events.GovernmentChanged.Add(RefreshAll)
  Events.GovernmentPolicyChanged.Add(RefreshAll)
  Events.GovernmentPolicyObsoleted.Add(RefreshAll)
  --
  Events.GovernorAppointed.Add(RefreshAll)
  Events.GovernorAssigned.Add(RefreshAll)
  Events.GovernorPromoted.Add(RefreshAll)
  --
  Events.LocalPlayerTurnBegin.Add(RefreshAll)
  --
  LuaEvents.CuiRemindSettingChange.Add(RefreshAll)
  --
  LuaEvents.CuiOnMinimapResize.Add(OnMinimapResize)
end
Initialize()
