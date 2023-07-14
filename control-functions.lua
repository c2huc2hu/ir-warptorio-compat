-- Modified from IR3 CONTROL.add_starting_resources
function distance_squared(a, b)
    return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2
end

function random_polar(min_distance, max_distance)
    local theta = math.random()*math.pi*2
    local distance = math.random() * (max_distance - min_distance) + min_distance
    return {x = math.cos(theta) * distance, y = math.sin(theta) * distance}
end

function add_starting_fissure(surface)
    if surface and surface.valid then
        -- starting area fissures
        local resources = {"copper-ore","coal","tin-ore"}
        local nearest = {}
        for _,resource in pairs(resources) do
            local entities = surface.find_entities_filtered{type = "resource", name = resource, radius = 256, position = {0, 0}}
            if entities and table_size(entities) > 0 then           
                for _,entity in pairs(entities) do
                    if nearest[resource] == nil or distance_squared({x=0,y=0},entity.position) < distance_squared({x=0,y=0},nearest[resource]) then
                        nearest[resource] = entity.position
                    end
                end
            end
        end

        local name = "steam-fissure"
        local fissure_origin = {x = 0, y = 0}

        if table_size(nearest) == 0 then
            -- On barren worlds, spawn a small distance from the platform so it doesn't overlap
            fissure_origin = random_polar(64, 96)

        else
            -- On normal worlds, spawn close to the average position of resource patches
            for _,resource in pairs(nearest) do
                fissure_origin.x = fissure_origin.x + resource.x
                fissure_origin.y = fissure_origin.y + resource.y
            end
            fissure_origin = {x = fissure_origin.x / table_size(nearest), y = fissure_origin.y / table_size(nearest)}

            local theta = math.random()*math.pi*2
            local distance = 10
            fissure_origin = { x = fissure_origin.x + (math.cos(theta)*distance), y = fissure_origin.y + (math.sin(theta)*distance) }
        end

        local p = surface.find_non_colliding_position(name, fissure_origin, 32, 0.5, true)
        if p then
            local fissure = surface.create_entity{name=name, position=p, raise_built=true}
            if fissure and fissure.valid then surface.destroy_decoratives{radius = 2.5, area = fissure.bounding_box} end
        end
    end
end

function add_junkpiles(surface, n)
    if surface and surface.valid then
        for i = 1,n do
            local centre = random_polar(64, 256)
            local non_collinding_position = surface.find_non_colliding_position("copper-tin-junkpile", centre, 16, 0.5, true)
            if non_collinding_position then
                surface.create_entity{name="copper-tin-junkpile", position=non_collinding_position, create_build_effect_smoke = false}
            end
        end
    end
end
