require("control-functions") -- add_starting_fissure

function on_warp(event)
    remote.call("ir-world", "allow-surface-fissures", event.newsurface.name, true)

    -- IR calls this on startup, not when surfaces are generated.
    -- This only adds a steam fissure and not any other modded fissures
    if math.random() < 0.3 then -- fissures are great if you get them. don't make it too easy :D
        add_starting_fissure(event.newsurface)
    end
end


function on_init(event)
    -- remove IR cutscene to avoid spawning the stone flooring. if you really like it, it's safe to enable
    remote.call("ir-world", "set-intro-cutscene", false)

    -- for fun, add gold and tin planets
    local function PlanetRNG(key) return settings.startup["planet_"..key].value or 1 end
    local function PCR(f,z,r) return {frequency=f or 1,size=z or f or 1,richness=r or f or 1} end

    remote.call("planets", "RegisterTemplate", {
        key="gold", name="A Gold Planet", zone=15, rng=PlanetRNG("res"), warptime=1, flags={"resource-specific"},
        desc="This place glitters. It's almost a shame to desecrate it.",
        modifiers={ {"resource",{op="set",all=true,value=0.3}},{"resource_named",{op="set",res={["gold-ore"]=PCR(4,2,1)}}},{"biters",{value=PCR(1.15,1.15,1)}} },
        required_controls={"tin-ore"},
    })

    remote.call("planets", "RegisterTemplate", {
        key="tin", name="A Tin Planet", zone=15, rng=PlanetRNG("res"), warptime=1, flags={"resource-specific"},
        desc="As you Solder on in your journey, you wonder what Lead you here and what could be missing...",
        modifiers={ {"resource",{op="set",all=true,value=0.3}},{"resource_named",{op="set",res={["tin-ore"]=PCR(4,2,1)}}} },
        required_controls={"tin-ore"},
    })

    local eventdefs=remote.call("warptorio","get_events")
    script.on_event(eventdefs["on_warp"], on_warp)
end

script.on_init(on_init)
