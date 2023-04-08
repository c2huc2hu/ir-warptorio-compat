------------------------------------------------------------------------------------------------------------------------------------------------------

-- TECHNOLOGY

-- print(serpent.block(data.raw.technology))

-- TECHNOLOGY CRASHES
-- these techs have been renamed from IR2 -> IR3, but the compatibility layer doesn't handle this properly.
local conversion = {
    ["advanced-material-processing"] = "ir-bronze-furnace",
    ["advanced-material-processing-2"] = "ir-electric-furnace",
    ["flammables"] = "ir-coking"
}

for _,tech in pairs(data.raw.technology) do
    if tech.prerequisites then
        for k,prereq in pairs(tech.prerequisites) do
            if conversion[prereq] then
                tech.prerequisites[k] = conversion[prereq]
            end
        end
    end
end

-- fix cycle:
-- move rocket silo to depend on reactor 7, not 8.
-- 8 depends on silo due to something from IR (maybe the auto cost setting)
local silo_tech = data.raw.technology['rocket-silo']
for i, prereq in pairs(silo_tech.prerequisites) do
    if prereq == "warptorio-reactor-8" then
        table.remove(silo_tech.prerequisites, i)
    end
end
table.insert(data.raw.technology['warptorio-reactor-7'].prerequisites, 'rocket-silo')

-- Add shotgun turrets to warptorio damage researches
table.insert(data.raw.technology["warptorio-physdmg-1"].effects, {type="turret-attack",modifier=0.15,turret_id="scattergun-turret"})

-- Add steel-axe back so that warptorio-axe researches are enabled
data.raw.technology['steel-axe'].enabled = true
data.raw.technology['steel-axe'].hidden = false
data.raw.technology['steel-axe'].unit.count = 10

-- Add toolbelt back so that warptorio toolbelt researches are enabled
data.raw.technology['toolbelt'].enabled = true
data.raw.technology['toolbelt'].hidden = false
data.raw.technology['toolbelt'].unit.count = 10


-- RECIPE MODIFICATIONS

-- Rebalance: Reduce smelting time for crushed and pure ores to make it
-- worth the extra space needed for processing

local mined_metals = {'copper', 'tin', 'iron', 'gold'}
local rare_metals = {'nickel', 'lead', 'chromium', 'platinum'}

local smelting_processes_crushed = {
    ['-ingot-from-crushed'] = 5,
}
local smelting_processes_washed = {
    ['-ingot-from-pure'] = 6,
    ['-molten-from-pure'] = 8,
}
local smelting_processes_blast = {
    ['-ingot-from-crushed-blast'] = 5,
    ['-ingot-from-pure-blast'] = 6,
}

for _, metal in ipairs(mined_metals) do
    for suffix, new_time in pairs(smelting_processes_crushed) do
        data.raw.recipe[metal..suffix].energy_required = new_time
    end
    for suffix, new_time in pairs(smelting_processes_washed) do
        data.raw.recipe[metal..suffix].energy_required = new_time
    end
end
for _, metal in ipairs(rare_metals) do
    for suffix, new_time in pairs(smelting_processes_washed) do
        data.raw.recipe[metal..suffix].energy_required = new_time
    end
end
for suffix, new_time in pairs(smelting_processes_blast) do
    data.raw.recipe['iron'..suffix].energy_required = new_time
end


-- NEW ITEMS

-- Rebalance: Add chrome-tier chests
-- (sorry about the lazy retinting, everyone)
local chromium_chest_tint = {r = 1.0, g = 0.9, b = 0.7, a = 1.0}

local chromium_chest_container = table.deepcopy(data.raw["container"]["tin-chest"])
chromium_chest_container.name = 'chromium-chest'
chromium_chest_container.minable.result = 'chromium-chest'
chromium_chest_container.next_upgrade = nil
chromium_chest_container.max_health = 400
chromium_chest_container.inventory_size = 60
chromium_chest_container.picture.layers[1].tint = chromium_chest_tint

local chromium_chest_item = table.deepcopy(data.raw["item"]["tin-chest"])
chromium_chest_item.name = 'chromium-chest'
chromium_chest_item.place_result = 'chromium-chest'
chromium_chest_item.order = "a[items]-d[chromium-chest]"
chromium_chest_item.icons[1].tint = chromium_chest_tint

local chromium_chest_recipe = table.deepcopy(data.raw["recipe"]["tin-chest"])
chromium_chest_recipe.name = "chromium-chest"
chromium_chest_recipe.result = "chromium-chest"
chromium_chest_recipe.order = "a[items]-d[chromium-chest]"
chromium_chest_recipe.ingredients = {{"chromium-rod", 6}, {"chromium-plate", 6}}

data:extend({chromium_chest_container, chromium_chest_item, chromium_chest_recipe})

data.raw["container"]["steel-chest"].next_upgrade = 'chromium-chest'
table.insert(data.raw["technology"]["ir-electroplating"].effects, {recipe = "chromium-chest", type = "unlock-recipe"})
