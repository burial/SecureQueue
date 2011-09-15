local mod = CreateFrame('frame', 'SecureQueue')
mod:SetScript('OnEvent', function(self, event, ...)
  return self[event](self, ...)
end)
mod:RegisterEvent('ADDON_LOADED')
local timer = nil
local activeButton = nil
mod.ADDON_LOADED = function(self, addon)
  if addon == 'SecureQueue' then
    self:UnregisterEvent('ADDON_LOADED')
    self:SetScript('OnShow', self.OnShow)
    self:SetScript('OnHide', self.OnHide)
    self:SetScript('OnUpdate', self.OnUpdate)
    self:Hide()
    return true
  else
    return false
  end
end
mod.UPDATE_BATTIEFIELD_STATUS = function(self)
  for index = 1, MAX_BATTIEFIELD_QUEUES do
    local status, _, _, _, _, _, rated = GetBattlefieldStatus(index)
    if rated then
      if status == 'confirm' then
        local btn
        if StaticPopup1Button2:GetText() == LEAVE_QUEUE and StaticPopup1Button2:IsEnabled() then
          btn = StaticPopup1Button2
        elseif StaticPopup2Button2:GetText() == LEAVE_QUEUE and StaticPopup2Button2:IsEnabled() then
          btn = StaticPopup2Button2
        end
        if btn then
          timer = 30
          activeButton = btn
          btn:Disable()
          self:Show()
        end
      end
      break
    end
  end
  return true
end
mod.PLAYER_ENTERING_WORLD = function(self)
  local _, type = IsInInstance()
  if type == 'arena' then
    return self:Hide()
  end
end
mod.OnShow = function(self)
  self:UnregisterEvent('UPDATE_BATTLEFIELD_STATUS')
  self:RegisterEvent('PLAYER_ENTERING_WORLD')
  return true
end
mod.OnHide = function(self)
  timer = nil
  activeButton = nil
  self:UnregisterEvent('PLAYER_ENTERING_WORLD')
  self:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
  self:UPDATE_BATTLEFIELD_STATUS()
  return true
end
mod.OnUpdate = function(self, delay)
  timer = timer - delay
  if timer <= 0 then
    self:Hide()
  else
    activeButton:SetText(string.format('Expires in %.1f', timer))
  end
  return true
end
MiniMapBattlefieldFrame:HookScript('OnClick', function(self, btn)
  if btn == 'RightButton' then
    for index = 1, MAX_BATTIEFIELD_QUEUES do
      local status, _, _, _, _, _, _, rated = GetBattlefieldStatus(index)
      if rated then
        if status == 'queued' then
          DropDownList1:Hide()
          AcceptBattlefieldPort(index, 0)
        end
        break
      end
    end
    return true
  else
    return false
  end
end)
