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


-- Rebalance: Add chrome-tier chests
data:extend(
{
  {
    type = "item",
    name = "chrome-chest",
    icons = {
        icon = "__base__/graphics/icons/steel-chest.png",
        tint = {r=0,g=0.3,b=0,a=0.3}
    },
    icon_size = 32,
    subgroup = "storage",
    order = "a[items]-d[chrome-chest]",
    place_result = "chrome-chest",
    stack_size = 50
  }
})


local chromeChest = table.deepcopy(data.raw["container"]["steel-chest"]) -- copy the table that defines the heavy armor item into the fireArmor variable
chromeChest.name = "chrome-chest"
-- chromeChest.icons = {
--     icon = "__base__/graphics/icons/steel-chest.png",
--     tint = {r=0,g=0.3,b=0,a=0.3}
-- }

chromeChest.inventory_size = 60
chromeChest.max_health = 500
chromeChest.minable = {
    mining_time = 0.2,
    result = "steel-chest"
}
chromeChest.picture.tint = {r=0,g=0.3,b=0,a=0.3}
-- data.raw.container['steel-chest'].next_upgrade = 'chrome-chest'


local recipe = table.deepcopy(data.raw["recipe"]["steel-chest"])
recipe.enabled = true
recipe.name = "chrome-chest"
recipe.ingredients = {{"copper-plate",200},{"steel-plate",50}}
recipe.result = "chrome-chest"


data:extend{chromeChest, recipe}

-- Rebalance: Increase smelting speed of crushed ores by 25% and washed ores by 50%
-- to make them worth the extra space needed for processing
