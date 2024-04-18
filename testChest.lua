--get the left chest 
local leftChest = peripheral.wrap("left")
--get the right chest
local rightChest = peripheral.wrap("right")
-- get top monitor
local monitor = peripheral.find("monitor")

monitor.clear()
monitor.setPaletteColor(colors.blue, 0x00BFFF)
monitor.setPaletteColor(colors.white, 0xFFFFFF)


local monitorUtils = require("/lib/monitorUtils")
local threadUtils = require("/lib/threadUtils")
local chestUtils = require("/lib/chestUtils")

local functions = {
    function() monitorUtils.createButton(monitor, 0, 1, 1, 1, "center", colors.blue, colors.white, "<---", function() chestUtils.transferItems(rightChest, leftChest) end, false) end,
    function() monitorUtils.createButton(monitor, 0, 3, 1, 1, "center", colors.blue, colors.white, "--->", function() chestUtils.transferItems(leftChest, rightChest) end, false) end,
    -- filter buttons minecraft:dirt
    function() monitorUtils.createButton(monitor, 0, 5, 1, 1, "center", colors.blue, colors.white, "<--- Dirt", function() chestUtils.transferItemsFilter(rightChest, leftChest, "minecraft:dirt") end, false) end,
    function() monitorUtils.createButton(monitor, 0, 7, 1, 1, "center", colors.blue, colors.white, "---> Dirt", function() chestUtils.transferItemsFilter(leftChest, rightChest, "minecraft:dirt") end, false) end,
}

threadUtils.runThreads(functions)



