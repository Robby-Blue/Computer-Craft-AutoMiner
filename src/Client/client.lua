local server

local queue = {}
local expected
local startx, starty, startz, startdir
local coordx, coordy, coordz, direction

function initClient()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item then
            if item.name == "minecraft:diamond_pickaxe" then
                turtle.select(i)
                turtle.equipRight()
            end
            if item.name == "computercraft:peripheral" then
                turtle.select(i)
                turtle.equipLeft()
            end
        end
    end

    turtle.select(1)

    turtle.refuel()
    rednet.open("Left")
    direction = getFacingDirection()
    coordx, coordy, coordz = gps.locate()
end

function startClient()
    while true do
        if table.getn(queue) > 0 then
            handleRequest(queue[1][1], queue[1][2])
            table.remove(queue, 1)
        else
            sleep(0)
        end
    end
end

function getFacingDirection()
    if not turtle.detect() then
        local x1, y1, z1 = gps.locate()
        turtle.forward()
        local x2, y2, z2 = gps.locate()
        turtle.back()

        if x2 > x1 then
            return 1
        elseif z2 > z1 then
            return 2
        elseif x2 < x1 then
            return 3
        elseif z2 < z1 then
            return 4
        end
    end

    return nil
end

function handleRequest(id, msg)
    print(id.." sent "..msg)

    local requestargs={}
    for str in string.gmatch(msg, "([^ ]+)") do
        table.insert(requestargs, str)
    end

    if server == nil then
        if requestargs[1] == "autominer.start" then
            rednet.send(id, "autominer.connect")
            server = id
        end
    elseif id == server then
        if requestargs[1] == "autominer.move" then
            gotoCoords(tonumber(requestargs[2]), tonumber(requestargs[3]), tonumber(requestargs[4]), tonumber(requestargs[5]))
            rednet.send(server, "autominer.finished")
        end
        if requestargs[1] == "autominer.dig" then
            dig()
            if turtle.getItemCount(16) ~= 0 then
                cleanInventory()
            end
            if turtle.getFuelLevel() < 100 then
                refuel()
            end
            rednet.send(server, "autominer.finished")
        end
    end
end

function dig()
    if turtle.detectUp() then
        turtle.digUp()
    end
    if turtle.detect() then
        turtle.dig()
    end
    if turtle.detectDown() then
        turtle.digDown()
    end
    sleep(0.5)
    while turtle.detect() do
        turtle.dig()
        sleep(0.5)
    end
end

function cleanInventory()
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item then
            if item.name == "minecraft:cobblestone" or item.name == "minecraft:dirt" or item.name == "minecraft:clay_ball" then
                turtle.select(i)
                turtle.drop()
            end
        end
    end
    turtle.select(1)
    turtle.turnRight()
    turtle.turnRight()
end

function refuel()
    for i = 1, 16 do
        if item then
            if item.name == "minecraft:coal" then
                turtle.refuel()
            end
        end
    end
end

function gotoCoords(gotox, gotoy, gotoz, dir)
    if dir == 1 or dir == 3 then
        gotoAxis("y", gotoy)
        gotoAxis("z", gotoz)
        gotoAxis("x", gotox)
    else
        gotoAxis("y", gotoy)
        gotoAxis("x", gotox)
        gotoAxis("z", gotoz)
    end
    turn(dir)
    sleep(0.5)
end

function gotoAxis(axis, coords)
    if axis == "y" then
        while coordy ~= coords do
            if coordy < coords  then
                moveUp()
            end
            if coordy > coords  then
                moveDown()
            end
        end
    end

    if axis == "x" then
        if coordx > coords then
            turn(3)
        elseif coordx < coords then
            turn(1)
        end
        while coordx ~= coords do
            moveForward()
        end
    end

    if axis == "z" then
        if(coordz > coords) then
            turn(4)
        elseif(coordz < coords) then
            turn(2)
        end
        while coordz ~= coords do
            moveForward()
        end
    end
end

function moveForward()
    local succes = turtle.forward()
    if succes then
        if direction == 1 then
            coordx = coordx + 1
        elseif direction == 2 then
            coordz = coordz + 1
        elseif direction == 3 then
            coordx = coordx - 1
        elseif direction == 4 then
            coordz = coordz - 1
        end
    else
        sleep(0.1)
    end
end

function moveUp()
    local succes = turtle.up()
    if succes then
        coordy = coordy + 1
    else
        sleep(0.1)
    end
end

function moveDown()
    local succes = turtle.down()
    if succes then
        coordy = coordy - 1
    else
        sleep(0.1)
    end
end

function turn(dir)
    while direction~=dir do
        turnRight()
    end
end

function turnRight()
    turtle.turnRight()
    direction = direction + 1
    if direction > 4 then
        direction = 1
    end
end

function getRednet()
    rednet.open("Left")
    while true do
        id, msg = rednet.receive()
        queue[table.getn(queue) + 1] = {id, msg} 
    end
end

initClient()
parallel.waitForAny(startClient, getRednet)