-- Teleport Menu (Forever catalog) strings for every supported language. Existing translations win.
local _, ns = ...
local locales = ns and ns.Locales
if type(locales) ~= "table" then return end

local keys = {
    "Class & Racial",
    "Items",
    "Teleports",
    "Portals",
    "Click to cast",
    "Click to use",
    "Not learned yet",
    "Not in your bags",
    "Reagent: %d",
}

local values = {
    esES = {
        "Clase y raza", "Objetos", "Teletransportes", "Portales", "Clic para lanzar", "Clic para usar",
        "Aún no aprendido", "No está en tus bolsas", "Componente: %d",
    },
    deDE = {
        "Klasse & Volk", "Gegenstände", "Teleports", "Portale", "Klicken zum Zaubern", "Klicken zum Benutzen",
        "Noch nicht erlernt", "Nicht in deinen Taschen", "Reagenz: %d",
    },
    frFR = {
        "Classe et race", "Objets", "Téléportations", "Portails", "Cliquer pour lancer", "Cliquer pour utiliser",
        "Pas encore appris", "Pas dans vos sacs", "Composant : %d",
    },
    itIT = {
        "Classe e razza", "Oggetti", "Teletrasporti", "Portali", "Clic per lanciare", "Clic per usare",
        "Non ancora appreso", "Non nelle tue borse", "Reagente: %d",
    },
    ptBR = {
        "Classe e raça", "Itens", "Teletransportes", "Portais", "Clique para lançar", "Clique para usar",
        "Ainda não aprendido", "Não está nas suas bolsas", "Reagente: %d",
    },
    ruRU = {
        "Класс и раса", "Предметы", "Телепорты", "Порталы", "Нажмите, чтобы применить", "Нажмите, чтобы использовать",
        "Ещё не изучено", "Нет в сумках", "Реагент: %d",
    },
    koKR = {
        "직업 및 종족", "아이템", "순간이동", "차원문", "클릭하여 시전", "클릭하여 사용",
        "아직 배우지 않음", "가방에 없음", "재료: %d",
    },
    zhCN = {
        "职业与种族", "物品", "传送", "传送门", "点击施放", "点击使用",
        "尚未学会", "背包中没有", "材料：%d",
    },
    zhTW = {
        "職業與種族", "物品", "傳送", "傳送門", "點擊施放", "點擊使用",
        "尚未學會", "背包中沒有", "材料：%d",
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
