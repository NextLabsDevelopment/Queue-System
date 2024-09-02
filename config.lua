Config = {}

Config.MaxPlayers = 32 -- Example value, adjust as necessary

Config.AcePermissions = {
    bypass = "queue.bypass",
    priority = "queue.priority"
}

Config.PriorityLevels = {
    bypass = 3,
    priority = 2,
    default = 1
}

Config.QueueBanner = {
    enabled = true, -- Set to false to disable the banner
    text = "Welcome to Our Server! Please wait in the queue...",
    imageUrl = "https://example.com/banner.png" -- URL of the image banner, if any
}
