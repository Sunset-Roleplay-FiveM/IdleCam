lib.locale()

local disabled = Config.DisabledByDefault == true
local requestInProgress = false

---@param title string
---@param message string
---@param notifyType string
---@param duration number?
local function notify(title, message, notifyType, duration)
    if not Config.Notify then return end

    duration = duration or 5000
    notifyType = notifyType or 'info'

    if Config.Notify == 'ESX' then
        if GetResourceState('es_extended') ~= 'started' then return end

        local esx = exports.es_extended:getSharedObject()
        esx.ShowNotification(('%s %s'):format(title, message))
    elseif Config.Notify == 'print' then
        print(('%s - %s'):format(title, message))
    elseif Config.Notify == 'okokNotify' then
        if GetResourceState('okokNotify') ~= 'started' then return end

        exports.okokNotify:Alert(title, message, duration, notifyType, false)
    elseif Config.Notify == 'ox_lib' then
        lib.notify({
            title = title,
            description = message,
            type = notifyType,
            duration = duration
        })
    end
end

---@param shouldDisable boolean
---@param showNotification boolean
local function applyIdleCamState(shouldDisable, showNotification)
    disabled = shouldDisable == true
    DisableIdleCamera(disabled)

    if not showNotification then return end

    if disabled then
        notify(locale('idlecam'), locale('disabled'), 'success', 5000)
    else
        notify(locale('idlecam'), locale('enabled'), 'success', 5000)
    end
end

CreateThread(function()
    Wait(500)

    local savedStatus = lib.callback.await('sunset_idlecam:server:getStatus', false)

    if type(savedStatus) ~= 'boolean' then
        savedStatus = Config.DisabledByDefault == true
    end

    applyIdleCamState(savedStatus, false)
end)

if Config.Command and Config.Command ~= 'false' then
    RegisterCommand(tostring(Config.Command), function()
        if requestInProgress then return end

        requestInProgress = true

        local newStatus = not disabled
        local success = lib.callback.await('sunset_idlecam:server:setStatus', false, newStatus)

        requestInProgress = false

        if success ~= true then
            notify(locale('idlecam'), locale('save_failed'), 'error', 5000)
            return
        end

        applyIdleCamState(newStatus, true)
    end, false)

    if Config.EnableKeybind then
        RegisterKeyMapping(tostring(Config.Command), locale('keybind'), 'keyboard', '')
    end
end
