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

