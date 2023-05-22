_G.commod = {shitsweird = false, shitscrazy = false, maxrantemp = 9999}
local chaos = false
local truechaos = false
local changable = {
    [1] = "Color",
    [2] = "Falldown",
    [3] = "AirDrag",
    [4] = "Flammable",
    [5] = "Hardness",
    [6] = "Temperature",
    [7] = "State",
    [8] = "HotAir",
    [9] = "Diffusion",
    [10] = "AirLoss",
    [11] = "Loss",
    [12] = "Collision",
    [13] = "Gravity",
    [14] = "Advection",
    [15] = "HeatConduct",
    [16] = "Meltable"
}
evt.register(evt.tick,function()
    if _G.commod.shitsweird and chaos ~= true then
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
                local flam = elements.property(v,"Flammable")
                local fall = elements.property(v,"Falldown")
                if flam > 0 then
                    elements.property(v,"Flammable",0)
                else
                    elements.property(v,"Flammable",1000)
                end
                if fall == 0 then
                    elements.property(v,"Falldown",1)
                elseif fall == 1 then
                    elements.property(v,"Falldown",2)
                elseif fall == 2 then
                    elements.property(v,"Falldown",0)
                end
                elements.property(v,"Explosive",2)
            end
        end
        print("finished regular chaos")
        chaos = true
    elseif _G.commod.shitsweird == false and chaos ~= false then
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
                elements.loadDefault(v)
            end
        end
        chaos = false
        print("disabled regular chaos")
    elseif _G.commod.shitscrazy and truechaos ~= true then
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
                local flam = elements.property(v,"Flammable")
                local fall = elements.property(v,"Falldown")
                if flam > 0 then
                    elements.property(v,"Flammable",0)
                else
                    elements.property(v,"Flammable",1000)
                end
                if fall == 0 then
                    elements.property(v,"Falldown",1)
                elseif fall == 1 then
                    elements.property(v,"Falldown",2)
                elseif fall == 2 then
                    elements.property(v,"Falldown",0)
                end
                elements.property(v,"Explosive",2)
            end
        end
        print("finished regular chaos")
        print("randomizer will take a while, if it asks you to stop a 'loop' just cancel")
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
                for k1,v1 in ipairs(changable) do
                    if v1 == "Color" then
                        elements.property(v,v1,math.random(1,16777215))
                    elseif v1 == "AirLoss" or v1 == "Collision" or v1 == "Advection" or v1 == "AirDrag" or v1 == "HotAir" or v1 == "Loss" then
                        elements.property(v,v1,math.random(0,255)/255)
                    elseif v1 == "Hardness" or v1 == "HeatConduct" or v1 == "Meltable" then
                        elements.property(v,v1,math.random(0,255))
                    elseif v1 == "Gravity" or v1 == "HotAir" then
                        elements.property(v,v1,math.random(-100,100))
                    elseif v1 == "Weight" then
                        elements.property(v,v1,math.random(-1,100))
                    elseif v1 == "Falldown" then
                        elements.property(v,v1,math.random(0,2))
                    elseif v1 == "State" then
                        elements.property(v,v1,math.random(0,4))
                    elseif v1 == "Temperature" then
                        elements.property(v,v1,math.random(1,_G.commod.maxrantemp))
                    end
                end
            end
        end
        print("finished randomizer")
        truechaos = true
        print("finished crazying shit up (true chaos enabled)")
    elseif _G.commod.shitscrazy == false and truechaos ~= false then
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" then
                elements.loadDefault(v)
            end
        end
        truechaos = false
        print("disabled true chaos")
    end
end)
for k,v in pairs(elem) do
    if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
        pcall(function()
            local elm = elements.allocate("BROKEN","B"..elements.property(v,"Name"):sub(1,3))
            elements.element(elm,elements.element(v))
            elem.property(elm,"Name","B"..elements.property(v,"Name"):sub(1,3))
            elem.property(elm,"Description","Broken "..elem.property(v,"Name")..".")
            elem.property(elm,"MenuSection", elem.SC_POWDERS)
            elem.property(elm,"Falldown",1)
            elem.property(elm,"Advection",0.7)
            elem.property(elm,"AirDrag",0.02)
            elem.property(elm,"AirLoss",0.96)
            elem.property(elm,"Loss",0.80)
            elem.property(elm,"Collision",0)
            elem.property(elm,"Gravity",0.1)
            elem.property(elm,"Weight",85)
        end)
    end
end
local el1 = elements.allocate("BROKEN","MARR")
elem.element(el1,elements.element(elements.DEFAULT_PT_DMND))
elem.property(el1,"Name","MARR")
elem.property(el1,"Description","Marriage, turns into BLOV under high pressure.")
elem.property(el1,"HighPressure",255)
elem.property(el1,"HighPressureTransition",elements.BROKEN_PT_BLOV)
elem.property(el1,"MenuSection",elements.SC_NUCLEAR)
elem.property(el1,"Temperature",2500)
elem.property(el1,"Color",0xFFC0CB)
local el2 = elements.allocate("BROKEN","CRSH")
elem.element(el2,elements.element(elements.DEFAULT_PT_DUST))
elem.property(el2,"Name","CRSH")
elem.property(el2,"Description","Crush, temp rises until it becomes MARR.")
elem.property(el2,"Temperature",23)
elem.property(el2,"HighTemperatureTransition",elements.BROKEN_PT_MARR)
elem.property(el2,"HighTemperature",2500)
elem.property(el2,"LowTemperature",-200)
elem.property(el2,"LowTemperatureTransition",elements.BROKEN_PT_BLOV)
elem.property(el2,"Flammable",0)
elem.property(el2,"Color",0xED174F)
elem.property(el2,"MenuSection",elements.SC_NUCLEAR)
local cd1 = 100
elem.property(el2,"Update",function(i)
    if sim.partProperty(i,"temp") < 2500 and sim.partProperty(i,"life") == 0 then
        sim.partProperty(i,"temp",sim.partProperty(i,"temp")+67)
        sim.partProperty(i,"life",cd1)
    else
        sim.partProperty(i,"life",sim.partProperty(i,"life") - 1)
    end
end)
