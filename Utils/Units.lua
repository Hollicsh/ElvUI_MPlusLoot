-- ElvUI M+ Loot unit helpers.
-- Loaded before ElvUI_MPlusLoot.lua; contains only group/unit name lookup helpers.

local addon = _G.ElvUIMPlusLoot or {}
_G.ElvUIMPlusLoot = addon

addon.Utils = addon.Utils or {}

local TrimText = addon.Utils.TrimText
local NormalizeName = addon.Utils.NormalizeName

local function GetUnitFullName(unit)
    if not unit or not UnitExists(unit) then return nil end

    local name, realm
    if UnitFullName then
        name, realm = UnitFullName(unit)
    else
        name, realm = UnitName(unit)
    end

    name = TrimText(name)
    if not name then return nil end

    realm = TrimText(realm)
    if realm then
        return string.format("%s-%s", name, realm:gsub("%s+", ""))
    end

    return name
end

local function ForEachKnownGroupUnit(callback)
    if type(callback) ~= "function" then return end

    if callback("player") then return true end

    if IsInRaid and IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            if callback("raid" .. i) then return true end
        end
    elseif IsInGroup and IsInGroup() then
        for i = 1, GetNumSubgroupMembers() do
            if callback("party" .. i) then return true end
        end
    end
end

local function FindGroupUnitByName(playerName)
    local wanted = NormalizeName(playerName)
    if not wanted then return nil, nil end

    local foundUnit, foundFullName

    ForEachKnownGroupUnit(function(unit)
        local fullName = GetUnitFullName(unit)
        if fullName and NormalizeName(fullName) == wanted then
            foundUnit = unit
            foundFullName = fullName
            return true
        end
    end)

    return foundUnit, foundFullName
end

addon.Utils.GetUnitFullName = GetUnitFullName
addon.Utils.ForEachKnownGroupUnit = ForEachKnownGroupUnit
addon.Utils.FindGroupUnitByName = FindGroupUnitByName
