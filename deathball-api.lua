--// Core
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local API = {}

--// Globals
local player = Players.LocalPlayer

local readyZone = workspace:WaitForChild("New Lobby"):WaitForChild("ReadyArea"):WaitForChild("ReadyZone")
local readyButton = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("HolderBottom"):WaitForChild("PlayButton")

--// Methods
function API.isPlayerReady(player)
    if not player.Character then return false end
    local parts = workspace:GetPartBoundsInBox(readyZone.CFrame, readyZone.Size)

    if table.find(parts, player.Character.HumanoidRootPart) then
        return true
    end

    return false
end

function API.isInGame()
    return not readyButton.Visible
end

function API.move(pos)
    if not player.Character then return end

    player.Character.Humanoid:MoveTo(pos)
end

function API.rotate(pos)
    if not player.Character then return end
    local origin = player.Character.HumanoidRootPart.Position

    player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(origin, Vector3.new(pos.X, origin.Y, pos.Z))
end

function API.hold(kc, t)
    VIM:SendKeyEvent(true, kc, false, game)
    task.wait(t or 0.1)
    VIM:SendKeyEvent(false, kc, false, game)
end

function API.getGameStateChangedSignal()
  return readyButton:GetPropertyChangedSignal()
end

--// Export
return API
