local queue = {}
local maxPlayers = Config.MaxPlayers
local reconnectionGracePeriod = 300
local reconnectionData = {}

local function hasSteamID(player)
    for _, identifier in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(identifier, "steam:") then
            return true
        end
    end
    return false
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local player = source
    local steamID = GetPlayerIdentifiers(player)[1]

    if not hasSteamID(player) then
        deferrals.done("You need to have Steam open to join this server.")
        return
    end

    deferrals.defer()
    Citizen.Wait(0)

    if reconnectionData[steamID] and (os.time() - reconnectionData[steamID].disconnectTime) <= reconnectionGracePeriod then
        local position = reconnectionData[steamID].position
        table.insert(queue, position, {player = player, priority = reconnectionData[steamID].priority, deferrals = deferrals, name = name})
        reconnectionData[steamID] = nil
    else
        local priority = getPriority(player)
        table.insert(queue, {player = player, priority = priority, deferrals = deferrals, name = name})
    end

    if Config.QueueBanner.enabled then
        deferrals.update(Config.QueueBanner.text)
        if Config.QueueBanner.imageUrl then
            deferrals.update(string.format("<img src='%s' alt='Banner'>", Config.QueueBanner.imageUrl))
        end
    else
        deferrals.update("You are in the queue. Please wait for your turn...")
    end

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

AddEventHandler('playerDropped', function(reason)
    local player = source
    local steamID = GetPlayerIdentifiers(player)[1]

    for i, p in ipairs(queue) do
        if p.player == player then
            reconnectionData[steamID] = {
                disconnectTime = os.time(),
                priority = p.priority,
                position = i
            }

            table.remove(queue, i)
            break
        end
    end
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
            table.sort(queue, function(a, b) return a.priority > b.priority end)
            local nextPlayer = table.remove(queue, 1)

            nextPlayer.deferrals.done()
        end
    end
end)
