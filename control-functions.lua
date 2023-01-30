-- Modified from IR3 CONTROL.add_starting_resources
function distance_squared(a, b)
    return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2
end

function add_starting_fissure(surface)
    if surface and surface.valid then
        -- starting area fissures
        local resources = {"copper-ore","coal","tin-ore"}
        local nearest = {}
        for _,resource in pairs(resources) do
            local entities = surface.find_entities_filtered{type = "resource", name = resource}
            if entities and table_size(entities) > 0 then           
                for _,entity in pairs(entities) do
                    if nearest[resource] == nil or distance_squared({x=0,y=0},entity.position) < distance_squared({x=0,y=0},nearest[resource]) then
                        nearest[resource] = entity.position
                    end
                end
            else
                nearest[resource] = {x=0,y=0}
            end
        end

        print(serpent.dump(nearest))

        local fissure_origin = {x = 0, y = 0}
        for _,resource in pairs(nearest) do
            fissure_origin.x = fissure_origin.x + resource.x
            fissure_origin.y = fissure_origin.y + resource.y
        end
        fissure_origin = {x = fissure_origin.x / table_size(nearest), y = fissure_origin.y / table_size(nearest)}
        local name = "steam-fissure"
        local theta = math.random()*math.pi*2
        local distance = 10
        fissure_origin = { x = fissure_origin.x + (math.cos(theta)*distance), y = fissure_origin.y + (math.sin(theta)*distance) }
        local p = surface.find_non_colliding_position(name, fissure_origin, 32, 0.5, true)
        if p then
            local fissure = surface.create_entity{name=name, position=p, raise_built=true}
            if fissure and fissure.valid then surface.destroy_decoratives{radius = 2.5, area = fissure.bounding_box} end
        end
    end
end
