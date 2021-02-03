local win = window.create(term.current(), 1, 1, term.getSize())
local rednet = peripheral.wrap("left")

local width, height = term.getSize()
local screen = "start"

local clients = {}

function drawScreen()
    win.setBackgroundColor(colors.blue)
    win.clear()
    if screen == "start" then
        win.setCursorPos(width / 2 - (string.len("Click anywhere to start") / 2), height / 2 )
        win.write("Click anywhere to start")
    end
    if screen == "connect" then
        for i = 1, table.getn(clients) do
            win.setCursorPos(2, i + 1)
            win.write(clients[i])
        end
    end
end

function startServer()
    while true do
        drawScreen()
        sleep(0)
    end
end

function mouseClick()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")

        if screen == "start" then
            screen = "connect"
            rednet.broadcast("autominer.start")
        end
    end
end

function rednet()
    local id, msg = rednet.receive()
    if screen == "connect" then
        clients[table.getn(clients) + 1] = id
    end
end

function listenEvents()
    parallel.waitForAny(mouseClick, rednet)
end

parallel.waitForAny(startServer, listenEvents)