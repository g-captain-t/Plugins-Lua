local theString = "Hello world"
local length = string.len(theString) print(length)
local font = workspace.Font.Fonts["Bebas Kai"]
local renderedLetter
local fontSizeStuds = 1
local letterSpacing = 1
local totalLength = 0
local canContinue = true
local Selection = game:GetService("Selection")
local lineStart
if Selection:Get()[1] then lineStart = Selection:Get()[1].Position else game.TestService:Error("[3D Font] ERROR: No objects are selected!") canContinue = false end
local isZ = false
local isX = true

------
function findLetter (currentLetter)
	local result = font:FindFirstChild(currentLetter) 
	
	if result ~= nil then result = result:Clone() return result
		
	elseif font:FindFirstChild(string.lower(currentLetter)) then 
		result = font:FindFirstChild(string.lower(currentLetter)):Clone()
		print(result)return result -- lowercase
		
	elseif font:FindFirstChild(string.upper(currentLetter)) then 
		result = font:FindFirstChild(string.upper(currentLetter)):Clone()
		print(result)return result -- uppercase 
		
	elseif result == nil then return nil end 
end 

function renderLetterX (targetLetter, i, spaceWidth, group)

	if targetLetter ~= nil and targetLetter ~= " " then 
		local letterY = targetLetter.Size.Y		
		local letterX = targetLetter.Size.X print (letterY, "LetterY") print(letterX, "letterX")
	
		targetLetter.Position = Vector3.new(
			lineStart.X + totalLength + letterX + letterSpacing, 
			lineStart.Y + letterY/2,
			0)

		totalLength = totalLength + letterX + letterSpacing
		

		targetLetter.Parent = group print(totalLength)
	else totalLength = lineStart.X + totalLength + spaceWidth + letterSpacing print (totalLength)return
	end
end
------



if canContinue then
	local spaceWidth = font["A"].Size.X or font["a"].Size.X or 2
	local group = Instance.new("Model")
	group.Name = "Letters" group.Parent = workspace

	for i = 1, length do
	    local letter = string.sub(theString,i,i) print(letter)
	    local letterObject = findLetter(letter)
		renderLetterX (letterObject, i, spaceWidth, group)
	end
	game.ChangeHistoryService:SetWaypoint("3D Font Generated: "..theString)
end


canContinue = true

