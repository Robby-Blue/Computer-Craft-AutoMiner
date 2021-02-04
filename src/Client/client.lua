local server

local queue = {}
local expected
local startx, starty, startz, startdir
local coordx, coordy, coordz, direction

function startClient()
    rednet.open("Left")
    direction = getFacingDirection()
    coordx, coordy, coordz = gps.locate()
    while true do
        if table.getn(queue) > 0 then
            handleRequest(queue[1][1], queue[1][2])
           table.remove(queue, 1)
        else
            sleep(1)
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
    if server == nil then
        if msg == "autominer.start" then
            rednet.send(id, "autominer.connect")
            server = id
        end
    elseif id == server then
        if msg == "autominer.move" then
            expected = "coords.x"
        elseif msg == "autominer.startmove" then
            gotoCoords(startx, starty, startz, startdir)
            rednet.send(server, "autominer.finished")
        elseif msg == "autominer.dig" then
            dig()
            moveForward()
            rednet.send(server, "autominer.finished")
        else
            if expected == "coords.x" then
                startx = tonumber(msg)
                expected = "coords.y"
            elseif expected == "coords.y" then
                starty = tonumber(msg)
                expected = "coords.z"
            elseif expected == "coords.z" then
                startz = tonumber(msg)
                expected = "coords.dir"
            elseif expected == "coords.dir" then
                startdir = tonumber(msg)
                expected = ""
            end
        end
    end
end

function dig()
    turtle.digUp()
    turtle.dig()
    turtle.digDown()
    sleep(0.5)
    while turtle.detectUp() do
        turtle.digUp()
    end
    while turtle.detect() do
        turtle.dig()
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
        while coordxy ~= coords do
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
    end
end

function moveUp()
    local succes = turtle.up()
    if succes then
        coordy = coordy + 1
    end
end

function moveDown()
    local succes = turtle.down()
    if succes then
        coordy = coordy - 1
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

parallel.waitForAny(startClient, getRednet)