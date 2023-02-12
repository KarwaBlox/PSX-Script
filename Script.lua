local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/KarwaBlox/UI-Library-Poland-Hub/main/Library.lua')))()
local lib = require(game:GetService("ReplicatedStorage").Framework.Library)
local hoverbrd = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs.Hoverboards)


--Services
local TeleportService = game:GetService("TeleportService")

getgenv().AutoLootbags = false
getgenv().AutoOrbs = false
getgenv().AutoEgg = false
getgenv().AutoFarmSuper = false
getgenv().AutoFarmMulti = false
getgenv().AutoFarmNormal = false
getgenv().AutoSendAllPets = false
getgenv().AutoGifts = false
getgenv().SelectedAreaFarm = nil
getgenv().WaitBeforeChangingCoin = 1
getgenv().FarmingMode = "Coin Multiplier"
getgenv().NameToEnchant = "Enchant"
getgenv().AutoEnchant = false
getgenv().AutoTripleCoin = false
getgenv().AutoTripleDamage = false
getgenv().AutoSuperLucky = false
getgenv().AutoUltraLucky = false
getgenv().AutoServerTripleCoins = false
getgenv().AutoServerTripleDamage = false
getgenv().AutoServerSuperLucky = false

local SelectedEnchants = {}

function BypassAntiCheat()
	local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
	local functions = Network.Fire, Network.Invoke
	local old 
	old = hookfunction(getupvalue(functions, 1) , function(...) return true end)
	
	local Blunder = require(game:GetService("ReplicatedStorage"):FindFirstChild("BlunderList", true))
	local OldGet = Blunder.getAndClear

	setreadonly(Blunder, false)

	local function OutputData(Message)
		print(Message .. "\n")
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
end

BypassAntiCheat()

function CollectLtbg()
	for i, v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do	
		local id = v:GetAttribute("ID")
		local cframe = v.CFrame.p
		lib.Network.Fire("Collect Lootbag", id, cframe)
	end
end

function CollectOrbs()
	local OrbTbl = {}
	for i, v in pairs(game:GetService("Workspace")["__THINGS"].Orbs:GetChildren()) do	
		table.insert(OrbTbl, v.Name)
	end
	if OrbTbl[1] == nil then
		
	else
		lib.Network.Fire("Claim Orbs", OrbTbl)
	end
	return OrbTbl
end

function RedeemGifts()
	for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.FreeGifts.Frame.Container.Gifts:GetDescendants()) do
		if v.ClassName == "TextLabel" and v.Text == "Redeem!" then
			local giftName = v.Parent.Name
			local number = string.match(giftName, "%d+")
			lib.Network.Invoke("Redeem Free Gift", tonumber(number))
		end
	end
end

function GetGamepasses()
	lib.Save.Get().Gamepasses = {}
	for i, v in pairs(lib.Directory.Gamepasses) do
		table.insert(lib.Save.Get().Gamepasses, v.ID)
	end
end

function GetHoverboards()
	lib.Save.Get().Hoverboards = {}
	for i, v in pairs(lib.Directory.Hoverboards) do
		table.insert(lib.Save.Get().Hoverboards, i)
		lib.Save.Get().EquippedHoverboard = i
	end
	hoverbrd:UpdateGamepassFrame()
	hoverbrd:Update()
	hoverbrd:UpdateCustomizeButton()
	hoverbrd:Scaling()
end

function EquipHoverboard(hoverboard)
	lib.Save.Get().EquippedHoverboard = hoverboard
end

function ReloadServer()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

function ActivateBoost(Boost)
	if (Boost ~= nil) then
		if Boost == "Triple Coins" or "Triple Damage" or "Super Lucky" or "Ultra Lucky" then
			if lib.Save.Get().BoostsInventory[Boost] then
				lib.Network.Fire("Activate Boost", Boost)
			end
		else
			print("Boost is not right named")
		end
	else 
		print("Boost is nil")
	end
end

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoTripleCoins then
			if not lib.Save.Get().Boosts["Triple Coins"] or lib.Save.Get().Boosts["Triple Coins"] < 5 then
				ActivateBoost("Triple Coins")
			end
		end
	end
end)

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoTripleDamage then
			if not lib.Save.Get().Boosts["Triple Damage"] or lib.Save.Get().Boosts["Triple Damage"] < 5 then
				ActivateBoost("Triple Damage")
			end
		end
	end
end)

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoSuperLucky then
			if not lib.Save.Get().Boosts["Super Lucky"] or lib.Save.Get().Boosts["Super Lucky"] < 5 then
				ActivateBoost("Super Lucky")
			end
		end
	end
