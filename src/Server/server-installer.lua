function install(link, file)
    local request = http.get(link)
    local code = request.readAll()
    request.close()

    local file = fs.open(file,"w")
    file.write(code)
    file.close()
end

print("Downloading files")

install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/startup.lua", "startup.lua")
install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/server.lua", "server.lua")
install("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/Server/version.txt", "version.txt")
