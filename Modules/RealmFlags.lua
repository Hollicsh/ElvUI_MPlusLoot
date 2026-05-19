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
    pt = "Portuguese",
    ru = "Russian",
}

local REALM_GROUPS = {
    de = {
        "Aegwynn", "Alexstrasza", "Alleria", "Aman'thul", "Ambossar", "Anetheron", "Antonidas", "Anub'arak",
        "Area 52", "Arthas", "Arygos", "Azshara", "Baelgun", "Blackhand", "Blackmoore", "Blackrock",
        "Blutkessel", "Dalvengyr", "Das Konsortium", "Das Syndikat", "Der Abyssische Rat", "Der Mithrilorden",
        "Der Rat von Dalaran", "Destromath", "Dethecus", "Die Aldor", "Die Arguswacht", "Die Nachtwache",
        "Die Silberne Hand", "Die Todeskrallen", "Die ewige Wacht", "Dun Morogh", "Durotan", "Echsenkessel",
        "Eredar", "Festung der Stürme", "Forscherliga", "Frostmourne", "Frostwolf", "Garrosh", "Gilneas",
        "Gorgonnash", "Gul'dan", "Kargath", "Kel'Thuzad", "Khaz'goroth", "Kil'jaeden", "Krag'jin",
        "Kult der Verdammten", "Lordaeron", "Lothar", "Madmortem", "Mal'Ganis", "Malfurion", "Malorne",
        "Malygos", "Mannoroth", "Mug'thol", "Nathrezim", "Nazjatar", "Nefarian", "Nera'thor", "Nethersturm",
        "Norgannon", "Nozdormu", "Onyxia", "Perenolde", "Proudmoore", "Rajaxx", "Rexxar", "Sen'jin",
        "Shattrath", "Taerar", "Teldrassil", "Terrordar", "Theradras", "Thrall", "Tichondrius", "Tirion",
        "Todeswache", "Ulduar", "Un'Goro", "Vek'lor", "Wrathbringer", "Ysera", "Zirkel des Cenarius", "Zuluhed",
    },
    en = {
        "Aerie Peak", "Agamaggan", "Aggramar", "Ahn'Qiraj", "Al'Akir", "Alonsus", "Anachronos", "Arathor",
        "Argent Dawn", "Aszune", "Auchindoun", "Azjol-Nerub", "Azuremyst", "Balnazzar", "Blade's Edge",
        "Bladefist", "Bloodfeather", "Bloodhoof", "Bloodscalp", "Boulderfist", "Bronze Dragonflight",
        "Bronzebeard", "Burning Blade", "Burning Legion", "Burning Steppes", "Chamber of Aspects", "Chromaggus",
        "Crushridge", "Daggerspine", "Darkmoon Faire", "Darksorrow", "Darkspear", "Deathwing", "Defias Brotherhood",
        "Dentarg", "Doomhammer", "Draenor", "Dragonblight", "Dragonmaw", "Drak'thul", "Dunemaul", "Earthen Ring",
        "Emerald Dream", "Emeriss", "Eonar", "Executus", "Frostmane", "Frostwhisper", "Genjuros", "Ghostlands",
        "Grim Batol", "Hakkar", "Haomarush", "Hellfire", "Hellscream", "Jaedenar", "Karazhan", "Kazzak", "Khadgar",
        "Kilrogg", "Kor'gall", "Kul Tiras", "Laughing Skull", "Lightbringer", "Lightning's Blade", "Magtheridon",
        "Mazrigos", "Moonglade", "Nagrand", "Neptulon", "Nordrassil", "Outland", "Quel'Thalas", "Ragnaros",
        "Ravencrest", "Ravenholdt", "Runetotem", "Saurfang", "Scarshield Legion", "Shadowsong", "Shattered Halls",
        "Shattered Hand", "Silvermoon", "Skullcrusher", "Spinebreaker", "Sporeggar", "Steamwheedle Cartel",
        "Stormrage", "Stormreaver", "Stormscale", "Sunstrider", "Sylvanas", "Talnivarr", "Tarren Mill", "Terenas",
        "Terokkar", "The Maelstrom", "The Sha'tar", "The Venture Co", "Thunderhorn", "Trollbane", "Turalyon",
        "Twilight's Hammer", "Twisting Nether", "Vashj", "Vek'nilash", "Wildhammer", "Xavius", "Zenedar",
    },
    es = {
        "C'Thun", "Colinas Pardas", "Dun Modr", "Exodar", "Los Errantes", "Minahonda", "Sanguino", "Shen'dralar",
        "Tyrande", "Uldum", "Zul'jin",
    },
    fr = {
        "Arak-arahm", "Arathi", "Archimonde", "Chants éternels", "Cho'gall", "Confrérie du Thorium",
        "Conseil des Ombres", "Culte de la Rive noire", "Dalaran", "Drek'Thar", "Eldre'Thalas", "Elune", "Etrigg",
        "Garona", "Hyjal", "Illidan", "Kael'thas", "Khaz Modan", "Kirin Tor", "Krasus", "La Croisade écarlate",
        "Les Clairvoyants", "Les Sentinelles", "Marécage de Zangar", "Medivh", "Naxxramas", "Ner'zhul",
        "Rashgarroth", "Sargeras", "Sinstralis", "Suramar", "Temple noir", "Throk'Feroth", "Uldaman",
        "Varimathras", "Vol'jin", "Ysondre",
    },
    it = {
        "Nemesis", "Pozzo dell'Eternità",
    },
    pt = {
        "Aggra", "Aggra (Portugiesisch)",
    },
    ru = {
        "Ashenvale", "Azuregos", "Blackscar", "Booty Bay", "Borean Tundra", "Deathguard", "Deathweaver", "Deephome",
        "Eversong", "Fordragon", "Galakrond", "Goldrinn", "Gordunni", "Greymane", "Grom", "Howling Fjord", "Lich King",
        "Razuvious", "Soulflayer", "Thermaplugg",
    },
}

local function IsSupportedRealmFlagRegion()
    return GetCurrentRegion and GetCurrentRegion() == 3
end

local function NormalizeRealmName(realm)
    realm = TrimText and TrimText(realm) or realm
    if type(realm) ~= "string" or realm == "" then return nil end

    realm = realm:lower()
    realm = realm:gsub("[%s%-%'%(%)]", "")

    return realm ~= "" and realm or nil
end

local function BuildRealmFlags()
    local realmFlags = {}

    for code, realms in pairs(REALM_GROUPS) do
        for _, realm in ipairs(realms) do
            local normalizedRealm = NormalizeRealmName(realm)
            if normalizedRealm then
                realmFlags[normalizedRealm] = code
            end
        end
    end

    return realmFlags
end

local REALM_FLAGS = BuildRealmFlags()

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
    if not IsSupportedRealmFlagRegion() then return nil end

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