end)

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoUltraLucky then
			if not lib.Save.Get().Boosts["Ultra Lucky"] or lib.Save.Get().Boosts["Ultra Lucky"] < 5 then
				ActivateBoost("Ultra Lucky")
			end
		end
	end
end)

function ActivateServerBoost(Boost)
	if (Boost ~= nil) then
		if Boost == "Triple Coins" or "Triple Damage" or "Super Lucky" then
			if lib.Save.Get().BoostsInventory[Boost] > 20 then
				lib.Network.Fire("Activate Server Boost", Boost)
			end
		else
			print("Boost is not right named")
		end
	else 
		print("Boost is nil")
	end
end

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoServerTripleCoins then
			if not lib.ServerBoosts.GetActiveBoosts()["Triple Coins"] or lib.ServerBoosts.GetActiveBoosts()["Triple Coins"].totalTimeLeft < 5 then
				ActivateServerBoost("Triple Coins")
			end
		end
	end
end)

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoServerTripleDamage then
			if not lib.ServerBoosts.GetActiveBoosts()["Triple Damage"] or lib.ServerBoosts.GetActiveBoosts()["Triple Damage"].totalTimeLeft < 5 then
				ActivateServerBoost("Triple Damage")
			end
		end
	end
end)

spawn(function()
	while task.wait(1.5) do
		if getgenv().AutoServerSuperLucky then
			if not lib.ServerBoosts.GetActiveBoosts()["Super Lucky"] or lib.ServerBoosts.GetActiveBoosts()["Super Lucky"].totalTimeLeft < 5 then
				ActivateServerBoost("Super Lucky")
			end
		end
	end
end)

spawn(function() --LootbagLoop
	while wait(0.5) do
		if getgenv().AutoLootbags then
			CollectLtbg()
		end
	end
end)

spawn(function() --OrbLoop
	while wait() do
		if getgenv().AutoOrbs then
			CollectOrbs()
		end
	end
end)

spawn(function()
	while wait(1) do
		if getgenv().AutoGifts then
			RedeemGifts()
		end
	end
end)

function OpenEgg(Egg, triple, octuple)
	if Egg == nil then 
		print("Select Egg First")
		elseif Egg ~= nil then
		lib.Network.Invoke("Buy Egg", Egg, triple, octuple)
	end
end
getgenv().Egg = nil
getgenv().Triple = false
getgenv().Octuple = false

--OpenEgg("Tropical Doodle Egg", getgenv().Triple, getgenv().Octuple)

spawn(function() --EggLoop
	while wait(0.11) do
		if getgenv().HatchMode == "Triple" then
			getgenv().Triple = true
			getgenv().Octuple = false
		elseif getgenv().HatchMode == "Octuple" then
			getgenv().Triple = false
			getgenv().Octuple = true
		elseif getgenv().HatchMode == "Deafult" then
			getgenv().Triple = false
			getgenv().Octuple = false
		end
		if getgenv().AutoEgg then
			OpenEgg(getgenv().Egg, getgenv().Triple, getgenv().Octuple)
		end
	end
end)



	
function GetPetsTable()
	local PetsEquipped = {}
	for i, v in pairs(lib.PetCmds.GetEquipped()) do
		table.insert(PetsEquipped, v.uid)
	end
	return PetsEquipped
end

for i, v in pairs(GetPetsTable()) do
	print(i, v)
end

function JoinCoin(CoinID, PetID)
	lib.Network.Invoke("Join Coin", CoinID, PetID)
end

function FarmCoin(CoinID, PetID)
	lib.Network.Fire("Farm Coin", CoinID, PetID)
end

function Enchant(petid)
	lib.Network.Invoke("Enchant Pet", petid, false)
end


function Teleport(EggName)
	for i,v in pairs(game:GetService("Workspace")["__MAP"].Eggs:GetDescendants()) do
		if v.Name == "SectionName" and v.Parent.Parent == EggName then
			print(v.CFrame)
		end
	end
end

spawn(function()
	while wait(0.15) do
		if getgenv().AutoFarmNormal then
			if #GetPetsTable() ~= 0 then
				if getgenv().SelectedAreaFarm ~= nil then
					if lib.Network.Invoke("Get Coins") ~= nil then
						for i, v in pairs(lib.Network.Invoke("Get Coins")) do
							if v.a == getgenv().SelectedAreaFarm then
								if getgenv().FarmingMode == "Coin Multiplier" then
									if v.b == nil then	
										Coinid = i
										CoinArea = v.a
									else
										for I, V in pairs(v.b) do
											Coinid = i
											CoinArea = v.a
											multiplier = V[1].m
										end	
									end
								end
							end
						end
						JoinCoin(Coinid, GetPetsTable())
						for i, v in pairs(GetPetsTable()) do
							FarmCoin(Coinid, v)
						end
						break
					end
				end
			end
		end
	end
end)

