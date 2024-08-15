local serv = socket.tcp4(); print(serv:bind("*",25565)); print(serv:listen(25)); serv:settimeout(0,"t"); serv:setoption('reuseaddr',false)
local rw = require("mcdsf")
local js = require("json")
local nbt = require("nbt")
local oFile = assert(io.open("/home/compec/winbck/Documents/GITREPO/TPT-Code/oLogs/latest.log","w+"))
local resFile = assert(io.open("/home/compec/winbck/Documents/GITREPO/TPT-Code/oLogs/result.log","w+"))
local clSocket
local iBuffer = ""
local ioBuffer = {}
local player = {}
local state = 0
local function killClient()
    if clSocket then
        clSocket:close()
        clSocket = nil
        iBuffer = nil
        state = 0
    end
end
local function tick()
    while true do
        local cl, err = serv:accept();
        if not cl then
            if err ~= "timeout" then print(err) serv:close() killClient() serv = nil evt.unregister(event.tick, tick) break end break
        end
        if cl then
            killClient()
            clSocket = cl
            clSocket:settimeout(0,"t")
            iBuffer = ""
        end
    end
    if clSocket then
        while true do
            local line, err, partial = clSocket:receive(64)
            if err and err == "timeout" then
                iBuffer = iBuffer..partial
            elseif line and not err then
                iBuffer = iBuffer..line
            end
            if #partial < 64 then break end -- it limits  at 10000 bytes or under, it SHOULDNT have this issue
        end -- this loop reads from the socket queue, had no problems so far...
        while true do
            if #iBuffer > 1 then
                local vInt, _ = rw.readVarInt(iBuffer)
                if vInt < #iBuffer then
                    table.insert(ioBuffer,iBuffer:sub(1,1+vInt))
                    iBuffer = iBuffer:sub(vInt+2)
                else
                    break
                end
            else
                break
            end
        end -- this pieces stuff up using the length varint, turning it into strings that go into ioBuffer
        if ioBuffer[1] then -- this is just packet processing
            local ioPacket = table.remove(ioBuffer,1)
            local translatedPacket = {} -- this small bit of code before the print and if translates it into something a little more readable and less painful
            local tempVar, tempBuf = rw.readVarInt(ioPacket)
            ioPacket = tempBuf; translatedPacket.len = tempVar
            tempVar, tempBuf = rw.readVarInt(ioPacket)
            if tempVar < 0xFF then
                translatedPacket.data = tempBuf; translatedPacket.id = tempVar
            else
                translatedPacket.data = ioPacket; translatedPacket.id = 0x00
            end
            translatedPacket.validLength = (translatedPacket.len == #ioPacket)
            translatedPacket.dataLen = #ioPacket
            ioPacket = nil; tempVar = nil; tempBuf = nil
            print(js.encode(translatedPacket))
            if translatedPacket.id == 0x00 and translatedPacket.len == 16 then -- server list processing
                local protVer, newDat = rw.readVarInt(translatedPacket.data); translatedPacket.data = newDat;
                local tempVar, newDat = rw.readVarInt(translatedPacket.data); translatedPacket.data = newDat:sub(tempVar+3);
                state, _ = rw.readVarInt(translatedPacket.data)
                print(protVer, tempVar, state)
                if state == 1 then
                    local resStr = js.encode({ version = { name = "1.21", protocol = protVer }, players = { max = 67, online = 67 }, description = { text = "You have requested this with protocol version "..protVer.."!" }, enforcesSecureChat = false })
                    clSocket:send(rw.makePacket(0x00,rw.makeString(resStr)))
                end
            elseif translatedPacket.id == 0x00 and state == 2 then -- login processing
                local nameLen, newDat = rw.readVarInt(translatedPacket.data); translatedPacket.data = newDat
                player.name = translatedPacket.data:sub(1,nameLen); translatedPacket.data = translatedPacket.data:sub(1+nameLen)
                player.uuid = rw.toHex(translatedPacket.data) print(js.encode(player))
                local resStr = rw.toStr(player.uuid); resStr = rw.writeVarInt(#player.name,resStr)..player.name
                resStr = rw.writeVarInt(0,resStr); resStr = rw.writeVarInt(1,resStr)
                clSocket:send(rw.makePacket(0x02,resStr)) -- send that shit!
            elseif translatedPacket.id == 0x01 and state == 1 then -- ping processing, uses a 64bit int so i just pipe it
                clSocket:send(rw.makePacket(translatedPacket.id,translatedPacket.data))
            elseif translatedPacket.id == 0x03 and state == 2 then
                player.connected = true
                local resArray = rw.makeString("minecraft")..rw.makeString("core")..rw.makeString("1.21")
                clSocket:send(rw.makePacket(0x0E,rw.writeVarInt(1)..resArray))
            end
        end -- i dont know why its broken nowwwwww
    end
end
evt.register(evt.tick,tick)
evt.register(evt.close,function()
    if serv then
        serv:close()
        killClient()
        serv = nil
    end
    oFile:close()
    resFile:close()
end)