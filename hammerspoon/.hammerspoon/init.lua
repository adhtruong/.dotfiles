hs = hs

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

-- Focus window to the left
hs.hotkey.bind({ "alt" }, "H", function()
	focusVisibleWindow("west")
end)

-- Focus window to the right
hs.hotkey.bind({ "alt" }, "L", function()
	focusVisibleWindow("east")
end)

-- Optional: up and down
hs.hotkey.bind({ "alt" }, "K", function()
	focusVisibleWindow("north")
end)

hs.hotkey.bind({ "alt" }, "J", function()
	focusVisibleWindow("south")
end)

hs.alert.show("Config loaded")
