--// Core
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local API = {}

--// Globals
local player = Players.LocalPlayer

local readyZone = workspace:WaitForChild("New Lobby"):WaitForChild("ReadyArea"):WaitForChild("ReadyZone")
local readyButton = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("HolderBottom"):WaitForChild("PlayButton")
local upd = 0

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
  return readyButton:GetPropertyChangedSignal("Visible")
end

function API.moveToReadyZone()
    API.move(readyZone.Position)
end

function API.activateAI()
    local _upd = upd

    --// Move
    task.spawn(function()
        while upd == _upd do
            local pos = Vector3.new()
            local r = math.random(1,2)
            
            if r ~= 1 then
                task.spawn(API.hold, Enum.KeyCode.W, math.random(50,200)/10)

                task.wait(.4)

                API.hold(Enum.KeyCode.Space, .25)
                API.hold(Enum.KeyCode.Q, .25)
            else 
                API.hold(Enum.KeyCode.A, math.random(1,10)/10)

                task.wait(math.random(1,50)/10)
                if upd ~= _upd then break end

                API.hold(Enum.KeyCode.D, math.random(1,10)/10)
            end

            task.wait(math.random(1,50)/10)
        end
    end)

    task.spawn(function()
        while upd == _upd do
            local r = math.random(1,5)
            if r == 3 or r == 4 then
                API.hold(Enum.KeyCode.Space)
                API.hold(Enum.KeyCode.Space)
            elseif r == 1 or r == 2 then
                API.hold(Enum.KeyCode.Space)
            else
                API.hold(Enum.KeyCode.Space, math.random(1,50)/10)
            end

            task.wait(math.random(20,170)/10)
        end
    end)

    task.spawn(function()
        while upd == _upd do
            API.hold(Enum.KeyCode.B)

            task.wait(math.random(100,200)/10)
        end
    end)

    task.spawn(function()
        while upd == _upd do
            API.hold(Enum.KeyCode.Space)
            API.hold(Enum.KeyCode.Q)

            task.wait(math.random(100,200)/10)
        end
    end)
end

function API.deactivateAI()
    upd += 1
end

--// Export
return API
