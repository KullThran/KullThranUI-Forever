local _, ns = ...
local locales = ns and ns.Locales
if type(locales) ~= "table" then return end

local keys = {
    "Aura Reminders", "Prepare group buffs, class upkeep and consumables from one KUI workspace.",
    "Control Center", "Group Readiness", "Class Upkeep", "Consumable Loadout", "Talent Reminders", "Custom Auras",
    "LOOK & PLACEMENT", "GROUP COVERAGE", "ASSIGNED & PERSONAL AURAS", "LOADOUT CHECKLIST",
    "ROGUE PREPARATION", "PALADIN PREPARATION", "SHAMAN PREPARATION", "Text Settings", "Display In:",
    "Select a talent...", "Blank Canvas", "Start from scratch", "Tracks a cooldown", "Tracks your buff",
    "Important warning", "Mythic Only", "Heroic and Mythic", "All Instanced Content", "Icon (Default)",
    "Text Only", "Weapon", "Buff", "Debuff", "Inky Black Potion Zone IDs", "a Glow Type other than None",
}

local values = {
 enUS={"Aura Reminders","Prepare group buffs, class upkeep and consumables from one KUI workspace.","Control Center","Group Readiness","Class Upkeep","Consumable Loadout","Talent Reminders","Custom Auras","LOOK & PLACEMENT","GROUP COVERAGE","ASSIGNED & PERSONAL AURAS","LOADOUT CHECKLIST","ROGUE PREPARATION","PALADIN PREPARATION","SHAMAN PREPARATION","Text Settings","Display In:","Select a talent...","Blank Canvas","Start from scratch","Tracks a cooldown","Tracks your buff","Important warning","Mythic Only","Heroic and Mythic","All Instanced Content","Icon (Default)","Text Only","Weapon","Buff","Debuff","Inky Black Potion Zone IDs","a Glow Type other than None"},
 esES={"Recordatorios de auras","Prepara los beneficios del grupo, el mantenimiento de clase y los consumibles desde un único espacio de KUI.","Centro de control","Preparación del grupo","Mantenimiento de clase","Equipamiento de consumibles","Recordatorios de talentos","Auras personalizadas","ASPECTO Y POSICIÓN","COBERTURA DEL GRUPO","AURAS ASIGNADAS Y PERSONALES","LISTA DE CONSUMIBLES","PREPARACIÓN DEL PÍCARO","PREPARACIÓN DEL PALADÍN","PREPARACIÓN DEL CHAMÁN","Ajustes de texto","Mostrar en:","Selecciona un talento...","Lienzo en blanco","Empezar desde cero","Rastrea un tiempo de reutilización","Rastrea tu beneficio","Aviso importante","Solo míticas","Heroicas y míticas","Todo el contenido instanciado","Icono (predeterminado)","Solo texto","Arma","Buff","Debuff","IDs de zona de la poción de tinta negra","un tipo de resplandor distinto de Ninguno"},
 deDE={"Aura-Erinnerungen","Bereite Gruppen-Buffs, Klassenbuffs und Verbrauchsgegenstände in einem KUI-Arbeitsbereich vor.","Kontrollzentrum","Gruppenbereitschaft","Klassenbuffs","Verbrauchsgegenstände","Talent-Erinnerungen","Benutzerdefinierte Auren","AUSSEHEN & PLATZIERUNG","GRUPPENABDECKUNG","ZUGEWIESENE & PERSÖNLICHE AUREN","VERBRAUCHSGEGENSTÄNDE","SCHURKEN-VORBEREITUNG","PALADIN-VORBEREITUNG","SCHAMANEN-VORBEREITUNG","Texteinstellungen","Anzeigen in:","Talent auswählen ...","Leere Vorlage","Von Grund auf beginnen","Verfolgt eine Abklingzeit","Verfolgt deinen Buff","Wichtiger Hinweis","Nur mythisch","Heroisch und mythisch","Alle Instanzinhalte","Symbol (Standard)","Nur Text","Waffe","Buff","Debuff","Zonen-IDs für Tiefschwarzen Trank","einen anderen Leuchttyp als Keine"},
 frFR={"Rappels d’aura","Préparez les améliorations de groupe, l’entretien de classe et les consommables depuis un seul espace KUI.","Centre de contrôle","Préparation du groupe","Entretien de classe","Consommables prêts","Rappels de talents","Auras personnalisées","APPARENCE ET POSITION","COUVERTURE DU GROUPE","AURAS ASSIGNÉES ET PERSONNELLES","LISTE DES CONSOMMABLES","PRÉPARATION DU VOLEUR","PRÉPARATION DU PALADIN","PRÉPARATION DU CHAMAN","Paramètres du texte","Afficher dans :","Sélectionnez un talent...","Toile vierge","Commencer de zéro","Suit un temps de recharge","Suit votre amélioration","Avertissement important","Mythique uniquement","Héroïque et mythique","Tout le contenu instancié","Icône (par défaut)","Texte uniquement","Arme","Buff","Affaiblissement","ID de zone de la potion noire d’encre","un type de lueur autre qu’Aucune"},
 itIT={"Promemoria aure","Prepara i buff di gruppo, il mantenimento della classe e i consumabili da un unico spazio KUI.","Centro di controllo","Preparazione del gruppo","Mantenimento della classe","Dotazione consumabili","Promemoria dei talenti","Aure personalizzate","ASPETTO E POSIZIONE","COPERTURA DEL GRUPPO","AURE ASSEGNATE E PERSONALI","ELENCO DEI CONSUMABILI","PREPARAZIONE DEL LADRO","PREPARAZIONE DEL PALADINO","PREPARAZIONE DELLO SCIAMANO","Impostazioni del testo","Mostra in:","Seleziona un talento...","Tela vuota","Inizia da zero","Tiene traccia di un tempo di recupero","Tiene traccia del tuo buff","Avviso importante","Solo mitiche","Eroiche e mitiche","Tutti i contenuti istanziati","Icona (predefinita)","Solo testo","Arma","Buff","Indebolimento","ID zona della Pozione nera d’inchiostro","un tipo di bagliore diverso da Nessuno"},
 ptBR={"Lembretes de auras","Prepare bônus do grupo, manutenção de classe e consumíveis em um único espaço do KUI.","Central de controle","Prontidão do grupo","Manutenção de classe","Conjunto de consumíveis","Lembretes de talentos","Auras personalizadas","APARÊNCIA E POSIÇÃO","COBERTURA DO GRUPO","AURAS ATRIBUÍDAS E PESSOAIS","LISTA DE CONSUMÍVEIS","PREPARAÇÃO DO LADINO","PREPARAÇÃO DO PALADINO","PREPARAÇÃO DO XAMÃ","Configurações de texto","Exibir em:","Selecione um talento...","Tela em branco","Começar do zero","Rastreia um tempo de recarga","Rastreia seu bônus","Aviso importante","Somente mítico","Heroico e mítico","Todo o conteúdo de instâncias","Ícone (padrão)","Somente texto","Arma","Buff","Debuff","IDs de zona da Poção Negra de Tinta","um tipo de brilho diferente de Nenhum"},
 ruRU={"Напоминания об аурах","Подготавливайте групповые баффы, эффекты класса и расходники в одном окне KUI.","Центр управления","Готовность группы","Обязательные эффекты класса","Набор расходников","Напоминания о талантах","Пользовательские ауры","ВИД И РАСПОЛОЖЕНИЕ","ПОКРЫТИЕ ГРУППЫ","НАЗНАЧЕННЫЕ И ЛИЧНЫЕ АУРЫ","СПИСОК РАСХОДНИКОВ","ПОДГОТОВКА РАЗБОЙНИКА","ПОДГОТОВКА ПАЛАДИНА","ПОДГОТОВКА ШАМАНА","Настройки текста","Показывать в:","Выберите талант...","Чистый холст","Начать с нуля","Отслеживает восстановление","Отслеживает ваш бафф","Важное предупреждение","Только эпохальные","Героические и эпохальные","Все подземелья и рейды","Значок (по умолчанию)","Только текст","Оружие","Бафф","Дебафф","ID зон Чернильно-чёрного зелья","тип свечения, отличный от «Нет»"},
 koKR={"오라 알림","하나의 KUI 공간에서 파티 버프, 직업 유지 효과와 소모품을 준비합니다.","제어 센터","그룹 준비","직업 유지","소모품 구성","특성 알림","사용자 지정 오라","모양 및 배치","그룹 적용 범위","지정 및 개인 오라","소모품 확인 목록","도적 준비","성기사 준비","주술사 준비","텍스트 설정","표시 대상:","특성을 선택하세요...","빈 캔버스","처음부터 시작","재사용 대기시간 추적","내 버프 추적","중요 경고","신화만","영웅 및 신화","모든 인스턴스 콘텐츠","아이콘(기본값)","텍스트만","무기","버프","디버프","칠흑의 잉크 물약 지역 ID","없음이 아닌 반짝임 유형"},
 zhCN={"光环提醒","在 KUI 的同一工作区中准备团队增益、职业维持效果和消耗品。","控制中心","团队准备","职业维持","消耗品配置","天赋提醒","自定义光环","外观与位置","团队覆盖","已分配与个人光环","消耗品清单","潜行者准备","圣骑士准备","萨满准备","文字设置","显示于：","选择一个天赋……","空白模板","从头开始","追踪冷却时间","追踪你的增益","重要警告","仅史诗","英雄和史诗","所有副本内容","图标（默认）","仅文字","武器","增益","减益","墨黑药水区域 ID","不是“无”的发光类型"},
 zhTW={"光環提醒","在 KUI 的同一工作區中準備團隊增益、職業維持效果與消耗品。","控制中心","隊伍準備","職業維持","消耗品配置","天賦提醒","自訂光環","外觀與位置","隊伍涵蓋","已指定與個人光環","消耗品清單","盜賊準備","聖騎士準備","薩滿準備","文字設定","顯示於：","選擇一個天賦……","空白範本","從頭開始","追蹤冷卻時間","追蹤你的增益","重要警告","僅限傳奇","英雄與傳奇","所有副本內容","圖示（預設）","僅文字","武器","增益","減益","墨黑藥水區域 ID","非「無」的發光類型"},
}

