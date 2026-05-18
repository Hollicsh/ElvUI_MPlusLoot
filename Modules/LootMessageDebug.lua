-- Read-only CHAT_MSG_LOOT diagnostics for ElvUI M+ Loot.

local E = ElvUI and unpack(ElvUI)
local MPL = E and E:GetModule("ElvUI_MythicPlusLoot", true)

if not MPL then return end

local function ExtractItemID(itemLink)
    if type(itemLink) ~= "string" then return nil end

    return tonumber(itemLink:match("item:(%d+)"))
end

local function HasPlayerLink(text)
    return type(text) == "string" and text:find("|Hplayer:", 1, true) ~= nil
end

local function HasItemLink(text)
    return type(text) == "string" and text:find("|Hitem:", 1, true) ~= nil
end

local function ClassifyLootMessage(text)
    if type(text) ~= "string" then
        return "unknown", false, false, "none"
    end

    local lowerText = text:lower()
    local bonus = lowerText:find("bonusbeute", 1, true) ~= nil
        or lowerText:find("bonus loot", 1, true) ~= nil
    local own = text:find("^Ihr%s") ~= nil
        or text:find("^Du%s") ~= nil
        or text:find("^You%s") ~= nil

    if bonus then
        local pattern = lowerText:find("bonusbeute", 1, true) and "de-bonus-loot" or "en-bonus-loot"
        return "bonus-loot", own, true, pattern
    end

    if own then
        local pattern = lowerText:find("you%s") == 1 and "en-own-loot" or "de-own-loot"
        return "own-loot", true, false, pattern
    end

    if lowerText:find(" bekommt beute", 1, true)
        or lowerText:find(" erhält beute", 1, true)
        or lowerText:find(" erhaelt beute", 1, true)
        or lowerText:find(" receives loot", 1, true) then
        local pattern = lowerText:find(" receives loot", 1, true) and "en-group-loot" or "de-group-loot"
        return "group-loot", false, false, pattern
    end

    return "unknown", false, false, "none"
end

function MPL:GetLootMessageDebugInfo(text, itemLink, eligible, seq)
    local kind, own, bonus, pattern = ClassifyLootMessage(text)

    return {
        seq = seq,
        itemID = ExtractItemID(itemLink),
        hasItemLink = HasItemLink(text),
        hasPlayerLink = HasPlayerLink(text),
        kind = kind,
        own = own,
        bonus = bonus,
        pattern = pattern,
        eligible = not not eligible,
    }
end

function MPL:PrintLootMessageDebugInfo(info)
    if type(info) ~= "table" then return end

    print(string.format(
        "|cff1784d1ElvUI M+ Loot:|r [M+ Loot Chat] seq=%s itemID=%s kind=%s own=%s bonus=%s hasItemLink=%s hasPlayerLink=%s pattern=%s eligible=%s",
        tostring(info.seq),
        tostring(info.itemID),
        tostring(info.kind or "unknown"),
        tostring(not not info.own),
        tostring(not not info.bonus),
        tostring(not not info.hasItemLink),
        tostring(not not info.hasPlayerLink),
        tostring(info.pattern or "none"),
        tostring(not not info.eligible)
    ))
end

function MPL:PrintLootEntryDebugInfo(seq, itemLink)
    print(string.format(
        "|cff1784d1ElvUI M+ Loot:|r [M+ Loot Entry] seq=%s itemID=%s inserted=true source=chat",
        tostring(seq),
        tostring(ExtractItemID(itemLink))
    ))
end
