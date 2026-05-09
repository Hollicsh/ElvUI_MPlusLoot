-- Optional KeystoneLoot integration helpers.
-- This file only reads KeystoneLoot's SavedVariables defensively.

local addon = _G.ElvUIMPlusLoot or {}
local T = addon.T

local E = ElvUI and unpack(ElvUI)
local MPL = E and E:GetModule("ElvUI_MythicPlusLoot", true)

if not MPL then return end

local KEYSTONELOOT_TIER_LABEL_KEYS = {
    [1] = "keystoneLootTierNice",
    [2] = "keystoneLootTierMust",
    [3] = "keystoneLootTierBiS",
}

local function GetItemIDFromLink(itemLink)
    if type(itemLink) == "number" then
        return itemLink
    end

    if type(itemLink) ~= "string" then
        return nil
    end

    return tonumber(itemLink:match("item:(%d+)"))
end

local function GetCurrentKeystoneLootCharacterKey()
    local name = UnitName("player")
    local realm = GetRealmName()
    local _, _, classId = UnitClass("player")

    if not name or name == "" or not realm or realm == "" or not classId then
        return nil
    end

    return string.format("%s-%s-%d", realm, name, classId)
end

function MPL:GetKeystoneLootFavoriteTier(itemLink)
    if type(KeystoneLootDB) ~= "table" or type(KeystoneLootDB.favorites) ~= "table" then
        return nil
    end

    local itemId = GetItemIDFromLink(itemLink)
    if not itemId then
        return nil
    end

    local characterKey = GetCurrentKeystoneLootCharacterKey()
    local characterFavorites = characterKey and KeystoneLootDB.favorites[characterKey]
    if type(characterFavorites) ~= "table" then
        return nil
    end

    for _, sourceData in pairs(characterFavorites) do
        if type(sourceData) == "table" then
            for _, specData in pairs(sourceData) do
                if type(specData) == "table" then
                    local favoriteInfo = specData[itemId] or specData[tostring(itemId)]
                    if type(favoriteInfo) == "table" then
                        return tonumber(favoriteInfo.tier) or 2
                    elseif favoriteInfo ~= nil then
                        return 2
                    end
                end
            end
        end
    end

    return nil
end

function MPL:IsKeystoneLootFavorite(itemLink)
    return self:GetKeystoneLootFavoriteTier(itemLink) ~= nil
end

function MPL:GetKeystoneLootTierLabel(tier)
    local labelKey = KEYSTONELOOT_TIER_LABEL_KEYS[tonumber(tier)]
    if not labelKey then
        return nil
    end

    return T and T(labelKey) or labelKey
end
