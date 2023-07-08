local awful = require("awful")

kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { "us", "es", "bg phonetic" }
kbdcfg.current = 1  -- us is the default layout

kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #kbdcfg.layout + 1
  local t = kbdcfg.layout[kbdcfg.current]
  os.execute(kbdcfg.cmd .. " " .. t)
end

kbdcfg.reverseSwitch = function ()
  kbdcfg.current = kbdcfg.current - 1
  if kbdcfg.current == 0 then
    kbdcfg.current = #kbdcfg.layout
  end
  local t = kbdcfg.layout[kbdcfg.current]
  os.execute(kbdcfg.cmd .. " " .. t)
end

kbdcfg.widget = awful.widget.keyboardlayout()

kbdcfg.widget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function () kbdcfg.switch() end),
    awful.button({ }, 3, function () kbdcfg.reverseSwitch() end)
  )
)

return kbdcfg