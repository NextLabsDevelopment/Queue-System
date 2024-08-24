local queue = {}
local maxPlayers = Config.MaxPlayers

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local player = source
    local steamID = GetPlayerIdentifiers(player)[1]

    deferrals.defer() 
    Citizen.Wait(0)

    local priority = getPriority(player)
    table.insert(queue, {player = player, priority = priority, deferrals = deferrals, name = name})
    
    deferrals.update(string.format("You are in the queue. Please wait for your turn..."))

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            
            local position = nil
            for i, p in ipairs(queue) do
                if p.player == player then
                    position = i
                    break
                end
            end

            if not position then break end
            
            deferrals.update(string.format("You are in the queue. Position: %d/%d. Please wait...", position, #queue))
        end
    end)
end)

function getPriority(player)
    if IsPlayerAceAllowed(player, Config.AcePermissions.bypass) then
        return Config.PriorityLevels.bypass
    elseif IsPlayerAceAllowed(player, Config.AcePermissions.priority) then
        return Config.PriorityLevels.priority
    else
        return Config.PriorityLevels.default
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        if #queue > 0 and GetNumPlayerIndices() < maxPlayers then
            -- Sort the queue by priority.
            table.sort(queue, function(a, b) return a.priority > b.priority end)
            local nextPlayer = table.remove(queue, 1)
            
            nextPlayer.deferrals.done() 
        end
    end
end)
