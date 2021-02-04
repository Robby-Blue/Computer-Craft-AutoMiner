function install(link, file)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open(file,"w")
    file.write(code)
    file.close()
end

print("Checking for new versions")

local request = http.get(link)
local onlineversion = request.readAll()
request.close()

local file = fs.open("version.txt","r")
local version = file.readAll()
file.close()

if request ~= onlineversion then
    print("New version found ("..onlineversion..")")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/startup.lua", "startup.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/server.lua", "server.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/version.txt", "version.txt")
    print("New version installed")
    os.reboot()
end

print("Starting up server (version "..version..")")

shell.run("server.lua")