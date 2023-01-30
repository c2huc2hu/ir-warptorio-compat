-- TECHNOLOGY REBALANCES
-- Convert techs that have changed places in the tech tree

tech_mapping = {
    ["steel"]="ir-iron-milestone",
    ["electric-energy-distribution-1"]="ir-electronics-1",
    ["fast-inserter"]="engine",
    ["stack-inserter"]="ir-electric-furnace",

    ["mining-productivity-1"]="ir-gold-milestone",
    ["mining-productivity-2"]="ir-grinding-3",
    ["mining-productivity-3"]="ir-mining-2",

    ["nuclear-fuel-reprocessing"]="ir-electrum-milestone",

}

for _, tech in pairs(data.raw.technology) do
    if tech.name:find("^warptorio") and tech.prerequisites then
        for i, prereq in pairs(tech.prerequisites) do
            if tech_mapping[prereq] then
                tech.prerequisites[i] = tech_mapping[prereq]
            end
        end
    end
end