spawn(function()
	while wait(getgenv().WaitBeforeChangingCoin) do
		if getgenv().AutoFarmSuper then
			if #GetPetsTable() ~= 0 then
				if getgenv().SelectedAreaFarm ~= nil then
					if lib.Network.Invoke("Get Coins") ~= nil then
						for i, v in pairs(lib.Network.Invoke("Get Coins")) do
							if v.a == getgenv().SelectedAreaFarm then
								Coinid = i
								CoinArea = v.a
								CoinWorld = v.w
								if Coinid ~= nil and #GetPetsTable() ~= 0 then
									JoinCoin(Coinid, GetPetsTable())
									for i, v in pairs(GetPetsTable()) do
										FarmCoin(Coinid, v)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

spawn(function()
	while wait() do
		if getgenv().AutoFarmMulti then
			if #GetPetsTable() ~= 0 then
				if getgenv().SelectedAreaFarm ~= nil then
					if lib.Network.Invoke("Get Coins") ~= nil then
						for i, v in pairs(lib.Network.Invoke("Get Coins")) do
							if v.a == getgenv().SelectedAreaFarm then
								Coinid = i
								CoinArea = v.a
								CoinWorld = v.w
								for indx, val in pairs(GetPetsTable()) do
									petid = val
								end
								if Coinid ~= nil then
									JoinCoin(Coinid, {petid})
									FarmCoin(Coinid, petid)
									wait(getgenv().WaitBeforeChangingCoin)
								end
							end
						end
					end
				end
			end
		end
	end
end)


-- // Pet Enchanting
spawn(function()
	while wait(2.12) do
		if getgenv().AutoEnchant then
			local EnchName
			local EnchTier
			local EnchTable = {}
			for i, v in pairs(lib.Directory.Powers) do
				if v.canDrop then
					for indx,val in pairs(v.tiers) do
						local petname = val.title
						for idx, vl in pairs(SelectedEnchants) do
							if petname == table.unpack(SelectedEnchants, idx) then
								EnchName = i
								EnchTier = indx
								EnchTable[EnchName] = EnchTier
							end
						end
					end
				end
			end




			local Blacklistedids = {}
			for I, V in pairs(lib.Save.Get().Pets) do
				if V.nk == getgenv().NameToEnchant then
					if V.powers and V.powers[1] then
						local found_ench = false
						for i, ench in pairs(EnchTable) do
							if V.powers[1][1] == i and V.powers[1][2] == ench then
								found_ench = true
								table.insert(Blacklistedids, V.uid)
							end
						end
					end
					if V.powers and V.powers[2] then
						local found_ench = false
						for i, ench in pairs(EnchTable) do
							if V.powers[2][1] == i and V.powers[2][2] == ench then
								found_ench = true
								table.insert(Blacklistedids, V.uid)
							end
						end
					end
				end
			end


			for i, v in pairs(lib.Save.Get().Pets) do
				if v.nk == getgenv().NameToEnchant then
					local found = false
					for _, uid in pairs(Blacklistedids) do
						if v.uid == uid then
							found = true
							break
						end
					end
					if not found then
						local PetEnchantid = v.uid
						Enchant(PetEnchantid)
					end
				end
			end
		end
	end
end)
-- //



Playerdisplay = game.Players.LocalPlayer.DisplayName

local main = Library:New({name = "Nigga Script | Pet Simulator X |"})

local Tab = main:CreateTab({
	name = "Home"
})

local TabFarm = main:CreateTab({name = "Farming", icon = "rbxassetid://12000177181"})

local TabEgg = main:CreateTab({name = "Eggs"})
local TabMachines = main:CreateTab({name = "Machines", icon = "rbxassetid://12412304458"})
local TabMisc = main:CreateTab({name = "Misc", icon = "rbxassetid://12000213750"})

local Label = Tab:Label({name = "Psx Script By Karwa#1132"})
local ReloadServer = Tab:Button({name = "Reload Server", callback = function() 
	ReloadServer()
end})

local SectionFarm = TabFarm:Section({name = "Farming (semi broken)"})
local NoralFarmToggle = SectionFarm:Toggle({name = "Auto Farm", callback = function(v) getgenv().AutoFarmNormal = (v) end})
local twondFarmToggle = SectionFarm:Toggle({name = "Super Farm", callback = function(v) getgenv().AutoFarmSuper = (v) end})
local twondFarmToggle = SectionFarm:Toggle({name = "Multi Super Farm", callback = function(v) getgenv().AutoFarmMulti = (v) end})
local NoralFarmSlider = SectionFarm:Slider({name = "(Super Farm) Wait Before Changing Coin", min = 0, max = 4, deafult = 2, callback = function(v) getgenv().WaitBeforeChangingCoin = (v) end})
local FarmDropdownAreas = SectionFarm:Dropdown({name = "Select Area", callback = function(v) getgenv().SelectedAreaFarm = (v) end})
local areas = {}
for i, v in pairs(lib.Directory.Areas) do
	areas[#areas+1] = {name = i, id = v.id}
end

for i, area in ipairs(areas) do
	FarmDropdownAreas:Add(area.name)
end


local SectionCollect = TabFarm:Section({name = "Auto Collect"})

local AutoOrbs = SectionCollect:Toggle({name = "Auto Orbs", callback = function(v) getgenv().AutoOrbs = (v) end})
local AutoLootbags = SectionCollect:Toggle({name = "Auto Lootbags", callback = function(v) getgenv().AutoLootbags = (v) end})
local AutoGifts = SectionCollect:Toggle({name = "Auto Redeem Gifts", callback = function(v) getgenv().AutoGifts = (v) end})

function DisableEggAnim(boolean)
	if boolean then 
		game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Open Eggs"].Disabled = true
	else
		game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Open Eggs"].Disabled = false
	end
end



local EggSection = TabEgg:Section({name = "Auto Eggs"})
local AutoEgg = EggSection:Toggle({name = "Auto Open Egg", callback = function(v) getgenv().AutoEgg = (v) end})
local DisableEggAnim = EggSection:Toggle({name = "Disable Egg Animation", callback = function(v) DisableEggAnim(v) end})
local DropHatchMode = EggSection:Dropdown({name = "Hatch Mode", callback = function(v) getgenv().HatchMode = (v) end})
DropHatchMode:Add("Deafult")
DropHatchMode:Add("Triple")
DropHatchMode:Add("Octuple")

local EggInfoSection = TabEgg:Section({name = "Egg Info"})
local EggTracker = EggInfoSection:Label({name = "Egg Info: (not selected)", icon = false, centerText = true})
local EggOpened = EggInfoSection:Label({name = "Eggs Opened: (not selected)", icon = false, centerText = true})
local EggAvaiable = EggInfoSection:Label({name = "Eggs Available: (not selected)", icon = false, centerText = true})

function CalculateAvaiableEggs(Egg)
	local EggCost = lib.Directory.Eggs[Egg].cost
	local EggCurrency = lib.Directory.Eggs[Egg].currency
	if game.PlaceId == 10321372166 then
		local Avaiable = math.ceil(lib.Save.Get().HardcoreCurrency[EggCurrency] / EggCost)
		return Avaiable
	else
		local Avaiable = math.ceil(lib.Save.Get()[EggCurrency] / EggCost)
		return Avaiable
	end
end

local EggDrop = EggSection:Dropdown({
	name = "Select Egg",
	callback = function(v) 
		getgenv().Egg = (v) 
		EggTracker:SetText("Egg Info: "..v)
		if (v) then
			if lib.Save.Get().EggsOpened[getgenv().Egg] ~= nil then 
				if game.PlaceId == 10321372166 and lib.Save.Get().Hardcore.EggsOpened[getgenv().Egg] ~= nil  then
					EggOpened:SetText("Opened: "..lib.Save.Get().Hardcore.EggsOpened[getgenv().Egg])
				elseif lib.Save.Get().EggsOpened[getgenv().Egg] ~= nil then
					EggOpened:SetText("Opened: "..lib.Save.Get().EggsOpened[getgenv().Egg])
				end
				EggAvaiable:SetText("Available: "..CalculateAvaiableEggs(getgenv().Egg))
			else
				EggOpened:SetText("Opened: 0")
				EggAvaiable:SetText("Available: "..CalculateAvaiableEggs(getgenv().Egg))
			end
		end	
end})


spawn(function()
	while task.wait(1) do
		if getgenv().Egg then 
				if game.PlaceId == 10321372166 and lib.Save.Get().Hardcore.EggsOpened[getgenv().Egg] ~= nil  then
					EggOpened:SetText("Opened: "..lib.Save.Get().Hardcore.EggsOpened[getgenv().Egg])
					EggAvaiable:SetText("Available: "..CalculateAvaiableEggs(getgenv().Egg))
				elseif lib.Save.Get().EggsOpened[getgenv().Egg] ~= nil then
					EggOpened:SetText("Opened: "..lib.Save.Get().EggsOpened[getgenv().Egg])
					EggAvaiable:SetText("Available: "..CalculateAvaiableEggs(getgenv().Egg))
				end
		end
	end
end)

for i, v in pairs(lib.Directory.Eggs) do
	if v.hatchable then
		local HatchableEggs = v.displayName
		EggDrop:Add(HatchableEggs)
	end
end

local EnchantSection = TabMachines:Section({name = "Enchant Pets"})
local EnchantToggle = EnchantSection:Toggle({name = "Auto Enchant", callback = function(v) getgenv().AutoEnchant = (v) end})
local EnchantPetName = EnchantSection:TextBox({name = "Name To Enchant", callback = function(v) getgenv().NameToEnchant = (v) end})
local EnchantDropdown = EnchantSection:MultiDropdown({name = "Select Enchants", callback = function(v) SelectedEnchants = (v) end})
for i, v in pairs(lib.Directory.Powers) do
	if v.canDrop then
		for indx,val in pairs(v.tiers) do
			local petname = val.title
			if petname then
				EnchantDropdown:Add(petname)
			end
		end
	end
end

local GamepassesSection = TabMisc:Section({name = "Gamepasses"})
local UnlockGamepasses = GamepassesSection:Button({name = "Unlock Gamepasses", callback = function(v) GetGamepasses() end})
local InfoGamepasses = GamepassesSection:Label({name = "Most of the gamepasses are just visual such as triple hatch pets equipped and more", icon = false})

local HoverboardsSection = TabMisc:Section({name = "Hoverboards"})
local UnlockHover = HoverboardsSection:Button({name = "Unlock Hoverboards", callback = function(v) GetHoverboards() end})
local DropdownHover = HoverboardsSection:Dropdown({name = "Equip Hoverboard", callback = function(v) EquipHoverboard(v) end})
for i, v in pairs(lib.Directory.Hoverboards) do
	DropdownHover:Add(i)
end

local BoostsSection = TabMisc:Section({name = "Boosts"})
local ActivateTripleCoins = BoostsSection:Toggle({name = "Auto Activate Triple Coins", callback = function(v) getgenv().AutoTripleCoins = (v) end})
local ActivateTripleDamage = BoostsSection:Toggle({name = "Auto Activate Triple Damage", callback = function(v) getgenv().AutoTripleDamage = (v) end})
local ActivateSuperLucky = BoostsSection:Toggle({name = "Auto Activate Super Lucky", callback = function(v) getgenv().AutoSuperLucky = (v) end})
local ActivateUltraLucky = BoostsSection:Toggle({name = "Auto Activate Ultra Lucky", callback = function(v) getgenv().AutoUltraLucky = (v) end})


local ServerBoostsSection = TabMisc:Section({name = "Server Boosts"})
local ActivateServerTripleCoins = ServerBoostsSection:Toggle({name = "Auto Activate Server Triple Coins", callback = function(v) getgenv().AutoServerTripleCoins = (v) end})
local ActivateServerTripleDamage = ServerBoostsSection:Toggle({name = "Auto Activate Server Triple Damage", callback = function(v) getgenv().AutoServerTripleDamage = (v) end})
local ActivateServerSuperLucky = ServerBoostsSection:Toggle({name = "Auto Activate Server Super Lucky", callback = function(v) getgenv().AutoServerSuperLucky = (v) end})

local Valentinestab = main:CreateTab({name = "Valentine's", icon = "rbxassetid://12454744817"})
local ScavengerHunt = Valentinestab:Section({name = "Scavenger Hunt"}) 

function TeleportScavenger()
	local Player = game.Players.LocalPlayer.Character
	for i, v in pairs(game:GetService("Workspace")["__MAP"].Scavenger:GetChildren()) do
		if v and v.CFrame then
			Player.HumanoidRootPart.CFrame = v.CFrame
			break
		end 
	end	
end
--local TPClaimHunt = ScavengerHunt:Button({name = "Teleport To Scavenger Egg", callback = function() TeleportScavenger()  end})
local ClaimHunt = ScavengerHunt:Button({name = "Claim Scavenger Hunt Egg", callback = function() lib.Network.Invoke("Claim Scavenger Item") end})
