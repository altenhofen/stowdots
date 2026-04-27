local browsers = {
  "Zen",
  "Google Chrome",
  "Vivaldi",
  "Firefox"
}

local index = 1

hs.hotkey.bind({}, "F3", function()
  local running = {}

  for _, app in ipairs(browsers) do
    local a = hs.application.get(app)
    if a then
      table.insert(running, a)
    end
  end

  if #running == 0 then return end

  index = (index % #running) + 1
  running[index]:activate()
end)

local devApps = {
  "Zed",
  "iTerm2",
  "Visual Studio Code"
}

local devIndex = 0

hs.hotkey.bind({}, "F2", function()
  local running = {}

  for _, app in ipairs(devApps) do
    local a = hs.application.get(app)
    if a then
      table.insert(running, a)
    end
  end

  if #running == 0 then return end

  local front = hs.application.frontmostApplication()
  local frontName = front and front:name()

  for i, app in ipairs(running) do
    if app:name() == frontName then
      devIndex = i
      break
    end
  end

  devIndex = (devIndex % #running) + 1
  running[devIndex]:activate()
end)
