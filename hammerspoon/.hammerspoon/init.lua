hs = hs

-- Load window navigation module
local windowNav = require("window-navigation")
windowNav.bindKeys()

-- Bind URL events for window navigation
windowNav.bindUrlEvents()
hs.alert.show("Config loaded")
