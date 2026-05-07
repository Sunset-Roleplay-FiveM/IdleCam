# sunset_idlecam

Persistent idle camera toggle for FiveM.

Persistente AFK-Kamera-Umschaltung für FiveM.

---

## Deutsch

### Zweck

`sunset_idlecam` deaktiviert oder aktiviert die GTA-V-AFK-/Idle-Kamera pro Spieler und speichert den Status dauerhaft in einer MySQL-Datenbank. Spieler können ihren Status per Command umschalten. Beim Join wird der gespeicherte Status geladen und lokal angewendet.

Die Resource ist bewusst klein gehalten:

- serverseitige Persistenz über Datenbank Integration
- lokalisierte Texte über `ox_lib` Locales
- optionales Notify-System über `ox_lib`, `okokNotify`, `ESX`, `print` oder deaktiviert

### Features

- Persistenter Idle-Cam-Status pro Identifier
- Automatische Tabellenerstellung optional möglich
- Command zum Umschalten
- Optionales FiveM-Keymapping
- Deutsch/Englisch Locales
- Rate-Limit für Speicheraktionen
- Standalone nutzbar

### Dependencies

- [ox_lib](https://github.com/overextended/ox_lib/releases/latest)
- [oxmysql](https://github.com/overextended/oxmysql/releases/latest)

### Installation

1. Resource in den Server-Resources-Ordner kopieren.
2. In der `server.cfg` eintragen:

```cfg
start sunset_idlecam
```
3. `config.lua` nach Bedarf konfigurieren.
4. Server neustarten

### Datenbank

Wenn `Config.AutoCreateTable = true` gesetzt ist, erstellt die Resource die Tabelle automatisch beim Resource-Start.

Manuelle SQL-Installation:

```sql
CREATE TABLE IF NOT EXISTS `sunset_idlecam_status` (
    `identifier` VARCHAR(64) NOT NULL,
    `idlecam_disabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Config

Datei: `config.lua`

| Option | Typ | Standard | Beschreibung |
|---|---:|---:|---|
| `Config.Locale` | `string` | `'de'` | Locale für ox_lib. Unterstützt vorhandene Dateien in `locales/`. |
| `Config.Notify` | `string\|false` | `'okokNotify'` | Notify-System. Unterstützt: `'ox_lib'`, `'okokNotify'`, `'ESX'`, `'print'`, `false`. |
| `Config.DisabledByDefault` | `boolean` | `true` | Standardstatus, wenn kein Datenbankeintrag existiert. `true` bedeutet: Idle-Cam deaktiviert. |
| `Config.Command` | `string\|false` | `'idlecam'` | Command zum Umschalten. Mit `false` deaktivierbar. |
| `Config.EnableKeybind` | `boolean` | `true` | Aktiviert FiveM-Keymapping für den Command. |
| `Config.AutoCreateTable` | `boolean` | `true` | Erstellt die benötigte Datenbanktabelle beim Resource-Start automatisch. |
| `Config.SaveDefaultOnFirstJoin` | `boolean` | `true` | Speichert den Standardstatus beim ersten Join, wenn noch kein Eintrag existiert. |
| `Config.SaveCooldown` | `number` | `5000` | Cooldown in Millisekunden für das Speichern des Status. |

### Commands

#### `/idlecam`

Schaltet die Idle-Cam für den Spieler um und speichert den neuen Status serverseitig.

```text
/idlecam
```

Hinweis: Der Command-Name kann über `Config.Command` geändert oder deaktiviert werden.

### Keybind

Wenn `Config.EnableKeybind = true` ist, registriert FiveM ein Keymapping für den Command. Standardmäßig ist keine Taste gesetzt. Spieler können die Taste in den GTA-/FiveM-Keybind-Einstellungen selbst zuweisen.

### Lizenz

Diese Resource enthält eine [LICENSE](LICENSE) auf Basis von Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International.

---

## English

### Purpose

`sunset_idlecam` disables or enables the GTA V idle camera per player and persists the selected state in a MySQL database. Players can toggle their state through a command. On join, the saved state is loaded and applied locally.

The resource is intentionally small:

- server-side persistence through `oxmysql`
- client-side application through `DisableIdleCamera`
- localized text through `ox_lib` locales
- optional notification system through `ox_lib`, `okokNotify`, `ESX`, `print`, or disabled notifications

### Features

- Persistent idle camera state per identifier
- Optional automatic database table creation
- Toggle command
- Optional FiveM key mapping
- German/English locales
- Save rate limit
- Standalone usage, no hard ESX/QBCore dependency

### Dependencies

- [ox_lib](https://github.com/overextended/ox_lib/releases/latest)
- [oxmysql](https://github.com/overextended/oxmysql/releases/latest)

### Installation

1. Copy the resource into your server resources folder.
2. Add this to your `server.cfg`:

```cfg
start sunset_idlecam
```
3. Configure `config.lua` as needed.
4. Restart the server

### Database

When `Config.AutoCreateTable = true`, the resource creates the required table automatically on resource start.

Manual SQL installation:

```sql
CREATE TABLE IF NOT EXISTS `sunset_idlecam_status` (
    `identifier` VARCHAR(64) NOT NULL,
    `idlecam_disabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Config

File: `config.lua`

| Option | Type | Default | Description |
|---|---:|---:|---|
| `Config.Locale` | `string` | `'de'` | Locale used by ox_lib. Supports existing files in `locales/`. |
| `Config.Notify` | `string\|false` | `'okokNotify'` | Notification system. Supported: `'ox_lib'`, `'okokNotify'`, `'ESX'`, `'print'`, `false`. |
| `Config.DisabledByDefault` | `boolean` | `true` | Default state when no database row exists. `true` means: idle camera disabled. |
| `Config.Command` | `string\|false` | `'idlecam'` | Toggle command. Can be disabled with `false`. |
| `Config.EnableKeybind` | `boolean` | `true` | Enables FiveM key mapping for the command. |
| `Config.AutoCreateTable` | `boolean` | `true` | Creates the required database table automatically on resource start. |
| `Config.SaveDefaultOnFirstJoin` | `boolean` | `true` | Saves the default state on first join when no row exists yet. |
| `Config.SaveCooldown` | `number` | `5000` | Cooldown in milliseconds for saving the state. |

### Commands

#### `/idlecam`

Toggles the idle camera for the player and saves the new state server-side.

```text
/idlecam
```

Note: The command name can be changed or disabled through `Config.Command`.

### Keybind

When `Config.EnableKeybind = true`, FiveM registers a key mapping for the command. No key is assigned by default. Players can assign a key in their GTA/FiveM keybind settings.

### License

This resource includes a [LICENSE](LICENSE) based on Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International.
