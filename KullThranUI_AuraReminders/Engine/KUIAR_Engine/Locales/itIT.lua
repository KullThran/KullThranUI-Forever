-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_Engine", function(...)
-- Modified for ForeverAuras, 2026-09-18.
if (GAME_LOCALE or GetLocale()) ~= "itIT" then
  return
end

local L = KUIAR_Runtime.L

-- ForeverAuras
--[[Translation missing --]]
L[ [=[ Filter formats: 'Name', 'Name-Realm', '-Realm'.

Supports multiple entries, separated by commas
Can use \ to escape -.]=] ] = [=[ Filter formats: 'Name', 'Name-Realm', '-Realm'.

Supports multiple entries, separated by commas
Can use \ to escape -.]=]
L["%s Overlay Color"] = "%s Colore Overlay"
L["* Suffix"] = "* Suffisso"
L["/wa help - Show this message"] = "/wa help - Mostra questo messaggio"
L["/wa minimap - Toggle the minimap icon"] = "/wa minimap - Mostra/Nascondi l'icona della minimappa"
L["/wa pprint - Show the results from the most recent profiling"] = "/wa pprint - Mostra i risultati del più recente profiling"
L["/wa pstart - Start profiling. Optionally include a duration in seconds after which profiling automatically stops. To profile the next combat/encounter, pass a \"combat\" or \"encounter\" argument."] = "/wa pstart - Inizia il profiling. Si può includere una durata in secondi dopo la quale il profiling termina automaticamente. Per profilare il prossimo combattimento, passare un argomento ''combat'' o ''encounter''."
L["/wa pstop - Finish profiling"] = "/wa pstop - Termina il profiling"
L["/wa repair - Repair tool"] = "/wa riparazione - Strumento di riparazione"
L["|cffeda55fLeft-Click|r to toggle showing the main window."] = "|cffeda55fClick Sinistro|r per mostrare/nascondere la finestra principale."
L["|cffeda55fMiddle-Click|r to toggle the minimap icon on or off."] = "|cffeda55fClick Centrale|r per mostrare/nascondere l'icona della minimappa."
L["|cffeda55fRight-Click|r to toggle performance profiling window."] = "|cffeda55fFare clic con il pulsante destro del mouse|r per attivare/disattivare la finestra di profilazione delle prestazioni."
L["|cffeda55fShift-Click|r to pause addon execution."] = "|cffeda55fShift Click|r per mettere in pausa l'addon."
--[[Translation missing --]]
L["|cffff0000deprecated|r"] = "|cffff0000deprecated|r"
L["|cFFFF0000Not|r Item Bonus Id Equipped"] = "|cFFFF0000Not|r Bonus Id oggetto equipaggiato"
L["|cFFFF0000Not|r Item Equipped"] = "|cFFFF0000Not|r Oggetto Equipaggiato "
L["|cFFFF0000Not|r Player Name/Realm"] = "|cFFFF0000Not|r Nome Giocatore/Reame"
L["|cFFFF0000Not|r Spell Known"] = "|cFFFF0000Not|r Incantesimo Conosciuto"
--[[Translation missing --]]
L[ [=[|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r
COMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.
Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events]=] ] = [=[|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r
COMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.
Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events]=]
L["|cFFffcc00Extra Options:|r %s"] = "|cFFffcc00Opzioni Extra:|r %s"
L["|cFFffcc00Extra Options:|r None"] = "|cFFffcc00Opzioni Extra:|r Nessuna"
L[ [=[• |cff00ff00Player|r, |cff00ff00Target|r, |cff00ff00Focus|r, and |cff00ff00Pet|r correspond directly to those individual unitIDs.
• |cff00ff00Specific Unit|r lets you provide a specific valid unitID to watch.
|cffff0000Note|r: The game will not fire events for all valid unitIDs, making some untrackable by this trigger.
• |cffffff00Party|r, |cffffff00Raid|r, |cffffff00Boss|r, |cffffff00Arena|r, and |cffffff00Nameplate|r can match multiple corresponding unitIDs.
• |cffffff00Smart Group|r adjusts to your current group type, matching just the "player" when solo, "party" units (including "player") in a party or "raid" units in a raid.

|cffffff00*|r Yellow Unit settings will create clones for each matching unit while this trigger is providing Dynamic Info to the Aura.]=] ] = "• |cff00ff00Player|r, |cff00ff00Target|r, |cff00ff00Focus|r e |cff00ff00Pet|r corrispondono direttamente a quei singoli unitID.  • |cff00ff00Unità specifica|r consente di fornire uno specifico ID unità valido da guardare.  |cffff0000Nota|r: il gioco non attiverà eventi per tutti gli unitID validi, rendendone alcuni non tracciabili da questa attivazione.  • |cffffff00Party|r, |cffffff00Raid|r, |cffffff00Boss|r, |cffffff00Arena|r e |cffffff00Nameplate|r possono corrispondere a più ID unità corrispondenti.  • |cffffff00Smart Group|r si adatta al tipo di gruppo corrente, abbinando solo il \"giocatore\" in modalità solista, le unità \"party\" (incluso il \"giocatore\") in un party o le unità \"raid\" in un raid.  |cffffff00*|r Le impostazioni dell'unità gialla creeranno cloni per ciascuna unità corrispondente mentre questa attivazione fornisce informazioni dinamiche all'aura."
L["1. Profession 1. Accessory"] = "1. Professione 1. Accessorio"
L["1. Profession 2. Accessory"] = "1. Professione 2. Accessorio"
L["1. Professsion Tool"] = "1. Strumento Professione "
L["10 Man Raid"] = "Incursione da 10 giocatori"
L["10 Player Raid"] = "Raid da 10 giocatori"
L["10 Player Raid (Heroic)"] = "Raid da 10 giocatori (Eroico)"
L["10 Player Raid (Normal)"] = "Raid da 10 giocatori (Normale)"
L["2. Profession 1. Accessory"] = "2. Professione 1. Accessorio"
L["2. Profession 2. Accessory"] = "2. Professione 2. Accessorio"
L["2. Professsion Tool"] = "2. Strumento Professione"
L["20 Man Raid"] = "incursione da 20 giocatori"
L["20 Player Raid"] = "Raid da 20 giocatori"
L["25 Man Raid"] = "Incursione da 25 giocatori"
L["25 Player Raid"] = "Raid da 25 giocatori"
L["25 Player Raid (Heroic)"] = "Raid da 25 giocatori (Eroico)"
L["25 Player Raid (Normal)"] = "Raid da 25 giocatori (Normale)"
L["40 Man Raid"] = "incursione da 40 giocatori"
L["40 Player Raid"] = "Raid da 40 giocatori"
L["5 Man Dungeon"] = "Spedizione da 5 giocatori"
L[ [=[A detailed overview of your auras and KUIAR_Runtime systems
Copy the whole text to Weakaura's Discord if you need assistance.]=] ] = "Una panoramica dettagliata delle tue aure e dei sistemi KUIAR_Engine, Copia l'intero testo su Discord di Weakaura se hai bisogno di assistenza."
--[[Translation missing --]]
L["A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."] = "A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."
L["Abbreviate"] = "Abbreviare"
L["AbbreviateLargeNumbers (Blizzard)"] = "AbbreviareGrandiNumeri (Blizzard)"
L["AbbreviateNumbers (Blizzard)"] = "Abbreviare i numeri (Blizzard)"
L["Absorb"] = "Assorbimento"
--[[Translation missing --]]
L["Absorb and Healing"] = "Absorb and Healing"
L["Absorb Heal Overlay"] = "Assorbe la copertura di guarigione"
--[[Translation missing --]]
L["Absorb Overlay"] = "Absorb Overlay"
L["Absorbed"] = "Assorbito"
L["Action Button Glow"] = "Bagliore Pulsante Azioni"
L["Actions"] = "Azioni"
L["Active"] = "Attivo"
L[ [=[Active boss mod addon: |cFFffcc00BigWigs|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = "Componente aggiuntivo mod boss attivo: |cFFffcc00BigWigs|r Nota: Questa attivazione utilizzerà BigWigs o DBM, in quest'ordine se entrambi sono installati."
L[ [=[Active boss mod addon: |cFFffcc00DBM|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = "Componente aggiuntivo mod boss attivo: |cFFffcc00DBM|r Nota: questa attivazione utilizzerà BigWigs o DBM, in quest'ordine se entrambi sono installati."
L["Add"] = "Aggiungi"
L["Add Missing Auras"] = "Aggiungi Aure Mancanti"
L["Advanced Caster's Target Check"] = "Controllo del bersaglio dell'incantatore avanzato"
L["Affected"] = "Affetto"
L["Affected Unit Count"] = "Conta Unità Interessate"
--[[Translation missing --]]
L["Afk"] = "Afk"
L["Aggro"] = "Aggro"
L["Agility"] = "Agilità"
L["Ahn'Qiraj"] = "Ahn'Qiraj"
L["Alert Type"] = "Tipo di Allerta"
L["Alive"] = "Vivo"
L["All"] = "Tutto"
L["All children of this aura will also not be loaded, to minimize the chance of further corruption."] = "Anche tutti i bambini di quest'aura non verranno caricati, per ridurre al minimo la possibilità di ulteriore corruzione."
--[[Translation missing --]]
L["All States table contains a non table at key: '%s'."] = "All States table contains a non table at key: '%s'."
L["All Triggers"] = "Tutte le attivazioni"
L["Alliance"] = "Alleanza"
L["Allow partial matches"] = "Permetti corrispondenze parziali"
L["Alpha"] = "Alfa"
L["Alternate Power"] = "Risorse Speciali"
L["Always"] = "Sempre"
L["Always active trigger"] = "Innesco sempre attivo"
L["Always include realm"] = "Includi sempre il reame"
L["Always True"] = "Sempre Vero"
L["Amount"] = "Quantità"
L["Anchoring"] = "Ancoraggio"
L["And Talent"] = "E Talento "
L["Angle and Radius"] = "Angolo e Raggio"
L["Animations"] = "Animazioni"
L["Anticlockwise"] = "Antiorario"
--[[Translation missing --]]
L["Anub'Rekhan"] = "Anub'Rekhan"
L["Any"] = "Qualsiasi"
L["Any Triggers"] = "Qualsiasi attivazione"
--[[Translation missing --]]
L["AOE"] = "AOE"
L["Arcane Resistance"] = "Resistenza Arcana"
L[ [=[Are you sure you want to run the |cffff0000EXPERIMENTAL|r repair tool?
This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s]=] ] = "Vuoi eseguire lo strumento di riparazione |cffff0000EXPERIMENTAL|r? Ciò sovrascriverà tutte le modifiche apportate dall'ultimo aggiornamento del database. Ultimo aggiornamento: %s"
L["Arena"] = "Arena"
L["Armor (%)"] = "Armatura (%)"
L["Armor against Target (%)"] = "Armatura contro il bersaglio (%)"
--[[Translation missing --]]
L["Armor Peneration Percent"] = "Armor Peneration Percent"
--[[Translation missing --]]
L["Armor Peneration Rating"] = "Armor Peneration Rating"
L["Armor Rating"] = "Grado di armatura"
--[[Translation missing --]]
L["Array"] = "Array"
L["Ascending"] = "Crescente"
L["Assigned Role"] = "Ruolo assegnato"
L["Assigned Role Icon"] = "Icona del ruolo assegnato"
--[[Translation missing --]]
L["Assist"] = "Assist"
--[[Translation missing --]]
L["Assisted Combat Next Cast"] = "Assisted Combat Next Cast"
L["At Least One Enemy"] = "Almeno un nemico"
L["At missing Value"] = "Al valore mancante"
L["At Percent"] = "In Percentuale"
L["At Value"] = "Al valore"
L["At War"] = "In guerra"
L["Attach to End"] = "Aggiungi alla Fine"
--[[Translation missing --]]
L["Attach to End, backwards"] = "Attach to End, backwards"
--[[Translation missing --]]
L["Attach to Point"] = "Attach to Point"
L["Attach to Start"] = "Aggiungi all'inizio"
L["Attack Power"] = "Potenza d'attacco"
L["Attackable"] = "Attaccabile"
L["Attackable Target"] = "Bersaglio attaccabile"
L["Aura"] = "Aura"
--[[Translation missing --]]
L["Aura '%s': %s"] = "Aura '%s': %s"
L["Aura Applied"] = "Aura applicata"
L["Aura Applied Dose"] = "Parte di aura applicata"
L["Aura Broken"] = "Aura finita"
L["Aura Broken Spell"] = "Aura di magia finita"
L["Aura is using deprecated SetDurationInfo"] = "Aura utilizza SetDurationInfo deprecato"
L["Aura loaded"] = "Aura caricata"
L["Aura Name"] = "Nome Aura"
L["Aura Names"] = "Nomi Aura"
L["Aura Refresh"] = "Aura rinnovata"
L["Aura Removed"] = "Aura rimossa"
L["Aura Removed Dose"] = "Parte di aura rimossa"
L["Aura Stack"] = "Aura Stack"
L["Aura Type"] = "Tipo di aura"
L["Aura Version: %s"] = "Versione dell'aura: %s"
L["Aura(s) Found"] = "Aura(e) Trovata(e)"
L["Aura(s) Missing"] = "Aura(e) Mancante(i)"
L["Aura:"] = "Aura:"
L["Auras"] = "Aure"
L["Auras:"] = "Aure:"
L["Author Options"] = "Opzioni Autore"
--[[Translation missing --]]
L["Auto"] = "Auto"
--[[Translation missing --]]
L["Autocast Shine"] = "Autocast Shine"
L["Automatic"] = "Automatico"
L["Automatic Length"] = "Lunghezza Automatica"
L["Automatic Rotation"] = "Rotazione Automatica"
L["Available features: %s"] = "Funzionalità disponibili: %s"
L["Avoidance (%)"] = "Elusione (%)"
L["Avoidance Rating"] = "Grado di Elusione"
L["Ayamiss the Hunter"] = "Ayamiss il Cacciatore"
--[[Translation missing --]]
L["Azuregos"] = "Azuregos"
L["Back and Forth"] = "Avanti e indietro"
L["Background"] = "Sfondo"
L["Background Color"] = "Colore Sfondo"
--[[Translation missing --]]
L["Balnazzar"] = "Balnazzar"
L["Bar Color/Gradient Start"] = "Inizio Colore/Inclinazione della Barra"
--[[Translation missing --]]
L["Bar enabled in BigWigs settings"] = "Bar enabled in BigWigs settings"
--[[Translation missing --]]
L["Bar enabled in Boss Mod addon settings"] = "Bar enabled in Boss Mod addon settings"
--[[Translation missing --]]
L["Bar enabled in DBM settings"] = "Bar enabled in DBM settings"
--[[Translation missing --]]
L["Bar Texture"] = "Bar Texture"
--[[Translation missing --]]
L["Bar Type"] = "Bar Type"
L["Baron Geddon"] = "Barone Geddon"
--[[Translation missing --]]
L["Battle for Azeroth"] = "Battle for Azeroth"
L["Battle.net Whisper"] = "Sussurri di Battle.net"
L["Battleground"] = "Campo di battaglia"
L["Battleguard Sartura"] = "Guardia di battaglia Sartura"
--[[Translation missing --]]
L["Beastmaster"] = "Beastmaster"
--[[Translation missing --]]
L["Beatrix"] = "Beatrix"
--[[Translation missing --]]
L["BG>Raid>Party>Say"] = "BG>Raid>Party>Say"
--[[Translation missing --]]
L["BG-System Alliance"] = "BG-System Alliance"
--[[Translation missing --]]
L["BG-System Horde"] = "BG-System Horde"
--[[Translation missing --]]
L["BG-System Neutral"] = "BG-System Neutral"
L["Big Number"] = "Grande Numero"
L["BigWigs Addon"] = "BigWigs Add-on"
L["BigWigs Message"] = "Messaggio di BigWigs"
--[[Translation missing --]]
L["BigWigs Stage"] = "BigWigs Stage"
L["BigWigs Timer"] = "Timer di BigWigs"
L["Black Wing Lair"] = "Sotterranei dell'Ala Nera"
--[[Translation missing --]]
L["Bleed"] = "Bleed"
L["Blizzard Combat Text"] = "Testo di combattimento Blizzard"
L["Blizzard Cooldown Reduction"] = "Riduzione Cooldown Blizzard"
L["Block"] = "Bloccare"
L["Block (%)"] = "Blocco (%)"
L["Block against Target (%)"] = "Blocco rispetto al target (%)"
L["Block Value"] = "Valore di Blocco"
L["Blocked"] = "Bloccato"
L["Blood"] = "Sangue"
L["Blood Rune #1"] = "Runa del sangue n. 1"
L["Blood Rune #2"] = "Runa del sangue n.2"
L["Bloodlord Mandokir"] = "Signore del Sangue Mandokir"
L["Border"] = "Bordo"
L["Boss"] = "Boss"
L["Boss Emote"] = "Boss Emote"
--[[Translation missing --]]
L["Boss Mod Announce"] = "Boss Mod Announce"
--[[Translation missing --]]
L["Boss Mod Stage"] = "Boss Mod Stage"
--[[Translation missing --]]
L["Boss Mod Stage (Event)"] = "Boss Mod Stage (Event)"
--[[Translation missing --]]
L["Boss Mod Timer"] = "Boss Mod Timer"
--[[Translation missing --]]
L["Boss Whisper"] = "Boss Whisper"
L["Bottom"] = "Basso"
L["Bottom Left"] = "Basso a sinistra"
L["Bottom Right"] = "Basso a destra"
L["Bottom to Top"] = "Basso verso l'alto"
L["Bounce"] = "Balzo"
L["Bounce with Decay"] = "Bounce with Decay"
--[[Translation missing --]]
L["Break"] = "Break"
--[[Translation missing --]]
L["BreakUpLargeNumbers (Blizzard)"] = "BreakUpLargeNumbers (Blizzard)"
L["Broodlord Lashlayer"] = "Signore della Progenie Lashlayer"
L["Buff"] = "Buff"
--[[Translation missing --]]
L["Buff/Debuff"] = "Buff/Debuff"
L["Buffed/Debuffed"] = "Buffato/Debuffato"
--[[Translation missing --]]
L["Burning Crusade"] = "Burning Crusade"
--[[Translation missing --]]
L["Buru the Gorger"] = "Buru the Gorger"
--[[Translation missing --]]
L["Caldoran"] = "Caldoran"
L["Callback function"] = "Funzione di richiamata"
L["Can be used for e.g. checking if \"boss1target\" is the same as \"player\"."] = "Può essere usato per esempio per controllare se \"boss1target\" sia uguale a \"player\"."
L["Cancel"] = "Cancella"
L[ [=[Cannot change secure frame in combat lockdown. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = "Non è possibile modificare il frame protetto durante il blocco del combattimento. Trova ulteriori informazioni: https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Can't schedule timer with %i, due to a World of Warcraft bug with high computer uptime. (Uptime: %i). Please restart your computer."] = "Impossibile programmare il timer con %i, a causa di un bug di World of Warcraft con tempi di attività elevati del computer.  (Tempo di attività: %i).  Riavvia il computer."
L["Capped"] = "Limitato"
L["Capped at Season Max"] = "Limitato alla stagione massima"
L["Capped at Weekly Max"] = "Limitato al massimo settimanale"
L["Cast"] = "Cast"
L["Cast Bar"] = "Barra del cast"
L["Cast Failed"] = "Cast fallito"
L["Cast Start"] = "Inizio cast"
L["Cast Success"] = "Cast terminato con successo"
L["Cast Type"] = "Tipo di cast"
--[[Translation missing --]]
L["Caster"] = "Caster"
L["Caster Name"] = "Nome del Caster"
L["Caster Realm"] = "Reame del Caster"
L["Caster Unit"] = "Unità del Caster"
L["Casters Name/Realm"] = "Nome/Reame dei Caster"
L["Caster's Target"] = "Bersaglio dei Caster"
--[[Translation missing --]]
L["Cataclysm"] = "Cataclysm"
--[[Translation missing --]]
L["Ceil"] = "Ceil"
L["Center"] = "Centro"
L["Center, then alternating bottom and top"] = "Al centro, poi alternando il basso e l'alto"
L["Center, then alternating left and right"] = "Al centro, poi alternando sinistra e destra"
L["Center, then alternating right and left"] = "Al centro, poi alternando destra e sinistra"
L["Center, then alternating top and bottom"] = "Al centro, poi alternando la parte superiore e quella inferiore"
L["Centered Horizontal"] = "Centrato orizzontalmente"
L["Centered Horizontal, then Centered Vertical"] = "Centrato orizzontalmente, poi centrato verticalmente"
L["Centered Horizontal, then Down"] = "Centrato orizzontalmente, poi in basso"
L["Centered Horizontal, then Up"] = "Centrato orizzontalmente, poi in alto"
L["Centered Vertical"] = "Centrato verticalmente"
L["Centered Vertical, then Centered Horizontal"] = "Centrato verticalmente, poi centrato orizzontalmente "
L["Centered Vertical, then Left"] = "Centrato verticalmente, poi a sinistra"
L["Centered Vertical, then Right"] = "Centrato verticalmente, poi a destra"
L["Changed"] = "Modificato"
L["Channel"] = "Canale"
L["Channel (Spell)"] = "Canale (Magia)"
--[[Translation missing --]]
L["Character GUID"] = "Character GUID"
--[[Translation missing --]]
L["Character Name"] = "Character Name"
L["Character Stats"] = "Statistiche del Personaggio "
--[[Translation missing --]]
L["Character Transferred Quantity"] = "Character Transferred Quantity"
L["Character Type"] = "Tipo di carattere"
L["Charge gained/lost"] = "Carica guadagnata/persa"
--[[Translation missing --]]
L["Charged Combo Points"] = "Charged Combo Points"
L["Charges"] = "Cariche"
L["Charges Changed Event"] = "Evento modificato caricato"
L["Charging"] = "In carica"
L["Chat Frame"] = "Cornice di chat"
L["Chat Message"] = "Messaggio di chat"
L["Check if a single talent match a Rank"] = "Controlla se un singolo talento corrisponde a un grado"
L["Check nameplate's target every 0.2s"] = "Controllare le barre del bersaglio ogni 0,2 s"
--[[Translation missing --]]
L["Chromaggus"] = "Chromaggus"
L["Circle"] = "Cerchio"
--[[Translation missing --]]
L["Circular Texture"] = "Circular Texture"
L["Clamp"] = "Morso"
L["Class"] = "Classe"
L["Class and Specialization"] = "Classe e Specializzazione"
--[[Translation missing --]]
L["Classic"] = "Classic"
L["Classification"] = "Classificazione"
L["Clockwise"] = "Senso Orario"
--[[Translation missing --]]
L["Clone per Character"] = "Clone per Character"
L["Clone per Event"] = "Clona per evento"
L["Clone per Match"] = "Clona per partita"
--[[Translation missing --]]
L["Coin Precision"] = "Coin Precision"
L["Color"] = "Colore"
L["Color Animation"] = "Animazione a colori"
L["Combat Log"] = "Registro di combattimento"
--[[Translation missing --]]
L["Communities"] = "Communities"
--[[Translation missing --]]
L["Condition Custom Test"] = "Condition Custom Test"
L["Conditions"] = "Condizioni"
L["Contains"] = "Contiene"
L["Continuously update Movement Speed"] = "Aggiorna continuamente la velocità di movimento"
--[[Translation missing --]]
L["Cooldown"] = "Cooldown"
L["Cooldown bars show time before an ability is ready to be use, BigWigs prefix them with '~'"] = "Le barre di Cooldown mostrano il tempo trascorso prima che un'abilità sia pronta per essere utilizzata, BigWigs le prefissa con '~'"
--[[Translation missing --]]
L["Cooldown Progress (Item)"] = "Cooldown Progress (Item)"
--[[Translation missing --]]
L["Cooldown Progress (Slot)"] = "Cooldown Progress (Slot)"
L["Cooldown Ready Event"] = "Cooldiwn evento pronto"
L["Cooldown Ready Event (Item)"] = "Cooldown evento pronto (Oggetto)"
L["Cooldown Ready Event (Slot)"] = "Cooldown evento pronto (Slot)"
L["Cooldown Reduction changes the duration of seconds instead of showing the real time seconds."] = "La riduzione del Cooldown modifica la durata dei secondi invece di mostrare i secondi in tempo reale."
L["Cooldown/Charges/Count"] = "Cooldown/Cariche/Conteggio "
--[[Translation missing --]]
L["Copper"] = "Copper"
L["Could not load KUIAR_Engine Archive, the addon is %s"] = "Impossibile caricare l'archivio KUIAR_Engine, il componente aggiuntivo è %s"
L["Count"] = "Conteggio "
L["Counter Clockwise"] = "Conteggio Antiorario"
L["Create"] = "Crea"
--[[Translation missing --]]
L["Creature Family"] = "Creature Family"
--[[Translation missing --]]
L["Creature Family Name"] = "Creature Family Name"
--[[Translation missing --]]
L["Creature Type"] = "Creature Type"
--[[Translation missing --]]
L["Creature Type Name"] = "Creature Type Name"
L["Critical"] = "Critico"
L["Critical (%)"] = "Critico (%)"
L["Critical Rating"] = "Grado del Critico"
--[[Translation missing --]]
L["Crop X"] = "Crop X"
--[[Translation missing --]]
L["Crop Y"] = "Crop Y"
--[[Translation missing --]]
L["Crowd Controlled"] = "Crowd Controlled"
L["Crushing"] = "Frantumazione "
--[[Translation missing --]]
L["C'thun"] = "C'thun"
L["Cumulated time used during profiling"] = "Tempo cumulativo utilizzato durante la profilazione"
L["Currency"] = "Corrente"
L["Current Essence"] = "Essenza Attuale"
L["Current Experience"] = "Esperienza Attuale"
L["Current Instance"] = "Spedizione Attuale "
L["Current Movement Speed (%)"] = "Velocità di movimento attuale (%)"
L["Current Stage"] = "Stage Attuale "
L["Current Zone"] = "Zona Attuale "
L["Current Zone Group"] = "Gruppo di Zona Attuale "
L["Curse"] = "Maledizione"
--[[Translation missing --]]
L["Custom"] = "Custom"
--[[Translation missing --]]
L["Custom Action"] = "Custom Action"
--[[Translation missing --]]
L["Custom Anchor"] = "Custom Anchor"
--[[Translation missing --]]
L["Custom Check"] = "Custom Check"
--[[Translation missing --]]
L["Custom Color"] = "Custom Color"
--[[Translation missing --]]
L["Custom Condition Code"] = "Custom Condition Code"
--[[Translation missing --]]
L["Custom Configuration"] = "Custom Configuration"
--[[Translation missing --]]
L["Custom Fade Animation"] = "Custom Fade Animation"
--[[Translation missing --]]
L["Custom Function"] = "Custom Function"
--[[Translation missing --]]
L["Custom Grow"] = "Custom Grow"
--[[Translation missing --]]
L["Custom Sort"] = "Custom Sort"
--[[Translation missing --]]
L["Custom Text Function"] = "Custom Text Function"
--[[Translation missing --]]
L["Custom Trigger Combination"] = "Custom Trigger Combination"
--[[Translation missing --]]
L["Custom Variables"] = "Custom Variables"
--[[Translation missing --]]
L["Damage"] = "Damage"
--[[Translation missing --]]
L["Damage Shield"] = "Damage Shield"
--[[Translation missing --]]
L["Damage Shield Missed"] = "Damage Shield Missed"
--[[Translation missing --]]
L["Damage Split"] = "Damage Split"
--[[Translation missing --]]
L["DBM Announce"] = "DBM Announce"
--[[Translation missing --]]
L["DBM Stage"] = "DBM Stage"
--[[Translation missing --]]
L["DBM Timer"] = "DBM Timer"
--[[Translation missing --]]
L["Dead"] = "Dead"
--[[Translation missing --]]
L["Death"] = "Death"
L["Death Knight Rune"] = "Rune del cavaliere della morte"
--[[Translation missing --]]
L["Debuff"] = "Debuff"
--[[Translation missing --]]
L["Debuff Class"] = "Debuff Class"
--[[Translation missing --]]
L["Debuff Class Icon"] = "Debuff Class Icon"
--[[Translation missing --]]
L["Debuff Type"] = "Debuff Type"
--[[Translation missing --]]
L["Debug Log contains more than 1000 entries"] = "Debug Log contains more than 1000 entries"
--[[Translation missing --]]
L["Debug Logging enabled"] = "Debug Logging enabled"
--[[Translation missing --]]
L["Debug Logging enabled for '%s'"] = "Debug Logging enabled for '%s'"
--[[Translation missing --]]
L["Defense"] = "Defense"
--[[Translation missing --]]
L["Defensive Stats"] = "Defensive Stats"
--[[Translation missing --]]
L["Deflect"] = "Deflect"
--[[Translation missing --]]
L["Delve"] = "Delve"
--[[Translation missing --]]
L["Desaturate"] = "Desaturate"
--[[Translation missing --]]
L["Desaturate Background"] = "Desaturate Background"
--[[Translation missing --]]
L["Desaturate Foreground"] = "Desaturate Foreground"
--[[Translation missing --]]
L["Descending"] = "Descending"
L["Description"] = "Descrizione"
--[[Translation missing --]]
L["Dest Raid Mark"] = "Dest Raid Mark"
--[[Translation missing --]]
L["Destination Affiliation"] = "Destination Affiliation"
--[[Translation missing --]]
L["Destination GUID"] = "Destination GUID"
--[[Translation missing --]]
L["Destination Info"] = "Destination Info"
--[[Translation missing --]]
L["Destination Name"] = "Destination Name"
--[[Translation missing --]]
L["Destination NPC Id"] = "Destination NPC Id"
--[[Translation missing --]]
L["Destination Object Type"] = "Destination Object Type"
--[[Translation missing --]]
L["Destination Reaction"] = "Destination Reaction"
--[[Translation missing --]]
L["Destination Unit"] = "Destination Unit"
--[[Translation missing --]]
L["Destination unit's raid mark index"] = "Destination unit's raid mark index"
--[[Translation missing --]]
L["Destination unit's raid mark texture"] = "Destination unit's raid mark texture"
--[[Translation missing --]]
L["Difficulty"] = "Difficulty"
--[[Translation missing --]]
L["Disable Spell Known Check"] = "Disable Spell Known Check"
--[[Translation missing --]]
L["Disabled"] = "Disabled"
--[[Translation missing --]]
L["Disabled feature %q"] = "Disabled feature %q"
--[[Translation missing --]]
L["Disabled Spell Known Check"] = "Disabled Spell Known Check"
--[[Translation missing --]]
L["Discovered"] = "Discovered"
--[[Translation missing --]]
L["Disease"] = "Disease"
--[[Translation missing --]]
L["Dispel"] = "Dispel"
--[[Translation missing --]]
L["Dispel Failed"] = "Dispel Failed"
--[[Translation missing --]]
L["Display"] = "Display"
L["Distance"] = "Distanza"
--[[Translation missing --]]
L["Do Not Disturb"] = "Do Not Disturb"
--[[Translation missing --]]
L["Dodge"] = "Dodge"
--[[Translation missing --]]
L["Dodge (%)"] = "Dodge (%)"
--[[Translation missing --]]
L["Dodge Rating"] = "Dodge Rating"
--[[Translation missing --]]
L["Down"] = "Down"
--[[Translation missing --]]
L["Down, then Centered Horizontal"] = "Down, then Centered Horizontal"
--[[Translation missing --]]
L["Down, then Left"] = "Down, then Left"
--[[Translation missing --]]
L["Down, then Right"] = "Down, then Right"
--[[Translation missing --]]
L["Dragonflight"] = "Dragonflight"
--[[Translation missing --]]
L["Drain"] = "Drain"
--[[Translation missing --]]
L["Dropdown Menu"] = "Dropdown Menu"
--[[Translation missing --]]
L["Dumping table"] = "Dumping table"
--[[Translation missing --]]
L["Dungeon (Celestial)"] = "Dungeon (Celestial)"
--[[Translation missing --]]
L["Dungeon (Heroic)"] = "Dungeon (Heroic)"
--[[Translation missing --]]
L["Dungeon (Mythic)"] = "Dungeon (Mythic)"
--[[Translation missing --]]
L["Dungeon (Mythic+)"] = "Dungeon (Mythic+)"
--[[Translation missing --]]
L["Dungeon (Normal)"] = "Dungeon (Normal)"
--[[Translation missing --]]
L["Dungeon (Timewalking)"] = "Dungeon (Timewalking)"
--[[Translation missing --]]
L["Dungeons"] = "Dungeons"
--[[Translation missing --]]
L["Durability Damage"] = "Durability Damage"
--[[Translation missing --]]
L["Durability Damage All"] = "Durability Damage All"
--[[Translation missing --]]
L["Duration"] = "Duration"
--[[Translation missing --]]
L["Duration Function"] = "Duration Function"
--[[Translation missing --]]
L["Duration Function (fallback state)"] = "Duration Function (fallback state)"
--[[Translation missing --]]
L["Ease In"] = "Ease In"
--[[Translation missing --]]
L["Ease In and Out"] = "Ease In and Out"
--[[Translation missing --]]
L["Ease Out"] = "Ease Out"
--[[Translation missing --]]
L["Ebonroc"] = "Ebonroc"
--[[Translation missing --]]
L["Eclipse Direction"] = "Eclipse Direction"
--[[Translation missing --]]
L["Edge"] = "Edge"
--[[Translation missing --]]
L["Edge of Madness"] = "Edge of Madness"
--[[Translation missing --]]
L["Effective Spell Id"] = "Effective Spell Id"
--[[Translation missing --]]
L["Elide"] = "Elide"
--[[Translation missing --]]
L["Elite"] = "Elite"
--[[Translation missing --]]
L["Emote"] = "Emote"
--[[Translation missing --]]
L["Empower Cast End"] = "Empower Cast End"
--[[Translation missing --]]
L["Empower Cast Interrupt"] = "Empower Cast Interrupt"
--[[Translation missing --]]
L["Empower Cast Start"] = "Empower Cast Start"
--[[Translation missing --]]
L["Empowered"] = "Empowered"
--[[Translation missing --]]
L["Empowered 1"] = "Empowered 1"
--[[Translation missing --]]
L["Empowered 2"] = "Empowered 2"
--[[Translation missing --]]
L["Empowered 3"] = "Empowered 3"
--[[Translation missing --]]
L["Empowered 4"] = "Empowered 4"
--[[Translation missing --]]
L["Empowered 5"] = "Empowered 5"
--[[Translation missing --]]
L["Empowered Cast"] = "Empowered Cast"
--[[Translation missing --]]
L["Empowered Cast Fully Charged"] = "Empowered Cast Fully Charged"
--[[Translation missing --]]
L["Empowered Fully Charged"] = "Empowered Fully Charged"
--[[Translation missing --]]
L["Empty"] = "Empty"
--[[Translation missing --]]
L["Enabled feature %q"] = "Enabled feature %q"
--[[Translation missing --]]
L["Enables (incorrect) round down of seconds, which was the previous default behavior."] = "Enables (incorrect) round down of seconds, which was the previous default behavior."
--[[Translation missing --]]
L["Enchant Applied"] = "Enchant Applied"
--[[Translation missing --]]
L["Enchant Found"] = "Enchant Found"
--[[Translation missing --]]
L["Enchant ID"] = "Enchant ID"
--[[Translation missing --]]
L["Enchant Missing"] = "Enchant Missing"
--[[Translation missing --]]
L["Enchant Name or ID"] = "Enchant Name or ID"
--[[Translation missing --]]
L["Enchant Removed"] = "Enchant Removed"
--[[Translation missing --]]
L["Enchanted"] = "Enchanted"
--[[Translation missing --]]
L["Encounter ID(s)"] = "Encounter ID(s)"
--[[Translation missing --]]
L["Energize"] = "Energize"
--[[Translation missing --]]
L["Enrage"] = "Enrage"
--[[Translation missing --]]
L["Enter a name or a spellId"] = "Enter a name or a spellId"
--[[Translation missing --]]
L["Entering"] = "Entering"
--[[Translation missing --]]
L["Entering/Leaving Combat"] = "Entering/Leaving Combat"
--[[Translation missing --]]
L["Entering/Leaving Encounter"] = "Entering/Leaving Encounter"
--[[Translation missing --]]
L["Entry Order"] = "Entry Order"
--[[Translation missing --]]
L["Environment Type"] = "Environment Type"
--[[Translation missing --]]
L["Environmental"] = "Environmental"
--[[Translation missing --]]
L["Equipment"] = "Equipment"
--[[Translation missing --]]
L["Equipment Set"] = "Equipment Set"
--[[Translation missing --]]
L["Equipment Set Equipped"] = "Equipment Set Equipped"
--[[Translation missing --]]
L["Equipment Slot"] = "Equipment Slot"
--[[Translation missing --]]
L["Equipped"] = "Equipped"
L["Error"] = "Errore"
--[[Translation missing --]]
L[ [=[Error '%s' created a secure clone. We advise deleting the aura. For more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = [=[Error '%s' created a secure clone. We advise deleting the aura. For more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=]
--[[Translation missing --]]
L["Error decoding."] = "Error decoding."
--[[Translation missing --]]
L["Error decompressing"] = "Error decompressing"
--[[Translation missing --]]
L["Error decompressing. This doesn't look like a KUIAR_Engine import."] = "Error decompressing. This doesn't look like a KUIAR_Engine import."
--[[Translation missing --]]
L["Error deserializing"] = "Error deserializing"
--[[Translation missing --]]
L["Error Frame"] = "Error Frame"
--[[Translation missing --]]
L["ERROR in '%s' unknown or incompatible sub element type '%s'"] = "ERROR in '%s' unknown or incompatible sub element type '%s'"
--[[Translation missing --]]
L["Error in Aura '%s'"] = "Error in Aura '%s'"
--[[Translation missing --]]
L["Error not receiving display information from %s"] = "Error not receiving display information from %s"
--[[Translation missing --]]
L["Essence"] = "Essence"
--[[Translation missing --]]
L["Essence #1"] = "Essence #1"
--[[Translation missing --]]
L["Essence #2"] = "Essence #2"
--[[Translation missing --]]
L["Essence #3"] = "Essence #3"
--[[Translation missing --]]
L["Essence #4"] = "Essence #4"
--[[Translation missing --]]
L["Essence #5"] = "Essence #5"
--[[Translation missing --]]
L["Essence #6"] = "Essence #6"
--[[Translation missing --]]
L["Evade"] = "Evade"
L["Event"] = "Evento"
--[[Translation missing --]]
L["Event(s)"] = "Event(s)"
--[[Translation missing --]]
L["Every Frame"] = "Every Frame"
--[[Translation missing --]]
L["Every Frame (High CPU usage)"] = "Every Frame (High CPU usage)"
--[[Translation missing --]]
L["Evoker Essence"] = "Evoker Essence"
--[[Translation missing --]]
L["Exact Spell ID(s)"] = "Exact Spell ID(s)"
--[[Translation missing --]]
L["Execute Conditions"] = "Execute Conditions"
--[[Translation missing --]]
L["Experience (%)"] = "Experience (%)"
--[[Translation missing --]]
L["Expertise Bonus"] = "Expertise Bonus"
--[[Translation missing --]]
L["Expertise Rating"] = "Expertise Rating"
--[[Translation missing --]]
L["Extend Outside"] = "Extend Outside"
--[[Translation missing --]]
L["Extra Amount"] = "Extra Amount"
--[[Translation missing --]]
L["Extra Attacks"] = "Extra Attacks"
--[[Translation missing --]]
L["Extra Spell Id"] = "Extra Spell Id"
--[[Translation missing --]]
L["Extra Spell Name"] = "Extra Spell Name"
--[[Translation missing --]]
L["Faction"] = "Faction"
--[[Translation missing --]]
L["Faction Name"] = "Faction Name"
--[[Translation missing --]]
L["Faction Reputation"] = "Faction Reputation"
--[[Translation missing --]]
L["Fade Animation"] = "Fade Animation"
--[[Translation missing --]]
L["Fade In"] = "Fade In"
--[[Translation missing --]]
L["Fade Out"] = "Fade Out"
--[[Translation missing --]]
L["Fail Alert"] = "Fail Alert"
--[[Translation missing --]]
L["False"] = "False"
--[[Translation missing --]]
L["Fankriss the Unyielding"] = "Fankriss the Unyielding"
--[[Translation missing --]]
L["Feature %q is already disabled"] = "Feature %q is already disabled"
--[[Translation missing --]]
L["Feature %q is already enabled"] = "Feature %q is already enabled"
--[[Translation missing --]]
L["Fetch Absorb"] = "Fetch Absorb"
--[[Translation missing --]]
L["Fetch Heal Absorb"] = "Fetch Heal Absorb"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Fill Area"] = "Fill Area"
--[[Translation missing --]]
L["Filter messages with format <message>"] = "Filter messages with format <message>"
--[[Translation missing --]]
L["Fire Resistance"] = "Fire Resistance"
--[[Translation missing --]]
L["Firemaw"] = "Firemaw"
--[[Translation missing --]]
L["First"] = "First"
--[[Translation missing --]]
L["First Value of Tooltip Text"] = "First Value of Tooltip Text"
--[[Translation missing --]]
L["Fixed"] = "Fixed"
--[[Translation missing --]]
L["Fixed Names"] = "Fixed Names"
--[[Translation missing --]]
L["Fixed Size"] = "Fixed Size"
--[[Translation missing --]]
L["Flamegor"] = "Flamegor"
--[[Translation missing --]]
L["Flash"] = "Flash"
--[[Translation missing --]]
L["Flex Raid"] = "Flex Raid"
--[[Translation missing --]]
L["Flip"] = "Flip"
--[[Translation missing --]]
L["Floor"] = "Floor"
--[[Translation missing --]]
L["Focus"] = "Focus"
--[[Translation missing --]]
L["Follower Dungeon"] = "Follower Dungeon"
--[[Translation missing --]]
L["Font"] = "Font"
--[[Translation missing --]]
L["Font Size"] = "Font Size"
--[[Translation missing --]]
L["Forbidden function or table: %s"] = "Forbidden function or table: %s"
--[[Translation missing --]]
L["Foreground"] = "Foreground"
--[[Translation missing --]]
L["Foreground Color"] = "Foreground Color"
L["Form"] = "Forma"
--[[Translation missing --]]
L["Format"] = "Format"
--[[Translation missing --]]
L["Format Gold"] = "Format Gold"
--[[Translation missing --]]
L["Formats |cFFFFCC00%unit|r"] = "Formats |cFFFFCC00%unit|r"
--[[Translation missing --]]
L["Formats Player's |cFFFFCC00%guid|r"] = "Formats Player's |cFFFFCC00%guid|r"
--[[Translation missing --]]
L["Forward"] = "Forward"
--[[Translation missing --]]
L["Forward, Reverse Loop"] = "Forward, Reverse Loop"
--[[Translation missing --]]
L["Fourth Value of Tooltip Text"] = "Fourth Value of Tooltip Text"
--[[Translation missing --]]
L["Frame Selector"] = "Frame Selector"
--[[Translation missing --]]
L["Frequency"] = "Frequency"
--[[Translation missing --]]
L["Friendly"] = "Friendly"
--[[Translation missing --]]
L["Friendly Fire"] = "Friendly Fire"
--[[Translation missing --]]
L["Friendship Max Rank"] = "Friendship Max Rank"
--[[Translation missing --]]
L["Friendship Rank"] = "Friendship Rank"
--[[Translation missing --]]
L["Friendship Reputation"] = "Friendship Reputation"
--[[Translation missing --]]
L["Frost"] = "Frost"
--[[Translation missing --]]
L["Frost Resistance"] = "Frost Resistance"
--[[Translation missing --]]
L["Frost Rune #1"] = "Frost Rune #1"
--[[Translation missing --]]
L["Frost Rune #2"] = "Frost Rune #2"
--[[Translation missing --]]
L["Full"] = "Full"
--[[Translation missing --]]
L["Full Region"] = "Full Region"
--[[Translation missing --]]
L["Full/Empty"] = "Full/Empty"
--[[Translation missing --]]
L["Gahz'ranka"] = "Gahz'ranka"
--[[Translation missing --]]
L["Gained"] = "Gained"
--[[Translation missing --]]
L["Garr"] = "Garr"
--[[Translation missing --]]
L["Gehennas"] = "Gehennas"
--[[Translation missing --]]
L["General"] = "General"
--[[Translation missing --]]
L["General Rajaxx"] = "General Rajaxx"
--[[Translation missing --]]
L["GetNameAndIcon Function (fallback state)"] = "GetNameAndIcon Function (fallback state)"
--[[Translation missing --]]
L["Glancing"] = "Glancing"
--[[Translation missing --]]
L["Global Cooldown"] = "Global Cooldown"
--[[Translation missing --]]
L["Glow"] = "Glow"
--[[Translation missing --]]
L["Glow External Element"] = "Glow External Element"
--[[Translation missing --]]
L["Gluth"] = "Gluth"
--[[Translation missing --]]
L["Glyph"] = "Glyph"
--[[Translation missing --]]
L["Gold"] = "Gold"
--[[Translation missing --]]
L["Golemagg the Incinerator"] = "Golemagg the Incinerator"
--[[Translation missing --]]
L["Gothik the Harvester"] = "Gothik the Harvester"
--[[Translation missing --]]
L["Gradient"] = "Gradient"
--[[Translation missing --]]
L["Gradient Enabled"] = "Gradient Enabled"
--[[Translation missing --]]
L["Gradient End"] = "Gradient End"
--[[Translation missing --]]
L["Gradient Orientation"] = "Gradient Orientation"
--[[Translation missing --]]
L["Gradient Pulse"] = "Gradient Pulse"
--[[Translation missing --]]
L["Grand Widow Faerlina"] = "Grand Widow Faerlina"
--[[Translation missing --]]
L["Grid"] = "Grid"
--[[Translation missing --]]
L["Grobbulus"] = "Grobbulus"
--[[Translation missing --]]
L["Group"] = "Group"
--[[Translation missing --]]
L["Group Arrangement"] = "Group Arrangement"
--[[Translation missing --]]
L["Group Leader/Assist"] = "Group Leader/Assist"
--[[Translation missing --]]
L["Group Size"] = "Group Size"
--[[Translation missing --]]
L["Group Type"] = "Group Type"
--[[Translation missing --]]
L["Grow"] = "Grow"
--[[Translation missing --]]
L["GTFO Alert"] = "GTFO Alert"
--[[Translation missing --]]
L["Guardian"] = "Guardian"
--[[Translation missing --]]
L["Guild"] = "Guild"
--[[Translation missing --]]
L["Hakkar"] = "Hakkar"
--[[Translation missing --]]
L["Hardcore"] = "Hardcore"
--[[Translation missing --]]
L["Has Target"] = "Has Target"
--[[Translation missing --]]
L["Has Vehicle UI"] = "Has Vehicle UI"
--[[Translation missing --]]
L["HasPet"] = "HasPet"
--[[Translation missing --]]
L["Haste (%)"] = "Haste (%)"
--[[Translation missing --]]
L["Haste Rating"] = "Haste Rating"
--[[Translation missing --]]
L["Heal"] = "Heal"
--[[Translation missing --]]
L["Heal Absorb"] = "Heal Absorb"
--[[Translation missing --]]
L["Heal Absorbed"] = "Heal Absorbed"
--[[Translation missing --]]
L["Health"] = "Health"
--[[Translation missing --]]
L["Health (%)"] = "Health (%)"
--[[Translation missing --]]
L["Health Deficit"] = "Health Deficit"
--[[Translation missing --]]
L["Heigan the Unclean"] = "Heigan the Unclean"
--[[Translation missing --]]
L["Height"] = "Height"
--[[Translation missing --]]
L["Hero Talent"] = "Hero Talent"
--[[Translation missing --]]
L["Heroic Party"] = "Heroic Party"
--[[Translation missing --]]
L["Hide"] = "Hide"
--[[Translation missing --]]
L["Hide 0 cooldowns"] = "Hide 0 cooldowns"
--[[Translation missing --]]
L["Hide Timer Text"] = "Hide Timer Text"
--[[Translation missing --]]
L["High Damage"] = "High Damage"
--[[Translation missing --]]
L["High Priest Thekal"] = "High Priest Thekal"
--[[Translation missing --]]
L["High Priest Venoxis"] = "High Priest Venoxis"
--[[Translation missing --]]
L["High Priestess Arlokk"] = "High Priestess Arlokk"
--[[Translation missing --]]
L["High Priestess Jeklik"] = "High Priestess Jeklik"
--[[Translation missing --]]
L["High Priestess Mar'li"] = "High Priestess Mar'li"
--[[Translation missing --]]
L["Higher Than Tank"] = "Higher Than Tank"
--[[Translation missing --]]
L["Highest Spell Id"] = "Highest Spell Id"
--[[Translation missing --]]
L["Hit (%)"] = "Hit (%)"
--[[Translation missing --]]
L["Hit Rating"] = "Hit Rating"
--[[Translation missing --]]
L["Holy Resistance"] = "Holy Resistance"
--[[Translation missing --]]
L["Horde"] = "Horde"
--[[Translation missing --]]
L["Horizontal"] = "Horizontal"
--[[Translation missing --]]
L["Hostile"] = "Hostile"
--[[Translation missing --]]
L["Hostility"] = "Hostility"
--[[Translation missing --]]
L["Humanoid"] = "Humanoid"
--[[Translation missing --]]
L["Hybrid"] = "Hybrid"
--[[Translation missing --]]
L["Icon"] = "Icon"
--[[Translation missing --]]
L["Icon Function"] = "Icon Function"
--[[Translation missing --]]
L["Icon Function (fallback state)"] = "Icon Function (fallback state)"
--[[Translation missing --]]
L["Id"] = "Id"
--[[Translation missing --]]
L["ID"] = "ID"
--[[Translation missing --]]
--[[Translation missing --]]
L["Ignore Dead"] = "Ignore Dead"
--[[Translation missing --]]
L["Ignore Disconnected"] = "Ignore Disconnected"
--[[Translation missing --]]
L["Ignore out of checking range"] = "Ignore out of checking range"
--[[Translation missing --]]
L["Ignore Rune CD"] = "Ignore Rune CD"
--[[Translation missing --]]
L["Ignore Rune CDs"] = "Ignore Rune CDs"
--[[Translation missing --]]
L["Ignore Self"] = "Ignore Self"
--[[Translation missing --]]
L["Ignore Spell Cooldown/Charges"] = "Ignore Spell Cooldown/Charges"
--[[Translation missing --]]
L["Ignore Spell Override"] = "Ignore Spell Override"
--[[Translation missing --]]
L["Immune"] = "Immune"
--[[Translation missing --]]
L["Important"] = "Important"
--[[Translation missing --]]
L["Importing will start after combat ends."] = "Importing will start after combat ends."
--[[Translation missing --]]
L["In Combat"] = "In Combat"
--[[Translation missing --]]
L["In Encounter"] = "In Encounter"
--[[Translation missing --]]
L["In Group"] = "In Group"
--[[Translation missing --]]
L["In Party"] = "In Party"
--[[Translation missing --]]
L["In Pet Battle"] = "In Pet Battle"
--[[Translation missing --]]
L["In Raid"] = "In Raid"
--[[Translation missing --]]
L["In Range"] = "In Range"
--[[Translation missing --]]
L["In Vehicle"] = "In Vehicle"
--[[Translation missing --]]
L["In War Mode"] = "In War Mode"
--[[Translation missing --]]
L["Include Bank"] = "Include Bank"
--[[Translation missing --]]
L["Include Charges"] = "Include Charges"
--[[Translation missing --]]
L["Include Death Runes"] = "Include Death Runes"
--[[Translation missing --]]
L["Include Pets"] = "Include Pets"
--[[Translation missing --]]
L["Include War Band Bank"] = "Include War Band Bank"
--[[Translation missing --]]
L["Incoming Heal"] = "Incoming Heal"
--[[Translation missing --]]
L["Increase Precision Below"] = "Increase Precision Below"
--[[Translation missing --]]
L["Increases by one per stage or intermission."] = "Increases by one per stage or intermission."
--[[Translation missing --]]
L["Information"] = "Information"
--[[Translation missing --]]
L["Inherited"] = "Inherited"
--[[Translation missing --]]
L["Instakill"] = "Instakill"
--[[Translation missing --]]
L["Install the addons BugSack and BugGrabber for detailed error logs."] = "Install the addons BugSack and BugGrabber for detailed error logs."
--[[Translation missing --]]
L["Instance"] = "Instance"
--[[Translation missing --]]
L["Instance Difficulty"] = "Instance Difficulty"
--[[Translation missing --]]
L["Instance Id"] = "Instance Id"
--[[Translation missing --]]
L["Instance ID"] = "Instance ID"
--[[Translation missing --]]
L["Instance Info"] = "Instance Info"
--[[Translation missing --]]
L["Instance Name"] = "Instance Name"
--[[Translation missing --]]
L["Instance Size Type"] = "Instance Size Type"
--[[Translation missing --]]
L["Instance Type"] = "Instance Type"
--[[Translation missing --]]
L["Instructor Razuvious"] = "Instructor Razuvious"
--[[Translation missing --]]
L["Insufficient Resources"] = "Insufficient Resources"
--[[Translation missing --]]
L["Intellect"] = "Intellect"
--[[Translation missing --]]
L["Interrupt"] = "Interrupt"
--[[Translation missing --]]
L["Interrupt School"] = "Interrupt School"
--[[Translation missing --]]
L["Interrupted School Text"] = "Interrupted School Text"
--[[Translation missing --]]
L["Interruptible"] = "Interruptible"
--[[Translation missing --]]
L["Inverse"] = "Inverse"
--[[Translation missing --]]
L["Inverse Pet Behavior"] = "Inverse Pet Behavior"
--[[Translation missing --]]
L["Is Away from Keyboard"] = "Is Away from Keyboard"
--[[Translation missing --]]
--[[Translation missing --]]
L["Is Death Rune"] = "Is Death Rune"
--[[Translation missing --]]
L["Is Exactly"] = "Is Exactly"
--[[Translation missing --]]
L["Is Moving"] = "Is Moving"
--[[Translation missing --]]
L["Is Off Hand"] = "Is Off Hand"
--[[Translation missing --]]
--[[Translation missing --]]
L["Is Paused"] = "Is Paused"
--[[Translation missing --]]
L["is useable"] = "is useable"
--[[Translation missing --]]
L["Is Weekly Renown Capped"] = "Is Weekly Renown Capped"
--[[Translation missing --]]
L["Island Expedition (Heroic)"] = "Island Expedition (Heroic)"
--[[Translation missing --]]
L["Island Expedition (Mythic)"] = "Island Expedition (Mythic)"
--[[Translation missing --]]
L["Island Expedition (Normal)"] = "Island Expedition (Normal)"
--[[Translation missing --]]
L["Island Expeditions (PvP)"] = "Island Expeditions (PvP)"
--[[Translation missing --]]
L["Item"] = "Item"
--[[Translation missing --]]
L["Item Bonus Id"] = "Item Bonus Id"
--[[Translation missing --]]
L["Item Bonus Id Equipped"] = "Item Bonus Id Equipped"
--[[Translation missing --]]
L["Item Count"] = "Item Count"
--[[Translation missing --]]
L["Item Equipped"] = "Item Equipped"
--[[Translation missing --]]
L["Item Id"] = "Item Id"
--[[Translation missing --]]
L["Item in Range"] = "Item in Range"
--[[Translation missing --]]
L["Item Name"] = "Item Name"
--[[Translation missing --]]
L["Item Set Equipped"] = "Item Set Equipped"
--[[Translation missing --]]
L["Item Set Id"] = "Item Set Id"
--[[Translation missing --]]
L["Item Slot"] = "Item Slot"
--[[Translation missing --]]
L["Item Slot String"] = "Item Slot String"
--[[Translation missing --]]
L["Item Type"] = "Item Type"
--[[Translation missing --]]
L["Item Type Equipped"] = "Item Type Equipped"
--[[Translation missing --]]
L["ItemId"] = "ItemId"
--[[Translation missing --]]
L["Jin'do the Hexxer"] = "Jin'do the Hexxer"
--[[Translation missing --]]
L["Journal Stage"] = "Journal Stage"
--[[Translation missing --]]
L["Kazzak"] = "Kazzak"
--[[Translation missing --]]
L["Keep Inside"] = "Keep Inside"
--[[Translation missing --]]
L["Kel'Thuzad"] = "Kel'Thuzad"
--[[Translation missing --]]
L["Kurinnaxx"] = "Kurinnaxx"
--[[Translation missing --]]
L["Large"] = "Large"
--[[Translation missing --]]
L["Latency"] = "Latency"
--[[Translation missing --]]
L["Leader"] = "Leader"
--[[Translation missing --]]
L["Least remaining time"] = "Least remaining time"
--[[Translation missing --]]
L["Leaving"] = "Leaving"
--[[Translation missing --]]
L["Leech"] = "Leech"
--[[Translation missing --]]
L["Leech (%)"] = "Leech (%)"
--[[Translation missing --]]
L["Leech Rating"] = "Leech Rating"
--[[Translation missing --]]
L["Left"] = "Left"
--[[Translation missing --]]
L["Left to Right"] = "Left to Right"
--[[Translation missing --]]
L["Left, then Centered Vertical"] = "Left, then Centered Vertical"
--[[Translation missing --]]
L["Left, then Down"] = "Left, then Down"
--[[Translation missing --]]
L["Left, then Up"] = "Left, then Up"
--[[Translation missing --]]
L["Legacy Looking for Raid"] = "Legacy Looking for Raid"
--[[Translation missing --]]
L["Legacy RGB Gradient"] = "Legacy RGB Gradient"
--[[Translation missing --]]
L["Legacy RGB Gradient Pulse"] = "Legacy RGB Gradient Pulse"
--[[Translation missing --]]
L["Legion"] = "Legion"
--[[Translation missing --]]
L["Length"] = "Length"
--[[Translation missing --]]
L["Level"] = "Level"
--[[Translation missing --]]
L["LibSharedMedia"] = "LibSharedMedia"
--[[Translation missing --]]
L["Lillian Voss"] = "Lillian Voss"
--[[Translation missing --]]
L["Limited"] = "Limited"
--[[Translation missing --]]
L["Linear Texture"] = "Linear Texture"
--[[Translation missing --]]
L["Lines & Particles"] = "Lines & Particles"
--[[Translation missing --]]
L["Load Conditions"] = "Load Conditions"
--[[Translation missing --]]
L["Loatheb"] = "Loatheb"
--[[Translation missing --]]
L["Location"] = "Location"
--[[Translation missing --]]
L["Looking for Raid"] = "Looking for Raid"
--[[Translation missing --]]
L["Loop"] = "Loop"
--[[Translation missing --]]
L["Loot"] = "Loot"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Lord Kazzak"] = "Lord Kazzak"
--[[Translation missing --]]
L["Lorewalking"] = "Lorewalking"
--[[Translation missing --]]
L["Lost"] = "Lost"
--[[Translation missing --]]
L["Low Damage"] = "Low Damage"
--[[Translation missing --]]
L["Lower Than Tank"] = "Lower Than Tank"
--[[Translation missing --]]
L["Lowest Spell Id"] = "Lowest Spell Id"
--[[Translation missing --]]
L["Lua error"] = "Lua error"
--[[Translation missing --]]
L["Lua error in Aura '%s': %s"] = "Lua error in Aura '%s': %s"
--[[Translation missing --]]
L["Lucifron"] = "Lucifron"
--[[Translation missing --]]
L["Maexxna"] = "Maexxna"
--[[Translation missing --]]
L["Magic"] = "Magic"
--[[Translation missing --]]
L["Magmadar"] = "Magmadar"
--[[Translation missing --]]
L["Main Character"] = "Main Character"
--[[Translation missing --]]
L["Main Stat"] = "Main Stat"
--[[Translation missing --]]
L["Majordomo Executus"] = "Majordomo Executus"
--[[Translation missing --]]
L["Malformed KUIAR_Engine link"] = "Malformed KUIAR_Engine link"
--[[Translation missing --]]
L["Manual"] = "Manual"
--[[Translation missing --]]
L["Manual Icon"] = "Manual Icon"
--[[Translation missing --]]
L["Manual Rotation"] = "Manual Rotation"
--[[Translation missing --]]
L["Marked First"] = "Marked First"
--[[Translation missing --]]
L["Marked Last"] = "Marked Last"
--[[Translation missing --]]
L["Mason"] = "Mason"
--[[Translation missing --]]
L["Master"] = "Master"
--[[Translation missing --]]
L["Mastery (%)"] = "Mastery (%)"
--[[Translation missing --]]
L["Mastery Rating"] = "Mastery Rating"
--[[Translation missing --]]
L["Match Count"] = "Match Count"
--[[Translation missing --]]
L["Match Count per Unit"] = "Match Count per Unit"
--[[Translation missing --]]
L["Matches (Pattern)"] = "Matches (Pattern)"
--[[Translation missing --]]
L[ [=[Matches stage number of encounter journal.
Intermissions are .5
E.g. 1;2;1;2;2.5;3]=] ] = [=[Matches stage number of encounter journal.
Intermissions are .5
E.g. 1;2;1;2;2.5;3]=]
--[[Translation missing --]]
L["Max Char "] = "Max Char "
--[[Translation missing --]]
L["Max Char"] = "Max Char"
--[[Translation missing --]]
L["Max Charges"] = "Max Charges"
--[[Translation missing --]]
L["Max Health"] = "Max Health"
--[[Translation missing --]]
L["Max Power"] = "Max Power"
--[[Translation missing --]]
L["Max Quantity"] = "Max Quantity"
--[[Translation missing --]]
L["Maximum Estimate"] = "Maximum Estimate"
--[[Translation missing --]]
L["Maximum Progress"] = "Maximum Progress"
--[[Translation missing --]]
L["Maximum time used on a single frame"] = "Maximum time used on a single frame"
--[[Translation missing --]]
L["Media"] = "Media"
--[[Translation missing --]]
L["Medium"] = "Medium"
--[[Translation missing --]]
L["Melee"] = "Melee"
--[[Translation missing --]]
L["Melee Haste (%)"] = "Melee Haste (%)"
--[[Translation missing --]]
L["Message"] = "Message"
--[[Translation missing --]]
L["Message Type"] = "Message Type"
--[[Translation missing --]]
L["Message type:"] = "Message type:"
--[[Translation missing --]]
L["Meta Data"] = "Meta Data"
--[[Translation missing --]]
L["Mine"] = "Mine"
--[[Translation missing --]]
L["Minimum Estimate"] = "Minimum Estimate"
--[[Translation missing --]]
L["Minimum Progress"] = "Minimum Progress"
--[[Translation missing --]]
L["Minus (Small Nameplate)"] = "Minus (Small Nameplate)"
--[[Translation missing --]]
L["Mirror"] = "Mirror"
--[[Translation missing --]]
L["Miscellaneous"] = "Miscellaneous"
--[[Translation missing --]]
L["Miss"] = "Miss"
--[[Translation missing --]]
L["Miss Type"] = "Miss Type"
--[[Translation missing --]]
L["Missed"] = "Missed"
--[[Translation missing --]]
L["Missing"] = "Missing"
--[[Translation missing --]]
L["Mists of Pandaria"] = "Mists of Pandaria"
--[[Translation missing --]]
L["Moam"] = "Moam"
--[[Translation missing --]]
L["Model"] = "Model"
--[[Translation missing --]]
L["Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"] = "Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"
--[[Translation missing --]]
L["Modernize"] = "Modernize"
--[[Translation missing --]]
L["Molten Core"] = "Molten Core"
--[[Translation missing --]]
L["Money"] = "Money"
--[[Translation missing --]]
L["Monochrome"] = "Monochrome"
--[[Translation missing --]]
L["Monochrome Outline"] = "Monochrome Outline"
--[[Translation missing --]]
L["Monochrome Thick Outline"] = "Monochrome Thick Outline"
--[[Translation missing --]]
L["Monster Emote"] = "Monster Emote"
--[[Translation missing --]]
L["Monster Party"] = "Monster Party"
--[[Translation missing --]]
L["Monster Say"] = "Monster Say"
--[[Translation missing --]]
L["Monster Whisper"] = "Monster Whisper"
--[[Translation missing --]]
L["Monster Yell"] = "Monster Yell"
--[[Translation missing --]]
L["Moon"] = "Moon"
--[[Translation missing --]]
L["Most remaining time"] = "Most remaining time"
--[[Translation missing --]]
L["Mounted"] = "Mounted"
--[[Translation missing --]]
L["Mouse Cursor"] = "Mouse Cursor"
--[[Translation missing --]]
L["Movement Speed Rating"] = "Movement Speed Rating"
--[[Translation missing --]]
L["Multi-target"] = "Multi-target"
--[[Translation missing --]]
L["Mythic Keystone"] = "Mythic Keystone"
--[[Translation missing --]]
L["Mythic+ Affix"] = "Mythic+ Affix"
--[[Translation missing --]]
L["Name"] = "Name"
--[[Translation missing --]]
L["Name Function"] = "Name Function"
--[[Translation missing --]]
L["Name Function (fallback state)"] = "Name Function (fallback state)"
--[[Translation missing --]]
L["Name of Caster's Target"] = "Name of Caster's Target"
--[[Translation missing --]]
L["Name of the (sub-)zone currently shown above the minimap."] = "Name of the (sub-)zone currently shown above the minimap."
--[[Translation missing --]]
L["Name(s)"] = "Name(s)"
--[[Translation missing --]]
L["Name/Realm of Caster's Target"] = "Name/Realm of Caster's Target"
--[[Translation missing --]]
L["Nameplate"] = "Nameplate"
--[[Translation missing --]]
L["Nameplates"] = "Nameplates"
--[[Translation missing --]]
L["Names of affected Players"] = "Names of affected Players"
--[[Translation missing --]]
L["Names of unaffected Players"] = "Names of unaffected Players"
--[[Translation missing --]]
L["Nature Resistance"] = "Nature Resistance"
--[[Translation missing --]]
L["Naxxramas"] = "Naxxramas"
--[[Translation missing --]]
L["Nefarian"] = "Nefarian"
--[[Translation missing --]]
L["Neutral"] = "Neutral"
--[[Translation missing --]]
L["Never"] = "Never"
--[[Translation missing --]]
L["Next Combat"] = "Next Combat"
--[[Translation missing --]]
L["Next Encounter"] = "Next Encounter"
--[[Translation missing --]]
L[ [=[No active boss mod addon detected.

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = [=[No active boss mod addon detected.

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=]
--[[Translation missing --]]
L["No Extend"] = "No Extend"
--[[Translation missing --]]
L["No Instance"] = "No Instance"
--[[Translation missing --]]
L["No Profiling information saved."] = "No Profiling information saved."
--[[Translation missing --]]
L["No Progress Information available."] = "No Progress Information available."
--[[Translation missing --]]
L["None"] = "None"
--[[Translation missing --]]
L["Non-player Character"] = "Non-player Character"
--[[Translation missing --]]
L["Normal"] = "Normal"
--[[Translation missing --]]
L["Normal Party"] = "Normal Party"
--[[Translation missing --]]
L["Not in Group"] = "Not in Group"
--[[Translation missing --]]
L["Not in Smart Group"] = "Not in Smart Group"
--[[Translation missing --]]
L["Not on Cooldown"] = "Not on Cooldown"
--[[Translation missing --]]
L["Not On Threat Table"] = "Not On Threat Table"
--[[Translation missing --]]
L["Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."] = "Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."
--[[Translation missing --]]
L["Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."] = "Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."
--[[Translation missing --]]
L["Note: The available text replacements for multi triggers match the normal triggers now."] = "Note: The available text replacements for multi triggers match the normal triggers now."
--[[Translation missing --]]
L["Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."] = "Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."
--[[Translation missing --]]
L["Note: This trigger relies on the WoW API, which returns incorrect information in some cases."] = "Note: This trigger relies on the WoW API, which returns incorrect information in some cases."
L["Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."] = "Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."
--[[Translation missing --]]
L["Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"] = "Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"
--[[Translation missing --]]
L["Noth the Plaguebringer"] = "Noth the Plaguebringer"
--[[Translation missing --]]
L["NPC"] = "NPC"
--[[Translation missing --]]
L["Npc ID"] = "Npc ID"
--[[Translation missing --]]
L["Number"] = "Number"
--[[Translation missing --]]
L["Number Affected"] = "Number Affected"
--[[Translation missing --]]
L["Object"] = "Object"
--[[Translation missing --]]
L[ [=[Occurrence of the event
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Works only if Boss Mod addon show counter]=] ] = [=[Occurrence of the event
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Works only if Boss Mod addon show counter]=]
--[[Translation missing --]]
L[ [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if BigWigs shows it on it's bar]=] ] = [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if BigWigs shows it on it's bar]=]
--[[Translation missing --]]
L[ [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if DBM shows it on it's bar]=] ] = [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if DBM shows it on it's bar]=]
--[[Translation missing --]]
L["Officer"] = "Officer"
--[[Translation missing --]]
L["Offset from progress"] = "Offset from progress"
--[[Translation missing --]]
L["Offset Timer"] = "Offset Timer"
--[[Translation missing --]]
L["Old Blizzard (2h | 3m | 10s | 2.4)"] = "Old Blizzard (2h | 3m | 10s | 2.4)"
--[[Translation missing --]]
L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
L["On Taxi"] = "On Taxi"
--[[Translation missing --]]
L["Only if on a different realm"] = "Only if on a different realm"
--[[Translation missing --]]
L["Only if Primary"] = "Only if Primary"
--[[Translation missing --]]
L["Onyxia"] = "Onyxia"
--[[Translation missing --]]
L["Opaque"] = "Opaque"
--[[Translation missing --]]
L["Option Group"] = "Option Group"
--[[Translation missing --]]
L["Options could not be loaded, the addon is %s"] = "Options could not be loaded, the addon is %s"
--[[Translation missing --]]
L["Options will finish loading after combat ends."] = "Options will finish loading after combat ends."
--[[Translation missing --]]
L["Options will open after the login process has completed."] = "Options will open after the login process has completed."
--[[Translation missing --]]
L["Or Talent"] = "Or Talent"
--[[Translation missing --]]
L["Orbit"] = "Orbit"
--[[Translation missing --]]
L["Orientation"] = "Orientation"
--[[Translation missing --]]
L["Ossirian the Unscarred"] = "Ossirian the Unscarred"
--[[Translation missing --]]
L["Other"] = "Other"
--[[Translation missing --]]
L["Other Addons"] = "Other Addons"
--[[Translation missing --]]
L["Other Events"] = "Other Events"
--[[Translation missing --]]
L["Ouro"] = "Ouro"
--[[Translation missing --]]
L["Outline"] = "Outline"
--[[Translation missing --]]
L["Over Energize"] = "Over Energize"
--[[Translation missing --]]
L["Overhealing"] = "Overhealing"
--[[Translation missing --]]
L["Overkill"] = "Overkill"
--[[Translation missing --]]
L["Overlay %s"] = "Overlay %s"
--[[Translation missing --]]
L["Overlay Charged Combo Points"] = "Overlay Charged Combo Points"
--[[Translation missing --]]
L["Overlay Cost of Casts"] = "Overlay Cost of Casts"
--[[Translation missing --]]
L["Overlay Latency"] = "Overlay Latency"
--[[Translation missing --]]
L["Pad"] = "Pad"
--[[Translation missing --]]
L["Pad Mode"] = "Pad Mode"
--[[Translation missing --]]
L["Pad to"] = "Pad to"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Parent Frame"] = "Parent Frame"
--[[Translation missing --]]
L["Parent Zone"] = "Parent Zone"
--[[Translation missing --]]
L["Parry"] = "Parry"
--[[Translation missing --]]
L["Parry (%)"] = "Parry (%)"
--[[Translation missing --]]
L["Parry Rating"] = "Parry Rating"
--[[Translation missing --]]
L["Party"] = "Party"
--[[Translation missing --]]
L["Party Kill"] = "Party Kill"
--[[Translation missing --]]
L["Patchwerk"] = "Patchwerk"
--[[Translation missing --]]
L["Path of Ascension: Courage"] = "Path of Ascension: Courage"
--[[Translation missing --]]
L["Path of Ascension: Humility"] = "Path of Ascension: Humility"
--[[Translation missing --]]
L["Path of Ascension: Loyalty"] = "Path of Ascension: Loyalty"
--[[Translation missing --]]
L["Path of Ascension: Wisdom"] = "Path of Ascension: Wisdom"
--[[Translation missing --]]
L["Paused"] = "Paused"
--[[Translation missing --]]
L["Periodic Spell"] = "Periodic Spell"
--[[Translation missing --]]
L["Personal Resource Display"] = "Personal Resource Display"
--[[Translation missing --]]
L["Pet"] = "Pet"
--[[Translation missing --]]
L["Pet Behavior"] = "Pet Behavior"
--[[Translation missing --]]
L["Pet Specialization"] = "Pet Specialization"
--[[Translation missing --]]
L["Pet Spell"] = "Pet Spell"
--[[Translation missing --]]
L["Pets only"] = "Pets only"
--[[Translation missing --]]
L["Phase"] = "Phase"
--[[Translation missing --]]
L["Pixel Glow"] = "Pixel Glow"
--[[Translation missing --]]
L["Placement"] = "Placement"
--[[Translation missing --]]
L["Placement %i"] = "Placement %i"
--[[Translation missing --]]
L["Placement Mode"] = "Placement Mode"
--[[Translation missing --]]
L["Play"] = "Play"
--[[Translation missing --]]
L["Player"] = "Player"
--[[Translation missing --]]
L["Player Character"] = "Player Character"
--[[Translation missing --]]
L["Player Class"] = "Player Class"
--[[Translation missing --]]
L["Player Effective Level"] = "Player Effective Level"
--[[Translation missing --]]
L["Player Experience"] = "Player Experience"
--[[Translation missing --]]
L["Player Faction"] = "Player Faction"
--[[Translation missing --]]
L["Player Level"] = "Player Level"
--[[Translation missing --]]
L["Player Location ID(s)"] = "Player Location ID(s)"
--[[Translation missing --]]
L["Player Money"] = "Player Money"
--[[Translation missing --]]
L["Player Name/Realm"] = "Player Name/Realm"
--[[Translation missing --]]
L["Player Race"] = "Player Race"
--[[Translation missing --]]
L["Player(s) Affected"] = "Player(s) Affected"
--[[Translation missing --]]
L["Player(s) Not Affected"] = "Player(s) Not Affected"
--[[Translation missing --]]
L["Player/Unit Info"] = "Player/Unit Info"
--[[Translation missing --]]
L["Players and Pets"] = "Players and Pets"
--[[Translation missing --]]
L["Poison"] = "Poison"
--[[Translation missing --]]
L["Power"] = "Power"
--[[Translation missing --]]
L["Power (%)"] = "Power (%)"
--[[Translation missing --]]
L["Power Deficit"] = "Power Deficit"
--[[Translation missing --]]
L["Power Type"] = "Power Type"
--[[Translation missing --]]
L["Precision"] = "Precision"
--[[Translation missing --]]
L["Preset"] = "Preset"
--[[Translation missing --]]
L["Primary Stats"] = "Primary Stats"
--[[Translation missing --]]
L["Princess Huhuran"] = "Princess Huhuran"
--[[Translation missing --]]
L["Print Profiling Results"] = "Print Profiling Results"
--[[Translation missing --]]
L["Proc Glow"] = "Proc Glow"
--[[Translation missing --]]
L["Profiling already started."] = "Profiling already started."
--[[Translation missing --]]
L["Profiling automatically started."] = "Profiling automatically started."
--[[Translation missing --]]
L["Profiling not running."] = "Profiling not running."
--[[Translation missing --]]
L["Profiling started."] = "Profiling started."
--[[Translation missing --]]
L["Profiling started. It will end automatically in %d seconds"] = "Profiling started. It will end automatically in %d seconds"
--[[Translation missing --]]
L["Profiling still running, stop before trying to print."] = "Profiling still running, stop before trying to print."
--[[Translation missing --]]
L["Profiling stopped."] = "Profiling stopped."
--[[Translation missing --]]
L["Progress"] = "Progress"
--[[Translation missing --]]
L["Progress Source"] = "Progress Source"
--[[Translation missing --]]
L["Progress Total"] = "Progress Total"
--[[Translation missing --]]
L["Progress Value"] = "Progress Value"
--[[Translation missing --]]
L["Pull"] = "Pull"
--[[Translation missing --]]
L["Pulse"] = "Pulse"
--[[Translation missing --]]
L["PvP Flagged"] = "PvP Flagged"
--[[Translation missing --]]
L["PvP Mode Active"] = "PvP Mode Active"
--[[Translation missing --]]
L["PvP Talent selected"] = "PvP Talent selected"
--[[Translation missing --]]
L["PvP Talent Selected"] = "PvP Talent Selected"
--[[Translation missing --]]
L["Quality Id"] = "Quality Id"
--[[Translation missing --]]
L["Quantity"] = "Quantity"
--[[Translation missing --]]
L["Quantity earned this week"] = "Quantity earned this week"
--[[Translation missing --]]
L["Quest Party"] = "Quest Party"
--[[Translation missing --]]
L["Queued Action"] = "Queued Action"
--[[Translation missing --]]
L["Radius"] = "Radius"
--[[Translation missing --]]
L["Ragnaros"] = "Ragnaros"
--[[Translation missing --]]
L["Raid"] = "Raid"
--[[Translation missing --]]
L["Raid (Heroic)"] = "Raid (Heroic)"
--[[Translation missing --]]
L["Raid (Mythic)"] = "Raid (Mythic)"
--[[Translation missing --]]
L["Raid (Normal)"] = "Raid (Normal)"
--[[Translation missing --]]
L["Raid (Timewalking)"] = "Raid (Timewalking)"
--[[Translation missing --]]
L["Raid Mark"] = "Raid Mark"
--[[Translation missing --]]
L["Raid Mark Icon"] = "Raid Mark Icon"
--[[Translation missing --]]
L["Raid Role"] = "Raid Role"
--[[Translation missing --]]
L["Raid Warning"] = "Raid Warning"
--[[Translation missing --]]
L["Raids"] = "Raids"
--[[Translation missing --]]
L["Range"] = "Range"
--[[Translation missing --]]
L["Range Check"] = "Range Check"
--[[Translation missing --]]
L["Ranged"] = "Ranged"
--[[Translation missing --]]
L["Rank"] = "Rank"
--[[Translation missing --]]
L["Rare"] = "Rare"
--[[Translation missing --]]
L["Rare Elite"] = "Rare Elite"
--[[Translation missing --]]
L["Rated Arena"] = "Rated Arena"
--[[Translation missing --]]
L["Rated Battleground"] = "Rated Battleground"
--[[Translation missing --]]
L["Raw Threat Percent"] = "Raw Threat Percent"
--[[Translation missing --]]
L["Razorgore the Untamed"] = "Razorgore the Untamed"
--[[Translation missing --]]
L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
L["Reagent Quality"] = "Reagent Quality"
--[[Translation missing --]]
L["Reagent Quality Texture"] = "Reagent Quality Texture"
--[[Translation missing --]]
L["Realm"] = "Realm"
--[[Translation missing --]]
L["Realm Name"] = "Realm Name"
--[[Translation missing --]]
L["Realm of Caster's Target"] = "Realm of Caster's Target"
--[[Translation missing --]]
L["Reborn Council"] = "Reborn Council"
--[[Translation missing --]]
L["Receiving %s Bytes"] = "Receiving %s Bytes"
--[[Translation missing --]]
L["Receiving display information"] = "Receiving display information"
--[[Translation missing --]]
L["Reflect"] = "Reflect"
--[[Translation missing --]]
L["Region type %s not supported"] = "Region type %s not supported"
--[[Translation missing --]]
L["Relative"] = "Relative"
--[[Translation missing --]]
L["Relative X-Offset"] = "Relative X-Offset"
--[[Translation missing --]]
L["Relative Y-Offset"] = "Relative Y-Offset"
--[[Translation missing --]]
L["Remaining Duration"] = "Remaining Duration"
--[[Translation missing --]]
L["Remaining Time"] = "Remaining Time"
--[[Translation missing --]]
L["Remove Obsolete Auras"] = "Remove Obsolete Auras"
--[[Translation missing --]]
L["Renown Level"] = "Renown Level"
--[[Translation missing --]]
L["Renown Max Level"] = "Renown Max Level"
--[[Translation missing --]]
L["Renown Reputation"] = "Renown Reputation"
--[[Translation missing --]]
L["Repair"] = "Repair"
--[[Translation missing --]]
L["Repeat"] = "Repeat"
--[[Translation missing --]]
L["Report Summary"] = "Report Summary"
--[[Translation missing --]]
L["Reputation"] = "Reputation"
--[[Translation missing --]]
L["Reputation (%)"] = "Reputation (%)"
--[[Translation missing --]]
L["Requested display does not exist"] = "Requested display does not exist"
--[[Translation missing --]]
L["Requested display not authorized"] = "Requested display not authorized"
--[[Translation missing --]]
L["Requesting display information from %s ..."] = "Requesting display information from %s ..."
--[[Translation missing --]]
L["Require Valid Target"] = "Require Valid Target"
--[[Translation missing --]]
L["Requires syncing the specialization via LibSpecialization."] = "Requires syncing the specialization via LibSpecialization."
--[[Translation missing --]]
L["Resilience (%)"] = "Resilience (%)"
--[[Translation missing --]]
L["Resilience Rating"] = "Resilience Rating"
--[[Translation missing --]]
L["Resist"] = "Resist"
--[[Translation missing --]]
L["Resistances"] = "Resistances"
--[[Translation missing --]]
L["Resisted"] = "Resisted"
--[[Translation missing --]]
L["Rested"] = "Rested"
--[[Translation missing --]]
L["Rested Experience"] = "Rested Experience"
--[[Translation missing --]]
L["Rested Experience (%)"] = "Rested Experience (%)"
--[[Translation missing --]]
L["Resting"] = "Resting"
--[[Translation missing --]]
L["Resurrect"] = "Resurrect"
--[[Translation missing --]]
L["Resurrect Pending"] = "Resurrect Pending"
--[[Translation missing --]]
L["Right"] = "Right"
--[[Translation missing --]]
L["Right to Left"] = "Right to Left"
--[[Translation missing --]]
L["Right, then Centered Vertical"] = "Right, then Centered Vertical"
--[[Translation missing --]]
L["Right, then Down"] = "Right, then Down"
--[[Translation missing --]]
L["Right, then Up"] = "Right, then Up"
--[[Translation missing --]]
L["Role"] = "Role"
--[[Translation missing --]]
L["Rollback snapshot is complete. Thank you for your patience!"] = "Rollback snapshot is complete. Thank you for your patience!"
--[[Translation missing --]]
L["Rotate Animation"] = "Rotate Animation"
--[[Translation missing --]]
L["Rotate Left"] = "Rotate Left"
--[[Translation missing --]]
L["Rotate Right"] = "Rotate Right"
--[[Translation missing --]]
L["Rotation"] = "Rotation"
--[[Translation missing --]]
L["Round"] = "Round"
--[[Translation missing --]]
L["Round Mode"] = "Round Mode"
--[[Translation missing --]]
L["Ruins of Ahn'Qiraj"] = "Ruins of Ahn'Qiraj"
--[[Translation missing --]]
L["Run Custom Code"] = "Run Custom Code"
--[[Translation missing --]]
L["Run Speed (%)"] = "Run Speed (%)"
--[[Translation missing --]]
L["Rune"] = "Rune"
--[[Translation missing --]]
L["Rune #1"] = "Rune #1"
--[[Translation missing --]]
L["Rune #2"] = "Rune #2"
--[[Translation missing --]]
L["Rune #3"] = "Rune #3"
--[[Translation missing --]]
L["Rune #4"] = "Rune #4"
--[[Translation missing --]]
L["Rune #5"] = "Rune #5"
--[[Translation missing --]]
L["Rune #6"] = "Rune #6"
--[[Translation missing --]]
L["Rune Count"] = "Rune Count"
--[[Translation missing --]]
L["Rune Count - Blood"] = "Rune Count - Blood"
--[[Translation missing --]]
L["Rune Count - Frost"] = "Rune Count - Frost"
--[[Translation missing --]]
L["Rune Count - Unholy"] = "Rune Count - Unholy"
--[[Translation missing --]]
L["Sapphiron"] = "Sapphiron"
--[[Translation missing --]]
L["Say"] = "Say"
--[[Translation missing --]]
L["Scale"] = "Scale"
--[[Translation missing --]]
L["Scarlet Enclave"] = "Scarlet Enclave"
--[[Translation missing --]]
L["Scenario"] = "Scenario"
--[[Translation missing --]]
L["Scenario (Heroic)"] = "Scenario (Heroic)"
--[[Translation missing --]]
L["Scenario (Normal)"] = "Scenario (Normal)"
--[[Translation missing --]]
L["Screen"] = "Screen"
--[[Translation missing --]]
L["Screen/Parent Group"] = "Screen/Parent Group"
--[[Translation missing --]]
L["Season of Discovery"] = "Season of Discovery"
--[[Translation missing --]]
L["Second"] = "Second"
--[[Translation missing --]]
L["Second Value of Tooltip Text"] = "Second Value of Tooltip Text"
--[[Translation missing --]]
L["Secondary Stats"] = "Secondary Stats"
--[[Translation missing --]]
L["Seconds"] = "Seconds"
--[[Translation missing --]]
L[ [=[Secure frame detected. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = [=[Secure frame detected. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=]
--[[Translation missing --]]
L["Select Frame"] = "Select Frame"
--[[Translation missing --]]
L["Select the type of timer to filter"] = "Select the type of timer to filter"
--[[Translation missing --]]
L["Selection Mode"] = "Selection Mode"
--[[Translation missing --]]
L["Separator"] = "Separator"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/cata/item-sets"] = "Set IDs can be found on websites such as wowhead.com/cata/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/classic/item-sets"] = "Set IDs can be found on websites such as wowhead.com/classic/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/item-sets"] = "Set IDs can be found on websites such as wowhead.com/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"] = "Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"
--[[Translation missing --]]
L["Shadow Resistance"] = "Shadow Resistance"
--[[Translation missing --]]
L["Shadowlands"] = "Shadowlands"
--[[Translation missing --]]
L["Shake"] = "Shake"
--[[Translation missing --]]
L["Shazzrah"] = "Shazzrah"
--[[Translation missing --]]
L["Shift-Click to resume addon execution."] = "Shift-Click to resume addon execution."
--[[Translation missing --]]
L["Show"] = "Show"
--[[Translation missing --]]
L["Show CD of Charge"] = "Show CD of Charge"
--[[Translation missing --]]
L["Show charged duration for empowered casts"] = "Show charged duration for empowered casts"
--[[Translation missing --]]
L["Show GCD"] = "Show GCD"
--[[Translation missing --]]
L["Show Global Cooldown"] = "Show Global Cooldown"
--[[Translation missing --]]
L["Show Incoming Heal"] = "Show Incoming Heal"
--[[Translation missing --]]
L["Show Loss of Control"] = "Show Loss of Control"
--[[Translation missing --]]
L["Show On"] = "Show On"
--[[Translation missing --]]
L["Show Rested Overlay"] = "Show Rested Overlay"
--[[Translation missing --]]
L["Shrink"] = "Shrink"
--[[Translation missing --]]
L["Silithid Royalty"] = "Silithid Royalty"
--[[Translation missing --]]
L["Silver"] = "Silver"
--[[Translation missing --]]
L["Simple"] = "Simple"
--[[Translation missing --]]
L["Since Active"] = "Since Active"
--[[Translation missing --]]
L["Since Apply"] = "Since Apply"
--[[Translation missing --]]
L["Since Apply/Refresh"] = "Since Apply/Refresh"
--[[Translation missing --]]
L["Since Charge Gain"] = "Since Charge Gain"
--[[Translation missing --]]
L["Since Charge Lost"] = "Since Charge Lost"
--[[Translation missing --]]
L["Since Ready"] = "Since Ready"
--[[Translation missing --]]
L["Since Stack Gain"] = "Since Stack Gain"
--[[Translation missing --]]
L["Since Stack Lost"] = "Since Stack Lost"
--[[Translation missing --]]
L["Size & Position"] = "Size & Position"
--[[Translation missing --]]
L["Skyriding"] = "Skyriding"
--[[Translation missing --]]
L["Slide Animation"] = "Slide Animation"
--[[Translation missing --]]
L["Slide from Bottom"] = "Slide from Bottom"
--[[Translation missing --]]
L["Slide from Left"] = "Slide from Left"
--[[Translation missing --]]
L["Slide from Right"] = "Slide from Right"
--[[Translation missing --]]
L["Slide from Top"] = "Slide from Top"
--[[Translation missing --]]
L["Slide to Bottom"] = "Slide to Bottom"
--[[Translation missing --]]
L["Slide to Left"] = "Slide to Left"
--[[Translation missing --]]
L["Slide to Right"] = "Slide to Right"
--[[Translation missing --]]
L["Slide to Top"] = "Slide to Top"
--[[Translation missing --]]
L["Slider"] = "Slider"
--[[Translation missing --]]
L["Small"] = "Small"
--[[Translation missing --]]
L["Smart Group"] = "Smart Group"
--[[Translation missing --]]
L["Soft Enemy"] = "Soft Enemy"
--[[Translation missing --]]
L["Soft Friend"] = "Soft Friend"
--[[Translation missing --]]
L["Solistrasza"] = "Solistrasza"
--[[Translation missing --]]
L["Sound"] = "Sound"
--[[Translation missing --]]
L["Sound by Kit ID"] = "Sound by Kit ID"
--[[Translation missing --]]
L["Source"] = "Source"
--[[Translation missing --]]
L["Source Affiliation"] = "Source Affiliation"
--[[Translation missing --]]
L["Source GUID"] = "Source GUID"
--[[Translation missing --]]
L["Source Info"] = "Source Info"
--[[Translation missing --]]
L["Source Name"] = "Source Name"
--[[Translation missing --]]
L["Source NPC Id"] = "Source NPC Id"
--[[Translation missing --]]
L["Source Object Type"] = "Source Object Type"
--[[Translation missing --]]
L["Source Raid Mark"] = "Source Raid Mark"
--[[Translation missing --]]
L["Source Reaction"] = "Source Reaction"
--[[Translation missing --]]
L["Source Unit"] = "Source Unit"
--[[Translation missing --]]
L["Source Unit Name/Realm"] = "Source Unit Name/Realm"
--[[Translation missing --]]
L["Source unit's raid mark index"] = "Source unit's raid mark index"
--[[Translation missing --]]
L["Source unit's raid mark texture"] = "Source unit's raid mark texture"
--[[Translation missing --]]
L["Space"] = "Space"
--[[Translation missing --]]
L["Spacing"] = "Spacing"
--[[Translation missing --]]
L["Spark"] = "Spark"
--[[Translation missing --]]
L["Spec Position"] = "Spec Position"
--[[Translation missing --]]
L["Spec Role"] = "Spec Role"
--[[Translation missing --]]
L["Specialization"] = "Specialization"
--[[Translation missing --]]
L["Specific Currency"] = "Specific Currency"
--[[Translation missing --]]
L["Specific Type"] = "Specific Type"
--[[Translation missing --]]
L["Specific Unit"] = "Specific Unit"
--[[Translation missing --]]
L["Spell"] = "Spell"
--[[Translation missing --]]
L["Spell (Building)"] = "Spell (Building)"
--[[Translation missing --]]
L["Spell Activation Overlay Glow"] = "Spell Activation Overlay Glow"
--[[Translation missing --]]
L["Spell Cast Succeeded"] = "Spell Cast Succeeded"
--[[Translation missing --]]
L["Spell Cost"] = "Spell Cost"
--[[Translation missing --]]
L["Spell Count"] = "Spell Count"
--[[Translation missing --]]
L["Spell ID"] = "Spell ID"
--[[Translation missing --]]
L["Spell Id"] = "Spell Id"
--[[Translation missing --]]
L["Spell ID:"] = "Spell ID:"
--[[Translation missing --]]
L["Spell IDs:"] = "Spell IDs:"
--[[Translation missing --]]
L["Spell in Range"] = "Spell in Range"
--[[Translation missing --]]
L["Spell Known"] = "Spell Known"
--[[Translation missing --]]
L["Spell Name"] = "Spell Name"
--[[Translation missing --]]
L["Spell Peneration Percent"] = "Spell Peneration Percent"
--[[Translation missing --]]
L["Spell Power"] = "Spell Power"
--[[Translation missing --]]
L["Spell School"] = "Spell School"
--[[Translation missing --]]
L["Spell Usable"] = "Spell Usable"
--[[Translation missing --]]
L["Spellname"] = "Spellname"
--[[Translation missing --]]
L["Spike"] = "Spike"
--[[Translation missing --]]
L["Spin"] = "Spin"
--[[Translation missing --]]
L["Spiral"] = "Spiral"
--[[Translation missing --]]
L["Spiral In And Out"] = "Spiral In And Out"
--[[Translation missing --]]
L["Spirit"] = "Spirit"
--[[Translation missing --]]
L["Stack Count"] = "Stack Count"
--[[Translation missing --]]
L["Stack trace:"] = "Stack trace:"
--[[Translation missing --]]
L["Stacks"] = "Stacks"
--[[Translation missing --]]
L["Stacks Function"] = "Stacks Function"
--[[Translation missing --]]
L["Stacks Function (fallback state)"] = "Stacks Function (fallback state)"
--[[Translation missing --]]
L["Stage"] = "Stage"
--[[Translation missing --]]
L["Stage Counter"] = "Stage Counter"
--[[Translation missing --]]
L["Stagger"] = "Stagger"
--[[Translation missing --]]
L["Stagger (%)"] = "Stagger (%)"
--[[Translation missing --]]
L["Stagger against Target (%)"] = "Stagger against Target (%)"
--[[Translation missing --]]
L["Stagger Scale"] = "Stagger Scale"
--[[Translation missing --]]
L["Stamina"] = "Stamina"
--[[Translation missing --]]
L["Stance/Form/Aura"] = "Stance/Form/Aura"
--[[Translation missing --]]
L["Standing"] = "Standing"
--[[Translation missing --]]
L["Star Shake"] = "Star Shake"
--[[Translation missing --]]
L["Start Animation"] = "Start Animation"
--[[Translation missing --]]
L["Start Now"] = "Start Now"
--[[Translation missing --]]
L["Start Profiling"] = "Start Profiling"
--[[Translation missing --]]
L["Status"] = "Status"
--[[Translation missing --]]
L["Status Bar"] = "Status Bar"
--[[Translation missing --]]
L["Stolen"] = "Stolen"
--[[Translation missing --]]
L["Stop"] = "Stop"
--[[Translation missing --]]
L["Stop Motion"] = "Stop Motion"
--[[Translation missing --]]
L["Story Raid"] = "Story Raid"
--[[Translation missing --]]
L["Strength"] = "Strength"
--[[Translation missing --]]
L["String"] = "String"
--[[Translation missing --]]
L["Subevent Info"] = "Subevent Info"
--[[Translation missing --]]
L["Subtract Cast"] = "Subtract Cast"
--[[Translation missing --]]
L["Subtract Channel"] = "Subtract Channel"
--[[Translation missing --]]
L["Subtract GCD"] = "Subtract GCD"
--[[Translation missing --]]
L["Subzone Name"] = "Subzone Name"
--[[Translation missing --]]
L["Success"] = "Success"
--[[Translation missing --]]
L["Sulfuron Harbinger"] = "Sulfuron Harbinger"
--[[Translation missing --]]
L["Summon"] = "Summon"
--[[Translation missing --]]
L["Summon Pending"] = "Summon Pending"
--[[Translation missing --]]
L["Sun"] = "Sun"
--[[Translation missing --]]
L["Supports multiple entries, separated by commas"] = "Supports multiple entries, separated by commas"
--[[Translation missing --]]
L[ [=[Supports multiple entries, separated by commas
]=] ] = [=[Supports multiple entries, separated by commas
]=]
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Prefix with '-' for negation."
--[[Translation missing --]]
L[ [=[Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.
Group Zone IDs must be prefixed with 'g', e.g. 'g277'.
Supports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.
Supports Instance IDs prefixed with 'i'.
Entries can be prefixed with '-' to negate.]=] ] = [=[Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.
Group Zone IDs must be prefixed with 'g', e.g. 'g277'.
Supports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.
Supports Instance IDs prefixed with 'i'.
Entries can be prefixed with '-' to negate.]=]
--[[Translation missing --]]
L["Swing"] = "Swing"
--[[Translation missing --]]
L["Swing Timer"] = "Swing Timer"
--[[Translation missing --]]
L["Swipe"] = "Swipe"
--[[Translation missing --]]
L["Syntax /wa feature <toggle|on|enable|disable|off> <feature>"] = "Syntax /wa feature <toggle|on|enable|disable|off> <feature>"
--[[Translation missing --]]
L["System"] = "System"
--[[Translation missing --]]
L["Systems"] = "Systems"
--[[Translation missing --]]
L["Tab "] = "Tab "
--[[Translation missing --]]
L["Talent"] = "Talent"
--[[Translation missing --]]
L["Talent |cFFFF0000Not|r Known"] = "Talent |cFFFF0000Not|r Known"
--[[Translation missing --]]
L["Talent |cFFFF0000Not|r Selected"] = "Talent |cFFFF0000Not|r Selected"
--[[Translation missing --]]
L["Talent Known"] = "Talent Known"
--[[Translation missing --]]
L["Talent Selected"] = "Talent Selected"
--[[Translation missing --]]
L["Talent selected"] = "Talent selected"
--[[Translation missing --]]
L["Talent Specialization"] = "Talent Specialization"
--[[Translation missing --]]
L["Tanking And Highest"] = "Tanking And Highest"
--[[Translation missing --]]
L["Tanking But Not Highest"] = "Tanking But Not Highest"
--[[Translation missing --]]
L["Target"] = "Target"
--[[Translation missing --]]
L["Targeted"] = "Targeted"
--[[Translation missing --]]
L["Tertiary Stats"] = "Tertiary Stats"
--[[Translation missing --]]
L["Test if bar is enabled in BigWigs settings"] = "Test if bar is enabled in BigWigs settings"
--[[Translation missing --]]
L["Test if bar is enabled in Boss Mod addon settings"] = "Test if bar is enabled in Boss Mod addon settings"
--[[Translation missing --]]
L["Test if bar is enabled in DBM settings"] = "Test if bar is enabled in DBM settings"
--[[Translation missing --]]
L["Text"] = "Text"
--[[Translation missing --]]
L["Text To Speech"] = "Text To Speech"
--[[Translation missing --]]
L["Text-to-speech"] = "Text-to-speech"
--[[Translation missing --]]
L["Texture"] = "Texture"
--[[Translation missing --]]
L["Texture Function"] = "Texture Function"
--[[Translation missing --]]
L["Texture Function (fallback state)"] = "Texture Function (fallback state)"
--[[Translation missing --]]
L["Texture Picker"] = "Texture Picker"
--[[Translation missing --]]
L["Texture Rotation"] = "Texture Rotation"
--[[Translation missing --]]
L["Thaddius"] = "Thaddius"
--[[Translation missing --]]
L["The aura has overwritten the global '%s', this might affect other auras."] = "The aura has overwritten the global '%s', this might affect other auras."
--[[Translation missing --]]
L["The aura tried to overwrite the aura_env global, which is not allowed."] = "The aura tried to overwrite the aura_env global, which is not allowed."
--[[Translation missing --]]
L["The effective level differs from the level in e.g. Time Walking dungeons."] = "The effective level differs from the level in e.g. Time Walking dungeons."
--[[Translation missing --]]
L["The Four Horsemen"] = "The Four Horsemen"
--[[Translation missing --]]
L["The 'ID' value can be found in the BigWigs options of a specific spell"] = "The 'ID' value can be found in the BigWigs options of a specific spell"
--[[Translation missing --]]
L["The Prophet Skeram"] = "The Prophet Skeram"
--[[Translation missing --]]
L["The total quantity a warband character can transfer after paying the transfer cost"] = "The total quantity a warband character can transfer after paying the transfer cost"
--[[Translation missing --]]
L["The total quantity after transferring everything to your current character and paying the transfer cost"] = "The total quantity after transferring everything to your current character and paying the transfer cost"
--[[Translation missing --]]
L["The War Within"] = "The War Within"
--[[Translation missing --]]
L["There are %i updates to your auras ready to be installed!"] = "There are %i updates to your auras ready to be installed!"
--[[Translation missing --]]
L["Thick Outline"] = "Thick Outline"
--[[Translation missing --]]
L["Thickness"] = "Thickness"
--[[Translation missing --]]
L["Third"] = "Third"
--[[Translation missing --]]
L["Third Value of Tooltip Text"] = "Third Value of Tooltip Text"
--[[Translation missing --]]
L["This aura calls GetData a lot, which is a slow function."] = "This aura calls GetData a lot, which is a slow function."
--[[Translation missing --]]
L["This aura has caused a Lua error."] = "This aura has caused a Lua error."
--[[Translation missing --]]
L["This aura is saving %s KB of data"] = "This aura is saving %s KB of data"
--[[Translation missing --]]
L["This aura plays a sound via a condition."] = "This aura plays a sound via a condition."
--[[Translation missing --]]
L["This aura plays a sound via an action."] = "This aura plays a sound via an action."
--[[Translation missing --]]
L["This aura plays a Text To Speech via a condition."] = "This aura plays a Text To Speech via a condition."
--[[Translation missing --]]
L["This aura plays a Text To Speech via an action."] = "This aura plays a Text To Speech via an action."
--[[Translation missing --]]
L["This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."] = "This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."
--[[Translation missing --]]
L["Threat Percent"] = "Threat Percent"
--[[Translation missing --]]
L["Threat Situation"] = "Threat Situation"
--[[Translation missing --]]
L["Threat Value"] = "Threat Value"
--[[Translation missing --]]
L["Tick"] = "Tick"
--[[Translation missing --]]
L["Time"] = "Time"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time in GCDs"] = "Time in GCDs"
--[[Translation missing --]]
L["Time since initial application"] = "Time since initial application"
--[[Translation missing --]]
L["Time since last refresh"] = "Time since last refresh"
--[[Translation missing --]]
L["Time since stack gain"] = "Time since stack gain"
--[[Translation missing --]]
L["Time since stack lost"] = "Time since stack lost"
--[[Translation missing --]]
L["Timed"] = "Timed"
--[[Translation missing --]]
L["Timed Progress"] = "Timed Progress"
--[[Translation missing --]]
L["Timer"] = "Timer"
--[[Translation missing --]]
L["Timer Id"] = "Timer Id"
--[[Translation missing --]]
L["Toggle"] = "Toggle"
--[[Translation missing --]]
L["Toggle List"] = "Toggle List"
--[[Translation missing --]]
L["Toggle Options Window"] = "Toggle Options Window"
--[[Translation missing --]]
L["Toggle Performance Profiling Window"] = "Toggle Performance Profiling Window"
--[[Translation missing --]]
L["Tooltip"] = "Tooltip"
--[[Translation missing --]]
L["Tooltip 1"] = "Tooltip 1"
--[[Translation missing --]]
L["Tooltip 2"] = "Tooltip 2"
--[[Translation missing --]]
L["Tooltip 3"] = "Tooltip 3"
--[[Translation missing --]]
L["Tooltip Value 1"] = "Tooltip Value 1"
--[[Translation missing --]]
L["Tooltip Value 2"] = "Tooltip Value 2"
--[[Translation missing --]]
L["Tooltip Value 3"] = "Tooltip Value 3"
--[[Translation missing --]]
L["Tooltip Value 4"] = "Tooltip Value 4"
--[[Translation missing --]]
L["Top"] = "Top"
--[[Translation missing --]]
L["Top Left"] = "Top Left"
--[[Translation missing --]]
L["Top Right"] = "Top Right"
--[[Translation missing --]]
L["Top to Bottom"] = "Top to Bottom"
--[[Translation missing --]]
L["Torghast"] = "Torghast"
--[[Translation missing --]]
L["Total Duration"] = "Total Duration"
--[[Translation missing --]]
L["Total Earned in this Season"] = "Total Earned in this Season"
--[[Translation missing --]]
L["Total Essence"] = "Total Essence"
--[[Translation missing --]]
L["Total Experience"] = "Total Experience"
--[[Translation missing --]]
L["Total Match Count"] = "Total Match Count"
--[[Translation missing --]]
L["Total Reputation"] = "Total Reputation"
--[[Translation missing --]]
L["Total Stacks"] = "Total Stacks"
--[[Translation missing --]]
L["Total stacks over all matches"] = "Total stacks over all matches"
--[[Translation missing --]]
L["Total Stages"] = "Total Stages"
--[[Translation missing --]]
L["Total Unit Count"] = "Total Unit Count"
--[[Translation missing --]]
L["Total Units"] = "Total Units"
--[[Translation missing --]]
L["Totem"] = "Totem"
--[[Translation missing --]]
L["Totem #%i"] = "Totem #%i"
--[[Translation missing --]]
L["Totem Icon"] = "Totem Icon"
--[[Translation missing --]]
L["Totem Name"] = "Totem Name"
--[[Translation missing --]]
L["Totem Name Pattern Match"] = "Totem Name Pattern Match"
--[[Translation missing --]]
L["Totem Number"] = "Totem Number"
--[[Translation missing --]]
L["Track Cooldowns"] = "Track Cooldowns"
--[[Translation missing --]]
L["Tracking Charge %i"] = "Tracking Charge %i"
--[[Translation missing --]]
L["Tracking Charge CDs"] = "Tracking Charge CDs"
--[[Translation missing --]]
L["Tracking Only Cooldown"] = "Tracking Only Cooldown"
--[[Translation missing --]]
L["Transmission error"] = "Transmission error"
--[[Translation missing --]]
L["Trigger"] = "Trigger"
--[[Translation missing --]]
L["Trigger %i"] = "Trigger %i"
--[[Translation missing --]]
L["Trigger %s"] = "Trigger %s"
--[[Translation missing --]]
L["Trigger 1"] = "Trigger 1"
--[[Translation missing --]]
L["Trigger State Updater (Advanced)"] = "Trigger State Updater (Advanced)"
--[[Translation missing --]]
L["Trigger Update"] = "Trigger Update"
--[[Translation missing --]]
L["Trigger:"] = "Trigger:"
--[[Translation missing --]]
L["Trivial (Low Level)"] = "Trivial (Low Level)"
--[[Translation missing --]]
L["True"] = "True"
--[[Translation missing --]]
L["Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."] = "Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."
--[[Translation missing --]]
L["Twin Emperors"] = "Twin Emperors"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."] = "Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."
--[[Translation missing --]]
L["Unaffected"] = "Unaffected"
--[[Translation missing --]]
L["Undefined"] = "Undefined"
--[[Translation missing --]]
L["Unholy"] = "Unholy"
--[[Translation missing --]]
L["Unholy Rune #1"] = "Unholy Rune #1"
--[[Translation missing --]]
L["Unholy Rune #2"] = "Unholy Rune #2"
--[[Translation missing --]]
L["Unit"] = "Unit"
--[[Translation missing --]]
L["Unit Characteristics"] = "Unit Characteristics"
--[[Translation missing --]]
L["Unit Destroyed"] = "Unit Destroyed"
--[[Translation missing --]]
L["Unit Died"] = "Unit Died"
--[[Translation missing --]]
L["Unit Dissipates"] = "Unit Dissipates"
--[[Translation missing --]]
L["Unit Frame"] = "Unit Frame"
--[[Translation missing --]]
L["Unit Frames"] = "Unit Frames"
--[[Translation missing --]]
L["Unit is Unit"] = "Unit is Unit"
--[[Translation missing --]]
L["Unit Name"] = "Unit Name"
--[[Translation missing --]]
L["Unit Name/Realm"] = "Unit Name/Realm"
--[[Translation missing --]]
L["Units Affected"] = "Units Affected"
--[[Translation missing --]]
L["Units of affected Players in a table format"] = "Units of affected Players in a table format"
--[[Translation missing --]]
L["Units of unaffected Players in a table format"] = "Units of unaffected Players in a table format"
--[[Translation missing --]]
L["Unknown action %q"] = "Unknown action %q"
--[[Translation missing --]]
L["Unknown feature %q"] = "Unknown feature %q"
--[[Translation missing --]]
L["unknown location"] = "unknown location"
--[[Translation missing --]]
L["Unlimited"] = "Unlimited"
--[[Translation missing --]]
L["Untrigger %s"] = "Untrigger %s"
--[[Translation missing --]]
L["Up"] = "Up"
--[[Translation missing --]]
L["Up, then Centered Horizontal"] = "Up, then Centered Horizontal"
--[[Translation missing --]]
L["Up, then Left"] = "Up, then Left"
--[[Translation missing --]]
L["Up, then Right"] = "Up, then Right"
--[[Translation missing --]]
L["Update Position"] = "Update Position"
--[[Translation missing --]]
L["Usage:"] = "Usage:"
--[[Translation missing --]]
L["Use /wa minimap to show the minimap icon again."] = "Use /wa minimap to show the minimap icon again."
--[[Translation missing --]]
L["Use Custom Color"] = "Use Custom Color"
--[[Translation missing --]]
L["Use Legacy floor rounding"] = "Use Legacy floor rounding"
--[[Translation missing --]]
L["Use Texture"] = "Use Texture"
--[[Translation missing --]]
L["Use Watched Faction"] = "Use Watched Faction"
--[[Translation missing --]]
L["Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."] = "Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."
--[[Translation missing --]]
L["Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."] = "Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."
--[[Translation missing --]]
L["Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."] = "Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."
--[[Translation missing --]]
L["Vaelastrasz the Corrupt"] = "Vaelastrasz the Corrupt"
--[[Translation missing --]]
L["Versatility (%)"] = "Versatility (%)"
--[[Translation missing --]]
L["Versatility Rating"] = "Versatility Rating"
--[[Translation missing --]]
L["Vertical"] = "Vertical"
--[[Translation missing --]]
L["Viscidus"] = "Viscidus"
--[[Translation missing --]]
L["Visibility"] = "Visibility"
--[[Translation missing --]]
L["Visions of N'Zoth"] = "Visions of N'Zoth"
--[[Translation missing --]]
L["Warband Quantity Total"] = "Warband Quantity Total"
--[[Translation missing --]]
L["Warband Transfer Percentage"] = "Warband Transfer Percentage"
--[[Translation missing --]]
L["Warband Transferred Quantity"] = "Warband Transferred Quantity"
--[[Translation missing --]]
L["Warfront (Heroic)"] = "Warfront (Heroic)"
--[[Translation missing --]]
L["Warfront (Normal)"] = "Warfront (Normal)"
--[[Translation missing --]]
L["Warlords of Draenor"] = "Warlords of Draenor"
--[[Translation missing --]]
L["Warning"] = "Warning"
--[[Translation missing --]]
L["Warning for unknown aura:"] = "Warning for unknown aura:"
--[[Translation missing --]]
L["Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"] = "Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"
--[[Translation missing --]]
L["Warning: Full Scan auras checking for both name and spell id can't be converted."] = "Warning: Full Scan auras checking for both name and spell id can't be converted."
--[[Translation missing --]]
L["Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."] = "Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."
--[[Translation missing --]]
L["Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."] = "Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."
--[[Translation missing --]]
L["KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"] = "KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"
--[[Translation missing --]]
--[[Translation missing --]]
L[ [=[KUIAR_Runtime has detected that it has been downgraded.
Your saved auras may no longer work properly.
Would you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s

|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r]=] ] = [=[KUIAR_Runtime has detected that it has been downgraded.
Your saved auras may no longer work properly.
Would you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s

|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r]=]
--[[Translation missing --]]
L["KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."] = "KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."
--[[Translation missing --]]
L["KUIAR_Engine Profiling"] = "KUIAR_Engine Profiling"
--[[Translation missing --]]
L["KUIAR_Engine Profiling Report"] = "KUIAR_Engine Profiling Report"
--[[Translation missing --]]
L["KUIAR_Engine Version: %s"] = "KUIAR_Engine Version: %s"
--[[Translation missing --]]
L["Weapon"] = "Weapon"
--[[Translation missing --]]
L["Weapon Enchant"] = "Weapon Enchant"
--[[Translation missing --]]
L["Weapon Enchant / Fishing Lure"] = "Weapon Enchant / Fishing Lure"
--[[Translation missing --]]
L["Whisper"] = "Whisper"
--[[Translation missing --]]
L["Width"] = "Width"
--[[Translation missing --]]
L["Wobble"] = "Wobble"
--[[Translation missing --]]
L["World Boss"] = "World Boss"
--[[Translation missing --]]
L["World Bosses"] = "World Bosses"
--[[Translation missing --]]
L["Wrap"] = "Wrap"
--[[Translation missing --]]
L["Wrath of the Lich King"] = "Wrath of the Lich King"
--[[Translation missing --]]
L["Writing to the KUIAR_Engine table is not allowed."] = "Writing to the KUIAR_Engine table is not allowed."
--[[Translation missing --]]
L["X-Offset"] = "X-Offset"
--[[Translation missing --]]
L["Yell"] = "Yell"
--[[Translation missing --]]
L["Y-Offset"] = "Y-Offset"
--[[Translation missing --]]
L["You have new auras ready to be installed!"] = "You have new auras ready to be installed!"
--[[Translation missing --]]
L["Your next encounter will automatically be profiled."] = "Your next encounter will automatically be profiled."
--[[Translation missing --]]
L["Your next instance of combat will automatically be profiled."] = "Your next instance of combat will automatically be profiled."
--[[Translation missing --]]
L["Your scheduled automatic profile has been cancelled."] = "Your scheduled automatic profile has been cancelled."
--[[Translation missing --]]
L["Your threat as a percentage of the tank's current threat."] = "Your threat as a percentage of the tank's current threat."
--[[Translation missing --]]
L["Your threat on the mob as a percentage of the amount required to pull aggro. Will pull aggro at 100."] = "Your threat on the mob as a percentage of the amount required to pull aggro. Will pull aggro at 100."
--[[Translation missing --]]
L["Your total threat on the mob."] = "Your total threat on the mob."
--[[Translation missing --]]
L["Zone Group ID"] = "Zone Group ID"
--[[Translation missing --]]
L["Zone ID"] = "Zone ID"
--[[Translation missing --]]
L["Zone Name"] = "Zone Name"
--[[Translation missing --]]
L["Zoom"] = "Zoom"
--[[Translation missing --]]
L["Zoom Animation"] = "Zoom Animation"
--[[Translation missing --]]
L["Zul'Gurub"] = "Zul'Gurub"

-- KUI: translations added for strings upstream leaves in English (2026-11-12).
L[" Filter formats: 'Name', 'Name-Realm', '-Realm'.\n\nSupports multiple entries, separated by commas\nCan use \\ to escape -."] = " Formati del filtro: 'Nome', 'Nome-Reame', '-Reame'.\n\nSupporta più voci, separate da virgole\nUsa \\ per l'escape di -."
L["|cffff0000deprecated|r"] = "|cffff0000obsoleto|r"
L["|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r\nCOMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.\nFind more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events"] = "|cFFFF0000Il supporto per COMBAT_LOG_EVENT_UNFILTERED non filtrato è obsoleto|r\nCOMBAT_LOG_EVENT_UNFILTERED senza filtro è disattivato perché pesa molto sulle prestazioni.\nMaggiori informazioni:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events"
L["A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."] = "Un'attivazione di quest'aura è impostata per seguire un'unità bersaglio morbido, ma i CVar necessari non sono configurati correttamente. Cambia l'unità seguita oppure configura i CVar del bersaglio morbido."
L["Absorb and Healing"] = "Assorbimento e cure"
L["Absorb Overlay"] = "Overlay assorbimento"
L["Afk"] = "Assente"
L["All States table contains a non table at key: '%s'."] = "La tabella All States contiene un valore non tabella alla chiave: '%s'."
L["Armor Peneration Percent"] = "Percentuale di penetrazione armatura"
L["Armor Peneration Rating"] = "Valutazione di penetrazione armatura"
L["Assist"] = "Assisti"
L["Assisted Combat Next Cast"] = "Prossimo lancio del combattimento assistito"
L["Attach to End, backwards"] = "Aggancia alla fine, all'indietro"
L["Attach to Point"] = "Aggancia al punto"
L["Aura Stack"] = "Cariche dell'aura"
L["Autocast Shine"] = "Scintilla di lancio automatico"
L["Bar enabled in BigWigs settings"] = "Barra abilitata nelle impostazioni di BigWigs"
L["Bar enabled in Boss Mod addon settings"] = "Barra abilitata nelle impostazioni dell'addon Boss Mod"
L["Bar enabled in DBM settings"] = "Barra abilitata nelle impostazioni di DBM"
L["Bar Texture"] = "Texture barra"
L["Bar Type"] = "Tipo di barra"
L["Beastmaster"] = "Cacciatore - Maestro delle bestie"
L["BG>Raid>Party>Say"] = "CB>Incursione>Gruppo>Dire"
L["BG-System Alliance"] = "Sistema CB Alleanza"
L["BG-System Horde"] = "Sistema CB Orda"
L["BG-System Neutral"] = "Sistema CB Neutrale"
L["BigWigs Stage"] = "Fase di BigWigs"
L["Bleed"] = "Sanguinamento"
L["Boss Emote"] = "Emote del boss"
L["Boss Mod Announce"] = "Annuncio Boss Mod"
L["Boss Mod Stage"] = "Fase Boss Mod"
L["Boss Mod Stage (Event)"] = "Fase Boss Mod (evento)"
L["Boss Mod Timer"] = "Timer Boss Mod"
L["Boss Whisper"] = "Sussurro del boss"
L["Bounce with Decay"] = "Rimbalzo con smorzamento"
L["Break"] = "Pausa"
L["Buff"] = "Beneficio"
L["Buff/Debuff"] = "Beneficio/Malefico"
L["Buru the Gorger"] = "Buru il Divoratore"
L["Cast"] = "Lancio"
L["Caster"] = "Incantatore"
L["Ceil"] = "Arrotonda per eccesso"
L["Character GUID"] = "GUID del personaggio"
L["Character Name"] = "Nome del personaggio"
L["Character Transferred Quantity"] = "Quantità trasferita dal personaggio"
L["Charged Combo Points"] = "Punti combo carichi"
L["Circular Texture"] = "Texture circolare"
L["Classic"] = "Classico"
L["Clone per Character"] = "Clone per personaggio"
L["Coin Precision"] = "Precisione monete"
L["Communities"] = "Comunità"
L["Condition Custom Test"] = "Test personalizzato della condizione"
L["Cooldown"] = "Tempo di recupero"
L["Cooldown Progress (Item)"] = "Avanzamento tempo di recupero (oggetto)"
L["Cooldown Progress (Slot)"] = "Avanzamento tempo di recupero (slot)"
L["Copper"] = "Rame"
L["Creature Family"] = "Famiglia di creature"
L["Creature Family Name"] = "Nome della famiglia di creature"
L["Creature Type"] = "Tipo di creatura"
L["Creature Type Name"] = "Nome del tipo di creatura"
L["Crop X"] = "Ritaglio X"
L["Crop Y"] = "Ritaglio Y"
L["Crowd Controlled"] = "Controllato (CC)"
L["C'thun"] = "C'Thun"
L["Custom"] = "Personalizzato"
L["Custom Action"] = "Azione personalizzata"
L["Custom Anchor"] = "Ancoraggio personalizzato"
L["Custom Check"] = "Controllo personalizzato"
L["Custom Color"] = "Colore personalizzato"
L["Custom Condition Code"] = "Codice condizione personalizzato"
L["Custom Configuration"] = "Configurazione personalizzata"
L["Custom Fade Animation"] = "Animazione di dissolvenza personalizzata"
L["Custom Function"] = "Funzione personalizzata"
L["Custom Grow"] = "Crescita personalizzata"
L["Custom Sort"] = "Ordinamento personalizzato"
L["Custom Text Function"] = "Funzione di testo personalizzata"
L["Custom Trigger Combination"] = "Combinazione di attivazioni personalizzate"
L["Custom Variables"] = "Variabili personalizzate"
L["Damage"] = "Danni"
L["Damage Shield"] = "Scudo danni"
L["Damage Shield Missed"] = "Scudo danni mancato"
L["Damage Split"] = "Divisione danni"
L["DBM Announce"] = "Annuncio DBM"
L["DBM Stage"] = "Fase DBM"
L["DBM Timer"] = "Timer DBM"
L["Dead"] = "Morto"
L["Death"] = "Morte"
L["Debuff"] = "Malefico"
L["Debuff Class"] = "Classe del malefico"
L["Debuff Class Icon"] = "Icona classe del malefico"
L["Debuff Type"] = "Tipo di malefico"
L["Debug Log contains more than 1000 entries"] = "Il registro di debug contiene più di 1000 voci"
L["Debug Logging enabled"] = "Registrazione di debug attiva"
L["Debug Logging enabled for '%s'"] = "Registrazione di debug attiva per '%s'"
L["Defense"] = "Difesa"
L["Defensive Stats"] = "Statistiche difensive"
L["Deflect"] = "Deviazione"
L["Delve"] = "Esplorazione"
L["Desaturate"] = "Desatura"
L["Desaturate Background"] = "Desatura sfondo"
L["Desaturate Foreground"] = "Desatura primo piano"
L["Descending"] = "Decrescente"
L["Dest Raid Mark"] = "Marchio raid della destinazione"
L["Destination Affiliation"] = "Affiliazione della destinazione"
L["Destination GUID"] = "GUID della destinazione"
L["Destination Info"] = "Info sulla destinazione"
L["Destination Name"] = "Nome della destinazione"
L["Destination NPC Id"] = "ID NPC della destinazione"
L["Destination Object Type"] = "Tipo di oggetto della destinazione"
L["Destination Reaction"] = "Reazione della destinazione"
L["Destination Unit"] = "Unità di destinazione"
L["Destination unit's raid mark index"] = "Indice del marchio raid dell'unità di destinazione"
L["Destination unit's raid mark texture"] = "Texture del marchio raid dell'unità di destinazione"
L["Difficulty"] = "Difficoltà"
L["Disable Spell Known Check"] = "Disattiva il controllo dell'incantesimo conosciuto"
L["Disabled"] = "Disattivato"
L["Disabled feature %q"] = "Funzione %q disattivata"
L["Disabled Spell Known Check"] = "Controllo dell'incantesimo conosciuto disattivato"
L["Discovered"] = "Scoperto"
L["Disease"] = "Malattia"
L["Dispel"] = "Dissoluzione"
L["Dispel Failed"] = "Dissoluzione fallita"
L["Display"] = "Visualizzazione"
L["Do Not Disturb"] = "Non disturbare"
L["Dodge"] = "Schivata"
L["Dodge (%)"] = "Schivata (%)"
L["Dodge Rating"] = "Valutazione di schivata"
L["Down"] = "Giù"
L["Down, then Centered Horizontal"] = "Giù, poi centrato orizzontalmente"
L["Down, then Left"] = "Giù, poi a sinistra"
L["Down, then Right"] = "Giù, poi a destra"
L["Drain"] = "Svuota"
L["Dropdown Menu"] = "Menu a discesa"
L["Dumping table"] = "Esportazione della tabella"
L["Dungeon (Celestial)"] = "Spedizione (Celestiale)"
L["Dungeon (Heroic)"] = "Spedizione (Eroica)"
L["Dungeon (Mythic)"] = "Spedizione (Mitica)"
L["Dungeon (Mythic+)"] = "Spedizione (Mitica+)"
L["Dungeon (Normal)"] = "Spedizione (Normale)"
L["Dungeon (Timewalking)"] = "Spedizione (Viaggio nel tempo)"
L["Dungeons"] = "Dungeon"
L["Durability Damage"] = "Danno alla durabilità"
L["Durability Damage All"] = "Danno alla durabilità (tutto)"
L["Duration"] = "Durata"
L["Duration Function"] = "Funzione di durata"
L["Duration Function (fallback state)"] = "Funzione di durata (stato di riserva)"
L["Ease In"] = "Entrata graduale"
L["Ease In and Out"] = "Entrata e uscita graduali"
L["Ease Out"] = "Uscita graduale"
L["Eclipse Direction"] = "Direzione eclissi"
L["Edge"] = "Bordo"
L["Edge of Madness"] = "Bordo della follia"
L["Effective Spell Id"] = "ID incantesimo effettivo"
L["Elide"] = "Tronca"
L["Elite"] = "Élite"
L["Empower Cast End"] = "Fine lancio potenziato"
L["Empower Cast Interrupt"] = "Interruzione lancio potenziato"
L["Empower Cast Start"] = "Inizio lancio potenziato"
L["Empowered"] = "Potenziato"
L["Empowered 1"] = "Potenziato 1"
L["Empowered 2"] = "Potenziato 2"
L["Empowered 3"] = "Potenziato 3"
L["Empowered 4"] = "Potenziato 4"
L["Empowered 5"] = "Potenziato 5"
L["Empowered Cast"] = "Lancio potenziato"
L["Empowered Cast Fully Charged"] = "Lancio potenziato completamente carico"
L["Empowered Fully Charged"] = "Potenziato completamente carico"
L["Empty"] = "Vuoto"
L["Enabled feature %q"] = "Funzione %q attivata"
L["Enables (incorrect) round down of seconds, which was the previous default behavior."] = "Abilita l'arrotondamento per difetto (errato) dei secondi, che era il comportamento predefinito precedente."
L["Enchant Applied"] = "Incantamento applicato"
L["Enchant Found"] = "Incantamento trovato"
L["Enchant ID"] = "ID incantamento"
L["Enchant Missing"] = "Incantamento mancante"
L["Enchant Name or ID"] = "Nome o ID dell'incantamento"
L["Enchant Removed"] = "Incantamento rimosso"
L["Enchanted"] = "Incantato"
L["Encounter ID(s)"] = "ID incontro"
L["Energize"] = "Energizza"
L["Enrage"] = "Furia"
L["Enter a name or a spellId"] = "Inserisci un nome o uno spellId"
L["Entering"] = "Entrata"
L["Entering/Leaving Combat"] = "Entrata/Uscita dal combattimento"
L["Entering/Leaving Encounter"] = "Entrata/Uscita dall'incontro"
L["Entry Order"] = "Ordine delle voci"
L["Environment Type"] = "Tipo di ambiente"
L["Environmental"] = "Ambientale"
L["Equipment"] = "Equipaggiamento"
L["Equipment Set"] = "Set di equipaggiamento"
L["Equipment Set Equipped"] = "Set di equipaggiamento indossato"
L["Equipment Slot"] = "Slot di equipaggiamento"
L["Equipped"] = "Equipaggiato"
L["Error '%s' created a secure clone. We advise deleting the aura. For more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"] = "L'errore '%s' ha creato un clone protetto. Si consiglia di eliminare l'aura. Per maggiori informazioni:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Error decoding."] = "Errore di decodifica."
L["Error decompressing"] = "Errore di decompressione"
L["Error decompressing. This doesn't look like a KUIAR_Engine import."] = "Errore di decompressione. Non sembra un'importazione di KUIAR_Engine."
L["Error deserializing"] = "Errore di deserializzazione"
L["Error Frame"] = "Cornice degli errori"
L["ERROR in '%s' unknown or incompatible sub element type '%s'"] = "ERRORE in '%s': tipo di sotto-elemento '%s' sconosciuto o incompatibile"
L["Error in Aura '%s'"] = "Errore nell'aura '%s'"
L["Error not receiving display information from %s"] = "Errore: nessuna informazione di display ricevuta da %s"
L["Essence"] = "Essenza"
L["Essence #1"] = "Essenza #1"
L["Essence #2"] = "Essenza #2"
L["Essence #3"] = "Essenza #3"
L["Essence #4"] = "Essenza #4"
L["Essence #5"] = "Essenza #5"
L["Essence #6"] = "Essenza #6"
L["Evade"] = "Fuga"
L["Event(s)"] = "Evento/i"
L["Every Frame"] = "Ogni frame"
L["Every Frame (High CPU usage)"] = "Ogni frame (alto uso della CPU)"
L["Evoker Essence"] = "Essenza dell'Evocatore"
L["Exact Spell ID(s)"] = "ID incantesimo esatto/i"
L["Spell ID(s)"] = "ID incantesimo"
L["Execute Conditions"] = "Esegui condizioni"
L["Experience (%)"] = "Esperienza (%)"
L["Expertise Bonus"] = "Bonus maestria"
L["Expertise Rating"] = "Valutazione di maestria"
L["Extend Outside"] = "Estendi all'esterno"
L["Extra Amount"] = "Quantità extra"
L["Extra Attacks"] = "Attacchi extra"
L["Extra Spell Id"] = "ID incantesimo extra"
L["Extra Spell Name"] = "Nome incantesimo extra"
L["Faction"] = "Fazione"
L["Faction Name"] = "Nome della fazione"
L["Faction Reputation"] = "Reputazione con la fazione"
L["Fade Animation"] = "Animazione di dissolvenza"
L["Fade In"] = "Dissolvenza in entrata"
L["Fade Out"] = "Dissolvenza"
L["Fail Alert"] = "Avviso di fallimento"
L["False"] = "Falso"
L["Fankriss the Unyielding"] = "Fankriss l'Implacabile"
L["Feature %q is already disabled"] = "La funzione %q è già disattivata"
L["Feature %q is already enabled"] = "La funzione %q è già attivata"
L["Fetch Absorb"] = "Recupera assorbimento"
L["Fetch Heal Absorb"] = "Recupera assorbimento cure"
L["Fill Area"] = "Riempi area"
L["Filter messages with format <message>"] = "Filtra i messaggi con formato <messaggio>"
L["Fire Resistance"] = "Resistenza al fuoco"
L["First"] = "Primo"
L["First Value of Tooltip Text"] = "Primo valore del testo del tooltip"
L["Fixed"] = "Fisso"
L["Fixed Names"] = "Nomi fissi"
L["Fixed Size"] = "Dimensione fissa"
L["Flash"] = "Lampeggio"
L["Flex Raid"] = "Incursione flessibile"
L["Flip"] = "Inverti"
L["Floor"] = "Arrotonda per difetto"
L["Follower Dungeon"] = "Spedizione con seguace"
L["Font"] = "Carattere"
L["Font Size"] = "Dimensione carattere"
L["Forbidden function or table: %s"] = "Funzione o tabella vietata: %s"
L["Foreground"] = "Primo piano"
L["Foreground Color"] = "Colore del primo piano"
L["Format"] = "Formato"
L["Format Gold"] = "Formato oro"
L["Formats |cFFFFCC00%unit|r"] = "Formatta |cFFFFCC00%unit|r"
L["Formats Player's |cFFFFCC00%guid|r"] = "Formatta il |cFFFFCC00%guid|r del giocatore"
L["Forward"] = "Avanti"
L["Forward, Reverse Loop"] = "Avanti, ciclo inverso"
L["Fourth Value of Tooltip Text"] = "Quarto valore del testo del tooltip"
L["Frame Selector"] = "Selettore di cornice"
L["Frequency"] = "Frequenza"
L["Friendly"] = "Amichevole"
L["Friendly Fire"] = "Fuoco amico"
L["Friendship Max Rank"] = "Grado massimo di amicizia"
L["Friendship Rank"] = "Grado di amicizia"
L["Friendship Reputation"] = "Reputazione di amicizia"
L["Frost"] = "Gelo"
L["Frost Resistance"] = "Resistenza al gelo"
L["Frost Rune #1"] = "Runa del gelo #1"
L["Frost Rune #2"] = "Runa del gelo #2"
L["Full"] = "Pieno"
L["Full Region"] = "Regione completa"
L["Full/Empty"] = "Pieno/Vuoto"
L["Gained"] = "Ottenuto"
L["General"] = "Generale"
L["General Rajaxx"] = "Generale Rajaxx"
L["GetNameAndIcon Function (fallback state)"] = "Funzione GetNameAndIcon (stato di riserva)"
L["Glancing"] = "Colpo di striscio"
L["Global Cooldown"] = "Tempo di recupero globale"
L["Glow"] = "Bagliore"
L["Glow External Element"] = "Bagliore su elemento esterno"
L["Glyph"] = "Glifo"
L["Gold"] = "Oro"
L["Golemagg the Incinerator"] = "Golemagg l'Incineratore"
L["Gothik the Harvester"] = "Gothik il Mietitore"
L["Gradient"] = "Gradiente"
L["Gradient Enabled"] = "Gradiente abilitato"
L["Gradient End"] = "Fine del gradiente"
L["Gradient Orientation"] = "Orientamento del gradiente"
L["Gradient Pulse"] = "Pulsazione del gradiente"
L["Grand Widow Faerlina"] = "Gran Vedova Faerlina"
L["Grid"] = "Griglia"
L["Group"] = "Gruppo"
L["Group Arrangement"] = "Disposizione del gruppo"
L["Group Leader/Assist"] = "Capogruppo/Assistente"
L["Group Size"] = "Dimensione del gruppo"
L["Group Type"] = "Tipo di gruppo"
L["Grow"] = "Crescita"
L["GTFO Alert"] = "Avviso GTFO"
L["Guardian"] = "Guardiano"
L["Guild"] = "Gilda"
L["Has Target"] = "Ha un bersaglio"
L["Has Vehicle UI"] = "Ha interfaccia veicolo"
L["Haste (%)"] = "Celerità (%)"
L["Haste Rating"] = "Valutazione di celerità"
L["Heal"] = "Cura"
L["Heal Absorb"] = "Assorbimento cure"
L["Heal Absorbed"] = "Cure assorbite"
L["Health"] = "Salute"
L["Health (%)"] = "Salute (%)"
L["Health Deficit"] = "Deficit di salute"
L["Heigan the Unclean"] = "Heigan l'Impuro"
L["Height"] = "Altezza"
L["Hero Talent"] = "Talento eroe"
L["Heroic Party"] = "Gruppo eroico"
L["Hide"] = "Nascondi"
L["Hide 0 cooldowns"] = "Nascondi tempi di recupero a 0"
L["Hide Timer Text"] = "Nascondi testo del timer"
L["High Damage"] = "Danno elevato"
L["High Priest Thekal"] = "Alto Sacerdote Thekal"
L["High Priest Venoxis"] = "Alto Sacerdote Venoxis"
L["High Priestess Arlokk"] = "Alta Sacerdotessa Arlokk"
L["High Priestess Jeklik"] = "Alta Sacerdotessa Jeklik"
L["High Priestess Mar'li"] = "Alta Sacerdotessa Mar'li"
L["Higher Than Tank"] = "Più alto del tank"
L["Highest Spell Id"] = "ID incantesimo più alto"
L["Hit (%)"] = "Colpo (%)"
L["Hit Rating"] = "Valutazione di colpo"
L["Holy Resistance"] = "Resistenza al sacro"
L["Horde"] = "Orda"
L["Horizontal"] = "Orizzontale"
L["Hostile"] = "Ostile"
L["Hostility"] = "Ostilità"
L["Humanoid"] = "Umanoide"
L["Hybrid"] = "Ibrido"
L["Icon"] = "Icona"
L["Icon Function"] = "Funzione icona"
L["Icon Function (fallback state)"] = "Funzione icona (stato di riserva)"
L["Ignore Dead"] = "Ignora morti"
L["Ignore Disconnected"] = "Ignora disconnessi"
L["Ignore out of checking range"] = "Ignora fuori portata di controllo"
L["Ignore Rune CD"] = "Ignora CD delle rune"
L["Ignore Rune CDs"] = "Ignora CD delle rune"
L["Ignore Self"] = "Ignora te stesso"
L["Ignore Spell Cooldown/Charges"] = "Ignora tempo di recupero/cariche dell'incantesimo"
L["Ignore Spell Override"] = "Ignora sostituzione dell'incantesimo"
L["Important"] = "Importante"
L["Importing will start after combat ends."] = "L'importazione inizierà al termine del combattimento."
L["In Combat"] = "In combattimento"
L["In Encounter"] = "In un incontro"
L["In Group"] = "In gruppo"
L["In Party"] = "In gruppo"
L["In Pet Battle"] = "In scontro tra mascotte"
L["In Raid"] = "In incursione"
L["In Range"] = "In portata"
L["In Vehicle"] = "In veicolo"
L["In War Mode"] = "In modalità guerra"
L["Include Bank"] = "Includi banca"
L["Include Charges"] = "Includi cariche"
L["Include Death Runes"] = "Includi rune della morte"
L["Include Pets"] = "Includi animali"
L["Include War Band Bank"] = "Includi banca della Brigata"
L["Incoming Heal"] = "Cure in arrivo"
L["Increase Precision Below"] = "Aumenta la precisione sotto"
L["Increases by one per stage or intermission."] = "Aumenta di uno per fase o intermezzo."
L["Information"] = "Informazioni"
L["Inherited"] = "Ereditato"
L["Instakill"] = "Morte istantanea"
L["Install the addons BugSack and BugGrabber for detailed error logs."] = "Installa gli addon BugSack e BugGrabber per registri degli errori dettagliati."
L["Instance"] = "Istanza"
L["Instance Difficulty"] = "Difficoltà dell'istanza"
L["Instance Id"] = "Id istanza"
L["Instance ID"] = "ID istanza"
L["Instance Info"] = "Info sull'istanza"
L["Instance Name"] = "Nome dell'istanza"
L["Instance Size Type"] = "Tipo di dimensione dell'istanza"
L["Instance Type"] = "Tipo di istanza"
L["Instructor Razuvious"] = "Istruttore Razuvious"
L["Insufficient Resources"] = "Risorse insufficienti"
L["Intellect"] = "Intelletto"
L["Interrupt"] = "Interruzione"
L["Interrupt School"] = "Scuola interrotta"
L["Interrupted School Text"] = "Testo della scuola interrotta"
L["Interruptible"] = "Interrompibile"
L["Inverse"] = "Inverso"
L["Inverse Pet Behavior"] = "Comportamento inverso dell'animale"
L["Is Away from Keyboard"] = "È assente dalla tastiera"
L["Is Death Rune"] = "È una runa della morte"
L["Is Exactly"] = "È esattamente"
L["Is Moving"] = "È in movimento"
L["Is Off Hand"] = "È nella mano secondaria"
L["Is Paused"] = "È in pausa"
L["is useable"] = "è utilizzabile"
L["Is Weekly Renown Capped"] = "Limite settimanale di Rinomanza raggiunto"
L["Island Expedition (Heroic)"] = "Spedizione sulle isole (Eroica)"
L["Island Expedition (Mythic)"] = "Spedizione sulle isole (Mitica)"
L["Island Expedition (Normal)"] = "Spedizione sulle isole (Normale)"
L["Island Expeditions (PvP)"] = "Spedizioni sulle isole (PvP)"
L["Item"] = "Oggetto"
L["Item Bonus Id"] = "ID bonus oggetto"
L["Item Bonus Id Equipped"] = "ID bonus oggetto equipaggiato"
L["Item Count"] = "Numero di oggetti"
L["Item Equipped"] = "Oggetto equipaggiato"
L["Item Id"] = "ID oggetto"
L["Item in Range"] = "Oggetto a portata"
L["Item Name"] = "Nome dell'oggetto"
L["Item Set Equipped"] = "Set di oggetti equipaggiato"
L["Item Set Id"] = "ID set di oggetti"
L["Item Slot"] = "Slot dell'oggetto"
L["Item Slot String"] = "Stringa dello slot dell'oggetto"
L["Item Type"] = "Tipo di oggetto"
L["Item Type Equipped"] = "Tipo di oggetto equipaggiato"
L["Jin'do the Hexxer"] = "Jin'do l'Orco"
L["Journal Stage"] = "Fase del Diario"
L["Keep Inside"] = "Mantieni all'interno"
L["Large"] = "Grande"
L["Latency"] = "Latenza"
L["Leader"] = "Capo"
L["Least remaining time"] = "Minor tempo rimanente"
L["Leaving"] = "Uscita"
L["Leech"] = "Sanguisuga"
L["Leech (%)"] = "Sottrazione di vita (%)"
L["Leech Rating"] = "Valutazione di sottrazione di vita"
L["Left"] = "A sinistra"
L["Left to Right"] = "Da sinistra a destra"
L["Left, then Centered Vertical"] = "A sinistra, poi centrato verticalmente"
L["Left, then Down"] = "A sinistra, poi giù"
L["Left, then Up"] = "A sinistra, poi su"
L["Legacy Looking for Raid"] = "Ricerca incursione legacy"
L["Legacy RGB Gradient"] = "Gradiente RGB legacy"
L["Legacy RGB Gradient Pulse"] = "Pulsazione del gradiente RGB legacy"
L["Length"] = "Lunghezza"
L["Level"] = "Livello"
L["Limited"] = "Limitato"
L["Linear Texture"] = "Texture lineare"
L["Lines & Particles"] = "Linee e particelle"
L["Load Conditions"] = "Quando caricare"
L["Load Flag"] = "Flag di caricamento"
L["Loads while an aura has set this flag with KUIAR_Engine.SetLoadFlag(name, true), for example a group's backend choosing which children to load from its custom options."] = "Si carica finché un'aura ha impostato questo flag con KUIAR_Engine.SetLoadFlag(name, true), per esempio quando il backend di un gruppo sceglie quali figli caricare dalle sue opzioni personalizzate."
L["Location"] = "Posizione"
L["Looking for Raid"] = "Ricerca incursione"
L["Loop"] = "Ciclo"
L["Loot"] = "Bottino"
L["Lord Kazzak"] = "Signore Kazzak"
L["Lost"] = "Perso"
L["Low Damage"] = "Danno basso"
L["Lower Than Tank"] = "Più basso del tank"
L["Lowest Spell Id"] = "ID incantesimo più basso"
L["Lua error"] = "Errore Lua"
L["Lua error in Aura '%s': %s"] = "Errore Lua nell'aura '%s': %s"
L["Magic"] = "Magia"
L["Main Character"] = "Personaggio principale"
L["Main Stat"] = "Statistica principale"
L["Majordomo Executus"] = "Maggiordomo Executus"
L["Malformed KUIAR_Engine link"] = "Link KUIAR_Engine malformato"
L["Manual"] = "Manuale"
L["Manual Icon"] = "Icona manuale"
L["Manual Rotation"] = "Rotazione manuale"
L["Marked First"] = "Segnato per primo"
L["Marked Last"] = "Segnato per ultimo"
L["Master"] = "Principale"
L["Mastery (%)"] = "Maestria (%)"
L["Mastery Rating"] = "Valutazione di maestria"
L["Match Count"] = "Numero di corrispondenze"
L["Match Count per Unit"] = "Numero di corrispondenze per unità"
L["Matches (Pattern)"] = "Corrisponde (schema)"
L["Matches stage number of encounter journal.\nIntermissions are .5\nE.g. 1;2;1;2;2.5;3"] = "Corrisponde al numero della fase nel Diario degli incontri.\nGli intermezzi sono .5\nEs. 1;2;1;2;2.5;3"
L["Max Char "] = "Caratteri max "
L["Max Char"] = "Caratteri max"
L["Max Charges"] = "Cariche massime"
L["Max Health"] = "Salute massima"
L["Max Power"] = "Potere massimo"
L["Max Quantity"] = "Quantità massima"
L["Maximum Estimate"] = "Stima massima"
L["Maximum Progress"] = "Avanzamento massimo"
L["Maximum time used on a single frame"] = "Tempo massimo usato in un singolo frame"
L["Medium"] = "Media"
L["Melee"] = "Corpo a corpo"
L["Melee Haste (%)"] = "Celerità in mischia (%)"
L["Message"] = "Messaggio"
L["Message Type"] = "Tipo di messaggio"
L["Message type:"] = "Tipo di messaggio:"
L["Meta Data"] = "Metadati"
L["Mine"] = "Mia"
L["Minimum Estimate"] = "Stima minima"
L["Minimum Progress"] = "Avanzamento minimo"
L["Minus (Small Nameplate)"] = "Meno (targhetta piccola)"
L["Mirror"] = "Specchio"
L["Miscellaneous"] = "Varie"
L["Miss"] = "Mancato"
L["Miss Type"] = "Tipo di mancato"
L["Missed"] = "Mancato"
L["Missing"] = "Mancante"
L["Model"] = "Modello"
L["Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"] = "Blizzard moderno (1h 3m | 3m 7s | 10s | 2.4)"
L["Modernize"] = "Modernizza"
L["Molten Core"] = "Nucleo Fuso"
L["Money"] = "Denaro"
L["Monochrome"] = "Monocromatico"
L["Monochrome Outline"] = "Contorno monocromatico"
L["Monochrome Thick Outline"] = "Contorno spesso monocromatico"
L["Monster Emote"] = "Emote del mostro"
L["Monster Party"] = "Gruppo del mostro"
L["Monster Say"] = "Dire del mostro"
L["Monster Whisper"] = "Sussurro del mostro"
L["Monster Yell"] = "Urlo del mostro"
L["Moon"] = "Luna"
L["Most remaining time"] = "Maggior tempo rimanente"
L["Mounted"] = "In sella"
L["Mouse Cursor"] = "Cursore del mouse"
L["Movement Speed Rating"] = "Punteggio velocità di movimento"
L["Multi-target"] = "Bersagli multipli"
L["Mythic Keystone"] = "Chiave del Mitico"
L["Mythic+ Affix"] = "Affisso Mitico+"
L["Name"] = "Nome"
L["Name Function"] = "Funzione nome"
L["Name Function (fallback state)"] = "Funzione nome (stato di riserva)"
L["Name of Caster's Target"] = "Nome del bersaglio del lanciatore"
L["Name of the (sub-)zone currently shown above the minimap."] = "Nome della (sotto)zona mostrata attualmente sopra la minimappa."
L["Name(s)"] = "Nome/i"
L["Name/Realm of Caster's Target"] = "Nome/Reame del bersaglio del lanciatore"
L["Nameplate"] = "Targa nome"
L["Nameplates"] = "Barre delle unità"
L["Names of affected Players"] = "Nomi dei giocatori interessati"
L["Names of unaffected Players"] = "Nomi dei giocatori non interessati"
L["Nature Resistance"] = "Resistenza alla Natura"
L["Neutral"] = "Neutrale"
L["Never"] = "Mai"
L["Next Combat"] = "Prossimo combattimento"
L["Next Encounter"] = "Prossimo incontro"
L["No active boss mod addon detected.\n\nNote: This trigger will use BigWigs or DBM, in that order if both are installed."] = "Nessun addon per boss rilevato attivo.\n\nNota: questo innesco userà BigWigs o DBM, in quest'ordine se sono installati entrambi."
L["No Extend"] = "Nessuna estensione"
L["No Instance"] = "Nessuna istanza"
L["No Profiling information saved."] = "Nessuna informazione di profilazione salvata."
L["No Progress Information available."] = "Nessuna informazione sull'avanzamento disponibile."
L["None"] = "Nessuno"
L["Non-player Character"] = "Personaggio non giocante"
L["Normal"] = "Normale"
L["Normal Party"] = "Gruppo normale"
L["Not in Group"] = "Non in gruppo"
L["Not in Smart Group"] = "Non nel gruppo intelligente"
L["Not on Cooldown"] = "Non in ricarica"
L["Not On Threat Table"] = "Non nella tabella delle minacce"
L["Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."] = "Nota: data la complessità del comportamento del timer dei colpi e la mancanza di API da parte di Blizzard, i risultati sono imprecisi in casi limite."
L["Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."] = "Nota: \"Nascondi se solo\" non è disponibile nel nuovo sistema di tracciamento delle aure. Si può usare invece un'opzione di caricamento."
L["Note: The available text replacements for multi triggers match the normal triggers now."] = "Nota: i testi sostitutivi disponibili per gli inneschi multipli ora corrispondono a quelli degli inneschi normali."
L["Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."] = "Nota: questo innesco memorizza internamente la posizione di mutaforma, quindi è incompatibile con l'apprendimento di posture al volo, come ad esempio la Runa del Gladiatore."
L["Note: This trigger relies on the WoW API, which returns incorrect information in some cases."] = "Nota: questo innesco si basa sull'API di WoW, che in alcuni casi restituisce informazioni errate."
L["Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."] = "Usa UnitIsVisible() per verificare se il client di gioco ha caricato un oggetto per questa unità. Questa distanza è di circa 100 metri. Viene controllata ogni secondo."
L["Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"] = "Nota: questo tipo di innesco stima la distanza dalla hitbox di un'unità. La distanza effettiva dai giocatori amichevoli è di solito 3 metri superiore alla stima. Le capacità di controllo della distanza dipendono dalla tua classe attuale e dalle abilità note, oltre che dal tipo di unità controllata. Alcune distanze potrebbero inoltre non funzionare con certi PNG.|n|n|cFFAAFFAAUnità amichevoli:|r %s|n|cFFFFAAAAUnità ostili:|r %s|n|cFFAAAAFFUnità varie:|r %s"
L["Noth the Plaguebringer"] = "Noth il Pestilente"
L["NPC"] = "PNG"
L["Npc ID"] = "ID PNG"
L["Number"] = "Numero"
L["Number Affected"] = "Numero di interessati"
L["Object"] = "Oggetto"
L["Occurrence of the event\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nWorks only if Boss Mod addon show counter"] = "Occorrenza dell'evento\nPuò essere un intervallo di valori\nPuò avere più valori separati da una virgola o da uno spazio\n\nEsempi:\n2°, 5° e 6° evento: 2, 5, 6\ndal 2° al 6°: 2-6\nogni 2 eventi: /2\nogni 3 eventi a partire dal 2°: 2/3\nogni 3 eventi a partire dal 2° e fino all'11°: 2-11/3\n\nFunziona solo se l'addon per boss mostra il contatore"
L["Occurrence of the event, reset when aura is unloaded\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nOnly if BigWigs shows it on it's bar"] = "Occorrenza dell'evento, azzerata quando l'aura viene scaricata\nPuò essere un intervallo di valori\nPuò avere più valori separati da una virgola o da uno spazio\n\nEsempi:\n2°, 5° e 6° evento: 2, 5, 6\ndal 2° al 6°: 2-6\nogni 2 eventi: /2\nogni 3 eventi a partire dal 2°: 2/3\nogni 3 eventi a partire dal 2° e fino all'11°: 2-11/3\n\nSolo se BigWigs lo mostra sulla sua barra"
L["Occurrence of the event, reset when aura is unloaded\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nOnly if DBM shows it on it's bar"] = "Occorrenza dell'evento, azzerata quando l'aura viene scaricata\nPuò essere un intervallo di valori\nPuò avere più valori separati da una virgola o da uno spazio\n\nEsempi:\n2°, 5° e 6° evento: 2, 5, 6\ndal 2° al 6°: 2-6\nogni 2 eventi: /2\nogni 3 eventi a partire dal 2°: 2/3\nogni 3 eventi a partire dal 2° e fino all'11°: 2-11/3\n\nSolo se DBM lo mostra sulla sua barra"
L["Officer"] = "Ufficiale"
L["Offset from progress"] = "Sfasamento dall'avanzamento"
L["Offset Timer"] = "Sfasamento timer"
L["Old Blizzard (2h | 3m | 10s | 2.4)"] = "Vecchio stile Blizzard (2h | 3m | 10s | 2.4)"
L["On Cooldown"] = "In recupero"
L["On Taxi"] = "In volo"
L["Only if on a different realm"] = "Solo se su un reame diverso"
L["Only if Primary"] = "Solo se primaria"
L["Opaque"] = "Opaco"
L["Option Group"] = "Gruppo di opzioni"
L["Options could not be loaded, the addon is %s"] = "Impossibile caricare le opzioni, l'addon è %s"
L["Options will finish loading after combat ends."] = "Le opzioni termineranno il caricamento al termine del combattimento."
L["Options will open after the login process has completed."] = "Le opzioni si apriranno al termine del processo di accesso."
L["Or Talent"] = "O talento"
L["Orbit"] = "Orbita"
L["Orientation"] = "Orientamento"
L["Ossirian the Unscarred"] = "Ossirian l'Invulnerabile"
L["Other"] = "Altro"
L["Other Addons"] = "Altri addon"
L["Other Events"] = "Altri eventi"
L["Outline"] = "Contorno"
L["Over Energize"] = "Energia in eccesso"
L["Overhealing"] = "Sovracura"
L["Overkill"] = "Danno in eccesso"
L["Overlay %s"] = "Sovrapposizione %s"
L["Overlay Charged Combo Points"] = "Sovrapponi punti combo caricati"
L["Overlay Cost of Casts"] = "Sovrapponi costo dei lanci"
L["Overlay Latency"] = "Sovrapponi latenza"
L["Pad"] = "Riempimento"
L["Pad Mode"] = "Modalità riempimento"
L["Pad to"] = "Riempi fino a"
L["Parent Frame"] = "Riquadro genitore"
L["Parent Zone"] = "Zona genitore"
L["Parry"] = "Parata"
L["Parry (%)"] = "Parata (%)"
L["Parry Rating"] = "Punteggio parata"
L["Party"] = "Gruppo"
L["Party Kill"] = "Uccisione del gruppo"
L["Path of Ascension: Courage"] = "Via dell'Ascensione: Coraggio"
L["Path of Ascension: Humility"] = "Via dell'Ascensione: Umiltà"
L["Path of Ascension: Loyalty"] = "Via dell'Ascensione: Lealtà"
L["Path of Ascension: Wisdom"] = "Via dell'Ascensione: Saggezza"
L["Paused"] = "In pausa"
L["Periodic Spell"] = "Incantesimo periodico"
L["Personal Resource Display"] = "Visualizzazione risorsa personale"
L["Pet"] = "Famiglio"
L["Pet Behavior"] = "Comportamento del famiglio"
L["Pet Specialization"] = "Specializzazione del famiglio"
L["Pet Spell"] = "Incantesimo del famiglio"
L["Pets only"] = "Solo famigli"
L["Phase"] = "Fase"
L["Pixel Glow"] = "Bagliore pixel"
L["Placement"] = "Posizionamento"
L["Placement %i"] = "Posizionamento %i"
L["Placement Mode"] = "Modalità di posizionamento"
L["Play"] = "Riproduci"
L["Player"] = "Giocatore"
L["Player Character"] = "Personaggio giocante"
L["Player Class"] = "Classe del giocatore"
L["Player Effective Level"] = "Livello effettivo del giocatore"
L["Player Experience"] = "Esperienza del giocatore"
L["Player Faction"] = "Fazione del giocatore"
L["Player Level"] = "Livello del giocatore"
L["Player Location ID(s)"] = "ID posizione del giocatore"
L["Player Money"] = "Denaro del giocatore"
L["Player Name/Realm"] = "Nome/Reame del giocatore"
L["Player Race"] = "Razza del giocatore"
L["Player(s) Affected"] = "Giocatore/i interessato/i"
L["Player(s) Not Affected"] = "Giocatore/i non interessato/i"
L["Player/Unit Info"] = "Info giocatore/unità"
L["Players and Pets"] = "Giocatori e famigli"
L["Poison"] = "Veleno"
L["Power"] = "Risorsa"
L["Power (%)"] = "Potere (%)"
L["Power Deficit"] = "Deficit di potere"
L["Power Type"] = "Tipo di risorsa"
L["Precision"] = "Precisione"
L["Preset"] = "Preimpostazione"
L["Primary Stats"] = "Statistiche primarie"
L["Princess Huhuran"] = "Principessa Huhuran"
L["Print Profiling Results"] = "Stampa risultati di profilazione"
L["Proc Glow"] = "Bagliore di proc"
L["Profiling already started."] = "La profilazione è già avviata."
L["Profiling automatically started."] = "Profilazione avviata automaticamente."
L["Profiling not running."] = "La profilazione non è in esecuzione."
L["Profiling started."] = "Profilazione avviata."
L["Profiling started. It will end automatically in %d seconds"] = "Profilazione avviata. Terminerà automaticamente tra %d secondi"
L["Profiling still running, stop before trying to print."] = "La profilazione è ancora in esecuzione, fermala prima di provare a stampare."
L["Profiling stopped."] = "Profilazione interrotta."
L["Progress"] = "Progressi"
L["Progress Source"] = "Fonte di avanzamento"
L["Progress Total"] = "Avanzamento totale"
L["Progress Value"] = "Valore di avanzamento"
L["Pulse"] = "Pulsazione"
L["PvP Flagged"] = "Marcato PvP"
L["PvP Mode Active"] = "Modalità PvP attiva"
L["PvP Talent selected"] = "Talento PvP selezionato"
L["PvP Talent Selected"] = "Talento PvP selezionato"
L["Quality Id"] = "ID qualità"
L["Quantity"] = "Quantità"
L["Quantity earned this week"] = "Quantità ottenuta questa settimana"
L["Quest Party"] = "Gruppo missione"
L["Queued Action"] = "Azione in coda"
L["Radius"] = "Raggio"
L["Raid"] = "Incursione"
L["Raid (Heroic)"] = "Raid (Eroico)"
L["Raid (Mythic)"] = "Raid (Mitico)"
L["Raid (Normal)"] = "Raid (Normale)"
L["Raid (Timewalking)"] = "Raid (Viaggio nel Tempo)"
L["Raid Mark"] = "Contrassegno raid"
L["Raid Mark Icon"] = "Icona contrassegno raid"
L["Raid Role"] = "Ruolo raid"
L["Raid Warning"] = "Avviso raid"
L["Raids"] = "Incursioni"
L["Range"] = "Portata"
L["Range Check"] = "Controllo distanza"
L["Ranged"] = "A distanza"
L["Rank"] = "Grado"
L["Rare"] = "Raro"
L["Rare Elite"] = "Elite raro"
L["Rated Arena"] = "Arena classificata"
L["Rated Battleground"] = "Campo di battaglia classificato"
L["Raw Threat Percent"] = "Percentuale di minaccia grezza"
L["Razorgore the Untamed"] = "Razorgore l'Indomito"
L["Ready Check"] = "Appello"
L["Reagent Quality"] = "Qualità del reagente"
L["Reagent Quality Texture"] = "Texture qualità del reagente"
L["Realm"] = "Reame"
L["Realm Name"] = "Nome del reame"
L["Realm of Caster's Target"] = "Reame del bersaglio del lanciatore"
L["Reborn Council"] = "Consiglio Rinato"
L["Receiving %s Bytes"] = "Ricezione di %s byte"
L["Receiving display information"] = "Ricezione delle informazioni di visualizzazione"
L["Reflect"] = "Riflesso"
L["Region type %s not supported"] = "Tipo di regione %s non supportato"
L["Relative"] = "Relativo"
L["Relative X-Offset"] = "Scostamento X relativo"
L["Relative Y-Offset"] = "Scostamento Y relativo"
L["Remaining Duration"] = "Durata rimanente"
L["Remaining Time"] = "Tempo rimasto"
L["Remove Obsolete Auras"] = "Rimuovi aure obsolete"
L["Renown Level"] = "Livello di fama"
L["Renown Max Level"] = "Livello massimo di fama"
L["Renown Reputation"] = "Reputazione di fama"
L["Repair"] = "Riparazione"
L["Repeat"] = "Ripeti"
L["Report Summary"] = "Riepilogo del rapporto"
L["Reputation"] = "Reputazione"
L["Reputation (%)"] = "Reputazione (%)"
L["Requested display does not exist"] = "La visualizzazione richiesta non esiste"
L["Requested display not authorized"] = "Visualizzazione richiesta non autorizzata"
L["Requesting display information from %s ..."] = "Richiesta delle informazioni di visualizzazione a %s ..."
L["Require Valid Target"] = "Richiedi bersaglio valido"
L["Requires syncing the specialization via LibSpecialization."] = "Richiede la sincronizzazione della specializzazione tramite LibSpecialization."
L["Resilience (%)"] = "Resilienza (%)"
L["Resilience Rating"] = "Punteggio resilienza"
L["Resist"] = "Resistenza"
L["Resistances"] = "Resistenze"
L["Resisted"] = "Resistito"
L["Rested"] = "Riposato"
L["Rested Experience"] = "Esperienza riposata"
L["Rested Experience (%)"] = "Esperienza riposata (%)"
L["Resting"] = "In riposo"
L["Resurrect"] = "Resurrezione"
L["Resurrect Pending"] = "Resurrezione in attesa"
L["Right"] = "Destra"
L["Right to Left"] = "Da destra a sinistra"
L["Right, then Centered Vertical"] = "A destra, poi centrato in verticale"
L["Right, then Down"] = "A destra, poi in basso"
L["Right, then Up"] = "A destra, poi in alto"
L["Role"] = "Ruolo"
L["Rollback snapshot is complete. Thank you for your patience!"] = "Lo snapshot di ripristino è completo. Grazie per la pazienza!"
L["Rotate Animation"] = "Animazione di rotazione"
L["Rotate Left"] = "Ruota a sinistra"
L["Rotate Right"] = "Ruota a destra"
L["Rotation"] = "Rotazione"
L["Round"] = "Rotondo"
L["Round Mode"] = "Modalità di arrotondamento"
L["Ruins of Ahn'Qiraj"] = "Rovine di Ahn'Qiraj"
L["Run Custom Code"] = "Esegui codice personalizzato"
L["Run Speed (%)"] = "Velocità di corsa (%)"
L["Rune"] = "Runa"
L["Rune #1"] = "Runa n. 1"
L["Rune #2"] = "Runa n. 2"
L["Rune #3"] = "Runa n. 3"
L["Rune #4"] = "Runa n. 4"
L["Rune #5"] = "Runa n. 5"
L["Rune #6"] = "Runa n. 6"
L["Rune Count"] = "Numero di rune"
L["Rune Count - Blood"] = "Numero di rune - Sangue"
L["Rune Count - Frost"] = "Numero di rune - Gelo"
L["Rune Count - Unholy"] = "Numero di rune - Empio"
L["Say"] = "Parla"
L["Scale"] = "Scala"
L["Scarlet Enclave"] = "Enclave Scarlatta"
L["Scenario (Heroic)"] = "Scenario (Eroico)"
L["Scenario (Normal)"] = "Scenario (Normale)"
L["Screen"] = "Schermo"
L["Screen/Parent Group"] = "Schermo/Gruppo genitore"
L["Season of Discovery"] = "Stagione della Scoperta"
L["Second"] = "Secondo"
L["Second Value of Tooltip Text"] = "Secondo valore del testo della descrizione"
L["Secondary Stats"] = "Statistiche secondarie"
L["Seconds"] = "Secondi"
L["Secure frame detected. Find more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"] = "Riquadro protetto rilevato. Maggiori informazioni:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Select Frame"] = "Seleziona riquadro"
L["Select the type of timer to filter"] = "Seleziona il tipo di timer da filtrare"
L["Selection Mode"] = "Modalità di selezione"
L["Separator"] = "Separatore"
L["Set IDs can be found on websites such as wowhead.com/cata/item-sets"] = "Gli ID dei set si trovano su siti come wowhead.com/cata/item-sets"
L["Set IDs can be found on websites such as wowhead.com/classic/item-sets"] = "Gli ID dei set si trovano su siti come wowhead.com/classic/item-sets"
L["Set IDs can be found on websites such as wowhead.com/item-sets"] = "Gli ID dei set si trovano su siti come wowhead.com/item-sets"
L["Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"] = "Gli ID dei set si trovano su siti come wowhead.com/mop-classic/item-sets"
L["Shadow Resistance"] = "Resistenza alle Ombre"
L["Shake"] = "Scossa"
L["Shift-Click to resume addon execution."] = "Maiusc+clic per riprendere l'esecuzione dell'addon."
L["Show"] = "Mostra"
L["Show CD of Charge"] = "Mostra recupero della carica"
L["Show charged duration for empowered casts"] = "Mostra durata di carica per i lanci potenziati"
L["Show GCD"] = "Mostra GCD"
L["Show Global Cooldown"] = "Mostra tempo di recupero globale"
L["Show Incoming Heal"] = "Mostra cure in arrivo"
L["Show Loss of Control"] = "Mostra perdita di controllo"
L["Show On"] = "Mostra su"
L["Show Rested Overlay"] = "Mostra sovrapposizione riposo"
L["Shrink"] = "Rimpicciolire"
L["Silithid Royalty"] = "Famiglia reale Silithid"
L["Silver"] = "Argento"
L["Simple"] = "Semplice"
L["Since Active"] = "Da quando è attivo"
L["Since Apply"] = "Da quando applicato"
L["Since Apply/Refresh"] = "Da applicazione/rinnovo"
L["Since Charge Gain"] = "Da guadagno carica"
L["Since Charge Lost"] = "Da perdita carica"
L["Since Ready"] = "Da quando è pronto"
L["Since Stack Gain"] = "Da guadagno cumulo"
L["Since Stack Lost"] = "Da perdita cumulo"
L["Size & Position"] = "Dimensione e posizione"
L["Skyriding"] = "Volo Dinamico"
L["Slide Animation"] = "Animazione di scorrimento"
L["Slide from Bottom"] = "Scorri dal basso"
L["Slide from Left"] = "Scorri da sinistra"
L["Slide from Right"] = "Scorri da destra"
L["Slide from Top"] = "Scorri dall'alto"
L["Slide to Bottom"] = "Scorri verso il basso"
L["Slide to Left"] = "Scorri verso sinistra"
L["Slide to Right"] = "Scorri verso destra"
L["Slide to Top"] = "Scorri verso l'alto"
L["Slider"] = "Cursore di scorrimento"
L["Small"] = "Piccolo"
L["Smart Group"] = "Gruppo intelligente"
L["Soft Enemy"] = "Nemico morbido"
L["Soft Friend"] = "Amico morbido"
L["Sound"] = "Suono"
L["Sound by Kit ID"] = "Suono per ID Sound Kit"
L["Source"] = "Fonte"
L["Source Affiliation"] = "Affiliazione della fonte"
L["Source GUID"] = "GUID della fonte"
L["Source Info"] = "Info fonte"
L["Source Name"] = "Nome della fonte"
L["Source NPC Id"] = "ID PNG della fonte"
L["Source Object Type"] = "Tipo di oggetto della fonte"
L["Source Raid Mark"] = "Contrassegno raid della fonte"
L["Source Reaction"] = "Reazione della fonte"
L["Source Unit"] = "Unità fonte"
L["Source Unit Name/Realm"] = "Nome/Reame dell'unità fonte"
L["Source unit's raid mark index"] = "Indice del contrassegno raid dell'unità fonte"
L["Source unit's raid mark texture"] = "Texture del contrassegno raid dell'unità fonte"
L["Space"] = "Spazio"
L["Spacing"] = "Spaziatura"
L["Spark"] = "Scintilla"
L["Spec Position"] = "Posizione specializzazione"
L["Spec Role"] = "Ruolo specializzazione"
L["Specialization"] = "Specializzazione"
L["Specific Currency"] = "Valuta specifica"
L["Specific Type"] = "Tipo specifico"
L["Specific Unit"] = "Unità specifica"
L["Spell"] = "Incantesimo"
L["Spell (Building)"] = "Incantesimo (in costruzione)"
L["Spell Activation Overlay Glow"] = "Bagliore di attivazione incantesimo"
L["Spell Cast Succeeded"] = "Lancio incantesimo riuscito"
L["Spell Cost"] = "Costo dell'incantesimo"
L["Spell Count"] = "Conteggio incantesimi"
L["Spell ID"] = "ID incantesimo"
L["Spell Id"] = "ID incantesimo"
L["Spell ID:"] = "ID incantesimo:"
L["Spell IDs:"] = "ID incantesimo:"
L["Spell in Range"] = "Incantesimo a portata"
L["Spell Known"] = "Incantesimo noto"
L["Spell Name"] = "Nome dell'incantesimo"
L["Spell Peneration Percent"] = "Percentuale di penetrazione degli incantesimi"
L["Spell Power"] = "Potere degli incantesimi"
L["Spell School"] = "Scuola di magia"
L["Spell Usable"] = "Incantesimo utilizzabile"
L["Spellname"] = "Nome incantesimo"
L["Spike"] = "Punta"
L["Spin"] = "Giro"
L["Spiral"] = "Spirale"
L["Spiral In And Out"] = "Spirale in entrata e in uscita"
L["Spirit"] = "Spirito"
L["Stack Count"] = "Numero di accumuli"
L["Stack trace:"] = "Traccia dello stack:"
L["Stacks"] = "Accumuli"
L["Stacks Function"] = "Funzione cariche"
L["Stacks Function (fallback state)"] = "Funzione cariche (stato di riserva)"
L["Stage"] = "Fase"
L["Stage Counter"] = "Contatore fase"
L["Stagger"] = "Barcollamento"
L["Stagger (%)"] = "Barcollamento (%)"
L["Stagger against Target (%)"] = "Barcollamento contro il bersaglio (%)"
L["Stagger Scale"] = "Scala barcollamento"
L["Stamina"] = "Tempra"
L["Stance/Form/Aura"] = "Postura/Forma/Aura"
L["Standing"] = "Posizione"
L["Star Shake"] = "Scossa di stelle"
L["Start Animation"] = "Animazione iniziale"
L["Start Now"] = "Inizia ora"
L["Start Profiling"] = "Avvia profilazione"
L["Status"] = "Stato"
L["Status Bar"] = "Barra di stato"
L["Stolen"] = "Rubato"
L["Stop"] = "Ferma"
L["Stop Motion"] = "Stop motion"
L["Story Raid"] = "Raid della storia"
L["Strength"] = "Forza"
L["String"] = "Stringa"
L["Subevent Info"] = "Info sottoevento"
L["Subtract Cast"] = "Sottrai lancio"
L["Subtract Channel"] = "Sottrai canalizzazione"
L["Subtract GCD"] = "Sottrai GCD"
L["Subzone Name"] = "Nome sottozona"
L["Success"] = "Successo"
L["Sulfuron Harbinger"] = "Araldo Sulfuron"
L["Summon"] = "Evocazione"
L["Summon Pending"] = "Evocazione in attesa"
L["Sun"] = "Sole"
L["Supports multiple entries, separated by commas"] = "Supporta più voci, separate da virgole"
L["Supports multiple entries, separated by commas\n"] = "Supporta più voci, separate da virgole\n"
L["Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."] = "Supporta più voci, separate da virgole. Usa \\ per il carattere ','. Prefisso '-' per negare."
L["Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."] = "Supporta più voci, separate da virgole. Usa \\ per l'escape. Prefisso '-' per negare."
L["Supports multiple entries, separated by commas. Prefix with '-' for negation."] = "Supporta più voci, separate da virgole. Prefisso '-' per negare."
L["Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.\nGroup Zone IDs must be prefixed with 'g', e.g. 'g277'.\nSupports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.\nSupports Instance IDs prefixed with 'i'.\nEntries can be prefixed with '-' to negate."] = "Supporta più voci, separate da virgole. Per includere gli ID delle zone figlie, usa il prefisso 'c', ad es. 'c2022'.\nGli ID delle zone di gruppo devono avere il prefisso 'g', ad es. 'g277'.\nSupporta gli ID area da https://wago.tools/db2/AreaTable con il prefisso 'a'.\nSupporta gli ID istanza con il prefisso 'i'.\nLe voci possono avere il prefisso '-' per negare."
L["Swing"] = "Colpo"
L["Swing Timer"] = "Timer dei colpi"
L["Swipe"] = "Animazione"
L["Syntax /wa feature <toggle|on|enable|disable|off> <feature>"] = "Sintassi /wa feature <toggle|on|enable|disable|off> <feature>"
L["System"] = "Sistema"
L["Systems"] = "Sistemi"
L["Tab "] = "Scheda"
L["Talent"] = "Talento"
L["Talent |cFFFF0000Not|r Known"] = "Talento |cFFFF0000non|r noto"
L["Talent |cFFFF0000Not|r Selected"] = "Talento |cFFFF0000non|r selezionato"
L["Talent Known"] = "Talento noto"
L["Talent Selected"] = "Talento selezionato"
L["Talent selected"] = "Talento selezionato"
L["Talent Specialization"] = "Specializzazione dei talenti"
L["Tanking And Highest"] = "Tank e più alto"
L["Tanking But Not Highest"] = "Tank ma non il più alto"
L["Target"] = "Bersaglio"
L["Targeted"] = "Bersagliato"
L["Tertiary Stats"] = "Statistiche terziarie"
L["Test if bar is enabled in BigWigs settings"] = "Verifica se la barra è attivata nelle impostazioni di BigWigs"
L["Test if bar is enabled in Boss Mod addon settings"] = "Verifica se la barra è attivata nelle impostazioni dell'addon per boss"
L["Test if bar is enabled in DBM settings"] = "Verifica se la barra è attivata nelle impostazioni di DBM"
L["Text"] = "Testo"
L["Text To Speech"] = "Sintesi vocale"
L["Text-to-speech"] = "Sintesi vocale"
L["Texture Function"] = "Funzione texture"
L["Texture Function (fallback state)"] = "Funzione texture (stato di riserva)"
L["Texture Picker"] = "Selettore texture"
L["Texture Rotation"] = "Rotazione texture"
L["The aura has overwritten the global '%s', this might affect other auras."] = "L'aura ha sovrascritto il globale '%s', questo potrebbe influire su altre aure."
L["The aura tried to overwrite the aura_env global, which is not allowed."] = "L'aura ha tentato di sovrascrivere il globale aura_env, cosa non consentita."
L["The effective level differs from the level in e.g. Time Walking dungeons."] = "Il livello effettivo differisce dal livello ad es. nelle spedizioni del Viaggio nel Tempo."
L["The Four Horsemen"] = "I Quattro Cavalieri"
L["The 'ID' value can be found in the BigWigs options of a specific spell"] = "Il valore 'ID' si trova nelle opzioni di BigWigs di un incantesimo specifico"
L["The Prophet Skeram"] = "Il Profeta Skeram"
L["The total quantity a warband character can transfer after paying the transfer cost"] = "La quantità totale che un personaggio della Brigata può trasferire dopo aver pagato il costo di trasferimento"
L["The total quantity after transferring everything to your current character and paying the transfer cost"] = "La quantità totale dopo aver trasferito tutto al tuo personaggio attuale e pagato il costo di trasferimento"
L["There are %i updates to your auras ready to be installed!"] = "Ci sono %i aggiornamenti alle tue aure pronti per l'installazione!"
L["Thick Outline"] = "Contorno spesso"
L["Thickness"] = "Spessore"
L["Third"] = "Terzo"
L["Third Value of Tooltip Text"] = "Terzo valore del testo della descrizione"
L["This aura calls GetData a lot, which is a slow function."] = "Questa aura chiama spesso GetData, che è una funzione lenta."
L["This aura has caused a Lua error."] = "Questa aura ha causato un errore Lua."
L["This aura is saving %s KB of data"] = "Questa aura sta salvando %s KB di dati"
L["This aura plays a sound via a condition."] = "Questa aura riproduce un suono tramite una condizione."
L["This aura plays a sound via an action."] = "Questa aura riproduce un suono tramite un'azione."
L["This aura plays a Text To Speech via a condition."] = "Questa aura riproduce una sintesi vocale tramite una condizione."
L["This aura plays a Text To Speech via an action."] = "Questa aura riproduce una sintesi vocale tramite un'azione."
L["This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."] = "Questo filtro è stato spostato nell'innesco Posizione. Modifica la tua aura per usare il nuovo innesco Posizione oppure unisciti al server Discord di KUIAR_Engine per ricevere aiuto."
L["Threat Percent"] = "Percentuale di minaccia"
L["Threat Situation"] = "Situazione di minaccia"
L["Threat Value"] = "Valore di minaccia"
L["Tick"] = "Tacca"
L["Time"] = "Tempo"
L["Time Format"] = "Formato dell'ora"
L["Time in GCDs"] = "Tempo in GCD"
L["Time since initial application"] = "Tempo dalla prima applicazione"
L["Time since last refresh"] = "Tempo dall'ultimo rinnovo"
L["Time since stack gain"] = "Tempo dal guadagno di cariche"
L["Time since stack lost"] = "Tempo dalla perdita di cariche"
L["Timed"] = "A tempo"
L["Timed Progress"] = "Avanzamento a tempo"
L["Timer Id"] = "ID timer"
L["Toggle"] = "Attiva/disattiva"
L["Toggle List"] = "Attiva/disattiva elenco"
L["Toggle Options Window"] = "Mostra/nascondi finestra delle opzioni"
L["Toggle Performance Profiling Window"] = "Mostra/nascondi finestra di profilazione delle prestazioni"
L["Tooltip"] = "Descrizione"
L["Tooltip 1"] = "Descrizione 1"
L["Tooltip 2"] = "Descrizione 2"
L["Tooltip 3"] = "Descrizione 3"
L["Tooltip Value 1"] = "Valore della descrizione 1"
L["Tooltip Value 2"] = "Valore della descrizione 2"
L["Tooltip Value 3"] = "Valore della descrizione 3"
L["Tooltip Value 4"] = "Valore della descrizione 4"
L["Top"] = "Alto"
L["Top Left"] = "In alto a sinistra"
L["Top Right"] = "In alto a destra"
L["Top to Bottom"] = "Dall'alto in basso"
L["Total Duration"] = "Durata totale"
L["Total Earned in this Season"] = "Totale guadagnato in questa stagione"
L["Total Essence"] = "Essenza totale"
L["Total Experience"] = "Esperienza totale"
L["Total Match Count"] = "Numero totale di corrispondenze"
L["Total Reputation"] = "Reputazione totale"
L["Total Stacks"] = "Cariche totali"
L["Total stacks over all matches"] = "Cariche totali su tutte le corrispondenze"
L["Total Stages"] = "Fasi totali"
L["Total Unit Count"] = "Numero totale di unità"
L["Total Units"] = "Unità totali"
L["Totem #%i"] = "Totem n. %i"
L["Totem Icon"] = "Icona totem"
L["Totem Name"] = "Nome totem"
L["Totem Name Pattern Match"] = "Corrispondenza del modello del nome del totem"
L["Totem Number"] = "Numero totem"
L["Track Cooldowns"] = "Traccia tempi di recupero"
L["Tracking Charge %i"] = "Traccia carica %i"
L["Tracking Charge CDs"] = "Traccia TR delle cariche"
L["Tracking Only Cooldown"] = "Traccia solo tempo di recupero"
L["Transmission error"] = "Errore di trasmissione"
L["Trigger"] = "Attivazione"
L["Trigger %i"] = "Innesco %i"
L["Trigger %s"] = "Innesco %s"
L["Trigger 1"] = "Innesco 1"
L["Trigger State Updater (Advanced)"] = "Aggiornatore di stato dell'innesco (avanzato)"
L["Trigger Update"] = "Aggiornamento innesco"
L["Trigger:"] = "Innesco:"
L["Trivial (Low Level)"] = "Banale (livello basso)"
L["True"] = "Vero"
L["Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."] = "Tentativo di riparare le condizioni danneggiate in %s, probabilmente causate da un bug di KUIAR_Engine."
L["Twin Emperors"] = "Imperatori Gemelli"
L["Type"] = "Tipo"
L["Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."] = "Impossibile modernizzare l'aura '%s'. Probabilmente per dati danneggiati o una migrazione errata."
L["Unaffected"] = "Non interessato"
L["Undefined"] = "Non definito"
L["Unholy"] = "Empio"
L["Unholy Rune #1"] = "Runa empia n. 1"
L["Unholy Rune #2"] = "Runa empia n. 2"
L["Unit"] = "Unità"
L["Unit Characteristics"] = "Caratteristiche dell'unità"
L["Unit Destroyed"] = "Unità distrutta"
L["Unit Died"] = "Unità morta"
L["Unit Dissipates"] = "Unità dissipata"
L["Unit Frame"] = "Riquadro unità"
L["Unit Frames"] = "Riquadri unità"
L["Unit is Unit"] = "L'unità è l'unità"
L["Unit Name"] = "Nome unità"
L["Unit Name/Realm"] = "Nome/Reame unità"
L["Units Affected"] = "Unità interessate"
L["Units of affected Players in a table format"] = "Unità dei giocatori interessati in formato tabella"
L["Units of unaffected Players in a table format"] = "Unità dei giocatori non interessati in formato tabella"
L["Unknown action %q"] = "Azione sconosciuta %q"
L["Unknown feature %q"] = "Funzione sconosciuta %q"
L["unknown location"] = "posizione sconosciuta"
L["Unlimited"] = "Illimitato"
L["Untrigger %s"] = "Disinnesco %s"
L["Up"] = "Su"
L["Up, then Centered Horizontal"] = "In alto, poi centrato in orizzontale"
L["Up, then Left"] = "In alto, poi a sinistra"
L["Up, then Right"] = "In alto, poi a destra"
L["Update Position"] = "Aggiorna posizione"
L["Usage:"] = "Uso:"
L["Use /wa minimap to show the minimap icon again."] = "Usa /wa minimap per mostrare di nuovo l'icona della minimappa."
L["Use Custom Color"] = "Usa colore personalizzato"
L["Use Legacy floor rounding"] = "Usa arrotondamento per difetto legacy"
L["Use Texture"] = "Usa texture"
L["Use Watched Faction"] = "Usa fazione osservata"
L["Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."] = "Usa UnitInRange() per verificare se è a portata. Corrisponde al comportamento fuori portata dei riquadri raid predefiniti, tra 25 e 40 metri a seconda di classe e specializzazione."
L["Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."] = "L'uso di KUIAR_Runtime.clones è obsoleto. Usa KUIAR_Runtime.GetRegion(id, cloneId)."
L["Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."] = "L'uso di KUIAR_Runtime.regions è obsoleto. Usa KUIAR_Runtime.GetRegion(id)."
L["Vaelastrasz the Corrupt"] = "Vaelastrasz il Corrotto"
L["Versatility (%)"] = "Versatilità (%)"
L["Versatility Rating"] = "Punteggio versatilità"
L["Vertical"] = "Verticale"
L["Visibility"] = "Visibilità"
L["Visions of N'Zoth"] = "Visioni di N'Zoth"
L["Warband Quantity Total"] = "Quantità totale della Brigata"
L["Warband Transfer Percentage"] = "Percentuale di trasferimento della Brigata"
L["Warband Transferred Quantity"] = "Quantità trasferita della Brigata"
L["Warfront (Heroic)"] = "Fronte di guerra (Eroico)"
L["Warfront (Normal)"] = "Fronte di guerra (Normale)"
L["Warning"] = "Avviso"
L["Warning for unknown aura:"] = "Avviso per aura sconosciuta:"
L["Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"] = "Avviso: l'ancoraggio nell'aura '%s' è impossibile a causa di un ciclo di ancoraggio"
L["Warning: Full Scan auras checking for both name and spell id can't be converted."] = "Avviso: le aure di scansione completa che controllano sia il nome sia l'ID incantesimo non possono essere convertite."
L["Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."] = "Avviso: le informazioni sul nome sono ora disponibili tramite %affected, %unaffected. Il numero di membri del gruppo interessati tramite %unitCount. Alcune opzioni ora si comportano diversamente. Non viene adattato automaticamente."
L["Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."] = "Avviso: i valori della descrizione sono ora disponibili tramite %tooltip1, %tooltip2, %tooltip3 invece di %s. Non viene adattato automaticamente."
L["KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"] = "KUIAR_Engine integrato (63:42 | 3:07 | 10 | 2.4)"
L["KUIAR_Runtime has detected that it has been downgraded.\nYour saved auras may no longer work properly.\nWould you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.\nLast upgrade: %s\n\n|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r"] = "KUIAR_Runtime ha rilevato di essere stato riportato a una versione precedente.\nLe tue aure salvate potrebbero non funzionare più correttamente.\nVuoi eseguire lo strumento di riparazione |cffff0000SPERIMENTALE|r? Sovrascriverà tutte le modifiche fatte dopo l'ultimo aggiornamento del database.\nUltimo aggiornamento: %s\n\n|cffff0000Dovresti fare un BACKUP della cartella WTF PRIMA di premere questo pulsante.|r"
L["KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."] = "KUIAR_Engine sta creando uno snapshot di ripristino delle tue aure. Questo snapshot ti permetterà di tornare allo stato attuale delle aure se qualcosa va storto. Il processo può far calare il framerate finché non è completato."
L["KUIAR_Engine Profiling"] = "Profilazione di KUIAR_Engine"
L["KUIAR_Engine Profiling Report"] = "Rapporto di profilazione di KUIAR_Engine"
L["KUIAR_Engine Version: %s"] = "Versione di KUIAR_Engine: %s"
L["Weapon"] = "Arma"
L["Weapon Enchant"] = "Incantamento dell'arma"
L["Enchant Type"] = "Tipo di incantamento"
L["Imbue (Firestones, Mage Scrolls, Shaman Imbues)"] = "Infusione (Pietre del fuoco, Pergamene del mago, Infusioni dello sciamano)"
L["Oil, Stone or Poison"] = "Olio, Pietra o Veleno"
L["Weapon Enchant / Fishing Lure"] = "Incantamento dell'arma / Esca da pesca"
L["Whisper"] = "Sussurra"
L["Width"] = "Larghezza"
L["Wobble"] = "Oscillazione"
L["World Boss"] = "Boss mondiale"
L["World Bosses"] = "Boss mondiali"
L["Wrap"] = "A capo"
L["Writing to the KUIAR_Engine table is not allowed."] = "La scrittura nella tabella KUIAR_Engine non è consentita."
L["X-Offset"] = "Scostamento X"
L["Yell"] = "Urlare"
L["Y-Offset"] = "Scostamento Y"
L["You have new auras ready to be installed!"] = "Hai nuove aure pronte per l'installazione!"
L["Your next encounter will automatically be profiled."] = "Il tuo prossimo incontro verrà profilato automaticamente."
L["Your next instance of combat will automatically be profiled."] = "Il tuo prossimo combattimento verrà profilato automaticamente."
L["Your scheduled automatic profile has been cancelled."] = "La profilazione automatica programmata è stata annullata."
L["Your threat as a percentage of the tank's current threat."] = "La tua minaccia come percentuale della minaccia attuale del tank."
L["Your threat on the mob as a percentage of the amount required to pull aggro. Will pull aggro at 100."] = "La tua minaccia sul mob come percentuale di quella necessaria per attirare l'aggro. Attirerai l'aggro a 100."
L["Your total threat on the mob."] = "La tua minaccia totale sul mob."
L["Zone Group ID"] = "ID gruppo di zone"
L["Zone ID"] = "ID zona"
L["Zone Name"] = "Nome zona"
L["Zoom Animation"] = "Animazione di zoom"
L["Raid Leader"] = "Capo incursione"
L["Blizzard refused the Remaining Time countdown: %s"] = "Blizzard ha rifiutato il conto alla rovescia del Tempo rimanente: %s"
L["Blizzard refused the Remaining Time %s: %s"] = "Blizzard ha rifiutato il %s del Tempo rimanente: %s"
L["Row cells: %s. The next display is laid out from this display's carrier, which is the wrong place."] = "Celle di riga: %s. La visualizzazione successiva viene disposta a partire dal supporto di questa visualizzazione, che è il posto sbagliato."
L["Row cells: a button's artwork could not be placed on the row: %s"] = "Celle di riga: non è stato possibile collocare la grafica di un pulsante sulla riga: %s"
L["Row cells: a Total Duration filter and a Remaining Time glow condition share one measurement; this display keeps one spot in the row."] = "Celle di riga: un filtro Durata totale e una condizione di bagliore Tempo rimanente condividono una misurazione; questa visualizzazione mantiene un solo posto nella riga."
L["Row cells: a list of several units keeps one spot in the row; only single-unit lists lay out side by side."] = "Celle di riga: un elenco di più unità mantiene un solo posto nella riga; solo gli elenchi di una singola unità vengono disposti affiancati."
L["Row cells: this display's elements reach further than 8 row steps around the icon; the display keeps one spot in the row. Move the elements closer or make the spacing larger."] = "Celle di riga: gli elementi di questa visualizzazione si estendono oltre 8 passi di riga intorno all'icona; la visualizzazione mantiene un solo posto nella riga. Avvicina gli elementi o aumenta la spaziatura."
L["Row cells: a Centered row keeps one spot for this display."] = "Celle di riga: una riga centrata mantiene un solo posto per questa visualizzazione."
L["Row cells: a row on unit frames or nameplates keeps one spot for this display."] = "Celle di riga: una riga su riquadri unità o targhe nome mantiene un solo posto per questa visualizzazione."
L["Row cells: a wrapped list keeps one spot in the row."] = "Celle di riga: un elenco a capo mantiene un solo posto nella riga."
L["on"] = "attivato"
L["Row cells: built as one spot during combat (the client allows no packed construction under aura restrictions); laid out side by side when the restrictions end."] = "Celle di riga: costruita come un solo posto durante il combattimento (il client non consente costruzioni compatte con le restrizioni delle aure); disposta affiancata al termine delle restrizioni."
L["Row cells combat fallback (one spot while restricted, chained when restrictions end) is %s (/fa cells fallback on|off; applies to the next build)."] = "Il ripiego in combattimento delle celle di riga (un solo posto finché c'è la restrizione, concatenate al termine delle restrizioni) è %s (/fa cells fallback on|off; si applica alla prossima costruzione)."
L["bound: record %d beyond the spine, ignored."] = "legato: record %d oltre la dorsale, ignorato."
L["text"] = "testo"
L["binding"] = "legame"
L["button to the holder and its text"] = "pulsante al supporto e al suo testo"
L["artwork"] = "grafica"
L["span from the button"] = "intervallo dal pulsante"
L["bound record %d: %s"] = "record legato %d: %s"
L["FA build:"] = "Build FA:"
L["Row cells build reports are %s (/fa cells debug on|off)."] = "I rapporti di costruzione delle celle di riga sono %s (/fa cells debug on|off)."
L["Row cells: Stack Count >= n and <= n use the display's one stack-count binding, so a display with a %s stack text keeps one spot in the row; remove the stack text to lay it out side by side (= n keeps it: the count is known)."] = "Celle di riga: Conteggio cariche >= n e <= n usano l'unico legame del conteggio cariche della visualizzazione, quindi una visualizzazione con un testo di cariche %s mantiene un solo posto nella riga; rimuovi il testo delle cariche per disporla affiancata (= n lo mantiene: il conteggio è noto)."
L["  record %d: complete %s; elements %s; P %s; text [%s, %s]; count [%s, %s]; clip [%s, %s]"] = "  record %d: completo %s; elementi %s; P %s; testo [%s, %s]; conteggio [%s, %s]; ritaglio [%s, %s]"
L["  content %s; end %s"] = "  contenuto %s; fine %s"
L["REFERENCE: red, green, blue groups, all 30x30, 2 buttons each, 3 cells per line"] = "RIFERIMENTO: gruppi rosso, verde, blu, tutti 30x30, 2 pulsanti ciascuno, 3 celle per riga"
L["Row cells: a Stack Count filter together with a Total Duration = / >= or Remaining Time filter is not supported yet (its side-by-side construction was withdrawn); the display is not shown. Each filter alone lays out side by side."] = "Celle di riga: un filtro Conteggio cariche insieme a un filtro Durata totale = / >= o Tempo rimanente non è ancora supportato (la sua costruzione affiancata è stata ritirata); la visualizzazione non viene mostrata. Ogni filtro da solo dispone gli elementi affiancati."
L["UNRESOLVED (an anchor read nil)"] = "IRRISOLTO (un'ancora ha letto nil)"
L["NOT CLOSED (the empty text is not the baseline)"] = "NON CHIUSO (il testo vuoto non è la linea di base)"
L["NOT OPEN (the markup did not render)"] = "NON APERTO (il markup non è stato visualizzato)"
L["OFF by %.2f px"] = "SFASATO di %.2f px"
L["cell %d/%d %s: text [%s, %s] (extent %s for a %d px markup); spans [%s, %s] [%s, %s]; next holder -> %s, expected P + extent/4 = %s -> %s"] = "cella %d/%d %s: testo [%s, %s] (estensione %s per un markup di %d px); intervalli [%s, %s] [%s, %s]; supporto successivo -> %s, atteso P + estensione/4 = %s -> %s"
L["cell check done: %d of %d states OK."] = "controllo celle completato: %d stati su %d OK."
L["cell check: one text cell (markup %d px, L = %d px, q = 4: two spans) and its follower; %d states, each set in one frame and read in the next; the verdict compares the follower with P + extent/4 within %.2f px."] = "controllo celle: una cella di testo (markup %d px, L = %d px, q = 4: due intervalli) e la sua successiva; %d stati, ciascuno impostato in un frame e letto nel successivo; il verdetto confronta la successiva con P + estensione/4 entro %.2f px."
L["cell %d/%d %s: holder near edge P = %s; empty text [%s, %s] -> baseline b = %s"] = "cella %d/%d %s: bordo vicino del supporto P = %s; testo vuoto [%s, %s] -> linea di base b = %s"
L["DIFFERENT near edge"] = "Bordo vicino DIVERSO"
L["INCONCLUSIVE (unreadable)"] = "NON CONCLUSIVO (illeggibile)"
L["NOT REACHED (the fill is not the requested length)"] = "NON RAGGIUNTO (il riempimento non ha la lunghezza richiesta)"
L["SAME near edge"] = "STESSO bordo vicino"
L["fill %d/%d %s %s %s: bar [%s, %s], fill [%s, %s] -> %s"] = "riempimento %d/%d %s %s %s: barra [%s, %s], riempimento [%s, %s] -> %s"
L["reading"] = "lettura"
L["setup"] = "configurazione"
L["Row cells: Remaining Time on an Icon draws one aura and keeps one spot in the row (the row closes up while no aura is in the window); on bars, textures and texts the list lays out side by side."] = "Celle di riga: Tempo rimanente su un'icona disegna un'aura e mantiene un solo posto nella riga (la riga si richiude finché nessuna aura è nella finestra); su barre, texture e testi l'elenco viene disposto affiancato."
L["Row cells: a Stack Count filter that can never match keeps one spot in the row."] = "Celle di riga: un filtro Conteggio cariche che non può mai corrispondere mantiene un solo posto nella riga."
L[" (root dirty)"] = " (radice da aggiornare)"
L[" (the root among them)"] = " (inclusa la radice)"
L["already cleaning."] = "pulizia già in corso."
L["anchoring"] = "ancoraggio"
L["cleared."] = "ripulito."
L["clearing."] = "pulizia in corso."
L["creation"] = "creazione"
L["moving the root"] = "spostamento della radice"
L["normal"] = "normale"
L["not measuring (%s)."] = "misurazione non eseguita (%s)."
L["nothing to clear."] = "niente da ripulire."
L["resolution"] = "risoluzione"
L["reverse"] = "inverso"
L["stopped."] = "interrotto."
L["off"] = "disattivato"
L["Row cells: Blizzard refused %s %d times. This display keeps one spot in the row and shows nothing until its settings change or the interface is reloaded."] = "Celle di riga: Blizzard ha rifiutato %s per %d volte. Questa visualizzazione mantiene un solo posto nella riga e non mostra nulla finché le sue impostazioni non cambiano o l'interfaccia non viene ricaricata."
L["Row cells: Blizzard refused %s. This display keeps one spot in the row and shows nothing until it is laid out again."] = "Celle di riga: Blizzard ha rifiutato %s. Questa visualizzazione mantiene un solo posto nella riga e non mostra nulla finché non viene disposta di nuovo."
L["Row cells: the game made %d more aura record(s) than the 10 this row lays out; they are hidden."] = "Celle di riga: il gioco ha creato %d record di aura in più rispetto ai 10 che questa riga dispone; sono nascosti."
L["the member's end (%s)"] = "la fine del membro (%s)"
L["a row cell (%s)"] = "una cella di riga (%s)"
L["this display's place in the row (%s)"] = "il posto di questa visualizzazione nella riga (%s)"
L["the next member's place (%s)"] = "il posto del membro successivo (%s)"
L["Row cells: this display is laid out; Blizzard refused it %d times for these settings, so no further automatic repair is made until its settings change or the interface is reloaded."] = "Celle di riga: questa visualizzazione è disposta; Blizzard l'ha rifiutata %d volte con queste impostazioni, quindi non verranno effettuate ulteriori riparazioni automatiche finché le sue impostazioni non cambiano o l'interfaccia non viene ricaricata."
L["%d cell(s) could not be hidden, so the display reserves its full length meanwhile."] = "Impossibile nascondere %d cella/e, quindi nel frattempo il display riserva tutta la sua lunghezza."
L["  %s: not built"] = "  %s: non creato"
L["%d button(s): %s"] = "%d pulsante/i: %s"
L["FA carriers: %s is not a Modern Aura Group."] = "FA carriers: %s non è un Gruppo di aure moderne."
L["FA carriers: %s: setting %s"] = "FA carriers: %s: impostazione %s"
L["    container %d: %d buttons; callbacks with the container: %d attempted, %d constructed (styled afterwards), %d failed (%d refused operations); later: %d attempted, %d built, %d failed (%d refused operations); of the later ones under restrictions: %d attempted, %d built, %d failed; boxes now: %d placed, %d failed%s"] = "    contenitore %d: %d pulsanti; callback con il contenitore: %d tentate, %d costruite (stilizzate in seguito), %d fallite (%d operazioni rifiutate); successive: %d tentate, %d create, %d fallite (%d operazioni rifiutate); tra quelle successive con restrizioni: %d tentate, %d create, %d fallite; riquadri ora: %d posizionati, %d falliti%s"
L["    history since login (all containers of this display, not the current state): later callbacks %d attempted, %d built, %d failed; under restrictions %d attempted, %d built, %d failed"] = "    cronologia dall'accesso (tutti i contenitori di questo display, non lo stato attuale): callback successive %d tentate, %d create, %d fallite; con restrizioni %d tentate, %d create, %d fallite"
L["FA carriermarks: %s is not a Modern Aura Group."] = "FA carriermarks: %s non è un Gruppo di aure moderne."
L["FA carriermarks: %d mark(s) could not be removed yet; they will be tried again next time."] = "FA carriermarks: %d marcatore/i non ancora rimosso/i; si riproverà la prossima volta."
L["FA carriers: %s: setting %s, growth %s, independent group %s, editor open now %s, combat now %s"] = "FA carriers: %s: impostazione %s, crescita %s, gruppo indipendente %s, editor aperto ora %s, combattimento ora %s"
L["  pin (group frame): %s"] = "  fissaggio (cornice del gruppo): %s"
L["  %s: independent %s, pinned %s, end %s, boxes %s; configured: growth %s, size %sx%s, spacing %s, capacity %s, padding %s, own offset %s,%s"] = "  %s: indipendente %s, fissato %s, fine %s, riquadri %s; configurato: crescita %s, dimensione %sx%s, spaziatura %s, capacità %s, margine %s, scostamento proprio %s,%s"
L["    start: %s"] = "    inizio: %s"
L["    content: %s"] = "    contenuto: %s"
L["    end in use: %s at %s %s,%s; translated end %s"] = "    fine in uso: %s a %s %s,%s; fine traslata %s"
L["    container%d: %s"] = "    contenitore%d: %s"
L["    #%d record %s%s; button %s; H %s; P %s; box %s"] = "    record #%d %s%s; pulsante %s; H %s; P %s; riquadro %s"
L["      art: icon %s; base %s; elements %s; clip %s"] = "      grafica: icona %s; base %s; elementi %s; ritaglio %s"
L["    #%d no box (not an independent-carrier button); button %s"] = "    #%d senza riquadro (non è un pulsante a supporto indipendente); pulsante %s"
L["    events (epoch:event@time, flags at that moment): %s"] = "    eventi (epoca:evento@tempo, flag in quel momento): %s"
L["FA carriermarks: %s: red pin, cyan member starts, white rings content corners, yellow/orange container TOPLEFT/BOTTOMRIGHT (%d containers), blue native button corners (index below), green box corners (index above; dim = no complete record; %d boxes), magenta translated list ends. %d marker operations failed. Type /fa carriermarks off to remove."] = "FA carriermarks: %s: spillo rosso, membro ciano inizia, anelli bianchi angoli del contenuto, giallo/arancione contenitore TOPLEFT/BOTTOMRIGHT (%d contenitori), blu angoli del pulsante nativo (indice sotto), verde angoli del riquadro (indice sopra; attenuato = nessun record completo; %d riquadri), magenta estremità dell'elenco traslato. %d operazioni sui marcatori fallite. Digita /fa carriermarks off per rimuoverli."
L["nothing"] = "niente"
L["This aura's time or stack filter may leave it blank during combat in a Centered row.\n\nChoose another Grow setting, or move this aura out of the group."] = "Il filtro di tempo o cariche di questa aura può lasciarla vuota durante il combattimento in una riga centrata.\n\nScegli un'altra impostazione di Crescita, oppure sposta questa aura fuori dal gruppo."
L["Another aura in this row also uses a time or stack filter. This aura may appear blank or in the wrong place during combat.\n\nMove it to a separate row or group."] = "Un'altra aura in questa riga usa anch'essa un filtro di tempo o di cariche. Questa aura potrebbe risultare vuota o nel posto sbagliato durante il combattimento.\n\nSpostala in una riga o in un gruppo separato."
L["Remaining Time shows one aura: the first that matches the trigger, and the time window applies to that one only. Select the spell(s) in the trigger so the window applies to the aura you mean."] = "Tempo rimanente mostra un'aura: la prima che corrisponde all'innesco, e la finestra temporale si applica solo a quella. Seleziona gli incantesimi nell'innesco affinché la finestra si applichi all'aura che intendi."
L["This display will be built when aura restrictions end."] = "Questa visualizzazione verrà costruita al termine delle restrizioni delle aure."
L["Blizzard refused the extra units of this display %d times (%s). They are left out until the display's settings change or the interface is reloaded."] = "Blizzard ha rifiutato %d volte le unità aggiuntive di questo display (%s). Restano escluse finché le impostazioni del display non cambiano o l'interfaccia non viene ricaricata."
L["Use old row layout (before 1.1.0)"] = "Usa il vecchio layout di riga (prima della 1.1.0)"
L["Groups made before 1.1.0 have this ticked so they keep looking the same. Untick it to move this group to the current layout, where the row starts where you place the group, like a Dynamic Group; then place the group where the row should start. This box goes away once unticked."] = "I gruppi creati prima della 1.1.0 hanno questa casella selezionata per mantenere lo stesso aspetto. Deselezionala per spostare questo gruppo al layout attuale, in cui la riga inizia dove posizioni il gruppo, come in un Gruppo dinamico; poi posiziona il gruppo dove deve iniziare la riga. Questa casella scompare una volta deselezionata."
L["Won't match:"] = "Non corrisponderà:"
L["Another unit's spell is secret on this server, in and out of combat; only your own casts can be filtered by spell."] = "L'incantesimo di un'altra unità è segreto su questo server, in e fuori combattimento; solo i tuoi lanci possono essere filtrati per incantesimo."
L["Another unit's casts are secret on this server, in and out of combat: they show with their bar and timer, but cannot be filtered by spell."] = "I lanci di un'altra unità sono segreti su questo server, in e fuori combattimento: appaiono con barra e timer, ma non possono essere filtrati per incantesimo."
L["Money (total copper)"] = "Denaro (rame totale)"
L["Set up Blizzard's Cooldown Manager for KUIAR_Engine? This changes your CDM settings (backed up) and works on a copy of your Edit Mode layout named \"<layout>-FA\"; your own layout is left as it is. Needs a reload."] = "Configurare il Gestore dei tempi di recupero di Blizzard per KUIAR_Engine? Questo modifica le impostazioni del CDM (con backup) e lavora su una copia del tuo layout della modalità Modifica chiamata \"<layout>-FA\"; il tuo layout resta invariato. Richiede un ricaricamento."
L["A KUIAR_Engine class pack can set up Blizzard's Cooldown Manager for its auras (%d buffs, %d spell cooldowns). This changes your CDM settings and makes a copy of your Edit Mode layout named \"<layout>-FA\" with the viewers always visible; your own layout is left as it is. Needs a reload."] = "Un pacchetto di classe KUIAR_Engine può configurare il Gestore dei tempi di recupero di Blizzard per le sue aure (%d benefici, %d tempi di recupero degli incantesimi). Questo modifica le impostazioni del CDM e crea una copia del tuo layout della Modalità Modifica chiamata \"<layout>-FA\" con i visualizzatori sempre visibili; il tuo layout resta invariato. Richiede un ricaricamento."
L["Is Ready"] = "È pronto"
L["Elapsed Time"] = "Tempo trascorso"
L[" (+%d more)"] = " (+%d altri)"
L[", remaining %s %s s"] = ", rimanenti %s %s s"
L["A Glow can follow Remaining Time or the pandemic window, not both."] = "Un Bagliore può seguire il Tempo rimanente o la finestra di pandemia, non entrambi."
L["A Remaining Time glow condition must use < and turn the glow on."] = "Una condizione di bagliore sul Tempo rimanente deve usare < e attivare il bagliore."
L["An In Pandemic Window glow condition must turn the glow on."] = "Una condizione di bagliore In finestra di pandemia deve attivare il bagliore."
L["Anchored to a unit frame, nameplate, the mouse or a custom anchor, this display keeps its own position."] = "Ancorato a una cornice unità, una targhetta, al mouse o a un ancoraggio personalizzato, questo display mantiene la propria posizione."
L["Any (no classification)"] = "Qualsiasi (nessuna classificazione)"
L["Aura (Modern)"] = "Aura (Moderna)"
L["A condition with an Aura (Modern) check (Aura Active, Remaining Time, In Pandemic Window, Stack Count, dispel type...) cannot use Else If."] = "Una condizione con un controllo Aura (Moderna) (Aura attiva, Tempo rimanente, In finestra di pandemia, Numero di cariche, tipo di dissoluzione...) non può usare Altrimenti Se."
L["Aura (Modern) in a Dynamic Group: It keeps its position even when no aura is shown. Use a Modern Aura Group to keep dynamic behaviour."] = "Aura (Moderna) in un Gruppo dinamico: mantiene la sua posizione anche quando non è mostrata alcuna aura. Usa un Gruppo di aure moderne per mantenere il comportamento dinamico."
L["Aura (Modern) time conditions support < and >=."] = "Le condizioni di tempo di Aura (Moderna) supportano < e >=."
L["Aura (Modern) type conditions support = and !=."] = "Le condizioni di tipo di Aura (Moderna) supportano = e !=."
L["Aura (Modern) works on Icon, Progress Bar, Progress Texture, Texture and Text displays."] = "Aura (Moderna) funziona con i display Icona, Barra di avanzamento, Texture di avanzamento, Texture e Testo."
L["Aura Active"] = "Aura attiva"
L["Aura Highlight Border Thickness"] = "Spessore bordo evidenziazione aura"
L["Aura Highlight Color"] = "Colore evidenziazione aura"
L["Aura Highlight Padding"] = "Margine evidenziazione aura"
L["Aura Highlight Pulse Duration"] = "Durata pulsazione evidenziazione aura"
L["Aura Highlight Style"] = "Stile evidenziazione aura"
L["Aura Highlight Texture"] = "Texture evidenziazione aura"
L["Aura Highlight Thickness / Padding"] = "Spessore / margine evidenziazione aura"
L["Aura(s) Gained, shown %s s"] = "Aura/e ottenuta/e, mostrata/e per %s s"
L["Auras Blizzard classifies as big defensives."] = "Aure che Blizzard classifica come grandi difese."
L["Auras Blizzard classifies as external defensives."] = "Aure che Blizzard classifica come difese esterne."
L["Auras Blizzard identifies as boss auras or marks as relevant to your role."] = "Aure che Blizzard identifica come aure del boss o segna come rilevanti per il tuo ruolo."
L["Auras Blizzard identifies as boss auras."] = "Aure che Blizzard identifica come aure del boss."
L["Auras Blizzard marks as relevant to your role."] = "Aure che Blizzard segna come rilevanti per il tuo ruolo."
L["Auras Blizzard marks for display on all nameplates."] = "Aure che Blizzard segna per la visualizzazione su tutte le targhette."
L["Auras Blizzard marks for its personal-debuff display on nameplates."] = "Aure che Blizzard segna per la sua visualizzazione dei malefici personali sulle targhette."
L["Auras Blizzard says your character can apply."] = "Aure che Blizzard indica come applicabili dal tuo personaggio."
L["Auras cast by any player or player pet, not only yours. For your own auras, use Own Only."] = "Aure lanciate da qualsiasi giocatore o animale di un giocatore, non solo da te. Per le tue aure usa Solo proprie."
L["Auras cast by you, your pet or your vehicle."] = "Aure lanciate da te, dal tuo animale o dal tuo veicolo."
L["Auras flagged by Blizzard for raid-frame display in combat."] = "Aure segnate da Blizzard per la visualizzazione nelle finestre incursione in combattimento."
L["Auras that the player can cancel."] = "Aure che il giocatore può annullare."
L["Auras with a crowd-control effect, such as a stun or fear."] = "Aure con un effetto di controllo, come stordimento o paura."
L["Big defensive"] = "Grande difesa"
L["Big defensives"] = "Grandi difese"
L["Blizzard could not create the Aura(s) Missing display: %s"] = "Blizzard non ha potuto creare il display Aura/e mancante/i: %s"
L["Blizzard could not create the Modern Aura Group spacing: %s"] = "Blizzard non ha potuto creare la spaziatura del Gruppo di aure moderne: %s"
L["Blizzard could not create the Remaining Time display: %s"] = "Blizzard non ha potuto creare il display del Tempo rimanente: %s"
L["Blizzard could not register the %s sound for spell %s."] = "Blizzard non ha potuto registrare il suono %s per l'incantesimo %s."
L["Blizzard debuff order"] = "Ordine dei malefici di Blizzard"
L["Blizzard default"] = "Predefinito di Blizzard"
L["Blizzard hides %s on %s from spell ID filters in combat."] = "In combattimento Blizzard nasconde %s su %s dai filtri per ID incantesimo."
L["Blizzard hides debuffs on %s from spell ID filters in combat: filter by Total Duration =, dispel type and flags instead."] = "In combattimento Blizzard nasconde i malefici su %s dai filtri per ID incantesimo: filtra invece per Durata totale =, tipo di dissoluzione e flag."
L["Blizzard refused the %s check: %s"] = "Blizzard ha rifiutato il controllo %s: %s"
L["Blizzard refused the Modern Aura Group spacing; this display keeps a fixed space."] = "Blizzard ha rifiutato la spaziatura del Gruppo di aure moderne; questo display mantiene uno spazio fisso."
L["Blizzard's important-aura flag, including non-stealable enemy buffs shown on nameplates."] = "Il flag di aura importante di Blizzard, inclusi i benefici dei nemici non rubabili mostrati sulle targhette."
L["Border (Pulsing)"] = "Bordo (pulsante)"
L["Border thickness in UI units, limited to one quarter of the aura's smaller dimension so the center stays visible. Set style and color in this same condition."] = "Spessore del bordo in unità UI, limitato a un quarto della dimensione minore dell'aura perché il centro resti visibile. Imposta stile e colore in questa stessa condizione."
L["Boss or role aura"] = "Aura del boss o del ruolo"
L["Bounce In"] = "Rimbalzo in entrata"
L["Buff Is Not Stealable"] = "Beneficio non rubabile"
L["Buff Is Stealable"] = "Beneficio rubabile"
L["Buffs that can be stolen with abilities such as Spellsteal."] = "Benefici che possono essere rubati con abilità come Ruba incantesimo."
L["Buffs you can apply, or debuffs you can dispel."] = "Benefici che puoi applicare, o malefici che puoi dissolvere."
L["CDM Category"] = "Categoria CDM"
L["Can Apply Aura"] = "Può applicare aura"
L["Can apply / dispel"] = "Può applicare / dissolvere"
L["Cancelable"] = "Annullabile"
L["Cannot load Blizzard_AuraContainer: %s"] = "Impossibile caricare Blizzard_AuraContainer: %s"
L["Cast by a Player"] = "Lanciato da un giocatore"
L["Choose Action Button Glow, Pixel Glow, Autocast Shine or Proc Glow."] = "Scegli Bagliore del pulsante azione, Bagliore a pixel, Scintilla di lancio automatico o Bagliore di proc."
L["Choose a sound file in Actions."] = "Scegli un file audio in Azioni."
L["Choose a supported Blizzard classification."] = "Scegli una classificazione Blizzard supportata."
L["Choose a supported sort order."] = "Scegli un ordinamento supportato."
L["Choose a supported unit and Buff or Debuff."] = "Scegli un'unità supportata e Beneficio o Malefico."
L["Choose supported Blizzard aura filters."] = "Scegli filtri aura Blizzard supportati."
L["Choose supported dispel types."] = "Scegli tipi di dissoluzione supportati."
L["Cooldown Manager entries"] = "Voci del Gestore dei tempi di recupero"
L["Crowd control"] = "Controllo"
L["Custom Texture"] = "Texture personalizzata"
L["Debuffs Blizzard marks as high priority."] = "Malefici che Blizzard segna come ad alta priorità."
L["Debuffs on you or your pet can't be found by spell ID in combat: filter by Total Duration =, dispel type and flags instead."] = "I malefici su di te o sul tuo animale non si trovano per ID incantesimo in combattimento: filtra invece per Durata totale =, tipo di dissoluzione e flag."
L["Detached Text uses hardcoded text. Use other triggers and Conditions to control when it appears."] = "Il Testo staccato usa testo fisso. Usa altre attivazioni e Condizioni per controllare quando appare."
L["Dispel Type"] = "Tipo di dissoluzione"
L["Dispellable"] = "Dissolvibile"
L["Dispellable by someone in your raid"] = "Dissolvibile da qualcuno della tua incursione"
L["Dispellable raid debuff"] = "Malefico dell'incursione dissolvibile"
L["Dispellable regardless of your or your raid's current abilities."] = "Dissolvibile indipendentemente dalle abilità attuali tue o della tua incursione."
L["Display changes will apply when aura restrictions end."] = "Le modifiche al display verranno applicate al termine delle restrizioni delle aure."
L["Displayed in CDM"] = "Mostrato nel CDM"
L["Each aura spell ID must be a positive whole number."] = "Ogni ID incantesimo dell'aura deve essere un numero intero positivo."
L["Elapsed Time (%)"] = "Tempo trascorso (%)"
L["Enable Name(s) or Exact Spell ID(s) in the Trigger and enter a spell that is not ignored to use aura sounds."] = "Abilita Nome/i o ID incantesimo esatto/i nell'attivazione e inserisci un incantesimo non ignorato per usare i suoni delle aure."
L["End Time (game clock)"] = "Ora di fine (orologio di gioco)"
L["Enter a Specific Unit such as party1, raid5, boss1 or arena2."] = "Inserisci un'unità specifica come party1, raid5, boss1 o arena2."
L["Enter an aura name or spell ID, or untick Name(s)."] = "Inserisci il nome di un'aura o un ID incantesimo, oppure deseleziona Nome/i."
L["Enter an exact spell ID, or untick Exact Spell IDs to show all matching auras."] = "Inserisci un ID incantesimo esatto, oppure deseleziona ID incantesimo esatti per mostrare tutte le aure corrispondenti."
L["Enter an ignored spell ID, or untick Ignored Exact Spell IDs."] = "Inserisci un ID incantesimo ignorato, oppure deseleziona ID incantesimo esatti ignorati."
L["Exact Spell IDs"] = "ID incantesimo esatti"
L["External defensive"] = "Difesa esterna"
L["Extra space around a glow or custom texture, in UI units. Overlay always fills the aura and ignores padding. Set style and color in this same condition."] = "Spazio extra attorno a un bagliore o a una texture personalizzata, in unità UI. La sovrapposizione riempie sempre l'aura e ignora il margine. Imposta stile e colore in questa stessa condizione."
L["KUIAR_Engine has changed CDM settings. Reload to apply them."] = "KUIAR_Engine ha modificato le impostazioni del CDM. Ricarica per applicarle."
L["Friendly units only."] = "Solo unità amichevoli."
L["Glow (Pulsing)"] = "Bagliore (pulsante)"
L["Glow (Static)"] = "Bagliore (statico)"
L["Glow starts once the aura's duration is known."] = "Il bagliore inizia quando è nota la durata dell'aura."
L["Grouped by nameplate, choose the Nameplate unit."] = "Raggruppato per targhetta, scegli l'unità della targhetta."
L["Grouped by unit frame or nameplate, use Show On: Aura(s) Found."] = "Raggruppato per cornice unità o targhetta, usa Mostra quando: Aura/e trovata/e."
L["Grouped by unit frame, choose a unit other than Nameplate."] = "Raggruppato per cornice unità, scegli un'unità diversa da Targhetta."
L["Groups inside a Modern Aura Group keep their own position."] = "I gruppi all'interno di un Gruppo di aure moderne mantengono la propria posizione."
L["Hostile units only."] = "Solo unità ostili."
L["Ignore buff classification"] = "Ignora classificazione dei benefici"
L["Ignore debuff classification"] = "Ignora classificazione dei malefici"
L["Ignore dispel classification"] = "Ignora classificazione della dissoluzione"
L["Importance only"] = "Solo importanza"
L["Important aura"] = "Aura importante"
L["In Pandemic Window"] = "In finestra di pandemia"
L["In a Dynamic Group it keeps a fixed position; a Modern Aura Group is recommended."] = "In un Gruppo dinamico mantiene una posizione fissa; si consiglia un Gruppo di aure moderne."
L["In a Grid layout, Remaining Time, Total Duration and Stack Count filters are not available. This aura is shown at its own position."] = "In un layout a griglia i filtri Tempo rimanente, Durata totale e Numero di cariche non sono disponibili. Questa aura è mostrata nella sua posizione."
L["In a Grid layout, choose one unit (Player, Target, Focus, Pet...). This aura is shown at its own position."] = "In un layout a griglia scegli una sola unità (Giocatore, Bersaglio, Focus, Animale...). Questa aura è mostrata nella sua posizione."
L["In a Grid layout, every aura watches the same unit as the first one. This aura is shown at its own position."] = "In un layout a griglia ogni aura osserva la stessa unità della prima. Questa aura è mostrata nella sua posizione."
L["In a Grid layout, use Show On: Aura(s) Found. This aura is shown at its own position."] = "In un layout a griglia usa Mostra quando: Aura/e trovata/e. Questa aura è mostrata nella sua posizione."
L["In a Grid, Remaining Time is not available."] = "In una griglia il Tempo rimanente non è disponibile."
L["In a Modern Aura Group, use an Icon, Progress Bar, Progress Texture, Texture or Text display."] = "In un Gruppo di aure moderne usa un display Icona, Barra di avanzamento, Texture di avanzamento, Texture o Testo."
L["Include global cooldown"] = "Includi tempo di recupero globale"
L["Includes helpful enrages on enemies."] = "Include le furie benefiche sui nemici."
L["Incompatible condition."] = "Condizione incompatibile."
L["Invalid aura filter: %s"] = "Filtro aura non valido: %s"
L["Invalid classification option: %s"] = "Opzione di classificazione non valida: %s"
L["Is Boss Aura"] = "È un'aura del boss"
L["Is Stealable"] = "È rubabile"
L["Item ID"] = "ID oggetto"
L["Marked for all nameplates"] = "Segnato per tutte le targhette"
L["Marked for personal debuff display"] = "Segnato per la visualizzazione dei malefici personali"
L["Maximum total duration must be a positive number."] = "La durata totale massima deve essere un numero positivo."
L["Mouseover"] = "Al passaggio del mouse"
L["Name (Blizzard priority)"] = "Nome (priorità Blizzard)"
L["No recording for '%s' in the selected FojjiCore voice pack."] = "Nessuna registrazione per '%s' nel pacchetto vocale FojjiCore selezionato."
L["On the screen, Aura(s) Missing, Always and Remaining Time watch one unit: choose Player, Target, Focus, Pet, Target of Target, Target of Focus, Pet Target or a Specific Unit. Anchored to unit frames or nameplates, Missing and Always work for every unit."] = "Sullo schermo, Aura/e mancante/i, Sempre e Tempo rimanente controllano un'unità: scegli Giocatore, Bersaglio, Focus, Famiglio, Bersaglio del bersaglio, Bersaglio del focus, Bersaglio del famiglio o Unità specifica. Se ancorati ai riquadri unità o alle targhe nome, Mancante e Sempre funzionano per ogni unità."
L["On this display type, Remaining Time can't be combined with Total Duration = or >=."] = "In questo tipo di visualizzazione, Tempo rimanente non può essere combinato con Durata totale = o >=."
L["Only Aura Active can be combined with All of / Any of, once, with ordinary checks."] = "Solo Aura attiva può essere combinata con Tutti di / Uno qualsiasi di, una volta, con i controlli ordinari."
L["Order applied"] = "Ordine applicato"
L["Overlay"] = "Sovrapposizione"
L["Own Only"] = "Solo propri"
L["PLAYER"] = "GIOCATORE"
L["Pet Target"] = "Bersaglio del famiglio"
L["Preview only: these auras will not display in combat with spell ID filters.\nConfigured sounds in Actions can still play."] = "Solo anteprima: queste aure non verranno mostrate in combattimento con i filtri per ID incantesimo.\nI suoni configurati in Azioni possono comunque essere riprodotti."
L["Priority debuff"] = "Danno prioritario"
L["Ready"] = "Pronto"
L["Recharging"] = "In ricarica"
L["Remaining Time (%)"] = "Tempo rimanente (%)"
L["Remaining Time can't anchor to unit frames or nameplates."] = "Tempo rimanente non può ancorarsi ai riquadri unità o alle targhe nome."
L["Remaining Time needs a comparison and a number of seconds of 0 or more."] = "Tempo rimanente richiede un confronto e un numero di secondi pari o superiore a 0."
L["Remaining time"] = "Tempo rimanente"
L["Remaining time (Blizzard priority)"] = "Tempo rimanente (priorità Blizzard)"
L["Role aura"] = "Aura di ruolo"
L["With an Aura (Modern) trigger, On Show/On Hide support Play Sound and Hide Glows only. Custom Init is available."] = "Con un innesco Aura (moderna), Alla comparsa/Alla scomparsa supportano solo Riproduci suono e Nascondi bagliori. Init personalizzato è disponibile."
L["With an Aura (Modern) trigger, the display's own Start/Main/Finish animations do not play; use the aura animations on the Animations tab."] = "Con un innesco Aura (moderna), le animazioni Inizio/Principale/Fine della visualizzazione non vengono riprodotte; usa le animazioni dell'aura nella scheda Animazioni."
L["Secret Auras"] = "Aure segrete"
L["Secret aura sounds support sound files, not Sound Kit IDs or Stop Sound."] = "I suoni delle aure segrete supportano file audio, non ID Sound Kit né Interrompi suono."
L["Secret auras support one text element for each of %p, %s and %n. Remove the duplicate or turn off Show Text."] = "Le aure segrete supportano un elemento di testo per ciascuno di %p, %s e %n. Rimuovi il duplicato o disattiva Mostra testo."
L["Select one recorded voice pack in FojjiCore. Recorded sounds cannot use synthesized TTS or random favorites."] = "Seleziona un pacchetto vocale registrato in FojjiCore. I suoni registrati non possono usare il TTS sintetizzato né i preferiti casuali."
L["Set Dynamic Information to this trigger."] = "Imposta informazioni dinamiche per questo innesco."
L["Shown on raid frames in combat"] = "Mostrato sui riquadri del raid in combattimento"
L["Sounds in Actions still play."] = "I suoni in Azioni vengono comunque riprodotti."
L["Speech is disabled in FojjiCore."] = "Il parlato è disattivato in FojjiCore."
L["Spell IDs (All Ranks)"] = "ID incantesimo (tutti i gradi)"
L["Spell In Range"] = "Incantesimo a portata"
L["Spin In"] = "Giro in entrata"
L["Stack Count < 0 never matches."] = "Conteggio cariche < 0 non corrisponde mai."
L["Stack Count can't anchor to unit frames or nameplates."] = "Conteggio cariche non può ancorarsi ai riquadri unità o alle targhe nome."
L["Stack Count can't be combined with Total Duration = or >=."] = "Conteggio cariche non può essere combinato con Durata totale = o >=."
L["Stack Count needs a whole number from 0 to %d."] = "Conteggio cariche richiede un numero intero da 0 a %d."
L["Stack Count only works with Show On: Aura(s) Found, without Remaining Time."] = "Conteggio cariche funziona solo con Mostra su: Aura/e trovata/e, senza Tempo rimanente."
L["Start Time (game clock)"] = "Ora di inizio (orologio di gioco)"
L["Target of Focus"] = "Bersaglio del focus"
L["Target of Target"] = "Bersaglio del bersaglio"
L["The Remaining Time glow could not be measured; it stays off."] = "Non è stato possibile misurare il bagliore di Tempo rimanente; resta disattivato."
L["This client can't check Remaining Time on this display type."] = "Questo client non può controllare Tempo rimanente su questo tipo di visualizzazione."
L["This client can't check Stack Count."] = "Questo client non può controllare Conteggio cariche."
L["This client can't check Total Duration = or >=."] = "Questo client non può controllare Durata totale = o >=."
L["This client cannot limit auras by Remaining Time."] = "Questo client non può limitare le aure in base a Tempo rimanente."
L["This client does not expose nameplate frames."] = "Questo client non espone i riquadri delle targhe nome."
L["This client does not provide native aura sound registration."] = "Questo client non fornisce la registrazione nativa dei suoni delle aure."
L["This client does not support native circular Progress Textures."] = "Questo client non supporta le texture di avanzamento circolari native."
L["This client does not support the selected Blizzard aura filters."] = "Questo client non supporta i filtri aura di Blizzard selezionati."
L["This sub element is not supported by Secret Auras. Use Text, Texture or Glow."] = "Questo sotto-elemento non è supportato dalle aure segrete. Usa Testo, Texture o Bagliore."
L["Timer Available"] = "Timer disponibile"
L["Total Duration = and >= can't anchor to unit frames or nameplates."] = "Durata totale = e >= non possono ancorarsi ai riquadri unità o alle targhe nome."
L["Total Duration = and >= only work with Show On: Aura(s) Found, without Remaining Time."] = "Durata totale = e >= funzionano solo con Mostra su: Aura/e trovata/e, senza Tempo rimanente."
L["Trigger Combination: the trigger chosen for when Aura (Modern) filters are not met no longer exists or is an Aura (Modern) trigger."] = "Combinazione di inneschi: l'innesco scelto per quando i filtri Aura (moderna) non sono soddisfatti non esiste più o è un innesco Aura (moderna)."
L["Unavailable in this specialization"] = "Non disponibile in questa specializzazione"
L["Unit-frame debuff sorting requires the Debuff or Dispellable raid debuff classification."] = "L'ordinamento dei danni nocivi sul riquadro unità richiede la classificazione Danno nocivo o Danno nocivo dissolvibile del raid."
L["Use dispellable-debuff classification"] = "Usa classificazione dei danni nocivi dissolvibili"
L["Use one time basis per countdown text: seconds, percentage, elapsed, total, start, or end."] = "Usa una sola base temporale per testo del conto alla rovescia: secondi, percentuale, trascorso, totale, inizio o fine."
L["With Centered growth this display keeps its own position: only icons and texts join a centred row (with the old row layout off, also textures, bars and progress textures)."] = "Con la crescita centrata questa visualizzazione mantiene la propria posizione: solo icone e testi si uniscono a una riga centrata (con il vecchio layout di riga disattivato, anche texture, barre e texture di avanzamento)."
L["With Grid or Group by Frame, only Aura (Modern) displays line up. This display keeps its own position."] = "Con Griglia o Raggruppa per riquadro, solo le visualizzazioni Aura (moderna) si allineano. Questa visualizzazione mantiene la propria posizione."
L["With Remaining Time, countdown conditions must use Remaining Time in seconds."] = "Con Tempo rimanente, le condizioni del conto alla rovescia devono usare Tempo rimanente in secondi."
L["Won't work:"] = "Non funzionerà:"
L["Works in combat."] = "Funziona in combattimento."
L["You can only use %p, %s, %n, %l or hardcoded text. Put each code in its own text element. Custom text (%c) is not supported."] = "Puoi usare solo %p, %s, %n, %l o testo fisso. Metti ogni codice nel proprio elemento di testo. Il testo personalizzato (%c) non è supportato."
L["Zoom In"] = "Ingrandimento"
L["Apply"] = "Applica"
L["Not now"] = "Non ora"
L["Don't ask again"] = "Non chiedere più"
L["Hitch capture armed for the next reload: frames slower than %dms are reported from addon load until %d s after entering the world."] = "Cattura dei rallentamenti attivata per il prossimo ricaricamento: i frame più lenti di %dms vengono segnalati dal caricamento dell'addon fino a %d s dopo l'ingresso nel mondo."
L["Entered the world; hitch capture continues for %d s."] = "Sei entrato nel mondo; la cattura dei rallentamenti continua per %d s."
L["/wa phitch login [ms] [seconds] - Run the hitch capture through the next reload and login, then print the load time and profile"] = "/wa phitch login [ms] [secondi] - Esegue la cattura dei rallentamenti fino al prossimo ricaricamento e accesso, poi mostra il tempo di caricamento e il profilo"

end)
