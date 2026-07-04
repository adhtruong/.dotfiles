hs = hs

require("hs.ipc")

local hsNameMap = { ["Visual Studio Code"] = "Code" }

function focusApp(appName)
  local hsName = hsNameMap[appName] or appName
  local focused = hs.window.focusedWindow()

  local wins = {}
  for _, w in ipairs(hs.window.orderedWindows()) do
    local app = w:application()
    if app and app:name() == hsName and not w:isMinimized() and w:isVisible() then
      table.insert(wins, w)
    end
  end

  if #wins == 0 then
    hs.application.open(appName)
    return
  end

  local onThisApp = focused and focused:application():name() == hsName
  if onThisApp and #wins > 1 then
    wins[2]:focus()
  else
    wins[1]:focus()
  end
end

-- Load window navigation module
local windowNav = require("window-navigation")
windowNav.bindKeys()

-- Bind URL events for window navigation
windowNav.bindUrlEvents()
hs.alert.show("Config loaded")