for locale, translated in pairs(values) do
    local target = locales[locale]
    if type(target) == "table" then
        for index, key in ipairs(keys) do target[key] = translated[index] end
    end
end
if type(locales.esMX) == "table" then
    for index, key in ipairs(keys) do locales.esMX[key] = values.esES[index] end
end

local extra = {
    enUS = {
        ["None"]="None", ["Action Button Glow"]="Action Button Glow", ["Pixel Glow"]="Pixel Glow", ["Auto-Cast Shine"]="Auto-Cast Shine", ["GCD"]="GCD", ["Modern WoW Glow"]="Modern WoW Glow", ["Classic WoW Glow"]="Classic WoW Glow",
        ["Rune"]="Rune", ["Last Used"]="Last Used", ["Preferred Click to Buff"]="Preferred Click to Buff", ["Flask"]="Flask", ["Food"]="Food", ["Weapon Enhancement"]="Weapon Enhancement", ["Augment Rune"]="Augment Rune", ["Inky Black Potion"]="Inky Black Potion", ["Mark"]="Mark", ["Weapon"]="Weapon", ["Pet"]="Pet", ["Poison"]="Poison", ["Shield"]="Shield",
        ["Flask of the Blood Knights"]="Flask of the Blood Knights", ["Flask of the Magisters"]="Flask of the Magisters", ["Flask of the Shattered Sun"]="Flask of the Shattered Sun", ["Flask of Thalassian Resistance"]="Flask of Thalassian Resistance", ["Vicious Thalassian Flask of Honor"]="Vicious Thalassian Flask of Honor",
    },
    esES = {
        ["None"]="Ninguno", ["Action Button Glow"]="Resplandor del botón de acción", ["Pixel Glow"]="Resplandor de píxeles", ["Auto-Cast Shine"]="Brillo de autocast", ["GCD"]="GCD", ["Modern WoW Glow"]="Resplandor de WoW moderno", ["Classic WoW Glow"]="Resplandor de WoW clásico",
        ["Rune"]="Runa", ["Last Used"]="Último usado", ["Preferred Click to Buff"]="Preferido para aplicar beneficios con clic", ["Flask"]="Frasco", ["Food"]="Comida", ["Weapon Enhancement"]="Mejora de arma", ["Augment Rune"]="Runa de aumento", ["Inky Black Potion"]="Poción de tinta negra", ["Mark"]="Marca", ["Weapon"]="Arma", ["Pet"]="Mascota", ["Poison"]="Veneno", ["Shield"]="Escudo",
        ["Flask of the Blood Knights"]="Frasco de los Caballeros de sangre", ["Flask of the Magisters"]="Frasco del Magister", ["Flask of the Shattered Sun"]="Frasco del Sol Devastado", ["Flask of Thalassian Resistance"]="Frasco de resistencia thalassiana", ["Vicious Thalassian Flask of Honor"]="Frasco de honor thalassiano feroz",
    },
    deDE = {
        ["None"]="Keine", ["Action Button Glow"]="Aktionstasten-Leuchten", ["Pixel Glow"]="Pixel-Leuchten", ["Auto-Cast Shine"]="AutoCast-Glanz", ["GCD"]="GCD", ["Modern WoW Glow"]="Modernes WoW-Leuchten", ["Classic WoW Glow"]="Klassisches WoW-Leuchten",
        ["Rune"]="Rune", ["Last Used"]="Zuletzt verwendet", ["Preferred Click to Buff"]="Bevorzugt zum Buffen per Klick", ["Flask"]="Fläschchen", ["Food"]="Essen", ["Weapon Enhancement"]="Waffenverbesserung", ["Augment Rune"]="Verstärkungsrune", ["Inky Black Potion"]="Tiefschwarzer Trank", ["Mark"]="Mal", ["Weapon"]="Waffe", ["Pet"]="Begleiter", ["Poison"]="Gift", ["Shield"]="Schild",
        ["Flask of the Blood Knights"]="Fläschchen der Blutritter", ["Flask of the Magisters"]="Fläschchen der Magister", ["Flask of the Shattered Sun"]="Fläschchen der Zerschmetterten Sonne", ["Flask of Thalassian Resistance"]="Fläschchen des thalassischen Widerstands", ["Vicious Thalassian Flask of Honor"]="Tückisches thalassisches Ehrenfläschchen",
    },
    frFR = {
        ["None"]="Aucune", ["Action Button Glow"]="Lueur de bouton d’action", ["Pixel Glow"]="Lueur pixelisée", ["Auto-Cast Shine"]="Éclat d'incantation automatique", ["GCD"]="GCD", ["Modern WoW Glow"]="Lueur WoW moderne", ["Classic WoW Glow"]="Lueur WoW classique",
        ["Rune"]="Rune", ["Last Used"]="Dernier utilisé", ["Preferred Click to Buff"]="Amélioration préférée au clic", ["Flask"]="Flacon", ["Food"]="Nourriture", ["Weapon Enhancement"]="Amélioration d’arme", ["Augment Rune"]="Rune d’augmentation", ["Inky Black Potion"]="Potion noire d’encre", ["Mark"]="Marque", ["Weapon"]="Arme", ["Pet"]="Familier", ["Poison"]="Poison", ["Shield"]="Bouclier",
        ["Flask of the Blood Knights"]="Flacon des chevaliers de sang", ["Flask of the Magisters"]="Flacon des magistères", ["Flask of the Shattered Sun"]="Flacon du Soleil brisé", ["Flask of Thalassian Resistance"]="Flacon de résistance thalassienne", ["Vicious Thalassian Flask of Honor"]="Flacon d’honneur thalassien vicieux",
    },
    itIT = {
        ["None"]="Nessuno", ["Action Button Glow"]="Bagliore del pulsante d'azione", ["Pixel Glow"]="Bagliore pixel", ["Auto-Cast Shine"]="Luce AutoCast", ["GCD"]="GCD", ["Modern WoW Glow"]="Bagliore WoW moderno", ["Classic WoW Glow"]="Bagliore WoW classico",
        ["Rune"]="Runa", ["Last Used"]="Ultimo usato", ["Preferred Click to Buff"]="Preferito per buff con clic", ["Flask"]="Fiaschetta", ["Food"]="Cibo", ["Weapon Enhancement"]="Potenziamento arma", ["Augment Rune"]="Runa d’incremento", ["Inky Black Potion"]="Pozione nera d'inchiostro", ["Mark"]="Marchio", ["Weapon"]="Arma", ["Pet"]="Famiglio", ["Poison"]="Veleno", ["Shield"]="Scudo",
        ["Flask of the Blood Knights"]="Fiaschetta dei Cavalieri del Sangue", ["Flask of the Magisters"]="Fiaschetta dei Magister", ["Flask of the Shattered Sun"]="Fiaschetta del Sole Infranto", ["Flask of Thalassian Resistance"]="Fiaschetta della resistenza dei Thalassiani", ["Vicious Thalassian Flask of Honor"]="Fiaschetta d'onore selvaggia dei Thalassiani",
    },
    ptBR = {
        ["None"]="Nenhum", ["Action Button Glow"]="Brilho do botão de ação", ["Pixel Glow"]="Brilho de pixels", ["Auto-Cast Shine"]="Brilho de lançamento automático", ["GCD"]="GCD", ["Modern WoW Glow"]="Brilho de WoW moderno", ["Classic WoW Glow"]="Brilho de WoW clássico",
        ["Rune"]="Runa", ["Last Used"]="Último usado", ["Preferred Click to Buff"]="Bônus preferido ao clicar", ["Flask"]="Frasco", ["Food"]="Comida", ["Weapon Enhancement"]="Aprimoramento de arma", ["Augment Rune"]="Runa de aprimoramento", ["Inky Black Potion"]="Poção Negra de Tinta", ["Mark"]="Marca", ["Weapon"]="Arma", ["Pet"]="Ajudante", ["Poison"]="Veneno", ["Shield"]="Escudo",
        ["Flask of the Blood Knights"]="Frasco dos Cavaleiros Sangrentos", ["Flask of the Magisters"]="Frasco dos Magísteres", ["Flask of the Shattered Sun"]="Frasco do Sol Estilhaçado", ["Flask of Thalassian Resistance"]="Frasco de resistência thalassiana", ["Vicious Thalassian Flask of Honor"]="Frasco de Honra Thalassiana Viciosa",
    },
    ruRU = {
        ["None"]="Нет", ["Action Button Glow"]="Свечение кнопки действия", ["Pixel Glow"]="Пиксельное свечение", ["Auto-Cast Shine"]="Сияние автоприменения", ["GCD"]="ГКД", ["Modern WoW Glow"]="Свечение современного WoW", ["Classic WoW Glow"]="Свечение классического WoW",
        ["Rune"]="Руна", ["Last Used"]="Последний использованный", ["Preferred Click to Buff"]="Предпочтительный бафф по нажатию", ["Flask"]="Настой", ["Food"]="Еда", ["Weapon Enhancement"]="Усиление оружия", ["Augment Rune"]="Руна усиления", ["Inky Black Potion"]="Чернильно-чёрное зелье", ["Mark"]="Метка", ["Weapon"]="Оружие", ["Pet"]="Питомец", ["Poison"]="Яд", ["Shield"]="Щит",
        ["Flask of the Blood Knights"]="Настой кровавых рыцарей", ["Flask of the Magisters"]="Настой магистров", ["Flask of the Shattered Sun"]="Настой Расколотого Солнца", ["Flask of Thalassian Resistance"]="Настой талассийской устойчивости", ["Vicious Thalassian Flask of Honor"]="Свирепый талассийский настой чести",
    },
    koKR = {
        ["None"]="없음", ["Action Button Glow"]="행동 단축 버튼 반짝임", ["Pixel Glow"]="픽셀 반짝임", ["Auto-Cast Shine"]="자동 시전 반짝임", ["GCD"]="GCD", ["Modern WoW Glow"]="현대 WoW 반짝임", ["Classic WoW Glow"]="클래식 WoW 반짝임",
        ["Rune"]="룬", ["Last Used"]="최근 사용", ["Preferred Click to Buff"]="클릭으로 사용할 버프", ["Flask"]="영약", ["Food"]="음식", ["Weapon Enhancement"]="무기 강화", ["Augment Rune"]="증강 룬", ["Inky Black Potion"]="칠흑의 잉크 물약", ["Mark"]="징표", ["Weapon"]="무기", ["Pet"]="소환수", ["Poison"]="독", ["Shield"]="방패",
        ["Flask of the Blood Knights"]="붉은 기사단의 영약", ["Flask of the Magisters"]="마법학자의 영약", ["Flask of the Shattered Sun"]="부서진 태양의 영약", ["Flask of Thalassian Resistance"]="탈라시안 저항의 영약", ["Vicious Thalassian Flask of Honor"]="흉포한 탈라시안 명예 영약",
    },
    zhCN = {
        ["None"]="无", ["Action Button Glow"]="动作按钮发光", ["Pixel Glow"]="像素发光", ["Auto-Cast Shine"]="自动施法闪光", ["GCD"]="GCD", ["Modern WoW Glow"]="现代 WoW 发光", ["Classic WoW Glow"]="经典 WoW 发光",
        ["Rune"]="符文", ["Last Used"]="上次使用", ["Preferred Click to Buff"]="首选点击增益", ["Flask"]="合剂", ["Food"]="食物", ["Weapon Enhancement"]="武器强化", ["Augment Rune"]="增幅符文", ["Inky Black Potion"]="墨黑药水", ["Mark"]="印记", ["Weapon"]="武器", ["Pet"]="宠物", ["Poison"]="毒药", ["Shield"]="盾牌",
        ["Flask of the Blood Knights"]="血骑士合剂", ["Flask of the Magisters"]="魔导师合剂", ["Flask of the Shattered Sun"]="破碎太阳合剂", ["Flask of Thalassian Resistance"]="萨拉斯抗性合剂", ["Vicious Thalassian Flask of Honor"]="凶猛萨拉斯荣誉合剂",
    },
    zhTW = {
        ["None"]="無", ["Action Button Glow"]="動作按鈕發光", ["Pixel Glow"]="像素發光", ["Auto-Cast Shine"]="自動施法閃光", ["GCD"]="GCD", ["Modern WoW Glow"]="現代 WoW 發光", ["Classic WoW Glow"]="經典 WoW 發光",
        ["Rune"]="符文", ["Last Used"]="上次使用", ["Preferred Click to Buff"]="點擊施放增益的偏好", ["Flask"]="精煉藥劑", ["Food"]="食物", ["Weapon Enhancement"]="武器強化", ["Augment Rune"]="增幅符文", ["Inky Black Potion"]="墨黑藥水", ["Mark"]="印記", ["Weapon"]="武器", ["Pet"]="寵物", ["Poison"]="毒藥", ["Shield"]="盾牌",
        ["Flask of the Blood Knights"]="血騎士精煉藥劑", ["Flask of the Magisters"]="魔導師精煉藥劑", ["Flask of the Shattered Sun"]="破碎之日精煉藥劑", ["Flask of Thalassian Resistance"]="薩拉斯抗性精煉藥劑", ["Vicious Thalassian Flask of Honor"]="兇猛薩拉斯榮譽精煉藥劑",
    },
}
for locale, translated in pairs(extra) do
    local target = locales[locale]
    if type(target) == "table" then
        for key, value in pairs(translated) do target[key] = value end
    end
