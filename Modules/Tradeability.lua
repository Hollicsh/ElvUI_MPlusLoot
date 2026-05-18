-- Tradeability detection for ElvUI M+ Loot.

local E = ElvUI and unpack(ElvUI)
local MPL = E and E:GetModule("ElvUI_MythicPlusLoot", true)

if not MPL then return end

local TRADEABILITY_CACHE = {}

local function GetTooltipLineText(line)
    if type(line) ~= "table" then return nil end

    return line.leftText
        or line.text
        or line.left
        or line.name
        or (line.args and line.args[1] and line.args[1].stringVal)
end

local function IsTooltipLineType(line, enumName)
    if type(line) ~= "table" then return false end

    local enumValue = Enum and Enum.TooltipDataLineType and Enum.TooltipDataLineType[enumName]
    return enumValue ~= nil and line.type == enumValue
end

local function GetItemBindType(itemLink)
    if not itemLink then return nil end

    if C_Item and C_Item.GetItemInfo then
        local results = { pcall(C_Item.GetItemInfo, itemLink) }
        if results[1] and results[15] ~= nil then
            return tonumber(results[15])
        end
    end

    if GetItemInfo then
        local results = { pcall(GetItemInfo, itemLink) }
        if results[1] and results[15] ~= nil then
            return tonumber(results[15])
        end
    end

    return nil
end

function MPL:GetItemTradeabilityInfo(itemLink, entry)
    if not itemLink then return "unknown", "unknown:no-item-link" end
    if entry and entry.isBonusLoot == true then
        return "notTradeable", "loot-message:bonus-loot"
    end

    local cached = TRADEABILITY_CACHE[itemLink]
    if cached then return cached.state, cached.reason end

    local state = "unknown"
    local reason = "unknown:no-clear-tooltip-signal"
    local hasBindingLine = false
    local bindingReason

    if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
        local ok, data = pcall(C_TooltipInfo.GetHyperlink, itemLink)
        if ok and type(data) == "table" and type(data.lines) == "table" then
            for _, line in ipairs(data.lines) do
                local text = GetTooltipLineText(line)
                local lowerText = type(text) == "string" and string.lower(text) or nil

                if IsTooltipLineType(line, "ItemBinding") then
                    hasBindingLine = true
                end

                if lowerText and (lowerText:find("soulbound", 1, true)
                    or lowerText:find("seelengebunden", 1, true)
                    or lowerText:find("not tradeable", 1, true)
                    or lowerText:find("not tradable", 1, true)
                    or lowerText:find("nicht handelbar", 1, true)
                    or lowerText:find("non%-tradeable")) then
                    if lowerText:find("soulbound", 1, true) or lowerText:find("seelengebunden", 1, true) then
                        bindingReason = "tooltip:item-binding+soulbound"
                    else
                        bindingReason = "tooltip:item-binding+not-tradeable"
                    end
                end

                if IsTooltipLineType(line, "TradeTimeRemaining")
                    or (lowerText and (lowerText:find("trade time remaining", 1, true)
                        or lowerText:find("remaining trade time", 1, true)
                        or lowerText:find("handelszeit", 1, true))) then
                    state = "tradeable"
                    reason = "tooltip:trade-time-remaining"
                    break
                end
            end
        else
            reason = "unknown:no-tooltip-info"
        end
    else
        reason = "unknown:no-tooltip-info"
    end

    if state == "unknown" and hasBindingLine and bindingReason then
        state = "notTradeable"
        reason = bindingReason
    end

    local bindType = GetItemBindType(itemLink)
    local bindNone = Enum and Enum.ItemBind and Enum.ItemBind.None or 0
    if state == "unknown" and bindType == bindNone then
        state = "tradeable"
        reason = "item-info:bind-type-none"
    end

    TRADEABILITY_CACHE[itemLink] = {
        state = state,
        reason = reason,
    }
    return state, reason
end
