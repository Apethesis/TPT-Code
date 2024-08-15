local function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end
for i in sim.parts() do
    local clr = elem.property(sim.partProperty(i,"type"),"Color")
    local cx, cy = sim.partProperty(i,"x"), sim.partProperty(i,"y")
    sim.partChangeType(i,elem.DEFAULT_PT_DMND)
    sim.decoBox(cx,cy,cx,cy,hex2rgb(string.format("%x", clr):sub(3)..string.format("%x", clr):sub(0,2)))
end