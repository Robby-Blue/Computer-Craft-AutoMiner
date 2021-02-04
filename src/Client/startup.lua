function install(link, file)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open(file,"w")
    file.write(code)
    file.close()
end

print("Checking for new versions")

local request = http.get("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/version.txt")
local onlineversion = request.readAll()
request.close()

local file = fs.open("version.txt","r")
local version = file.readAll()
file.close()

if request ~= onlineversion then
    print("New version found ("..onlineversion..")")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/startup.lua", "startup.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/client.lua", "client.lua")
    install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/version.txt", "version.txt")
    print("New version installed")
    os.reboot()
end

print("Starting up client (version "..version..")")

shell.run("client.lua")