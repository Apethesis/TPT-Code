_G.shitsweird = false
local changed = false
evt.register(evt.tick,function()
    if _G.shitsweird and changed ~= true then
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
        changed = true
    elseif _G.shitsweird == false and changed ~= false then
        for k,v in pairs(elem) do
            if type(v) ~= "function" and k:sub(1,7) == "DEFAULT" and elements.property(v,"Name") ~= "DMND" then
                elements.loadDefault(v)
            end
        end
        changed = false
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
