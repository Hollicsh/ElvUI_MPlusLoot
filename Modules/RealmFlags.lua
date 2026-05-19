-- Read-only realm flag lookup prototype for ElvUI M+ Loot.

local E = ElvUI and unpack(ElvUI)
local MPL = E and E:GetModule("ElvUI_MythicPlusLoot", true)

if not MPL then return end

local addon = _G.ElvUIMPlusLoot or {}
local Utils = addon.Utils or {}
local TrimText = Utils.TrimText
local StripChatMarkup = Utils.StripChatMarkup
local FindGroupUnitByName = Utils.FindGroupUnitByName

local FLAG_LABELS = {
    de = "German",
    en = "English",
    es = "Spanish",
    fr = "French",
    it = "Italian",
}

local REALM_FLAGS = {
    aegwynn = "de",
    antonidas = "de",
    blackhand = "de",
    blackmoore = "de",
    eredar = "de",

    archimonde = "fr",
    hyjal = "fr",

    dunmodr = "es",
    sanguino = "es",

    pozzodelleternita = "it",
    ["pozzodelleternità"] = "it",

    draenor = "en",
    kazzak = "en",
    ragnaros = "en",
    ravencrest = "en",
    tarrenmill = "en",
    twistingnether = "en",
}

local function NormalizeRealmName(realm)
    realm = TrimText and TrimText(realm) or realm
    if type(realm) ~= "string" or realm == "" then return nil end

    realm = realm:lower()
    realm = realm:gsub("[%s%-%']", "")

    return realm ~= "" and realm or nil
end

local function ExtractRealmFromFullName(playerName)
    playerName = StripChatMarkup and StripChatMarkup(playerName) or playerName
    if type(playerName) ~= "string" then return nil end

    return playerName:match("^.-%-(.+)$")
end

local function GetRealmFromGroupUnit(playerName)
    if type(FindGroupUnitByName) ~= "function" then return nil end

    local unit = FindGroupUnitByName(playerName)
    if not unit then return nil end

    local _, realm
    if UnitFullName then
        _, realm = UnitFullName(unit)
    else
        _, realm = UnitName(unit)
    end

    return realm or (GetRealmName and GetRealmName())
end

local function GetRealmFromPlayerName(playerName)
    return ExtractRealmFromFullName(playerName) or GetRealmFromGroupUnit(playerName)
end

function MPL:GetRealmFlagInfo(playerName)
    local realm = GetRealmFromPlayerName(playerName)
    local normalizedRealm = NormalizeRealmName(realm)
    local code = normalizedRealm and REALM_FLAGS[normalizedRealm]
    if not code then return nil end

    return {
        code = code,
        label = FLAG_LABELS[code],
        known = true,
    }
end
