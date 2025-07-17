local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",true))()

local DataEnabled = {
	StealExecuted = false
}

local tab = library:CreateWindow("MicaHub")

tab:AddButton({
	text = "Instant steal",
	flag = "button",
	callback = function()
		if DataEnabled.StealExecuted then return end
		DataEnabled.StealExecuted = true
		
		for _, prompt in pairs(workspace:GetDescendants()) do
			if prompt:IsA("ProximityPrompt") then
				prompt.HoldDuration = 0
			end
		end
		
		workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("ProximityPrompt") then
				descendant.HoldDuration = 0
			end
		end)
	end
})

tab:AddToggle({
	text = "Auto Lock",
	flag = "toggle",
	callback = function(v)
	end
})

tab:AddLabel({
	text = "Github: Mkklz",
	type = "label"
})

library:Init()