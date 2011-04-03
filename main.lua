-- disable "leave queue" button

local frame = CreateFrame("Frame", nil, UIParent)
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

frame:SetScript("OnEvent", function()
    for i=1, MAX_BATTLEFIELD_QUEUES do
        local status, _, _, _, _, _, registeredMatch = GetBattlefieldStatus(i)
        if registeredMatch == 1 then
            if status == "confirm" then
                if StaticPopup1Button2:GetText() == "Leave Queue" and StaticPopup1Button2:IsEnabled() then
                    StaticPopup1Button2:Disable()
                end
                if StaticPopup2Button2:GetText() == "Leave Queue" and StaticPopup2Button2:IsEnabled() then 
                    StaticPopup2Button2:Disable()
                end    
            end
            break
        end
    end
end)

if AddonLoader then
    frame:GetScript("OnEvent")()
end

-- leave queue when the button is clicked

MiniMapBattlefieldFrame:HookScript("OnClick", function(self, btn)
    if btn == "RightButton" then
        for i=1, MAX_BATTLEFIELD_QUEUES do
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
