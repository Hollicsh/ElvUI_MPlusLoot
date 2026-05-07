-- ElvUI M+ Loot text helpers.
-- Loaded before ElvUI_MPlusLoot.lua; contains only pure text normalization helpers.

local addon = _G.ElvUIMPlusLoot or {}
_G.ElvUIMPlusLoot = addon

addon.Utils = addon.Utils or {}

local function TrimText(value)
    if type(value) ~= "string" then return nil end

    value = value:gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then return nil end

    return value
end

local function StripChatMarkup(value)
    if type(value) ~= "string" then return nil end

    local playerFromLink = value:match("|Hplayer:[^|]+|h%[([^%]]+)%]|h")
    value = playerFromLink or value
    value = value:gsub("|c%x%x%x%x%x%x%x%x", "")
    value = value:gsub("|r", "")
    value = value:gsub("^%[", ""):gsub("%]$", "")

    return TrimText(value)
end

local function NormalizeName(name)
    local cleanName = StripChatMarkup(name)
    if not cleanName then return nil end

    if Ambiguate then
        return Ambiguate(cleanName, "short")
    end

    return cleanName:match("^([^-]+)") or cleanName
end

addon.Utils.TrimText = TrimText
addon.Utils.StripChatMarkup = StripChatMarkup
addon.Utils.NormalizeName = NormalizeName
