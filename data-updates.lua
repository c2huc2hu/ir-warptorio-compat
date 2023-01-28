------------------------------------------------------------------------------------------------------------------------------------------------------

-- TECHNOLOGY

-- print(serpent.block(data.raw.technology))

-- TECHNOLOGY CRASHES
-- these techs have been renamed from IR2 -> IR3, but the compatibility layer doesn't handle this properly.
local conversion = {
    ["advanced-material-processing"] = "ir-bronze-furnace",
    ["advanced-material-processing-2"] = "ir-electric-furnace",
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


-- TECHNOLOGY REBALANCES
-- harvester floor is locked behind blue science. rebalance it to be very early g science.
-- note: in normal warptorio it is actually late red, but I think this is reasonable
local harvester_tech = data.raw.technology['warptorio-harvester-floor']
for i,prereq in pairs(harvester_tech.prerequisites) do
    if prereq == "fast-inserter" then
        harvester_tech.prerequisites[i] = "engine"
    end
end

-- Add shotgun turrets to warptorio damage researches
table.insert(data.raw.technology["warptorio-physdmg-1"].effects, {type="turret-attack",modifier=0.15,turret_id="scattergun-turret"})
