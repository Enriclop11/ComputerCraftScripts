local M = {}

function M.transferItems(chestOrigin, chestDestination) 
    local items = chestOrigin.list()
    for i, item in pairs(items) do
        chestOrigin.pushItems(peripheral.getName(chestDestination), i)
    end
end

function M.transferItemsWhiteList(chestOrigin, chestDestination, whiteList) 
    local items = chestOrigin.list()
    for i, item in pairs(items) do
        if(whiteList[item.name]) then
            chestOrigin.pushItems(peripheral.getName(chestDestination), i)
        end
    end
end

function M.transferItemsBlacklist(chestOrigin, chestDestination, blacklist) 
    local items = chestOrigin.list()
    for i, item in pairs(items) do
        if(not blacklist[item.name]) then
            chestOrigin.pushItems(peripheral.getName(chestDestination), i)
        end
    end
end

return M