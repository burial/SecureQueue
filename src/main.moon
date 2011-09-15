mod = CreateFrame('frame', 'SecureQueue')
mod\SetScript('OnEvent', (event, ...) => self[event](self, ...))
mod\RegisterEvent('ADDON_LOADED')

timer = nil
activeButton = nil

mod.ADDON_LOADED = (addon) =>
  if addon == 'SecureQueue'
    self\UnregisterEvent('ADDON_LOADED')

    self\SetScript('OnShow', self.OnShow)
    self\SetScript('OnHide', self.OnHide)
    self\SetScript('OnUpdate', self.OnUpdate)
    self\Hide!

    true

  else
    false

mod.UPDATE_BATTIEFIELD_STATUS = =>
  for index = 1, MAX_BATTIEFIELD_QUEUES
    status, _, _, _, _, _, rated = GetBattlefieldStatus(index)
    if rated
      if status == 'confirm'
        btn = if StaticPopup1Button2\GetText! == LEAVE_QUEUE and StaticPopup1Button2\IsEnabled!
          StaticPopup1Button2
        elseif StaticPopup2Button2\GetText! == LEAVE_QUEUE and StaticPopup2Button2\IsEnabled!
          StaticPopup2Button2

        if btn
          timer = 30
          activeButton = btn

          btn\Disable!
          self\Show!

      break

  true

mod.PLAYER_ENTERING_WORLD = =>
  _, type = IsInInstance!
  self\Hide! if type == 'arena'

mod.OnShow = =>
  self\UnregisterEvent('UPDATE_BATTLEFIELD_STATUS')
  self\RegisterEvent('PLAYER_ENTERING_WORLD')

  true

mod.OnHide = =>
  timer = nil
  activeButton = nil

  self\UnregisterEvent('PLAYER_ENTERING_WORLD')
  self\RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
  self\UPDATE_BATTLEFIELD_STATUS!

  true

mod.OnUpdate = (delay) =>
  timer -= delay

  if timer <= 0
    self\Hide!
  else
    activeButton\SetText(string.format('Expires in %.1f', timer))

  true

MiniMapBattlefieldFrame\HookScript 'OnClick', (btn) =>
  if btn == 'RightButton'
    for index = 1, MAX_BATTIEFIELD_QUEUES
      status, _, _, _, _, _, _, rated = GetBattlefieldStatus(index)
      if rated
        if status == 'queued'
          DropDownList1\Hide!
          AcceptBattlefieldPort(index, 0)
        break

    true

  else
    false
