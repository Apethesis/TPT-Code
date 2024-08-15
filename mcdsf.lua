local fun = {}
local SEGMENT_BITS = 0x7F
local CONTINUE_BIT = 0x80
function fun.readVarInt(str)
    local val = 0
    local pos = 0
    local strPos = 1
    local curByte
    while true do
        curByte = str:sub(strPos, strPos):byte(); strPos = strPos + 1
        val = bit.bor(val,bit.lshift(bit.band(curByte or 0,SEGMENT_BITS),pos))
        if bit.band(curByte or 0,CONTINUE_BIT) == 0 then break end
        pos = pos + 7
        if pos >= 32 then error("VarInt too large.") end
    end
    return val, str:sub(strPos)
end
function fun.writeVarInt(val,str)
    str = str or ""
    while true do
        if bit.band(val,bit.bnot(SEGMENT_BITS)) == 0 then
            str = str..string.char(val)
            return str
        end

        str = str..string.char(bit.bor(bit.band(val,SEGMENT_BITS),CONTINUE_BIT))

        val = bit.rshift(val,7)
    end
end
function fun.toLong(num)
    local retStr = ""
    for i=0,7 do
        retStr = retStr..string.char(bit.band(bit.rshift(num,(i*8)),0xFF))
    end
end
function fun.toHex(str)
    local retStr = ""
    for i=1,#str do
        retStr = retStr..string.format("%x",str:sub(i,i):byte())
    end
    return retStr
end
function fun.toStr(str)
    local retStr = ""
    for i=1,#str,2 do
        retStr = retStr..string.char(tonumber("0x"..str:sub(i,i+1)))
    end
    return retStr
end
function fun.makePacket(id,data)
    local id = fun.writeVarInt(id); id = id..data
    return fun.writeVarInt(#id)..data
end
function fun.makeString(str)
    return fun.writeVarInt(#str)..str
end
return fun