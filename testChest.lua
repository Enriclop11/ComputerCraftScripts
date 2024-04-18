--get the left chest 
local leftChest = peripheral.wrap("left")
--get the right chest
local rightChest = peripheral.wrap("right")
-- get top monitor
local monitor = peripheral.find("monitor")

monitor.clear()

monitor.setBackgroundColor(colors.white)

local monitorUtils = require("/lib/monitorUtils")
local threadUtils = require("/lib/threadUtils")
local chestUtils = require("/lib/chestUtils")

local filter = {
    ["minecraft:dirt"] = true
}

local functions = {
    function() monitorUtils.createButton(monitor, 0, 1, 1, 1, "center", colors.blue, colors.black, "<---", function() chestUtils.transferItems(rightChest, leftChest) end, false) end,
    function() monitorUtils.createButton(monitor, 0, 3, 1, 1, "center", colors.blue, colors.black, "--->", function() chestUtils.transferItems(leftChest, rightChest) end, false) end,
    -- filter buttons minecraft:dirt
    function() monitorUtils.createButton(monitor, 0, 5, 1, 1, "center", colors.blue, colors.black, "<--- Dirt", function() chestUtils.transferItemsWhiteList(rightChest, leftChest, filter) end, false) end,
    function() monitorUtils.createButton(monitor, 0, 7, 1, 1, "center", colors.blue, colors.black, "---> Dirt", function() chestUtils.transferItemsWhiteList(leftChest, rightChest, filter) end, false) end,
    -- filter buttons not minecraft:dirt
    function() monitorUtils.createButton(monitor, 0, 9, 1, 1, "center", colors.blue, colors.black, "<--- Not Dirt", function() chestUtils.transferItemsBlacklist(rightChest, leftChest, filter) end, false) end,
    function() monitorUtils.createButton(monitor, 0, 11, 1, 1, "center", colors.blue, colors.black, "---> Not Dirt", function() chestUtils.transferItemsBlacklist(leftChest, rightChest, filter) end, false) end
}

threadUtils.runThreads(functions)



