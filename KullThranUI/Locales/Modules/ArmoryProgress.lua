-- The Armory's Progress page on Forever (Modules/ArmoryProgressForever.lua),
-- for every supported language. Existing translations win.
local _, ns = ...
local locales = ns and ns.Locales
if type(locales) ~= "table" then return end

local keys = {
    "%s XP to level %d",
    "Rested: %d%%",
    "1 run",
    "%d runs",
    "Best: %s",
    "No dungeons completed yet",
    "PvP Rank",
    "Rank cap this week: %d",
}

local values = {
    esES = {
        "%s PX para el nivel %d",
        "Descansado: %d%%",
        "1 vez",
        "%d veces",
        "Mejor: %s",
        "Aún no has completado mazmorras",
        "Rango JcJ",
        "Rango máximo esta semana: %d",
    },
    deDE = {
        "%s EP bis Stufe %d",
        "Ausgeruht: %d%%",
        "1 Lauf",
        "%d Läufe",
        "Bestzeit: %s",
        "Noch keine Dungeons abgeschlossen",
        "PvP-Rang",
        "Höchster Rang diese Woche: %d",
    },
    frFR = {
        "%s XP avant le niveau %d",
        "Reposé : %d%%",
        "1 fois",
        "%d fois",
        "Meilleur : %s",
        "Aucun donjon terminé pour l’instant",
        "Rang JcJ",
        "Rang maximal cette semaine : %d",
    },
    itIT = {
        "%s PE al livello %d",
        "Riposato: %d%%",
        "1 volta",
        "%d volte",
        "Migliore: %s",
        "Nessuna spedizione completata",
        "Grado PvP",
        "Grado massimo questa settimana: %d",
    },
    ptBR = {
        "%s XP até o nível %d",
        "Descansado: %d%%",
        "1 vez",
        "%d vezes",
        "Melhor: %s",
        "Nenhuma masmorra concluída ainda",
        "Posto JxJ",
        "Posto máximo nesta semana: %d",
    },
    ruRU = {
        "%s опыта до уровня %d",
        "Отдых: %d%%",
        "1 прохождение",
        "Прохождений: %d",
        "Лучшее: %s",
        "Подземелья ещё не пройдены",
        "Звание PvP",
        "Предел звания на этой неделе: %d",
    },
    koKR = {
        "경험치 %s 남음 (레벨 %d)",
        "휴식: %d%%",
        "1회",
        "%d회",
        "최고 기록: %s",
        "아직 완료한 던전이 없습니다",
        "PvP 계급",
        "이번 주 최대 계급: %d",
    },
    zhCN = {
        "还需%s经验升到%d级",
        "休息：%d%%",
        "1次",
        "%d次",
        "最佳：%s",
        "尚未完成任何地下城",
        "PvP军衔",
        "本周军衔上限：%d",
    },
    zhTW = {
        "還需%s經驗升到%d級",
        "休息：%d%%",
        "1次",
        "%d次",
        "最佳：%s",
        "尚未完成任何地城",
        "PvP軍階",
        "本週軍階上限：%d",
    },
}

local function Apply(target, locale)
    if type(target) ~= "table" then return end
    local translated = values[locale]
    for index, key in ipairs(keys) do
        if target[key] == nil or target[key] == key then
            target[key] = translated and translated[index] or key
        end
    end
end

for _, locale in ipairs({ "enUS", "esES", "deDE", "frFR", "itIT", "ptBR", "ruRU", "koKR", "zhCN", "zhTW" }) do
    Apply(locales[locale], locale)
end
if locales.esMX and locales.esMX ~= locales.esES then Apply(locales.esMX, "esES") end
if locales.ptPT and locales.ptPT ~= locales.ptBR then Apply(locales.ptPT, "ptBR") end
