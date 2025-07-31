import "Turbine.UI.Lotro"
import "Turbine.Gameplay";



function GetItemFromID(itemID)
    if itemID == nil then return end;
    local function GetHex(IN)
            local B,K,OUT,I,D=16,"0123456789ABCDEF","",0,0;
            if IN == 0 or IN == "0" then return "00" end;
            while IN>0 do
                    I=I+1
                    IN,D=math.floor(IN/B),math.mod(IN,B)+1
                    OUT=string.sub(K,D,D)..OUT
            end
            if string.len(OUT)==1 then OUT="0"..OUT end;
            return OUT
    end
    local itemHex = GetHex(itemID);
    local cItemInspect = Turbine.UI.Lotro.Quickslot();
    cItemInspect:SetSize(1,1);
    cItemInspect:SetVisible(false);
    local function SetItemShortcut()        -- PCALL THIS incase item does not exist
            cItemInspect:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Item, "0x0,0x" .. itemHex));
    end
    if pcall(SetItemShortcut) then
        SetItemShortcut();
        local item = cItemInspect:GetShortcut():GetItem();
        cItemInspect = nil;
        print(item:GetItemInfo():GetName());
    else
        print("nope")
    end
    cItemInspect = nil;
end


ClassNames = {
    [214] = "Beorning",
    [215] = "Brawler",
    [40] = "Burglar",
    [24] = "Captain",
    [172] = "Champion",
    [23] = "Guardian",
    [162] = "Hunter",
    [185] = "LoreMaster",
    [216] = "Mariner",
    [31] = "Minstrel",
    [193] = "RuneKeeper",
    [194] = "Warden",
    [71] = "Reaver",
    [128] = "Defiler",
    [179] = "Blackarrow",
    [52] = "Warleader",
    [127] = "Weaver",
    [126] = "Stalker",
    [192] = "Chicken"
};

function print(text) Turbine.Shell.WriteLine("<rgb=#00FFFF>StatsExporter:</rgb> "..tostring(text)) end

function SaveComplete(success, errorMessage)
    if not success then
        print("Error saving file!");
    else
        print("Successfully saved data!");
    end
end

MainWindow = Turbine.UI.Lotro.Window();
MainWindow:SetSize(500, 300);
MainWindow:SetText("Character Stats Exporter");
MainWindow:SetVisible(false);

ExportCharStatsButton = Turbine.UI.Lotro.Button();
ExportCharStatsButton:SetParent(MainWindow);
ExportCharStatsButton:SetText("Export Character Stats to File");
ExportCharStatsButton:SetPosition(125, 50);
ExportCharStatsButton:SetSize(250, 30);

ItemSlot = Turbine.UI.Lotro.Quickslot();
ItemSlot:SetParent(MainWindow);
ItemSlot:SetPosition(232, 100);
ItemSlot:SetSize(36, 36);
ItemSlot:SetBackColor(Turbine.UI.Color(0.2,0.2,0.2))

AddItemButton = Turbine.UI.Lotro.Button();
AddItemButton:SetParent(MainWindow);
AddItemButton:SetText("Add Item");
AddItemButton:SetPosition(125, 150);
AddItemButton:SetSize(250, 30);

ExportItemsButton = Turbine.UI.Lotro.Button();
ExportItemsButton:SetParent(MainWindow);
ExportItemsButton:SetText("Export Items to File");
ExportItemsButton:SetPosition(125, 200);
ExportItemsButton:SetSize(250, 30);


ItemSlot.DragDrop = function(sender, args)
    local shortcut = sender:GetShortcut()
    local item = shortcut:GetItem()
    local data = shortcut:GetData()
    local info = item:GetItemInfo()
    local name = item:GetName()
    print(name)
    print(item)
    print(info)
    for k,v in pairs(info) do
        print(k)
        print(v)
    end
end



function ExportCharStatsButton_Click(sender, args)
    local character = Turbine.Gameplay.LocalPlayer.GetInstance();
    local characterAttributes = character:GetAttributes();

    local originalColor = ExportCharStatsButton:GetForeColor();
    ExportCharStatsButton:SetForeColor(Turbine.UI.Color.ForestGreen);

    local statsTable = {
        Class = ClassNames[character:GetClass()],
        Level = character:GetLevel(),
        Morale = character:GetMaxMorale(),
        InCombatMoraleRegeneration = characterAttributes:GetInCombatMoraleRegeneration() * 60,
        NonCombatMoraleRegeneration = characterAttributes:GetOutOfCombatMoraleRegeneration() * 60,
        Power = character:GetMaxPower(),
        InCombatPowerRegeneration = characterAttributes:GetInCombatPowerRegeneration() * 60,
        NonCombatPowerRegeneration = characterAttributes:GetOutOfCombatPowerRegeneration() * 60,
        Armour = characterAttributes:GetArmor(),
        Might = characterAttributes:GetMight(),
        Agility = characterAttributes:GetAgility(),
        Vitality = characterAttributes:GetVitality(),
        Will = characterAttributes:GetWill(),
        Fate = characterAttributes:GetFate(),
        --CriticalRatingBase = characterAttributes:GetBaseCriticalHitChance(),
        CriticalRatingMelee = characterAttributes:GetMeleeCriticalHitChance(),
        CriticalRatingRange = characterAttributes:GetRangeCriticalHitChance(),
        CriticalRatingTactical = characterAttributes:GetTacticalCriticalHitChance(),
        FinesseRating = characterAttributes:GetFinesse(),
        PhysicalMasteryRatingMelee = characterAttributes:GetMeleeDamage(),
        PhysicalMasteryRatingRange = characterAttributes:GetRangeDamage(),
        TacticalMasteryRating = characterAttributes:GetTacticalDamage(),
        OutgoingHealingRating = characterAttributes:GetOutgoingHealing(),
        ResistanceRating = characterAttributes:GetBaseResistance(),
        CriticalDefenceRating = characterAttributes:GetBaseCriticalHitAvoidance(),
        --CriticalDefenceRatingMelee = characterAttributes:GetMeleeCriticalHitAvoidance(),
        --CriticalDefenceRatingRange = characterAttributes:GetRangeCriticalHitAvoidance(),
        --CriticalDefenceRatingTactical = characterAttributes:GetTacticalCriticalHitAvoidance(),
        IncomingHealingRating = characterAttributes:GetIncomingHealing(),
        BlockChanceRating = characterAttributes:GetBlock(),
        PartialBlockChanceRating = characterAttributes:GetBlock(),
        PartialBlockMitigationRating = characterAttributes:GetBlock(),
        ParryChanceRating = characterAttributes:GetParry(),
        PartialParryChanceRating = characterAttributes:GetParry(),
        PartialParryMitigationRating = characterAttributes:GetParry(),
        EvadeChanceRating = characterAttributes:GetEvade(),
        PartialEvadeChanceRating = characterAttributes:GetEvade(),
        PartialEvadeMitigationRating = characterAttributes:GetEvade(),
        PhysicalMitigationRating = characterAttributes:GetPhysicalMitigation(),
        TacticalMitigationRating = characterAttributes:GetTacticalMitigation(),
    };
    print("Saving information to file...")
    local jsonStats = Turbine.PluginData.Save(Turbine.DataScope.Character, "Stats", statsTable, SaveComplete);
    ExportCharStatsButton:SetForeColor(originalColor);
end

ExportCharStatsButton.Click = ExportCharStatsButton_Click;

MainWindow:SetVisible(true);
