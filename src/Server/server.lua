local win = window.create(term.current(), 1, 1, term.getSize())

local width, height = term.getSize()
local screen = "start"

local clients = {{}}

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
            win.write("Computer ID: "..clients[i][1].." Personal ID: "..clients[i][2])
        end
    end
end

function startServer()
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
    end
end

function mouseClick()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")

        if screen == "start" then
            screen = "connect"
            rednet.broadcast("autominer.start")
            sleep(1)
            screen = "move"
        end
    end
end

function getRednet()
    rednet.open("Left")
    while true do
        local id, msg = rednet.receive()
        if screen == "connect" then
            clients[table.getn(clients) + 1] = id
        end
    end
end

function listenEvents()
    parallel.waitForAny(mouseClick, getRednet)
end

parallel.waitForAny(startServer, listenEvents)