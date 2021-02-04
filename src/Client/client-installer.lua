function install(link, file)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open(file,"w")
    file.write(code)
    file.close()
end

print("Downloading files")

install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/startup.lua", "startup.lua")
install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/client.lua", "client.lua")
install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Client/version.txt", "version.txt")
