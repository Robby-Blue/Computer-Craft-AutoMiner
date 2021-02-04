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
end

local args = { ... }

if table.getn(args) == 0 then
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/universal-installer.lua")
elseif table[1] == "client" or table[1] == "Client"
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/client-installer.lua")
elseif table[1] == "server" or table[1] == "Server"
    runInstaller("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/server-installer.lua")
end

os.reboot()