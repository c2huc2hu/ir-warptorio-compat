for _,force in pairs(game.forces) do
  if force.technologies["ir-electroplating"].researched then
    force.recipes["chromium-chest"].enabled = true
  end
end
