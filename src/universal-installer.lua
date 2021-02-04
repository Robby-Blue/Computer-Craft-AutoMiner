function install(link, file)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open(file,"w")
    file.write(code)
    file.close()
end

local win = window.create(term.current(), 1, 1, term.getSize())

local width, height = term.getSize()
local stop = false
local type

win.setBackgroundColor(colors.blue)
win.clear()
win.setCursorPos(width / 2 - (string.len("Server") / 2), height / 2 )
win.write("Server")
win.setCursorPos(width / 2 - (string.len("Client") / 2), height / 2 + 1)
win.write("Client")

while not stop do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x > width / 2 - (string.len("Server") / 2) and x < width / 2 + (string.len("Server") / 2) and y == math.floor(height / 2) then
        stop = true
        type = "Server"
    end
    if x > width / 2 - (string.len("Client") / 2) and x < width / 2 + (string.len("Client") / 2) and y == math.floor(height / 2 + 1) then
        stop = true
        type = "Client"
    end
end

win.clear()
win.setCursorPos(width / 2 - (string.len("Downloading files") / 2), height / 2 )
win.write("Downloading files")

if type == "Server" then
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/startup.lua", "startup.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/server.lua", "server.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/version.txt", "version.txt")
end

if type == "Client" then
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/startup.lua", "startup.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/client.lua", "client.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/version.txt", "version.txt")
end