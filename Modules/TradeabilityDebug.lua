-- Read-only tradeability diagnostics for ElvUI M+ Loot.

local E = ElvUI and unpack(ElvUI)
local MPL = E and E:GetModule("ElvUI_MythicPlusLoot", true)

if not MPL then return end

local MAX_TOOLTIP_LINES = 20
local MAX_TOOLTIP_TEXT_LENGTH = 120

local function GetTooltipLineText(line)
    if type(line) ~= "table" then return nil end

    return line.leftText
        or line.text
        or line.left
        or line.name
        or (line.args and line.args[1] and line.args[1].stringVal)
end

local function GetTooltipLineTypeName(line)
    if type(line) ~= "table" then return "-" end

    local lineType = line.type
    if Enum and Enum.TooltipDataLineType then
        for name, value in pairs(Enum.TooltipDataLineType) do
            if value == lineType then
                return name
            end
        end
    end

    return tostring(lineType or "-")
end

local function TruncateText(text)
    text = tostring(text or "")
    text = text:gsub("|Hplayer:[^|]+|h%[[^%]]+%]|h", "[player]")
    text = text:gsub("|HBNplayer:[^|]+|h%[[^%]]+%]|h", "[player]")
    if #text <= MAX_TOOLTIP_TEXT_LENGTH then
        return text
    end

    return text:sub(1, MAX_TOOLTIP_TEXT_LENGTH) .. "..."
end

local function IsRelevantLine(line)
    local lineTypeName = GetTooltipLineTypeName(line)
    if lineTypeName == "ItemBinding" or lineTypeName == "TradeTimeRemaining" then
        return true
    end

    local text = GetTooltipLineText(line)
    local lowerText = type(text) == "string" and text:lower() or ""
    return lowerText:find("trade", 1, true)
        or lowerText:find("handel", 1, true)
        or lowerText:find("gebunden", 1, true)
        or lowerText:find("bound", 1, true)
        or lowerText:find("soulbound", 1, true)
        or lowerText:find("seelengebunden", 1, true)
        or lowerText:find("nicht handelbar", 1, true)
        or lowerText:find("not tradeable", 1, true)
end

function MPL:GetItemTradeabilityDebugLines(itemLink, mode)
    if not itemLink or not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then
        return nil
    end

    local ok, data = pcall(C_TooltipInfo.GetHyperlink, itemLink)
    if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
        return nil
    end

    local result = {}
    local lineLimit = mode == "dump" and math.min(#data.lines, MAX_TOOLTIP_LINES) or #data.lines

    for lineIndex = 1, lineLimit do
        local line = data.lines[lineIndex]
        if mode == "dump" or IsRelevantLine(line) then
            table.insert(result, {
                index = lineIndex,
                lineType = GetTooltipLineTypeName(line),
                text = TruncateText(GetTooltipLineText(line)),
            })
        end
    end

    return result, #data.lines
end
