-- Register the event that gets called when a player is banned
AddEventHandler('easyadmin:onBan', function(admin, player)
    local adminName = GetPlayerName(admin)  -- Get the admin's name
    local playerName = GetPlayerName(player)  -- Get the player's name who is banned

    -- Send the information to Discord webhook
    local discordWebhook = Config.WebhookURL
    local message = Config.Message:gsub("{admin}", adminName):gsub("{player}", playerName)

    -- Create the webhook payload
    local payload = {
        content = message,
        embeds = {
            {
                title = "Ban Alert",
                description = "A player has been banned.",
                fields = {
                    { name = "Admin", value = adminName, inline = true },
                    { name = "Banned Player", value = playerName, inline = true }
                },
                color = 15158332,  -- Red color for ban alert
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }
        }
    }

    -- Send to Discord Webhook
    PerformHttpRequest(discordWebhook, function(err, text, headers)
        if err ~= 200 then
            print("Error sending webhook: " .. err)
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end)
