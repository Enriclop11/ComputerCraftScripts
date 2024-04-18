local M = {}

function M.transferItems(chestOrigin, chestDestination) 
    local items = chestOrigin.list()
    for i, item in pairs(items) do
        chestOrigin.pushItems(peripheral.getName(chestDestination), i)
    end
    print("Items transferred")
end

function M.transferItemsFilter(chestOrigin, chestDestination, filter) 
    local items = chestOrigin.list()
    for i, item in pairs(items) do
        if(item.name == filter) then
            chestOrigin.pushItems(peripheral.getName(chestDestination), i)
        end
    end
    print("Items transferred")
end

return M