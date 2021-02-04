local win = window.create(term.current(), 1, 1, term.getSize())

local width, height = term.getSize()
local screen = "start"

local direction
local finished

local clients = {}

function drawScreen()
    win.setBackgroundColor(colors.blue)
    win.clear()
    if screen == "start" then
        win.setCursorPos(width / 2 - (string.len("Click anywhere to start") / 2), height / 2 )
        win.write("Click anywhere to start")
    end
    if screen == "connect" then
        win.setCursorPos(1,1)
        win.write("Connected clients")
        for i = 1, table.getn(clients) do
            win.setCursorPos(2, i + 2)
            win.write("Computer ID: "..clients[i][1].." Internal ID: "..clients[i][2])
        end
    end
    if screen == "move" then
        win.setCursorPos(width / 2 - (string.len("Moving towards mine") / 2), height / 2 )
        win.write("Moving towards mine")

        local turtlecount = finished.."/"..table.getn(clients)

        win.setCursorPos(width / 2 - (string.len(turtlecount) / 2), height / 2 )
        turtle.write(turtlecount)
    end
end

function startServer()
    finished = 0
    direction = getFacingDirection()
    while true do
        drawScreen()
        sleep(0)
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

function getCoordsForOffset(dir, xoffset, yoffset)
    local x, y, z = gps.locate()
    y = y + yoffset
    if dir == 1 then
        x = x + 2
        z = z + xoffset
    elseif dir == 2 then
        z = z + 2
        x = x - xoffset
    elseif dir == 3 then
        x = x - 2
        z = z - xoffset
    elseif dir == 4 then
        z = z - 2
        x = x + xoffset
    end
    return x, y, z
end

function mouseClick()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")

        if screen == "start" then
            rednet.broadcast("autominer.start")
            screen = "connect"
            sleep(5)
            screen = "move"

            for i = 1, table.getn(clients) do
                local xmove, ymove, zmove = getCoordsForOffset(direction, clients[i][3][1], clients[i][3][2])

                rednet.send(clients[i][1], "autominer.move")
                rednet.send(clients[i][1], xmove.."")
                rednet.send(clients[i][1], ymove.."")
                rednet.send(clients[i][1], zmove.."")
                rednet.send(clients[i][1], direction.."")
                rednet.send(clients[i][1], "autominer.startmove")
            end
        end
    end
end

function getRednet()
    rednet.open("Left")
    while true do
        local id, msg = rednet.receive()
        if screen == "connect" then
            if msg == "autominer.connect" then
                local newx = 0
                local newy = 1
                if table.getn(clients) > 0 then
                    newx = clients[table.getn(clients)][3][1] + 1
                    newy = clients[table.getn(clients)][3][2]
                    if newx > 16 then
                        newy = newy + 3
                    end
                end
                clients[table.getn(clients) + 1] = {id, table.getn(clients) + 1, {newx, newy}}
            end
        end
        if msg == "autominer.finished" then
            finished = finished + 1
            if finished == table.getn(clients) then
                finished = 0
                if screen == "move" then
                    screen = "dig"
                end
                if screen == "dig" then
                    for i = 1, table.getn(clients) do
                        rednet.send(clients[i][1], "autominer.dig")
                    end
                    turtle.forward()
                end
            end
        end
    end
end

function listenEvents()
    parallel.waitForAny(mouseClick, getRednet)
end

parallel.waitForAny(startServer, listenEvents)