end
if type(locales.esMX) == "table" then
    for key, value in pairs(extra.esES) do locales.esMX[key] = value end
end

-- The section cards of the options panel.
local cards = {
    enUS = { ["Group Readiness Card Title"]="Group Readiness", ["Talent Reminders Card Title"]="Talent Reminders", ["Consumable Loadout Card Title"]="Consumable Loadout", ["Preview"]="Preview", ["%d of %d on"]="%d of %d on", ["%d saved"]="%d saved", ["Module, look and placement"]="Module, look and placement", ["Raid buffs and personal auras"]="Raid buffs and personal auras", ["Poisons, rites and imbues"]="Poisons, rites and imbues", ["Flasks, food and runes"]="Flasks, food and runes", ["Talent swaps by zone"]="Talent swaps by zone", ["Your own tracked auras"]="Your own tracked auras" },
    esES = { ["Group Readiness Card Title"]="Preparación del grupo", ["Talent Reminders Card Title"]="Recordatorios de talentos", ["Consumable Loadout Card Title"]="Equipamiento de consumibles", ["Preview"]="Vista previa", ["%d of %d on"]="%d de %d activos", ["%d saved"]="%d guardados", ["Module, look and placement"]="Módulo, aspecto y colocación", ["Raid buffs and personal auras"]="Beneficios de banda y auras personales", ["Poisons, rites and imbues"]="Venenos, ritos e imbuiciones", ["Flasks, food and runes"]="Frascos, comida y runas", ["Talent swaps by zone"]="Cambios de talentos por zona", ["Your own tracked auras"]="Tus propias auras" },
    deDE = { ["Group Readiness Card Title"]="Gruppen- bereitschaft", ["Talent Reminders Card Title"]="Talent- Erinnerungen", ["Consumable Loadout Card Title"]="Verbrauchs- gegenstände", ["Preview"]="Vorschau", ["%d of %d on"]="%d von %d an", ["%d saved"]="%d gespeichert", ["Module, look and placement"]="Modul, Aussehen und Position", ["Raid buffs and personal auras"]="Schlachtzug-Buffs und persönliche Auren", ["Poisons, rites and imbues"]="Gifte, Riten und Waffenzauber", ["Flasks, food and runes"]="Fläschchen, Essen und Runen", ["Talent swaps by zone"]="Talentwechsel nach Gebiet", ["Your own tracked auras"]="Deine eigenen Auren" },
    frFR = { ["Group Readiness Card Title"]="Préparation du groupe", ["Talent Reminders Card Title"]="Rappels de talents", ["Consumable Loadout Card Title"]="Consommables prêts", ["Preview"]="Aperçu", ["%d of %d on"]="%d sur %d actifs", ["%d saved"]="%d enregistrés", ["Module, look and placement"]="Module, apparence et position", ["Raid buffs and personal auras"]="Améliorations de raid et auras personnelles", ["Poisons, rites and imbues"]="Poisons, rites et imprégnations", ["Flasks, food and runes"]="Flacons, nourriture et runes", ["Talent swaps by zone"]="Changements de talents par zone", ["Your own tracked auras"]="Vos propres auras" },
    itIT = { ["Group Readiness Card Title"]="Preparazione del gruppo", ["Talent Reminders Card Title"]="Promemoria dei talenti", ["Consumable Loadout Card Title"]="Dotazione consumabili", ["Preview"]="Anteprima", ["%d of %d on"]="%d di %d attivi", ["%d saved"]="%d salvati", ["Module, look and placement"]="Modulo, aspetto e posizione", ["Raid buffs and personal auras"]="Buff d'incursione e aure personali", ["Poisons, rites and imbues"]="Veleni, riti e infusioni", ["Flasks, food and runes"]="Fiaschette, cibo e rune", ["Talent swaps by zone"]="Cambi di talento per zona", ["Your own tracked auras"]="Le tue aure" },
    ptBR = { ["Group Readiness Card Title"]="Prontidão do grupo", ["Talent Reminders Card Title"]="Lembretes de talentos", ["Consumable Loadout Card Title"]="Conjunto de consumíveis", ["Preview"]="Pré-visualização", ["%d of %d on"]="%d de %d ativos", ["%d saved"]="%d salvos", ["Module, look and placement"]="Módulo, aparência e posição", ["Raid buffs and personal auras"]="Bônus de raide e auras pessoais", ["Poisons, rites and imbues"]="Venenos, ritos e imbuições", ["Flasks, food and runes"]="Frascos, comida e runas", ["Talent swaps by zone"]="Trocas de talentos por zona", ["Your own tracked auras"]="Suas próprias auras" },
    ruRU = { ["Group Readiness Card Title"]="Готовность группы", ["Talent Reminders Card Title"]="Напоминания о талантах", ["Consumable Loadout Card Title"]="Набор расходников", ["Preview"]="Предпросмотр", ["%d of %d on"]="Вкл.: %d из %d", ["%d saved"]="Сохранено: %d", ["Module, look and placement"]="Модуль, вид и положение", ["Raid buffs and personal auras"]="Рейдовые баффы и личные ауры", ["Poisons, rites and imbues"]="Яды, обряды и чары", ["Flasks, food and runes"]="Настои, еда и руны", ["Talent swaps by zone"]="Смена талантов по зонам", ["Your own tracked auras"]="Ваши собственные ауры" },
    koKR = { ["Group Readiness Card Title"]="그룹 준비", ["Talent Reminders Card Title"]="특성 알림", ["Consumable Loadout Card Title"]="소모품 구성", ["Preview"]="미리 보기", ["%d of %d on"]="%d/%d 켜짐", ["%d saved"]="%d개 저장됨", ["Module, look and placement"]="모듈, 모양 및 위치", ["Raid buffs and personal auras"]="공격대 버프와 개인 오라", ["Poisons, rites and imbues"]="독, 의식과 무기 강화", ["Flasks, food and runes"]="영약, 음식과 룬", ["Talent swaps by zone"]="지역별 특성 변경", ["Your own tracked auras"]="직접 추적하는 오라" },
    zhCN = { ["Group Readiness Card Title"]="团队准备", ["Talent Reminders Card Title"]="天赋提醒", ["Consumable Loadout Card Title"]="消耗品配置", ["Preview"]="预览", ["%d of %d on"]="已开启 %d/%d", ["%d saved"]="已保存 %d", ["Module, look and placement"]="模块、外观与位置", ["Raid buffs and personal auras"]="团队增益与个人光环", ["Poisons, rites and imbues"]="毒药、仪式与灌注", ["Flasks, food and runes"]="合剂、食物与符文", ["Talent swaps by zone"]="按区域切换天赋", ["Your own tracked auras"]="你自己追踪的光环" },
    zhTW = { ["Group Readiness Card Title"]="隊伍準備", ["Talent Reminders Card Title"]="天賦提醒", ["Consumable Loadout Card Title"]="消耗品配置", ["Preview"]="預覽", ["%d of %d on"]="已開啟 %d/%d", ["%d saved"]="已儲存 %d", ["Module, look and placement"]="模組、外觀與位置", ["Raid buffs and personal auras"]="團隊增益與個人光環", ["Poisons, rites and imbues"]="毒藥、儀式與灌注", ["Flasks, food and runes"]="精煉藥劑、食物與符文", ["Talent swaps by zone"]="依區域切換天賦", ["Your own tracked auras"]="你自己追蹤的光環" },
}
for locale, translated in pairs(cards) do
    local target = locales[locale]
    if type(target) == "table" then
        for key, value in pairs(translated) do target[key] = value end
    end
end
if type(locales.esMX) == "table" then
    for key, value in pairs(cards.esES) do locales.esMX[key] = value end
end
