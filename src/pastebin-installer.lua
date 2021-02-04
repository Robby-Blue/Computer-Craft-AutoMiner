-- code pasted on pastebin allowing for easy install

function runInstaller(link)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open("installing.lua","w")
    file.write(code)
    file.close()

    shell.run("installing.lua")
    sleep(1)
    fs.delete("installing.lua")
    os.reboot()
end

local args = { ... }

if table.getn(args) == 0 then
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/universal-installer.lua")
elseif args[1] == "client" or table[1] == "Client" then
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/client-installer.lua")
elseif args[1] == "server" or table[1] == "Server" then
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/server-installer.lua")
else
    print("Invalid argument")
end