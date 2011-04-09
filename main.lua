-- disable "leave queue" button & add expiration timer

local expires = "Expires in %.1f"

local frame = CreateFrame("Frame", "SecureQueue", UIParent)
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

function frame:OnUpdate(delay)
    self.timer = self.timer - delay
    self.button:SetText(expires:format(self.timer))

    if self.timer < 0 then
        self.timer = nil
        self.button = nil
        self:SetScript("OnUpdate", nil)
    end
end

frame:SetScript("OnEvent", function(self)
    for i = 1, MAX_BATTLEFIELD_QUEUES do
        local status, _, _, _, _, _, registeredMatch = GetBattlefieldStatus(i)
        if registeredMatch == 1 then
            if status == "confirm" then
                local btn

                if StaticPopup1Button2:GetText() == LEAVE_QUEUE and StaticPopup1Button2:IsEnabled() then
                    StaticPopup1Button2:Disable()
                    btn = StaticPopup1Button2
                end

                if StaticPopup2Button2:GetText() == LEAVE_QUEUE and StaticPopup2Button2:IsEnabled() then 
                    StaticPopup2Button2:Disable()
                    btn = StaticPopup2Button2
                end

                if btn and not self.timer then
                    self.timer = 30
                    self.button = btn
                    self:SetScript("OnUpdate", self.OnUpdate)
                end
            end
            break
        end
    end
end)

-- leave queue when the button is clicked (skip the dropdown)

MiniMapBattlefieldFrame:HookScript("OnClick", function(self, btn)
    if btn == "RightButton" then
        for i = 1, MAX_BATTLEFIELD_QUEUES do
            local status, _, _, _, _, _, registeredMatch = GetBattlefieldStatus(i)
            if registeredMatch == 1 then
                if status == "queued" then
                    DropDownList1:Hide()
                    AcceptBattlefieldPort(i, 0)
                end
                break
            end
        end
    end
end)
