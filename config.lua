Config = {}

-- Supported: ox_lib, okokNotify, ESX, print, false
-- Unterstützt: ox_lib, okokNotify, ESX, print, false
Config.Notify = 'okokNotify'

-- Disable the idle camera by default when no database entry exists.
-- Deaktiviert die AFK-Kamera standardmäßig, wenn kein Datenbankeintrag existiert.
Config.DisabledByDefault = true

-- Command to toggle the idle camera. Use false to disable.
-- Command zum Umschalten der AFK-Kamera. false deaktiviert den Command.
Config.Command = 'idlecam'

-- Enable key mapping for the command.
-- Aktiviert Key Mapping für den Command.
Config.EnableKeybind = true

-- Automatically create the required database table on resource start.
-- Erstellt die benötigte Datenbanktabelle beim Resource-Start automatisch.
Config.AutoCreateTable = true

-- Insert the default status into the database when a player has no entry yet.
-- Speichert den Standardstatus in der Datenbank, wenn noch kein Eintrag existiert.
Config.SaveDefaultOnFirstJoin = true

-- Cooldown in milliseconds for saving the status.
-- Cooldown in Millisekunden für das Speichern des Status.
Config.SaveCooldown = 5000
