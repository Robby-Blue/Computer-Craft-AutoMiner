local server

local id
local msg

function startClient()
    rednet.open("Left")
end

function getRednet()
    rednet.open("Left")
    id, msg = rednet.receive()
    parallel.waitForAny(getRednet, handleRednet)
end

function handleRednet()
    print(id.." sent "..msg)
    if server ~= nil then
        if server == id then
            if id == server then
            end
        end
    else
        if msg == "autominer.start" then
            server = id
        end
    end
end

parallel.waitForAny(startClient, getRednet)