local playerCooldowns = {}

---@param source number
---@return string?
local function getPlayerIdentifier(source)
    local license = GetPlayerIdentifierByType(source, 'license')
    if license then return license end

    local identifiers = GetPlayerIdentifiers(source)
    return identifiers and identifiers[1] or nil
end

---@return boolean
local function getDefaultStatus()
    return Config.DisabledByDefault == true
end

---@param source number
---@return boolean
local function isRateLimited(source)
    local cooldown = tonumber(Config.SaveCooldown) or 1500
    if cooldown <= 0 then return false end

    local now = GetGameTimer()
    local lastSave = playerCooldowns[source] or 0

    if now - lastSave < cooldown then
        return true
    end

    playerCooldowns[source] = now
    return false
end

local function createTable()
    if Config.AutoCreateTable ~= true then return end

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `sunset_idlecam_status` (
            `identifier` VARCHAR(64) NOT NULL,
            `idlecam_disabled` TINYINT(1) NOT NULL DEFAULT 1,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
end

CreateThread(function()
    createTable()
end)

lib.callback.register('sunset_idlecam:server:getStatus', function(source)
    local identifier = getPlayerIdentifier(source)
    if not identifier then
        return getDefaultStatus()
    end

    local row = MySQL.single.await(
        'SELECT `idlecam_disabled` FROM `sunset_idlecam_status` WHERE `identifier` = ? LIMIT 1',
        { identifier }
    )

    if row then
        return tonumber(row.idlecam_disabled) == 1
    end

    local defaultStatus = getDefaultStatus()

    if Config.SaveDefaultOnFirstJoin == true then
        MySQL.insert.await(
            'INSERT INTO `sunset_idlecam_status` (`identifier`, `idlecam_disabled`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `idlecam_disabled` = `idlecam_disabled`',
            { identifier, defaultStatus and 1 or 0 }
        )
    end

    return defaultStatus
end)

lib.callback.register('sunset_idlecam:server:setStatus', function(source, status)
    if type(status) ~= 'boolean' then
        return false
    end

    if isRateLimited(source) then
        return false
    end

    local identifier = getPlayerIdentifier(source)
    if not identifier then
        return false
    end

    local affectedRows = MySQL.update.await(
        'INSERT INTO `sunset_idlecam_status` (`identifier`, `idlecam_disabled`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `idlecam_disabled` = VALUES(`idlecam_disabled`)',
        { identifier, status and 1 or 0 }
    )

    return affectedRows ~= false
end)

AddEventHandler('playerDropped', function()
    playerCooldowns[source] = nil
end)
