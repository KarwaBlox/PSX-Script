local lib = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

local BlacklistedUsernames = {

}

local BlacklistedWorlds = {
	"Kawaii",
	"Doodle",
	"Diamond Mine"
}

local BlacklistedAreas = {
	"VIP",
	"Portals",
	"Cat Throne Room",
	"Secret House",
	"Secret Vault",
	"Doodle Barn",
	"Steampunk Chest",
	"Alien Chest",
	"Limbo",
	"Shop",
	"Fantasy Shop",
	"Tech Shop",
	"The Void",
	"Tech Entry"
}

local BlacklistedFruits = {
	"Banana",
	"Apple",
	"Pineapple",
	"Pear"
}

if table.find(BlacklistedUsernames, game:GetService("Players").LocalPlayer.Name) then
	print("Username On Blacklist Stopping Farming Fruits")
	return
end

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Servers = {}
print("Getting servers from Roblox API")
local CurrentPage = 1
local nextPageCursor = ""
repeat
	local url = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
	if nextPageCursor ~= "" then
		url = url .. "&cursor=" .. nextPageCursor
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	RblxServerSite = result
	for i, v in pairs(RblxServerSite.data) do
		table.insert(Servers, v)
	end

	nextPageCursor = RblxServerSite.nextPageCursor or ""
	CurrentPage = CurrentPage + 1
until nextPageCursor == "" or CurrentPage > 2

for i = #Servers, 2, -1 do
	local j = math.random(i)
	Servers[i], Servers[j] = Servers[j], Servers[i]
end

function ServerHop()
	local found = false
	local jobid 
	local playerplaying
	local ping
	local Filename = "NiggaScriptAntiSameServer.json"
	local BlacklistedServers
	local CurrentBlacklisted
	if not isfile(Filename) then
		writefile(Filename, HttpService:JSONEncode({game.JobId}))
	end
	local succces, returned = pcall(function()
		BlacklistedServers = HttpService:JSONDecode(readfile(Filename))
	end)
	local succes, shit = pcall(function()
		for i, v in ipairs(Servers) do
			jobid = v.id
			if typeof(BlacklistedServers) == "table" and not table.find(BlacklistedServers, jobid) and v.playing and v.ping  then
				found = true
				jobid = v.id
				ping = v.ping
				local success, errorr = pcall(function()
					if not isfile(Filename) then
						json = HttpService:JSONEncode({jobid})
						writefile(Filename, json)   
					else
						CurrentBlacklisted = HttpService:JSONDecode(readfile(Filename))
						table.insert(CurrentBlacklisted, jobid)
						json = HttpService:JSONEncode(CurrentBlacklisted)
						writefile(Filename, json)   
					end
				end)
				if typeof(BlacklistedServers) == "table" and not table.find(BlacklistedServers, jobid) then
					print("Teleporting To "..jobid.." With "..ping.." Ping".." And "..v.playing.."/"..v.maxPlayers.." Players")
					TeleportService:TeleportToPlaceInstance(game.PlaceId, jobid, LocalPlayer)
					task.wait(1.3)
				end
			end
		end
		if not found then
			print("Server Not Found Teleporting With Shit Method")
			TeleportService:Teleport(game.PlaceId)
			task.wait(1.3)
		end
	end)
end

local functions = lib.Network.Fire, lib.Network.Invoke
local NetworkHook 
NetworkHook = hookfunction(getupvalue(functions, 1) , function(...) return true end)
local Blunder = require(game:GetService("ReplicatedStorage"):FindFirstChild("BlunderList", true))
local OldGet = Blunder.getAndClear
setreadonly(Blunder, false)
local function OutputData(Message)
	return Message
end
Blunder.getAndClear = function(...)
	local Packet = ...
	for i,v in next, Packet.list do
		if v.message ~= "PING" then
			OutputData(v.message)
			table.remove(Packet.list, i)
		end
	end
	return OldGet(Packet)
end
local Audio = require(game:GetService("ReplicatedStorage").Library.Audio)
local OldAudio
OldAudio = hookfunction(Audio.Play, function(...)
	local Sound = ...
	if Sound == "rbxassetid://7009904957" or Sound == "rbxassetid://7000720081" or Sound == "rbxassetid://7358008634" then
		return nil
	else
		return OldAudio(...)
	end
end)
local WorldCmds = require(game:GetService("ReplicatedStorage").Library.Client.WorldCmds)
for i, v in pairs(getconstants(WorldCmds.Load)) do
	if v == "Sound" then
		setconstant(WorldCmds.Load, i, "ADAWDAWDAWD")
	end
end

local Fruits = {}
for i, v in pairs(lib.Directory.Fruits) do
	if not table.find(BlacklistedFruits, i) then
		table.insert(Fruits, v.Coin)
	end
end

local Areas = {}
for i, v in pairs(lib.Directory.Areas) do
	if not v.hidden and not table.find(BlacklistedAreas, v.name) and not table.find(BlacklistedWorlds, v.world) then
		Areas[v.id] = i
	end
end

local Worlds = {}
for i, v in pairs(lib.Directory.Areas) do
	if not v.hidden and not table.find(BlacklistedAreas, v.name) and not table.find(BlacklistedWorlds, v.world) and not table.find(Worlds, v.world) then
		table.insert(Worlds, v.world)
	end
end

function GetEquipped()
	local Equipped = {}
	for i, v in pairs(lib.PetCmds.GetEquipped()) do
		table.insert(Equipped, v.uid)
	end
	return Equipped
end

function FarmCoin(Coin)
	lib.Network.Invoke("Join Coin", Coin, GetEquipped())
	for i, v in pairs(GetEquipped()) do
		lib.Network.Fire("Farm Coin", Coin, v)
	end
end

function RemoveValueFromTable(tbl, value)
	local i = 1
	while i <= #tbl do
		if tbl[i] == value then
			table.remove(tbl, i)
		else
			i = i + 1
		end
	end
end

local Teleport = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs.Teleport)
local CurrentArea
local AreasWithFruits = {}
for i, v in pairs(Worlds) do
	if lib.WorldCmds.Get() ~= v then
		lib.WorldCmds.Load(v)
	end
	repeat task.wait() until lib.WorldCmds.HasLoaded()
	for ii, vv in pairs(lib.Network.Invoke("Get Coins")) do
		if table.find(Fruits, vv.n) and not table.find(AreasWithFruits, vv.a) then
			CurrentArea = vv.a
			Teleport.Teleport(vv.a, true)
			table.insert(AreasWithFruits, vv.a)
		end
		if vv.a == CurrentArea and table.find(Fruits, vv.n) then
			print("Farming "..vv.n.." Fruit")
			FarmCoin(ii)
		end
	end
end

task.wait(0.5)
ServerHop()
