hs = hs

-- Load window navigation module
local windowNav = require("window-navigation")
windowNav.bindKeys()

-- Bind URL events for window navigation
windowNav.bindUrlEvents()

hs.urlevent.bind("someAlert", function(eventName, params)
	hs.alert.show("Received someAlert")
end)

hs.alert.show("Config loaded")
