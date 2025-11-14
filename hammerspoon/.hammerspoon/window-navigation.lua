local M = {}

-- Helper function to focus on visible windows in a given direction
local function focusVisibleWindow(direction)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local currentFrame = win:frame()
	local screen = win:screen()

	-- Get windows ordered by z-index (front to back)
	local orderedWindows = hs.window.orderedWindows()

	-- Filter to visible, standard windows on current screen
	local candidateWindows = {}
	for _, w in ipairs(orderedWindows) do
		if w:screen() == screen and w:isStandard() and w:isVisible() then
			table.insert(candidateWindows, w)
		end
	end

	-- Use windowsToWest/East/North/South with pre-filtered candidates
	-- Parameters: candidateWindows, frontmost (prioritize unoccluded), strict (angle filtering)
	local candidates
	if direction == "west" then
		candidates = win:windowsToWest(candidateWindows, true, true)
	elseif direction == "east" then
		candidates = win:windowsToEast(candidateWindows, true, true)
	elseif direction == "north" then
		candidates = win:windowsToNorth(candidateWindows, true, true)
	elseif direction == "south" then
		candidates = win:windowsToSouth(candidateWindows, true, true)
	end

	-- Take the first candidate (closest by distance, filtered by z-order)
	local targetWindow = candidates and candidates[1] or nil

	if targetWindow then
		targetWindow:focus()
		-- Move mouse to center of the focused window
		local frame = targetWindow:frame()
		local center = hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)
		hs.mouse.absolutePosition(center)
	end
end

-- Focus on next monitor
local function focusNextMonitor()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local screen = win:screen()
	local nextScreen = screen:next()

	-- Get the first visible, standard window on the next screen
	local orderedWindows = hs.window.orderedWindows()
	for _, w in ipairs(orderedWindows) do
		if w:screen() == nextScreen and w:isStandard() and w:isVisible() then
			w:focus()
			-- Move mouse to center of the focused window
			local frame = w:frame()
			local center = hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)
			hs.mouse.absolutePosition(center)
			return
		end
	end
end

-- Focus on previous monitor
local function focusPreviousMonitor()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local screen = win:screen()
	local prevScreen = screen:previous()

	-- Get the first visible, standard window on the previous screen
	local orderedWindows = hs.window.orderedWindows()
	for _, w in ipairs(orderedWindows) do
		if w:screen() == prevScreen and w:isStandard() and w:isVisible() then
			w:focus()
			-- Move mouse to center of the focused window
			local frame = w:frame()
			local center = hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)
			hs.mouse.absolutePosition(center)
			return
		end
	end
end

-- Bind hotkeys
function M.bindKeys()
	-- Focus window to the left
	hs.hotkey.bind({ "alt" }, "H", function()
		focusVisibleWindow("west")
	end)

	-- Focus window to the right
	hs.hotkey.bind({ "alt" }, "L", function()
		focusVisibleWindow("east")
	end)

	-- Focus window up
	hs.hotkey.bind({ "alt" }, "K", function()
		focusVisibleWindow("north")
	end)

	-- Focus window down
	hs.hotkey.bind({ "alt" }, "J", function()
		focusVisibleWindow("south")
	end)

	-- Focus next monitor
	hs.hotkey.bind({ "alt" }, "N", function()
		focusNextMonitor()
	end)

	-- Focus previous monitor
	hs.hotkey.bind({ "alt" }, "P", function()
		focusPreviousMonitor()
	end)
end

-- Bind URL events for external triggering (e.g., from Karabiner)
function M.bindUrlEvents()
	hs.urlevent.bind("focusLeft", function(eventName, params)
		focusVisibleWindow("west")
	end)

	hs.urlevent.bind("focusRight", function(eventName, params)
		focusVisibleWindow("east")
	end)

	hs.urlevent.bind("focusUp", function(eventName, params)
		focusVisibleWindow("north")
	end)

	hs.urlevent.bind("focusDown", function(eventName, params)
		focusVisibleWindow("south")
	end)

	hs.urlevent.bind("focusNextMonitor", function(eventName, params)
		focusNextMonitor()
	end)

	hs.urlevent.bind("focusPreviousMonitor", function(eventName, params)
		focusPreviousMonitor()
	end)
end

return M
