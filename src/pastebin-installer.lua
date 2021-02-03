-- code pasted on pastebin allowing for easy install

local request = http.get("https://raw.githubusercontent.com/Robby-Blue/Computer-Craft-AutoMiner/main/src/installer.lua")
local code = request.readAll()
request.close()
 
local file = fs.open("installing.lua","w")
file.write(code)
file.close()
 
shell.run("installing.lua")
sleep(1)
fs.delete("installing.lua")
os.reboot()